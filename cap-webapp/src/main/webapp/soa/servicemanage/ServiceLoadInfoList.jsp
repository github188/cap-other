<%
/**********************************************************************
* ����װ����Ϣ��ѯ
* 2015-2-2 ŷ���� �½�
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
<title>����װ����Ϣ��ѯ</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
   <style type="text/css">
        td
        {
            white-space: nowrap;
        }
    </style>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="69" collapsable="false">
		<table id="panelWidth" class="table_edit_bg">
			<tr height="15">
	          	<td width="6%" class="td_title">&nbsp;&nbsp;������IP��</td>
	            <td width="10%" style="text-align: left;" class="td_content"><span id="appIp" uitype="Input" name="appIp" width="100px" databind="formData.appIp" on_keydown="keyDownQuery"></span></td>
	            <td width="6%">&nbsp;�������˿ڣ�</td>
	            <td width="28%" style="text-align: left;"><span id="appPort" uitype="Input" name="appPort" width="100%" databind="formData.appPort" on_keydown="keyDownQuery"></span></td> 
	            <td style="text-align: right;padding-top: 1px;padding-right: 5px;" width="50%">&nbsp;&nbsp;</td>
		</tr>
		<tr height="15">
	           <td>&nbsp;&nbsp;���״̬��</td>
	            <td  style="text-align: left;"><span id="loadStatus" width="100px" uitype="PullDown" mode="Single" datasource="resultStatus" value="-1"></span></td>
                <td>&nbsp;�����ʶ��</td>
	            <td  style="text-align: left;"><span id="methodCode" uitype="Input" name="methodCode" width="100%" databind="formData.methodCode" on_keydown="keyDownQuery"></span></td>
			    <td style="text-align: right;padding-top: 1px;padding-right: 5px;" width="50%">
	                <cui:button id="sarchService" label="��   ѯ"  on_click="queryServiceLoad"></cui:button>
	            </td>
		</tr>
		</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no"  resizeheight="getBodyHeight"
			gridwidth="900px" datasource="queryServiceLoad" primarykey="loadId" resizewidth="getBodyWidth" pagination="true" >
			<thead>
				<tr>
					<th renderStyle="text-align: left" style="width: 10%;" bindName="sysName">ϵͳ����</th>
					<th renderStyle="text-align: left" style="width: 9%;" bindName="appIp">������IP</th>
					<th renderStyle="text-align: left" style="width: 6%;" bindName="appPort">�������˿�</th>
					<th renderStyle="text-align: left" style="width: 23%;" bindName="methodCode">�����ʶ</th>
					<th renderStyle="text-align: center" style="width: 8%;" render="renderType">�����ṩ��</th>
					<th renderStyle="text-align: center" style="width: 9%;" bindName="loadTime">װ��ʱ��</th>
					<th renderStyle="text-align: center" style="width: 7%;" render="renderStatus">���״̬</th>
					<th renderStyle="text-align: left" style="width: 28%;" render="renderLoadResult">װ�ؽ��(�������鿴��ջ��Ϣ)</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript">
<!--
var bussSys={code:"${param.sysCode}"};
var emptydata = [];
/**
 * ����soa����ҳ
 */
function returnIndex(){
	window.location.href="<cui:webRoot/>/soa/index.jsp";
}
/**
 * ����SOA���������־
 */
function fastQuery(){
	var que={};
	que.pageNo=1;
	que.pageSize=50;
	queryServiceLoad(null,que);
}
/**
 * ����SOA���������־
 */
function queryServiceLoad(obj,query){
	var sysCode=bussSys.code;
	var methodCode= cui("#methodCode").getValue();
	var appIp=cui("#appIp").getValue();
	var appPort=cui("#appPort").getValue();
	var loadStatus=cui("#loadStatus").getValue();
	//alert(JSON.stringify(query));
	var curPage=query.pageNo;
	var pageSize=query.pageSize;
	if(!curPage){
		curPage=1;
		pageSize=50;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/queryServiceLoad?operType=queryServiceLoad&sysCode='+sysCode+'&methodCode='+methodCode+'&appIp='+appIp+'&appPort='+appPort+'&loadStatus='+loadStatus+'&curPage='+curPage+'&pageSize='+pageSize+'&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
  		   var emptydata = jQuery.parseJSON(data);
		   var tableObj= cui('#cui_grid_list');
           if (checkStrEmty(emptydata)){
        		 tableObj.setDatasource([]);
             }else{
        	  	 tableObj.setDatasource(emptydata.list, emptydata.allRows);
             }
         },
         error: function (msg) {
        	 var tableObj= cui('#cui_grid_list');
        	 tableObj.setDatasource([]);
		 	cui.message('��ѯ���������־�쳣��', 'error');
         }
     });
}

var renderType=function (rd, index, col){
	var editClientHtml=null;
	if(rd.isLocal==0){
	    editClientHtml="Զ�̷���";
	}else if(rd.isLocal==1){
	    editClientHtml="���ط���";
	}else if(rd.isLocal==2){
	    editClientHtml="��������";
	}
	return editClientHtml;
} 

var renderStatus = function (rd, index, col){
	var editClientHtml=null;
	if(rd.loadStatus==1){
	    editClientHtml="<font color='green'>װ�سɹ�</font>";
	}else{
		editClientHtml="<font color='red'>װ��ʧ��</font>";
	}
	return editClientHtml;
} 
var renderLoadResult = function (rd, index, col){
	var editClientHtml=null;
	if(rd.loadStatus==1){
	    editClientHtml="<font color='green'>װ�سɹ�</font>";
	}else{
	    editClientHtml='<a title="����鿴��ջ��Ϣ" href="javascript:viewDetail(\''+rd.loadId+'\',\''+rd.methodCode+'\',\''+rd.appIp+'\',\''+rd.appPort+'\')"><font color="red">'+rd.loadResult+'</font></a>';
	}
	return editClientHtml;
} 
function viewDetail(loadId,methodCode,ip,port){
	if(loadId==null||loadId==""){
		return ;
	}
	var url = '<cui:webRoot/>/soa/servicemanage/ServiceLoadResultDetail.jsp?loadId='+loadId+'&timeStamp='+ new Date().getTime();
	    cui("#ServiceElementInfoDetail").dialog({
		modal: true, 
		title: "����װ�ؽ����ջ��Ϣ(<font color='red'>�����ʶ:"+methodCode+","+ip+":"+port+"</font>)",
		src : url,
		width: 680,
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
window.onload = function(){
	comtop.UI.scan();   //ɨ��
	$('#panelWidth').width(getBodyWidth());
}
var resultStatus = [{id:'-1',text:'ȫ��'},{id:'0',text:'װ��ʧ��'},{id:'1',text:'װ�سɹ�'}];
-->
</script>
</body>
</html>
