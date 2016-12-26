<%
  /**********************************************************************
	* Table表同步实体jsp
	*
	* 2016-10-25 许畅 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='tableSysncEntity'>
<head>
<meta charset="UTF-8"/>
<title>列差异对比</title>
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
	<top:script src="/cap/dwr/interface/TableFacade.js"></top:script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="tableSysncEntityController" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<div style="clear: both;">
		   <div style="float:left;">
			   <span>
		        	<blockquote class="cap-form-group">
						<span>差异分析</span>
					</blockquote>
			    </span>
		   </div>
		    
		    <div class="toolbar" style="float:right;margin-bottom:10px;">
		        <span cui_button id="syncAll" ng-click="syncAll()" button_type="orange-button" label="同步所有"></span>
	            <span cui_button id="sysncSelected" ng-click="sysncSelected()" button_type="green-button" label="同步所选"></span>
			    <span cui_button id="cancel" ng-click="cancel()" label="取消"></span>
	        </div>
		</div>
		
		<table class="custom-grid" style="width: 100%">
			<thead>
			   <tr>
				   <th style="width:30px;">
				      <input type="checkbox" ng-change="checkAllChange(checkAll,data.analyzeResults)" ng-model="checkAll">
				   </th>
				   <th style="width:80px;">
				        状态
				   </th>
				   <th style="width:150px;">
				        字段名称
				   </th>
				   <th style="width:150px;">
			                  中文名     
				   </th>
				   <th>
			                 详细信息                   
				   </th>
			   </tr>
			</thead>
		    <tbody>
	           <tr ng-repeat="data in data.analyzeResults as lst" style="background-color: {{data.id == selectedData.id ? '#99ccff' : '#ffffff'}}">
	                 <td>
	                     <input type="checkbox" name="{{ 'data'+($index +1) }}" ng-model="data.check" ng-change="checkBoxChange(data,lst)">
	                 </td>
	                 <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="rowClick(data)">
	                      <span>{{data.state}}</span>
	                 </td>
	                 <td style="text-align: left;" class="notUnbind" ng-click="rowClick(data)">
	                      <span>{{data.engName}}</span>
	                 </td>
	                  <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="rowClick(data)">
	                      <span>{{data.chName}}</span>
	                 </td>
	                 <td style="text-align: left;" class="notUnbind" ng-click="rowClick(data)">
	                     <span ng-repeat="dt in data.details" >
	                     	{{dt}}<br>
	                     </span>
	                 </td>
	           </tr>
	           <tr ng-if="!data.analyzeResults || data.analyzeResults.length == 0">
	                 <td colspan="5" class="grid-empty"> 本列表暂无记录</td>
	           </tr>
		    </tbody>
	    </table>
		
    </div>
</div>	
<script type="text/javascript">
	 //获得传递参数
	 var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	 var from = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("from"))%>;
	
	 //拿到angularJS的scope
	 var scope=null;
	 var selectedData={};
	 var selectedDatas=[];
	 var data=window.parent.scope.dataStorage;
	 angular.module('tableSysncEntity', [ "cui"]).controller('tableSysncEntityController', function($scope) {
			$scope.selectedData = selectedData;
			$scope.selectedDatas = selectedDatas;
			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
			
			//页面初始化
			$scope.init =function(){
				$scope.analyzeDifferent();
				$scope.readerDetail();
				if ($scope.data.analyzeResults.length > 0) {
					$scope.selectedData = $scope.data.analyzeResults[0];
				}
			};

			/**
			 * 分析差异
			 * 
			 * @return {[type]} [description]
			 */
			$scope.analyzeDifferent = function() {
				$scope.data = data;
			}

			/**
			 * 渲染详细信息,多个不同信息则换行
			 * 
			 * @return {[type]} [description]
			 */
			$scope.readerDetail = function() {
				$scope.data.analyzeResults.forEach(function(item, index, arr) {
					if (item.detail) {
						item.details = item.detail.split(",");
					}
				});
			}
			//同步所选
			$scope.sysncSelected = function(){
				if(!$scope.selectedDatas || $scope.selectedDatas.length <= 0) {
					cui.alert("请选择需要同步的数据.")
					return;
				}
				$scope.synscEntity($scope.selectedDatas);
			
			};

			//同步所有
			$scope.syncAll = function() {
				if (!$scope.data.analyzeResults || $scope.data.analyzeResults.length <= 0) {
					cui.alert("无任何差异数据,不能同步.");
					return;
				}
				$scope.synscEntity($scope.data.analyzeResults);
			}
            
            //取消
			$scope.cancel = function() {
				if (window.parent.sysncToEntityDialog) {
					window.parent.sysncToEntityDialog.hide();
				}
			}
            
			/**
			 * 同步实体
			 * 
			 * @return {[type]} [description]
			 */
			$scope.synscEntity = function(selectedDatas) {
				var param = angular.copy($scope.data);
				param.analyzeResults = selectedDatas;

				dwr.TOPEngine.setAsync(false);
				TableFacade.synscEntity(param, {
					callback: function(data) {
						cui.message("同步成功", "success");
						$scope.refreshData();
					},
					errorHandler: function(message, exception) {
						cui.message("执行失败:" + message, "error");
					}
				});
				dwr.TOPEngine.setAsync(true);
			};

            //刷新数据
			$scope.refreshData = function() {
				window.parent.scope.analyzeDifferent();
				$scope.data = window.parent.scope.dataStorage
			}
			
            //启用按钮
			$scope.enablebutton = function(){
				cui("#syncAll").disable(false);
				cui("#sysncSelected").disable(false);
				cui("#cancel").disable(false);
			};

			//禁用同步全部等按钮
			$scope.disablebutton = function() {
				cui("#sysncSelected").disable(true);
				cui("#cancel").disable(true);
				cui("#syncAll").disable(true);
			};
			
			//行点击事件
			$scope.rowClick = function(data){
				$scope.setSelectedData(data);
			};
			
			$scope.setSelectedData = function(data){
				$scope.selectedData = data;
			};
			
			//checkBox值改变
			$scope.checkBoxChange = function(data, datas) {
				var selectedvalues = [];
				datas.forEach(function(item, index, arr) {
					if (item["check"]) {
						selectedvalues.push(item);
					}
				});
				if (selectedvalues.length == datas.length) {
					$scope.checkAll = true;
				}else{
					$scope.checkAll = false;
				}
				$scope.selectedDatas = selectedvalues;
				$scope.setSelectedData(data);
			};

			//全选
			$scope.checkAllChange = function(ischeck, datas) {
				if (!datas) {
					return;
				}
				datas.forEach(function(item, index, array) {
					item.check = ischeck;
				});
				if (ischeck) {
					$scope.selectedDatas = datas;
				} else {
					$scope.selectedDatas = [];
				}
			};

	 });
	 
		
</script>

</body>
</html>