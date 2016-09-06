package com.github.crystal.admin.controller;

import com.github.crystal.admin.entity.UserInfo;
import com.google.common.collect.Maps;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.apache.shiro.subject.support.DefaultSubjectContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.*;

import java.util.Map;


@Component
public class CrystalWebSocketHandler implements WebSocketHandler {

    private static final Logger logger = LoggerFactory.getLogger(CrystalWebSocketHandler.class);

    public static final Map<String, WebSocketSession> userSocketSessionMap = Maps.newHashMap();

    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        UserInfo userInfo = getUserInfo(session);
        if(userInfo != null){
            session.sendMessage(new TextMessage("hello, " + userInfo.getUsername()));
            userSocketSessionMap.put(userInfo.getId(),session);
        }else {
            session.close(CloseStatus.NORMAL.withReason("没有登录"));
        }
    }

    public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
        if(message instanceof TextMessage){
            String msg = ((TextMessage) message).getPayload();
            session.sendMessage(new TextMessage("reply for : " + msg));
            return;
        }
    }

    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
        if (session.isOpen()) {
            session.close();
        }
        UserInfo userInfo = getUserInfo(session);
        if(userInfo != null){
            userSocketSessionMap.remove(userInfo.getId());
        }
    }

    public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
        UserInfo userInfo = getUserInfo(session);
        if(userInfo != null){
            userSocketSessionMap.remove(userInfo.getId());
        }
    }

    private UserInfo getUserInfo(WebSocketSession session) {
        Object obj = session.getAttributes().get(DefaultSubjectContext.PRINCIPALS_SESSION_KEY);
        if(obj instanceof SimplePrincipalCollection){
            SimplePrincipalCollection principals = (SimplePrincipalCollection)obj;
            obj = principals.getPrimaryPrincipal();
            if(obj instanceof UserInfo){
                return (UserInfo)obj;
            }
        }
        return null;
    }

    public boolean supportsPartialMessages() {
        return false;
    }

}
