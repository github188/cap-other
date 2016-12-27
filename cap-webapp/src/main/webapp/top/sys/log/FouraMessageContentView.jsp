<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>报文消息查看</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
</head>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">报文消息查看</div>
		<div id="top_float_right" class="thw_operate" style="margin-right: 12px;"   >
			<span uitype="button" label="关闭"  id="close" on_click="closeWin"></span>
		</div>
	</div>
	<div class="top_content_wrap">
		<table class="form_table">
			<tr>
			  <td> 
			  	<span id="messageContent" width="100%" height="340px" uitype="Textarea"  readonly="true" ></span>
			  	</td>           
             </tr>
		</table>
	</div>
<script type='text/javascript'>
var contactId = "<c:out value='${param.contentId}'/>";
var messageContent = "<c:out value='${param.messageContent}'/>";
window.onload = function(){
	//初始化页面
	comtop.UI.scan();
	cui("#messageContent").setValue(messageContent);
}
function closeWin(){
	window.top.cuiEMDialog.dialogs['MessageContentListDialog'].hide();
}
</script>
</body>
</html>
