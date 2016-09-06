<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html>
<head>
  <jsp:include page="/WEB-INF/adminlte.jsp"></jsp:include>
  <title><sitemesh:write property="title"/></title>
  <sitemesh:write property="head"/>
</head>
<body class="hold-transition login-page">
    <sitemesh:write property="body"/>

<script>
    $('input').iCheck({
        checkboxClass: 'icheckbox_square-blue',
        radioClass: 'iradio_square-blue'
    });
</script>
</body>
</html>
