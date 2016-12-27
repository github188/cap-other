<%
/**********************************************************************
* Ӧ������:Ӧ������ҳ
* 2014-7-4 ʯ�� �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>Ӧ�ñ༭ҳ</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FuncAction.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js"></script>
<style type="text/css">
 .imgMiddle {line-height:350px;text-align:center;}
.top_header_wrap{
	padding-right:5px;
}
</style> 
</head>
<body onload="window.status='Finished';">
<div uitype="Borderlayout"  id="body" is_root="true" on_sizechange="resizeTab">
	<div id="topMain" style="overflow:hidden;" position="top" height="330" gap="0px 0px 0px 0px" collapsable="true" show_expand_icon="true">
	<div class="top_header_wrap" style="padding-top:15px;padding-bottom:15px;padding-right:15px;">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle">�༭Ӧ����Ϣ</font> 
		</div>
		<div class="thw_operate" <% if(isHideSystemBtn){ %> style="display:none" <% } %>>
			<span uitype="button" label="�鿴Ȩ��" id="button_right" on_click="rightRecommend"></span>
			<span uitype="button" id="new_same" label="����ͬ��"  menu="insertSame" ></span>
			<span uitype="button" id="new_sub" label="�����¼�"  menu="insertSub"></span>
			<span uitype="button" label="�༭" id="updBtn" on_click="updateFunc"></span>
			<span uitype="button" label="����" id="saveBtn" on_click="saveFunc"></span>
			<span uitype="button" label="ɾ��" id="delBtn" on_click="delFunc"></span>
			<span uitype="button" label="����" id="back_to"   on_click="backTo" ></span>
		</div>
	</div>
	<div class="top_content_wrap cui_ext_textmode">
			<table class="form_table" style="table-layout:fixed;">
					<tr>
						<td class="td_label" width="10%"><span class="top_required">*</span><span id="nodeNameText"></span>Ӧ�����ƣ�</td>
						<td class="td_content" width="40%" >
							<span uitype="input" id="funcName" name="funcName" databind="funcData.funcName"  width="240" maxlength="36"
								validate="[{'type':'required','rule':{'m':'������Ӧ�����ơ�'}}, {'type':'custom','rule':{'against':'checkName','m':'����ֻ��Ϊ���֡����֡���ĸ���»��ߡ���б�ܡ���Ӣ�����š�'}}, {'type':'custom','rule':{'against':'isExistRename','m':'�����ѱ�ռ�á�'}}]"
							></span>
						</td>
						<td class="td_label" width="10%"><span class="top_required">*</span><span id="nodeCodeText"></span>Ӧ�ñ��룺</td>
						<td class="td_content" width="40%" >
							<span uitype="input" id="funcCode" name="funcCode" databind="funcData.funcCode"  width="220" maxlength="28"
								validate="[{'type':'required','rule':{'m':'������Ӧ�ñ��롣'}}, {'type':'custom','rule':{'against':'checkCode','m':'����ֻ��Ϊ���֡���ĸ���»��ߡ�'}}, {'type':'custom','rule':{'against':'isExistCode','m':'�����ѱ�ռ�á�'}}]"
							></span>
						</td>
					</tr>
					<tr>
						<td class="td_label"> <span class="top_required">*</span>Ӧ��״̬�� </td>
						<td>
							<span uitype="RadioGroup" name="status" id="status" value="1"  databind="funcData.status" validate="��ѡ��Ӧ��״̬��"> 
								<input type="radio" name="status" value="1"/>����
                				<input type="radio" name="status" value="2"/>����
							</span> 
						</td>
						<td class="td_label"> <span class="top_required">*</span>��Ҫ��Ȩ��  </td>
						<td>
							<span uitype="RadioGroup" name="permissionType" id="permissionType" value="2"  databind="funcData.permissionType" validate="��ѡ���Ƿ���Ҫ��Ȩ��"> 
								<input type="radio" name="permissionType" value="2"/>��
                				<input type="radio" name="permissionType" value="1"/>��
							</span> 
						</td>
					</tr>
					<tr>
						<td class="td_label">����ʱ�䣺</td>
						<td class="td_content" >
							<span uitype="Calender" id="updateTime" name="updateTime" width="240" format="yyyy-MM-dd hh:mm" databind="funcData.updateTime"></span>
						</td>
						<td class="td_label">�ϼ����ƣ�</td>
						<td class="td_content" >
							<span uitype="input" id="parentFuncName" name="parentFuncName" width="220" databind="funcData.parentFuncName"></span>
						</td>
					</tr>
					<tr>
						<td class="td_label"  >��ҳ��ַ��</td>
						<td class="td_content">
							<span uitype="input" id="funcUrl" name="funcUrl"  databind="funcData.funcUrl"  maxlength="500"
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'��ҳ��ַ�����������ġ�'}}]"
								 width="98%"></span>
						</td>
						<td class="td_label"  >���¼�¼��ַ��</td>
						<td class="td_content">
							<span uitype="input" id="funcNoteUrl" name="funcNoteUrl"  databind="funcData.funcNoteUrl"  maxlength="500"
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'���¼�¼��ַ�����������ġ�'}}]"
								 width="98%"></span>
						</td>
					</tr>
					<tr>
						<td class="td_label">ͼ���ַ��</td>
						<td class="td_content">
							<span uitype="input" id="menuIconUrl" name="menuIconUrl"  databind="funcData.menuIconUrl"  maxlength="200"
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'ͼ���ַ�����������ġ�'}}]"
								 width="98%"></span>
						</td>
						<td class="td_label"  >�����ĵ���ַ��</td>
						<td class="td_content">
							<span uitype="input" id="helpDocumentUrl" name="helpDocumentUrl"  databind="funcData.helpDocumentUrl"  maxlength="500"
								 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'���¼�¼��ַ�����������ġ�'}}]"
								 width="98%"></span>
						</td>
					</tr>
					<tr>
						<td class="td_label" valign="top">������
						</td>
						<td class="td_content" colspan = "3">
							<div>
								<span uitype="textarea" name="description" databind="funcData.description" 
									relation="remarkLength" maxlength="500" width="99%"></span>
								<div style="float:right">
									<font id="applyRemarkLengthFont" >(����������<label id="remarkLength" style="color:red;"></label>&nbsp; �ַ�)</font>
								</div>
							</div>
						</td>
					</tr>
			</table>
	</div>
	</div>
	<div  id="centerMain" position="center" url="" gap="0px 0px 0px 0px" />
	
	</div>
</div>
<!-- js�ű� -->
<script type="text/javascript">

	//�������ʽ add ���� edit �޸�
	var actionType = "<c:out value='${param.actionType}'/>";
	//ģ��ID
	var moduleId = "<c:out value='${param.moduleId}'/>";
	//ģ������
	var moduleName = decodeURIComponent(decodeURIComponent("<c:out value='${param.moduleName}'/>"));
	//����ID
	var backId = "<c:out value='${param.backId}'/>";
	//���ڵ�ID
	var parentModuleId = "<c:out value='${param.parentModuleId}'/>";
	//���ڵ�����
	var parentModuleName = decodeURIComponent(decodeURIComponent("<c:out value='${param.parentModuleName}'/>"));
	//���ڵ�����
	var parentModuleType = "<c:out value='${param.parentModuleType}'/>";
	
	//�ڵ�״̬
	var nodeStatus = 0;
	var nodePermission = 0;
	
	//�Ƿ�����������
	var isUsing = true;
	
	var funcData = {}; 
	
	//��ȡӦ�÷�����Ϣ
	function ajaxData(obj){
		dwr.TOPEngine.setAsync(false);
		FuncAction.getFuncTagList(function(data){
			obj.setDatasource(data);
		});
	}
	
	$(document).ready(function (){
		if(actionType == 'add'){
			//����Ҫ��ʼ����������
			cui('#new_same').hide();
			cui('#new_sub').hide();
			cui('#delBtn').hide();
			cui('#button_right').hide();
			funcData["parentFuncId"]= parentModuleId;
			funcData["parentFuncType"] = "MODULE";
			funcData["funcNodeType"] = 3;
			funcData["permissionType"] = 2;
			funcData["parentFuncName"] = parentModuleName;
			funcData["status"] = 1;
		}else{
			cui('#back_to').hide();	
			
			dwr.TOPEngine.setAsync(false);
			FuncAction.readFuncByModuleId(moduleId, function(data){
				funcData = data;
				funcData.parentFuncName = parentModuleName;
				//�õ�Ӧ�ýڵ�״̬����Ȩ״̬
				nodeStatus = data.status;
				if(nodeStatus == 2){
					//�����ǰ�ڵ�״̬�ǽ��ã������ж��丸�ڵ�Ӧ��״̬�Ƿ�Ϊ����
					FuncAction.readFuncByModuleId(parentModuleId, function(data1){
						if(data1 != null && data1.status == 2){
							//��ʾ��ǰ�ڵ�ĸ��ڵ�Ҳ��һ�����õ�Ӧ�ã��˴���Ӧ������Ӧ��״̬���Ա������
							isUsing = false;
						}
					});
				}
				//funcData.funcTag = convertTagToArray(funcData.funcTag);
				nodePermission = data.permissionType;
				//��Ӧ�ò���Ҫ��Ȩ����������Ȩ��Ϣ��ť
				if(nodePermission != 2){
					cui('#button_right').hide();
				}
			});		
			dwr.TOPEngine.setAsync(true);		 
		}
		comtop.UI.scan();
		cui("#parentFuncName").setReadonly(true);
		if(actionType == 'edit'){
			cui("#funcCode").setReadonly(true);
		}
		init();
	});
	
	function convertTagToArray(tagContent){
		if(tagContent){
			var tags = tagContent.split(',');
			return tags;
		}
		return [];
	}
	
	//�����¼�
 	var insertSub = {
    	datasource: [
            {id:'insertSubApplication',label:'�����¼�Ӧ��'}
        ],
        on_click:function(obj){
        	if(obj.id=='insertSubApplication'){
        		insertSubAppliation();
        	}
        }
    };
	
 	//����ͬ��
 	var insertSame = {
    	datasource: [
  	            {id:'insertSameSys',label:'����ͬ��ϵͳ'},
  	            {id:'insertSameDirectory',label:'����ͬ��Ŀ¼'},
  	            {id:'insertSameApplication',label:'����ͬ��Ӧ��'},
  	        ],
  	        on_click:function(obj){
  	        	if(obj.id=='insertSameSys'){
  	        		insertSameSysOrDirectory(1);
  	        	}else if(obj.id=='insertSameDirectory'){
  	        		insertSameSysOrDirectory(3);
  	        	}else if(obj.id=='insertSameApplication'){
  	        		insertSameSysOrDirectory(2);
 	        	}
  	        }
    };
 	
 	/**
 	*  ����
	*/
	function backTo(){
		//�ж�������ṹ�Ƿ��Ѿ����б�չʾ��
		if($('#moduleTree',window.parent.document).is(":hidden")){
			window.parent.clickRecord(backId, '');
		}else{
			window.parent.nodeUrl(backId);
		}
	}
 	//�����¼�Ӧ��
 	function insertSubAppliation(){
 		var moduleName = funcData.funcName;
 		var url = "${cuiWebRoot}/top/sys/menu/FuncEdit.jsp?actionType=add&backId="+moduleId+"&parentModuleId="+moduleId+"&parentModuleName="+encodeURIComponent(encodeURIComponent(moduleName));
 		window.location.href = url;
 	}

	//����ͬ��
	function insertSameSysOrDirectory(nodeType){
		cui('#button_right').hide();
		var url = "";
		//����ͬ��Ӧ��
		if(nodeType == 2){
			url = "${cuiWebRoot}/top/sys/menu/FuncEdit.jsp?actionType=add&backId="+moduleId+"&parentModuleId="+parentModuleId+"&parentModuleName="+encodeURIComponent(encodeURIComponent(parentModuleName));
		}else{
			url = "${cuiWebRoot}/top/sys/module/ModuleEdit.jsp?actionType=add&moduleType="+nodeType+"&parentId="+parentModuleId+"&parentName="+encodeURIComponent(encodeURIComponent(parentModuleName))+"&moduleId="+moduleId+"&parentModuleType="+parentModuleType;
		}
		window.location.href = url;
	}
	
	//��ʼ��Ӧ����Դ�б�����
	function init(){
		if(actionType == 'add'){
			cui('#centerMain').hide();
			cui('#updBtn').hide();
		}else{
			comtop.UI.scan.setReadonly(true);	
			//�����ǰ�ڵ�״̬Ϊ����ʱ��Ĭ�����ص����е�������ť
			if(nodeStatus == 2){
				cui('#new_same').hide();
				cui('#new_sub').hide();
			}
			//���� *��
			cui('.top_required').hide();
			$('#pageTittle').html("Ӧ�û�����Ϣ");
			$('#applyRemarkLengthFont').hide();
			cui('#saveBtn').hide();
			//������ڵ���Ӧ�ã��¼�ֻ�ܽ�Ӧ��
			if(parentModuleType == 2){
				cui('#new_same').getMenu().disable("insertSameSys",true);
				cui('#new_same').getMenu().disable("insertSameDirectory",true);
			}else if(parentModuleType == 3){
				//������ڵ���Ŀ¼��������ֻ�ܽ�Ŀ¼��Ӧ��
				cui('#new_same').getMenu().disable("insertSameSys",true);
			}
			//չʾ�����б�
			cui('#body').setContentURL("center",'${cuiWebRoot}/top/sys/menu/FuncList.jsp?parentResourceId='+funcData.funcId+"&parentResourceType=FUNC&parentName="+encodeURIComponent(encodeURIComponent(moduleName))+"&permissionType="+funcData.permissionType);
		}
	}
	
	//�༭
	function updateFunc(){
		comtop.UI.scan.setReadonly(false);		
		cui('.top_required').show();
		cui('#funcCode').setReadonly(true);
		cui('#parentFuncName').setReadonly(true);
		if(isUsing == false){
			//�༭״̬Ӧ��״̬����Ϊ����ѡ
			cui('#status').setReadonly(true);
		}
		$('#applyRemarkLengthFont').show();
		$('#pageTittle').html("�༭Ӧ����Ϣ");
		cui('#saveBtn').show();
		cui('#updBtn').hide();
		cui('#button_right').hide();
	}
	
	//ɾ��
	function delFunc(){
		var isHasChildren = "false";
		var deleteMessage = "";
		//�жϸ�Ӧ�����Ƿ����¼�Ӧ�ã�����У�������ɾ����
		dwr.TOPEngine.setAsync(false);
		ModuleAction.hasSubModule(moduleId,function(data){
			isHasChildren = data.isDelete;
			deleteMessage = data.deleteMessage;
		});
		dwr.TOPEngine.setAsync(true);
		if(isHasChildren=="true"&&deleteMessage!=""&&deleteMessage!=null){
			cui.warn("�޷�ɾ����Ӧ��ģ�飬��Ӧ��ģ���´�����"+deleteMessage);
			return false;	
		}
		if(isHasChildren=="true"){
			cui.warn("�޷�ɾ����Ӧ�ã���Ӧ���´�����Ӧ�á�");
			return false;	
		}
		//�ж�Ӧ���¼���û�в˵�ҳ����Դ������У�������ɾ�� 
		var selectData = [];
		selectData.push(funcData.funcId);
		dwr.TOPEngine.setAsync(false);
		FuncAction.getNoDelFuncId(selectData, function(data){
			if(data == null || data.length == 0){
				var msg = "ȷ��Ҫɾ����ǰӦ����";
				cui.confirm(msg, {
			        onYes: function () {
			        	var funcDTO = {};
						funcDTO.parentFuncId = moduleId;
						funcDTO.funcId = funcData.funcId;
						FuncAction.deleteFuncVOInModule(funcDTO, function(data){
							window.parent.cui.message('Ӧ��ɾ���ɹ���',"success");
							cui('#button_right').hide();
							delRefresh(moduleId,parentModuleId);
						});
			        }
				});
				
			}else{
				cui.warn("�޷�ɾ����Ӧ��ģ�飬��Ӧ��ģ���´�����Դ���ݡ�");	
			}
		});
		dwr.TOPEngine.setAsync(true);
		
	}
	
	// ɾ��������ˢ���� 
	function delRefresh(moduleId,parentModuleId){
		var treeObject = parent.cui("#moduleTree");
		var pNode = treeObject.getNode(parentModuleId);
		var selectNode = treeObject.getNode(moduleId);
		//����listboxչʾ���Խṹ����λ��ɾ���ڵ㸸�ڵ�   
		showTree();
		if(selectNode && selectNode.dNode) {
			pNode.activate(true);
			pNode.getData().isLazy = false;
			// ɾ���ڵ�
			selectNode.remove();
		}
		var isHasChildren = false;
		dwr.TOPEngine.setAsync(false);
		ModuleAction.hasSubModule(parentModuleId,function(data){
			isHasChildren = data;
		});
		dwr.TOPEngine.setAsync(true);
		if(!isHasChildren) {
			pNode.getData().isFolder = false;
		} 
		parent.nodeUrl(parentModuleId);
	}
	
	//����Ӧ��
	function saveFunc(){
		var map = window.validater.validAllElement();
        var inValid = map[0];
        var valid = map[1];
       	//��֤��Ϣ
		if(inValid.length > 0){//��֤ʧ��
			var str = "";
		   	for (var i = 0; i < inValid.length; i++) {
				str += inValid[i].message + "<br />";
			}
		}else{ 
			var vo = cui(funcData).databind().getValue();
			//ת��tag
			//vo.funcTag = convertTags(vo.funcTag);
			if(actionType == 'add'){
				dwr.TOPEngine.setAsync(false);
				//����Ӧ����Ϣ
				FuncAction.saveFuncVOInModule(vo, function(data){
					if(data) {
						//����listboxչʾ���Խṹ����λ�������ڵ�  
						showTree();
						//ˢ����
						window.parent.cui.message('Ӧ�������ɹ���',"success");
						parent.addRefreshTree(data, parentModuleId);
					}else{
						window.parent.cui.message("Ӧ������ʧ�ܡ�", "error");
					} 
				});
				dwr.TOPEngine.setAsync(true);
			}else{
				//�����ӽڵ�״̬
				if(nodeStatus != vo.status){
					dwr.TOPEngine.setAsync(false);
					var isEnableDis = false;
					FuncAction.isHasNormalFunc(moduleId, function(data){
						isEnableDis = data;
					});
					dwr.TOPEngine.setAsync(true);
					if(isEnableDis){
						cui.warn("�޷����ø�Ӧ��ģ�飬��Ӧ��ģ���´������õ���Ӧ��ģ�顣");
						return false;	
					}
					vo.cascadeForbidden = 1;
				}
				if(vo.cascadeForbidden == 1 && vo.status == 2){
					var msg = "ȷ��Ҫ���õ�ǰӦ����";
					cui.confirm(msg, {
				        onYes: function () {
				        	updateFuncData(vo);
				        }
					});
				}else{
					updateFuncData(vo);
				}
			}
		}
	}
	
	function convertTags(tags){
		var tag = "";
		if(tags && tags.length > 0){
			for(var i = 0;i<tags.length;i++){
				if(i > 0){
					tag = tag + ',';
				}
				tag = tag + tags[i];
			}
		}
		return tag;
	}
	
	function updateFuncData(vo){
		if(nodePermission != vo.permissionType){
			if(vo.permissionType == 1){
				//�ڵ���Ȩ״̬�ӡ��ǡ���Ϊ���񡰣���Ҫɾ���ڵ���Ȩ����
				vo.cascadeOpen = 2;
			}
		}
		dwr.TOPEngine.setAsync(false);
		moduleName = vo.funcName;
		//�޸�Ӧ����Ϣ
		FuncAction.updateFuncVOInModule(vo, function(data){
			//����listboxչʾ���Խṹ����λ�������ڵ�  
			nodeStatus = vo.status;
			nodePermission = vo.permissionType;
			showTree();
			window.parent.cui.message('Ӧ���޸ĳɹ���',"success");
			parent.editRefreshTree(moduleId, parentModuleId,moduleName);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//���νṹչʾ
	function showTree() {
		parent.cui('#keyword').setValue('');
		parent.$('#fastQueryList').hide();
		parent.$('#moduleTree').show();
		parent.addType = '';
	}
	
	//�ж������Ƿ�����淶
	function checkName(data){
		var reg = new RegExp("^[\uff08 \uff09 \u0028 \u0029 \u4E00-\u9FA5A-Za-z0-9_/\(��\)��]+$");
		return (reg.test(data));
	}
	
	//�ж������Ƿ��ظ�
	function isExistRename(data){
		if(data){
			var flag = true;
			dwr.TOPEngine.setAsync(false);
			var conditionVO = {parentModuleId:parentModuleId, moduleName:data, moduleId:moduleId};
			ModuleAction.isModuleNameExist(conditionVO, function(data){
				if(data){
					flag = false;
				}else{
					flag = true;
				}
			});	
			dwr.TOPEngine.setAsync(true);
			return flag;
		}
	}
	
	//ֻ��Ϊ Ӣ�ġ����֡��»���
	function checkCode(data) {
		if(data){
			var reg = new RegExp("^[A-Za-z0-9_]+$");
			return (reg.test(data));
		}
		return true;
	}
	
	/**
	* ������ȫ���Ƿ�Ψһ
	**/
	function isExistCode(data){
		var flag = true;
		if(actionType != 'add' || $.trim(data) == ''){//ֻ��������ҪУ��
			return flag;
		}else{
			dwr.TOPEngine.setAsync(false);
			//������Ҫ��֤ȫ��Ψһ,�˴��ж�ģ���Ƿ�Ψһ
			var conditionVO = {parentModuleId:parentModuleId, moduleCode:data, moduleId:moduleId};
			ModuleAction.isModuleCodeExist(conditionVO, function(data){
				if(data){
					flag = false; //�����ظ��ı���	
				}else{
					flag = true;
				}
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	 	}
	}
	
	//���ӵ�ַ������������
	function checkURL(data){
		 var flag = true;
		 var patrn = /[\u4E00-\u9FA5]/i;
		 if(data&&patrn.test(data)){
			flag = false;
		 }
		 return flag;
	}
	
	//��ʾ�˵��Ľ�ɫ�͸�λ����
	function rightRecommend(){
		var url = '${pageScope.cuiWebRoot}/top/sys/menu/RoleList.jsp?actionType=edit&funcId='+funcData.funcId;
		var title = funcData.funcName ;
		cui.extend.emDialog({
			id: 'roleDialog',
			title : title,
			src : url,
			width : 750,
			height : 390
	    }, window.parent.parent).show(url);
		
	}
</script>
</body>
</html>
