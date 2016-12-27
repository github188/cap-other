<%
  /**********************************************************************
			 * Ìø×ªµ½µÇÂ¼Ò³Ãæ
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
</head>
<body>
	<script type="text/javascript">
    var url = "<c:out value='${param.url}'/>";
	window.onload = function(){
		if(url){
			window.location.replace("<top:webRoot/>/initLogin.ac?url="+url);
		}else{
			window.location.replace("<top:webRoot/>/initLogin.ac");
		}
	}
	</script>
</body>
</html>
