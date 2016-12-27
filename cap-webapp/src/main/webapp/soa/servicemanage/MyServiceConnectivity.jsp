<%
/**********************************************************************
* 服务连通性检查
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
<title>服务连通性检查</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="900">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no"  resizeheight="getBodyHeight"
			gridwidth="900px" datasource="initGridData" primarykey="sid" resizewidth="getBodyWidth" pagination="false">
			<thead>
				<tr>
				    <th renderStyle="text-align: left" style="width: 20%;" render="renderCode">服务/服务元素</th>
					<th renderStyle="text-align: left" style="width: 14%;" bindName="ip">服务器IP</th>
					<th renderStyle="text-align: center" style="width: 12%;" bindName="port">服务器端口</th>
					<th renderStyle="text-align: left" style="width: 52%;" render="renderResult">测试结果</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript">
<!--
var paramData={sysCode:"${param.sysCode}",code:"${param.code}"};
var emptydata = [];
/**
 * 检查业务系统下的soa服务连通性
 */
function checkServiceConnectivity(){
	 var code= paramData.code;
	 var callSysCode=paramData.sysCode;
 	var url = '<cui:webRoot/>/soa/SoaServlet/checkConnectivity?operType=checkServiceConnectivity&code='+code+'&callSysCode='+callSysCode+'&timeStamp='+ new Date().getTime();
      cui('#cui_grid_list').setDatasource([],0);
 	  cui.handleMask.show();
     //采用ajax请求提交
     $.ajax({
          type: "GET",
          url: url,
          success: function(data,status){
      	    var emptydata = jQuery.parseJSON(data);
        	cui('#cui_grid_list').setDatasource(emptydata,emptydata.length);
    	  	cui.handleMask.hide();
           	clearInterval(100);
          },
          error: function (msg) {
 		 	cui.message('服务连通性检查失败。', 'error');
 		 	cui.handleMask.hide();
           	clearInterval(100);
          }
      });
}

var renderResult = function (rd, index, col){
	var editClientHtml=null;
	if(rd.operate==''){
	    editClientHtml='<font color=\'green\'>'+rd.result+'</font>';
	}else{
		 editClientHtml='<font color=\'red\'>'+rd.result+'</font>';
	}
	return editClientHtml;
} 
var renderCode= function (rd, index, col){
	var editClientHtml=null;
	if (checkStrEmty(rd.sid)){
	    editClientHtml=paramData.code;
	}else{
		 editClientHtml=rd.sid;
	}
	return editClientHtml;
}
/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	
}
//宽度自适应
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 10;
}
cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">正在执行连通性测试,请耐心等待……</font></span></div>'
});
window.onload = function(){	
    cui.handleMask.show();
	comtop.UI.scan();   //扫描
	checkServiceConnectivity();
}
-->
</script>
</body>
</html>
