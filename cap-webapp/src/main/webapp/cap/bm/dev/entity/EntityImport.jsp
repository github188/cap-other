<%
/**********************************************************************
* 元数据建模：由表导入实体
* 2014-9-2 徐庆庆 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>由数据库表导入实体</title>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>                        
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	<style type="text/css">

	</style>
</head>
<body class="body_layout" style="margin:10px">
 <table class="cap-table-fullWidth" >
	<tr>
		<td class="cap-form-td" style="font-size:16px;font-weight: bold;">由数据库表导入实体</td>
	</tr>
	<tr>
		<td class="cap-form-td">
			<table style="width:100%">
				<tr>
					<td style="color:#999;text-align:left;vertical-align: middle;" id="import_desc">
						<span style="color:red;">
						说明：如果输入的忽略表名前缀长度为“2”，那么表名“T_OMS_DEFECT”将转换为实体名称“Defect”,表名为“T_DEFECT”转换为实体名称“TDefect”
						</span>
					</td>
					<td style="text-align: right;width:650px;vertical-align: middle;" nowrap="nowrap">
						<span>忽略表名前缀长度</span>
						<span uitype="PullDown" id="prefix" name="prefix" width="50px" value ="2" editable="false" datasource="prefixData" on_change="valueChange"></span>
						<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入表名过滤" on_iconclick="fastQuery"  icon="search" enterable="true" style="text-align:left;" editable="true" width="330" ></span>
						<span uitype="button" label="导入" on_click="enSure"></span>
						<span uitype="button" label="关闭" on_click="closeWin"></span> 
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="cap-form-td">
			<table uitype="Grid" id="EntityImportGrid" primarykey="code" datasource="initData" pagination="true"  pagesize_list="[18,27,50]"  
			 	pagesize="20" resizewidth="resizeWidth" resizeheight="resizeHeight" >
			  <thead>	
			 	<tr>
					<th style="width:50px"><input type="checkbox"/></th>
					<th bindName="code" style="width:50%;" renderStyle="text-align: left;" sort="false">表名</th>
					<th bindName="description" renderStyle="text-align: left;" sort="false">描述</th>
				</tr>
			  </thead>	
			</table> 
		</td>
	</tr>
</table>

<script language="javascript"> 
	var GEN_CODE_PATH_CNAME = "GEN_CODE_PATH_CNAME";
	var _=cui.utils;
	var packageId = "${param.packageId}";//包ID，top的模块ID
	var entityList=new Array();//别名冲突实体列表
	var prefixData = [
						{id:'0',text:'0'},
						{id:'1',text:'1'},
						{id:'2',text:'2'},
						{id:'3',text:'3'},
						{id:'4',text:'4'},
						{id:'5',text:'5'}
					];
	
	
	window.onload = function(){
		comtop.UI.scan();
	}
	
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){
		var queryString = cui("#keyword").getValue();
		var prefix = parseInt(cui("#prefix").getValue());
		dwr.TOPEngine.setAsync(false);
		EntityFacade.loadEntityFromDatabase(queryString,prefix, query,function(data){
			if(data && data.count > 0) {
			    tableObj.setDatasource(data.list, data.count);
			}else {
				tableObj.setDatasource([], 0);
				if(data.errorMessage) {
					cui.alert(data.errorMessage);
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	function fastQuery() {
		initData(cui("#EntityImportGrid"),cui("#EntityImportGrid").getQuery());
	}
// 	function keyDownQuery(event) {
// 		if(event.keyCode ==13) {
// 			initData(cui("#EntityImportGrid"),cui("#EntityImportGrid").getQuery());
// 		}
// 	}
	//导入
	function enSure() {
		var codePath = "";
		
		var selectData = cui("#EntityImportGrid").getSelectedRowData();
		if (selectData.length == 0) {
		    cui.alert("请选择要导入的表。");
		    return;
		}
		var tableNames = [];
		for(var i = 0;i<selectData.length;i++){
			tableNames.push(selectData[i].code);
		}
		//判断是否存在有非单主键数据
		EntityFacade.loadTablePrimitiveKeyFormDataBase(tableNames,function(data){
			if(!data){
				cui.alert("存在无单主键的表，无法导入");
				return;
			}
			var prefix = parseInt(cui("#prefix").getValue());
			entityList=new Array();
			cui.handleMask.show();
			setTimeout(function(){
				//导入表之前先验证数据库表对应实体的别名是否存在，如果不存在则继续执行导入操作
				EntityFacade.beforeImportTableToProject(packageId,tableNames,prefix,function(data){
					if(data.count>0) {
						cui.handleMask.hide();
						entityList=data.list;
						editEntityAliasName();
					}else{
						EntityFacade.importTableToProject(packageId,tableNames,prefix,codePath,globalCapEmployeeId,globalCapEmployeeName,entityList,function(data){
							if(data) {
								window.opener.focus();
								window.opener.cui.message("导入实体成功。","success");
								window.opener.importCallback(packageId,tableNames,prefix);
								closeWin();
							}else {
								window.cui.message("导入实体出错，请联系管理员。");
							}
							cui.handleMask.hide();
						});
					}
				});
				
			}, 100);
		});
	}
	// 别名编辑后导入 
	function enSureData(entityListTemp){
		var codePath = "";
		
		var selectData = cui("#EntityImportGrid").getSelectedRowData();
		if (selectData.length == 0) {
		    cui.alert("请选择要导入的表。");
		    return;
		}
		var tableNames = [];
		for(var i = 0;i<selectData.length;i++){
			tableNames.push(selectData[i].code);
		}
		var prefix = parseInt(cui("#prefix").getValue());
		cui.handleMask.show();
		EntityFacade.importTableToProject(packageId,tableNames,prefix,codePath,globalCapEmployeeId,globalCapEmployeeName,entityListTemp,function(data){
			if(data) {
				window.opener.focus();
				window.opener.cui.message("导入实体成功。","success");
				window.opener.importCallback(packageId,tableNames,prefix);
				closeWin();
			}else {
				window.cui.message("导入实体出错，请联系管理员。");
			}
			cui.handleMask.hide();
		});
	}
	
	var dialog;
	// 编辑重复的别名 
	function editEntityAliasName() {
		var height = 300;
		var width = 500;
		var url ='EntityNameEditList.jsp';
		if(!dialog){
			dialog = cui.dialog({
			  	title : "实体别名编辑",
			  	src : url,
			    width : width,
			    height : height
			});
		}
	 	dialog.show(url);
	}
	
	//关闭实体名称编辑窗口
	function closeEntityNameWindow(){
		dialog.hide();
	}
	
	//取消
	function closeWin() {
		window.top.close();
	}

	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) -120; //Grid上面有3个tr，每个tr高度均为40px，故grid总高度应该是body的高度减去120px
	}
 </script>
</body>
</html>