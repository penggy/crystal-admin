<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html>
<head>
<title>访问记录</title>
<link rel="stylesheet" href="${ctx }/resources/adminlte-2.3.6/plugins/daterangepicker/daterangepicker.css" />
<script src="${ctx }/resources/adminlte-2.3.6/plugins/daterangepicker/moment-with-locales.js"></script>
<script src="${ctx }/resources/adminlte-2.3.6/plugins/daterangepicker/daterangepicker.js"></script>
</head>
<body>
	<div class="page-header">
		<div class="form-inline form-search pull-right col-md-4 col-lg-3">
			<div class="form-group">
				<div class="input-group">
					<span class="input-group-addon">
						<i class="fa fa-calendar"></i>
					</span>
					<input class="form-control search-query" type="text" name="dateRange" placeholder="访问时间" value="">
					<span class="input-group-btn">
						<button type="button" class="btn btn-primary" onclick="javascript:searchLog();">
							查询 <i class="ace-icon fa fa-search icon-on-right"></i>
						</button>
					</span>
				</div>
			</div>
		</div>
		<div class="clearfix"></div>
	</div>
	<table id="log-table" class="easyui-datagrid" width="100%" rownumbers="true" pagination="true" url="${ctx}/log/logs?q=${param.q}"
		pageSize="20" singleSelect="true" title="访问记录列表">
		<thead>
			<tr>
				<th field="username" width="120" align="center" sortable="true">用户名</th>
				<th field="method" width="80" align="center">访问方式</th>
				<th field="path" width="200" align="left" sortable="true">访问路径</th>
				<th field="ip" width="140" align="center">远程IP</th>
				<th field="time" width="140" align="center" formatter="formatDateTime" sortable="true">访问时间</th>
				<th field="params" width="600" align="left">访问参数</th>
				<th field="ua" width="800" align="left">UA</th>
			</tr>
		</thead>
	</table>

	<script type="text/javascript">
		$(function() {
			moment.locale("zh-cn");
			$("input[name=dateRange]").daterangepicker({
				applyClass : 'btn-sm btn-primary',
				cancelClass : 'btn-sm btn-default',
				autoUpdateInput : false,
				locale : {
					format : 'YYYY-MM-DD',
					applyLabel : '确定',
					cancelLabel : '取消',
					customRangeLabel : '自定义',
					fromLabel : '从',
					toLabel : '到'
				}
			}).on('apply.daterangepicker', function(ev, picker) {
				$(this).val(picker.startDate.format('YYYY-MM-DD') + ' - ' + picker.endDate.format('YYYY-MM-DD'));
			}).on('cancel.daterangepicker', function(ev, picker) {
				$(this).val('');
			}).prev().on("click", function() {
				$(this).next().focus();
			});
		})
		function searchLog() {
			$("#log-table").datagrid("load", {
				q : '',
				dateRange : $("input[name=dateRange]").val()
			});
		}
	</script>
</body>
</html>