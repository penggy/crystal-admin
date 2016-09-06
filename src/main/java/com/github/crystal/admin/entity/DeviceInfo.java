package com.github.crystal.admin.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

import com.github.crystal.entity.UUIDBaseEntity;

/**
 * Created by Penggy on 2016/8/11.
 */
@Entity
@Table(name = "t_device")
public class DeviceInfo extends UUIDBaseEntity {
	private String model;// 型号
	private String ver;// 版本
	private String ip;
	private Integer port;
	private String status;
	private Float lng;
	private Float lat;

	@Column(name = "model", length = 255)
	public String getModel() {
		return model;
	}

	public void setModel(String model) {
		this.model = model;
	}

	@Column(name = "ver", length = 255)
	public String getVer() {
		return ver;
	}

	public void setVer(String ver) {
		this.ver = ver;
	}

	@Column(name = "ip", length = 255)
	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	@Column(name = "port")
	public Integer getPort() {
		return port;
	}

	public void setPort(Integer port) {
		this.port = port;
	}

	@Column(name = "[status]", length = 255)
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Column(name = "lng")
	public Float getLng() {
		return lng;
	}

	public void setLng(Float lng) {
		this.lng = lng;
	}

	@Column(name = "lat")
	public Float getLat() {
		return lat;
	}

	public void setLat(Float lat) {
		this.lat = lat;
	}

}
