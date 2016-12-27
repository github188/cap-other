
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
    <title>��λ����</title>
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
        &nbsp;<label style="font-size: 12px;">��֯�ṹ��</label>
        <span uitype="radioGroup" name="orgStructureId" value="A" id="orgStructure" on_change="changeOrgStructure"> 
			<input type="radio" value="A" text="�й��Ϸ�������˾"></input>
		</span></div>
		<div style="height:5px;width:100%"></div>
		<span uitype="clickInput"  id="orgNameText" name="orgNameText"  emptytext="����������֯�����ơ�ȫƴ����ƴ" enterable="true" editable="true"
		 	 width="271px"  icon="search" on_iconclick="quickSearch"></span>
		<div style="height:3px;width:100%" ></div>
		 
		 <div id="associateDiv" style="text-align: left;width:186px;font:12px/25px Arial;margin-left: 3px;margin-bottom: 1px;" >
			<input type="checkbox" id="associateQuery" align="middle"  title="������ѯ" onclick="setAssociate(0)" style="cursor:pointer;"/>
			<label  onclick="setAssociate(1)" style="cursor:pointer;" id="label"><font color="#2894FF">������ѯ��λ</font></label>
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
	//��ʼ����ѯ����֯����   
	var initBoxData=[];
	 //��Ͻ��Χ
    var rootId = "<c:out value='${param.orgId}'/>";
    if(rootId==''){
        //���ĸ��ڵ�ID
    	rootId = '-1';
    }
    //���ٲ�ѯѡ�еĽ��
    var fastQueryRecordId='';
    var fastQueryRecordOrgName='';
    
    /********************��֯���Լ��༭ҳ��ĳ�ʼ��   start **************************************************************/
	//ɨ�裬�൱����Ⱦ
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
	//����ʼ��
	function initOrgTreeData(obj){
		var node = {orgStructureId:cui('#orgStructure').getValue(), orgId:rootId};
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgTreeNode(node,function(data){
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
	   			  //�����ұߵ�ҳ������
	   			  setEditUrl(curOrgStrucId,'','','');
			}
   		 });
   		dwr.TOPEngine.setAsync(true);
	}
	//�л���֯�ṹ�����¼�������ҳ��
	function changeOrgStructure(){
		initOrgTreeData(cui('#treeDiv'));
	}
   	//��̬�����¼��ڵ�
   	function lazyData(node){
   		node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
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
	function setEditUrl(orgStructureId,parentNodeId,orgId,orgName){
		//Ϊ1 ������ѯ
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
    /********************��֯���Լ��༭ҳ��ĳ�ʼ��   end **************************************************************/
    
    
    
         //���ü���  1Ϊ ������ѯ��0ΪĬ��
    	function setAssociate(type){
    		var associate=$('#associateQuery')[0].checked;
    		if(type==1){
        		if(associate)$('#associateQuery')[0].checked=false;
        		else $('#associateQuery')[0].checked=true;
        	}
    		//ִ�в�ѯ
        	if(searchType == "tree"){
	     	   var node=cui('#treeDiv').getActiveNode();
	     	   treeClick(node);
            }else{
            	setEditUrl(curOrgStrucId,parentNodeId,fastQueryRecordId,fastQueryRecordOrgName);
            }
        }
    
    
    /********************���ٲ�ѯ    start  **************************************************************/
	/**
	���ٲ�ѯѡ�м�¼
	*/
	function fastQuerySelect(chooseOrgStructureId,chooseParentNodeId,orgId,orgName){
		 //��¼���ٲ�ѯ�Ľ��
		 fastQueryRecordId = orgId;
		 fastQueryRecordOrgName = orgName;
		 parentNodeId=chooseParentNodeId;
		 setEditUrl(chooseOrgStructureId,chooseParentNodeId,orgId,orgName);
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
			cui("#treeDiv").show();
			//������ѡ�п��ٲ�ѯ�Ľ��
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
			//ˢ��ѡ��������
			var obj;
			if(rootId != '-1'){
				obj = {keyword:keyword,orgStructureId:curOrgStrucId,orgId:rootId};
				if(obj.orgStructureId == 'B'){ //��Э��λ���ù�Ͻ��Χ
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
		$("#orgNameDivBox").show();
	    searchType="box";
	}
	
	/********************���ٲ�ѯ    end **************************************************************/
	
	
 </script>
</body>
</html>