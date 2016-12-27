<%
/**********************************************************************
* SOA服务重载管理
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
<title>SOA服务重载管理</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="60" collapsable="false">
			<table id="panelWidth">
				<tr height="15" >
				   <td style="padding-left: 5px;padding-top: 2px;" width="30%"></td>
				</tr>
				<tr height="15" >
				   <td style="text-align: right;padding-top: 5px;" width="92%">
					<cui:button id="editButton" label="重载所有业务系统服务&nbsp;"  on_click="reloadAllService"></cui:button>
				   </td>

				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no"  resizeheight="getBodyHeight"
			gridwidth="900px" datasource="initGridData" primarykey="serverCode" resizewidth="getBodyWidth" pagination="false">
			<thead>
				<tr>
					<th renderStyle="text-align: left" style="width: 13%;" bindName="sysCode">系统编码</th>
					<th renderStyle="text-align: left" style="width: 13%;" bindName="sysName">系统名称</th>
					<th renderStyle="text-align: left" style="width: 7%;" bindName="ip">服务器IP</th>
					<th renderStyle="text-align: left" style="width: 7%;" bindName="port">服务器端口</th>
					<th renderStyle="text-align: center" style="width: 50%;" render="renderResult">操作结果</th>
					<th renderStyle="text-align: center" style="width: 10%;" render="renderOperate">操作</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript">
<!--
var emptydata = [];
/**
 * 返回soa导航页
 */
function returnIndex(){
	window.location.href="<cui:webRoot/>/soa/index.jsp";
}
/**
 * 重载所有业务系统的SOA服务
 */
function reloadAllService(){
	var url = '<cui:webRoot/>/soa/SoaServlet/reloadService?operType=reloadService&timeStamp='+ new Date().getTime();
	
    cui.confirm('该功能会重载所有应用服务器及服务注册信息，将花费较长时间，重载完成之前可能会影响SOA服务的调用，确定要开始此操作？', {
        onYes: function () {
       	 cui('#cui_grid_list').setDatasource([],0);
      	  cui.handleMask.show();
          //采用ajax请求提交
          $.ajax({
               type: "GET",
               url: url,
               success: function(data,status){
             	 	cui.message('服务装载完成。', 'success');
             	  	cui.handleMask.hide();
           	     var emptydata = jQuery.parseJSON(data);
             	    //grid数据分页
             	 	cui('#cui_grid_list').setDatasource(emptydata,emptydata.length);
                	clearInterval(100);
               },
               error: function (msg) {
      		 	cui.message('服务装载失败。', 'error');
      		 	cui.handleMask.hide();
                	clearInterval(100);
               }
           });
        },
        onNo: function () {
        }
    });  
}
/**
 * 重载所有业务系统的SOA服务
 */
function reloadService(sysCode,serverCode,ip,port){
	var url = '<cui:webRoot/>/soa/SoaServlet/reloadService?operType=reloadService&sysCode='+sysCode+'&ip='+ ip+'&port='+port+'&timeStamp='+ new Date().getTime();;
	  cui.handleMask.show();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
        	 var serverData = jQuery.parseJSON(data);
        	 serverData.serverCode=serverCode;
        	 if(serverData.operate=='undefined' || serverData.operate=='' ){
            	 	cui.success('服务装载成功。');
                  var objData= cui('#cui_grid_list').getRowsDataByPK(serverCode);
                  objData[0].result=serverData.result;
                  if(objData!=null && objData.length>0){
                      cui('#cui_grid_list').changeData(objData[0]);
                  }
        	 }else{
                 var objData= cui('#cui_grid_list').getRowsDataByPK(serverCode);
                 if(objData!=null && objData.length>0){
                 objData[0].result="服务重载失败";
                     cui('#cui_grid_list').changeData(objData[0]);
                 }
        		 cui.error(serverData.result, null, {
        	            title: '服务装载失败:ip='+ip+",port="+port,
        	            width: 430
        	        });
        	 }
       	  	cui.handleMask.hide();
          	clearInterval(100);
         },
         error: function (msg) {
		 	cui.message('服务装载失败。', 'error');
		 	cui.handleMask.hide();
          	clearInterval(100);
         }
     });
}
cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">SOA服务正在装载中,请耐心等待……</font></span></div>'
});

var renderResult = function (rd, index, col){
	var editClientHtml=null;
	if(rd.result=='服务重载成功'){
	    editClientHtml="<font color='green'>服务重载成功</font>";
	}else{
		editClientHtml="<font color='red'>"+rd.result+"</font>";
	}
	return editClientHtml;
} 

var renderOperate = function (rd, index, col){
	var editClientHtml=null;
	if(rd.operate==''){
	    editClientHtml="无";
	}else{
		 editClientHtml='<a href="javascript:reloadService(\''+rd.sysCode+'\',\''+rd.serverCode+'\',\''+rd.ip+'\',\''+rd.port+'\')">'+rd.operate+'</a>';
	}
	return editClientHtml;
} 

/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	//obj.setDatasource(emptydata,emptydata.length);
	var curPage=query.pageNo;
	var pageSize=query.pageSize;
	if(!curPage){
		curPage=1;
		pageSize=50;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/queryAppServerList?operType=queryAppServerList&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
  		   var emptydata = jQuery.parseJSON(data);
  		   var tableObj= cui('#cui_grid_list');
  	  	   tableObj.setDatasource(emptydata,emptydata.length);
         },
         error: function (msg) {
		 	cui.message('查询异常。', 'error');
         }
     });
	
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
-->
</script>
</body>
</html>
