<%
/**********************************************************************
* 已有属性选择界面
* 2015-11-21 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<style>

</style>
<meta charset="UTF-8">
<title> 自定义行为编辑页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<style type="text/css">
    </style> 
	<script type="text/javascript">
	
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
	});
	
	//取消
	function cancel(){
		window.parent.importPropertyCancel();
	}
	
	function initData(obj){
		var data = [{ename:"code",cname:"数据字典code",type:"String",readonly:"true",requried:"true",description:"通过数据字典页面设置编码",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'code','ng-model':'code','onclick':'openDictionarySelect()','validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"relationGridId",cname:"关联表格控件",type:"String",readonly:"true",requried:"true",description:"关联表格控件选择",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'relationGridId','ng-model':'relationGridId','onclick':'openComponentSelect(1)','validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"queryCondition",cname:"查询数据集合",type:"String",readonly:"true",requried:"true",description:"选择查询数据集合",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'queryCondition','ng-model':'queryCondition','onclick':\"openDataStoreSelect(\'queryCondition\')\",'validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"pageURL",cname:"页面URL",type:"String",readonly:"true",requried:"true",description:"页面选择",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'pageURL','ng-model':'pageURL','onclick':\"openDataStoreSelect(\'pageURL\')\",'validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"columnAttribute",cname:"对象属性",type:"String",readonly:"true",requried:"true",description:"对象属性选择",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'columnAttribute','ng-model':'columnAttribute','onclick':'openDataStoreSelect(1)','validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"dataStore",cname:"数据集",type:"String",readonly:"true",requried:"true",description:"数据集选择",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'dataStore','ng-model':'dataStore','onclick':\"openDataStoreSelect(\'dataStore\')\",'validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"actionMethodName",cname:"后台方法",type:"String",readonly:"true",requried:"true",description:"后台方法选择",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'actionMethodName','ng-model':'actionMethodName','onclick':'openEntityMethodSelectWindow()','validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"treeIdParam",cname:"树形节点ID",type:"String",readonly:"true",requried:"true",description:"对象属性选择",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'treeIdParam','ng-model':'treeIdParam','onclick':\"openDataStoreSelect(\'treeIdParam\')\",'validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"treeParentIdParam",cname:"树形父节点ID",type:"String",readonly:"true",requried:"true",description:"对象属性选择",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'treeParentIdParam','ng-model':'treeParentIdParam','onclick':\"openDataStoreSelect(\'treeParentIdParam\')\",'validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}},
		            {ename:"treeNameParam",cname:"树形名称",type:"String",readonly:"true",requried:"true",description:"对象属性选择",propertyEditorUI:{componentName:"cui_clickinput",script:"{'id':'treeNameParam','ng-model':'treeNameParam','onclick':\"openDataStoreSelect(\'treeNameParam\')\",'validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}}
		            ];
		obj.setDatasource(data,data.length);
	}
	
	//确定
    function save(){
    	var selectData = cui("#propertyList").getSelectedRowData();
    	if(selectData == null || selectData.length == 0){
			cui.alert("请选择属性。");
			return;
		}
    	window.parent.importPropertyCallBack(selectData);
    }
	
	function resizeWidth() {
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}

	function resizeHeight() {
		return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
	}
	</script>
</head>
 <body style="background-color:#f5f5f5;">
	<div id="pageRoot" class="cap-page">
			<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span id="formTitle" uitype="Label" value="已有属性列表" class="cap-label-title" size="12pt"></span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="save" uitype="Button" onclick="save()" label="确定"></span> 
					 <span id="cancel" uitype="Button" onclick="cancel()" label="取消"></span>
				</td>
			</tr>
		</table>
		<table id="propertyList" uitype="grid" datasource="initData" primarykey="ename" ellipsis="true" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight" >
			<thead>
				<tr>
					<th width="30px" bindName=""><input type="checkbox"></th>
					<th style="width: 40px" renderStyle="text-align: center;" bindName="1">序号</th>
					<th renderStyle="text-align:center;" bindName="cname" width="20%">中文名称</th>
					<th renderStyle="text-align:center;" bindName="ename" width="20%" >英文名称</th>
					<th renderStyle="text-align:center;" bindName="type" width="15%">值类型</th>
					<th renderStyle="text-align:center;" bindName="propertyEditorUI.componentName" width="15%">控件类型</th>
					<th renderStyle="text-align:center;" bindName="description" width="40%">描述</th>
				</tr>
			</thead>
		</table>
	</div>
 </body>
</html>
	