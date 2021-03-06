<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/font-awesome-4.5.0/css/font-awesome.min.css">
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/ionicons-2.0.1/css/ionicons.min.css">
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/dist/css/AdminLTE.min.css">
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/dist/css/skins/skin-blue.min.css">

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
<![endif]-->

<script src="${ctx}/resources/adminlte-2.3.6/plugins/jQuery/jquery-2.2.3.min.js"></script>
<script src="${ctx}/resources/adminlte-2.3.6/bootstrap/js/bootstrap.min.js"></script>
<script src="${ctx}/resources/adminlte-2.3.6/dist/js/app.js"></script>
<script src="${ctx}/resources/adminlte-2.3.6/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/plugins/iCheck/all.css">
<script src="${ctx}/resources/adminlte-2.3.6/plugins/iCheck/icheck.min.js"></script>
<script src="${ctx}/resources/adminlte-2.3.6/plugins/md5/jquery.md5.js"></script>
<script src="${ctx}/resources/adminlte-2.3.6/plugins/input-number/jquery.inputnumber.js"></script>
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/plugins/gritter/jquery.gritter.css">
<script src="${ctx}/resources/adminlte-2.3.6/plugins/gritter/jquery.gritter.js"></script>
<script src="${ctx}/resources/adminlte-2.3.6/plugins/validator/validator.min.js"></script>
<script src="${ctx}/resources/adminlte-2.3.6/plugins/bootbox/bootbox.min.js"></script>
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/plugins/pace/pace.css">
<script src="${ctx}/resources/adminlte-2.3.6/plugins/pace/pace.js"></script>
<script src="${ctx}/resources/easyui/easyloader.js"></script>

<style>
    .datagrid-row-selected {
        background: #9dbdd6 !important;
    }

    .datagrid-body {
        overflow-x: auto !important;
    }

    button {
        outline: none !important;
    }

    /*always show sidebar second level menu*/
    .block, .treeview-menu.menu-open {
        display : block;
    }

    /*help for display easyui until parse done*/
    .easyui-wrapper{
        visibility: hidden;
    }

    /*fix sidebar menu top position*/
    .main-header   {
        max-height:none;
    }
    .input-group .input-group-addon {
    	background-color : #eee;
    }
</style>

<script type="text/javascript">
    var ctx = '${ctx}';

    //格式化时间
    Date.prototype.format = function (f) {
        var o = {
            "M+": this.getMonth() + 1, // month
            "d+": this.getDate(), // day
            "H+": this.getHours(), // hour
            "h+": this.getHours() % 12, // 12hour
            "m+": this.getMinutes(), // minute
            "s+": this.getSeconds(), // second
            "q+": Math.floor((this.getMonth() + 3) / 3), // quarter
            "S": this.getMilliseconds()
            // millisecond
        }
        if (/(y+)/.test(f)) {
            f = f.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        }
        for (var k in o) {
            if (new RegExp("(" + k + ")").test(f)) {
                f = f.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
            }
        }
        return f;
    }

    // String 格式化
    String.prototype.format = function (args) {
        var result = this;
        if (arguments.length > 0) {
            if (arguments.length == 1 && typeof (args) == "object") {
                for (var key in args) {
                    if (args[key] != undefined) {
                        var reg = new RegExp("({" + key + "})", "g");
                        result = result.replace(reg, args[key]);
                    }
                }
            } else {
                for (var i = 0; i < arguments.length; i++) {
                    if (arguments[i] != undefined) {
                        var reg = new RegExp("({)" + i + "(})", "g");
                        result = result.replace(reg, arguments[i]);
                    }
                }
            }
        }
        return result;
    }

    /** time formatter */
    function formatDateTime(value, row, index) {
        return new Date(value).format('yyyy-MM-dd HH:mm:ss');
    }
    function formatDate(value, row, index) {
        return new Date(value).format('yyyy-MM-dd');
    }
    /** link formatter */
    function formatLink(value, row, index) {
        return "<a href='{0}'>{1}</a>".format(value, value);
    }
    /** size formatter */
    function formatSize(value, row, index) {
        function roundFun(numberRound, roundDigit) {
            if (numberRound >= 0) {
                var tempNumber = parseInt((numberRound * Math.pow(10, roundDigit) + 0.5)) / Math.pow(10, roundDigit);
                return tempNumber;
            } else {
                numberRound1 = -numberRound
                var tempNumber = parseInt((numberRound1 * Math.pow(10, roundDigit) + 0.5)) / Math.pow(10, roundDigit);
                return -tempNumber;
            }
        }

        if (!value || value < 0) {
            return "0 Bytes";
        }
        var unitArr = new Array("Bytes", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB");
        var index = 0;
        var srcsize = parseFloat(value);
        var size = roundFun(srcsize / Math.pow(1024, (index = Math.floor(Math.log(srcsize) / Math.log(1024)))), 2);
        return size + unitArr[index];
    }

    $(function () {
        $.extend($.gritter.options, {
            class_name: 'gritter-error',
            position: 'bottom-right',
            fade_in_speed: 100,
            fade_out_speed: 100,
            time: 3000
        });

        $(".content-wrapper").on("transitionend",function(){
            $("table.easyui-datagrid").each(function (i) {
                $(this).datagrid("resize");
            });
        });
        $(".main-header").on("transitionend",function(){
            $.AdminLTE.layout.fix();
            $(".main-sidebar").css('padding-top',$(".main-header").outerHeight());
        });
        $(document).on('click','.sidebar-toggle',function(){
            $(".main-sidebar").css('padding-top',$(".main-header").outerHeight());
        })

        if (typeof errorMsg != 'undefined' && errorMsg) {
            $.gritter.add({
                text: errorMsg
            });
        }
        $(document).ajaxError(function (evt, xhr, opts, ex) {
            if (xhr.status == 401) {
                location.href = ctx + '/login';
                return false;
            }
            if (xhr.status == 404) {
                xhr.responseText = "请求服务不存在或已停止";
            }
            var msg = xhr.responseText;
            try {
                msg = JSON.parse(msg);
            } catch (e) {
            }
            if (typeof msg != 'undefined' && msg) {
                $.gritter.add({
                    text: msg
                });
            }
        });

        $(document).on("shown.bs.modal", ".modal", function () {
            //$(this).find("input:visible:first").focus();
        }).on("hidden.bs.modal", ".modal", function (e) {
            $(this).find("form").each(function(){
                $(this)[0].reset();
            });
            $(this).find("input:hidden").val('');
        }).on("show.bs.modal", ".modal", function (e) {
            $(this).find(".form-group").removeClass("has-error").removeClass("has-success");
            $(this).find(".with-errors").empty();
        });

        $(document).ajaxStart(function () {
            $(".modal:visible .btn-primary").prop("disabled", true).attr("data-ajaxing", "true");
        }).ajaxComplete(function () {
            $(".btn-primary:disabled[data-ajaxing=true]").prop("disabled", false).removeAttr("data-ajaxing");
        });

        $('form[data-toggle=validator]').validator().on('submit', function (e) {
            var $form = $(this);
            if (e.isDefaultPrevented()) {
                $form.find(".form-group.has-error:first").find("input:visible").focus();
            }
        });

        easyloader.theme = 'bootstrap';
        easyloader.locale = 'zh_CN';
        easyloader.onProgress = function(name) {
            if (name == 'parser') {
                $.parser.onComplete = function() {
                    $(".easyui-wrapper").removeClass("easyui-wrapper");
                    easyloader.load([ 'form' ]);
                }
            }
        }
    });
</script>
