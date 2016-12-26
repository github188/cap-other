	
<%
  /**********************************************************************
	* soa注册服务配置
	* 2016-5-19 许畅
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html ng-app="SoaServiceConfig">
<head>
<title>SOA注册服务配置</title>
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
<body ng-controller="SoaServiceConfigCtrl" data-ng-init="ready()" >
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<td class="cap-td" style="text-align: center; padding: 5px;width: 30%" >
					<span class="cap-label-title" size="12pt">SOA注册服务配置：</span>
				</td>
				<td class="cap-td" style="text-align: center; padding: 5px;width: 70%" >
				    <span cui_button  id="saveBtn"  ng-click="saveModel()" label="保存"></span> 
				</td>
			</tr>
			<tr align="center">
				<td class="cap-td" style="text-align: right;width:100px">
	        		<font color="red">*</font>是否执行soa远端服务：
		        </td>
				<td class="cap-td" style="text-align: left;">
		        	<input type="checkbox" ng-model="model.callSoaService" ng-checked="model.callSoaService" />
		        </td>
			</tr>
		</table>
	</div>
<script type="text/javascript">
	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;		
	
	var scope = null;
	var model={};
	angular.module('SoaServiceConfig', ["cui"]).controller('SoaServiceConfigCtrl', function ($scope) {
		$scope.model=model;
    	//预加载方法
    	$scope.ready = function() {
    		comtop.UI.scan();
	        $scope.initData();
			scope = $scope;
		}
    	
    	//页面初始化数据
    	$scope.initData = function() {
    		dwr.TOPEngine.setAsync(false);
    		PreferencesFacade.isCallSoaRemoteService(function(data) {
				if(data){
					$scope.model.callSoaService = data;
				}
			});
			dwr.TOPEngine.setAsync(true);
    	}
    	
    	//保存到配置文件
    	$scope.saveModel=function(){
			dwr.TOPEngine.setAsync(false);
			PreferencesFacade.saveIsCallSoaRemoteService($scope.model.callSoaService,function(data) {
				if(data){
					cui.message('页面保存成功！', 'success');
				}else{
					cui.error("页面保存失败！"); 
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
	});
	
</script>
</body>
</html>