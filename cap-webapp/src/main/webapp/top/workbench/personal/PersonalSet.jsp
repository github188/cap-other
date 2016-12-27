<%@page import="com.comtop.top.sys.usermanagement.user.util.UomCommonUtil"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>
<%		
	//�Ƿ�����ϵͳ��Ա��֯���ܰ�ť true ���� false ������
    boolean isHideSystemBtnInUserOrg = UomCommonUtil.getHideSystemBtnInUserOrgCfg();
%>
<html>
<head>
<title>�û�����</title>
<style type="text/css">
    .user-header{
        width:120px;
        height:120px;
    }
    
    table td{
        color:#666;
        font-size:14px;
    }
    
    .app-category {
	  margin-bottom: 10px;
	  font-size: 14px;
	  font-weight: bold;
	  border-left: 3px solid #6AA725;
	  height: 20px;
	}
	.app-category .place-left{
	   padding-left:5px;
	}
	.app-category hr {
	  height: 0px;
	  border: 0px;
	  border-bottom: 1px solid #ddd;
	}
	#personal-set{
	    background:#fff;
	    padding:10px;
	    border:1px solid #ccc;
	}
	.table-wrap{
	   margin-left:50px;
	}
	#personal-set .table-wrap table{
	   width:100%;
	   height:120px;
	}
	#personal-set .table-wrap table td{
       text-align: left;
       vertical-align:top;
    }
    .tip{
        color:red;
    }
    .label {
        display: inline-block;
        padding: 2px 4px;
        font-size: 10.152px;
        font-weight: bold;
        line-height: 14px;
        color: #fff;
        vertical-align: baseline;
        white-space: nowrap;
        text-shadow: 0 -1px 0 rgba(0,0,0,0.25);
        background-color: #3a87ad;
        border-radius: 3px;
        cursor: pointer;
        margin:2px 5px;
    }
</style>
</head>
<body>
<div id="personal-set">
	<div class="app-category clearfix">
		<div class="place-left">������Ϣ</div><hr>
	</div>
	<div  class="table-wrap">
    	<table>
    	    <tr>
    	        <td width="120px">
    	        	<img class="user-header" src="${pageScope.cuiWebRoot}/top/workbench/personal/img/default_head.jpg"/><br>
    	        	<span uitype="Button"  label="����ͷ��" on_click="changeHead" style="display:block;margin:10px 0 0 22px;"></span>
    	        </td>
    	        <td>
    	            <table width="100%" height="100px" style="padding-left:20px;table-layout: fixed;">
    	            <colgroup>
				        <col width=90 />
				        <col width= />
				        <col width=90 />
				        <col width=/>
				    </colgroup>
    	                <tr>
    						<td align="right" >�� &nbsp; ����</td>
    						<td align="left" >${userInfo.employeeName}</td>
    						<td align="right" >�� &nbsp; �ţ�</td>
    						<td align="left">${userInfo.nameFullPath}</td>
    					</tr>
    					<tr>
    					    <td align="right">�� &nbsp; �䣺</td>
                            <td align="left">${userInfo.email}</td>
    						<td align="right">�� &nbsp; ����</td>
    						<td align="left">${userInfo.mobilePhone}</td>
    					</tr>
    					<tr>
    						<td align="right">�� &nbsp; λ��</td>
                            <td align="left" id="user-post" colspan="3"></td>
    					</tr>
    	            </table>
    	        </td>
    	    </tr>
    	</table>
	</div>
	<br>
	<div class="app-category clearfix">
		<div class="place-left">���Ի�����</div><hr>
	</div>
	<div  class="table-wrap">
		<table>
			<tr>
				<td width="85px" align="center">��¼����ҳ��</td>
				<td>
					<div id="platformId"></div>
				</td>
			</tr>
			<tr>
				<td  align="center">��Ϣ���նˣ�</td>
				<td>
					<div id="messageType"></div>
				</td>
			</tr>
			<tr>	
				<td align="left" colspan="2">
					<span uitype="Button" label="����" on_click="saveMessageType"></span>
				</td>
			</tr>
		</table>
	</div>
	<br>
	<div class="app-category clearfix">
		<div class="place-left">ί�д���</div><hr>
	</div>
	
	<div id="delegateInsertId" style="display:none" class="table-wrap">
		 <table>
			<tr>
				<td width="70px" align="center">��ί���ˣ�</td>
				<td>
					<span uitype="ChooseUser" validate="��ί���˲���Ϊ��" id="entrustUser" chooseMode="1" width="190px" height="30px"  userType="1"  isSearch="true" ></span>
				</td>
			</tr>
			<tr>
				<td  align="center">ί��ʱ�Σ�</td>
				<td><span uitype="Calender" isrange="true"  validate="[{'type':'custom','rule':{'against':'checkEntrustStartDate','m':'ί�п�ʼʱ�β���Ϊ�ա�'}},{ 'type':'custom','rule':{ 'against':'checkEntrustEndDate', 'm':'ί�н���ʱ�β���Ϊ�ա�'}}]" 
		           id="entrustDate" panel="2" width="225px"></span></td>
			</tr>
			<tr>	
				<td align="left" colspan="2">
					<span uitype="Button" label="����" on_click="saveButton"></span> &nbsp;&nbsp;
					<span uitype="Button" label="����" on_click="resetButton"></span> &nbsp;&nbsp;
					<span uitype="Button" label="ί�м�¼" on_click="searchButton"></span>
				</td>
			</tr>
		</table>	
	</div>
	<div id="delegateUpdateId" style="margin-left:50px;line-height:30px;font-size:14px;">
    </div>
    <% if(!isHideSystemBtn){ %>
		<% if(!isHideSystemBtnInUserOrg){ %>
    <div class="app-category clearfix">
        <div class="place-left">�޸�����</div><hr>
    </div>
    <div class="table-wrap">
        <table>
            <tr>
                <td width="85px" align="center">��������룺</td>
                <td>
                    <span uitype="Input" id="oldPassword" type="password" 
      		 validate="[{'type':'required','rule':{'m':'���벻��Ϊ�գ�'}},{ 'type':'custom','rule':{ 'against':'validateOldPassword', 'm':'�������'}}]"></span>
                </td>
            </tr>
            <tr>
                <td  align="center">���������룺</td>
                <td>
                    <span uitype="Input" id="newPassword" type="password" on_blur="validateEqual"
      		 validate="[{'type':'required','rule':{'m':'�����벻��Ϊ�գ�'}},{ 'type':'custom','rule':{ 'against':'validateEquals', 'm':'�¾����벻����ͬ�����������������룡'}}]"></span>
                    <span style="margin-left:15px;"></span><br/><span class="tip"></span>
                </td>
            </tr>
            <tr>    
                <td  align="center">ȷ�������룺</td>
                <td>
                    <span uitype="Input" id="newPasswordConfirm" type="password" maxlength="50" 
      		 validate="[{'type':'required','rule':{'m':'������ȷ�����룡'}},{ 'type':'custom','rule':{ 'against':'validatePasswordConfirm', 'm':'��������������벻һ�£����������룡'}}]"></span>
                </td>
            </tr>
            <tr>    
                <td align="left" colspan="2">
                    <span uitype="Button" label="�޸�����" id="btn-reset-password"></span>
                </td>
            </tr>
        </table>
    </div>
	<% } %>
	<% } %>
	
	<div id="headDialog">
	</div>	
	
	<div id="delegateDialog">
	</div>
</div>

<script>
var pattern;
	require(['cui','workbench/dwr/interface/UserPersonalizationAction',
	          'workbench/dwr/interface/WorkbenchUserDelegateAction','uochoose','loginAction'], function() {
      comtop.UI.scan();
		UserPersonalizationAction.getUserPersonalization(function(data) {
			//��ȡ��Ϣ���ն�
			var messageType = data.personalInfo.messageType;
			var messageArray;
			if(messageType!=null){
				messageArray = messageType.split(",");
			}else{
				messageArray = new Array();
			}
			messageArray.push(0);
			cui('#messageType').checkboxGroup({
				checkbox_list: initMessageTypeData,
				value: messageArray,
				border:true
			});
			
			//��ȡ�û�ͷ����Ϣ
			if (data.personalInfo.isHasHead == 'Y') {
				$(".user-header").attr("src","${pageScope.cuiWebRoot}/top/workbench/workbenchServlet.ac?actionType=displayHead");
			}
			var postInfo = data.personalInfo.postInfo;
			if(postInfo&&postInfo.length>0){
                 var postName = [];
                 for(var i=0;i<postInfo.length;i++){
                	 if(postInfo[i].postName){
	                     postName.push($('<label class="label" >'+postInfo[i].postName+'</label>').data('post-info',postInfo[i]));
                	 }
                 }
                 $('#user-post').html(postName);
             }
			//��ȡ��¼����ҳ ������
			var initPlatformData = data.platFormList;
       		cui('#platformId').pullDown({
       			mode: 'Single',
       			value_field:'platformId',
       			label_field:'platformName',
       			select:'0',
       			datasource :initPlatformData
       		});
       		//��ʾ���������ʾ
       		showPasswordConfig(data.passwordConfig||[]);
		});
		
		//��ȡ�û������¼
		WorkbenchUserDelegateAction.queryUserValidDateDelegateInfo(function(data) {
			if(data.length > 0){
				for(var i=0;i<data.length;i++){
					var consignId = data[i].consignId;
					var startTime = data[i].startTime;
					var strStartTime =  startTime.getFullYear()+"-"+(startTime.getMonth() + 1)+"-"+startTime.getDate();
					var endTime = data[i].endTime;
					var strEndTime =  endTime.getFullYear()+"-"+(endTime.getMonth() + 1)+"-"+endTime.getDate();
					var nowTime = new Date();
					var str = "��ί��"+data[i].delegatedUserName+"��"+strStartTime+"��"+strEndTime+"�ڼ�������ҵ��,";
					if(startTime<nowTime && nowTime<endTime){
						str = str + "��ǰ�Ѿ���ʼ��<br>"+"	<span uitype='Button' label='��ֹί��' mark='"+consignId+"' on_click='stopButton' ></span> <br>";
					}else if(nowTime<startTime){
						str = str + "��ǰ��δ��ʼ��<br>"+" <span uitype='Button' label='ȡ��ί��' mark='"+consignId+"' on_click='cancleButton' ></span> <br>";
					}
					$("#delegateUpdateId").append(str);
					comtop.UI.scan();
				}
			}else{
				$("#delegateInsertId").css("display","block");
				$("#delegateUpdateId").css("display","none");
			}
		});	
		
	});
	/**
	 *��ȡ�û������¼ 
	 */
	function showPasswordConfig(passwordConfig){
	    var configMessage = [],$newPassword = $('#newPassword');
	    if(passwordConfig&&passwordConfig.length>0){
// 	    for(var i=0;i<passwordConfig.length;i++){
	        configMessage.push(passwordConfig[0].message);
		    pattern = new RegExp(passwordConfig[0].rule);
	    }
	    $newPassword.data('passwordConfig',passwordConfig);
	    $newPassword.next().html(configMessage.join('��'));
	    var message = configMessage.join('��') || "�������������";
		cui().validate().add('newPassword', 'custom', {'against':'validateNewPassword', 'm':message});
	}
	//��Ϣ���ն����� ����Դ
	function initMessageTypeData (obj) {
		var data = [{
		text: '��Ϣ����(վ����)',
		readonly : "readonly", //��ʼ��ֻ��
		value: '0'
		}
		/*  Ŀǰû��ʵ�������������ն˵Ĺ��ܣ������ȡҲ��д���ģ���ʱ����  2016-0517  by cjs
		,{
		text: '�����ʼ�',
		value: '1'
		},{
		text: '�ֻ�����',
		value: '2'
		}*/
		];
		obj.setDatasource(data);
	}
	
	//����ͷ��
	function changeHead(){
		cui('#headDialog').dialog({
			modal: true,
			width:650,
			height:450,
			title:"����ͷ��",
			src: "${pageScope.cuiWebRoot}/top/workbench/personal/UploadPersonal.jsp"
			}).show();
	}
	
	//������Ϣ���ն�����
	function saveMessageType(){
		var platformId = cui("#platformId").getValue();
		var messageType = cui("#messageType").getValueString(",");
		UserPersonalizationAction.updatePersonalization(messageType,platformId,function(data) {
			cui.alert("����ɹ�!");
		});
	}
	
	
	//����ί��
	function saveButton(){
		window.validater.disValid('entrustUser', false);
		window.validater.disValid('entrustDate', false);
		var valids = window.validater.validElement('AREA', '#delegateInsertId');
	   
		if(valids[0].length == 0){//��֤ͨ��		
			var regEx = new RegExp("\\-","gi"); 
			var startTime = cui("#entrustDate").getValue()[0].replace(regEx,"/"); 
			var endTime = cui("#entrustDate").getValue()[1].replace(regEx,"/");
			
			var userDelegateDTO = new Object();
			userDelegateDTO.userId = globalUserId;
			userDelegateDTO.delegatedUserId = cui("#entrustUser").getValue()[0].id;
			userDelegateDTO.startTime =	Date.parse(startTime+" 00:00:01");
			userDelegateDTO.endTime = Date.parse(endTime+" 23:59:59");
			userDelegateDTO.delegatedUserName = cui("#entrustUser").getValue()[0].name;
			userDelegateDTO.state="1";
			WorkbenchUserDelegateAction.saveUserDelegate(userDelegateDTO,function(data) {
				if(data){
					window.location.reload();
				}
			});
		}
	}
	
	//����
	function resetButton(){
		window.validater.disValid('entrustUser', true);
		window.validater.disValid('entrustDate', true);
		cui("#entrustUser").setValue("");
		cui("#entrustDate").setValue("");
	}
	
	//��ѯί�м�¼
	function searchButton(){
		cui('#delegateDialog').dialog({
			modal: true,
			title: 'ί�м�¼',
			width:680,
			height:450,
			src:"${pageScope.cuiWebRoot}/top/workbench/personal/UserDelegateList.jsp"
			}).show();
	}
	
	//��ֹί��
	function stopButton(event, self, mark){
		WorkbenchUserDelegateAction.stopUserDelegate(mark,function(data) {
			window.location.reload();
		});
		
	}
	
	//ȡ��ί��
	function cancleButton(event, self, mark){
		WorkbenchUserDelegateAction.deleteUserDelegate(mark,function(data) {
			window.location.reload();
		});
	}
	
	//��֤�������Ƿ���ȷ
	function validateOldPassword(){
		var oldPassword = cui("#oldPassword").getValue();
		var value;
		dwr.TOPEngine.setAsync(false);
		LoginAction.isPasswordCorrect(oldPassword,function(isCorrect){
			value = isCorrect;
		});
		dwr.TOPEngine.setAsync(true);
		return value;
	}

	
	//��֤�������Ƿ�����������
	function validateNewPassword(){
		if(!pattern){return true}
		var newPassword = cui("#newPassword").getValue();
		if(!pattern.test(newPassword)){
			return false;
		}
		return true;
	}
	//��֤�¾������Ƿ����
	function validateEquals(){
		var newPassword = cui("#newPassword").getValue();
		var oldPassword = cui("#oldPassword").getValue();
		if(newPassword == oldPassword){
			return false;
		}
		return true;
	}
	
	//ʧȥ�����ʱ����֤���������Ƿ����
	function validateEqual(){
		var newPasswordConfirm = cui("#newPasswordConfirm").getValue();
		if(newPasswordConfirm){
			 window.validater.validOneElement('newPasswordConfirm');
		}
	}
	
	//ȷ��������У��
	function validatePasswordConfirm(){
		var newPassword = cui("#newPassword").getValue();
		var newPasswordConfirm = cui("#newPasswordConfirm").getValue();
		if(newPasswordConfirm != newPassword){
			return false;
		}
		return true;
	}
	
	require(['loginAction'],function(){
        $('#btn-reset-password').click(function(){
        	var validateMap = window.validater.validElement('CUSTOM',['oldPassword','newPassword','newPasswordConfirm']);
    		var inValid = validateMap[0];
    		var valid = validateMap[1];
    		if(inValid.length > 0){
    			return;
    		}
    		var newPassword = cui("#newPassword").getValue();
    		var oldPassword = cui("#oldPassword").getValue();
    		LoginAction.resetPassword(oldPassword,newPassword,function(data){
    			if(data=="oldPassWordNotCorrect"){
    				cui.alert("���벻��ȷ��");
    			}else if(data=="FourAEncryptError"){
    				cui.alert("4A�㷨���ܳ���");
    			}else if(data==='passWordNotMatchRule'){
    				cui.alert("�����벻���Ϲ���");
    			}else if(data==='passWordEquals'){
    				cui.alert("��������������һ�������޸ġ�");
    			}else{
    				exitOut();
    			}
        	});	
        });	    
	});
	
	//�˳�ϵͳ
    function exitOut() {
    	 cui.success('�����޸ĳɹ��������ȷ�������µ�¼��',function(){
	       	 LoginAction.exit({callback:logoutCallback,errorHandler:logoutCallback});
    	 });
    }
    
	$('#user-post').on('click','.label',function(){
	   var postInfo = $(this).data('post-info');
	   cui.dialog({
	       src:webPath + '/top/workbench/personal/RoleListForPost.jsp?postId='+postInfo.postId,
            refresh:false,
            modal: true,
            title: '��ɫ�б�',
            width:600,
            height:400
	   }).show();
	});
	
	/*
	* ί��ʱ����֤��ʹ����������������ó�isrange=true ��Χ����һ��Ĭ��ֵ,["", ""]
	*/
	function checkEntrustStartDate(data){
		     var startTime = cui("#entrustDate").getValue()[0]; 
		     if(startTime==''){
		    	 return false;
		     }
		     return true;
	}
	
	/*
	* ί��ʱ����֤��ʹ����������������ó�isrange=true ��Χ����һ��Ĭ��ֵ,["", ""]
	*/
	function checkEntrustEndDate(data){
		     var endTime = cui("#entrustDate").getValue()[1];
		     if(endTime==''){
		    	 return false;
		     }
		     return true;
	}
      
</script>
</body>
</html>