<%
/**********************************************************************
* 模块快速构建首页
* 2015-08-02 杨赛
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/template.png">
    <title>模块快速构建页面</title>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <!-- <top:link href="/cap/bm/dev/page/template/css/base.css"/> -->
	<style type="text/css">
		.entity-list-container {
			padding: 10px 10px 0;
		}
		.app_item li {
			float: left;
		    margin: 5px 5px 3px 0px;
		    background-color: #fff;
		    position: relative;
		    transition: all 0.8s cubic-bezier(0.175, 0.885, 0.32, 1);
		    padding: 3px;
		    border-radius: 3px;
		    width: 225px;
		    height: 22px;
		    white-space: nowrap;
		}
		.app_item li img {
			float: left;
    		margin-top: 3px;
		}
		.app_item .selected {
			background-color: #e5e5e5;
		}
	</style>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.all.js"></top:script>
	<!-- <top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script> -->
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<!-- dwr -->
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
</head>
<body ng-app="wizardIndex" ng-controller="wizardIndexCtrl" data-ng-init="ready()">
	<div id="indexLayout" uitype="Borderlayout" is_root="true">
		<div position="top" height="60px" collapsable="true" show_expand_icon="true">
			<div class="entity-list-container">
				<div style="float:left;padding:5px 5px 5px 0px;">
					<span>已选实体：</span>
					<span uitype="Button" label="导入实体" id="menuImportData"  menu="menuImportData"></span>
				</div>
				<ul class="app_item" style="float:left;" ng-cloak>
					<li ng-repeat="entity in entityList track by $index | filter:{entity:'!!'}" ng-class="{selected: entity.modelId == selectedEntity.modelId}">
						<div ng-click="editEntity($index)">
							<img src="<top:webRoot/>/cap/ptc/index/image/biz_entity.png">
							<span>{{entity.engName}}</span>
						</div>
						<i class="colsebtn" ng-click="deleteEntity($index)"></i>
					</li>
				</ul>
			</div>
			<!-- <ng-include src="'entityTopOperate.tmpl.html'"></ng-include> -->
		</div>
		<div position="center" url="Empty.jsp">
			
		</div>
	</div>
	<script type="text/javascript">
		// 需要单独使用cui扫描构建Borderlayout控件，否则ng-include无法正常显示。
		(function (win) {
			// menu="menuImportData" 
			win.menuImportData = { 
						datasource:[
							{id:'item1',label:'数据库导入', href: webPath + '/cap/bm/dev/entity/EntityImport.jsp?packageId=' + cui.utils.param.packageId, target:'_blank'},
							{id:'item1',label:'选择已有实体', href: webPath + '/cap/bm/dev/page/designer/EntityListSelectionMain.jsp?packageId=' + cui.utils.param.packageId
									+'&selectType=multi&filterEntityTypes=query_entity,data_entity&callBackMethod=importEntityCallBack', target:'_blank'}
							//{id:'item2',label:'PDM导入', href: webPath + '/cap/bm/dev/pdm/PdmUpload.jsp?packageId=' + cui.utils.param.packageId, target:'_blank'}
						]
				};
			comtop.UI.scan();
		})(window);
		var scope;
		var packageId = cui.utils.param.packageId;
		var moduleCode = "${param.moduleCode}";
		angular.module('wizardIndex', ['cui']).controller('wizardIndexCtrl', ['$scope','$window', function($scope,$window){
			$scope.entityList = [];
			$scope.selectedEntity;
			scope = $scope;
			
			//初始化方法
			$scope.ready=function(){
				dwr.TOPEngine.setAsync(false);
		   		EntityFacade.queryUnGenerCodeEntityListByPkgId(packageId, function(result){
		  			var entityList = [];
		   			for(var i=0,len=result.length; i<len; i++){
						if("query_entity,data_entity".indexOf(result[i].entityType) == -1){
							entityList.push(result[i]);
						}
					}
		   			scope.entityList = entityList;
		   		}); 
		 		dwr.TOPEngine.setAsync(true);
		 		if(!scope.selectedEntity){
					scope.editEntity(0);
				}
			}
			
			$scope.editEntity = function ($index) {
				if($scope.entityList.length <= $index) {
					return;
				}
				if($scope.selectedEntity && $scope.selectedEntity.modelId === $scope.entityList[$index].modelId) {
					return;
				}
				$scope.selectedEntity = $scope.entityList[$index];
				cui("#indexLayout").setContentURL('center', "EntityWizard.jsp?entityId=" + $scope.selectedEntity.modelId + "&moduleCode=" + moduleCode);
			}

			$scope.deleteEntity = function ($index) {
				cui.confirm('确认要删除信息吗？', {
					onYes: function () {
						deleteEntity($index, $scope.entityList[$index]);
						$scope.$apply();
					},
					onNo: function () {
						
					}
				});
			}

			function deleteEntity(index, entity) {
				var modelId = entity.modelId
				//检查元数据一致性检查不通过则终止执行
				// if(!checkConsistency([modelId],"entity")){
				// 	return;
				// }
				
				//需要判断实体是否允许删除
				dwr.TOPEngine.setAsync(false);
				//验证能否被删除
				var isDeleteEntity = {modelId:modelId};
				var valIsAbleDelete = true;
		 		EntityFacade.isAbleDeleteEntity(isDeleteEntity,function(data){
		 			if(data != "") {
		 				valIsAbleDelete = false;
		 				cui.alert(data);
		 			}else {
		 				valIsAbleDelete = true;
		 			}
		 		});
				//如果不允许删除则直接返回
				if(!valIsAbleDelete) {
					dwr.TOPEngine.setAsync(true);
						return ;
				}
				
				var deleteEntity = [modelId];
				EntityFacade.delEntitys(deleteEntity,function(data){
					if(data){
						// 移除
						$scope.entityList.splice(index, 1);
						if($scope.entityList.length == 0) {
							$scope.selectedEntity = null;
							cui("#indexLayout").setContentURL('center', "Empty.jsp");
						}else if($scope.selectedEntity == entity) {
							$scope.editEntity(0);
						}
						delete $window.pageSessionMap[entity.modelId];
						cui.message("删除实体成功。","success");
						// refreshWindowByOperateType("entity");
					}else{
						cui.message("删除实体失败。","error");
					}
		 		});
		 		dwr.TOPEngine.setAsync(true);

			}

			// 数据库导入回调js方法
			$window.importCallback = function (packageId,tableNames,prefix) {
				EntityFacade.loadEntityListByTableName(packageId,tableNames,prefix, function (entityList) {
					// console.debug(entityList);
					$scope.$apply(function() {
						cui.utils.each(entityList, function(entity) {
							// 去重
							if(entity && cui.utils.find($scope.entityList, function(sEntity){return sEntity.modelId == entity.modelId}) === undefined) {
								$scope.entityList.push(entity);
							}
						});
						// 第一次导入加载第一个实体页面
						if(!$scope.selectedEntity){
							$scope.editEntity(0);
						}
					});
				});
			}
			
			//导入已有实体回调方法
			$window.importEntityCallBack =function (entityList){
				$scope.$apply(function() {
					cui.utils.each(entityList, function(entity) {
						// 去重
						if(entity && cui.utils.find($scope.entityList, function(sEntity){return sEntity.modelId == entity.modelId}) === undefined) {
							$scope.entityList.push(entity);
						}
					});
					// 第一次导入加载第一个实体页面
					if(!$scope.selectedEntity){
						$scope.editEntity(0);
					}
				});
			}
			
			
			//记录生成页面后的结果
			$window.genPageJsonResult={};
			$window.pageSessionMap={};
			
			/**
			 * 设置实体与生成的页面的映射
			 * @param data 元数据录入界面，“生成页面元数据”的返回值
			 */
			$window.setEntityPageMapping = function(data){
				if($scope.selectedEntity && $scope.selectedEntity.modelId){
					genPageJsonResult[$scope.selectedEntity.modelId] = data;
				}
			};

			$scope.showImportEntity = function () {
				window.open(webPath + '/cap/bm/dev/entity/EntityImport.jsp?packageId=' + cui.utils.param.packageId);
			}
			
		}]);
		
		

	</script>
</body>
</html>