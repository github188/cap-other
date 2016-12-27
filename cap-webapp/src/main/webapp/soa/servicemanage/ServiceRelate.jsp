<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<% 
   pageContext.setAttribute("cuiWebRoot",request.getContextPath());
%>
<!DOCTYPE HTML>
<html>
<head>
<title>服务关联列表</title>
<cui:link
	href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css" />
<cui:link href="/soa/css/soa.css" />
<cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js" />
<cui:script src="/soa/js/jquery.min.js" />
<cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout" id="addServiceDialog">
<cui:borderlayout id="body" is_root="true">
	<cui:bpanel id="panelTop" position="top" width="500" gap='5px 5px 5px 5px' split_size="0" collapsable="false" height="50">
			<table width="100%">
				<tr height="20">
					<td style="padding-left: 5px;padding-top: 10px">
						<cui:clickinput editable="true" id="keyword" name="keyword" on_iconclick="fastQuery" 
							emptytext="请输入服务别名、服务中文名关键字查询" icon="${cuiWebRoot}/soa/css/img/querysearch.gif" 
							width="400" on_keydown="keyDownQuery"/>
					</td>
					<td style="text-align: right;padding-top: 10px">
					  <span style="margin-right: 5px" id="saveId" uitype="Button" label="添加关联" on_click="save"></span>
					</td>
				</tr> 
			</table>
	</cui:bpanel>
	<cui:bpanel position="center" id="centerMain" gap="5px 5px 5px 0px">
		<table id="cui_grid_list" uitype="Grid" class="cui_grid_list"  resizewidth="getBodyWidth" resizeheight="getBodyHeight"
			gridwidth="880px" datasource="initGridData" adaptive="true" primarykey="code" >
			<thead>
				<tr>
				    <th  style="width: 5%;"><input type="checkbox"/></th>
					<th renderStyle="text-align: left" style="width: 25%;" bindName="code" >服务别名</th>
					<th renderStyle="text-align: left" style="width: 25%;" bindName="name" >服务中文名</th>
					<th renderStyle="text-align: left" style="width: 45%;" bindName="serviceAddress">服务类(地址)</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var dirCode = "${param.dirCode}";
var sysCode = "${param.sysCode}";
var sysName = "${param.sysName}";
/**
 * 关联服务列表
 */
function save(){
	var serviceCode = cui('#cui_grid_list').getSelectedPrimaryKey();
    if (checkStrEmty(serviceCode)){
    	cui.alert('1、请在选择要关联的服务。');
		return;
	}
    cui.handleMask.show();
	var url = '<cui:webRoot/>/soa/SoaServlet/addServiceToDir?operType=addServiceToDir&serviceCode='+serviceCode+'&dirCode='+dirCode+'&sysCode='+sysCode+'&sysName='+sysName+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
        	     window.parent.location.href='<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
        	     window.parent.cui.alert('服务关联成功。');
        	     
         },
         error: function (msg) {
		         cui.message('服务关联失败。', 'error');
		         window.parent.location.href='<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
              }
     });
}
var page={pageNo:1};
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
	var serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/query?operType=loadOtherService&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "POST",
         url: url,
         contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
         data:{'sysCode':sysCode,'serviceCode':serviceCode},
         beforeSend: function(XMLHttpRequest){
          	XMLHttpRequest.setRequestHeader("RequestType", "ajax");
          },
         success: function(data,status){

        	 if (checkStrEmty(data)){
        		 obj.setDatasource([]);
        		 return;
             }
             
    	     var emptydata = jQuery.parseJSON(data);
    	    //grid数据分页
    	 	obj.setDatasource(emptydata.slice((query.pageNo - 1) * query.pageSize, query.pageNo * query.pageSize), emptydata.length);
          },
         error: function (msg) {
		         cui.message('加载服务失败。', 'error');
              }
     });
}
//宽度自适应
function getBodyWidth () {
  return (document.documentElement.clientWidth || document.body.clientWidth)-7;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}
window.onload = function(){	
	comtop.UI.scan();   //扫描
}

cui.handleMask({
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">保存服务关联信息成功，后台正在重载服务关联操作,请稍等……</font></span></div>'
});
--></script>
</body>
</html>