<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <title>登录</title>

    <style>
        .header-space {
            margin : 60px 0;
        }

        .login-container{
            margin : 0 auto;
            width : 340px;
        }

        .panel {
            position: fixed;
            visibility: hidden;
            z-index: auto;

            -moz-transform: scale(0,1) translate(-150px);
            -webkit-transform: scale(0,1) translate(-150px);
            -o-transform: scale(0,1) translate(-150px);
            -ms-transform: scale(0,1) translate(-150px);
            transform: scale(0,1) translate(-150px);
        }

        .panel.visible {
            visibility: visible;
            position: relative;

            -moz-transform: scale(1,1) translate(0);
            -webkit-transform: scale(1,1) translate(0);
            -o-transform: scale(1,1) translate(0);
            -ms-transform: scale(1,1) translate(0);
            transform: scale(1,1) translate(0);

            transition: transform .3s ease;
            -moz-transition: -moz-transform .3s ease;
            -webkit-transition: -webkit-transform .3s ease;
            -o-transition: -o-transform .2s ease;
        }
    </style>
</head>

<body class="center ">
<div class="row header-space">
</div>
<div class="login-container">
    <div id="login-panel" class="panel panel-primary visible no-border">
        <div class="panel-heading text-center">
            <h3><b>Admin</b>LTE</h3>
        </div>
        <div class="panel-body">
            <br>
            <form action="${ctx}/login" method="post">
                <input name="password" type="hidden"/>
                <div class="form-group has-feedback">
                    <input id="login-username" type="text" class="form-control" placeholder="用户名" name="username" value="${username}">
                    <span class="glyphicon glyphicon-user form-control-feedback text-gray"></span>
                </div>
                <div class="form-group has-feedback">
                    <input id="login-pwd" type="password" class="form-control" placeholder="密码">
                    <span class="glyphicon glyphicon-lock form-control-feedback text-gray"></span>
                </div>
                <div class="row">
                    <div class="col-xs-8">
                        <input type="hidden" id="login-remember-me" name="rememberMe" value="${rememberMe}"/>
                        <div class="checkbox icheck">
                            <label>
                                <input id="checkbox-login-remember-me" type="checkbox"> 保持登录
                            </label>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <button id="btn-login" type="button" class="btn btn-primary btn-block btn-flat">登录</button>
                    </div>
                </div>
            </form>
        </div>

        <div class="panel-footer">
            <div class="row">
                <div class="col-xs-6 text-left">
                    <a href="#" class="" data-target="#forgot-panel">忘记密码</a>
                </div>
                <div class="col-xs-6 text-right">
                    <c:if test="${not empty param.regist }">
                        <a href="#" class="" data-target="#regist-panel">注 册</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div id="forgot-panel" class="panel panel-danger no-border">
        <div class="panel-heading">
            <p class="panel-title text-left"><i class="fa fa-key"></i> 提示</p>
        </div>
        <div class="panel-body text-center">
            <small>请联系运营人员重置您的密码。</small>
        </div>

        <div class="panel-footer text-center">
            <a href="#" data-target="#login-panel">返回登录
            </a>
        </div>
    </div>

    <div id="regist-panel" class="panel panel-primary no-border">
        <div class="panel-heading text-center">
            <h3>注册<b>Admin</b>LTE</h3>
        </div>
        <div class="panel-body">
            <br>
            <form>
                <div class="form-group has-feedback">
                    <input id="regist-username" type="text" class="form-control" placeholder="用户名" name="username">
                    <span class="glyphicon glyphicon-user form-control-feedback text-gray"></span>
                </div>
                <div class="form-group has-feedback">
                    <input id="regist-pwd" type="password" class="form-control" placeholder="密码">
                    <span class="glyphicon glyphicon-lock form-control-feedback text-gray"></span>
                </div>
                <div class="form-group has-feedback">
                    <input id="regist-pwd2" type="password" class="form-control" placeholder="确认密码">
                    <span class="glyphicon glyphicon-retweet form-control-feedback text-gray"></span>
                </div>
                <div class="row">
                    <div class="col-xs-4">
                        <button type="reset" class="btn btn-default btn-block btn-flat">重 置</button>
                    </div>
                    <div class="col-xs-4">
                    </div>
                    <div class="col-xs-4">
                        <button id="btn-regist" type="button" class="btn btn-primary btn-block btn-flat">注 册</button>
                    </div>
                </div>
            </form>
        </div>
        <div class="panel-footer text-center">
            <a href="#" data-target="#login-panel">返回登录
            </a>
        </div>
    </div>

</div>

<script>
    var errorMsg = '${errorMsg}';

    $(function () {

        $("#checkbox-login-remember-me").on("ifChecked", function() {
            $("#login-remember-me").val('yes');
        }).on("ifUnchecked",function () {
            $("#login-remember-me").val('no');
        }).iCheck($("#login-remember-me").val() == 'yes' ? 'check' : 'uncheck');

        $(document).on('click', '.panel-footer a[data-target]', function (e) {
            e.preventDefault();
            var target = $(this).data('target');
            $('.panel.visible').removeClass('visible');
            $(target).addClass('visible');
        });

        $("#login-username").focus().select().on('keyup',function(e){
            if(e.keyCode == 13){
                $("#login-pwd").focus().select();
                return false;
            }
        });

        $("#login-pwd").on("keyup", function(e) {
            if (e.keyCode == 13) {
                $("#login-panel form").submit();
                return false;
            }
        });

        $("#btn-login").click(function(){
            $("#login-panel form").submit();
        });

        $("#login-panel form").on("submit",function(event){
            var $un = $("#login-username");
            var $pwd = $("#login-pwd");
            if(!$un.val()){
                $.gritter.add({
                    text : "用户名不能为空"
                });
                $un.focus();
                return false;
            }
            if(!$pwd.val()){
                $.gritter.add({
                    text : "密码不能为空"
                });
                $pwd.focus();
                return false;
            }
            var pwd = $pwd.val();
            $("input[name=password]").val($.md5(pwd));
        });

        $("#regist-username").on("keyup",function (e) {
            if(e.keyCode == 13){
                $("#regist-pwd").focus().select();
                return false;
            }
        })

        $("#regist-pwd").on("keyup",function (e) {
            if(e.keyCode == 13){
                $("#regist-pwd2").focus().select();
                return false;
            }
        });

        $("#regist-pwd2").on("keyup",function (e) {
            if(e.keyCode == 13){
                $("#btn-regist").trigger("click");
                return false;
            }
        });

        $("#regist-panel button[type=reset]").on("click",function(){
            $("#regist-username").focus().select();
        });

        $("#btn-regist").on("click", function(e) {
            var username = $("#regist-username").val();
            var password = $("#regist-pwd").val();
            var password2 = $("#regist-pwd2").val();
            if (!username) {
                $.gritter.add({
                    text : '用户名不能为空'
                });
                $("#regist-username").focus().select();
                return false;
            }
            if (!password) {
                $.gritter.add({
                    text : '密码不能为空'
                });
                $("#regist-pwd").focus().select();
                return false;
            }
            if (password != password2) {
                $.gritter.add({
                    text : '两次输入密码不一致'
                });
                $("#regist-pwd2").focus().select();
                return false;
            }
            $.ajax({
                url : ctx + '/regist',
                method : 'POST',
                type : 'json',
                data : {
                    username : username,
                    password : $.md5(password)
                },
                success : function() {
                    $.gritter.add({
                        text : '注册成功!',
                        class_name : 'gritter-success'
                    });
                    $("#regist-panel button[type=reset]").trigger("click");
                }
            });
            return false;
        });

    });

</script>
</body>
</html>
