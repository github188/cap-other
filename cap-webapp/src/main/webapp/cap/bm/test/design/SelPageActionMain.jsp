<%
  /**********************************************************************
	* 界面行为选择
	* 2016-7-19  李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>


<!doctype html>
<html>
<head>
<title>界面行为选择</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
    <top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
    <top:script src="/cap/dwr/util.js"></top:script>
    <top:script src="/cap/dwr/interface/SystemModelAction.js"></top:script>
    <top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div uitype="Borderlayout"  id="body"  is_root="true" >
		<div id="leftMain" position="left" width="200" collapsabltie="true" show_expand_icon="true">       
	        <table width="95%" style="margin-left: 10px">
				<tr id="tr_moduleTree">
					<td>
	                    <div id="moduleTree" uitype="Tree" children="initData" on_click="treeClick" min_expand_level="1"  
	                    	on_lazy_read="loadNode"  click_folder_mode="1"></div>
	                   </td>
				</tr>
			</table>
         </div>
         <div id="centerMain" position ="center">
			
		</div>
	</div>


<script type="text/javascript">
var packageId = "${param.packageId}";

window.onload = function(){
  		comtop.UI.scan();
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
				$(".bl_box_left").scrollTop($(".dynatree-active").offset().top-($(".bl_box_left").height()/3));
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
	if(childrenNode && childrenNode.length > 0) {
		for (var i = 0; i < childrenNode.length; i++) {
			doneTreeDataNode(childrenNode[i], childrenNode[i].children);
		};
	}else {
		node.isLazy = true;
	}
	node.isFolder = true;
}

//点击click事件加载节点方法
function loadNode(node) {
	dwr.TOPEngine.setAsync(false);
	PageFacade.queryPageListForNode(node.getData().key,function(data){
		node.addChild(data);
		node.setLazyNodeStatus(node.ok);
		nodeUrl(node.getData().key);		
	});
	dwr.TOPEngine.setAsync(true);
}

//设置右边的页面链接
function nodeUrl(nodeId){
	var url = "PageActionSelList.jsp?pageModelId=" + nodeId + "&nodeType=app";
	cui('#body').setContentURL("center", url);	
}

//树单击事件
function treeClick(node){
	var data = node.getData();
	var nodeType = "app";
	if(data.data.modelType  && data.data.modelType == "page"){
		nodeType = "page";
	}
	var url = "PageActionSelList.jsp?pageModelId=" + data.data.modelId + "&nodeType=" + nodeType;
	cui('#body').setContentURL("center", url);	
}

//关闭窗口
function closeSelf(){
	window.parent.dialog.hide();
}
</script>
</body>
</html>