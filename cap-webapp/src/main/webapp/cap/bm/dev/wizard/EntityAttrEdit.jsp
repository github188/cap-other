<!-- 
* 模块快速构建：实体属性编辑（第二步）
* 2015-08-03 杨赛
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" deferredSyntaxAllowedAsLiteral="true"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">	<title>实体属性编辑</title>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/template/css/base.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/dev/wizard/css/stepNav.css"></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.all.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/dev/wizard/js/entityService.js"></top:script>
    <top:script src="/cap/bm/dev/wizard/js/angularUtils.js"></top:script>
	<!-- dwr -->
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/MetadataGenerateFacade.js"></top:script>

</head>
<body ng-app="entityAttrEdit" ng-controller="entityAttrEditCtrl">
	
	<div class="cap-page" ng-cloak>
		<div ng-repeat="entityViewVO in entityViewVOList track by entityViewVO.modelId">
			<div style="width:100%;text-align:right;padding-bottom:10px">
				<span cui_button label="新增" ng-click="add(entityViewVO)" ng-disabled="true"></span>
			    <span cui_button id="delete_button" label="删除" ng-click="delete(entityViewVO)"></span>
			    <span cui_button id="up_button_{{entityViewVO.modelId}}" label="上移" ng-click="up(entityViewVO)" ></span>
			    <span cui_button id="down_button_{{entityViewVO.modelId}}" label="下移" ng-click="down(entityViewVO)" ></span>
				<!-- <span cui_button label="上一步" ng-click="saveDataAndPre()" ></span> -->
			    <span cui_button label="保存" ng-click="saveData()"></span>
			    <!-- <span cui_button label="下一步" ng-click="saveDataAndNext()" ></span> -->
			</div>
			<table class="custom-grid" style="width: 100%;">
		        <thead>
		            <tr>
		            	<th width="30px">
		            		<input type="checkbox" ng-model="entityViewVO.isCheckAll" ng-change="checkAll(entityViewVO)">
		                </th>
		                <th width="10%">
		                	实体属性
		                </th>
						<th width="10%">
		                	属性中文名
		                </th>	
						<th width="12%">
		                	实体属性枚举
		                </th>
						<th width="15%">
		                	查询表达式
		                </th>
		                <th width="7%">
		                	界面配置
		                </th>
		                <th width="10%">
		                	控件类型
		                </th>
		                <th>
		                	控件属性
		                </th>
		            </tr>
		        </thead>
		        <tbody>
		        	<tr ng-repeat="attriViewVO in entityViewVO.attriViewVOList track by $index">
		            	<td style="text-align: center;">
		                    <input type="checkbox" name="componentCheck-{{($index + 1)}}" ng-model="attriViewVO.check" ng-change="check(entityViewVO)">
		                </td>
		                <td style="text-align: center;">
		                	<span width="100%" cui-input ng-if="isShowQueryExpr(attriViewVO)" validate="validateAttrEnName(entityViewVO)" ng-model="attriViewVO.attriVO.engName"></span>
		                	
		                	<span width="100%" cui-input ng-if="!isShowQueryExpr(attriViewVO)" readonly="true" validate="validateAttrEnName(entityViewVO)" ng-model="attriViewVO.attriVO.engName"></span>

		                </td>
		                <td style="text-align: center;">
		                	<span width="100%" cui-input ng-if="isShowQueryExpr(attriViewVO)" validate="validateAttrChName" ng-model="attriViewVO.attriVO.chName"></span>
		                	
		                	<span width="100%" cui-input ng-if="!isShowQueryExpr(attriViewVO)" readonly="true" validate="validateAttrChName" ng-model="attriViewVO.attriVO.chName"></span>
		                </td>
		                <td style="text-align: center;">
		                	<!-- <span width="80%" readonly="true" cui-input ng-show="" ng-model="attriViewVO.attriVO.attributeType.value"></span> -->
		                	<span width="100%" ng-show="isShowQueryExpr(attriViewVO)" cui-clickinput ng-model="attriViewVO.attriVO.attributeType.value" ng-click="showDictDialog(attriViewVO)"></span>
		                </td>
		                <td style="text-align: center;">
		                	<span width="100%" ng-show="isShowQueryExpr(attriViewVO)" cui-clickinput ng-model="attriViewVO.attriVO.queryExpr" ng-click="showQueryExprDialog(attriViewVO)"></span>
		                </td>
		                <td style="text-align: center;" ng-switch on=" isShowPageConfig(attriViewVO) && entityViewVO.relationType">

		                	<span ng-switch-when="One-Many">
		    				   <input type="checkbox" ng-model="attriViewVO.pageConfigVO.configArea" ng-true-value="4" ng-change="changePageConfig(attriViewVO)"/> 编辑列
		                	</span>
		                	<span ng-switch-when="false">
		                		<!-- 关联属性不显示任何编辑属性 -->
		                	</span>
		                	<span ng-switch-when="One-One">
		                		<!-- 关联属性不显示任何编辑属性 -->
		                		One-One
		                	</span>
		                	<span ng-switch-default>
		    		           <span cui-pulldown ng-model="attriViewVO.pageConfigVO.configArea" value_field="id" label_field="text" mode="Multi" width="100%" ng-change="changePageConfig(attriViewVO)">
		    						<a value="0">编辑字段</a>
		    						<a value="1">列表字段</a>
		    						<a value="2">固定查询</a>
		    						<a value="3">更多查询</a>
		    				   </span>
		                	</span>

		                </td>
		                <td style="text-align: center;">
		                	<span cui-pulldown ng-if="isShowPageConfig(attriViewVO)" ng-model="attriViewVO.pageConfigVO.componentModelId" value_field="componentModelId" label_field="modelName" datasource="getComponentList" width="100%" ng-change="changeComponent(attriViewVO)">
		                </td>
		                <td>
		                	<ng-include src="showComponentProPerty(attriViewVO)"></ng-include>
		                </td>
		            </tr>
		       	</tbody>
	    	</table>
		</div>
	</div>
</body>
<script type="text/javascript">

	angular.module('entityAttrEdit', ['cui', 'metadata', 'utils']).controller('entityAttrEditCtrl', ['$scope', '$window', 'EntityServer', 'ComponentServer', 'utils', function($scope, $window, EntityServer, ComponentServer, utils){

		// 获取父页面的pageSession
		var pageSession = $window.parent.pageSession;

		var metadataGenerateVO;
		
		var entityId = cui.utils.param.entityId;
		var entityViewVOList = $scope.entityViewVOList = pageSession.get("page_session_entityViewVOList", []);
		// 属性view VO 方便于页面展示
		// var attriViewVOList = $scope.attriViewVOList = pageSession.get("page_session_attriViewVOList", []);
		
		var relationMap = {};
		var relationAttrMap = {};

		// var primaryAttr = pageSession.get("page_session_primaryAttr");

		$scope.entity = null;

		// 关联的实体集合
		var relationEntitys = [];

		initData();

		function initData() {
			if(!entityId) {
				console.error("entityId can not be null.");
				return;
			}
			var entity = $scope.entity = pageSession.get("page_session_entity");
			if(!entity) {
				console.error("can not find entity by entityId: %s", entityId);
				return;
			}
			if(_.isEmpty(entityViewVOList)) {
				createEntityViewVOList(entity);
			}else {	 // 由于关系会发生变化导致字段会变化，需要同步entityViewVOList
				syncEntityViewVOList(entity, entityViewVOList);
			}
			metadataGenerateVO = pageSession.get("page_session_metadataGenerateVO", {});
		}
		
		function initRelationMap(entity) {
			_.forEach(entity.lstRelation, function (relation) {
				return relationMap[relation.relationId] = relation;
			});
		}

		function syncEntityViewVOList(entity, oldEntityViewVOList) {
			var entityViewVOMap = {};
			_.forEach(oldEntityViewVOList, function (entityViewVO) {
				entityViewVOMap[entityViewVO.modelId] = entityViewVO;
			});

			entityViewVOList.length = 0;
			initRelationMap(entity);
			entityViewVOList.push(createEntityViewVO(entity, entityViewVOMap[entity.modelId]));
			// 获取关联关系实体
			_.forEach(entity.lstRelation, function (relation) {
				if(relation.multiple == 'One-Many') {	// 由于第三步模板只支持一对多，故暂时只处理一对多的关联关系
					var relationEntity = EntityServer.getEntityById(relation.targetEntityId);
					relationEntitys.push(relationEntity);
					var entityViewVO = createEntityViewVO(relationEntity, entityViewVOMap[relationEntity.modelId]);
					entityViewVO.relation = relation;
					entityViewVO.relationType = relation.multiple;
					entityViewVO.relationAttr = relationAttrMap[relation.relationId];
					entityViewVOList.push(entityViewVO);
				}
			});
		}

		function createEntityViewVOList(entity) {
			initRelationMap(entity);
			entityViewVOList.push(createEntityViewVO(entity));
			// 获取关联关系实体
			_.forEach(entity.lstRelation, function (relation) {
				if(relation.multiple == 'One-Many') {	// 由于第三步模板只支持一对多，故暂时只处理一对多的关联关系
					var relationEntity = EntityServer.getEntityById(relation.targetEntityId);
					relationEntitys.push(relationEntity);
					var entityViewVO = createEntityViewVO(relationEntity);
					entityViewVO.relation = relation;
					entityViewVO.relationType = relation.multiple;
					entityViewVO.relationAttr = relationAttrMap[relation.relationId];
					entityViewVOList.push(entityViewVO);	
				}
				
				//TODO 待确认一对一如何处理
				if(relation.multiple == 'One-One') {	
					var relationEntity = EntityServer.getEntityById(relation.targetEntityId);
					console.log(relationEntity);
				}
				
			});
		}

		// entityViewVO 数据结构图
		// {
		// 	modelId: entity.modelId,
		// 	entity: entity,
		// 	primaryAttr: null,
		// 	relationAttr:null,		// 存放关联实体的关联属性，关联实体才有
		// 	relation:null,			// 关联关系信息
		// 	relationType:'One-Many'	// 关联关系的类型，如：One-Many
		// 	attriViewVOList : [
		// 		{
		// 			attriVO: attr,
		//    			pageConfigVO: {
		//    				component:{
		//    					isSetDefaultValue:
		//    					validate:
		//    					dictionary:
		//    					...
		//    				},
		//    				configArea:1,	//
		//    				componentModelId:'uicomponent.common.component.input'
		//    			},
		// 			entity: entity,
		// 			entityViewVO: entityViewVO,
		// 			check: false,
		// 			type: null // 暂未使用
		// 		}
		// 	]
		// }
		function createEntityViewVO(entity, oldEntityViewVO) {
			if(entity == null) {
				return null; 
			}

			var entityViewVO = {
				modelId: entity.modelId,
				entity: entity,
				primaryAttr: null,
				relationAttr:null,		// 存放关联实体的关联属性，关联实体才有
				relation:null,			// 关联关系信息
				relationType: null,		// 关联关系的类型，如：One-Many
				attriViewVOList : []
			}
			if(oldEntityViewVO) {
				syncAttriViewVOList(entityViewVO, oldEntityViewVO);
			}else {
				createAttriViewVOList(entityViewVO);
			}

			return entityViewVO;
		}

		/**
		 * 遍历实体属性集合构建attriViewVO，用于页面展示
		 * @param  {Object} entity 实体
		 */
		function createAttriViewVOList(entityViewVO) {
			var entity = entityViewVO.entity;
			var attriViewVOList = entityViewVO.attriViewVOList;

			// initRelationMap(entity);
			// console.debug("insert entity attributes into attriViewVO.");
			// 构建attriViewVO 用于页面展示
			_.forEach(entity.attributes, function (attr, index) {
				// console.log(attr, index);
				var attriViewVO = createAttriViewVO(entityViewVO, attr);
				attriViewVOList.push(attriViewVO);
			});
		}

		function syncAttriViewVOList(entityViewVO, oldEntityViewVO) {
			var entity = entityViewVO.entity;
			var attriViewVOList = entityViewVO.attriViewVOList;

			var oldAttriViewVOList = oldEntityViewVO.attriViewVOList;

			var cacheMap = {};
			for (var i = 0; i < oldAttriViewVOList.length; i++) {
				cacheMap[oldAttriViewVOList[i].attriVO.engName] = oldAttriViewVOList[i];
			}
			// clear attriViewVOList
			attriViewVOList.length = 0;
			// 遍历 entity attributes 构建attriViewVoList
			_.forEach(entity.attributes, function (attr, index) {
				var attriViewVO;
				if(attr.relationId || cacheMap[attr.engName] == null) {
					attriViewVO = createAttriViewVO(entityViewVO, attr);
				}else {
					attriViewVO = createAttriViewVO(entityViewVO, attr, cacheMap[attr.engName]);
				}
				attriViewVOList.push(attriViewVO);
			});
		}

	   	function createAttriViewVO(entityViewVO, attr, oldAttriViewVO) {
	   		var entity = entityViewVO.entity;
	   		var attriViewVO;
	   		if(oldAttriViewVO) {	// 第二次进来
	   			attriViewVO = oldAttriViewVO;
	   			attriViewVO.entityViewVO = entityViewVO;
	   			attriViewVO.check = false;
	   			attriViewVO.type = null;
	   		} else {
	   			attriViewVO = {
		   			attriVO: attr,
		   			pageConfigVO: {
		   				component:{}
		   			},
					entity: entity,
					entityViewVO: entityViewVO,
					check: false,
					type: null
		   		};
	   		}

	   		if(attr.primaryKey) {
	   			entityViewVO.primaryAttr = attr;
	   		}

	   		if(attr.relationId) {
	   			// console.debug(relationMap[attr.relationId]);
	   			// var relationInfo = relationMap[attr.relationId];
	   			// console.debug("find relation info : ", relationInfo);
	   			// attriViewVO.multiple = relationInfo.multiple;
	   			attriViewVO.type = 'relationEntity';
	   			if(relationMap[attr.relationId]) {
	   				relationAttrMap[attr.relationId] = attr;
	   			}
	   			// 暂时不处理关联的属性
	   			// insertRelationAttri(relationInfo);
	   		}
	   		return attriViewVO;
	   	}

		/**
		 * 插入关联对象属性
		 * @param  {Object} relationInfo 关联关系对象
		 */
		// function insertRelationAttri(relationInfo) {
		// 	var relationEntity = EntityServer.getEntityById(relationInfo.targetEntityId);

		// 	if(_.isNull(relationEntity)) {
		// 		console.debug("can find relation entity by relationEntityId: %s", relationInfo.targetEntityId);
		// 		return;
		// 	}
		// 	console.debug("insert relation entity attributes into attriViewVO. relation entity ", relationInfo);
		// 	_.forEach(relationEntity.attributes, function (relationAttr, index) {
		// 		var attriViewVO = {
		// 			attriVO: relationAttr,
		// 			pageConfigVO: {},
		// 			entity: relationEntity,
		// 			multiple: relationInfo.multiple
		// 		};
		// 		attriViewVOList.push(attriViewVO);
		// 	})
		// 	$scope.relationEntitys.push(relationEntity);
		// }

		var componentList = []; // [{component.modelId, component.modelName}]
		var componentMap = {};  // <component.modelId,component>
		// 获取控件类型下拉集合
		$window.getComponentList  = function (obj) {
			if(componentList.length === 0) {
				_.forEach(ComponentServer.queryComponentList('edittype'), function (component) {
					componentList.push({componentModelId:component.modelId, modelName: component.modelName});
					componentMap[component.modelId] = component;
				});
			}
			obj.setDatasource(componentList);
		}

		function saveData() {
			if(!saveValidate()) {
				return false;
			}
			// 保存实体
			saveEntity();

			// 创建MetadataGenerateVO
			metadataGenerateVO = getMetadataGenerateVO();
			// 清空相关属性防止数据混乱
			clearMetadataGenerateVO(metadataGenerateVO);
			// 填充对应数据
			fillMetadataGenerateVO(metadataGenerateVO);

			// console.log(metadataGenerateVO);
			ComponentServer.saveModel(metadataGenerateVO)
			return true;
		}

		function saveEntity() {
			// 保存实体
			EntityServer.saveEntity($scope.entity);
			// 保存关联实体
			for (var i = 0; i < relationEntitys.length; i++) {
				EntityServer.saveEntity(relationEntitys[i]);
			}

		}

		function saveValidate() {
			var result = validateAll();
			if(!result[2]) {	//验证不通过
				var messages = ["验证不通过："];
				_.forEach(result[0], function (failObj) {
					messages.push(failObj.message);
				})
				cui.alert(_.uniq(messages).join("<br/>"), 'warn');
				return false;
			}
			return true;
		}

		// 供父页面下一步的时候回调使用
		$window.save = function () {
			return saveData();
		}

		$scope.saveData = function () {
			if(saveData()){
				cui.message("保存成功", "success");
			}
		}

		$scope.saveDataAndNext = function () {
			if(saveData()) {
				$window.parent.nextStep();
			}
		}

		$scope.saveDataAndPre = function () {
			if(saveData()) {
				$window.parent.preStep();
			}
		}

		$scope.add = function (entityViewVO) {
			var iSortNo = entityViewVO.entity.attributes.length + 1;
			var newEntityAttribute = {
					relationId:"",sortNo:iSortNo,engName:"",chName:'',primaryKey:false,attributeType:{source:"primitive",type:"String"},dbFieldId:"",queryField:"false",allowNull:"true",accessLevel:"private"};
			insertAttri(entityViewVO, newEntityAttribute);
		}

		$scope.delete = function (entityViewVO) {
			cui.confirm("确定要删除选中属性？",{
				onYes:function(){
					$scope.$apply(function() {
						var attriViewVOList = entityViewVO.attriViewVOList
						_.forEach(attriViewVOList, function (attriViewVO, index) {
							if(attriViewVO.check && !isRelationAttr(attriViewVO)) {
								// 增加删除标记
								attriViewVO._delete = true;	
								entityViewVO.entity.attributes[index]._delete = true;

							}
						});
						// 根据删除标记删除对应属性
						deleteAttriByTag(entityViewVO);
						
						resetAttriSortNo(entityViewVO.entity);
					});
				}
			});
		}

		$scope.checkAll = function (entityViewVO) {
			_.forEach(entityViewVO.attriViewVOList, function (attriViewVO) {
				attriViewVO.check = entityViewVO.isCheckAll;
			});
		}

		$scope.check = function (entityViewVO) {
			var checkNum = 0
			_.forEach(entityViewVO.attriViewVOList, function (attriViewVO, index) {
				if(attriViewVO.check) {
					checkNum ++;
					// if($scope.canDelete && isRelationEntity(attriViewVO)) {
					// 	$scope.canDelete = false;
					// }
				}
			});
			entityViewVO.isCheckAll = checkNum == entityViewVO.attriViewVOList.length;
		}

		// $scope.$watch('attriViewVOList[0].check', function(newValue, oldValue, scope) {
		// 	cui("#up_button").disable(newValue);
		// });

		// $scope.$watch('attriViewVOList[attriViewVOList.length-1].check', function(newValue, oldValue, scope) {
		// 	cui("#down_button").disable(newValue);
		// });

		// $scope.$watch('canDelete', function(newValue, oldValue, scope) {
		// 	cui("#delete_button").disable(!newValue);
		// });

		$scope.up = function (entityViewVO) {
			var moveList = [];
			var attriViewVOList = entityViewVO.attriViewVOList;
			if(attriViewVOList[0].check) {	// 第一个选中就不能上移
				return;
			}
			_.forEach(attriViewVOList, function (attriViewVO, index) {
				if(attriViewVO.check) {
					moveList.push(attriViewVO);
				}
			});
			_.forEach(moveList, function (moveAttriViewVO) {
				for (var index = 0; index <= attriViewVOList.length - 1; index++) {
					if(attriViewVOList[index] == moveAttriViewVO && index != 0) {
						swapData(attriViewVOList, index, index - 1);
						swapData(entityViewVO.entity.attributes, index, index - 1);
						attriViewVOList[index].attriVO.sortNo = index + 1;
						attriViewVOList[index - 1].attriVO.sortNo = index;
						break;
					}
				}
			});
			utils.safeApply($scope);
		}

		$scope.down = function (entityViewVO) {
			var moveList = [];
			var attriViewVOList = entityViewVO.attriViewVOList;
			if(attriViewVOList[attriViewVOList.length - 1].check) {	// 最后一个选中就不能下移
				return;
			}
			for (var i = attriViewVOList.length - 1; i >= 0; i--) {
				if(attriViewVOList[i].check) {
					moveList.push(attriViewVOList[i]);
				}
			}
			_.forEach(moveList, function (moveAttriViewVO) {
				for (var index = attriViewVOList.length - 1; index >= 0; index--) {
					if(attriViewVOList[index] == moveAttriViewVO && index != attriViewVOList.length -1) {
						swapData(attriViewVOList, index, index + 1);
						swapData(entityViewVO.entity.attributes, index, index + 1);
						attriViewVOList[index].attriVO.sortNo = index + 1;
						attriViewVOList[index + 1].attriVO.sortNo = index + 2;
						break;
					}
				}
			});
			utils.safeApply($scope);
		}

		function swapData(list, fromIndex, toIndex) {
			var temp = list[fromIndex];
			list[fromIndex] = list[toIndex];
			list[toIndex] = temp;
		}

		function clearMetadataGenerateVO(metadataGenerateVO) {
			metadataGenerateVO.metadataValue.editComponentList[0].formAreaList[0].rowList = [];
			metadataGenerateVO.metadataValue.editComponentList[0].editGridAreaList = [];
			metadataGenerateVO.metadataValue.editComponentList[0].subComponentLayoutSortList=["form_9639532198073907"];

			metadataGenerateVO.metadataValue.queryComponentList[0].fixedQueryAreaList[0].rowList = [];
			metadataGenerateVO.metadataValue.queryComponentList[0].moreQueryAreaList[0].rowList = [];
			metadataGenerateVO.metadataValue.gridComponentList[0].options = {
						"columns" : [],
						"extras" : {
							entityId: entityViewVOList[0].modelId,
							tableHeader: []
						},
						"primarykey": entityViewVOList[0].primaryAttr == null ? null : entityViewVOList[0].primaryAttr.engName
					};
		}

		function fillMetadataGenerateVO(metadataGenerateVO) {
			// 根据主实体配置生成编辑字段、列表字段、固定查询、更多查询
			var attriViewVOList = entityViewVOList[0].attriViewVOList;
			_.forEach(attriViewVOList, function (attriViewVO) {
				// 插入查询区域、更多查询区域、编辑区域
				if(attriViewVO.pageConfigVO.configArea != null && attriViewVO.pageConfigVO.configArea != "") {
					areaArray = attriViewVO.pageConfigVO.configArea.split(";");
					var componentRowObj = {};
					_.forEach(areaArray, function (area) {
						switch(area) {
							case '0': // 编辑字段
								fillEditComponentList(attriViewVO,componentRowObj);
								break;
							case '1': // 列表字段
								fillGridComponentList(attriViewVO);
								break;
							case '2': // 固定查询
								fillFixedQueryAreaList(attriViewVO,componentRowObj);
								break;
							case '3': // 更多查询
								fillMoreQueryAreaList(attriViewVO,componentRowObj);
								break;
						}
					});
				}
			});


			// 根据关联关系实体配置生成编辑字段信息，目前模板只支持one-many的关联关系实体，关联关系字段以editgrid方式展现。
			fillEditGridArea(entityViewVOList);

			// 相关属性对象转成json字符串，后台才能正常存储
			var columns = metadataGenerateVO.metadataValue.gridComponentList[0].options.columns;
			metadataGenerateVO.metadataValue.gridComponentList[0].options.columns = JSON.stringify(columns);
			var tableHeader = metadataGenerateVO.metadataValue.gridComponentList[0].options.extras.tableHeader;
			metadataGenerateVO.metadataValue.gridComponentList[0].options.extras.tableHeader = JSON.stringify(tableHeader);
			var extras = metadataGenerateVO.metadataValue.gridComponentList[0].options.extras;
			metadataGenerateVO.metadataValue.gridComponentList[0].options.extras = JSON.stringify(extras);

			var editGridAreaList = metadataGenerateVO.metadataValue.editComponentList[0].editGridAreaList;
			for (var i = 0; i < editGridAreaList.length; i++) {
				var editGridArea = editGridAreaList[i];
				editGridArea.options.columns = JSON.stringify(editGridArea.options.columns);
				editGridArea.options.edittype = JSON.stringify(editGridArea.options.edittype);
				editGridArea.options.extras.tableHeader = JSON.stringify(editGridArea.options.extras.tableHeader);
				editGridArea.options.extras = JSON.stringify(editGridArea.options.extras);
			}

			// var fixedRowList = metadataGenerateVO.metadataValue.queryComponentList[0].fixedQueryAreaList[0].rowList;
			// metadataGenerateVO.metadataValue.queryComponentList[0].fixedQueryAreaList[0].rowList = JSON.stringify(fixedRowList);

			// fixedRowList = metadataGenerateVO.metadataValue.queryComponentList[0].moreQueryAreaList[0].rowList;
			// metadataGenerateVO.metadataValue.queryComponentList[0].moreQueryAreaList[0].rowList = JSON.stringify(fixedRowList);
		}

		/**
		 * 生成editgridarea区域，<br>
		 * 根据关联关系实体配置生成编辑字段信息，目前模板只支持one-many的关联关系实体，关联关系字段以editgrid方式展现。
		 * @param  {[entityViewVO]} entityViewVOList
		 */
		function fillEditGridArea(entityViewVOList) {
			if(entityViewVOList.length < 1) {
				return;
			}
			for (var i = 0; i < entityViewVOList.length; i++) {
				var entityViewVO = entityViewVOList[i];

				if(i == 0) {	// 跳过第一个主实体
					continue;
				}
				var editGridArea = {
					"area":"editGridCodeArea",
					"entityId": entityViewVO.entity.modelId,
					"id":"editGrid_" + i,
					"includeFileList":[],
					"options":{
						"columns":[],
						"databind": 'editEntity.' + entityViewVO.relationAttr.engName,
						"edittype":{},
						"extras":{
							"entityId": entityViewVO.entity.modelId,
							"tableHeader": []
						},
						"primarykey": entityViewVO.primaryAttr.engName
					}
				}

				attriViewVOList = entityViewVO.attriViewVOList;
				_.forEach(attriViewVOList, function (attriViewVO) {
					if(attriViewVO.pageConfigVO.configArea != null && attriViewVO.pageConfigVO.configArea == PageConfig_EDIT_COLUM) {
						// 获取column
						var column = getEditGridAreaColumn(attriViewVO);
						editGridArea.options.columns.push(column);

						// 获取editType
						var editType = getEditGridAreaEditType(attriViewVO, column);
						editGridArea.options.edittype[attriViewVO.attriVO.engName] = editType;
						
						// 获取extras里的tableHeader
						var tableHeader = getEditGridAreaTableHeader(attriViewVO, column);
						editGridArea.options.extras.tableHeader.push(tableHeader);
						
					}
				});
				metadataGenerateVO.metadataValue.editComponentList[0].editGridAreaList.push(editGridArea);
				metadataGenerateVO.metadataValue.editComponentList[0].subComponentLayoutSortList.push(editGridArea.id);
			}
		}

		function getEditGridAreaTableHeader(attriViewVO, column) {
			var tableHeader = {
				customHeaderId: attriViewVO.attriVO.engName,
				edittype: {
					data: {

					}
				}
			};
			tableHeader = _.assign(tableHeader, column);

			var component = getComponent(attriViewVO);
			if(component) {
				// 用户配置的控件属性
				var viewcomponent = attriViewVO.pageConfigVO.component

				// 遍历控件属性
				_.forEach(component.properties, function (propertie) {
					if(propertie.ename === 'databind') {
						// continue; 使用continue angluarjs会报错。
					} else if(propertie.ename === 'uitype') {
						tableHeader.edittype.data[propertie.ename] = propertie.defaultValue;
					} else if(!isNullOrBlank(viewcomponent[propertie.ename])) {
						tableHeader.edittype.data[propertie.ename] = viewcomponent[propertie.ename];
					}
				});
				tableHeader.edittype.data.componentModelId = component.modelId;

			}
			return tableHeader;
		}

		function getEditGridAreaColumn(attriViewVO) {
			var column =  {
				name: attriViewVO.attriVO.chName,
				bindName: attriViewVO.attriVO.engName
			}
			setColumnDefaultValue(column, attriViewVO);
			return column
		}

		function getEditGridAreaEditType(attriViewVO) {
			var component = getComponent(attriViewVO);
			if(component) {
				var editType = {
					uitype: component.modelName,
					componentModelId:component.modelId
				}
				setColumnDefaultValue(editType, attriViewVO);

				setChooseComponentEditType(component, attriViewVO, editType);
				return editType;
			}
			return null;
		}

		function setChooseComponentEditType(component, attriViewVO, editType) {
			if(component.modelName === 'ChooseOrg' || component.modelName === 'ChooseUser') {
				// 用户配置的控件属性
				var viewcomponent = attriViewVO.pageConfigVO.component

				// 遍历控件属性
				_.forEach(component.properties, function (propertie) {
					if(propertie.ename === 'databind') {
						// continue; 使用continue angluarjs会报错。
					} else if(propertie.ename === 'uitype') {
						editType[propertie.ename] = propertie.defaultValue;
					} else if(!isNullOrBlank(viewcomponent[propertie.ename])) {
						editType[propertie.ename] = viewcomponent[propertie.ename];
					}
				});
				editType.componentModelId = component.modelId;
			}
		}

		// 转换attriViewVO为对应区域的控件数据对象
		function convertComponentRowObj(metadataComponentRowObj, attriViewVO) {
			_.assign(metadataComponentRowObj, {
				"cname":attriViewVO.attriVO.chName,
				"colspan":1,
				"componentModelId":attriViewVO.pageConfigVO.componentModelId,
				"id": attriViewVO.attriVO.engName,
				"options":{
					// "databind": suffix + '.' + attriViewVO.attriVO.engName,
					// "uitype":"Input",
					// "validate":"[{\"type\":\"length\",\"rule\":{\"max\":256,\"maxm\":\"项目名称长度不能大于256个字符\"}}]"
				}
			});
			if(attriViewVO.pageConfigVO.componentModelId && attriViewVO.pageConfigVO.componentModelId != null) {
				// 获取对应控件信息
				var component = getComponent(attriViewVO);
				if(component) {
					// 用户配置的控件属性
					var viewcomponent = attriViewVO.pageConfigVO.component

					// 遍历控件属性
					_.forEach(component.properties, function (propertie) {
						if(propertie.ename === 'uitype') {
							metadataComponentRowObj[propertie.ename] = propertie.defaultValue;
						} else if(!isNullOrBlank(viewcomponent[propertie.ename])) {
							metadataComponentRowObj.options[propertie.ename] = viewcomponent[propertie.ename];
						}

					});
					
				}
			}
			return metadataComponentRowObj;
		}

		function isNullOrBlank(value) {
			return value == null || value === '';
		}

		function fillEditComponentList(attriViewVO, componentRowObj) {
			if(_.isEmpty(componentRowObj)) {
				convertComponentRowObj(componentRowObj, attriViewVO);
			}else {		
				// 若存在，需要clone对象，因为该对象在metadataGenerateVO属性中会多次引用，会导致dwr传递到后台时对应的属性值为引用的地址而非实际的数据，例如：
				// "rowList":[
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[0]"},
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[1]"},
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[2]"}
				// ]
				componentRowObj = _.clone(componentRowObj, true);
			}
			metadataGenerateVO.metadataValue.editComponentList[0].formAreaList[0].rowList.push(componentRowObj);
		}


		function fillGridComponentList(attriViewVO) {
			var column =  {
				name: attriViewVO.attriVO.chName,
				bindName: attriViewVO.attriVO.engName
			}
			setColumnDefaultValue(column, attriViewVO);

			metadataGenerateVO.metadataValue.gridComponentList[0].options.columns.push((column));
			metadataGenerateVO.metadataValue.gridComponentList[0].options.extras.tableHeader.push((_.assign({customHeaderId: attriViewVO.attriVO.engName}, column)));
		}

		var gridDicRender = "actionlibrary.bestPracticeAction.gridAction.action.gridDicRender";
		var dateformat = 'yyyy-MM-dd';

		function setColumnDefaultValue(column, attriViewVO) {
			if(isEnum(attriViewVO)) {
				column.render = gridDicRender;
			}
			if(isDictionary(attriViewVO)) {
				column.render = gridDicRender;
			}
			if(isTimestamp(attriViewVO)) {
				column.format = dateformat;
			}
		}


		function isRelationEntity(attriViewVO) {
			return attriViewVO.type === 'relationEntity';
		}

		function isEnum(attriViewVO) {
			return attriViewVO.attriVO.attributeType.source === 'enumType';
		}

		function isDictionary(attriViewVO) {
			return attriViewVO.attriVO.attributeType.source === 'dataDictionary';
		}

		function isTimestamp(attriViewVO) {
			return attriViewVO.attriVO.attributeType.type === 'java.sql.Timestamp';
		}

		function isAllowNull(attriViewVO) {
			return attriViewVO.attriVO.allowNull;
		}

		// 获取attrViewVO对应的主键信息
		function getComponent(attriViewVO) {
			if(attriViewVO.pageConfigVO && attriViewVO.pageConfigVO.componentModelId) {
				return componentMap[attriViewVO.pageConfigVO.componentModelId];
 			}
 			return null;
		}

		/**
		 * 获取attrviewVO的validate对象
		 * @param  {Object} attriViewVO 
		 * @return {Array}  验证信息对象
		 */
		function getValidate(attriViewVO) {
			var validateStr = attriViewVO.pageConfigVO.component.validate || '[]';
			return JSON.parse(validateStr);
		}

		function fillFixedQueryAreaList(attriViewVO, componentRowObj) {
			if(_.isEmpty(componentRowObj)) {
				convertComponentRowObj(componentRowObj, attriViewVO);
				// 去掉必填验证
				clearRequiredValidate(componentRowObj);
			}else {
				// 若存在，需要clone对象，因为该对象在metadataGenerateVO属性中会多次引用，会导致dwr传递到后台时对应的属性值为引用的地址而非实际的数据，例如：
				// "rowList":[
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[0]"},
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[1]"},
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[2]"}
				// ]
				componentRowObj = _.clone(componentRowObj, true);
			}
			clearRequiredValidate(componentRowObj);
			metadataGenerateVO.metadataValue.queryComponentList[0].fixedQueryAreaList[0].rowList.push(componentRowObj);
		}

		function fillMoreQueryAreaList(attriViewVO, componentRowObj) {
			if(_.isEmpty(componentRowObj)) {
				convertComponentRowObj(componentRowObj, attriViewVO);

			} else {
				// 若存在，需要clone对象，因为该对象在metadataGenerateVO属性中会多次引用，会导致dwr传递到后台时对应的属性值为引用的地址而非实际的数据，例如：
				// "rowList":[
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[0]"},
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[1]"},
				// 	{"$ref":"$.metadataValue.editComponentList[0].formAreaList[0].rowList[2]"}
				// ]
				componentRowObj = _.clone(componentRowObj, true);
			}
			clearRequiredValidate(componentRowObj);
			metadataGenerateVO.metadataValue.queryComponentList[0].moreQueryAreaList[0].rowList.push(componentRowObj);
		}

		function clearRequiredValidate(metadataComponentRowObj) {
			if(metadataComponentRowObj.options.validate) {
				var validaters = JSON.parse(metadataComponentRowObj.options.validate);
				cap.array.remove(validaters,[{"type" : 'required'}],true);
				var validate = validaters.length === 0 ? "" : JSON.stringify(validaters);
				metadataComponentRowObj.options.validate = validate;
			}
		}

		var suffix = 'editEntity';
		var areaColSize = 2;

		function getMetadataGenerateVO() {
			if(_.isEmpty(metadataGenerateVO)) {
				// metadataGenerateVO = {};
				var menuVO = ComponentServer.queryMenuByPackageId($scope.entity.packageId);
				if($scope.entity.processId) {
					metadataGenerateVO.metadataPageConfigModelId = 'pageTemplate.oldPageConfigTmp.pageConfig.fwmsCommonModule';
				}else {
					metadataGenerateVO.metadataPageConfigModelId = 'pageTemplate.oldPageConfigTmp.pageConfig.simpleModule';
				}
				metadataGenerateVO.modelName = pageSession.get("page_session_generate_name");
				// metadataGenerateVO.modelName = 'quickBuild' + $scope.entity.modelName;
				metadataGenerateVO.modelId = $scope.entity.modelPackage + '.metadataGenerate.' + metadataGenerateVO.modelName;
				metadataGenerateVO.modelPackage = $scope.entity.modelPackage;
				metadataGenerateVO.modelType = 'metadataGenerate';

				var metadataValue = metadataGenerateVO.metadataValue = {
					inputComponentList: [],
					menuComponentList: [],
					entityComponentList: [],
					queryComponentList: [],
					gridComponentList: [],
					editComponentList: [],
					hiddenComponentList: []
				};

				metadataValue.inputComponentList = [
					{
						"id":"modelName",
						"name":"modelName",
						"value":metadataGenerateVO.modelName
					},
					{
						"id":"cname",
						"name":"cname",
						"value":metadataGenerateVO.modelName
					}
				];

				metadataValue.menuComponentList = [{
					"id":"parentName",
					"name":"parentName",
					"value":menuVO.funcName
				}];

				metadataValue.entityComponentList = [{
					"id":"entityId",
					"rowList":[{
						"chName":$scope.entity.chName,
						"engName":$scope.entity.engName,
						"modelId":$scope.entity.modelId,
						"entityAlias":$scope.entity.aliasName,
						"suffix":suffix
					}]
				}];
				metadataValue.gridComponentList = [{
					"area":"listCodeArea",
					"areaId":"areaId_listArea",
					"entityAlias":suffix,
					"entityId":$scope.entity.modelId,
					"id":"listArea",
					"includeFileList":[],
					"options":{
						
					}
				}],
				// 查询区域
				metadataValue.queryComponentList = [{
					"entityAlias":suffix,
					"entityId":$scope.entity.modelId,
					"fixedQueryAreaList":[{
						"area":"queryFixedCodeArea",
						"areaId":"areaId_queryFixedCodeArea",
						"col":areaColSize,
						"id":"uiid_40623767498170174",
						"rowList":[]
					}],
					"id":"queryArea",
					"moreQueryAreaList":[{
						"area":"queryMoreCodeArea",
						"areaId":"areaId_queryMoreCodeArea",
						"col":areaColSize,
						"id":"uiid_6521887202666792",
						"rowList":[]
					}]
				}];
				metadataValue.editComponentList = [{
						"editGridAreaList":[],
						"entityAlias":suffix,
						"entityId":$scope.entity.modelId,
						"formAreaList":[{
							"area":"editFormCodeArea",
							"col":2,
							"id":"form_9639532198073907",
							"rowList":[],
						}],
						"groupingBarList":[],
						"id":"editArea",
						"subComponentLayoutSortList":[
							"form_9639532198073907"
						]
					}];
				metadataValue.hiddenComponentList = [{
					"id":"parentId",
					"name":"parentId",
					"value":menuVO.funcId
				}];
			}

			return metadataGenerateVO;
		}

		/**
		 * 重置属性的sortNo
		 */
	   	function resetAttriSortNo(entity){
	   		//重新维护序号
	        for(var i=0;i<entity.attributes.length;i++){
	        	entity.attributes[i].sortNo = i + 1;
	        }
	   	}

	   	function deleteAttriByTag(entityViewVO) {
	   		_.remove(entityViewVO.entity.attributes, function(attri) {
	   			console.log(attri);
	   			return attri._delete === true;
	   		});

	   		_.remove(entityViewVO.attriViewVOList, function(attri) {
	   			return attri._delete === true;
	   		});
	   	}

	   	function deleteAttri(entityViewVO, attr) {
	   		cap.array.remove(entityViewVO.entity.attributes,[{"engName" : attr.engName}],true);
			cap.array.remove(entityViewVO.attriViewVOList,[{"attriVO" : {"engName": attr.engName}}],true);
	   	}

	   	function insertAttri(entityViewVO, attr) {
	   		entityViewVO.entity.attributes.push(attr);
	   		entityViewVO.attriViewVOList.push(createAttriViewVO(entityViewVO.entity, attr));
	   	}

		$scope.showComponentProPerty = function (attriViewVO) {
			var componentModelId = attriViewVO.pageConfigVO.componentModelId;
			if(componentModelId == undefined || componentModelId == null || componentModelId == '') {
				return '';
			}
			var modeIdArray = componentModelId.split('.')
			var componentName = modeIdArray[modeIdArray.length - 1];
			// console.count(componentName);
			if(['editor','clickInput','input','radioGroup','pullDown','checkboxGroup'].indexOf(componentName) > -1) {
				return "template/commonProperty.tpl.html";
			}else if(['chooseUser','chooseOrg'].indexOf(componentName) > -1) {
				return "template/chooseProperty.tpl.html";
			}else if(componentName === 'calender') {
				return "template/calenderProperty.tpl.html";
			}else if(componentName === 'textarea') {
				return "template/textareaProperty.tpl.html";
			}
 		}
 		var PageConfig_Edit = 0;	// 编辑字段
 		var PageConfig_Grid = 1;	// 列表字段
 		var PageConfig_Fix_Query = 2; 	// 固定查询
 		var PageConfig_More_Query = 3;	// 更多查询
 		var PageConfig_EDIT_COLUM = 4;	// 编辑列

 		$scope.changePageConfig = function (attriViewVO) {
			if(attriViewVO.pageConfigVO.configArea && attriViewVO.pageConfigVO.configArea != PageConfig_Grid) {
				// 非列表区域 需要根据属性带出对应控件
				if(_.isEmpty(attriViewVO.pageConfigVO.componentModelId)) {
					setDefaultComponent(attriViewVO);
					$scope.changeComponent(attriViewVO);
				}
			}
		}

		function setDefaultComponent (attriViewVO) {
			if(isTimestamp(attriViewVO)) {
				// 属性类型为日期 -> calender控件 -> uicomponent.common.component.calender
				attriViewVO.pageConfigVO.componentModelId = 'uicomponent.common.component.calender';
			}else if (isEnum(attriViewVO) || isDictionary(attriViewVO)) {
				// 属性为参数字典 -> pulldown组件 -> uicomponent.common.component.pullDown
				attriViewVO.pageConfigVO.componentModelId = 'uicomponent.common.component.pullDown';
			} else {
				// 其他 -> input组件 -> uicomponent.common.component.input
				attriViewVO.pageConfigVO.componentModelId = 'uicomponent.common.component.input';
			}
		}

		$scope.changeComponent = function (attriViewVO) {
			// console.log(componentMap);
			if(attriViewVO.pageConfigVO.component == null) {
				attriViewVO.pageConfigVO.component = {};
			}
			var viewcomponent = attriViewVO.pageConfigVO.component;
			// console.log("changeComponent");
			if(viewcomponent.isSetDefaultValue === undefined) {

				viewcomponent.isSetDefaultValue = true;
				// set databind
				setComponentPropertie(viewcomponent, 'databind', suffix + '.' + attriViewVO.attriVO.engName)

				// pulldown、checkboxgroup
				// set enumType
				if(isEnum(attriViewVO)) {
					setComponentPropertie(viewcomponent, 'enumdata', attriViewVO.attriVO.attributeType.value)
				}else if(isDictionary(attriViewVO)) {
					setComponentPropertie(viewcomponent, 'dictionary', attriViewVO.attriVO.attributeType.value)
				}
				// set required validate
				setRequiredValidate(attriViewVO);
			}
			var componentModelId = attriViewVO.pageConfigVO.componentModelId;
			var modeIdArray = componentModelId.split('.')
			var componentName = modeIdArray[modeIdArray.length - 1];
			if(componentName === 'radioGroup') {	// radioGroup必须给定name的属性值，其他控件不必须
				// radiogroup
				setComponentPropertie(viewcomponent, 'name', attriViewVO.attriVO.engName)
			}else if(componentName === 'chooseUser' || componentName === 'chooseOrg'){// chooseUser chooseOrg 给定idName的属性值
				if(attriViewVO.pageConfigVO.component.idName == '' || attriViewVO.pageConfigVO.component.idName == undefined  ){
					setComponentPropertie(viewcomponent, 'idName', attriViewVO.pageConfigVO.component.databind);
				}
			}else {
				// radiogroup
				setComponentPropertie(viewcomponent, 'name', "");
			}

			if(['editor','input','textarea'].indexOf(componentName) > -1) {
				setLenthValidate(attriViewVO)
			}else {
				clearLenthValidate(attriViewVO);
			}
			console.debug("component properties : ",viewcomponent);
		}

		function setLenthValidate(attriViewVO) {
			var validaters = getValidate(attriViewVO);
			
			var hasValidate = false;
			_.forEach(validaters, function (validater) {
				if(validater.type == 'length') {
					hasValidate = true;
				}
			});
			if(!hasValidate) {
				var attributeLength = attriViewVO.attriVO.attributeLength;
				validaters.push({type:'length',"rule":{max:attributeLength, "maxm": attriViewVO.attriVO.chName + "不能大于"+ attributeLength +"个字符"}});
				setComponentPropertie(attriViewVO.pageConfigVO.component, "validate", validaters);
			}
		}

		function clearLenthValidate(attriViewVO) {
			var validaters = getValidate(attriViewVO);
			cap.array.remove(validaters,[{"type" : 'length'}],true);
			setComponentPropertie(attriViewVO.pageConfigVO.component, "validate", validaters);
		}

		function setRequiredValidate(attriViewVO) {
			if(!isAllowNull(attriViewVO)) {
				var validaters = getValidate(attriViewVO);
				validaters.push({type:'required',"rule":{"m": attriViewVO.attriVO.chName + "不能为空"}});
				setComponentPropertie(attriViewVO.pageConfigVO.component, "validate", validaters);
			}
		}

		// 设置控件属性值
		function setComponentPropertie(viewcomponent, propertie, value) {
			if(propertie === "validate" && typeof value != 'string') {
				value = value.length === 0 ? null : JSON.stringify(value);
				viewcomponent[propertie] = value;
				return;
			}

			viewcomponent[propertie] = value;
			if(propertie === 'dictionary') {
				viewcomponent.enumdata = "";
			}else if(propertie === 'enumdata') {
				viewcomponent.dictionary = "";
			}
		}

		function isRelationAttr(attriViewVO) {
			return attriViewVO.type === 'relationEntity';
		}

		$scope.isShowPageConfig = function (attriViewVO) {
			return !isRelationAttr(attriViewVO);
		}
		
		$scope.isShowQueryExpr = function (attriViewVO) {
			return !isRelationAttr(attriViewVO);
		}

		$scope.isShowDictOrEnum = function (attriViewVO) {
			return isEnum(attriViewVO) || isDictionary(attriViewVO);
		}

		// 打开查询表达式编页面
		var selectDictionaryDialog;

		var editDialogAttrVO;
		$scope.showDictDialog = function (attriViewVO) {
			editDialogAttrVO = attriViewVO;
			//需要定位到的配置项所属模块的Id
			var gotoModulId = $scope.entity.packageId;
			
			//通过配置项全编码查询配置项所属的模块Id
			var dicDataFullCode = attriViewVO.attriVO.attributeType.value;
			if(dicDataFullCode){
				var cfgVO;
				dwr.TOPEngine.setAsync(false);
				EntityFacade.getModulIdByCfgFullCode(dicDataFullCode,function(data){
					cfgVO = data;
				});
				dwr.TOPEngine.setAsync(true);
				if(cfgVO && cfgVO.configClassifyId){
					gotoModulId = cfgVO.configClassifyId;
				}
			}
			
			var url = webPath + "/cap/bm/dev/entity/SelectDictionary.jsp?sourceModuleId="+gotoModulId+"&code="+dicDataFullCode;
			var title ="选择数据字典";
			var height = 500; 
			var width =  680; 
			selectDictionaryDialog = cui.dialog({
				id : "selectDictionaryDialog",
				title : title,
				src : url,
				width : width,
				height : height
			});
			selectDictionaryDialog.show(url);
		}

		//选择数据字典的回调函数
		$window.dictionaryCallBack = function (data){
			editDialogAttrVO.attriVO.attributeType.value = data.configItemFullCode;
			editDialogAttrVO.attriVO.attributeType.source = 'dataDictionary';
			setComponentPropertie(editDialogAttrVO.pageConfigVO.component, 'dictionary', editDialogAttrVO.attriVO.attributeType.value);
			utils.safeApply($scope);
			if(selectDictionaryDialog){
				selectDictionaryDialog.hide();
			}
		}
		
		//选择数据字典清空按钮的回调函数
		$window.clearDataCallBack = function (){
			editDialogAttrVO.attriVO.attributeType.value = "";
			editDialogAttrVO.attriVO.attributeType.source = "primitive";
			setComponentPropertie(editDialogAttrVO.pageConfigVO.component, 'dictionary', editDialogAttrVO.attriVO.attributeType.value);
			utils.safeApply($scope);
			if(selectDictionaryDialog){
				selectDictionaryDialog.hide();
			}
		}

		$scope.showEnumDialog = function (attriViewVO) {
			editDialogAttrVO = attriViewVO;
			var url = 'EditEnum.jsp?enumValue=' + attriViewVO.attriVO.attributeType.value + "&callback=enumDialogCallBack";
		    openWindow(url, "diolag", 480, 300);
		}

		$window.enumDialogCallBack = function (data) {
			editDialogAttrVO.attriVO.attributeType.value = data;
			if(data == null || data == "") {
				editDialogAttrVO.attriVO.attributeType.source = "primitive";
			} else {
				editDialogAttrVO.attriVO.attributeType.source = 'enumType';
			}
			setComponentPropertie(editDialogAttrVO.pageConfigVO.component, 'enumdata', editDialogAttrVO.attriVO.attributeType.value);
			utils.safeApply($scope);
		}

		$scope.showQueryExprDialog = function (attriViewVO) {
			editDialogAttrVO = attriViewVO;
			var url = 'SetAttriQueryExp.jsp';
		    openWindow(url);
		}

		// 供查询表达式编辑页面获取数据
		$window.getCurrentAttriVO = function () {
			return editDialogAttrVO.attriVO;
		}

		// 查询表达式编辑页面回调方法
		$window.changeAttiQueryExp = function (callBackParam) {
			if(callBackParam.length === 3) {	// 范围查询，会新增2个属性用于范围查询
				// 删除已有的范围查询属性
				cap.array.remove(editDialogAttrVO.entity.attributes,[{"queryRangeBy" : callBackParam[0].engName}],true);
				cap.array.remove(editDialogAttrVO.entityViewVO.attriViewVOList,[{"queryRangeBy" : callBackParam[0].engName}],true);
				// 插入属性
				insertAttri(editDialogAttrVO.entityViewVO, callBackParam[1]);
				insertAttri(editDialogAttrVO.entityViewVO, callBackParam[2]);
				resetAttriSortNo(editDialogAttrVO.entity);
			}
			utils.safeApply($scope);
		}


		var editingAttriViewVO;
		/**
		 * 打开校验组件界面
		 * @param event
		 * @param self
		 */
		$scope.openValidateAreaWindow = function (attriViewVO){
			editingAttriViewVO = attriViewVO;
			var url = webPath + '/cap/bm/dev/page/uilibrary/ValidateComponent.jsp?propertyName=validate&callbackMethod=propertyCallback';
		    // 设置数据供弹出窗口读取
		    $window.currSelectDataModelVal = editingAttriViewVO.pageConfigVO.component.validate;
		    openWindow(url);
		}

		$window.propertyCallback = function (propertyName, callBackParam) {
			editingAttriViewVO.pageConfigVO.component[propertyName] = callBackParam;
			utils.safeApply($scope);
		}

		//打开数据模型选择界面
		$scope.openDataStoreSelect = function (attriViewVO, propertyName) {
			editingAttriViewVO = attriViewVO;
			var param = '?entityId='+attriViewVO.entity.modelId+'&propertyName='+propertyName+'&callbackMethod=entityPropertyCallback';
			var url = webPath + '/cap/bm/dev/page/template/EntityAttributeSelection.jsp' + param;
			openWindow(url);
		}

		// 实体属性选择回调方法
		$window.entityPropertyCallback = function (callBackParam, flag, propertyName) {
			if(editingAttriViewVO.entityViewVO.relationType === 'One-Many') {
				editingAttriViewVO.pageConfigVO.component[propertyName] = callBackParam.engName;
			} else {
				editingAttriViewVO.pageConfigVO.component[propertyName] = suffix + '.' +callBackParam.engName;
			}
			utils.safeApply($scope);
		}

		function openWindow(url, target, width, height) {
			width = width || 800; //窗口宽度
		    height= height || 600; //窗口高度
		    var top=(window.screen.availHeight-height)/2;
		    var left=(window.screen.availWidth-width)/2;
		    // 设置数据供弹出窗口读取
		    target = target || 'diolag';
		    $window.open(url, target, "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}

		//属性名称检测 
		$scope.validateAttrEnName = function (entityViewVO) {
			return 	[
		      {'type':'required','rule':{'m':'属性名称不能为空。'}},
		      {'type':'custom','rule':{'against':checkAttrEnNameChar, 'm':'实体属性必须为英文字符、数字或者下划线，且必须以英文字符开头。'}},
		      {'type':'custom','rule':{'against':checkAttrEnName, 'm':'实体属性已存在。', 'args': entityViewVO.attriViewVOList}}
		    ]
		}

		//检查属性英文名称字符
		function checkAttrEnNameChar(data) {
			var regEx = "^(?![0-9_])[a-zA-Z0-9_]+$";
			if(data){
				var reg = new RegExp(regEx);
				return (reg.test(data));
			}
			return true;
		}

		//校验属性名称是否存在
		function checkAttrEnName(engName, attriViewVOList) {
			var ret = true;
			var num = 0;
			for(var i in attriViewVOList) {
				if(engName == attriViewVOList[i].attriVO.engName) {
					num ++;
				}

				if(num > 1) {
					ret = false;
					break;
				}
			}
			return ret;
		}
		//属性中文名称检测 
		$window.validateAttrChName = [{'type':'required','rule':{'m':'实体属性中文名称不能为空。'}}];

		//统一校验函数
		function validateAll() {
			return $window.cap.validater.validAllElement();
		}
	}]);
</script>
</html>