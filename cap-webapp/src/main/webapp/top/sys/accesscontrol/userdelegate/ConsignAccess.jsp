
<%
	/**********************************************************************
	 * 委托管理:权限分配--展现菜单目录树
	 * 2013-04-09 汪超  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>系统权限页面分配</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">

<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/UserDelegateAction.js"></script>

</head>
    <style type="text/css">
    th {
	font-weight: bold;
	font-size: 14px;
    }
    </style>
<body>
	<div class="list_header_wrap" style="padding-bottom:15px;">
		<div class="top_float_right">
			<span uitype="Button" label="保存" on_click="doSave"></span>
		</div>
	</div>

	<table id="tableList" uitype="Grid" class="cui_grid_list"
		datasource="initData" primarykey="funcId" 
		resizeheight="resizeHeight" resizewidth="resizeWidth">
		<thead>
			<tr>
				<th width="40px" align="center"><input type="checkbox" /></th>
				<th style="width: 85%;" renderStyle="text-align: left"
					bindName="funcName">我的应用</th>
			</tr>
		</thead>
	</table>
</body>
<script type="text/javascript">
	//当前操作人
	var userId = "<c:out value='${param.userId}'/>";
	//委托id
	var consignId = "<c:out value='${param.consignId}'/>";

	//功能数据
	var funcList = [];

	//var totalSize="";
	var moduleId = "";//菜单id
	var moduleName = "";//菜单目录名称
	var initBoxData = [];
	var nodeData = [];
	//扫描，相当于渲染
	window.onload = function() {
		comtop.UI.scan();
	}

	//初始化数据
	function initData(obj, query) {
		
		dwr.TOPEngine.setAsync(false);
		UserDelegateAction.getFuncAccessList(userId, function(data) {
			//加载数据源
			obj.setDatasource(data.list, data.count);
		});
		dwr.TOPEngine.setAsync(true);
		
		
		dwr.TOPEngine.setAsync(false);
		UserDelegateAction.queryUserDelegatedFunc(consignId, function(data) {
			funcList = data.list;
		});
		dwr.TOPEngine.setAsync(true);
		
		if(funcList != null && funcList.length != 0){
			var arr = []
			for(var i=0;i<funcList.length;i++){		
				arr[i] = funcList[i].resourceId;
			}
			obj.selectRowsByPK(arr);
		}
	
	}
	
	
	//自适应宽度
	function resizeWidth() {
		return $('body').width() - 2;
	}
	//自适应高度
	function resizeHeight() {
		return $(document).height() - 65;
	}
	
	//保存委托权限
	function doSave() {
		var funcIds = cui("#tableList").getSelectedPrimaryKey();
		dwr.TOPEngine.setAsync(false);
		UserDelegateAction.delegateUserAccess(consignId, funcIds, globalUserId,
				function(data) {
					if (data) {
						window.cui.message('委托权限更新成功。');
					}
				});
		dwr.TOPEngine.setAsync(true);
	}
</script>
</html>
