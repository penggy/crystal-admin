<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html>
<head>
<title>一级渠道管理</title>

<style type="text/css">
</style>

<link rel="stylesheet" href="${ctx }/resources/css/daterangepicker.css" />

<script src="${ctx }/resources/assets/js/fuelux.spinner.min.js"></script>
<script src="${ctx }/resources/js/moment-with-locales.js"></script>
<script src="${ctx }/resources/js/daterangepicker.js"></script>

</head>
<body>
	<div class="page-header">
		<div class="form-search clearfix">
			<div class="input-group pull-right col-md-4 col-lg-2">
				<input type="text" class="form-control search-query" placeholder="渠道名,渠道码" id="input-channel-search">
				<span class="input-group-btn">
					<button type="button" class="btn btn-info btn-sm" onclick="javascript:searchChannel();">
						查询 <i class="ace-icon fa fa-search icon-on-right"></i>
					</button>
				</span>
			</div>
		</div>
	</div>
	<table id="channel-table" class="easyui-datagrid" width="100%" rownumbers="true" pagination="true"
		data-options="onLoadSuccess : refreshWellcome" url="${ctx}/channel/channels" singleSelect="true" toolbar="#channel-tb"
		title="一级渠道列表">
		<thead>
			<tr>
				<th field="name" width="100" align="center" sortable="true" formatter="formatChannelName">渠道</th>
				<th field="code" width="100" align="center" sortable="true">渠道码</th>
				<th field="lv" width="80" align="center" formatter="formatLv">渠道级别</th>
				<th field="authCode" width="80" align="center" sortable="true">授权码</th>
				<th field="disable" width="60" align="center" sortable="true" formatter="formatState">状态</th>
				<th field="realRemainCount" width="100" align="center" sortable="true">剩余可用授权</th>
				<th field="realUsedCount" width="100" align="center" sortable="true">累计使用授权</th>
				<th field="totalCount" width="100" align="center" sortable="true">累计发放授权</th>
				<th field="id" width="400" align="center" formatter="formatOpt">操作</th>
			</tr>
		</thead>
	</table>
	<div id="channel-tb">
		<button type="button" class="easyui-linkbutton" iconCls="fa fa-plus" plain="true" data-toggle="modal"
			data-target="#channel-dlg">新增一级渠道</button>
	</div>
	<div class="modal fade" id="channel-dlg">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">渠道详情</h4>
				</div>
				<form id="channel-form" class="form-horizontal" data-toggle="validator">
					<div class="modal-body">
						<input type="hidden" name="id" value="">
						<div class="form-group">
							<label for="input-channel-name" class="col-sm-4 control-label">
								渠道名
								<span class="light-red">*</span>
								:
							</label>
							<div class="col-sm-7">
								<input id="input-channel-name" type="text" name="name" class="form-control" required>
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-channel-lv" class="col-sm-4 control-label">渠道级别:</label>
							<div class="col-sm-7">
								<select id="input-channel-lv" name="lv" class="form-control" required>
									<option value="一级渠道">一级渠道</option>
								</select>
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-channel-code" class="col-sm-4 control-label">
								渠道码/登录用户名
								<span class="light-red">*</span>
								:
							</label>
							<div class="col-sm-7">
								<input id="input-channel-code" type="text" name="code" class="form-control" required>
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-channel-auth-code" class="col-sm-4 control-label">授权码:</label>
							<div class="col-sm-7">
								<input id="input-channel-auth-code" type="text" name="authCode" class="form-control" placeholder="自动生成"
									readonly="readonly">
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-channel-admin-name" class="col-sm-4 control-label">
								联系人
								<span class="light-red">*</span>
								:
							</label>
							<div class="col-sm-7">
								<input id="input-channel-admin-name" type="text" name="adminName" class="form-control" required>
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-channel-phone-number" class="col-sm-4 control-label">联系电话:</label>
							<div class="col-sm-7">
								<input id="input-channel-phone-number" type="text" name="phoneNumber" class="form-control">
								<span class="help-block with-errors"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="input-channel-email" class="col-sm-4 control-label">邮箱:</label>
							<div class="col-sm-7">
								<input id="input-channel-email" type="email" name="email" class="form-control">
								<span class="help-block with-errors"></span>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="submit" class="btn btn-primary">保存并关闭</button>
					</div>
				</form>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<div class="modal fade" id="add-auth-dlg">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">增加授权</h4>
				</div>
				<form id="add-auth-form" class="form-horizontal" data-toggle="validator">
					<div class="modal-body">
						<div class="well">
							<div class="form-group">
								<label for="input-channel" class="col-sm-3 control-label" style="text-align: left;">一级渠道:</label>
								<div class="col-sm-5">
									<select id="input-channel" name='id' class="form-control" require></select>
									<span class="help-block with-errors"></span>
								</div>
							</div>
							<div class="form-group">
								<label class="channel-info" style="text-align: left;"></label>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-1"></div>
							<label for="input-add-auth" class="col-sm-3 control-label">增加授权数:</label>
							<div class="col-sm-3">
								<input id="input-add-auth" type="text" name="count" class="form-control" data-toggle="integer">
								<span class="help-block with-errors"></span>
							</div>
							<div class="col-sm-5"></div>
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

	<div class="modal fade" id="export-dlg">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">导出授权记录</h4>
				</div>
				<form id="export-form" class="form-horizontal" data-toggle="validator">
					<input type="hidden" name="id" />
					<div class="modal-body">
						<div class="alert alert-info">导出记录过大, 请选择日期区间导出!</div>
						<div class="form-group">
							<label for="input-add-auth" class="col-sm-4 control-label">
								导出日期区间
								<span class="light-red">*</span>
								:
							</label>
							<div class="col-sm-7">
								<div class="input-group">
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
									<input class="form-control" type="text" name="dateRange" required>
								</div>
								<span class="help-block with-errors"></span>
							</div>
							<div class="col-sm-5"></div>
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
			moment.locale("zh-cn");
			$("input[name=dateRange]").daterangepicker({
				'applyClass' : 'btn-sm btn-success',
				'cancelClass' : 'btn-sm btn-default',
				"ranges" : {
					"今天" : [ moment().format("YYYY-MM-DD"), moment().format("YYYY-MM-DD") ],
					"最近一星期" : [ moment().add(-1, "w").add(1, 'd').format("YYYY-MM-DD"), moment().format("YYYY-MM-DD") ],
					"最近一个月" : [ moment().add(-1, "M").add(1, 'd').format("YYYY-MM-DD"), moment().format("YYYY-MM-DD"), ],
					"最近一年" : [ moment().add(-1, "y").add(1, 'd').format("YYYY-MM-DD"), moment().format("YYYY-MM-DD"), ]
				},
				startDate : moment().add(-1, "M").add(1, 'd').format("YYYY-MM-DD"),
				endDate : moment().format("YYYY-MM-DD"),
				locale : {
					format : 'YYYY-MM-DD',
					applyLabel : '确定',
					cancelLabel : '取消',
					customRangeLabel : '自定义',
					fromLabel : '从',
					toLabel : '到'
				}
			}).prev().on(ace.click_event, function() {
				$(this).next().focus();
			});
			$(document).on(
					"shown.bs.modal",
					"#export-dlg",
					function() {
						$("input[name=dateRange]").data("daterangepicker").setStartDate(
								moment().add(-1, "M").add(1, 'd').format("YYYY-MM-DD"));
						$("input[name=dateRange]").data("daterangepicker").setEndDate(moment().format("YYYY-MM-DD"));
					});

			$("#input-add-auth").ace_spinner({
				value : 1,
				min : 1,
				max : 100000000,
				step : 1,
				on_sides : true,
				icon_up : 'ace-icon fa fa-plus smaller-75',
				icon_down : 'ace-icon fa fa-minus smaller-75',
				btn_up_class : 'btn-success',
				btn_down_class : 'btn-danger'
			});
			$(document).on(
					"change",
					"#input-channel",
					function() {
						var id = $(this).val();
						var row = $(this).find("option[value={0}]".format(id)).data('channel');
						var info = "剩余授权: {0} &nbsp;&nbsp;&nbsp;&nbsp;累计使用授权: {1}  &nbsp;&nbsp;&nbsp;&nbsp;累计发放授权: {2}".format(
								row.realRemainCount, row.realUsedCount, row.totalCount);
						$("#add-auth-dlg .well .channel-info").html(info);
					});
			$('#export-form').validator().on('submit', function(e) {
				if (!e.isDefaultPrevented()) {
					e.preventDefault();
					easyloader.load("messager",function(){
						$.messager.progress();
						$.ajax({
							url : ctx + '/channel/exportlog',
							type : 'post',
							data : $("#export-form").serialize(),
							success : function(data) {
								$("#export-dlg").modal("hide");
								location.href = data;
							},
							complete : function() {
								$.messager.progress("close");
							}
						});
					});
				}
			});
			$('#channel-form').validator().on('submit', function(e) {
				if (!e.isDefaultPrevented()) {
					e.preventDefault();
					var row = $("#channel-table").datagrid("getSelected");
					var id = $("#channel-form input[name=id]").val();
					var code = $("#input-channel-code").val();
					if (row && id && row.code != code) {
						bootbox.confirm({
							title : "提示",
							message : "修改渠道码，会重置该渠道[{0}]登录密码，是否继续?".format(row.name),
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
									$.post(ctx + '/channel/save', $("#channel-form").serialize(), function(data) {
										$.gritter.add({
											text : '提交成功!',
											class_name : 'gritter-info'
										});
										$("#channel-dlg").modal("hide");
										$("#channel-table").datagrid("reload");
									});
								}
							}
						});
						return;
					}
					$.post(ctx + '/channel/save', $("#channel-form").serialize(), function(data) {
						$.gritter.add({
							text : '提交成功!',
							class_name : 'gritter-info'
						});
						$("#channel-dlg").modal("hide");
						$("#channel-table").datagrid("reload");
					});
				}
			});
			$(document).on("shown.bs.modal", "#channel-dlg", function() {
				var id = $(this).find("input[name=id]").val();
				if (id) {
					$(this).find(".modal-title").text("渠道详情");
				} else {
					$(this).find(".modal-title").text("新增渠道");
				}
			});
			$('#add-auth-form').validator().on('submit', function(e) {
				if (!e.isDefaultPrevented()) {
					e.preventDefault();
					$.post(ctx + '/channel/addauth', $("#add-auth-form").serialize(), function(data) {
						$.gritter.add({
							text : '提交成功!',
							class_name : 'gritter-info'
						});
						$("#add-auth-dlg").modal("hide");
						$("#channel-table").datagrid("reload");
					});
				}
			});
		});

		function formatChannelName(val, row, idx) {
			/* if(row.disable == 1){
				return val;
			} */
			return "<a href='javascript:editChannel();'>{0}</a>".format(val);
		}

		function formatState(val, row, idx) {
			return val ? "禁用" : "正常";
		}

		function formatOpt(val, row, idx) {
			var btns = "<div class='btn-group'>";
			if (row.disable) {
				btns += "<a class='btn btn-xs btn-success' href='javascript:addAuth();' disabled='disabled'><i class='ace-icon fa fa-plus'></i> 增加授权</a>";
				btns += "<a class='btn btn-xs btn-primary' href='javascript:resetPwd();' disabled='disabled'><i class='ace-icon fa fa-undo'></i> 重置密码</a>";
				btns += "<a class='btn btn-xs btn-warning' href='javascript:enableChannel();'><i class='ace-icon fa fa-check'></i> 启用</a>";
			} else {
				btns += "<a class='btn btn-xs btn-success' href='javascript:addAuth();'><i class='ace-icon fa fa-plus'></i> 增加授权</a>";
				btns += "<a class='btn btn-xs btn-primary' href='javascript:resetPwd();'><i class='ace-icon fa fa-undo'></i> 重置密码</a>";
				btns += "<a class='btn btn-xs btn-danger' href='javascript:disableChannel();'><i class='ace-icon fa fa-ban'></i> 禁用</a>";
			}
			btns += "<a class='btn btn-xs btn-info' href='javascript:exportLog();'><i class='ace-icon fa fa-download'></i> 导出授权记录</a>";

			<c:if test="${not empty param.remove }">
			btns += "<a class='btn btn-xs btn-danger' href='javascript:removeChannel();'><i class='ace-icon fa fa-remove'></i> 删除</a>";
			</c:if>

			btns += "</div>";
			return btns;
		}

		function formatLv(val, row, idx) {
			return row.parent ? "二级渠道" : "一级渠道";
		}

		function addAuth() {
			var row = $("#channel-table").datagrid("getSelected");
			$("#input-channel").empty();
			$.ajax({
				url : ctx + '/channel/subs',
				type : 'post',
				async : false,
				success : function(data) {
					$.each(data, function(i, a) {
						var $opt = $("<option value='{0}'>{1}</option>".format(a.id, a.name));
						$opt.data('channel', a);
						$("#input-channel").append($opt);
					});
				}
			});
			$("#add-auth-form").find("[name=id]").val(row.id);
			$("#input-add-auth").ace_spinner('value', 1);
			$("#add-auth-dlg .well .channel-title").text(row.name);
			var info = "剩余授权: {0} &nbsp;&nbsp;&nbsp;&nbsp;累计使用授权: {1}  &nbsp;&nbsp;&nbsp;&nbsp;累计发放授权: {2}".format(
					row.realRemainCount, row.realUsedCount, row.totalCount);
			$("#add-auth-dlg .well .channel-info").html(info);

			$("#add-auth-dlg").modal('show');
		}

		function editChannel() {
			var row = $("#channel-table").datagrid("getSelected");
			$("#channel-form").form("load", row);
			$("#channel-dlg").modal('show');
		}

		function disableChannel() {
			var msg = "<h4 class='bigger red'>危险!</h4><p>";
			msg += "您即将禁用<span class='bolder bigger'>一级渠道-{0}</span>，禁用后该渠道已授权的终端将无法继续使用，且无法授权新的终端。</p>";
			msg += "<p class='bolder bigger'>请确认!</p>";
			var row = $("#channel-table").datagrid("getSelected");
			msg = msg.format(row.name);
			bootbox.confirm({
				title : "提示",
				message : msg,
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
						$.post(ctx + '/channel/disable', "id=" + row.id, function(data) {
							$("#channel-table").datagrid("reload");
						})
					}
				}
			});

		}

		function enableChannel() {
			var row = $("#channel-table").datagrid("getSelected");
			$.post(ctx + '/channel/enable', "id=" + row.id, function(data) {
				$("#channel-table").datagrid("reload");
			})
		}

		function exportLog() {
			var row = $("#channel-table").datagrid("getSelected");
			easyloader.load("messager",function(){
				$.messager.progress();
				$.ajax({
					url : ctx + '/channel/exportlog',
					type : 'post',
					data : "id=" + row.id,
					success : function(data) {
						if (data == 'OutOfSize') {
							$("#export-form input[name=id]").val(row.id);
							$("#export-dlg").modal("show");
							return;
						}
						location.href = data;
					},
					error : function(xhr){
						var msg = xhr.responseText || "";
						if(msg.indexOf("记录过大") >=0 ){
							$("#export-form input[name=id]").val(row.id);
							$("#export-dlg").modal("show");
						}
					},
					complete : function() {
						$.messager.progress("close");
					}
				});
			});
		}

		function removeChannel() {
			var row = $("#channel-table").datagrid("getSelected");
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
						$.post(ctx + '/channel/remove', "id=" + row.id, function(data) {
							$("#channel-table").datagrid("reload");
						});
					}
				}
			});
		}

		function resetPwd() {
			var row = $("#channel-table").datagrid("getSelected");
			bootbox.confirm({
				title : "提示",
				message : "确定要重置渠道 <span class='bolder bigger'>{0}</span> 密码?".format(row.name),
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
						$.post(ctx + '/channel/resetpwd', "id=" + row.id, function(data) {
							$.gritter.add({
								text : '渠道[{0}]重置密码成功!'.format(row.name),
								class_name : 'gritter-info'
							});
						});
					}
				}
			});
		}

		function searchChannel() {
			$("#channel-table").datagrid("load", {
				queryText : $("#input-channel-search").val()
			});
		}
	</script>
</body>
</html>