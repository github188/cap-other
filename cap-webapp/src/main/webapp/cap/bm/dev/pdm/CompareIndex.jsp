<%
  /**********************************************************************
	* PDM导入表索引对比
	*
	* 2016-11-01 许畅 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='compareIndex'>
<head>
<meta charset="UTF-8"/>
<title>索引差异对比</title>
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
	<top:script src="/cap/dwr/interface/TableOperateAction.js"></top:script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="compareIndexController" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<div style="clear: both;">
		   <div style="float:left;">
			   <span>
		        	<blockquote class="cap-form-group">
						<span>索引差异</span>
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
				      <input type="checkbox" ng-model="checkAll" ng-change="checkAllChange(checkAll,datas)">
				   </th>
				   <th style="width:100px;">
				         状态
				   </th>
				   <th>
				   	表名
				   </th>
				   <th>
			                   索引                       
				   </th>
				   <th>
			                   列名        
				   </th>
			   </tr>
			</thead>
		    <tbody>
	           <tr ng-repeat="data in datas" style="background-color: {{data.id == selectedData.id ? '#99ccff' : '#ffffff'}}">
	                 <td>
	                     <input type="checkbox" name="{{ 'data'+($index +1) }}" ng-model="data.check" ng-change="checkBoxChange(data,datas)">
	                 </td>
	                 <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="rowClick(data)">
	                      <span>{{data.state}}</span>
	                 </td>
	                  <td style="text-align: left;" class="notUnbind" ng-click="rowClick(data)">
	                      <span>{{data.table}}</span>
	                 </td>
	                 <td style="text-align: left;" class="notUnbind" ng-click="rowClick(data)">
	                      <span>{{data.index}}</span>
	                 </td>
	                 <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="rowClick(data)">
	                      <span>{{data.column}}</span>
	                 </td>
	           </tr>
	           <tr ng-if="!datas || datas.length == 0">
	                 <td colspan="5" class="grid-empty"> 本列表无差异信息</td>
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
	 var datastorage = window.parent.datastorage;
	 angular.module('compareIndex', [ "cui"]).controller('compareIndexController', function ($scope) {
			$scope.selectedData = selectedData;
			$scope.selectedDatas = selectedDatas;

			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
			
			//页面初始化
			$scope.init =function(){
				if(datastorage["indexs"].length>0){
				   $scope.datas=datastorage["indexs"];
				   $scope.selectedData = datastorage["indexs"][0];
				}
			};

			//同步所选
			$scope.sysncSelected = function(){
				if(!$scope.selectedDatas || $scope.selectedDatas.length <= 0) {
					cui.alert("请选择需要同步的数据.")
					return;
				}

				var tableCompareResults = [];
				$scope.selectedDatas.forEach(function(item, index, arr) {
					tableCompareResults.push(item["indexCompareResult"]);
				});

				$scope.sysncIndex(tableCompareResults);
			};

			//同步所有
			$scope.syncAll = function() {
                if (!$scope.datas || $scope.datas.length <= 0) {
					cui.alert("无任何差异数据,不能同步.");
					return;
				}

				var tableCompareResults = [];
				$scope.datas.forEach(function(item, index, arr) {
					tableCompareResults.push(item["indexCompareResult"]);
				});

				$scope.sysncIndex(tableCompareResults);
			}

			//同步索引
			$scope.sysncIndex = function(tableCompareResults) {
				$scope.disablebutton();

				dwr.TOPEngine.setAsync(false);
				TableOperateAction.sysncIndex(tableCompareResults, packageId, {
					callback: function(data) {
						if (data == "success") {
							cui.message("操作成功!", 'success', {
								'callback': function() {
									//刷新主页面数据源
									window.parent.initDatas();
									window.location.reload();
									$scope.enablebutton();
								}
							});
						}
					},
					errorHandler: function(message, exception) {
						cui.message("执行失败:" + message, "error");
						$scope.enablebutton();
					}
				});
				dwr.TOPEngine.setAsync(true);
			}

			//启用按钮
			$scope.enablebutton = function() {
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
			
			//取消
			$scope.cancel = function(){
				if(from && from=="table"){
					window.parent.parent.sysncDataBaseDialog.hide();
					return;
				}

				if(window.top.emDialog){
					window.top.emDialog.hide();
				}
			};
			
			//行点击事件
			$scope.rowClick = function(data){
				$scope.setSelectedData(data);
			};
			
			$scope.setSelectedData = function(data){
				$scope.selectedData = data;
			};
			
			//checkBox值改变
			$scope.checkBoxChange = function(data,datas){
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
				//存储索引信息
				$scope.storageIndexs();
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
				//存储索引信息
				$scope.storageIndexs();
			};

            //存储索引信息
			$scope.storageIndexs = function(){
				datastorage["selectedIndexs"] = $scope.selectedDatas;
			}
			
	 });
	 
		
</script>

</body>
</html>