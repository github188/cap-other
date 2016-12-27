<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<%/****************************************************************************
	* 跳转到BPMS监控管理平台
	* 2012-09-25 黄晓彬 新建
	*****************************************************************************/%>
<html>
<head>
<title></title>
</head>
<body>
<form id="userlogin_form"  name="userlogin_form" action="flex/MonitorUI.jsp" method="post">

<input type="hidden" name="perID" value="${userInfo.userId}"/>
<input type="hidden" name="perAct" value="${userInfo.account}"/>
<input type="hidden" name="perPwd" value="${userInfo.password}"/>
<input type="hidden" name="perAlias" value="${userInfo.name}"/>
<input type="hidden" name="neededLogin" value="false"/>
<!-- 
<input type="hidden" name="userId" value=""/>
<input type="hidden" name="userAccount" value=""/>
<input type="hidden" name="userPassword" value=""/>
<input type="hidden" name="userName" value=""/>
<input type="hidden" name="neededLogin" value="true"/>
 -->
<input type="hidden" name="autoLogin" value="false"/>
 </form> 
 
</body>
</html>
<script language="javascript">
  var Dwidth = window.screen.width;    //获取屏幕宽
  var Dheight= window.screen.height;   //获取屏幕高
  ///bpms/RedirectToBPMSMonitor.jsp?userId=SuperAdmin&userAccount=SuperAdmin&userName=SuperAdmin&userPassword=SuperAdmin
  //var userId=document.forms[0].userId.value;
  //var userAccount=document.forms[0].userAccount.value;
  //var userPassword=document.forms[0].userPassword.value;
  //var userName=document.forms[0].userName.value;
  //var url="flex/MonitorUI.jsp?userId="+userId+"&userAccount="+userAccount+"&userName="+userName+"&userPassword="+userPassword;
 //window.open(url,'myWin','height='+Dheight+', width='+Dwidth+', top=0,left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=yes');
  window.open('about:blank','myWin','height='+Dheight+', width='+Dwidth+', top=0,left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=yes');
  //window.open(url,'myWin','height='+Dheight+', width='+Dwidth+', top=0,left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=yes');
  	var ie=navigator.appName=="Microsoft Internet Explorer"?true:false;
	if(ie){
		userlogin_form.target='myWin';
		userlogin_form.submit(); 
	}else{
		 var _form=document.getElementById("userlogin_form");
		 _form.setAttribute("target","myWin");
		_form.submit();			
	}
  window.opener = null;
  window.close();
</script>
