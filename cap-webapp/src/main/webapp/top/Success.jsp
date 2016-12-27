
<%
    /**********************************************************************
			 * 登录成功页面
			 * 2014-10-28   新建
			 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%@ page import="com.comtop.top.component.common.config.UniconfigManager"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%
    String strMainFrameURL = UniconfigManager.getGlobalConfig("mainFrameURL");
%>
<html>
<head></head>
<body>
<script type="text/javascript">  
var strMainFrameURL = '<%=strMainFrameURL%>';
var loginMessageVO = eval(${sessionScope.loginMessageVO})||{};
window.onload = function(){
	if(loginMessageVO.loginMessage == "resetPassword"){
		window.location.replace('<top:webRoot/>/top/workbench/login/ResetPassword.jsp');
	}else{
		window.location.replace('<top:webRoot/>'+strMainFrameURL);
	}
}
</script>
</body>
</html>
