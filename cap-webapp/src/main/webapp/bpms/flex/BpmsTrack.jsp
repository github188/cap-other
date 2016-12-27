<!DOCTYPE HTML>
<%/****************************************************************************
	* 流程跟踪主页面
	* 2014-07-28 李欢 新建
	*****************************************************************************/%>
<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>流程跟踪</title>
     <link rel="stylesheet" type="text/css" href="../bizflow/common/cui/themes/default/css/comtop.ui.min.css" />
    <script type="text/javascript" src="../bizflow/common/cui/js/comtop.ui.min.js" ></script>
   
</head>
<body>
<div id="dt1" uitype="tab" tabs="tabs" closeable="true" fill_height="true"></div>
<script type="text/javascript" id="sourceCode">
	<%
	String processId = request.getParameter("processId");
	String processInsId = request.getParameter("processInsId"); 
	String trackKey = request.getParameter("trackKey"); 
	String webRootUrl = request.getParameter("webRootUrl");
  String showTrackFlag = request.getParameter("showTrackFlag");
	String webRoot = request.getParameter("webRoot");
	if (null == webRoot){
    	 webRoot = request.getContextPath();
     }else if (null != webRoot && !webRoot.startsWith("/")) {
		 webRoot = "/" + webRoot;
	 }
	 request.setAttribute("webRoot",webRoot);
	%>
	var webRoot = "<c:out value='${webRoot}'/>"; 
	var processId = "<c:out value='${param.processId}'/>";
	var processInsId = "<c:out value='${param.processInsId}'/>";
	//分布式环境下，需要传模块路径，如资产项目子系统webRootUrl = /web/lcam/project
	var webRootUrl = "<c:out value='${param.webRootUrl}'/>";
	if("" == webRootUrl || "null" == webRootUrl || "undefined" == webRootUrl ){
		webRootUrl =   "${pageContext.request.contextPath}";
	}
	var trackKey= "<c:out value='${param.trackKey}'/>";
	var showTrackFlag = "<c:out value='${param.showTrackFlag}'/>";
	var tabs = [ 
	    {
		    title: "\u6d41\u7a0b\u8ddf\u8e2a\u8868",
		    fill_height: true,
		    tab_width: "80px",
		    url: webRoot+"/bpms/track/BpmsTrackTable.jsp?processId="+processId+"&processInsId="+processInsId+
			"&trackKey="+trackKey+"&webRootUrl="+webRootUrl
		},
		{
		    title: "\u6d41\u7a0b\u8ddf\u8e2a\u56fe",
		    tab_width: "80px",
		    url: webRoot+"/bpms/flex/BpmsTrackDiagram.jsp?processId="+processId+"&processInsId="+processInsId+"&webRootUrl="+webRootUrl+ "&showTrackFlag="+showTrackFlag
	}];
	comtop.UI.scan();
	 var loginInterval = setInterval(function(){
	        if(localStorage.isLogout==='true'){
	            window.opener = null;
	            window.top.open('','_self');
	            window.top.close();
	            clearInterval(loginInterval);
	        }
	    },1000);
</script>
</body>
</html>