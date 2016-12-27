
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
<title>���÷���ά��</title>
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
				<span uitype="button" id="addButton" label="��������" on_click="editClassify"></span>
				<span uitype="button" id="editButton" label="�༭����"  on_click="editClassify"></span>
				<span uitype="button" id="deleteButton" label="ɾ������" on_click="delClassify"></span>
			</div>
			<div style="padding-left: 10px;">
				<span uitype="clickInput" id="classifyNameText" name="classifyNameText"  emptytext="�������������" enterable="true" editable="true"
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
//��ǰ������ڵ�id
var clickNodeId = '-1';
//��ǰ������ڵ��Ƿ��������Ǹ�ģ�� Yes No
var sysModule = 'No';
//��ʼ����ѯ����֯����   
var initBoxData=[];
//ҳ����Ⱦ
window.onload = function(){
    comtop.UI.scan();
    $("#treeDivHight").height($("#leftMain").height()-80);
}
window.onresize= function(){
	setTimeout(function(){
		$("#treeDivHight").height($("#leftMain").height()-80);
	},300);
}
//������
function treeData(obj) {
    ConfigClassifyAction.getTreeNodeData("-1",'Yes', function(data) {
    	if(data&&data!==""){
   			var treeData = jQuery.parseJSON(data);
   			treeData.isRoot = true;
   			obj.setDatasource(treeData);
   			//������ڵ�
   			obj.getNode(treeData.key).activate(true);
   			obj.getNode(treeData.key).expand(true);
   			treeClick(obj.getActiveNode());
		}else{
			  var emptydata=[{title:"û������"}];
   			  obj.setDatasource(emptydata);
		}
    });
}
//�����
function treeClick(node) {
    var id = node.getData("key");
    clickNodeId = id;
    sysModule = node.getData().data.sysModule;//��ʶ��ǰ�ڵ���ϵͳģ�黹��ͳһ����
    //��ѡ�нڵ�Ϊϵͳģ�飬�༭��ť��ɾ����ť ���ε�
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
//������
function loadNode(node) {
    ConfigClassifyAction.getTreeNodeData(node.getData("key"),node.getData().data.sysModule, function(data) {
    	var treeData = jQuery.parseJSON(data);
    	//�����ӽڵ���Ϣ
    	node.addChild(treeData.children);
	    node.setLazyNodeStatus(node.ok);
	    node.activate(true);
    });
}
//�༭����
var dialog;
function editClassify(event,el){
	var url='${pageScope.cuiWebRoot}/top/cfg/AddConfigClassify.jsp?sysModule='+sysModule;
	var node = cui('#ClassifyTree').getNode(clickNodeId);
	var pId= clickNodeId;//����ڵ�ĸ��ڵ�
	if(el.options.label=='�༭����'){
		pId = node.parent().getData().key;
		url += '&pId='+pId+'&classifyId='+clickNodeId;
	}else{
		url += '&pId='+pId;
	}
	var title="���÷���༭";
	var height = 300; 
	var width = 550; 
	//�ж�dialog�Ƿ����
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
//ˢ�����ڵ�
function refrushNode(type,configClassifyName,configClassifyFullCode){
	var nodeId = clickNodeId;
	if('edit' == type){ 
		//�༭
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
//ɾ��ͳһ����
function delClassify(){
	var node = cui('#ClassifyTree').getNode(clickNodeId);
	var nodeName = node.getData().title;
	ConfigClassifyAction.getConfigItemDeleteFlag(clickNodeId,function(result){
		if(!result){
			cui.alert("ѡ��ġ�<font color='red'>"+nodeName+"</font>�������ӷ�������������ɾ����");
		}else{
			cui.confirm("ȷ��Ҫɾ����<font color='red'>" + nodeName + "</font>����", {
		        onYes: function(){
					ConfigClassifyAction.deleteConfigClassify(clickNodeId,function(){
						var node = cui('#ClassifyTree').getNode(clickNodeId);
						clickNodeId = node.parent().getData().key;
						refrushNode('del','','');
						cui.message('����ɾ���ɹ�','success');
					});
		        }
	    	});
		}
	});
}
//���ٲ�ѯ
function quickSearch(){
    initBoxData=[];
    cui("#classifyNameBox").setDatasource(initBoxData);
    var keyword = cui("#classifyNameText").getValue().replace(new RegExp("/", "gm"), "//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_", "gm"), "/_");
	if(!keyword){
		cui("#ClassifyTree").show();
		//������չʾ��ʱ�����������ڵ�
		treeClick(cui('#ClassifyTree').getNode(clickNodeId));
		//��ʾ������ť
		cui('#addButton').disable(false);
		return;
	}
	dwr.TOPEngine.setAsync(false);
	//ˢ��ѡ��������
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
			initBoxData = [{name:'û������',title:'û������'}];
		}
	});
	dwr.TOPEngine.setAsync(true);
	cui("#classifyNameBox").setDatasource(initBoxData);
	cui("#ClassifyTree").hide();
	//���ٲ�ѯʱ�����������ť
	cui('#addButton').disable(true);
	cui('#editButton').disable(true);
	cui('#deleteButton').disable(true);
}
//ѡ����ٲ�ѯ�ļ�¼
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