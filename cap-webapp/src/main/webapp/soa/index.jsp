<%
  /**********************************************************************
	* SOA��ҳ����
	* 2015-2-10 ŷ����  �½�
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="com.comtop.soa.common.constant.SoaBaseConstant"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<html>
 <% 
   pageContext.setAttribute("cuiWebRoot",request.getContextPath());
%>
<head>
	<title>SOA��ҳ����</title>
	<cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
<style>
body {
	background: #ededed;
	margin: 15px auto;
}
.button {
	display: inline-block;
	zoom: 1; 
	margin: 0 auto;
	outline: none;
	cursor: pointer;
	text-align: center;
	font: 15px;
	padding: .5em 0em .10em;
    color:#226DDD;
}
</style>
</head>
<body>
<center>
	<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" tablewidth='30' selectrows="no" gridwidth="800px" gridheight="auto" datasource="initGridData" primarykey="id" pagination="false" resizewidth="getBodyWidth"  rowstylerender="rowStyleRender">
		<thead>
			<tr>
				<th renderStyle="text-align: left" style="width: 25%;" bindName="name" render="renderName"><font  size="3">����ģ��</font></th>
				<th renderStyle="text-align: left" style="width: 75%;" bindName="desc" render="renderDesc"><font  size="3" title="">����˵��</font></th>
			</tr>
		</thead>
	</table>
</center>
<script type="text/javascript">
<!--
var renderName = function (rd, index, col){
	return '<span title="" class="button" onClick="gotoPage(\''+rd.addr+'\');"><b>'+rd.name+'</b></span>';

}
var renderDesc = function (rd, index, col){
	return '<font color="#6C7B8B" size="2" title="">'+rd.desc+'</font>';
} 
function gotoPage(addr){
	window.open(addr,'',' left=0,top=0,width='+ (screen.availWidth - 10) +',height='+ (screen.availHeight-50) +',scrollbars,resizable=yes,toolbar=no');
}
/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
	var appAddr="${cuiWebRoot}/soa/servicemanage/ModuleDialog.jsp";
	<%
	if(!SoaBaseConstant.SERVICE_DID_DATA_TARGET.equals("local")){
	%>
	   appAddr="${cuiWebRoot}/top/sys/module/ModuleMain.jsp";
	<%  
	}
	%>
    var data = [
          {id: '1', name: 'ϵͳӦ�ù���',addr:appAddr, desc: '1�����ҵ��ϵͳ��ģ�����ṹ��Ϣ;</br>2����TOPƽ̨����ʱͨ��TOPƽ̨��ϵͳӦ�ù���������ҵ��ϵͳ��Ӧ����Ϣ��'},
          {id: '2', name: 'Ӧ�÷���������',addr:'<cui:webRoot/>/soa/servicemanage/ProxyServerMain.jsp', desc: '1������ҵ��ϵͳ�������ͼ������ַ��</br>2������Ӧ�÷�����IP���˿���Ϣ��</br>3�����Է�������ͨ�ԣ�</br>4�����ط�������Ϣ��'},
          {id: '3', name: '�ڲ��������',addr:'<cui:webRoot/>/soa/servicemanage/ModuleMain.jsp', desc: '1����ѯ�ѹ���ҵ��ϵͳ�ķ��񡢲�ѯδ����ҵ��ϵͳ�ķ���</br>2����������ɾ��������</br>3���������񡢱༭��������</br>4�����Է�����ͨ�ԡ����Է���Ԫ����ͨ�ԡ����ط���'},
          {id: '4', name: '�����������',addr:'<cui:webRoot/>/soa/servicemanage/TBIServiceManage.jsp', desc: '1����������ӿڲ�ѯ��</br>2���������Ʊ༭����������/ͣ�ã�</br>3��������֤�����á����������Ȩ��</br>4���ӿڲ��ԡ�'},
          {id: '5', name: '����װ����Ϣ��ѯ',addr:'<cui:webRoot/>/soa/servicemanage/ServiceLoadInfoMain.jsp', desc: '1����ѯ����װ�سɹ���ȷ�Ϸ���������ȷ��˵���÷�������������;</br>2����������Ϊ���ط���˵���÷��������ڸ�ҵ��ϵͳ;</br>3������װ���쳣��������޷��������á�'},
          {id: '6', name: '���������־��ѯ',addr:'<cui:webRoot/>/soa/servicemanage/ServiceCallLogMain.jsp', desc: '1����ѯ�������������־����������쳣��־��</br>2���ط������������'}
            ];
    obj.setDatasource(data, 10);
}
//�������Ӧ
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)*3/5;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
}
function rowStyleRender (rowData) {
        return "height:90px;";
}


window.onload = function(){	
	comtop.UI.scan();   //ɨ��
}
-->
</script>
</body>
</html>