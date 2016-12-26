<%
  /**********************************************************************
	* CAP业务流程编辑
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>业务模型管理</title>
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
</head>
<body>
	<div uitype="Borderlayout" id="border" is_root="true">
		<div id="BizRelInfoList" position="left" width="150px" url="">
		</div>
		<div id="BizRelInfoEdit" position="center" width="690px" url="">
		</div>
	</div>
<script type="text/javascript">
	var domainId = "${param.domainId}";
	var BizProcessInfoId = "<c:out value='${param.BizProcessInfoId}'/>";
	var BizProcessnodeId = "${param.BizProcessnodeId}";
	//业务域ID
	window.onload = function(){
		comtop.UI.scan();
		setLeftUrl("");
		var url = 'BizRelInfoEdit.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId;
		setCenterUrl(url);
	}
	//设置左侧布局链接界面 
	function setLeftUrl(bizRelInfoId){
		var url = 'BizRelInfoTree.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId;
		if(bizRelInfoId){
			url +="&BizRelInfoId="+bizRelInfoId;
		}
		cui("#border").setContentURL("left",url);
	}
	//设置中间布局链接页面
	function setCenterUrl(url){
		cui("#border").setContentURL("center",url);
	}
</script>
</body>
</head>
</html>