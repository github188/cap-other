<%@page import="com.comtop.top.component.common.systeminit.TopServletListener"%>
<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>

<%@ page import="com.comtop.top.sys.login.filter.SSO4AWrapFilter" %>
<%@ page import="com.comtop.top.sys.login.filter.SSO4AFilterChain" %>
<%@ page import="com.sgcc.isc.ualogin.client.filter.IscSSOAuthenticationFilter" %>
<%@ page import="com.sgcc.isc.ualogin.client.filter.IsoSSOAssertionThreadLocalFilter" %>
<%@ page import="com.sgcc.isc.ualogin.client.filter.IscSSOHttpServletRequestWrapperFilter" %>
<%@ page import="com.sgcc.isc.ualogin.client.filter.IscSSO20ProxyReceivingTicketValidationFilter" %>
<%@ page import="org.jasig.cas.client.javafilter.authentication.Test4AFilter" %>
<%

   SSO4AFilterChain objChain = new SSO4AFilterChain();
   IscSSOAuthenticationFilter iscSSOAuthenticationFilter = new IscSSOAuthenticationFilter();
   IscSSO20ProxyReceivingTicketValidationFilter iscSSO20ProxyReceivingTicketValidationFilter = new IscSSO20ProxyReceivingTicketValidationFilter();
   IscSSOHttpServletRequestWrapperFilter iscSSOHttpServletRequestWrapperFilter = new IscSSOHttpServletRequestWrapperFilter();
   IsoSSOAssertionThreadLocalFilter isoSSOAssertionThreadLocalFilter = new IsoSSOAssertionThreadLocalFilter();
   


 %> 
<html>
<head></head>
<body>
4A��������ʱ��⿪ʼ...
<br><br>

<%
    long lStartTime = System.currentTimeMillis();
    long lStartTime1 = System.currentTimeMillis();
	try {
	    iscSSOAuthenticationFilter.init(SSO4AWrapFilter.getFilterConfig());
	    iscSSOAuthenticationFilter.doFilter(request, response, objChain);
	} catch (IOException e) {
	    e.printStackTrace();
	} catch (ServletException e) {
	    e.printStackTrace();
	}
	long lFilter1 = System.currentTimeMillis() - lStartTime1;
%>
iscSSOAuthenticationFilter��ʱ: <%=lFilter1%> ���롣
<br><br>
<%
	long lStartTime2 = System.currentTimeMillis();
	try {
	    iscSSO20ProxyReceivingTicketValidationFilter.init(SSO4AWrapFilter.getFilterConfig());
	    iscSSO20ProxyReceivingTicketValidationFilter.doFilter(request, response, objChain);
	} catch (IOException e1) {
	    e1.printStackTrace();
	} catch (ServletException e1) {
	    e1.printStackTrace();
	}
	long lFilter2 = System.currentTimeMillis() - lStartTime2;
%>
iscSSO20ProxyReceivingTicketValidationFilter��ʱ: <%=lFilter2%> ���롣
<br><br>
<%
	long lStartTime3 = System.currentTimeMillis();
	try {
	    iscSSOHttpServletRequestWrapperFilter.init(SSO4AWrapFilter.getFilterConfig());
	    iscSSOHttpServletRequestWrapperFilter.doFilter(request, response, objChain);
	} catch (IOException e1) {
	    e1.printStackTrace();
	} catch (ServletException e1) {
	    e1.printStackTrace();
	}
	long lFilter3 = System.currentTimeMillis() - lStartTime3;

%>
iscSSOHttpServletRequestWrapperFilter��ʱ: <%=lFilter3%> ���롣
<br><br>
<%
	long lStartTime4 = System.currentTimeMillis();
	try {
	    isoSSOAssertionThreadLocalFilter.init(SSO4AWrapFilter.getFilterConfig());
	    isoSSOAssertionThreadLocalFilter.doFilter(request, response, objChain);
	} catch (IOException e) {
	    e.printStackTrace();
	} catch (ServletException e) {
	    e.printStackTrace();
	}
	
	long lFilter4 = System.currentTimeMillis() - lStartTime4;
	long lFilter = System.currentTimeMillis() - lStartTime;
%>
isoSSOAssertionThreadLocalFilter��ʱ: <%=lFilter4%> ���롣
<br><br>
4A�������ܺ�ʱ: <%=lFilter%> ���롣
</body>
</html>