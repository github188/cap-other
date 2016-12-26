<!doctype html>
<%
  /**********************************************************************
	* 表单单选界面
	* 2015-11-17 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>表单基本信息列表</title>
    <top:link href="/cap/bm/common/top/css/top_base.css" />
	<top:link href="/cap/bm/common/top/css/top_sys.css" />
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
	<top:script src="/cap/bm/common/top/js/jquery.js" />
	<top:script src="/cap/bm/common/js/capCommon.js" />
	<top:script src="/cap/dwr/engine.js" />
	<top:script src="/cap/dwr/util.js" />
</head>

<style>
.top_float_right{
				margin-top: 4px;
				margin-bottom:4px;
}
</style>
<body style="overflow-y:hidden;">
<div style="padding-left:10px;">
		<div id="queryDiv">
				 <table id="select_condition">
			    	<tbody>
						<tr>
							<td class="td_label"  width="15%"><span class="hide_span">页面标题：</span></td>
							<td	width="30%"><span uitype="Input" id="keyword" maxlength="100" align="left" width="85%" readonly="false"></span></td>
							<td></td>
							<td></td>
						</tr>
					</tbody>
			    </table>
			</div>
				<div id="buttonDiv" class="top_float_right">
				<span uitype="button" id="search_btn" label="查询" on_click="search" ></span>
				<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch"></span>
				<span uitype="button" on_click="btnCheck" id="btnCheck" label="确定"></span> 
				<span uitype="button" on_click="btnClose" id="btnClose" label="关闭"></span>
			</div>
			<table uitype="Grid" id="itemGrid" adaptive="true" fixcolumnnumber="0" resizeheight="resizeHeight" titleellipsis="true" sorttype="[]" sortname="[]" 
				   resizewidth="resizeWidth" loadtip="true" colmove="false" selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="false" oddevenrow="false" pagesize="50" gridheight="500px" ellipsis="false" colhidden="false" pageno="1" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="single" datasource="initData">
			 	<tr>
						<th width="5%"></th>
						<th width="20%" sort="true" align="center" bindName="title">页面标题</th>
						<th width="35%" align="center" bindName="path">界面路径</th>
						<th width="40%" sort="true" align="center" bindName="description">描述</th>
				</tr>
			</table>
</div>
	<top:script src="/cap/dwr/interface/PageAction.js" />
<script language="javascript">
	window.onload = function(){
		comtop.UI.scan();	
	}
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){
		if(cui("#keyword").getValue()){
			query.keyword=cui("#keyword").getValue();
		}
		dwr.TOPEngine.setAsync(false);
		PageAction.queryPageList(query,function(data){
	    	tableObj.setDatasource(data.list);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
    /**
     * 按钮查询事件
     */
    function search(){
        //重新加载数据，loadData时，会重新调用initData
        cui('#itemGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
    	cui("#keyword").setValue(null)
        search();
    }

	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 28;
	}

	//grid高度
	function resizeHeight(){
		var queryDiv = $("#queryDiv");
		var buttonDiv = $("#buttonDiv");
		var existingHeight = 0;
		if(queryDiv){
			existingHeight = queryDiv[0].clientHeight;
		}
		if(buttonDiv){
			existingHeight += buttonDiv[0].clientHeight;
		}
		return (document.documentElement.clientHeight || document.body.clientHeight) - existingHeight-50;
	}
	
	//选择事件
	function btnCheck(){
		var result = true;
		if(!result && typeof(result) != "undefined"){
			return;
		}
		var selects = cui("#itemGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择数据。");
			return;
		}
		window.parent.capPageSelectCallback(selects[0].id,selects[0].title);
		btnClose(); 
	}
	
	function btnClose(){
		window.parent.capPageSelectDialog.hide(); 
	}
</script>
</body>
</html>