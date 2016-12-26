<!-- 
* 模块快速构建：中间部分布局
* 2015-08-03 杨赛
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/template.png">
    <title>模块实体快速构建页面</title>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <!-- <top:link href="/cap/bm/dev/page/template/css/base.css"/> -->
    <top:link href="/cap/bm/dev/wizard/css/stepNav.css"></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.all.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/dev/wizard/js/PageSession.js"></top:script>
	<!-- dwr -->
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/MetadataGenerateFacade.js"></top:script>
</head>
<body ng-app="entityWizard">
	<div id="entityWizardLayout" uitype="Borderlayout" is_root="true" ng-controller="entityWizardCtrl">
		<div position="top" height="80px" split_size=0 ng-init="cuiScan()">
			<!-- step-nav 指令 -->
			<div step-nav resource-set="wizardSet"  data-current-step="stepInfo.currentStep" enable-step="stepInfo.enableStep" on-show-resource="showResource(resource, index)" on-save="save(currentResource, index)"></div>
		</div>
		<div position="center">
		</div>
	</div>
	<script type="text/javascript">
		var moduleCode = "${param.moduleCode}";
		angular.module('entityWizard', ['cui']).controller('entityWizardCtrl', ['$scope', '$window', function($scope, $window){
			
			var entityId;
			var pageSessionId = entityId = cui.utils.param.entityId;
			// 构建pageSession 用于iframe之间数据共享
			var pageSession;
			if($window.parent.pageSessionMap[entityId]) {
				pageSession = $window.pageSession = $window.parent.pageSessionMap[entityId];
			}else {
				pageSession = $window.pageSession = $window.parent.pageSessionMap[entityId] = new PageSession(pageSessionId);
			}

			var entity;
			$scope.wizardSet = [
				{code:'entityInfoEdit', name:'实体信息编辑', url: 'EntityInfoEdit.jsp'},
				{code:'entityAttrEdit', name: '实体属性编辑', url: 'EntityAttrEdit.jsp'},
				{code:'MetadataGenerateEdit',name: '页面控件定义', url: webPath + '/cap/bm/dev/page/template/MetadataGenerateEdit.jsp'},
				{code:'codeGeneration',name: '代码生成', url: 'CodeGeneration.jsp'}
			];

			initData();

			function initData() {
				// 获取数据存放到pageSession
				initPageSession($window.pageSession);

				// 只有是第一次构建，才显示实体属性编辑
				if(!isFirstBuild()) {
					$scope.wizardSet.splice(1, 1);
				}
			}
			

			// pageSession获取数据
			function initPageSession(pageSession) {

				// 存入entity
				EntityFacade.loadEntity(entityId, {
		    		callback:function (result) {
		    			entity = result;
		    			var oldEntity = pageSession.get("page_session_entity");
		    			if(oldEntity) {
		    				entity.hasWorkInfo = oldEntity.hasWorkInfo;
		    			}
		    			pageSession.createPageAttribute("page_session_entity",entity);

		    		},
		    		async:false
		    	});

				$scope.stepInfo = pageSession.get("page_session_step_info", {
						currentStep: 0,
						enableStep: 0
					});
			}

			$scope.cuiScan = function () {
				comtop.UI.scan();
			}

			

			function isFirstBuild() {
				var attriViewVOList = pageSession.get("page_session_attriViewVOList");
				if(attriViewVOList) {
					return true;
				}else {
					var generateVOName = pageSession.get("page_session_generate_name", fristWordLoweCase(entity.modelName));
					var generateVOModelId = entity.modelPackage + '.metadataGenerate.' + generateVOName;
					var metadataGenerateVO;
					MetadataGenerateFacade.readModel(generateVOModelId, {
		    			callback:function (result) {
		    				metadataGenerateVO = result;
		    			},
		    			async:false
		    		});
		    		if(metadataGenerateVO) {
		    			pageSession.createPageAttribute("page_session_metadataGenerateVO", metadataGenerateVO);
		    			return false;
		    		}else {
						return true;
		    		}
				}
			}

			function fristWordLoweCase(str) {
				if(str == null || str == '') {
					return str;
				}

				var fristWord = str.slice(0, 1);
				var lowerFristWord = fristWord.toLowerCase();

				if(fristWord === lowerFristWord) {	// 首字母就是小写
					return str;
				}
				return lowerFristWord + str.slice(1);

			}

			// 下一步
			$window.nextStep = $scope.nextStep =  function () {
				var resourceSet = $scope.wizardSet
                if($scope.stepInfo.currentStep == resourceSet.length - 1) {
                    return;
                }
                $scope.stepInfo.currentStep = $scope.stepInfo.currentStep + 1;
                if($scope.stepInfo.currentStep >= $scope.stepInfo.enableStep) {
                    $scope.stepInfo.enableStep = $scope.stepInfo.currentStep + 1;
                }
                $scope.showResource(resourceSet[$scope.stepInfo.currentStep], $scope.stepInfo.currentStep);
                $scope.$apply();
			}

			// 上一步
			$window.preStep = $scope.preStep = function () {
			    var resourceSet = $scope.wizardSet
			    if($scope.stepInfo.currentStep == 0) {
			        return;
			    }
			    $scope.stepInfo.currentStep = $scope.stepInfo.currentStep - 1;
			    $scope.showResource(resourceSet[$scope.stepInfo.currentStep], $scope.stepInfo.currentStep);
			    $scope.$apply();
			}

			$scope.showResource = function (resource, index) {
				// console.debug(resource, index);
				
				var url = resource.url;
				if(resource.code == 'MetadataGenerateEdit') {
					var metadataGenerateVO = pageSession.get("page_session_metadataGenerateVO");
					url = url + '?packageId=' + entity.packageId + '&operationType=edit&metadataGenerateModelId=' + metadataGenerateVO.modelId;
				}else {
					url = url + "?entityId=" + cui.utils.param.entityId;
				}
				cui("#entityWizardLayout").setContentURL('center', url);
			}

			// 下一步之前保存当前页面属性 返回false则不调到下一步
			$scope.save = function (currentResource, index) {
				if(currentResource.code == 'MetadataGenerateEdit') {
					var result = $window.frames[0].generateCode(true);
					if(result && result.done) {
						result.done(function(reResult, data) {
							console.log("wizardPage: generate code done, result: %s, data:%O", reResult, data);
			        		if(reResult) {
			        			//设置实体与生成的页面之间的映射（快速构建功能使用）
			        			var pWindow = cap.searchParentWindow("genPageJsonResult");
			        			if(pWindow && pWindow["setEntityPageMapping"]){
				        			pWindow["setEntityPageMapping"].call({},data);
			        			}
				        	}
						});
					}
					return result;
				}
	
				
				
				if(typeof $window.frames[0].save === 'function') {
					return $window.frames[0].save();
				}
				throw new Error("子页面未定义点击下一步时调用的save()方法.");
			}

		}]).directive('stepNav', function () {
	        // Runs during compile
	        return {
	            // priority: 1,
	            // terminal: true,
	            scope: {
	                resourceSet: '=',
	                currentStep: '=',
	                enableStep: '=',
	                onShowResource: '&',
	                onSave: '&'
	            }, // {} = isolate, true = child, false/undefined = no change
	            // controller: function($scope, $element, $attrs, $transclude) {},
	            // require: 'ngModel', // Array = multiple requires, ? = optional, ^ = check parent elements
	            restrict: 'A', // E = Element, A = Attribute, C = Class, M = Comment
	            // template: '',
	            templateUrl: 'template/stepNav.tpl.html',
	            // replace: true,
	            // transclude: true,
	            // compile: function(tElement, tAttrs, function transclude(function(scope, cloneLinkingFn){ return function linking(scope, elm, attrs){}})),
	            link: function($scope, iElm, iAttrs, controller) {

	            	// 验证是否有配置必须的映射属性
	            	function validateAttr(value, message) {
	            		if(angular.isUndefined(iAttrs[value])) {
	            			throw new Error(message);
	            		}
	            	}
	            	validateAttr('currentStep', "stepNav指令必须指定current-step或者data-current-step属性.")
	            	validateAttr('enableStep', "stepNav指令必须指定enable-step或者data-enable-step属性.")
	            	$scope.currentStep = $scope.currentStep || 0;
	            	$scope.enableStep = $scope.enableStep || 0;
	                // console.debug("link step-nav directive",$scope.resourceSet, $scope.currentStep, $scope.enableStep);
	                // 调用外部方法onShowResource方法
	                $scope.showResource = function (resource, index) {
	                    $scope.currentStep = index;
	                    $scope.onShowResource({resource:resource, index:index});
	                }

	                // 下一步
	                $scope.nextStep = function () {
	                    var resourceSet = $scope.resourceSet
	                    if($scope.isLast()) {
	                        return;
	                    }

	                    if(!angular.isUndefined(iAttrs["onSave"])) {
	                    	var result = $scope.onSave({currentResource:resourceSet[$scope.currentStep],currentStep:$scope.currentStep});
	                    	if(result) {
	                    		if(typeof result === 'boolean') {
		                    		_nextStep();
		                    	}else if(typeof result.done === 'function') {
		                    		result.done(function(reResult) {
		                    			console.log("stepNav: generate code done, result: %s", reResult);
		                    			if(reResult) {
		                    				safeApply(_nextStep);
		                    			}
		                    		});
		                    	}
	                    	}
	                    }
	                }
	                
	               	function safeApply (fn) {
	                    var phase = $scope.$root.$$phase;
	                    if (phase == '$apply' || phase == '$digest') {
	                        if (fn && (typeof(fn) === 'function')) {
	                            fn();
	                        }
	                    } else {
	                    	$scope.$apply(fn);
	                    }
	                }
	                
	                function _nextStep () {
	                	var resourceSet = $scope.resourceSet
	                	$scope.currentStep = $scope.currentStep + 1;
                    	if($scope.currentStep >= $scope.enableStep) {
                    	    $scope.enableStep = $scope.currentStep + 1;
                    	}
                    	$scope.showResource(resourceSet[$scope.currentStep], $scope.currentStep);
	                }

	                // 上一步
	                $scope.preStep = function () {
	                    var resourceSet = $scope.resourceSet
	                    if($scope.isFirst()) {
	                        return;
	                    }
	                    $scope.currentStep = $scope.currentStep - 1;
	                    $scope.showResource(resourceSet[$scope.currentStep], $scope.currentStep);
	                }

	                // 初始化时调用
	                $scope.showResource($scope.resourceSet[$scope.currentStep], $scope.currentStep);

	                $scope.isFirst = function () {
	                	return $scope.currentStep == 0;
	                }

	                $scope.isLast = function () {
	                	return $scope.currentStep == $scope.resourceSet.length - 1;
	                }
	            }   
	        };
    });
	</script>
</body>
</html>
