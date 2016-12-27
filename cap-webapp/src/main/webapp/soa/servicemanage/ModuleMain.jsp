<%
  /**********************************************************************
    * �ڲ��������
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
<% 
   pageContext.setAttribute("cuiWebRoot",request.getContextPath());
   String strLoadMode = SOAConfigUtils.getConfigInfo(SoaBaseConstant.SERVICE_LOAD_MODE);
   if (SOAStringUtils.isNotBlank(strLoadMode) && SoaBaseConstant.LOAD_MODE_XML.equalsIgnoreCase(strLoadMode)) {
          response.sendRedirect(request.getContextPath()+"/soa/error.jsp");
   }
%>
<!DOCTYPE HTML>
<html>
<head>
    <title>�ڲ��������</title>
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
        <cui:bpanel id="leftMain" position="left" gap="5px 5px 5px 5px" width="228" collapsable="false">
            <table width="100%">
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
var systemCode="";
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
//������
function xmlImport(){
	var url = '<cui:webRoot/>/soa/servicemanage/fileUpload.jsp?timeStamp='+ new Date().getTime();
	exportObj = cui("#fileUploadDialog").dialog({
		modal: true, 
		title: "������",
		src : url,
		width: 500,
		height: 130
	    }).show();
	}

//���¼���tree�ṹ
function reloadTree(){
	var objTree = cui("#dirTree");
	initModuleTree(objTree);
}


//��ʼ������Ŀ¼�����ṹ
function initModuleTree(obj) {
  var url = '<cui:webRoot/>/soa/SoaServlet/loadBussSystemAndDir?operType=loadBussSystemAndDir&timeStamp='+ new Date().getTime();
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
               cui.message('����Ŀ¼ʧ�ܡ�', msg);
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
//��ȡҵ��ϵͳname
function getSysNameByNode(node){
	var parentNode = node.parent();
	var childNode = node;
	for (var i =0 ;i< 1000;i++){
        var childData = childNode.getData("data");
        if (childData.moduleType == 1){
            return childNode.getData("title");
        }
        childNode = parentNode;
        parentNode = parentNode.parent();
    }
}
//�������¼�
function treeClick(node){
    var data = node.getData("data");
    var url="";
    if(data.moduleType==2){//���Ŀ¼
    	var dirCode = node.getData("key");
        var bussSystemCode = getSysCodeByNode(node);
        var sysName = getSysNameByNode(node);
        //Ӧ��ģ�����ͣ��鿴�����ķ����б�
        url = '<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?target=windowTarget&dirCode='+dirCode+'&sysCode='+bussSystemCode+'&sysName='+sysName+'&timeStamp='+ new Date().getTime();

    } else{//���ϵͳ
    	var bussSystemCode = node.getData("key");
    	var sysName = node.getData("title");
        url = '<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?target=windowTarget&sysCode='+bussSystemCode+'&sysName='+sysName+'&timeStamp='+ new Date().getTime();
    }
    //�����Ӧ��ģ�飬��˴�������ת��Ӧ��ģ��༭ҳ��
    cui('#body').setContentURL("center",url);
}
function selectNode(sysCode,dirCode){
	var objTree = cui("#dirTree");
	objTree.getNode(sysCode).expand(true);
	objTree.selectNode(dirCode,true);
}
window.onload = function(){
    //ɨ��
    comtop.UI.scan();
    url = '<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?target=windowTarget&sysCode=-1';
    cui('#body').setContentURL("center",url);
}

//��ȡĿ¼����
function getDirCode(){
	return dirCode;
}
//��ȡϵͳ����
function getSysCode(){
	return sysCode;
}
-->
</script>   
</body>
</html>
            