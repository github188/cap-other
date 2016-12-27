<%
/**********************************************************************
* ������ͨ�Լ��
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
<title>������ͨ�Լ��</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="900">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no"  resizeheight="getBodyHeight"
			gridwidth="900px" datasource="initGridData" primarykey="sid" resizewidth="getBodyWidth" pagination="false">
			<thead>
				<tr>
				    <th renderStyle="text-align: left" style="width: 20%;" render="renderCode">����/����Ԫ��</th>
					<th renderStyle="text-align: left" style="width: 14%;" bindName="ip">������IP</th>
					<th renderStyle="text-align: center" style="width: 12%;" bindName="port">�������˿�</th>
					<th renderStyle="text-align: left" style="width: 52%;" render="renderResult">���Խ��</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript">
<!--
var paramData={sysCode:"${param.sysCode}",code:"${param.code}"};
var emptydata = [];
/**
 * ���ҵ��ϵͳ�µ�soa������ͨ��
 */
function checkServiceConnectivity(){
	 var code= paramData.code;
	 var callSysCode=paramData.sysCode;
 	var url = '<cui:webRoot/>/soa/SoaServlet/checkConnectivity?operType=checkServiceConnectivity&code='+code+'&callSysCode='+callSysCode+'&timeStamp='+ new Date().getTime();
      cui('#cui_grid_list').setDatasource([],0);
 	  cui.handleMask.show();
     //����ajax�����ύ
     $.ajax({
          type: "GET",
          url: url,
          success: function(data,status){
      	    var emptydata = jQuery.parseJSON(data);
        	cui('#cui_grid_list').setDatasource(emptydata,emptydata.length);
    	  	cui.handleMask.hide();
           	clearInterval(100);
          },
          error: function (msg) {
 		 	cui.message('������ͨ�Լ��ʧ�ܡ�', 'error');
 		 	cui.handleMask.hide();
           	clearInterval(100);
          }
      });
}

var renderResult = function (rd, index, col){
	var editClientHtml=null;
	if(rd.operate==''){
	    editClientHtml='<font color=\'green\'>'+rd.result+'</font>';
	}else{
		 editClientHtml='<font color=\'red\'>'+rd.result+'</font>';
	}
	return editClientHtml;
} 
var renderCode= function (rd, index, col){
	var editClientHtml=null;
	if (checkStrEmty(rd.sid)){
	    editClientHtml=paramData.code;
	}else{
		 editClientHtml=rd.sid;
	}
	return editClientHtml;
}
/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
	
}
//�������Ӧ
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 10;
}
cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">����ִ����ͨ�Բ���,�����ĵȴ�����</font></span></div>'
});
window.onload = function(){	
    cui.handleMask.show();
	comtop.UI.scan();   //ɨ��
	checkServiceConnectivity();
}
-->
</script>
</body>
</html>
