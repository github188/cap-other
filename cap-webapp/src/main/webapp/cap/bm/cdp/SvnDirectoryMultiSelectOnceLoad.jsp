<%
  /**********************************************************************
		* SVN库的目录选择 （多选）
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
	                    <div id="moduleTree" uitype="Tree" children="initData" select_mode="2"  checkbox="true"
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
	var path = "${param.path}";
	
	window.onload = function(){
	  		comtop.UI.scan();
	}

	//初始化数据 ---一次加载 
	function initData(obj) {
		var configRepositoryVO = {repositoryUrl:repositoryUrl,username:username,password:password};
		cui.handleMask.show();
		SvnDirectoryAction.getAllSvnDirTree(configRepositoryVO,function(data){
				cui.handleMask.hide();
				var treeData = jQuery.parseJSON(data);
				treeData.expand = true;
				treeData.activate = true;
		    	obj.setDatasource(treeData);
		    	if(path){
		    		var splits = path.split(',');
		    		for(var i = 0; i < splits.length; i++){
		    			obj.selectNode(repositoryUrl + "/" + splits[i],true);
		    			var sourceNode = obj.getNode(repositoryUrl + "/" + splits[i]);
		    			sourceNode.activate();
						sourceNode.expand();
		    		}
					//定位到对应的选中的项
					$(".bl_box_center").scrollTop($(".dynatree-active").offset().top-($(".bl_box_center").height()/3));
		    	}
	     });
	}

	//点击确定按钮
	function confirm(){
		var nodeKeys = "";
		var selectNodes = cui("#moduleTree").getSelectedNodes();
		if(selectNodes && selectNodes.length > 0){
			for(var i = 0; i < selectNodes.length; i++){
				var fullPath = selectNodes[i].getData().key;
				var relativePath = fullPath.replace(repositoryUrl, "");
				relativePath = relativePath.substr(1); //去掉最前面的"/"
				nodeKeys +=  relativePath + ",";
			}
		}else{
			cui.alert("请选择节点。");
			return;
		}
		if(nodeKeys){
			nodeKeys = nodeKeys.substring(0,nodeKeys.length-1);
		}
		window.parent.selMultiBackOnce(nodeKeys);
	}
	
	//关闭窗口
	function closeWindow(){
		parent.closeDialog(); 
	}
</script>
</body>
</html>