<%
/**********************************************************************
* 用户操作日志展现
* 2012-10-30 汪超   新建
**********************************************************************/
%>

<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"></meta>
	<title>日志管理</title>
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	
	<style>
		body{
			margin:0;
		}
	</style>
</head>
<body>
	<div class="list_header_wrap">
		<div class="top_float_left">
			<span uitype="Calender" id="startTimeId1" maxdate="-0d" width="125px"></span>
		</div>
		<div class="top_float_right">
			<span uitype="button" label="查&nbsp;询" on_click="doQuery"></span>
			<span uitype="button" label="导&nbsp;出" on_click="doExport"></span>
		</div>
	</div>
 	<table  uitype="grid" id="userOnlineGrid" primarykey="strGridId" datasource="initData" selectrows="no" pagesize_list="[10,20,30]" 
		adaptive="true" resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer"  >
		<tr>
			<th style="width:150px" sort="false" bindName="orgName" rowspan="2">部门名称</th>
			<th style="width:150px" sort="false" bindName="account" rowspan="2">用户帐号</th>
			<th style="width:150px" sort="false" bindName="userName" rowspan="2">用户名</th>
			<th style="width:150px" sort="false" bindName="operateName" rowspan="2">操作类型</th>
			<th style="width:200px" sort="false" colspan="2">访问时间</th>
			<th style="width:200px" sort="false" colspan="2">用户机器</th>
			<th style="width:200px" sort="false" colspan="2">用户环境</th>
		</tr>
		<tr>
			<th style="width:200px" sort="false" format="yyyy-MM-dd hh:mm:ss" bindName="loginTime">进入时间</th>
			<th style="width:200px" sort="false" format="yyyy-MM-dd hh:mm:ss" bindName="exitTime">退出时间</th>
			<th style="width:200px" sort="false" bindName="remoteAddr">IP</th>
			<th style="width:200px" sort="false" bindName="remoteHost">名称</th>
			<th style="width:200px" sort="false" bindName="envBrowser">浏览器</th>
			<th style="width:200px" sort="false" bindName="envSystem">操作系统</th>
		</tr>
	</table>
	
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/component/topui/cui/js/comtop.ui.min.js'></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/js/jquery.js' ></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/js/commonUtil.js' ></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/engine.js'></script>
<script type="text/javascript" src="<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/util.js"></script>
<script type="text/javascript" src='<c:out value='${pageScope.cuiWebRoot}'/>/top/sys/dwr/interface/UserOnlineAction.js'></script>

<script language="javascript">
	var queryCondition={};
	$(function(){
		comtop.UI.scan();
	});
	
	//渲染列表数据
	function initData(grid, query){
		var statisticsTime = cui('#startTimeId1').getValue();
		if(statisticsTime ==''){
			grid.setDatasource(null, 0);
			return;
		}
		queryCondition.statisticsTime = statisticsTime;
		queryCondition.pageNo = query.pageNo;
		queryCondition.pageSize = query.pageSize;
		UserOnlineAction.queryUserAccessList(queryCondition, function(data){
	        var totalSize = data.count;
	        var dataList = data.list; 
	        grid.setDatasource(dataList, totalSize);
	    });
	}
	
	function resizeWidth(){
	    return (document.documentElement.clientWidth || document.body.clientWidth) - 3;
	}

	function resizeHeight(){
	    return (document.documentElement.clientHeight || document.body.clientHeight) - 40;
	}

	/*
	* 执行查询
	* param:查询参数, 清空快速查询条件
	*/
	function doQuery(){
		var statisticsTime = cui('#startTimeId1').getValue();
		if(statisticsTime ==''){
			cui.alert("请选择查询日期");
			return;
		}

		queryCondition = {};
		cui("#userOnlineGrid").setQuery({pageNo:1});
		queryCondition.statisticsTime = statisticsTime;
		queryCondition.fastQuery = 'no';
		cui("#userOnlineGrid").loadData();
		//清除快速查询的条件
		cui("#speedScan").setValue("");
	}

	/*
	* 执行查询
	* param:查询参数, 清空快速查询条件
	*/
	function doExport(){
		
        //var url = <c:out value='${pageScope.cuiWebRoot}'/>;
		var statisticsTime = cui('#startTimeId1').getValue();
		if(statisticsTime ==''){
			cui.alert("请选择导出日期");
			return;
		}
		cui.handleMask.show();
		queryCondition.statisticsTime = statisticsTime;
		UserOnlineAction.exportUserAccessList(queryCondition, function(data){
			cui.handleMask.hide();
			if(data=="OK"){
	 	        var url = "${pageScope.cuiWebRoot}/top/sys/log/downloadUserAccessList.ac";
	 	        location.href = url;
	        }else{
	        	cui.alert("导出失败，请联系管理员。");
	        }	       
	    });
	}
	
	
	//清空查询条件
	function clearCondition(){
		cui("#organizationName").setValue('');
		cui("#account").setValue('');
	}
	
	/**
	**快速查询, 清空精确查询条件
	**/
	function keyWordQuery(){
		var keyWord = handleStr(cui("#speedScan").getValue());
		queryCondition = {};
		if(keyWord!="关键字搜索"){
			queryCondition.fastQueryValue = keyWord;
			queryCondition.fastQuery = "yes";
		}else{
			queryCondition.fastQuery = "no";			
		}
		cui("#userOnlineGrid").loadData();
		clearCondition();
	} 
</script>
</body>
</html>