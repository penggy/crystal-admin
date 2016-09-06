package com.github.crystal.admin.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;

import com.github.crystal.entity.UUIDBaseEntity;

/**
 * Created by Penggy on 2016/8/11.
 */
@Entity
@Table(name = "t_role")
public class RoleInfo extends UUIDBaseEntity {

    private String name;

    @Column(name = "[name]", length = 255)
    @NotBlank(message = "角色名称不能为空")
    @Length(min = 1, max = 200, message = "角色名称长度范围[1-200]")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
