/**
 * Copyright 2015 iflytek.com
 * 
 * All right reserved
 *
 * creator : pengwu2
 */
package com.github.crystal.admin.controller;

import javax.annotation.Resource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.mangofactory.swagger.configuration.SpringSwaggerConfig;
import com.mangofactory.swagger.plugin.EnableSwagger;
import com.mangofactory.swagger.plugin.SwaggerSpringMvcPlugin;

/**
 * @author pengwu2
 *
 */
@Configuration
@EnableSwagger
public class DocSwaggerConfig {

	@Resource
	private SpringSwaggerConfig springSwaggerConfig;

	@Bean
	public SwaggerSpringMvcPlugin auth() {
		return new SwaggerSpringMvcPlugin(this.springSwaggerConfig).includePatterns("/api/auth/.*")
				.swaggerGroup("auth");
	}

	@Bean
	public SwaggerSpringMvcPlugin dieyun() {
		return new SwaggerSpringMvcPlugin(this.springSwaggerConfig).includePatterns("/api/lv1/.*", "/channel/.*")
				.swaggerGroup("lv1");
	}

}
