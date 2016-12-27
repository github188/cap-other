<%
/**********************************************************************
* 服务装载信息查询
* 2015-2-2 欧阳辉 新建
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
<title>服务装载信息查询</title>
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
	          	<td width="6%" class="td_title">&nbsp;&nbsp;服务器IP：</td>
	            <td width="10%" style="text-align: left;" class="td_content"><span id="appIp" uitype="Input" name="appIp" width="100px" databind="formData.appIp" on_keydown="keyDownQuery"></span></td>
	            <td width="6%">&nbsp;服务器端口：</td>
	            <td width="28%" style="text-align: left;"><span id="appPort" uitype="Input" name="appPort" width="100%" databind="formData.appPort" on_keydown="keyDownQuery"></span></td> 
	            <td style="text-align: right;padding-top: 1px;padding-right: 5px;" width="50%">&nbsp;&nbsp;</td>
		</tr>
		<tr height="15">
	           <td>&nbsp;&nbsp;结果状态：</td>
	            <td  style="text-align: left;"><span id="loadStatus" width="100px" uitype="PullDown" mode="Single" datasource="resultStatus" value="-1"></span></td>
                <td>&nbsp;服务标识：</td>
	            <td  style="text-align: left;"><span id="methodCode" uitype="Input" name="methodCode" width="100%" databind="formData.methodCode" on_keydown="keyDownQuery"></span></td>
			    <td style="text-align: right;padding-top: 1px;padding-right: 5px;" width="50%">
	                <cui:button id="sarchService" label="查   询"  on_click="queryServiceLoad"></cui:button>
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
					<th renderStyle="text-align: left" style="width: 10%;" bindName="sysName">系统名称</th>
					<th renderStyle="text-align: left" style="width: 9%;" bindName="appIp">服务器IP</th>
					<th renderStyle="text-align: left" style="width: 6%;" bindName="appPort">服务器端口</th>
					<th renderStyle="text-align: left" style="width: 23%;" bindName="methodCode">服务标识</th>
					<th renderStyle="text-align: center" style="width: 8%;" render="renderType">服务提供者</th>
					<th renderStyle="text-align: center" style="width: 9%;" bindName="loadTime">装载时间</th>
					<th renderStyle="text-align: center" style="width: 7%;" render="renderStatus">结果状态</th>
					<th renderStyle="text-align: left" style="width: 28%;" render="renderLoadResult">装载结果(点击结果查看堆栈信息)</th>
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
 * 返回soa导航页
 */
function returnIndex(){
	window.location.href="<cui:webRoot/>/soa/index.jsp";
}
/**
 * 重载SOA服务调用日志
 */
function fastQuery(){
	var que={};
	que.pageNo=1;
	que.pageSize=50;
	queryServiceLoad(null,que);
}
/**
 * 重载SOA服务调用日志
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
    //采用ajax请求提交
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
		 	cui.message('查询服务调用日志异常。', 'error');
         }
     });
}

var renderType=function (rd, index, col){
	var editClientHtml=null;
	if(rd.isLocal==0){
	    editClientHtml="远程服务";
	}else if(rd.isLocal==1){
	    editClientHtml="本地服务";
	}else if(rd.isLocal==2){
	    editClientHtml="南网服务";
	}
	return editClientHtml;
} 

var renderStatus = function (rd, index, col){
	var editClientHtml=null;
	if(rd.loadStatus==1){
	    editClientHtml="<font color='green'>装载成功</font>";
	}else{
		editClientHtml="<font color='red'>装载失败</font>";
	}
	return editClientHtml;
} 
var renderLoadResult = function (rd, index, col){
	var editClientHtml=null;
	if(rd.loadStatus==1){
	    editClientHtml="<font color='green'>装载成功</font>";
	}else{
	    editClientHtml='<a title="点击查看堆栈信息" href="javascript:viewDetail(\''+rd.loadId+'\',\''+rd.methodCode+'\',\''+rd.appIp+'\',\''+rd.appPort+'\')"><font color="red">'+rd.loadResult+'</font></a>';
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
		title: "服务装载结果堆栈信息(<font color='red'>服务标识:"+methodCode+","+ip+":"+port+"</font>)",
		src : url,
		width: 680,
		height: 460
	    }).show();
}
//宽度自适应
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
}
window.onload = function(){
	comtop.UI.scan();   //扫描
	$('#panelWidth').width(getBodyWidth());
}
var resultStatus = [{id:'-1',text:'全部'},{id:'0',text:'装载失败'},{id:'1',text:'装载成功'}];
-->
</script>
</body>
</html>
