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
							<td class="td_label"  width="15%"><span class="hide_span">所属业务域：</span></td>
							<td	width="30%"><span id="domainId" uitype="ClickInput"  on_change="search" icon="th-list" on_iconclick="chooseDomain"  databind="formInfo.domain"></span></td>
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
			<table uitype="Grid" id="itemGrid" adaptive="true" fixcolumnnumber="0" resizeheight="resizeHeight" titleellipsis="true" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" colmove="false" selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="false" oddevenrow="false" pagesize="50" gridheight="500px" ellipsis="false" colhidden="false" pageno="1" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initData">
			 	<tr>
						<th width="5%"></th>
						<th width="15%" sort="true" align="center" bindName="code" render="itemInfo">编码</th>
						<th width="15%" sort="true" align="center" bindName="name">名称</th>
						<th width="35%" align="center" bindName="bizDesc">业务说明</th>
						<th width="35%" align="center" bindName="managePoints">管理要点</th>
				</tr>
			</table>
</div>
	<top:script src="/cap/dwr/interface/BizItemsAction.js" />
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<script language="javascript">
	var roleVO = {};
	var domainId = "<c:out value='${param.domainId}'/>";
	var itemIdList = "<c:out value='${param.selectItemIdList}'/>";
	var selectItemIdList=itemIdList.split(",");
	var domainVO={};
	window.onload = function(){
		comtop.UI.scan();	
		if(domainId){
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.queryDomainById(domainId,function(data){
				domainVO=data;
			});
			dwr.TOPEngine.setAsync(true);
			cui("#domainId").setValue(domainVO.name);
			search();
		}
		if(selectItemIdList){
			cui('#itemGrid').selectRowsByPK(selectItemIdList);
		}
	}
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){
		dwr.TOPEngine.setAsync(false);
		BizItemsAction.queryItemsList(query,function(data){
	    	tableObj.setDatasource(data);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(formInfo).databind().getValue();
        if(domainVO){
        	data.domainId=domainVO.id;
        }
        //设置Grid的查询条件
        cui('#itemGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#itemGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
        cui(formInfo).databind().setEmpty();
        domainVO.id=null;
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
		window.parent.chooseBizItemCallback(selects);
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
		domainVO.id=id;
		domainVO.name=name;
		domainId=id;
		search();
	}
</script>
</body>
</html>