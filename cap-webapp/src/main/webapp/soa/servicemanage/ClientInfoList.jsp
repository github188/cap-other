
<%
    /**********************************************************************
			 * �ͻ��˷�����Ȩҳ��
	**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<%
    pageContext.setAttribute("cuiWebRoot", request.getContextPath());
%>
<!doctype html>
<html>
<head>
<title>�ͻ�������ҳ��</title>
<cui:link
	href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css" />
<cui:link href="/soa/css/soa.css" />
<cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js" />
<cui:script src="/soa/js/jquery.min.js" />
<cui:script src="/soa/js/soa.common.js" />
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px"
		height="50" collapsable="false">
		<table id="panelWidth">
			<tr height="20">
				<td style="padding-left: 5px; padding-top: 10px;" width="30%">
				<cui:clickinput editable="true" id="keyword" name="keyword"
					on_iconclick="fastQuery" emptytext="������ͻ������Ʋ�ѯ" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" width="260"
					on_keydown="keyDownQuery" /></td>
					<td class="thw_operate">
					<td style="text-align: right;padding-top: 10px;padding-right: 5px;" width="70%">
				     <cui:button id="addClientAuthButton" label="ȷ��"  on_click="saveClientAuth"></cui:button>
					</td>
				</td>
			</tr>
		</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"
			gridwidth="900px" datasource="initGridData" primarykey="clientId"
			resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
					<th style="width: 5%;"><input type="checkbox" /></th>
					<th renderStyle="text-align: left" style="width: 45%;" bindName="name">�ͻ�������</th>
					<th renderStyle="text-align: left" style="width: 15%;" render="renderTypeData">����</th>
					<th renderStyle="text-align: left" style="width: 25%;" bindName="ip1">ip��ַ</th>
					<th renderStyle="text-align: center" style="width: 10%;" bindName="prot">�˿�</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var wsCodes = "${param.wsCode}";
/**
 * ��ӿͻ���Ȩ��
 */
function saveClientAuth(){
	var clientIds = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(clientIds)){
		cui.alert('��ѡ��һ����¼��');
		return;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/addClientwebseviceRel?operType=addClientwebseviceRel&clientIds='+clientIds+'&wsCodes='+wsCodes+'&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	         cui('#cui_grid_list').loadData();
    	         cui.message('��Ȩ�ɹ���', 'success');
          },
         error: function (msg) {
		         cui.message('��Ȩʧ�ܡ�', 'error');
              }
     });
}
//��ѯ����
function fastQuery(){
	var clientName = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientByPage?operType=queryClientByPage&timeStamp='+ new Date().getTime();
  //����ajax�����ύ
  $.ajax({
       type: "POST",
       url: url,
       contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
       data:{'clientName':clientName},
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

//�������Ӧ
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-5;
}

/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){

	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientByPage?operType=queryClientByPage&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	   var emptydata = jQuery.parseJSON(data);
    	   if(emptydata){
    	       //grid���ݷ�ҳ
    	 	   obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
    	   }else{
    		   obj.setDatasource([]);
    	   }

          },
         error: function (msg) {
		         cui.message('��������ʧ�ܡ�', 'error');
              }
     });
}
var renderTypeData=function(rd, index, col){
	if(rd.type=="1"){
		return "<span style=\"color:green;\">������</span>";
	}else if(rd.type=="2"){
		return "��ͨ�ͻ���";
	}else if(rd.type=="3"){
		return "<span style=\"color:red\">������</span>";
	}
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}
window.onload = function(){	
	comtop.UI.scan();   //ɨ��
	$('#panelWidth').width(getBodyWidth());
}
--></script>
</body>
</html>
