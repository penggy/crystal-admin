<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="/WEB-INF/adminlte.jsp"></jsp:include>
    <title><sitemesh:write property="title"/></title>
    <sitemesh:write property="head"/>
</head>
<body class="hold-transition skin-blue sidebar-mini">
<script>
    var q = '${param.q}';
    try {
        $(document).on("transitionend", ".content-wrapper", function () {
            localStorage["sidebar-collapse"] = $("body").hasClass("sidebar-collapse") ? "sidebar-collapse" : "";
        });
        $("body").addClass(localStorage["sidebar-collapse"]);
    } catch (e) {
    }
</script>
<div class="wrapper">

    <header class="main-header">

        <a href="#" class="logo">
            <!-- mini logo for sidebar mini 50x50 pixels -->
            <span class="logo-mini">CA</span>
            <!-- logo for regular state and mobile devices -->
            <span class="logo-lg">Crystal Admin</span>
        </a>

        <nav class="navbar navbar-static-top" role="navigation">
            <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
                <span class="sr-only">Toggle navigation</span>
            </a>
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <li>
                        <a id="btn-modify-pwd" href="#" data-toggle="modal" data-target="#pwd-dlg"><i
                                class="fa fa-key"></i> 修改密码</a>
                    </li>
                    <li>
                        <a id="btn-logout" href="${ctx}/logout"><i class="fa fa-power-off"></i> 注 销</a>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <aside class="main-sidebar main-sidebar-gray">

        <section class="sidebar">
            <!-- search form (Optional) -->
            <div class="sidebar-form">
                <form>
                    <c:forEach var="paramEntry" items="${param}">
                        <c:if test="${paramEntry.key != 'q'}">
                            <input type="hidden" name="${paramEntry.key}" value="${paramEntry.value}">
                        </c:if>
                    </c:forEach>
                    <div class="input-group">
                        <input type="text" name="q" class="form-control" placeholder="搜索..." value="${param.q}" onfocus="this.select();" onmouseup="this.select();">
                        <span class="input-group-btn">
                            <button type="submit" class="btn btn-flat"><i class="fa fa-search"></i>
                            </button>
                        </span>
                    </div>
                </form>
            </div>
            <ul class="sidebar-menu">
            </ul>
        </section>
    </aside>

    <div class="content-wrapper">
        <section class="content easyui-wrapper">
            <sitemesh:write property="body"/>
        </section>
    </div>

    <footer class="main-footer">
        <div class="pull-right hidden-xs">
            Anything you want
        </div>
        <strong>Copyright &copy; 2016 <a href="#">Company</a>.</strong> All rights reserved.
    </footer>

    <div class="modal fade" id="pwd-dlg">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">修改密码</h4>
                </div>
                <form id="pwd-form" class="form-horizontal" data-toggle="validator">
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="input-old-pwd" class="col-sm-3 control-label">
                                原密码
                                <span class="text-red">*</span>
                                :
                            </label>
                            <div class="col-sm-8">
                                <input id="input-old-pwd" type="password" name="oldPwd" class="form-control" required>
                                <span class="help-block with-errors"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="input-new-pwd" class="col-sm-3 control-label">
                                新密码
                                <span class="text-red">*</span>
                                :
                            </label>
                            <div class="col-sm-8">
                                <input id="input-new-pwd" type="password" name="newPwd" class="form-control" required>
                                <span class="help-block with-errors"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="input-new-pwd2" class="col-sm-3 control-label">
                                确认新密码
                                <span class="text-red">*</span>
                                :
                            </label>
                            <div class="col-sm-8">
                                <input id="input-new-pwd2" type="password" name="newPwd2" class="form-control"
                                       data-match="#input-new-pwd"
                                       data-match-error="两次密码输入不一致" required>
                                <span class="help-block with-errors"></span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">确定</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    $("form[data-toggle=validator]").attr("data-disable", "false");
    $("input[data-toggle=integer]").inputNumber();
    $(".modal.fade").attr("data-backdrop", "static");
    $('input').iCheck({
        checkboxClass: 'icheckbox_square-blue',
        radioClass: 'iradio_square-blue'
    });
    <c:if test="${not empty first_time_login }">
    bootbox.confirm({
        title: "首次登录",
        message: "是否修改密码?",
        buttons: {
            confirm: {
                label: "现在修改",
                className: "btn-primary btn-sm",
            },
            cancel: {
                label: "跳过",
                className: "btn-sm",
            }
        },
        callback: function (result) {
            if (result) {
                $("#btn-modify-pwd").trigger("click");
            }
        }
    });
    <c:remove var="first_time_login"/>
    </c:if>

    $('#pwd-form').validator().on('submit', function (e) {
        if (!e.isDefaultPrevented()) {
            e.preventDefault();
            var _oldPwd = $("#pwd-form [name=oldPwd]").val();
            var _newPwd = $("#pwd-form [name=newPwd]").val();
            var _newPwd2 = $("#pwd-form [name=newPwd2]").val();
            if (!/^[a-zA-Z0-9]+$/.test(_newPwd) || _newPwd.length > 16) {
                $.gritter.add("密码长度不超过16字符，为英文或数字!");
                return false;
            }
            $.post(ctx + '/modifypwd', {
                oldPwd: $.md5(_oldPwd),
                newPwd: $.md5(_newPwd),
                newPwd2: $.md5(_newPwd2)
            }, function (data) {
                $("#pwd-dlg").modal("hide");
                bootbox.alert({
                    title: "提示",
                    message: "密码修改成功,即将重新登录!",
                    buttons: {
                        ok: {
                            label: "确定",
                            className: "btn-primary",
                        }
                    },
                    callback: function () {
                        $("#btn-logout i").trigger("click");
                    }
                });
            });
        }
    });

    $(function () {
        function renderMenu($ul, menu, lv) {
            if (!menu) {
                return;
            }
            if (!menu.id) {
                $ul.empty();
                $.each(menu.subMenus, function (i, a) {
                    renderMenu($ul, a, lv + 1);
                });
                return;
            }
            if (menu.url) {
                var $li = $("<li></li>");
                var $a = $("<a href='{0}'></a>".format(ctx + menu.url));
                $a.append("<i class='{0}'></i>".format(menu.icon || (lv == 1 ? "fa fa-file-o" : "fa fa-caret-right")));
                $a.append(" <span>{0}</span>".format(menu.title));
                $li.append($a);
                $ul.append($li);
                return;
            }
            if (menu.title && !menu.url) {
                var $li = $("<li class='treeview'></li>");
                var $a = $("<a href='#'></a>");
                $a.append("<i class='{0}'></i>".format(menu.icon || "fa fa-folder-open-o"));
                $a.append(" <span>{0}</span>".format(menu.title));
                $a.append("<span class='pull-right-container'></span>");
                $li.append($a);

                var $subul = $("<ul class='treeview-menu menu-open'></ul>");
                $li.append($subul);

                $.each(menu.subMenus, function (i, a) {
                    renderMenu($subul, a, lv + 1);
                });

                $ul.append($li);
                return;
            }
        }//renderMenu

        var $menu = $("ul.sidebar-menu");
        $.post(ctx + '/menu/tree', function (data) {
            renderMenu($menu, data, 0);
            //阻止菜单的展开关闭动作
            $menu.find("> li > a").click(function () {
                return false;
            });
            //$menu.append("<li class='header text-gray text-center'><i class='fa fa-sitemap'></i>  设备树</li>")

            //渲染菜单状态
            $menu.find("li").removeClass('active');
            $link = $menu.find("li a[href='{0}']".format(location.pathname)).first();
            if ($link.size() == 1) {
                $link.parents("ul.sidebar-menu li").addClass("active");
            }
        }, "json");
    });
</script>
</body>
</html>
