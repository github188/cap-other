<%@page import="java.net.URLDecoder"%>
<%
/**********************************************************************
* 页面选择界面
* 2015-6-23 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%
   String packageId = request.getParameter("packageId");
   String parentNodeId = request.getParameter("parentNodeId");
   String parentNodeName =(String) session.getAttribute("parentNodeName");
%>
<!DOCTYPE html>
<html>
<head>
    <title>表或视图选择界面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.emDialog.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/PdmFacade.js'></top:script>
    <top:script src='/cap/dwr/interface/TableOperateAction.js'></top:script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
		<div id="centerMain" position ="center">
		<table class="cap-table-fullWidth" width="100%">
		    <tr>
		        <td class="cap-td" style="text-align: left;padding:5px">
		        	<span id="formTitle" uitype="Label" value="表或视图选择列表" class="cap-label-title" size="12pt"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	 <span id="saveToPage" uitype="Button" onclick="selectTable()" label="导入元数据"></span> 
		        	 <span id="importAndExecute" uitype="Button" onclick="importAndExecute()" label="导入&执行脚本"></span> 
		        	 <span id="returnback" uitype="Button" onclick="returnback()" label="返回"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td">
		        	<table uitype="Grid" id="table" primarykey="id" selectrows="multi" colhidden="false" datasource="initTableData" pagination="false"
					 	resizewidth="getBodyWidth" resizeheight="getBodyHeight"  colrender="columnRenderer" rowclick_callback="clickCallback">
						<thead>
							<tr>
							    <th style="width:25px"></th>
								<th  style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
								<th  style="width:10%" renderStyle="text-align: center;" bindName="type">表/视图</th>
								<th  style="width:20%" renderStyle="text-align: left" render="editPage" bindName="chName">中文名</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="engName">英文名</th>
								<th  style="width:20%" renderStyle="text-align: left" bindName="description">描述</th>
								<th  style="width:20%" renderStyle="text-align: left" bindName="parentTableName">关联表名</th>
								<th  style="width:20%" renderStyle="text-align: left" bindName="id" hide="true">Id</th>
								<th  style="width:20%" renderStyle="text-align: left" bindName="parentTableId" hide="true">关联表Id</th>
							</tr>
						</thead>
					</table>
		        </td>
		    </tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	var packageId = "<%=packageId%>";
	var parentModuleId = "<%=parentNodeId%>";
	var parentModuleName = "<%=parentNodeName%>";
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
	});
	
    //方法
    var tableGrid = cui("#table");
	//初始化页面模板列表
	function initTableData(gridObj, query) {
		PdmFacade.loadPdmVO(packageId,function(data) {
			gridObj.setDatasource(data, data.length);
		})
	}
	
	//渲染列
	function columnRenderer(rowData, bindName){
		 var value;
	        if (bindName == "type") {
	            value = rowData[bindName];
	            if (value == 1) {
	                return "表";
	            }else{
	            	return "视图";
	            }
	        }
	}

	/**
	 * 选择关联表
	 */
	function selectRelaTable(data){
		var tableId = data.id;
		var allDatas = cui("#table").getData();
		var relaTableDatas = [];
		for(var i = 0; i < allDatas.length; i++){
			var currentTable = allDatas[i];
			if(tableId == currentTable.parentTableId && !isSelectedTableData(currentTable.id)){//isSelectedTableData防止死循环
				relaTableDatas.push(currentTable);//添加关联子表
			}
		}

		var parentTableData = cui("#table").getRowsDataByPK(data.parentTableId)[0];
		if(parentTableData != null && !isSelectedTableData(parentTableData.id)){
			relaTableDatas.push(parentTableData);
		}
		for(var i = 0; i < relaTableDatas.length; i++){
			var relaTableData = relaTableDatas[i];
			if(relaTableData == null){
				continue;
			}
			cui("#table").selectRowsByPK(relaTableData.id);
			selectRelaTable(relaTableData);
		}
	}

	/**
	 * 取消选择关联表
	 */
	function unselectRelaTable(data){
		var tableId = data.id;
		var selectedRowData = cui("#table").getSelectedRowData();
		var relaTableDatas = [];
		for(var i = 0; i < selectedRowData.length; i++){
			var currentTable = selectedRowData[i];
			if(tableId == currentTable.parentTableId){
				relaTableDatas.push(currentTable);//添加关联子表
			}
		}

		var parentTableData = cui("#table").getRowsDataByPK(data.parentTableId)[0];
		if(parentTableData != null && isSelectedTableData(parentTableData.id)){
			relaTableDatas.push(parentTableData);
		}
		for(var i = 0; i < relaTableDatas.length; i++){
			var relaTableData = relaTableDatas[i];
			if(relaTableData == null){
				continue;
			}
			cui("#table").selectRowsByPK(relaTableData.id, false);
			unselectRelaTable(relaTableData);
		}
	}

	function isSelectedTableData(currentPK){
		var selectedPKs = cui("#table").getSelectedPrimaryKey();
		if(selectedPKs == null){
			return false;
		}
		for(var i = 0; i < selectedPKs.length; i++){
			if(currentPK == selectedPKs[i]){
				return true;
			}
		}
		return false;
	}

	//单击
	 function clickCallback(data, checked, index) {
		 // 选中
		 if(checked){
			 selectRelaTable(data);
		 }else{
			 unselectRelaTable(data);
		 }
	}
	
	// 导入元数据
	function selectTable(){
		importMetadata(false);
	}
	
	/**
	 * 导入并执行SQL
	 */
	function importAndExecute(){
		importMetadata(true);
	}
	
	window.top.selectedDatas =[];
	window.top.emDialog = null;
	//导入元数据
	function importMetadata(isExecuteSQL) {
		var selectData = cui("#table").getSelectedRowData();
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择表或者视图。");
			return;
		}
		if (isExecuteSQL) {
			//判断是否增量执行SQL
			dwr.TOPEngine.setAsync(false);
			TableOperateAction.isIncrementExecute(selectData, function(isIncrementExecute) {
				if (isIncrementExecute) {
					window.top.selectedDatas = selectData;
					dwr.TOPEngine.setAsync(false);
					PdmFacade.importPdm(packageId, selectData, function(data) {
						if (data) {
							console.log("表或视图保存成功");
						} else {
							console.log("表或视图保存失败");
						}
					});
					dwr.TOPEngine.setAsync(true);
					//增量执行SQL
					var url = webPath + "/cap/bm/dev/pdm/CompareTableMain.jsp?packageId=" + packageId;
					if (!window.top.emDialog) {
						window.top.emDialog = cui.extend.emDialog({
							id: 'compareTableMain',
							title: '数据表结构差异',
							src: url,
							width: 800,
							height: 600,
							onClose: function() {
								//do nothing
							}
						});
					}
					window.top.emDialog.show(url);
				} else {
					//全量执行
					doImport(selectData, isExecuteSQL);
				}
			});
			dwr.TOPEngine.setAsync(true);
		} else {
			doImport(selectData, isExecuteSQL);
		}
	}
	
	//导入
	function doImport(selectData,isExecuteSQL){
		dwr.TOPEngine.setAsync(false);
		PdmFacade.importPdm(packageId,selectData,function(data){
			if(data){
				console.log("表或视图保存成功");
			}else{
				console.log("表或视图保存失败");
			}
		});
		dwr.TOPEngine.setAsync(true);
		
		dwr.TOPEngine.setAsync(false);
		TableOperateAction.importTableSQL(packageId,selectData,isExecuteSQL,{
			callback: function(data) {
				cui.message("创建表成功", 'success', {
					'callback': function() {
						returnback();
					}
				});
			},
			errorHandler: function(message, exception) {
				cui.message("建表失败","error");
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//返回
	function returnback(){
		var returnParentNodeName  = decodeURIComponent(decodeURIComponent(parentModuleName));
		if(returnParentNodeName!="undefined"&&returnParentNodeName!=null&&returnParentNodeName!="null"){
			returnParentNodeName = encodeURIComponent(encodeURIComponent(returnParentNodeName));
		}
		var returnUrl = '<%=request.getContextPath() %>/cap/ptc/index/AppDetail.jsp?packageId=' + packageId + '&parentNodeId=' + parentModuleId
		+ "&parentNodeName=" + returnParentNodeName;
		window.open(returnUrl, '_self');
	}
	
	/**
	 * 表格自适应宽度
	 */
	function getBodyWidth () {
	    return parseInt(jQuery("#centerMain").css("width"))- 10;
	}

	/**
	 * 表格自适应高度
	 */
	function getBodyHeight () {
	    return (document.documentElement.clientHeight || document.body.clientHeight) - 71;
	}
	
		
	</script>
</body>
</html>