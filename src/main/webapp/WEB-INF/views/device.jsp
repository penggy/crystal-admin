<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html>
<head>
<title>设备管理</title>
<link rel="stylesheet" href="${ctx}/resources/adminlte-2.3.6/plugins/bootstrap-select/bootstrap-select.min.css">
<script type="text/javascript" src="${ctx}/resources/adminlte-2.3.6/plugins/bootstrap-select/bootstrap-select.min.js"></script>
<script type="text/javascript" src="${ctx}/resources/adminlte-2.3.6/plugins/bootstrap-select/defaults-zh_CN.min.js"></script>
</head>
<body>
	<table id="device-table" class="easyui-datagrid" width="100%" rownumbers="true" pagination="true" toolbar="#device-tb"
		url="${ctx}/device/devices?q=${param.q}" pageSize="20" singleSelect="true" title="设备列表">
		<thead>
			<tr>
				<th field="model" width="120" align="center">型号</th>
				<th field="ver" width="100" align="center" sortable="true">版本</th>
				<th field="ip" width="140" align="center">IP</th>
				<th field="status" width="80" align="center" formatter="formatStatus">状态</th>
				<th field="id" width="100" align="center" formatter="formatPos">位置</th>
				<th field="id" width="120" align="center" formatter="formatOpt">操作</th>
			</tr>
		</thead>
	</table>

	<div id="device-tb">
		<button type="button" class="easyui-linkbutton" iconCls="fa fa-plus" plain="true" data-toggle="modal"
			data-target="#device-dlg">新增设备</button>
	</div>

	<div class="modal fade" id="device-dlg">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">编辑设备</h4>
				</div>
				<form id="menu-form" class="form-horizontal" data-toggle="validator">
					<div class="modal-body">
						<input type="hidden" name="id" value="">
						<div class="form-group">
							<label for="input-device-model" class="col-sm-3 control-label">
								<span class="text-red">*</span>
								型号
								:
							</label>
							<div class="col-sm-8">
								<input id="input-device-model" type="text" name="model" class="form-control" required>
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-device-ver" class="col-sm-3 control-label">版本:</label>
							<div class="col-sm-8">
								<input id="input-device-ver" type="text" name="ver" class="form-control">
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-device-ip" class="col-sm-3 control-label">IP:</label>
							<div class="col-sm-8">
								<input id="input-device-ip" type="text" name="ip" class="form-control">
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-device-status" class="col-sm-3 control-label">状态:</label>
							<div class="col-sm-8">
								<select id="input-device-status" name="status" class="form-control selectpicker" data-live-search="true" title="选择...">
									<option>关闭</option>
									<option>开启</option>
									<option>故障</option>
								</select>
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

	<script type="text/javascript">
		function formatStatus() {

		}
		function formatOpt() {

		}
		function formatPos() {

		}
		$(function() {
			$("#input-device-status").selectpicker({
			}).on('changed.bs.select',function(){
				console.log($(this).val());
			});
		})
	</script>
</body>
</html>