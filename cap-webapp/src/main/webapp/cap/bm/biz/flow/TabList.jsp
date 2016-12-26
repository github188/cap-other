<%
  /**********************************************************************
	* CAP业务模型Tab页管理
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<title>业务模型Tab页管理</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
</head>
<body style="overflow-y:hidden;">
	<div  uitype="Tab" tabs="tabs" fill_height="true"></div>
<script type="text/javascript">
var domainId = "${param.domainId}";
var BizProcessInfoId = "<c:out value='${param.BizProcessInfoId}'/>";
var BizProcessnodeId = "${param.BizProcessnodeId}";
var tabs =[
    {
    	title: '基本信息',
    	url:'BizProcessNodeEdit.jsp?BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId+"&domainId="+domainId},
	{
		title: '业务对象',
		url:'BizNodeConstraintMain.jsp?domainId='+domainId+'&BizProcessnodeId='+BizProcessnodeId},
	{
		title: '业务表单',
		url:'BizFormNodeRelList.jsp?domainId='+domainId+'&BizProcessnodeId='+BizProcessnodeId},
	{
		title: '业务关联',
		url:'BizRelInfoMain.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId},
];
	window.onload = function(){
		comtop.UI.scan();
	}
	
</script>
</body>
</html>