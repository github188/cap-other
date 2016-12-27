
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
<title>配置分类维护</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
</head>
<body>
    <div uitype="borderlayout" id="border" is_root="true" gap="0px 0px 0px 0px">       
    	<div uitype="bpanel" style="overflow:hidden" position="left" id="leftMain" width="250" collapsable="true">
    		 <div style="padding-top:80px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:80px;width:100%;">
    		<div style="padding-bottom: 10px;padding-left: 10px;padding-top: 10px;">
				<span uitype="button" id="addButton" label="新增分类" on_click="editClassify"></span>
				<span uitype="button" id="editButton" label="编辑分类"  on_click="editClassify"></span>
				<span uitype="button" id="deleteButton" label="删除分类" on_click="delClassify"></span>
			</div>
			<div style="padding-left: 10px;">
				<span uitype="clickInput" id="classifyNameText" name="classifyNameText"  emptytext="请输入分类名称" enterable="true" editable="true"
		 			width="223px"  icon="search" on_iconclick="quickSearch"></span>
		 			</div>
			</div>     
               <div  id="treeDivHight" style="overflow:auto;height:100%;">
			<div style="padding-left: 10px;">
		 		<div uitype="multiNav" id="classifyNameBox" datasource="initBoxData"></div>
				<div id="ClassifyTree" uitype="Tree" children="treeData" on_lazy_read="loadNode"  on_click="treeClick" click_folder_mode="1"></div>
			</div>
			</div>
			</div>
    	</div>
	    <div uitype="bpanel" position="center" id="centerMain">
	    </div>
    </div>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/engine.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/util.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/ConfigClassifyAction.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
<script type="text/javascript"> 
//当前点击树节点id
var clickNodeId = '-1';
//当前点击树节点是否是胸膛那个模块 Yes No
var sysModule = 'No';
//初始化查询的组织数据   
var initBoxData=[];
//页面渲染
window.onload = function(){
    comtop.UI.scan();
    $("#treeDivHight").height($("#leftMain").height()-80);
}
window.onresize= function(){
	setTimeout(function(){
		$("#treeDivHight").height($("#leftMain").height()-80);
	},300);
}
//树加载
function treeData(obj) {
    ConfigClassifyAction.getTreeNodeData("-1",'Yes', function(data) {
    	if(data&&data!==""){
   			var treeData = jQuery.parseJSON(data);
   			treeData.isRoot = true;
   			obj.setDatasource(treeData);
   			//激活根节点
   			obj.getNode(treeData.key).activate(true);
   			obj.getNode(treeData.key).expand(true);
   			treeClick(obj.getActiveNode());
		}else{
			  var emptydata=[{title:"没有数据"}];
   			  obj.setDatasource(emptydata);
		}
    });
}
//树点击
function treeClick(node) {
    var id = node.getData("key");
    clickNodeId = id;
    sysModule = node.getData().data.sysModule;//标识当前节点是系统模块还是统一分类
    //当选中节点为系统模块，编辑按钮、删除按钮 屏蔽掉
    if(sysModule=='Yes'){
    	cui('#editButton').disable(true);
    	cui('#deleteButton').disable(true);
    }else{
    	cui('#editButton').disable(false);
    	cui('#deleteButton').disable(false);
    }
    var classifyCode = node.getData().data.configClassifyFullCode;
    cui('#border').setContentURL("center","ConfigItemList.jsp?classifyId=" + id + "&sysModule=" + sysModule+"&classifyCode="+classifyCode);
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
//编辑分类
var dialog;
function editClassify(event,el){
	var url='${pageScope.cuiWebRoot}/top/cfg/AddConfigClassify.jsp?sysModule='+sysModule;
	var node = cui('#ClassifyTree').getNode(clickNodeId);
	var pId= clickNodeId;//点击节点的父节点
	if(el.options.label=='编辑分类'){
		pId = node.parent().getData().key;
		url += '&pId='+pId+'&classifyId='+clickNodeId;
	}else{
		url += '&pId='+pId;
	}
	var title="配置分类编辑";
	var height = 300; 
	var width = 550; 
	//判断dialog是否存在
	if(!dialog){
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
	}
	dialog.show(url);
}
//刷新树节点
function refrushNode(type,configClassifyName,configClassifyFullCode){
	var nodeId = clickNodeId;
	if('edit' == type){ 
		//编辑
		var node = cui('#ClassifyTree').getNode(nodeId);
		node.setData("title",configClassifyName);
		node.getData().data.configClassifyFullCode = configClassifyFullCode;
		node.activate();
	}else{
		var node = cui('#ClassifyTree').getNode(nodeId);
		var children=node.children();
		if(children){
			for(var i=0; i < children.length; i++){
				children[i].remove();  
			}
		}
		loadNode(node);
		treeClick(node);
	}
}
//删除统一分类
function delClassify(){
	var node = cui('#ClassifyTree').getNode(clickNodeId);
	var nodeName = node.getData().title;
	ConfigClassifyAction.getConfigItemDeleteFlag(clickNodeId,function(result){
		if(!result){
			cui.alert("选择的【<font color='red'>"+nodeName+"</font>】包含子分类或配置项，不能删除。");
		}else{
			cui.confirm("确定要删除【<font color='red'>" + nodeName + "</font>】吗？", {
		        onYes: function(){
					ConfigClassifyAction.deleteConfigClassify(clickNodeId,function(){
						var node = cui('#ClassifyTree').getNode(clickNodeId);
						clickNodeId = node.parent().getData().key;
						refrushNode('del','','');
						cui.message('分类删除成功','success');
					});
		        }
	    	});
		}
	});
}
//快速查询
function quickSearch(){
    initBoxData=[];
    cui("#classifyNameBox").setDatasource(initBoxData);
    var keyword = cui("#classifyNameText").getValue().replace(new RegExp("/", "gm"), "//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_", "gm"), "/_");
	if(!keyword){
		cui("#ClassifyTree").show();
		//返回树展示的时候点击到树根节点
		treeClick(cui('#ClassifyTree').getNode(clickNodeId));
		//显示新增按钮
		cui('#addButton').disable(false);
		return;
	}
	dwr.TOPEngine.setAsync(false);
	//刷新选择框的数据
	var obj = {configClassifyId:cui('#ClassifyTree').getRoot().firstChild().getData().key,keyword:keyword};
	ConfigClassifyAction.quickSearchClassify(obj,function(data){
		cui("#ClassifyTree").hide();
		if (data && data.length > 0) {
			var path="";
			$.each(data,function(i,cData){
				 if(cData.configClassifyName.length>21){
					    path=cData.configClassifyName.substring(0,21)+"..";
					 }else{
						 path=cData.configClassifyName;
					 }
					initBoxData.push({href:"#",name:path,title:cData.configClassifyName,onclick:"fastQuerySelect('"+cData.configClassifyId+"','"+cData.sysModule+"','"+cData.configClassifyFullCode+"')"});
			});
		}else{
			initBoxData = [{name:'没有数据',title:'没有数据'}];
		}
	});
	dwr.TOPEngine.setAsync(true);
	cui("#classifyNameBox").setDatasource(initBoxData);
	cui("#ClassifyTree").hide();
	//快速查询时候禁用三个按钮
	cui('#addButton').disable(true);
	cui('#editButton').disable(true);
	cui('#deleteButton').disable(true);
}
//选择快速查询的记录
function fastQuerySelect(classifyId,sysModule,classifyCode){
    //clickNodeId = classifyId;
   	cui('#addButton').disable(true);
   	cui('#editButton').disable(true);
   	cui('#deleteButton').disable(true);
    cui('#border').setContentURL("center","ConfigItemList.jsp?classifyId=" + classifyId + "&sysModule=" + sysModule+"&classifyCode="+classifyCode);
}
</script>
</body>
</html>