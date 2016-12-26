<%
/**********************************************************************
* 查询建模-Where自定义条件
* 2016-08-09 许畅 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='whereCustomCondition'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>自定义条件</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"/>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<style type="text/css">
	.cap-form-td{
		padding: 2px 0px 2px 0px;
	}
	</style>
</head>
<body class="body_layout" ng-controller="customConditionController" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td  class="cap-form-td" style="text-align: left;padding-left:5px;" width="30%">
						<span class="cap-group">自定义条件</span>
			        </td>
			        <td  class="cap-form-td" style="text-align: right;padding-right:5px" width="70%">
						<span cui_button id="confim" ng-click="confim()" label="确定"></span>
						<span cui_button id="close" ng-click="close()" label="关闭"></span>
			        </td>
			    </tr>

			    <tr ng-show="false">
			    	<td class="cap-form-td">
			    		<font color="red">*</font>条件描述:
			    	</td>
			    	<td class="cap-form-td" style="text-align:left;">
			    		<span cui_input id ="desc" ng-model="condition.desc" />
			    	</td>
			    </tr>

			    <tr>
			    	<td class="cap-form-td">
			    		<font color="red">*</font>SQL脚本:
			    	</td>
			    	<td class="cap-form-td" style="text-align:left;">
			    		<span cui_textarea id="customCondition" ng-model="condition.customCondition" width="95%"  height="250px" ></span>
			    	</td>
			    </tr>
			</table>
		</div>	
	</div>
</body>

<script type="text/javascript" charset="UTF-8">
		//实体id
		var modelId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var clickinputid = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("clickinputid"))%>;
		var value =  window.opener.scope.customCondition;
		//拿到angularJS的scope
		var scope = null;
		var condition = {};
		angular.module('whereCustomCondition', ["cui"]).controller('customConditionController', ['$scope', function($scope) {

			$scope.ready = function() {
				comtop.UI.scan();
				$scope.condition = condition;
				scope = $scope;
				$scope.init();
			};
             
			//初始化
			$scope.init = function() {
				$scope.condition.customCondition = value;
			};

			//确定
			$scope.confim = function() {
				window.opener.whereCustomConditionCallBack($scope.condition,clickinputid);
				window.close();
			};

			//关闭窗口
			$scope.close = function() {
				window.close();
			}

		}]);

</script>

</html>