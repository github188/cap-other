<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%
   String packageId = request.getParameter("packageId");
   String parentNodeId = request.getParameter("parentNodeId");
   String parentNodeName = (String)session.getAttribute("parentNodeName");
%>
<html>
<head>
<title>success</title>
</head>
<body>
	<script type="text/javascript">
	   window.parent.cui.message('上传成功。', 'success');
	   window.onload = function(){
			window.parent.location.replace("bm/dev/pdm/PdmImportListMain.jsp?packageId=<%=packageId%>" + "&parentNodeId=<%=parentNodeId%>" 
					+ "&parentNodeName=<%=parentNodeName%>");
		}
	   window.parent.dialog.hide();
	</script>
</body>
</html>