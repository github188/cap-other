<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.slf4j.org/taglib/tld" prefix="log"%> 
<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%@ page contentType="text/html; charset=GBK" %>
<%@page import="com.comtop.top.component.common.systeminit.ServerConstant"%>
<%@page import="com.comtop.top.sys.login.util.LoginConstant"%>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
<%@page import="com.comtop.top.component.app.session.HttpSessionUtil"%>


<top:noCache/>
<%		
	response.setHeader("Content-Type", "text/html; charset=GBK");
	request.setCharacterEncoding("GBK");
	pageContext.setAttribute("pageEncoding", "GBK");
	//UserDTO objUserDTO =(UserDTO)session.getAttribute(LoginConstant.SECURITY_CURR_USER_INFO_KEY);
	UserDTO objUserDTO =(UserDTO) HttpSessionUtil.getCurUserInfo();
	pageContext.setAttribute("userInfo",objUserDTO);
	pageContext.setAttribute("cuiWebRoot",request.getContextPath()); 
	
%>
<script language="javascript">
	var globalUserId ='${userInfo.userId}';
	var globalUserName ='${userInfo.employeeName}';
	var globalOrganizationId ='${userInfo.orgId}';
	var globalOrganizationName ='${userInfo.orgName}'; 
	var webPath = '<top:webRoot/>';
</script>
<log:debug category="jsp.request">
  <!-- ƽ̨�汾:<%=ServerConstant.VERSION%>ƽ̨��������:<%=ServerConstant.PULISH_DATE%> -->
 <top:info type="url"/>
</log:debug>