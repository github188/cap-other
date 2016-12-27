<!DOCTYPE HTML>
<%/****************************************************************************
	* 流程跟踪主页面
	* 2014-10-16 路猷 新建
	*****************************************************************************/%>
<%@ page contentType="text/html; charset=GBK" %>
<%@page import="com.comtop.lcam.flowtrack.service.IWorkFlowUtilBizService"%>
<%@page import="com.comtop.lcam.flowtrack.service.impl.WorkFlowUtilBizService"%>	
<%@page import="com.comtop.lcam.flowtrack.model.WorkFlowMapingInfoVo"%>
<html>
<head>
    <title>历史迁移数据流程跟踪</title>
    <link rel="stylesheet" type="text/css" href="../../common/cui/themes/default/css/comtop.ui.min.css" ></link>
    <script type="text/javascript" src="../../common/cui/js/comtop.ui.min.js"></script>
</head>
<body>
<div id="dt1" uitype="tab" tabs="tabs" closeable="true" fill_height="true"></div>
    <%
     String processInsId = request.getParameter("processInsId");
     String processId = request.getParameter("processId");
     String webRoot = request.getParameter("webRoot");
     if (null == webRoot){
    	 webRoot = request.getContextPath();
     }else if (null != webRoot && !webRoot.startsWith("/")) {
		 webRoot = "/" + webRoot;
	 }
     processInsId=processInsId.replace(" ","+");
     IWorkFlowUtilBizService iWorkFlowUtilBizService = new WorkFlowUtilBizService();
     WorkFlowMapingInfoVo workFlowMapingInfoVo = iWorkFlowUtilBizService.readWorkFlowMapingInfoVo(processInsId);
     String workFlowId = "";
     String workId = "";
     if (null != workFlowMapingInfoVo) {
    	 workFlowId = workFlowMapingInfoVo.getWorkflowId();
    	 workId = workFlowMapingInfoVo.getWorkId();
     }
	%>
<script type="text/javascript" id="sourceCode">
	 var flowControlId = "";
	 var workFlowId = "<%=workFlowId%>";
	 var workId = "<%=workId%>";
	 var strTableURL = "WorkFlowTrackTable.jsp?flowControlId="+flowControlId+"&workFlowId="+workFlowId+"&workId="+workId;
     var strDiagramURL = "WorkFlowTrackDiagram.jsp?processId=<%=workFlowId%>&webRoot=<%=webRoot%>";
	 var tabs = [ 
	    {
		    title: "\u6d41\u7a0b\u8ddf\u8e2a\u8868",
		    fill_height: true,
		    tab_width: "80px",
		    url: strTableURL
		},
		{
		    title: "\u6d41\u7a0b\u8ddf\u8e2a\u56fe",
		    tab_width: "80px",
		    url: strDiagramURL
	}];
	comtop.UI.scan();
</script>
</body>
</html>