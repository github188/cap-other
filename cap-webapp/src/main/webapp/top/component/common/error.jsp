<!doctype html>
<%@page isErrorPage="true" pageEncoding="GBK" contentType="text/html; charset=GBK"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page import="java.io.StringWriter"%>
<%@page import="java.io.PrintWriter"%>
<html>
<head>
<meta charset="utf-8">
<title>error页面</title>
<top:link href="/top/component/common/error.css" />
</head>
<body>
	<div class="topui_error_custom">
		<div class="topui_error_warp">
			<h1>哎呀！出错啦！</h1>
			<div class="topui_error_info">
				<c:choose>
					<c:when test="${empty exception.message}">
						<p>系统出错啦！您的请求服务器暂时无法处理 .</p>
					</c:when>
					<c:otherwise>

						<p class="topui_error_title">可能原因：</p>
                        <p class="topui_error_text">${exception.message}</p>
						
						
					</c:otherwise>
				</c:choose>
				<p class="topui_error_help">如果您持续遇到这类问题，欢迎随时联络我们，给你带来的不便表示歉意。</p>
			</div>
		</div>
	</div>
</body>
</html>
