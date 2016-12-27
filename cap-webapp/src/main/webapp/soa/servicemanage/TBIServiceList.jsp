<%
/**********************************************************************
* ��������������
* 2014-9-18 �ƿ��� �½�
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
<title>�����������</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="51" collapsable="false">
			<table id="panelWidth" class="cui_grid_list">
				<tr height="20" >
				   <td width="35%" style="padding-left: 5px;padding-top: 10px;">
						<cui:clickinput editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" 
							emptytext="������WS���롢WS��������ѯ" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" 
							width="100%" on_keydown="keyDownQuery"/>
					</td>
					<td width="65%" style="text-align: right;padding-top: 10px;padding-right: 5px;">
				     <cui:button id="openclientMainButton" label="�ͻ�����֤ά��"   on_click="openClientMain"></cui:button>
					</td>
				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px" height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no"
			gridwidth="900px" datasource="initGridData" primarykey="code" resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
				  <th renderStyle="text-align: left" style="width: 15%;" bindName="code" render="renderCode">WS����</th>
				  <th renderStyle="text-align: left" style="width: 15%;" bindName="sysName" render="renderSysName">����ϵͳ</th>
					<th renderStyle="text-align: left" style="width: 15%;" bindName="serviceName">WS������</th>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="methodCode">����Ԫ��(SID)</th>
					<th renderStyle="text-align: center" style="width: 5%;" bindName="flag" render="renderFlage">����״̬</th>
					<th renderStyle="text-align: left" style="width: 20%;"  bindName="wsClassAddress">����������</th>
					<th renderStyle="text-align: center" style="width: 10%;" render="renderOperate">����</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var dirCode = "${param.dirCode}";
var dirName = "${param.dirName}";
var sysCode = "${param.sysCode}";
var serviceCode="";
function renderCode(rowData){
    var wsdl=rowData.wsdl;
    var indstr=wsdl.substring(0,1);
    if(indstr=='/'){
  	    wsdl=wsdl.substring(1,wsdl.length);
    }
		return '<a title=\"����鿴wsdl\" href=\"javascript:void window.open(\''+wsdl+'\')\">'+rowData.code+'</a>';
}
function renderSysName(rowData){
	if(checkStrEmty(rowData.sysName)){
		return '<font color="red" size="2">δ����ҵ��ϵͳ</font>';
	}else {
		return rowData.sysName;
	}
}

function renderFlage(rowData){
	if(rowData.flag === '1'){
		return '������';
	}else if (rowData.flag === '0'){
		return '<font color="red" size="2">ͣ��</font>';
	}
}
var renderOperate = function (rd, index, col){
	var strStateName="��������";
	var startPng="stop.png";
	if(rd.flag === '1'){
		strStateName="ֹͣ����";
		startPng="start.png";
	}
	 var editHtml='<img height="18px" width="16px" title="�༭" src="<cui:webRoot/>/soa/css/img/edit.png" onClick="editHtml(\''+rd.methodCode+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editHtml=editHtml+'<img height="18px" width="16px" title="�ӿڲ���" src="<cui:webRoot/>/soa/css/img/sendReq.png" onClick="testConnectivity(\''+rd.code+'\',\''+rd.wsdl+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editHtml=editHtml+'<img height="15px" width="13px" title="'+strStateName+'" src="<cui:webRoot/>/soa/css/img/'+startPng+'" onClick="updateWsStateConfirm(\''+rd.code+'\',\''+rd.flag+'\');" style="cursor: hand"/>';
	return editHtml;
} 
//��Ȩ�ͻ�����֤
function addClientAuth(){
	var wsCode = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(wsCode)){
		cui.alert('��ѡ��һ�������¼��');
		return;
	}
	   var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoList.jsp?wsCode='+wsCode+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "��������ͻ�����Ȩ",
		src : url,
		width: 700,
		height: 550
	    }).show();
}
//�򿪿ͻ�����֤ά��ҳ��
function openClientMain(){
	   var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoMain.jsp?timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "�ͻ�����֤ά��",
		src : url,
		width: 780,
		height: 480
	    }).show();
}

//�༭WebServiceҳ��
function editHtml(methodCode){
	   var url = '<cui:webRoot/>/soa/servicemanage/TBIServiceEdit.jsp?methodCode='+methodCode+'&sysCode='+sysCode+'&pageNo='+page.pageNo+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "�༭��������",
		src : url,
		width: 620,
		height: 405
	    }).show();
}
//����������ͨ�Բ���
function testConnectivity(code,wsdl){
	var url = '<cui:webRoot/>/soa/servicemanage/TBIServiceConnectivity.jsp?code='+code+'&wsdl='+wsdl+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "����������ͨ�Բ���",
		src : url,
		width: 780,
		height: 460
	    }).show();
}

//�������Ӧ
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
}
var page={pageNo:1};
var pageNo="${param.pageNo}";
//��ѯ����
function fastQuery(){
	 page.pageNo=1;
	 initGridData(cui('#cui_grid_list'),page);
}
/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
    page=query;
	serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryTBIWebservice?operType=queryTBIWebservice&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "POST",
         url: url,
         contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
         data:{'serviceCode':serviceCode,'sysCode':sysCode},
         beforeSend: function(XMLHttpRequest){
          	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
          },
         success: function(data,status){
        	   var emptydata = jQuery.parseJSON(data);
    	       //grid���ݷ�ҳ
   	           if(!checkStrEmty(emptydata)){
   	        	   obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
   	              }else{
   	                obj.setDatasource([]);
   	              }
          },
         error: function (msg) {
		         cui.message('���ط���ʧ�ܡ�', 'error');
              }
     });
}
//ֹͣtbi����ȷ�Ͽ�
function updateWsStateConfirm(code,flag){
	var title='ֹͣ��������';
	var titleDetail='�ò�����ֹͣ������������Ⱪ¶��ȷ��Ҫִ�иò���?';
	if(flag=='0'){
		title='������������';
		titleDetail='�ò��������Ⱪ¶����������ȷ��Ҫִ�иò���?';
	}
   cui.confirm("<font color='red'>"+titleDetail+"</font>", {
      title:title,
	   buttons: [
                 {
                     name: 'ȷ��',
                     handler: function () {
                   	  updateWsState(code,flag);
                     }
                 },
                 {
                     name: ' ȡ��',
                     handler: function () {
                   	  //
                     }
                 }
             ]
       
   });
}
/**
 * ����״̬
 */
function updateWsState(code,flag){
	if(flag=='1'){
		flag='0';
	}else{
		flag='1';
	}
	var url = '<cui:webRoot/>/soa/servicemanage/RePublishWs.jsp?code='+code+'&flag='+flag+'&timeStamp='+ new Date().getTime();
  	    cui("#addServiceDialog").dialog({
  		modal: true, 
  		title: "���²���WebService����",
  		src : url,
  		width: 680,
  		height: 420
  	    }).show();
}
/**
 * ����grid����
 */
function updateGridData(){
	initGridData(cui('#cui_grid_list'),page);
}
window.onload = function(){	
	comtop.UI.scan();   //ɨ��
	$('#panelWidth').width(getBodyWidth());
}
--></script>
</body>

</html>
