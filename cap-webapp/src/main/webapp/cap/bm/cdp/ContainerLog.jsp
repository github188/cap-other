<%
    /**********************************************************************
	 * Pod日志查看列表
	 * 2016-09-30  李小芬  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<html>
<head>
<title>容器日志查询</title>
<top:link href="/cap/bm/common/top/css/top_base.css"/>
<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
<top:script src='/cap/rt/common/globalVars.js'></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/EvcontralListPageAction.js'></top:script>
</head>
<body>
	<div class="top_content_wrap">
		<span id="podLog" width="100%" height="100%" style="font-size:12px; color:#CD3333;">暂时没有日志信息,请稍后查询...</span>
	</div>
<script type='text/javascript'>
var rcName = '${param.rcName}';
var containerName ='${param.containerName}';
var data = {};
window.onload = function(){
	queryContainerLog();
    comtop.UI.scan();
}
/**
*  查询日志
**/
function queryContainerLog(){
	//初始化页面
       EvcontralListPageAction.queryContainerLog(containerName,function(logData){
       	if(logData && logData.length > 0){
           	document.getElementById("podLog").innerText=logData;
       	}else{
       		document.getElementById("podLog").innerText="暂时没有日志信息,请稍后查询...";
       	}
       });
}
</script>
</body>
</html>