<%
/**********************************************************************
* 服务列表
* 2014-7-31 欧阳辉 新建
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
<title>服务管理</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="52" collapsable="false">
			<table id="panelWidth" class="cui_grid_list">
				<tr height="20" >
				   <td width="35%" style="padding-left: 5px;padding-top: 10px;">
						<cui:clickinput editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" width="100%"
							emptytext="请输入服务别名、服务中文名查询" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" 
							 on_keydown="keyDownQuery"/>
					</td>
					<td  width="65%" style="text-align: right;padding-top: 10px;padding-right: 5px;">
					 <cui:button id="exportButton" label="导出服务" icon="${cuiWebRoot}/soa/css/img/export.gif"  on_click="serviceExport"></cui:button>
				     <cui:button id="releatButton" label="关联服务" icon="${cuiWebRoot}/soa/css/img/add.bmp"  on_click="addService"></cui:button>
				     <cui:button id="deleteButton" label="删除关联" icon="${cuiWebRoot}/soa/css/img/delete.gif"  on_click="deleteService"></cui:button>
					 <cui:button id="exportButton" label="未关联服务查询" icon="${cuiWebRoot}/soa/css/img/querysearch.gif"  on_click="queryNoRelateService"></cui:button>
					</td>
				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px" height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" pagination="true"
			gridwidth="900px" datasource="initGridData" primarykey="code" resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
				  <th  style="width: 4%;"><input type="checkbox"/></th>
					<th renderStyle="text-align: left" style="width: 19%;" render="renderServiceCode">服务别名</th>
					<th renderStyle="text-align: left" style="width: 13%;" bindName="name">服务中文名</th>
					<th renderStyle="text-align: left" style="width: 16%;" bindName="builderClass">服务构造器</th>
					<th renderStyle="text-align: left" style="width: 40%;" bindName="serviceAddress">服务类/地址</th>
					<th renderStyle="text-align: center" style="width: 12%;" render="renderOperate">操作</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<iframe id="exportXMLFrame" style="display: none;" src=""></iframe>
<script type="text/javascript"><!--
var emptydata = [];
var dirCode = "${param.dirCode}";
var dirName = "${param.dirName}";
var sysCode = "${param.sysCode}";
/**
 * 返回soa导航页
 */
function returnIndex(){
	parent.document.location.href="<cui:webRoot/>/soa/index.jsp";
}
//服务目录关联
function addService(){
    if (checkStrEmty(dirCode)){
		cui.alert('请在业务系统树下选择一个要关联的服务目录。');
		return;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/queryBussSystem?operType=queryBussSystem&bussSystemCode='+sysCode+'&timeStamp='+ new Date().getTime();
	//采用ajax请求提交
    $.ajax({
        type: "GET",
        url: url,
        success: function(data,status){
             newBussSytsemData = jQuery.parseJSON(data);
             //先设置业务系统服务器信息，才能关联服务
             if (!checkStrEmty(newBussSytsemData)){
            	   var url = '<cui:webRoot/>/soa/servicemanage/ServiceRelate.jsp?dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            	    cui("#addServiceDialog").dialog({
            		modal: true, 
            		title: "关联服务",
            		src : url,
            		width: (document.documentElement.clientWidth || document.body.clientWidth) - 120,
            		height: (document.documentElement.clientHeight || document.body.clientHeight) - 200
            	    }).show();
                 }else{
                	 cui.alert('请先设置该业务系统的代理地址、服务器信息。');
                 }
        },
        error: function (msg) {
        	cui.alert('请先设置该业务系统的代理地址、服务器信息。');
        }
    });
}
//未关联服务查询
function queryNoRelateService(){
   var url = '<cui:webRoot/>/soa/servicemanage/NoRelateServiceMain.jsp?sysCode=-1&dirCode=&timeStamp='+ new Date().getTime();
    cui("#addServiceDialog").dialog({
	modal: true, 
	title: "未关联的服务管理",
	src : url,
	width: (document.documentElement.clientWidth || document.body.clientWidth) - 120,
	height: (document.documentElement.clientHeight || document.body.clientHeight) - 200
    }).show();
}
//数组转json字符串
function stringify(arrData)
{
    var s = "";
    var data = "";
    for (i=0;i<arrData.length ;i++ ){
    	data = "";
	    $.each(arrData[i],function(k,v){
	    	if(k=='code'){
		    	data+= ",serviceCode:\"" + v+"\"";
	    	}else if(k=='code'||k=='sysCode'||k=='dirCode'){
		    	data+= "," + k + ":\"" + v+"\"";
	    	}
	    });
	    if(i==0){
		    s="{"+data.substring(1)+"}";
	    }else{
		    s = s+",{"+data.substring(1)+"}";
	    }
    }
    return "[" + s + "]";
}
//删除服务关联
function deleteService(){
	var serviceCode = cui('#cui_grid_list').getSelectedPrimaryKey();
	var rowDatas = cui('#cui_grid_list').getSelectedRowData();
	if (checkStrEmty(serviceCode)){
		cui.alert('请选择一条服务记录。');
		return;
	}
	var jsonDatas=stringify(rowDatas);
    cui.confirm('<font color="red">该操作将删除选中的服务与业务系统的关联信息，确定要进行删除操作?</font>', {
        onYes: function () {
        	cui.handleMask.show();
        	var url = '<cui:webRoot/>/soa/SoaServlet/deleteServiceByDir?operType=deleteServiceByDir&serviceCode='+serviceCode+'&dirCode='+dirCode+'&rowDatas='+jsonDatas+'&timeStamp='+ new Date().getTime();
            //采用ajax请求提交
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
                	  cui.handleMask.hide();
            	         cui('#cui_grid_list').loadData();
            	         cui.message('删除成功。');
                  },
                 error: function (msg) {
                	  cui.handleMask.hide();
        		      cui.message('删除失败。', 'error');
                      }
             });
        },
        onNo: function () {
        }
    });
}
var page={pageNo:1};
//查询数据
function fastQuery(){
	 page.pageNo=1;
	 initGridData(cui('#cui_grid_list'),page);
}
//宽度自适应
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
}
/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	page=query;
	var serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryLikeService?operType=queryLikeService&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "POST",
         url: url,
         contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
         data:{'sysCode':sysCode,'dirCode':dirCode,'serviceCode':serviceCode},
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
		         cui.message('加载服务信息失败。', 'error');
              }
     });
}

var renderServiceCode = function (rd, index, col){
	var editClientHtml='<a title="点击查看服务元素列表" href="javascript:viewServiceDetail(\''+rd.sysCode+'\',\''+rd.code+'\')">'+rd.code+'</a>';
	return editClientHtml;
} 


function viewServiceDetail(sysCode,code){
	if(code==null||code==""){
		return ;
	}
	
	var url = '<cui:webRoot/>/soa/servicemanage/ServiceElementInfo.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#ServiceElementInfoDetail").dialog({
		modal: true, 
		title: "服务元素列表",
		src : url,
		width: (document.documentElement.clientWidth || document.body.clientWidth) - 100,
		height: (document.documentElement.clientHeight || document.body.clientHeight) - 100
	    }).show();
}
var renderOperate = function (rd, index, col){
	var builderClass=rd.builderClass;
	if(checkStrEmty(builderClass)){
		builderClass="";
	}
	 var editClientHtml='<img height="20px" width="16px" title="编辑" src="<cui:webRoot/>/soa/css/img/edit.png" onClick="editService(\''+rd.code+'\',\''+rd.name+'\',\''+rd.serviceAddress+'\',\''+builderClass+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="20px" width="16px" title="测试连通性" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="testConnection(\''+rd.sysCode+'\',\''+rd.code+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 editClientHtml=editClientHtml+'<img height="20px" width="16px" title="重载服务" src="<cui:webRoot/>/soa/css/img/loading.png" onClick="reloadServiceConfirm(\''+rd.sysCode+'\',\''+rd.code+'\');" style="cursor: hand"/>';
	 return editClientHtml;
} 
//编辑Service
function editService(code,serviceName,serviceAddress,builderClass){
	   var url = '<cui:webRoot/>/soa/servicemanage/ServiceEdit.jsp?code='+code+'&sysCode='+sysCode+'&dirCode='+dirCode+'&serviceName='+serviceName+'&serviceAddress='+serviceAddress+'&builderClass='+builderClass+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "编辑服务",
		src : url,
		width: 500,
		height: 260
	    }).show();
}
//测试服务连通性
function testConnection(sysCode,code){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceConnectivity.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "服务连通性测试结果显示",
		src : url,
   		width: 680,
		height: 400
	    }).show();
}
/**
 * 重载所有业务系统的应用服务器SOA缓存信息确认框
 */
function reloadServiceConfirm(sysCode,code){
	   cui.confirm("<font color='red' size='2'>重载过程中可能会影响当前SOA服务调用，‘取消’不进行重载操作？</font>", {
        onYes: function () {
        	reloadService(sysCode,code);
        },
        onNo: function () {
        },
        width: 390,
        title:'重载服务：'+code
    });
}
//重载服务
function reloadService(sysCode,code){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceReload.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "服务重载结果显示",
		src : url,
		width: 680,
		height: 400
	    }).show();
}
var strParam = "";
//服务导出
function serviceExport() {
	var serviceCode = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(serviceCode)){
		cui.alert('请选择要导出的服务。');
		return;
	}
	var datas=cui('#cui_grid_list').getSelectedRowData();
	var sysCodes="";
	for (i=0;i<datas.length ;i++ ){
		if(i==0){
			sysCodes=datas[i].sysCode;
		}else{
			sysCodes=sysCodes+","+datas[i].sysCode;
		}
	}
	//导出数据iframe提交
	var url = '<cui:webRoot/>/soa/SoaServlet/serviceExport?operType=serviceExport&sysCodes='+sysCodes+'&serviceCode='+serviceCode+'&exportAppServer=false'+'&timeStamp='+ new Date().getTime();
    document.getElementById("exportXMLFrame").src=url;
}

window.onload = function(){	
	if(!checkStrEmty(dirCode)){
		parent.selectNode(sysCode,dirCode);
	}
	comtop.UI.scan();   //扫描
	$('#panelWidth').width(getBodyWidth());
}
cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">删除服务关联信息成功，后台正在重载服务关联操作,请稍等……</font></span></div>'
});
--></script>
</body>
</html>
