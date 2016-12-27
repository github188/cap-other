<%
  /**********************************************************************
			 * ��֯����
			 * 2014-07-30  ����  �½�
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<head>
    <title>��֯���� </title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/organization/css/orgAdjust.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/OrganizationAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
</head>
<body>
     <div uitype="Borderlayout" id="border" is_root="true">
        <div position="top" height="100px" id="leadingAreaDiv" >
          <div style="width: 700px;margin: 0 auto;">
        	<div class="step_1" id="leadingHead"></div>
        	<div uitype="button" on_click="preview" label="��һ��" id="preview" class="leading_button_style leading_button_left_style" ></div>
        	<div uitype="button" on_click="next" label="��һ��" id="next" class="leading_button_style leading_button_right_style" disable="true" style="display: block;" button_type="green-button"></div>
        	<div uitype="button" on_click="finish" label="��&nbsp;&nbsp;&nbsp;��" id="finish" class="leading_button_style leading_button_right_style" button_type="green-button"></div>
          </div>
        </div>
        <div position="center" id="operateAreaDiv" >
	         <div class="sourceDiv" id="sourceDiv"  style="text-align: left;overflow-y:auto; ">
	         <div class="operateAreaHeadStyle">Դ��֯</div><hr>
	           &nbsp;<label style="font-size: 14px;">��֯�ṹ��</label>
			        <div uitype="radioGroup" name="orgStructureId" id="orgStructure" on_change="changeOrgStructure" radio_list="initOrgStructure"> 
					</div>
					<div uitype="tree" id="treeDiv" on_click="treeClick" on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand" ></div>
	         </div>
			 <div class="imgDiv" id="imgDiv" style="display:inline-block;margin: 0 auto;">
			 	<img title="ѡ��Դ��֯��Ŀ����֯" src="${pageScope.cuiWebRoot}/top/sys/images/arrow.png" width="64px" height="64px" style="margin-bottom: 310px;"/>
			 </div>
			 <div class="destDiv" id="destDiv" style="text-align: left;overflow-y:auto; ">
			 <div class="operateAreaHeadStyle">Ŀ����֯</div><hr>
			 	&nbsp;<label style="font-size: 14px;">��֯�ṹ��</label>
			        <div uitype="radioGroup" name="orgStructureId1" id="orgStructure1" radio_list="initOrgStructure" readonly="true"> 
					</div>
					<div uitype="tree" id="treeDiv1" on_click="treeClick" on_lazy_read="lazyData" click_folder_mode="1" on_expand="onExpand" ></div>
			 </div>
			 <div class="afterAdjustDiv" id="afterAdjustDiv" style="display:none;text-align: left;margin-left: 22px;overflow-y:auto; ">
			 	<div class="operateAreaHeadStyle">������</div><hr>
			 	<div uitype="tree" id="previewTree" on_lazy_read="previewTreeLazyData" on_click="clickPreviewTree" click_folder_mode="1" on_expand="onExpand" ></div>
			 </div>
			 <div class="adjustOrgCodeDiv" id="adjustOrgCodeDiv" style="display:none;border: 0;margin-left: 90px;">
			 	<label class="label_head_style">������֯����</label>
			 	<label class="label_style">&nbsp;ע����<font color="red">���족</font>����֯�����ͻ�������:</label>
			 	<label class="label_style" style="padding-right: 80px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���ѡ���Ҳ��޸ġ�</label>
			 	<table id="confictTable" style="clear:both;float:left;">
			 	</table>
			 </div>
			 <div class="adjustOrgTypeDiv" id="adjustOrgTypeDiv" style="display:none;border: 0;margin-left: 90px;">
			 	<label class="label_head_style">��֯���͵�������ѡ��</label>
			 	<label class="label_style">&nbsp;ע�����ѡ���Ҳ��޸ġ�</label>
			 	<label class="label_style">&nbsp;��֯���ͣ�</label>
			  	<span  class="label_style" uitype="singlePullDown" id="orgType" name="orgType" datasource="initOrgTypeData" on_change="selectOrgType" empty_text="��ѡ��"
			  		editable="false" label_field="orgTypeName" value_field="orgType""></span>
			 	<table id="orgTypeTable" style="clear:both;float: left;">
			 	</table>
			 </div>
        </div>
    </div>
<script type="text/javascript">
	//��Ͻ��Χ,���ĸ��ڵ�ID
	var rootId = '-1';
	//ѡ��Դ�ڵ�id
	var selectSourceNodeId;
	//ѡ��Ŀ��ڵ�id
	var selectDestNodeId;
	//�������裬Ĭ��Ϊ1
	var step = 1;
	//��һ����ʶ Դid:Ŀ��id
	var priviewFlag;
	//���±�ʶ  Դid:Ŀ��id
	var latestFlag;
	//���޸���֯���͵���֯id
	var modifyOrgId;
	//���޸���֯���͵���֯����
	var modifyOrgName;
	//���޸���֯���͵���֯����
	var modifyOrgCode;
	//��������Ϣ
	var message = [];
	//��Ͻ��Χ������֯�ṹid
    var manageDeptOrgStructure = '';
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
       initOrgTreeData('treeDiv');
       initOrgTreeData('treeDiv1');
	}); 
	//��һ��	
	function next(){
		//�ӵ�һ���л����ڶ���
		if(step == 1){
			//�ж��ƶ���֯�Ƿ�ΪĿ����֯���ӽڵ�
			var node = cui("#treeDiv").getNode(selectSourceNodeId);
			//����ýڵ㱾����Ŀ��ڵ��µ��ӽڵ�
			if(node.getData().data.parentOrgId==selectDestNodeId){
				cui.alert("ѡ�е�Դ��֯�Ѿ�������Ŀ����֯�¡�");
				return false;
			}
			//���Դ��֯ѡ�е��Ǹ��ڵ㣬Ҳ��������ת���ڶ����� start
			if(globalUserId != 'SuperAdmin'){
				var vOrgStructure = cui('#orgStructure').getValue();
				var vId = '-1';
				if(vOrgStructure==manageDeptOrgStructure){
					//����֯�ṹΪ����Э��ʱ���жϸ��ڵ���ѡ�нڵ��Ƿ����
					if(selectSourceNodeId == rootId){
						cui.alert("ѡ�е�Դ��֯Ϊ����֯�����ܵ�����");
						return false;
					}
				}else{
					//��Э
					if(node.getData().data.parentOrgId == '-1'){
						cui.alert("ѡ�е�Դ��֯Ϊ����֯�����ܵ�����");
						return false;
					}
				}
			}else{
				if(node.getData().data.parentOrgId == '-1'){
					cui.alert("ѡ�е�Դ��֯Ϊ����֯�����ܵ�����");
					return false;
				}
			}
			//end
			var sourceOrgName=node.getData().data.orgName;
			var DestOrgName=cui("#treeDiv1").getNode(selectDestNodeId).getData().data.orgName;
		
			  cui.confirm("��<font color='red'>"+sourceOrgName+"</font>�������¼���֯���뽫���ݡ�<font color='red'>"+DestOrgName+"</font>���ı���淶�޸ģ��Ƿ������",{
					onYes:function(){ //����
									//�ж�Ŀ����֯���Ƿ���������֯
									dwr.TOPEngine.setAsync(false);
									OrganizationAction.isExistSameOrgName(selectDestNodeId,selectSourceNodeId,function(data){
								         if(!data){
								      		    cui.alert("Ŀ����֯�Ѵ���������֯�����ܵ�����");
								              	return false;
								       	 }else{
											step = 2;
											document.getElementById('leadingHead').className="step_2";
											document.getElementById('sourceDiv').style.display = 'none';
											document.getElementById('imgDiv').style.display = 'none';
											document.getElementById('destDiv').style.display = 'none';
											document.getElementById('afterAdjustDiv').style.display = 'inline-block';
											document.getElementById('adjustOrgCodeDiv').style.display = 'inline-block';
											//ÿ�ν���ڶ������͸������±�ʶ
											latestFlag = selectDestNodeId+':'+selectSourceNodeId;
											//��һ�Σ���ҪУ�����
											if(!priviewFlag){
												priviewFlag = latestFlag;
												changeToStepTwo();
											}else{
												//�������뵽�ڶ�����ʱ�����ǰ�����α�ʶ��һ������ҪУ����룬���¼���
												if(priviewFlag != latestFlag){
													changeToStepTwo();
													//������ɣ�������ֵ������һ�Σ������´���֤
													priviewFlag = latestFlag;
												}
											}
								       	 }
									});
									dwr.TOPEngine.setAsync(true);
									buttonShow();
					   }
			        }
			   );
		
			
			
		}else if(step == 2){
			step = 3;
			document.getElementById('leadingHead').className="step_3";
			document.getElementById('adjustOrgCodeDiv').style.display = 'none';
			document.getElementById('adjustOrgTypeDiv').style.display = 'inline-block';
		}
		buttonShow();
	}
	//��һ��	
	function preview(){
		//�ӵڶ����л�����һ��
		if(step == 2){
			step = 1;
			//���ԭ�еı����ͻ
			deleteConfictNode();
			document.getElementById('leadingHead').className="step_1";
			document.getElementById('sourceDiv').style.display = 'inline-block';
			document.getElementById('imgDiv').style.display = 'inline-block';
			document.getElementById('destDiv').style.display = 'inline-block';
			document.getElementById('afterAdjustDiv').style.display = 'none';
			document.getElementById('adjustOrgCodeDiv').style.display = 'none';
		}else if(step == 3){
			step = 2;
			document.getElementById('leadingHead').className="step_2";
			document.getElementById('sourceDiv').style.display = 'none';
			document.getElementById('imgDiv').style.display = 'none';
			document.getElementById('destDiv').style.display = 'none';
			document.getElementById('afterAdjustDiv').style.display = 'inline-block';
			document.getElementById('adjustOrgCodeDiv').style.display = 'inline-block';
			document.getElementById('adjustOrgTypeDiv').style.display = 'none';
		}
		buttonShow();
	}
	//��ɡ�����
	function finish(){
		dwr.TOPEngine.setAsync(false);
 		OrganizationAction.adjustOrganizaiton(message,function(resultData){
			if(resultData){
				cui.message('��֯�����ɹ���');
				step = 4;
				//����֮�󣬰�ťȫ�����أ�ȫ�ֱ������
				buttonShow();
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	//ѡ��ֵ����
	function selectOrgType(data){
		//1���޸�����ֵ��Ҫ�ı�
		var tr = document.getElementById('orgTypeTable').rows[0];
		if(tr){
			var newNodeTitle = modifyOrgName + '('+ data.orgTypeName + ')';
			tr.cells[0].innerText = newNodeTitle;
			//2�����Ͻڵ���ʾ��������Ҫ�ı�
			var node = cui('#previewTree').getNode(modifyOrgId);
			node.setData("title",newNodeTitle);
			//3����Ӧ��orgType��Ҫ����
			node.getData().data.orgType = data.orgType;
			//4����¼�����Ϣ
			var objMessage = getMessage(modifyOrgId);
			if(objMessage == null){
				objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":modifyOrgId,"parentOrgId":node.parent().getData().data.orgId,"orgType":data.orgType};
				message.push(objMessage);
			}else{
				objMessage.orgType = data.orgType;
			}
		}
	}
	//���Ԥ������������֯����
	function clickPreviewTree(node){
		var data = node.getData().data;
		modifyOrgName = data.orgName;
		modifyOrgId = data.orgId;
		modifyOrgCode = data.orgCode;
		var orgTypeName = data.orgTypeName;
		var orgType = data.orgType;
		
		var table = document.getElementById('orgTypeTable');
		var rows = table.rows.length;
		if(rows > 0){
			//�Ƚ�֮ǰ�ļ�¼ɾ�����������޸�����
			table.deleteRow(0);
		}
		var oTr = table.insertRow(-1);
		var oTd = oTr.insertCell(0);
		oTd.className = "td_label";
		oTd.innerHTML = modifyOrgName + "(" + orgTypeName + ")<br>";
		oTr.id = modifyOrgId;
	}
	//��ʼ����֯����������
 	function initOrgTypeData(obj){
 		dwr.TOPEngine.setAsync(false);
	 		OrganizationAction.getOrgTypeInfo(function(resultData){
				obj.setDatasource(jQuery.parseJSON(resultData));
			});
 		dwr.TOPEngine.setAsync(true);
 	}
	
	//�л����ڶ�����������֯����
	function changeToStepTwo(){
		message = [];
		//��Ŀ��IDΪ�������µ���   start-------------------------
		var emptydata=[{title:"û������"}];
      	//��ѯ��֯����Ϣ
      	dwr.TOPEngine.setAsync(false);
      	var node = {orgStructureId:cui('#orgStructure').getValue(), orgId:selectDestNodeId};
      	cui("#previewTree").setDatasource(null);
      	OrganizationAction.getOrgTreeNode(node,function(data){
       		var treeData = $.parseJSON(data);
    		if(treeData!=null){
       			  cui("#previewTree").setDatasource(treeData);
    		}else{
       			  cui("#previewTree").setDatasource(emptydata);
    		}
      	});
      	dwr.TOPEngine.setAsync(true);
	    //��Ŀ��IDΪ�������µ��� end-----------------------------------//
	
       //�������ṹ start-------------------------------------------
       
      	   /**
		*�������ṹ
		*1���ƶ�Դ�ڵ㵽Ŀ����
		*2������Ŀ��ڵ㼰�ӽڵ����
		*/
		//��ȡĿ����֯
		var parentNode = cui("#previewTree").getNode(selectDestNodeId);
		var parentNodeCode= parentNode.getData().data.orgCode;
		parentNode.setData("title",parentNode.getData().data.orgName+"("+parentNodeCode+")("+parentNode.getData().data.orgTypeName+")");
		parentNode.setData({'unselectable':true});
		//�ƶ�Դ����Ŀ��ڵ�
		var node = cui("#treeDiv").getNode(selectSourceNodeId);
		//ѡ�еĽ�Ҫ�ƶ���Դ�ڵ��ƶ���������Ŀ��ڵ���
		var newNode={title:node.getData().title, key:node.getData().key,isLazy:node.getData().isFolder,
				data:{orgId:node.getData().data.orgId,orgCode:node.getData().data.orgCode,
			orgName:node.getData().data.orgName,orgTypeName:node.getData().data.orgTypeName,
			orgType:node.getData().data.orgType,parentOrgId:selectDestNodeId},
				icon:'${pageScope.cuiWebRoot}/top/sys/images/closeicon.gif'};
		
		//��װԴ��֯��Ϣ
		var objMessage = getMessage(selectSourceNodeId);
		if(objMessage == null){
			//��װ orgId��parentOrgId orgStructureId
			objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":selectSourceNodeId,"parentOrgId":selectDestNodeId,"orgCode":node.getData().data.orgCode};
			message.push(objMessage);
		}
		parentNode.addChild(newNode);
		cui("#previewTree").getNode(selectSourceNodeId).expand(true);
		
		parentNode.expand(true);
		//����Դ�ڵ���ӽڵ����
		//�����޸��¼���֯����
		recursiveNode(parentNode,function(arrNode){
			$.each(arrNode,function(i,node){
					var oldChildCode =node.getData().data.orgCode;
					var oldChildCodeLength = oldChildCode.length;
					//��ȡ����λ����
					var lastCode = oldChildCode.substr(oldChildCodeLength-2,2);
					var vNewCode = node.parent().getData().data.orgCode+lastCode;
					node.getData().data.orgCode = vNewCode;
					//�����иĶ�
					if(vNewCode != oldChildCode){
						//��װԴ��֯��Ϣ
						var vId = node.getData().data.orgId;
						var objMessage = getMessage(vId);
						if(objMessage == null){
							//��װ orgId��parentOrgId orgStructureId
							objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":vId,"parentOrgId":node.parent().getData().data.orgId,"orgCode":vNewCode};
							message.push(objMessage);
						}else{
							objMessage.orgCode = vNewCode;
						}
					}
					node.setData("title",node.getData().data.orgName+"("+node.getData().data.orgCode+")("+node.getData().data.orgTypeName+")");
			});
		});
	    //�������ṹ end----------------------------------
		//У���µ����ϵ���֯�����Ƿ��г�ͻ
		validateCode();
		buttonShow();
	}
	//��ȡ�Ѿ���װ�Ķ���
	function getMessage(orgId){
		var tMessage=null;
		$.each(message,function(o,iMessage){
			if(iMessage.orgId==orgId){
				tMessage=iMessage;
				return tMessage;
			}
		});
	    return tMessage;
	}
	//�г�ͻ����֯id����
	var orgIds = [];
	//�������ͻ
	function validateCode(){
		orgIds = [];
		deleteConfictNode();
		//�Ƿ�ͨ�����ı�ʶ
		var rootNode = cui("#previewTree").getNode(selectDestNodeId);
		//�ݹ�������ͻ
		recursiveNode(rootNode,function(arrNode){
			for(var i=0;i<arrNode.length;i++){
				for(var j=i+1;j<arrNode.length;j++){
					if(arrNode[i].getData().data.orgCode==arrNode[j].getData().data.orgCode){
						arrNode[i].setStyle("color:red");
						arrNode[j].setStyle("color:red");
						//���б����ͻ����֯�ŵ�������������˴��Ƿ���Ҫ�����߶��ŵ��༭��������Ҫ��ϸ���ǣ�Ŀǰ�� һ��
						//pushCodeConfictNode(arrNode[i]);
						pushCodeConfictNode(arrNode[j]);
					}
				}
			}
		});
	}
	//���ư�ť��չʾ
	function buttonShow(){
		if(step == 2){
			var table = document.getElementById('confictTable');
			var rows = table.rows.length;
			cui('#preview').show();
			if(rows>0){
				cui('#next').disable(true);
			}else{
				cui('#next').show();
				cui('#next').disable(false);
			}
			cui('#preview').show();
			cui('#finish').hide();
		}else if(step == 1){
			cui('#preview').hide();
			//��ѡ����Դ��֯��Ŀ����֯�����߻�����ͬʱ����ʾ����һ������ť
	   		if(selectSourceNodeId &&��selectDestNodeId){
	   			if(selectSourceNodeId != selectDestNodeId){
		   			cui('#next').disable(false);
	   			}else{
	   				cui('#next').disable(true);
	   			}
	   		}
		}else if(step == 3){
			cui('#preview').show();
			cui('#next').hide();
			cui('#finish').show();
		}else if(step == 4){
			cui('#preview').hide();
			cui('#finish').hide();
			cui('#orgType').setReadonly(true);
		}
	}
	//ɾ����ͻ
	function deleteConfictNode(){
		var table = document.getElementById('confictTable');
		var rows = table.rows.length;
		for(var i=rows;i>0;i--){ //�޸�Ϊ�Ӻ�ʼɾ��rows�Ǳ仯��
			table.deleteRow(i-1);
		}
	}
	//���г�ͻ����֯�ŵ����������
	function pushCodeConfictNode(node){
		var data = node.getData().data;
		var nodeKey = data.orgId;
		var isExisted = true;
	    // ��id�Ѿ������֮�󣬾Ͳ���Ҫ�����
		for(var i=0;i<orgIds.length;i++){
			if(orgIds[i] == nodeKey){
				isExisted = false;
				break;
			}
		}
		if(isExisted){
			orgIds.push(nodeKey);
		}else{
			return;
		}
		var orgName = data.orgName;
		var orgCode = data.orgCode;
		var orgCodeLength = orgCode.length;
		//��ȡ����λ����
		var lastCode = orgCode.substr(orgCodeLength-2,2);
		var parentCode = orgCode.substr(0,orgCodeLength);
		var table = document.getElementById('confictTable');
		var rows = table.rows.length;
		var oTr = table.insertRow(rows);
		var oTd = oTr.insertCell(0);
		oTd.className = "td_label";
		oTd.innerHTML = orgName + "(" + parentCode + "<input type='text' maxlength='2' style='width:40px;' onblur='validateAdjustOrgCode(\"" + nodeKey + "\",\"" + lastCode + "\")' id='" + nodeKey + "' value='" + lastCode + "' />)<br>"; 
	}
	/**
	 * ��������������ƿ���ʱ����֤�޸ĵı����Ƿ�Ϸ�
	 * @param nodeId �޸ĵ���֯id
	 * @lastCode �޸�֮ǰ�������λ����
	 */
	function validateAdjustOrgCode(nodeId,lastCode){
		var newLastCode = document.getElementById(nodeId).value;
		if(newLastCode == lastCode){
			return;
		}
		if(!isCode(newLastCode)){
			cui.alert('��֯����ֻ��ΪӢ�Ļ����֡�');
			return;
		}
		modifyNodeCode(nodeId,newLastCode);
		resetTreeStyle();
		validateCode();
		buttonShow();
	}
	/**
	* ����ֻ����������
	*/
	function isCode(code){
		var reg = new  RegExp("^[A-Za-z0-9]+$");
		return (reg.test(code));
	}
	//�޸Ľڵ���֯����
	function modifyNodeCode(nodeId,lastCode){
		var node = cui('#previewTree').getNode(nodeId);
		if(lastCode.length!=2){
			cui.alert('��������λ������Ϊ�����׺��');
			return;
		}
		oldCode = node.getData().data.orgCode;
		codeLength = oldCode.length;
		var newCode = node.getData().data.orgCode.substr(0,codeLength-2)+lastCode;
		node.getData().data.orgCode = newCode;
		
		var newParentName = node.getData().data.orgName+'('+node.getData().data.orgCode+')('+node.getData().data.orgTypeName+')';
		node.setData("title",newParentName);
		
		//��װ������Ϣ
		var objMessage = getMessage(nodeId);
		if(objMessage == null){
			objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":nodeId,"parentOrgId":node.parent().getData().data.orgId,"orgCode":newCode};
			message.push(objMessage);
		}else{
			objMessage.orgCode = newCode;
		}
		//�����޸��¼���֯����
		recursiveNode(node,function(arrNode){
			$.each(arrNode,function(i,vNode){
					var oldChildcode = vNode.getData().data.orgCode;
					var oldChildcodeLength = oldChildcode.length;
					//��ȡ����λ����
					var lastChildCode = oldChildcode.substr(oldChildcodeLength-2,2);
					var vNewChildCode = vNode.parent().getData().data.orgCode+lastChildCode;
					vNode.getData().data.orgCode = vNewChildCode;
					var newName = vNode.getData().data.orgName+'('+vNode.getData().data.orgCode+')('+vNode.getData().data.orgTypeName+')';
					
					//��װ������Ϣ
					var objMessage = getMessage(vNode.getData().data.orgId);
					if(objMessage == null){
						objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":vNode.getData().data.orgId,"parentOrgId":vNode.parent().getData().data.orgId,"orgCode":vNewChildCode};
						message.push(objMessage);
					}else{
						objMessage.orgCode = vNewChildCode;
					}
					
					vNode.setData("title",newName);
			});
		});
	}
	//����������нڵ���ʽ
	function resetTreeStyle(){
		var rootNode = cui("#previewTree").getNode(selectDestNodeId);
		recursiveNode(rootNode,function(arrNode){
			$.each(arrNode,function(i,node){
				node.removeStyle();
			});
		});
	}
 	//��̬�����¼��ڵ�
   	function previewTreeLazyData(node){
   		dwr.TOPEngine.setAsync(false);
		var userChildObj={"orgId":node.getData("key"),orgStructureId:cui('#orgStructure').getValue()};
		OrganizationAction.getOrgTreeNode(userChildObj,function(data){
	    	var nodeData = $.parseJSON(data);
	    	//�����ǰҪչ���Ľڵ㲻��Ŀ��ڵ㣬��Ҫ��ӵĽڵ�ΪԴ�ڵ㣬��˵����Դ�ڵ��µģ����˵�������ʾ
	    	var children = nodeData.children;
	    	var toShow = [];
	    	var sourceId = selectSourceNodeId;
 			if(selectDestNodeId != node.getData("key")){
				for(var j=0;j<children.length;j++){
					var bAdd = true;
					var curChild = children[j];
					if(curChild.key==sourceId){
						bAdd = false;
						continue;
					}
					if(bAdd){
						toShow.push(curChild);	
					}
				}
     		}else{
     			toShow = children.slice(0);
         	}
         	
	    	//�����ӽڵ���Ϣ
	    	 node.addChild(toShow);
		     node.setLazyNodeStatus(node.ok);
		     if(node.children()){
	        	for(var i=0;i<node.children().length;i++){
	            	var childNode=node.children()[i];
   	                //�����ڵ���֯���� start
					var oldCode = childNode.getData().data.orgCode;
					var oldCodeLength = oldCode.length;
					var lastCode = oldCode.substr(oldCodeLength-2,2);
					var vNewCode = node.getData().data.orgCode + lastCode;
					childNode.getData().data.orgCode = vNewCode
					
					//��װ������Ϣ
					var objMessage = getMessage(childNode.getData().data.orgId);
					if(objMessage == null){
						objMessage = {"orgStructureId":cui('#orgStructure').getValue(),"orgId":childNode.getData().data.orgId,"parentOrgId":node.getData().data.orgId,"orgCode":vNewCode};
						message.push(objMessage);
					}else{
						objMessage.orgCode = vNewCode;
					}

					childNode.setData("title",childNode.getData().data.orgName+"("+childNode.getData().data.orgCode+")("+childNode.getData().data.orgTypeName+")");
					//�����ڵ���֯���� end
	            	childNode.expand(true);
	        	}
	   		  }
	     });
	    dwr.TOPEngine.setAsync(true);
   	}
 	
	//�ݹ鴦�����ڵ�
    function recursiveNode(parentNode,func){
        if(parentNode.hasChild()){
        	for(var i=0;i<parentNode.children().length;i++){
            	var childNode=parentNode.children()[i];
            	func(parentNode.children());
            	recursiveNode(childNode,func);
        	}
        }
    }
   	// �������¼�
   	function treeClick(node,event){
   		//�������� below
   		var nodeId = node.getData().key;
   		var treeId = event.currentTarget.id
   		if(treeId){
   			if(treeId == 'treeDiv'){
   				if(!node.isRoot){
	   				selectSourceNodeId = nodeId;
   				}
   			}
   			if(treeId == 'treeDiv1'){
   				selectDestNodeId = nodeId;
   			}
   		}
   		buttonShow();
   	}
   	//��ȡ��ѯ����Ҫ�Ĳ�ѯ����
   	function getQueryCondition(){
   		var vOrgStructure = cui('#orgStructure').getValue();
		var vId = '-1';
		//���л����ǹ�Ͻ��Χ�ڵ���֯�ṹʱ��չ��������
		if(vOrgStructure==manageDeptOrgStructure){
			vId = rootId;
		}
		var node = {orgStructureId:vOrgStructure, orgId:vId};
		return node;
   	}
	//����ʼ��
	function initOrgTreeData(id){
		var obj = cui('#'+id);
		node = getQueryCondition();
		dwr.TOPEngine.setAsync(false);
		OrganizationAction.getOrgTreeNode(node,function(data){
		   	if(data&&data!==""){
	   			var treeData = jQuery.parseJSON(data);
	   			treeData.isRoot = true;
	   			obj.setDatasource(treeData);
	   		    //������ڵ�
	   			obj.getNode(treeData.key).activate(true);
	   			obj.getNode(treeData.key).expand(true);
	   			//ȡ������״̬
	   			obj.getNode(treeData.key).deactivate();
	   			//����Դ��֯���ĸ��ڵ�
	   			//if(id='treeDiv'){
	   				//obj.getNode(treeData.key).disable();
	   			//}
			}else{
				  var emptydata=[{title:"���޸���֯"}];
	   			  obj.setDatasource(emptydata);
	   			  $('#moveOrg').hide();
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
	function changeOrgStructure(value){
		cui('#orgStructure1').setValue(value);
		initOrgTreeData('treeDiv');
	    initOrgTreeData('treeDiv1');
	    selectSourceNodeId = '';
		selectDestNodeId = '';
	}
   	//��̬�����¼��ڵ�
   	function lazyData(node){
   		node.setData('icon','${pageScope.cuiWebRoot}/top/sys/images/openicon.gif');
   		dwr.TOPEngine.setAsync(false);
		var userChildObj={"orgId":node.getData().key,orgStructureId:cui('#orgStructure').getValue()};
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
 </script>
</body>
</html>