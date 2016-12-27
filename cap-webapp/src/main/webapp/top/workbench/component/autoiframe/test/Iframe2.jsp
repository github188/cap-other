<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.slf4j.org/taglib/tld" prefix="log"%> 
<%@ taglib uri="http://www.szcomtop.com/top" prefix="top"%>
<%@ page contentType="text/html; charset=GBK" %>
<%@page import="com.comtop.top.component.common.systeminit.ServerConstant"%>
<%@page import="com.comtop.top.sys.login.util.LoginConstant"%>
<%@page import="com.comtop.top.sys.usermanagement.user.model.UserDTO"%>
<top:noCache/>
<%      
    response.setHeader("Content-Type", "text/html; charset=GBK");
    request.setCharacterEncoding("GBK");
    pageContext.setAttribute("pageEncoding", "GBK");
    UserDTO objUserDTO =(UserDTO)session.getAttribute(LoginConstant.SECURITY_CURR_USER_INFO_KEY);
    pageContext.setAttribute("userInfo",objUserDTO);
    pageContext.setAttribute("cuiWebRoot",request.getContextPath());
%>
<script language="javascript">
    var globalUserId ='${userInfo.userId}';
    var globalUserName ='${userInfo.employeeName}';
    var globalOrganizationId ='${userInfo.orgId}';
    var globalOrganizationName ='${userInfo.orgName}'; 
    var webPath = '<top:webRoot/>';
</script>
<log:debug category="jsp.request">
  <!-- ƽ̨�汾:<%=ServerConstant.VERSION%>,ƽ̨��������:<%=ServerConstant.PULISH_DATE%> -->
 <top:info type="url"/>
</log:debug>
<html>
    <head>
        <title>��ѯ����-�й��Ϸ�����</title>
        <%@ include file="/top/workbench/base/Header.jsp" %>
    </head>
    <body>
        <div style="height:112px;background:green;color:white;font-size:16px;text-align:center">
                                        �ڲ�iframe<br/>
            <button onclick="addHeight(50)">����50px</button>
            <button onclick="addHeight(-50)">����50px</button><br/>
            <button onclick="addAnimate(50)">��������50px</button>
            <button onclick="addAnimate(-50)">��������50px</button><br/>
            <button onclick="addResize(false)">�Ƴ�resize�¼�</button>
            <button onclick="addResize(true)">���resize�¼�</button><input id="resizeHeight" value="112" style="width:60px">
        </div>
        <div id="main" style="height:100px;background:yellow;color:black;font-size:24px;text-align:center">��������Ӧ
        </div>
        <script>
            var isResize = false;
            window.onresize = function(){
                //console.log('inner resize');
                if(isResize){
                    $('#main').height($(window).height()-$('#resizeHeight').val());
                }
                console.log('document.scrollHeight:' + document.documentElement.scrollHeight);
                console.log('body.scrollHeight:' + document.body.scrollHeight);
            };
            
            //$('#main').height($(window).height()-112);
            function addHeight(h){
                $('#main').height($('#main').height() + h);
            }
            function addAnimate(h){
                $('#main').animate({height:$('#main').height() + h});
            }
            function addResize(flag){
                isResize = flag;
            }
        </script>
    </body>
</html>