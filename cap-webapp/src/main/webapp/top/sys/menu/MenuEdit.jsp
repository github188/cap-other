<%
/**********************************************************************
* �˵�����ҳ��:�˵��༭ҳ
* 2014-7-4 ʯ�� �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<html>
<head>
<title>�˵��༭ҳ</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FuncAction.js"></script>
<style type="text/css">
 .imgMiddle {line-height:350px;text-align:center;}
</style> 
</head>
<body onload="window.status='Finished';">
		<div class="top_header_wrap">
			<div class="thw_title" style="font-size:14px">
				<font id = "pageTittle" class="fontTitle"></font> 
			</div>
			<div class="thw_operate">
				<% if(!isHideSystemBtn){ %>
					<span uitype="button" label="����" id="saveBtn" on_click="saveFunc"></span>
				<% } %>
				<span uitype="button" label="�ر�" id="closeBtn" on_click="closeWindow"></span>
			</div>
		</div>
		<div>
				<table class="form_table">
						<tr>
							<td class="td_label" width="15%"><span class="top_required">*</span><span id="nodeNameText"></span>���ƣ�</td>
							<td class="td_content" width="20%" >
								<span uitype="input" id="funcName" name="funcName" databind="funcData.funcName"  width="200" maxlength="40"
									validate="[{'type':'required','rule':{'m':'���������ơ�'}}, {'type':'custom','rule':{'against':'checkName','m':'����ֻ��Ϊ���֡����֡���ĸ���»��ߡ���б�ܡ���Ӣ�����š�'}}, {'type':'custom','rule':{'against':'isExistRename','m':'�����ѱ�ռ�á�'}}]"
								></span>
							</td>
							<td class="td_label" width="10%">�ϼ����ƣ�</td>
							<td class="td_content" width="25%" >
								<span uitype="input" id="parentFuncName" name="parentFuncName" databind="funcData.parentFuncName" width="200" readonly="true"/>
							</td>
						</tr>
						<tr id="funcCodeTr">
							<td class="td_label" width="15%"><span id="nodeCodeText"></span>���룺</td>
							<td class="td_content" width="20%">
								<span uitype="input" id="funcCode" name="funcCode" databind="funcData.funcCode"  width="200" <c:choose><c:when test='${param.funcNodeType == 2 or param.funcNodeType == 4}'>maxlength="100"</c:when><c:otherwise>maxlength="40"</c:otherwise></c:choose>
									validate="[{'type':'custom','rule':{'against':'checkCode','m':'����ֻ��Ϊ���֡���ĸ���»��ߡ�'}}, {'type':'custom','rule':{'against':'isExistCode','m':'�����ѱ�ռ�á�'}}]"
								></span>
							</td>
							<td class="td_label" width="10%" id="permissionTd"> <span class="top_required">*</span>��Ҫ��Ȩ�� </td>
							<td class="td_content" width="25%">
								<span uitype="RadioGroup" name="permissionType" id="permissionType" value="2"  databind="funcData.permissionType" validate="��ѡ���Ƿ���Ҫ��Ȩ��"> 
									<input type="radio" name="permissionType" value="2"/>��
	                				<input type="radio" name="permissionType" value="1"/>��
								</span> 
							</td>
						</tr>
						<tr id="funcUrlTr">
							<td class="td_label"> <span id="funcUrlSpan" class="top_required" style="display:none">*</span> ���ӵ�ַ��</td>
							<td class="td_content" colspan="3">
								<span uitype="input" id="funcUrl" name="funcUrl"  databind="funcData.funcUrl"  maxlength="500"
									 validate="[{'type':'custom', 'rule':{'against':'checkURL', 'm':'���ӵ�ַ�����������ġ�'}}]"
									 width="492"></span>
							</td>
						</tr>
						<tr id="funcTagTr">
							<td class="td_label">�˵����ࣺ</td>
							<td class="td_content" colspan="3">
<!-- 								<span uitype="RadioGroup" name="funcTag" id="funcTag" value="1"  databind="funcData.funcTag" validate="��ѡ��˵����ࡣ">  -->
<!-- 									<input type="radio" name="funcTag" value="1"/>ҵ��˵� -->
<!-- 	                				<input type="radio" name="funcTag" value="2"/>��ѯ�˵� -->
<!-- 	                				<input type="radio" name="funcTag" value="3"/>ͳ�Ʋ˵� -->
<!-- 								</span> -->
								<span uitype="CheckboxGroup" name="funcTags" id="funcTags" value="['1']" databind="funcData.funcTags" validate="��ѡ��˵����ࡣ"> 
									<input type="checkbox" name="funcTags" value="1" text="ҵ��˵�" readonly="readonly"/>
	                				<input type="checkbox" name="funcTags" value="2" text="��ѯ�˵�"/>
	                				<input type="checkbox" name="funcTags" value="3" text="ͳ�Ʋ˵�"/>
								</span>
								
							</td>
						</tr>
						<tr>
							<td class="td_label">������
							</td>
							<td class="td_content" colspan="3">
								<div style="width:440px;">
									<span uitype="textarea" name="description" databind="funcData.description" 
										relation="remarkLength" maxlength="500" width="480px"></span>
									<div style="float:right">
										<font id="applyRemarkLengthFont" >(����������<label id="remarkLength" style="color:red;"></label>&nbsp; �ַ�)</font>
									</div>
								</div>
							</td>
						</tr>
				</table>
	</div>
<!-- js�ű� -->
<script type="text/javascript">
	//actionType
	var actionType = "<c:out value='${param.actionType}'/>";
	//��ø��ڵ�����
	var parentFuncType = "<c:out value='${param.parentFuncType}'/>";
	//��ǰ�ڵ�ID
	var funcId = "<c:out value='${param.funcId}'/>";
	//���ڵ�ID
	var parentFuncId = "<c:out value='${param.parentFuncId}'/>";
	//���ڵ�����
	var parentFuncName = decodeURIComponent(decodeURIComponent("<c:out value='${param.parentFuncName}'/>"));
	//��ǰ�ڵ����� 1Ŀ¼ 2�˵� 3Ӧ��
	var funcNodeType = "<c:out value='${param.funcNodeType}'/>";
	//���ڵ�Ȩ��״̬
	var parentPermission = "<c:out value='${param.parentPermissionType}'/>";
	//��ǰ�ڵ�Ȩ��״̬
	var nodePermission = 0;
	
	var funcData = {}; 
	var nodeTypeName = "Ŀ¼";
	var funcName = "";
	
	$(document).ready(function (){
		showField();
		if(actionType == "edit"){
			dwr.TOPEngine.setAsync(false);
			FuncAction.readFunc(funcId, function(data){
				funcData = data;
				funcName = funcData.funcName;
				nodePermission = funcData.permissionType;
			});		
			$("#pageTittle").html("�༭"+nodeTypeName);
			dwr.TOPEngine.setAsync(true);		
		}else {
			//����Ҫ��ʼ����������
			funcData["parentFuncId"]= parentFuncId;
			funcData["parentFuncType"] = parentFuncType;
			funcData["funcNodeType"] = funcNodeType;
			if(parentFuncName == ''){
				//���δ���ݸ��ڵ����ƣ��˴���Ҫͨ������ID��ȡ�����ڵ�������Ϣ�����ƺ���Ȩ״̬
				dwr.TOPEngine.setAsync(false);
				FuncAction.readFunc(parentFuncId, function(data){
					parentFuncName = data.funcName;
					parentPermission = data.permissionType;
				});		
				dwr.TOPEngine.setAsync(true);		
			}
			funcData["parentFuncName"]= parentFuncName; 
			//permissionTypeĬ��Ϊ������Ȩ
			if(funcNodeType == 5){
				funcData["permissionType"] = 2;
			}
			//funcData["funcTag"] = 1;
			funcData["status"] = 1;
			$("#pageTittle").html("����"+nodeTypeName);
		}
		comtop.UI.scan();
		if(funcNodeType != 2){
			window.validater.disValid('funcTags', true);
		}else{
			$('#funcUrlSpan').show();
			 window.validater.add('funcUrl', 'required', {
	                m:'���ӵ�ַ����Ϊ��'
	            });
		} 
		if(funcNodeType == 5){
			//�����ǰ�½������޸ĵ��ǲ������¼���������Ҫ��֤����Ȩ����Ȩ״̬��������ѡ��
			cui("#permissionType").setReadonly(true);
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
	
	//�ֶθ��ݲ�ͬ���ͽ���չʾ
	function showField(){
		if(funcNodeType == 1){
			nodeTypeName = "Ŀ¼";
			$('#funcCodeTr').hide();
			$('#funcUrlTr').hide();
			$('#funcTagTr').hide();
		}else if(funcNodeType == 2){
			nodeTypeName = "�˵�";
		}else if(funcNodeType == 4){
			nodeTypeName = "ҳ��";
			$('#deleteBtn').hide();
			$('#funcTagTr').hide();
		}else if(funcNodeType == 5){
			nodeTypeName = "����";
			$('#funcTagTr').hide();
		}
		$('#nodeNameText').html(nodeTypeName);
		$('#nodeCodeText').html(nodeTypeName);
	}

	function init(){
		if(actionType == "edit"){
			if($.trim(cui('#funcCode').getValue()) != ''){
				//Ȩ����ص��ֶ�Ҫ����Ϊֻ��
				cui("#funcCode").setReadonly(true);
			}
		}
	}
	
	//�رմ���
	function closeWindow(){
		window.parent.cuiEMDialog.dialogs['funcDialog'].hide();
	}
	
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
			if(actionType == "add"){
				dwr.TOPEngine.setAsync(false);
				//���湦����Ϣ
				FuncAction.saveFunc(vo, function(data){
					window.parent.cuiEMDialog.dialogs['funcDialog'].hide();
					window.parent.cuiEMDialog.wins['funcDialog'].editFuncCallBack(actionType, parentFuncId);
				});
				dwr.TOPEngine.setAsync(true);
			}else{
				if(nodePermission != vo.permissionType){
					if(vo.permissionType == 1){
						//�ڵ���Ȩ״̬�ӡ��ǡ���Ϊ���񡰣���Ҫɾ���ڵ���Ȩ����
						vo.cascadeOpen = 2;
					}
				}
				dwr.TOPEngine.setAsync(false);
				//�޸Ĺ�����Ϣ
				FuncAction.updateFunc(vo, function(data){
					window.parent.cuiEMDialog.dialogs['funcDialog'].hide();
					window.parent.cuiEMDialog.wins['funcDialog'].editFuncCallBack(actionType, funcId); 
				});
				dwr.TOPEngine.setAsync(true);
			}
		}
	}
	
	//�ж������Ƿ�����淶
	function checkName(data){
		var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_/\(��\)��]+$");
		return (reg.test(data));
	}
	
	//�ж������Ƿ��ظ�
	function isExistRename(data){
		if(data){
			var flag = true;
			dwr.TOPEngine.setAsync(false);
			var conditionVO = {parentFuncId:parentFuncId, funcName:data, funcId:funcId};
			FuncAction.judgeNameRepeat(conditionVO, function(data){
				if(data == 'NameExists'){
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
			var conditionVO = {funcCode:data, funcId:funcId};
			if(funcNodeType == 5){
				//����ǲ��������ж��Ƿ�ͬһ���ڵ��±���Ψһ���������ж�ȫ��Ψһ
				conditionVO.parentFuncId = parentFuncId; 
			}
			FuncAction.judgeCodeRepeat(conditionVO, function(data){
				if(data == 'CodeExists'){
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
</script>
</body>
</html>
