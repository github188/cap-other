<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<%//360浏览器指定webkit内核打开%>
<meta name="renderer" content="webkit">
<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
<meta http-equiv="x-ua-compatible" content="IE=edge" >


<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/platform/css/iSmartAbleWidget.css?v=<%=version%>"/>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/platform/css/task.css?v=<%=version%>"/>
<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/top/workbench/base/img/logo.ico">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/component/requirejs/require.config.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/dwr/engine.js?v=<%=version%>"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/workbench/dwr/util.js?v=<%=version%>'></script>



