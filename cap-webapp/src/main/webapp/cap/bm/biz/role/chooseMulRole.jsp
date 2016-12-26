<!doctype html>
<%
  /**********************************************************************
	* 角色单选界面
	* 2015-11-17 CAP 新增
  **********************************************************************/
%>    
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>角色基本信息列表</title>
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
.btn-more:hover { color: #1c0ba1; background-color: #c0cef5;}
.btn-more {border: 1px solid #C4D5E9;background-color: #EBF0F5;color: #2164A1;padding: 0 4px;height: 24px;line-height: 24px;margin: 1px 5px 3px 0;cursor: pointer;border-radius: 4px;float: right;font-size : 12px;}
</style>
<body style="overflow-y:hidden;">
<div class="list_header_wrap" style="padding-left:10px;">
		<div id="queryDiv">
				 <table id="select_condition">
			    	<tbody>
						<tr>
							<td class="td_label"  width="15%"><span class="hide_span">编码/名称：</span></td>
							<td	width="30%"><span uitype="Input" id="keyWords" maxlength="100" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="roleInfo.keyWords" type="text" readonly="false"></span></td>
							<td class="td_label"  width="15%"><span class="hide_span">所属业务域：</span></td>
							<td	width="30%"><span id="domainId" uitype="ClickInput"  on_change="search" icon="th-list" on_iconclick="chooseDomain" databind="roleInfo.domain"></span></td>
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
			<table uitype="Grid" id="RoleGrid" adaptive="true" fixcolumnnumber="0" resizeheight="resizeHeight" titleellipsis="true" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" colmove="false" selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="true" oddevenrow="false" pagesize="50" gridheight="500px" ellipsis="true" colhidden="false" pageno="1" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initData">
			 	<tr>
					<th style="width:30px"></th>
					<th width="20%" align="center" bindName="roleCode">编码</th>
					<th width="20%" align="center" bindName="roleName">名称</th>
					<th width="15%" align="center" bindName="shortName">简称</th>
					<th width="35%" align="center" bindName="remark">备注/职责</th>
				</tr>
			</table>
</div>
	<top:script src="/cap/dwr/interface/BizRoleAction.js" />
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<script language="javascript">
	var roleVO = {};
	var domainId = "<c:out value='${param.domainId}'/>";
	var roleIds = parent.roleIds;
	window.onload = function(){
		comtop.UI.scan();	
		if(domainId){
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.queryDomainById(domainId,function(data){
				cui("#domainId").setValue(data.name);
			});
			dwr.TOPEngine.setAsync(true);
			search();
		}
		//原先选中的，继续默认选中
		if(roleIds){
			var ids  = [];
			ids = roleIds.split(",");
			for(var i=0;i<ids.length;i++){
				cui("#RoleGrid").selectRowsByPK(ids[i], true);
			}
		}
	}
	
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){
		dwr.TOPEngine.setAsync(false);
		BizRoleAction.queryRoleList(query,function(data){
			dataCount = data.count;
		    tableObj.setDatasource(data.list, data.count);
		    maxSortNo = dataCount;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(roleInfo).databind().getValue();
        if(domainId){
        	data.domainId=domainId;
        }
        //设置Grid的查询条件
        cui('#RoleGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#RoleGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
        cui(roleInfo).databind().setEmpty();
        domainId=null;
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
		return (document.documentElement.clientHeight || document.body.clientHeight) - existingHeight-50;
	}
	
	//选择事件
	function btnCheck(){
		var result = true;
		if(!result && typeof(result) != "undefined"){
			return;
		}
		var selects = cui("#RoleGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择数据。");
			return;
		}
		window.parent.chooseRole(selects);
		btnClose(); 
	}
	
	function btnClose(){
		window.parent.dialog.hide(); 
	}
	
	function chooseDomain(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/domain/jsp/DomainTree.jsp?selectDomainId="+domainId;
		var title="选择业务域";
		var height = 400;
		var width =  300;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	function chooseDomainCallback(id,name){
		cui("#domainId").setValue(name);
		domainId=id;
		search();
	}
</script>
</body>
</html>