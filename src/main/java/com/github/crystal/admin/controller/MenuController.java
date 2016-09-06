package com.github.crystal.admin.controller;

import com.github.crystal.admin.entity.MenuInfo;
import com.github.crystal.dao.HDao;
import com.github.crystal.util.EasyuiPageBean;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

@Controller
public class MenuController {

	@Resource
	private HDao hDao;

	@RequestMapping(value = "/menu", method = RequestMethod.GET)
	public String menu(HttpServletRequest request, String pid) {
		String title = "";
		MenuInfo pm = hDao.get(MenuInfo.class, pid);
		if (pm != null) {
			title = pm.getTitle();
		} else {
			title = "菜单根节点";
			pid = "";
		}
		request.setAttribute("title", title);
		request.setAttribute("pid", pid);
		return "menu";
	}

	@RequestMapping(value = "/menu/menus", method = RequestMethod.POST)
	@ResponseBody
	public Object menus(HttpServletRequest request, String pid, String q) {
		String hql = "from MenuInfo where 1=1 ";
		List<Object> values = Lists.newArrayList();
		if (StringUtils.isNotEmpty(pid)) {
			hql += " and parent.id = ? ";
			values.add(pid);
		} else {
			hql += " and parent is null ";
		}
		if (StringUtils.isNotEmpty(q)) {
			hql += " and title like ? ";
			values.add("%" + q + "%");
		}
		hql += " order by order";
		return EasyuiPageBean.pageQuery(request, hDao, hql, values.toArray());
	}

	@RequestMapping(value = "/menu/save", method = RequestMethod.POST)
	@ResponseBody
	public MenuInfo save(HttpServletRequest request, final MenuInfo menuInfo, final String pid) {
		if (StringUtils.isEmpty(menuInfo.getId())) {
			menuInfo.setId(null);
		}
		menuInfo.setParent(hDao.get(MenuInfo.class, pid));
		List<MenuInfo> list = Lists.newArrayList();
		if (StringUtils.isEmpty(pid)) {
			list = hDao.find("from MenuInfo where parent is null order by order");
		} else {
			list = hDao.find("from MenuInfo where parent.id = ? order by order", pid);
		}
		list.remove(menuInfo);

		int order = NumberUtils.toInt(String.valueOf(menuInfo.getOrder()),0);
		if (order < 1) {
			order = 1;
		}
		if (order > list.size() + 1) {
			order = list.size() + 1;
		}
		list.add(order - 1, menuInfo);
		for (int i = 0; i < list.size(); i++) {
			list.get(i).setOrder(i + 1);
		}
		hDao.saveAll(list);
		return menuInfo;
	}

	@RequestMapping(value = "/menu/remove", method = RequestMethod.POST)
	@ResponseBody
	public void remove(final String id) {
		MenuInfo menu = hDao.get(MenuInfo.class, id);
		if (menu == null) {
			return;
		}
		List<MenuInfo> children = hDao.find("from MenuInfo where parent.id = ?", id);
		for (MenuInfo child : children) {
			remove(child.getId());
		}
		hDao.delete(menu);
		List<MenuInfo> list = Lists.newArrayList();
		if (menu.getParent() == null) {
			list = hDao.find("from MenuInfo where parent is null order by order");
		} else {
			list = hDao.find("from MenuInfo where parent.id = ? order by order", menu.getParent().getId());
		}
		for (int i = 0; i < list.size(); i++) {
			list.get(i).setOrder(i + 1);
		}
		hDao.saveAll(list);

	}

	@RequestMapping(value = "/menu/tree", method = RequestMethod.POST)
	@ResponseBody
	public MenuInfo tree() {
		MenuInfo root = new MenuInfo();
		fetchMenu(root);
		return root;
	}

	private void fetchMenu(MenuInfo menu) {
		String pid = menu.getId();
		List<MenuInfo> list = Lists.newArrayList();
		if (StringUtils.isEmpty(pid)) {
			list = hDao.find("from MenuInfo where parent is null order by order");
		} else {
			list = hDao.find("from MenuInfo where parent.id = ? order by order", pid);
		}
		Iterator<MenuInfo> it = list.iterator();
		while (it.hasNext()) {
			MenuInfo _menu = it.next();
			String _roles = _menu.getRoles();
			boolean hasRole = true;
			if (StringUtils.isNotBlank(_roles)) {
				hasRole = false;
				Set<String> roles = Sets.newHashSet();
				Collections.addAll(roles, _roles.split(",|，|;|；|\\s+"));
				roles.remove("");
				for (String role : roles) {
					if (SecurityUtils.getSubject().hasRole(role)) {
						hasRole = true;
						break;
					}
				}
			}
			if (!hasRole) {
				it.remove();
			}
		}
		menu.setSubMenus(list);
		for (MenuInfo subMenu : list) {
			fetchMenu(subMenu);
		}
	}

}
