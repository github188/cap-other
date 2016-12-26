	
<%
  /**********************************************************************
	* CAP父类设置
	* 2015-12-18 肖威
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html ng-app="ParentEntityConfig">
<head>
<title>代码生成页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
	
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PreferencesFacade.js'></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body ng-controller="parentEntityEditCtrl" data-ng-init="ready()" >
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<td class="cap-td" style="text-align: center; padding: 5px;width: 30%" >
					<span class="cap-label-title" size="12pt">默认父实体配置：</span>
				</td>
				<td class="cap-td" style="text-align: center; padding: 5px;width: 70%" >
				</td>
			</tr>
			<tr align="center">
				<td class="cap-td" style="text-align: right;width:100px">
	        		<font color="red">*</font>父实体：
		        </td>
				<td class="cap-td" style="text-align: left;">
		        	<span cui_clickinput id="parentEntityId" ng-model="parentEntity.configValue" ng-click="selectParentEntity('parentEntityId')" width="60%"></span>
		        	<span cui_button  id="saveParentEntity"  ng-click="saveParentEntity('parentEntityId')" label="保存"></span> 
		        </td>
			</tr>
			<tr align="center">
				<td class="cap-td" style="text-align: right;width:100px">
	        		<font color="red">*</font>父流程实体：
		        </td>
				<td class="cap-td" style="text-align: left;">
		        	<span cui_clickinput id="workflowParentEntityId" ng-model="workflowParentEntity.configValue" ng-click="selectParentEntity('workflowParentEntityId')" width="60%"></span>
		        	<span cui_button  id="saveWorkflowParentEntity"  ng-click="saveParentEntity('workflowParentEntityId')" label="保存"></span> 
		        </td>
			</tr>
			<tr align="center">
				<td class="cap-td" style="text-align: right;width:100px">
	        		<font color="red">*</font>父流程实体匹配规则：
		        </td>
				<td class="cap-td" style="text-align: left;">
		        	<span cui_input id="workflowParentEntityMatchRule" ng-model="workflowParentEntityMatchRule.configValue" width="60%"></span>
		        	<span cui_button  id="saveMachRule"  ng-click="saveParentEntity('saveMachRule')" label="保存"></span>
		        	<font color=red>表字段名,用英文逗号隔开</font>
		        </td>
			</tr>
		</table>
	</div>
<script type="text/javascript">
	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;		
	
	var scope = null;
	var entityDialog;
	var parentEntity={};
	var workflowParentEntity={};
	var workflowParentEntityMatchRule = {};
	var configList;
	angular.module('ParentEntityConfig', ["cui"]).controller('parentEntityEditCtrl', function ($scope, $compile) {
		$scope.root={};//作用域根节点
		$scope.parentEntity=parentEntity;
		$scope.workflowParentEntity=workflowParentEntity;
		$scope.workflowParentEntityMatchRule=workflowParentEntityMatchRule;
		$scope.entityDialog=entityDialog;
    	
    	//预加载方法
    	$scope.ready = function() {
	        	$scope.initData();
				scope = $scope;
		}
    	
    	//页面初始化数据
    	$scope.initData = function() {
    		dwr.TOPEngine.setAsync(false);
    		PreferencesFacade.getConfigList(function(data) {
				if(data!=null){
					configList = new cap.CollectionUtil(data);
					$scope.parentEntity= configList.query("this.configKey=='defaultParentEntityId'")[0];
					$scope.workflowParentEntity=configList.query("this.configKey=='defaultWorkflowParentEntityId'")[0];
					$scope.workflowParentEntityMatchRule=configList.query("this.configKey=='defaultWorkflowMatchRule'")[0];
				}
			});
			dwr.TOPEngine.setAsync(true);
    	}
    	
    	$scope.selectParentEntity=function(propertyName){
			var url = "${pageScope.cuiWebRoot}/cap/bm/dev/entity/SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=false"+"&propertyName="+propertyName;
			var title="选择目标实体";
			var height = 450; //600
			var width =  380; // 680;
			
			entityDialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			})
			entityDialog.show(url);
		}
    	
    	$scope.saveParentEntity=function(propertyName){
			dwr.TOPEngine.setAsync(false);
			var objParentEntity ;
			if(propertyName==="parentEntityId"){
				objParentEntity = $scope.parentEntity;
			}else if(propertyName==="workflowParentEntityId"){
				objParentEntity = $scope.workflowParentEntity;
			}else if(propertyName==="saveMachRule"){
				objParentEntity = $scope.workflowParentEntityMatchRule;
			}
			PreferencesFacade.saveConfig(objParentEntity,function(data) { 
				rs = data;
				if(rs){
					cui.message('保存成功！', 'success');
				}else{
					cui.error("保存失败！"); 
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
	});
	
    	//实体选择回调
		function selEntityBack(selectNodeData,propertyName) {
			if(propertyName==="parentEntityId"){
				scope.parentEntity.configValue=selectNodeData.modelId;
			}else if(propertyName==="workflowParentEntityId"){
				scope.workflowParentEntity.configValue=selectNodeData.modelId;
			}
			scope.$digest();
			if(entityDialog){
				entityDialog.hide();
			}
		}
    	
		//实体选择界面清空按钮
		function setDefault(propertyName){
			if(propertyName==="parentEntityId"){
				scope.parentEntity.configValue = "";
			}else if(propertyName==="workflowParentEntityId"){
				scope.workflowParentEntity.configValue="";
			}
			scope.$digest();
			if(entityDialog){
				entityDialog.hide();
			}
		}
		//实体选择界面取消按钮
		function closeEntityWindow(){
			if(entityDialog){
				entityDialog.hide();
			}
		}
		
</script>
</body>
</html>