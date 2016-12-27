
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%@ page import="com.comtop.top.sys.usermanagement.user.util.UomCommonUtil" %>
<%		
	//�Ƿ�����ϵͳ��Ա��֯���ܰ�ť true ���� false ������
    boolean isHideSystemBtnInUserOrg = UomCommonUtil.getHideSystemBtnInUserOrgCfg();
%>
<html>
<head>
    <title>��Ա������Ϣ</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/OrganizationAction.js"></script>
	 <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserManageAction.js"></script>
	 <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
	  <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostAction.js"></script>
	 <style type="text/css">
		th{
		    font-weight: bold;
		    font-size:14px;
		}
	</style>
</head>
<body>
 <div uitype="borderlayout"  id="le" is_root="true" >           
      <div uitype="bpanel"  style="overflow:hidden" position="left" id="leftMain" width="280"  >
      	 <div style="padding-top:80px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:80px;width:100%;">
        &nbsp;&nbsp;<label style="font-size: 12px;">��֯�ṹ��</label>
        <div uitype="radioGroup" name="orgStructureId" id="orgStructure" on_change="changeOrgStructure" radio_list="initOrgStructure"> 
		</div>
		<div uitype="clickInput" id="orgNameText" name="orgNameText" emptytext="��������֯����" enterable="true" editable="true"
		 	 width="240px" icon="search" on_iconclick="quickSearch" style="font-size: 12px;padding-left: 5px"></div>
		 <div id="associateDiv" style="text-align: left;width:186px;font:12px/25px Arial;margin-left: 3px;margin-bottom: 1px;" >
			<div style="float: left;padding-left: 4px;padding-top: 2px;"><input type="checkbox" id="associateQuery" align="middle"  title="������ѯ" onclick="setAssociate(0)" style="cursor:pointer;"/></div>
			<div style=""><label  onclick="setAssociate(1)" style="cursor:pointer;" id="label">&nbsp;������ѯ�û�</label></div>
		</div>
		 </div>     
        <div  id="treeDivHight" style="overflow:auto;height:100%;">
		 <div style="width:259px; border:1px solid #ccc;font: 12px/25px Arial;" id="orgNameDivBox">
			   <div uitype="multiNav" id="orgNameBox" datasource="initBoxData"></div>
		</div>
		<div>
		  <div uitype="tree" id="treeDiv" on_click="treeClick" on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand" ></div>
	    </div>  
	   </div>
	   </div>
      </div>         
      <div uitype="bpanel"  position="center" id="centerMain" header_title="��Ա�б�" style="overflow:hidden;">
             <div class="list_header_wrap ie6_list_header_wrap"  style="padding:15px 0 15px 15px;">
				    <div class="top_float_left">
				    <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="������������ȫƴ����ƴ" editable="true" width="220" on_iconclick="iconclick"
			        		icon="search" iconwidth="18px"></span>
			        &nbsp;&nbsp;&nbsp;&nbsp;״̬��<span uiType="PullDown"   mode="Single"  id="employeeState" name="employeeState"  width="60" datasource="stateSource" label_field="text" value_field="id" select="0" on_change="changeUserState"></span>          
					</div>
					<div class="top_float_right" style="padding-right: 5px;">
					<% if(!isHideSystemBtn){ %>
					     <% if(!isHideSystemBtnInUserOrg){ %>
						<top:verifyAccess pageCode="TopUserAdmin" operateCode="updateUser">
						    <span uiType="Button" label="¼��" on_click="addUser" id="addUser"></span>
						    <span uiType="Button" label="ע��" on_click="deleteUser" id="deleteUser"></span>
						</top:verifyAccess>
						<span uiType="Button" label="������Ա" on_click="excelImport" id="excelImport"></span>
						<% } %>
					<% } %>
					    <span uiType="Button" label="������Ա" on_click="exportUser" id="exportUser"></span>
					<% if(!isHideSystemBtn){ %>
					      <% if(!isHideSystemBtnInUserOrg){ %>
						<span uiType="Button" label="����ģ��" on_click="downEmployeeTemplate" id="downEmployeeTemplate"></span>
					     <% } %>	
					<% } %>	
					</div>
			 </div>
		 <div id="userGridWrap" style="padding:0 15px 0 15px">
		     <table uitype="Grid" id="userGrid" primarykey="userId"   sorttype="1" datasource="initData" pagesize_list="[10,20,30]"  resizewidth="resizeWidth" resizeheight="resizeHeight"  colrender="columnRenderer">
				<th style="width:30px"><input type="checkbox"/></th>
				<th bindName="employeeName" sort="true" style="width:25%">����</th>
				<th bindName="account" sort="true"  style="width:20%">�˺�</th>
				<th bindName="createTime" sort="true" style="width:15%;"  renderStyle="text-align: center" format="yyyy-MM-dd">��������</th>
				<th bindName="nameFullPath" sort="true" style="width:50%;"  >������֯ȫ·��</th>
			</table>
		 </div>
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
    var fastQueryRecordOrgName='';
    //��Ͻ��Χ������֯�ṹid
    var manageDeptOrgStructure = '';
    //��ǰѡ�е����ڵ�
	var curNodeId = '';
    
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
				}else{
					rootId = null;
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
	   			//�����ݵ�����£���ť����
	   			 cui("#addUser").disable(false);
	   			 cui("#exportUser").disable(false);
	   			 cui("#downEmployeeTemplate").disable(false);
	   			 cui("#excelImport").disable(false);
	   			 cui("#deleteUser").disable(false);
			}else{
				  var emptydata=[{title:"û������"}];
	   			  obj.setDatasource(emptydata);
	   			    //�����ұߵ�ҳ������
		   			 selectNodeId = "";
			   		 selectNodeName= "";
			   		 parentNodeId =  "";
			   		 curOrgStrucId =  "";
		   			 cui("#userGrid").loadData();
		   			 //û�����ݵ������ ��ť�û�
		   			 cui("#addUser").disable(true);
		   			 cui("#exportUser").disable(true);
		   			 cui("#downEmployeeTemplate").disable(true);
		   			 cui("#excelImport").disable(true);
		   			 cui("#deleteUser").disable(true);
		   			
			}
   		 });
   		dwr.TOPEngine.setAsync(true);
	}
	//�л���֯�ṹ�����¼�������ҳ��
	function changeOrgStructure(){
		//��ղ�ѯ���������ز�ѯ�������ʾ����searchType�޸�Ϊtree
		cui('#orgNameText').setValue('');
		$("#orgNameDivBox").hide();
		cui("#treeDiv").show();
		searchType = "tree";
		curOrgStrucId = cui('#orgStructure').getValue();
		initOrgTreeData(cui('#treeDiv'));
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
	
	
   	//��̬�����¼��ڵ�
   	function lazyData(node){
   		// �����ļ���ͼƬ
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

	//���ڵ�չ�����𴥷� �����ļ���ͼƬ
	function onExpand(flag,node){
		if(flag){
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
		}else{
			node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif');
		}
	}

   	// �������¼�
    var isAdmin =""; 
    var associateType =""; //Ϊ1 ʱ������ѯ
   	function treeClick(node){
    	
   		checkId=node.getData().key;
   		curNodeId = node.getData().key; //Ϊ�ղ�ѯ��ʱ���õ�
   		selectNodeId = node.getData().key;
   		selectNodeName=node.getData().title;
   		parentNodeId = node.getData().data.parentOrgId;
   		curOrgStrucId = cui('#orgStructure').getValue();
   	   
  	    var isRootNode = false;
		var curNode = cui('#treeDiv').getNode(selectNodeId);
		if(curNode&&curNode.getData("isRoot") === true) {
			isRootNode = true;
		}
		
		if(rootId == null){
			isAdmin="no";
		}
	     
   		cui("#userGrid").loadData();
   	}

   	
    /********************��֯���Լ��༭ҳ��ĳ�ʼ��   end **************************************************************/
    
    
    
         //���ü���  1Ϊ ������ѯ��0ΪĬ��
    	function setAssociate(type){
    		var associate=$('#associateQuery')[0].checked;
    		if(type==1){
        		if(associate)$('#associateQuery')[0].checked=false;
        		else $('#associateQuery')[0].checked=true;
        	}
    		 //Ϊ1 ������ѯ
      	    associateType=$('#associateQuery')[0].checked==true?1:0;
    		//ִ�в�ѯ
        	if(searchType == "tree"){
	     	   var node=cui('#treeDiv').getActiveNode();
	     	   treeClick(node);
            }else{
            	fastQuerySelect(curOrgStrucId,parentNodeId,fastQueryRecordId,fastQueryRecordOrgName);
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
		 
		    selectNodeId = orgId;
	   		selectNodeName=orgName;
	   		parentNodeId = chooseParentNodeId;
	   		curOrgStrucId = chooseOrgStructureId;
	   		cui("#userGrid").loadData();
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
			var node = cui('#treeDiv').getNode(curNodeId);
			if(node){
    			treeClick(node);
   			}
			searchType="tree";
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
			$("#orgNameDivBox").show();
		    searchType="box";
		}
	}
	
	/********************���ٲ�ѯ    end **************************************************************/
	
	/********************��Ա�б�   start **************************************************************/
	
	
	   
	
	    var keyword="";
	    var employeeState=1;  //Ĭ����ʾ��ְ�û�
	  
	  //��ѡ���е������������������༭ʱ�Զ�ѡ��
		var selectedKey=''
			
		//״̬����
	    var stateSource=[  
	    		                    {id:"1",text:"��ְ"},
	    		                    {id:"2",text:"ע��"}
	    		                    ];
	    
	    
		//��Ⱦ�б�����
		function initData(grid,query){
			 
				//��ȡ�����ֶ���Ϣ
			    var sortFieldName = query.sortName[0];
			    var sortType = query.sortType[0];
			    //���ò�ѯ����,keyword��Ҫ���»�ȡ
			    keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
				keyword = keyword.replace(new RegExp("%", "gm"), "/%");
				keyword = keyword.replace(new RegExp("_","gm"), "/_");
				keyword = keyword.replace(new RegExp("'","gm"), "''");
				
			    var queryObj = {pageNo:query.pageNo,pageSize:query.pageSize,orgId:selectNodeId,state:employeeState,userState:employeeState,fastQueryValue:keyword,sortFieldName:sortFieldName,sortType:sortType,associateType:associateType};
			    dwr.TOPEngine.setAsync(false);
			    UserManageAction.queryUserList(queryObj,function(data){
			    	var totalSize = data.count;
					var dataList = data.list;
					//��������Դ
					grid.setDatasource(dataList,totalSize);
					if(selectedKey!=''){
						grid.selectRowsByPK(selectedKey);
						selectedKey='';
					}
	        	});
			    dwr.TOPEngine.setAsync(true);
			
	  	}

		//Grid�������Ӧ��Ȼص����������ظ߶ȼ���������
		function resizeWidth() {
			return $('body').width() -300;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid�������Ӧ�߶Ȼص����������ؿ�ȼ���������
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 58;
		}
		
		
		//����Ⱦ
		function columnRenderer(data,field) {
			
			if(field == 'employeeName'){
				//�滻��ʾ
				var employeeName = data["employeeName"];
				return "<a class='a_link'    onclick='javascript:editUser(\""+data["userId"]+ "\",\""+data["orgId"]+ "\");'>"+employeeName+"</a>";
			}
		}
		
		
		 
		 
		 //��Ա����
		var dialog;
		function addUser(){
			var url='${pageScope.cuiWebRoot}/top/sys/usermanagement/user/UserEdit.jsp?orgId='+selectNodeId+"&orgName="+encodeURIComponent(encodeURIComponent(selectNodeName))+"&orgStructureId="+curOrgStrucId+"&state="+employeeState;
			var width = (document.documentElement.clientWidth || document.body.clientWidth) - 300; // 700;
			var height =  (document.documentElement.clientHeight || document.body.clientHeight)-100; //400
		  if(!dialog){//��ֹ�ظ���������
			dialog = cui.dialog({
				title : '��Ա��Ϣ¼��',
				src : url,
				width : width,
				height : height
			})
		  }
			dialog.show(url);
			
		}
		 
		 //��Ա�༭
		function editUser(userId,orgId){
			 
			var url='${pageScope.cuiWebRoot}/top/sys/usermanagement/user/UserEdit.jsp?orgId='+selectNodeId+"&orgStructureId="+curOrgStrucId+"&userId="+userId+"&state="+employeeState;
			var width = (document.documentElement.clientWidth || document.body.clientWidth) - 300; // 700;
			var height =  (document.documentElement.clientHeight || document.body.clientHeight)-100; //400
			 if(!dialog){//��ֹ�ظ���������
				dialog = cui.dialog({
					title : '��Ա��Ϣ�༭',
					src : url,
					width : width,
					height : height
				})
			 }
			dialog.show(url);
		}
		 
		 //������ͼƬ����¼�
		 function iconclick() {
	 		keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
	        cui("#userGrid").setQuery({pageNo:1});
	        //ˢ���б�
			cui("#userGrid").loadData();
	     }
		 
		 //�ı��û�״̬
		 function  changeUserState(){
			 employeeState=cui("#employeeState").getValue();
			 cui("#userGrid").setQuery({pageNo:1});
		        //ˢ���б�
		     cui("#userGrid").loadData();
		     //ֻ��ʾ������ť ��������
		     if(employeeState==2){
			     cui('#addUser').hide();
			     cui('#downEmployeeTemplate').hide();
			     cui('#excelImport').hide();
			     cui('#deleteUser').hide();
		     }else{
		    	 cui('#addUser').show();
			     cui('#downEmployeeTemplate').show();
			     cui('#excelImport').show();
			     cui('#deleteUser').show();
		    	 
		     }
			
		 }
		 
		 
		    //�༭ҳ��ص����� ִ�ж������ʱ����Դ����������ݲ������ж�ִ��ʲô������
			function editCallBack(type,key){
				selectedKey=key;
				//������Ϣ
				if(type=="add"){
					cui("#myClickInput").setValue("");
					keyword="";
					cui("#userGrid").setQuery({pageNo:1,sortType:[],sortName:[]});
				}
				cui("#userGrid").loadData();
				cui("#userGrid").selectRowsByPK(selectedKey);
			}
		    
			function refreshList() {
				cui("#userGrid").loadData();
			}
		    
		    
			//ע����Ա����
			function deleteUser(){
				var selectIds = cui("#userGrid").getSelectedPrimaryKey();
				if(selectIds == null || selectIds.length == 0){
					cui.alert("��ѡ��Ҫע������Ա��");
					return;
				}
				cui.confirm("ȷ��Ҫע����"+selectIds.length+"����Ա��Ϣ��",{
					onYes:function(){
						dwr.TOPEngine.setAsync(false);
						//�ж��û��Ƿ��й�������������
						  PostAction.queryUserTaskInALlProcess(selectIds,function(data){
										 if(data.flag){//true ��û�����Ѵ������ݣ�����ע��
									
													UserManageAction.deleteUsers(selectIds,function(data){
															cui("#userGrid").removeData(cui("#userGrid").getSelectedIndex());
															cui("#userGrid").loadData();
															cui.message("ע��"+selectIds.length+"����Ա��Ϣ�ɹ�","success");
											        });
									 	 }else{
								    		 //��ʾ����ע������Ա
								    		 cui.alert("��<font color='red'>"+data.usrNames+"</font>������δ����������ݣ�����ע����");
								    	 }
								    	
						     });
						dwr.TOPEngine.setAsync(true);
				  	}
				});
				
			}    
			
			 
			//������Ա����ģ��
			function downEmployeeTemplate(){
				var url = '${pageScope.cuiWebRoot}/top/sys/user/downloadUserImportTemplate.ac';
				 window.open(url,'_self');
			}
			
			//������Ա��Ϣ
			function exportUser(){
				var fastQueryValue = "";
				var vos =  cui("#userGrid").getSelectedPrimaryKey();
				fastQueryValue= cui("#myClickInput").getValue();
				//jodd���󣬲���Ϊ/���治��Ϊ""��
				if(fastQueryValue == ""){
					fastQueryValue = null;
				}
				 associateType=$('#associateQuery')[0].checked==true?1:0;
				 
				 cui.confirm('��ѡ�񵼳�����������', {
			            buttons: [
			                {
			                    name: '��Ա������Ϣ',
			                    handler: function () {
			        				 var url = "${pageScope.cuiWebRoot}/top/sys/user/userExport.ac?orgId="+selectNodeId+"&orgStructureId="+curOrgStrucId+"&fastQueryValue="+fastQueryValue+"&state="+employeeState+"&associateType="+associateType+"&selectedIds="+vos;
			        			     location.href = url;
			                    }
			                },
			                {
			                    name: ' ��Ա��λ��Ϣ',
			                    handler: function () {
			                    	 var url = "${pageScope.cuiWebRoot}/top/sys/user/userPostExport.ac?orgId="+selectNodeId+"&orgStructureId="+curOrgStrucId+"&fastQueryValue="+fastQueryValue+"&state="+employeeState+"&associateType="+associateType+"&selectedIds="+vos;
			        			     location.href = url;
			                    }
			                },
			                {
			                    name: ' ȡ��',
			                    handler: function () {
			                    	return;
			                    }
			                }
			            ]
			        });
				 

			}
			
		     //������Ա��Ϣ
			 function excelImport(){
				 var vWidth =450;
				 var vHeight =180;
				 var vTopPos =(window.screen.height-180)/2;
				 var vLeftPos =(window.screen.width-450)/2;
				 var vHeight =180;
				 var sFeatures = "width="+vWidth+",height="+vHeight+",help=no,resizable=no,menu=no,toolbar=no,status=no,left="+vLeftPos+",top="+vTopPos;
				 var win = window.open("${pageScope.cuiWebRoot}/excelImportServlet.topExcelImportServlet?actionType=excelImport&configName=excel.xml&callback=editCallBack&excelId=userImport&param="+selectNodeId, "ExcelImportWindow", sFeatures);
				 if(win) { win.focus();}
				} 
			 

	/********************��Ա�б�   end **************************************************************/
	
	
   
	

	
	
	
 </script>
</body>
</html>