<%
  /**********************************************************************
	* 实体类型参数选择JSP
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
			   <span>
		        	<blockquote class="cap-form-group">
						<span>参数选择</span>
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
	           <tr ng-repeat="param in params" style="background-color: {{param.engName == selectedParam.engName ? '#99ccff' : '#ffffff'}}">
	                 <td>
	                     <input type="checkbox" name="{{ 'param'+($index +1) }}" ng-model="param.check" ng-change="checkBoxChange(param)">
	                 </td>
	                 <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="engNameClick(param)">
	                       {{param.engName}}
	                 </td>
	                 <td style="text-align: center;" class="notUnbind" ng-click="chNameClick(param)">
	                       {{param.chName}}
	                 </td>
	                 <td style="text-align: center;" class="notUnbind" ng-click="valueClick(param)">
	                    <span cui_input id="{{'value' + ($index+1)}}" name="value" ng-model="param.value"  
	                    validate="{{(param.attributeType.type =='int' || param.attributeType.type =='java.math.BigDecimal' || param.attributeType.type =='Integer' || param.attributeType.type =='double' || param.attributeType.type =='long' || param.attributeType.type =='float') ? 'validateNunmber' :''}}"
	                    ng-if="param.attributeType.type!='java.sql.Date' && param.attributeType.type!='java.sql.Timestamp' && param.attributeType.type!='entity' && param.attributeType.type!='java.util.List' ">
	                    </span>
	                    <span cui_Calender id="{{'value' + ($index+1)}}" format="yyyy-MM-dd hh:mm:ss" name="value" ng-model="param.value" ng-if="param.attributeType.type=='java.sql.Date' || param.attributeType.type=='java.sql.Timestamp'"></span>
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
	 var type = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("type"))%>;
	 
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

			$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
			
			//页面初始化
			$scope.init =function(){
				var attributes = entity.attributes;
				var attrs =[];
				var parentParamValue = window.opener.scope.entityParamValue.value;
				for (var i = 0; i < attributes.length; i++) {
					//过滤掉entity类型和list类型的属性
					if(attributes[i].attributeType.type!='entity' && attributes[i].attributeType.type!='java.util.List'){
						if(parentParamValue && type=="entity"){
							attributes[i].value=parentParamValue[attributes[i].engName];
						}else if(parentParamValue && type=="java.util.List"){
							attributes[i].value=parentParamValue[0][attributes[i].engName];
						}
						attrs.push(attributes[i]);
					}
				};
				
				$scope.params = attrs;
				$scope.selectedParam = (attrs && attrs.length>0) ?  attrs[0] : {};
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
				if(type=="entity"){
					window.opener.scope.entityParamValueCallback(cui.utils.stringifyJSON(result));
				}else{
					var lst=[];
					lst.push(result);
					window.opener.scope.entityParamValueCallback(cui.utils.stringifyJSON(lst));
				}
				
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
			
			$scope.validateNumber =function(){
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
		
</script>

</body>
</html>