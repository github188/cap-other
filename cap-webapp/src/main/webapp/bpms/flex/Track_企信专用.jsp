<!DOCTYPE HTML>
<%/****************************************************************************
	* 流程跟踪主页面
	* 2014-07-28 李欢 新建
	*****************************************************************************/%>
<%@ page contentType="text/html; charset=GBK" %>
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
     String processInsId = request.getParameter("processInsId");
     String processId = request.getParameter("processId");
     String webRoot = request.getParameter("webRoot");
     String webRootUrl = request.getParameter("webRootUrl");
	 String showTrackFlag = request.getParameter("showTrackFlag");
     if (null == webRoot){
    	 webRoot = request.getContextPath();
     }else if (null != webRoot && !webRoot.startsWith("/")) {
		 webRoot = "/" + webRoot;
	 }
     //判断流程定义是否为wft_开头，如果以wtf_开头则展示2.0跟踪，否则展示BPMS跟踪
     if (null != processInsId && !processInsId.startsWith("wft_")) {
    	 //重定向到bpms跟踪jsp
    	 
    	 String url = webRoot + "/bpms/flex/BpmsTrack.jsp?processId=" + processId + "&processInsId=" 
		 + processInsId + "&webRootUrl=" + webRootUrl + "&showTrackFlag="+showTrackFlag;
    	 response.sendRedirect(url);
    	 return;
     }
     else if(null != processInsId && processInsId.startsWith("wft_")){
    	 //重定向到旧版跟踪jsp    /bpms/bizflow/flowmanage/track
    	 String url = webRoot + "/bpms/bizflow/flowmanage/track/WorkFlowTrack.jsp?processId=" 
		 + processId + "&processInsId=" + processInsId;
    	 response.sendRedirect(url);
    	 return;
     }
     %>
</script>
</body>
</html>