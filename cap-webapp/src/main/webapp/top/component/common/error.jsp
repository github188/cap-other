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
<title>errorҳ��</title>
<top:link href="/top/component/common/error.css" />
</head>
<body>
	<div class="topui_error_custom">
		<div class="topui_error_warp">
			<h1>��ѽ����������</h1>
			<div class="topui_error_info">
				<c:choose>
					<c:when test="${empty exception.message}">
						<p>ϵͳ�����������������������ʱ�޷����� .</p>
					</c:when>
					<c:otherwise>

						<p class="topui_error_title">����ԭ��</p>
                        <p class="topui_error_text">${exception.message}</p>
						
						
					</c:otherwise>
				</c:choose>
				<p class="topui_error_help">��������������������⣬��ӭ��ʱ�������ǣ���������Ĳ����ʾǸ�⡣</p>
			</div>
		</div>
	</div>
</body>
</html>
