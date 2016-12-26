
<%
/**********************************************************************
* 元数据建模：已部署流程列表
* 2015-1-17 徐庆庆  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>流程选择列表</title>   
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<!-- dwr js引入-->
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
    <top:script src='/cap/dwr/interface/CipWorkFlowListAction.js'></top:script>
		   
</head>
<body class="body_layout">
<div class="list_header_wrap">
	<div class="top_float_left">
		<div class="thw_title" style="margin-left:11px;margin-top:0px;">
			<font id="pageTittle" class="fontTitle">已部署流程</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="button" id="addSureBtn" label="新增" on_click="addWorkflow" hide="true"></span>
		<span uitype="button" id="enSureBtn" label="确定" on_click="enSure"></span>
		<span uitype="button" id="closeBtn" label="取消" on_click="closeSelf"></span>
		<span uitype="button" id="cleanBtn" label="清空" on_click="cleanInfo"></span>
	</div>
</div>
<table id="deployedFlow_grid_list" uitype="Grid" primarykey="deployeId" sorttype="1" datasource="initGridData" 
		pagination="true"  pagesize_list="[10,20,30,50]" resizewidth="resizeWidth" rowdblclick_callback="dbclick"
		resizeheight="resizeHeight" colrender="columnRenderer" selectRows="single">
 <thead>	
 	<tr>
		<th style="width: 5%;"></th>
		<th renderStyle="text-align: left" style="width: 25%;" bindName="processId">流程ID</th>
		<th renderStyle="text-align: left" style="width: 25%;" bindName="name">流程名称</th>
		<th renderStyle="text-align: left" style="width: 15%;" bindName="version">版本</th>
		<th renderStyle="text-align: left" style="width: 30%;" bindName="deployTime" format="yyyy-MM-dd hh:mm:ss" >部署时间</th>
	</tr>
	</thead>
</table>

<script type="text/javascript"><!--

var dirCode="${param.dirCode}"; 
var callfrom="${param.callfrom}"; 
var perPwd = "hello";
var perAct = "SuperAdmin";
var globalUserId = "SuperAdmin";
var globalUserName = "超级管理员";

	window.onload = function(){
		comtop.UI.scan();
		if(callfrom=="entityWizard"){
			cui("#addSureBtn").show();
		}else{
			cui("#addSureBtn").hide();
		}
	};
	
	//补始化列表数据
	function initGridData(tableObj,query){
		dwr.TOPEngine.setAsync(false);
		CipWorkFlowListAction.queryDeployeEdProcesses(dirCode,globalUserId,query.pageNo,query.pageSize,function(data){
			if(data.error!=null){
				 cui.message(data.error, 'error');
			}
			
			tableObj.setDatasource(data.list, data.count);
		    maxSortNo = data.count;	   
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	// 渲染流程id列,添加点击事件
	var renderDeployProcessId = function (rd, index, col){
		return '<a href="javascript:editDeployedProcess(\''+rd.deployeId+'\')">'+rd.processId+'</a>';
	} 
	
	//新增工作流
	function addWorkflow(){
		var urlParam = '?perID='+globalUserId+'&perAct='+perAct+'&perPwd='+perPwd+'&perAlias='
				+globalUserName+'&webRootUrl='+webPath+'&fileType=undeploy&operateType=newFile&timeStamp='+ new Date().getTime();
		var addUnDeployWorkflowUrl = '<%=request.getContextPath() %>/bpms/flex/DesignerUI.jsp'+urlParam;
		// cui("#addProcessDialog").dialog({
		// 	modal: true, 
		// 	draggable: true,
		// 	title: "新增流程",
		// 	src : addUnDeployWorkflowUrl,
		// 	width: (document.documentElement.clientWidth || document.body.clientWidth) - 120,
		// 	height: (document.documentElement.clientHeight || document.body.clientHeight) - 150,
		// 	beforeClose: function () {
				
  //           }
		//  }).show();
		var winObj = window.open(addUnDeployWorkflowUrl);
		var loop = setInterval(function() {   
		    if(winObj.closed) {
		        clearInterval(loop);  
		        window.setTimeout(window.location.reload(),600);
		    }  
		}, 1000); 
	}
	
	// 通过deployeId修改流程，点击流程ID修改流程
	function editDeployedProcess(deployId){
		  var url = '<%=request.getContextPath() %>/bpms/flex/DesignerUI.jsp?perID='+globalUserId+'&perAct='+perAct+'&perPwd='+perPwd+'&perAlias='+globalUserName+'&webRootUrl='+webPath+'&fileType=deploy&operateType=editFile&deployId='+deployId+'&timeStamp='+ new Date().getTime();
		  
		  cui("#editDeployedProcessPage").dialog({
			modal: false, 
			title: "已部署流程修改",
			src : url,
			width: (document.documentElement.clientWidth || document.body.clientWidth) - 60,
			height: (document.documentElement.clientHeight || document.body.clientHeight) - 60
		    }).show();
	}
	
	// 根据部署ID卸载流程
	function enSure(){
		var deployeId = cui('#deployedFlow_grid_list').getSelectedPrimaryKey();
		if (checkStrEmty(deployeId)){
			cui.alert('请选择一条记录。');
			return;
		}
		
		if(callfrom=="entityWizard"){
			window.opener.selProcessBack(cui('#deployedFlow_grid_list').getSelectedRowData()[0]);
			closeSelf();
			return;
		}
		
		if(parent.selProcessBack) {
			parent.selProcessBack(cui('#deployedFlow_grid_list').getSelectedRowData()[0]);
		}
		closeSelf();
	}
	
	//双击选择
	function dbclick(rowData,index){
		parent.selProcessBack(rowData);
		closeSelf();
	}
	
	//关闭
	function closeSelf() {
		if(callfrom=="entityWizard"){
			window.close();			
		}else{
			window.parent.dialog.hide();
		}
	}
	
	//清空
	function cleanInfo() {
		var pWindow = cap.searchParentWindow("cleanProcess");
		if(pWindow.cleanProcess && Object.prototype.toString.call(pWindow.cleanProcess) === "[object Function]") {
			pWindow.cleanProcess();
		}
		closeSelf();
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 1;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
	}
	
	function checkStrEmty(strParam){
	   if(strParam == null || strParam == "" || strParam == "undefined" || strParam == "null"){
	   	  return true;
	   }
	  return false;
	}
</script>
</body>
</html>
