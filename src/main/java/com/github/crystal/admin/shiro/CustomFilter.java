package com.github.crystal.admin.shiro;

import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import com.github.crystal.admin.entity.MenuInfo;
import com.github.crystal.admin.entity.UserInfo;
import com.github.crystal.admin.entity.VisitLog;
import com.github.crystal.dao.HDao;
import com.github.crystal.util.HttpUtils;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.common.collect.Sets;

@Component
public class CustomFilter extends AccessControlFilter {

	@Resource
	private HDao hDao;

	private Cache<String, String> roleCache = CacheBuilder.newBuilder().expireAfterWrite(3, TimeUnit.SECONDS).build();

	@Override
	protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
		if (isLoginRequest(request, response)) {
			return true;
		}
		Subject subject = getSubject(request, response);
		if (subject == null || subject.getPrincipal() == null) {
			return false;
		}
		UserInfo user = (UserInfo)subject.getPrincipal();
		String path = WebUtils.getPathWithinApplication(WebUtils.toHttp(request));
		String _roles = roleCache.getIfPresent(path);
		if (_roles == null) {
			List<MenuInfo> menus = hDao.find("from MenuInfo where url = ?", path);
			if (menus.size() > 0) {
				_roles = StringUtils.defaultString(menus.get(0).getRoles());
			} else {
				_roles = "";
			}
			roleCache.put(path, _roles);
		}
		Set<String> roles = Sets.newHashSet();
		Collections.addAll(roles, _roles.split(",|，|;|；|\\s+"));
		roles.remove("");
		if (CollectionUtils.isEmpty(roles)) {
			return true;
		}
		for (String role : roles) {
			if (subject.hasRole(role)) {
				new VisitLog(user.getUsername(), WebUtils.toHttp(request)).save(hDao);
				return true;
			}
		}
		return false;
	}

	protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
		String method = WebUtils.toHttp(request).getMethod();
		boolean isAjax = HttpUtils.isAjax(WebUtils.toHttp(request));
		if (isAjax || !StringUtils.equalsIgnoreCase(method, "GET")) {
			HttpServletResponse resp = WebUtils.toHttp(response);
			resp.setContentType("text/plain;charset=UTF-8");
			resp.setCharacterEncoding("UTF-8");
			Subject subject = getSubject(request, response);
			if (subject == null || subject.getPrincipal() == null) {
				resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				resp.getWriter().print("请重新登录");
			} else {
				resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
				resp.getWriter().print("访问受限");
			}
			return false;
		}
		saveRequestAndRedirectToLogin(request, response);
		return false;
	}

}
