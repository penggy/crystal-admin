package com.github.crystal.admin.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

@Component
@EnableWebSocket
public class WebSocketConfig extends WebMvcConfigurerAdapter implements WebSocketConfigurer {

    @Resource
    CrystalWebSocketHandler crystalWebSocketHandler;

    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(crystalWebSocketHandler, "/ws").addInterceptors(new HttpSessionHandshakeInterceptor());

        registry.addHandler(crystalWebSocketHandler, "/ws/sockjs").addInterceptors(new HttpSessionHandshakeInterceptor()).withSockJS();
    }

}
