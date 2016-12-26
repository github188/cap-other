<!doctype html>
<%
  /**********************************************************************
	* 人员基本信息列表
	* 2015-10-10 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>人员基本信息列表</title>
    <top:link href="/cap/bm/common/styledefine/css/top_base.css" />
	<top:link href="/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
</head>

<style>
.btn-more:hover { color: #1c0ba1; background-color: #c0cef5;}
.btn-more {border: 1px solid #C4D5E9;background-color: #EBF0F5;color: #2164A1;padding: 0 4px;height: 24px;line-height: 24px;margin: 1px 5px 3px 0;cursor: pointer;border-radius: 4px;float: right;font-size : 12px;}
</style>
<body style="overflow-y:hidden;">
<div class="list_header_wrap" style="padding-left:10px;">
		<div id="queryDiv">
				 <table id="select_condition">
			    	<tbody>
						<tr>
							<td class="td_label"  width="15%"><span class="hide_span">账号/姓名：</span></td>
							<td	width="30%"><span class="hide_span"><span uitype="Input" id="keywords" maxlength="10" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="Employee.keywords" type="text" readonly="false"></span></span></td>
							<td class="td_label"  width="15%"><span class="hide_span">所属团队：</span></td>
							<td	width="30%"><span id="teamId" uitype="PullDown" mode="Single" value="'<c:out value='${param.teamId}'/>'" value_field="id" label_field="text" databind="Employee.teamId" on_change="search" datasource="initTeamData"></span></td>
						</tr>
					</tbody>
			    </table>
			</div>
				<div id="buttonDiv" class="top_float_right">
				<span uitype="button" id="search_btn" label="查询" on_click="search" button_type="green-button" icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/search.gif"></span>
				<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch" button_type="orange-button" icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/clear.gif"></span>
				<span uitype="button" on_click="btnCheck" id="btnCheck" hide="false" button_type="blue-button" disable="false" label="确定"></span> 
				<span uitype="button" on_click="btnClose" id="btnClose" hide="false" button_type="blue-button" disable="false" label="关闭"></span>
			</div>
			<table uitype="Grid" id="EmployeeGrid" adaptive="true" fixcolumnnumber="0" resizeheight="resizeHeight" titleellipsis="true" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" colmove="false" selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="false" oddevenrow="false" pagesize="50" gridheight="500px" ellipsis="true" colhidden="false" pageno="1" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="single" datasource="initData">
			 	<tr>
					<th style="width:30px"></th>
					<th bindName="employeeAccount" sort="true" renderStyle="text-align: center;">人员账号</th>
					<th bindName="employeeName" sort="true" renderStyle="text-align: center;">人员姓名</th>
				</tr>
			</table>
</div>
 
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" />
	<top:script src="/cap/bm/common/cui/js/cui.utils.js" />
    <top:script src="/top/js/jquery.js"/>
	<top:script src="/cap/dwr/engine.js"/>
	<top:script src="/cap/dwr/util.js"/>
	<top:script src="/cap/dwr/interface/CapEmployeeAction.js"/>
	<top:script src="/cap/dwr/interface/TeamAction.js"/>
<script language="javascript">
	var Employee = {};
	var teamId = "<c:out value='${param.teamId}'/>";
	window.onload = function(){
		comtop.UI.scan();	
		if(teamId){
			cui("#teamId").setValue(teamId);
			search();
		}
	}
	
	function initTeamData(obj){
		dwr.TOPEngine.setAsync(false);
		TeamAction.queryTeamList(function(data){
			var initData = data.list;
			var jsonData = new Array();
			for(var i=0; i < initData.length; i++){
				var arr  = {
						"id" : initData[i].id,         
						"text" : initData[i].teamName     
						};
				jsonData.push(arr);
			}
			obj.setDatasource(jsonData);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){
		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		CapEmployeeAction.queryEmployeeList(query,function(data){
		    tableObj.setDatasource(data.list);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	/**
     * 配合下一个方法config做列宽的持久化
     */
	function onstatuschange(config){
		var seesionUrl = window.location.pathname + 'Employee';
		cui.utils.setCookie(seesionUrl,config,new Date(2100,10,10).toGMTString(), '/');
	}
	
	/**
     * 配合下一个方法onstatuschange做列宽的持久化
     */
	function config(obj){
		var seesionUrl = window.location.pathname +'Employee';
		obj.setConfig(cui.utils.getCookie(seesionUrl));
	}
		
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(Employee).databind().getValue();
        //设置Grid的查询条件
        cui('#EmployeeGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#EmployeeGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
        cui(Employee).databind().setEmpty();
        search();
    }

	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
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
		return (document.documentElement.clientHeight || document.body.clientHeight) - existingHeight;
	}
	
	//选择事件
	function btnCheck(){
		var result = true;
		if(!result && typeof(result) != "undefined"){
			return;
		}
		var selects = cui("#EmployeeGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择数据。");
			return;
		}
		window.parent.chooseEmployee(selects);
		window.parent.dialog.hide(); 
	}
	
	function btnClose(){
		window.parent.dialog.hide(); 
	}
</script>
</body>
</html>