<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>模块部署图</title>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
<style>
	body{margin:0}
	.top_header_wrap {
		padding: 5px 0;
		height: 25px
	}
	.thw_title{
		float:left;
		font:14px "宋体";
		margin-top:5px;
		margin-left:10px;
		font-weight:bold;
		color: #000;
	}
		
	.thw_operate{
		float:right;
	}
</style>
<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
</head>
<body style="overflow: hidden; position: absolute; width: 98%; height: 98%; cursor: default;">
<div class="top_header_wrap" style="padding-top:3px">
	<div class="thw_title">
		<font id = "pageTittle" class="fontTitle">模块资源图</font> 
	</div>
	<div class="thw_operate">
		<span uitype="button" id="exportImage" label="导出图片"  on_click="exportImage" ></span>
		<span uitype="button" id="new_same" label="返回"  on_click="returnToPage" ></span>
	</div>
</div>
    <%
       String moduleId = request.getParameter("moduleId");
	   String diagramType = request.getParameter("diagramType");
	   String contextPath = request.getContextPath();
    %>
<iframe id="graphEditor" src="Editor.jsp?moduleId=${param.moduleId}&diagramType=${param.diagramType}"  style="overflow: auto; position: absolute; width: 100%; height: 100%; margin-left: 10px; margin-top: 5px; cursor: default;"></iframe>
<script type="text/javascript">
	var returnUrl = "${param.returnUrl}";//模块ID
	var testModel = "${param.testModel}";//测试建模
	
	//DOM加载完毕后，执行scan扫描生成组件
	comtop.UI.scan();	
	function returnToPage(){
		window.open(returnUrl+"&testModel="+testModel, '_self');
	}
	
	function exportImage(){
		var graphEditor = document.getElementById('graphEditor');
		var graphEditorWin = graphEditor.window || graphEditor.contentWindow;
		graphEditorWin.exportToImage();
	}
</script>	
</body>
</html>
