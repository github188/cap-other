
<%
    /**********************************************************************
			 * 客户端基础数据据及访问授权管理
			 * 2014-10-10 李小强 新建
			 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<%
    pageContext.setAttribute("cuiWebRoot", request.getContextPath());
%>
<!DOCTYPE html>
<html>
<head>
<title>客户端认证维护</title>
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
				<td id="wsAUthorStatusSpanId" style="font-size: 12px" width="35%">&nbsp;</td>
				<td style="text-align: right; padding-top: 10px; padding-right: 5px;" width="35%">
				<cui:button id="editButton" label="增加客户端" icon="${cuiWebRoot}/soa/css/img/add.bmp" on_click="addClient"></cui:button>
				<cui:button id="editButton" label="删除客户端" on_click="deleteClient"></cui:button>
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
					<th renderStyle="text-align: left" style="width: 41%;"
						bindName="name">客户端名称</th>
					<th renderStyle="text-align: left" style="width: 10%;"
						render="renderTypeData">类型</th>
					<th renderStyle="text-align: left" style="width: 25%;"
						bindName="ip1">ip地址</th>
					<th renderStyle="text-align: center" style="width: 11%;"
						bindName="prot">端口</th>
					<th renderStyle="text-align: left" style="width: 8%;"
						render="renderOptions">操作</th>
				</tr>
			</thead>
		</table>
	</cui:bpanel>
</cui:borderlayout>
<script type="text/javascript"><!--
var emptydata = [];
//授权客户端认证
function addClientAuth(){
	var clientIds = cui('#cui_grid_list').getSelectedPrimaryKey();
	if (checkStrEmty(clientIds)){
		cui.alert('请选择一条客户端记录。');
		return;
	}
	   var url = '<cui:webRoot/>/soa/servicemanage/ClientRelNoWsList.jsp?clientIds='+clientIds+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "南网服务客户端授权",
		src : url,
		width: 550,
		height: 500
	    }).show();
}
//新增客户端信息
function addClient(){
   var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoEdit.jsp?timeStamp='+ new Date().getTime();
    cui("#addServiceDialog").dialog({
	modal: true, 
	title: "增加接入客户端",
	src : url,
	width: 550,
	height: 280
    }).show();
}
//编辑客户端信息
function editClient(clientId,name,ip1,prot,type,memo){
	   var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoEdit.jsp?clientId='+clientId
	   +'&name='+name+'&ip1='+ip1+'&prot='+prot+'&type='+type+'&memo='+memo+'&timeStamp='+ new Date().getTime();
	    cui("#addServiceDialog").dialog({
		modal: true, 
		title: "增加接入客户端",
		src : url,
		width: 550,
		height: 280
	    }).show();
	}
var renderOptions = function (rd, index, col){
	 var editHtml='<img height="20px" width="16px" title="编辑" src="<cui:webRoot/>/soa/css/img/edit.png" onClick="editClient(\''+rd.clientId+'\',\''+rd.name+'\',\''+rd.ip1+'\',\''+rd.prot+'\',\''+rd.type+'\',\''+rd.memo+'\');" style="cursor: hand"/>&nbsp;&nbsp;';
   if(rd.type=="2"){	
	   editHtml=editHtml+'<img height="16px" width="16px" title="查看权限" src="<cui:webRoot/>/soa/css/img/editAc.png" onClick="viewRel(\''+rd.clientId+'\');" style="cursor: hand"/>';
	}
	return editHtml;
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

//删除客户端
function deleteClient(){
	var clientId = cui('#cui_grid_list').getSelectedPrimaryKey();
	var clientName = cui("#keyword").getValue();
	if (checkStrEmty(clientId)){
		cui.alert('请选择一条记录。');
		return;
	}
    cui.confirm('<font color="red">确定要进行删除操作?</font>', {
        onYes: function () {
        	var url = '<cui:webRoot/>/soa/SoaServlet/deleteClientById?operType=deleteClientById&clientId='+clientId+'&clientName='+clientName+'&timeStamp='+ new Date().getTime();
            //采用ajax请求提交
            $.ajax({
                 type: "GET",
                 url: url,
                 success: function(data,status){
            	         cui('#cui_grid_list').loadData();
            	         cui.message('删除成功。', 'success');
                  },
                 error: function (msg) {
        		         cui.message('删除失败。', 'error');
                      }
             });
        },
        onNo: function () {
        }
    });

}
function viewRel(clientId){
	 var url = '<cui:webRoot/>/soa/servicemanage/ClientInfoDetailRel.jsp?clientIds='+clientId+'&timeStamp='+ new Date().getTime();
	    cui("#ClientInfoDetailRel").dialog({
		modal: true, 
		title: "客户端权限列表",
		src : url,
		width: 600,
		height: 350
	    }).show();
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
    	 	  renderOperate();
    	   }else{
    		   obj.setDatasource([]);
    	   }

          },
         error: function (msg) {
		         cui.message('加载数据失败。', 'error');
              }
     });
}


function renderOperate(){
	var url = '<cui:webRoot/>/soa/SoaServlet/queryWsAuthorStatus?operType=queryWsAuthorStatus&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){       
    		updateStatusButton(data);
          },
         error: function (msg) {
		         cui.message('加载数据失败。', 'error');
              }
     });
}
function updateStatusButton(data){
	var span = document.getElementById("wsAUthorStatusSpanId");
	if(data == "1"||data==1){
		
		span.innerHTML= "&nbsp;WS身份验证服务:&nbsp;<span style=\"color: green\">已打开</span>&nbsp;<input type='button' style='background:#00ff00;cursor:pointer;border:1px solid rgba(0,0,0,0.21);' value='停用服务' onClick='setWsNeedStatus(\"0\")'>";
	}else if (data == "0"||data==0){
		span.innerHTML=  "&nbsp;WS身份验证服务:&nbsp;<span style=\"color: red\">已关闭</span>&nbsp;<input type='button' style='background:#F32E2E;cursor:pointer;border:1px solid rgba(0,0,0,0.21);' value='启用服务' onClick='setWsNeedStatus(\"1\")'>";
	}else{
		span.innerHTML= "获取失败";
	}
}

function setWsNeedStatus(status){
	var url = '<cui:webRoot/>/soa/SoaServlet/updateWsAuthorStatus?operType=updateWsAuthorStatus&SoaClientRquestWSAuthSwitch='+status+'&timeStamp='+ new Date().getTime();
    //采用ajax请求提交
    $.ajax({
         type: "GET",
         url: url,
         success: function(data,status){
    		updateStatusButton(data);
          },
         error: function (msg) {
		         cui.message('操作失败。', 'error');
              }
     });
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
