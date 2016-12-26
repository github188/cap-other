<%
/**********************************************************************
* 行为属性编译器页面
* 2015-5-13 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='actionTemplateList'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>行为属性编译器</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>
    <top:link href="/cap/bm/dev/page/designer/css/table-layout.css"/>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <style type="text/css">
    	.list_header_wrap {
    		padding:8px 5px 10px 5px;
    		border-bottom: 1px solid #ccc;
    	}
    	.list_main_wrap {
    		margin:-5px 5px 0 5px;
    	}
		.CodeMirror, .right-area{
			height: 550px;
		}
		.left-area, .right-area{
			overflow-y:auto;
		}
		.left-area{
			height: 486px;
		}
		.tab .addFavorite {
			float: right;
			font-size: 12px;
			font-weight: normal;
			padding: 0 5px;
		}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
	<top:script src="/cap/bm/common/base/js/jsformat.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>
	<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ActionTypeFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/ActionDefineFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/FavoritesFacade.js"></top:script>
</head>
<body ng-controller="actionTemplateListCtrl" data-ng-init="ready()">
<div ng-cloak>
	<div class="list_header_wrap">
		<div class="top_float_left">
			<span id="formTitle" uitype="Label" value="行为模板选择" class="cap-label-title" size="12pt"></span>
		</div>
		<div class="top_float_right">
			<span id="save" uitype="Button" label="确定" on_click="saveData"></span>
			<span id="close" uitype="Button" label="关闭" onClick="closeWindow()"></span>
		</div>
	</div>
	<div class="list_main_wrap">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td ng-switch="type" style="text-align: left; width: 234px;">
		        	<ul ng-switch-when="dev" class="tab">
						<li ng-class="{'tab_base':'active'}[active]" ng-click="showPanel('tab_base')">&nbsp;基本&nbsp;</li>
						<li ng-class="{'tab_biz':'active'}[active]" ng-click="showPanel('tab_biz')">&nbsp;业务&nbsp;</li>
						<li ng-class="{'tab_favorites':'active'}[active]" ng-click="showPanel('tab_favorites')">&nbsp;收藏夹&nbsp;</li>
						<li class="addFavorite" ng-switch="active">
							<span ng-switch-when="tab_favorites" class="cui-icon" style="font-size:12pt;cursor:pointer;" title="整理收藏夹" ng-click="openOrganizeActionFavoritesWin()">&#xf115;</span>
							<span ng-switch-default class="cui-icon" style="font-size:12pt;cursor:pointer;" title="点击收藏" ng-click="openActionBookmarksDialog()">&#xf006;</span>
						</li>
					</ul>

					<ul ng-switch-when="req" class="tab">
						<li ng-class="{'tab_base':'active'}[active]" ng-click="showPanel('tab_base')">&nbsp;控件行为&nbsp;</li>
					</ul>
					
					<div id="actionDefine_area_panel" class="tab_panel">
						<div id="actionFilter" cui_clickinput emptytext="请输入过滤条件" ng-model="data.actionFilter" on_iconclick="searchAction" onkeydown="keyDown(event)" icon="search" iconwidth="18px" editable="true" width="229"></div>
						<div id="tab_base" ng-show="active=='tab_base'" class="tab_base"></div>
						<div id="tab_biz" ng-show="active=='tab_biz'" class="tab_biz"></div>
						<div id="tab_favorites" ng-show="active=='tab_favorites'" class="tab_favorites"></div>
						<div id="actionTree" class="left-area" uitype="Tree" children="initTreeData" on_click="show"></div>
					</div>
		        </td>
		        <td style="text-align: left;">
			        <div class="right-area">
			       	 	<textarea id="code" name="code">
						</textarea>
			        </div>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        </td>
		    </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
    var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
    var type;	
    var action = {};
    
    if(window.opener&&window.opener.pageSession){
		var pageSession = window.opener.pageSession;
		var page;
		if(pageSession!=null){
			page = pageSession.get("page");
		}
	}
	
	var scope = {};
	var compile = {};
	angular.module('actionTemplateList', ["cui"]).controller('actionTemplateListCtrl', function ($scope, $compile) {
    	//默认显示属性tab标签
    	$scope.active='tab_base';
    	$scope.data = {};
    	$scope.tabsModule;
    	$scope.type = "<c:out value='${param.type}'/>";  // 页面使用type，若为req则是需求使用，若无值的话就是开放建模使用
    	$scope.ready=function(){
    		scope=$scope;
    		comtop.UI.scan();
    		editor.setValue('');
	    }

	    initTabsModule();

	    function initTabsModule() {
	    	$scope.type = $scope.type == "" ? 'dev' : $scope.type;		//若为空就为dev
	    	var type = $scope.type;
	    	if(type == 'dev') {
    			$scope.tabsModule = {
	    			tab_base: {modelType: "actionType", modelId: "actionlibrary.actionType.customBase"},
	    			tab_biz: {modelType: "actionType", modelId: "actionlibrary.actionType.customBiz"},
	    			tab_favorites: {modelType: "favorites", modelId: "favorites.favoriteType.customAction"}
	    		};
    		} else if(type == 'req') {
    			$scope.tabsModule = {
	    			tab_base: {modelType: "actionType", modelId: "req.actionlibrary.actionType.component"}
	    			// tab_biz: {modelType: "actionType", modelId: "actionlibrary.actionType.customBiz"},
	    			// tab_favorites: {modelType: "favorites", modelId: "favorites.favoriteType.customAction"}
	    		};
    		}
	    }
    	
    	//切换Tab标签
    	$scope.showPanel=function(selectTabName){
    		if($scope.active != selectTabName){
    			$scope.active = selectTabName;
    			initTreeData(cui("#actionTree"));
	    		action = {};
				editor.setValue('');
				$scope.data.actionFilter = '';
				var hasShow = cui("#actionTree").options.children.length > 0;;
				if(hasShow){
					cui("#actionFilter").show();
				} else {
					cui("#actionFilter").hide();
				}
    		}
    	}
    	
    	//监听选项卡切换事件
    	$scope.$watch("active", function(newValue, oldValue){
    		if(newValue != oldValue){
    			
    		}
    	}, false);
    	
    	//打开新增行为收藏夹窗口
    	$scope.openActionBookmarksDialog=function(){
    		openActionBookmarksDialog();
    	}
    	
    	//打开整理行为收藏夹窗口
    	$scope.openOrganizeActionFavoritesWin=function(){
    		var width=380; //窗口宽度
    	    var height=500; //窗口高度
    	    var top=(window.screen.availHeight-height)/2;
    	    var left=(window.screen.availWidth-width)/2;
    	    var url = webPath + "/cap/bm/dev/page/actionlibrary/OrganizeActionFavorites.jsp?evalParam=window.opener.reloadTreeData()";
    	    window.open(url, "codeEditArea", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
    	}
	});
	
	function closeWindow(){
		if(window.opener){
		  window.close();
		}else{
			window.parent.closeWindowCallback();
		}
	}
	
	//打开新增行为收藏夹窗口
	var addActionBookmarksDialog;
	
	function openActionBookmarksDialog(){
		var url = webPath + "/cap/bm/dev/page/actionlibrary/AddActionBookmarks.jsp";
		if($.isEmptyObject(action)){
    		cui.alert("请选择要收藏的行为模版.");
		} else {
			var height = 420;
			var width = 350;
			if(!addActionBookmarksDialog){
				addActionBookmarksDialog = cui.dialog({
				  	title : "新增行为书签",
				  	src : url,
				    width : width,
				    height : height
				});
			}
			addActionBookmarksDialog.show(url);
		}
	}
	
    /**
	 * 初始化树节点
	 * @param obj 树节点数据源
	 */
 	function initTreeData(obj){
    	var datasource = [];
    	var modelVO = scope.tabsModule[scope.active];
 		if(modelVO.modelType === 'actionType'){
 			datasource = queryActionTypeTreeNode(modelVO.modelId);
 		} else if(modelVO.modelType === 'favorites'){
 			datasource = queryFavoritesTreeNode(modelVO.modelId);
 		}
		obj.setDatasource(datasource);
 	}
    
    /**
	 * 根据行为类型模型Id，获取行为类型模型对象树节点数据
	 * @param modelId 模型Id
	 */
 	function queryActionTypeTreeNode(modelId){
 		var datasource = [];
 		dwr.TOPEngine.setAsync(false);
 		ActionTypeFacade.loadModel(modelId, function(_result){
 			datasource = _result != null ? _result.datasource : datasource;
		});
		dwr.TOPEngine.setAsync(true);
		return datasource;
 	}
 	
 	/**
	 * 根据行为类型模型Id，获取行为类型模型对象树节点数据
	 * @param modelId 模型Id
	 */
 	function queryFavoritesTreeNode(modelId){
 		var datasource = [];
 		dwr.TOPEngine.setAsync(false);
 		FavoritesFacade.loadModel(modelId, function(_result){
 			datasource = _result != null ? _result.datasource : datasource;
		});
 		return datasource;
 	}
    
	//重新加载常用tree数据源
	function reloadTreeData(){
		initTreeData(cui("#actionTree"));
	}
    
 	/**
	 * 点击树节点触发事件
	 * @param node 节点
	 * @param event 事件对象
	 */
 	function show(node, event){
 		if(node.dNode.data.isFolder != true){
 			dwr.TOPEngine.setAsync(false);
 			ActionDefineFacade.loadModelByModelId(node.dNode.data.key, function(data){
 				if(data){
					action=data;
					var script = data.script;
					editor.setValue(script);
 				} else {
 		 			cui.alert("该行为模版已不存在，请更新行为分类模版.");
 					action = {};
 		 			editor.setValue('');
 		 			node.deactivate();
 				}
			});
			dwr.TOPEngine.setAsync(true);
 		} else {
 			action = {};
 			editor.setValue('');
 		}
 	}
 	
 	//确定选中行为模版
 	function saveData(){
 		if(!$.isEmptyObject(action)){
			try{
				if(window.opener){
				    window.opener[callbackMethod](action);
				    window.close();
			    }else{
			    	window.parent[callbackMethod](action);	
			    }
			}catch(err){ 
				console.log(err);
			}
 		} else {
 			cui.alert("请选择行为模版.");
 		}
    }
 	
	var editor;
	//创建codeMirror组件
	editor = CodeMirror.fromTextArea(document.getElementById('code'), {
        //根据页面类型生成codeMirror类型
		viewportMargin: Infinity,
		theme: "eclipse",
		mode: "javascript",
		styleActiveLine: true, //line选择是是否加亮
		lineNumbers: true, //是否显示行数
		lineWrapping: true, //是否自动换行
		readOnly: true
	});
	
	//展开树形结构
	function expandTree(){
		var treeDatas = cui("#actionTree").getDatasource();
		if(treeDatas==null){
			return;
		}
		expandNode(treeDatas);
	}
	
	//展开当前节点及节点下所有子节点
	function expandNode(treeDatas){
		if(treeDatas==null){
			return;
		}
		for(var i=0; i<treeDatas.length; i++){
			var nodeData = treeDatas[i];
			if(nodeData.isFolder==true){
				cui("#actionTree").getNode(nodeData.key).expand(true);
			}
			expandNode(nodeData.children);
		}
	}
	
	function searchAction() {
		if(scope.active === 'tab_favorites') {
			searchFavoritesAction();
		}else {
			searchSysAction();
		}
	}

	//搜索行为
	function searchSysAction(){
		var actionFilter = cui("#actionFilter").getValue();
		dwr.TOPEngine.setAsync(false);
 		ActionTypeFacade.search(scope.tabsModule[scope.active].modelId, actionFilter, function(data){
	 		cui("#actionTree").setDatasource(data);
	 		if($.trim(actionFilter) != ''){
		 		expandTree();
	 		}
		});
		dwr.TOPEngine.setAsync(true);
	}

	function searchFavoritesAction() {
		var actionFilter = cui("#actionFilter").getValue();
		dwr.TOPEngine.setAsync(false);
 		FavoritesFacade.searchAction(scope.tabsModule[scope.active].modelId, actionFilter, function(data){
	 		cui("#actionTree").setDatasource(data);
	 		if($.trim(actionFilter) != ''){
		 		expandTree();
	 		}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//按回车键回调函数
	function keyDown(e) {
	   var ev= window.event||e;
	   //13是键盘上面固定的回车键
	   if (ev.keyCode == 13) {
	   	  searchAction();
	   }
	}
	
</script>
</body>
</html>