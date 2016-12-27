
<%
    /**********************************************************************
			 * 客户端访问授权页面
	**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<%
    pageContext.setAttribute("cuiWebRoot", request.getContextPath());
%>
<!doctype html>
<html>
<head>
<title>客户端配置页面</title>
<cui:link
	href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css" />
<cui:link href="/soa/css/soa.css" />
<cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js" />
<cui:script src="/soa/js/jquery.min.js" />
<cui:script src="/soa/js/soa.common.js" />
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel id="topMain" position="top" gap="5px 5px 5px 0px"
		height="50" collapsable="false">
		<table id="panelWidth">
			<tr height="20">
				<td style="padding-left: 5px; padding-top: 10px;" width="30%">
				<cui:clickinput editable="true" id="keyword" name="keyword"
					on_iconclick="fastQuery" emptytext="请输入客户端名称查询" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" width="260"
					on_keydown="keyDownQuery" /></td>
					<td class="thw_operate">
					<td style="text-align: right;padding-top: 10px;padding-right: 5px;" width="70%">
				     <cui:button id="addClientAuthButton" label="确定"  on_click="saveClientAuth"></cui:button>
					</td>
				</td>
			</tr>
		</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"
			gridwidth="900px" datasource="initGridData" primarykey="clientId"
			resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
					<th style="width: 5%;"><input type="checkbox" /></th>
					<th renderStyle="text-align: left" style="width: 45%;" bindName="name">客户端名称</th>
					<th renderStyle="text-align: left" style="width: 15%;" render="renderTypeData">类型</th>
					<th renderStyle="text-align: left" style="width: 25%;" bindName="ip1">ip地址</th>
					<th renderStyle="text-align: center" style="width: 10%;" bindName="prot">端口</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
var wsCodes = "${param.wsCode}";
/**
 * 添加客户端权限
 */
function saveClientAuth(){
	var clientIds = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(clientIds)){
		cui.alert('请选择一条记录。');
		return;
	}
	var url = '<cui:webRoot/>/soa/SoaServlet/addClientwebseviceRel?operType=addClientwebseviceRel&clientIds='+clientIds+'&wsCodes='+wsCodes+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	         cui('#cui_grid_list').loadData();
    	         cui.message('授权成功。', 'success');
          },
         error: function (msg) {
		         cui.message('授权失败。', 'error');
              }
     });
}
//查询数据
function fastQuery(){
	var clientName = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientByPage?operType=queryClientByPage&timeStamp='+ new Date().getTime();
  //采用ajax请求提交
  $.ajax({
       type: "POST",
       url: url,
       contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
       data:{'clientName':clientName},
       beforeSend: function(XMLHttpRequest){
        	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
        },
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
    return (document.documentElement.clientWidth || document.body.clientWidth)-5;
}

/**
 * 初始化grid数据
 */
function initGridData(obj,query){

	var url = '<cui:webRoot/>/soa/SoaServlet/queryClientByPage?operType=queryClientByPage&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	   var emptydata = jQuery.parseJSON(data);
    	   if(emptydata){
    	       //grid数据分页
    	 	   obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
    	   }else{
    		   obj.setDatasource([]);
    	   }

          },
         error: function (msg) {
		         cui.message('加载数据失败。', 'error');
              }
     });
}
var renderTypeData=function(rd, index, col){
	if(rd.type=="1"){
		return "<span style=\"color:green;\">白名单</span>";
	}else if(rd.type=="2"){
		return "普通客户端";
	}else if(rd.type=="3"){
		return "<span style=\"color:red\">黑名单</span>";
	}
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}
window.onload = function(){	
	comtop.UI.scan();   //扫描
	$('#panelWidth').width(getBodyWidth());
}
--></script>
</body>
</html>
