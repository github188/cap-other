<%
/**********************************************************************
* 用户访问情况管理main页面
* 2012-10-31 汪超  新建
**********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
	<title>在线用户</title>
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
</head>
<style>
	body{
		margin:0 10px 0 10px;
	}
</style>
<body>
	<div uitype="tab" closeable="false" fill_height="true"></div>
	
	<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js'></script>
	<script language="javascript">
		var urlList=["UserVisitLogsStatistics.jsp","UserVisitLogsDetail.jsp"],
			tabs=[{
				title:"用户访问统计",
				url:urlList[0],
				tab_width:110
			},{
				title:"用户访问列表",
				url:urlList[1],
				tab_width:100
			}];
		
		comtop.UI.scan(); 
	</script>
</body>
</html>