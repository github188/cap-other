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
	
	String strId = request.getParameter("id");
	String strUserId = request.getParameter("userId");
	String strWordId = request.getParameter("wordId");
	String strStyle = request.getParameter("style");
	String strIcon = request.getParameter("icon");
	String strParam = request.getParameter("param");
	String strButtonName = request.getParameter("buttonName");
	String strAsyn = request.getParameter("asyn");
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>word导出测试页面</title>
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
			<eic:wordExport id="<%=strId %>" userId="<%=strUserId %>" wordId="<%=strWordId %>" style="<%=strStyle %>" icon="<%=strIcon %>" param="<%=strParam %>" 
				hide="<%=hide %>" buttonName="<%=strButtonName %>" asyn="<%=strAsyn %>" />
		</center>
	</body>
	
	
</html>