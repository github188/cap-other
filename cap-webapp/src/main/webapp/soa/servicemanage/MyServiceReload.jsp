<%
/**********************************************************************
* ��������
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
<title>��������</title>
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
				    <th renderStyle="text-align: left" style="width: 20%;" bindName="sid">����/����Ԫ��</th>
				    <th renderStyle="text-align: left" style="width: 10%;" bindName="sysName">ҵ��ϵͳ</th>
					<th renderStyle="text-align: left" style="width: 13%;" bindName="ip">������IP</th>
					<th renderStyle="text-align: center" style="width: 10%;" bindName="port">�������˿�</th>
					<th renderStyle="text-align: left" style="width: 47%;" render="renderResult">���ؽ��</th>
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
 * ��������ҵ��ϵͳ�µ�ĳһ��soa����
 */
function reloadService(){
 	var url = '<cui:webRoot/>/soa/SoaServlet/reload?operType=reloadService&serviceCode='+paramData.code+'&timeStamp='+ new Date().getTime();
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
 		 	cui.message('��������ʧ�ܡ�', 'error');
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

/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
	//obj.setDatasource(emptydata,emptydata.length);
}
//�������Ӧ
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 10;
}
cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">�������ط���,�����ĵȴ�����</font></span></div>'
});
window.onload = function(){	
	cui.handleMask.show();
	comtop.UI.scan();   //ɨ��
	reloadService();
}
-->
</script>
</body>
</html>
