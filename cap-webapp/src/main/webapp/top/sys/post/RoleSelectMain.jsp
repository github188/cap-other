<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>角色选择界面</title>
<meta http-equiv="X-UA-Compatible" content="edge" />
<link rel="stylesheet"  href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet"href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"  type="text/css">
<script type="text/javascript"  src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript"  src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"  src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/RoleAction.js"></script>
<script type="text/javascript"  src='${pageScope.cuiWebRoot}/top/sys/dwr/interface/ModuleAction.js'></script>
<style type="text/css">
img {
	margin-left: 5px;
}





.grid_container input {
	margin-left: -3px;
}
</style>
</head>
<body onload="window.status='Finished';">

	<div uitype="Borderlayout" id="body" is_root="true">
		<!-- 左边模块树 -->
		<div uitype="bpanel" style="overflow:hidden" id="leftMain" position="left" width="240"
			show_expand_icon="true">
			<div style="padding-top:60px;width:100%;position:relative;">
          <div style="position:absolute;top:0;left:0;height:40px;width:100%;">
				<div style = "padding-left:5px;padding-top:5px;">
				<span uitype="ClickInput" id="keywordModule"
							name="keyword" emptytext="请输入系统或模块名称关键字查询"
							on_iconclick="fastModuleQuery"
							icon="search"
							enterable="true" editable="true" width="225"
							></span>
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
			<div class="list_header_wrap" style="padding:10px 5px 10px 5px;">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput"
						editable="true" emptytext="请输入角色名称或描述关键字查询" on_keydown="keyDowngGridQuery"
						width="225" on_iconclick="iconclick"
						icon="search"></span>
					<span uitype="RadioGroup" name="ball" id="radioGroup" value="1"
						br="[2, 4]" on_change="changeHandler"> <input type="radio"
						value="1" text="自建角色" /> <input type="radio" value="2"
						text="委托角色" />
					</span>
				</div>
				<div class="top_float_right">
					<span uitype="button" id="addRoleButton" label="添加角色"
						on_click="addRole"></span> 
				</div>
			</div>
			<div id="grid_wrap" style="padding-left: 5px">
				<table uitype="grid" id="roleGrid" sorttype="1"
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="20"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th style="width:30px;"><input type="checkbox" /></th>
					<th bindName="roleName" sort="true">角色名称</th>
					<th bindName="description" sort="true">描述</th>
					<th bindName="creatorName" sort="true"
						renderStyle="text-align: center">创建人</th>
					<th bindName="createTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">创建日期</th>
					<th bindName="strRoleType" sort="true"
						renderStyle="text-align: center">角色类型</th>
					
				</table>
			</div>

			<div id="grid_wrap2">
				<table uitype="grid" id="roleGrid2" sorttype="1" 
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="20"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					<th><input type="checkbox" /></th>
					<th bindName="roleName" sort="true">角色名称</th>
					<th bindName="description" sort="true">描述</th>
					<th bindName="creatorName" sort="true"
						renderStyle="text-align: center">创建人</th>
					<th bindName="createTime" sort="true"
						renderStyle="text-align: center" format="yyyy-MM-dd">创建日期</th>
					<th bindName="strRoleType" sort="true"
						renderStyle="text-align: center">角色类型</th>
					
				</table>
			</div>



		</div>
	</div>
	<script type="text/javascript">
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
		var associateType ="";
		//当前选中的树节点
		var curNodeId = '';
		$(document).ready(function() {
			cui("#grid_wrap2").hide();
			comtop.UI.scan();
			$("#treeDivHight").height($("#leftMain").height()-40);
			if (globalUserId == 'SuperAdmin') {
				cui("#radioGroup").hide();
			} else {
				chooes_type = 1;
			}
		});
		
		window.onresize= function(){
        	$("#treeDivHight").height($("#leftMain").height()-40);
        }

		//快速查询
		function fastQuery() {
			var keyword = cui('#keyword').getValue().replace(
					new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");
			if (keyword == '') {
				switchTreeListStyle("tree");
				//TODO 必须选择节点，并刷新右侧iframe
				var node = cui('#roleClassifyTree').getNode(curNodeId);
				if (node) {
					treeClick(node);
				}
			} else {
				switchTreeListStyle("list");
				listBoxData(cui('#fastQueryList'), keyword);
			}
		}
		//双击列表记录
		function selectMultiNavClick(roleClassifyId, roleClassifyName,
				fatherClassifyId) {
			tempMultiNavClickId = roleClassifyId;
			tempMultiNavClickFatherId = fatherClassifyId;
			tempMultiNavClickName = roleClassifyName;
			var selectedRoleClassifyId;
			if (roleClassifyId == null) {
				selectedRoleClassifyId = '';
			} else {
				selectedRoleClassifyId = roleClassifyId;
			}
			activeRoleClassifyId = selectedRoleClassifyId;
			cui("#roleGrid").loadData();
		}
		function changeHandler(value) {
			chooes_type = value;
			if (value == 2) {
			
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
		//-----------------------------------------------------------------------------------新增编辑框弹出前预处理区域-----------------------------------		
		//----------------------------------------------------------------------------------------------------------------------------------------------
		//获得树选中节点，刷新右侧
		function refreshRoleList() {
			var activeNode = cui("#roleClassifyTree").getActiveNode();
			if (!activeNode) {
				cui.alert("请选择节点。");
				cui('#body').setContentURL("center", "");
				return;
			}
			activeRoleClassifyId = activeNode.getData().key;
			if (chooes_type == 2) {
				cui("#roleGrid2").loadData();
			} else {
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
			return $('body').width() - 250;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 50;
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

		//添加角色到岗位
		function addRole() {
			var selectIds ;
			if(chooes_type==2){
				 selectIds = cui("#roleGrid2").getSelectedPrimaryKey();
            }else{
			     selectIds = cui("#roleGrid").getSelectedPrimaryKey();
			}
			
			if(selectIds == null || selectIds.length == 0){
				cui.alert("请选择添加的角色。");
				return;
			}
			window.top.cuiEMDialog.wins['selectRole'].addRoleToPost(selectIds);

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
			curOrgId = node.getData().key;
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
			
			var keyword = cui('#keywordModule').getValue().replace(
					new RegExp("/", "gm"), "//");
			keyword = keyword.replace(new RegExp("'", "gm"), "''");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_", "gm"), "/_");

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
		
	</script>
</body>
</html>
