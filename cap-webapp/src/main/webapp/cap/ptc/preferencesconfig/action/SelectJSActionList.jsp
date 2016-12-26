<%
  /**********************************************************************
   * CAP自定义行为帮助
   *
   * 2016-10-31 肖威 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta charset="UTF-8">
<title>已有函数列表</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>

<style type="text/css">
.cui-tab ul.cui-tab-nav li{
	padding:0 5px;
	margin-right:5px
}
</style>


<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/dev/consistency/js/consistency.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/JSFunctionFacade.js"></top:script>
<script type="text/javascript">
		
		var compentObject = null;
		var propertyEditorUI = null;
		var selectedJS = null;
		var group = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("group"))%>;//
		/**
		* 设置grid数据源
		*
		* @param grid 表格组件对象
		* @param query Json对象：包含分页信息和题头排序信息
		*/
		function initData(grid, query) {
			dwr.TOPEngine.setAsync(false);
			
			JSFunctionFacade.loadModelByModelId(group,function(data) {
				if(data==null || data.jsFunctions==null){
					grid.setDatasource([],0);
				}
				grid.setDatasource(data.jsFunctions, data.jsFunctions.length);
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//页面装载方法
		jQuery(document).ready(function(){
			comtop.UI.scan();
			if(window.parent!=null && window.parent.scope!=null && window.parent.scope.script !=null){
				compentObject = window.parent.scope.script;
			}
			if(window.parent!=null && window.parent.scope!=null && window.parent.scope.propertyEditorUI != null){
				propertyEditorUI = window.parent.scope.propertyEditorUI;
			}
		});
		
		function resizeWidth() {
			return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
		}
		
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
		}
		
		function selectedAction(){
		   	 var gridObj = cui("#actionList");
			var selectDatas = gridObj.getSelectedRowData();
	   		if(selectDatas == null || selectDatas.length == 0){
	   			cui.alert("请选择函数。");
	   			return;
	   		}
	   		var params = selectedJS.inParams;
			var paramString="()";
	   		if(params.length > 0){
	   			paramString="(";
		   		for(var i = 0; i<params.length; i++){
		   			if(cui("#"+params[i].ename) != null){
		   				if(params[i].ename=="self"){
		   					paramString+="self"+",";
		   					continue;
		   				}
				   		var paramValue = cui("#"+params[i].ename).getValue();
				   		paramString+="\'"+paramValue+"\',";
		   			}else{
		   				paramString+="\',";
		   			}
				}
		   		if(paramString.endsWith(',')){
		   			paramString = paramString.substring(0,paramString.lastIndexOf(','));
		   		}
		   		paramString+=")";
	   		}
	   		selectedJS.functionFullName =selectedJS.functionName+ paramString;
	   		cui("#actionList").destroy();
			window.parent.fromCallBack(selectDatas);
			window.parent.selectJSActionDialog.hide();
		}
		
		function changeSelectFunction(data, checked, index){
			if(checked && data.inParams != null ){
				//getValue(id),getSelectData(nodes), selectPageData(selectData, openType,flag),
				//importDataStoreVariableCallBack(variableSelect, flag, isWrap, selectDataStoreVO),
				//generateValidate(attribute, uitype),openWindowCallback(propertyName, propertyValue),
				//setBorderlayoutItems(data,fixed), 
				selectedJS = data;
				 if(selectedJS==null || selectedJS ==""){
					return;
				}
				//id为当前控件ID
				if(data.functionFullName=="getValue(id)"){
					if(compentObject!=null){
						dataid=[{id:compentObject.id,text:compentObject.id}]
					}
				}
				//selectData是指  ， openType是指  ，flag是指
				else if(data.functionFullName=="selectPageData(selectData, openType,flag)"){
									
				}
				//variableSelect是指 ， flag是指 ，isWrap是指 ， selectDataStoreVO
				else if(data.functionFullName=="importDataStoreVariableCallBack(variableSelect, flag, isWrap, selectDataStoreVO)"){
					
				}
				//attribute是指 ， uitype是指当前控件类型
				else if(data.functionFullName=="generateValidate(attribute, uitype)"){
					if(compentObject!=null){
						dataattribute=[{id:compentObject.id,text:compentObject.id}];
						if(propertyEditorUI.componentName != null){
							datauitype=[{id:propertyEditorUI.componentName,text:propertyEditorUI.componentName}];
						}else{
							datauitype=[];
						}
							
					}
				}
				//propertyName是指 ，propertyValue是指 
				else if(data.functionFullName=="openWindowCallback(propertyName, propertyValue)"){
					
				}
				//data是指 ，fixed是指 
				else if(data.functionFullName=="setBorderlayoutItems(data,fixed)"){
					
				}else{
					if(compentObject!=null){
						dataevent=[{id:compentObject.id,text:compentObject.id}];
					}
				} 
				createTable();
			}
		}
		
		
		function createTable(){
			var trNum =  Math.ceil(selectedJS.inParams.length/2);
			if(trNum==0){
				cui("#functionParamDiv").html("<table  class='cap-table-fullWidth'></table>");
				comtop.UI.scan(document.getElementById('functionParamDiv'));
				return;
			}
			var params = selectedJS.inParams;
			for(var i = 0; i<trNum; i++){
				var trhtml = "<tr><td  class='td_label' style='text-align: right;width:auto'>参数"+params[i].ename+"：</td><td class='cap-td' style='text-align: left;'>"
					+"<span uitype='PullDown' mode='Single' id=\'"+params[i].ename+"\' datasource=\'data"+params[i].ename+"\' select='0' must_exist='false'></span>"+"</td>";
				if(i+1<params.length){
					if(params[i+1].ename=="self"){
						trhtml =trhtml+ "<td></td><td></td>";						
					}else{
						trhtml =trhtml+ "<td class='td_label' style='text-align: right;width:auto'>参数"+params[i+1].ename+"：</td><td class='cap-td' style='text-align: left;'>"
							+"<span uitype='PullDown' mode='Single' id=\'"+params[i+1].ename+"\' datasource=\'data"+params[i+1].ename+"\' select='0' must_exist='false'></span>"+"</td>";
					}
				}else{
					trhtml =trhtml+ "<td></td><td></td>";
				}
				trhtml =trhtml+ "</tr>";
			}
			cui("#functionParamDiv").html("<table  class='cap-table-fullWidth'>"+trhtml+"</table>");
			comtop.UI.scan(document.getElementById('functionParamDiv'));
		}
		
		function closewin(){
			window.parent.selectJSActionDialog.hide();
		}
	
</script>
</head>
<body  style="background-color:#f5f5f5"  >
	<div id="pageRoot" class="cap-page" style="padding-top:0px;">
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span id="formTitle" uitype="Label" value="已有函数列表" class="cap-label-title" size="12pt"></span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="selectedAction" uitype="Button" onclick="selectedAction();">确定</span>
					<span id="selectedAction" uitype="Button" onclick="closewin()">关闭</span>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div id="functionParamDiv" hidden="true">
					</div>
				</td>
			</tr>
		</table>
		<table id="actionList" uitype="grid" datasource="initData" primarykey="functionFullName" ellipsis="true" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight" 
			selectrows="single"  rowclick_callback="changeSelectFunction">
			<thead>
				<tr>
					<th width="30px" ></th>
					<th style="width: 40px" renderStyle="text-align: center;" bindName="1">序号</th>
					<th renderStyle="text-align:center;" bindName="functionName" width="20%" >函数名称</th>
					<th renderStyle="text-align:left;" bindName="inParamsDeclare" width="20%" >入参说明</th>
					<th renderStyle="text-align:left;" bindName="outParamsDeclare" width="20%">出参说明</th>
					<th renderStyle="text-align:left;" bindName="remark" width="35%">说明</th>
				</tr>
			</thead>
		</table>
	</div>
</body>
</html>