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
</style>
<body>
	<div uitype="Borderlayout"  id="body"  is_root="true" >
		<div id="leftMain" position="left" width="200" collapsabltie="true" show_expand_icon="true"> 
			<div class="treeDivHight" style="overflow:auto;height:100%;">      
	    		<div id="moduleTree" uitype="Tree" children="initData" on_click="treeClick"
	                    on_dbl_click="treeOndbClick" min_expand_level="1"  on_lazy_read="loadNode"  click_folder_mode="1"></div>
	        </div>
        </div>
        <div id="centerMain" position ="center"></div>
	</div>


<script type="text/javascript">
var selectNodeId = "";
var selectNodeTitle = "";
var selectNodeType = true;
var selectNodeData = {};
var modelId = "${param.modelId}";
var entityName = "${param.entityName}";
var selectFlag = "${param.selectFlag}";
var packageId = "${param.packageId}";
var actionType = "${param.actionType}";//主要区分是单属性还是多属性选择selMultiAttr
var selData = "${param.selData}";
var tableAlias = "${param.tableAlias}";//表别名用户查询建模
var initCount = 0; // 0:代表页面初始化 ，非0 : 代表不是页面初始化，  解决节点展开刷新右侧页面问题 add by linyuqian 20160829

window.onload = function(){
  		comtop.UI.scan();
  		if(modelId!=""){
  		//根据实体ID获取所在包ID，定位树到相应的模块位置
  	    dwr.TOPEngine.setAsync(false);
	   EntityFacade.loadEntity(modelId,"",function(entity){
		   packageId = entity.packageId;
	   });
		dwr.TOPEngine.setAsync(true);
  		}
}

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
			doneTreeDataNode(treeData, treeData.children);
	    	obj.setDatasource(treeData);
	    	var sourceNode = packageId ? obj.getNode(packageId) : null;
	    	if(sourceNode) {	//有来源实体需要自动定位到对应实体应用方便于用户选择
	    		sourceNode.activate();
				sourceNode.expand();
				//定位到对应的选中的项
				$(".treeDivHight").scrollTop($(".dynatree-active").offset().top-($(".bl_box_center").height()/3));
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
	node.isFolder = true;
	if(childrenNode && childrenNode.length > 0) {
		for (var i = 0; i < childrenNode.length; i++) {
			doneTreeDataNode(childrenNode[i], childrenNode[i].children);
			if (node.data&&node.data.moduleType==2) {
				node.isLazy = true;
				loadNodeForInit(node);
			}
		};
	}else {
		node.isLazy = true;
	}
}

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
		var nodeUrlData = "";
		if(modelId!=""){
			node.addChild(data);
			node.setLazyNodeStatus(node.ok);
			nodeUrlData = modelId;//设置链接节点数据
			cui("#moduleTree").getNode(modelId).activate();
		 }else{
			node.addChild(data);
			node.setLazyNodeStatus(node.ok);
			nodeUrlData = node.getData().key;//设置链接节点数据
		 }
		 //如果是页面初始化，则需要初始化右侧页面
		 if(initCount == 0){
			 nodeUrl(nodeUrlData);
			 initCount = 1;//设置为页面非初始化
		 }
	});
	dwr.TOPEngine.setAsync(true);
}

//设置右边的页面链接
function nodeUrl(nodeId){
	var url = "EntityAttributeSelectionList.jsp?entityId=" + nodeId + "&selectFlag="+selectFlag+"&selData="+selData;
	if(actionType=="selMultiAttr"){
		if(tableAlias){
			url = "BizEntityMultiAttribute.jsp?entityId=" + nodeId + "&selectFlag="+selectFlag+"&selData="+selData+"&tableAlias="+tableAlias;
		}else{
			url = "BizEntityMultiAttribute.jsp?entityId=" + nodeId + "&selectFlag="+selectFlag+"&selData="+selData;
		}
	}
	cui('#body').setContentURL("center", url);	
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
	if(selectNodeType) {
   		cui.alert("请选择实体！");
   		return;
   	}
	if(selectNodeId == "") {
		cui.alert("请选择实体！");
   		return;
	}
	if(parent.selEnityValidate) {
		if(!parent.selEnityValidate(selectNodeData)) {
			return ;
		}
	}
	parent.selEntityBack(selectNodeData);
	closeSelf();
}

//树双击事件
function treeOndbClick(node) {
	treeClick(node);
}

//树单击事件
function treeClick(node){
	var data = node.getData();
	modelId = data.data.modelId;//重新设置modelId
	var url = "EntityAttributeSelectionList.jsp?entityId=" + modelId + "&selectFlag="+selectFlag;
	if(actionType=="selMultiAttr"){
		url = "BizEntityMultiAttribute.jsp?entityId=" + modelId + "&selectFlag="+selectFlag;
	}
	cui('#body').setContentURL("center", url);	
}

//关闭窗口
function closeSelf(){
	window.parent.dialog.hide();
}
</script>
</body>
</html>