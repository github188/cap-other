<!DOCTYPE html>
<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%response.setStatus(HttpServletResponse.SC_OK);%>
<html>
<head>
	<title>找不到页面</title>
<top:link href="/top/component/common/error.css" /> 
</head>
<body  class="topui_error_bg" style="width:auto;height:auto;">
<div class="topui_error">
    <div class="topui_error_box404">
        <div class="topui_error_box_line">
            <h1>
                 页面不存在。
            </h1>
            <p>
                	服务器上找不到您请求的页面
            </p>
        </div>
        <div class="topui_error_box_font">
            <p>
                	如果您持续遇到这类问题，请联络我们
            </p>
            <p>
                	对此产生的不便我们表示歉意
            </p>

        </div>
    </div>
</div>
</body>
</html>
