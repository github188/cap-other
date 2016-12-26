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
    <top:script src="/cap/dwr/engine.js"></top:script>
    <top:script src="/cap/dwr/util.js"></top:script>
    <top:script src="/top/cfg/dwr/interface/ConfigClassifyAction.js"></top:script>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/dwr/interface/SystemModelAction.js"></top:script>
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
				<tr>
					<td>
						<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
					</td>
				</tr>
				<tr id="tr_moduleTree">
					<td>
	                    <div id="ClassifyTree" uitype="Tree" children="treeData" on_lazy_read="loadNode"  on_click="treeClick" click_folder_mode="1"></div>
	                   </td>
				</tr>
			</table>
         </div>
         <div id="centerMain" position ="center">
			
		</div>
	</div>


<script type="text/javascript">
var sourceModuleId = '${param.sourceModuleId}';
var codeVal = '${param.code}';
window.onload = function(){
  		comtop.UI.scan();
  	}
//树加载
function treeData(obj) {
	// 为达到自动展开到对应节点功能以提升用户体验	--杨赛 2015年8月5日
	// 根据页面逻辑这里只是查询了TOP_SYS_MODULE表
    SystemModelAction.getAllModuleTree(function(data){		//将模块全部查询出来
		if(data == null || data == "") {
			//当为空时，进行根节点新增操作
			var emptydata=[{title:"没有数据"}];
   			obj.setDatasource(emptydata);
		} else {
			var treeData = jQuery.parseJSON(data);
			treeData.expand = true;
			treeData.activate = true;
	    	obj.setDatasource(treeData);
	    	
	    	var sourceNode = sourceModuleId ? obj.getNode(sourceModuleId) : null;
	    	if(sourceNode) {	//需要自动定位到对应实体应用方便于用户选择
	    		sourceNode.activate();
				sourceNode.expand();
				treeClick(sourceNode);
				//定位到对应的选中的项
				$(".bl_box_left").scrollTop($(".dynatree-active").offset().top-($(".bl_box_left").height()/3));
	    	}else {
	    		treeClick(obj.getActiveNode());
	    	}
		}
     });
}
//树点击
function treeClick(node) {
    var id = node.getData("key");
    clickNodeId = id;
    // add by 杨赛 2015年8月5日
    // sysModule = node.getData().data.sysModule;//标识当前节点是系统模块还是统一分类
    // var classifyCode = node.getData().data.CONFIGCLASSIFYFULLCODE;
    sysModule = 'Yes';
    var classifyCode = node.getData().data.moduleCode;
    var param = "classifyId=" + id + "&sysModule=" + sysModule+"&classifyCode="+classifyCode+"&dictionaryCode="+codeVal;
    cui('#body').setContentURL("center","DictionaryList.jsp?"+param);
}
//懒加载
function loadNode(node) {
    ConfigClassifyAction.getTreeNodeData(node.getData("key"),node.getData().data.sysModule, function(data) {
    	var treeData = jQuery.parseJSON(data);
    	//加载子节点信息
    	node.addChild(treeData.children);
	    node.setLazyNodeStatus(node.ok);
	    node.activate(true);
    });
}

//树双击事件
function treeOndbClick(node) {
	treeClick(node);
}
</script>
</body>
</html>