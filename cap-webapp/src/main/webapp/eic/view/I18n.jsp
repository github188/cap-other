<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="com.comtop.eic.core.util.PropertiesUtils"%>
<%
	String locale = PropertiesUtils.getValue("locale");
	if("".equals(locale) || locale == null){
		String language = Locale.getDefault().getLanguage();
		String country = Locale.getDefault().getCountry();
		locale = language + "_" + country;
	}
	session.setAttribute("lan",locale);
%>
<fmt:setLocale value="${sessionScope.lan}"/>
<fmt:setBundle basename="com.i18n.eic_messages"/>
