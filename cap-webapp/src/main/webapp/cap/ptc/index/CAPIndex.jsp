<!DOCTYPE html>
<%
  /**********************************************************************
	* CAP首页主页面 
	* 2015-09-22  李小芬  新增
  **********************************************************************/
%>
<html>
<head>
    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/cap/bm/dev/main/header.jsp" %>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/app/css/app.css"/>
    <title>CAP业务应用平台首页</title>
</head>
<body style="overflow: hidden">
<%@ include file="/cap/ptc/index/CAPMainNav.jsp" %>
<div class="workbench-container box">
	<div class="myapp-container" id="myapp-container">
		<iframe id="mainIframe" name="mainIframe" marginwidth="0" scrolling="no" src="${pageScope.cuiWebRoot}/cap/ptc/index/HomePageMain.jsp" 
			marginheight="0" frameborder="0" src="" style="display:block;width:100%;height:100%"></iframe>
	</div>

	<div class="goto-top" title="回到顶部"> </div>
</div>
        
<script type="text/javascript">

	//加载cui,引入window.top.comtop对象，勿删除
	 require(['cui'], function() {});
	 
	//初始化页面最小高度
	$(window).resize(function(){
		jQuery("#myapp-container").css("height",$(window).height()-90);
	}).resize();
	
</script>
</body>
</html>
