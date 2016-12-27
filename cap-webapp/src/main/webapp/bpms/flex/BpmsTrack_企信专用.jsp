<!DOCTYPE HTML>
<%/****************************************************************************
	* 流程跟踪主页面
	* 2014-07-28 李欢 新建
	*****************************************************************************/%>
<%@ page contentType="text/html; charset=GBK" %>

<%@page import="com.comtop.bpms.client.ClientFactory"%><html>
<head>
    <title>流程跟踪</title>
     <link rel="stylesheet" type="text/css" href="../bizflow/common/cui/themes/default/css/comtop.ui.min.css" />
    <script type="text/javascript" src="../bizflow/common/js/component/jquery/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="../bizflow/common/cui/js/comtop.ui.min.js" ></script>
    <style type="text/css">
    	body,html{font-family:'Microsoft YaHei','Hiragino Sans GB',Helvetica,Arial,'Lucida Grande',sans-serif;}
    	.msg_font {font-size: 12px; color: #333333;}
    	.count_font {font-size: 12px; color: #0077ff;}
    </style>
   
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
	int total = ClientFactory.getTrackService().queryDiscusUserCount(processId, processInsId);
	if (null == webRoot){
    	 webRoot = request.getContextPath();
     }else if (null != webRoot && !webRoot.startsWith("/")) {
		 webRoot = "/" + webRoot;
	 }
	%>
	var webRoot = "<%=webRoot%>";
	var processId = "<%=processId%>";
	var processInsId = "<%=processInsId%>";
	//分布式环境下，需要传模块路径，如资产项目子系统webRootUrl = /web/lcam/project
	var webRootUrl = "<%=null == webRootUrl?"":webRootUrl%>";
	if("" == webRootUrl || "null" == webRootUrl || "undefined" == webRootUrl ){
		webRootUrl =   "${pageContext.request.contextPath}";
	}
	var trackKey= "<%=trackKey%>";
	var showTrackFlag="<%=showTrackFlag%>";
	var tabs = [ 
	    {
		    title: "\u6d41\u7a0b\u8ddf\u8e2a\u8868",
		    fill_height: true,
		    closeable: false,
		    tab_width: "80px",
		    url: webRoot+"/bpms/track/BpmsTrackTable.jsp?processId="+processId+"&processInsId="+processInsId+
			"&trackKey="+trackKey+"&webRootUrl="+webRootUrl
		},
		{
		    title: "\u6d41\u7a0b\u8ddf\u8e2a\u56fe",
		    tab_width: "80px",
		    closeable: false,
		    url: webRoot+"/bpms/flex/BpmsTrackDiagram.jsp?processId="+processId+"&processInsId="+processInsId+"&webRootUrl="+webRootUrl+ "&showTrackFlag="+showTrackFlag
	}];
	comtop.UI.scan();
	$(document).ready(function() {
		var html = "";
		html = "<div style='float:right;padding-top:5px;' class='msg_font'>\u6709<span class='count_font'><%=total%></span>\u4eba\u53c2\u4e0e\u4e86\u6b64\u6d41\u7a0b\uff0c\u53d1\u8d77\u8ba8\u8bba</div>";
		html += "<img style='float:right;' src='../track/images/qixinyun.png'/>";
		$(".cui-tab-nav").append(html);
	});
</script>
</body>
</html>