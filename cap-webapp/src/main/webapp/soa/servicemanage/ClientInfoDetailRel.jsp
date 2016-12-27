<%
/**********************************************************************
* 客户端授权管理
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
<title>客户端授权管理</title>
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
				<tr height="30" >
					<td style="text-align: left;padding-top: 10px;padding-right: 5px;" width="70%">
						<font color="red" size="1" id="descId" style="display: none">目前没有南网服务的访问权限，点击“添加权限”，给客户端授权。</font>
					</td>
					<td style="text-align: right;padding-top: 10px;padding-right: 5px;" width="70%">
						<cui:button id="editButton" label="添加权限" on_click="addRelWebService"></cui:button>
					</td>				
				</tr>
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"
			gridwidth="100px" datasource="initGridData" resizewidth="getBodyWidth" selectrows="no" pagination="false" colhidden="false" resizeheight="getBodyHeight">
			<thead>
				<tr>
					<th renderStyle="text-align: left" style="width: 30%;" bindName="wsName">ws服务中文名</th>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="wsCode">ws服务名</th>	
					<th renderStyle="text-align: left" style="width: 30%;" bindName="methodCode">服务元素</th>	
					<th renderStyle="text-align: center" style="width: 10%;" render="renderOperate">操作</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var clientIds = "${param.clientIds}";
function renderOperate(rd){
	var code = rd.relId;
	var htmlstr='<a href="javascript:removeRel(\''+rd.relId+'\')">取消授权</a>';
    return htmlstr;
}
function removeRel(relId){
	var url = '<cui:webRoot/>/soa/SoaServlet/deleteClientwebseviceRel?operType=deleteClientwebseviceRel&relId='+relId+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	         cui('#cui_grid_list').loadData();
    	         cui.message('取消成功。', 'success');
          },
         error: function (msg) {
		         cui.message('取消失败。', 'error');
              }
     });
}


//添加权限
function addRelWebService(){
   var url = '<cui:webRoot/>/soa/servicemanage/ClientRelNoWsList.jsp?clientIds='+clientIds+'&timeStamp='+ new Date().getTime();
    cui("#addRelWebServiceDialog").dialog({
	modal: true, 
	title: "添加客户端权限",
	src : url,
	width: 500,
	height: 300
    }).show();
}
//查询数据
function fastQuery(){
	var clientName = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientByPage?operType=queryClientByPage&clientName='+clientName+'&timeStamp='+ new Date().getTime();
  //采用ajax请求提交
  $.ajax({
       type: "GET",
       url: url,
       success: function(data,status){
  	     var emptydata = jQuery.parseJSON(data);
  	    //grid数据分页
  	 	cui('#cui_grid_list').setDatasource(emptydata,emptydata.length);
        },
       error: function (msg) {
		         cui.message('查询数据失败。', 'error');
            }
   });
}

//宽度自适应
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}
/**
 * 初始化grid数据
 */
function initGridData(obj,query){

	var url = '<cui:webRoot/>/soa/SoaServlet/queryOwnerWebServiceByClientId?operType=queryOwnerWebServiceByClientId&clientId='+clientIds+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	   var emptydata = jQuery.parseJSON(data);
    	   if(checkStrEmty(emptydata)){
    		   $('#descId').show();
    	   }
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
	$('#panelWidth').width(getBodyWidth());
}
--></script>
</body>
</html>
