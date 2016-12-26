<%
  /**********************************************************************
	* 文档管理主页面 
	* 2015-11-9  李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!doctype html>
<html>
<head>
<title>文档管理主页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/jquery.dynatree.min.js'></script>
	<script type="text/javascript" src='<%=request.getContextPath() %>/top/component/topui/cui/js/comtop.ui.tree.js'></script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div uitype="Borderlayout"  id="body"  is_root="true" > 
		<div id="area" position="left" width="300px" url="" collapsable="true" show_expand_icon="true">
		</div>
		<div id="centerMain" position ="center">
		</div>
	</div>


	<script type="text/javascript">
		//选中的树节点
		$(document).ready(function(){
			comtop.UI.scan();   //扫描
			setLeftUrl("");
		});
		
		//设置左侧布局链接界面 
		function setLeftUrl(nodeId){ 
			var url = "<%=request.getContextPath() %>/cap/bm/biz/domain/jsp/domainList.jsp?selectNodeId="+nodeId + "&treeScope=document";
			cui("#body").setContentURL("left",url);
		}
		
		//设置右侧Tab页 (单击业务域)
		function setCenterUrlForClik(selectDomainId,editType){ 
			var contentUrl = '<%=request.getContextPath() %>/cap/bm/doc/info/DocList.jsp?bizDomainId=' + selectDomainId;
			cui('#body').setContentURL("center",contentUrl);	
		}
		
	</script>
</body>
</html>