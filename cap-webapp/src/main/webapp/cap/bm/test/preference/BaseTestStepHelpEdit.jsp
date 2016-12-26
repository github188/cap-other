<%
/**********************************************************************
* 基本测试步骤帮助编辑页面
* 2015-6-30 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>基本测试步骤帮助编辑</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"></top:script>
    <script type="text/javascript">
	var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
	var attrName = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("attrName"))%>;
	var index = parseInt(flag);
	var ctrlHelp = window.parent.scope.arguments[index].help==null?"":window.parent.scope.arguments[index].help;
   	window.onload = function(){
   	 comtop.UI.scan();
   	cui("#attrValue").setValue(ctrlHelp);
   	}
   	
   	//确定保存数据
   	function saveHelp(){
   		var editAttrValue = cui("#attrValue").getValue();
   		window.parent.scope.arguments[index].help = editAttrValue;
   		closeHelp();
   	}
   	
   	//关闭窗口
   	function closeHelp(){
   		window.parent.closeWindowCallback();
   	}
	</script>
</head>
<style>
	.top_header_wrap{
		padding-right:5px;
	}
</style>
<body>
<div uitype="Borderlayout" id="body" is_root="true">	
		<div class="top_header_wrap" style="padding:10px 30px 10px 25px;">
			<div class="thw_operate" style="float:right;height: 28px;">
				<span uitype="button" id="saveHelp" label="确定"  on_click="saveHelp" ></span>
				<span uitype="button" id="closeHelp" label="取消"  on_click="closeHelp" ></span>
			</div>
		</div>
		<div class="cap-area" style="width:100%;padding:25px 0px 20px 0px">
		<span uitype="Textarea" id="attrValue" name="help" width="92%" height="300px"></span>
		</div>
</div>
</body>
</html>