
<%
	/**********************************************************************
	 * SQL查询页面
	 * 2014-12-18  zhangzunzhi  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>SQL查询编辑</title>

<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript" 
    src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/SQLQueryAction.js'></script>
<style type="text/css">
.imgMiddle {
	line-height: 350px;
	text-align: center;
}

.top_header_wrap {
	padding-right: 5px;
}
</style>
</head>
<body onload="window.status='Finished';">
	<div uitype="Borderlayout" id="body" is_root="true">
		<div class="top_header_wrap" >
			<div class="thw_title" style="padding-top: 3px;margin-top:0px;">
				<span><font id="pageTittle" class="fontTitle"></font></span>
			</div>
			<div class="thw_operate">
				<span uitype="button" label="保存" id="saveRole" on_click="saveRole" ></span>
				&nbsp;<span uitype="button" label="返回" id="back" on_click="openQuerySQLList" ></span>
			</div>
		</div>
		<div class="cui_ext_textmode" style="margin-top:5px;padding-left: 15px;">
			<table class="form_table" style="table-layout: fixed;">
				<tr>
					<td width="20%" ><span style="color: red">*</span>&nbsp;SELECT语句：</td>
					</tr>
					<tr>
					<td class="td_content">
						<div style="width:99%;">
							<span uitype="textarea"  name="querySQL"
								width="97%" databind="data.querySQL" height="380px"
								maxlength="4000" relation="defect2">
							</span>
							<div style="float:right;">
								<font>
								(您还能输入<label id="defect2" style="color: red"></label>个字符)
								</font>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td width="20%">描述：</td>
					</tr>
					<tr>
					<td class="td_content">
						<div style="width:99%;">
							<span uitype="textarea"  name="description"
								width="97%" databind="data.description" height="50px"
								maxlength="500" relation="defect1">
							</span>
							<div style="float:right;">
								<font>
								(您还能输入<label id="defect1" style="color: red"></label>个字符)
								</font>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>

	<script language="javascript">
		var queryId = "<c:out value='${param.queryId}'/>";//查询sql ID
		var data = {};
		var selectedQueryId ;
		//扫描，相当于渲染
		window.onload = function() {
			if (queryId) {//编辑
				dwr.TOPEngine.setAsync(false);
				SQLQueryAction.readQuerySQL(queryId, function(querySQLdata) {
					data = querySQLdata;
				});
				dwr.TOPEngine.setAsync(true);
			} else {//新增
			}
			comtop.UI.scan();
			if(queryId){
				$('#pageTittle').html('修改SQL')
			}else{
				$('#pageTittle').html('新增SQL')
			}
		}

		//保存sql信息
		function saveRole() {
			//获取表单信息
			var vo = cui(data).databind().getValue();
			if(window.parent.checkSQL(vo.querySQL)){
				vo.queryId = queryId;
				if (queryId) {//编辑
					SQLQueryAction.updateQuerySQL(vo, function(data) {
						cui.message('SQL修改成功。',"success");
						//window.parent.cui.message('SQL修改成功。',"success");
						setTimeout("openQuerySQLList(queryId)",400);
					});
				} else {
					SQLQueryAction.insertQuerySQL(vo, function(data) {
						cui.message('SQL新增成功。',"success");
						selectedQueryId = data.queryId;
						//window.parent.cui.message('SQL新增成功。',"success");
						setTimeout("openQuerySQLList(selectedQueryId)",400);
					});
				}
			}
			
		}
		
		function openQuerySQLList(selectedRowId){
			var url = '${pageScope.cuiWebRoot}/top/component/app/tool/QuerySQLList.jsp?selectedRowId='+selectedRowId;
			if(!window.parent.dialog){
				dialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
			}
			window.parent.dialog.show(url);
		}
	</script>
</body>
</html>