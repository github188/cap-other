
<%
/**********************************************************************
* 元数据建模：已部署流程列表
* 2014-10-17 李小强  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>已部署流程列表</title>   
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<!-- dwr js引入-->
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/CipWorkFlowListAction.js"></script>
		   
</head>
<body class="body_layout">
<div class="list_header_wrap">
	<div class="top_float_left">
		<div class="thw_title" style="margin-left:11px;margin-top:0px;">
			<font id="pageTittle" class="fontTitle">已部署流程</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="button" id="unDeploy_Process" label="卸载" on_click="unDeployProcess"></span>
	</div>
</div>
<table id="deployedFlow_grid_list" uitype="Grid" primarykey="deployeId" sorttype="1" datasource="initGridData" pagination="true"  pagesize_list="[10,20,30,50]" resizewidth="resizeWidth" resizeheight="resizeHeight"  colrender="columnRenderer">
 	<tr>
		<th style="width: 5%;"><input type="checkbox"/></th>
		<th renderStyle="text-align: left" style="width: 25%;" bindName="processId" render="renderDeployProcessId">流程ID</th>
		<th renderStyle="text-align: left" style="width: 25%;" bindName="name">流程名称</th>
		<th renderStyle="text-align: left" style="width: 15%;" bindName="version">版本</th>
		<th renderStyle="text-align: left" style="width: 30%;" bindName="deployTime" format="yyyy-MM-dd hh:mm:ss" >部署时间</th>
	</tr>
</table>

<script type="text/javascript"><!--
var dirCode="${param.dirCode}";
var dirCode = "${param.dirCode}";
var perPwd = "${param.perPwd}";
var perAct = "${param.perAct}";
var globalUserId = "${param.globalUserId}";
var globalUserName = "${param.globalUserName}";
	window.onload = function(){
		comtop.UI.scan();
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
	
	// 通过deployeId修改流程，点击流程ID修改流程
	function editDeployedProcess(deployId){
		  var url = '<%=request.getContextPath() %>/bpms/flex/DesignerUI.jsp?perID='+globalUserId+'&perAct='+perAct+'&perPwd='+perPwd+'&perAlias='+globalUserName+'&webRootUrl='+webPath+'&fileType=deploy&operateType=editFile&deployId='+deployId+'&timeStamp='+ new Date().getTime();
		  
// 		  cui("#editDeployedProcessPage").dialog({
// 			modal: false, 
// 			title: "已部署流程修改",
// 			src : url,
// 			width: (document.documentElement.clientWidth || document.body.clientWidth) - 60,
// 			height: (document.documentElement.clientHeight || document.body.clientHeight) - 60
// 		    }).show();
		  var winObj = window.open(url);
		  var loop = setInterval(function() {   
		    if(winObj.closed) {  
		        clearInterval(loop);  
		        window.setTimeout('refresh()',600);
		    }  
		  }, 1000); 
	}
	
	// 根据部署ID卸载流程
	function unDeployProcess(){
		var deployeId = cui('#deployedFlow_grid_list').getSelectedPrimaryKey();
		if (checkStrEmty(deployeId)){
			cui.alert('请选择一条记录。');
			return;
		}
		
		cui.confirm("确定要卸载这"+deployeId.length+"个已部署流程吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				CipWorkFlowListAction.uninstallDeployeById(dirCode,deployeId,globalUserId,function(result){
					cui('#deployedFlow_grid_list').loadData();
					if(result == 'SUCCESS') {
						cui.message("卸载成功。","success");
					} else {
						cui.message(result,"error");							
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
		});
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
	
	//刷新当前页面函数
	function refresh(){
		window.location.reload();
	}
</script>
</body>
</html>
