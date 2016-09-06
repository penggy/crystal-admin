package com.github.crystal.admin.controller;

import com.github.crystal.admin.entity.UserInfo;
import com.github.crystal.admin.entity.UserInfo;
import com.github.crystal.dao.HDao;
import com.github.crystal.util.EasyuiPageBean;
import com.github.crystal.util.PropertiesUtils;
import com.google.common.collect.Lists;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

/**
 * Created by wupeng on 16/8/22.
 */
@Controller
public class UserController {

    @Resource
    private HDao hDao;

    @RequestMapping(value = "/user", method = RequestMethod.GET)
    public String user(HttpServletRequest request) {
        return "user";
    }

    @RequestMapping(value = "/user/users", method = RequestMethod.POST)
    @ResponseBody
    public Object users(HttpServletRequest request, String q) {
        String hql = "from UserInfo where 1=1 ";
        List<Object> values = Lists.newArrayList();
        if (StringUtils.isNotEmpty(q)) {
            hql += " and username like ? ";
            values.add("%" + q + "%");
        }
        hql += " order by registTime desc";
        return EasyuiPageBean.pageQuery(request, hDao, hql, values.toArray());
    }

    @RequestMapping(value = "/user/save", method = RequestMethod.POST)
    @ResponseBody
    public UserInfo save(HttpServletRequest request, final UserInfo userInfo) {
        if (StringUtils.isEmpty(userInfo.getId())) {
            userInfo.setRegistTime(new Date());
            String pass = PropertiesUtils.getProperty("default.pwd","1234");
            pass = DigestUtils.md5Hex(pass);
            pass = DigestUtils.md5Hex(userInfo.getUsername() + pass);
            userInfo.setPassword(pass);
        }else{
            UserInfo old = hDao.get(UserInfo.class,userInfo.getId());
            userInfo.setPassword(old.getPassword());
            userInfo.setRegistTime(old.getRegistTime());
            userInfo.setLastLoginTime(old.getLastLoginTime());
        }
        hDao.save(userInfo);
        return userInfo;
    }

    @RequestMapping(value = "/user/remove", method = RequestMethod.POST)
    @ResponseBody
    public void remove(final String id) {
        UserInfo user = hDao.get(UserInfo.class, id);
        if (user == null) {
            return;
        }
        hDao.delete(user);
    }

}
