<%
/**********************************************************************
* ����װ�ؽ������
* 2015-3-11 ŷ���� �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<% 
   pageContext.setAttribute("cuiWebRoot",request.getContextPath());
%>
<!doctype html>
<html>
<head>
<title>����װ�ؽ������</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<div id="loadDetailDivId" style="color: red"></div>
<script type="text/javascript"><!--
var emptydata = [];
var loadId = "${param.loadId}";
var formdata={};
/**
 * ��ʼ��grid����
 */
function initLoadDetail(){
	var url = '<cui:webRoot/>/soa/SoaServlet/queryServiceLoadDetail?operType=queryServiceLoad&loadId='+loadId+'&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
        	 //var emptydata = jQuery.parseJSON(data);
        	 var a=document.getElementById("loadDetailDivId");
        	 if (checkStrEmty(data)) { 
        		 a.innerText="   ��";
        	 }else{
        		 a.innerText=data;
        	 }
          },
         error: function (msg) {
		         cui.message('��������ʧ�ܡ�', 'error');
              }
     });
}
window.onload = function(){
	initLoadDetail();
}
--></script>
</body>
</html>
