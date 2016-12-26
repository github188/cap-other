<%
/**********************************************************************
* 应用模式管理编辑页面
* 2016-08-02 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>数据库选择页面</title>
    <top:link href="/cap/rt/common/base/css/base.css"/>
    <top:link href="/cap/rt/common/base/css/comtop.cap.rt.css"/>
    <top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
    <style type="text/css">
    	.cap-page{
    		width: 1024px;
    	}
    	body{padding:10px;}
    	.header-button{
    		height:20px;
    	}
    </style>
	<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
	<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
	<top:script src='/cap/rt/common/globalVars.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.extend.dictionary.js'></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/EvcontralListPageAction.js'></top:script>
    
</head>
<body>
	<div class="header-button">
		<div style="float:right">
			<span uitype="button" label="确定" on_click="confirm"></span>
			<span uitype="button" label="关闭" on_click="closeWindow"></span>
		</div>
	</div>
	<div id="databaseConfigTree" uitype="Tree" checkbox="true"
		select_mode="3" min_expand_level="3"></div>
</body>

<script type="text/javascript">
var databaseConfigCodes = '${param.databaseConfigCodes}';
var treeData = readTreeData();

function readTreeData(){
	var result;
	dwr.TOPEngine.setAsync(false);
	EvcontralListPageAction.getDatabaseConfigTree(
			function(data){
				result = data;
	});
	dwr.TOPEngine.setAsync(true);
	return result;
}
comtop.UI.scan();
initPage();

function initPage(){
	cui('#databaseConfigTree').setDatasource(treeData);
	if(databaseConfigCodes != '' && databaseConfigCodes != 'undefined'){
		var splits = databaseConfigCodes.split(',');
		for(var i = 0; i < databaseConfigCodes.length; i++){
			cui('#databaseConfigTree').selectNode(splits[i],true);
		}
	}
}

function confirm(){
	var rootNode = cui("#databaseConfigTree").getNode('all');
	if(rootNode.dNode.bSelected){
		parent.selectDatabaseCallback([{name:'所有', code:'all'}]);
		parent.closeDialog();
	}else{
		var selectNodes = cui("#databaseConfigTree").getSelectedNodes();
	    if(selectNodes){
	    	var filterNodes = filterCodes(selectNodes);
	    	if(filterNodes.length > 0){
	    		parent.selectDatabaseCallback(filterNodes);
	    		parent.closeDialog();
	    	}else{
	    		cui.alert('必须选择至少一个数据库。');
	    	}
	    }
	}
   
    
}

function filterCodes(selectNodes){
	var result = [];
	for(var i = 0; i < selectNodes.length; i++){
		var item = {};
		if(selectNodes[i].dNode.data.type == "database"){
			item.name = selectNodes[i].dNode.data.title;
			item.code = selectNodes[i].dNode.data.key;
			result.push(item);
		}
	}
	return result;
}
function closeWindow(){
	parent.closeDialog(); 
}
</script>
</html>