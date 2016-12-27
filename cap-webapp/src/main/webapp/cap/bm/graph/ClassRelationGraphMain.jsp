<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>模块资源关系</title>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
<style>
	body{margin:0}
	.top_header_wrap {
		padding: 5px 0;
		height: 25px;
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
<body style="overflow: auto; position: absolute; width: 100%; height: 100%; cursor: default;">
<div class="top_header_wrap" style="padding-top:3px">
	<div class="thw_title">
		<font id = "pageTittle" class="fontTitle">模块资源图</font> 
	</div>
	<div class="thw_operate">
		<span uitype="button" id="new_same" label="返回"  on_click="returnToPage" ></span>
	</div>
</div>
<div id="moduleRelationTab" uitype="Tab" tabs="tabs" closeable="true"></div>
<script type="text/javascript">
	var moduleId = "${param.moduleId}";//模块ID
	var moduleName = "${param.moduleName}";
	var title = moduleName + "资源关系";
	var returnUrl = "${param.returnUrl}";//模块ID
	
	var tabs =  [
	 	     	{
	 		     	title: title,
	 		     	url: 'ClassRelationGraph.jsp?moduleId=' + moduleId
	 	     	}
	 ];
	//DOM加载完毕后，执行scan扫描生成组件
	comtop.UI.scan();
	
	var height = (document.documentElement.clientHeight || document.body.clientHeight) - 40;
	cui('#moduleRelationTab').resize(height);
	
	function returnToPage(){
		window.open(returnUrl, '_self');
	}
	
</script>	
</body>
</html>
