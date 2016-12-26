<%
/**********************************************************************
* 页面/菜单所属上级目录选择
* 2015-6-19 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>页面/菜单所属上级目录选择</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">

    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/top/sys/dwr/engine.js"></top:script>
	<top:script src="/top/sys/dwr/util.js"></top:script>
	<top:script src="/top/sys/dwr/interface/FuncAction.js"></top:script>
	<top:script src="/top/sys/dwr/interface/SystemModelAction.js"></top:script>
    <script type="text/javascript">
    
    var parentId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("parentId"))%>;//parentId为fundId
    var moduleId ="";
    
    jQuery(document).ready(function(){
    	//把fundId转换为moduleID
    	dwr.TOPEngine.setAsync(false);
    	FuncAction.readFunc(parentId,function(result){
    		moduleId = result.parentFuncId;
    	});
    	dwr.TOPEngine.setAsync(true);
    	comtop.UI.scan();
    	initData();
    });
    
    function setCatalog(){
    	var node=cui("#tree").getActiveNode();
    	var result={};
    	var moduleType = node.getData().data.moduleType;
    	if(!node||moduleType!=2){
    		cui.alert('请选择目录！', function(){});
    	}else{
    		result=cui("#tree").getActiveNode().getData();
    		//把fundId转换为moduleID
        	dwr.TOPEngine.setAsync(false);
        	FuncAction.readFuncByModuleId(result.key,function(data){
        		result.key = data.funcId;
        	});
        	dwr.TOPEngine.setAsync(true);
    		window.opener.setCatalog(result);
    		window.close();
    	}
	}
    
    function initData(){
    	SystemModelAction.getAllModuleTree(function(data){
    		if(data == null || data == "") {
    			var treeData = {title:"暂无数据",key:"0"};
    			treeData.activate = true;
    			cui("#tree").setDatasource(treeData);
    		} else {
    			var treeData = jQuery.parseJSON(data);
    			treeData.expand = true;
    			treeData.activate = true;
    			cui("#tree").setDatasource(treeData);
    	    	var sourceNode = moduleId ? cui("#tree").getNode(moduleId) : null;
    	    	if(sourceNode) {	//有来源实体需要自动定位到对应实体应用方便于用户选择
    	    		sourceNode.activate();
    				//定位到对应的选中的项
    				$(".bl_box_center").scrollTop($(".dynatree-active").offset().top-($(".bl_box_center").height()/3));
    	    	}
    		}
         });
    }
    
    </script>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true" >
		<div position="top" height="50">
       <table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="模块/应用目录选择" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="code" uitype="Button" label="确定" onClick="setCatalog()"></span>
		        	<span id="code" uitype="Button" label="关闭" onClick="window.close()"></span>
		        </td>
		    </tr>
	</table>
	</div>
	<div id="leftMain" position="center" width="300" collapsabltie="true" show_expand_icon="true"> 
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:100%">
		        	<span id="tree" uitype="Tree" click_folder_mode="1" ></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        </td>
		    </tr>
		</table>
	</div>
</div>
</body>
</html>