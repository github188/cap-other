<%
  /**********************************************************************
	* CAP业务模型Tab页管理
	* 2015-11-03 姜子豪 新增
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
<style>
</style>
<body>
	<div id="mainTab" uitype="Tab" tabs="tabs" fill_height="true"></div>
<script type="text/javascript">
var editType = "${param.editType}";
var parentId = "${param.parentId}";
var selectDomainId = "${param.selectDomainId}";
var tabs =[
    {
    	title: '基本信息',
    	url:'${pageScope.cuiWebRoot}/cap/bm/biz/basicInfo.jsp?parentId='+parentId+'&editType='+editType+'&selectDomainId='+selectDomainId},
	{
		title: '业务事项',
		url:'${pageScope.cuiWebRoot}/cap/bm/biz/item/BizItemList.jsp?selectDomainId='+selectDomainId},
	{
		title: '业务流程',
		url:'${pageScope.cuiWebRoot}/cap/bm/biz/flow/BizProcessInfoMain.jsp?domainId='+selectDomainId},
	{
		title: '业务对象',
		url:'${pageScope.cuiWebRoot}/cap/bm/biz/info/BizObjInfoMain.jsp?selectDomainId='+selectDomainId},
	{
		title: '业务表单',
		url:'${pageScope.cuiWebRoot}/cap/bm/biz/form/bizFormMainPage.jsp?selectDomainId='+selectDomainId}
];
	window.onload = function(){
		comtop.UI.scan();
	}
	
	function refleshDomain(selectDomainId,editType){
		parent.setCenterUrlForClik(selectDomainId,editType);
	}
	
	//loadTree
	function loadTree(nodeId){
		parent.setLeftUrl(nodeId);
		parent.cui.message('保存成功','success');
	}
	
</script>
</body>
</html>