
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>非行政岗位</title>
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
    			<span uitype="button" id="addRootButton" label="新增根" on_click="addRootClassify"></span>
				<span uitype="button" id="addButton" label="新增分类" on_click="editClassify"></span>
				<span uitype="button" id="editButton" label="编辑分类"  on_click="editClassify"></span>
				<span uitype="button" id="deleteButton" label="删除分类" on_click="delClassify"></span>
			<div style="padding-bottom: 5px;padding-left: 2px;padding-top: 10px;">
			<span uitype="clickInput" id="classifyNameText" name="classifyNameText"  emptytext="请输入岗位名称" enterable="true" editable="true"
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
//当前点击树节点id
var clickNodeId = '-1';

//当前选中的树节点  快速查询返回使用
var curNodeId = '';

//初始化查询的组织数据   
var initBoxData=[];

//根节点ID
var rootOrgId = "";

//页面渲染
window.onload = function(){
	cui("#addRootButton").hide();
    comtop.UI.scan();
    $("#treeDivHight").height($("#leftMain").height()-80);
    accessBtn();
	 if(globalUserId != 'SuperAdmin'){
		    dwr.TOPEngine.setAsync(false);
		    //查询管辖范围
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

//树加载
function treeData(obj) {
	dwr.TOPEngine.setAsync(false);
	PostOtherAction.queryChildrenPostClassify("-1", function(data) {
    	if(data&&data!=="{}"){
   			var treeData = jQuery.parseJSON(data);
   			treeData.isRoot = true;
   			curNodeId = treeData.key;
   			obj.setDatasource(treeData);
   			//激活根节点
   			obj.getNode(treeData.key).activate(true);
   			obj.getNode(treeData.key).expand(true);
   			treeClick(obj.getActiveNode());
   		
		}else{
			  var emptydata=[{title:"没有数据"}];
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
//树点击
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
    
    
  //选上岗位节点后，分类按钮应该置灰
    if(postFlag==2){
    	 cui('#addButton').disable(true);
    	 cui('#editButton').disable(true);
    	 cui('#deleteButton').disable(true);
    	 accessBtn();
    	 cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + id + "&postFlag=" + postFlag+"&rootOrgId="+rootOrgId+ "&classifyName=" + encodeURIComponent(encodeURIComponent(classifyName))+ "&parentName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentId=" + parentId);
    }else{  //点击分类
    	 cui('#addButton').disable(false);
    	 cui('#editButton').disable(false);
    	 cui('#deleteButton').disable(false);
    	 accessBtn();
    	 cui('#border').setContentURL("center","PostOtherList.jsp?classifyId=" + id +"&postFlag=" + postFlag+ "&classifyName=" + encodeURIComponent(encodeURIComponent(classifyName))+ "&parentName=" + encodeURIComponent(encodeURIComponent(parentName))+ "&parentId=" + parentId);
    }
}
//懒加载
function loadNode(node) {
	dwr.TOPEngine.setAsync(false);
	PostOtherAction.queryChildrenPostClassify(node.getData("key"), function(data) {
			if(data&&data!=="{}"){
			    	var treeData = jQuery.parseJSON(data);
			    	curNodeId = node.getData().key;
			    	//加载子节点信息
			    	node.addChild(treeData.children);
			}else{
				  var emptydata=[{title:"没有数据"}];
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

//新增根分类
var dialog;
function addRootClassify(event,el){
	var pId ="-1";
	var url='${pageScope.cuiWebRoot}/top/sys/post/AddPostClassify.jsp?parentId='+pId;
	var title="新增根分类";
	var height = 250; //300
	var width = 500; // 560;
	 if(!dialog){//防止重复创建对象
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
	 }
	dialog.show(url);
}



	//编辑分类
	var dialog;
	function editClassify(event,el){
		var url='${pageScope.cuiWebRoot}/top/sys/post/AddPostClassify.jsp';
		//var node = cui('#ClassifyTree').getNode(clickNodeId);
		var node =cui('#ClassifyTree').getActiveNode();
		var parentId= "";//点击节点的父节点
		if(el.options.label=='编辑分类'){
		    parentId=node.getData().data.parentClassifyId;
			url += '?parentId='+parentId+'&classifyId='+node.getData().key;
		}else{
			parentId =node.getData().key;
			url += '?parentId='+parentId;
		}
		var title="分类编辑";
		var height = 300; //300
		var width = 550; // 560;
		if(!dialog){//防止重复创建对象
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
function refrushNode(type,classifyId,parentId,classifyName){
     
	if('addRoot'==type){//新增根分类的处理
		cui("#addRootButton").hide();
	    cui("#addButton").show();
	    dwr.TOPEngine.setAsync(false);
	    PostOtherAction.queryChildrenPostClassify("-1", function(data) {
	    	if(data&&data!=="{}"){
	   			var treeData = jQuery.parseJSON(data);
	   			treeData.isRoot = true;
	   		    cui('#ClassifyTree').setDatasource(treeData);
	   			//激活根节点
	   			cui('#ClassifyTree').getNode(treeData.key).activate(true);
	   			cui('#ClassifyTree').getNode(treeData.key).expand(true);
	   			treeClick(cui('#ClassifyTree').getActiveNode());
			}
	    });
		dwr.TOPEngine.setAsync(true);
	} else{
		
		//var nodeId = clickNodeId;//新增下级分类
		if('edit' == type){//编辑直接更改节点名称和定位
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
			//新增分类点击新增分类的节点，防止新增岗位后所属分类不正确
			treeClick(cui('#ClassifyTree').getNode(classifyId));
			cui('#ClassifyTree').getNode(classifyId).activate(true);
   			cui('#ClassifyTree').getNode(classifyId).focus(true);
	     }
	}
	
}


//刷新树节点  num默认0  回调类型num：1是新增，2是编辑，3是删除，4保存 并继续,5返回
function refrushNodeByPost(parmClassifyName,postId,parentId,num){

			//显示树
			cui("#classifyNameBox").hide();
			cui("#ClassifyTree").show();

		//移除parentId下的所有子节点，重新加载子节点
	    var node = cui('#ClassifyTree').getNode(parentId);
	   
		
		if(node){ //节点已经加载
			node.getData().isLazy=false;
			var children=node.children();
			if(children){
				for(var i=0; i < children.length; i++){
					children[i].remove();  
				}
			}
			loadNode(node);
		}else{//节点未加载
			
			var tmpPostId=postId;
			if(num==3||num==4){
				tmpPostId="";
			     }
			 //得到新增和编辑节点的ID Path
           
			 var path;
			 dwr.TOPEngine.setAsync(false);
			 PostOtherAction.queryIDFullPath(parentId,tmpPostId,function(data){
					path = data.split('/');
			 });
			 dwr.TOPEngine.setAsync(true);
			 //从根节点开始遍历，直到展开到当前节点为止 ，并选中当前节点
			  
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
			//选择岗位需要置灰分类按钮
			 cui('#addButton').disable(true);
	    	 cui('#editButton').disable(true);
	    	 cui('#deleteButton').disable(true);
	    	 accessBtn();
   			cui('#ClassifyTree').getNode(postId).activate(true);
   			cui('#ClassifyTree').getNode(postId).focus(true);
   			//显示右边页面
   			cui('#border').setContentURL("center","PostOtherEdit.jsp?classifyId=" + postId + "&postFlag=2&parentId=" + parentId+"&rootOrgId="+rootOrgId+"&parentName=" + encodeURIComponent(encodeURIComponent(parmClassifyName)));
		}
		if(num==2){
			//选择岗位需要置灰分类按钮
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
   		    //显示右边页面  返回删除岗位的上级分类
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

//删除分类
function delClassify(){
	var node = cui('#ClassifyTree').getNode(clickNodeId);
	var nodeName = node.getData().title;
	PostOtherAction.getPostClassifyDeleteFlag(clickNodeId,function(result){
	
		if(!result){
			cui.alert("选择的【<font color='red'>"+nodeName+"</font>】包含子分类或岗位，不能删除。");
		}else{
			cui.confirm("确定要删除【<font color='red'>" + nodeName + "</font>】吗？", {
		        onYes: function(){
		        	dwr.TOPEngine.setAsync(false);
		        	PostOtherAction.deletePostOtherClassify(clickNodeId,function(){
						var node = cui('#ClassifyTree').getNode(clickNodeId);
						clickNodeId = node.parent().getData().key;
						refrushNode('delete',clickNodeId,clickNodeId,0);
						cui.message('删除分类成功','success');
					});
		        	dwr.TOPEngine.setAsync(true);
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
		 cui("#classifyNameBox").hide();
		cui("#ClassifyTree").show();
		var node = cui('#ClassifyTree').getNode(curNodeId);
		if(node){
			treeClick(node);
			}
	}else{
		dwr.TOPEngine.setAsync(false);
		//刷新选择框的数据
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
				initBoxData = [{name:'没有数据',title:'没有数据'}];
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
//选择快速查询的记录
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