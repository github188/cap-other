<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<% 
   pageContext.setAttribute("cuiWebRoot",request.getContextPath());
%>
<!DOCTYPE HTML>
<html>
<head>
<title>未关联业务系统的服务关联列表</title>
<cui:link
	href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css" />
<cui:link href="/soa/css/soa.css" />
<cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js" />
<cui:script src="/soa/js/jquery.min.js" />
<cui:script src="/soa/js/soa.common.js"/>
</head>
<body class="body_layout">
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
					<th renderStyle="text-align: left" style="width: 43%;" bindName="serviceAddress">服务类(地址)</th>
					<th renderStyle="text-align: center" style="width: 7%;" render="renderOperate">操作</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var dirCode ="";
var sysCode ="";
/**
 * 关联服务列表
 */
function save(){
	var serviceCode = cui('#cui_grid_list').getSelectedPrimaryKey();
    dirCode= window.parent.getDirCode();
    sysCode= window.parent.getSysCode();
	if (checkStrEmty(serviceCode)&&checkStrEmty(dirCode)){
		cui.alert('1、请在该服务类对应的子系统树下选择一个服务目录；<br/>2、请在右侧服务列表中选择至少一条服务信息。');
		return;
	}else if (checkStrEmty(dirCode)){
		cui.alert('请在该服务类对应的子系统树下选择一个服务目录。');
		return;
	}else if (checkStrEmty(serviceCode)){
		cui.alert('1、请在右侧服务列表中选择至少一条服务信息。');
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
            		cui('#saveId').disable(true);
            		cui.handleMask.show();
            		var url = '<cui:webRoot/>/soa/SoaServlet/addServiceToDir?operType=addServiceToDir&serviceCode='+serviceCode+'&dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            	    //采用ajax请求提交
            	    $.ajax({
            	         type: "GET",
            	         url: url,
            	         success: function(data,status){
            	        	     cui.handleMask.hide();
            	        	     window.parent.parent.cui.alert('服务关联成功。');
            	        	     window.parent.parent.location.href='<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            	          },
            	         error: function (msg) {
            			         cui.message('服务关联失败。', 'error');
            			         window.parent.parent.location.href='<cui:webRoot/>/soa/servicemanage/ServiceList.jsp?dirCode='+dirCode+'&sysCode='+sysCode+'&timeStamp='+ new Date().getTime();
            	              }
            	     });
                 }else{
                	 cui.alert('请先设置该业务系统的代理地址、服务器信息。');
                 }
        },
        error: function (msg) {
        	cui.alert('请先设置该业务系统的代理地址、服务器信息。');
        }
    });
}

/**
 * 初始化grid数据
 */
function initGridData(obj,query){
	page=query;
	var serviceCode = cui("#keyword").getValue();
	var url = '<cui:webRoot/>/soa/SoaServlet/loadOtherService?operType=loadOtherService&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "POST",
         url: url,
         contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
         data:{'serviceCode':serviceCode},
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
var renderOperate = function (rd, index, col){
	 if (checkStrEmty(rd.sysCode)){
		 rd.sysCode="";
	 }
	 var editClientHtml='<img height="20px" width="16px" title="测试连通性" src="<cui:webRoot/>/soa/css/img/check.jpg" onClick="testConnection(\''+rd.sysCode+'\',\''+rd.code+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
	 return editClientHtml;
} 
//测试服务连通性
function testConnection(sysCode,code){
	   var url = '<cui:webRoot/>/soa/servicemanage/MyServiceConnectivity.jsp?sysCode='+sysCode+'&code='+code+'&timeStamp='+ new Date().getTime();
	    cui("#testConnection").dialog({
		modal: true, 
		title: "服务连通性测试结果显示",
		src : url,
   		width: 680,
		height: 400
	    }).show();
}
var page={pageNo:1};
//查询数据
function fastQuery(){
	 page.pageNo=1;
	 initGridData(cui('#cui_grid_list'),page);
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
    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">正在执行服务关联操作,请稍等……</font></span></div>'
});
--></script>
</body>
</html>
