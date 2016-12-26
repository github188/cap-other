<%
/**********************************************************************
* 添加行为书签
* 2016-5-20 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='addActionBookmarks'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>添加行为书签</title>
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
			height: 72px;
		}
		.tree_area{
			height: 280px;
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
	<body class="body_layout" ng-controller="addActionBookmarksCtrl" data-ng-init="ready()">
		<div class="header top_header_wrap" style="padding:10px 5px; height: 24px;">
		<span cui_button id="addFolderBtn" on_click="openOrganizeActionFavoritesWin" icon="th-list" label="整理收藏夹"></span>
			<div class="thw_operate" style="float:right;">
				<span cui_button id="saveBtn" ng-click="save()" label="保存"></span>
				<span cui_button id="closeBtn" ng-click="close()" label="关闭"></span>
			</div>
		</div>
		<div class="containers">
			<div class="form_area">
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td" style="text-align: right; width: 100px;"><font color="red">*</font>行为名称：</td>
						<td class="cap-td" style="text-align: left;">
							<span cui_input id="title" name="title" ng-model="data.title" maxlength="28" width="100%" validate="titleValRule"></span>
						</td>
					</tr>
					<tr>
						<td class="cap-td" style="text-align: right;">行为模型ID：</td>
						<td class="cap-td" style="text-align: left;">
							<span cui_input id="key" name="key" ng-model="data.key" maxlength="28" width="100%" readonly="true"></span>
						</td>
					</tr>
				</table>
			</div>
			<div class="selectFavoritesDirectory">
				<div id="tree_area" class="tree_area" uitype="Tree" children="initTreeData" on_click="selectNode"></div>
			</div>
		</div>
		<div class="footer"></div>
		<script type="text/javascript">
		    var actionDefine = window.parent.action;
			var scope = {};
			angular.module('addActionBookmarks', ["cui"]).controller('addActionBookmarksCtrl', function ($scope, $compile) {
				$scope.data = {parentId: ''};
		    	$scope.ready=function(){
		    		scope=$scope;
		    		$scope.init();
		    		comtop.UI.scan();
			    }
		    	
		    	//初始化数据
		    	$scope.init=function(){
		    		if(!$.isEmptyObject(actionDefine)){
			    		$scope.data.title = actionDefine.cname;
			    		$scope.data.key = actionDefine.modelId;
		    		}
		    	}
		    	
		    	//保存
		    	$scope.save=function(){
		    		var result = validateAll();
		    		if(result.validFlag == false){
			    		cui.alert(result.message);
			    		return;
		    		}
		    		dwr.TOPEngine.setAsync(false);
			 		FavoritesFacade.addBookmarks('favorites.favoriteType.customAction', $scope.data, function(_result){
			 			if(_result){//成功
				    		$scope.close();
				    		window.parent.cui.message("收藏成功.", "success");
			    		} else {
			    			cui.alert("收藏失败.");
			    		}
					});
					dwr.TOPEngine.setAsync(true);
		    	}
		    	
		    	//关闭
		    	$scope.close=function(){
		    		window.parent.addActionBookmarksDialog.hide();
		    	}
			});
			
			//打开整理行为收藏夹窗口
			function openOrganizeActionFavoritesWin(event, left){
				var width=380; //窗口宽度
			    var height=500; //窗口高度
			    var top=(window.screen.availHeight-height)/2;
			    var left=(window.screen.availWidth-width)/2;
			    var url = webPath + "/cap/bm/dev/page/actionlibrary/OrganizeActionFavorites.jsp?evalParam=window.opener.reloadInitTreeData()";
			    window.open(url, "codeEditArea", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
			}
			
			/**
			 * 初始化树节点
			 * @param obj 树节点数据源
			 */
		 	function initTreeData(obj){
				var datasource = [];
		 		dwr.TOPEngine.setAsync(false);
		 		FavoritesFacade.queryFolderNodeByModelId('favorites.favoriteType.customAction', function(data){
		 			datasource = data != null ? data : datasource;
				});
				dwr.TOPEngine.setAsync(true);
		 		obj.setDatasource(datasource);
		 	}
			
			//重新初始化树数据源
			function reloadInitTreeData(){
				initTreeData(cui("#tree_area"));
			}
			
		 	/**
			 * 点击树节点触发事件
			 * @param node 节点
			 * @param event 事件对象
			 */
		 	function selectNode(node, event){
		 		scope.data.parentId = node.dNode.data.id;
		 	}
			
		 	var titleValRule = [{type:'required',rule:{m:'行为名称不能为空.'}}];
			
		 	//统一校验函数
			function validateAll(){
		    	var validate = new cap.Validate();
		    	var result = validate.validateAllElement(scope.data, {title: titleValRule});
				return result;
			}
		 	
		</script>
	</body>
</html>