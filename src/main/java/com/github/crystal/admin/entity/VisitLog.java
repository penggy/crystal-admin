package com.github.crystal.admin.entity;

import java.util.Date;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.util.CollectionUtils;

import com.alibaba.fastjson.JSON;
import com.github.crystal.dao.HDao;
import com.github.crystal.entity.UUIDBaseEntity;
import com.github.crystal.util.HttpUtils;

@Entity
@Table(name = "t_visit_log")
public class VisitLog extends UUIDBaseEntity {

	private String username = "";
	private String path = "";
	private String params = "";
	private String method = "";
	private String ua = "";
	private String ip = "";
	private Date time = new Date();

	public VisitLog() {

	}

	public VisitLog(HttpServletRequest request) {
		if (request == null) {
			return;
		}
		this.path = WebUtils.getPathWithinApplication(request);
		Map<String, Object> data = org.springframework.web.util.WebUtils.getParametersStartingWith(request, null);
		if(!CollectionUtils.isEmpty(data)){
			this.params = JSON.toJSONString(data);
		}
		this.method = request.getMethod();
		this.ua = HttpUtils.getUserAgent(request);
		this.ip = HttpUtils.getRemoteIP(request);
	}

	public VisitLog(String username, HttpServletRequest request) {
		this(request);
		this.username = username;
	}

	public VisitLog save(HDao dao) {
		if (dao == null) {
			return this;
		}
		this.username = StringUtils.substring(this.username, 0, 255);
		this.path = StringUtils.substring(this.path, 0, 255);
		this.params = StringUtils.substring(this.params, 0, 255);
		this.method = StringUtils.substring(this.method, 0, 255);
		this.ua = StringUtils.substring(this.ua, 0, 255);
		this.ip = StringUtils.substring(this.ip, 0, 255);
		dao.save(this);
		return this;
	}

	@Column(name = "username", length = 255)
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	@Column(name = "path", length = 255)
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	@Column(name = "params", length = 255)
	public String getParams() {
		return params;
	}

	public void setParams(String params) {
		this.params = params;
	}

	@Column(name = "method", length = 255)
	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	@Column(name = "ua", length = 255)
	public String getUa() {
		return ua;
	}

	public void setUa(String ua) {
		this.ua = ua;
	}

	@Column(name = "ip", length = 255)
	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	@Column(name = "[time]")
	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

}
