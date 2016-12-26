<%
/**********************************************************************
* 测试用例基本信息编辑
* 2016-06-29 李小芬  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app="testCaseEdit">
	<head>
		<title>测试用例编辑</title>
		<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/rt/common/base/css/base.css"></top:link>
		<top:link href="/cap/bm/test/css/comtop.cap.test.css"/>
		<top:script src="/cap/bm/test/js/jquery.min.js"></top:script>
	    <top:script src="/cap/rt/common/cui/js/comtop.ui.min.js"></top:script>
	    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	    <top:script src="/cap/bm/test/js/comtop.cap.js"></top:script>
	    <top:script src="/cap/bm/test/js/angular.js"></top:script>
		<top:script src="/cap/bm/test/js/cui2angularjs.js"></top:script>
		<top:script src='/cap/dwr/engine.js'></top:script>
		<top:script src='/cap/dwr/util.js'></top:script>
		<top:script src="/cap/dwr/interface/TestCaseFacade.js"></top:script>
		
	</head>
	<style>
		.top_header_wrap{
			padding-right:5px;
		}
	</style>
	<body ng-controller="testCaseEditCtrl" data-ng-init="ready()">
		<div uitype="Borderlayout" id="body" is_root="true">	
				<div class="cap-area" style="width:100%;padding:25px 0px 20px 0px">
				<table class="cap-table-fullWidth">
					<colgroup>
						<col width="27%" />
						<col width="73%" />
					</colgroup>
					<tr>
						<td class="cap-td" style="text-align: right;"><font color="red">*</font>用例中文名称：</td>
						<td class="cap-td" style="text-align: left;">
						<span cui_input ng-model="data.name" id="name" name="name" maxlength="50" width="93%"
			               validate="validateName"></span>
						</td>
					</tr>
					<tr>
						<td class="cap-td" style="text-align: right;"><font color="red">*</font>用例英文名称：</td>
						<td class="cap-td" style="text-align: left;">
						<span cui_input ng-model="data.modelName" id="modelName" name="modelName" maxlength="50" width="93%"
			               validate="validateEngName" readonly="true"></span>
						</td>
					</tr>
					<tr>
						<td class="cap-td" style="text-align: right;"><font color="red">*</font>用例类型：</td>
						<td class="cap-td" style="text-align: left;">
			               <span id="type" cui_pulldown ng-model="data.type" value_field="id" label_field="text"
			               		 width="93%" datasource="testCaseType"  validate="[{'type':'required', 'rule':{'m': '用例类型不能为空'}}]" readonly="true"></span>
						</td>
					</tr>
					<tr ng-if="data.type === 'FUNCTION'">
						<td class="cap-td" style="text-align: right;">界面行为：</td>
						<td class="cap-td" style="text-align: left;">
			               <span id="pageActionId"  cui_input  ng-model="data.showMetadata" width="93%" readonly="true"></span>
						</td>
					</tr>
					<tr ng-if="data.type === 'API'">
						<td class="cap-td" style="text-align: right;">实体方法：</td>
						<td class="cap-td" style="text-align: left;">
			               <span id="entityMethodId" cui_input ng-model="data.showMetadata" width="93%"  readonly="true"></span>
						</td>
					</tr>
					<tr  ng-if="data.type === 'SERVICE'">
						<td class="cap-td" style="text-align: right;">服务方法：</td>
						<td class="cap-td" style="text-align: left;">
			               <span id="serviceMethodId" cui_input ng-model="data.showMetadata" width="93%"  readonly="true"></span>
						</td>
					</tr>
					<tr>
						<td class="cap-td" style="text-align: right;">测试场景：</td>
						<td class="cap-td" style="text-align: left;">
						<span cui_textarea ng-model="data.scene" id="scene" name="scene" maxlength="100" 
							  width="93%" height="100px"></span>
						</td>
					</tr>
					<tr id="desc_div" style="display: none;">
						<td class="cap-td" style="text-align: right;">用例描述：</td>
						<td class="cap-td" style="text-align: left;">
						<span cui_textarea ng-model="data.description" id="description" name="description" maxlength="100" 
							  width="93%" height="100px"></span>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<script type="text/javascript">
			var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		   	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		   	var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
		   	var pageSession = new cap.PageStorage(modelId);
		   	var testCaseVO = pageSession.get("testCase");
		   
		   	var testCaseType = [
		               		{id:'FUNCTION',text:'界面功能'},
		               		{id:'API',text:'后台API'},
		               		{id:'SERVICE',text:'业务服务'}
		    ]
		   
		   	var scope = {};
		   	var dialog;
		   	angular.module('testCaseEdit', ["cui"]).controller('testCaseEditCtrl', function ($scope) {
				$scope.data = testCaseVO;// 绑定对象
				
				$scope.ready=function(){
		    		comtop.UI.scan();
		    		scope = $scope;
			    }
				
				$scope.selPageAction=function(){
					var url = "SelPageActionMain.jsp?packageId=" + packageId;
					var title="界面行为选择";
					var height = 600; //600
					var width =  680; // 680;
					
					dialog = cui.dialog({
						title : title,
						src : url,
						width : width,
						height : height
					})
					dialog.show(url);
				}
				
				$scope.selEntityMethod=function(){
					var url = "SelEntityMethodMain.jsp?packageId=" + packageId;
					var title="实体方法选择";
					var height = 600; //600
					var width =  680; // 680;
					
					dialog = cui.dialog({
						title : title,
						src : url,
						width : width,
						height : height
					})
					dialog.show(url);
				}
				
				$scope.selServiceMethod=function(){
					var url = "SelServiceMethodMain.jsp?packageId=" + packageId;
					var title="服务方法选择";
					var height = 600; //600
					var width =  680; // 680;
					
					dialog = cui.dialog({
						title : title,
						src : url,
						width : width,
						height : height
					})
					dialog.show(url);
				}
				
				$scope.selPractice=function(){
					var url = "SelPractice.jsp?testCaseType=" + testCaseVO.type;
					var title="最佳实践选择";
					var height = 600; //600
					var width =  680; // 680;
					
					dialog = cui.dialog({
						title : title,
						src : url,
						width : width,
						height : height
					})
					dialog.show(url);
				}
				
		    });
		   	
		  	//界面行为选择回调
			function selPageActionBack(selectData) {
				scope.data.metadata = selectData[0].actionDefineVO.modelId;
				scope.$digest();
				if(dialog){
					dialog.hide();
				}
			}
		  	
			//实体方法选择回调
			function selEntityMethodBack(selectData) {
				scope.data.metadata = selectData[0].methodId;
				scope.$digest();
				if(dialog){
					dialog.hide();
				}
			}
			
			//服务方法选择回调
			function selServiceMethodBack(selectData) {
				scope.data.metadata = selectData[0].engName;
				scope.$digest();
				if(dialog){
					dialog.hide();
				}
			}
		   	
		  	//"#entityMethodId" '实体方法不能为空！'
		  	function addValidate(id,msg){
			  	window.validater.disValid(cui(id),false);
			  	window.validater.add(cui(id), 'required', {m:msg});
		  	}
		  
		  	//"#entityMethodId" 
		  	function notValidateQuery(id){
			  	window.validater.disValid(cui(id),true);
		  	}
		  
			//中文名称检测
			var validateName = [
			      {'type':'required','rule':{'m':'用例中文名称不能为空。'}},
			      {'type':'custom','rule':{'against':checkNameIsExist, 'm':'用例中文名称已经存在。'}}
			];
		
			//名称检测
			var validateEngName = [
			      {'type':'required','rule':{'m':'用例英文名称不能为空。'}},
			      {'type':'custom','rule':{'against':checkNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以大写英文字符开头。'}},
			      {'type':'custom','rule':{'against':checkEngNameIsExist, 'm':'用例英文名称已经存在。'}}
			];
		    
			//校验实体名称字符
			function checkNameChar(data) {
		  		var regEx = "^[a-zA-Z0-9_]*$";
		  		if(data){
					var reg = new RegExp(regEx);
					return (reg.test(data));
				}
				return true;
			}
			
			//检验实体名称是否存在
			function checkNameIsExist(name) {
		  		var flag = true;
		  		dwr.TOPEngine.setAsync(false);
		  		TestCaseFacade.isExistSameNameTestCase(moduleCode,name,modelId,function(bResult){
					flag = !bResult;
				});
				dwr.TOPEngine.setAsync(true);
				return flag;
			}
		
			//检验实体名称是否存在
			function checkEngNameIsExist(engName) {
		  		var flag = true;
		  		dwr.TOPEngine.setAsync(false);
		  		TestCaseFacade.isExistSameEngNameTestCase(moduleCode,engName,modelId,function(bResult){
					flag = !bResult;
				});
				dwr.TOPEngine.setAsync(true);
				return flag;
			}
	
		</script>
	</body>
</html>