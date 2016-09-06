package com.github.crystal.admin.controller;

import com.github.crystal.admin.entity.AreaInfo;
import com.github.crystal.dao.HDao;
import com.github.crystal.util.EasyuiPageBean;
import com.google.common.collect.Lists;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by Penggy on 2016/8/11.
 */
@Controller
public class AreaController {

    @Resource
    private HDao hDao;

    @RequestMapping(value = "/area/save", method = RequestMethod.POST)
    @ResponseBody
    public AreaInfo save(HttpServletRequest request, final AreaInfo areaInfo, final String pid) {
        if (StringUtils.isEmpty(areaInfo.getId())) {
            areaInfo.setId(null);
        }
        areaInfo.setParent(hDao.get(AreaInfo.class, pid));
        List<AreaInfo> list = Lists.newArrayList();
        if (StringUtils.isEmpty(pid)) {
            list = hDao.find("from AreaInfo where parent is null order by order");
        } else {
            list = hDao.find("from AreaInfo where parent.id = ? order by order", pid);
        }
        list.remove(areaInfo);
        int order = areaInfo.getOrder();
        if (order < 1) {
            order = 1;
        }
        if (order > list.size() + 1) {
            order = list.size() + 1;
        }
        list.add(order - 1, areaInfo);
        for (int i = 0; i < list.size(); i++) {
            list.get(i).setOrder(i + 1);
        }
        hDao.saveAll(list);
        return areaInfo;
    }

    @RequestMapping(value = "/area/remove", method = RequestMethod.POST)
    @ResponseBody
    public void remove(final String id) {
        AreaInfo area = hDao.get(AreaInfo.class, id);
        if (area == null) {
            return;
        }
        List<AreaInfo> children = hDao.find("from AreaInfo where parent.id = ?", id);
        for (AreaInfo child : children) {
            remove(child.getId());
        }
        hDao.delete(area);
        List<AreaInfo> list = Lists.newArrayList();
        if (area.getParent() == null) {
            list = hDao.find("from AreaInfo where parent is null order by order");
        } else {
            list = hDao.find("from AreaInfo where parent.id = ? order by order", area.getParent().getId());
        }
        for (int i = 0; i < list.size(); i++) {
            list.get(i).setOrder(i + 1);
        }
        hDao.saveAll(list);
    }

    @RequestMapping(value = "/area/areas", method = RequestMethod.POST)
    @ResponseBody
    public Object areas(HttpServletRequest request, String pid, String q) {
        String hql = "from AreaInfo where 1=1 ";
        List<Object> values = Lists.newArrayList();
        if (StringUtils.isNotEmpty(pid)) {
            hql += " and parent.id = ? ";
            values.add(pid);
        } else {
            hql += " and parent is null ";
        }
        if (StringUtils.isNotEmpty(q)) {
            hql += " and name like ? ";
            values.add("%" + q + "%");
        }
        hql += " order by order";
        return EasyuiPageBean.pageQuery(request, hDao, hql, values.toArray());
    }
}
