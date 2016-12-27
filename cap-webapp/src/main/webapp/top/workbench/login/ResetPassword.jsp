<%
/**********************************************************************
* ��¼ģ��:�޸�����
* 2013-3-26 ̷���� �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
	<title>�޸�����</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
   	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
   	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/engine.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ResetPasswordAction.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/LoginAction.js'></script>
	<style type="text/css">
		html,body{
			overflow-y:hidden;
		}
		
		tr{
			height:50px;
		}
		.reset_password_button{
			text-align:center;
		}
		.div_all{
			width:732px;
			height:331px;
			margin:0 auto;
			margin-top:70px;
			background:url(./img/resetPassword_bg.gif) no-repeat;
			font-size:16px;
			color:#666666;
		}
		.div_top{
			font-weight:bold;
			padding: 10px 0 0 20px;
			height:30px;
		}
		.div_center{
			font-weight:bold;
			padding:20px 10px;
			margin:10px 0;
			font-size:14px;
		}
		.div_bottom{
			padding-left:20px;
			font-size:14px;
			height:30px;
			color:red;
		}
		
		.button_box{
			_margin-left:6px;
		}
	</style>
</head>
<body>
<div class="div_all">
	<div class="div_top">���븴�Ӷȹ��ͣ�Ϊ�˱��������˺Ű�ȫ�����޸����롣</div>
	<div class="div_center">
		<table class="form_table">
	   		<tr>
	       		<td class="td_label" width="42%">��������룺</td>
	       		<td>
	       		 	<span uitype="input" id="oldPassword" name="oldPassword" type="password" 
      		 validate="[{'type':'required','rule':{'m':'���벻��Ϊ�գ�'}},{ 'type':'custom','rule':{ 'against':'validateOldPassword', 'm':'�������'}}]"></span>
	       		 </td>
	       	</tr>
	       	<tr>
	       		<td class="td_label">���������룺</td>
	       		<td>
	       			<span uitype="input" id="newPassword" name="newPassword" type="password"  on_blur="validateEqual"
      		 validate="[{'type':'required','rule':{'m':'�����벻��Ϊ�գ�'}},{ 'type':'custom','rule':{ 'against':'validateEquals', 'm':'�¾����벻����ͬ�����������������룡'}}]"></span>
	       		</td>
	       	</tr>
	       	<tr>
	       		<td class="td_label">ȷ�������룺</td>
	       		<td>
	       			<span uitype="input" id="newPasswordConfirm" name="newPasswordConfirm" type="password" maxlength="50" 
      		 validate="[{'type':'required','rule':{'m':'������ȷ�����룡'}},{ 'type':'custom','rule':{ 'against':'validatePasswordConfirm', 'm':'��������������벻һ�£����������룡'}}]"></span>
	       		</td>
	   		</tr>
	       	<tr>
		       	<td colspan="2" class="reset_password_button">
		       		<span uitype="button" label="��&nbsp;��" on_click="submit"></span>
		       		<span uitype="button" label="��&nbsp;��" on_click="reset"></span>
		       		<span uitype="button" label="��&nbsp;��" on_click="exitOut"></span>
<!-- 		       		<span uitype="button" label="�ݲ��޸�" on_click="forwardToMainFrame"></span> -->
<!-- 		       		<span uitype="button" label="������������" on_click="setQuestion"></span> -->
		       	</td>
	       	</tr>
	 	</table>
	</div>
	<div class="div_bottom">
		ע���µ����������ɵ����벻ͬ
	</div>
</div>
<script type="text/javascript">
	var pattern;//�������������ʽ����
	var message;//���븴�Ӷ�������Ϣ
	var isFormDeskLogin = "${param.login}";
	//�Ƿ��ѵǳ�
    localStorage.isLogout = 'false';
	   var loginInterval = setInterval(function(){
	        if(localStorage.isLogout==='true'){
	            window.opener = null;
	            window.top.open('','_self');
	            window.top.close();
	            clearInterval(loginInterval);
	        }
	    },500);
	window.onload = function(){
		comtop.UI.scan();
		initData();
	}
	//��ʼ������
	function initData(){
		ResetPasswordAction.getConfigValue(function(data){
			if(data){
				pattern = new RegExp(data.pattern);
				message = data.message || "�������������";
				cui().validate().add('newPassword', 'custom', {'against':'validateNewPassword', 'm':message});
			}
		});
	}
	//��ת�������ҳ��
	function forwardToMainFrame(){
		if(isFormDeskLogin){
			window.close();
			return;
		}
		//window.location.href = '<top:webRoot/>/indexFrame/indexFrame.jsp';
		window.location.replace('<top:webRoot/>/top/workbench/PlatFormAction/initPlatform.ac');
	}
	//��֤�������Ƿ���ȷ
	function validateOldPassword(){
		var oldPassword = cui("#oldPassword").getValue();
		var value;
		dwr.TOPEngine.setAsync(false);
		ResetPasswordAction.isPasswordCorrect(oldPassword,function(isCorrect){
			value = isCorrect;
		});
		dwr.TOPEngine.setAsync(true);
		return value;
	}

	
	//��֤�������Ƿ�����������
	function validateNewPassword(){
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

	//�ύ
	function submit() {
		var validateMap = window.validater.validAllElement();
		var inValid = validateMap[0];
		var valid = validateMap[1];
		if(inValid.length > 0){
			return;
		}
		var newPassword = cui("#newPassword").getValue();
		var oldPassword = cui("#oldPassword").getValue();
		ResetPasswordAction.resetPassword(oldPassword,newPassword,function(data){
			if(data=="oldPassWordNotCorrect"){
				cui.alert("���벻��ȷ��");
			}else if(data=="FourAEncryptError"){
				cui.alert("4A�㷨���ܳ���");
			}else if(data==='passWordNotMatchRule'){
				cui.alert("�����벻���Ϲ���");
			}else if(data==='passWordEquals'){
				cui.alert("��������������һ�������޸ġ�");
			}else{
				if(isFormDeskLogin){
					window.close();
					return;
				}
// 				forwardToMainFrame();
				exitOut();
			}
    	});
	}
	//����
	function reset(){
		disValidate(true);
		cui("#oldPassword").setValue('');
		cui("#newPassword").setValue('');
		cui("#newPasswordConfirm").setValue('');
		disValidate(false);
	}
	
	//��ʱ������֤
	function disValidate(flag){
		var validate = cui().validate();
		validate.disValid("oldPassword", flag);
		validate.disValid("newPassword", flag);
		validate.disValid("newPasswordConfirm", flag);
	}
	
	//��ת�����������ҳ��
	function setQuestion(){
		window.location.href = 'SetQuestion.jsp?isFormDeskLogin=' + isFormDeskLogin;
	}

	//�˳�ϵͳ
    function exitOut() {
        LoginAction.exit({callback:logoutCallback,errorHandler:logoutCallback});
    }

    function logoutCallback(loginType){
        clearInterval(loginInterval);
        localStorage.isLogout="true";
        if (loginType == "1") {
			window.location.href = "${pageScope.cuiWebRoot}" + "/signout";
		} else if (loginType == "2") {
			window.location.href = "${pageScope.cuiWebRoot}" + "/exit4ASSO.ac";
		} else {
			window.location.href = "${pageScope.cuiWebRoot}";
		}
    }
</script>
</body>
</html>
