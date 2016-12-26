<%
/**********************************************************************
* 最佳实践选择 
* 2016-7-19 李小芬  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>最佳实践选择</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>                        
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/PracticeFacade.js'></top:script>
	<style type="text/css">
		th{
		    font-weight: bold;
		    font-size:14px;
		}
	</style>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left">
		<div class="thw_title" style="margin-left:11px;margin-top:0px;">
			<font id="pageTittle" class="fontTitle">最佳实践列表</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="确定" on_click="enSure"></span> 
	    <span uitype="button" label="取消" on_click="closeSelf"></span> 
	</div>
</div>
 <table uitype="Grid" id="practiceGrid" primarykey="modelId" sorttype="1" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
 	resizewidth="resizeWidth" selectrows="single" resizeheight="resizeHeight" >
 	 <thead>	
 	<tr>
		<th style="width:30px"></th>
		<th bindName="name" style="width:30%;" renderStyle="text-align: left;" sort="false">名称</th>
		<th bindName="definition" style="width:30%;" renderStyle="text-align: left;" sort="false">定义</th>
		<th bindName="practiceType" style="width:30%;" renderStyle="text-align: left;" sort="false">类型</th>
	</tr>
	</thead>
</table>

<script language="javascript"> 

	var testCaseType = "${param.testCaseType}";
	
	window.onload = function(){
		comtop.UI.scan();
	}

	//grid数据源
	function initData(tableObj,query){
		PracticeFacade.loadPracticeList(testCaseType, function(data){
			tableObj.setDatasource(data, data.length);
		});
	}
	
	//点击确定回调传值到父页面
	function enSure() {
		var selectData = cui("#practiceGrid").getSelectedRowData();
		if(selectData == null || selectData.length == 0){
			cui.alert("请选择最佳实践。");
			return;
		}
		window.parent.selPracticeBack(selectData);
	}
	
	//取消，关闭窗口
	function closeSelf(){
		window.parent.dialog.hide();
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
	}
	
 </script>
</body>
</html>