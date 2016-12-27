<!DOCTYPE html>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.comtop.top.sys.accesscontrol.gradeadmin.GradeAdminConstants" %>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
<%		
	UserDTO objUserInfo = (UserDTO)pageContext.getAttribute("userInfo");
	boolean isAdminManager = GradeAdminConstants.isManagerByUserId(objUserInfo.getUserId());
	if(!isAdminManager){
	   	response.sendRedirect(request.getContextPath()+"/top/sys/accesscontrol/gradeadmin/GradeAdminError.html");
	}
%>
