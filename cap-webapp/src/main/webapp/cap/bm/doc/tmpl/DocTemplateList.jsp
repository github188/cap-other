<!doctype html>
<%
  /**********************************************************************
	* 文档模板列表
	* 2015-11-9 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>文档模板列表</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:link  href="/eic/css/eic.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.eic.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
</head>

<style>
.queryDiv{
	float:left;
	margin-bottom:4px;
}
.buttonDiv{
	float:right;
	margin-bottom:4px;
}
</style>

<body style="overflow-y:hidden;">
<div class="list_header_wrap" style="padding-left:10px;">
		<div class="queryDiv">
			<span>文档类型：</span>
			<span uitype="PullDown" datasource="docTypeData" on_change="search" value_field="id" must_exist="true" editable="true" mode="Single" empty_text="请选择" id="type" height="200" databind="CapDocTemplate.type"></span>
			<span uitype="button" id="search_btn" label="查询" on_click="search"></span>
			<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch"></span>
		</div>
		<div  class="buttonDiv">
		<span uitype="button" on_click="btnAdd" id="btnAdd" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/add_white.gif" hide="false" button_type="blue-button" disable="false" label="新增"></span> 
		<span uitype="button" on_click="btnDelete" id="btnDelete" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/delete_white.gif" hide="false" button_type="blue-button" disable="false" label="删除"></span> 
		</div>
			<table uitype="Grid" id="CapDocTemplateGrid" ellipsis="true" pageno="1" sortstyle="1" selectrows="multi" datasource="initData" resizeheight="resizeHeight" 
				   resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" primarykey="id"  pagination="true" pagesize="50" >
				<thead>
			 	<tr>
					<th style="width:5%"><input type="checkbox"/></th>
					<th bindName="1" render="" renderStyle="text-align: center;" style="width:5%;">序号</th>
					<th bindName="name" render="editLinkRender" renderStyle="text-align: left;" style="width:20%;">名称</th>
					<th bindName="type" render="typeSysRender" renderStyle="text-align: left;" style="width:10%;">模板类别</th>
					<th bindName="docConfigType" render="docConfigTypeRender" renderStyle="text-align: center;" style="width:10%;">模板属性</th>
					<th bindName="path" renderStyle="text-align: left;" style="width:20%;">存储地址</th>
					<th bindName="remark" renderStyle="text-align: left;" style="width:30%;">说明</th>
				</tr>
				</thead>
			</table>
</div>
 
	<top:script src="/cap/dwr/interface/CapDocTemplateAction.js"/>

<script language="javascript">
	var CapDocTemplate = {};
	var docTypeData =  [
	                		{"id": "BIZ_MODEL", "text":"业务模型说明书"},                   
	                		{"id": "SRS", "text":"需求规格说明书"},
	                		{"id": "HLD", "text":"概要设计说明书"},
	                		{"id": "LLD", "text":"详细设计说明书"},
	                		{"id": "DBD", "text":"数据库设计说明书"}
	                	];
	window.onload = function(){
		comtop.UI.scan();		
	}
	
	var dataCount = 0;
	var typeSysRenderDatalist;
	//grid数据源
	function initData(tableObj,query){	
		query.sortFieldName = "docConfigType";
		query.sortType = "DESC";
		dwr.TOPEngine.setAsync(false);
		CapDocTemplateAction.queryCapDocTemplateList(query,function(data){
			dataCount = data.count;
		    tableObj.setDatasource(data.list, data.count);
		    maxSortNo = dataCount;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	function isExitsFunction(funcName) {
	    try {
	        if(typeof(eval(funcName)) == "function") {
	            return true;
	        }
	    } catch(e) {}
	    return false;
	}
	
	function rowNoRender(rowData, index, colName){
		return index+1;
	}
	
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(CapDocTemplate).databind().getValue();
        //设置Grid的查询条件
        cui('#CapDocTemplateGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#CapDocTemplateGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
        cui(CapDocTemplate).databind().setEmpty();
        search();
    }
    

	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}

	//grid高度
	function resizeHeight(){
		var queryDiv = $(".queryDiv");
		var buttonDiv = $(".buttonDiv");
		var existingHeight = 0;
		if(queryDiv){
			existingHeight = queryDiv[0].clientHeight;
		}
		if(buttonDiv){
			existingHeight += buttonDiv[0].clientHeight;
		}
		return (document.documentElement.clientHeight || document.body.clientHeight) - existingHeight-50;
	}
	
	function typeSysRender(rd, index, col){
		var finalValue = rd[col.bindName];
		if(finalValue == undefined || finalValue==null){
			return;
		}
		if(finalValue == "BIZ_MODEL"){
			text="业务模型说明书"
		}
		else if(finalValue == "SRS"){
			text="需求规格说明书"
		}else if(finalValue == "HLD"){
			text="概要设计说明书"
		}else if(finalValue == "LLD"){
			text="详细设计说明书"
		}else{
			text="数据库设计说明书"
		}
		return text;
	}
	
	function docConfigTypeRender(rd, index, col){
		var finalValue = rd[col.bindName];
		var text="";
		if(finalValue == undefined || finalValue==null){
			return;
		}
		if(finalValue == "PRIVATE"){
			text="专用模板"
		}
		else{
			text="公共模板"
		}
		return text;
	}
    //列表列渲染——编辑链接渲染
	function editLinkRender(rd, index, col) {	
		if(!rd[col.bindName]){
			return;
		}		
		return "<a href='javascript:;' onclick='edit(\"" +rd.id+"\");'>" + rd[col.bindName] + "</a>";
	}
	
    
    //列表列渲染——查看链接渲染
    function viewLinkRender(rd, index, col) {
    	if(!rd[col.bindName]){
			return;
		}			
		return "<a href='javascript:;' onclick='view(\"" +rd.id+"\");'>" + rd[col.bindName] + "</a>";
	}
	
	//删除事件
	function btnDelete(){
		var selects = cui("#CapDocTemplateGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}	
		cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				CapDocTemplateAction.deleteCapDocTemplateList(cui("#CapDocTemplateGrid").getSelectedRowData(),function(msg){
				 	cui("#CapDocTemplateGrid").loadData();
				 	cui.message("删除成功！","success");
				 	});
				dwr.TOPEngine.setAsync(true);
			}
		});

	}




</script>
<top:script src="/cap/bm/doc/tmpl/js/DocTemplateList.js"/>
</body>
</html>