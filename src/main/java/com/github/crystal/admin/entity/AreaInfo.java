package com.github.crystal.admin.entity;

import com.github.crystal.entity.UUIDBaseEntity;
import com.google.common.collect.Interner;
import com.google.common.collect.Lists;
import org.hibernate.annotations.Columns;
import org.hibernate.annotations.ForeignKey;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import java.util.List;

/**
 * Created by Penggy on 2016/8/11.
 */
@Entity
@Table(name = "t_area")
public class AreaInfo extends UUIDBaseEntity {

    private AreaInfo parent;
    private String name;
    private Integer order;
    private UserInfo admin;

    private List<AreaInfo> subAreas = Lists.newArrayList();

    @ManyToOne
    @JoinColumn(name = "pid")
    @NotFound(action = NotFoundAction.IGNORE)
    @ForeignKey(name = "none")
    public AreaInfo getParent() {
        return parent;
    }

    public void setParent(AreaInfo parent) {
        this.parent = parent;
    }

    @Column(name = "[name]", length = 255)
    @Length(min = 1, max = 200, message = "区域名称长度范围[1-200]")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Column(name = "[order]")
    public Integer getOrder() {
        return order;
    }

    public void setOrder(Integer order) {
        this.order = order;
    }

    @ManyToOne
    @JoinColumn(name = "admin_id")
    @NotFound(action = NotFoundAction.IGNORE)
    @ForeignKey(name = "none")
    public UserInfo getAdmin() {
        return admin;
    }

    public void setAdmin(UserInfo admin) {
        this.admin = admin;
    }

    @Transient
    public List<AreaInfo> getSubAreas() {
        return subAreas;
    }

    public void setSubAreas(List<AreaInfo> subAreas) {
        this.subAreas = subAreas;
    }
}
