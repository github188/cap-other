<!DOCTYPE html>
<%@page isErrorPage="true" pageEncoding="GBK" contentType="text/html; charset=GBK"  %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.io.StringWriter"%>
<%@page import="java.io.PrintWriter"%>
<html>
<head>
	<title>error页面</title>
	<top:link href="/top/component/common/error.css" /> 

<script type="text/javascript">
 /* var flag=1;
   function showError(){
	   if(flag==1){
	   document.getElementById("errorId").style.display="block"; 
	   document.getElementById("showHide").innerHTML="收起错误信息";
	    flag=2;
	   }else{

		   document.getElementById("errorId").style.display="none"; 
		   document.getElementById("showHide").innerHTML="显示错误信息";
		    flag=1;
	   }
	   
   }*/
</script>	
<%
/* if(null!=exception){
   StringWriter objSW = new StringWriter();  
   exception.printStackTrace(new PrintWriter(objSW)); 
   request.setAttribute("exceStr",objSW.toString());
  }*/
%>
</head>
<body class="topui_error_bg" style="width:auto;height:auto;">
<div class="topui_error">
    <div class="topui_error_boxErr">
        <div class="topui_error_box_line">
            <h1>
                error - 程序抛出了异常。
            </h1>
            <p>
                程序抛出了异常，您的 Web 服务器目前无法处理 HTTP 请求
            </p>
        </div>
        <div class="topui_error_box_font">
            <p>
                如果您持续遇到这类问题，请联络我们
            </p>
            <p>
                对此产生的不便我们表示歉意
            </p>
            <p>
                &nbsp;
            </p>
            <p>
                &nbsp;
            </p>
            <p>
 
<!--                 &nbsp;&nbsp; 
                <a href="javascript:showError();" id="showHide">
                    	显示错误信息
                </a>-->
            </p>
        </div>
    </div>
    
<!-- 	<div id="errorId" style="display: none; background-color:#F2F2F2;">
		<fieldset>
			<legend>
				<strong>页面错误信息：<c:out value='${exception.message}'/></strong>
				&nbsp;&nbsp;
 
			</legend>
			<font color="red"><code><c:out value='${requestScope.exceStr}'/></code></font>
		</fieldset>
	</div> -->
</div>
</body>
</html>
