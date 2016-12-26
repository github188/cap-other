<%
/**********************************************************************
* 嵌套子查询
* 2016-08-12 林玉千
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!doctype html>
<html ng-app='subQueryModel'>
<head>
	<meta charset="UTF-8"/>
    <title>嵌套子查询</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
  	<top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
  	<top:link href="/cap/bm/dev/entity/css/queryModel.css"></top:link>
	<style type="text/css">
    	
    </style>
    <script type="text/javascript">
		//获得传递参数
		var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		var isSubQuery=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("isSubQuery"))%>;
		var tableAlias=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("tableAlias"))%>;
		var subQueryId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("subQueryId"))%>;
	</script>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/validate.js"></top:script>
	<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/easy.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/sql/sql.js"></top:script>
	
    <top:script src="/cap/dwr/engine.js"></top:script> 
 	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityOperateAction.js"></top:script>
	<top:script src="/cap/dwr/interface/QueryPreviewFacade.js"></top:script>
	
	<top:script src="/cap/bm/dev/entity/js/entityMethodList.js"></top:script>
	<top:script src="/cap/bm/dev/entity/js/queryModel.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
</head>
<body ng-controller="subQueryModelController" data-ng-init="ready()">
	<div style="margin-left: 10px">
		<table class="cap-table-fullWidth">
			<tr>
				<td colspan="2" style="padding-top: 5px; padding-bottom: 5px;">
					<span class="cap-group" style="text-align:left;font-size: 15px;margin-bottom: 10px">子查询描述:</span>
					<span cui_input id="remark" width="300px" width="100%" ng-model="remark">
					</span>
					<div style="text-align:right;float:right;">
						<span cui_button id="confirm" onclick="confirm()" label="确定"></span>
						<span cui_button id="closeWin" onclick="closeWin()" label="关闭"></span>
					</div>
				</td>
			</tr>
			<tr>
				<td width="90%"><%@ include file="/cap/bm/dev/entity/QueryModel.jsp" %></td>
				<td width="10%"></td>
			</tr>
		</table>
	</div>
	<script type="text/javascript">
		//调用angularjs
	    angular.module('subQueryModel', ["cui"]).controller('subQueryModelController',['$scope',entityMethodList]);
		//关闭
		function closeWin() {
			window.close();
		}
		//确认
		function confirm() {
			//保存之前做相应的校验
			var validateQueryModelRule = checkRightColumnNameNeedRule();
			if (validateQueryModelRule[1]) {
				cui.alert(validateQueryModelRule[0]);
				return;
			}
			//子查询对象
			var refQueryModel = scope.selectEntityMethodVO.queryModel;
			if (refQueryModel.from.primaryTable && refQueryModel.select.selectAttributes 
				&& refQueryModel.select.selectAttributes.length > 0) {
				window.opener.fromRefQueryModelCallBack(refQueryModel, subQueryId, scope.remark);
				closeWin();
			} else {
				cui.alert("select属性不能为空！");
				return;
			}
		}
		
	</script>
</body>
</html>