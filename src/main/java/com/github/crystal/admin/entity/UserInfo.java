package com.github.crystal.admin.entity;

import java.util.Date;

import javax.persistence.*;

import org.hibernate.annotations.ForeignKey;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;
import org.hibernate.validator.constraints.NotBlank;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.github.crystal.entity.UUIDBaseEntity;

@Entity
@Table(name = "t_user", uniqueConstraints = {@UniqueConstraint(columnNames = "username")})
public class UserInfo extends UUIDBaseEntity {

    private String username;
    private String password;
    private String roles;
    private String department;
    private AreaInfo area;
    private Date registTime;
    private Date lastLoginTime;

    @Column(name = "username", length = 255)
    @NotBlank(message = "用户名不能为空")
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    @Column(name = "password", length = 255)
    @NotBlank(message = "密码不能为空")
    @JsonIgnore
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Column(name = "roles", length = 255)
    public String getRoles() {
        return roles;
    }

    public void setRoles(String roles) {
        this.roles = roles;
    }

    @Column(name = "department", length = 255)
    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    @ManyToOne
    @JoinColumn(name = "area_id")
    @NotFound(action = NotFoundAction.IGNORE)
    @ForeignKey(name = "none")
    public AreaInfo getArea() {
        return area;
    }

    public void setArea(AreaInfo area) {
        this.area = area;
    }

    @Column(name = "regist_time")
    public Date getRegistTime() {
        return registTime;
    }

    public void setRegistTime(Date registTime) {
        this.registTime = registTime;
    }

    @Column(name = "last_login_time")
    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

}
