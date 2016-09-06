package com.github.crystal.admin.shiro;

import java.util.Collections;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.github.crystal.admin.entity.UserInfo;
import com.github.crystal.dao.HDao;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.common.collect.Sets;

@Component
public class DbRealm extends AuthorizingRealm {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(DbRealm.class);

	private Cache<String, String> roleCache = CacheBuilder.newBuilder().expireAfterWrite(3, TimeUnit.SECONDS).build();

	@Resource
	private HDao hDao;

	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
		UserInfo userInfo = (UserInfo) principals.getPrimaryPrincipal();
		String username = userInfo.getUsername();
		String _roles = roleCache.getIfPresent(username);
		if (_roles == null) {
			UserInfo _userInfo = hDao.get(UserInfo.class, userInfo.getId());
			if (_userInfo == null) {// 用户不存在，可能已被删除，退出登录
				SecurityUtils.getSubject().logout();
				return info;
			}
			_roles = StringUtils.defaultString(_userInfo.getRoles());
			roleCache.put(username, _roles);
		}
		Set<String> roles = Sets.newHashSet();
		Collections.addAll(roles, _roles.split(",|，|;|；|\\s+"));
		roles.remove("");
		info.setRoles(roles);
		return info;
	}

	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		UsernamePasswordToken _token = (UsernamePasswordToken) token;
		String username = _token.getUsername();
		UserInfo userInfo = hDao.findSingle("from UserInfo where username = ?", username);
		if (userInfo == null) {
			throw new AuthenticationException("用户名不存在");
		}
		return new SimpleAuthenticationInfo(userInfo, userInfo.getPassword(), getName());
	}

	@Override
	public boolean supports(AuthenticationToken token) {
		return (token instanceof UsernamePasswordToken);
	}

}
