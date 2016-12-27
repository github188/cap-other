<%
/**********************************************************************
* ����Ԫ����Ϣ�б�
* 2014-10-10 ��Сǿ �½�
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
<title>����Ԫ����Ϣ�б�</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
    <style type="text/css">
        body {margin:0;font-size: 12px;}
        h4{font-size: 16px;font: bold; }
        .formWrap{ padding: 10px; }
        .formtable td{ line-height: 25px; height:25px;}
        .formtable.td_label{ text-align: right;font-size: 12px;}
        .formtable.bottom { text-align: right;}
    </style>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"
			gridwidth="900px" datasource="initGridData" resizewidth="getBodyWidth" resizeheight="getBodyHeight" selectrows="no" pagination="false" colhidden="false" >
			<thead>
				<tr>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="code">����Ԫ�أ�SID��</th>
					<th renderStyle="text-align: left" style="width: 15%;" bindName="cnName">����Ԫ��������</th>
					<th renderStyle="text-align: left" style="width: 10%;" bindName="name">������</th>
					<th renderStyle="text-align: left" style="width: 10%;" bindName="alias">��������</th>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="methodDesc">����ǩ��</th>
					<th renderStyle="text-align: center" style="width: 13%;" bindName="hasWs" render="renderHasWs">��������</th>
					<th renderStyle="text-align: center" style="width: 12%;" render="renderOperate">����</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var serviceCode = "${param.code}";
var sysCode = "${param.sysCode}";
var formdata={};
//�������Ӧ
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
//�߶�����Ӧ
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 15;
}
/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
	var url = '<cui:webRoot/>/soa/SoaServlet/queryServiceMeta?operType=queryServiceMethodByServiceCode&servicecode='+serviceCode+'&timeStamp='+ new Date().getTime();
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
		         cui.message('��������ʧ�ܡ�', 'error');
              }
     });
}

window.onload = function(){	
	comtop.UI.scan();   //ɨ��
}

function renderHasWs(rowData){
	if(rowData.hasWs==true){	
		return '<a title="����鿴��������" href="javascript:getWebServiceVO(\''+rowData.code+'\')">��ע��</a>';
	}else {
		return 'δע��';
	}
}
function getWebServiceVO(methodCode){
	   var url = '<cui:webRoot/>/soa/servicemanage/TBIServiceDetail.jsp?methodCode='+methodCode+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "����������ϸ",
		src : url,
		width: 600,
		height: 320
	    }).show();
}
//����
var renderOperate = function (rd, index, col){
    var cnName =encodeURIComponent(encodeURIComponent(rd.cnName));
     var editClientHtml='<img title="�༭" src="<cui:webRoot/>/soa/css/img/edit.png" onClick="editServiceMethod(\''+rd.code+'\',\''+rd.alias+'\',\''+rd.name+'\',\''+cnName+'\',\''+rd.methodDesc+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="20px" width="16px" title="������ͨ��" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="testConnection(\''+sysCode+'\',\''+rd.code+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="20px" width="16px" title="�ӿڲ���" src="<cui:webRoot/>/soa/css/img/sendReq.png" onClick="mockReqConfirm(\''+rd.code+'\');" style="cursor: hand"/>';
	return editClientHtml;
} 
//�༭Service
function editServiceMethod(methodCode,alias,name,cnName,methodDesc){
	   var url = '<cui:webRoot/>/soa/servicemanage/ServiceElementEdit.jsp?methodCode='+methodCode+'&sysCode='+sysCode+'&serviceCode='+serviceCode+'&alias='+alias+'&name='+name+'&cnName='+cnName+'&methodDesc='+methodDesc+'&timeStamp='+ new Date().getTime();
	   cui("#addServiceDialog").dialog({
		modal: true, 
		title: "�༭����Ԫ��",
		src : url,
		width: 500,
		height: 310
	    }).show();
}
//���Է�����ͨ��
function testConnection(sysCode,methodCode){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceConnectivity.jsp?sysCode='+sysCode+'&code='+methodCode+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "������ͨ�Բ��Խ����ʾ",
		src : url,
		width: 600,
		height: 400
	    }).show();
}
//����ӿڲ���ȷ��
function mockReqConfirm(methodCode){
	   cui.confirm("<font color='red' size='2'>���ã���ʽ�����£������ز����˹��ܣ�������ᷢ����ʵ�������,���ø��²������ܵ��������쳣������������ݣ�</font>", {
			width: 480,
        buttons: [
                  {
                      name: '�����������',
                      handler: function () {
                    	  mockReq(methodCode);
                      }
                  }
              ]
        
    });
}
//����ӿڲ���
function mockReq(methodCode){
	   var url = '<cui:webRoot/>/soa/servicemanage/ServicetMockSend.jsp?methodCode='+methodCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "����ӿڲ���"+"��<font color='red'>������Ϊ��ʵ������ã������ز����˹��ܣ�</font>��",
		src : url,
		width: 680,
		height: 430
	    }).show();
}

//���ط���
function reloadService(sysCode,code){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceReload.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "�������ؽ����ʾ",
		src : url,
		width: 950,
		height: 400
	    }).show();
}
--></script>
</body>
</html>
