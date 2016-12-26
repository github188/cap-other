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
	var componetId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("componetId"))%>;
	var index = parseInt(flag);
	var ctrlOptions = window.parent.scope.arguments[index].ctrl.options==null?"":window.parent.scope.arguments[index].ctrl.options;
   	window.onload = function(){
   	 comtop.UI.scan();
   	cui("#ctrlOptions").setValue(ctrlOptions);
   	}
   	
   	//确定保存数据
   	function saveCtrl(){
   		var ctrlOptions = cui("#ctrlOptions").getValue();
   		window.parent.scope.arguments[index].ctrl.options = ctrlOptions;
   		closeCtrl();
   	}
   	
   	//关闭窗口
   	function closeCtrl(){
   		window.parent.ctrlDialog.hide();
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
				<span uitype="button" id="saveCtrl" label="确定"  on_click="saveCtrl" ></span>
				<span uitype="button" id="closeCtrl" label="取消"  on_click="closeCtrl" ></span>
			</div>
		</div>
		<div class="cap-area" style="width:100%;padding:25px 0px 20px 0px">
		<span uitype="Textarea" id="ctrlOptions" name="help" width="92%" height="300px"></span>
		</div>
</div>
</body>
</html>