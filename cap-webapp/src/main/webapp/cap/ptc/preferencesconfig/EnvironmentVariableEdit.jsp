<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html  ng-app='EnvironmentVariableEdit'>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>首选项配置</title>
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
<script type='text/javascript' src="${pageScope.cuiWebRoot}/cap/dwr/interface/EnvironmentVariablePreferenceFacade.js"></script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/cap/dwr/interface/IncludeFilePreferenceFacade.js"></script>
</head>
<body ng-controller="environmentVariableEditCtrl" data-ng-init="ready()" >
	<div class="main">
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span class="cap-label-title" size="12pt">页面引入文件编辑</span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span cui_button  id="saveAttribute()"  ng-click="saveAttribute()" label="保存"></span> 
					 <span cui_button  id="goBack"  ng-click="returnToList()" label="返回"></span>
				</td> 
			</tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:150px">
					<font color="red">*</font>参数名称：
		        </td>
		        <td class="cap-td" style="text-align: left;" >
		        	<span cui_input id="attributeName" ng-model="environmentVariableVO.attributeName" width="70%" validate="validateAttributeName" ></span>
		        </td>
	        </tr>
	        <tr>
		    	<td  class="cap-td" style="text-align: right;width:150px">
					参数类别：
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span cui_radiogroup id="attributeClass" ng-model="environmentVariableVO.attributeClass" 
		        		name="attributeClass" width="70%"  readonly="false" validate="validateAttributeClass" >
		        		<input type="radio" value="java" name="attributeClass" />java
		        		<input type="radio" value="js" name="attributeClass" />js
		        	</span>
		        </td>
	        </tr>
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:150px">
					参数类型：
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span cui_radiogroup id="attributeType" ng-model="environmentVariableVO.attributeType"  ng-if="environmentVariableVO.attributeClass=='java'"
		        		name="attributeType" width="70%"  readonly="false" validate="validateAttributeType" >
		        		<input type="radio" name="attributeType" value="String"  >String</input>
		        		<input type="radio" name="attributeType" value="int"  >int</input>
		        		<!-- 
		        		<input type="radio" name="attributeType" value="long"  >long</input>
		        		<input type="radio" name="attributeType" value="float"  >float</input>
		        		 -->
		        		<input type="radio" name="attributeType" value="double"  >double</input>
		        		<input type="radio" name="attributeType" value="boolean"  >boolean</input>
		        		<!-- 
		        		<input type="radio" name="attributeType" value="date"  >date</input>
		        		 -->
		        	</span>
		        	
		        	<span cui_radiogroup id="attributeType" ng-model="environmentVariableVO.attributeType" ng-if="environmentVariableVO.attributeClass=='js'"
		        		name="attributeType" width="70%"  readonly="false" validate="validateAttributeType">
		        		<input type="radio" name="attributeType" value="js" >js表达式</input>
		        	</span>
		        </td>
	        </tr>
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:150px">
					默认值：
		        </td>
		        <td class="cap-td" style="text-align: left;" >
		        	<span cui_input id="attributeValue" ng-model="environmentVariableVO.attributeValue" width="70%"  validate="validateAttributeVale" ng-if="environmentVariableVO.attributeType!='boolean'"></span>
		        	<span cui_pulldown id="attributeValue" ng-model="environmentVariableVO.attributeValue" width="70%"  validate="validateAttributeVale"  ng-if="environmentVariableVO.attributeType=='boolean'"
		        	   datasource="initAttributeValue" value_field="id" label_field="text"></span>
		        </td>
	        </tr>
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:150px">
					<font color="red">*</font>关联引入文件名称：
		        </td>
		        <td class="cap-td" style="text-align: left;" >
		        	<span cui_pulldown id="fileName" ng-model="environmentVariableVO.fileName" width="70%"  validate="validateFileName" 
		        		datasource="initFileList" ng-change="fileChangeEvent()"  value_field="filePath" label_field="fileName" empty_text="请选择"></span>
		        </td>
	        </tr>
		    <tr>
		    	<td  class="cap-td" style="text-align: right;width:150px">
					描述：
		        </td>
		        <td class="cap-td" style="text-align: left;" >
		        	<span cui_input id="attributeDescription" ng-model="environmentVariableVO.attributeDescription" width="70%" ></span>
		        </td>
	        </tr>
        </table>
	</div>
	<script>
		var attributeName = "<%=request.getParameter("attributeName")%>";
		var attributeDescription = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("attributeDescription"))%>;
		var attributeType = "<%=request.getParameter("attributeType")%>";
		var attributeValue="<%=request.getParameter("attributeValue")%>";
		var fileName="<%=request.getParameter("fileName")%>";
		var oldAttributeName ="";
		
		function initFileList(obj){
	    	dwr.TOPEngine.setAsync(false);
			IncludeFilePreferenceFacade.queryIncludeFileList(function(data) {
				if(data!=null){
					obj.setDatasource(data);
				}
			});
			dwr.TOPEngine.setAsync(true);
    	}
	    	
    	function fileChangeEvent(){
    		
    	}
		
		function resizeWidth() {
			return (document.documentElement.clientWidth || document.body.clientWidth) - 4;
		}
	
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 40;
		}
		
		var validateAttributeName = [
		                        {type:'required',rule:{m:'参数名称：不能为空'}}
		                        ];
		var validateAttributeClass = [
		                        {type:'required',rule:{m:'参数类别：不能为空'}}
		                        ];
		var validateAttributeType = [
				                        {type:'required',rule:{m:'参数类型：不能为空'}}
				                        ];
		var validateAttributeVale = [
				                        {type:'custom',rule:{against:'validateEnviromentVariableValue', m:'输入数据与参数类型不匹配！'}}
				                        ];
		var validateFileName = [
		                        {type:'required',rule:{m:'关联引入文件名称：不能为空'}},
		                        {type:'custom',rule:{against:'validateIncludeFileName', m:'关联引入文件名称：未选择'}}
		                        ];
		function validateEnviromentVariableValue(data){
			var attributeType = environmentVariableVO.attributeType;
			var attributeValue = environmentVariableVO.attributeValue;
			if(attributeValue==""){
				return true;
			}
			if("String"==attributeType){
				var patt1=new RegExp("[\s|\S]*");
				return patt1.exec(attributeValue);
			}
			if("int"==attributeType){
				var patt1=new RegExp("-?[1-9]\d{0,9}");
				return patt1.exec(attributeValue);
			}
			//if("long"==attributeType){
			//	var patt1=new RegExp("-?[1-9]\d{0,18}");
			//	console.log(attributeType+"---"+attributeValue);
			//	return patt1.exec(attributeValue);
			//}
			//if("float"==attributeType){
			//	var patt1=new RegExp("^[-\+]?\d+(\.\d+)?$");
			//	console.log(attributeType+"---"+attributeValue);
			//	return patt1.exec(attributeValue);
			//}
			if("double"==attributeType){
				var patt1=new RegExp("^[-\+]?\d+(\.\d+)?$");
				return patt1.exec(attributeValue);
			}
			if("boolean"==attributeType){
				var patt1=new RegExp("^true$|^false$","i");
				return patt1.exec(attributeValue);
			}
			//if("date"==attributeType){
			//	var patt1=new RegExp("^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$");
			//	console.log(attributeType+"---"+attributeValue);
			//	return patt1.exec(attributeValue);
			//}
			return false;
		}
		
		var attributeBooleanValue = [{id:'true',text:'true'},{id:'false',text:'false'}];
		
		function initAttributeValue(obj){
			obj.setDatasource(attributeBooleanValue);
		}
		
		function  validateIncludeFileName(data){
			var fileName = data;
			if(fileName != null || fileName != ""){
				return true;
			}
			return false;
		}
		//angularJS的scope
	    var scope=null;
	    var environmentVariableVO = {}; 
	    angular.module('EnvironmentVariableEdit', ["cui"]).controller('environmentVariableEditCtrl', function ($scope, $compile) {
	    	$scope.root={};//作用域根节点
	    	$scope.environmentVariableVO = environmentVariableVO;//作用域中IncludeFile对象
	    	
	    	//预加载方法
	    	$scope.ready = function() {
		        	$scope.initData();
					scope = $scope;
			}
	    	
	    	//页面初始化数据
	    	$scope.initData = function() {
	    		if(attributeName == null || attributeName == "null"){
		    		$scope.environmentVariableVO.attributeName = "";
		    		$scope.environmentVariableVO.attributeDescription = "";
		    		$scope.environmentVariableVO.attributeClass = "java";
		    		$scope.environmentVariableVO.attributeType = "String";
		    		$scope.environmentVariableVO.attributeValue="";
		    		$scope.environmentVariableVO.fileName="";
	    			
	    		}else{
		    		dwr.TOPEngine.setAsync(false);
			    	EnvironmentVariablePreferenceFacade.loadByEnvironmentVariableName(attributeName,function(data) {
			    		if(data!=null){
			    			oldAttributeName = data.attributeName;
			    			$scope.environmentVariableVO.attributeName = data.attributeName;
				    		$scope.environmentVariableVO.attributeDescription = data.attributeDescription;
				    		$scope.environmentVariableVO.attributeClass = data.attributeClass;
				    		$scope.environmentVariableVO.attributeType = data.attributeType;
				    		$scope.environmentVariableVO.attributeValue=data.attributeValue;
				    		$scope.environmentVariableVO.fileName=data.fileName;
		    			}else{
		    				$scope.environmentVariableVO.attributeName = "";
				    		$scope.environmentVariableVO.attributeDescription = "";
				    		$scope.environmentVariableVO.attributeClass = "java";
				    		$scope.environmentVariableVO.attributeType = "String";
				    		$scope.environmentVariableVO.attributeValue="";
				    		$scope.environmentVariableVO.fileName="";
		    			}
					});
					dwr.TOPEngine.setAsync(true);
	    		}
	    	}
	    	
	    	$scope.saveAttribute=function(){
		    		var rs = validataInfoRequired();
		    		if(!rs.validFlag){
	    				cui.error(rs.message);
	    				return;
	    			}
			    	dwr.TOPEngine.setAsync(false);
			    	EnvironmentVariablePreferenceFacade.addEnvironmentVariable(environmentVariableVO,oldAttributeName,function(data) {
						rs = data;
						if(rs){
							oldAttributeName = environmentVariableVO.attributeName;
							cui.message('保存成功！', 'success');
						}else{
							cui.error("保存失败！"); 
						}
					});
					dwr.TOPEngine.setAsync(true);
			 }
			    
	    	$scope.returnToList=function(){
			    	window.open("EnvironmentVariableList.jsp","_self");
			}
	    	
	    	$scope.$watch("environmentVariableVO.attributeType",function(){
	    		var rs = validataInforAttribute();
	    		if(!rs.validFlag){
					cui.error(rs.message);
				}else{
					$('#attributeValue input').focus().blur();
				} 
	    		
	    	});
	    });
	    
	    //保存按钮调用
	    function validataInfoRequired(){
			var validate = new cap.Validate();
	    	var valRule = {attributeName:validateAttributeName,fileName:validateFileName,attributeType:validateAttributeType,attributeValue:validateAttributeVale};
	    	return validate.validateAllElement(environmentVariableVO,valRule);
	    }
	    
	    //参数类型改变调用
	    function validataInforAttribute(){
			var validate = new cap.Validate();
	    	var valRule = {attributeType:validateAttributeType,attributeValue:validateAttributeVale};
	    	return validate.validateAllElement(environmentVariableVO,valRule);
	    }
	    
	    function setFocus(){
	    	//document.getElementById("attributeValue").focus(); 
	    	console.log($("#attributeValue"));
	    }
	
 	</script>
</body>
</html>