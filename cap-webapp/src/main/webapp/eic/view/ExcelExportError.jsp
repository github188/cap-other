<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/eic/view/I18n.jsp" %>
<html>
<head>
<title><fmt:message key="operationFailed_Title" /></title>
<meta http-equiv="Content-Type" content="text/html charset=gbk">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/eic/css/eic.css">
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
<script language="javascript">
            var _pt = window.top.cuiEMDialog.wins;
		    if(null != _pt.exportDialog){
		    	_pt.isDelExportDialog = true;
		    	_pt.exportDialog.exportDialog.setTitle("<fmt:message key="abnormalInformation" />");
			}
			var errorInfo = decodeURIComponent("<%=request.getParameter("errorInfo")%>");
			$(function(){
				if(errorInfo!=null && errorInfo!="null" && errorInfo.length>0){
					$(".note").html(decodeURIComponent(errorInfo));
				}
			});
</script>
<style type="text/css">
html,body {
	margin:0;
	height:100%;
}

body {
 
	font: 12px/ 1.5 Arial, "宋体", Helvetica, sans-serif;
	
}

.header_wrap {
	border-top: 1px solid #BFCFDA;
	padding: 5px 0 0 0;
	height: 25px;
}

.thw_title {
	float: left;
	font: 12px "宋体";
	margin-top: 10px;
	margin-left: 5px;
	font-weight: bold;
	color: #333;
}

.thw_operate {
	float: right;
	padding: 0 6px;
}

.content_wrap {
	padding: 12px 12px 0 12px;
	height: 60px;
	background-color: #FFFFFF;
}

.note {
    *zoom:1;
	font-size: 12px;
	font-family: "宋体", Arial, Sans;
	color: #333;
	word-wrap: break-word;
	margin-left: 35px;
	margin-top: -25px;
}

.icon {
	width: 30px;
	height: 30px;
	margin-top: 10px;
	background: url(../images/c-icon-1.png) no-repeat 0 -180px;
}
</style>
</head>
<body>
<div class="content_wrap">
<div style="padding: 0; margin: 0">
<div class="icon"></div>
<div class="note">&nbsp;&nbsp;</div>
</div>
</div>
</body>
</html>