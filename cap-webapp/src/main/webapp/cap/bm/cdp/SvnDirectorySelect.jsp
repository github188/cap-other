<%
  /**********************************************************************
		* SVN库的目录选择 
		* 2016-09-05 CAP超级管理员 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>


<!doctype html>
<html>
<head>
<title>Svn目录选择</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
    <top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
    <top:script src="/cap/dwr/util.js"></top:script>
    <top:script src="/cap/dwr/interface/SvnDirectoryAction.js"></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div uitype="Borderlayout"  id="body"  is_root="true" >
		<div id="topMain" position ="top" height="38">
				<div style="float:right;margin-top:4px;">
					<span uitype="button" label="确定" on_click="confirm"></span>
					<span uitype="button" label="关闭" on_click="closeWindow"></span>
				</div>
		</div>
		<div id="centerMain" position ="center">
			<table width="95%" style="margin-left: 10px">
				<tr id="tr_moduleTree">
					<td>
	                    <div id="moduleTree" uitype="Tree" children="initData" on_lazy_read="loadNode"  
	                    	on_click="treeClick"  min_expand_level="1"    click_folder_mode="1"></div>
	                   </td>
				</tr>
			</table>
		</div>
	</div>

<script type="text/javascript">
	var repositoryUrl = "${param.repositoryUrl}";
	var username = "${param.username}";
	var password = "${param.password}";
	
	//对付树节点单选必选显示单选按钮的， 不想显示单选按钮，采用treeclick来做中间参数
	var selectNodeData;
	
	window.onload = function(){
	  		comtop.UI.scan();
	}

	//初始化数据 ---一次加载 
	function initDataAll(obj) {
		var configRepositoryVO = {repositoryUrl:repositoryUrl,username:username,password:password};
		SvnDirectoryAction.getAllSvnDirTree(configRepositoryVO,function(data){
				var treeData = jQuery.parseJSON(data);
				treeData.expand = true;
				treeData.activate = true;
		    	obj.setDatasource(treeData);
		    	//定位节点 
		    	/**var sourceNode = packageId ? obj.getNode(packageId) : null;
		    	if(sourceNode) {	//有来源实体需要自动定位到对应实体应用方便于用户选择
		    		sourceNode.activate();
					sourceNode.expand();
					//定位到对应的选中的项
					$(".bl_box_left").scrollTop($(".dynatree-active").offset().top-($(".bl_box_left").height()/3));
		    	}**/
	     });
	}

	//初始化数据 -----懒加载
	function initData(obj) {
		var configRepositoryVO = {repositoryUrl:repositoryUrl,username:username,password:password};
		var svnTreeVO = {parentUrl:"-1"};
		dwr.TOPEngine.setAsync(false);
		SvnDirectoryAction.getLazySvnDirTree(configRepositoryVO,svnTreeVO,function(data){
				var treeData = jQuery.parseJSON(data);
				treeData.expand = true;
				treeData.activate = true;
		    	obj.setDatasource(treeData);
	     });
		dwr.TOPEngine.setAsync(true);
	}
	
	//点击click事件加载节点方法
	function loadNode(node) {
		var configRepositoryVO = {repositoryUrl:repositoryUrl,username:username,password:password};
		var svnTreeVO = node.getData().data;
		dwr.TOPEngine.setAsync(false);
		SvnDirectoryAction.getLazySvnDirTree(configRepositoryVO,svnTreeVO,function(data){
	    	var treeData = jQuery.parseJSON(data);
	    	var childData = treeData.children;
	    	treeData.activate = true;
	    	node.addChild(childData);
			node.setLazyNodeStatus(node.ok);
	     });
		dwr.TOPEngine.setAsync(true);
	}

	//点击确定按钮
	function confirm(){
		if(selectNodeData == null || selectNodeData.data.parentUrl === "-1"){
			cui.alert("请选择节点。");
			return;
		}
		//alert("节点类型："+selectNodeData.data.type);
		
		//返回相对路径
		window.parent.selSingleBack(selectNodeData);
	}
	
	//树单击事件
	function treeClick(node){
		selectNodeData = node.getData();
	}


//关闭窗口
function closeWindow(){
	parent.closeDialog(); 
}
</script>
</body>
</html>