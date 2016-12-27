<%
/**********************************************************************
* �����б�
* 2014-7-31 ŷ���� �½�
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
<title>�������</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="52" collapsable="false">
			<table id="panelWidth" class="cui_grid_list">
				<tr height="20" >
				   <td width="35%" style="padding-left: 5px;padding-top: 10px;">
						<cui:clickinput editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" width="100%"
							emptytext="��������������������������ѯ" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" 
							 on_keydown="keyDownQuery"/>
					</td>
					<td  width="65%" style="text-align: right;padding-top: 10px;padding-right: 5px;">
					 <cui:button id="exportButton" label="��������" icon="${cuiWebRoot}/soa/css/img/export.gif"  on_click="serviceExport"></cui:button>
				     <cui:button id="releatButton" label="��������" icon="${cuiWebRoot}/soa/css/img/add.bmp"  on_click="addService"></cui:button>
				     <cui:button id="deleteButton" label="ɾ������" icon="${cuiWebRoot}/soa/css/img/delete.gif"  on_click="deleteService"></cui:button>
					 <cui:button id="exportButton" label="δ���������ѯ" icon="${cuiWebRoot}/soa/css/img/querysearch.gif"  on_click="queryNoRelateService"></cui:button>
					</td>
				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px" height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" pagination="true"
			gridwidth="900px" datasource="initGridData" primarykey="code" resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
				  <th  style="width: 4%;"><input type="checkbox"/></th>
					<th renderStyle="text-align: left" style="width: 19%;" render="renderServiceCode">�������</th>
					<th renderStyle="text-align: left" style="width: 13%;" bindName="name">����������</th>
					<th renderStyle="text-align: left" style="width: 16%;" bindName="builderClass">��������</th>
					<th renderStyle="text-align: left" style="width: 40%;" bindName="serviceAddress">������/��ַ</th>
					<th renderStyle="text-align: center" style="width: 12%;" render="renderOperate">����</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<iframe id="exportXMLFrame" style="display: none;" src=""></iframe>
<script type="text/javascript"><!--
var emptydata = [];
var dirCode = "${param.dirCode}";
var dirName = "${param.dirName}";
var sysCode = "${param.sysCode}";
/**
 * ����soa����ҳ
 */
function returnIndex(){
	parent.document.location.href="<cui:webRoot/>/soa/index.jsp";
}
//����Ŀ¼����
function addService(){
    if (checkStrEmty(dirCode)){
		cui.alert('����ҵ��ϵͳ����ѡ��һ��Ҫ�����ķ���Ŀ¼��');
		return;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/queryBussSystem?operType=queryBussSystem&bussSystemCode='+sysCode+'&timeStamp='+ new Date().getTime();
	//����ajax�����ύ
    $.ajax({
        type: "GET",
        url: url,
        success: function(data,status){
             newBussSytsemData = jQuery.parseJSON(data);
             //������ҵ��ϵͳ��������Ϣ�����ܹ�������
             if (!checkStrEmty(newBussSytsemData)){
            	   var url = '<cui:webRoot/>/soa/servicemanage/ServiceRelate.jsp?dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            	    cui("#addServiceDialog").dialog({
            		modal: true, 
            		title: "��������",
            		src : url,
            		width: (document.documentElement.clientWidth || document.body.clientWidth) - 120,
            		height: (document.documentElement.clientHeight || document.body.clientHeight) - 200
            	    }).show();
                 }else{
                	 cui.alert('�������ø�ҵ��ϵͳ�Ĵ����ַ����������Ϣ��');
                 }
        },
        error: function (msg) {
        	cui.alert('�������ø�ҵ��ϵͳ�Ĵ����ַ����������Ϣ��');
        }
    });
}
//δ���������ѯ
function queryNoRelateService(){
   var url = '<cui:webRoot/>/soa/servicemanage/NoRelateServiceMain.jsp?sysCode=-1&dirCode=&timeStamp='+ new Date().getTime();
    cui("#addServiceDialog").dialog({
	modal: true, 
	title: "δ�����ķ������",
	src : url,
	width: (document.documentElement.clientWidth || document.body.clientWidth) - 120,
	height: (document.documentElement.clientHeight || document.body.clientHeight) - 200
    }).show();
}
//����תjson�ַ���
function stringify(arrData)
{
    var s = "";
    var data = "";
    for (i=0;i<arrData.length ;i++ ){
    	data = "";
	    $.each(arrData[i],function(k,v){
	    	if(k=='code'){
		    	data+= ",serviceCode:\"" + v+"\"";
	    	}else if(k=='code'||k=='sysCode'||k=='dirCode'){
		    	data+= "," + k + ":\"" + v+"\"";
	    	}
	    });
	    if(i==0){
		    s="{"+data.substring(1)+"}";
	    }else{
		    s = s+",{"+data.substring(1)+"}";
	    }
    }
    return "[" + s + "]";
}
//ɾ���������
function deleteService(){
	var serviceCode = cui('#cui_grid_list').getSelectedPrimaryKey();
	var rowDatas = cui('#cui_grid_list').getSelectedRowData();
	if (checkStrEmty(serviceCode)){
		cui.alert('��ѡ��һ�������¼��');
		return;
	}
	var jsonDatas=stringify(rowDatas);
    cui.confirm('<font color="red">�ò�����ɾ��ѡ�еķ�����ҵ��ϵͳ�Ĺ�����Ϣ��ȷ��Ҫ����ɾ������?</font>', {
        onYes: function () {
        	cui.handleMask.show();
        	var url = '<cui:webRoot/>/soa/SoaServlet/deleteServiceByDir?operType=deleteServiceByDir&serviceCode='+serviceCode+'&dirCode='+dirCode+'&rowDatas='+jsonDatas+'&timeStamp='+ new Date().getTime();
            //����ajax�����ύ
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
                	  cui.handleMask.hide();
            	         cui('#cui_grid_list').loadData();
            	         cui.message('ɾ���ɹ���');
                  },
                 error: function (msg) {
                	  cui.handleMask.hide();
        		      cui.message('ɾ��ʧ�ܡ�', 'error');
                      }
             });
        },
        onNo: function () {
        }
    });
}
var page={pageNo:1};
//��ѯ����
function fastQuery(){
	 page.pageNo=1;
	 initGridData(cui('#cui_grid_list'),page);
}
//�������Ӧ
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
}
/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
	page=query;
	var serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryLikeService?operType=queryLikeService&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "POST",
         url: url,
         contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
         data:{'sysCode':sysCode,'dirCode':dirCode,'serviceCode':serviceCode},
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
		         cui.message('���ط�����Ϣʧ�ܡ�', 'error');
              }
     });
}

var renderServiceCode = function (rd, index, col){
	var editClientHtml='<a title="����鿴����Ԫ���б�" href="javascript:viewServiceDetail(\''+rd.sysCode+'\',\''+rd.code+'\')">'+rd.code+'</a>';
	return editClientHtml;
} 


function viewServiceDetail(sysCode,code){
	if(code==null||code==""){
		return ;
	}
	
	var url = '<cui:webRoot/>/soa/servicemanage/ServiceElementInfo.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#ServiceElementInfoDetail").dialog({
		modal: true, 
		title: "����Ԫ���б�",
		src : url,
		width: (document.documentElement.clientWidth || document.body.clientWidth) - 100,
		height: (document.documentElement.clientHeight || document.body.clientHeight) - 100
	    }).show();
}
var renderOperate = function (rd, index, col){
	var builderClass=rd.builderClass;
	if(checkStrEmty(builderClass)){
		builderClass="";
	}
	 var editClientHtml='<img height="20px" width="16px" title="�༭" src="<cui:webRoot/>/soa/css/img/edit.png" onClick="editService(\''+rd.code+'\',\''+rd.name+'\',\''+rd.serviceAddress+'\',\''+builderClass+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="20px" width="16px" title="������ͨ��" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="testConnection(\''+rd.sysCode+'\',\''+rd.code+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="20px" width="16px" title="���ط���" src="<cui:webRoot/>/soa/css/img/loading.png" onClick="reloadServiceConfirm(\''+rd.sysCode+'\',\''+rd.code+'\');" style="cursor: hand"/>';
	 return editClientHtml;
} 
//�༭Service
function editService(code,serviceName,serviceAddress,builderClass){
	   var url = '<cui:webRoot/>/soa/servicemanage/ServiceEdit.jsp?code='+code+'&sysCode='+sysCode+'&dirCode='+dirCode+'&serviceName='+serviceName+'&serviceAddress='+serviceAddress+'&builderClass='+builderClass+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "�༭����",
		src : url,
		width: 500,
		height: 260
	    }).show();
}
//���Է�����ͨ��
function testConnection(sysCode,code){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceConnectivity.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "������ͨ�Բ��Խ����ʾ",
		src : url,
   		width: 680,
		height: 400
	    }).show();
}
/**
 * ��������ҵ��ϵͳ��Ӧ�÷�����SOA������Ϣȷ�Ͽ�
 */
function reloadServiceConfirm(sysCode,code){
	   cui.confirm("<font color='red' size='2'>���ع����п��ܻ�Ӱ�쵱ǰSOA������ã���ȡ�������������ز�����</font>", {
        onYes: function () {
        	reloadService(sysCode,code);
        },
        onNo: function () {
        },
        width: 390,
        title:'���ط���'+code
    });
}
//���ط���
function reloadService(sysCode,code){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceReload.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "�������ؽ����ʾ",
		src : url,
		width: 680,
		height: 400
	    }).show();
}
var strParam = "";
//���񵼳�
function serviceExport() {
	var serviceCode = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(serviceCode)){
		cui.alert('��ѡ��Ҫ�����ķ���');
		return;
	}
	var datas=cui('#cui_grid_list').getSelectedRowData();
	var sysCodes="";
	for (i=0;i<datas.length ;i++ ){
		if(i==0){
			sysCodes=datas[i].sysCode;
		}else{
			sysCodes=sysCodes+","+datas[i].sysCode;
		}
	}
	//��������iframe�ύ
	var url = '<cui:webRoot/>/soa/SoaServlet/serviceExport?operType=serviceExport&sysCodes='+sysCodes+'&serviceCode='+serviceCode+'&exportAppServer=false'+'&timeStamp='+ new Date().getTime();
    document.getElementById("exportXMLFrame").src=url;
}

window.onload = function(){	
	if(!checkStrEmty(dirCode)){
		parent.selectNode(sysCode,dirCode);
	}
	comtop.UI.scan();   //ɨ��
	$('#panelWidth').width(getBodyWidth());
}
cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">ɾ�����������Ϣ�ɹ�����̨�������ط����������,���Եȡ���</font></span></div>'
});
--></script>
</body>
</html>
