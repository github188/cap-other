<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<html>
<head>
    <title>登录-中国南方电网</title>
    <%//360浏览器指定webkit内核打开%>
    <meta name="renderer" content="webkit">
    <%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
    <meta http-equiv="x-ua-compatible" content="IE=edge" >
    <link rel="shortcut icon" href="${pageScope.cuiWebRoot}/top/workbench/base/img/logo.ico">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/login/css/login.css?v=<%=version%>"/>
    <c:if test="${param.loginPictureId!=null && param.loginPictureId!=''}">
        <style type="text/css">
            /* 更换背景图片 */
            html{
                background-image:url("${pageScope.cuiWebRoot}/top/workbench/loginpicture/display.ac?id=${param.loginPictureId}");
            }
        </style>
    </c:if>
</head>
<body>
    <div class="top-bar">
        <h2 class="workbench-logo"></h2>
        <a id="addFav" href="#" class="fav" hidefocus="true"><i>＋</i><span>点击收藏</span></a>
    </div>
    <div class="contact">
        <div class="login-wrap">
            <h2 id="chineseSystemName">系统名称</h2>
            <div id="loginTip" class="login-tip">请输入有效的用户名或密码！</div>
            <form id="loginForm" class="login-form" method="post">
                <input type="hidden" id="mainUrl" name="mainUrl" />
                <!-- value="<c:out value='${param.url}'/>" -->
                <input type="hidden" id="url" name="url" value="<c:out value='${param.url}'/>"/>
                <div id="loginUserName" class="login-input-wrap">
                    <span>用户名</span>
                    <div><input id="userName" name="account" type="text" value="<c:out value='${param.account}'/>"></div>
                </div>
                <div id="loginPassWord" class="login-input-wrap">
                    <span>密码</span>
                    <div>
                        <input id="passWordHidden" name="password" type="hidden" value="">
                        <input id="passWord" name="password" type="password" value="">
                    </div>
                </div>
            </form>
            <div class="login-entries">
                <label for="rememberMe" hidefocus="true">
                    <input type="checkbox" name="" id="rememberMe"/>
                    记住我
                </label>
            </div>
            <a id="loginBtn" href="javascript:;" hidefocus="true" class="login-btn">登录</a>
            <p class="forget-password-tip" id="forget-password-tip"></p>
        </div>
        <div class="login-wrap-ie6"></div>
    </div>
    <div class="footer-bar">
        <p>Copyright&copy;&nbsp;1999-2014&nbsp;Shenzhen&nbsp;Comtop&nbsp;Co.,Ltd.</p>
        <p>深圳市康拓普信息技术有限公司</p>
        <div class="footer-bar-ie6"></div>
    </div>
</body>
</html>