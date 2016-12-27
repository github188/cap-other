<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/eic" prefix="eic"%>
<%!
			 /**
		     * 对文件路径+名称进行解码
		     * 
		     * @param filePathAndName 文件+名称
		     * @return 文件+名称decode解码
		     */
		    private String decodeFilePathAndName(String filePathAndName) {
		        String strFilePathAndName = filePathAndName;
		        if (null != strFilePathAndName && "".equals(strFilePathAndName)) {
		            return "";
		        }
		        try {
		            strFilePathAndName = java.net.URLDecoder.decode(strFilePathAndName, "GBK");
		        } catch (java.io.UnsupportedEncodingException e) {
		            
		        }
		        return strFilePathAndName;
		    }
		%>
<%
	String strHide = request.getParameter("hide");
	boolean hide = false;
	if ("false".equalsIgnoreCase(strHide) || "true".equalsIgnoreCase(strHide)) {
		hide = Boolean.parseBoolean(strHide);
	}
			
	String strAsyn = request.getParameter("asyn");
	boolean asyn = false;
	if ("false".equalsIgnoreCase(strAsyn) || "true".equalsIgnoreCase(strAsyn)) {
		asyn = Boolean.parseBoolean(strAsyn);
	}
			
	String strShowDownloadBtn = request.getParameter("showDownloadBtn");
	boolean showDownloadBtn = false;
	if ("false".equalsIgnoreCase(strShowDownloadBtn) || "true".equalsIgnoreCase(strShowDownloadBtn)) {
		showDownloadBtn = Boolean.parseBoolean(strShowDownloadBtn);
	}
	
	String id=request.getParameter("id");
	String userId =request.getParameter("userId");
	String excelId = decodeFilePathAndName(request.getParameter("excelId"));
	String param =decodeFilePathAndName(request.getParameter("param"));
	String style =request.getParameter("style");
	String downloadIcon =request.getParameter("downloadIcon");
	String callback =request.getParameter("callback");
	String icon =request.getParameter("icon");
	String buttonName=request.getParameter("buttonName");
	String downloadBtnName =request.getParameter("downloadBtnName");
%>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>excel导入测试页面</title>
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
			<eic:excelImport id="<%=id %>" userId="<%=userId %>" buttonName="<%=buttonName %>"
				excelId="<%=excelId %>" hide="<%=hide %>" downloadBtnName="<%=downloadBtnName %>"
				param="<%=param %>" showDownloadBtn="<%=showDownloadBtn %>" 
				style="<%=style %>" downloadIcon="<%=downloadIcon %>" 
				callback="<%=callback %>"
				icon="<%=icon %>" asyn="<%=asyn %>" />
		</center>
	</body>
	
	
</html>