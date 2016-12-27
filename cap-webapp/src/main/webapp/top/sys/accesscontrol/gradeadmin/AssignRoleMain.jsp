
<%
	/**********************************************************************
	 * 分级管理资源分配角色列表页面
	 * 2014-7-15  杨卫清 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>角色管理视图</title>
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
	src="${pageScope.cuiWebRoot}/top/sys/dwr/util.js"></script>
<script type="text/javascript"
	src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/GradeAdminAction.js"></script>
	
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
</style>
</head>
<body onload="window.status='Finished';">

	<div uitype="Borderlayout" id="body" is_root="true">
		<!-- 左边模块树 -->
		<div uitype="bpanel" style="overflow:hidden" id="leftMain" position="left" width="288"
			show_expand_icon="true">
			<div style="padding-top:40px;width:100%;position:relative;">
		          <div style="position:absolute;top:0;left:0;height:55px;width:100%;">
		          	
					<div style = "padding-left:5px;padding-top:5px;">
						<span uitype="ClickInput" id="keywordModule" name="keywordModule"
								emptytext="请输入系统应用名称关键字查询" on_iconclick="fastModuleQuery"
								icon="search"
								enterable="true" editable="true" width="260px"
								on_keydown="keyDownModuleQuery"></span>
					</div>
					<div id="associateDiv" style="padding-left:5px;text-align: left;width:186px;font:12px/25px Arial;margin-bottom: 1px;" >
						<input type="checkbox" id="associateQuery" align="middle"  title="级联查询" onclick="setAssociate(0)" style="cursor:pointer;"/>
						<label  onclick="setAssociate(1)" style="cursor:pointer;" id="label"><font color="#2894FF">级联查询角色</font></label>
					</div>
				  </div>
				  
				  <div style="height:15px;width:100%"></div>
	               <div  id="treeDivHight" style="overflow:auto;height:100%;">
							<div id="fastQueryList" uitype="MultiNav" datasource="initBoxData"></div> 
							<div id="moduleTree" uitype="Tree" children="initDataModule"
								on_lazy_read="loadNode" on_click="treeClick"
								click_folder_mode="1"></div>
				   </div>
			</div>

		</div>
		<div uitype="bpanel" position="center" id="centerMain"
			header_title="角色列表" height="500" style="margin-left: 10px">
			<div class="list_header_wrap">
				<div class="top_float_left">
					<span uitype="ClickInput" id="myClickInput" name="clickInput"
						editable="true" emptytext="请输入角色名称或描述关键字查询" on_keydown="keyDowngGridQuery"
						width="271px" on_iconclick="iconclick" icon="search"></span>
				</div>
				<div class="top_float_right">
					<span uitype="button" id="addRoleButton" label="保存"
						on_click="saveRole"></span>
				</div>
			</div>
			<div id="grid_wrap">
				<table uitype="grid" id="roleGrid" sorttype="1" 
					datasource="initGridData" pagesize_list="[10,20,30]" pagesize="20"
					primarykey="roleId" resizewidth="resizeWidth"
					resizeheight="resizeHeight" colrender="columnRenderer"
					titlerender="title">
					
					<th><input type="checkbox"/></th>
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
	    var subjectId="<c:out value='${param.subjectId}'/>";
		var activeRoleClassifyId = "";
		var roleClassifyType = "";
		var resourceTypeCode="ROLE";
		var subjectClassifyCode="ADMIN";
		queryCondition = {};
		var oldResourceIds="";
		var roleWin;
		//当前选中的树节点
		var curNodeId = '-1';
		$(document).ready(function() {
			comtop.UI.scan();
			 $("#treeDivHight").height($("#leftMain").height()-55);
		});

		window.onresize= function(){
			setTimeout(function(){
				$("#treeDivHight").height($("#leftMain").height()-55);
			},300);
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
			cui("#roleGrid").loadData();
		}

		
		//渲染列表数据
		function initGridData(grid, query) {
			oldResourceIds = "";
			var sortFieldName = query.sortName[0];
			var sortType = query.sortType[0];
			queryCondition.pageNo = query.pageNo;
			queryCondition.pageSize = query.pageSize;
			queryCondition.roleClassifyId = activeRoleClassifyId;
			queryCondition.fastQueryValue = gridKeyword;
			queryCondition.sortFieldName = sortFieldName;
			queryCondition.sortType = sortType;
			if(query.associateType!=null && query.associateType!=''){
				queryCondition.cascadeQuery = query.associateType;
			}else{
				queryCondition.cascadeQuery='';
			}
			queryCondition.creatorId=globalUserId;
			
			if (globalUserId == "SuperAdmin") {
				 dwr.TOPEngine.setAsync(false);
				   GradeAdminAction.querySuperAdminRoleList(queryCondition,subjectId, function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					grid.setDatasource(dataList, totalSize);
				});
				 dwr.TOPEngine.setAsync(true);
			}
			 else {
				 dwr.TOPEngine.setAsync(false);
				 GradeAdminAction.queryGradeAdminRoleList(queryCondition,subjectId,function(data) {
					var totalSize = data.count;
					var dataList = data.list;
					
					grid.setDatasource(dataList, totalSize);
				});
				 dwr.TOPEngine.setAsync(true);
			}
			var resourceIdArray=[];
			var resourceIds = oldResourceIds.substring(0, oldResourceIds.length - 1);
			resourceIdArray = resourceIds.split(",");
			if(resourceIdArray.length>0){
				grid.selectRowsByPK(resourceIdArray);
			}
		}

		//Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth() {
			return $('body').width() - 305;
			//return (document.documentElement.clientWidth || document.body.clientWidth) - 297;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
		}

		

		//列渲染
		function columnRenderer(data, field) {
			var isSelect=data["isSelect"];
			var resourceId=data["roleId"];
			if(field=='roleName'&&isSelect==1){
				oldResourceIds+=resourceId+",";
			}
		}
		
		//保存角色
		function saveRole(){
			var selectIds = cui("#roleGrid").getSelectedPrimaryKey();
			var oldResourceIdArray=[];
			oldResourceIds = oldResourceIds.substring(0, oldResourceIds.length - 1);
			oldResourceIdArray = oldResourceIds.split(",");
			dwr.TOPEngine.setAsync(false);
			GradeAdminAction.saveRoleSubjectResource(oldResourceIdArray,selectIds,subjectId,resourceTypeCode,subjectClassifyCode,globalUserId,function() {
				//cui("#roleGrid").removeData(cui("#roleGrid").getSelectedIndex());
				 cui.message("角色授权成功。","success");
				 setTimeout('cui("#roleGrid").loadData()',500);
			});
			dwr.TOPEngine.setAsync(true);
		}
		//搜索框图片点击事件
		var gridKeyword = "";
		function iconclick() {
			gridKeyword = cui("#myClickInput").getValue().replace(
					new RegExp("/", "gm"), "//");
			gridKeyword = gridKeyword.replace(new RegExp("'", "gm"), "''");
			gridKeyword = gridKeyword.replace(new RegExp("%", "gm"), "/%");
			gridKeyword = gridKeyword.replace(new RegExp("_", "gm"), "/_");
			var associateType=$('#associateQuery')[0].checked==true?1:0;
			
			cui("#roleGrid").setQuery({
				pageNo : 1,
				associateType:$('#associateQuery')[0].checked==true?1:0
			});
			cui("#roleGrid").loadData();
		}

		//键盘回车键快速查询 
		function keyDowngGridQuery(event) {
			if (event.keyCode == 13) {
				iconclick();
			}
		}

		//设置级联  1为 级联查询，0为默认
    	function setAssociate(type){
    		var associate=$('#associateQuery')[0].checked;
    		if(type==1){
        		if(associate)$('#associateQuery')[0].checked=false;
        		else $('#associateQuery')[0].checked=true;
        	}
    		//执行查询
// 	     	var activeNode = cui("#roleClassifyTree").getActiveNode();
    		fastModuleQuery();
            
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
			activeRoleClassifyId = data.key;
			var associateType=$('#associateQuery')[0].checked==true?1:0;
			var query = cui("#roleGrid").getQuery();
			query.pageNo = 1;
			query.associateType = associateType;
			//清空查询条件，清除题头排序条件
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			cui("#roleGrid").setQuery(query)
			cui("#roleGrid").loadData();
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
		function listBoxData(obj){
			initBoxData = [];
			var keyword = cui("#keywordModule").getValue().replace(new RegExp("/","gm"), "//");
			keyword = keyword.replace(new RegExp("%", "gm"), "/%");
			keyword = keyword.replace(new RegExp("_","gm"), "/_");
			keyword = keyword.replace(new RegExp("'","gm"), "''");
			dwr.TOPEngine.setAsync(false);
			ModuleAction.fastQueryModule(keyword,function(data){
				var len = data.length ;
				if(len != 0) {
					$.each(data,function(i,cData){
						if(cData.moduleName.length > 31) {
							path=cData.moduleName.substring(0,31)+"..";
						} else {
							path = cData.moduleName;
						}
						initBoxData.push({href:"#",name:path,title:cData.moduleName,onclick:"clickRecord('"+cData.moduleId+"','"+cData.moduleName+"')"});
					});
				} else {
					initBoxData.push({href:"#",name:"没有数据",title:"",onclick:""});
				}
			});
			cui("#fastQueryList").setDatasource(initBoxData);
			dwr.TOPEngine.setAsync(true);
		}
		
		function fastModuleQuery(){
			var keyword = cui('#keywordModule').getValue();
			if(keyword==''){
				$('#fastQueryList').hide();
				$('#moduleTree').show();
				addType = '';
				var node=cui('#moduleTree').getNode(curNodeId);
				if(node){
					treeClick(node);
				}
			}else{
				$('#fastQueryList').show();
				$('#moduleTree').hide();
				listBoxData(cui('#fastQueryList'));
				addType = 'fastQueryType';
			}
		}

		//键盘回车键快速查询 
		function keyDownModuleQuery() {
		
			if ( event.keyCode ==13) {
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

			//curNodeId = moduleId
// 			var node = cui('#moduleTree').getNode(curNodeId);
// 			node.select();
			activeRoleClassifyId = moduleId;
			var query = cui("#roleGrid").getQuery();
			var associateType=$('#associateQuery')[0].checked==true?1:0;
			query.pageNo = 1;
			query.associateType = associateType;
			
			//清空查询条件，清除题头排序条件
			cui("#myClickInput").setValue("");
			gridKeyword = "";
			cui("#roleGrid").setQuery(query)
			cui("#roleGrid").loadData();
		}
	</script>
  </body>
</html>
