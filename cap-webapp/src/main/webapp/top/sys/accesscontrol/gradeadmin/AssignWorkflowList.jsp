
<%
    /**********************************************************************
	 * 分级管理员分配岗位
	 * 2014-07-15 谢阳  新建
	 **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<html>
<head>
<title>分配工作流列表</title>

<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AssignManageAuthorityAction.js"></script>


</head>

<body>
	<div class="list_header_wrap">
<!-- 		<div class="top_float_left"> -->
<!-- 			<br/> -->
<!-- 		</div> -->
		
		<div class="top_float_right">
			<span uitype="button" id="button_add" label="保存" on_click="doAdd"></span>
		</div>
	</div>
	<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="dataProvider" primarykey="processId" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
		<tr>
			<th style="width:5%"><input type="checkbox" /></th>
			<th bindName="processId" style="width:30%" sort="true" renderStyle="text-align: left">流程ID</th>
			<th bindName="name" style="width:35%" sort="true" renderStyle="text-align: left">流程名称</th>
			<th bindName="version" style="width:30%" sort="true" renderStyle="text-align: left">流程版本</th>
		</tr>
	</table>
	
<script language="javascript">
	var adminId = "<c:out value='${param.adminId}'/>";
	var moduleCode = "<c:out value='${param.moduleCode}'/>";
	var dataList = null;
	var oldResourceId_arr = [];
	window.onload = function() {
		comtop.UI.scan();
	}
	var query = {};
	// 窗口对象
	var dialog;
	
	//定义grid宽度 
	function resizeWidth() {
		return (document.documentElement.clientWidth || document.body.clientWidth) - 21;
	}

	//定义grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
	}
	//展示页面数据
	function dataProvider(tableObj,query){
		//获取排序字段信息
		var sortFieldName = query.sortName[0];
	    var sortType = query.sortType[0];
		var condition = {pageNo:query.pageNo,pageSize:query.pageSize,
				sortFieldName:sortFieldName,
				sortType:sortType};
		condition.adminId = adminId;
		condition.creatorId = globalUserId;
		condition.moduleCode = moduleCode;
		dwr.TOPEngine.setAsync(false);
		if('SuperAdmin'==globalUserId){
			AssignManageAuthorityAction.querySuperAssignWorkflowList(condition,function(data){
				dataList = data.list;
		    	tableObj.setDatasource(data.list, data.count);
			});
		}else{
			AssignManageAuthorityAction.queryAssignWorkflowList(condition,function(data){
				dataList = data.list;
		    	tableObj.setDatasource(data.list, data.count);
			});
		}
		dwr.TOPEngine.setAsync(true);
		//选中
		oldResourceId_arr = [];
		for(var index in dataList){
			if(dataList[index].isselected==1){
				oldResourceId_arr.push(dataList[index].processId);
				tableObj.selectRowsByPK(dataList[index].processId);
			}
		}
	}

	/**
	**回调函数
	**/
	function addCallBack(selectedKey){
		cui("#speedScan").setValue("");
		cui("#grid").setQuery({pageNo:1,sortType:[],sortName:[]});
		cui("#grid").loadData();
		cui("#grid").selectRowsByPK(selectedKey);
	}

	function doAdd(){
		// isCascade orgId  resourceList
		if(!adminId){
			return;
		}
		var selected = [];
		selected = cui("#grid").getSelectedPrimaryKey();
		dwr.TOPEngine.setAsync(true);
		//循环遍历所有选中的列表数据
		var post_arr = [];
		if(selected!=null && selected.length>0){
			for(var i=0; i<selected.length; i++) {
				if(selected[i]){
					var post_obj = {};
					post_obj.subjectId= adminId;
					post_obj.resourceId= selected[i];
					post_obj.creatorId = globalUserId;
					post_arr.push(post_obj);
				}
			}
		}
		dwr.TOPEngine.setAsync(false);
		AssignManageAuthorityAction.assignWorkflow(adminId,globalUserId,post_arr,oldResourceId_arr,function(result) {
			if("success"==result){
				cui.message('工作流授权成功！','success');
				cui("#grid").loadData();
			}
		});
		dwr.TOPEngine.setAsync(true);

		
	}
</script>
</body>
</html>
