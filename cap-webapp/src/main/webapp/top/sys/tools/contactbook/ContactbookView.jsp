<%
	/**********************************************************************
	 * 
	 * 2012-10-24 �¼�ɽ  �½�
	 * 2013-2-22 ̷���� �ع�
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>ͨѶ¼����</title>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css" />
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css" />
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script> 
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/ContactbookAction.js"></script>

<style type="text/css">
.table {
	border: 1px solid #ccc;
	border-width: 1px 0 0 1px;
	width: 100%;
}

.table td {
	padding: 2px;
	border: 1px solid #ccc;
	border-width: 0 1px 1px 0;
	background: #fff;
}

.table .label {
	text-align: right;
	background: #1d67a6;
	color: #fff;
	width: 42px;
}

html,body {
	
}

.button_box {
	*margin-right: 6px;
}
</style>
</head>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">�鿴��ϵ����Ϣ</div>
		
	</div>
	<div class="top_content_wrap">
		<table class="form_table">
			<tr>    
			<td class="td_label" width="15%">��ϵ�� <span style="color: red">*</span></td>     
			<td class="td_content">
			  <td> 
			  <span id="contacter" ></span></td>
              </td>
              </tr>
              
              	<tr>    
			<td class="td_label" width="15%">��ϵ�绰<span style="color: red">*</span></td>     
			<td class="td_content">
			  <td> <span id="tel"  ></span></td>
              </td>
              </tr>
              
              	<tr>    
			<td class="td_label" width="15%">��ע  </td>     
			<td class="td_content">
			  <td> <span id="remark"  ></span></td>
              </td>
              </tr>
				
		</table>
	</div>
	

<script type='text/javascript'>

var contactId = "<c:out value='${param.contactId}'/>";
var menuData={};
var data = {};

window.onload = function(){
	//��ʼ��ҳ��
    if (contactId) {//�༭ҳ��
        dwr.TOPEngine.setAsync(false);
        ContactbookAction.readContactBook(contactId,function(contactpersonData){
        	
                    data = contactpersonData;     
                    $("#contacter").text(contactpersonData['contacter']);
                    $("#tel").text(contactpersonData['tel']);
                   if(contactpersonData['remark']==null){
                	   $("#remark").text(" ");
                   }else{
                	   $("#remark").text(contactpersonData['remark']);
                   }
               
        });
        dwr.TOPEngine.setAsync(true);
        $(".thw_title").html("�鿴ͨѶ¼��Ϣ");
    }
    comtop.UI.scan();
}








</script>
</body>
</html>