<%
/**********************************************************************
* 查询建模实体选择界面
* 2016-7-26 刘城  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>实体选择界面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/SystemModelAction.js'></top:script>
    <top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
		<div id="leftMain" position="left" style="overflow:hidden" width="200" collapsable="true" show_expand_icon="true">       
		   <div  id="treeDivHight" style="overflow:auto;height:100%;">
			<div id="moduleTree" uitype="Tree" children="initData" 
                     on_dbl_click="dbClickNode" min_expand_level="1"  on_lazy_read="loadNode" on_click="treeClick" click_folder_mode="1"></div>
			</div>
        </div>
		<div id="centerMain" position ="center">
		<table class="cap-table-fullWidth" width="100%">
		    <tr>
		        <td class="cap-td" style="text-align: left;padding:5px">
		        	<span id="formTitle" uitype="Label" value="实体列表" class="cap-label-title" size="12pt"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	 <span id="saveToEntity" uitype="Button" onclick="selectEntity()" label="确定"></span> 
			         <span id="closeTemplate" uitype="Button" onclick="entityClose()" label="关闭"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td">
		        	<table uitype="Grid" id="selectEntity" primarykey="modelId" selectrows="single" colhidden="false" datasource="initSelectEntityData" pagination="false"
					 	resizewidth="getBodyWidth" resizeheight="getBodyHeight"  colrender="columnRenderer">
						<thead>
							<tr>
							    <th style="width:25px"></th>
								<th  style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
								<th  style="width:20%" renderStyle="text-align: left" bindName="engName">实体名称</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="chName">中文名称</th>
								<th  style="width:30%" renderStyle="text-align: left" bindName="dbObjectName">对应表</th>			 
								<th  style="width:20%" renderStyle="text-align: left" bindName="modelPackage">包路径</th>
								<th  style="width:20%" renderStyle="text-align: left"  render="entityTypeRenderer" bindName="entityType">实体类型</th>
							</tr>
						</thead>
					</table>
					<table uitype="Grid" id="selectEntityMulti" primarykey="modelId" selectrows="multi" colhidden="false" datasource="initSelectEntityData" pagination="false"
					 	resizewidth="getBodyWidth" resizeheight="getBodyHeight"  colrender="columnRenderer"  >
						<thead>
							<tr>
							    <th style="width:25px"></th>
								<th  style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
								<th  style="width:20%" renderStyle="text-align: left" bindName="engName">实体名称</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="chName">中文名称</th>
								<th  style="width:30%" renderStyle="text-align: left" bindName="dbObjectName">对应表</th>			 
								<th  style="width:20%" renderStyle="text-align: left" bindName="modelPackage">包路径</th>
								<th  style="width:20%" renderStyle="text-align: left" render="entityTypeRenderer" bindName="entityType">实体类型</th>
							</tr>
						</thead>
					</table>
		        </td>
		    </tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	var systemModuleId =<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("systemModuleId"))%>;
	var openType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;//single
	var selectType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectType"))%>;//选择类型，分为选择jsp或者是全部页面
	var flag =  <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;//界面设计器选择页面用，绑定的属性标志
	var packageId = systemModuleId;
	var constantName =  <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("constantName"))%>;//
	var modelId =  <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;//
	var tableAlias = "${param.tableAlias}";
	
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
		if(openType=="multi"){
			cui("#selectEntity").destroy();
		}else{
			cui("#selectEntityMulti").destroy();
		}
		
	});
	
	//初始化数据 
	function initData(obj) {
		SystemModelAction.getAllModuleTree(function(data){
			if(data == null || data == "") {
				//当为空时，进行根节点新增操作
				isRootNodeAdd = "true";
				setRootNode(obj);
			} else {
				var treeData = jQuery.parseJSON(data);
				treeData.expand = true;
				treeData.activate = true;
		    	obj.setDatasource(treeData);
		    	var sourceNode = systemModuleId ? obj.getNode(systemModuleId) : null;
		    	if(sourceNode) {	//有来源实体需要自动定位到对应实体应用方便于用户选择
		    		sourceNode.activate();
					//定位到对应的选中的项
		    		$("#treeDivHight").scrollTop($(".dynatree-active").offset().top-($(".bl_box_left").height()/3));
		    	}
			}
	     });
	}
	
	function selectEntity() {
		var selectData = [];
		if(openType=="multi"){
			selectData = cui("#selectEntityMulti").getSelectedRowData();
		}else{
			selectData = cui("#selectEntity").getSelectedRowData();
		}
		if (selectData == null || selectData.length == 0) {
			cui.alert("请选择所需的实体。");
			return;
		} else {
			if (openType && openType == "multi") {
				//确定前先销毁防止多次点击
				cui("#saveToEntity").destroy();
				window.opener.fromCallBack(selectData);
				window.close();
			}
		}
	}
	
	// 编辑实体
	function updateEntity(id,modelId,entityType) {
		window.location.href=getEditUrl(id,modelId,entityType);
	}


	function getEditUrl(mId,modelId,entityType) {
		return "EntityMain.jsp?modelId=" + modelId + "&packageId=" + packageId + "&entityType="+entityType+"&openType=listToMain"; 
	}
	//grid列渲染
	function entityTypeRenderer(data,field){
		if(data.entityType == "biz_entity") {
			return "业务实体";
		}else if(data.entityType == "query_entity"){
			if("exist_entity_input" == data.entitySource){
				return "已有实体";
			}
			return "查询实体";
		}else if(data.entityType == "data_entity"){
			if("exist_entity_input" == data.entitySource){
				return "已有实体";
			}
			return "数据实体";
		}
	}
	
	function returnSelectEntity(){
		var selectData = [];
		if(openType=="multi"){
			selectData = cui("#selectEntityMulti").getSelectedRowData();
		}else{
			selectData = cui("#selectEntity").getSelectedRowData();
		}
		return selectData;
	}

	function copyPageResult(rs){
		if(typeof rs === 'number'){
			cui.message(rs+'个页面复制成功！', 'success');
		}
		if(typeof rs === 'boolean'){
			if (rs) {
				cui.message('页面复制成功！', 'success');
			} else {
				cui.error("页面复制失败！");
			} 
		}
		if(window.opener!=null){
			window.opener.location.reload();
		}
	}
	
    //页面关闭
	function entityClose(){
		window.close();
	}
	
	//初始化页面模板列表
	function initSelectEntityData(gridObj, query) {
		EntityFacade.queryEntityListByEntityType(packageId,'biz_entity',function(data) {
			if(selectType=="jsp"){
				var jspData = getJspData(data);
			  gridObj.setDatasource(jspData, jspData.length);
			}else{
			  gridObj.setDatasource(data, data.length);
			}
		})
	}
	
	//过滤自定义的实体
	function getJspData(pageData){
		var retData = [];
		for(var i =0;i<pageData.length;i++){
			if(pageData[i].pageType==2){
				retData.push(pageData[i]);
			}
		}
		return retData;
	}
	
	//点击click事件加载节点方法
	function loadNode(node) {
		var moduleObj={"parentModuleId":node.getData().key};
		SystemModelAction.queryChildrenModule(moduleObj,function(data){
	    	var treeData = jQuery.parseJSON(data);
	    	treeData.activate = true;
	    	node.addChild(treeData.children);
			node.setLazyNodeStatus(node.ok);
	     });
		dwr.TOPEngine.setAsync(true);
	}
	
	//树单击事件
	function treeClick(node){
		var data = node.getData();
		var parentData = node.parent().getData();
		var nodeTypeVal = data.data.moduleType;
		
		var systemId;
		if(nodeTypeVal==0){
			systemId = parentData.key;
		}else{
			systemId = data.key;
		}
		if(nodeTypeVal == 2){
			packageId = systemId;
			if(openType=="multi"){
				cui("#selectEntityMulti").loadData();
			}else{
				cui("#selectEntity").loadData();
			}
		}
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