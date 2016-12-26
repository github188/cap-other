<!doctype html>
<%
  /**********************************************************************
	* 业务表单
	* 2015-11-24 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>业务表单</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
</head>

<style>
.btn-more:hover { color: #1c0ba1; background-color: #c0cef5;}
.btn-more {border: 1px solid #C4D5E9;background-color: #EBF0F5;color: #2164A1;padding: 0 4px;height: 24px;line-height: 24px;margin: 1px 5px 3px 0;cursor: pointer;border-radius: 4px;float: right;font-size : 12px;}
.divTreeBtn {
		margin-right :12px;
		margin-top:4px;
		margin-bottom:4px;
	    float:right;
}
</style>

<body style="overflow-y:hidden;">
<div class="list_header_wrap" style="padding-left:10px;">
	<div id="queryDiv">
		 <table id="select_condition">
	    	<tbody>
			</tbody>
	    </table>
	</div>
	<div id="buttonDiv" class="divTreeBtn">
			<span uitype="button" on_click="btnImport" id="btnImport" hide="false" button_type="blue-button" disable="false" label="导入"></span> 
		<span uitype="button" on_click="btnDelete" id="btnDelete" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/delete_white.gif" hide="false" button_type="blue-button" disable="false" label="删除"></span> 
		<span uitype="button" on_click="btnClose" id="btnClose" hide="false" button_type="blue-button" disable="false" label="关闭"></span>
	</div>
			<table uitype="Grid" id="BizFormNodeRelGrid" pagesize="50" gridheight="500px" ellipsis="true" colhidden="true" pageno="1" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initData" fixcolumnnumber="0" adaptive="true" resizeheight="resizeHeight" titleellipsis="true" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" colmove="false" selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="true" oddevenrow="false">
			 	<thead>
				 	<tr>
						<th style="width:30px"><input type="checkbox"/></th>
						<th bindName="code" sort ="true" render="" renderStyle="text-align: center;">表单编码</th>
						<th bindName="name" sort ="true" render="" renderStyle="text-align: left;">表单名称</th>
						<th bindName="remark" sort ="true" render="" renderStyle="text-align: left;">说明</th>
					</tr>
				</thead>
			</table>
</div>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" />
	<top:script src="/cap/bm/common/cui/js/cui.utils.js" />
    <top:script src="/top/js/jquery.js"/>
	<top:script src="/cap/dwr/engine.js"/>
	<top:script src="/cap/dwr/util.js"/>
	<top:script src="/cap/dwr/interface/BizFormNodeRelAction.js"/>

<script language="javascript">
	var BizFormNodeRel = {};
	var domainId = "${param.domainId}";
	var BizProcessnodeId = "${param.BizProcessnodeId}";
	window.onload = function(){
		comtop.UI.scan();		
	}
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){	
		if (typeof(beforeInitData) == "function") {
			eval("beforeInitData(tableObj,query)");
		}

		if (typeof(myBeforeInitData) == "function") {
			eval("myBeforeInitData(tableObj,query)");
		}
		if(query.nodeId!="" && query.nodeId !=null){
			query.sortFieldName = query.sortName[0];
			query.sortType = query.sortType[0];
			dwr.TOPEngine.setAsync(false);
			BizFormNodeRelAction.queryBizFormNodeRelList(query,function(data){
				dataCount = data.count;
			    tableObj.setDatasource(data.list, data.count);
			    maxSortNo = dataCount;
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			 tableObj.setDatasource([], 0);
		}
		if (typeof(myAfterInitData) == "function") {
			eval("myAfterInitData(tableObj,query)");
		}
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
     * 配合下一个方法config做列宽的持久化
     */
	function onstatuschange(config){
		var seesionUrl = window.location.pathname + 'BizFormNodeRel';
		cui.utils.setCookie(seesionUrl,config,new Date(2100,10,10).toGMTString(), '/');
	}
	
	/**
     * 配合下一个方法onstatuschange做列宽的持久化
     */
	function config(obj){
		var seesionUrl = window.location.pathname +'BizFormNodeRel';
		obj.setConfig(cui.utils.getCookie(seesionUrl));
	}
		
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(BizFormNodeRel).databind().getValue();
        //设置Grid的查询条件
        cui('#BizFormNodeRelGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#BizFormNodeRelGrid').loadData();
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
	
	
	//列表初始化前处理事件
	function beforeInitData(tableObj,query){
		if(BizProcessnodeId!=null && BizProcessnodeId !=""){
			query.nodeId = BizProcessnodeId;
		}
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

		var result = true;
		if (typeof(myBeforeDelete) == "function") {
			result = eval("myBeforeDelete()");
		}
		if(!result && typeof(result) != "undefined"){
			return;
		}

		var selects = cui("#BizFormNodeRelGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}	
		cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				BizFormNodeRelAction.deleteBizFormNodeRelList(cui("#BizFormNodeRelGrid").getSelectedRowData(),function(msg){
				 	cui("#BizFormNodeRelGrid").loadData();
				 	cui.message("删除成功！","success");
				 	});
				dwr.TOPEngine.setAsync(true);
			}
		});

		if (typeof(myAfterDelete) == "function") {
			eval("myAfterDelete()");
		}

	}
	
	//弹出表单数据
	function btnImport(){
		var title="业务表单选择";
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/form/chooseMulForm.jsp?domainId="+domainId;
		var height = 800; //600
		var width =  1000; // 680;
		var y =0; 
		var x = (document.body.clientWidth-width)/2; 
		dialog = cui.dialog({
			title:title,
			src : url,
			top : y,
			left : x,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//选择表单数据
	function chooseFormCallback(selects){
		var allData = new Array();
		allData = getArray(selects);
		if(allData == 0){
			cui.alert("选择的数据项已经导入。");
			return;
		}
		var flag=false;
		dwr.TOPEngine.setAsync(false);
		BizFormNodeRelAction.saveBizFormNodeReltList(allData, function(bResult){
			flag=bResult;
		});
		dwr.TOPEngine.setAsync(true);
		if(flag){
			cui.message('导入成功。','success');
			search();
		}
		
	}
	
	//解析是否有重复
	function getArray(selects){
		var RelLst =[];
		RelLst = cui("#BizFormNodeRelGrid").getData();
		var BizFormNodeRelLst = new Array();
		for(var i = 0;i<selects.length;i++){
			var flag = true;
			if(RelLst.length>0){
				for(var j =0;j<RelLst.length;j++){
					if(selects[i].id == RelLst[j].formId){
						flag = false;
						break;
					}
				}
			}
			if(flag){
				var BizFormNodeRel={};
				BizFormNodeRel.formId = selects[i].id;
				BizFormNodeRel.nodeId = BizProcessnodeId;
				BizFormNodeRelLst.push(BizFormNodeRel);
			}
		}
		return BizFormNodeRelLst;
	}

	//关闭事件
	function btnClose() {
		window.parent.parent.close();
	}

</script>
</body>
</html>