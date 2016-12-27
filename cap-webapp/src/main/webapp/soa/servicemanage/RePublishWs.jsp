<%
/**********************************************************************
* 重新部署WebService服务
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
<title>重新部署WebService服务显示</title>
    <cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
    <cui:link href="/soa/css/soa.css"/>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
    <cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel position="center" id="centerMain" gap="0px 5px 5px 0px"
		height="800">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list" selectrows="no" resizeheight="getBodyHeight"
			gridwidth="900px" datasource="initGridData" primarykey="serverCode" resizewidth="getBodyWidth" pagination="false">
			<thead>
				<tr>
					<th renderStyle="text-align: left" style="width: 20%;" bindName="sysName">系统名称</th>
					<th renderStyle="text-align: left" style="width: 15%;" bindName="ip">服务器IP</th>
					<th renderStyle="text-align: left" style="width: 10%;" bindName="port">服务器端口</th>
					<th renderStyle="text-align: left" style="width: 55%;" render="renderResult">操作结果</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript">
<!--
var code="${param.code}";
var flag="${param.flag}";
/**
 * 重载应用服务器注册信息
 */
function reloadAppServer(){
	var url = '<cui:webRoot/>/soa/SoaServlet/update?operType=updateWsState&code='+code+'&flag='+flag+'&timeStamp='+ new Date().getTime();
	cui('#cui_grid_list').setDatasource([],0);
	cui.handleMask.show();
      //采用ajax请求提交
      $.ajax({
           type: "GET",
           url: url,
           success: function(data,status){
         	  	cui.handleMask.hide();
       	        var emptydata = jQuery.parseJSON(data);
         	    //grid数据分页
         	 	cui('#cui_grid_list').setDatasource(emptydata,emptydata.length);
         	    parent.updateGridData();
            	clearInterval(100);
           },
           error: function (msg) {
  		 	cui.message('部署失败。', 'error');
  		 	cui.handleMask.hide();
            	clearInterval(100);
           }
       });
}
cui.handleMask({
    html: '<div align="center"><span><font color="red" size="3">正在重新部署WebService服务,请稍等……</font></span></div>'
});

var renderResult = function (rd, index, col){
	var editClientHtml=null;
	if(rd.result=='1'){
		var strFlag='WebService服务重新部署成功';
		if(flag=='0'){
			strFlag='WebService服务已被停用';
		}
	    editClientHtml="<font color='green'>"+strFlag+"</font>";
	}else{
		editClientHtml="<font color='red'>"+rd.result+"</font>";
	}
	return editClientHtml;
} 
/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	//obj.setDatasource([],0);
}
//宽度自适应
function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth)-6;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 13;
}
window.onload = function(){	
	comtop.UI.scan();   //扫描
    reloadAppServer();
}
-->
</script>
</body>
</html>
