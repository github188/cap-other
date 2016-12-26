<%
    /**********************************************************************
	 * 步骤属性页面
	 * 2016-7-7 诸焕辉 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='stepPropertiesEdit'>
	<head>
		<meta charset="UTF-8">
		<title>步骤属性页面</title>
		<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/bm/test/design/css/table-layout.css"></top:link>
		<top:link href="/cap/bm/test/design/css/pageDesigner.css"></top:link>
		<style type="text/css">
			.step_propss_form{
				padding: 8px 5px;
			}
			.cap-table {
			  	width: 100%;
			}
			.cap-table td {
			  	padding: 0 0 8px 0;
			  	word-break: break-all; 
				line-height：5pt;
			}
			ul.cui-tab-nav {
				padding: 7px 0 0 7px;
				border-bottom: 1px solid #aaa;
  			}
  			ul.cui-tab-nav li {
  				-moz-border-radius: 5px 5px 0 0;
     			-webkit-border-radius: 5px 5px 0 0; 
    			border-radius: 5px 5px 0 0;
			    color:#fff;
				display: inline-block;
				font-weight: bold;
				padding: 0 10px;
				height: 32px;
				line-height: 32px;
				box-sizing: border-box;
				font-size: 14px;
				background: #4585e5;
			}
			ul.cui-tab-nav li.active {
				background: #4585e5;
				color: #fff;
			}
			ul.cui-tab-nav li.help {
				float: right;
				font-size: 12px;
				font-weight: normal;
				text-decoration: underline;
				padding: 0 5px;
				background: #fff;
			}
			.updateTip, .syncTip{
				width: 226px;
			    border:1px solid #ccc;
				padding:5px;
				margin-bottom:5px;
				position:absolute;
				-moz-border-radius:5px;
			    -webkit-border-radius:5px;
			    border-radius:5px;
			    background-color: #F4FFEF;
			    display: none;
			}
			.updateTip:before,.updateTip:after,.syncTip:before,.syncTip:after{ 
				content:'';
				width:0;
				height:0;
				position:absolute;
			}
			.updateTip:before,.syncTip:before{
				top:-8px;
				border-bottom:8px solid #ccc;
				border-left:8px solid transparent;
				border-right:8px solid transparent;
			}
			.updateTip:before{
			    left:150px;
			}
			.syncTip:before{
			    left:205px;
			}
			.updateTip:after,.syncTip:after{
				border-bottom:8px solid #fff;
				border-left:6px solid transparent;
				border-right:6px solid transparent;
			}
			.updateTip:after{
			    left:152px;
			}
			.syncTip:after{
			    left:207px;
			}
		</style>
		<top:script src="/cap/bm/test/design/js/jquery.min.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/comtop.ui.all.js"></top:script>
		<top:script src="/cap/bm/test/js/comtop.cap.js"></top:script>
		<top:script src="/cap/bm/test/js/jct.js"></top:script>
		<top:script src="/cap/bm/test/js/angular.js"></top:script>
    	<top:script src="/cap/bm/test/js/comtop.cap.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/cui.utils.js"></top:script>
		<top:script src="/cap/bm/test/js/cui2angularjs.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/cui.extend.dictionary.js"></top:script>
		<top:script src="/cap/bm/test/js/lodash.min.js"></top:script>
		<top:script src="/cap/bm/test/design/js/pageDesign.js"></top:script>
		<top:script src="/cap/dwr/engine.js"></top:script>
		<top:script src="/cap/dwr/util.js"></top:script>
		<top:script src="/cap/dwr/interface/InvokeFacade.js"></top:script>
		<top:script src="/cap/dwr/interface/TestCaseFacade.js"></top:script>
	</head>
	<body ng-controller="stepPropertiesEditCtrl" data-ng-init="ready()">
		<ul class="cui-tab-nav">                        
           	<li title="测试步骤">参数设置</li>  
           	<li class="help" ng-click="openHelpDoc()">
				<span class="cui-icon" title="帮助说明" style="font-size:16pt; color:#4585e5; cursor:pointer;">&#xf059;</span>
			</li>                    
        </ul>       
		<div id="main" class="step_propss_form"></div>
		
		<script type="text/javascript"> 
			var modelId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		    var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		    var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
		    var pageSession = new cap.PageStorage(modelId);
		    var testCaseVO = pageSession.get("testCase");
		    var toolsData = pageSession.get("toolsData");
		    var triggerDataChangePage = 'currPage';//哪个页面触发数据变更（默认值是本页面）
			var scope = {};
			var compile = {};
			var timeout = {};
			angular.module('stepPropertiesEdit', ["cui"]).controller('stepPropertiesEditCtrl', function ($scope, $compile, $timeout) {
				$scope.data = {};// 绑定对象
				$scope.stepDefinition = {};// 步骤定义控件对象（来至于步骤定义元数据）
				$scope.argumentsType = {};// 属性类型
				$scope.step = {};// 步骤定义数据对象（来至于testCase元数据中的steps中的步骤）
				$scope.scanMap = {};// 存储扫描编辑页面需要的map参数
				$scope.stepArgReferenceMap = {};
				
				$scope.ready=function(){
		    		scope = $scope;
		    		compile = $compile;
		    		timeout = $timeout;
		    		comtop.UI.scan();
			    }
				
				//监听data数据
				$scope.$watch("data", function(newValue, oldValue){
					if(newValue != oldValue){
						if(triggerDataChangePage === 'currPage'){
							var data = jQuery.extend(true, {}, newValue);
							//子步骤（只针对动态步骤）
			    			var hasRenderDynamic = false;
							if($scope.scanMap && !$.isEmptyObject($scope.scanMap)){
				    			for(var key in $scope.scanMap){
				    				if(newValue[key] != oldValue[key]){
				    					hasRenderDynamic = true;
				    					break;
				    				}
				    			}
				    			if(hasRenderDynamic){
				    				var dynamicStep = execScanEditPage();
				    				$scope.step.reference.steps = dynamicStep != null ? dynamicStep.steps : null;
				    				$scope.step.containCustomizedStep = dynamicStep != null && dynamicStep.containCustomizedStep;
				    				$scope.step.reference.containCustomizedStep = $scope.step.containCustomizedStep;
				    				setStepArgReferenceVariables($scope.step);
				    			}
				    		}
							$scope.wrapperDataPostMessageToParent(data, newValue.description != oldValue.description, hasRenderDynamic);
						} 
					}
		    	}, true);
				
				//步骤参数引用值处理
				$scope.stepArgReferenceValueHandler=function(data){
					_.forEach($scope.stepArgReferenceMap, function (subSteps, parentArgKey) {
						_.forEach(subSteps, function (step, subStepArgKey) {
							var argRefer = _.find($scope.step.reference.steps[step.index].arguments, {name: step.name});
							if(argRefer){
								argRefer.value = data[parentArgKey];
							}
						});
					});
		    	}
				
				//发送通知给父页面（绘制页面）
				$scope.postMessageToParent=function(data, hasStepTitleName, hasRenderDynamic){
					var reference = $scope.step.reference;
					$scope.step.description = data.description;
					_.forEach(reference.arguments, function (arg, key) {
						var argName = arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name;
						arg.value = data[argName];
					});
		    		window.parent.postMessage({action: "stepDataChange", step: $scope.step, hasStepTitleName: hasStepTitleName, hasRenderDynamic: hasRenderDynamic}, "*");
		    	}
				
				//过滤数据
				$scope.filterData=function(data){
					for(var key in data){
	    				if(data[key] === null || data[key] === '' ){
	    					delete data[key];
	    				}
		    		}
		    	}
				
				//转换数据值类型（STRING、NUMBER、TIME、BOOL）
				$scope.transformValueType=function(data){
					for(var key in data){
	    				if($scope.argumentsType[key]){
	    					if($scope.argumentsType[key] === "BOOL" || $scope.argumentsType[key] === "NUMBER"){
	    						data[key] = eval(data[key]);
		    				} 
	    				}
		    		}
		    	}
				//打开步骤帮助说明(未实现)
				$scope.openHelpDoc=function(){
					var url = "./StepHelpManual.jsp?modelId=" + $scope.stepDefinition.modelId;
					var winName = "stepHelpManual";
					var win = window.open("", winName);
					//判断是否打开 (在新窗口打开页面（浏览器中只打开一次）)
		            if (win.location.href === "about:blank") {//窗口不存在
		            	win = window.open(url, winName); 
		            } else {//窗口以已经存在了
		            	win.location.replace(url); 
		            } 
		            win.focus(); 
				}
				
				//给父页面发送消息
				$scope.wrapperDataPostMessageToParent=function(data, hasStepTitleName, hasRenderDynamic){
    				//步骤参数引用值处理（值针对组合控件）
					$scope.stepArgReferenceValueHandler(data);
					//注释原因：如果当前步骤有属性值为空，其他属性输入值会失去焦点bug
					//$scope.filterData(data);
					$scope.transformValueType(data);
		    		$scope.postMessageToParent(data, hasStepTitleName, hasRenderDynamic);
				}
				
				//重置扫描编辑页面（更新功能）
				$scope.resetExecScanEditPage=function(){
					var dynamicStep = execScanEditPage();
    				$scope.step.reference.steps = dynamicStep != null ? dynamicStep.steps : null;
    				$scope.step.containCustomizedStep = dynamicStep != null && dynamicStep.containCustomizedStep;
    				$scope.step.reference.containCustomizedStep = $scope.step.containCustomizedStep;
    				setStepArgReferenceVariables($scope.step);
    				$scope.wrapperDataPostMessageToParent(jQuery.extend(true, {}, $scope.data), false, true);
		    		cui.message('更新成功！', 'success');
				}
				//动态步骤同步查找（先保存，再同步）
				$scope.dynamicSyncOpertion=function(){
					var valid = window.parent.parent.validateAll();
					if(!valid.result){
			   			window.parent.parent.cui.error("同步失败，原因是当前测试用例校验不通过！<br/>校验结果如下：<br/>" + valid.message); 
			   			return;
			   		}
					if(!saveTestCase()){
						cui.message('测试用例保存失败，无法进行同步操作！', 'error');
						return;
					}
					var invokeData = {clazz: $scope.stepDefinition.scan, modelId: $scope.stepDefinition.modelId};
					var datas = jQuery.extend(true, {}, scope.scanMap);
					datas.testCaseModelId = testCaseVO.modelId;
					datas.currentStepId = $scope.step.id;
					invokeData.datas = datas;
					dwr.TOPEngine.setAsync(false);
					InvokeFacade.invoke(invokeData, function(_data){
			    		if(_data){
			    			$scope.step.containCustomizedStep = _data.containCustomizedStep;
			    			$scope.step.reference.containCustomizedStep = $scope.step.containCustomizedStep;
			    			$scope.step.reference.steps = _data.steps;
			    			setStepArgReferenceVariables($scope.step);
			    			$scope.wrapperDataPostMessageToParent(jQuery.extend(true, {}, $scope.data), false, true);
				    		cui.message('同步成功！', 'success');
			    		} else {
			    			cui.message('同步失败！', 'error');
			    		}
				   	});
			    	dwr.TOPEngine.setAsync(true);
				}
				
				//动态步骤（更新或同步按钮提示语显示）
				$scope.showTip=function(flag){
					$("."+flag).show();
				}
				//动态步骤（更新或同步按钮提示语隐藏）
				$scope.hideTip=function(flag){
					$("."+flag).hide();
				}
			});
			
			window.addEventListener("message", messageHandle, false);
			/**
			 * 接收消息回调方法
			 * @param e 回调数据
			 */
			function messageHandle(e) {
		    	if(e.data.type === 'pageDesigner'){
		    		triggerDataChangePage = 'parentPage';
		    		initStepProps(e.data.id);
		    	} 
		    }
			
			/**
			 * 接收消息回调方法
			 * @param id 步骤节点Id
			 */
			function initStepProps(stepId){
				$('#main').empty();
				scope.step = {};
				scope.data = {};
				scope.stepDefinition = {};
				scope.scanMap = {};
				scope.stepArgReferenceMap = {};
				cap.digestValue(scope);
				if(stepId == null || stepId == ''){
					return;
				}
				scope.step = _.find(testCaseVO.steps, {id: stepId});
				//测试数据
				//scope.step = jQuery.extend(true, {}, testCaseVO.steps[3]);
				createDom(scope.step);
			}
			
			//创建步骤属性节点表单
			function createDom(step){
				//获取步骤定义控件
				scope.stepDefinition = getTestStepDefinitionsByModelId(toolsData, step.reference.type, step.type);
				//设置步骤参数对应的dom元素节点模版
				setArgDomElementTmpl(scope.stepDefinition);
				//设置步骤参数引用变量
				setStepArgReferenceVariables(step);
				//设置scope.data数据
				setData4Scope(step);
				var jct = new jCT($('#stepPropsTmpl').html());
				jct.stepDefinition = scope.stepDefinition;
				$('#main').html(jct.Build().GetView()); 
				compile($('#main').contents())(scope);
				cap.digestValue(scope);
				timeout(function(){triggerDataChangePage = 'currPage'}, 0);
			}
			
			/**
			 * 设置步骤参数对应的dom元素节点模版
			 * @param stepDefinition 步骤模型对象
			 */
			function setArgDomElementTmpl(stepDefinition){
				//存储参数类型
				scope.argumentsType = {};
				if(stepDefinition.arguments && stepDefinition.arguments.length > 0){
					for(var i=0, len=stepDefinition.arguments.length; i<len; i++){
						var arg = stepDefinition.arguments[i];
						var ctrl = arg.ctrl;
						var options = ctrl.optionMap;
						var argName = options.name != null ? options.name : arg.name;
						scope.argumentsType[argName] = arg.valueType;
						if(options && !$.isEmptyObject(options)){
							if(ctrl.script && $.trim(ctrl.script) != ''){
								try{
						    		$("<script type='text/javascript'>" + ctrl.script + "<\/script>").appendTo("head");  //动态加载	
						    	}catch(e){
						    		console.log("function不规范：\n" + ctrl.script);
						    	}
							}
							var attr = "";
							if(arg.required){
								arg.labelDom = '<font color="red" style="position:relative;top:3px;margin-right:2px;">*</font>' + argName;
								attr = ' validate="[{\'type\':\'required\', \'rule\':{\'m\': \''+ arg.description +'不能为空\'}}]" ';
							} else {
								arg.labelDom = argName;
							}
							for(var key in options){
								attr += key + '="' + options[key] + '" ';
							}
							arg.uiDom = '<span ' + directiveUI[ctrl.type] + ' ng-model="data.'+ argName + '" ' + attr+ ' width="145">';	
						}
					}
				}
			}
			
			//设置步骤参数引用变量（key：使用者名称、value：被应用者名称）
			function setStepArgReferenceVariables(step){
				//格式：{主步骤参数变量：[{index：子步骤数组下标，name：子步骤参数变量}]}
				scope.stepArgReferenceMap = {};
				var subSteps = step.reference.steps != null ? step.reference.steps : [];
				_.forEach(subSteps, function (subStep, subKey) {
					var arguments = subStep.arguments != null ? subStep.arguments : [];
					_.forEach(arguments, function (arg, argKey) {
						var hasName4OptionMap = arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null;
						var argName = hasName4OptionMap ? arg.ctrl.optionMap.name : arg.name;
						if(arg.reference){ //处理有reference属性的引用变量（即：不同变量名称）
							if(scope.stepArgReferenceMap[arg.reference] == null){
								scope.stepArgReferenceMap[arg.reference] = [];
							}
							scope.stepArgReferenceMap[arg.reference].push({index: subKey, name: argName});
						} else {//扫描具有相同名称的变量
							var argReference = _.find(step.reference.arguments, function(n){return (hasName4OptionMap && n.ctrl.optionMap.name === argName) || n.name === argName});
							if(argReference){
								if(scope.stepArgReferenceMap[argName] == null){
									scope.stepArgReferenceMap[argName] = [];
								}
								scope.stepArgReferenceMap[argName].push({index: subKey, name: argName});
							}
						}
					});
				});
		    }
			
			//设置scope.data数据
			function setData4Scope(step){
				var reference = step.reference;
				scope.data = {name: step.name, description: step.description};
				var arguments = reference.arguments != null ? reference.arguments : [];
				scope.scanMap = {};
				for(var i=0, len=arguments.length; i<len; i++){
					var arg = arguments[i];
					var argName = arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name;
					scope.data[argName] = arg.value;
					scope.scanMap[argName] = arg.value;
				}
				scope.scanMap = scope.stepDefinition.scan != null ? scope.scanMap : null;
			}
			
			/**
			 * 通用的回调函数
			 * @param modelId 页面元数据模型id
			 */
			function commonCallback(modelId, argName){
				scope.data[argName] = modelId;
				cap.digestValue(scope);
			}
			
			/**
			 * 扫描编辑页面
			 * @param model
			 */
			function execScanEditPage(){
				var ret = null;
				var hasRequest = true;
				for(var key in scope.scanMap){
					scope.scanMap[key] = scope.data[key];
					if(scope.data[key] == null || scope.data[key] == ""){
						hasRequest = false;
					}
				}
				//参数值未填写完整，则不请求后台api接口
				if(hasRequest){
					var invokeData = {clazz: scope.stepDefinition.scan, modelId: scope.stepDefinition.modelId, datas: scope.scanMap};
					dwr.TOPEngine.setAsync(false);
					InvokeFacade.invoke(invokeData, function(_data){
			    		ret = _data;
				   	});
			    	dwr.TOPEngine.setAsync(true);
				}
		    	return ret;
			}
			
		</script>
		<!-- 步骤属性表单模版  -->
		<script id="stepPropsTmpl" type="text/template">
			<table class="cap-table">
				<!---
					if(this.stepDefinition.name){
				-->
				<tr><td width="100px">步骤名称：</td><td><span cui_input ng-model="data.name" value='+-this.stepDefinition.name-+' readonly='true' width='145'></span></td></tr>
				<!---
					}
				-->
				<!---
					if(this.stepDefinition.description){
				-->
			    <tr><td>步骤说明：</td><td><span cui_textarea ng-model="data.description" value='+-this.stepDefinition.description-+' width='145'></span></td></tr>
				<!---
					}
				-->
				<!---
					if(this.stepDefinition.arguments && this.stepDefinition.arguments.length > 0){
						for(var i=0, len=this.stepDefinition.arguments.length; i<len; i++){
							var arg = this.stepDefinition.arguments[i];
				-->
			    <tr><td>+-arg.labelDom-+：</td><td>+-arg.uiDom-+</td></tr>
				<!---
						}
					}
				-->
				<!---
					if(this.stepDefinition.group === 'dynamic'){
				-->
			    <tr><td colspan="2" align="right"><span cui_button class="dynamic-btn" label="更新" ng-click="resetExecScanEditPage()" ng-mouseover="showTip('updateTip')" ng-mouseleave="hideTip('updateTip')"></span>&nbsp;&nbsp;<span cui_button class="dynamic-btn" label="同步" ng-click="dynamicSyncOpertion()" ng-mouseover="showTip('syncTip')" ng-mouseleave="hideTip('syncTip')"></span></td></tr>
				<tr><td colspan="2" align="left">
					<p class="updateTip">
						将按照最新的界面元数据，重新生成该动态步骤，以前设置（修改）的数据将会被覆盖。
					</p>
					<p class="syncTip">
						将按照最新的界面元数据，完善该动态步骤，以前设置（修改）的数据将不会被覆盖。
					</p>
				<!---
					}
				-->
	   		</table>
		</script>
	</body>
</html>