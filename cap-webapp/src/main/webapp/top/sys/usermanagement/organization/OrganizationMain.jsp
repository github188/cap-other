<%
  /**********************************************************************
			 * ��֯������Ϣά��
			 * 2014-07-02  ����  �½�
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>��֯������Ϣά��</title>
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
        &nbsp;&nbsp;<label style="font-size: 12px;">��֯�ṹ��</label>
        <div uitype="radioGroup" name="orgStructureId" id="orgStructure" on_change="changeOrgStructure" radio_list="initOrgStructure"> 
		</div>
		<div uitype="clickInput" id="orgNameText" name="orgNameText" emptytext="��������֯����" enterable="true" editable="true"
		 	 width="262px" icon="search" on_iconclick="quickSearch" style="font-size: 14px;padding-left: 5px""></div>
		 <div align="right" id="moveOrg" style="padding-top:3px;width:100%">
				<img id="topimg" alt="����" src="${pageScope.cuiWebRoot}/top/sys/images/func_top.png" style="cursor:pointer" title="����" onclick="sort('top');">&nbsp;&nbsp;
	   	    	<img id="upimg" alt="����" src="${pageScope.cuiWebRoot}/top/sys/images/func_up.png" style="cursor:pointer" title="����" onclick="sort('up');">&nbsp;&nbsp;
	   	    	<img id="downimg" alt="����" src="${pageScope.cuiWebRoot}/top/sys/images/func_down.png" style="cursor:pointer" title="����" onclick="sort('down');">&nbsp;&nbsp;
	   	    	<img id="bottomimg"alt="�õ�" src="${pageScope.cuiWebRoot}/top/sys/images/func_bottom.png" style="cursor:pointer" title="�õ�" onclick="sort('bottom');">
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
	//��ʼ����ѯ����֯����   
	var initBoxData=[];
	 //��Ͻ��Χ,���ĸ��ڵ�ID
    var rootId = '-1';
    //���ٲ�ѯѡ�еĽ��
    var fastQueryRecordId='';
    //��Ͻ��Χ������֯�ṹid
    var manageDeptOrgStructure = '';
    //��ǰѡ�е����ڵ�
	var curNodeId = '';
    var winH;
    /********************��֯���Լ��༭ҳ��ĳ�ʼ��   start **************************************************************/
	//ɨ�裬�൱����Ⱦ
	window.onload = (function(){
		if(globalUserId != 'SuperAdmin'){
		    dwr.TOPEngine.setAsync(false);
		    //��ѯ��Ͻ��Χ
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
    
	//����ʼ��
	function initOrgTreeData(obj){
		var vOrgStructure = cui('#orgStructure').getValue();
		var vId = '-1';
		//���л����ǹ�Ͻ��Χ�ڵ���֯�ṹʱ��չ��������
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
	   			//������ڵ�
	   			obj.getNode(treeData.key).activate(true);
	   			obj.getNode(treeData.key).expand(true);
	   			curNodeId = data.key;
	   			treeClick(obj.getActiveNode());
			}else{
				  var emptydata=[{title:"���޸���֯"}];
	   			  obj.setDatasource(emptydata);
	   			  $('#moveOrg').hide();
	   			  //�����ұߵ�ҳ������
	   			  setEditUrl(cui('#orgStructure').getValue(),'','','');
			}
   		 });
   		dwr.TOPEngine.setAsync(true);
	}
	//��ʼ����֯�ṹ��Ϣ
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
	//�л���֯�ṹ�����¼�������ҳ��
	function changeOrgStructure(){
		//��ղ�ѯ���������ز�ѯ�������ʾ��
		cui('#orgNameText').setValue('');
		$("#orgNameDivBox").hide();
		cui("#treeDiv").show();
		cui("#moveOrg").show();
		curOrgStrucId = cui('#orgStructure').getValue();
		initOrgTreeData(cui('#treeDiv'));
	}
   	//��̬�����¼��ڵ�
   	function lazyData(node){
   		node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
   		curNodeId = node.getData().key;
   		curOrgStrucId = cui('#orgStructure').getValue();
   		dwr.TOPEngine.setAsync(false);
		var userChildObj={"orgId":node.getData().key,orgStructureId:curOrgStrucId};
		OrganizationAction.getOrgTreeNode(userChildObj,function(data){
	    	var treeData = jQuery.parseJSON(data);
	    	//�����ӽڵ���Ϣ
	    	 node.addChild(treeData.children);
		         node.setLazyNodeStatus(node.ok);
	     });
	    dwr.TOPEngine.setAsync(true);
   	}

	//���ڵ�չ�����𴥷�
	function onExpand(flag,node){
		if(flag){
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
		}else{
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif');
		}
	}

   	// �������¼�
   	function treeClick(node){
   		checkId=node.getData().key;
   		curNodeId = node.getData().key; //Ϊ�ղ�ѯ��ʱ���õ�
   		selectNodeId = node.getData().key;
   		selectNodeName=node.getData().title;
   		parentNodeId = node.getData().data.parentOrgId;
   		curOrgStrucId = cui('#orgStructure').getValue();
      	//�����ұߵ�ҳ������
   		setEditUrl(curOrgStrucId,parentNodeId,selectNodeId,selectNodeName);
   	}

   	/**
	*  ���ñ༭ҳ���URL·�� 
	*  ��֯�ṹID�����ڵ�ID����֯ID����֯����
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
    /********************��֯���Լ��༭ҳ��ĳ�ʼ��   end **************************************************************/
    
    /********************���ٲ�ѯ    start  **************************************************************/
	/**
	���ٲ�ѯѡ�м�¼
	*/
	function fastQuerySelect(orgStructureId,parentNodeId,orgId,name){
		 //��¼���ٲ�ѯ�Ľ��
		 fastQueryRecordId = orgId;
		 setEditUrl(orgStructureId,parentNodeId,orgId,name);
	}

	//���ٲ�ѯ
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
					//ˢ��ѡ��������
					var obj;
					if(rootId != '-1'){
						obj = {keyword:keyword,orgStructureId:curOrgStrucId,orgId:rootId};
						if(obj.orgStructureId != manageDeptOrgStructure){ //��Э��λ���ù�Ͻ��Χ
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
							initBoxData = [{name:'û������',title:'û������'}];
						}
					});
					dwr.TOPEngine.setAsync(true);
				}else {
					initBoxData = [{name:'û������',title:'û������'}];
				}
				cui("#orgNameBox").setDatasource(initBoxData);
				cui("#treeDiv").hide();
				cui("#moveOrg").hide();
				$("#orgNameDivBox").show();
			    searchType="box";
		}
	}
	
	/********************���ٲ�ѯ    end **************************************************************/
	
	/********************��֯����    start **************************************************************/
	/**
	*	��֯����
	*	@param {String} option ��ʽ��'top'/'bottom'/'down'/'up' 
	*/
	function sort(option){
		var node = cui('#treeDiv').getActiveNode();
		if(node && node.parent()){
			var obj = findRelativeNode(node,option);
			if(obj.orgRelationsToBeUpdate && obj.relativeNode){
				dwr.TOPEngine.setAsync(false);
				OrganizationAction.updateOrgRelations(option,obj.orgRelationsToBeUpdate,function(data){
					node.move(obj.relativeNode,obj.where);//�����ڵ�λ�ò�����ѡ�в����ڵ�
					cui('#treeDiv').getNode(node.getData().key).activate();
				});
				dwr.TOPEngine.setAsync(true);
			}
		}else{
			cui.alert('��ѡ����֯�����ڵ㲻�ܽ�������');
			return;
		}
	}

	/**
	 * ����ʱ�ҵ���Ҫ��˽ڵ���н����Ľڵ�
	 * 
	 * @param n
	 * @param option
	 * @return
	 */
	function findRelativeNode(node,option){
		var relativeNode;	//����ο��ڵ�
		var where;
		var orgRelationsToBeUpdate;
		switch(option){
			case 'top':
				//node������㼶�ĵ�һ���ڵ㣬��relativeNodeΪͬ���׽ڵ�
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
	/********************��֯����    start **************************************************************/
	
   	/**
	*  ����֮��Ļص�
	*/
    function importCallBack(){
    	if(searchType != "tree"){
    		showTree();
    		cui("#orgNameText").setValue('');
        }
        //ѡ�еĸ��ڵ�
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
	* ȡ�������¼���
	*/
	function cancelLoad(parentNodeId,orgId,name){
		setTimeout(function(){
			setEditUrl(curOrgStrucId,parentNodeId,orgId,name);
		},50);
	}
	/********************  ��ͬ��ˢ�� start ***********************************
	/*
	 * �༭ҳ����ɺ��������ͬ��
	 */
	function sychronizeUpdateTree(orgId,name){
		if(searchType == "tree"){//�����������νṹ���ýڵ�ض��Ѽ��� ��ֱ��ѡ�в��ı�nameֵ 
			var currNode=cui('#treeDiv').getNode(orgId);
			currNode.setData("title",name);
			currNode.activate();
			
		 }else{//����1.��ղ�ѯ������2.�ص����νṹ��ѡ�нڵ�
			showTree();
			var selectNode = cui("#treeDiv").getNode(orgId);
			if(selectNode&&selectNode.dNode){//2.1 ����ڵ��Ѿ����أ�ֱ��ѡ��
				selectNode.setData("title",name);
				selectNode.activate();
			}else{//2.2 ����ڵ㻹δ���� 
				//1. ��ýڵ��IDȫ·�� 1(���ڵ�ID)/2/3/...
				var path;
				var objPath = {orgId:orgId,orgStructureId:curOrgStrucId};
				dwr.TOPEngine.setAsync(false);
				OrganizationAction.queryIDFullPath(objPath,function(data){
					path = data.split('/');
				});
				dwr.TOPEngine.setAsync(true);
				//2. �Ӹ��ڵ㿪ʼ������ֱ��չ������ǰ�ڵ�Ϊֹ ����ѡ�е�ǰ�ڵ�
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
	 * ����ҳ����ɺ��������ͬ��
	 * parentNodeId name orgId sortNo
	 */
	function sychronizeAddTree(parentNodeId,name,orgId,type,sortNo){
		var parentOrgNode;
		var jsonNode=null;
		if(type == 1){//������
			//���¼����� 
			dwr.TOPEngine.setAsync(false);
			var node = {orgStructureId:curOrgStrucId, orgId:-1};
			OrganizationAction.getOrgTreeNode(node, function(data){
				  cui('#treeDiv').setDatasource([$.parseJSON(data)]);
				  treeClick(cui('#treeDiv').getRoot().firstChild());
			});
			dwr.TOPEngine.setAsync(true);
		}else if(type == 2){//����ͬ��
			if(searchType == "tree"){//�����������θ�ʽ��ֱ�������ڵ㵽��һ��
				parentOrgNode = cui('#treeDiv').getNode(parentNodeId); //��ø���֯
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
				if(parentOrgNode&&parentOrgNode.dNode){//�ڵ��Ѿ�����
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
				}else{//�ڵ�δ����
					 showTree();
					 //�õ������ڵ��ID Path
					 var path;
					 var objIdPath = {orgId:orgId,orgStructureId:curOrgStrucId};
					 dwr.TOPEngine.setAsync(false);
					 OrganizationAction.queryIDFullPath(objIdPath,function(data){
							path = data.split('/');
					 });
					 dwr.TOPEngine.setAsync(true);
					 //�Ӹ��ڵ㿪ʼ������ֱ��չ������ǰ�ڵ�Ϊֹ ����ѡ�е�ǰ�ڵ�
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
		}else {//�����¼�
			parentOrgNode = cui('#treeDiv').getNode(parentNodeId); //��ø���֯
			jsonNode={key:orgId,title:name,icon:"${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif",data:{parentNodeId:parentNodeId}};
			if(searchType == "tree" && !parentOrgNode.getData().isFolder){//������Ϊ���νṹ
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
			 }else if(parentOrgNode &&parentOrgNode.dNode && parentOrgNode.hasChild()){//���Ϊ�б��ѯ���� ���������ӽڵ�
				 showTree();//�л�Ϊ����
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
			 }else if(parentOrgNode &&parentOrgNode.dNode &&!parentOrgNode.hasChild()){//���Ϊ�б��ѯ���������������ӽڵ�
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
			 }else{//������ڵ�δ����
				 showTree();
				 //�õ������ڵ��ID Path
				 var path;
				 var objIdPath = {orgId:orgId,orgStructureId:curOrgStrucId};
				 dwr.TOPEngine.setAsync(false);
				 OrganizationAction.queryIDFullPath(objIdPath,function(data){
						path = data.split('/');
				 });
				 dwr.TOPEngine.setAsync(true);
				 //�Ӹ��ڵ㿪ʼ������ֱ��չ������ǰ�ڵ�Ϊֹ ����ѡ�е�ǰ�ڵ�
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
	 * �����Ƴ�ԭ�����ӽڵ�
	 */
	 function removeChildrenNode(selectParentNode){

		    //���Ƴ�ԭ�����ӽڵ�
			selectParentNode.getData().isLazy=false;
			var children=selectParentNode.children();
			if(children){
				for(var i=0; i < children.length; i++){
					children[i].remove();  
				}
			}
	}

	/*
	 * ע����ɺ��������ͬ��
	 */
	function sychronizeDeleteTree(orgId,parentNodeId){
		if(searchType == "tree"){//�����������νṹ�����ڵ�ض��Ѽ��� ��ֱ��ѡ�и��ڵ�
			var selectParentNode = cui('#treeDiv').getNode(parentNodeId);//ѡ�и��ڵ�
			removeChildrenNode(selectParentNode);
			//�����¼��ظ��ڵ�����
			lazyData(selectParentNode);
			//����ڵ�
			selectParentNode.activate();
			treeClick(selectParentNode);
		}else{//����1.��ղ�ѯ������2.�ص����νṹ��ɾ��ע���ڵ㲢ѡ�и��ڵ�
			showTree();
			var selectNode =cui('#treeDiv').getNode(orgId);
			var selectParentNode = cui('#treeDiv').getNode(parentNodeId);
			if(selectNode&&selectNode.dNode){//2.1 ���ע���ڵ��Ѿ����أ��Ƴ�ע���ڵ㣬ѡ�и��ڵ�
				//����ڵ�
				selectParentNode.activate(true);
				treeClick(selectParentNode);
				removeChildrenNode(selectParentNode);
				//�����¼��ظ��ڵ�����
				lazyData(selectParentNode);
			}else if(selectParentNode && selectParentNode.dNode){//2.2 ע���ڵ�δ���أ����ڵ���أ�ѡ�и��ڵ�
				selectParentNode.expand(true);
				selectParentNode.activate();
				treeClick(selectParentNode);
				removeChildrenNode(selectParentNode);
				//�����¼��ظ��ڵ�����
				lazyData(selectParentNode);
			}else {//2.2 ������ڵ㻹δ���� 
				var path;//1. ��ø��ڵ��IDȫ·�� 1(���ڵ�ID)/2/3/...
				var obj = {orgId:parentNodeId,orgStructureId:curOrgStrucId};
				dwr.TOPEngine.setAsync(false);
				OrganizationAction.queryIDFullPath(obj,function(data){
					path = data.split('/');
				});
				dwr.TOPEngine.setAsync(true);
				 //�Ӹ��ڵ㿪ʼ������ֱ��չ������ǰ�ڵ�Ϊֹ ����ѡ�е�ǰ�ڵ�
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
			cui.message('��֯ע���ɹ���');
		},50);
	}
	
	/********************  ��ͬ��ˢ�� end **********************************
	
	/**
	* �л����νṹ 
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