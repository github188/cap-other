<%
/**********************************************************************
* 元数据表单界面
* 2015-9-23 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app="metadataGenerateEdit">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/template.png">
    <title>元数据表单界面</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/template/css/base.css"/>
    <style type="text/css">
    	.header {
    		height:25px; 
    		border-bottom: 1px solid #e6e6e6;
    		box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
    	}
    	.container{
    		position: relative; 
    		overflow:auto;
    	}
    	.thw_operate{
    		margin-top: -2px;
    	}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cip_common.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/dev/page/template/js/common.js"></top:script>
	<top:script src="/cap/bm/dev/page/template/js/directive.js"></top:script>
	<top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/grid.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/ComponentTypeFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/MetadataPageConfigFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/MetadataGenerateFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/PageFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/PageTemplateActionPreferenceFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/ActionDefineFacade.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/pageactioncommon.js"></top:script>
	
</head>
<body ng-controller="metadataGenerateEditCtrl" data-ng-init="ready()">
	<div class="cap-page">
		<div class="cap-area" style="width: 100%; text-align: left;">
			<div class="header">
				<div class="thw_title">元数据录入界面</div>
				<div class="thw_operate">
					<span uitype="Button" id="createMetadata_button" label="生成元数据" ng-click="generateCode()"></span>
					<span uitype="Button" id="save_button" label="保存" ng-click="save()"></span>
					<span ng-hide="isQuickBuild()" uitype="Button" id="return" label="返回" ng-click="back()"></span>
					<span ng-hide="isQuickBuild()" uitype="Button" id="close" label="关闭" ng-click="close()"></span>
				</div>
			</div>
			<div class="container">
				<table class="cap-table-fullWidth">
					<tbody id="metadataForm"></tbody>
				</table>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var metadataPageConfigModelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("metadataPageConfigModelId"))%>;
		var metadataGenerateModelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("metadataGenerateModelId"))%>;
		var operationType=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("operationType"))%>;
		var openType=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;
		//控件工具箱
		var toolsdata = [];
		var scope = {};
		var entityDatasource = [];//实体区域控件已选择的实体集合
		//控件定义类型数据源
		var defaultCompTypeDatasource = getDefaultComponentByEditType();
		var defaultRenderDatasource = getDefaultRenderMethods();
		//开发建模-》应用模版，解决通过子页面刷新了父页面后，再使用window.opener获取不到父窗口引用，所以先把引用对象存在一份
		var appDetailPage;
		if(operationType=="insert"){
			appDetailPage = window.opener && window.opener.frames ? window.opener.frames.parent : null;
		}else{
			appDetailPage = window.opener;
		}
		angular.module('metadataGenerateEdit', ["cui"]).controller('metadataGenerateEditCtrl', function ($scope, $compile) {
	    	$scope.root={};
	    	$scope.metadataGenerateVO = {};
	    	$scope.entityList = [];
	    	//多个实体控件会使用到该变量
	    	$scope.componentDefineId = '';
	        $scope.ready = function() {
	        	setContainerHeight();
	        	$scope.initData();
				scope = $scope;
				$scope.loadTemplate();
				initToolsdata();
				if(openType=="listToMain"){
					cui("#close").hide();
					//原先父窗口左侧面板的折叠情况
					originalCollapsed = window.parent.cui("#body").getCollapseState("left").collapsed;
					window.parent.cui("#body").setCollapse("left",true);
				}else{
					cui("#return").hide();
				}
				if($scope.metadataGenerateVO.modelId != null){
			       document.title = $scope.metadataGenerateVO.modelName + document.title;
		        }
				$(window).resize(function() {
				   setContainerHeight();
				});
	        }
	        
	        //初始化页面数据
	        $scope.initData = function() {
	        	$scope.getMetadataGenerate();
	        	$scope.initEntity();
	        	$scope.initInputOrMenu('input');
	        	$scope.initInputOrMenu('menu');
	        	$scope.initQueryCodeArea();
	        	$scope.initListCodeArea();
	        	$scope.initEditCodeArea();
	        	$scope.initHidden();
	        }
	        
	        //初始化实体区域控件
	        $scope.initEntity = function() {
				var componentList = _.filter($scope.metadataGenerateVO.metadataPageConfigVO.metaComponentDefineVOList, {uiType: 'entitySelection'});
				if(componentList.length > 0){
					//实体控件
					var component = componentList[0];
					var suffixList = component.uiConfig.suffix;
					var entityList = [];
					for(var i=0, len=suffixList.length; i<len; i++){
						entityList.push({suffix:suffixList[i]});
					}
					//实体控件数据
					var dataList = $scope.metadataGenerateVO.metadataValue.entityComponentList;
					if(dataList.length > 0){
						var rowList = dataList[0].rowList;
						for(var i=0, len=entityList.length; i<len; i++){
							entityList[i] = _.find(rowList, {suffix: entityList[i].suffix});
							$scope.entityList[i] = entityList[i].modelId != null ? getEntity(entityList[i].modelId) : {};
							$scope.entityList[i].suffix = entityList[i].suffix;
						}
					} 
					$scope.root[component.id] = {metaComponentDefine: component, entityList:entityList};
					entityDatasource = entityDataToDatasource($scope.entityList);
				}
	        }
	        
	        //初始化文本框、菜单控件
	        $scope.initInputOrMenu = function(uitype) {
	        	var componentList = _.filter($scope.metadataGenerateVO.metadataPageConfigVO.metaComponentDefineVOList, {uiType: uitype});
				var dataList = $scope.metadataGenerateVO.metadataValue[uitype+'ComponentList'];
	        	_.forEach(componentList, function(component) {
	        		var idName = component.id;
	        		$scope.root[idName] = {metaComponentDefine: component};
					var data = _.find(dataList, {id: idName});
					$scope.root[idName][idName] = data != null ? data.value : '';
	        	})
	        }
	        
	        //初始化查询区域模块
	        $scope.initQueryCodeArea = function(){
	        	var componentList = _.filter($scope.metadataGenerateVO.metadataPageConfigVO.metaComponentDefineVOList, {uiType: 'queryCodeArea'});
				var dataList = $scope.metadataGenerateVO.metadataValue.queryComponentList;
				_.forEach(componentList, function(component) {
	        		var idName = component.id;
	        		var data = _.find(dataList, {id: idName});
	        		$scope.root[idName] = {metaComponentDefine: component, scope: {components: setQuerySubAreaData(component, data), entityId: '', entityAlias: ''}};
	        		if(data != null){
	        			$scope.root[idName].scope.entityId = data.entityId; 
	        			$scope.root[idName].scope.entityAlias = data.entityAlias; 
						$scope.initQuerySubArea(data.fixedQueryAreaList, $scope.root[idName].scope.components, data);
	    	        	$scope.initQuerySubArea(data.moreQueryAreaList, $scope.root[idName].scope.components, data);
	        		} 
	        	})
	        	
	        }
	        
	        //初始化查询区域子区域控件
	        $scope.initQuerySubArea = function(querySubAreaList, oldComponents, data){
	        	_.forEach(querySubAreaList, function(chr) {
        			var querySubArea = _.find(oldComponents, {id: chr.id});
        			$scope.initFormData(querySubArea.scope, jQuery.extend(true, chr, {entityId: data.entityId}));
        			querySubArea.scope.col = chr.col;
        			querySubArea.scope.entityAlias = data.entityAlias;
				});
	        }
	        
	        //初始化表单模块
	        $scope.initFormData = function(formScope, obj){
	        	var components = obj.rowList;
				_.forEach(components, function(obj) {
					_.forEach(obj.options, function(value, key) {
						obj.options[key] = value + '';
					});
				});
				formScope.entityId = obj.entityId;
				formScope.attributes = $scope.initFormAttributes(obj, obj.entityId);
				formScope.components = components;
	        }
	        
	        //初始化表单左侧属性选择table数据集
	        $scope.initFormAttributes=function(obj, entityId){
    			var customAttributes = [];
	        	var attributes = _.result(_.find($scope.entityList, {'modelId': entityId}), 'attributes');
		    	for(var i in attributes){
		    		var sourceType = attributes[i].attributeType.source;
		    		if(sourceType != "primitive" && sourceType != "dataDictionary" && sourceType != "enumType"){
						continue;
					}
		    		var isFilter = _.find(obj.rowList, {id: attributes[i].engName}) != null ? true : false;
					var attr = jQuery.extend(true, {}, attributes[i]);
					attr.isFilter = isFilter;
					customAttributes.push(attr);
				}
		    	return customAttributes;
	        }
	        
	        //初始化列表区域模块
	        $scope.initListCodeArea = function(){
	        	var componentList = _.filter($scope.metadataGenerateVO.metadataPageConfigVO.metaComponentDefineVOList, {uiType: 'listCodeArea'});
				var dataList = $scope.metadataGenerateVO.metadataValue.gridComponentList;
	        	_.forEach(componentList, function(component) {
	        		var idName = component.id;
	        		var data = _.find(dataList, {id: idName});
	        		var listCodeArea = component.uiConfig.componentInfo.listCodeArea;
	        		var tempScope = {entityId: '', label:listCodeArea[0].pageURL != null ? JSON.stringify(listCodeArea[0].pageURL) : null, entityAlias: '', attributes: [], customHeaders: [], data: {}};
	        		if(data != null){
		        		var options = data.options;
		        		if(_.size(options) > 0){
		        			tempScope.selectrows = options.selectrows;
							var extras = eval("("+options.extras+")");
			        		if(extras != null){
								var customHeaders = eval("("+extras.tableHeader+")");
			        			tempScope.entityId = data.entityId;
			        			tempScope.entityAlias = data.entityAlias;
								tempScope.attributes = $scope.initGridAttributes(extras.entityId, $scope.entityList, customHeaders);
								tempScope.customHeaders = customHeaders;
								tempScope.data = customHeaders[0];
							} else {
								tempScope.entityId = "";
			        			tempScope.entityAlias = "";
							}
		        		} else {
							tempScope.entityId = "";
		        			tempScope.entityAlias = "";
						}
	        		}
	        		$scope.root[idName] = {metaComponentDefine: component, scope: tempScope};
	        	})
	        }
	        
	        //初始化列表或编辑列表左侧属性table数据源
	     	$scope.initGridAttributes=function(entityId, entityList, customHeaders){
    			var customAttributes = [];
    			var attributes = _.result(_.find(entityList, {'modelId': entityId}), 'attributes');
		    	for(var i in attributes){
		    		var sourceType = attributes[i].attributeType.source;
		    		if(sourceType != "primitive" && sourceType != "dataDictionary" && sourceType != "enumType"){
						continue;
					}
					var isFilter = _.find(customHeaders, {'customHeaderId': attributes[i].engName}) != null ? true : false;
					var attr = jQuery.extend(true, {}, attributes[i]);
					attr.isFilter = isFilter;
					customAttributes.push(attr);
				}
		    	return customAttributes;
	     	}
	        
	     	//初始化编辑区域模块
	        $scope.initEditCodeArea = function(){
	        	var componentList = _.filter($scope.metadataGenerateVO.metadataPageConfigVO.metaComponentDefineVOList, {uiType: 'editCodeArea'});
				var dataList = $scope.metadataGenerateVO.metadataValue.editComponentList;
				_.forEach(componentList, function(component) {
					var idName = component.id;
					var data = _.find(dataList, {id: idName});
					var tempScope = {entityId: '', components: setEditSubAreaData(component, data), attributes: []};
					if(data != null){
						tempScope.entityId = data.entityId;
						tempScope.entityAlias = data.entityAlias; 
						tempScope.attributes = getAttributes(data.entityId);
						var groupingBarList = data.groupingBarList;
		     			var formAreaList = data.formAreaList;
		     			var editGridAreaList = data.editGridAreaList;
		     			var subComponentLayoutSortList = data.subComponentLayoutSortList;
		     			if(tempScope.components.length > 0){//模版配置了子控件
		     				//分组栏区域
			     			_.forEach(groupingBarList, function(chr) {
		            			var groupingBarArea = _.find(tempScope.components, {id: chr.id});
		            			groupingBarArea.value = chr.value;
		    				});
			     			//表单区域
			     			var formCodeAreaList= _.filter(tempScope.components, {uitype: 'editFormCodeArea'});
		     				_.forEach(formAreaList, function(chr) {
		     					var formArea = _.find(tempScope.components, {id: chr.id});
		            			$scope.initFormData(formArea.scope, jQuery.extend(true, chr, {entityId: data.entityId}));
		            			formArea.scope.col = chr.col;
		            			formArea.scope.entityAlias = data.entityAlias;
		    				});
			     			//editGrid区域
		     				_.forEach(editGridAreaList, function(chr) {
		     					var datasource = entityInfoToDatasource(data.entityId);
		            			var editGridArea = _.find(tempScope.components, {id: chr.id});
		            			var editGridScope = editGridArea.scope;
		            			editGridScope.entityId = chr.entityId;
		            			var customHeaders = [];
		            			var options = chr.options;
		            			if(_.size(options) > 0){
			            			var extras = eval("("+options.extras+")");
			    	    			if(extras != null){
			    	    				customHeaders = eval("("+extras.tableHeader+")");
				            			editGridScope.data = customHeaders[0];
				     					var entityList = data.entityId === extras.entityId ? $scope.entityList : $scope.getSubEntity(data.entityId);
				            			editGridScope.attributes = $scope.initGridAttributes(extras.entityId, entityList, customHeaders);
			    	    			}
			            			editGridScope.selectrows = options.selectrows;
		            			}
		            			editGridScope.customHeaders = customHeaders;
		    				});
		     			} else {
		     				//分组栏区域
			     			_.forEach(groupingBarList, function(chr) {
			     				tempScope.components.push(chr);
		    				});
			     			//表单区域
		     				_.forEach(formAreaList, function(chr) {
								var formArea = {id: chr.id, uitype: 'editFormCodeArea', scope: {}};
		            			$scope.initFormData(formArea.scope, jQuery.extend(true, chr, {entityId: data.entityId}));
		            			formArea.scope.col = chr.col;
		            			formArea.scope.entityAlias = data.entityAlias;
		            			tempScope.components.push(formArea);
		    				});
			     			//editGrid区域
		     				_.forEach(editGridAreaList, function(chr) {
		            			var subEntity = $scope.getSubEntity(data.entityId);
		     					var datasource = entityInfoToDatasource(data.entityId);
		     					var editGrid = {id: chr.id, uitype: 'editGridCodeArea', scope: {entityId: chr.entityId}};
		            			var options = chr.options;
		            			var customHeaders = [];
		            			if(_.size(options) > 0){
			            			var extras = eval("("+options.extras+")");
			    	    			if(extras != null){
			    	    				customHeaders = eval("("+extras.tableHeader+")");
			    	    				editGrid.scope.data = customHeaders[0];
			    	    			}
			    	    			editGrid.scope.selectrows = options.selectrows;
		            			}
	    	    				editGrid.scope.attributes = $scope.initGridAttributes(chr.entityId, subEntity, customHeaders);
	    	    				editGrid.scope.customHeaders = customHeaders;
		            			tempScope.components.push(editGrid);
		    				});
		     			}
		     			sortByEditArea(tempScope.components, subComponentLayoutSortList);
					}
	     			$scope.root[idName] = {metaComponentDefine: component, scope: tempScope};
				});
	      	}
	        
	        //初始化uitype=‘’控件
	        $scope.initHidden = function() {
	        	var componentList = _.filter($scope.metadataGenerateVO.metadataPageConfigVO.metaComponentDefineVOList, {uiType: ''});
        		var dataList = $scope.metadataGenerateVO.metadataValue.hiddenComponentList;
	        	_.forEach(componentList, function(component) {
	        		var idName = component.id;
	        		$scope.root[idName] = {metaComponentDefine: component};
	        		var data = _.find(dataList, {id: component.id});
	        		if(data != null){
	        			$scope.root[idName][idName] = data.value;
	        		} 
	        	})
	        }

	        $scope.isQuickBuild = function () {
	        	return window.parent != null && window.parent.location.href.indexOf('EntityWizard.jsp') != -1;
	        }
	        
	     	//获取关联子实体
	     	$scope.getSubEntity=function(entityId){
	     		var subEntity = [];
        		var entityVO = getEntity(entityId);
        		if(entityVO != null && entityVO.attributes != null){
        			dwr.TOPEngine.setAsync(false);
        			PageFacade.dealRelationEntity(entityVO, function(data){
        				subEntity = data;
        			});
        			dwr.TOPEngine.setAsync(true);
      			}
        		return subEntity;
	     	}
	        
	        //保存
	        $scope.save = function() {
	        	var res = validateRequired();
	     	    if(!res.validFlag){
	     			cui.alert(res.message);
	     		  	return;
	     	   	}
	     	    res = validateEntity();
	     	    if(!res){
	     	    	cui.alert("实体未选择。");
	     		  	return;
	     	    }
	     	    res = validateGridAndEditGridStructure();
	     	    if(res.result === 'error'){
	     	    	cui.alert(res.message);
	     		  	return;
	     	    }
	     	    res = validateGridAndEditGridByRule({bindName: bindNameValRule});
	     		if(!res.validFlag){
	     			cui.alert(res.message);
	     			return;
	     		}
	     		res = validateGridAndEditGridByRule({name:nameValRule});
	     		if(!res.validFlag){
	     			cui.alert(res.message);
	     			return;
	     		}
	     		res = validateGridAndEditGridByRule({cname:nameValRule});
	     		if(!res.validFlag){
	     			cui.alert(res.message);
	     			return;
	     		}
	     		res = validateAll();
	     	  	if(!res.validFlag){
	     		   	cui.confirm(res.message+"是否继续保存？<br/>",{
	     				onYes: function(){
	     					$scope.saveModel();
	     				}
	     	      	}); 		   
	     	   	} else {
	     	   		$scope.saveModel();
	     	   	}
	        }
	        
	        //生成元数据
	        $scope.generateCode=function(){
	        	if(cui("#createMetadata_button").options.disable){//按钮设置为禁止，但控件所绑定的事件并没取消绑定
					return false;
				}
	        	var res = validateRequired();
	     	    if(!res.validFlag){
	     			cui.alert(res.message);
	     		  	return false;
	     	   	}
	     	    res = validateEntity();
	     	    if(!res){
	     	    	cui.alert("实体未选择。");
	     		  	return false;
	     	    }
	     	    res = validateGridAndEditGridStructure();
	     	    if(res.result === 'error'){
	     	    	cui.alert(res.message);
	     		  	return false;
	     	    }
	     	    //检查是否已存在对应的页面元数据，需要用到modelName值，用于拼接页面modelName值
	     	    $scope.metadataGenerateVO.modelName = $scope.root.modelName.modelName;
	     	    var hasGenerated = hasGeneratedCode($scope.metadataGenerateVO);
	     	    var callFromParent = arguments[0];
	     	    var def = $.Deferred();
	     	    if(hasGenerated){
	     	    	cui.confirm('页面元数据已存在，是否执行覆盖？', {
			            onYes: function () {
			            	$scope.execGeneratePageMetaCode()
			            	.always(function(reResult, data) {
			            		// console.log("editPage: generate code always, result: %s, data:%O", reResult, data);
			            		// 刷新模块首页
			            		$scope.refreshAppDetailPage();
			            	})
			            	.done(function(reResult, data) {
			            		// console.log("editPage: generate code done, result: %s, data:%O", reResult, data);
			            		def.resolve(reResult, data);
			            	});
			            }
			        });
	     	    } else {
		     	    return $scope.execGeneratePageMetaCode().always(function(reResult, data) {
			            		// 刷新模块首页
			            		$scope.refreshAppDetailPage();
			            	});
	     	    }
	     	   return def.promise();
	        }
	        
	        // 快速构建点击下一步时调用
	        window.generateCode = function (callFromParent) {
	        	return $scope.generateCode(callFromParent);
	        }

	        //请求后台api生成元数据代码
	        $scope.execGeneratePageMetaCode = function(){
	        	var def = $.Deferred();
	        	var reResult = true;
	        	$scope.saveInit();
	     	    var cascadeMethodList = getCascadeMethodList($scope.metadataGenerateVO); 
	        	MetadataGenerateFacade.generatePageJson($scope.metadataGenerateVO, cascadeMethodList, $scope.metadataGenerateVO.metadataValue.entityComponentList[0].rowList[0].modelId, 
	        			{
							callback: function (data){
								operationType = 'edit';
			        			cui("#modelName").setReadonly(true);
			        			var iCount = updatePageActionMethodBody(eval(data.pageModelIds));
			        			var message = "生成界面元数据成功";
								if(data.result === '1'){
			        				cui.message(message, "success");
				        			def.resolve(reResult, data);
			        			} else {
			        				var errorCount = data.templateNum - iCount;
			        				message = "生成界面元数据成功" + iCount + "个，失败" + errorCount + "个，失败界面模版如下：<br/>" + data.failTempateName;
			        				cui.alert(message, function() {
			        					reResult = data.templateNum != errorCount;
			        					if(reResult) {
			        						def.resolve(reResult, data);
			        					}else {
			        						def.reject(reResult, data);
			        					}
			        				});
			        			}
							},
							errorHandler: function(){
								cui.message("生成元数据失败。", "error");
			        			def.reject(false);
							}
						}
	        	);
	        	return def.promise();
	        }
	        
	        $scope.refreshAppDetailPage = function() {
	        	if(openType != "listToMain"){
    				if(appDetailPage && appDetailPage.refresh){
    					appDetailPage.refresh();
    				}	
    				window.focus();
    			}
	        }
	        
	        //保存前初始化
	        $scope.saveInit = function() {
	        	if($scope.metadataGenerateVO.modelId == null){//新增
			    	$scope.metadataGenerateVO.modelName = $scope.root.modelName.modelName;
			    	$scope.metadataGenerateVO.modelId = $scope.metadataGenerateVO.modelPackage+"."+$scope.metadataGenerateVO.modelType+"."+$scope.metadataGenerateVO.modelName;
		        	$scope.metadataGenerateVO.modelPackageId = packageId;
	        	}
	 			var metadataValue = $scope.metadataGenerateVO.metadataValue;
	 			_.forEach($scope.root, function(data, key) {
	        		var uiType = data.metaComponentDefine.uiType;
	        		var idName = data.metaComponentDefine.id;
	    		 	if(uiType === 'input' || uiType === 'menu'){//文本框控件或菜单目录选择控件
	    		 		$scope.setMetadataValueByInputOrMenu(data, metadataValue[uiType+"ComponentList"], idName);
	    		 	} else if(uiType === 'entitySelection'){//实体选择控件
	    		 		$scope.setMetadataValueByEntity(data, metadataValue.entityComponentList, idName);
	    		 	} else if(uiType === 'queryCodeArea'){//查询区域控件
	    		 		$scope.setMetadataValueByQueryArea(data, metadataValue.queryComponentList, idName);
	    		 	} else if(uiType === 'listCodeArea'){//列表区域控件
	    		 		$scope.setMetadataValueByListArea(data, metadataValue.gridComponentList, idName);
	    		 	} else if(uiType === 'editCodeArea'){//编辑区域控件
	    		 		$scope.setMetadataValueByEditArea(data, metadataValue.editComponentList, idName);
	    		 	} else {
	    		 		$scope.setMetadataValueByHidden(data, metadataValue.hiddenComponentList, idName);
	    		 	}
	    		});
	        	
	 			//剔除数组中的null值
	 			_.forEach(metadataValue, function(dataList, key) {
	 				_.forEach(dataList, function(value, index) {
	 					if(value == null){
	 						dataList.splice(index, 1);
		 				}
	 				});
	 			})
	        }
	        
	        //文本框控件中的值设置到metadataValue对象中
	        $scope.setMetadataValueByInputOrMenu = function (data, componentList, idName){
 		 		var inputOrMenuData = {id: idName, name: idName, value: data[idName]};
 		 		var index = _.findIndex(componentList, {id: idName});
	 			if(index >= 0){
	 				componentList[index] = inputOrMenuData;
	 			} else {
			 		componentList.push(inputOrMenuData);
	 			}
	        }
	        
	        //列表控件中的值设置到metadataValue对象中
	        $scope.setMetadataValueByListArea = function (data, componentList, idName){
	        	var listData = data.scope.saveCustomHeader();
 		 		var index = _.findIndex(componentList, {id: idName});
	 			if(index >= 0){
	 				componentList[index] = listData;
	 			} else {
			 		componentList.push(listData);
	 			}
	        }
	        
	        //实体控件中的值设置到metadataValue对象中
	        $scope.setMetadataValueByEntity = function (data, componentList, idName){
	        	componentList.splice(0, componentList.length); 
	        	componentList.push({id: idName, rowList: data.entityList});
	        }
	        
	        //查询区域控件中的值设置到metadataValue对象中
	        $scope.setMetadataValueByQueryArea = function (data, componentList, idName){
	        	var queryData = data.scope.save();
	        	var index = _.findIndex(componentList, {id: idName});
	 			if(index >= 0){
	 				componentList[index] = queryData;
	 			} else {
			 		componentList.push(queryData);
	 			}
	        }
	        
	        //编辑区域控件中的值设置到metadataValue对象中
	        $scope.setMetadataValueByEditArea = function (data, componentList, idName){
	        	var editData = data.scope.save();
 				var index = _.findIndex(componentList, {id: idName});
	 			if(index >= 0){
	 				componentList[index] = editData;
	 			} else {
			 		componentList.push(editData);
	 			}
	        }
	        
	        //空控件中的值设置到metadataValue对象中
	        $scope.setMetadataValueByHidden = function (data, componentList, idName){
	        	var data = {id: idName, name: idName, value: data[idName]};
	        	var index = _.findIndex(componentList, {id: idName});
	 			if(index >= 0){
	 				componentList[index] = data;
	 			} else {
			 		componentList.push(data);
	 			}
	        }
	        
	        /**
			 * 扫描使用了级联的编辑网格
			 * @param metadataGenerateVO 生成界面对象
			 */
			function scanAllCascadeEditGrid(metadataGenerateVO){
				var cascadeEditGridList = [];
				_.forEach(metadataGenerateVO.metadataValue.editComponentList, function (editCmp, editCmpKey) {
					_.forEach(editCmp.editGridAreaList, function(editGrid, editGridKey){
						if(!$.isEmptyObject(editGrid.options)){
							cascadeEditGridList.push({formEditAreaId: editCmp.id, parentEntity: editGrid.entityId, relationEntityId: editCmp.entityId, editGrid: editGrid});
						}
					});		
				});
				return cascadeEditGridList;
	        }
	        
	        function getCascadeMethodList(metadataGenerateVO) {
	        	var cascadeEditGridList = scanAllCascadeEditGrid(metadataGenerateVO);
	        	var cascadeMethodList = [];
// 	        	if(metadataGenerateVO.metadataValue.editComponentList[0].editGridAreaList.length == 0) {	// 未配置editgrid
// 	        		return cascadeMethodList;
// 	        	}
	        	if(cascadeEditGridList.length == 0){
	        		return cascadeMethodList;
	        	}
				//PS:后续可以直接使用cascadeEditGridList实现一下逻辑
	        	tmpCascadeAttribute.length = 0;		// 清空tmpCascadeAttribute
	        	var modelId = metadataGenerateVO.metadataValue.entityComponentList[0].rowList[0].modelId;
	        	// 级联查询方法
	        	cascadeMethodList.push(getQueryCascadeMethod(metadataGenerateVO, modelId));
	        	// 级联保存方法
	        	cascadeMethodList.push(getSaveCascadeMethod(metadataGenerateVO, modelId));
	        	// 级联删除
	        	cascadeMethodList.push(getDeleteCascadeMethod(metadataGenerateVO, modelId));

	        	return cascadeMethodList;
	        }

	        function getQueryCascadeMethod(metadataGenerateVO, modelId) {
	        	var methodVO = createBaseMethodVO('cascadeQuery', "级联查询", "级联查询", "query", [{
		   			"chName":"查询的实体Id",
		   			"dataType":{
		   				"source":"primitive",
		   				"type":"String"
		   				},
		   				"description":"查询的实体Id",
		   				"engName":"entityId",
		   				"parameterId":((new Date()).valueOf()+1).toString(),
		   				"sortNo":0}],
		   				{
		   					"source":"entity",
							"type":"entity",
							"value":modelId
						}, true, 1, getCascadeAttributeList(metadataGenerateVO, modelId));
	        	return methodVO;
	        }

	        function getSaveCascadeMethod(metadataGenerateVO, modelId) {
	        	var methodVO = createBaseMethodVO("cascadeSave", "级联保存", "级联保存", "save", [{
					"chName":"保存的实体VO",
					"dataType":{
						"source":"entity",
						"type":"entity",
						"value":modelId
					},
					"description":"保存的实体VO",
					"engName":"saveVO",
					"parameterId":((new Date()).valueOf()+3).toString(),
					"sortNo":0}],
	   				{
			   			"source":"primitive",
						"type":"String"
					}, false, 3, getCascadeAttributeList(metadataGenerateVO, modelId));
	        	return methodVO;
	        }

	        function getDeleteCascadeMethod(metadataGenerateVO, modelId) {
	        	var methodVO = createBaseMethodVO('cascadeDel', "级联删除", "级联删除", "delete", [{
		   			"chName":"删除的实体VO集合",
		   			"dataType":{
		   				"generic":[{
		   					"source":"entity",
		   					"type":"entity",
		   					"value":modelId}],
		   				"source":"collection",
		   				"type":"java.util.List"
		   			},
		   			"description":"删除的实体VO集合",
		   			"engName":"lstDelVO",
		   			"parameterId":((new Date()).valueOf()+2).toString(),
		   			"sortNo":0}],
		   			{
						"source":"primitive",
						"type":"boolean"
					}, false, 2, getCascadeAttributeList(metadataGenerateVO, modelId));
	        	return methodVO;
	        }

	        var tmpCascadeAttribute = [];
	        function getCascadeAttributeList(metadataGenerateVO, entityId) {
	        	if(tmpCascadeAttribute.length > 0) {
	        		return tmpCascadeAttribute;
	        	}

	        	var entity;
	        	EntityFacade.loadEntity(entityId, {
		    		callback:function (result) {
		    			entity = result;
		    		},
		    		async:false
		    	});
	        	var relationMap = [];
		    	_.forEach(entity.lstRelation, function (relation) {
					return relationMap[relation.targetEntityId] = relation;
				});

	        	
	        	var editComponentList = metadataGenerateVO.metadataValue.editComponentList;
	        	for (var i = 0; i < editComponentList.length; i++) {
	        		if(editComponentList[0].editGridAreaList[0] == null) {
						continue;
					}
	        		var name = editComponentList[0].editGridAreaList[0].options.databind.split(".")[1];
	        		var relationEntityId = editComponentList[i].editGridAreaList[0].entityId;
	        		tmpCascadeAttribute.push({
	        			"generateCodeType": relationEntityId,
	        			"id": relationMap[relationEntityId].relationId + "/" + entityId + "." + name,
	        			"name": name,
	        			"parentId":"-1"
	        		});
	        	}
	        	return tmpCascadeAttribute;
	        }


	        function createBaseMethodVO(ename, cname, desc, methodOperateType, parameters, returnType, transaction, n, lstCascadeAttribute){
		   		var method = {
		   				"accessLevel":"public",
		   				"aliasName":ename,
		   				"assoMethodName":"",
		   				"autoMethod":false,
		   				"chName":cname,
		   				"constraint":"",
		   				"description":desc,
		   				"engName":ename,
		   				"exceptions":[],
		   				"expPerformance":"",
		   				"features":"",
		   				"privateService":"false",
		   				"lstCascadeAttribute":lstCascadeAttribute,//
		   				"methodId":((new Date()).valueOf() + n).toString(),
		   				"methodOperateType":methodOperateType,
		   				"methodSource":"entity",
		   				"methodType":"cascade",
		   				"needCount":false,
		   				"needPagination":false,
		   				"parameters":parameters,
		   				"returnType":returnType,
		   				"serviceEx":"none",
		   				"transaction":transaction
		   		};
		   		
		   		return method;
		   	};

	        //请求保存后台接口
			$scope.saveModel = function() {
				cui("#createMetadata_button").disable(true);
				$scope.saveInit();
		    	dwr.TOPEngine.setAsync(false);
		    	// 若有配置editgrid则需要构建级联方法
		    	var cascadeMethodList = getCascadeMethodList($scope.metadataGenerateVO); 
	        	MetadataGenerateFacade.saveModel($scope.metadataGenerateVO, cascadeMethodList, $scope.metadataGenerateVO.metadataValue.entityComponentList[0].rowList[0].modelId, function(data){
	        		if(data){
	        			cui.message('页面保存成功。', 'success',  {'callback':function(){cui("#createMetadata_button").disable(false);}});
	      			  	operationType = 'edit';
	      			  	cui("#modelName").setReadonly(true);
		      			if(openType != "listToMain"){
		    				if(appDetailPage && appDetailPage.refresh){
		    					appDetailPage.refresh();
		    				}
		    				window.focus();
		    			}
	      		  	}else{
	      			 	$scope.metadataGenerateVO = {};
	      			 	cui.error("页面保存失败。"); 
			      		cui("#createMetadata_button").disable(false);
	      		  	}
				});
				dwr.TOPEngine.setAsync(true);
	        }
	        
			//返回
			$scope.back = function() {
				cui.confirm('请确认保存了，再离开此页面。',{
					onYes:function(){
						//恢复父窗口原先结构展现模式
						window.parent.cui("#body").setCollapse("left", originalCollapsed);
						var attr="packageId="+packageId+"&selectedTabId=metadataGenerate";
						window.location="../PageHome.jsp?"+attr;
					}
				});
			}
			
			//关闭页面
			$scope.close = function(){
				 window.close();
			}
			
	      	//加载生成的元数据模版
	        $scope.getMetadataGenerate = function () {
	        	dwr.TOPEngine.setAsync(false);
	      		MetadataGenerateFacade.loadModel(metadataGenerateModelId, packageId, function(data){
	        		if(data != null){
	        			$scope.metadataGenerateVO = data;
	        			metadataPageConfigModelId = data.metadataPageConfigModelId != null ? data.metadataPageConfigModelId : metadataPageConfigModelId;
	        		}
				});
	      		dwr.TOPEngine.setAsync(true);
	      		if($scope.metadataGenerateVO.metadataPageConfigModelId == null){//新增
	      			$scope.metadataGenerateVO.metadataPageConfigModelId = metadataPageConfigModelId;
	      			$scope.metadataGenerateVO.metadataPageConfigVO = $scope.getMetadataPageConfig(metadataPageConfigModelId);
	      		}
	        }
	        
	        //通过模版modelId获取页面配置信息
	        $scope.getMetadataPageConfig = function(){
	        	var metadataPageConfigVO = {};
	        	dwr.TOPEngine.setAsync(false);
	        	MetadataPageConfigFacade.loadModel(metadataPageConfigModelId, function(data){
	        		metadataPageConfigVO = data;
				});
				dwr.TOPEngine.setAsync(true);
				return metadataPageConfigVO;
	        }
	      	
	        //加载元数据模版
	        $scope.loadTemplate = function () {
				$('#metadataForm').html(new jCT($('#metadataFormInterfaceTmpl').html()).Build().GetView()); 
				$compile($('#metadataForm').contents())(scope);
	        }
    	});
		
		//获取工具箱数据
	    function initToolsdata(){
		    dwr.TOPEngine.setAsync(false);
		    ComponentTypeFacade.queryList(function(data){
	           toolsdata = data;
	        });
		    dwr.TOPEngine.setAsync(true);
	    }
		
		//从其他页面导入表达式
    	function openCatalogSelect(){
    		var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-400)/2;
    		window.open ('../designer/CatalogSelect.jsp?packageId='+packageId,'CatalogSelectWin','height=600,width=400,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
    	}
		
    	//设置上级目录
    	function setCatalog(node){
    		scope.root.parentName.parentName = node.title;
    		scope.root.parentId.parentId = node.key;
    		cap.digestValue(scope);
    	}
		
	    //列表按钮组
	    function customColumnButtonGroup2Grid(){
	    	var caller = this.id;
	    	return {
	            datasource: [
	                {id:'insertSerialCol',label:'添加序号列'},
	                {id:'insertBlankCol',label:'添加空白列'}
	            ],
	            on_click : function(obj){
	            	if(obj.id === 'insertSerialCol'){
	            		caller.addCustomHeader({customHeaderId: (new Date()).valueOf()+'', name: '序号', level: 1, indent:'', bindName:'1'});
	            	}else if(obj.id === 'insertBlankCol'){
	            		caller.addCustomHeader({customHeaderId: (new Date()).valueOf()+'', name: '', level: 1, indent:''});
	            	}
	            	cap.digestValue(caller);
	            }
	        };
	    }

	    //列表按钮组
		function customColumnButtonGroup2EditGrid(){
			var caller = this.id;
			return {
		        datasource: [
     	            {id:'insertSerialCol',label:'添加序号列'},
     	            {id:'insertBlankCol',label:'添加空白列'}
     	        ],
     	        on_click : function(obj){
     	        	if(obj.id === 'insertSerialCol'){
     	        		caller.addCustomHeader({customHeaderId: (new Date()).valueOf()+'', name: '序号', level: 1, indent:'', bindName:'1', edittype:{data:{}}});
     	        	}else if(obj.id === 'insertBlankCol'){
     	        		caller.addCustomHeader({customHeaderId: (new Date()).valueOf()+'', name: '', level: 1, indent:'', edittype:{data:{}}});
     	        	}
     	        	cap.digestValue(caller);
     	        }
     	    };
		}
	    
	    //实体列表按钮组(页面数据集)
	    function initEntityPullDown(obj){
	    	obj.setDatasource(entityDatasource); 
	    }
	    
	  	//选择实体
		function openEntitySelect(){
			var sequenceNumber = this.sequenceNumber;
    		var url = "../designer/EntityListSelectionMain.jsp?packageId=" + packageId + "&filterEntityTypes=query_entity,data_entity&callBackMethod=importEntityCallBack_" + sequenceNumber;
			var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
			window.open(url,'entitySelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    	}
		
		/**
		 * 获取实体信息
		 * @param entityId 实体id
		 */
	  	function getEntity(entityId){
	  		var entityVO = null;
			if(entityId != null && entityId != ''){
		  		entityVO = _.find(scope.entityList, {modelId: entityId});
		  		if(entityVO == null){
			  		dwr.TOPEngine.setAsync(false);
					PageFacade.readEntity(entityId,function(data){
						entityVO= data;
					});
					dwr.TOPEngine.setAsync(true);
		  		}
			}
			return entityVO;
	  	}
	  	
		//导入实体回调函数
		function importEntityCallBack(entityVO){
			var componentDefineId = this.id;
			var sequenceNumber = this.sequenceNumber - 1;
			scope.root[componentDefineId].entityList[sequenceNumber].modelId = entityVO.modelId;
			scope.root[componentDefineId].entityList[sequenceNumber].engName = entityVO.engName;
			scope.root[componentDefineId].entityList[sequenceNumber].chName = entityVO.chName;
			scope.root[componentDefineId].entityList[sequenceNumber].entityAlias = entityVO.aliasName;
			if(entityVO.parentEntity != null){
				scope.root[componentDefineId].entityList[sequenceNumber].parentEntityModelId = entityVO.parentEntity.modelId;
			}
			entityVO.suffix = this.suffix;
			scope.entityList[sequenceNumber] = entityVO;
			cap.digestValue(scope);
			entityDatasource = entityDataToDatasource(scope.entityList);
			var entitySelectedPullDownNode = $("span[id^='selectEntity_']");
			for(var i=0, len=entitySelectedPullDownNode.length; i<len; i++){
				var cuiNode = cui(entitySelectedPullDownNode[i]);
				var oldSelectData = cuiNode.selectData;
				var oldSelectValue = oldSelectData != null ? oldSelectData.id : '';
				var name = cuiNode.options.name;
				cuiNode.setDatasource(entityDatasource);
				var embeddedDirectiveScope = scope.root[name].scope;
				cuiNode.setValue(oldSelectValue);
				
				if(cuiNode.options.alias != null && cuiNode.options.alias === this.suffix){
					embeddedDirectiveScope.entityAlias = this.suffix;
					embeddedDirectiveScope.entityId = entityVO.modelId;
					if(oldSelectData != null && oldSelectData.entityVO.modelId != entityVO.modelId){
						embeddedDirectiveScope.reloadData();
					}
					cap.digestValue(embeddedDirectiveScope);
				} else if(oldSelectValue != ''){
					var metaComponentDefine = scope.root[name].metaComponentDefine;
					var uitype = metaComponentDefine.uiType;
					if(oldSelectValue === this.suffix && entityVO.modelId != oldSelectData.entityVO.modelId){
						embeddedDirectiveScope.entityId = entityVO.modelId;
						embeddedDirectiveScope.reloadData();
						cap.digestValue(embeddedDirectiveScope);
					}
				}
			}
		}
		
		//打开数据模型选择界面
		function openDataStoreSelect(event, self) {
			var bindObj = {componentDefineId: self.options.componentdefineid, subComponentDefineId: self.options.subcomponentdefineid, subComponentDefineType: self.options.subcomponentdefinetype, rowId: self.options.rowid};
			var entityId = scope.root[bindObj.componentDefineId].scope.entityId;
			if(bindObj.subComponentDefineType === 'editGridCodeArea'){
				entityId = _.find(scope.root[bindObj.componentDefineId].scope.components, {'id': bindObj.subComponentDefineId}).scope.entityId;
			} else {
				entityId = scope.root[bindObj.componentDefineId].scope.entityId;
			}
			if(entityId == ''){
				cui.alert("请选择数据对象。");
				return;
			}
			editCallBackAttrSelect_wrap = _.bind(editCallBackAttrSelect, bindObj);
			var param = '?entityId='+entityId+'&propertyName='+self.options.name+'&flag='+self.options.flag+'&callbackMethod=editCallBackAttrSelect_wrap';
			var url = './EntityAttributeSelection.jsp' + param;
			var top=(window.screen.availHeight-450)/2;
			var left=(window.screen.availWidth-500)/2;
			window.open(url,'importRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		}

		//选择实体属性回调
		function editCallBackAttrSelect(data, flag, propertyName) {
			var entityVo = _.find(scope.entityList, {'suffix': scope.root[this.componentDefineId].scope.entityAlias});
			var obj = {};
			var embeddedDirectiveScope = {};
			if(this.subComponentDefineType === 'queryFixedCodeArea' || this.subComponentDefineType === 'queryMoreCodeArea'
					|| this.subComponentDefineType === 'editFormCodeArea'){
				embeddedDirectiveScope = _.find(_.find(scope.root[this.componentDefineId].scope.components, {'id': this.subComponentDefineId}).scope.components,{'id': this.rowId}).scope;
				obj = embeddedDirectiveScope.data;
				obj[propertyName] = entityVo.suffix + '.' + data.engName;
			} else if(this.subComponentDefineType === 'editGridCodeArea'){
				embeddedDirectiveScope = _.find(scope.root[this.componentDefineId].scope.components, {'id': this.subComponentDefineId}).scope;
				obj = embeddedDirectiveScope.data.edittype.data;
				obj[propertyName] = data.engName;
			} else {
				embeddedDirectiveScope = scope.root[flag].scope.embeddedDirectiveScope;
				obj = scope.root[flag].scope.data.edittype.data;
				obj[propertyName] = entityVo.suffix + '.' + data.engName;
			}
			var isChooseUserOrg = obj.uitype === 'ChooseUser' || obj.uitype === 'ChooseOrg';
			if(isChooseUserOrg){
				if(propertyName === 'idName'){
					obj.databind = obj[propertyName] + obj.uitype;
				} else if(propertyName === "opts"){
					obj.opts = "{'codeName':'"+ entityVo.suffix + '.' + data.engName+"'}";
				} else if(propertyName === 'databind'){
					obj.databind = obj.databind + obj.uitype;
				}
			} else if(propertyName === 'databind' && obj.hasOwnProperty("validate")){
				var validate = generateValidate(data, obj.uitype, this.subComponentDefineType);
				obj.validate = validate.length > 0 ? JSON.stringify(validate) : "";
			} 
			embeddedDirectiveScope.$digest();
			cap.digestValue(embeddedDirectiveScope);
		}

		/**
		 * 跳转到校验组件界面(js/css/dom)
		 * @param event
		 * @param self
		 */
		function openValidateAreaWindow(event, self){
			var bindObj = {componentDefineId: self.options.componentdefineid, subComponentDefineId: self.options.subcomponentdefineid, subComponentDefineType: self.options.subcomponentdefinetype, rowId: self.options.rowid};
			var param = '?propertyName='+self.options.name + '&callbackMethod=callBackOpenWindow_wrap';
			var url = '../uilibrary/ValidateComponent.jsp' + param;
			var width=800; //窗口宽度
		    var height=600; //窗口高度
		    var top=(window.screen.availHeight-height)/2;
		    var left=(window.screen.availWidth-width)/2;
		    currSelectDataModelVal=self.$input[0].value;
		    callBackOpenWindow_wrap = _.bind(callBackOpenWindow, bindObj);
		    window.open(url, "validateArea", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}

		/**
		 * 公共的回调函数
		 * @param propertyName
		 * @param propertyValue
		 */
		function callBackOpenWindow(propertyName, propertyValue){
			var obj = {};
			var embeddedDirectiveScope = {};
			if(this.subComponentDefineType === 'queryFixedCodeArea' || this.subComponentDefineType === 'queryMoreCodeArea'
				|| this.subComponentDefineType === 'editFormCodeArea'){
				embeddedDirectiveScope = _.find(_.find(scope.root[this.componentDefineId].scope.components, {'id': this.subComponentDefineId}).scope.components,{'id': this.rowId}).scope;
				obj = embeddedDirectiveScope.data;
			} else if(this.subComponentDefineType === 'editGridCodeArea'){
				embeddedDirectiveScope = _.find(scope.root[this.componentDefineId].scope.components, {'id': this.subComponentDefineId}).scope;
				obj = embeddedDirectiveScope.data.edittype.data;
			} else {
				embeddedDirectiveScope = scope.root[this.componentDefineId].scope;
				obj = embeddedDirectiveScope.data.edittype.data;
			}
			obj[propertyName] = propertyValue;
			cap.digestValue(embeddedDirectiveScope);
		}

		/**
		 * 打开input组件的mask属性编辑窗口(js/css/dom)
		 * @param event
		 * @param self
		 */
		function openSelectInputMaskWindow(event, self){
			var bindObj = {componentDefineId: self.options.componentdefineid, subComponentDefineId: self.options.subcomponentdefineid, subComponentDefineType: self.options.subcomponentdefinetype, rowId: self.options.rowid};
		    var data = {};
		    data = _.find(scope.root[bindObj.componentDefineId].scope.components, {'id': bindObj.subComponentDefineId}).scope.data.edittype.data;
		    callBackOpenWindow_wrap = _.bind(callBackOpenWindow, bindObj);
			var width=450; //窗口宽度
		    var height=300; //窗口高度
		    var url='../uilibrary/SelectInputMask.jsp?mask='+data.mask+'&callbackMethod=callBackOpenWindow_wrap&valuetype='+self.options.valuetype+'&maskoptions='+escape(data.maskoptions);
		    var top=(window.screen.availHeight-height)/2;
		    var left=(window.screen.availWidth-width)/2;
		    window.open(url, "selectInputMask", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}

		//打开数据字典选择界面
		function openDictionarySelect(event, self) {
			var codeVal = self.$input.val();
			var bindObj = {componentDefineId: self.options.componentdefineid, subComponentDefineId: self.options.subcomponentdefineid, subComponentDefineType: self.options.subcomponentdefinetype, rowId: self.options.rowid};
			var url = '../dictionary/SelectDictionary.jsp?sourceModuleId=' + packageId + '&propertyName='+self.options.name+'&code='+codeVal+'&callbackMethod=callBackOpenWindow_wrap';
			var top=(window.screen.availHeight-600)/2;
			var left=(window.screen.availWidth-800)/2;
			callBackOpenWindow_wrap = _.bind(callBackOpenWindow, bindObj);
			window.open(url,'dictionarySelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		}

		/**
		 * 跳转到编写代码文本域界面(js/css/dom)
		 * @param event
		 * @param self
		 */
		function openCodeEditAreaWindow(event, self){
			var bindObj = {componentDefineId: self.options.componentdefineid, subComponentDefineId: self.options.subcomponentdefineid, subComponentDefineType: self.options.subcomponentdefinetype, rowId: self.options.rowid};
			var scopeName = 'scope.root.'+bindObj.componentDefineId+'.scope';
			if(bindObj.subComponentDefineType === 'editGridCodeArea'){
				var index = _.findIndex(scope.root[bindObj.componentDefineId].scope.components, {'id': bindObj.subComponentDefineId});
				scopeName = "scope.root."+bindObj.componentDefineId+".scope.components["+index+"].scope";
			} else if(bindObj.subComponentDefineType === 'queryFixedCodeArea' || bindObj.subComponentDefineType === 'queryMoreCodeArea'){
				var subComponentIndex = _.findIndex(scope.root[bindObj.componentDefineId].scope.components, {'id': bindObj.subComponentDefineId});
				var index = _.findIndex(scope.root[bindObj.componentDefineId].scope.components[subComponentIndex].scope.components, {'id': bindObj.rowId});
				scopeName = "scope.root."+bindObj.componentDefineId+".scope.components["+subComponentIndex+"].scope.components["+ index +"].scope";
			}
			var width=800; //窗口宽度
		    var height=600; //窗口高度
		    var top=(window.screen.availHeight-height)/2;
		    var left=(window.screen.availWidth-width)/2;
		    var propertyName=self.options.name;
		    var url='../uilibrary/CustomDataModel.jsp?removeTabIndex=1&propertyName='+propertyName+'&callbackMethod=callBackOpenWindow_wrap&scopeName='+scopeName;
		    callBackOpenWindow_wrap = _.bind(callBackOpenWindow, bindObj);
		    window.open(url, "codeEditArea", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}
		
		//初始化表单区域列合并下拉框数据源（该函数给_.bind包装函数使用）
		function colPulldown(obj){
			obj.setDatasource(this.data);
		}
		
		//过滤数据源
		function filterDatasource(entityAreaDatasource, originalDatasource, condition){
			var datasource = [];
			var filterData = _.find(entityAreaDatasource, {suffix: condition});
			if(filterData != null){
				datasource = _.filter(originalDatasource, function(n){
					return n.id != filterData.modelId;
				});
				var entityList = _.filter(scope.entityList, {modelId: filterData.modelId});
				if(entityList.length > 1){
					datasource.push({id: entityList[0].modelId, text: entityList[0].engName, entityVO: entityList[0]});
				}
			}
			return datasource;
		}
		
		//验证规则
	    var modelNameValRule = [{type:'required',rule:{m:'模块英文名称不能为空'}},{type:'format', rule:{pattern:'\^[a-z]\\w+\$', m:'模块英文名称只能输入由字母、数字或者下划线组成的字符串,且首字符必须为小写字母'}},{type:'custom',rule:{against:'isExistModelName', m:'模块英文名称已存在'}}];
	    var cnameValRule = [{type:'required',rule:{m:'模块中文名称不能为空'}}];
	    var parentNameValRule = [{type:'required',rule:{m:'上级菜单/目录不能为空'}}];
	    var bindNameValRule = [{type:'format', rule:{pattern:'^\\w+$', m:'只能输入由字母、数字或者下划线组成的字符串'}}];
	    //var nameValRule = [{type:'format', rule:{pattern:'^[a-zA-Z_0-9\u4e00-\u9fa5]+$', m:'只能输入由字母、数字、汉字或者下划线组成的字符串'}}];
	    var nameValRule = [{type:'exclusion', rule:{within:['\\','$'], partialMatch:true, caseSensitive:true , m:'名称不能为空并且不能输入‘\\’字符'}}];
	    
		//模块英文名称是否存在检验
		function isExistModelName(modelName){
			var ret = true;
			if(operationType === 'edit'){
				cui("#modelName").setReadonly(true);
			} else {
				dwr.TOPEngine.setAsync(false);
	        	MetadataGenerateFacade.isExistNewModelName(modelName, function(result) {
	        		ret = !result;
	        	});
	        	dwr.TOPEngine.setAsync(true);
			}
			return ret;
		}
		
		//检验关联页面是否勾选，前提实体已选择
		function isSelectedEntityAssociationPage(value, args){
			var entityEngName = eval(args);
			return entityEngName != '' ? value != null && value.length > 0 ? true : false : true;
		}
		
		//检验必填项
		function validateRequired(){
			var data = {};
	    	var validate = new cap.Validate();
	    	var valRule = {};
	    	if(scope.root.modelName){
	    		valRule.modelName = modelNameValRule;
	    		data.modelName = scope.root.modelName.modelName;
	    	}
	    	return validate.validateAllElement(data, valRule);
	    }
		
		//实体检验
		function validateEntity(){
			var ret = true;
			_.forEach(scope.root, function(value, key) {
        		var uiType = value.metaComponentDefine.uiType;
        		var idName = value.metaComponentDefine.id;
    		 	if(uiType === 'entitySelection'){//实体选择控件
    		 		_.forEach(value.entityList, function(chr) {
    		 			if(chr.engName == ''){
    		 				ret = false;
    		 			}
    		 		});
    		 	}
    		});
			return ret;	
		}
		
		//grid、editGrid表头结构校验
		function validateGridAndEditGridStructure(){
			var retData = {result: 'success', message: '', pointingId: ''};
			_.forEach(scope.root, function(value, key) {
        		var uiType = value.metaComponentDefine.uiType;
        		var idName = value.metaComponentDefine.id;
    		 	if(uiType === 'listCodeArea'){
    		 		packTipMessage(retData, value.scope.validate(), idName);
    		 	} else if(uiType === 'editCodeArea'){
    		 		_.forEach(value.scope.components, function(component, index) {
    		 			if(component.uitype === 'editGridCodeArea'){
    		 				packTipMessage(retData, component.scope.validate(), component.id);
    		 			}
    		 		});
    		 	}
    		});
			if(retData.pointingId != ''){
				var relativeTopHeight = $("#"+retData.pointingId).position().top-50;
				if(relativeTopHeight > 25){
					$(".container").animate({scrollTop: relativeTopHeight}, 10);
				} else {
					$(".container").animate({scrollTop: $(".container").scrollTop() + relativeTopHeight}, 10);
				}
			}
			return retData;	
		} 
		
		//封装提示信息
		function packTipMessage(retData, res, idName){
			if(res.result == 'error'){
	 			var titleName = $("#"+idName+" .area_title span .cap-form-group span").html();
	 			retData.result = res.result;
	 			retData.message += "【" + titleName + "】" + res.message + "<br/>";
	 			retData.pointingId = retData.pointingId != '' ? retData.pointingId : idName;
	 		}
		}
		
		//统一校验函数
		function validateAll(){
			var data = {};
	    	var validate = new cap.Validate();
	    	var valRule = {};
	    	if(scope.root.modelName){
	    		valRule.modelName = modelNameValRule;
	    		data.modelName = scope.root.modelName.modelName;
	    	}
	    	if(scope.root.cname){
	    		valRule.cname = cnameValRule;
	    		data.cname = scope.root.cname.cname;
	    	}
	    	if(scope.root.parentName){
	    		valRule.parentName = parentNameValRule;
	    		data.parentName = scope.root.parentName.parentName;
	    	}
			return validate.validateAllElement(data, valRule);
		}
		
		//校验网格列对象值
		function validateGridAndEditGridByRule(ruleObj){
	    	var validate = new cap.Validate();
	    	var bindNameRule = {bindName: bindNameValRule};
	    	var bindNameCloumns=[];
	    	_.forEach(scope.root, function(value, key) {
        		var uiType = value.metaComponentDefine.uiType;
        		var idName = value.metaComponentDefine.id;
    		 	if(uiType === 'listCodeArea'){
    		 		var listAreaCloumns = value.scope.customHeaders;
    		    	for(var j=0, len=listAreaCloumns.length; j<len; j++){
        				bindNameCloumns.push(listAreaCloumns[j]);
        			}
    		 	} else if(uiType === 'editCodeArea' || uiType === 'queryCodeArea'){
    		 		_.forEach(value.scope.components, function(component, index) {
    		 			if(component.uitype === 'editGridCodeArea'){
    		 				var editGridCloumn = component.scope.customHeaders;
			    			for(var j=0, len=editGridCloumn.length; j<len; j++){
			    				bindNameCloumns.push(editGridCloumn[j]);
			    			}
    		 			}else if(component.uitype === 'editFormCodeArea' || component.uitype === 'queryFixedCodeArea' || component.uitype === 'queryMoreCodeArea'){
    		 				var editGridCloumn = component.scope.components;
    		 				for(var j=0, len=editGridCloumn.length; j<len; j++){
			    				bindNameCloumns.push(editGridCloumn[j]);
			    			}
    		 			}
    		 		});
    		 	}
    		});
	    	return validate.validateAllElement(bindNameCloumns, ruleObj);
		}
		
		//设置表单区域高度
		function setContainerHeight(){
			var containerHeight = document.documentElement.clientHeight || document.body.clientHeight;
        	$(".container").height(containerHeight-80);
		}
	</script>
	<%@ include file="/cap/bm/dev/page/template/MetadataComponentTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesBatchEditTmpl.jsp" %>
</body>
</html>
