<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/eic/view/I18n.jsp" %>
<html>
	<head>
		<title><fmt:message key="operationFailed_Title" /></title>
		<meta http-equiv="Content-Type" content="text/html charset=gbk">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/eic/css/eic.css">
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
		<script language="javascript">
		    var _pt = window.top.cuiEMDialog.wins;
		    var errorInfo = "<%=request.getAttribute("errorInfo") == null ? "" : request.getAttribute("errorInfo")%>";
			var error = unescape("<%=request.getParameter("errorInfo") == null ? "" :request.getParameter("errorInfo")%>");
			var url = "<%=request.getAttribute("returnUrl") == null ? "" : request.getAttribute("returnUrl")%>";
			if("" == url){
				url = "<%=request.getParameter("returnUrl")%>"
			}
			$(function(){
				if(errorInfo!=null && errorInfo!="null" && errorInfo.length>0){
					$(".note").text(errorInfo);
				}else if(error!=null && error!="null" && error.length>0){
					$(".note").text( error);
				}
			});

			function returnPage(){
				  document.location.href = url;
			}

			function colsePage(){
				if(null != _pt.taskMonitorDialog){
					_pt.taskMonitorDialog.hide();
					_pt.document.getElementById("eic_openTaskMonitorList_openDivId").style.display = "block";
				}
			}
		</script>
		<style type="text/css">
			html {
				overflow: visible;
			}
			
			body {
				margin: 0px;
				font: 12px/1.5 Arial, "宋体", Helvetica, sans-serif;
				background-color: #EFF1F6;
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
				height: 210px;
				background-color: #FFFFFF;
			}
			.note {
				font-size: 12px;
				font-family: "宋体", Arial, Sans;
				color: #333;
				word-wrap: break-word;
				margin-left: 35px;
				margin-top: -25px;
			}
			.icon{
				width : 30px;
				height: 30px;
				margin-top: 10px;
				background: url(<%=request.getContextPath()%>/eic/images/c-icon-1.png) no-repeat 0 -180px;
			}
		</style>
	</head>
	<body>
		<div class="content_wrap">
			<div style=" padding: 0;margin: 0">
				<div class="icon"></div><div class="note">&nbsp;&nbsp;</div>
			</div>
		</div>
		<div class="header_wrap">
			<div class="thw_operate">
				<a type="button" name="cancelBtn" id="cancelBtn" class="button_top" onclick="colsePage()" ><fmt:message key="close" /></a>
			</div>
		</div>
	</body>
</html>