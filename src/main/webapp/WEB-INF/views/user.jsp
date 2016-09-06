<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html>
<head>
<title>用户管理</title>

<style type="text/css">
</style>
</head>
<body>
	<table id="user-table" class="easyui-datagrid" width="100%" rownumbers="true" pagination="true"
		url="${ctx}/user/users?q=${param.q}" singleSelect="true" toolbar="#user-tb">
		<thead>
			<tr>
				<th field="username" width="120" align="center">用户名</th>
				<th field="roles" width="150" align="center">角色</th>
				<th field="lastLoginTime" width="140" align="center" formatter="formatDateTime">最近登录时间</th>
				<th field="id" width="180" align="center" formatter="formatOpt">操作</th>
			</tr>
		</thead>
	</table>
	<div id="user-tb">
		<button type="button" class="easyui-linkbutton" iconCls="fa fa-plus" plain="true" data-toggle="modal"
			data-target="#user-dlg">新增用户</button>
	</div>

	<div class="modal fade" id="user-dlg">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">编辑用户</h4>
				</div>
				<form id="user-form" class="form-horizontal" data-toggle="validator">
					<div class="modal-body">
						<input type="hidden" name="id" value="">
						<div class="form-group">
							<label for="input-username" class="col-sm-3 control-label">
								<span class="text-red">*</span>
								用户名
								:
							</label>
							<div class="col-sm-8">
								<input id="input-username" type="text" name="username" class="form-control" required>
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-roles" class="col-sm-3 control-label">角色:</label>
							<div class="col-sm-8">
								<input id="input-roles" type="text" name="roles" class="form-control">
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
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<script type="text/javascript">
		$(function() {
			$(document).on("shown.bs.modal", "#user-dlg", function() {
				var id = $(this).find("input[name=id]").val();
				if (id) {
					$(this).find(".modal-title").text("编辑用户");
				} else {
					$(this).find(".modal-title").text("新增用户");
				}
			});
			$('#user-form').validator().on('submit', function(e) {
				if (!e.isDefaultPrevented()) {
					e.preventDefault();
					$.post(ctx + '/user/save', $("#user-form").serialize(), function(data) {
						$.gritter.add({
							text : '提交成功!',
							class_name : 'gritter-info'
						});
						$("#user-dlg").modal("hide");
						$("#user-table").datagrid("reload");
					});
				}
			});
		});

		function formatOpt(val, row, idx) {
			var btns = "<div class='btn-group'>";
			btns += "<a class='btn btn-xs btn-primary' href='javascript:editUser();'><i class='ace-icon fa fa-edit'></i> 编辑</a>";
			btns += "<a class='btn btn-xs btn-warning' href='javascript:resetPwd();'><i class='ace-icon fa fa-undo'></i> 重置密码</a>";
			btns += "<a class='btn btn-xs btn-danger' href='javascript:removeUser();'><i class='ace-icon fa fa-remove'></i> 删除</a>";
			btns += "</div>";
			return btns;
		}

		function editUser() {
			var row = $("#user-table").datagrid("getSelected");
			$("#user-form").form("load", row);
			$("#user-dlg").modal("show");
		}
		
		function resetPwd(){
			var row = $("#user-table").datagrid("getSelected");
			bootbox.confirm({
				title : "提示",
				message : "确定要重置用户 <span class='label label-warning'>{0}</span> 密码?".format(row.username),
				buttons : {
					confirm : {
						label : "确定",
						className : "btn-primary btn-sm",
					},
					cancel : {
						label : "取消",
						className : "btn-sm",
					}
				},
				callback : function(result) {
					if (result) {
						$.post(ctx + '/user/resetpwd', "id=" + row.id, function(data) {
							$.gritter.add({
								text : '用户[{0}]重置密码成功!'.format(row.username),
								class_name : 'gritter-info'
							});
						});
					}
				}
			});
		}

		function removeUser() {
			var row = $("#user-table").datagrid("getSelected");
			bootbox.confirm({
				title : "提示",
				message : "确定删除用户 <span class='label label-danger'>{0}</span> ?".format(row.username),
				buttons : {
					confirm : {
						label : "确定",
						className : "btn-primary btn-sm",
					},
					cancel : {
						label : "取消",
						className : "btn-sm",
					}
				},
				callback : function(result) {
					if (result) {
						$.post(ctx + '/user/remove', "id=" + row.id, function(data) {
							$("#user-table").datagrid("reload");
						});
					}
				}
			});
		}
	</script>
</body>
</html>