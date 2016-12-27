
<%
    /**********************************************************************
			 * �ͻ��˻������ݾݼ�������Ȩ����
			 * 2014-10-10 ��Сǿ �½�
			 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<%
    pageContext.setAttribute("cuiWebRoot", request.getContextPath());
%>
<!DOCTYPE html>
<html>
<head>
<title>�ͻ�����֤ά��</title>
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
				<td id="wsAUthorStatusSpanId" style="font-size: 12px" width="35%">&nbsp;</td>
				<td style="text-align: right; padding-top: 10px; padding-right: 5px;" width="35%">
				<cui:button id="editButton" label="���ӿͻ���" icon="${cuiWebRoot}/soa/css/img/add.bmp" on_click="addClient"></cui:button>
				<cui:button id="editButton" label="ɾ���ͻ���" on_click="deleteClient"></cui:button>
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
					<th renderStyle="text-align: left" style="width: 41%;"
						bindName="name">�ͻ�������</th>
					<th renderStyle="text-align: left" style="width: 10%;"
						render="renderTypeData">����</th>
					<th renderStyle="text-align: left" style="width: 25%;"
						bindName="ip1">ip��ַ</th>
					<th renderStyle="text-align: center" style="width: 11%;"
						bindName="prot">�˿�</th>
					<th renderStyle="text-align: left" style="width: 8%;"
						render="renderOptions">����</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
//��Ȩ�ͻ�����֤
function addClientAuth(){
	var clientIds = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(clientIds)){
		cui.alert('��ѡ��һ���ͻ��˼�¼��');
		return;
	}
	   var url = '<cui:webRoot/>/soa/servicemanage/ClientRelNoWsList.jsp?clientIds='+clientIds+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "��������ͻ�����Ȩ",
		src : url,
		width: 550,
		height: 500
	    }).show();
}
//�����ͻ�����Ϣ
function addClient(){
   var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoEdit.jsp?timeStamp='+ new Date().getTime();
    cui("#addServiceDialog").dialog({
	modal: true, 
	title: "���ӽ���ͻ���",
	src : url,
	width: 550,
	height: 280
    }).show();
}
//�༭�ͻ�����Ϣ
function editClient(clientId,name,ip1,prot,type,memo){
	   var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoEdit.jsp?clientId='+clientId
	   +'&name='+name+'&ip1='+ip1+'&prot='+prot+'&type='+type+'&memo='+memo+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "���ӽ���ͻ���",
		src : url,
		width: 550,
		height: 280
	    }).show();
	}
var renderOptions = function (rd, index, col){
	 var editHtml='<img height="20px" width="16px" title="�༭" src="<cui:webRoot/>/soa/css/img/edit.png" onClick="editClient(\''+rd.clientId+'\',\''+rd.name+'\',\''+rd.ip1+'\',\''+rd.prot+'\',\''+rd.type+'\',\''+rd.memo+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
   if(rd.type=="2"){	
	   editHtml=editHtml+'<img height="16px" width="16px" title="�鿴Ȩ��" src="<cui:webRoot/>/soa/css/img/editAc.png" onClick="viewRel(\''+rd.clientId+'\');" style="cursor: hand"/>';
	}
	return editHtml;
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

//ɾ���ͻ���
function deleteClient(){
	var clientId = cui('#cui_grid_list').getSelectedPrimaryKey();
	var clientName = cui("#keyword").getValue();
	if (checkStrEmty(clientId)){
		cui.alert('��ѡ��һ����¼��');
		return;
	}
    cui.confirm('<font color="red">ȷ��Ҫ����ɾ������?</font>', {
        onYes: function () {
        	var url = '<cui:webRoot/>/soa/SoaServlet/deleteClientById?operType=deleteClientById&clientId='+clientId+'&clientName='+clientName+'&timeStamp='+ new Date().getTime();
            //����ajax�����ύ
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            	         cui('#cui_grid_list').loadData();
            	         cui.message('ɾ���ɹ���', 'success');
                  },
                 error: function (msg) {
        		         cui.message('ɾ��ʧ�ܡ�', 'error');
                      }
             });
        },
        onNo: function () {
        }
    });

}
function viewRel(clientId){
	 var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoDetailRel.jsp?clientIds='+clientId+'&timeStamp='+ new Date().getTime();
	    cui("#ClientInfoDetailRel").dialog({
		modal: true, 
		title: "�ͻ���Ȩ���б�",
		src : url,
		width: 600,
		height: 350
	    }).show();
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
    	 	  renderOperate();
    	   }else{
    		   obj.setDatasource([]);
    	   }

          },
         error: function (msg) {
		         cui.message('��������ʧ�ܡ�', 'error');
              }
     });
}


function renderOperate(){
	var url = '<cui:webRoot/>/soa/SoaServlet/queryWsAuthorStatus?operType=queryWsAuthorStatus&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){       
    		updateStatusButton(data);
          },
         error: function (msg) {
		         cui.message('��������ʧ�ܡ�', 'error');
              }
     });
}
function updateStatusButton(data){
	var span = document.getElementById("wsAUthorStatusSpanId");
	if(data == "1"||data==1){
		
		span.innerHTML= "&nbsp;WS�����֤����:&nbsp;<span style=\"color: green\">�Ѵ�</span>&nbsp;<input type='button' style='background:#00ff00;cursor:pointer;border:1px solid rgba(0,0,0,0.21);' value='ͣ�÷���' onClick='setWsNeedStatus(\"0\")'>";
	}else if (data == "0"||data==0){
		span.innerHTML=  "&nbsp;WS�����֤����:&nbsp;<span style=\"color: red\">�ѹر�</span>&nbsp;<input type='button' style='background:#F32E2E;cursor:pointer;border:1px solid rgba(0,0,0,0.21);' value='���÷���' onClick='setWsNeedStatus(\"1\")'>";
	}else{
		span.innerHTML= "��ȡʧ��";
	}
}

function setWsNeedStatus(status){
	var url = '<cui:webRoot/>/soa/SoaServlet/updateWsAuthorStatus?operType=updateWsAuthorStatus&SoaClientRquestWSAuthSwitch='+status+'&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    		updateStatusButton(data);
          },
         error: function (msg) {
		         cui.message('����ʧ�ܡ�', 'error');
              }
     });
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
