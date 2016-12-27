
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>岗位分配</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/OrganizationAction.js"></script>
</head>
<body>
 <div uitype="borderlayout"  id="le" is_root="true" gap="0px 0px 0px 0px">           
      <div uitype="bpanel"  style="overflow:hidden" position="left" id="leftMain" width="300" max_size="550" min_size="50" collapsable="true" style="margin-left: 6px">
         <div style="padding-top:55px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:55px;width:100%;">
        <div style="display:none;">
        &nbsp;<label style="font-size: 12px;">组织结构：</label>
        <span uitype="radioGroup" name="orgStructureId" value="A" id="orgStructure" on_change="changeOrgStructure"> 
			<input type="radio" value="A" text="中国南方电网公司"></input>
		</span></div>
		<div style="height:5px;width:100%"></div>
		<span uitype="clickInput"  id="orgNameText" name="orgNameText"  emptytext="请请输入组织的名称、全拼、简拼" enterable="true" editable="true"
		 	 width="271px"  icon="search" on_iconclick="quickSearch"></span>
		<div style="height:3px;width:100%" ></div>
		 
		 <div id="associateDiv" style="text-align: left;width:186px;font:12px/25px Arial;margin-left: 3px;margin-bottom: 1px;" >
			<input type="checkbox" id="associateQuery" align="middle"  title="级联查询" onclick="setAssociate(0)" style="cursor:pointer;"/>
			<label  onclick="setAssociate(1)" style="cursor:pointer;" id="label"><font color="#2894FF">级联查询岗位</font></label>
		</div>
		  </div>     
        <div  id="treeDivHight" style="overflow:auto;height:100%;">
		 <div style="width:259px; border:1px solid #ccc;font: 12px/25px Arial;" id="orgNameDivBox">
			   <div uitype="multiNav" id="orgNameBox" datasource="initBoxData"></div>
		</div>
		 <div uitype="tree" id="treeDiv" on_click="treeClick" on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand"></div>
       </div>  
	   </div>
      </div>         
      <div uitype="bpanel"  position="center" id="centerMain" url="" >
      </div> 
 </div>
<script type="text/javascript">
	var adminId = "<c:out value='${param.adminId}'/>";
	var curOrgStrucId = '';
	var parentNodeId = '';
	var selectNodeId = '';
	var selectNodeName = '';
	var orgResultList;
	var searchType = "tree";
	var checkId = '';
	//初始化查询的组织数据   
	var initBoxData=[];
	 //管辖范围
    var rootId = "<c:out value='${param.orgId}'/>";
    if(rootId==''){
        //树的根节点ID
    	rootId = '-1';
    }
    //快速查询选中的结果
    var fastQueryRecordId='';
    var fastQueryRecordOrgName='';
    
    /********************组织树以及编辑页面的初始化   start **************************************************************/
	//扫描，相当于渲染
	window.onload = (function(){
	      comtop.UI.scan();
	      $("#treeDivHight").height($("#leftMain").height()-55);
	      initOrgTreeData(cui('#treeDiv'));
	      $("#orgNameDivBox").hide();
	}); 
    
	window.onresize= function(){
		setTimeout(function(){
			$("#treeDivHight").height($("#leftMain").height()-55);
		},300);
	}
	//树初始化
	function initOrgTreeData(obj){
		var node = {orgStructureId:cui('#orgStructure').getValue(), orgId:rootId};
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgTreeNode(node,function(data){
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
	   			  //设置右边的页面链接
	   			  setEditUrl(curOrgStrucId,'','','');
			}
   		 });
   		dwr.TOPEngine.setAsync(true);
	}
	//切换组织结构，重新加载整个页面
	function changeOrgStructure(){
		initOrgTreeData(cui('#treeDiv'));
	}
   	//动态加载下级节点
   	function lazyData(node){
   		node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
   		curOrgStrucId = cui('#orgStructure').getValue();
   		dwr.TOPEngine.setAsync(false);
		var userChildObj={"orgId":node.getData().key,orgStructureId:curOrgStrucId};
		OrganizationAction.getOrgTreeNode(userChildObj,function(data){
	    	var treeData = jQuery.parseJSON(data);
	    	//加载子节点信息
	    	 node.addChild(treeData.children);
		         node.setLazyNodeStatus(node.ok);
	     });
	    dwr.TOPEngine.setAsync(true);
   	}

	//树节点展开合起触发
	function onExpand(flag,node){
		if(flag){
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
		}else{
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif');
		}
	}

   	// 树单击事件
   	function treeClick(node){
   		checkId=node.getData().key;
   		selectNodeId = node.getData().key;
   		selectNodeName=node.getData().title;
   		parentNodeId = node.getData().data.parentOrgId;
   		curOrgStrucId = cui('#orgStructure').getValue();
      	//设置右边的页面链接
   		setEditUrl(curOrgStrucId,parentNodeId,selectNodeId,selectNodeName);
   	}

   	/**
	*  设置编辑页面的URL路径 
	*  组织结构ID、父节点ID、组织ID、组织名称
	*/
	function setEditUrl(orgStructureId,parentNodeId,orgId,orgName){
		//为1 级联查询
  	   var associateType=$('#associateQuery')[0].checked==true?1:0;
		
		var isRootNode = false;
		var curNode = cui('#treeDiv').getNode(orgId);
		if(curNode&&curNode.getData("isRoot") === true) {
			isRootNode = true;
		}
		var url = "${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignPostList.jsp?" + "orgId="+orgId+"&orgName="+orgName+"&associateType="+associateType+"&adminId="+adminId;
		if(rootId == null){
			url += "&isAdmin=no";
		}
		 cui("#le").setContentURL("center",url); 
	}
    /********************组织树以及编辑页面的初始化   end **************************************************************/
    
    
    
         //设置级联  1为 级联查询，0为默认
    	function setAssociate(type){
    		var associate=$('#associateQuery')[0].checked;
    		if(type==1){
        		if(associate)$('#associateQuery')[0].checked=false;
        		else $('#associateQuery')[0].checked=true;
        	}
    		//执行查询
        	if(searchType == "tree"){
	     	   var node=cui('#treeDiv').getActiveNode();
	     	   treeClick(node);
            }else{
            	setEditUrl(curOrgStrucId,parentNodeId,fastQueryRecordId,fastQueryRecordOrgName);
            }
        }
    
    
    /********************快速查询    start  **************************************************************/
	/**
	快速查询选中记录
	*/
	function fastQuerySelect(chooseOrgStructureId,chooseParentNodeId,orgId,orgName){
		 //记录快速查询的结果
		 fastQueryRecordId = orgId;
		 fastQueryRecordOrgName = orgName;
		 parentNodeId=chooseParentNodeId;
		 setEditUrl(chooseOrgStructureId,chooseParentNodeId,orgId,orgName);
	}

	//快速查询
	function quickSearch(){
	    initBoxData=[];
	    cui("#orgNameBox").setDatasource(initBoxData);
	    $("#orgNameDivBox").hide();
	    var keyword = cui("#orgNameText").getValue().replace(new RegExp("/", "gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_", "gm"), "/_");
		if(!keyword){
			cui("#treeDiv").show();
			//在树中选中快速查询的结果
			//selectFastQueryInTree();
			var node = cui('#treeDiv').getNode(selectNodeId);
			searchType="tree";
			if (node) {
				treeClick(node);
			}
			return;
		}
		dwr.TOPEngine.setAsync(false);
		if(rootId != null){
			//刷新选择框的数据
			var obj;
			if(rootId != '-1'){
				obj = {keyword:keyword,orgStructureId:curOrgStrucId,orgId:rootId};
				if(obj.orgStructureId == 'B'){ //外协单位不用管辖范围
                	 obj.orgId = '';
	    		}
			} else {
				obj = {keyword:keyword,orgStructureId:curOrgStrucId};
			}
			OrganizationAction.quickSearchOrg(obj,function(datas){
				cui("#treeDiv").hide();
				if (datas && datas.length > 0) {
					var path="";
					$.each(datas,function(i,cData){
						 if(cData.nameFullPath.length>21){
							    path=cData.nameFullPath.substring(0,21)+"..";
							 }else{
								 path=cData.nameFullPath;
							 }
							initBoxData.push({href:"#",name:path,title:cData.nameFullPath,onclick:"fastQuerySelect('"+curOrgStrucId+"','"+cData.parentOrgId+"','"+cData.orgId+"','"+cData.orgName+"')"});
					});
				}else{
					initBoxData = [{name:'没有数据',title:'没有数据'}];
				}
			});
			dwr.TOPEngine.setAsync(true);
		}else {
			initBoxData = [{name:'没有数据',title:'没有数据'}];
		}
		cui("#orgNameBox").setDatasource(initBoxData);
		cui("#treeDiv").hide();
		$("#orgNameDivBox").show();
	    searchType="box";
	}
	
	/********************快速查询    end **************************************************************/
	
	
 </script>
</body>
</html>