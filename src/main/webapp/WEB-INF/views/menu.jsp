<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html>
<head>
<title>菜单管理</title>

<style type="text/css">
</style>
</head>
<body>
	<table id="menu-table" class="easyui-datagrid" width="100%" rownumbers="true" pagination="true"
		url="${ctx}/menu/menus?pid=${pid}&q=${param.q}" singleSelect="true" toolbar="#menu-tb" title="${title }">
		<thead>
			<tr>
				<th field="title" width="120" align="center" formatter="formatTitle">名称</th>
				<th field="roles" width="120" align="center">角色</th>
				<th field="url" width="500" align="left">链接</th>
				<th field="id" width="180" align="center" formatter="formatOpt">操作</th>
			</tr>
		</thead>
	</table>
	<div id="menu-tb">
		<button type="button" class="easyui-linkbutton" iconCls="fa fa-plus" plain="true" data-toggle="modal"
			data-target="#menu-dlg">新增菜单</button>
	</div>

	<div class="modal fade" id="menu-dlg">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">编辑菜单</h4>
				</div>
				<form id="menu-form" class="form-horizontal" data-toggle="validator">
					<div class="modal-body">
						<input type="hidden" name="id" value="">
						<input type="hidden" name="pid" value="${pid }">
						<div class="form-group">
							<label for="input-menu-title" class="col-sm-3 control-label">
								<span class="text-red">*</span>
								名称
								:
							</label>
							<div class="col-sm-8">
								<input id="input-menu-title" type="text" name="title" class="form-control" required>
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-menu-icon" class="col-sm-3 control-label">图标:</label>
							<div class="col-sm-8">
								<input id="input-menu-icon" type="text" name="icon" class="form-control">
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-menu-url" class="col-sm-3 control-label">链接:</label>
							<div class="col-sm-8">
								<input id="input-menu-url" type="text" name="url" class="form-control">
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-menu-roles" class="col-sm-3 control-label">角色:</label>
							<div class="col-sm-8">
								<input id="input-menu-roles" type="text" name="roles" class="form-control">
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-menu-order" class="col-sm-3 control-label">排序:</label>
							<div class="col-sm-3">
								<input id="input-menu-order" type="text" name="order" class="form-control" data-toggle="integer" value="1">
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
			$(document).on("shown.bs.modal", "#menu-dlg", function() {
				var id = $(this).find("input[name=id]").val();
				if (id) {
					$(this).find(".modal-title").text("编辑菜单");
				} else {
					$(this).find(".modal-title").text("新增菜单");
					//$("#input-menu-order").ace_spinner('value', 1);
				}
			});
			$('#menu-form').validator().on('submit', function(e) {
				if (!e.isDefaultPrevented()) {
					e.preventDefault();
					$.post(ctx + '/menu/save', $("#menu-form").serialize(), function(data) {
						$.gritter.add({
							text : '提交成功!',
							class_name : 'gritter-info'
						});
						$("#menu-dlg").modal("hide");
						$("#menu-table").datagrid("reload");
					});
				}
			});
		});

		function formatTitle(val, row, idx) {
			return "<a href='{0}'>{1}</a>".format(ctx + '/menu?pid=' + row.id, val);
		}

		function formatOpt(val, row, idx) {
			var btns = "<div class='btn-group'>";
			btns += "<a class='btn btn-xs btn-primary' href='javascript:editMenu();'><i class='ace-icon fa fa-edit'></i> 编辑</a>";
			btns += "<a class='btn btn-xs btn-danger' href='javascript:removeMenu();'><i class='ace-icon fa fa-remove'></i> 删除</a>";
			btns += "</div>";
			return btns;
		}

		function editMenu() {
			var row = $("#menu-table").datagrid("getSelected");
			$("#menu-form").form("load", row);
			//$("#input-menu-order").ace_spinner('value', row.order);
			$("#menu-form [name='pid']").val(row.parent ? row.parent.id : '');
			$("#menu-dlg").modal("show");
		}

		function removeMenu() {
			var row = $("#menu-table").datagrid("getSelected");
			bootbox.confirm({
				title : "提示",
				message : "确定删除?",
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
						$.post(ctx + '/menu/remove', "id=" + row.id, function(data) {
							$("#menu-table").datagrid("reload");
						});
					}
				}
			});
		}
	</script>
</body>
</html>