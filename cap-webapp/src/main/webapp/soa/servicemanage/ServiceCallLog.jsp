<%
/**********************************************************************
* 服务调用日志查询
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
<title>服务调用日志查询</title>
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
<body class="body_layout" style="overflow:auto;">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="69" collapsable="false">
		<table id="panelWidth">
			<tr height="15">
	          	<td>&nbsp;&nbsp;结果状态：</td>
	            <td width="8%" style="text-align: left;"><span id="resultStatus" width="118px" uitype="PullDown" mode="Single" datasource="resultStatus" value="-1"></span></td>
				<td width="6%">&nbsp;&nbsp;服务类型：</td>
	            <td width="25%" style="text-align: left;"><span id="invokeType" width="100%" uitype="PullDown" mode="Single" datasource="invokeType" value="-1"></span></td>
	            <td width="6%">&nbsp;&nbsp;服务标识：</td>
	            <td width="25%" style="text-align: left;"><span id="methodCode" width="100%"  uitype="Input" name="methodCode" databind="formData.methodCode" on_keydown="keyDownQuery" emptytext="输入服务标识关键字"></span></td>
	            <td width="30%" style="text-align: right;padding-top: 1px;padding-right: 5px;">&nbsp;&nbsp;</td>
		</tr>
			<tr height="15">
			 	<td>&nbsp;&nbsp;服务响应时间：</td>
	            <td style="text-align: left;" ><span id="invokeTime" width="118px" uitype="Calender" name="invokeTime" validate="服务响应时间不能为空" emptytext="填写服务响应时间"></span></td>
	           <td>&nbsp;&nbsp;请求报文：</td>
	            <td style="text-align: left;"><span id="inputArgs" width="100%"  uitype="Input" name="inputArgs" databind="formData.inputArgs" on_keydown="keyDownQuery" emptytext="输入请求报文关键字"></span></td>
	            <td>&nbsp;&nbsp;响应报文：</td>
	            <td style="text-align: left;"><span id="invokeResult" width="100%"  uitype="Input" name="invokeResult" databind="formData.invokeResult" on_keydown="keyDownQuery" emptytext="输入响应报文关键字"></span></td>
			    <td style="text-align: right;padding-top: 1px;padding-right: 5px;" width="30%"><cui:button id="sarchService" label="查   询"  on_click="query"></cui:button></td>
		</tr>
		</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no"  resizeheight="getBodyHeight"
			gridwidth="900px" datasource="query" primarykey="logId" resizewidth="getBodyWidth" pagination="true" >
			<thead>
				<tr>
					<th renderStyle="text-align: left" style="width: 19%;" bindName="methodCode">服务标识(SID)</th>
					<th renderStyle="text-align: center" style="width: 7%;" render="renderInvokeType">服务类型</th>
					<th renderStyle="text-align: left" style="width: 9%;" bindName="sysName">所属系统</th>
					<th renderStyle="text-align: left" style="width: 9%;" bindName="appIp">服务器IP</th>
					<th renderStyle="text-align: left" style="width: 7%;" bindName="appPort">服务器端口</th>
					<th renderStyle="text-align: left" style="width: 9%;" bindName="clientIp">客户端IP</th>
					<th renderStyle="text-align: left" style="width: 7%;" bindName="clientPort">客户端端口</th>
					<th renderStyle="text-align: center" style="width: 12%;" bindName="invokeTime">服务响应时间</th>
					<th renderStyle="text-align: center" style="width: 6%;" bindName="spendTime">耗时(毫秒)</th>
					<th renderStyle="text-align: center" style="width: 6%;" render="renderResultStatus">状态</th>
					<th renderStyle="text-align: center" style="width: 7%;" render="renderOperat">操作</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript">
<!--
var bussSys={code:"${param.sysCode}",name:"${param.sysName}"};
var emptydata = [];
/**
 * 返回soa导航页
 */
function returnIndex(){
	window.location.href="<cui:webRoot/>/soa/index.jsp";
}
/**
 * 查询SOA服务调用日志
 */
function fastQuery(){
	var que={};
	que.pageNo=1;
	que.pageSize=50;
	query(null,que);
}
/**
 * 查询SOA服务调用日志
 */
function query(obj,query){
	var sysCode=bussSys.code;
	var methodCode= cui("#methodCode").getValue();
	var invokeTime=cui("#invokeTime").getValue();
	var resultStatus=cui("#resultStatus").getValue();
	var invokeType=cui("#invokeType").getValue();
	
	var inputArgs=cui("#inputArgs").getValue();
	var invokeResult=cui("#invokeResult").getValue();
	//alert(JSON.stringify(query));
	var curPage=query.pageNo;
	var pageSize=query.pageSize;
	if(!curPage){
		curPage=1;
		pageSize=50;
	}
	if(!invokeTime){
		cui('#invokeTime').setValue(new Date()); 
		invokeTime=cui("#invokeTime").getValue();
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/queryCallLog?operType=queryCallLog&sysCode='+sysCode+'&curPage='+curPage+'&pageSize='+pageSize+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "POST",
         url: url,
         contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
         data:{'inputArgs':inputArgs,'invokeResult':invokeResult,'methodCode':methodCode,'invokeType':invokeType,'invokeTime':invokeTime,'resultStatus':resultStatus},
         success: function(data,status){
  		     var tableObj= cui('#cui_grid_list');
  		     var emptydata = jQuery.parseJSON(data);
        	 if (checkStrEmty(emptydata)){
        		 tableObj.setDatasource([]);
             }else{
        	  	   tableObj.setDatasource(emptydata.list, emptydata.allRows);
             }
         },
         error: function (msg) {
		 	cui.message('查询服务调用日志异常。', 'error');
         }
     });
}


var renderInvokeType= function (rd, index, col){
	var editClientHtml=null;
	if(rd.invokeType==1){
	    editClientHtml="南网服务";
	}
	 else if(rd.invokeType==2){
		editClientHtml="内部服务";
	}
	return editClientHtml;
}
var renderResultStatus = function (rd, index, col){
	var editClientHtml=null;
	if(rd.resultStatus==1){
	    editClientHtml="<font color='green'>调用成功</font>";
	}else{
		editClientHtml="<font color='red'>调用失败</font>";
	}
	return editClientHtml;
} 
var renderOperat = function (rd, index, col){
	 var editClientHtml='<img height="18px" width="16px" title="查看详情" src="<cui:webRoot/>/soa/css/img/detail_page.gif" onClick="viewServiceDetail(\''+rd.logId+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="18px" width="16px" title="重发请求" src="<cui:webRoot/>/soa/css/img/sendReq.png" onClick="sendRequest(\''+rd.logId+'\',\''+rd.invokeType+'\');" style="cursor: hand"/>';
	return editClientHtml;
} 
//重发请求
function sendRequest(logId,invokeType){
	   var url = null;
	   //内部服务
	   if(invokeType==2){
		   url = '<cui:webRoot/>/soa/servicemanage/ServiceRequestSend.jsp?logId='+logId+'&timeStamp='+ new Date().getTime();
	   }else{
		   url = '<cui:webRoot/>/soa/servicemanage/WsRequestSend.jsp?logId='+logId+'&timeStamp='+ new Date().getTime();
	   }
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "重发接口请求",
		src : url,
		width: 760,
		height: 470
	    }).show();
}
//显示服务调用详情
function viewServiceDetail(logId){
	   var url = '<cui:webRoot/>/soa/servicemanage/ServiceCallDetail.jsp?logId='+logId+'&timeStamp='+ new Date().getTime();
	   var height =  (document.documentElement.clientHeight || document.body.clientHeight)-100; //400
	    cui.dialog({
		modal: true, 
		title: "服务调用详情",
		src : url,
		width: 780,
		page_scroll:true,
		height: height
	    }).show();
}
function obtainData(obj,params){
	var dataArray = [];
    for(var i=0;i<=9; i++)
        dataArray.push({ code: i + '', name: '选择 ' + i ,filterName:'Boss ' + i});
    
    obj.setDatasource(dataArray);
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

var resultStatus = [{id:'-1',text:'全部'},{id:'0',text:'调用失败'},{id:'1',text:'调用成功'}];
var invokeType=[{id:'-1',text:'全部'},{id:'1',text:'南网服务'},{id:'2',text:'内部服务'}];
-->
</script>
</body>
</html>
