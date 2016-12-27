
<%
    /**********************************************************************
			 * 服务导出
			 * 2014-2-13  袁巧林
			 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.comtop.soa.common.util.SOAStringUtils"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE HTML>
<html>
<head>
<title>内部服务导出页面</title>
<cui:link
	href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css" />
<cui:link href="/soa/css/soa.css" />
<cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js" />
<cui:script src="/soa/js/jquery.min.js" />
<cui:script src="/soa/js/soa.common.js"/>
<style type="text/css">
img {
	margin-left: 5px;
}

#addRoleButton {
	margin-right: 5px;
}
</style>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel id="leftMain" position="left" gap="5px 5px 5px 5px" width="180" header_content="" collapsable="false">
		<table width="90%">
			<tr>
				<td>
					<div  uitype="Tree" children="initData" click_folder_mode="1" on_select="on_selected" id="dirTree" checkbox="true" select_mode="3"></div>
				</td>
				
			</tr>
		</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="5px 5px 5px 0px" height="80">
	     <div class="exportDiv" style="text-align: right;padding-right: 8px;height: 20px">
			<span id="serviceExportId" uitype="Button" label="导&nbsp;出" on_click="serviceExport"></span>
		</div>
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" gridwidth="480px" datasource="initGridData"  primarykey="code"  resizewidth="getBodyWidth" resizeheight="getBodyHeight">
			<thead>
				<tr>
				    <th  style="width: 5%;"><input type="checkbox"/></th>
				    <th renderStyle="text-align: left" style="width: 20%;" bindName="sysCode">系统编码</th>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="code">服务别名</th>
					<th renderStyle="text-align: left" style="width: 55%;" bindName="serviceAddress">服务类(地址)</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<iframe id="exportXMLFrame" style="display: none;" src=""></iframe>

<script type="text/javascript"><!--
var strParam = "";
var emptydata = [];
//var dirCode = "${param.dirCode}";
//树单击事件
function treeClick(node){
	strParam = "";
	var activeNode = cui("#dirTree").getSelectedNodes(false);
	for (var i =0;i<activeNode.length;i++){
		if (activeNode[i].getData().key == 'root'){
			continue;
		}
		strParam += activeNode[i].getData().key + ":";
	}
	 var url = '<cui:webRoot/>/soa/SoaServlet/queryDirCode?operType=queryDirCode&sysCodes='+strParam+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	     if(!checkStrEmty(data)){
    	    	 var treeData = jQuery.parseJSON(data);
    	    	 emptydata = treeData;
    	    	 cui("#cui_grid_list").loadData();
    			}else{
    				cui("#cui_grid_list").setDatasource([]);
    	   			cui("#body").setContentURL("center",""); 
    			}
          },
         error: function (msg) {
		         cui.error("加载服务失败。");
              }
     });
 
}

//初始化服务目录的树结构
function initData(obj) {
	  var url = '<cui:webRoot/>/soa/SoaServlet/queryAllBussSystem?operType=queryAllBussSystem&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    	     if(!checkStrEmty(data)){
    	    	 var treeData = jQuery.parseJSON(data);
    				treeData.expand = true;
    				treeData.activate = true;
    		    	obj.setDatasource(treeData);
    			}else{
    				obj.setDatasource(emptydata);
    	   			cui("#body").setContentURL("center",""); 
    			}
          },
         error: function (msg) {
		         cui.error("初始化树失败。");
              }
     });
}

function serviceExport() {
	if(strParam == null || strParam == ""
        || strParam == "undefined" || strParam == "null"){
		cui.alert("请选择节点后在导出。");
        return;
    }
	var serviceCode = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(serviceCode)){
		cui.alert('请选择要导出的服务。');
		return;
	}
	//导出数据iframe提交
	var url = '<cui:webRoot/>/soa/SoaServlet/serviceExport?operType=serviceExport&strParam='+strParam+'&serviceCode='+serviceCode+'&exportAppServer=false'+'&timeStamp='+ new Date().getTime();
	var exportFrame = document.getElementById("exportXMLFrame");
	exportFrame.src = url;
}

/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	//grid数据分页
	obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
}

function on_selected(flag,node){
	if(flag == false || node.getData()._isApi){
		treeClick(node);
		return;
	}
	selectedChildrens(node);
	treeClick(node);
}
/**
 * 选中当前对应的所有子节点、子节点的子节点……
 */
function selectedChildrens(node){
	var childNodes = node.children();
	if (childNodes != null){
		for(var i =0;i<childNodes.length;i++){
			 childNodes[i].getData()._isApi=true;
			 childNodes[i].select(true);
			if(childNodes[i].hasChild()){
				selectedChildrens(childNodes[i]);
			}else{
				continue;
			}
		}
	}
}

//宽度自适应
function getBodyWidth () {
  return (document.documentElement.clientWidth || document.body.clientWidth)-210;
}
//宽度自适应
function getBodyHeight () {
  return (document.documentElement.clientHeight || document.body.clientHeight)-80;
}
window.onload = function(){	
	comtop.UI.scan();   //扫描
}
--></script>
</body>
</html>
