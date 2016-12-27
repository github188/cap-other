<%
/**********************************************************************
* 南网服务服务管理
* 2014-9-18 黄科林 新建
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
<title>南网服务管理</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="51" collapsable="false">
			<table id="panelWidth" class="cui_grid_list">
				<tr height="20" >
				   <td width="35%" style="padding-left: 5px;padding-top: 10px;">
						<cui:clickinput editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" 
							emptytext="请输入WS编码、WS中文名查询" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" 
							width="100%" on_keydown="keyDownQuery"/>
					</td>
					<td width="65%" style="text-align: right;padding-top: 10px;padding-right: 5px;">
				     <cui:button id="openclientMainButton" label="客户端认证维护"   on_click="openClientMain"></cui:button>
					</td>
				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px" height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no"
			gridwidth="900px" datasource="initGridData" primarykey="code" resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
				  <th renderStyle="text-align: left" style="width: 15%;" bindName="code" render="renderCode">WS编码</th>
				  <th renderStyle="text-align: left" style="width: 15%;" bindName="sysName" render="renderSysName">所属系统</th>
					<th renderStyle="text-align: left" style="width: 15%;" bindName="serviceName">WS中文名</th>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="methodCode">服务元素(SID)</th>
					<th renderStyle="text-align: center" style="width: 5%;" bindName="flag" render="renderFlage">服务状态</th>
					<th renderStyle="text-align: left" style="width: 20%;"  bindName="wsClassAddress">南网服务类</th>
					<th renderStyle="text-align: center" style="width: 10%;" render="renderOperate">操作</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var dirCode = "${param.dirCode}";
var dirName = "${param.dirName}";
var sysCode = "${param.sysCode}";
var serviceCode="";
function renderCode(rowData){
    var wsdl=rowData.wsdl;
    var indstr=wsdl.substring(0,1);
    if(indstr=='/'){
  	    wsdl=wsdl.substring(1,wsdl.length);
    }
		return '<a title=\"点击查看wsdl\" href=\"javascript:void window.open(\''+wsdl+'\')\">'+rowData.code+'</a>';
}
function renderSysName(rowData){
	if(checkStrEmty(rowData.sysName)){
		return '<font color="red" size="2">未关联业务系统</font>';
	}else {
		return rowData.sysName;
	}
}

function renderFlage(rowData){
	if(rowData.flag === '1'){
		return '运行中';
	}else if (rowData.flag === '0'){
		return '<font color="red" size="2">停用</font>';
	}
}
var renderOperate = function (rd, index, col){
	var strStateName="启动服务";
	var startPng="stop.png";
	if(rd.flag === '1'){
		strStateName="停止服务";
		startPng="start.png";
	}
	 var editHtml='<img height="18px" width="16px" title="编辑" src="<cui:webRoot/>/soa/css/img/edit.png" onClick="editHtml(\''+rd.methodCode+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editHtml=editHtml+'<img height="18px" width="16px" title="接口测试" src="<cui:webRoot/>/soa/css/img/sendReq.png" onClick="testConnectivity(\''+rd.code+'\',\''+rd.wsdl+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editHtml=editHtml+'<img height="15px" width="13px" title="'+strStateName+'" src="<cui:webRoot/>/soa/css/img/'+startPng+'" onClick="updateWsStateConfirm(\''+rd.code+'\',\''+rd.flag+'\');" style="cursor: hand"/>';
	return editHtml;
} 
//授权客户端认证
function addClientAuth(){
	var wsCode = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(wsCode)){
		cui.alert('请选择一条服务记录。');
		return;
	}
	   var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoList.jsp?wsCode='+wsCode+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "南网服务客户端授权",
		src : url,
		width: 700,
		height: 550
	    }).show();
}
//打开客户端认证维护页面
function openClientMain(){
	   var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoMain.jsp?timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "客户端认证维护",
		src : url,
		width: 780,
		height: 480
	    }).show();
}

//编辑WebService页面
function editHtml(methodCode){
	   var url = '<cui:webRoot/>/soa/servicemanage/TBIServiceEdit.jsp?methodCode='+methodCode+'&sysCode='+sysCode+'&pageNo='+page.pageNo+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "编辑南网服务",
		src : url,
		width: 620,
		height: 405
	    }).show();
}
//南网服务连通性测试
function testConnectivity(code,wsdl){
	var url = '<cui:webRoot/>/soa/servicemanage/TBIServiceConnectivity.jsp?code='+code+'&wsdl='+wsdl+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "南网服务连通性测试",
		src : url,
		width: 780,
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
var page={pageNo:1};
var pageNo="${param.pageNo}";
//查询数据
function fastQuery(){
	 page.pageNo=1;
	 initGridData(cui('#cui_grid_list'),page);
}
/**
 * 初始化grid数据
 */
function initGridData(obj,query){
    page=query;
	serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryTBIWebservice?operType=queryTBIWebservice&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "POST",
         url: url,
         contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
         data:{'serviceCode':serviceCode,'sysCode':sysCode},
         beforeSend: function(XMLHttpRequest){
          	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
          },
         success: function(data,status){
        	   var emptydata = jQuery.parseJSON(data);
    	       //grid数据分页
   	           if(!checkStrEmty(emptydata)){
   	        	   obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
   	              }else{
   	                obj.setDatasource([]);
   	              }
          },
         error: function (msg) {
		         cui.message('加载服务失败。', 'error');
              }
     });
}
//停止tbi服务确认框
function updateWsStateConfirm(code,flag){
	var title='停止南网服务';
	var titleDetail='该操作将停止该南网服务对外暴露，确定要执行该操作?';
	if(flag=='0'){
		title='启动南网服务';
		titleDetail='该操作将对外暴露该南网服务，确定要执行该操作?';
	}
   cui.confirm("<font color='red'>"+titleDetail+"</font>", {
      title:title,
	   buttons: [
                 {
                     name: '确定',
                     handler: function () {
                   	  updateWsState(code,flag);
                     }
                 },
                 {
                     name: ' 取消',
                     handler: function () {
                   	  //
                     }
                 }
             ]
       
   });
}
/**
 * 更新状态
 */
function updateWsState(code,flag){
	if(flag=='1'){
		flag='0';
	}else{
		flag='1';
	}
	var url = '<cui:webRoot/>/soa/servicemanage/RePublishWs.jsp?code='+code+'&flag='+flag+'&timeStamp='+ new Date().getTime();
  	    cui("#addServiceDialog").dialog({
  		modal: true, 
  		title: "重新部署WebService服务",
  		src : url,
  		width: 680,
  		height: 420
  	    }).show();
}
/**
 * 更新grid数据
 */
function updateGridData(){
	initGridData(cui('#cui_grid_list'),page);
}
window.onload = function(){	
	comtop.UI.scan();   //扫描
	$('#panelWidth').width(getBodyWidth());
}
--></script>
</body>

</html>
