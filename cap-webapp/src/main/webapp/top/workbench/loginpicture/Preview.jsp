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
    <title>��¼-�й��Ϸ�����</title>
    <%//360�����ָ��webkit�ں˴�%>
    <meta name="renderer" content="webkit">
    <%//�ر�ie����ģʽ,ʹ����߰汾�ĵ�ģʽ��Ⱦҳ��%>
    <meta http-equiv="x-ua-compatible" content="IE=edge" >
    <link rel="shortcut icon" href="${pageScope.cuiWebRoot}/top/workbench/base/img/logo.ico">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/login/css/login.css?v=<%=version%>"/>
    <c:if test="${param.loginPictureId!=null && param.loginPictureId!=''}">
        <style type="text/css">
            /* ��������ͼƬ */
            html{
                background-image:url("${pageScope.cuiWebRoot}/top/workbench/loginpicture/display.ac?id=${param.loginPictureId}");
            }
        </style>
    </c:if>
</head>
<body>
    <div class="top-bar">
        <h2 class="workbench-logo"></h2>
        <a id="addFav" href="#" class="fav" hidefocus="true"><i>��</i><span>����ղ�</span></a>
    </div>
    <div class="contact">
        <div class="login-wrap">
            <h2 id="chineseSystemName">ϵͳ����</h2>
            <div id="loginTip" class="login-tip">��������Ч���û��������룡</div>
            <form id="loginForm" class="login-form" method="post">
                <input type="hidden" id="mainUrl" name="mainUrl" />
                <!-- value="<c:out value='${param.url}'/>" -->
                <input type="hidden" id="url" name="url" value="<c:out value='${param.url}'/>"/>
                <div id="loginUserName" class="login-input-wrap">
                    <span>�û���</span>
                    <div><input id="userName" name="account" type="text" value="<c:out value='${param.account}'/>"></div>
                </div>
                <div id="loginPassWord" class="login-input-wrap">
                    <span>����</span>
                    <div>
                        <input id="passWordHidden" name="password" type="hidden" value="">
                        <input id="passWord" name="password" type="password" value="">
                    </div>
                </div>
            </form>
            <div class="login-entries">
                <label for="rememberMe" hidefocus="true">
                    <input type="checkbox" name="" id="rememberMe"/>
                    ��ס��
                </label>
            </div>
            <a id="loginBtn" href="javascript:;" hidefocus="true" class="login-btn">��¼</a>
            <p class="forget-password-tip" id="forget-password-tip"></p>
        </div>
        <div class="login-wrap-ie6"></div>
    </div>
    <div class="footer-bar">
        <p>Copyright&copy;&nbsp;1999-2014&nbsp;Shenzhen&nbsp;Comtop&nbsp;Co.,Ltd.</p>
        <p>�����п�������Ϣ�������޹�˾</p>
        <div class="footer-bar-ie6"></div>
    </div>
</body>
</html>