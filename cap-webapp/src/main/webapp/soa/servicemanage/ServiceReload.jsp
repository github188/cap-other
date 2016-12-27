<%
/**********************************************************************
* SOA�������ع���
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
<title>SOA�������ع���</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="60" collapsable="false">
			<table id="panelWidth">
				<tr height="15" >
				   <td style="padding-left: 5px;padding-top: 2px;" width="30%"></td>
				</tr>
				<tr height="15" >
				   <td style="text-align: right;padding-top: 5px;" width="92%">
					<cui:button id="editButton" label="��������ҵ��ϵͳ����&nbsp;"  on_click="reloadAllService"></cui:button>
				   </td>

				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no"  resizeheight="getBodyHeight"
			gridwidth="900px" datasource="initGridData" primarykey="serverCode" resizewidth="getBodyWidth" pagination="false">
			<thead>
				<tr>
					<th renderStyle="text-align: left" style="width: 13%;" bindName="sysCode">ϵͳ����</th>
					<th renderStyle="text-align: left" style="width: 13%;" bindName="sysName">ϵͳ����</th>
					<th renderStyle="text-align: left" style="width: 7%;" bindName="ip">������IP</th>
					<th renderStyle="text-align: left" style="width: 7%;" bindName="port">�������˿�</th>
					<th renderStyle="text-align: center" style="width: 50%;" render="renderResult">�������</th>
					<th renderStyle="text-align: center" style="width: 10%;" render="renderOperate">����</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript">
<!--
var emptydata = [];
/**
 * ����soa����ҳ
 */
function returnIndex(){
	window.location.href="<cui:webRoot/>/soa/index.jsp";
}
/**
 * ��������ҵ��ϵͳ��SOA����
 */
function reloadAllService(){
	var url = '<cui:webRoot/>/soa/SoaServlet/reloadService?operType=reloadService&timeStamp='+ new Date().getTime();
	
    cui.confirm('�ù��ܻ���������Ӧ�÷�����������ע����Ϣ�������ѽϳ�ʱ�䣬�������֮ǰ���ܻ�Ӱ��SOA����ĵ��ã�ȷ��Ҫ��ʼ�˲�����', {
        onYes: function () {
       	 cui('#cui_grid_list').setDatasource([],0);
      	  cui.handleMask.show();
          //����ajax�����ύ
          $.ajax({
               type: "GET",
               url: url,
               success: function(data,status){
             	 	cui.message('����װ����ɡ�', 'success');
             	  	cui.handleMask.hide();
           	     var emptydata = jQuery.parseJSON(data);
             	    //grid���ݷ�ҳ
             	 	cui('#cui_grid_list').setDatasource(emptydata,emptydata.length);
                	clearInterval(100);
               },
               error: function (msg) {
      		 	cui.message('����װ��ʧ�ܡ�', 'error');
      		 	cui.handleMask.hide();
                	clearInterval(100);
               }
           });
        },
        onNo: function () {
        }
    });  
}
/**
 * ��������ҵ��ϵͳ��SOA����
 */
function reloadService(sysCode,serverCode,ip,port){
	var url = '<cui:webRoot/>/soa/SoaServlet/reloadService?operType=reloadService&sysCode='+sysCode+'&ip='+ ip+'&port='+port+'&timeStamp='+ new Date().getTime();;
	  cui.handleMask.show();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
        	 var serverData = jQuery.parseJSON(data);
        	 serverData.serverCode=serverCode;
        	 if(serverData.operate=='undefined' || serverData.operate=='' ){
            	 	cui.success('����װ�سɹ���');
                  var objData= cui('#cui_grid_list').getRowsDataByPK(serverCode);
                  objData[0].result=serverData.result;
                  if(objData!=null && objData.length>0){
                      cui('#cui_grid_list').changeData(objData[0]);
                  }
        	 }else{
                 var objData= cui('#cui_grid_list').getRowsDataByPK(serverCode);
                 if(objData!=null && objData.length>0){
                 objData[0].result="��������ʧ��";
                     cui('#cui_grid_list').changeData(objData[0]);
                 }
        		 cui.error(serverData.result, null, {
        	            title: '����װ��ʧ��:ip='+ip+",port="+port,
        	            width: 430
        	        });
        	 }
       	  	cui.handleMask.hide();
          	clearInterval(100);
         },
         error: function (msg) {
		 	cui.message('����װ��ʧ�ܡ�', 'error');
		 	cui.handleMask.hide();
          	clearInterval(100);
         }
     });
}
cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">SOA��������װ����,�����ĵȴ�����</font></span></div>'
});

var renderResult = function (rd, index, col){
	var editClientHtml=null;
	if(rd.result=='�������سɹ�'){
	    editClientHtml="<font color='green'>�������سɹ�</font>";
	}else{
		editClientHtml="<font color='red'>"+rd.result+"</font>";
	}
	return editClientHtml;
} 

var renderOperate = function (rd, index, col){
	var editClientHtml=null;
	if(rd.operate==''){
	    editClientHtml="��";
	}else{
		 editClientHtml='<a href="javascript:reloadService(\''+rd.sysCode+'\',\''+rd.serverCode+'\',\''+rd.ip+'\',\''+rd.port+'\')">'+rd.operate+'</a>';
	}
	return editClientHtml;
} 

/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
	//obj.setDatasource(emptydata,emptydata.length);
	var curPage=query.pageNo;
	var pageSize=query.pageSize;
	if(!curPage){
		curPage=1;
		pageSize=50;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/queryAppServerList?operType=queryAppServerList&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
  		   var emptydata = jQuery.parseJSON(data);
  		   var tableObj= cui('#cui_grid_list');
  	  	   tableObj.setDatasource(emptydata,emptydata.length);
         },
         error: function (msg) {
		 	cui.message('��ѯ�쳣��', 'error');
         }
     });
	
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
-->
</script>
</body>
</html>
