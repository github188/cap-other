<%
    /**********************************************************************
	 * 应用列表页面
	 * 2016-05-9  欧阳辉  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<html> 
<head>
<title>容器管理</title>
<top:link href="/cap/bm/common/top/css/top_base.css"/>
<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
<top:script src='/cap/rt/common/globalVars.js'></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/EvcontralListPageAction.js'></top:script>
	
<style type="text/css">
 .list_header_wrap{
     height:25px;
     margin-right: 9px;
 }
 .container_title{
	float:left;
	font:12px "宋体";
	margin-top:10px;
	margin-left:5px;
	font-weight:bold;
    color: #000;
}
 </style>
</head>

<body style="background-color: #ffffff">
<div id="centerMain">
   <div class="list_header_wrap" >
 	 <div class="thw_title">应用列表</div>
	</div>
	<div id="grid_wrap" style="margin: 0 19px">
		<table id="grid" uitype="grid"  pagination="false" datasource="initData" primarykey="rcName" 
		       colrender="columnRenderer" resizewidth="resizeWidth"  gridheight="600" selectrows="single"  rowclick_callback="selectApp">
		 <thead>
			<tr>
			    <th width="20px;">&nbsp;</th>
				<th bindName="rcName" style="width:25%" renderStyle="text-align: left"   >应用名称</th>
				<th bindName="podCount" style="width:10%" renderStyle="text-align: center"   >副本个数</th>
				<th bindName="createTime" style="width:15%" renderStyle="text-align: center"   >创建时间</th>
                 <th bindName="operate" style="width:18%" renderStyle="text-align: center">操作</th>
			</tr>
		 </thead>
		</table>
	   <div id="ctListId">
	    <div class="list_header_wrap" >
	 	    <div id="containerTitle" class="thw_title">副本管理</div>
			<div id="top_float_right" class="top_float_right" >
				 <span uitype="button" on_click="flushStatus" label="刷&nbsp;&nbsp新"></span>&nbsp;&nbsp;
			</div>
		</div>
		<table id="containerGrid" uitype="grid"  datasource="initCtData" primarykey="containerName"
			       colrender="ctColumnRenderer" resizewidth="resizeWidth"  gridheight="200" selectrows="no" pagination="false">
			 <thead>
				<tr> 
					<th bindName="containerName"  style="width:15%" renderStyle="text-align: center"  >副本名称</th>
					<th bindName="nodeName"  style="width:10%" renderStyle="text-align: center"  >节点IP</th>
					<th bindName="port"  style="width:10%" renderStyle="text-align: center"  >容器端口</th>
					<th bindName="status" style="width:10%" renderStyle="text-align: left">容器状态</th>
					<th bindName="createTime" style="width:15%" renderStyle="text-align: center"   >创建时间</th>
	                <th bindName="operate" style="width:20%" renderStyle="text-align: center">操作</th>
				</tr>
			 </thead>
			</table>
	   </div>
	</div>
</div>
<script type="text/javascript">
	//参数获取
	var envId =  "${param.envId}";
	var envCode =  "${param.envCode}";

	//窗口对象
	var dialog;
	var selectRcName="";
	
	//初始化页面 
	window.onload=function(){		
		comtop.UI.scan();
		document.getElementById("ctListId").style.display="inline";
	}
	
	//渲染页面数据
	function initData(tableObj,query){ 
		var condition = {id:envId,code:envCode};
		//获取容器列表
		EvcontralListPageAction.queryAppList(condition,{
			 callback:function(data){
					tableObj.setDatasource(data,data.length);
					cui("#grid").selectRowsByIndex(0);
					selectApp();
				 },
			 errorHandler:function(message){
				 tableObj.setDatasource([]);
			 },
			 timeout:30000
		 });
	}
	
	/**
	* 列渲染
	**/
	function columnRenderer(initData,field) {
	if(field === 'operate'){
			var reBoot="<a class='a_link' href='javascript:rebootApp(\""+initData["rcName"]+"\");'>重启</a>&nbsp;&nbsp;";
			var deleteApp="<a class='a_link' href='javascript:delApp(\""+initData["rcName"]+"\");'>删除</a>&nbsp;&nbsp;";
			var volume="<a class='a_link' href='javascript:expansion(\""+initData["rcName"]+"\",\""+initData["podCount"]+"\");'>调整副本数</a>&nbsp;&nbsp;";
			//var url=reBoot+stop+deleteApp+volume;
			var url=reBoot+deleteApp+volume;
			return url;
		}
	}
	
	/**
	*  重启应用
	**/
	function rebootApp(rcName){
		if (!rcName) {
		    cui.alert("请选择要重启的应用！");
		} else {
			cui("#grid").selectRowsByPK(rcName);
		    var msg = "确定要重启当前应用吗？";
		    cui.confirm(msg, {
		        onYes: function () {
		        	cui.handleMask.show();
		        	EvcontralListPageAction.rebootAppByRcName(rcName,{
			   			 callback:function(){
		                    		cui.handleMask.hide();
		                    		cui.message('重启成功', 'success');
		                    		setTimeout("selectApp()",50);
			   			},
			   			 errorHandler:function(){
			   				cui.handleMask.hide();
			   			    cui.error("重启当前应用出现异常！");
			   			 },
			   			 timeout:300000
			   	  });
		        }
		    });
		}
	 }
	
	//删除当前应用
	function delApp(rcName){
		if (!rcName) {
		    cui.alert("请选择要删除的应用！");
		} else {
			cui("#grid").selectRowsByPK(rcName);
		    var msg = "确定要删除当前应用吗？";
		    cui.confirm(msg, {
		        onYes: function () {
		        	cui.handleMask.show();
		        	EvcontralListPageAction.deleteAppByRcName(rcName,{
			   			callback:function(){
			   				cui.handleMask.hide();
                    		cui.message('删除成功', 'success');
                    		gridReload();
			   			},
			   			 errorHandler:function(){
			   				cui.handleMask.hide();
			   			    cui.error("删除当前应用出现异常！");
			   			 },
			   			 timeout:300000
			   	  });
		        }
		    });
		}
	}
	
	//应用扩容
	function expansion(rcName,podCount){
		cui("#grid").selectRowsByPK(rcName);
		var url = '${pageScope.cuiWebRoot}/cap/bm/cdp/AppExpansion.jsp?rcName='+rcName + "&podCount=" + podCount;
		var title = "调整副本数";
		var height = 150;  
		var width = 400;  
		if(!dialog){
			dialog = cui.dialog({
				title: title,
				src:url,
				width:width,
				height:height
			});
		}else{
			dialog.setSize({width:width, height:height});
			dialog.setTitle(title);
			dialog.reload(url);
		}
		dialog.show(); 
	}
	
	//调整副本数后回调
	function gridReload(rcName){
		var condition = {id:envId,code:envCode};
		//获取容器列表
		EvcontralListPageAction.queryAppList(condition, {
			 callback:function(data){
				    cui("#grid").setDatasource(data,data.length);
				    if(rcName){
				    	cui("#grid").selectRowsByPK(rcName);
						selectApp();
				    }else{
				    	if(data && data.length > 0){
				    		cui("#grid").selectRowsByPK(data[0].rcName);
				    	}
						selectApp();
				    }
				 },
			 errorHandler:function(message){
				 cui("#grid").setDatasource([]);
			 },
			 timeout:30000
		 });
	}
	
	
	//选中应用
	function selectApp(){
		var appData = cui("#grid").getSelectedRowData();
		if(appData[0]){
			initCtData(cui("#containerGrid"),appData[0]);
			selectRcName = appData[0].rcName;
			document.getElementById("containerTitle").innerHTML="【<font color=\"red\">"+appData[0].rcName+"</font>】副本列表";
		}else{
			cui("#containerGrid").setDatasource([]);
		}
	}
	
	
/*****************************容器数据操作*****************************************************************************/
	//渲染页面数据
	function initCtData(tableObj,query){ 
		if(query && query.rcName){
			//获取容器列表
			EvcontralListPageAction.queryContainerList(query,{
				 callback:function(data){
					 tableObj.setDatasource(data);
				 },
				 errorHandler:function(message){
					 tableObj.setDatasource([]);
				 },
				 timeout:30000
			 });
		}else{
			tableObj.setDatasource([]);
		}
	}
	
	//刷新容器状态
	function flushStatus(){
		var appData = cui("#grid").getSelectedRowData()[0];
		initCtData(cui("#containerGrid"),appData);
	}
	
  /**
	* 列渲染
	**/
	function ctColumnRenderer(initData,field) {
	 if(field === 'operate'){
			var rebooturl="<a class='a_link' href='javascript:rebootContainer(\""+selectRcName+"\",\""+initData["containerName"]+"\");'>重启</a>";
			var logUrl="&nbsp;&nbsp;<a class='a_link' href='javascript:lookLog(\""+selectRcName+"\",\""+initData["containerName"]+"\");'>查看日志</a>";
			var downUrl="&nbsp;&nbsp;<a class='a_link' href='javascript:loadLog(\""+selectRcName+"\",\""+initData["containerName"]+"\");'>下载日志</a>";
			return rebooturl+logUrl+downUrl;
		}
	}
  
	//下载日志
	function loadLog(rcName,containerName){
		downloadLogForm.inRcName.value = rcName;
		downloadLogForm.inContainerName.value = containerName;
		downloadLogForm.submit();
	}
  
	/**
	*  重启容器
	**/
	function rebootContainer(rcName,containerName){
	    var msg = "确定要重启当前容器吗？";
	    cui.confirm(msg, {
	        onYes: function () {
	        	EvcontralListPageAction.rebootContainer(containerName,{
		   			 callback:function(){
		   				cui.message('重启成功', 'success');
		   				containerGridLoad(rcName);
		   			 },
		   			 errorHandler:function(message){
		   			    cui.message("重启当前容器出现异常！", "error");
		   			 },
		   			 timeout:30000
		   			 });
	        }
	    });
	 }
	
	//查看日志
	function lookLog(rcName,containerName){
		var url = '${pageScope.cuiWebRoot}/cap/bm/cdp/ContainerLog.jsp?rcName='+rcName+'&containerName='+containerName;
		var title = "【"+containerName+"】容器日志";
		var height = $(window).height()-150;  
		var width =  $(window).width()-150;  
		if(!dialog){
			dialog = cui.dialog({
				title: title,
				src:url,
				width:width,
				height:height
			});
		}else{
			dialog.setSize({width:width, height:height});
			dialog.setTitle(title);
			dialog.reload(url);
		}
		dialog.show(); 
	}
	
	function containerGridLoad(selectRcName){
		var appData = cui("#grid").selectRowsByPK(selectRcName)[0];
		initCtData(cui("#containerGrid"),appData);
	}
	
	//grid宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 44;
	} 
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 98;
	} 
	
	//load加载膜
    cui.handleMask({
	    html: '<div class="custom_hmstyle"><span id="process"><font color="red" size="5">正在执行中,此过程可能需要耗费较长时间……</font></span></div>'
	});
</script>
<iframe name="downloadFrame" id="downloadFrame" style="display:none;"></iframe>  
<form name="downloadLogForm" id="downloadLogForm" style="display:none" 
		action="<%=request.getContextPath() %>/cap/bm/cdp/downloadPodLog.ac" method="POST"
		target="downloadFrame">
		<input type="hidden" name="inRcName" value=""/>
		<input type="hidden" name="inContainerName" value=""/>
</form>
</body>
</html>
