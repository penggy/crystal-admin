package com.github.crystal.admin.entity;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.ForeignKey;
import org.hibernate.annotations.NotFound;
import org.hibernate.annotations.NotFoundAction;
import org.hibernate.validator.constraints.NotBlank;

import com.github.crystal.entity.UUIDBaseEntity;
import com.google.common.collect.Lists;

@Entity
@Table(name = "t_menu")
public class MenuInfo extends UUIDBaseEntity {

	public static int TYPE_FOLDER = 1;
	public static int TYPE_LINK = 2;
	public static int TYPE_OPERATION = 3;

	private MenuInfo parent;
	private Integer type;
	private String url;
	private String icon;
	
	private String title;
	private Integer order = 0;
	private String roles;
	
	private List<MenuInfo> subMenus = Lists.newArrayList();

	@ManyToOne
	@JoinColumn(name = "pid")
	@NotFound(action = NotFoundAction.IGNORE)
	@ForeignKey(name = "none")
	public MenuInfo getParent() {
		return parent;
	}

	public void setParent(MenuInfo parent) {
		this.parent = parent;
	}

	@Column(name = "[type]")
	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	@Column(name = "url", length = 511)
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	@Column(name = "icon", length = 255)
	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	@Column(name = "title", length = 255)
	@NotBlank(message = "菜单标题不能为空")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Column(name = "[order]")
	public Integer getOrder() {
		return order;
	}

	public void setOrder(Integer order) {
		this.order = order;
	}

	@Column(name = "roles",length = 255)
	public String getRoles() {
		return roles;
	}

	public void setRoles(String roles) {
		this.roles = roles;
	}

	@Transient
	public List<MenuInfo> getSubMenus() {
		return subMenus;
	}

	public void setSubMenus(List<MenuInfo> subMenus) {
		this.subMenus = subMenus;
	}

}
