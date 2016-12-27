<%
  /**********************************************************************
    * Ӧ�÷���������
    * 2014-7-31  ŷ����
  **********************************************************************/
%>
<%@page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="com.comtop.soa.common.constant.SoaBaseConstant"%>
<%@page import="com.comtop.soa.common.util.SOAConfigUtils"%>
<%@page import="com.comtop.soa.common.util.SOAStringUtils"%>
<%@page import="java.util.Date"%>
<%@page import="java.net.URLEncoder"%>
<%@taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE HTML>
<html>
<head>
    <title>Ӧ�÷���������</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/top/component/ui/editGridEX/themes/default/css/editGridEX.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/top/component/ui/editGridEX/js/comtop.ui.editGridEX.js" cuiTemplate="gridEX.html"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
    <style type="text/css">
        img{
          margin-left:5px;
        }
        #addRoleButton{
        margin-right:5px;
        }
    </style>
    </head>
<body class="body_layout">
<cui:borderlayout id="body"  is_root="true">
        <cui:bpanel id="leftMain" position="left" gap="5px 5px 5px 5px" width="220" collapsable="false">
            <table width="100%">
               <tr>
					<td style="text-align: right;padding-top: 5px;padding-right: 5px;">
					    <cui:button id="returnButton" label="��������SOA����"  on_click="reloadAllSystemConfirm"></cui:button>
					</td>
				</tr>
                <tr>
                    <td>
                        <div  uitype="Tree" children="initModuleTree" on_click="treeClick"  click_folder_mode="1" id="dirTree" on_expand="onExpand" on_lazy_read="loadNode"></div>
                    </td>
                </tr>
            </table>
        </cui:bpanel>
        <cui:bpanel  position="center" id="centerMain" height="500" collapsable="false"></cui:bpanel>
    </cui:borderlayout>
<script type="text/javascript">
<!--
var systemCode;
var dialog;
var oldSystemCode;
//�ϼ�Ŀ¼ѡ��
var exportObj = null;
/**
 * ����soa����ҳ
 */
function returnIndex(){
	window.location.href="<cui:webRoot/>/soa/index.jsp";
}
//���¼���tree�ṹ
function reloadTree(){
	var objTree = cui("#dirTree");
	initModuleTree(objTree);
}


//��ʼ��ҵ��ϵͳ
function initModuleTree(obj) {
  var url = '<cui:webRoot/>/soa/SoaServlet/queryAllBussSystem?operType=queryAllBussSystem&timeStamp='+ new Date().getTime();
  //����ajax�����ύ
  $.ajax({
       type: "GET",
       url: url,
       success: function(data,status){
           treeData = jQuery.parseJSON(data);
           if(!checkStrEmty(treeData)){
                  treeData.expand = true;
                  obj.setDatasource(treeData);
              }else{
                  obj.setDatasource([]);
                  cui("#body").setContentURL("center",""); 
              }
        },
       error: function (msg) {
               cui.message('����ҵ��ϵͳʧ�ܡ�', msg);
            }
   });
}

//��ȡҵ��ϵͳcode
function getSysCodeByNode(node){
	var parentNode = node.parent();
	var childNode = node;
	for (var i =0 ;i< 1000;i++){
        var childData = childNode.getData("data");
        if (childData.moduleType == 1){
            return childNode.getData("key");
        }
        childNode = parentNode;
        parentNode = parentNode.parent();
    }
}

//�������¼�
function treeClick(node){
   var data = node.getData("data");
   var sysCode = node.getData("key");
   if(sysCode=='root'){
	   return;
   }
   var bussSystemCode = getSysCodeByNode(node);
   var sysName = encodeURIComponent(encodeURIComponent(data.name));
    var  url = '<cui:webRoot/>/soa/servicemanage/AppServerEdit.jsp?sysCode='+sysCode+"&sysName="+sysName+'&timeStamp='+ new Date().getTime();
    //�����Ӧ��ģ�飬��˴�������ת��Ӧ��ģ��༭ҳ��
    cui('#body').setContentURL("center",url);
}

/**
 * ��������ҵ��ϵͳ��Ӧ�÷�����SOA������Ϣȷ�Ͽ�
 */
function reloadAllSystemConfirm(){
	   cui.confirm("<font size='2'>�����ȷ������������ҵ��ϵͳ��SOA���񣬴˹��̽��ķѽϳ�ʱ�䣬��ȷ��ҵ��ϵͳ��<font color='red' size='2'>�����ַ���ڵ�IP���˿�</font>������ȷ������������������Ϣ���ķѸ���ʱ������ȡ�������������ز�����</font>", {
        onYes: function () {
     	   reloadAll();
        },
        onNo: function () {
        },
        width: 390,
        title:'��������SOA����'
    });
}
//��������ҵ��ϵͳ��Ӧ�÷�����SOA������Ϣ
function reloadAll(){
	   var url = '<cui:webRoot/>/soa/servicemanage/ReloadAppServer.jsp?operType=reloadAppServer&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "���������ؽ����ʾ",
		src : url,
		width: 680,
		height: 500
	    }).show();
}

window.onload = function(){
    //ɨ��
    comtop.UI.scan();
    cui('#addSystemDialog').hide();
}
-->
</script>   
</body>
</html>
            