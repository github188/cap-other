<%
/**********************************************************************
* 元数据建模：实体方法列表
* 2014-8-7 沈康 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>实体列表页</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script> 
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	
	<style type="text/css">
		#showAllCheckBox {
			vertical-align: middle;
		}
		
		th{
		    font-weight: bold;
		    font-size:14px;
		}
	</style>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left">
		<div class="thw_title" style="margin-left:11px;margin-top:0px;">
			<font id="pageTittle" class="fontTitle">请选择</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="确定" id="button_add" on_click="ensure"></span>
		<span uitype="button" label="取消" id="button_add" onClick="window.close()"></span>
	</div>
</div>
<br>
<div id="singleGrid">
 <table uitype="Grid" id="EntityGrid" primarykey="modelId" datasource="initData" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight" selectrows="single">
 	<thead>
	 	<tr>
			<th style="width:50px"></th>
			<th bindName="engName"  renderStyle="text-align: left;" >实体名称</th>
			<th bindName="chName"  renderStyle="text-align: left;" >中文名称</th>
			<th bindName="dbObjectName"  renderStyle="text-align: center">对应表</th>
		</tr>
	</thead>
</table>
</div>
<div id="multiGrid">
	 <table uitype="Grid" id="EntityMultiGrid" primarykey="modelId" datasource="initData" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight" selectrows="multi">
	 	<thead>
		 	<tr>
				<th style="width:50px"><input type="checkbox" /></th>
				<th bindName="engName"  renderStyle="text-align: left;" >实体名称</th>
				<th bindName="chName"  renderStyle="text-align: left;" >中文名称</th>
				<th bindName="dbObjectName"  renderStyle="text-align: center">对应表</th>
			</tr>
		</thead>
</table>
</div>

<script language="javascript"> 
	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	var callBackMethod = "${param.callBackMethod}";
	var selectType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectType"))%>;
	var filterEntityTypes = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("filterEntityTypes"))%>;
	window.onload = function(){
		if(selectType=='multi'){
			document.getElementById("singleGrid").style.display="none";
		}else{
			document.getElementById("multiGrid").style.display="none";
		}
 		comtop.UI.scan();
	}
	
	//grid数据源
	function initData(obj){
		dwr.TOPEngine.setAsync(false);
		EntityFacade.queryEntityList(packageId,function(data){
			var datasource = [];
			if(filterEntityTypes){
				for(var i=0,len=data.length; i<len; i++){
					if(filterEntityTypes.indexOf(data[i].entityType) == -1){
						datasource.push(data[i]);
					}
				}
			} else {
				datasource = data;
			}
			obj.setDatasource(datasource, datasource.length);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//读取本实体及其所有父实体的属性
	function getSelfAndParentAttributes(modelId){
		var attributes = [];
		dwr.TOPEngine.setAsync(false);
		EntityFacade.getSelfAndParentAttributes(modelId,function(data){
			attributes = data;
		});
		dwr.TOPEngine.setAsync(true);
		return attributes;
	}
	
	//确认选择
	function ensure() {
 		var selects = null;
 		if(selectType=='multi'){
 			selects = cui("#EntityMultiGrid").getSelectedRowData();
 		}else{
 			selects = cui("#EntityGrid").getSelectedRowData();
 		}
 		
		if(selects != null ){
	 		if(selectType=='multi'){
	 			callBackMethod = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("callBackMethod"))%>;
				var callback = callBackMethod != '' ? callBackMethod : 'importEntityCallBack';
				window.opener[callback](selects);
	    		window.close();
	 		}else if(selectType != 'multi' && selects.length == 1){
	 			var callback = callBackMethod != '' ? callBackMethod : 'importEntityCallBack';
				selects[0].attributes = getSelfAndParentAttributes(selects[0].modelId);
				window.opener[callback](selects[0]);
	    		window.close();
	 		}else {
				cui.alert("请选择一个实体。");
			}
		}else {
			cui.alert("请选择一个实体。");
		}
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
	}
 </script>
</body>
</html>