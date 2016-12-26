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
.top_float_right{
				margin-right:10px;
				margin-top:4px;
				margin-bottom:4px;
}
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
							<td	width="30%"><span id="team" uitype="PullDown" mode="Single" value="'<c:out value='${param.teamId}'/>'" value_field="id" label_field="text" databind="Employee.teamId" on_change="search" datasource="initTeamData"></span></td>
						</tr>
					</tbody>
			    </table>
			</div>
				<div id="buttonDiv" class="top_float_right">
				<span uitype="button" id="search_btn" label="查询" on_click="search" button_type="green-button" icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/search.gif"></span>
				<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch" button_type="orange-button" icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/clear.gif"></span>
				<span uitype="button" id="btnPersonAdd" label="新增" on_click="addEmployee" button_type="green-button"></span> 
				<span uitype="button" id="btnPersonDel" label="删除" on_click="delEmployee" button_type="green-button"></span>
			</div>
			<table uitype="Grid" id="EmployeeGrid" adaptive="true" fixcolumnnumber="0" resizeheight="resizeHeight" titleellipsis="true" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" colmove="false" selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="true" oddevenrow="false" pagesize="50" gridheight="500px" ellipsis="true" colhidden="false" pageno="1" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initData" sorttype="DESC" sortname="ctd">
			 	<thead>
			 	<tr>
					<th style="width: 5%"></th>
					<th style="width: 15%" sort="true" bindName="employeeName" render="editEmployeeInfo" renderStyle="text-align: center;">人员姓名</th>
					<th style="width: 35%" sort="true" bindName="employeeAccount" renderStyle="text-align: center;">人员账号</th>
					<th style="width: 5%"  sort="true" bindName="sex"  render="sexSet" renderStyle="text-align: center;">性别</th>
					<th style="width: 25%" sort="true" bindName="mobilePhone"  renderStyle="text-align: center;">联系电话</th>
					<th style="width: 15%" sort="true" bindName="cdt"  format="yyyy-MM-dd hh:mm" renderStyle="text-align: center;">创建时间</th>
				</tr>
				<thead>
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
	var teamId = "${param.teamId}";
	window.onload = function(){
		comtop.UI.scan();	
		if(teamId){
			cui("#team").setValue(teamId);
			search();
		}
	}
	//团队下拉列表加载
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
			dataCount = data.count;
		    tableObj.setDatasource(data.list,dataCount);
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
	//性别行渲染 
	function sexSet(rd, index, col) {
		if(rd["sex"]==1){
			return "男";
		}
		return "女";
	}
	
	//新增人员方法事件 
	function addEmployee(){
		var pageId="EmployeeEdit";
		var title="人员新增";
		var url = "EmployeeEdit.jsp";
		var height = 500; //600
		var width =  810; // 680;
		
		dialog = cui.dialog({
			id:pageId,
			title : title,
			src : url,
			width : width,
			page_scroll : true,
			height : height
		})
		dialog.show(url);
	}
	//删除人员 
	function delEmployee(){
		var selects = cui("#EmployeeGrid").getSelectedRowData();
		if(selects != null && selects.length > 0){
			cui.confirm("确定要删除这"+selects.length+"个人员吗？",{
				onYes:function(){
					dwr.TOPEngine.setAsync(false);
					CapEmployeeAction.deleteEmployeeList(selects);
					dwr.TOPEngine.setAsync(true);
					cui("#EmployeeGrid").loadData();
					cui.message('删除成功。','success');
				}
			});
		}else {
			cui.alert("请选择需要删除的人员。");
		}
	}
	//新增后刷新页面 
	function reflesh(EmployeeVO){
		cui("#EmployeeGrid").loadData();
		cui("#EmployeeGrid").selectRowsByPK(EmployeeVO.id);
	}
	
	//名称行渲染（点击进入编辑界面）
	function editEmployeeInfo(rd,index,col){
		return "<a href='javascript:;' onclick='edit(\"" +rd.id+"\");'>" + HTMLEnCode(rd[col.bindName]) + "</a>";
		
	}
	
	//点击grid名称行事件
	function edit(id){
		var pageId="RoleSelection";
    	var rd = cui("#EmployeeGrid").getRowsDataByPK(id)[0];
    	var title="人员编辑";
		var url = "EmployeeEdit.jsp?EmployeelId="+rd.id;
		var height = 500; //600
		var width =  810; // 680;
		
		dialog = cui.dialog({
			id:pageId,
			title : title,
			src : url,
			width : width,
			page_scroll : true,
			height : height
		})
		dialog.show(url);
    }
</script>
</body>
</html>