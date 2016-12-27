
<%
	/**********************************************************************
	 * 4A同步监控日志
	 * 2014-08-22 杨卫清  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>4A同步监控日志</title>

<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FouraSyncTailAction.js"></script>
<style type="text/css">
body,html {
	margin: 0;
	width: 100%;
}
</style>

</head>
<body>
	<div style="margin-left: 10px">
		<div uitype="bpanel" position="center" id="centerMain"
			header_title="4A同步监控日志" height="500">
			<div class="list_header_wrap">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput"
						editable="true" emptytext="请输入名称" on_keydown="keyDowngGridQuery"
						width="280" on_iconclick="iconclick"
						icon="${pageScope.cuiWebRoot}/top/sys/images/querysearch.gif"></span>
				</div>
			</div>
			<div id="grid_wrap" style="margin-top: 5px">
				<table uitype="grid" id="tailGrid" sorttype="1" selectrows="no"
					datasource="initGridData" pagesize_list="[20,30,50]" pagesize="20"
					primarykey="syncTailId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th bindName="syncName" sort="true">名称</th>
					<th bindName="syncDataType" sort="true">同步类型</th>
					<th bindName="syncDataMethod" sort="true">操作类型</th>
					<th bindName="syncTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">记录时间</th>
					<th bindName="syncInfoNote" renderStyle="text-align: center">描述</th>
					<th bindName="syncState" sort="true"
						renderStyle="text-align: center">状态</th>

				</table>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		queryCondition = {};

		$(document).ready(function() {
			comtop.UI.scan();
		});

		//搜索框图片点击事件
		var gridKeyword = "";
		function iconclick() {
			gridKeyword = cui("#myClickInput").getValue().replace(
					new RegExp("/", "gm"), "//");
			gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
			gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
			gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
			cui("#tailGrid").setQuery({
				pageNo : 1
			});
			cui("#tailGrid").loadData();
		}

		//键盘回车键快速查询 
		function keyDowngGridQuery(event) {

			if (event.keyCode == 13) {
				iconclick();
			}
		}
		function initGridData(grid, query) {
			var sortFieldName = query.sortName[0];
			var sortType = query.sortType[0];
			queryCondition.syncName = gridKeyword;
			queryCondition.pageNo = query.pageNo;
			queryCondition.pageSize = query.pageSize;
			queryCondition.sortFieldName = sortFieldName;
			queryCondition.sortType = sortType;
			FouraSyncTailAction.querySyncTailList(queryCondition,
					function(data) {
						var totalSize = data.count;
						var dataList = data.list;
						grid.setDatasource(dataList, totalSize);
					});
		}

		//Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth() {
			return $('body').width() - 20;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}

		function columnRenderer(data, field) {
			if (field == 'syncDataType') {
				var dataType = data['syncDataType'];
				if (dataType == 1) {
					return "人员"
				} else if (dataType == 2) {
					return "部门";
				} else if (dataType == 3) {
					return "岗位";
				}
			}
			if (field == 'syncDataMethod') {
				var dataMethod = data['syncDataMethod'];
				if (dataMethod == 1) {
                    return "新增";
				} else if (dataMethod == 2) {
					return "修改";
				} else if (dataMethod == 3) {
					return "删除";
				}
			}
			if(field=='syncState'){
				var state=data['syncState'];
				if(state==11||state==21||state==31){
					return "已新增 ";
				}else if(state==12||state==22||state==32){
					return "已修改";
				}else if(state==13||state==23||state==33){
					return "已注销";
				}else if(state==14){
					return "已兼职";
				}else if(state==15){
					return "待撤职";
				}else if(state==16){
					return "已撤职";
				}else if(state==17){
					return "待调岗";
				}else if(state==18){
					return "已调岗";
				}else if(state==0){
					return "待确认处理";
				}else if(state==-1){
					return "数据异常";
				}else{
					return "其他";
				}
			}

		}
	</script>
</body>
</html>