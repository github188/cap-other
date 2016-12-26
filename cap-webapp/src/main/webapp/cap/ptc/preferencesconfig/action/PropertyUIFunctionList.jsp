<%
/**********************************************************************
* 已有属性选择界面
* 2015-11-22 zhangzunzhi 新建
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
		window.parent.propertyFunctionCancel();
	}
	
	function initData(obj){
		var data = [{onclick:"openDictionarySelect(this)",description:"数据字典code选择函数"},
					{onclick:"openComponentSelect(1,this)",description:"关联表格控件选择函数"},
					{onclick:"openDataStoreSelect('pageURL','',this)",description:"页面url选择函数"},
					{onclick:"openDataStoreSelect('dataStore','',this)",description:"数据集选择函数"},
					{onclick:"openDataStoreSelect(1,'',this)",description:"对象属性选择函数"},
					{onclick:"openDataStoreSelect('treeIdParam','',this)",description:"包含对象的对象属性选择函数"},
					{onclick:"openEntityMethodSelectWindow('','','',this)",description:"后台方法选择函数"}
		            ];
		obj.setDatasource(data,data.length);
	}
	
	//确定
    function save(){
    	var selectData = cui("#propertyList").getSelectedRowData();
    	if(selectData == null || selectData.length == 0){
			cui.alert("请选择函数。");
			return;
		}
    	window.parent.propertyFunctionCallBack(selectData[0].onclick);
    }
	
	function resizeWidth() {
		return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
	}

	function resizeHeight() {
		return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
	}
	</script>
</head>
 <body style="background-color:#f5f5f5;">
	<div id="pageRoot" class="cap-page" style="padding-top:0px;">
			<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span id="formTitle" uitype="Label" value="已有函数列表" class="cap-label-title" size="12pt"></span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="save" uitype="Button" onclick="save()" label="确定"></span> 
					 <span id="cancel" uitype="Button" onclick="cancel()" label="取消"></span>
				</td>
			</tr>
		</table>
		<table id="propertyList" uitype="grid" datasource="initData" primarykey="ename" ellipsis="true" selectrows="single" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight" >
			<thead>
				<tr>
					<th width="30px" bindName=""></th>
					<th style="width: 40px" renderStyle="text-align: center;" bindName="1">序号</th>
					<th renderStyle="text-align:center;" bindName="onclick" width="40%">函数名称</th>
					<th renderStyle="text-align:center;" bindName="description" width="50%" >说明</th>
				</tr>
			</thead>
		</table>
	</div>
 </body>
</html>
	