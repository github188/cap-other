<!DOCTYPE html>
<%@page isErrorPage="true" pageEncoding="GBK" contentType="text/html; charset=GBK"  %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.io.StringWriter"%>
<%@page import="java.io.PrintWriter"%>
<html>
<head>
	<title>errorҳ��</title>
	<top:link href="/top/component/common/error.css" /> 

<script type="text/javascript">
 /* var flag=1;
   function showError(){
	   if(flag==1){
	   document.getElementById("errorId").style.display="block"; 
	   document.getElementById("showHide").innerHTML="���������Ϣ";
	    flag=2;
	   }else{

		   document.getElementById("errorId").style.display="none"; 
		   document.getElementById("showHide").innerHTML="��ʾ������Ϣ";
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
                error - �����׳����쳣��
            </h1>
            <p>
                �����׳����쳣������ Web ������Ŀǰ�޷����� HTTP ����
            </p>
        </div>
        <div class="topui_error_box_font">
            <p>
                ��������������������⣬����������
            </p>
            <p>
                �Դ˲����Ĳ������Ǳ�ʾǸ��
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
                    	��ʾ������Ϣ
                </a>-->
            </p>
        </div>
    </div>
    
<!-- 	<div id="errorId" style="display: none; background-color:#F2F2F2;">
		<fieldset>
			<legend>
				<strong>ҳ�������Ϣ��<c:out value='${exception.message}'/></strong>
				&nbsp;&nbsp;
 
			</legend>
			<font color="red"><code><c:out value='${requestScope.exceStr}'/></code></font>
		</fieldset>
	</div> -->
</div>
</body>
</html>
