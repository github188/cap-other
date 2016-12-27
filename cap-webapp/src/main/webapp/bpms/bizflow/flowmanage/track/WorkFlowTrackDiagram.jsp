<html>
<head>
<title>工作流跟踪表</title>
<common:css href="../../common/cui/themes/default/css/flowtrack-style.css"/>

<style type="text/css">
.arrow{
    padding: 1px;
    text-align: center;
}

.branch{
    margin: 2px;
 }

.break-word{
	word-break:break-all;
	word-wrap:break-word;
}

.flowImage
{
    border-style:none;
}

</style>
</head>
<body>
<%
 String processId = request.getParameter("processId");
 String webRoot = request.getParameter("webRoot");
%>
<table>
<tr>
	<td>
	    <img id="id_flowtrack_img" class="flowImage" src="<%=webRoot%>/bpms/workFlowImageAction.do?processId=<%=processId%>"
			USEMAP="#flowmap" onload='this.style.display="block";' >
		<MAP name="flowmap" id="id_flowmap">
		</MAP>
	</td>
</tr>
</table>
</body>
</html>

