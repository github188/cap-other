<%@ page contentType="text/html;charset=gb2312"%>
<%@ page import="java.util.*"%>
<%@ page import="com.comtop.top.component.app.sna.RemoteCache"%>
<%
//Random objRandom = new Random();
boolean result = false;
String strTestString = "testCacheConnnect";
long lStartTime = System.currentTimeMillis();
RemoteCache.put("testCacheConnnect_key", strTestString,30);
String strCacheValue = (String)RemoteCache.get("testCacheConnnect_key");
long lUsedTime = System.currentTimeMillis()-lStartTime;
if(null!=strCacheValue){
    result = true;
    //out.print(true);
}
%>

<html>
<head></head>
<body>
<br><br>
��⻺���ʱ: <%=lUsedTime%> ���롣
<br><br>
��⻺����: <%=result%>��
</body>
</html>

