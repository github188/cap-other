<%
/**********************************************************************
* webservice服务列表--用于客户端授权
* 2014-10-13 李小强  新建
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
<title>WS服务列表，客户端授权管理</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
    <cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px" height="50" collapsable="false">
			<table id="panelWidth">
				<tr height="20" >
				   <td style="padding-left: 5px;padding-top: 10px;" width="30%">
						<cui:clickinput editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" 
							emptytext="请输入服务编码查询" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" 
							width="350" on_keydown="keyDownQuery"/>
					</td>
					<td style="text-align: right;padding-top: 10px;padding-right: 5px;" width="70%">
						<cui:button id="editButton" label="确&nbsp;定" on_click="addRelWebService"></cui:button>
					</td>	
				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="5px 5px 5px 5px"
		height="400">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"
			gridwidth="500px" datasource="initGridData" primarykey="code" resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
				 	<th  style="width: 10%;"><input type="checkbox"/></th>
					<th renderStyle="text-align: left" style="width: 45%;" bindName="code">WS服务编码</th>
					<th renderStyle="text-align: left" style="width: 45%;" bindName="serviceName">WS服务名称</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var clientIds = "${param.clientIds}";
//查询数据
function fastQuery(){
	var serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientNoWebServices?operType=queryClientNoWebServices&timeStamp='+ new Date().getTime();
  //采用ajax请求提交
  $.ajax({
       type: "POST",
       url: url,
       contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
       data:{'clientId':clientIds,'serviceCode':serviceCode},
       beforeSend: function(XMLHttpRequest){
        	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
        },
       success: function(data,status){
  	     var emptydata = jQuery.parseJSON(data);
  	    //grid数据分页
  	 	cui('#cui_grid_list').setDatasource(emptydata,emptydata.length);
        },
       error: function (msg) {
		         cui.message('查询服务失败。', 'error');
            }
   });
}
function addRelWebService(){
	var ids = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(ids)){
		cui.alert('请选择一条记录。');
		return;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/addClientwebseviceRel?operType=addClientwebseviceRel&clientIds='+clientIds+'&wsCodes='+ids+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
        	     window.parent.cui('#cui_grid_list').loadData();
    	         window.parent.cui.message('授权成功。', 'success');
    	         window.parent.location.href='<cui:webRoot/>/soa/servicemanage/ClientInfoDetailRel.jsp?clientIds='+clientIds;
          },
         error: function (msg) {
		         cui.message('授权失败。', 'error');
              }
     });
    
}
//宽度自适应
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-15;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}
/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientNoWebServices?operType=queryClientNoWebServices&clientId='+clientIds+'&timeStamp='+ new Date().getTime();
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
		         cui.message('加载服务失败。', 'error');
              }
     });
}

window.onload = function(){	
	comtop.UI.scan();   //扫描
	$('#panelWidth').width(getBodyWidth());
}
--></script>
</body>
</html>
