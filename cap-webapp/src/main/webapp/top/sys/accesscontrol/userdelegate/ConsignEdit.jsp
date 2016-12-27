<!DOCTYPE html>
<%
/**********************************************************************
* ί�й���:�༭�����˼�Ȩ��
* 2013-04-22 ����  �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
    <title>������Ϣ�鿴���༭</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">    
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/css/choose.css" type="text/css"/>	
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">

	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/usermanagement/orgusertag/js/choose.js" ></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserDelegateAction.js"></script>	
	<script src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ChooseAction.js" type="text/javascript"></script>	
   
</head>
<body >
<div class="top_header_wrap" style="padding-top:15px;padding-bottom:15px;padding-right:15px;">
	<div class="thw_operate">
		<span uitype="Button" label="�� ��" on_click="saveConsignInfo" id="saveBtn"></span>
	</div>
</div>
<div >
	<table class="form_table">
	 <colgroup>
     	<col width="25%"/>
     	<col width="75%"/>
     </colgroup>
     
		<tr>
			<td width="25%" class="td_label">
				<span class="top_required">*</span>������������
			</td>
			<td width="75%">
				<span uitype="ChooseUser" id="chooseUser" width="250px" height="25px" chooseMode="1" userType="1"  isSearch="true" ></span>
			</td>
		</tr>
		<tr>
			<td width="15%" class="td_label">
				<span class="top_required">*</span>״̬��
			</td>
			<td width="85%" class="td_content">
				<div id="state" uitype="RadioGroup" name="state"  databind="delegateData.state" value="1" >
					<input type="radio"  value="1" />��Ч
					<input type="radio"  value="2" />��Ч
				</div>
			</td>
		</tr>
		<tr>
			<td width="15%" class="td_label">
				<span class="top_required">*</span>��ʼʱ�䣺
			</td>
			<td width="85%" class="td_content">
				<span uitype="Calender" id="startTime" name="startTime" databind="delegateData.startTime" model="date" format="yyyy-MM-dd hh:mm:ss" emptytext="������ί�п�ʼʱ��" 
					 validate="[{'type':'required', 'rule':{'m': '��ʼʱ�䲻��Ϊ�ա�'}}]"  maxdate="#endTime"></span>
			</td>
		</tr>
		<tr>
			<td width="15%" class="td_label">
				<span class="top_required">*</span>����ʱ�䣺
			</td>
			<td width="85%" class="td_content">
				<span uitype="Calender" id="endTime" name="endTime"  databind="delegateData.endTime" model="date"  format="yyyy-MM-dd hh:mm:ss" emptytext="������ί�н���ʱ��" 
					validate="[{'type':'required', 'rule':{'m': '����ʱ�䲻��Ϊ�ա�'}}]" mindate="#startTime"></span>
			</td>
		</tr>
		<tr>
			<td width="18%" class="td_label">
				<span class="top_required">*</span>ί�������
			</td>
			<td width="82%" class="td_content">
				<div id="hasAllAccess" uitype="RadioGroup" name="hasAllAccess"  databind="delegateData.hasAllAccess" value="0" >
					<input type="radio"  value="0" />ȫ��Ȩ��
					<input type="radio"  value="1" />����Ȩ��
				</div>
			</td>
		</tr>
		<tr>
			<td width="15%" class="td_label">
				��ע��
			</td>
			<td class="td_content">
				<div style="width:315px;">
				<span uitype="Textarea" id="description"  height="50px" 
				name="descripition" maxlength="250" relation="defect1" databind="delegateData.description"></span>
				<div style="float:right">
					<font id="applyRemarkLengthFont" >(����������<label id="defect1" style="color:red;"></label>&nbsp; �ַ�)</font>
				</div>
				
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
<script type="text/javascript">
	//ί����
	var userId = "<c:out value='${param.userId}'/>";
	var consignId = "<c:out value='${param.consignId}'/>";
	
	var delegateData = {}; 
window.name = "test"
	//ҳ�����
	window.onload = function() { 
		
		comtop.UI.scan(); 
		//�༭ҳ���ʼ��
		if(consignId != ""){
			dwr.TOPEngine.setAsync(false);
			UserDelegateAction.readUserDelegate(consignId,function(consignData){
				delegateData = consignData;
				var user = [{id:consignData.delegatedUserId,name:consignData.delegatedUserName}];
				cui('#chooseUser').setValue(user);	
				cui('#chooseUser').setReadonly(true);
				cui('#startTime').setValue(consignData.startTime);
				cui('#endTime').setValue(consignData.endTime);
				cui('#description').setValue(consignData.description);
				cui('#state').setValue(consignData.state);
				cui('#hasAllAccess').setValue(consignData.hasAllAccess);
			});	
			dwr.TOPEngine.setAsync(true);
	    }	
	}

	//�����������Ϣ
	function saveConsignInfo(){
		if(validateInfo()){
			var vo = cui(delegateData).databind().getValue();
			
			var userObject=cui('#chooseUser').getValue();
			var delegatedUserId = userObject[0].id;
			vo.delegatedUserId = delegatedUserId;
			vo.state = cui("#state").radioGroup().getValue();
			vo.startTime = cui("#startTime").getValue("date");
			vo.endTime = cui("#endTime").getValue("date");
			vo.hasAllAccess = cui("#hasAllAccess").radioGroup().getValue();
			vo.description = cui("#description").getValue();
			vo.userId = userId;
			dwr.TOPEngine.setAsync(false);
			UserDelegateAction.saveUserDelegate(vo,function(data){
				if(consignId){
					parent.editCallBack('edit');
					parent.cui.message('ί����Ϣ���³ɹ���','success');
				}else{
					parent.editCallBack('add');
					parent.cui.message('ί����Ϣ�����ɹ���','success');
				}
				parent.dialog.hide();
			});
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//�����Ƿ���Ա���
	function validateInfo(){
		var map = window.validater.validAllElement();
	   	var inValid = map[0];//���ô�����Ϣ
	   	var valid = map[1]; //���óɹ���Ϣ
	   	var strInfo='';
	   	var str = '';
	   	
		var userObject=cui('#chooseUser').getValue();  
	    if(userObject.length > 0){
			if(userId ==  userObject[0].id){
				strInfo += '�����˺�ί���˲�����ͬһ���ˡ�';
			}
			//�ж�����֮����ѡ�е�ʱ���֮���Ƿ��Ѿ�������ί�й�ϵ01909096.dg
			if(inValid.length == 0){
				dwr.TOPEngine.setAsync(false);
				var obj = {'consignId':consignId,'userId':userId,'delegatedUserId':userObject[0].id,'startTime':cui("#startTime").getValue("date"),'endTime':cui("#endTime").getValue("date")};
				UserDelegateAction.isExistConsignRelation(obj,function(data){
					if(data==true||data=='true'){
						strInfo += 'ͬһʱ����ڲ��ܱ�ͬһ���û��ظ�����';
					}
				});
				dwr.TOPEngine.setAsync(true);
		    }
		}else{
			strInfo += '�����˲���Ϊ�ա�'
		}
	    
	    if (inValid.length > 0) {
	        for (var i = 0; i < inValid.length; i++) {
			 	 str +=  inValid[i].message + "<br />";
			}
	    }
	    str += strInfo;
	    if(str != ''){
	    	cui.warn(str);
	    	return false;
		}
		return true;
	}
</script>
</html>


            