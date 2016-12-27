<%
/**********************************************************************
* 登录模块:修改密码
* 2013-3-26 谭国华 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
	<title>修改密码</title>
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
	<div class="div_top">密码复杂度过低，为了保障您的账号安全，请修改密码。</div>
	<div class="div_center">
		<table class="form_table">
	   		<tr>
	       		<td class="td_label" width="42%">输入旧密码：</td>
	       		<td>
	       		 	<span uitype="input" id="oldPassword" name="oldPassword" type="password" 
      		 validate="[{'type':'required','rule':{'m':'密码不能为空！'}},{ 'type':'custom','rule':{ 'against':'validateOldPassword', 'm':'密码错误！'}}]"></span>
	       		 </td>
	       	</tr>
	       	<tr>
	       		<td class="td_label">设置新密码：</td>
	       		<td>
	       			<span uitype="input" id="newPassword" name="newPassword" type="password"  on_blur="validateEqual"
      		 validate="[{'type':'required','rule':{'m':'新密码不能为空！'}},{ 'type':'custom','rule':{ 'against':'validateEquals', 'm':'新旧密码不能相同，请重新输入新密码！'}}]"></span>
	       		</td>
	       	</tr>
	       	<tr>
	       		<td class="td_label">确认新密码：</td>
	       		<td>
	       			<span uitype="input" id="newPasswordConfirm" name="newPasswordConfirm" type="password" maxlength="50" 
      		 validate="[{'type':'required','rule':{'m':'请输入确认密码！'}},{ 'type':'custom','rule':{ 'against':'validatePasswordConfirm', 'm':'两次输入的新密码不一致，请重新输入！'}}]"></span>
	       		</td>
	   		</tr>
	       	<tr>
		       	<td colspan="2" class="reset_password_button">
		       		<span uitype="button" label="提&nbsp;交" on_click="submit"></span>
		       		<span uitype="button" label="清&nbsp;空" on_click="reset"></span>
		       		<span uitype="button" label="返&nbsp;回" on_click="exitOut"></span>
<!-- 		       		<span uitype="button" label="暂不修改" on_click="forwardToMainFrame"></span> -->
<!-- 		       		<span uitype="button" label="设置密码问题" on_click="setQuestion"></span> -->
		       	</td>
	       	</tr>
	 	</table>
	</div>
	<div class="div_bottom">
		注：新的密码必须与旧的密码不同
	</div>
</div>
<script type="text/javascript">
	var pattern;//密码规则正则表达式对象
	var message;//密码复杂度描述信息
	var isFormDeskLogin = "${param.login}";
	//是否已登出
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
	//初始化数据
	function initData(){
		ResetPasswordAction.getConfigValue(function(data){
			if(data){
				pattern = new RegExp(data.pattern);
				message = data.message || "不符合密码规则！";
				cui().validate().add('newPassword', 'custom', {'against':'validateNewPassword', 'm':message});
			}
		});
	}
	//跳转到主框架页面
	function forwardToMainFrame(){
		if(isFormDeskLogin){
			window.close();
			return;
		}
		//window.location.href = '<top:webRoot/>/indexFrame/indexFrame.jsp';
		window.location.replace('<top:webRoot/>/top/workbench/PlatFormAction/initPlatform.ac');
	}
	//验证旧密码是否正确
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

	
	//验证新密码是否符合密码规则
	function validateNewPassword(){
		var newPassword = cui("#newPassword").getValue();
		if(!pattern.test(newPassword)){
			return false;
		}
		return true;
	}
	//验证新旧密码是否相等
	function validateEquals(){
		var newPassword = cui("#newPassword").getValue();
		var oldPassword = cui("#oldPassword").getValue();
		if(newPassword == oldPassword){
			return false;
		}
		return true;
	}
	
	//失去焦点的时候验证两个密码是否相等
	function validateEqual(){
		var newPasswordConfirm = cui("#newPasswordConfirm").getValue();
		if(newPasswordConfirm){
			 window.validater.validOneElement('newPasswordConfirm');
		}
	}
	
	//确认新密码校验
	function validatePasswordConfirm(){
		var newPassword = cui("#newPassword").getValue();
		var newPasswordConfirm = cui("#newPasswordConfirm").getValue();
		if(newPasswordConfirm != newPassword){
			return false;
		}
		return true;
	}

	//提交
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
				cui.alert("密码不正确。");
			}else if(data=="FourAEncryptError"){
				cui.alert("4A算法加密出错。");
			}else if(data==='passWordNotMatchRule'){
				cui.alert("新密码不符合规则。");
			}else if(data==='passWordEquals'){
				cui.alert("新密码与老密码一样，请修改。");
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
	//重置
	function reset(){
		disValidate(true);
		cui("#oldPassword").setValue('');
		cui("#newPassword").setValue('');
		cui("#newPasswordConfirm").setValue('');
		disValidate(false);
	}
	
	//暂时忽略验证
	function disValidate(flag){
		var validate = cui().validate();
		validate.disValid("oldPassword", flag);
		validate.disValid("newPassword", flag);
		validate.disValid("newPasswordConfirm", flag);
	}
	
	//跳转到设置问题的页面
	function setQuestion(){
		window.location.href = 'SetQuestion.jsp?isFormDeskLogin=' + isFormDeskLogin;
	}

	//退出系统
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
