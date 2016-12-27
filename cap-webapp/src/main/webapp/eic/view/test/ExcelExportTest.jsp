<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/eic" prefix="eic"%>
<%
	String strHide = request.getParameter("hide");
	boolean hide = false;
	if ("false".equalsIgnoreCase(strHide) || "true".equalsIgnoreCase(strHide)) {
		hide = Boolean.parseBoolean(strHide);
	}
			
	String id=request.getParameter("id");
	String userId =request.getParameter("userId");
	String excelId = request.getParameter("excelId");
	String param =request.getParameter("param");
	String exportType =request.getParameter("exportType");
	String style =request.getParameter("style");
	String buttonName =request.getParameter("buttonName");
	String callback =request.getParameter("callback");
	String icon =request.getParameter("icon");
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>excel导出测试页面</title>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/eic/css/eic.css"></link>
		<link rel="stylesheet" type="text/css"
			href="<%=request.getContextPath()%>/eic/cui/themes/default/css/comtop.ui.min.css" />
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/cui/js/comtop.ui.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/comtop.eic.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
	
		<script type="text/javascript">
		
		</script>
	</head>
	<body>
		<center>
			<eic:excelExport id="<%=id %>" userId="<%=userId %>"
				excelId="<%=excelId %>" hide="<%=hide %>" 
				param="<%=param %>" exportType="<%=exportType %>" 
				style="<%=style %>" buttonName="<%=buttonName %>" 
				icon="<%=icon %>" />
		</center>
	</body>
	
	
</html>