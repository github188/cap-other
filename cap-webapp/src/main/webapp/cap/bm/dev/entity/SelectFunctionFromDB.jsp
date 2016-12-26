<%
/**********************************************************************
* 数据库建模：数据库函数列表
* 2015-12-17 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>函数模型列表页</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/FunctionFacade.js'></top:script>
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
			<font id="pageTittle" class="fontTitle">函数列表</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="PullDown" mode="Single" id="import_type" width="200px" datasource="importTypes" value="existFunction" on_change="changeType" editable="false"></span>
		<span uitype="ClickInput" id="button_keyword" name="keyword" emptytext="请输入存储过程名过滤"
			on_iconclick="fastQuery"  icon="search" enterable="true" width="200px" style="text-align:left;"
			editable="true"	 width="330" on_keyup="keyDownQuery" ></span>
		<span uitype="button" label="确定" id="button_add" on_click="selectFunction"></span>
		<span uitype="button" label="关闭" id="button_del" on_click="closeWin"></span>
	</div>
</div>
 <table uitype="Grid" id="FunctionGrid" primarykey="modelId"  sorttype="DESC" datasource="initFunctionData" pagination="false"  
 	selectrows="single" resizewidth="resizeWidth" resizeheight="resizeHeight">
 	 <thead>
 	<tr>
 	    <th style="width: 30px" renderStyle="text-align: center;"></th>
		<th bindName="engName" style="width:30%;" renderStyle="text-align: left;"  >函数名称</th>
		<th bindName="chName" style="width:30%;" renderStyle="text-align: left;" >中文名称</th>
		<th bindName="description" style="width:35%;" renderStyle="text-align: center" >描述</th>
	</tr>
	</thead>
</table>

<script language="javascript"> 
var functionId = '${param.functionId}';	
var packagePath = "${param.packagePath}";//包路径
var switchParameter = 'exist'; 
	window.onload = function(){
		comtop.UI.scan();
		init();
	}
	
	var importTypes = [
	                   {id:'existFunction',text:"已导入的函数"},
	                   {id:'databaseFunction',text:"数据库函数"},
	               ];
	      	
	//初始化页面
	function init(){
		cui("#import_type").setValue('existFunction');
		cui("#button_keyword").hide();
	}
	
	//grid数据源
	function initFunctionData(tableObj,query){		
		dwr.TOPEngine.setAsync(false);
		FunctionFacade.queryProcedureList(packagePath,function(data){
			tableObj.setDatasource(data, data.length);
			if(functionId != ''){
				for(var i=0;i<data.length;i++){
					if(data[i].modelId == functionId){
						tableObj.selectRowsByPK(data[i].modelId);
						break;
					}
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

	//grid数据源
	function initDatabaseFunctionData(tableObj,query){
		var queryString = cui("#button_keyword").getValue();
		dwr.TOPEngine.setAsync(false);
		FunctionFacade.loadFunctinFromDatabase(queryString,query,function(data){
			if(data && data.length > 0) {
			    tableObj.setDatasource(data, data.length);
			}else {
				tableObj.setDatasource([], 0);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//确定
	function selectFunction(){
		if(switchParameter == 'exist'){
			selectExistFunction();
		}else{
			selectDatabaseFunction();
		}
	}
	//切换类型
	function changeType(){
   		var importType = cui("#import_type").getValue();
   		if(importType == 'existFunction'){
   			switchParameter = 'exist';
   			cui("#button_keyword").hide();
   			initFunctionData(cui("#FunctionGrid"),cui("#FunctionGrid").getQuery());
   		}else{
   			switchParameter ='';
   			cui("#button_keyword").show();
   			cui("#button_keyword").setValue('');
   			initDatabaseFunctionData(cui("#FunctionGrid"),cui("#FunctionGrid").getQuery());
   		}
   	}
	
	//选择
	function selectExistFunction(){
		var selectdata = cui("#FunctionGrid").getSelectedRowData();
		if(selectdata == null || selectdata.length == 0){
			cui.alert("请选择要引入的存储过程。");
			return;
		}
		window.opener.selectedDBObjectCalled(selectdata[0],"function");
		window.close();
	}
	//快速查询
	function fastQuery() {
		initDatabaseFunctionData(cui("#FunctionGrid"),cui("#FunctionGrid").getQuery());
	}
	function keyDownQuery(event) {
		if(event.keyCode ==13) {
			initDatabaseFunctionData(cui("#FunctionGrid"),cui("#FunctionGrid").getQuery());
		}
	}
	//导入
	function selectDatabaseFunction() {
		var selectData = cui("#FunctionGrid").getSelectedRowData();
		if (selectData.length == 0) {
		    cui.alert("请选择要导入的函数。");
		    return;
		}
		var functionModelId = packagePath+".function."+selectData[0].engName;
		cui.handleMask.show();
		setTimeout(function(){
			dwr.TOPEngine.setAsync(false);
			FunctionFacade.importFunctions(packagePath,selectData,function(data){
				if(data) {
					getFunction(functionModelId);
					closeWin();
				}else {
					parent.cui.message("导入函数出错，请联系管理员。");
				}
				cui.handleMask.hide();
			});
			dwr.TOPEngine.setAsync(true);
		}, 100);
	}
	//获取导入的存储过程  procedureModelId 存储过程的modelId
	function getFunction(functionModelId){
		dwr.TOPEngine.setAsync(false);
		FunctionFacade.queryFunctionById(functionModelId,function(data){
			if(data) {
				window.opener.selectedDBObjectCalled(data,"function");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//关闭
	function closeWin(){
		window.close();
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