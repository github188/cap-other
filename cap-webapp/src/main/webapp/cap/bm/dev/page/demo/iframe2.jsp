<%
/**********************************************************************
* 示例页面
* 2015-5-13 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>iframe子页面1</title>
    <link rel="stylesheet" href="lib/cui/themes/default/css/comtop.ui.min.css"/>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/comtop.cap.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/cui.utils.js"></script>
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/jct/js/jct.js"></script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/rt/common/base/js/comtop.cap.rt.js"></top:script>
    <script type="text/javascript">
	    var pageStorage = new cap.PageStorage("com.comtop.user");
    	function getIframeChildrenPageDate(){
    		var page = pageStorage.get("globalPage");
    		console.log(page);
    	}
    	
    	function openAWindow(){
    		window.open ('openwindow1.jsp','iframe2','height=600,width=800,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    	}
    </script>
</head>
<body>
     <button onclick="getIframeChildrenPageDate()">从iframe子页面2上去取数据</button>
     <button onclick="openAWindow()">open一个子页面</button>
     
</body>
</html>