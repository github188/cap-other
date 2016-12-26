<%
  /**********************************************************************
	* CIP元数据建模----系统建模主页面 
	* 2014-10-30  沈康 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>


<!doctype html>
<html>
<head>
<title>系统建模主页面</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
    <top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
    <top:script src="/cap/dwr/util.js"></top:script>
    <top:script src="/cap/dwr/interface/SystemModelAction.js"></top:script>
    <top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
    <top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
span.dynatree-node-disable a {
    color: #ccc!important;
}
</style>
<body>
	<div uitype="Borderlayout"  id="body"  is_root="true" >
		<div position="top" height="50">
			<div style="padding-top: 10px;text-align:right;">
				<span uitype="button" id="enSure" label="确定" on_click="enSure"></span>
				<span uitype="button" id="closeSelf" label="关闭" on_click="closeSelf"></span>
				<span uitype="button" id="setDefault" label="清空" on_click="setDefault"></span>
			</div>
		</div>
		<div id="leftMain" position="center" width="300" collapsabltie="true" show_expand_icon="true">       
	        <table width="285" style="margin-left: 10px">
				<tr height="40px;">
					<td>
						<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输实体名称关键字查询"
							on_iconclick="fastQuery"  icon="search" enterable="true"
							editable="true"	 width="260" on_keydown="keyDownQuery"></span>
					</td>
				</tr>
				<tr>
					<td>
						<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
					</td>
				</tr>
				<tr id="tr_moduleTree">
					<td>
	                    <div id="moduleTree" uitype="Tree" children="initData" on_click="treeClick"
	                    on_dbl_click="treeOndbClick" min_expand_level="1" on_lazy_read="loadNode"  click_folder_mode="1"></div>
	                   </td>
				</tr>
			</table>
         </div>
	</div>


<script type="text/javascript">
var addType = '';
//选中的树节点
var selectNodeId = "-1";
var selectNodeTitle = "";
var selectNodeType = true;
var selectNodeData = {};
var fastQueryDataArray = new Array();
var sourceEntityId = "${param.sourceEntityId}";
var sourcePackageId = "${param.sourcePackageId}";
var isSelSelf = "${param.isSelSelf}";
var showClean = "${param.showClean}";
var selfEntityId ="${param.selfEntityId}";
var propertyName = "${param.propertyName}";
var operateNodeDisable = "${param.operateNodeDisable}";
var openType = 'newWin' == <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>?true:false;
var subEntity;
window.onload = function(){
	  if(sourceEntityId&&sourceEntityId!="") {
		  //如果触发泛型不是来自服务实体，则执行选择操作
		  dwr.TOPEngine.setAsync(false);
		  EntityFacade.loadEntity(sourceEntityId,"",function(entity){
			  sourcePackageId = entity.packageId ? entity.packageId : null;
			  //初始化设置树节点选中数据
			  selectNodeData = entity;
			  selectNodeId = sourceEntityId;
	     });
		 
		 dwr.TOPEngine.setAsync(true);	
	  }
	comtop.UI.scan();   //扫描
	
	if(operateNodeDisable == "true"){
		dwr.TOPEngine.setAsync(false);
		EntityFacade.loadEntity(selfEntityId,"",function(entity){
		    subEntity = entity;
	    });
		dwr.TOPEngine.setAsync(true);	
	 }
	if(showClean=="false"){
		cui("#setDefault").hide();
	}
}

//初始化数据 
function initData(obj) {
	// var moduleObj={"parentModuleId":"-1"};
	SystemModelAction.getAllModuleTree(function(data){
		if(data == null || data == "") {
			//当为空时，进行根节点新增操作
			isRootNodeAdd = "true";
			setRootNode(obj);
		} else {
			var treeData = jQuery.parseJSON(data);
			treeData.expand = true;
			treeData.activate = true;
			doneTreeDataNode(treeData, treeData.children);
	    	obj.setDatasource(treeData);
	    	var sourceNode = sourcePackageId ? obj.getNode(sourcePackageId) : null;
	    	if(sourceNode) {	//有来源实体需要自动定位到对应实体应用方便于用户选择
	    		sourceNode.activate();
				sourceNode.expand();

				//如果没有子应用时会在展开时自动执行loadNode方法定位
				//有子应用时需要手动定位到具体的实体
				var children = sourceNode.children();
				if (children&&children.length>0) {
					cui("#moduleTree").getNode(sourceEntityId).activate();
				}
				//定位到对应的选中的项
				$(".bl_box_center").scrollTop($(".dynatree-active").offset().top-($(".bl_box_center").height()/3));
	    	}
		}
    });

}

/**
 * 将所有的节点isFolder设置为true,叶子节点isLazy设置为true（点击叶子节点加载对应的实体VO）
 * @param  node         节点
 * @param  childrenNode 节点对应的子节点集合
 * @return              
 */
function doneTreeDataNode (node, childrenNode) {
	node.isFolder = true
	if(childrenNode && childrenNode.length > 0) {
		for (var i = 0; i < childrenNode.length; i++) {
			doneTreeDataNode(childrenNode[i], childrenNode[i].children);
			if (node.data&&node.data.moduleType==2) {
				node.isLazy = true;
				loadNodeForInit(node);
			}else{
				node.isFolder = false;
			}
		};
	}else {
		node.isLazy = true;
	}
	
	
}

//初始化加载应用下(有子应用的应用)的实体信息
function loadNodeForInit(node){
	dwr.TOPEngine.setAsync(false);
	EntityFacade.queryEntityForNode(node.key,function(data){
		node.children = _.union(node.children,data);
	});
	dwr.TOPEngine.setAsync(true);
}


//点击click事件加载节点方法
function loadNode(node) {
	dwr.TOPEngine.setAsync(false);
	EntityFacade.queryEntityForNode(node.getData().key,function(data){

		//解决点击应用目录层时，会自动跳到sourceEntityId对应的那个实体
		if (isEmptyObject(data)) {
			node.setLazyNodeStatus(node.ok);
			return;
		}
		//设置节点禁用与显示的状态,只用于选择父类继承时使用
		if(operateNodeDisable == "true"){
			setNodeDisableState(data);
		}
		
		if(sourceEntityId!=""){
			node.addChild(data);
			node.setLazyNodeStatus(node.ok);
			cui("#moduleTree").getNode(sourceEntityId).activate();
		 }else{
			node.addChild(data);
			node.setLazyNodeStatus(node.ok);
		 }
     });
	dwr.TOPEngine.setAsync(true);
}

// 增加指定目录节点
function addSomeChildNode(childData) {
	for(var i=0; i<childData.length; i++) { 
   		if(childData[i].data.moduleType == 2) {
   			dwr.TOPEngine.setAsync(false);
   			EntityFacade.queryEntityForNode(childData[i].data.moduleId,function(data){
   				childData[i].children = data;
   		     });
   			
   			dwr.TOPEngine.setAsync(true);
   			childData[i].isFolder = true;
   		}
   	} 
	return childData;
}

//点击确定回调传值到父页面
function enSure() {
	if(selectNodeId == "" || !selectNodeData.packageId) {
		cui.alert("请选择实体！");
   		return;
	}
	
	if(operateNodeDisable == "true"){
		if(!validateSelectEntity(selectNodeData)){
			return;
		}
	}
	
	if(isSelSelf=="false"&&selfEntityId == selectNodeData.modelId){
		cui.alert("请选择其他实体，暂不支持自关联！");
		return;
	}
	
	if(openType){
		if(opener.selEnityValidate){
			if(!parent.selEnityValidate(selectNodeData,propertyName)) {
				return ;
			}
		}
		opener.selEntityBack(selectNodeData,propertyName);
		window.close();
		return;
	}
	
	if(parent.selEnityValidate) {
		if(!parent.selEnityValidate(selectNodeData,propertyName)) {
			return ;
		}
	}
		
	parent.selEntityBack(selectNodeData,propertyName);
}

//树双击事件
function treeOndbClick(node) {
	treeClick(node);
	enSure();
}

//树单击事件
function treeClick(node){
	var data = node.getData();
	selectNodeData = data.data;
	selectNodeId = data.key;
	selectNodeTitle = data.title;
	selectNodeType = data.isFolder;
}

function clickDbRecord(data) {
	for(var i = 0 ; i < fastQueryDataArray.length; i++) {
		if(fastQueryDataArray[i].modelId == data) {
			selectNodeData = fastQueryDataArray[i];
			selectNodeId = data;
			selectNodeTitle = selectNodeData.englishName;
			enSure();
		}
	}
}

function clickRecord(data) {
	for(var i = 0 ; i < fastQueryDataArray.length; i++) {
		if(fastQueryDataArray[i].modelId == data) {
			selectNodeData = fastQueryDataArray[i];
			selectNodeId = data;
			selectNodeTitle = selectNodeData.englishName;
		}
	}
}

//快速查询
function fastQuery(){
	var keyword = cui('#keyword').getValue();
	if(keyword==''){
		$('#fastQueryList').hide();
		$('#moduleTree').show();
		addType = '';
		var node=cui('#moduleTree').getNode(selectNodeId);
		if(node){
			treeClick(node);
		}
	}else{
		$('#fastQueryList').show();
		$('#moduleTree').hide();
		listBoxData(cui('#fastQueryList'));
		addType = 'fastQueryType';
	}
}

//键盘回车键快速查询 
function keyDownQuery() {
	if ( event.keyCode ==13) {
		fastQuery();
	}
}

/*
 * 设置节点禁用与显示状态
 *  1、如果实体是本身则置不可选，如果是CapBase，则无需控制，所有实体类型均可以继承
 *  2、如果子类实体为业务实体时，父类只能是业务实体和查询实体;查询实体只能继承查询实体;数据实体只能继承数据实体。
 *  3、工作流实体父类最终必须继承工作流实体，非工作流实体父类最终智能继承非工作流实体
 */
function setNodeDisableState(data){
	//获取当前实体是否是工作流实体
	var isWorkflowEntity = false;
	if(hasWorkflowFiled(subEntity) || isExtendsWorkflow(subEntity)){
		isWorkflowEntity = true;
	}
	for(var i = 0 ; i < data.length; i++){
		//将子类自身实体置灰
		if(subEntity.modelId == data[i].data.modelId){
			data[i].disable = true;
			continue;
		}
		//如果实体是capBase,则无需控制
		if(data[i].data.modelId =='com.comtop.cap.runtime.base.entity.CapBase'){
			continue;
		}
		if(subEntity.entityType == 'biz_entity'){
			//如果实体是CapWorkflow，则无需控制
			if(data[i].data.modelId =='com.comtop.cap.runtime.base.entity.CapWorkflow'){
				continue;
			}
			//如果子类实体为业务实体或者查询实体时，父类只能是业务实体和查询实体，将数据实体设置为不可选
			if(data[i].data.entityType == 'biz_entity' ||　data[i].data.entityType == 'query_entity'){
				//控制实体可选功能，工作流实体父类最终必须继承工作流实体，非工作流实体父类最终智能继承非工作流实体
				controlEntityDisable(isWorkflowEntity,data[i]);
			}else{
				data[i].disable = true;
			}
		} else if(subEntity.entityType == 'query_entity'){
			//如果实体是CapWorkflow，则无需控制
			if(data[i].data.modelId =='com.comtop.cap.runtime.base.entity.CapWorkflow'){
				continue;
			}
			//如果子类实体为业务实体或者查询实体时，父类只能是业务实体和查询实体，将数据实体设置为不可选
			if(data[i].data.entityType == 'query_entity'){
				//控制实体可选功能，工作流实体父类最终必须继承工作流实体，非工作流实体父类最终智能继承非工作流实体
				controlEntityDisable(isWorkflowEntity,data[i]);
			}else {
				data[i].disable = true;
			}
		}else {
			if(data[i].data.modelId =='com.comtop.cap.runtime.base.entity.CapWorkflow'){
				data[i].disable = true;
				continue;
			}
			if(data[i].data.entityType != 'data_entity'){
				data[i].disable = true;
			}
		}
	}
}
 
 /*
  * 设置是否可以选择此实体
  *  1、如果实体是本身则置不可选，如果是CapBase，则无需控制，所有实体类型均可以继承
  *  2、如果子类实体为业务实体时，父类只能是业务实体和查询实体;查询实体只能继承查询实体;数据实体只能继承数据实体。
  *  3、工作流实体父类最终必须继承工作流实体，非工作流实体父类最终智能继承非工作流实体
  */
 function validateSelectEntity(entity){
 	//获取当前实体是否是工作流实体
 	var isWorkflowEntity = false;
 	if(hasWorkflowFiled(subEntity) || isExtendsWorkflow(subEntity)){
 		isWorkflowEntity = true;
 	}
	//将子类自身设置为不可选
	if(subEntity.modelId == entity.modelId){
		cui.alert("实体不能继承自身实体!");
		return false;
	}
	//如果实体是capBase,则无需控制
	if(entity.modelId =='com.comtop.cap.runtime.base.entity.CapBase'){
		return true;
	}
	if(subEntity.entityType == 'biz_entity'){
		return operateSubBizEntity(isWorkflowEntity,entity);
	} else if(subEntity.entityType == 'query_entity'){
		return operateSubQueryEntity(isWorkflowEntity,entity);
	}else {
		return operateSubDataEntity(entity);
 	}
 }
 
  //如果子类是业务实体，则判断实体是否可选
 function operateSubBizEntity(isWorkflowEntity,entity){
	//如果实体是CapWorkflow，则无需控制
	if(entity.modelId =='com.comtop.cap.runtime.base.entity.CapWorkflow'){
		return true;
	}
	//如果子类实体为业务实体或者查询实体时，父类只能是业务实体和查询实体，将数据实体设置为不可选
	if(entity.entityType == 'biz_entity' ||　entity.entityType == 'query_entity'){
		//控制实体可选功能，工作流实体父类最终必须继承工作流实体，非工作流实体父类最终智能继承非工作流实体
		if(isWorkflowEntity){
			if(!isExtendsWorkflow(entity)){
				cui.alert("工作流实体只能继承工作流实体,请重新选择。");
				return false;
			}
		}else{
			if(!isExtendsCapBase(entity)){
				cui.alert("非工作流实体只能继承非工作流实体，请重新选择。");
				return false;
			}
		}
		return true;
	}else{
		cui.alert("业务实体不能继承数据实体，请重新选择。");
		return false;
	}
 }
 
 //如果子类是查询实体，则判断实体是否可选
 function operateSubQueryEntity(isWorkflowEntity,entity){
	//如果实体是CapWorkflow，则无需控制
	if(data[i].data.modelId =='com.comtop.cap.runtime.base.entity.CapWorkflow'){
		return true;
	}
	//如果子类实体为业务实体或者查询实体时，父类只能是业务实体和查询实体，将数据实体设置为不可选
	if(entity.entityType == 'query_entity'){
		//控制实体可选功能，工作流实体父类最终必须继承工作流实体，非工作流实体父类最终智能继承非工作流实体
		if(isWorkflowEntity){
			if(!isExtendsWorkflow(entity)){
				cui.alert("工作流实体只能继承工作流实体,请重新选择。");
				return false;
			}
		}else{
			if(!isExtendsCapBase(entity)){
				cui.alert("非工作流实体只能继承非工作流实体，请重新选择。");
				return false;
			}
		}
		return true;
	}else{
		cui.alert("查询实体不能继承业务实体或数据实体，情重新选择。");
		return false;
	}
 }
 //如果子类是数据实体，则判断实体是否可选
 function operateSubDataEntity(entity){
	 if(entity.modelId =='com.comtop.cap.runtime.base.entity.CapWorkflow'){
		 cui.alert("数据实体不能继承工作流实体，请重新选择。")
		return false;
	 }
	 if(entity.entityType != 'data_entity'){
		 cui.alert("数据实体不能继承业务实体或查询实体，请重新选择。")
		return false;
	 }
	 return true;
 }
 
//判断实体属性是否同时关联PROCESS_INS_ID和FLOW_STATE两数据字段 true:存在，false:不存在
function hasWorkflowFiled(subEntity){
	if(!subEntity.attributes){
		return false;
	}
	//判断实体属性是否同时关联PROCESS_INS_ID和FLOW_STATE两数据字段
	var includeProcessInsIdFlag = false;
	var includeFlowState = false;
	for(var n = 0 ; n < subEntity.attributes.length ; n++){
		if(subEntity.attributes[n].dbFieldId == 'PROCESS_INS_ID'){
			includeProcessInsIdFlag = true;
		}else if(subEntity.attributes[n].dbFieldId == 'FLOW_STATE'){
			includeFlowState = true;
		}
	}
	if(includeProcessInsIdFlag && includeFlowState){
		return true;
	}
	return false;
}
/**
 * 控制实体可选功能
 * @param 当前实体是否是工作流实体 true : 是 ，false ： 否
 * @param 需要控制的实体
 */
function controlEntityDisable(isWorkflowEntity,dataObject){
	//如果当前实体为工作流实体，则直接将非工作流实体置为不可选，否则将工作流实体置为不可选
	if(isWorkflowEntity){
		if(!isExtendsWorkflow(dataObject.data)){
			dataObject.disable = true;
		}
	}else{
		if(!isExtendsCapBase(dataObject.data)){
			dataObject.disable = true;
		}
	}
}

/**
 * 实体是否继承了工作流实体CapWrokflow
 * @param entity 需要判断的实体
 * @return true:是  ，false: 否
 */
function isExtendsWorkflow(entity){
	var isWorkflow = false;
	dwr.TOPEngine.setAsync(false);
	EntityFacade.isEntityExtendsCapWrokflow(entity,function(result){
		isWorkflow = result;
	});
	dwr.TOPEngine.setAsync(true);
	return isWorkflow;
}

/**
 * 实体是否继承了CapBase
 * @param entity 需要判断的实体
 * @return true:是  ，false: 否
 */
function isExtendsCapBase(entity){
	var isExtendsCapBase = false;
	dwr.TOPEngine.setAsync(false);
	EntityFacade.isEntityExtendsCapBase(entity,function(result){
		isExtendsCapBase = result;
	});
	dwr.TOPEngine.setAsync(true);
	return isExtendsCapBase;
}


//快速查询列表数据源
function listBoxData(obj){
	initBoxData = [];
	var keyword = cui("#keyword").getValue().replace(new RegExp("/","gm"), "//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_","gm"), "/_");
	keyword = keyword.replace(new RegExp("'","gm"), "''");
	dwr.TOPEngine.setAsync(false);
	fastQueryDataArray = new Array();
	EntityFacade.fastQueryEntity(keyword,function(data){
		var len = data.length ;
		if(len != 0) {
			$.each(data,function(i,cData){
				if(cData.engName.length > 31) {
					path=cData.engName.substring(0,31)+"..";
				} else {
					path = cData.engName;
				}
				fastQueryDataArray.push(cData);
				initBoxData.push({href:"#",name:path,title:cData.engName,ondblclick:"clickDbRecord('"+cData.modelId+"')",onclick:"clickRecord('"+cData.modelId+"')"});
			});
		} else {
			initBoxData.push({href:"#",name:"没有数据",title:"",onclick:""});
		}
	});
	cui("#fastQueryList").setDatasource(initBoxData);
	dwr.TOPEngine.setAsync(true);
}

//关闭窗口
function closeSelf(){
	if(openType){
		window.close();
		return;
	}
	if(parent.closeEntityWindow){
		parent.closeEntityWindow();
	}
}

//判断对象是否为空
function isEmptyObject( obj ) {
    for ( var name in obj ) {
        return false;
    }
    return true;
}

function setDefault() {
	if(openType){
		if(opener.setDefault) {
			opener.setDefault(propertyName);
		}
		return;
	}
	if(parent.setDefault) {
		parent.setDefault(propertyName);
	}
}
</script>
</body>
</html>