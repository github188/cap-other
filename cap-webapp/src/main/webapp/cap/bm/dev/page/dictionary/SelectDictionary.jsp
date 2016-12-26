<%
  /**********************************************************************
	* 系统建模主页面 
	* 2015-7-10  龚斌 新增、诸焕辉 修改
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>


<!doctype html>
<html>
<head>
<title>系统建模主页面</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
    <script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
    <script type='text/javascript' src='<%=request.getContextPath() %>/top/cfg/dwr/interface/ConfigClassifyAction.js'></script>
    <script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js'></script>
    <script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/SystemModelAction.js'></script>
    <script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/EntityFacade.js'></script>
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
var selectNodeId = "";
var selectNodeTitle = "";
var selectNodeType = true;
var selectNodeData = {};

var propertyName = "<c:out value='${param.propertyName}'/>";
var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
var sourceModuleId = '${param.sourceModuleId}';
var codeVal = '${param.code}';
window.onload = function(){
	sourceModuleId = getSourceModuleId(codeVal);
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
			treeData.isRoot = true;
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

//确定按钮事件
function selectOne(data){
	window.opener[callbackMethod](propertyName, data.configItemFullCode);
    window.close();
}

//清空按钮事件
function clearData(){
	window.opener[callbackMethod](propertyName, "");
    window.close();
}

//通过配置项全编码查询配置项所属的模块Id
function getSourceModuleId(dicDataFullCode){
	var gotoModulId = sourceModuleId;
	if(dicDataFullCode && dicDataFullCode != ''){
		var cfgVO;
		dwr.TOPEngine.setAsync(false);
		EntityFacade.getModulIdByCfgFullCode(dicDataFullCode,function(data){
			cfgVO = data;
		});
		dwr.TOPEngine.setAsync(true);
		if(cfgVO && cfgVO.configClassifyId){
			gotoModulId = cfgVO.configClassifyId;
		}
	}
	return gotoModulId;
}
</script>
</body>
</html>