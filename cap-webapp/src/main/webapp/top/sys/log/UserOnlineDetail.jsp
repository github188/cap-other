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
			<span uitype="ClickInput"  id="speedScan" name="speedScan" emptytext="关键字搜索" 
				width="260px"  enterable="true" icon="<c:out value='${pageScope.cuiWebRoot}'/>/top/cfg/images/querysearch.gif" 
				on_iconclick="keyWordQuery" maxlength="50" editable="true">
			</span>
		</div>
		<div class="top_float_right">
			<span uitype="Input" id="organizationName" name="organizationName" emptytext="部门名称" width="120"></span>
		    &nbsp;<span uitype="Input" id="account" name="account" emptytext="用户账号"  width="120"></span>
			<span uitype="button" label="查&nbsp;询" on_click="doQuery"></span>
		</div>
	</div>
 	<table  uitype="grid" id="userOnlineGrid" primarykey="strGridId" datasource="initData" selectrows="no"
		adaptive="true" resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer" >
		<tr>
			<th style="width:150px" bindName="orgName" rowspan="2">部门名称</th>
			<th style="width:150px" bindName="account" rowspan="2">用户帐号</th>
			<th style="width:150px" bindName="userName" rowspan="2">用户名</th>
			<th style="width:200px" format="yyyy-MM-dd hh:mm:ss" bindName="loginTime" rowspan="2">进入时间</th>
			<th style="width:200px" bindName="onlineHour" rowspan="2">在线时长</th>
			<th style="width:200px" colspan="2">用户机器</th>
			<th style="width:200px" colspan="2">用户环境</th>
		</tr>
		<tr>
			<th style="width:200px" bindName="remoteAddr">IP</th>
			<th style="width:200px" bindName="remoteHost">名称</th>
			<th style="width:200px" bindName="envBrowser">浏览器</th>
			<th style="width:200px" bindName="envSystem">操作系统</th>
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
		queryCondition.pageNo = query.pageNo;
		queryCondition.pageSize = query.pageSize;
		UserOnlineAction.queryOnlineUserList(queryCondition, function(data){
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
		queryCondition = {};
		queryCondition.orgName = cui("#organizationName").getValue();
		queryCondition.account = cui("#account").getValue();
		queryCondition.fastQuery = 'no';
		queryCondition.fastQueryValue  = cui('#speedScan').getValue();
		cui("#userOnlineGrid").loadData();
		//清除快速查询的条件
		cui("#speedScan").setValue("");
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