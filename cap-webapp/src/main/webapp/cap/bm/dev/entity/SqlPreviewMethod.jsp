<%
  /**********************************************************************
	* SQL预览方法选择界面
	* 2016-10-10 许畅 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='sqlPreviewMethod'>
<head>
<meta charset="UTF-8"/>
<title>查询方法</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/validate.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/QueryPreviewFacade.js"></top:script>
	
</head>
<body style="background-color:#f5f5f5;" ng-controller="sqlPreviewMethodController" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<div style="clear: both;">
		   <div style="float:left;">
			   <span>
		        	<blockquote class="cap-form-group">
						<span>查询方法</span>
					</blockquote>
			    </span>
		   </div>
		    
		    <div class="toolbar" style="float:right;margin-bottom:10px;">
	            <span cui_button id="confirm" ng-click="confirm()" label="确定"></span>
			    <span cui_button id="cancel" ng-click="cancel()" label="取消"></span>
	        </div>
		</div>
		
		<table class="custom-grid" style="width: 100%">
			<thead>
			   <tr>
				   <th style="width:30px;">
				   </th>
				   <th>
				   	方法名称
				   </th>
				   <th>
			                  中文名称        
				   </th>
			   </tr>
			</thead>
		    <tbody>
	           <tr ng-repeat="method in methods" style="background-color: {{method.methodId == selectedMethod.methodId ? '#99ccff' : '#ffffff'}}">
	                 <td>
	                     <input type="checkbox" name="{{ 'method'+($index +1) }}" ng-model="method.check" ng-change="checkBoxChange(method)">
	                 </td>
	                 <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="engNameClick(method)">
	                      <span>{{method.engName}}</span>
	                 </td>
	                 <td style="text-align: center;" class="notUnbind" ng-click="chNameClick(method)">
	                      <span>{{method.chName}}</span>
	                 </td>
	           </tr>
	           <tr ng-if="!methods || methods.length == 0">
	                 <td colspan="3" class="grid-empty"> 本列表暂无记录</td>
	           </tr>
		    </tbody>
	    </table>
		
    </div>
</div>	
<script type="text/javascript">
	 //获得传递参数
	 var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	 var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	 var from = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("from"))%>;
	 
	 var pageStorage = new cap.PageStorage(modelId);
	 var entity = pageStorage.get("entity");

	 if(!entity){
	 	dwr.TOPEngine.setAsync(false);
	 	EntityFacade.loadEntity(modelId, packageId, function(rst) {
	 		entity = rst;
	 	});
	 	dwr.TOPEngine.setAsync(true);
	 }
	
	 //拿到angularJS的scope
	 var scope=null;
	 var methods=[];
	 var selectedMethod={};
	 angular.module('sqlPreviewMethod', [ "cui"]).controller('sqlPreviewMethodController', function ($scope) {
			$scope.methods= methods;
			$scope.selectedMethod = selectedMethod;

			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
			
			//页面初始化
			$scope.init =function(){
				$scope.loadAllMethods();
			};

			//确认
			$scope.confirm = function(){
				if(!$scope.selectedMethod || !$scope.selectedMethod.engName){
					cui.alert("没有选择任何行.")
					return;
				}
				cui.handleMask.show();
				
				if($scope.selectedMethod.engName.indexOf("ByTaskId")>-1){//父类方法
					var statementId = $scope.selectedMethod.engName.replace('VO',entity.engName+"VO");
				}else if($scope.selectedMethod.methodType=="queryModeling" || $scope.selectedMethod.methodType=="userDefinedSQL"){//查询建模或者自定义SQL方法
					var firstCharLowerCase = $scope.firstCharLowerCase(entity.engName);//首字符小写
					var statementId = firstCharLowerCase+"_"+$scope.selectedMethod.engName;
				}else{//父类方法
					var statementId = $scope.selectedMethod.engName.replace('VO',entity.engName);
				}
				window.opener.statementIdCallback(statementId);
				window.close();
			};
			
			//首字符小写
			$scope.firstCharLowerCase = function(str){
				if(!str || str.length==0){
					return str;
				}
				return str.substring(0,1).toLowerCase()+str.substring(1);//首字符小写
			}
			
			//取消
			$scope.cancel = function(){
				window.close();
			};
			
			//engName click event
			$scope.engNameClick = function(method){
				$scope.setSelectedMethod(method);
			};
			
			//chName click event
			$scope.chNameClick = function(method){
				$scope.setSelectedMethod(method);
			};
			
			$scope.setSelectedMethod = function(method){
				$scope.selectedMethod = method;
			};
			
			//checkBox值改变
			$scope.checkBoxChange = function(method){
				$scope.setSelectedMethod(method);
			};
			
			/**
			 * 加载当前实体的父类以及子类方法
			 */
			$scope.loadAllMethods = function() {
				dwr.TOPEngine.setAsync(false);
				EntityFacade.getAllParentEntity(entity.parentEntityId, function(result) {
					//所有父实体的方法的集合
					if (result) {
						result.forEach(function(item) {
							if (item.methods) {
								item.methods.forEach(function(_item) {
									//过滤掉父类实体count方法
									if ((_item.assoMethodName == null || _item.assoMethodName == "") && _item.queryExtend!=null && _item.queryExtend!='') {
										$scope.methods.push(_item);
									}
								});
							}
						});
					}
				});
				dwr.TOPEngine.setAsync(true);
				
				//收集本地的查询建模和SQL自定义方法
				entity.methods.forEach(function(method){
					if((method.methodType=="queryModeling" || method.methodType=="userDefinedSQL") 
							&& (method.assoMethodName == null || method.assoMethodName == "")){
						$scope.methods.push(method);
					}
				});
			};
			
	 });
	 
		
</script>

</body>
</html>