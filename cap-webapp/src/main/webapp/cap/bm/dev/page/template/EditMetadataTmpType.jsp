<%
/**********************************************************************
* 页面模板分类选择页面
* 2015-6-16 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='editMetadataTmpType'>
<head>
	<title>编辑模板分类</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/MetadataTmpTypeFacade.js'></top:script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body ng-controller="editMetadataTmpTypeCtrl" data-ng-init="ready()">
	<div uitype="Borderlayout" id="body" is_root="true">	
		<div class="top_header_wrap" style="padding:10px 30px 10px 25px">
			<div class="thw_operate" style="float:right;height: 28px;">
				<span uitype="button" id="saveTemplate" label="保存"  on_click="saveTemplateType" ></span>
				<span uitype="button" id="close" label="关闭"  on_click="closeTemplate" ></span>
			</div>
		</div>
		<div class="cap-area" style="width:100%;padding:25px 0px 20px 0px">
			<table class="cap-table-fullWidth">
				<colgroup>
					<col width="27%" />
					<col width="73%" />
				</colgroup>
				<tr ng-if="isShow">
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>父级模版分类：</td>
					<td class="cap-td" style="text-align: left;">
						<span cui_pulldown id="parentemplateTypeCode" mode="Single" ng-model="data.parentemplateTypeCode" value_field="id" label_field="text" datasource="initData" width="290px" validate="validataParentemplateType"></span>
				    </td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>模板分类编码：</td>
					<td class="cap-td" style="text-align: left;">
						<span cui_input id="templateTypeCode" name="templateTypeCode" ng-model="data.templateTypeCode" maxlength="28" width="290px" 
						   validate="validateTemplateCode" readonly="{{data.operationType == 'edit'}}"></span>
					</td>
				</tr>
				<tr>
					<td class="cap-td" style="text-align: right;"><font color="red">*</font>模板分类名称：</td>
					<td class="cap-td" style="text-align: left;">
						<span cui_input id="templateTypeName" name="templateTypeName" ng-model="data.templateTypeName" maxlength="28" width="290px"
			               validate="validateTemplateName" readonly="false"></span>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
		var operationType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("operationType"))%>;
		var parentemplateTypeCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("parentemplateTypeCode"))%>;
		var templateTypeCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("temlateTypeCode"))%>;
		var templateTypeName = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("temlateTypeName"))%>;
		var data = {operationType: operationType, parentemplateTypeCode: parentemplateTypeCode, templateTypeCode: templateTypeCode != null ? templateTypeCode : '', templateTypeName: templateTypeName != null ? decodeURIComponent(templateTypeName) : ''};
		var scope = {};
		angular.module('editMetadataTmpType', ["cui"]).controller('editMetadataTmpTypeCtrl', function ($scope) {
	    	$scope.data = data;
	    	$scope.isShow = data.operationType == 'add' && data.parentemplateTypeCode == null;
	    	$scope.ready=function(){
	    		scope = $scope;
	    		validateTemplateCode = operationType != "add" ? validateTemplateCode : validateTemplateCode.concat([{'type':'custom','rule':{'against':isExistMetadataTmpTypeByTypeCode, 'm':'模板分类编码已存在。'}}]);
		    	comtop.UI.scan();
		    }
		});
		
		//初始化父级模块分类下拉框数据源
		function initData(obj){
			var datasource = [];
			var treeData = window.parent.cui("#templateTypeTree").getDatasource();
			var metadataTmpTypes = treeData[0].children;
			for(var i=0, len=metadataTmpTypes.length; i<len; i++){
				datasource.push({id: metadataTmpTypes[i].key, text: metadataTmpTypes[i].title});
			}
			obj.setDatasource(datasource);
		}
		
		//保存模板
		function saveTemplateType(){
			var map = cap.validater.validAllElement();
	        var inValid = map[0];
	        var valid = map[1];
	       	//验证消息
			if(inValid.length > 0){//验证失败
				var str = "";
	            for (var i = 0; i < inValid.length; i++) {
					str += inValid[i].message + "<br />";
				}
			}else{
				window.parent.saveTemplateType(data, operationType);
				closeTemplate();
			}
		}
		
		//关闭窗口
		function closeTemplate(){
			window.parent.addTemplateDialog.hide();
		}
		
		//系统目录名称和编码的检测
		var validateTemplateName = [
		      	{'type':'required','rule':{'m':'名称不能为空。'}},
		      	{'type':'custom','rule':{'against':checkName, 'm':'名称只能为汉字、数字、字母、下划线、正斜杠、中英文括号。'}},
		      	{'type':'custom','rule':{'against':isExistMetadataTmpTypeByTypeName, 'm':'模板分类名称已存在。'}}
		    ],
		    validataParentemplateType = [
            	{'type':'required','rule':{'m':'父级模版分类不能为空。'}}
         	],
		    validateTemplateCode = [
		      	{'type':'required','rule':{'m':'编码不能为空。'}},
		      	{'type':'custom','rule':{'against':checkCode, 'm':'编码只能为数字、字母、下划线。'}}
		    ];
		/**     
		 * 只能为汉字、数字、字母、下划线
		 */     
		function checkName(data) {  
			var flag = true;
			if(data == null || data == ''){
				return flag;
			}
			var patrn = /^[\u4E00-\u9FA5A-Za-z0-9_/\(（\)）]+$/; 
			if (!patrn.exec(data)) flag= false;
			return flag;
		}
		
		//只能为 英文、数字、下划线
		function checkCode(data) {
			if(data){
				var reg = new RegExp("^[A-Za-z0-9_]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		/**     
		 * 检查类型模版分类编码的是否已存在
		 */  
		function isExistMetadataTmpTypeByTypeCode(typeCode){
			var isExist = false;
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.isExistMetadataTmpTypeByTypeCode(typeCode, function(data){
				isExist = !data;
			});
			dwr.TOPEngine.setAsync(true);
			return isExist;
		}
		
		/**     
		 * 检查类型模版分类名称是否存在
		 */  
		function isExistMetadataTmpTypeByTypeName(typeName){
			var isExist = false;
			dwr.TOPEngine.setAsync(false);
			MetadataTmpTypeFacade.isExistMetadataTmpTypeByTypeName(typeName, templateTypeCode, function(data){
				isExist = !data;
			});
			dwr.TOPEngine.setAsync(true);
			return isExist;
		}
	</script>
</body>
</html>