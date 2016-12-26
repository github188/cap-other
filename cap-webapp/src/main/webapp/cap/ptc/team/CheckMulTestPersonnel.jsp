<!doctype html>
<%
  /**********************************************************************
	* 人员基本信息列表
	* 2015-10-10 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>人员基本信息列表</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/styledefine/css/top_base.css" type="text/css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js"></script>	
	<style type="text/css">
		th{
		    font-weight: bold;
		    font-size:14px;
		}
		.fontTitle{
		    font-weight: bold;
		    font-size:16px;
		}
		
	</style>
</head>
<body style="overflow-y:hidden;">
		<div class="list_header_wrap">
			<div class="top_float_left">
				<span id="teamId" uitype="PullDown" mode="Single" value_field="id" label_field="text" 
						databind="Employee.teamId" on_change="changeTeam" datasource="initTeamData"></span>
				<span uitype="ClickInput" id="keywords"  name="keywords" emptytext="请输入人员姓名"  on_iconclick="search"  icon="search" enterable="true" 
						style="text-align:left;" editable="true" databind="Employee.keywords" width="250" on_keydown="keyDownQuery"></span>
			</div>
			<div class="top_float_right">
				<span uitype="button" on_click="btnCheck" id="btnCheck" hide="false" button_type="green-button" disable="false" label="确定"></span> 
				<span uitype="button" on_click="btnClose" id="btnClose" hide="false" button_type="" disable="false" label="关闭"></span>	
			</div>
		</div>
		<table uitype="Grid" id="EmployeeGrid" adaptive="true" fixcolumnnumber="0" resizeheight="resizeHeight" titleellipsis="true" resizewidth="resizeWidth" loadtip="true" colmove="false" 
				selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="false" oddevenrow="false" pagesize="50" 
				gridheight="500px" ellipsis="true" colhidden="false" pageno="1" gridwidth="600px" pagination_model="pagination_min_1" config="config" 
				oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initData">
			 	<tr>
					<th style="width:30px"></th>
					<th bindName="employeeName" sort="true" renderStyle="text-align: center;">人员姓名</th>
					<th bindName="employeeAccount" sort="true" renderStyle="text-align: center;">人员账号</th>
				</tr>
		</table>
 
	<top:script src="/cap/common/cui/js/cui.extend.dictionary.js" />
	<top:script src="/cap/common/cui/js/cui.utils.js" />
    <top:script src="/top/js/jquery.js"/>
	<top:script src="/cap/dwr/engine.js"/>
	<top:script src="/cap/dwr/util.js"/>
	<top:script src="/cap/dwr/interface/CapEmployeeAction.js"/>
	<top:script src="/cap/dwr/interface/TeamAction.js"/>
	<top:script src="/cap/dwr/interface/CapAppAction.js"/>
<script language="javascript">
	var fromAppDetailPage=true;
	var Employee = {};
	var appId = "<c:out value='${param.appId}'/>";
	var assignAppEmployeeArray={};
	var teamId = "<c:out value='${param.teamId}'/>";//一个人可能在多个团队
	var employeeData;
	
	
	window.onload = function(){
		comtop.UI.scan();		
		if(teamId){
			cui("#teamId").setValue(teamId);
		}
		selectRowsForApp(employeeData);
	}
	
	//所属团队 
	function initTeamData(obj){
		var testTeamList;
		dwr.TOPEngine.setAsync(false);
		TeamAction.queryTestTeamList(function(data){
			testTeamList = data.list;
			var jsonData = new Array();
			for(var i=0; i < testTeamList.length; i++){
				var arr  = {
						"id" : testTeamList[i].id,         
						"text" : testTeamList[i].teamName     
						};
				jsonData.push(arr);
			}
			obj.setDatasource(jsonData);
		});
		dwr.TOPEngine.setAsync(true);
		if(teamId){
			addIndexOfMethod();
			for(var i=0; i < testTeamList.length; i++){
				if(teamId.indexOf(testTeamList[i].id) > -1){
					cui("#teamId").setValue(testTeamList[i].id);
					search();
					break;
				}
			}
		}
	}
	//grid数据源
	function initData(tableObj,query){
		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		CapEmployeeAction.queryTestEmployeeListNoPage(query,function(data){
		    tableObj.setDatasource(data);
		    employeeData=data;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//查询应用已分配的人员
	function initAppAssignEmployee(){
		dwr.TOPEngine.setAsync(false);
		var getTeamId=cui("#teamId").getValue();
		CapAppAction.queryEmployeeListByAppId(appId,getTeamId,function(data){
			assignAppEmployeeArray = data;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//勾选已分配的人员
	function selectRowsForApp(data){
		var array = new Array();
		if(appId){
			initAppAssignEmployee();
		}
		if(assignAppEmployeeArray.length) {
			for(var i=0;i<data.length;i++){
				for(var j=0;j<assignAppEmployeeArray.length;j++){
					if(data[i].id == assignAppEmployeeArray[j].id){
						array.push(data[i].id);
					}
				}
			}	
		}
		
		cui("#EmployeeGrid").selectRowsByPK(array);
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
	
	/**切换团队 */
	function changeTeam(){
		cui("#keywords").setValue("");
		search();
	}
		
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(Employee).databind().getValue();
        data.keywords = cui("#keywords").getValue();
        //设置Grid的查询条件
        cui('#EmployeeGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#EmployeeGrid').loadData();
        selectRowsForApp(employeeData);
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
		return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
	}
	
	//选择事件
	function btnCheck(){
		var result = true;
		if(!result && typeof(result) != "undefined"){
			return;
		}
		var selects = cui("#EmployeeGrid").getSelectedRowData();
		var teamId = cui("#teamId").getValue();
		window.parent.chooseEmployee(selects,teamId);
		btnClose();
	}
	
	function btnClose(){
		window.parent.dialog.hide(); 
	}
	
	function addIndexOfMethod(){
		if (!Array.prototype.indexOf){
		  	Array.prototype.indexOf = function(elt){
			    var len = this.length >>> 0;
			    var from = Number(arguments[1]) || 0;
			    from = (from < 0)? Math.ceil(from): Math.floor(from);
			    if (from < 0){
				      from += len;
			    }
			    for(; from < len; from++){
			      if (from in this && this[from] === elt){
				        return from;
			      }
			    }
			    return -1;
		  	};
		}
	}
	
	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode === 13) {
			search();
		}
	}
</script>
</body>
</html>