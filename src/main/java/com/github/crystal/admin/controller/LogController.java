package com.github.crystal.admin.controller;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.crystal.dao.HDao;
import com.github.crystal.util.DateUtils;
import com.github.crystal.util.EasyuiPageBean;
import com.google.common.collect.Lists;

@Controller
public class LogController {
	
	@Resource
	private HDao hDao;
	
	@RequestMapping(value = "/log", method = RequestMethod.GET)
	public String menu(HttpServletRequest request) {
		return "log";
	}

	@RequestMapping(value = "/log/logs", method = RequestMethod.POST)
	@ResponseBody
	public Object logs(HttpServletRequest request, String q, String dateRange) {
		Date start = DateUtils.DEF_START;
		Date end = DateUtils.DEF_END;
		if (StringUtils.isNotBlank(dateRange)) {
			try {
				String[] ranges = dateRange.split("\\s\\-\\s");
				start = DateUtils.parseDate(ranges[0]);
				end = DateUtils.parseDate(ranges[1]);
				end = DateUtils.addDays(end, 1);
			} catch (Exception e) {
			}
		}
		String hql = "from VisitLog where time >= ? and time < ? ";
		List<Object> values = Lists.newArrayList();
		values.add(start);
		values.add(end);
		if (StringUtils.isNotEmpty(q)) {
			hql += " and (username like ? or path like ?) ";
			values.add("%" + q + "%");
			values.add("%" + q + "%");
		}
		hql += " order by time desc";
		return EasyuiPageBean.pageQuery(request, hDao, hql, values.toArray());
	}

}
