<%
  /**********************************************************************
    * 应用服务器管理
    * 2014-7-31  欧阳辉
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
    <title>应用服务器管理</title>
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
					    <cui:button id="returnButton" label="重载所有SOA服务"  on_click="reloadAllSystemConfirm"></cui:button>
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
//上级目录选择
var exportObj = null;
/**
 * 返回soa导航页
 */
function returnIndex(){
	window.location.href="<cui:webRoot/>/soa/index.jsp";
}
//重新加载tree结构
function reloadTree(){
	var objTree = cui("#dirTree");
	initModuleTree(objTree);
}


//初始化业务系统
function initModuleTree(obj) {
  var url = '<cui:webRoot/>/soa/SoaServlet/queryAllBussSystem?operType=queryAllBussSystem&timeStamp='+ new Date().getTime();
  //采用ajax请求提交
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
               cui.message('加载业务系统失败。', msg);
            }
   });
}

//获取业务系统code
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

//树单击事件
function treeClick(node){
   var data = node.getData("data");
   var sysCode = node.getData("key");
   if(sysCode=='root'){
	   return;
   }
   var bussSystemCode = getSysCodeByNode(node);
   var sysName = encodeURIComponent(encodeURIComponent(data.name));
    var  url = '<cui:webRoot/>/soa/servicemanage/AppServerEdit.jsp?sysCode='+sysCode+"&sysName="+sysName+'&timeStamp='+ new Date().getTime();
    //如果是应用模块，则此处快速跳转到应用模块编辑页面
    cui('#body').setContentURL("center",url);
}

/**
 * 重载所有业务系统的应用服务器SOA缓存信息确认框
 */
function reloadAllSystemConfirm(){
	   cui.confirm("<font size='2'>点击‘确定’重载所有业务系统的SOA服务，此过程将耗费较长时间，请确保业务系统的<font color='red' size='2'>代理地址、节点IP、端口</font>配置正确，否则因错误的配置信息将耗费更多时长；‘取消’不进行重载操作？</font>", {
        onYes: function () {
     	   reloadAll();
        },
        onNo: function () {
        },
        width: 390,
        title:'重载所有SOA服务'
    });
}
//重载所有业务系统的应用服务器SOA缓存信息
function reloadAll(){
	   var url = '<cui:webRoot/>/soa/servicemanage/ReloadAppServer.jsp?operType=reloadAppServer&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "服务器重载结果显示",
		src : url,
		width: 680,
		height: 500
	    }).show();
}

window.onload = function(){
    //扫描
    comtop.UI.scan();
    cui('#addSystemDialog').hide();
}
-->
</script>   
</body>
</html>
            