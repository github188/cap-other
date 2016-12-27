<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<% 
   pageContext.setAttribute("cuiWebRoot",request.getContextPath());
%>
<!DOCTYPE HTML>
<html>
<head>
<title>δ����ҵ��ϵͳ�ķ�������б�</title>
<cui:link
	href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css" />
<cui:link href="/soa/css/soa.css" />
<cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js" />
<cui:script src="/soa/js/jquery.min.js" />
<cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel id="panelTop" position="top" width="500" gap='5px 5px 5px 5px' split_size="0" collapsable="false" height="50">
			<table width="100%">
				<tr height="20">
					<td style="padding-left: 5px;padding-top: 10px">
						<cui:clickinput editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" 
							emptytext="�������������������������ؼ��ֲ�ѯ" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" 
							width="400" on_keydown="keyDownQuery"/>
					</td>
					<td style="text-align: right;padding-top: 10px">
					  <span style="margin-right: 5px" id="saveId" uitype="Button" label="��ӹ���" on_click="save"></span>
					</td>
				</tr> 
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="5px 5px 5px 0px">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"  resizewidth="getBodyWidth" resizeheight="getBodyHeight"
			gridwidth="880px" datasource="initGridData" adaptive="true" primarykey="code" >
			<thead>
				<tr>
				    <th  style="width: 5%;"><input type="checkbox"/></th>
					<th renderStyle="text-align: left" style="width: 25%;" bindName="code" >�������</th>
					<th renderStyle="text-align: left" style="width: 25%;" bindName="name" >����������</th>
					<th renderStyle="text-align: left" style="width: 43%;" bindName="serviceAddress">������(��ַ)</th>
					<th renderStyle="text-align: center" style="width: 7%;" render="renderOperate">����</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var dirCode ="";
var sysCode ="";
/**
 * ���������б�
 */
function save(){
	var serviceCode = cui('#cui_grid_list').getSelectedPrimaryKey();
    dirCode= window.parent.getDirCode();
    sysCode= window.parent.getSysCode();
	if (checkStrEmty(serviceCode)&&checkStrEmty(dirCode)){
		cui.alert('1�����ڸ÷������Ӧ����ϵͳ����ѡ��һ������Ŀ¼��<br/>2�������Ҳ�����б���ѡ������һ��������Ϣ��');
		return;
	}else if (checkStrEmty(dirCode)){
		cui.alert('���ڸ÷������Ӧ����ϵͳ����ѡ��һ������Ŀ¼��');
		return;
	}else if (checkStrEmty(serviceCode)){
		cui.alert('1�������Ҳ�����б���ѡ������һ��������Ϣ��');
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
            		cui('#saveId').disable(true);
            		cui.handleMask.show();
            		var url = '<cui:webRoot/>/soa/SoaServlet/addServiceToDir?operType=addServiceToDir&serviceCode='+serviceCode+'&dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            	    //����ajax�����ύ
            	    $.ajax({
            	         type: "GET",
            	         url: url,
            	         success: function(data,status){
            	        	     cui.handleMask.hide();
            	        	     window.parent.parent.cui.alert('��������ɹ���');
            	        	     window.parent.parent.location.href='<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            	          },
            	         error: function (msg) {
            			         cui.message('�������ʧ�ܡ�', 'error');
            			         window.parent.parent.location.href='<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            	              }
            	     });
                 }else{
                	 cui.alert('�������ø�ҵ��ϵͳ�Ĵ����ַ����������Ϣ��');
                 }
        },
        error: function (msg) {
        	cui.alert('�������ø�ҵ��ϵͳ�Ĵ����ַ����������Ϣ��');
        }
    });
}

/**
 * ��ʼ��grid����
 */
function initGridData(obj,query){
	page=query;
	var serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/loadOtherService?operType=loadOtherService&timeStamp='+ new Date().getTime();
    //����ajax�����ύ
    $.ajax({
         type: "POST",
         url: url,
         contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
         data:{'serviceCode':serviceCode},
         beforeSend: function(XMLHttpRequest){
          	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
          },
         success: function(data,status){
        	 if (checkStrEmty(data)){
        		 obj.setDatasource([]);
        		 return;
             }
    	     var emptydata = jQuery.parseJSON(data);
    	    //grid���ݷ�ҳ
    	 	obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
          },
         error: function (msg) {
		         cui.message('���ط���ʧ�ܡ�', 'error');
              }
     });
}
var renderOperate = function (rd, index, col){
	 if (checkStrEmty(rd.sysCode)){
		 rd.sysCode="";
	 }
	 var editClientHtml='<img height="20px" width="16px" title="������ͨ��" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="testConnection(\''+rd.sysCode+'\',\''+rd.code+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 return editClientHtml;
} 
//���Է�����ͨ��
function testConnection(sysCode,code){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceConnectivity.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#testConnection").dialog({
		modal: true, 
		title: "������ͨ�Բ��Խ����ʾ",
		src : url,
   		width: 680,
		height: 400
	    }).show();
}
var page={pageNo:1};
//��ѯ����
function fastQuery(){
	 page.pageNo=1;
	 initGridData(cui('#cui_grid_list'),page);
}
//�������Ӧ
function getBodyWidth () {
  return (document.documentElement.clientWidth || document.body.clientWidth)-7;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}
window.onload = function(){	
	comtop.UI.scan();   //ɨ��
}
cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">����ִ�з����������,���Եȡ���</font></span></div>'
});
--></script>
</body>
</html>
