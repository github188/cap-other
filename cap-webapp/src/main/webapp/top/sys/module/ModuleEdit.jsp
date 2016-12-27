<%
  /**********************************************************************
	* ģ�����
	* 2013-2-25 ��־ΰ  �ع�
	* 2013-3-12 �� cui�ع�
	* 2013-3-27 ��С��CUI�ع�
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
	<title>Ŀ¼����༭ҳ��</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.editor.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/engine.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body>
<div uitype="Borderlayout"  id="body" is_root="true">	
	<div class="top_header_wrap" style="padding-top:15px;padding-right:15px;">
		<div class="thw_title">
			<font id = "pageTittle" class="fontTitle"></font> 
		</div>
		<div class="thw_operate">
		<% if(!isHideSystemBtn){ %>
		<span uitype="button" id="new_same" label="����ͬ��"  menu="insertSame" ></span>
		<span uitype="button" id="new_sub" label="�����¼�"  menu="insertSub"></span>
		<span uitype="button" label="�༭" id="updBtn" on_click="updateFunc"></span>
		<span uitype="button" id="save" label="����"  on_click="save" ></span>
		<span uitype="button" id="delete" label="ɾ��"  on_click="canDeleteModuleVO" ></span>
		<span uitype="button" id="back_to" label="����"  on_click="backTo" ></span>
		<% } %>
		</div>
		
	</div>
	<div class="cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr style = "display:none">
				<td class="td_label" width="25%">���� ��<span style="color: red">*</span></td>
				<td>
					<span id="moduleTypeGroup" uitype="RadioGroup" name="moduleType" databind="data.moduleType"
			      readonly="true">
		        <input type="radio" name="moduleType" value="1" />
		                         ϵͳ
		        <input type="radio" name="moduleType" value="3" />
		                      Ŀ¼ </span>
				</td>
				
			</tr>
			<tr>
				<td class="td_label">�ϼ����ƣ�</td>
				<td>
				<span uitype="input" name="parentName" id="parentName" databind="data.parentName" width="440px" readonly="true"></span>
				<span uitype="input" id="parentModuleId" name="parentModuleId" databind="data.parentModuleId" readonly="true"></span>	
				</td>
			</tr>
	        <tr>
	            <td class="td_label"> <span id="requiredName" class="top_required">*</span> ���ƣ�</td>
	            <td>
	               <span uitype="input" id="moduleName" name="moduleName" databind="data.moduleName" maxlength="36" width="440px"
	                validate="validateModuleName">
	                </span>
	            </td>
	        	
	        </tr>
	        <tr>
	        	<td class="td_label"><span id="requiredModuleCode" class="top_required">*</span> ���룺 </td>
				<td>
					<span uitype="input" id="moduleCode" name="moduleCode" databind="data.moduleCode" maxlength="28" width="440px"
	               validate="validateModuleCode" readonly="true"></span>
				</td>
	        </tr>
	        
			<tr> 
				<td class="td_label" valign="top">������
				</td>
				<td>
				<div style="width:440px;">
					<span uitype="textarea" id="description" name="description" width="428px" databind="data.description" 
						 maxlength="500" relation="remarkLength" ></span>
					<div style="float:right">
						<font id="applyRemarkLengthFont" >(����������<label id="remarkLength" style="color:red;"></label>&nbsp; �ַ�)</font>
					</div>
				</div>
				</td>
			</tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	var inputModuleId = "<c:out value='${param.moduleId}'/>";//�����Ŀ¼ID
	var parentModuleId = "<c:out value='${param.parentId}'/>";
	var parentName = "<c:out value='${param.parentName}'/>";
	var moduleTypeVal = "<c:out value='${param.moduleType}'/>";
	var parentModuleType = "<c:out value='${param.parentModuleType}'/>";
	var actionType = "<c:out value='${param.actionType}'/>";
	if(parentName=="undefined"||parentName==null||parentName=="null"){
		parentName="";
	}else{
		parentName = decodeURIComponent(decodeURIComponent(parentName));
	}
	var addType = "<c:out value='${param.addType}'/>";
	var databindIns;//���ݰ�ʵ�� 
	var insertFlag = 2;//����ʱ��Ҫ�ж����������滹�Ǹ��±���,1��ʾ������2��ʾ���� 
	var isRootNodeAdd = "<c:out value='${param.isRootNodeAdd}'/>";
	var parentModuleIdVal = "";
	var parentModuleNameVal = "";
	
	$(document).ready(function(){
		//��ʼ���༭������
		if(actionType =="add"){
			comtop.UI.scan(); 
			insertFlag = 1;//��ʾ����
			//��ť���� 
			cui('#new_same').hide();
			cui('#new_sub').hide();
			cui('#delete').hide();
			cui('#back_to').show();
			cui('#parentModuleId').hide();
			cui('#save').show();
		   	cui('#updBtn').hide();
			getModuleTypeFlag(parentModuleId,moduleTypeVal);
			cui('#parentModuleId').setValue(parentModuleId);
			cui('#parentName').setValue(parentName);
			cui('#moduleCode').setReadonly(false);//���ñ����ֶ�Ϊ�ɱ༭
		}else{
			dwr.TOPEngine.setAsync(false);
			ModuleAction.getModuleInfo(inputModuleId,function(moduleData){
				data = moduleData;//����ID���Ŀ¼������Ϣ
				comtop.UI.scan();   //ɨ��
			});
			dwr.TOPEngine.setAsync(true);
			if(data.length != 0&&typeof(data.length)!="undefined") {
				parentModuleId = data.parentModuleId;
			};
		   comtop.UI.scan.setReadonly(true);	
		   
		   $('#applyRemarkLengthFont').hide();
		   cui('#parentModuleId').hide();		
		   cui('#back_to').hide();	
		   cui('#parentName').setValue(parentName);
		   cui('#save').hide();
		   cui('#updBtn').show();
		   cui('#requiredName').hide();
		   cui('#requiredModuleCode').hide();
	    }
		if(data.parentModuleId == '-1'){// ����Ǹ��ڵ�
			cui('#parentName').setValue("");
			cui('#new_same').hide();
			cui('#delete').hide();
		}
		if(isRootNodeAdd == "true") {
			cui('#new_same').hide();
			cui('#new_sub').hide();
			cui('#delete').hide();
			cui('#back_to').hide();
			cui('#moduleCode').setReadonly(false);//���ñ����ֶ�Ϊ�ɱ༭
			cui('#moduleTypeGroup').radioGroup().setValue("1");
			cui('#centerMain').hide();
		}
		//���ñ���
		if(moduleTypeVal==1){
			$('#pageTittle').html("ϵͳ������Ϣ");  
		}else if(moduleTypeVal == 3){
			$('#pageTittle').html("Ŀ¼������Ϣ");  
		} 
		//���Ʋ˵���ť�Ŀ�����
		checkButton();
	});
	
	//�༭
	function updateFunc(){
		initEditPage(moduleTypeVal);
	}
	
	function initEditPage(nodeType){
		comtop.UI.scan.setReadonly(false);		
		cui('#moduleCode').setReadonly(true);
		cui('#parentName').setReadonly(true);
		cui('#requiredName').show();
		cui('#requiredModuleCode').show();
		$('#applyRemarkLengthFont').show();
		//���ñ���
		if(nodeType==1){
			$('#pageTittle').html("�༭ϵͳ��Ϣ");  
		}else if(nodeType == 3){
			$('#pageTittle').html("�༭Ŀ¼��Ϣ");  
		} 
		cui('#save').show();
		cui('#updBtn').hide();
	}
	
	//���Ʋ˵���ť�Ŀ�����
	function checkButton(){
		if(moduleTypeVal==2){
			 cui('#new_sub').getMenu().disable("insertSubSys",true);	
			 cui('#new_sub').getMenu().disable("insertSubDirectory",true);	
		}else if(moduleTypeVal==3){
			 cui('#new_sub').getMenu().disable("insertSubSys",true);	
			 if(parentModuleType ==3){
				 cui('#new_same').getMenu().disable("insertSameSys",true);	 
			 }
		}
	}
	
	//�����¼�
	function insertSubSysOrDirectory(nodeType){
		initEditPage(nodeType);
		insertFlag = 1;//��ʾ����
		//��ť���� 
		cui('#new_same').hide();
		cui('#new_sub').hide();
		cui('#delete').hide();
		cui('#back_to').show();
		//�ֶδ���
		var moduleNameVal = cui('#moduleName').getValue();
		cui(data).databind().setEmpty();
		cui('#parentName').setValue(moduleNameVal);//�����ϼ������ֶ�
		cui('#parentModuleId').setValue(inputModuleId);
		getModuleTypeFlag(inputModuleId,nodeType);
		cui('#moduleCode').setReadonly(false);//���ñ����ֶ�Ϊ�ɱ༭
	}
	
	//�����¼�Ӧ��
	function insertSubApplication(){
		var moduleNameVal = cui('#moduleName').getValue();
		window.parent.cui('#body').setContentURL("center","${cuiWebRoot}/top/sys/menu/FuncEdit.jsp?actionType=add&backId="
				+inputModuleId+"&parentModuleId="+inputModuleId+"&parentModuleName="+encodeURIComponent(encodeURIComponent(moduleNameVal))+"&addType"+addType); 
	}

	//����ͬ��
	function insertSameSysOrDirectory(nodeType){
		initEditPage(nodeType);
		insertFlag = 1;//��ʾ����
		//��ť���� 
		cui('#new_same').hide();
		cui('#new_sub').hide();
		cui('#delete').hide();
		cui('#back_to').show();
		//�ֶδ���
		cui(data).databind().setEmpty();
		getModuleTypeFlag(parentModuleId,nodeType);
		cui('#parentModuleId').setValue(parentModuleId);
		cui('#parentName').setValue(parentName);
		cui('#moduleCode').setReadonly(false);//���ñ����ֶ�Ϊ�ɱ༭
	}
	
	//����ͬ��Ӧ��
	function insertSameApplication(){
		window.parent.cui('#body').setContentURL("center","${cuiWebRoot}/top/sys/menu/FuncEdit.jsp?actionType=add&backId="
				+inputModuleId+"&parentModuleId="+parentModuleId+"&parentModuleName="+encodeURIComponent(encodeURIComponent(parentName))+"&addType"+addType); 
	}
	
	/**
 	*  ����
	*/
	function backTo(){
		//�ж�������ṹ�Ƿ��Ѿ����б�չʾ��
		if($('#moduleTree',window.parent.document).is(":hidden")){
			window.parent.clickRecord(inputModuleId, '');
		}else{
			window.parent.nodeUrl(inputModuleId);	
		}
	}

	//����ͬ�����¼�ʱ�ж��ܷ�����ϵͳ
	function getModuleTypeFlag(parentModuleId,nodeType){
		cui('#moduleTypeGroup').radioGroup().setValue(nodeType);
		cui('#moduleTypeGroup').radioGroup().setReadonly(true);
	}

	//�����볤��
	function checkLength() {
		var moduleIdLength = cui('#moduleId').getValue().length;
		if(moduleIdLength > 50) {
			return false;
		}
		return true;
	}

	//������ڵ㷽��
	function saveRootNode(moduleVO) {
		moduleVO.parentModuleId = "-1";
		moduleVO.moduleType = cui('#moduleTypeGroup').radioGroup().getValue();
		dwr.TOPEngine.setAsync(false);
		ModuleAction.insertModuleVO(moduleVO,function(data){
			if(data && data.moduleId) {
				//���³�ʼ���� 
				window.parent.cui.message("�����ɹ���", "success");
				window.parent.location.reload();
			}else{
				window.parent.cui.message("����ʧ�ܡ�", "error");
			}
		});
		dwr.TOPEngine.setAsync(true);	
	}

	//���淽��
	function save(){
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
			//��֤ȫ�ֱ���Ψһ�� 
			var moduleVO = cui(data).databind().getValue();
			moduleVO.moduleType =  cui('#moduleTypeGroup').radioGroup().getValue();
			var strModuleType = moduleVO.moduleType;
			if(isRootNodeAdd == "true"){
				saveRootNode(moduleVO);
				return false;
			}
			if(insertFlag == 1){//���� 
				dwr.TOPEngine.setAsync(false);
				ModuleAction.insertModuleVO(moduleVO,function(data){
					if(data && data.moduleId) {
						//����listboxչʾ���Խṹ����λ�������ڵ�  
						showTree();
						//ˢ����
						parent.addRefreshTree(data.moduleId,data.parentModuleId);
						if(strModuleType==1){
							window.parent.cui.message('ϵͳ�����ɹ���',"success");
						}else if(strModuleType ==3){
							window.parent.cui.message('Ŀ¼�����ɹ���',"success");
						}
					}else{
						if(strModuleType==1){
							window.parent.cui.message('ϵͳ����ʧ�ܡ�',"error");
						}else if(strModuleType ==3){
							window.parent.cui.message('Ŀ¼����ʧ�ܡ�',"error");
						}
					}
				});
				dwr.TOPEngine.setAsync(true);	
			}else{//����
				dwr.TOPEngine.setAsync(false);
				ModuleAction.updateModuleVO(moduleVO,function(data){
					if(data && data.moduleId){
						//����listboxչʾ���Խṹ����λ�������ڵ�  
						showTree();
						parent.editRefreshTree(data.moduleId,data.parentModuleId,data.moduleName);
						if(strModuleType==1){
							window.parent.cui.message('ϵͳ�޸ĳɹ���',"success");
						}else if(strModuleType ==3){
							window.parent.cui.message('Ŀ¼�޸ĳɹ���',"success");
						}
					}else{
						if(strModuleType==1){
							window.parent.cui.message('ϵͳ�޸�ʧ�ܡ�',"error");
						}else if(strModuleType ==3){
							window.parent.cui.message('Ŀ¼�޸�ʧ�ܡ�',"error");
						}
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
		}
	}

	//���νṹչʾ
	function showTree() {
		parent.cui('#keyword').setValue('');
		parent.$('#fastQueryList').hide();
		parent.$('#moduleTree').show();
		parent.addType = '';
	}

	//ֻ��Ϊ Ӣ�ġ����֡��»���
	function checkModuleCode(data) {
		if(data){
			var reg = new RegExp("^[A-Za-z0-9_]+$");
			return (reg.test(data));
		}
		return true;
	}
	
	/**     
	 * ֻ��Ϊ���֡����֡���ĸ���»���
	 */     
	function checkName(data) {  
		var flag = true;
		if(data == null || data == ''){
			return flag;
		}
		var patrn = /^[\uff08 \uff09 \u0028 \u0029\u4E00-\u9FA5A-Za-z0-9_/\(��\)��]+$/; 
		if (!patrn.exec(data)) flag= false;
		return flag;
	}

	/**
	* function:���ϵͳĿ¼�����Ƿ�Ψһ
	*/
	function checkNameUnique(data){
		var flag = true;
		var moduleVO = {moduleName:data,parentModuleId:parentModuleId,moduleId:inputModuleId};
		if(insertFlag == 1) {
			moduleVO.parentModuleId = cui("#parentModuleId").getValue();
			moduleVO.moduleId = '';
		}
		if(data!=""){
			dwr.TOPEngine.setAsync(false);
			ModuleAction.isModuleNameExist(moduleVO,function(result){
				if(result){
					flag = false;
				}else{
					flag = true;
				}			
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}

	/**
	* function:�������Ƿ�Ψһ
	*/
	function checkCodeUnique(data){
		var flag = true;
		if(insertFlag == 2) {
			return flag;
		}
		var moduleDTO = {moduleCode:data,parentModuleId:parentModuleId};
		if(insertFlag == 1) {
			moduleDTO.parentModuleId = cui("#parentModuleId").getValue();
		}
		dwr.TOPEngine.setAsync(false);
		if(data != ""){
			ModuleAction.isModuleCodeExist(moduleDTO,function(result){
				if(result){
					flag = false;
				}else{
					flag = true;
				}
			});
		}
		dwr.TOPEngine.setAsync(true);
		return flag;
	}

	// ɾ��ϵͳ����Ŀ¼
	function canDeleteModuleVO(){
		var vo = {moduleId:inputModuleId,parentModuleId:parentModuleId};
		var moduleVO = cui(data).databind().getValue();
		var strModuleType = moduleVO.moduleType;
		var isHasChildren = "false";
		var deleteMessage = "";
		dwr.TOPEngine.setAsync(false);
		ModuleAction.hasSubModule(inputModuleId,function(data){
			isHasChildren = data.isDelete;
			deleteMessage = data.deleteMessage;
			
		});
		dwr.TOPEngine.setAsync(true);
		if(moduleVO.moduleType == 3&&isHasChildren =="true"&&deleteMessage!=""&&deleteMessage!=null){
			cui.warn("�޷�ɾ����Ŀ¼����Ŀ¼�´�����"+deleteMessage);
			return false;
		}
		if(moduleVO.moduleType == 2&&isHasChildren =="true"&&deleteMessage!=""&&deleteMessage!=null){
			cui.warn("�޷�ɾ����Ӧ�ã���Ӧ���´�����"+deleteMessage);
			return false;
		}
		
		if(moduleVO.moduleType == 1&&isHasChildren =="true"&&deleteMessage!=""&&deleteMessage!=null){
			cui.warn("�޷�ɾ����ϵͳ����ϵͳ�´�����"+deleteMessage);
			return false;
		}
		if(isHasChildren =="true"&& moduleVO.moduleType == 3) {
			cui.warn("�޷�ɾ����Ŀ¼����Ŀ¼�´�����Ŀ¼����Ӧ��");
			return false;
		}
		if(isHasChildren =="true"&& moduleVO.moduleType == 2) {
			cui.warn("�޷�ɾ����Ӧ�ã���Ӧ���´�����Ӧ�á�");
			return false;
		}
		if(isHasChildren =="true"&& moduleVO.moduleType == 1) {
			cui.warn("�޷�ɾ����ϵͳ����ϵͳ�´�����ϵͳ����Ŀ¼����Ӧ�á�");
			return false;
		}

		cui.confirm("ȷ��Ҫɾ������������",{
			onYes: function(){
				dwr.TOPEngine.setAsync(false);
				ModuleAction.deleteModuleVO(vo,function(){
					if(strModuleType==1){
						window.parent.cui.message('ϵͳɾ���ɹ���',"success");
					}else if(strModuleType ==3){
						window.parent.cui.message('Ŀ¼ɾ���ɹ���',"success");
					}
				});
				dwr.TOPEngine.setAsync(true);
				delRefresh(inputModuleId,parentModuleId);
			}
		}); 
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
		var isHasChildren = "false";
		dwr.TOPEngine.setAsync(false);
		ModuleAction.hasSubModule(parentModuleId,function(data){
			isHasChildren = data;
		});
		dwr.TOPEngine.setAsync(true);
		if(isHasChildren.isDelete == "false") {
			pNode.setData("isFolder",false);
		} 
		parent.nodeUrl(parentModuleId);
	}

	//ϵͳĿ¼���ƺͱ���ļ��
	var validateModuleName = [
	      {'type':'required','rule':{'m':'���Ʋ���Ϊ�ա�'}},
	      {'type':'custom','rule':{'against':checkName, 'm':'����ֻ��Ϊ���֡����֡���ĸ���»��ߡ���б�ܡ���Ӣ�����š�'}},
	      {'type':'custom','rule':{'against':checkNameUnique, 'm':'���Ʋ����ظ���'}}
	    ],
	    validateModuleCode = [
	      {'type':'required','rule':{'m':'���벻��Ϊ�ա�'}},
	      {'type':'custom','rule':{'against':checkModuleCode, 'm':'����ֻ��Ϊ���֡���ĸ���»��ߡ�'}},
	      {'type':'custom','rule':{'against':checkCodeUnique, 'm':'���벻���ظ���'}}
	    ],
	    data={};
	
	//�����¼�
 	var insertSub = {
 	    	datasource: [
 	            {id:'insertSubSys',label:'�����¼�ϵͳ'},
 	            {id:'insertSubDirectory',label:'�����¼�Ŀ¼'},
 	            {id:'insertSubApplication',label:'�����¼�Ӧ��'},
 	        ],
 	        on_click:function(obj){
 	        	if(obj.id=='insertSubSys'){
 	        		insertSubSysOrDirectory(1);
 	        	}else if(obj.id=='insertSubDirectory'){
 	        		insertSubSysOrDirectory(3);
 	        	}else if(obj.id=='insertSubApplication'){
 	        		insertSubApplication();
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
 	     	        		insertSameApplication();
 	    	        	}
 	     	        }
 	     	    };
	
	</script>
</body>
</html>