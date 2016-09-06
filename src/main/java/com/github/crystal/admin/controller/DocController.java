package com.github.crystal.admin.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.mangofactory.swagger.annotations.ApiIgnore;

@Controller
@RequestMapping("/api")
@ApiIgnore
public class DocController {

	@RequestMapping(value = "/doc/{group}", method = RequestMethod.GET)
	public String group(HttpServletRequest request, @PathVariable String group) {
		request.setAttribute("group", StringUtils.defaultString(group, "auth"));
		return "api";
	}
	
	@RequestMapping(value = "/doc", method = RequestMethod.GET)
	public String doc(HttpServletRequest request) {
		request.setAttribute("group","auth");
		return "api";
	}

}
