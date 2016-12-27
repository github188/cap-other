
<%
	/**********************************************************************
	 * 分级管理资源分配
	 * 2014-7-15  谢阳 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>权限分配</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">

<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>

</head>
<body>
<div uitype="Borderlayout" id="body" is_root="true">
	<div  uitype="bpanel" id="centerMain" position="center" width="288px"  show_expand_icon="true">       
		<div id="assignMain" uitype="tab" tabs="assignMain"  fill_height="true"></div>
	</div>
</div>
 
 <script type="text/javascript">
   var subjectId="<c:out value='${param.adminId}'/>";
   var orgId = "<c:out value='${param.orgId}'/>";
   
    var assignMain = [ {
        title: "行政岗位",
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignPostMain.jsp?adminId="+subjectId+"&orgId="+orgId
    }, {
    	title: "非行政岗位",
    	url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignPostOtherMain.jsp?adminId="+subjectId
    }, {
        title: "资源",
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignFuncMain.jsp?subjectId="+subjectId
    }, {
        title: "角色",
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignRoleMain.jsp?subjectId="+subjectId
    }, {
        title: "工作流",
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignWorkflowMain.jsp?adminId="+subjectId
    }];
    $(document).ready(function() {
		comtop.UI.scan();
		
	});
</script>
</body>
</html>