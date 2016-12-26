<%
  /**********************************************************************
	* CIP流程集成----流程列表主页面 
	* 2014-11-17 李小强  新增
	* 2015-01-10 沈康 修改
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>

<!doctype html>
<html>
<head>
<title>流程设计主页面</title>

	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	
</head>

<body>
	
	<div id="defectManTab" uitype="tab" tabs="tabs" fill_height="true"></div>

	<script type="text/javascript">
		var globalUserId ='${userInfo.userId}';
		var globalUserName = '${userInfo.employeeName}';
		var perPwd ='${userInfo.password}';
		var perAct = '${userInfo.account}';
		
		var dirCode="${param.packageModuleCode}"; 
		var tabs = [ {
	        title: "草稿",
	        url: "${pageScope.cuiWebRoot}/cap/bm/dev/workflow/WorkFlowUnDeployList.jsp?dirCode=" + dirCode + "&perPwd=" + perPwd + "&perAct=" + perAct + "&globalUserId=" + globalUserId + "&globalUserName=" + globalUserName
	        
	    },{
	        title: "运行中",
	        url: "${pageScope.cuiWebRoot}/cap/bm/dev/workflow/WorkFlowDeployEdList.jsp?dirCode=" + dirCode + "&perPwd=" + perPwd + "&perAct=" + perAct + "&globalUserId=" + globalUserId + "&globalUserName=" + globalUserName
	    }];
		
		//初始化    加载  	
	   	window.onload = function(){
	   		comtop.UI.scan();
	   	}
		
	</script>
</body>
</html>