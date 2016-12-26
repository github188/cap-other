<%
/**********************************************************************
* 查询建模-select属性表达式页面
* 2016-08-08 许畅 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='selectAttributeExp'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>添加属性表达式</title>
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
<body class="body_layout" ng-controller="selectAttributeExpController" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td class="cap-form-td" style="text-align: left;padding-left:5px;" width="30%">
						<span class="cap-group">添加属性表达式</span>
			        </td>
			        <td  class="cap-form-td" style="text-align: right;padding-right:5px" width="70%">
						<span cui_button id="confim" ng-click="confim()" label="确定"></span>
						<span cui_button id="close" ng-click="close()" label="关闭"></span>
			        </td>
			    </tr>

			    <tr>
			    	<td class="cap-form-td">
			    		<font color="red">*</font>查询结果别名:
			    	</td>
			    	<td class="cap-form-td" style="text-align:left;" ng-if="!isCanEdit">
			    		<span cui_clickinput id ="entityAttributeAlias" ng-model="queryAttribute.entityAttributeAlias" ng-disable="true" validate="entityAttributeAliasRule" on_iconclick="queryAttributeClick" />
			    	</td>

			    	<td class="cap-form-td" style="text-align:left;" ng-if="isCanEdit">
			    		<span cui_input id ="entityAttributeAlias" ng-model="queryAttribute.entityAttributeAlias"  validate="entityAttributeAliasRule"/>
			    	</td>
			    </tr>

			    <tr>
			    	<td class="cap-form-td">
			    		<font color="red">*</font>查询表达式:
			    	</td>
			    	<td class="cap-form-td" style="text-align:left;">
			    		<span cui_textarea id="sqlScript" ng-model="queryAttribute.sqlScript" width="95%"  height="200px" validate="sqlScriptRule"></span>
			    	</td>
			    </tr>

			    <tr ng-show="false">
			    	<td class="cap-form-td">
			    		实体id:
			    	</td>
			    	<td class="cap-form-td" style="text-align:left;">
			    		<span cui_input id="entityId" ng-model="queryAttribute.entityId" width="95%"  height="200px" ></span>
			    		<span cui_input id="engName" ng-model="queryAttribute.engName" width="95%"  height="200px" ></span>
			    		<span cui_input id="chName" ng-model="queryAttribute.chName" width="95%"  height="200px" ></span>
			    		<span cui_input id="dbFieldId" ng-model="queryAttribute.dbFieldId" width="95%"  height="200px" ></span>
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
		var operateType ="addNew";

		//拿到angularJS的scope
		var scope = null;
		var queryAttribute = {};
		var selectAttribute =  window.opener.scope.selectAttribute;
		angular.module('selectAttributeExp', ["cui"]).controller('selectAttributeExpController', ['$scope', function($scope) {

			$scope.ready = function() {
				$scope.queryAttribute = queryAttribute;
				scope = $scope;
				$scope.init();
				comtop.UI.scan();
			};

			$scope.init = function() {
				if(modelId && modelId!=""){
					$scope.isCanEdit = false;
				}else{
					$scope.isCanEdit = true;
				}
			};

			//确定
			$scope.confim = function() {
				if (!validateAll().validFlag){
					cui.alert("表单信息不完整,请先完善表单信息.");
					return;
				}

				var isCanAdd = window.opener.sqlScriptCallBack($scope.queryAttribute, operateType, null);
				if (isCanAdd) {
					window.close();
				} else {
					cui.alert("当前查询结果别名在SELECT属性中已存在,请重新选择.");
				}
			};

			//关闭窗口
			$scope.close = function() {
				window.close();
			}

			//实体属性选择
			$scope.queryAttributeClick = function() {
				var url = "RelationAttribute.jsp?packageId=" + packageId + "&modelId=" + modelId;
				var width = 500; //窗口宽度
				var height = 500; //窗口高度
				var top = (window.screen.height - 30 - height) / 2;
				var left = (window.screen.width - 10 - width) / 2;
				window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
			}
			
			$scope.confirmCallBack = function(selectedAttribute){
				$scope.queryAttribute.entityAttributeName = selectedAttribute.engName;
				$scope.queryAttribute.entityAttributeAlias = selectedAttribute.engName;
				$scope.queryAttribute.entityId = modelId;
				$scope.queryAttribute.engName = selectedAttribute.engName;
				$scope.queryAttribute.chName = selectedAttribute.chName;
				$scope.queryAttribute.dbFieldId = selectedAttribute.dbFieldId;
				$scope.$digest();
			}

		}]);

		var entityAttributeAliasRule = [{
			'type': 'required',
			'rule': {
				'm': '查询结果别名不能为空'
			}
		}];
		var sqlScriptRule = [{
			'type': 'required',
			'rule': {
				'm': '查询表达式不能为空'
			}
		}];

		//统一校验函数
		function validateAll() {
			var validate = new cap.Validate();
			var validateRule = {
				entityAttributeAlias: entityAttributeAliasRule,
				sqlScript: sqlScriptRule
			};
			return validate.validateAllElement([scope.queryAttribute], validateRule);
		}
</script>

</html>