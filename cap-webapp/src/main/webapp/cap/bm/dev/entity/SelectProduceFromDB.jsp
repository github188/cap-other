<%
/**********************************************************************
* 数据库建模：数据库存储过程列表
* 2015-12-17 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>存储过程模型列表页</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/ProcedureFacade.js'></top:script>
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
			<font id="pageTittle" class="fontTitle">存储过程列表</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="PullDown" mode="Single" id="import_type" width="200px" datasource="importTypes" value="existProcedure" on_change="changeType" editable="false"></span>
		<span uitype="ClickInput" id="button_keyword" name="keyword" emptytext="请输入存储过程名过滤"
			on_iconclick="fastQuery"  icon="search" enterable="true" width="200px" style="text-align:left;"
			editable="true"	 width="330" on_keyup="keyDownQuery" ></span>
		<span uitype="button" label="确定" id="button_add" on_click="selectProcedure"></span>
		<span uitype="button" label="关闭" id="button_close" on_click="closeWin"></span>
	</div>
</div>
 <table uitype="Grid" id="ProcedureGrid" primarykey="modelId"  sorttype="DESC" datasource="initProcedureData" pagination="false" 
 	selectrows="single" resizewidth="resizeWidth" resizeheight="resizeHeight">
 	 <thead>
 	<tr>
 	    <th style="width: 30px" renderStyle="text-align: center;"></th>
		<th bindName="engName" style="width:30%;" renderStyle="text-align: left;"  >存储过程名称</th>
		<th bindName="chName" style="width:30%;" renderStyle="text-align: left;" >中文名称</th>
		<th bindName="description" style="width:35%;" renderStyle="text-align: center" >描述</th>
	</tr>
	</thead>
</table>

<script language="javascript"> 
var produreId = '${param.produreId}';
var packagePath = "${param.packagePath}";//包路径
var switchParameter = 'exist'; 
	window.onload = function(){
		comtop.UI.scan();
		init();
	}
	
	var importTypes = [
	                   {id:'existProcedure',text:"已导入的存储过程"},
	                   {id:'databaseProcedure',text:"数据库存储过程"},
	               ];
	      	
	//初始化页面
	function init(){
		cui("#import_type").setValue('existProcedure');
		cui("#button_keyword").hide();
	}
	//grid数据源
	function initProcedureData(tableObj,query){
		dwr.TOPEngine.setAsync(false);
		ProcedureFacade.queryProcedureList(packagePath,function(data){
			tableObj.setDatasource(data, data.length);
			if(produreId != ''){
				for(var i=0;i<data.length;i++){
					if(data[i].modelId == produreId){
						tableObj.selectRowsByPK(data[i].modelId);
						break;
					}
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//grid数据源
	function initDatabaseProcedureData(tableObj,query){
		var queryString = cui("#button_keyword").getValue();
		dwr.TOPEngine.setAsync(false);
		ProcedureFacade.loadProcedureFromDatabase(queryString,query,function(data){
			if(data && data.length > 0) {
			    tableObj.setDatasource(data, data.length);
			}else {
				tableObj.setDatasource([], 0);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	function changeType(){
		var importType = cui("#import_type").getValue();
		if(importType == 'existProcedure'){
			switchParameter ='exist';
			cui("#button_keyword").hide();
			initProcedureData(cui("#ProcedureGrid"),cui("#ProcedureGrid").getQuery());
		}else{
			switchParameter ='';
			cui("#button_keyword").show();
			cui("#button_keyword").setValue('');
			initDatabaseProcedureData(cui("#ProcedureGrid"),cui("#ProcedureGrid").getQuery());
		}
	}
	
	//确定
	function selectProcedure(){
		if(switchParameter == 'exist'){
			selectExistProcedure();
		}else{
			selectDatabaseProcedure();
		}
	}
	
	//选择
	function selectExistProcedure(){
		var selectdata = cui("#ProcedureGrid").getSelectedRowData();
		if(selectdata == null || selectdata.length == 0){
			cui.alert("请选择要引入的存储过程。");
			return;
		}
		window.opener.selectedDBObjectCalled(selectdata[0],"procedure");
		window.close();
	}
	
	//关闭
	function closeWin(){
		window.close();
	}
	
	//快速查询
	function fastQuery() {
		initDatabaseProcedureData(cui("#ProcedureGrid"),cui("#ProcedureGrid").getQuery());
	}
	function keyDownQuery(event) {
		if(event.keyCode ==13) {
			initDatabaseProcedureData(cui("#ProcedureGrid"),cui("#ProcedureGrid").getQuery());
		}
	}
	//导入
	function selectDatabaseProcedure() {
		var selectData = cui("#ProcedureGrid").getSelectedRowData();
		if (selectData.length == 0) {
		    cui.alert("请选择要导入的存储过程。");
		    return;
		}
		var procedureModelId = packagePath+".procedure."+selectData[0].engName;
		cui.handleMask.show();
		setTimeout(function(){
			dwr.TOPEngine.setAsync(false);
			ProcedureFacade.importProcedures(packagePath,selectData,function(data){
				if(data) {
					getProcedure(procedureModelId);
					closeWin();
				}else {
					parent.cui.message("导入存储过程出错，请联系管理员。");
				}
				cui.handleMask.hide();
			});
			dwr.TOPEngine.setAsync(true);
		}, 100);
	}
	
	//获取导入的存储过程  procedureModelId 存储过程的modelId
	function getProcedure(procedureModelId){
		dwr.TOPEngine.setAsync(false);
		ProcedureFacade.queryProcedureById(procedureModelId,function(data){
			if(data) {
				window.opener.selectedDBObjectCalled(data,"procedure");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//grid列渲染
	function correspondTableRenderer(rd, index, col) {
		return "<a href='javascript:;' onclick='viewTableModel(\"" +rd.modelId+ "\");'>" +rd.engName + "</a>";
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