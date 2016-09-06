package com.github.crystal.admin.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.crystal.dao.HDao;
import com.github.crystal.util.EasyuiPageBean;
import com.google.common.collect.Lists;

/**
 * Created by Penggy on 2016/8/23.
 */
@Controller
public class DeviceController {

    @Resource
    private HDao hDao;

    @RequestMapping(value = "/device", method = RequestMethod.GET)
    public String device() {
        return "device";
    }


    @RequestMapping(value = "/device/devices", method = RequestMethod.POST)
    @ResponseBody
    public Object devices(HttpServletRequest request, String q) {
        String hql = "from DeviceInfo where 1=1 ";
        List<Object> values = Lists.newArrayList();
        if (StringUtils.isNotEmpty(q)) {
            hql += " and title like ? ";
            values.add("%" + q + "%");
        }
        return EasyuiPageBean.pageQuery(request, hDao, hql, values.toArray());
    }
}
