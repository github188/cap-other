<%
/**********************************************************************
* 服务元素信息列表
* 2014-10-10 李小强 新建
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
<title>服务元素信息列表</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
    <style type="text/css">
        body {margin:0;font-size: 12px;}
        h4{font-size: 16px;font: bold; }
        .formWrap{ padding: 10px; }
        .formtable td{ line-height: 25px; height:25px;}
        .formtable.td_label{ text-align: right;font-size: 12px;}
        .formtable.bottom { text-align: right;}
    </style>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"
			gridwidth="900px" datasource="initGridData" resizewidth="getBodyWidth" resizeheight="getBodyHeight" selectrows="no" pagination="false" colhidden="false" >
			<thead>
				<tr>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="code">服务元素（SID）</th>
					<th renderStyle="text-align: left" style="width: 15%;" bindName="cnName">服务元素中文名</th>
					<th renderStyle="text-align: left" style="width: 10%;" bindName="name">方法名</th>
					<th renderStyle="text-align: left" style="width: 10%;" bindName="alias">方法别名</th>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="methodDesc">方法签名</th>
					<th renderStyle="text-align: center" style="width: 13%;" bindName="hasWs" render="renderHasWs">南网服务</th>
					<th renderStyle="text-align: center" style="width: 12%;" render="renderOperate">操作</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var serviceCode = "${param.code}";
var sysCode = "${param.sysCode}";
var formdata={};
//宽度自适应
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
//高度自适应
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 15;
}
/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	var url = '<cui:webRoot/>/soa/SoaServlet/queryServiceMeta?operType=queryServiceMethodByServiceCode&servicecode='+serviceCode+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	   var emptydata = jQuery.parseJSON(data);
	       //grid数据分页
	 	   obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
          },
         error: function (msg) {
		         cui.message('加载数据失败。', 'error');
              }
     });
}

window.onload = function(){	
	comtop.UI.scan();   //扫描
}

function renderHasWs(rowData){
	if(rowData.hasWs==true){	
		return '<a title="点击查看南网服务" href="javascript:getWebServiceVO(\''+rowData.code+'\')">已注册</a>';
	}else {
		return '未注册';
	}
}
function getWebServiceVO(methodCode){
	   var url = '<cui:webRoot/>/soa/servicemanage/TBIServiceDetail.jsp?methodCode='+methodCode+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "南网服务明细",
		src : url,
		width: 600,
		height: 320
	    }).show();
}
//操作
var renderOperate = function (rd, index, col){
    var cnName =encodeURIComponent(encodeURIComponent(rd.cnName));
     var editClientHtml='<img title="编辑" src="<cui:webRoot/>/soa/css/img/edit.png" onClick="editServiceMethod(\''+rd.code+'\',\''+rd.alias+'\',\''+rd.name+'\',\''+cnName+'\',\''+rd.methodDesc+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="20px" width="16px" title="测试连通性" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="testConnection(\''+sysCode+'\',\''+rd.code+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="20px" width="16px" title="接口测试" src="<cui:webRoot/>/soa/css/img/sendReq.png" onClick="mockReqConfirm(\''+rd.code+'\');" style="cursor: hand"/>';
	return editClientHtml;
} 
//编辑Service
function editServiceMethod(methodCode,alias,name,cnName,methodDesc){
	   var url = '<cui:webRoot/>/soa/servicemanage/ServiceElementEdit.jsp?methodCode='+methodCode+'&sysCode='+sysCode+'&serviceCode='+serviceCode+'&alias='+alias+'&name='+name+'&cnName='+cnName+'&methodDesc='+methodDesc+'&timeStamp='+ new Date().getTime();
	   cui("#addServiceDialog").dialog({
		modal: true, 
		title: "编辑服务元素",
		src : url,
		width: 500,
		height: 310
	    }).show();
}
//测试服务连通性
function testConnection(sysCode,methodCode){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceConnectivity.jsp?sysCode='+sysCode+'&code='+methodCode+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "服务连通性测试结果显示",
		src : url,
		width: 600,
		height: 400
	    }).show();
}
//服务接口测试确认
function mockReqConfirm(methodCode){
	   cui.confirm("<font color='red' size='2'>您好，正式环境下，请慎重操作此功能，该请求会发起真实服务调用,调用更新操作可能导致数据异常或产生垃圾数据！</font>", {
			width: 480,
        buttons: [
                  {
                      name: '进入操作界面',
                      handler: function () {
                    	  mockReq(methodCode);
                      }
                  }
              ]
        
    });
}
//服务接口测试
function mockReq(methodCode){
	   var url = '<cui:webRoot/>/soa/servicemanage/ServicetMockSend.jsp?methodCode='+methodCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "服务接口测试"+"（<font color='red'>该请求为真实服务调用，请慎重操作此功能！</font>）",
		src : url,
		width: 680,
		height: 430
	    }).show();
}

//重载服务
function reloadService(sysCode,code){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceReload.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "服务重载结果显示",
		src : url,
		width: 950,
		height: 400
	    }).show();
}
--></script>
</body>
</html>
