<%
  /**********************************************************************
	* 功能子项Tab页
	* 2015-11-26 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
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
<body> 
	<div uitype="tab" id="divTabId"   tab_width="65"  active_index="0"  closeable="false"  reload_on_active="true"  trigger_type="click"  tabs="tabs"  fill_height="true"></div>
<script type="text/javascript">
	var selectDomainId = "${param.selectDomainId}";
	var modelPackage = "${param.modelPackage}";
	var tabs = [ 
				{
					title: "功能子项",
					url: "ReqFunctionSubitemEdit.jsp?ReqFunctionSubitemId="+selectDomainId},
				{
			    	title: "功能用例",
					url: "ReqFunctionUsecaseEdit.jsp?ReqFunctionSubitemId="+selectDomainId},
				{
			    	title: "界面原型",
					url: "ReqPrototypeList.jsp?ReqFunctionSubitemId="+selectDomainId+"&modelPackage="+modelPackage}
		];
	window.onload = function(){
		comtop.UI.scan();
	}
	
	function gotoReqFunctionItemEdit(){
		var url = "<%=request.getContextPath()%>/cap/bm/req/subfunc/ReqFunctionSubitemEdit.jsp";
		window.location.href = url;
	}
	
</script>
</body>
</head>
</html>