
<%
    /**********************************************************************
	 * ��ϵ���б�
	 * 2014-07-15 л��  �½�
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>��ϵ�˲鿴</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactPersonAction.js"></script>
</head>

<body>
	<div class="top_header_wrap">
		<div class="thw_title">�鿴��ϵ����Ϣ</div>
		
	</div>
	</div>
	<div class="top_content_wrap">
	
	<table class="form_table"  >
		<tr>
			<td class="td_label" width="12%">��ϵ����Ϣ ��</td>
			<td class="td_content">
			<td>
				<span id="contactContent"></span>
			</td>
		</td>
		</tr>
		<tr>
			<td class="td_label" width="12%">����ʱ�� ��</td>
			<td class="td_content">
			<td>
				<span id="updateTime"></span>
			</td>
		</td>
		</tr>
	</table>
	</div>
	
<script language="javascript">

var contactId = "<c:out value='${param.contactId}'/>";
var menuData={};
var data = {};

	window.onload = function(){
	    if (contactId) {
	        dwr.TOPEngine.setAsync(false);
	   
	        ContactPersonAction.readContactPerson(contactId,function(contactpersonData){	        	
	            data = contactpersonData;	  
	           
	            $("#contactContent").text(contactpersonData['contactContent']);
	        	$("#updateTime").text(contactpersonData['updateTime']);
	        });
	        dwr.TOPEngine.setAsync(true);
	        $(".thw_title").html("�鿴��ϵ����Ϣ");
	    }
	}
	
	 //grid���
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 680;
	} 
	
	//grid�߶�
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 500;
	}  
	
</script>
</body>
</html>
