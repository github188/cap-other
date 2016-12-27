<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title>统一工作台</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
    </head>
    <body>
        <%@ include file="/top/workbench/base/MainNav.jsp"%>
        <iframe id="mainFrame"  name="mainFrame" src="about:blank" style="border:0px;width:100%;"></iframe>
        <script>
            require(['autoIframe'], function() {
                $('#mainFrame').autoFrameHeight('${param.url}');
            });
        </script>
    </body>
</html>