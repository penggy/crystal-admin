package com.github.crystal.admin.controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.crystal.admin.entity.UserInfo;
import com.github.crystal.dao.HDao;
import com.github.crystal.util.BusinessException;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;

@Controller
public class LoginController {

	private Integer lockTime = 5;
	private Integer allowErrorTimes = 10;
	private Cache<String, Integer> errorCache = CacheBuilder.newBuilder().expireAfterAccess(lockTime, TimeUnit.MINUTES)
			.build();

	@Resource
	private HDao hDao;

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login() {
		if (SecurityUtils.getSubject().isRemembered() || SecurityUtils.getSubject().isAuthenticated()) {
			return "redirect:/dashboard";
		}
		return "login";
	}

	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String doLogin(HttpServletRequest request, HttpServletResponse response, String username, String password, Boolean rememberMe) {
		if (rememberMe == null) {
			rememberMe = false;
		}
		request.setAttribute("rememberMe", rememberMe ? "yes" : "no");
		request.setAttribute("username", StringEscapeUtils.escapeHtml(username));
		if (StringUtils.isEmpty(username)) {
			request.setAttribute("errorMsg", "用户名不能为空");
			return "login";
		}
		if (StringUtils.isEmpty(password)) {
			request.setAttribute("errorMsg", "密码不能为空");
			return "login";
		}
		Integer errorCnt = errorCache.getIfPresent(username);
		if (errorCnt == null) {
			errorCnt = 0;
		}
		if (errorCnt >= allowErrorTimes) {
			request.setAttribute("errorMsg", String.format("连续登录失败%d次, %d分钟后重试", allowErrorTimes, lockTime));
			return "login";
		}
		String _password = DigestUtils.md5Hex(username + password);
		UsernamePasswordToken token = new UsernamePasswordToken(username, _password, rememberMe);
		try {
			SecurityUtils.getSubject().login(token);
		} catch (Exception e) {
			errorCnt++;
			errorCache.put(username, errorCnt);
			request.setAttribute("errorMsg", String.format("用户名或密码错误[%d]", errorCnt));
			return "login";
		}
		errorCache.invalidate(username);
		UserInfo u = hDao.findSingle("from UserInfo where username = ?", username);
		if (u.getLastLoginTime() == null) {
			request.getSession().setAttribute("first_time_login", "true");
		}
		u.setLastLoginTime(new Date());
		hDao.save(u);
		
		try {
			WebUtils.redirectToSavedRequest(request, response, "/dashboard");
			return null;
		} catch (IOException e) {
		}
		return "redirect:/dashboard";
	}

	@ResponseBody
	@RequestMapping(value = "/regist", method = RequestMethod.POST)
	public UserInfo doRegist(String username, String password) {
		if (StringUtils.isEmpty(username)) {
			throw new BusinessException("用户名不能为空");
		}
		if (StringUtils.isEmpty(password)) {
			throw new BusinessException("密码不能为空");
		}
		List<UserInfo> users = hDao.find("from UserInfo where username = ?", username);
		if (users.size() > 0) {
			throw new BusinessException("用户名已存在");
		}
		password = DigestUtils.md5Hex(username + password);
		UserInfo u = new UserInfo();
		u.setUsername(username);
		u.setPassword(password);
		u.setRegistTime(new Date());
		hDao.save(u);
		return u;
	}

	@RequestMapping(value = "/logout")
	public String logout() {
		SecurityUtils.getSubject().logout();
		return "redirect:/login";
	}

	@ResponseBody
	@RequestMapping(value = "/modifypwd", method = RequestMethod.POST)
	public void modifyPwd(HttpServletRequest request, String oldPwd, String newPwd, String newPwd2) {
		UserInfo user = (UserInfo) SecurityUtils.getSubject().getPrincipal();
		if (user == null) {
			throw new BusinessException("用户未找到!");
		}
		user = hDao.get(UserInfo.class, user.getId());
		if (user == null) {
			throw new BusinessException("用户未找到!");
		}
		oldPwd = DigestUtils.md5Hex(user.getUsername() + oldPwd);
		if (!StringUtils.equals(oldPwd, user.getPassword())) {
			throw new BusinessException("原密码不正确!");
		}
		if (!StringUtils.equals(newPwd, newPwd2)) {
			throw new BusinessException("两次输入新密码不一致!");
		}
		newPwd = StringUtils.defaultString(newPwd);
		newPwd = DigestUtils.md5Hex(user.getUsername() + newPwd);
		hDao.bulkUpdate("update UserInfo set password = ? where id = ?", newPwd, user.getId());
	}

}
