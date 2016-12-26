<%
  /**********************************************************************
	* SQL预览参数调试选择界面
	* 2016-10-09 许畅 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='sqlPreviewParams'>
<head>
<meta charset="UTF-8"/>
<title>查询参数</title>
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
<body style="background-color:#f5f5f5;" ng-controller="sqlPreviewParamsController" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<div style="clear: both;">
		   <div style="float:left;">
			   <span style="float:left;">
		        	<blockquote class="cap-form-group">
						<span>参数填写</span>
					</blockquote>
			    </span>
			    <span>
			                  实体 : <span cui_clickinput id="entity" width="250px" name="entity" ng-model="modelId" on_iconclick="selectEntity" ></span>
			    </span>
		   </div>
		    
		    <div class="toolbar" style="float:right;margin-bottom:10px;">
		        <span cui_button id="addLine" ng-click="addLine()" label="新增行" ng-if="!modelId || modelId=='null'"></span>
			    <span cui_button id="deleteLine" ng-click="deleteLine()" label="删除行" ng-if="!modelId || modelId=='null'"></span>
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
				   	属性名称
				   </th>
				   <th>
			                  中文名称        
				   </th>
				   <th>
			                  属性值        
				   </th>
			   </tr>
			</thead>
		    <tbody>
	           <tr ng-repeat="param in params" style="background-color: {{param.sortNo == selectedParam.sortNo ? '#99ccff' : '#ffffff'}}">
	                 <td>
	                     <input type="checkbox" name="{{ 'param'+($index +1) }}" ng-model="param.check" ng-change="checkBoxChange(param)">
	                 </td>
	                 <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="engNameClick(param)">
	                      <span ng-if="modelId && modelId!='null'">{{param.engName}}</span>
	                      <span cui_input id="{{'engName' + ($index+1)}}" name="engName" ng-model="param.engName" ng-if="!modelId || modelId=='null'"></span>
	                 </td>
	                 <td style="text-align: center;" class="notUnbind" ng-click="chNameClick(param)">
	                       <span ng-if="modelId && modelId!='null'">{{param.chName}}</span>
	                       <span cui_input id="{{'chName' + ($index+1)}}" name="chName" ng-model="param.chName" ng-if="!modelId || modelId=='null'"></span>
	                 </td>
	                 <td style="text-align: center;" class="notUnbind" ng-click="valueClick(param)">
	                    <span cui_input id="{{'value' + ($index+1)}}" name="value" ng-model="param.value"  
	                    validate="{{(param.attributeType.type =='int' || param.attributeType.type =='java.math.BigDecimal' || param.attributeType.type =='Integer' || param.attributeType.type =='double' || param.attributeType.type =='long' || param.attributeType.type =='float') ? 'validateNunmber' :''}}"
	                    ng-if="param.attributeType.type!='java.sql.Date' && param.attributeType.type!='java.sql.Timestamp' && param.attributeType.type!='entity' && param.attributeType.type!='java.util.List' ">
	                    </span>
	                    <span cui_Calender id="{{'value' + ($index+1)}}" name="value" format="yyyy-MM-dd hh:mm:ss" ng-model="param.value" ng-if="param.attributeType.type=='java.sql.Date' || param.attributeType.type=='java.sql.Timestamp'"></span>
	                    <span cui_clickinput id="{{'value' + ($index+1)}}" name="value" ng-model="param.text" ng-if="param.attributeType.type=='entity' || param.attributeType.type=='java.util.List' " ng-click="entityParamValueClick(param)"></span>
	                 </td>
	           </tr>
	           <tr ng-if="!params || params.length == 0">
	                 <td colspan="4" class="grid-empty"> 本列表暂无记录</td>
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
	 var params=[];
	 var selectedParam={};
	 angular.module('sqlPreviewParams', [ "cui"]).controller('sqlPreviewParamsController', function ($scope) {
			$scope.params= params;
			$scope.selectedParam = selectedParam;
			$scope.modelId=modelId;

			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
			
			//页面初始化
			$scope.init =function(){
				$scope.initParentData();
				if (!entity) {
					return;
				}
					
				$scope.params = entity.attributes;
				$scope.selectedParam = (entity.attributes && entity.attributes.length>0) ?  entity.attributes[0] : {};
			};

			$scope.initParentData = function(){
				var pp = window.opener.scope.queryPreview.params;
				if(!pp){
					return;
				}
				var parentParamValue=cui.utils.parseJSON(pp);
				for (var i = 0; i < entity.attributes.length; i++) {
					entity.attributes[i].value= parentParamValue[entity.attributes[i].engName];
					if((entity.attributes[i].attributeType.type=="entity" || entity.attributes[i].attributeType.type=="java.util.List") &&  entity.attributes[i].value){
						entity.attributes[i].text ="JSON Object";
					}
				};
			};
			
			//确认
			$scope.confirm = function(){
				var validateResult = $scope.validateNumber();
				if (validateResult != "success") {
					cui.alert(validateResult);
					return;
				}
				
				var result={};
				for (var i = 0; i < $scope.params.length; i++) {
					if($scope.params[i].value){
						result[$scope.params[i].engName] = $scope.params[i].value;
					}
				};
				window.opener.scope.paramsCallback(cui.utils.stringifyJSON(result));
				console.log(cui.utils.stringifyJSON(result));
				window.close();
			};
			
			//取消
			$scope.cancel = function(){
				window.close();
			};
			
			//engName click event
			$scope.engNameClick = function(param){
				$scope.setSelectedParam(param);
			};
			
			//chName click event
			$scope.chNameClick = function(param){
				$scope.setSelectedParam(param);
			};
			
			//value click event
			$scope.valueClick = function(param){
				$scope.setSelectedParam(param);
			};
			
			//设置选中参数
			$scope.setSelectedParam = function(param){
				$scope.selectedParam = param;
			};
			
			//checkBox值改变
			$scope.checkBoxChange = function(param){
				$scope.setSelectedParam(param);
			};
			
			//实体或者list类型值click事件
			$scope.entityParamValueClick = function(param){
				$scope.entityParamValue=param;
				var entityId = "";
				if(param.attributeType.type=="entity"){
					entityId = param.attributeType.value;
				}else if(param.attributeType.type=="java.util.List"){
					entityId = param.attributeType.generic[0].value;
				}else{
					entityId = param.attributeType.value;
				}
				var top = (window.screen.availHeight - 500) / 2;
				var left = (window.screen.availWidth - 700) / 2;
				window.open("EntityTypeParamSelect.jsp?modelId=" + entityId +"&type="+param.attributeType.type, "entityTypeParamSelect", 'height=500,width=700,top=' + top + ',left=' + left + ',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
			};
			
			//实体或者list类型值回调
			$scope.entityParamValueCallback = function(result){
				$scope.entityParamValue.value = cui.utils.parseJSON(result);
				$scope.entityParamValue.text = "JSON Object";
				$scope.$apply();
			};
			
			//校验
			$scope.validateNumber =function(){
				if(!entity)
				   return "success";
				
				for (var i = 0; i < $scope.params.length; i++) {
					var param = $scope.params[i];
					if (param.attributeType.type == 'int' || param.attributeType.type == 'java.math.BigDecimal' || param.attributeType.type == 'Integer' || param.attributeType.type == 'double' || param.attributeType.type == 'long' || param.attributeType.type == 'float') {
						 if(!checkNumber(param.value)){
						 	return "属性名称为["+param.engName+"]的行值必须为数字!";
						 }
					}
				};
				return "success";
			};
			
			//新增行
			$scope.addLine = function(){
				var row ={engName:null,chName:null,value:null,sortNo:(new Date().getTime()+$scope.params.length+1)};
				$scope.params.push(row);
			};
			
			//删除行
			$scope.deleteLine = function(){
				var selectedParam = $scope.selectedParam;
				if(!selectedParam || !selectedParam.sortNo){
					cui.alert("请先选择选中的数据.");
					return;
				}
				var params = $scope.params;
				var ps=[];
				for (var i = 0; i < params.length; i++) {
					if(params[i].sortNo != selectedParam.sortNo){
						ps.push(params[i]);
					}
				};
				$scope.params = ps;
			};
			
	 });
	 
	 var validateNunmber = [{'type':'custom','rule':{'against':checkNumber, 'm':'必须为数字'}}];
	 
	 //数字校验
	 function checkNumber(data){
		var regEx = "^[0-9]+.?[0-9]*$";
		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	 }
	 
	 //实体选择
	 var dialog;
     function selectEntity(){
    	var url = "SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=true&showClean=false&sourceEntityId="+modelId;
		var title="切换实体";
		var height = 600; //600
		var width =  400; // 680;
		var top = '2%';
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height,
			top : top
		})
		dialog.show(url);
     }
     
     //实体选择回调
     function selEntityBack(selectNodeData,propertyName){
    	window.opener.modelId = selectNodeData.modelId;
    	window.location.href="SqlPreviewParams.jsp?modelId=" + selectNodeData.modelId + "&packageId="+ packageId +"&from="+from;
    	dialog.hide();
     }
	    
	 //close回调
	 function closeEntityWindow(){
    	if(dialog){
    		dialog.hide();
		}
	 }
		
</script>

</body>
</html>