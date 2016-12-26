<%
/**********************************************************************
* 整理行为收藏夹
* 2016-5-20 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='organizeActionFavorites'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>整理行为收藏夹</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/designer/css/table-layout.css"/>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <style type="text/css">
		.form_area, .tree_area{
			margin: 5px;
			border: 1px solid #eeeeee; 
		}
		.form_area{
			height: 38px;
		}
		.tree_area{
			height: 370px;
			overflow-y:auto;
		}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/FavoritesFacade.js"></top:script>
</head>
	<body class="body_layout" ng-controller="organizeActionFavoritesCtrl" data-ng-init="ready()">
		<div class="header top_header_wrap" style="padding:10px 5px; height: 24px;">
			<span uitype="button" id="addFolderBtn" label="新增文件夹" menu="initMenuBtnDatasource"></span>
			<span cui_button id="delFolderOrBookmarksBtn" ng-click="delFolderOrBookmarks()" label="删除"></span>
			<div class="thw_operate" style="float:right;">
				<span cui_button id="saveBtn" ng-click="save()" label="保存"></span>
				<span cui_button id="closeBtn" ng-click="close()" label="关闭"></span>
			</div>
		</div>
		<div class="containers">
			<div class="form_area">
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td" style="text-align: right; width: 50px;">名称：</td>
						<td class="cap-td" style="text-align: left;">
							<span cui_input id="title" name="title" ng-model="title" maxlength="28" width="100%" validate=""></span>
						</td>
					</tr>
				</table>
			</div>
			<div id="favoritesTree" class="tree_area" uitype="Tree" children="initTreeData" on_click="selectNode"></div>
		</div>
		<div class="footer"></div>
		<script type="text/javascript">
			var evalParam = "<c:out value='${param.evalParam}'/>";
			var scope = {};
			var favoritesVO = {};
			angular.module('organizeActionFavorites', ["cui"]).controller('organizeActionFavoritesCtrl', function ($scope, $compile) {
				$scope.data = {parentId: ''};
		    	$scope.ready=function(){
		    		scope=$scope;
		    		comtop.UI.scan();
			    }
		    	
		    	//监听选项卡切换事件
		    	$scope.$watch("title", function(newValue, oldValue){
		    		if(newValue != oldValue){
		    			var activeNode = cui("#favoritesTree").getActiveNode();
		    			if(activeNode){
			    			activeNode.setTitle(newValue);
		    			}
		    		}
		    	}, false);
		    	
		    	//删除
		    	$scope.delFolderOrBookmarks=function(){
		    		var activeNode = cui("#favoritesTree").getActiveNode();
		    		if(activeNode){
		    			cui.confirm("确定要删除吗？", {
		    				onYes : function() {
		    					activeNode.remove();
		    				}
		    			});
		    		}
		    	}
		    	
		    	//保存
		    	$scope.save=function(){
		    		var datasource = cui("#favoritesTree").getDatasource();
		    		favoritesVO.datasource = datasource;
		    		dwr.TOPEngine.setAsync(false);
			 		FavoritesFacade.saveModel(favoritesVO, function(_result){
			 			if(_result){
			 				eval(evalParam);
			 				cui.message("保存成功.", "success");
			 				$scope.close();
			 			} else {
			 				cui.alert("保存失败.");
			 			}
					});
					dwr.TOPEngine.setAsync(true);
		    	}
		    	
		    	//关闭
		    	$scope.close=function(){
		    		window.close();
		    	}
			});
			
			//初始化新增文件夹按钮数据
		 	function initMenuBtnDatasource(){
		 		var menuData = {
		 				datasource:[
			 				{id:'root',label:'根目录'},
			 				{id:'child',label:'子目录'},
		 				],
		 				on_click: function(obj){
	 						var cuiTreeObj = cui("#favoritesTree");
	 						var activeNode = cuiTreeObj.getActiveNode();
		 					if(obj.id === 'root'){
		 						var datasource = cuiTreeObj.getDatasource();
		 						datasource = datasource != null ? datasource : [];
		 						scope.title = '新增文件夹';
		 						var idValue = 'code_' + (datasource.length + 1);
		 						var newNode = {id: idValue, key: generateRandomId('folder'), title: scope.title, parentId: '0', isFolder: true, icon: webPath + '/top/sys/images/closeicon.gif', activate: true};
		 						var index = _.findIndex(datasource, {isFolder: false});
	 							if(index > -1){
	 								datasource.splice(index, 0, newNode);
	 							} else {
	 								datasource.push(newNode);
	 							}
		 						cuiTreeObj.setDatasource(datasource);
		 						cap.digestValue(scope);
		 					} else if(activeNode && activeNode.dNode.data.isFolder){
		 						var data = activeNode.dNode.data;
				    			var children = activeNode.children();
				    			scope.title = '新增文件夹';
				    			var idValue = data.id +'_' + (children != null ? (children.length + 1) : 1);
				    			var newNode = {id: idValue, key: generateRandomId('folder'), title: scope.title, parentId: data.id, isFolder: true, icon: webPath + '/top/sys/images/closeicon.gif', activate: true};
				    			var firstNotFolderNode = _.find(children, function(n){return n.dNode.data.isFolder === false;});
	 							if(firstNotFolderNode){
	 								activeNode.addChild(newNode, firstNotFolderNode);
	 							} else {
	 								activeNode.addChild(newNode);
	 							}
				    			activeNode.expand(true);
				    			cap.digestValue(scope);
		 					}
		 				}
		 			};
		 		return menuData;
		 	}
			
			/**
			 * 初始化树节点
			 * @param obj 树节点数据源
			 */
		 	function initTreeData(obj){
				var datasource = [];
		 		dwr.TOPEngine.setAsync(false);
		 		FavoritesFacade.loadModel('favorites.favoriteType.customAction', function(data){
		 			if(data){
		 				favoritesVO = data;
		 				datasource = data.datasource;
		 			}
				});
				dwr.TOPEngine.setAsync(true);
		 		obj.setDatasource(datasource);
		 		if(datasource.length > 0){
		 			obj.getNode(datasource[0].key).activate(true);
		 			scope.title = datasource[0].title;
		 		}
		 	}
			
			/**
			 * 点击树节点触发事件
			 * @param node 节点
			 * @param event 事件对象
			 */
		 	function selectNode(node, event){
		 		scope.title = node.dNode.data.title;
		 		cap.digestValue(scope);
		 	}
			
		 	/**
			 * 生成随机数ID
			 * @param prefix 前缀
			 */
			function generateRandomId(prefix){
			      return prefix +"_"+ (90*Math.random()+10).toString().replace(".","");
		    }
		</script>
	</body>
</html>