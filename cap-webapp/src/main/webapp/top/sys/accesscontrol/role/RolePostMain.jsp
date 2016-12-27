<%
	/**********************************************************************
	 * 角色关联岗位信息查看
	 * 2016-1-14  石刚 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>角色关联岗位信息查看</title>
<link rel="stylesheet"	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"	type="text/css">

<script type="text/javascript"	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>

</head>
<body>
<div uitype="Borderlayout" id="body" is_root="true">
	<div  uitype="bpanel" id="centerMain" position="center" width="288px"  show_expand_icon="true">       
		<div id="assignMain" uitype="tab" tabs="assignMain"  fill_height="true"></div>
	</div>
</div>
 
 <script type="text/javascript">
   var roleId = "<c:out value='${param.roleId}'/>"; 
   
    var assignMain = [ {
        title: "行政类岗位",
        tab_width:90,
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/RolePostList.jsp?roleId="+roleId
    },{
        title: "非行政类岗位",
        tab_width:90,
        url:"${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/RoleOtherPostList.jsp?roleId="+roleId
    }];
    $(document).ready(function() {
		comtop.UI.scan();
	});
</script>
</body>
</html>