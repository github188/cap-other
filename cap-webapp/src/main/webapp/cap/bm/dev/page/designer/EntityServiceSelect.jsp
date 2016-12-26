<%
/**********************************************************************
* 实体服务方法选择
* 2015-6-29 龚斌 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>实体方法列表页</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
   <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script> 
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	
	<script language="javascript"> 
		var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var isGenerateParameterForm=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("isGenerateParameterForm"))%>;
		var isTree=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("isTree"))%>;
		var actionReLoadMethodName=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("actionReLoadMethodName"))%>;
		var propertyName=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("propertyName"))%>;

		var selEntityVO; //选中的实体对象
		var selectedModelId;
		
		window.onload = function(){
			comtop.UI.scan();
		}
		
		/**
		 * 获取当前模块下的所有实体
		 *
		 * @param <code>tableObj</code>grid对象 <code>query</code>查询条件
		 */
		function initEntityData(tableObj,query){
			dwr.TOPEngine.setAsync(false);
			EntityFacade.queryEntityList(packageId,function(data){
				if(data && data.length > 0) {					
				    tableObj.setDatasource(data, data.length);
				    selEntityVO = data[0];
				    selectedModelId = selEntityVO.modelId;
				    tableObj.setHighLight(selEntityVO.modelId, true);
				}else {
					tableObj.setDatasource([], 0);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		/**
		 * 获取当前实体以及当前实体的所有父实体的所有方法集合
		 * 
		 * @param <code>tableObj</code>grid对象 <code>query</code>查询条件
		 */
		function initServiceData(tableObj,query){
			dwr.TOPEngine.setAsync(false);
			EntityFacade.getSelfAndParentMethods(selEntityVO.modelId,function(data){		
				if(data && data.length > 0) {					
				    tableObj.setDatasource(data, data.length);
				}else {
					tableObj.setDatasource([], 0);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//确定
		function selectConfirm(){
			var selectData = cui("#ServiceGrid").getSelectedRowData();
			if(selectData && selectData.length == 1){
				var res = selectData[0];
				res.entity = selEntityVO;
				window.opener.entityServiceSelectCallBack(res,isGenerateParameterForm,isTree,actionReLoadMethodName,propertyName);
				window.close();
			}else{
				cui.alert("请选择数据。");
			}
		}
		
		//grid列渲染
		function returnTypeRender(rd, index, col) {
			return rd.returnType.type;
		}
		
		//grid参数类型列渲染
		function parameterRender(rd, index, col) {
			var objParameters = rd.parameters;
			var renderReturnStr = "";
			if(objParameters && objParameters.length && objParameters.length > 0) {
				for(var i = 0 ; i < objParameters.length; i++) {
					if(i != 0) {
						renderReturnStr += ","
					}
					renderReturnStr += objParameters[i].dataType.type;
				}
			}
			return renderReturnStr;
		}
		
		//方法grid 宽度
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth) * 0.74;
		}
		
		//方法grid 高度
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
		}
		
		//实体grid 宽度
		function resizeEntityGridWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth) * 0.23;
		}
		
		//实体grid 高度
		function resizeEntityGridHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
		}
		
		//实体grid名称列渲染
		function entityNameRender(rd, index, col) {
			return rd['chName'] + "("+rd['engName'] + ")";
		}
		
		//点击实体grid的行
		function rowClick(rd, isChecked, index) {
			refreshHighLight(rd);
			dwr.TOPEngine.setAsync(false);
			EntityFacade.getSelfAndParentMethods(selEntityVO.modelId,function(data){		
				if(data && data.length > 0) {
					//过滤掉查询重写方法
					var afterFilterData = filterData(data);
					cui("#ServiceGrid").setDatasource(afterFilterData, afterFilterData.length);
				}else {
					cui("#ServiceGrid").setDatasource([], 0);
				}
			});
			dwr.TOPEngine.setAsync(true);
			
		}
		
		//设置实体GRID的高亮
		function refreshHighLight(rd) {
			selEntityVO = rd;
			var arr = cui("#EntityGrid").getData();
			var key;
			for(var i=0;i<arr.length;i++){
				key = arr[i].modelId;
				if(key==selEntityVO.modelId){
					cui("#EntityGrid").setHighLight(key, true);
					selectedModelId =key;
				}else{
					cui("#EntityGrid").setHighLight(key, false);
				}
			}
		}

		//过滤掉查询重写方法
		function filterData(data){
			var afterFilterData = [];
			for(var i=0;i<data.length;i++){
				if(data[i]["methodType"]!="queryExtend"){
					afterFilterData.push(data[i]);
				}
			}
			return afterFilterData;
		}

        //回车过滤条件
		function keyDown(e){
			var ev= window.event||e;
			//13是键盘上面固定的回车键
			if (ev.keyCode == 13) {
				  searchAction();
			}
		}

        //实体过滤查询
		function searchAction(){
			if(!selectedModelId)
				return;

			var filter = cui("#entityFilter").getValue();
			dwr.TOPEngine.setAsync(false);
			EntityFacade.filterMethods(selectedModelId, filter, function(data) {
				if (data && data.length > 0) {
					var afterFilterData = filterData(data);
					cui("#ServiceGrid").setDatasource(afterFilterData, afterFilterData.length);
				} else {
					cui("#ServiceGrid").setDatasource([], 0);
				}
			});
			dwr.TOPEngine.setAsync(true);
			
		}

	 </script>
</head>
<body>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<font id="pageTittle" class="fontTitle">实体方法列表</font> 
		        	<span id="entityFilter" style="padding-left:130px;" uitype="ClickInput" emptytext="请输入方法名称/中文名称" on_iconclick="searchAction" onkeydown="keyDown(event)" icon="search" iconwidth="18px" editable="true" width="229"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="code" uitype="Button" label="确定" onClick="selectConfirm()"></span>
					<span id="code" uitype="Button" label="关闭" onClick="window.close()"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
			<tr>
				<td class="cap-td" style="text-align: left" valign="top" >
					 <table uitype="grid" id="EntityGrid" primarykey="modelId" datasource="initEntityData" pagination="false"  
					    selectrows="no"  resizewidth="resizeEntityGridWidth" resizeheight="resizeEntityGridHeight" rowclick_callback="rowClick">
					 	<thead>
						 	<tr>
								<th align="center" renderStyle="text-align: left;cursor:pointer;" render="entityNameRender">实体名称</th>
							</tr>
						</thead>
					</table>
				</td>
				<td class="cap-td"  style="text-align: left;vertical-align: top" width="80%">
					 <table uitype="grid" id="ServiceGrid" primarykey="methodId" pagination="false" datasource="initServiceData"
					 	 selectRows="single"  resizewidth="resizeWidth" resizeheight="resizeHeight">
					 	<thead>
						 	<tr>
								<th style="width:50px"></th>
								<th align="center" bindName="engName" style="width:20%;" renderStyle="text-align: left;">方法名称</th>
								<th align="center" bindName="aliasName" style="width:20%;" renderStyle="text-align: left;">方法别名</th>
								<th align="center" bindName="chName" style="width:20%;" renderStyle="text-align: left;" >中文名称</th>
								<th align="center" bindName="returnType" style="width:20%;" renderStyle="text-align: center"  render="returnTypeRender">返回值</th>
								<th align="center" bindName="parameters" style="width:20%;" renderStyle="text-align: center" render="parameterRender">参数类型</th>
							</tr>
						</thead>
					</table>
				</td>
			</tr>
		</table>
</body>
</html>