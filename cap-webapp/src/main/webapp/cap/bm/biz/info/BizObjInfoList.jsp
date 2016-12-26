<!doctype html>
<%
  /**********************************************************************
	* 业务对象多选界面
	* 2015-12-2 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<head>
    <title>流程节点信息列表</title>
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
							<td class="td_label"  width="15%"><span class="hide_span">名称：</span></td>
								<td	width="30%"><span uitype="Input" id="name" maxlength="100" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizObjInfo.name" type="text" readonly="false"></span></td>
							<td class="td_label"  width="15%"><span class="hide_span">所属业务域：</span></td>
							<td	width="30%"><span id="domainId" uitype="ClickInput"  on_change="search" icon="th-list" on_iconclick="chooseDomain" databind="BizObjInfo.domain"></span></td>
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
			<table uitype="Grid" id="BizObjInfoGrid" pagesize="50" gridheight="500px" ellipsis="true" colhidden="true" pageno="1" colmaxheight="auto" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initData" fixcolumnnumber="0" adaptive="true" titleellipsis="true" resizeheight="resizeHeight" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" colmove="false" selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="true" oddevenrow="false">
			 	<tr>
					<th width="5%" ><input type="checkbox"/></th>
					<th bindName="code" width="25%" sort="true" render="" renderStyle="text-align: center;">编码</th>
					<th bindName="name" width="25%" sort="true" render="" renderStyle="text-align: left;">名称</th>
					<th bindName="description" width="45%" sort="true"  render="" renderStyle="text-align: left;">说明</th>
				</tr>
			</table>
</div>
	<top:script src="/cap/dwr/interface/BizObjInfoAction.js"/>
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<script language="javascript">
	var id = "<c:out value='${param.id}'/>";
	var BizObjInfo = {};
	var domainId = "<c:out value='${param.domainId}'/>";
	var bizObjectIds = parent.bizObjectIds;
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
			BizObjInfo.domainId = domainId;
			search();
		}
		//原先选中的，继续默认选中
		if(bizObjectIds){
			var ids  = [];
			ids = bizObjectIds.split(",");
			for(var i=0;i<ids.length;i++){
				cui("#BizObjInfoGrid").selectRowsByPK(ids[i], true);
			}
		}
	}
	
	//grid数据源
	function initData(tableObj,query){
		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		BizObjInfoAction.queryBizObjInfoList(query,function(data){
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
        var data = cui(BizObjInfo).databind().getValue();
        if(domainVO){
        	data.domainId=domainVO.id;
        }
        //设置Grid的查询条件
        cui('#BizObjInfoGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#BizObjInfoGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
    	 cui(BizObjInfo).databind().setEmpty();
         domainVO.id=null;
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
		var selects = cui("#BizObjInfoGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择数据。");
			return;
		}
		window.parent.chooseObjInfoCallback(selects);
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
<html>