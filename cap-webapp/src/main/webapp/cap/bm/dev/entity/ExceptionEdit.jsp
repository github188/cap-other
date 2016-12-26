<%
/**********************************************************************
* 异常编辑页面
* 2015-10-14 凌晨
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='exceptionEdit'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>异常选择</title>
	<top:link href="/cap/bm/common/base/css/base.css"/>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/validate.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/ExceptionFacade.js"></top:script>
	<style type="text/css">
		
	</style>
	<script type="text/javascript" charset="UTF-8">
		//获得传递参数
		var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var fromServiceObject=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("fromServiceObject"))%>;
		
		//拿到angularJS的scope
		var scope=null;
		angular.module('exceptionEdit', ["cui"]).controller('exceptionEditCtrl',['$scope',function ($scope) {
			
		   	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
		   	
		   	$scope.init=function(){
		   		//load异常对象
		   		dwr.TOPEngine.setAsync(false);
		   		ExceptionFacade.loadException(modelId, packageId, function(result){
		   			//当前异常对象
		   			$scope.currentExceptionVO = result;
		   		});
		 		dwr.TOPEngine.setAsync(true);
		   	};
		   	
		   	/**
		   	 * 选择异常确定方法
		   	 *
		   	 */
		   	$scope.save = function(){
		   		//保存前的校验
		   		var result = validateAll();
				if(!result.validFlag){
					cui.alert(result.message);
					return;
				}
		   		
		   		//新增设置modelName及modelId
		   		if(!modelId){
		   			$scope.currentExceptionVO.modelName = $scope.currentExceptionVO.engName; 
		   			$scope.currentExceptionVO.modelId = $scope.currentExceptionVO.modelPackage + "." + $scope.currentExceptionVO.modelType + "." + $scope.currentExceptionVO.modelName; 
		   		}
		   		
		   		dwr.TOPEngine.setAsync(false);
		   		ExceptionFacade.saveException($scope.currentExceptionVO, function(result){
		   			
		   		});
		 		dwr.TOPEngine.setAsync(true);
		   		$scope.returnBack();
		   	};		   	
		   	
		   	/**
		   	 * 返回按钮事件
		   	 *
		   	 */
		   	$scope.returnBack = function(){
		   		var url='ExceptionList.jsp?packageId=' + packageId+'&fromServiceObject='+fromServiceObject;
		   		window.location.href = url;
			    //window.open(url, "_self", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes");
		   	};
		   	
		   	/**
		   	 * 关闭窗口
		   	 */
		   	$scope.close = function(){
		   		if(fromServiceObject=='true'){
		   			window.parent.dialog.hide();
		   		}else{
			   		window.close();
		   		}
		   	};
		}]);
		
		/**
		 * 校验同一个package下的异常是否已存在（校验异常的engName，）
		 *
		 * @engName <code>engName</code>异常的英文名称
		 */
		var isExistSameNameException = function(eName){
			var result = false;
	   		dwr.TOPEngine.setAsync(false);
	   		ExceptionFacade.isExistSameNameException(scope.currentExceptionVO.modelPackage, eName, modelId, function(_result){
	   			result = _result;
	   		});
	 		dwr.TOPEngine.setAsync(true);
			return !result;
		};
		
		
		//验证规则
	    var exceptionChNameValRule = [{'type' : 'required', 'rule' : {'m': '中文名称不能为空'}}];
	    var exceptionEngNameValRule = [{'type' : 'required', 'rule' : {'m': '异常名称不能为空'}}, {type : 'custom', rule : {against : 'isExistSameNameException', m : '已存在同名的异常'}}, {'type':'custom','rule':{'against':'checkUpperEngName', 'm':'必须为英文字符、数字或者下划线，且必须以英文字符开头。'}}];

        //校验首字母大写
	    var checkUpperEngName = function(eName){
	    	var regEx = "^[A-Z]\\w*$";
    		if(eName){
    			var reg = new RegExp(regEx);
    			return (reg.test(eName));
    		}
    		return true;
	    }

	    //统一校验函数
		function validateAll(){
	    	var validate = new cap.Validate();
	    	var validateRule = {engName : exceptionEngNameValRule, chName : exceptionChNameValRule};
			return validate.validateAllElement([scope.currentExceptionVO],validateRule);
		}
	</script>
</head>
<body class="body_layout" ng-controller="exceptionEditCtrl" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth">
			     <tr>
			        <td  class="cap-form-td" style="text-align: left;">
						<div style="float:left;padding-left:5px">
							<span class="cap-group">异常编辑</span>
						</div>
						<div style="float:right;padding-right:5px">
							<span cui_button id="save" ng-click="save()" label="保存"></span>
							<span cui_button id="close" ng-click="close()" label="关闭"></span>
							<span cui_button id="returnBack" ng-click="returnBack()" label="返回"></span>
						</div>
						
			        </td>
			    </tr>
			    <tr>
			    	<td  style="text-align: left;">
			    		<table class="cap-table-fullWidth">
						   <tr>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	<font color="red">*</font>异常名称：
						        </td>
						        <td class="cap-td" style="text-align: left;width:auto" nowrap="nowrap">
						        	<span cui_input id="engName" ng-model="currentExceptionVO.engName" validate="exceptionEngNameValRule" width="100%"/>
						        </td>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	<font color="red">*</font>中文名称：
						        </td>
						         <td class="cap-td" style="text-align: left;width:auto" nowrap="nowrap">
					   				<span cui_input id="chName" ng-model="currentExceptionVO.chName" validate="exceptionChNameValRule" width="100%"/>
						        </td>
						    </tr>

						    <tr>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	包名：
						        </td>
						         <td class="cap-td" style="text-align: left;width:auto" nowrap="nowrap">
					   				<span cui_input id="packageName" ng-model="currentExceptionVO.modelPackage" validate="" width="100%" readonly="true"/>
						        </td>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        </td>
						         <td class="cap-td" style="text-align: left;width:auto" nowrap="nowrap">
						        </td>
						    </tr>
						    <tr ng-show="false">
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	提示信息：
						        </td>
						        <td class="cap-td" style="text-align: left;width:auto" colspan="3" nowrap="nowrap">
	      		                   <span cui_textarea id="message" ng-model="currentExceptionVO.message" width="100%" height="80px" ></span>
						        </td>
						    </tr>
						    <tr>
						        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
						        	描述：
						        </td>
						         <td class="cap-td" style="text-align: left;width:auto" colspan="3" nowrap="nowrap">
	      		                   <span cui_textarea id="description" ng-model="currentExceptionVO.description" width="100%" height="80px" ></span>
						        </td>
						    </tr>
						</table>
			    	</td>
			    </tr>
			</table>
		</div>	
	</div>
</body>
</html>