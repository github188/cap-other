<%
  /**********************************************************************
	* 执行SQL
	* 2016-10-11 许畅 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='sqlExecute'>
<head>
<meta charset="UTF-8"/>
<title>查询数据</title>
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
<body style="background-color:#f5f5f5;" ng-controller="sqlExecuteController" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<div style="clear: both;">
		   <div style="float:left;">
			   <span>
		        	<blockquote class="cap-form-group">
						<span>查询数据</span>
					</blockquote>
			    </span>
		   </div>
		    
		    <div class="toolbar" style="float:right;margin-bottom:10px;">
			    <span cui_button id="cancel" ng-click="cancel()" label="关闭"></span>
	        </div>
		</div>
		
		<div>
		   <textarea id="error" style="float: left;margin-left: 10px;margin-bottom: 10px;" ng-if="error" ng-model="error"></textarea>
           <table uitype="Grid" id="dataGrid" primarykey="id" colhidden="false" datasource="initData" pagination="true"
				resizewidth="resizeWidth" resizeheight="resizeHeight" selectrows="no"
				colrender="columnRenderer">
				<thead>
					<tr>
						<th ng-repeat="column in columns" style="{{column==1 ? 'width:20px':''}}" renderStyle="text-align: left;" bindName="{{column}}">{{column==1 ? '' : column}}</th>
					</tr>
				</thead>
		   </table>
		</div>
		
    </div>
</div>	
<script type="text/javascript">
	 //获得传递参数
	 var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	 var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	 var from = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("from"))%>;
	 
	 var pageStorage = new cap.PageStorage(modelId);
	 var entity = pageStorage.get("entity");

	 //拿到angularJS的scope
	 var scope=null;
	 var sql = window.opener.scope.model.mybatisSQL;
	 var data=null;
	 angular.module('sqlExecute', [ "cui"]).controller('sqlExecuteController', function ($scope) {
		    $scope.sql= sql;
		    $scope.data= data;
		    
			$scope.ready=function(){
		    	scope=$scope;
		    	$scope.init();
		    };
			
			//页面初始化
			$scope.init =function(){
				$scope.queryData();
			};
			
			$scope.cancel = function(){
				window.close();
			};
			
			//查询数据
			$scope.queryData = function() {
				dwr.TOPEngine.setAsync(false);
				QueryPreviewFacade.sqlExecute(sql, {
					callback: function(rst) {
						$scope.error = null;
						$scope.data = rst.datas;
				        $scope.columns = $.merge([1], rst.columns);
					},
					errorHandler: function(message, exception) {
						$scope.error = message;
					}
				});
				dwr.TOPEngine.setAsync(true);
			};
	 });
	 
	 $(function($){
		 $("#error").css("width",(document.documentElement.clientWidth || document.body.clientWidth) - 100);
		 comtop.UI.scan();
	 });
	 
	 //grid数据源
	 function initData(tableObj,query){
		if(scope.data){
			tableObj.setDatasource(scope.data, scope.data.length);
		}else{
			tableObj.destroy();
		}
	 }
	 
	 //grid 宽度
	 function resizeWidth(){
	 	return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
	 }

	 //grid高度
	 function resizeHeight(){
	 	return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
	 }	
		
</script>

</body>
</html>