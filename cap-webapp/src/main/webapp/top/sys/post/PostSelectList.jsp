
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
<title>分配岗位列表</title>

<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/AssignManageAuthorityAction.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/PostOtherAction.js"></script>


</head>

<body>
	<div class="list_header_wrap">
		<div class="top_float_left">
			<span uitype="ClickInput" editable="true" id="speedScan" name="keyword" emptytext="请输入岗位名称关键字查询" 
				width="200" maxlength="500" icon="search" on_keydown="keyDownQuery" on_iconclick="keyWordQuery" ></span><br/>
		</div>
		<div class="top_float_right">
			<span uitype="button" id="button_add" label="添加" on_click="doAdd"></span>
		</div>
	</div>
	<div id="doSaveAllBtn" style="display: none;text-align: left; margin-top:30px;margin-left:5px;line-height: 20px;"></div>
	<table id="grid" uitype="grid" pagesize_list="[10,20,30]" datasource="dataProvider" pagination_model="pagination_min_3"  primarykey="POST_ID" colrender="columnRenderer" resizewidth="resizeWidth"  resizeheight="resizeHeight" >
		<tr>
			<th style="width:5%"><input type="checkbox" /></th>
			<th bindName="POST_NAME" style="width:25%" sort="true" renderStyle="text-align: left" sort="true">岗位名称</th>
			<th bindName="ORG_NAME" style="width:25%" sort="true" renderStyle="text-align: left" sort="true">所属组织</th>
			<th bindName="POST_CODE" style="width:25%" sort="true" renderStyle="text-align: left" sort="true">岗位编码</th>
			
		</tr>
	</table>
	
<script language="javascript">
	
	var orgId = "<c:out value='${param.orgId}'/>";
	var associateType = "<c:out value='${param.associateType}'/>";
	var orgName = "<c:out value='${param.orgName}'/>";
	   //标准岗位id
    var postId ="<c:out value='${param.postId}'/>";
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
				sortName:sortFieldName,
				sortType:sortType};
		var fastQueryValue = cui("#speedScan").getValue().replace(new RegExp("%", "gm"), "/%");
		fastQueryValue = fastQueryValue.replace(new RegExp("_", "gm"), "/_");
		fastQueryValue = fastQueryValue.replace(new RegExp("'","gm"), "''");
		fastQueryValue = fastQueryValue.replace(new RegExp("/","gm"), "//");
		if(fastQueryValue != '') {
			condition.fastQueryValue = fastQueryValue;
		}
		condition.adminId = globalUserId;
		condition.creatorId = globalUserId;
		condition.orgId = orgId;
		condition.isCascade = associateType
		dwr.TOPEngine.setAsync(false);
		if(globalUserId=='SuperAdmin'){
			//超管
			AssignManageAuthorityAction.querySuperAssignPostList(condition,function(data){
				dataList = data.list;
		    	tableObj.setDatasource(data.list, data.count);
			});
		}else{
			AssignManageAuthorityAction.queryAssignPostList(condition,function(data){
				dataList = data.list;
		    	tableObj.setDatasource(data.list, data.count);
			});
		}
		dwr.TOPEngine.setAsync(true);
		//选中
		oldResourceId_arr = [];
		for(var index in dataList){
			if(dataList[index].ISSELECTED==2){
				oldResourceId_arr.push(dataList[index].POST_ID);
				tableObj.selectRowsByPK(dataList[index].POST_ID);
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

       var selectIds = cui("#grid").getSelectedPrimaryKey();

		if(selectIds == null || selectIds.length == 0){
			cui.alert("请选择添加的岗位。");
			return;
		}

		 dwr.TOPEngine.setAsync(false);
		 PostOtherAction.updatePostStandardRelation(postId,selectIds,1,function(){
		    	window.cui.message('添加岗位成功。','success');
		 		window.top.cuiEMDialog.wins['selectPost'].cui("#postGrid").loadData();
     	 });
		 dwr.TOPEngine.setAsync(true);
	}
	
	function keyWordQuery(){
		var fastQueryValue = cui('#speedScan').getValue(); 
		var tableObj = cui('#grid');
		tableObj.setQuery({pageNo:1});
		tableObj.loadData();
	}
	
	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			keyWordQuery();
		}
	} 
</script>
</body>
</html>
