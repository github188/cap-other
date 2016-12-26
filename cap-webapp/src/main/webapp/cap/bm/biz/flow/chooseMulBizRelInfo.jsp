<!doctype html>
<%
  /**********************************************************************
	* 业务对象基本信息列表
	* 2015-11-10 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>业务对象基本信息列表</title>
    <top:link href="/cap/bm/common/styledefine/css/top_base.css" />
	<top:link href="/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
</head>

<style>
.top_float_right{
	margin-bottom:4px;
	margin-right:10px;
}
</style>

<body style="overflow-y:hidden;">
<div class="list_header_wrap" style="padding-left:10px;">
	<div id="queryDiv">
		 <table id="select_condition">
	    	<tbody>
				<tr>
					<td class="td_label" width="15%"><span>编码：</span></td>
					<td width="30%" ><span uitype="Input" id="code" maxlength="250" byte="true" textmode="false" width="85%" align="left" maskoptions="{}" databind="BizObjInfo.code" type="text" readonly="false"></span></td>
					<td class="td_label" width="15%"><span>名称：</span></td>
					<td width="30%" ><span uitype="Input" id="name" maxlength="200" byte="true" textmode="false" width="85%" align="left" maskoptions="{}" databind="BizObjInfo.name" type="text" readonly="false"></span></td>
				</tr>
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td>
						<div class="top_float_left">
							<span uitype="button" id="search_btn" label="查询" on_click="search" button_type="green-button" icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/search.gif"></span>
							<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch" button_type="orange-button" icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/clear.gif"></span>
						</div>
					</td>
				</tr>
			</tbody>
	    </table>
	</div>

	
	<div id="buttonDiv" class="top_float_right">
		<span uitype="button" on_click="btnCheck" label="确定" id="btn_Check"></span> 
		<span uitype="button" on_click="btnClose" label="关闭" id="btn_Close"></span>
	</div>
		<table uitype="Grid" id="BizRelInfoGrid" pagesize="50" gridheight="500px" ellipsis="true" colhidden="true" pageno="1" colmaxheight="auto" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="single" datasource="initData" fixcolumnnumber="0" adaptive="true" titleellipsis="true" resizeheight="resizeHeight" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" selectedrowclass="selected_row" colmove="false" primarykey="id" onstatuschange="onstatuschange" pagination="false" oddevenrow="false">
		 	<tr>
				<th style="width:30px"><input type="checkbox"/></th>
				<th bindName="code" renderStyle="text-align: center;">编码</th>
				<th bindName="name" renderStyle="text-align: center;">名称</th>
				<th bindName="relType" renderStyle="text-align: center;" >关联类型</th>
			</tr>
		</table>
</div>
 
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" />
	<top:script src="/cap/bm/common/cui/js/cui.utils.js" />
    <top:script src="/top/js/jquery.js"/>
	<top:script src="/cap/dwr/engine.js"/>
	<top:script src="/cap/dwr/util.js"/>
	<top:script src="/cap/dwr/interface/BizRelInfoAction.js"/>
<script language="javascript">
	var BizObjInfo = {};
	var domainId = "${param.domainId}";//业务域ID 
	window.onload = function(){
		comtop.UI.scan();
		if (domainId && domainId!=null && domainId!=""){
			initDomainData(domainId);
		}
	}
	
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){	
		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		BizRelInfoAction.queryBizRelInfoList(query,function(data){
			dataCount = data.count;
		    tableObj.setDatasource(data.list, data.count);
		    maxSortNo = dataCount;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//确定返回
	function btnCheck(){
		var selects = cui("#BizRelInfoGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择数据。");
			return;
		}	
		window.parent.chooseBizRelInfoCallback(selects);
		btnClose();
	}
		
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(BizObjInfo).databind().getValue();
        //设置Grid的查询条件
        cui('#BizRelInfoGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#BizRelInfoGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
        cui(BizObjInfo).databind().setEmpty();
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
		return (document.documentElement.clientHeight || document.body.clientHeight) - existingHeight-10;
	}
	
	function btnClose(){
		window.parent.dialog.hide();
	}

</script>
<top:script src="/cap/bm/biz/info/js/BizObjInfo.js"/>
</body>
</html>