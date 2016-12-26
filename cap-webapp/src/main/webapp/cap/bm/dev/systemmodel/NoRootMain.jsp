<%
  /**********************************************************************
	* CIP元数据建模----系统建模 无根节点主页面  
	* 2014-10-30  沈康 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>


<!doctype html>
<html>
<head>
<title>系统建模主页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/ProjectAppAction.js'></script>
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
		<div align="center" style="padding-top: 100px">
			<font style="font-size: 24px;font-family: 微软雅黑;color: #999999">暂无系统应用信息，请点击下方的按钮进行首步操作</font>
		</div>
		<div align="center" style="padding-top: 20px">
			<span uitype="button" label="新增系统" button_type="green-button" on_click="insertRootSystem"></span>
		</div>
	</div>


	<script type="text/javascript">
		window.onload = function(){
	   		comtop.UI.scan();
	   	}
		
		function insertRootSystem() {
			var url = "<%=request.getContextPath() %>/cap/bm/dev/systemmodel/SystemModuleEdit.jsp?isRootNodeAdd=true&actionType=add";
			var title="系统编辑页面";
			var height = 500; //600
			var width =  800; // 680;
			
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			})
			dialog.show(url);
		}
	</script>
</body>
</html>