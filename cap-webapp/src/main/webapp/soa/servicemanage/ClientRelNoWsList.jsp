<%
/**********************************************************************
* webservice�����б�--���ڿͻ�����Ȩ
* 2014-10-13 ��Сǿ  �½�
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
<title>WS�����б��ͻ�����Ȩ����</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="50" collapsable="false">
			<table id="panelWidth">
				<tr height="20" >
				   <td style="padding-left: 5px;padding-top: 10px;" width="30%">
						<cui:clickinput editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" 
							emptytext="�������������ѯ" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" 
							width="350" on_keydown="keyDownQuery"/>
					</td>
					<td style="text-align: right;padding-top: 10px;padding-right: 5px;" width="70%">
						<cui:button id="editButton" label="ȷ&nbsp;��" on_click="addRelWebService"></cui:button>
					</td>	
				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="5px 5px 5px 5px"
		height="400">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"
			gridwidth="500px" datasource="initGridData" primarykey="code" resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
				 	<th  style="width: 10%;"><input type="checkbox"/></th>
					<th renderStyle="text-align: left" style="width: 45%;" bindName="code">WS�������</th>
					<th renderStyle="text-align: left" style="width: 45%;" bindName="serviceName">WS��������</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var clientIds = "${param.clientIds}";
//��ѯ����
function fastQuery(){
	var serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientNoWebServices?operType=queryClientNoWebServices&timeStamp='+ new Date().getTime();
  //����ajax�����ύ
  $.ajax({
       type: "POST",
       url: url,
       contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
       data:{'clientId':clientIds,'serviceCode':serviceCode},
       beforeSend: function(XMLHttpRequest){
        	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
        },
       success: function(data,status){
  	     var emptydata = jQuery.parseJSON(data);
  	    //grid���ݷ�ҳ
  	 	cui('#cui_grid_list').setDatasource(emptydata,emptydata.length);
        },
       error: function (msg) {
		         cui.message('��ѯ����ʧ�ܡ�', 'error');
            }
   });
}
function addRelWebService(){
	var ids = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(ids)){
		cui.alert('��ѡ��һ����¼��');
		return;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/addClientwebseviceRel?operType=addClientwebseviceRel&clientIds='+clientIds+'&wsCodes='+ids+'&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
        	     window.parent.cui('#cui_grid_list').loadData();
    	         window.parent.cui.message('��Ȩ�ɹ���', 'success');
    	         window.parent.location.href='<cui:webRoot/>/soa/servicemanage/ClientInfoDetailRel.jsp?clientIds='+clientIds;
          },
         error: function (msg) {
		         cui.message('��Ȩʧ�ܡ�', 'error');
              }
     });
    
}
//�������Ӧ
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-15;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}
/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientNoWebServices?operType=queryClientNoWebServices&clientId='+clientIds+'&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	   var emptydata = jQuery.parseJSON(data);
	       //grid���ݷ�ҳ
	 	   obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
          },
         error: function (msg) {
		         cui.message('���ط���ʧ�ܡ�', 'error');
              }
     });
}

window.onload = function(){	
	comtop.UI.scan();   //ɨ��
	$('#panelWidth').width(getBodyWidth());
}
--></script>
</body>
</html>
