
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>��������λ</title>
<meta http-equiv="X-UA-Compatible" content="edge" />
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/engine.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/util.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/PostOtherAction.js'></script>
 <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
</head>
<body>
    <div uitype="borderlayout" id="border" is_root="true" gap="0px 0px 0px 0px">       
    	<div uitype="bpanel" position="left" style="overflow:hidden" id="leftMain" width="255" collapsable="true" height="100%"  >
    		 <div style="padding-top:80px;width:100%;position:relative;">
                  <div style="position:absolute;top:0;left:0;height:80px;width:100%;">
    		<div style="padding-bottom: 5px;padding-left: 10px;padding-top: 10px;">
    		<% if(!isHideSystemBtn){ %>
    			<top:verifyAccess pageCode="TopOtherPostAdmin" operateCode="updateOtherPostClassify">
    				<div id="access" style="display:none"></div>
    			</top:verifyAccess>
    		   <% } %>	
    			<span uitype="button" id="addRootButton" label="������" on_click="addRootClassify"></span>
				<span uitype="button" id="addButton" label="��������" on_click="editClassify"></span>
				<span uitype="button" id="editButton" label="�༭����"  on_click="editClassify"></span>
				<span uitype="button" id="deleteButton" label="ɾ������" on_click="delClassify"></span>
			<div style="padding-bottom: 5px;padding-left: 2px;padding-top: 10px;">
			<span uitype="clickInput" id="classifyNameText" name="classifyNameText"  emptytext="�������λ����" enterable="true" editable="true"
		 			width="223px"  icon="search" on_iconclick="quickSearch"></span>
		 			</div>
		 			</div>
		 			</div>
			<div  id="treeDivHight" style="overflow:auto;height:100%;">
			<div style="padding-left: 10px;">
		 		<div uitype="multiNav" id="classifyNameBox" datasource="initBoxData"></div>
		 		<div id="div_tree" >
				  <div id="ClassifyTree" uitype="Tree" children="treeData" on_lazy_read="loadNode"  on_click="treeClick" click_folder_mode="1"></div>
			    </div>
			</div>
			</div>
          </div>
    	</div>
    	
	    <div uitype="bpanel" position="center" id="centerMain">
	    </div>
    </div>

<script type="text/javascript"> 
//��ǰ������ڵ�id
var clickNodeId = '-1';

//��ǰѡ�е����ڵ�  ���ٲ�ѯ����ʹ��
var curNodeId = '';

//��ʼ����ѯ����֯����   
var initBoxData=[];

//���ڵ�ID
var rootOrgId = "";

//ҳ����Ⱦ
window.onload = function(){
	cui("#addRootButton").hide();
    comtop.UI.scan();
    $("#treeDivHight").height($("#leftMain").height()-80);
    accessBtn();
	 if(globalUserId != 'SuperAdmin'){
		    dwr.TOPEngine.setAsync(false);
		    //��ѯ��Ͻ��Χ
		    GradeAdminAction.getGradeAdminOrgByUserId(globalUserId, function(orgId){
		    	if(orgId){
					rootOrgId = orgId;
				}else{
					rootOrgId = null;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
}

function accessBtn(){
	if($('#access').length == 0){
    	cui('#addRootButton').disable(true);
    	cui('#addButton').disable(true);
    	cui('#editButton').disable(true);
    	cui('#deleteButton').disable(true);
    }
}

window.onresize= function(){
	setTimeout(function(){
		$("#treeDivHight").height($("#leftMain").height()-80);
	},300);
}

//������
function treeData(obj) {
	dwr.TOPEngine.setAsync(false);
	PostOtherAction.queryChildrenPostClassify("-1", function(data) {
    	if(data&&data!=="{}"){
   			var treeData = jQuery.parseJSON(data);
   			treeData.isRoot = true;
   			curNodeId = treeData.key;
   			obj.setDatasource(treeData);
   			//������ڵ�
   			obj.getNode(treeData.key).activate(true);
   			obj.getNode(treeData.key).expand(true);
   			treeClick(obj.getActiveNode());
   		
		}else{
			  var emptydata=[{title:"û������"}];
   			  obj.setDatasource(emptydata);
   			  cui("#addRootButton").show();
   			  cui("#addButton").hide();
   	    	  cui('#editButton').disable(true);
   	    	  cui('#deleteButton').disable(true);
   			  //setEditUrl(curOrgStrucId,'','','');
   	    	 accessBtn();
		}
    });
	dwr.TOPEngine.setAsync(true);
}
//�����
function treeClick(node) {
    var id = node.getData("key");
    clickNodeId = id;
	curNodeId =id;
    var postFlag = node.getData().data.postFlag;
    var classifyName =  node.getData().data.classifyName;
    var parentName=node.parent().getData().title;
    var parentId=node.getData().data.parentClassifyId;
    if(parentName==null||parentName==""){
    	parentName=classifyName;
    }
    
    
  //ѡ�ϸ�λ�ڵ�󣬷��ఴťӦ���û�
    if(postFlag==2){
    	 cui('#addButton').disable(true);
    	 cui('#editButton').disable(true);
    	 cui('#deleteButton').disable(true);
    	 accessBtn();
    	 cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + id + "&postFlag=" + postFlag+"&rootOrgId="+rootOrgId+ "&classifyName=" + encodeURIComponent(encodeURIComponent(classifyName))+ "&parentName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentId=" + parentId);
    }else{  //�������
    	 cui('#addButton').disable(false);
    	 cui('#editButton').disable(false);
    	 cui('#deleteButton').disable(false);
    	 accessBtn();
    	 cui('#border').setContentURL("center","PostOtherList.jsp?classifyId=" + id +"&postFlag=" + postFlag+ "&classifyName=" + encodeURIComponent(encodeURIComponent(classifyName))+ "&parentName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentId=" + parentId);
    }
}
//������
function loadNode(node) {
	dwr.TOPEngine.setAsync(false);
	PostOtherAction.queryChildrenPostClassify(node.getData("key"), function(data) {
			if(data&&data!=="{}"){
			    	var treeData = jQuery.parseJSON(data);
			    	curNodeId = node.getData().key;
			    	//�����ӽڵ���Ϣ
			    	node.addChild(treeData.children);
			}else{
				  var emptydata=[{title:"û������"}];
				  cui('#ClassifyTree').setDatasource(emptydata);
	   			  cui("#addRootButton").show();
	   			  cui("#addButton").hide();
	   	    	  cui('#editButton').disable(true);
	   	    	  cui('#deleteButton').disable(true);
	   	    	 accessBtn();
			}
    });
	dwr.TOPEngine.setAsync(true);
}

//����������
var dialog;
function addRootClassify(event,el){
	var pId ="-1";
	var url='${pageScope.cuiWebRoot}/top/sys/post/AddPostClassify.jsp?parentId='+pId;
	var title="����������";
	var height = 250; //300
	var width = 500; // 560;
	 if(!dialog){//��ֹ�ظ���������
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
	 }
	dialog.show(url);
}



	//�༭����
	var dialog;
	function editClassify(event,el){
		var url='${pageScope.cuiWebRoot}/top/sys/post/AddPostClassify.jsp';
		//var node = cui('#ClassifyTree').getNode(clickNodeId);
		var node =cui('#ClassifyTree').getActiveNode();
		var parentId= "";//����ڵ�ĸ��ڵ�
		if(el.options.label=='�༭����'){
		    parentId=node.getData().data.parentClassifyId;
			url += '?parentId='+parentId+'&classifyId='+node.getData().key;
		}else{
			parentId =node.getData().key;
			url += '?parentId='+parentId;
		}
		var title="����༭";
		var height = 300; //300
		var width = 550; // 560;
		if(!dialog){//��ֹ�ظ���������
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
function refrushNode(type,classifyId,parentId,classifyName){
     
	if('addRoot'==type){//����������Ĵ���
		cui("#addRootButton").hide();
	    cui("#addButton").show();
	    dwr.TOPEngine.setAsync(false);
	    PostOtherAction.queryChildrenPostClassify("-1", function(data) {
	    	if(data&&data!=="{}"){
	   			var treeData = jQuery.parseJSON(data);
	   			treeData.isRoot = true;
	   		    cui('#ClassifyTree').setDatasource(treeData);
	   			//������ڵ�
	   			cui('#ClassifyTree').getNode(treeData.key).activate(true);
	   			cui('#ClassifyTree').getNode(treeData.key).expand(true);
	   			treeClick(cui('#ClassifyTree').getActiveNode());
			}
	    });
		dwr.TOPEngine.setAsync(true);
	} else{
		
		//var nodeId = clickNodeId;//�����¼�����
		if('edit' == type){//�༭ֱ�Ӹ��Ľڵ����ƺͶ�λ
			var node = cui('#ClassifyTree').getActiveNode();
			node.setData("title",classifyName);
			node.getData().data.classifyName=classifyName;
			node.activate();
			node.focus(true);
			treeClick(node);
		} else{
			
			var node = cui('#ClassifyTree').getNode(parentId);
			node.getData().isLazy=false;
			var children=node.children();
			if(children){
				for(var i=0; i < children.length; i++){
					children[i].remove();  
				}
			}
			
			loadNode(node);
			clickNodeId=classifyId;
			//������������������Ľڵ㣬��ֹ������λ���������಻��ȷ
			treeClick(cui('#ClassifyTree').getNode(classifyId));
			cui('#ClassifyTree').getNode(classifyId).activate(true);
   			cui('#ClassifyTree').getNode(classifyId).focus(true);
	     }
	}
	
}


//ˢ�����ڵ�  numĬ��0  �ص�����num��1��������2�Ǳ༭��3��ɾ����4���� ������,5����
function refrushNodeByPost(parmClassifyName,postId,parentId,num){

			//��ʾ��
			cui("#classifyNameBox").hide();
			cui("#ClassifyTree").show();

		//�Ƴ�parentId�µ������ӽڵ㣬���¼����ӽڵ�
	    var node = cui('#ClassifyTree').getNode(parentId);
	   
		
		if(node){ //�ڵ��Ѿ�����
			node.getData().isLazy=false;
			var children=node.children();
			if(children){
				for(var i=0; i < children.length; i++){
					children[i].remove();  
				}
			}
			loadNode(node);
		}else{//�ڵ�δ����
			
			var tmpPostId=postId;
			if(num==3||num==4){
				tmpPostId="";
			     }
			 //�õ������ͱ༭�ڵ��ID Path
           
			 var path;
			 dwr.TOPEngine.setAsync(false);
			 PostOtherAction.queryIDFullPath(parentId,tmpPostId,function(data){
					path = data.split('/');
			 });
			 dwr.TOPEngine.setAsync(true);
			 //�Ӹ��ڵ㿪ʼ������ֱ��չ������ǰ�ڵ�Ϊֹ ����ѡ�е�ǰ�ڵ�
			  
			$.each(path,function(i,iPostId){
				var iNode = cui("#ClassifyTree").getNode(iPostId);
				if(i==path.length-1){
					iNode.activate(true);
				}else{
					iNode.expand(true);
				}
			});
			
		}
		if(num==1){
			//ѡ���λ��Ҫ�ûҷ��ఴť
			 cui('#addButton').disable(true);
	    	 cui('#editButton').disable(true);
	    	 cui('#deleteButton').disable(true);
	    	 accessBtn();
   			cui('#ClassifyTree').getNode(postId).activate(true);
   			cui('#ClassifyTree').getNode(postId).focus(true);
   			//��ʾ�ұ�ҳ��
   			cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + postId + "&postFlag=2&parentId=" + parentId+"&rootOrgId="+rootOrgId+"&parentName=" + encodeURIComponent(encodeURIComponent(parmClassifyName)));
		}
		if(num==2){
			//ѡ���λ��Ҫ�ûҷ��ఴť
			 cui('#addButton').disable(true);
	    	 cui('#editButton').disable(true);
	    	 cui('#deleteButton').disable(true);
	    	 accessBtn();
   			cui('#ClassifyTree').getNode(postId).activate(true);
   			cui('#ClassifyTree').getNode(postId).focus(true);
		}
		if(num==3){
			cui('#addButton').disable(false);
	    	 cui('#editButton').disable(false);
	    	 cui('#deleteButton').disable(false);
	    	 accessBtn();
   			cui('#ClassifyTree').getNode(parentId).activate(true);
   			cui('#ClassifyTree').getNode(parentId).focus(true);
   			clickNodeId=parentId;
   		    //��ʾ�ұ�ҳ��  ����ɾ����λ���ϼ�����
   		   cui('#border').setContentURL("center","PostOtherList.jsp?classifyId=" + parentId +"&postFlag=" + 1+ "&classifyName=" + encodeURIComponent(encodeURIComponent(parmClassifyName)));
   		    
		}
		if(num==4){
			cui('#addButton').disable(false);
	    	cui('#editButton').disable(false);
	    	cui('#deleteButton').disable(false);
	    	 accessBtn();
			cui('#ClassifyTree').getNode(parentId).activate(true);
   			cui('#ClassifyTree').getNode(parentId).focus(true);
   			clickNodeId=parentId;
		}
		
		if(num==5){
			cui('#addButton').disable(false);
	    	 cui('#editButton').disable(false);
	    	 cui('#deleteButton').disable(false);
	    	 accessBtn();
  			cui('#ClassifyTree').getNode(parentId).activate(true);
  			cui('#ClassifyTree').getNode(parentId).focus(true);
  			clickNodeId=parentId;
		}
		
	
}

//ɾ������
function delClassify(){
	var node = cui('#ClassifyTree').getNode(clickNodeId);
	var nodeName = node.getData().title;
	PostOtherAction.getPostClassifyDeleteFlag(clickNodeId,function(result){
	
		if(!result){
			cui.alert("ѡ��ġ�<font color='red'>"+nodeName+"</font>�������ӷ�����λ������ɾ����");
		}else{
			cui.confirm("ȷ��Ҫɾ����<font color='red'>" + nodeName + "</font>����", {
		        onYes: function(){
		        	dwr.TOPEngine.setAsync(false);
		        	PostOtherAction.deletePostOtherClassify(clickNodeId,function(){
						var node = cui('#ClassifyTree').getNode(clickNodeId);
						clickNodeId = node.parent().getData().key;
						refrushNode('delete',clickNodeId,clickNodeId,0);
						cui.message('ɾ������ɹ�','success');
					});
		        	dwr.TOPEngine.setAsync(true);
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
		 cui("#classifyNameBox").hide();
		cui("#ClassifyTree").show();
		var node = cui('#ClassifyTree').getNode(curNodeId);
		if(node){
			treeClick(node);
			}
	}else{
		dwr.TOPEngine.setAsync(false);
		//ˢ��ѡ��������
		var obj = {classifyId:cui('#ClassifyTree').getRoot().firstChild().getData().key,keyword:keyword};
		PostOtherAction.quickSearchPostOther(obj,function(data){
			cui("#ClassifyTree").hide();
			if (data && data.length > 0) {
				var path="";
				$.each(data,function(i,cData){
					 if(cData.otherPostName.length>21){
						    path=cData.otherPostName.substring(0,21)+"..";
						 }else{
							 path=cData.otherPostName;
						 }
						initBoxData.push({href:"#",name:path,title:cData.nameFullPath,onclick:"fastQuerySelect('"+cData.classifyId+"','"+cData.otherPostId+"','"+cData.classifyName+"','"+cData.otherPostName+"')"});
				});
			}else{
				initBoxData = [{name:'û������',title:'û������'}];
				 cui('#addButton').disable(true);
		    	 cui('#editButton').disable(true);
		    	 cui('#deleteButton').disable(true);
		    	 accessBtn();
			}
		});
		dwr.TOPEngine.setAsync(true);
		cui("#classifyNameBox").setDatasource(initBoxData);
		cui("#classifyNameBox").show();
		cui("#ClassifyTree").hide();
	}
}
//ѡ����ٲ�ѯ�ļ�¼
function fastQuerySelect(classifyId,postId,parentName,postName){
	
     cui('#addButton').disable(true);
     cui('#editButton').disable(true);
     cui('#deleteButton').disable(true);
     accessBtn();
    
    clickNodeId = postId;
	cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + postId + "&postFlag=2&parentId=" + classifyId+"&rootOrgId="+rootOrgId+"&parentName=" +  encodeURIComponent(encodeURIComponent(parentName))+"&classifyName=" +  encodeURIComponent(encodeURIComponent(postName)));
}



</script>
</body>
</html>