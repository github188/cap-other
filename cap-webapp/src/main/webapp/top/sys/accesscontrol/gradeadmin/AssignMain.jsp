
<%
	/**********************************************************************
	 * �ּ�������Դ����
	 * 2014-7-15  л�� �½�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>Ȩ�޷���</title>
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
        title: "������λ",
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignPostMain.jsp?adminId="+subjectId+"&orgId="+orgId
    }, {
    	title: "��������λ",
    	url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignPostOtherMain.jsp?adminId="+subjectId
    }, {
        title: "��Դ",
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignFuncMain.jsp?subjectId="+subjectId
    }, {
        title: "��ɫ",
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignRoleMain.jsp?subjectId="+subjectId
    }, {
        title: "������",
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/gradeadmin/AssignWorkflowMain.jsp?adminId="+subjectId
    }];
    $(document).ready(function() {
		comtop.UI.scan();
		
	});
</script>
</body>
</html>