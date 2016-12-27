
<%
	/**********************************************************************
	 * 角色管理
	 * 2014-7-21 杨卫清 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/SystemHideTaglibs.jsp" %>

<%@ include file="/top/component/common/AccessTaglibs.jsp" %>

<html>
<head>
<title>角色管理</title>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"
	type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>
<script type="text/javascript"
	src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>

<style type="text/css">
img {
	margin-left: 5px;
}

#addRoleButton {
	margin-right: 5px;
}

.grid_container input {
	margin-left: -3px;
}

th {
	font-weight: bold;
	font-size: 14px;
}

.img1 {
	width:16px;
	background: url(../../images/setting.png) no-repeat;
	height: 16px;
	cursor:pointer;
}

</style>
</head>
<body onload="window.status='Finished';" style="padding-left:5px">

	<div uitype="Borderlayout" id="body" is_root="true">
		<!-- 左边模块树 -->
		<div uitype="bpanel" id="leftMain" style="overflow:hidden" position="left" width="275" show_expand_icon="true">
			<div style="padding-top:60px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:60px;width:100%;">
          <div style = "padding-left:5px;padding-top:5px;">			
						<span uitype="ClickInput" id="keywordModule"
						name="keyword" emptytext="请输入系统应用名称关键字查询"
						on_iconclick="fastModuleQuery"
						icon="search" enterable="true" editable="true" width="240"
						on_keydown="keyDownModuleQuery"></span>
						</div>
						<div style="float:left;padding-left:4px;padding-top:5px;">
							<input type="checkbox" id="associateQuery" align="middle"  title="级联查询"  onclick="setAssociate(0)" style="cursor:pointer;"/>
						</div>
						<div style="float:left;padding-top:2.5px;"><label onclick="setAssociate(1)" style="cursor:pointer;" id="label">&nbsp;级联查询角色</label></div>	
						</div>  
						  <div  id="treeDivHight" style="overflow:auto;height:100%;">
						<div style="width:255px; border:1px solid #ccc;display:none;font: 12px/25px Arial;" id="moduleNameDivBox">
							<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div>
						</div>
						<div id="moduleTree" uitype="Tree" children="initDataModule"
							on_lazy_read="loadNode" on_click="treeClick"
							click_folder_mode="1"></div>
					</div>
					</div>
							
		</div>
	
		<div uitype="bpanel" position="center" id="centerMain"
			header_title="角色列表" height="500">
			<div class="list_header_wrap"  style="padding-top: 15px;padding-bottom: 15px;padding-left: 15px;padding-right:10px;">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput"
						editable="true" emptytext="请输入角色名称或描述关键字查询" on_keydown="keyDowngGridQuery"
						width="280" on_iconclick="iconclick"
						icon="search"></span>
					&nbsp;<span uitype="RadioGroup" name="ball" id="radioGroup" value="1"
						br="[2, 4]" on_change="changeHandler"> <input type="radio"
						value="1" text="自建角色" /><input type="radio" value="2"
						text="委托角色" />
					</span>
				</div>
				<div class="top_float_right" <% if(isHideSystemBtn){ %> style="display:none" <% } %> style="margin-right:5px" >
					<span uitype="button" id="addRoleButton" label="新增角色"
						on_click="addRole"></span>&nbsp;<span uitype="button"
						id="deleteRoleButton" label="删除角色" on_click="deleteRole"></span>&nbsp;
						
				</div>
			</div>
			<div style="padding:0 15px 0 15px">
			<div id="grid_wrap">
				<table uitype="grid" id="roleGrid" 
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="20"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th style="width:30px"><input type="checkbox" /></th>
					<th bindName="roleName" sort="true">角色名称</th>
					<th bindName="description" sort="true">描述</th>
					<th bindName="classifyName" sort="true">所属系统应用</th>
					<th bindName="creatorName" sort="true"
						renderStyle="text-align: center">创建人</th>
					<th bindName="createTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">创建日期</th>
					<th bindName="operator" sort="false"
						renderStyle="text-align: center">操作</th>
				</table>
			</div>
			<div id="grid_wrap2">
				<table uitype="grid" id="roleGrid2" sorttype="1" selectrows="no"
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="20"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th bindName="roleName" sort="true">角色名称</th>
					<th bindName="description" sort="true">描述</th>
					<th bindName="classifyName" sort="true">所属系统应用</th>
					<th bindName="creatorName" sort="true"
						renderStyle="text-align: center">创建人</th>
					<th bindName="createTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">创建日期</th>
					<th bindName="operator" sort="false"
						renderStyle="text-align: center">操作</th>
				</table>
			</div>
</div>

		</div>
	</div>
	<script type="text/javascript">

		var isHideSystemBtn = '<%=isHideSystemBtn %>';
		var activeRoleClassifyId = "";
		var roleClassifyType = "";
		var initBoxData = [];
		var tempMultiNavClickId = "";
		var tempMultiNavClickFatherId = "";
		var tempMultiNavClickName = "";
		var dialog;
		var chooes_type = 0;
		//globalUserId="${param.userName}";
		queryCondition = {};
		var roleWin;
		var curOrgId = "-1";
		//当前选中的树节点
		var curNodeId = '-1';
		var associateType ="";
		
		window.onload = function() {
			comtop.UI.scan();
			$("#treeDivHight").height($("#leftMain").height()-60);
			cui("#grid_wrap2").hide();
			if (globalUserId == 'SuperAdmin') {
				cui("#radioGroup").hide();
			} else {
				chooes_type = 1;
			}
		}
		
		window.onresize= function(){
			setTimeout(function(){
				$("#treeDivHight").height($("#leftMain").height()-60);
			},300);
		}
		
		  //设置级联  1为 级联查询，0为默认
    	function setAssociate(type){
    		var associate=$('#associateQuery')[0].checked;
    		if(type==1){
        		if(associate){
        			$('#associateQuery')[0].checked=false;
        		}else{
        			$('#associateQuery')[0].checked=true;
        		}
        	}
    		 //为1 级联查询
      	    associateType=$('#associateQuery')[0].checked==true?1:0;
    		//判断当前展示的树形结构还是列表查询
    		if($('#moduleNameDivBox').is(":hidden")){
    			//如果树未隐藏
    			var node = cui('#moduleTree').getActiveNode();
    			if(node){
	    			treeClick(node);
    			}
    		}else{
    			//如果树已经隐藏，则判断快速查询出来的结果集中是否有记录被选中
    			//选中则继续后续查询
    			var checkdata = cui('#fastQueryList').getCheckedData();
    			if(checkdata){
    				if(checkdata.data.moduleId){
	    				clickRecord(checkdata.data.moduleId, checkdata.data.moduleName);
    				}
    			}
    		} 
        }
		
		function changeHandler(value) {
			chooes_type = value;
			if (value == 2) {
				cui("#addRoleButton").hide();
				cui("#deleteRoleButton").hide();
				cui("#grid_wrap").hide();
				cui("#grid_wrap2").show();
				cui("#myClickInput").setValue("");
				gridKeyword = "";
				cui("#roleGrid2").setQuery({
					pageNo : 1,
					sortType : [],
					sortName : []
				});
				cui("#roleGrid2").loadData();
			} else if (value == 1) {
				cui("#addRoleButton").show();
				cui("#deleteRoleButton").show();
				cui("#grid_wrap2").hide();
				cui("#grid_wrap").show();
				cui("#myClickInput").setValue("");
				gridKeyword = "";
				cui("#roleGrid").setQuery({
					pageNo : 1,
					sortType : [],
					sortName : []
				});
				cui("#roleGrid").loadData();
			}
		}

		//----------------------------------------------------------------------------------Grid-------------------------------------------
		//----------------------------------------------------------------------------------------------------------------------------------

		//渲染列表数据
		function initGridData(grid, query) {
			var sortFieldName = query.sortName[0];
			var sortType = query.sortType[0];
			queryCondition.pageNo = query.pageNo;
			queryCondition.pageSize = query.pageSize;
			queryCondition.roleClassifyId = activeRoleClassifyId;
			queryCondition.fastQueryValue = gridKeyword;
			queryCondition.sortFieldName = sortFieldName;
			queryCondition.sortType = sortType;
			queryCondition.cascadeQuery = associateType;
			//用户新建角色
			if (chooes_type == 1) {
				queryCondition.creatorId = globalUserId;
				RoleAction.queryRoleList(queryCondition, function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList, totalSize);
				});
			}
			//委托角色
			else if (chooes_type == 2) {
				queryCondition.creatorId = globalUserId;
				RoleAction.queryGradeAdminRoleList(queryCondition, function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList, totalSize);
				});
			} else if(globalUserId=='SuperAdmin'){
				RoleAction.queryRoleList(queryCondition, function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList, totalSize);
				});
			}
		}

		//Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth() {
			return $('body').width() - 321;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}

		function title(rowData, bindName) {
			if (bindName == 'operator') {
				return " ";
			}
		}

		//列渲染
		function columnRenderer(data, field) {
			if(field=='roleType'){
				return data['strRoleType'];
			}
			if (field == 'operator') {
				if (chooes_type==2) {
					var strRole = "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor:pointer' title='角色权限视图' onclick='setRoleAccess(\""
					+ data["roleId"]
					+ "\",\""
					+ data["roleClassifyId"]
					+"\",\""
					+ data["roleName"]
					+ "\");'></img>";
					strRole = strRole + "&nbsp;&nbsp;<img src='${pageScope.cuiWebRoot}/top/sys/images/post.png' style='cursor:pointer' title='关联岗位信息'  onclick='showPost(\""
					+ data["roleId"]
					+ "\",\""
					+ data["roleName"]
					+ "\");'></img>";
					return strRole;
				} else  {
					var strRole = "<img src='${pageScope.cuiWebRoot}/top/sys/images/setting.png' style='cursor:pointer' title='角色授权' onclick='setRoleAccess(\""
						+ data["roleId"] + "\",\"" + data["roleClassifyId"] +"\",\"" + data["roleName"] + "\");'></img>";
					if(isHideSystemBtn != 'true'){
						strRole = strRole + "&nbsp;&nbsp;<img src='${pageScope.cuiWebRoot}/top/sys/images/wrong_fork.gif' style='cursor:pointer' title='删除角色' onclick='deleteOneRole(\""
								+ data["roleId"]
								+ "\",\""
								+ data["roleName"]
								+ "\");'></img>";
					}
					strRole = strRole + "&nbsp;&nbsp;<img src='${pageScope.cuiWebRoot}/top/sys/images/post.png' style='cursor:pointer' title='关联岗位信息'  onclick='showPost(\""
					+ data["roleId"]
					+ "\",\""
					+ data["roleName"]
					+ "\");'></img>";
					return strRole;
							
				} 
			}
			if (field == 'roleName') {
                if(chooes_type!=2){
				return "<a class='a_link' href='javascript:eidtRole(\""
						+ data["roleId"] + "\",\"" + data["creatorId"] + "\",\"" +data["roleClassifyId"] + "\");'>" 
							+ data["roleName"] + "</a>";
                 }

			}
			
		}
		
		//获取角色所属岗位信息
		function showPost(roleId, roleName){
			var height = (document.documentElement.clientHeight || document.body.clientHeight)-100; //300
			var width = (document.documentElement.clientWidth || document.body.clientWidth)-100; // 560;
			var url = 'RolePostMain.jsp?roleId='+roleId;
			var title = "角色（"+ roleName + "）关联的岗位信息";
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}
		
		//设置管理权限
		function setRoleAccess(roleId, roleClassifyId, roleName, roleType) {
			var height = (document.documentElement.clientHeight || document.body.clientHeight)-100; //300
			var width = (document.documentElement.clientWidth || document.body.clientWidth)-100; // 560;
			var url = 'RoleFuncMain.jsp?roleId=' + roleId + "&roleName=" + roleName
					+ "&moduleId=" + roleClassifyId + "&chooes_type="
					+ chooes_type;
			if ("app" == roleType) {
				url = url + "&roleType=app"
			}
			var title = "给角色（" + roleName + "）分配权限";
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}

		//编辑页面回调函数 执行多任务的时候可以带参数，根据参数来判断执行什么操作。
		function editCallBack(roleId) {
			cui("#roleGrid").loadData();
			cui("#roleGrid").selectRowsByPK(roleId);
		}

		function addCallBack(roleId) {
			//清空查询条件，清除题头排序条件
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			cui("#roleGrid").setQuery({
				pageNo : 1,
				sortType : [],
				sortName : []
			});
			cui("#roleGrid").loadData();
			cui("#roleGrid").selectRowsByPK(roleId);
		}

		//搜索框图片点击事件
		var gridKeyword = "";
		function iconclick() {
			gridKeyword = cui("#myClickInput").getValue().replace(
					new RegExp("/", "gm"), "//");
			gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
			gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
			gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
			if (chooes_type == 2) {
				cui("#roleGrid2").setQuery({
					pageNo : 1
				});
				cui("#roleGrid2").loadData();
			} else {
				cui("#roleGrid").setQuery({
					pageNo : 1
				});
				cui("#roleGrid").loadData();
			}
		}

		//键盘回车键快速查询 
		function keyDowngGridQuery(event) {
			if (event.keyCode == 13) {
				iconclick();
			}
		}

		//新增角色
		function addRole() {
			var url = '${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/RoleEdit.jsp?roleClassifyId='
					+ activeRoleClassifyId;
			var title = "";
			var height = 200;
			var width = 500;
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}

		//编辑角色
		function eidtRole(roleId, creatorId, roleClassifyId) {
			var url = '${pageScope.cuiWebRoot}/top/sys/accesscontrol/role/RoleEdit.jsp?creatorId='
					+ creatorId
					+ '&roleClassifyId='
					+ roleClassifyId
					+ '&roleId=' + roleId;
			if (chooes_type == 2) {
				url += "&chooes_type=" + chooes_type;
			}
			var height = 200;
			var width = 500;
			dialog = cui.dialog({
				title : '',
				src : url,
				width : width,
				height : height
			});
			dialog.show(url);
		}

		//删除按钮
		function deleteRole() {
			var selectIds = cui("#roleGrid").getSelectedPrimaryKey();//获取要删除的数据组
			if (selectIds == null || selectIds.length == 0) {
				cui.alert("请选择要删除的角色。");
				return;
			}
			var canDelete = true;
			//如果不是超级管理员，检查是否有委托的角色，有则不允许删除 
			if (globalUserId != 'SuperAdmin') {
				var selectedDatas = cui("#roleGrid").getSelectedRowData();
				for ( var data in selectedDatas) {
					if (globalUserId != selectedDatas[data]["creatorId"]) {
						canDelete = false;
						break;
					}
				}
			}
			var message = "将同时删除人员角色权限，确定要删除这" + selectIds.length + "条角色吗？";
			deleteRoles(selectIds, message);//删除角色
		}

		//列表上删除
		function deleteOneRole(roleId, roleName) {
			cui("#roleGrid").selectRowsByPK(roleId);
			var message = "将同时删除人员角色权限，确定要删除&nbsp;<font color='red'>"
					+ roleName + "</font>&nbsp;吗？";
			var selectIds = new Array();//获取要删除的数据组
			selectIds[0] = roleId;
			deleteRoles(selectIds, message);//删除角色
		}

		//删除角色
		function deleteRoles(selectIds, message) {
			cui.confirm(message,
							{buttons : [{name : '确定',
											handler : function() {
												dwr.TOPEngine.setAsync(false);
												RoleAction.deleteRoles(selectIds,function() {
																	cui("#roleGrid").removeData(cui("#roleGrid").getSelectedIndex());
																	cui("#roleGrid").loadData();
																	cui.message("删除"+ selectIds.length+ "条角色成功","success");
																});
												dwr.TOPEngine.setAsync(true);
											}
										}, {
											name : '取消',
											handler : function() {
											}
										} ]
							});

		}

		//---------------------------------------------------------------	

		//初始化数据 
		function initDataModule(obj) {
			$('#fastQueryList').hide();

			var moduleObj = {
				"parentModuleId" : "-1"
			};
			ModuleAction.queryChildrenModule(moduleObj, function(data) {
				if (data == null || data == "") {
					//当为空时，进行根节点新增操作
					return;
				} else {
					var treeData = jQuery.parseJSON(data);
					treeData.expand = true;
					treeData.activate = true;
					obj.setDatasource(treeData);
					nodeData = treeData;
					var node = cui('#moduleTree').getNode(treeData.key);
					treeClick(node);
				}
			});
		}

		// 树单击事件
		function treeClick(node) {
			var data = node.getData();
			curNodeId = data.key;
			node.select();
			loadRole( data.key);
		}

		function loadRole(id){
			activeRoleClassifyId = id;
			var query = cui("#roleGrid").getQuery();
			query.pageNo = 1;
			//清空查询条件，清除题头排序条件
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			if (chooes_type == 2) {
				cui("#roleGrid2").setQuery(query)
				cui("#roleGrid2").loadData();
			}else{
				cui("#roleGrid").setQuery(query)
				cui("#roleGrid").loadData();
			}
		}
		function showTree() {
			cui('#keyword').setValue('');
			cui('#fastQueryList').hide();
			cui('#moduleTree').show();
			cui.addType = '';
		}

		//点击click事件加载节点方法
		function loadNode(node) {
			curNodeId = node.getData().key;
			dwr.TOPEngine.setAsync(false);
			var moduleObj = {
				"parentModuleId" : node.getData().key
			};
			ModuleAction.queryChildrenModule(moduleObj, function(data) {
				var treeData = jQuery.parseJSON(data);
				treeData.activate = true;
				node.addChild(treeData.children);
				node.setLazyNodeStatus(node.ok);
			});
			dwr.TOPEngine.setAsync(true);
		}

		//快速查询列表数据源
		function listBoxData(obj) {
			initBoxData = [];
			var keyword = cui("#keywordModule").getValue().replace(
					new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			dwr.TOPEngine.setAsync(false);
			ModuleAction.fastQueryModule(keyword, function(data) {
				var len = data.length;
				if (len != 0) {
					$.each(data, function(i, cData) {
						if (cData.moduleName.length > 31) {
							path = cData.moduleName.substring(0, 31) + "..";
						} else {
							path = cData.moduleName;
						}
						initBoxData.push({
							href : "#",
							name : path,
							data : {moduleId:cData.moduleId,moduleName:cData.moduleName},
							title : cData.moduleName,
							onclick : "clickRecord('" + cData.moduleId + "','"
									+ cData.moduleName + "')"
						});
					});
				} else {
					initBoxData.push({
						href : "#",
						name : "没有数据",
						data : {},
						title : "",
						onclick : ""
					});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
		}

		function fastModuleQuery() {
			var keyword = cui('#keywordModule').getValue();
			if (keyword == '') {
				$('#fastQueryList').hide();
				$('#moduleTree').show();
				$('#moduleNameDivBox').hide();
				addType = '';
				var node = cui('#moduleTree').getNode(curNodeId);
				if (node) {
					treeClick(node);
				}
			} else {
				$('#fastQueryList').show();
				$('#moduleTree').hide();
				$('#moduleNameDivBox').show();
				listBoxData(cui('#fastQueryList'));
				addType = 'fastQueryType';
			}
		}

		//键盘回车键快速查询 
		function keyDownModuleQuery() {
        
			if (event.keyCode == 13) {
				fastModuleQuery();
			}
		}
		
		
		function clickRecord(moduleId, modulePath){
			var selectedModuleId = moduleId;
			var moduleName = "";
			var moduleType = "";
			var parentModuleId = "";
			var parentModuleName = "";
			var parentModuleType = "";
			dwr.TOPEngine.setAsync(false);
			ModuleAction.getModuleInfo(selectedModuleId,function(data){
				var moduleVO = data;
				moduleName = moduleVO.moduleName;
				moduleType = moduleVO.moduleType;
				parentModuleId = moduleVO.parentModuleId;
			});	
			dwr.TOPEngine.setAsync(true);

			dwr.TOPEngine.setAsync(false);
			ModuleAction.getModuleInfo(parentModuleId,function(data){
				var parentModuleVO = data;
				if(data == null) {
					parentModuleName = '';
				} else {
					parentModuleName = parentModuleVO.moduleName;
					parentModuleType = parentModuleVO.moduleType;
				}
			});	
			dwr.TOPEngine.setAsync(true);
			loadRole(moduleId);
			
		}
	</script>
</body>
</html>
