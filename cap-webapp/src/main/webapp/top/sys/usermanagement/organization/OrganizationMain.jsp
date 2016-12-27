<%
  /**********************************************************************
			 * 组织基本信息维护
			 * 2014-07-02  汪超  新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>组织基本信息维护</title>
    <meta http-equiv="X-UA-Compatible" content="edge" />
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/OrganizationAction.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
</head>
<body>
 <div uitype="borderlayout"  id="le" is_root="true" gap="0px 0px 0px 0px">           
      <div uitype="bpanel"  position="left" style="overflow:hidden" id="leftMain" width="290" max_size="550" min_size="50" collapsable="true">
         <div style="padding-top:80px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:80px;width:100%;">
        &nbsp;&nbsp;<label style="font-size: 12px;">组织结构：</label>
        <div uitype="radioGroup" name="orgStructureId" id="orgStructure" on_change="changeOrgStructure" radio_list="initOrgStructure"> 
		</div>
		<div uitype="clickInput" id="orgNameText" name="orgNameText" emptytext="请输入组织名称" enterable="true" editable="true"
		 	 width="262px" icon="search" on_iconclick="quickSearch" style="font-size: 14px;padding-left: 5px""></div>
		 <div align="right" id="moveOrg" style="padding-top:3px;width:100%">
				<img id="topimg" alt="置项" src="${pageScope.cuiWebRoot}/top/sys/images/func_top.png" style="cursor:pointer" title="置项" onclick="sort('top');">&nbsp;&nbsp;
	   	    	<img id="upimg" alt="上移" src="${pageScope.cuiWebRoot}/top/sys/images/func_up.png" style="cursor:pointer" title="上移" onclick="sort('up');">&nbsp;&nbsp;
	   	    	<img id="downimg" alt="下移" src="${pageScope.cuiWebRoot}/top/sys/images/func_down.png" style="cursor:pointer" title="下移" onclick="sort('down');">&nbsp;&nbsp;
	   	    	<img id="bottomimg"alt="置底" src="${pageScope.cuiWebRoot}/top/sys/images/func_bottom.png" style="cursor:pointer" title="置底" onclick="sort('bottom');">
			    <label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
		 </div> 
	  </div>     
        <div  id="treeDivHight" style="overflow:auto;height:100%;">
         	 <div style="width:259px; border:1px solid #ccc;font: 12px/25px Arial;" id="orgNameDivBox">
			   <div uitype="multiNav" id="orgNameBox" datasource="initBoxData"></div>
		    </div>
		<div uitype="tree" id="treeDiv" on_click="treeClick" on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand" ></div>
      </div> 
   </div>
	</div>         
      <div uitype="bpanel"  position="center" id="centerMain" url="">
      </div> 
 </div>
<script type="text/javascript">
	var curOrgStrucId = '';
	var parentNodeId = '';
	var selectNodeId = '';
	var selectNodeName = '';
	var orgResultList;
	var searchType = "tree";
	var checkId = '';
	//初始化查询的组织数据   
	var initBoxData=[];
	 //管辖范围,树的根节点ID
    var rootId = '-1';
    //快速查询选中的结果
    var fastQueryRecordId='';
    //管辖范围所属组织结构id
    var manageDeptOrgStructure = '';
    //当前选中的树节点
	var curNodeId = '';
    var winH;
    /********************组织树以及编辑页面的初始化   start **************************************************************/
	//扫描，相当于渲染
	window.onload = (function(){
		if(globalUserId != 'SuperAdmin'){
		    dwr.TOPEngine.setAsync(false);
		    //查询管辖范围
		    GradeAdminAction.getGradeAdminOrgByUserId(globalUserId, function(orgId){
		    	if(orgId){
					rootId = orgId;
					OrganizationAction.queryOrgStructureId(orgId,function(data){
						manageDeptOrgStructure = data;
					});
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
	      comtop.UI.scan();
	      $("#treeDivHight").height($("#leftMain").height()-80);
	      initOrgTreeData(cui('#treeDiv'));
	      $("#orgNameDivBox").hide();
	}); 
    
	window.onresize= function(){
		setTimeout(function(){
			$("#treeDivHight").height($("#leftMain").height()-80);
		},300);
    }
    
	//树初始化
	function initOrgTreeData(obj){
		var vOrgStructure = cui('#orgStructure').getValue();
		var vId = '-1';
		//当切换到非管辖范围内的组织结构时候，展现整棵树
		if(vOrgStructure==manageDeptOrgStructure){
			vId = rootId;
		}
		var node = {orgStructureId:vOrgStructure, orgId:vId};
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgTreeNode(node,function(data){
		   	if(data&&data!==""){
	   			var treeData = jQuery.parseJSON(data);
	   			treeData.isRoot = true;
	   			obj.setDatasource(treeData);
	   			//激活根节点
	   			obj.getNode(treeData.key).activate(true);
	   			obj.getNode(treeData.key).expand(true);
	   			curNodeId = data.key;
	   			treeClick(obj.getActiveNode());
			}else{
				  var emptydata=[{title:"暂无根组织"}];
	   			  obj.setDatasource(emptydata);
	   			  $('#moveOrg').hide();
	   			  //设置右边的页面链接
	   			  setEditUrl(cui('#orgStructure').getValue(),'','','');
			}
   		 });
   		dwr.TOPEngine.setAsync(true);
	}
	//初始化组织结构信息
	function initOrgStructure(obj){
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgStructureInfo(function(data){
			if(data){
				var arrData = jQuery.parseJSON(data)
				obj.setDatasource(arrData);
				obj.setValue(arrData[0].value,true);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//切换组织结构，重新加载整个页面
	function changeOrgStructure(){
		//清空查询条件，隐藏查询结果，显示树
		cui('#orgNameText').setValue('');
		$("#orgNameDivBox").hide();
		cui("#treeDiv").show();
		cui("#moveOrg").show();
		curOrgStrucId = cui('#orgStructure').getValue();
		initOrgTreeData(cui('#treeDiv'));
	}
   	//动态加载下级节点
   	function lazyData(node){
   		node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
   		curNodeId = node.getData().key;
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
   		curNodeId = node.getData().key; //为空查询的时候用到
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
	function setEditUrl(orgStructureId,parentNodeId,orgId,name){
		var isRootNode = false;
		var curNode = cui('#treeDiv').getNode(orgId);
		if(curNode&&curNode.getData("isRoot") === true) {
			isRootNode = true;
		}
		var url = "${pageScope.cuiWebRoot}/top/sys/usermanagement/organization/OrganizationEdit.jsp?" + "orgStructureId="+orgStructureId+"&parentNodeId="+parentNodeId+"&orgId="+orgId+"&name="+encodeURIComponent(encodeURIComponent(name))+"&isRootNode="+isRootNode;
		if(rootId == null){
			url += "&isAdmin=no";
		}
		 cui("#le").setContentURL("center",url); 
	}
    /********************组织树以及编辑页面的初始化   end **************************************************************/
    
    /********************快速查询    start  **************************************************************/
	/**
	快速查询选中记录
	*/
	function fastQuerySelect(orgStructureId,parentNodeId,orgId,name){
		 //记录快速查询的结果
		 fastQueryRecordId = orgId;
		 setEditUrl(orgStructureId,parentNodeId,orgId,name);
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
		    cui("#orgNameDivBox").hide();
			cui("#treeDiv").show();
			cui("#moveOrg").show();
			var node = cui('#treeDiv').getNode(curNodeId);
			if(node){
    			treeClick(node);
   			}
		}else{
				dwr.TOPEngine.setAsync(false);
				if(rootId != null){
					//刷新选择框的数据
					var obj;
					if(rootId != '-1'){
						obj = {keyword:keyword,orgStructureId:curOrgStrucId,orgId:rootId};
						if(obj.orgStructureId != manageDeptOrgStructure){ //外协单位不用管辖范围
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
				cui("#moveOrg").hide();
				$("#orgNameDivBox").show();
			    searchType="box";
		}
	}
	
	/********************快速查询    end **************************************************************/
	
	/********************组织排序    start **************************************************************/
	/**
	*	组织排序
	*	@param {String} option 方式，'top'/'bottom'/'down'/'up' 
	*/
	function sort(option){
		var node = cui('#treeDiv').getActiveNode();
		if(node && node.parent()){
			var obj = findRelativeNode(node,option);
			if(obj.orgRelationsToBeUpdate && obj.relativeNode){
				dwr.TOPEngine.setAsync(false);
				OrganizationAction.updateOrgRelations(option,obj.orgRelationsToBeUpdate,function(data){
					node.move(obj.relativeNode,obj.where);//交换节点位置并重新选中操作节点
					cui('#treeDiv').getNode(node.getData().key).activate();
				});
				dwr.TOPEngine.setAsync(true);
			}
		}else{
			cui.alert('请选择组织，根节点不能进行排序。');
			return;
		}
	}

	/**
	 * 排序时找到需要与此节点进行交换的节点
	 * 
	 * @param n
	 * @param option
	 * @return
	 */
	function findRelativeNode(node,option){
		var relativeNode;	//排序参考节点
		var where;
		var orgRelationsToBeUpdate;
		switch(option){
			case 'top':
				//node不是其层级的第一个节点，则relativeNode为同层首节点
				if(node.parent().firstChild().getData().key!=node.getData().key)
					relativeNode = node.parent().firstChild();
				if(relativeNode){
					where = 'before';
					orgRelationsToBeUpdate = [node.getData().data,relativeNode.getData().data];
				}
				break;
			case 'bottom':
				if(node.parent().lastChild().getData().key!=node.getData().key)
					relativeNode = node.parent().lastChild();
				if(relativeNode){
					where = 'after';
					orgRelationsToBeUpdate = [node.getData().data,relativeNode.getData().data];
				}
					break;
			case 'up':
				if(node.parent().firstChild().getData().key!=node.getData().key)
					relativeNode = node.prev();
				if(relativeNode){
					where = 'before';
					orgRelationsToBeUpdate = [node.getData().data,relativeNode.getData().data];
				}
					break;
			case 'down':
				if(node.parent().lastChild().getData().key!=node.getData().key)
					relativeNode = node.next();
				if(relativeNode){
					where = 'after';
					orgRelationsToBeUpdate = [node.getData().data,relativeNode.getData().data];
				}
				break;
			default:
		};
		return {'relativeNode':relativeNode,'where':where,'orgRelationsToBeUpdate':orgRelationsToBeUpdate};
	}
	/********************组织排序    start **************************************************************/
	
   	/**
	*  导入之后的回调
	*/
    function importCallBack(){
    	if(searchType != "tree"){
    		showTree();
    		cui("#orgNameText").setValue('');
        }
        //选中的父节点
    	var pNode = cui("#treeDiv").getNode(selectNodeId);
    	if(pNode && pNode.dNode) {
			if(pNode.hasChild()) {
				var lstChildrenNodes = pNode.children();
				for(var i=0;i<lstChildrenNodes.length;i++) {
					var dNode = lstChildrenNodes[i];
					dNode.remove();
				}
			}
			lazyData(pNode);
			pNode.activate();
			pNode.focus();
    	}
    }
	
	/**
	* 取消后重新加载
	*/
	function cancelLoad(parentNodeId,orgId,name){
		setTimeout(function(){
			setEditUrl(curOrgStrucId,parentNodeId,orgId,name);
		},50);
	}
	/********************  树同步刷新 start ***********************************
	/*
	 * 编辑页面完成后左侧树形同步
	 */
	function sychronizeUpdateTree(orgId,name){
		if(searchType == "tree"){//如果左侧是树形结构，该节点必定已加载 ，直接选中并改变name值 
			var currNode=cui('#treeDiv').getNode(orgId);
			currNode.setData("title",name);
			currNode.activate();
			
		 }else{//否则，1.清空查询条件、2.回到树形结构并选中节点
			showTree();
			var selectNode = cui("#treeDiv").getNode(orgId);
			if(selectNode&&selectNode.dNode){//2.1 如果节点已经加载，直接选中
				selectNode.setData("title",name);
				selectNode.activate();
			}else{//2.2 如果节点还未加载 
				//1. 获得节点的ID全路径 1(根节点ID)/2/3/...
				var path;
				var objPath = {orgId:orgId,orgStructureId:curOrgStrucId};
				dwr.TOPEngine.setAsync(false);
				OrganizationAction.queryIDFullPath(objPath,function(data){
					path = data.split('/');
				});
				dwr.TOPEngine.setAsync(true);
				//2. 从根节点开始遍历，直到展开到当前节点为止 ，并选中当前节点
				$.each(path,function(i,orgId){
					var iNode = cui("#treeDiv").getNode(orgId);
					if(i==path.length-1){
						iNode.activate(true);
					}else{
						iNode.expand(true);
					}
				});
			}
		 }
	}
	/*
	 * 新增页面完成后左侧树形同步
	 * parentNodeId name orgId sortNo
	 */
	function sychronizeAddTree(parentNodeId,name,orgId,type,sortNo){
		var parentOrgNode;
		var jsonNode=null;
		if(type == 1){//新增根
			//重新加载树 
			dwr.TOPEngine.setAsync(false);
			var node = {orgStructureId:curOrgStrucId, orgId:-1};
			OrganizationAction.getOrgTreeNode(node, function(data){
				  cui('#treeDiv').setDatasource([$.parseJSON(data)]);
				  treeClick(cui('#treeDiv').getRoot().firstChild());
			});
			dwr.TOPEngine.setAsync(true);
		}else if(type == 2){//新增同级
			if(searchType == "tree"){//如果左侧是树形格式，直接新增节点到第一个
				parentOrgNode = cui('#treeDiv').getNode(parentNodeId); //获得父组织
				if(parentOrgNode.hasChild()) {
					var lstChildrenNodes = parentOrgNode.children();
					for(var i=0;i<lstChildrenNodes.length;i++) {
						var dNode = lstChildrenNodes[i];
						dNode.remove();
					}
				}
				lazyData(parentOrgNode);
				var iNode = cui("#treeDiv").getNode(orgId);
				iNode.activate();
				iNode.focus();
				treeClick(iNode);
			}else{
				var parentOrgNode =cui('#treeDiv').getNode(parentNodeId);
				if(parentOrgNode&&parentOrgNode.dNode){//节点已经加载
					 showTree();
					 if(parentOrgNode.hasChild()) {
							var lstChildrenNodes = parentOrgNode.children();
							for(var i=0;i<lstChildrenNodes.length;i++) {
								var dNode = lstChildrenNodes[i];
								dNode.remove();
							}
						}
						lazyData(parentOrgNode);
						var iNode = cui("#treeDiv").getNode(orgId);
						iNode.activate();
						iNode.focus();
						treeClick(iNode);
				}else{//节点未加载
					 showTree();
					 //得到新增节点的ID Path
					 var path;
					 var objIdPath = {orgId:orgId,orgStructureId:curOrgStrucId};
					 dwr.TOPEngine.setAsync(false);
					 OrganizationAction.queryIDFullPath(objIdPath,function(data){
							path = data.split('/');
					 });
					 dwr.TOPEngine.setAsync(true);
					 //从根节点开始遍历，直到展开到当前节点为止 ，并选中当前节点
					$.each(path,function(i,iOrgId){
						var iNode = cui("#treeDiv").getNode(iOrgId);
						if(i==path.length-1){
							iNode.activate(true);
						}else{
							iNode.expand(true);
						}
					});
				}
			}
		}else {//新增下级
			parentOrgNode = cui('#treeDiv').getNode(parentNodeId); //获得父组织
			jsonNode={key:orgId,title:name,icon:"${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif",data:{parentNodeId:parentNodeId}};
			if(searchType == "tree" && !parentOrgNode.getData().isFolder){//如果左侧为树形结构
				parentOrgNode.setData("isFolder",true);
					if(parentOrgNode.hasChild()) {
						var lstChildrenNodes = parentOrgNode.children();
						for(var i=0;i<lstChildrenNodes.length;i++) {
							var dNode = lstChildrenNodes[i];
							dNode.remove();
						}
					}
					lazyData(parentOrgNode);
					var iNode = cui("#treeDiv").getNode(orgId);
					iNode.activate();
					iNode.focus();
					treeClick(iNode);
			 }else if(parentOrgNode &&parentOrgNode.dNode && parentOrgNode.hasChild()){//如果为列表查询条件 ，且树有子节点
				 showTree();//切换为树形
				 if(parentOrgNode.hasChild()) {
						var lstChildrenNodes = parentOrgNode.children();
						for(var i=0;i<lstChildrenNodes.length;i++) {
							var dNode = lstChildrenNodes[i];
							dNode.remove();
						}
					}
					lazyData(parentOrgNode);
					var iNode = cui("#treeDiv").getNode(orgId);
					iNode.activate();
					iNode.focus();
					treeClick(iNode);
			 }else if(parentOrgNode &&parentOrgNode.dNode &&!parentOrgNode.hasChild()){//如果为列表查询条件，且树还无子节点
				 showTree();
				 parentOrgNode.setData("isFolder",true);
				 if(parentOrgNode.hasChild()) {
						var lstChildrenNodes = parentOrgNode.children();
						for(var i=0;i<lstChildrenNodes.length;i++) {
							var dNode = lstChildrenNodes[i];
							dNode.remove();
						}
					}
					lazyData(parentOrgNode);
					var iNode = cui("#treeDiv").getNode(orgId);
					iNode.activate();
					iNode.focus();
					treeClick(iNode);
			 }else{//如果父节点未加载
				 showTree();
				 //得到新增节点的ID Path
				 var path;
				 var objIdPath = {orgId:orgId,orgStructureId:curOrgStrucId};
				 dwr.TOPEngine.setAsync(false);
				 OrganizationAction.queryIDFullPath(objIdPath,function(data){
						path = data.split('/');
				 });
				 dwr.TOPEngine.setAsync(true);
				 //从根节点开始遍历，直到展开到当前节点为止 ，并选中当前节点
				$.each(path,function(i,iOrgId){
					var iNode = cui("#treeDiv").getNode(iOrgId);
					iNode.expand(true);
					if(i==path.length-1){
						iNode.activate(true);
					}
				});
			 }
		}
	}

	/*
	 * 批量移除原来的子节点
	 */
	 function removeChildrenNode(selectParentNode){

		    //先移除原来的子节点
			selectParentNode.getData().isLazy=false;
			var children=selectParentNode.children();
			if(children){
				for(var i=0; i < children.length; i++){
					children[i].remove();  
				}
			}
	}

	/*
	 * 注销完成后左侧树形同步
	 */
	function sychronizeDeleteTree(orgId,parentNodeId){
		if(searchType == "tree"){//如果左侧是树形结构，父节点必定已加载 ，直接选中父节点
			var selectParentNode = cui('#treeDiv').getNode(parentNodeId);//选中父节点
			removeChildrenNode(selectParentNode);
			//再重新加载父节点数据
			lazyData(selectParentNode);
			//激活节点
			selectParentNode.activate();
			treeClick(selectParentNode);
		}else{//否则，1.清空查询条件、2.回到树形结构，删除注销节点并选中父节点
			showTree();
			var selectNode =cui('#treeDiv').getNode(orgId);
			var selectParentNode = cui('#treeDiv').getNode(parentNodeId);
			if(selectNode&&selectNode.dNode){//2.1 如果注销节点已经加载，移除注销节点，选中父节点
				//激活节点
				selectParentNode.activate(true);
				treeClick(selectParentNode);
				removeChildrenNode(selectParentNode);
				//再重新加载父节点数据
				lazyData(selectParentNode);
			}else if(selectParentNode && selectParentNode.dNode){//2.2 注销节点未加载，父节点加载，选中父节点
				selectParentNode.expand(true);
				selectParentNode.activate();
				treeClick(selectParentNode);
				removeChildrenNode(selectParentNode);
				//再重新加载父节点数据
				lazyData(selectParentNode);
			}else {//2.2 如果父节点还未加载 
				var path;//1. 获得父节点的ID全路径 1(根节点ID)/2/3/...
				var obj = {orgId:parentNodeId,orgStructureId:curOrgStrucId};
				dwr.TOPEngine.setAsync(false);
				OrganizationAction.queryIDFullPath(obj,function(data){
					path = data.split('/');
				});
				dwr.TOPEngine.setAsync(true);
				 //从根节点开始遍历，直到展开到当前节点为止 ，并选中当前节点
				$.each(path,function(i,iOrgId){
					var iNode = cui("#treeDiv").getNode(iOrgId);
					iNode.expand(true);
					if(i==path.length-1){
						iNode.activate(true);
						treeClick(iNode);
					}
				});
			}
		}
		setTimeout(function(){
			cui.message('组织注销成功。');
		},50);
	}
	
	/********************  树同步刷新 end **********************************
	
	/**
	* 切换树形结构 
	*/
	function showTree(){
		 cui("#treeDiv").show();
		 cui("#orgNameBox").setDatasource([]);
		 $("#orgNameDivBox").hide();
		 searchType = "tree";
		 cui('#orgNameText').setValue('');
	}
	
    	
 </script>
</body>
</html>