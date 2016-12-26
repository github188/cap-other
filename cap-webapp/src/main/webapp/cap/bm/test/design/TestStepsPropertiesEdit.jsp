<%
    /**********************************************************************
	 * 测试步骤页面
	 * 2016-7-11 诸焕辉 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='testStepsPropertiesEdit'>
	<head>
		<meta charset="UTF-8">
		<title>测试步骤页面</title>
		<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/bm/test/css/comtop.cap.test.css"/>
		<top:link href="/cap/bm/test/design/css/table-layout.css"></top:link>
		<top:link href="/cap/bm/test/design/css/pageDesigner.css"></top:link>
		<top:link href="/cap/bm/test/css/icons.css"></top:link>
		<style type="text/css">
			.step-table { 
				background-color:#ffffff;
				border:solid #ddd; 
				border-width:1px 0px 0px 1px;
				display: none;
			}
			.step-table tr {
				height: 35px;
			}
			.step-table th {
				font-weight: bold;
			}
			.step-table td,th {
				border:solid #ddd; 
				border-width:0px 1px 1px 0px;
				vertical-align: middle;
			}
			.cap-area {
				background:#f4f4f4;
			}
			.step-area {
				padding: 7px; 
				margin: 8px 0 0  0;
			}
			.step-title {
				font-size: 12pt;
				font-weight: bold;
    			line-height: 22px;
				text-align: left;
			}
			.step-title .step-name {
				margin-left: 25px;
				margin-bottom: 2px;
				font-size: 100%
			}
			.step-title .icon-img {
				float: left;
				width: 20px;
				height: 20px;
				text-align: center;
   				background-size: 100% 100% !important;
   				position: relative;
   				top: 1px;
			}
			.cui-tab-content {
				overflow: hidden; 
				padding: 5px; 
				box-sizing: border-box;
			}
			.error_border_color {
				border: 1px solid red!important;
				background-color: '#f0f0f0';
			}
			/**7-20新增**/
			.teststep-head{				 
				height: 42px;
				background:#337ab7;
				font-size: 16px;
				line-height: 42px;
				color: #fff;
				padding-left: 10px;
				border-radius:5px 5px 0  0;
				box-sizing: border-box;
				cursor: pointer;
				font-weight: bold;			 
				width: 100%;
			}
			.cap-area {
				box-shadow:none;
				border: 1px dotted rgba(0, 0, 0, 0.3)
			}
			#teststep{
				overflow: hidden;
			    border: 1px solid #d3d3d3;
			    background: #fefefe;		 
			    -moz-border-radius: 5px;
			    -webkit-border-radius: 5px;
			    border-radius: 5px;
			    -moz-box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
			    -webkit-box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);					 
			}
			.teststep-table{
				margin:0 5px;				 
				overflow: auto;
			}
			.step-title{
				cursor: pointer;
			}
			.cui-tab ul.cui-tab-nav li{
				background: none;
				margin-right: 0;
				font-size: 15px;
				border-right:3px solid #ccc;				 
				transform:skew(-40deg,0deg);

			}
			.cui-tab ul.cui-tab-nav li:nth-child(2){
				border: none;
			}
			.cui-tab .cui-tab-nav .cui-active {
			    background-color: #fff;
			    color:#333;
			    font-size: 16px;
			    font-weight: bold;
            }
            .cui-tab ul.cui-tab-nav li span{
            	display: block;
            	transform:skew(40deg,0deg);
            }
             .cui_textarea_box .textarea_textarea{
            	font-size: 13px;
            	padding:8px!important;
            	box-sizing: border-box;
            }
            .cIndicator {
            	float: left; 
            	left:0; 
            	top:0; 
            	width:100%; 
            	height:100%;
            	display:table;
            	margin: 0 auto;
            	background-color: rgba(0, 0, 0, 0.4); 
				filter: alpha(opacity=40);
            	font-size:14px;
            	vertical-align:middle; 
            	z-index: 9999; 
            	display: none;
            }
            .loading {
            	position: relative;
            	top:50%;
            	margin: 0 auto; 
            	vertical-align:middle; 
            	text-align: center; 
            	font-size: 14px;
            }
            #scriptText{
            	overflow: hidden;
            	box-sizing: border-box; 
			    box-shadow: 0 2px 2px rgba(0,0,0,.1) inset;
			    -moz-transition: border .3s linear 0s;
			    -webkit-transition: border .3s linear 0s;
			    -o-transition: border .3s linear 0s;
			    transition: border .3s linear 0s;
			    border: 1px solid #ccc;
			    border-radius: 3.01px;
			    padding: 4px 5px;
			    vertical-align: top;
			    font-size: 0;
			    line-height: normal;
			    position: relative;
			    background: #f5f5f5!important
            }
            #code{
            	font-size: 13px;
            	color:#bb8844;
            	line-height:1.7;
            	padding:5px 10px; 
            }
            #code .line{
            	zoom:1;
            	margin-left:20px; 
            	width：100%;
            	word-break:break-all;
            	word-wrap:break-word;
            }
            #code .line:after{
             	display: table;
             	content: '';
             	clear: both;
            }
            #code .line span{
                margin-right:25px;
                display:block;
                float:left
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
		<top:script src="/cap/dwr/interface/TestCaseFacade.js"></top:script>
		
	</head>
	<body ng-controller="testStepsPropertiesEditCtrl" data-ng-init="ready()">
		<div class="tableIframe">
			<div class="cui-tab"> 
		    	<div class="cui-tab-content">                    
		            <div id="teststep" class="item" style="overflow: hidden; left: 0px; height:100%;box-sizing:border-box;" ng-show="active=='step'">
		            <!--全部展开-->
		                <div class="teststep-head"><span>全部展开</span><img style="position:relative;top:2px;left: 10px;" src="Images/list_arrow.png"></div>
		                <div class="teststep-table">
			                <div ng-repeat="step in testCaseVO.steps track by step.id" ng-click="findParentSteps(this)" class="cap-area step-area" id="{{step.id}}">
								<div class="step-title" id="step-panel-{{step.id}}" ng-click="expandStepPanelToggleEvent(this)">
									<div class="icon-img {{step.reference.icon != null && step.reference.icon != ''? step.reference.icon : 'icon-cog-wheel-silhouette'}}"></div>
									<div class="icon-expand icon-img icon-thin-arrowheads-pointing-down" style="width: 12px;float: right;margin-right: 10px;"></div>
									<div class="step-name">{{step.description}}</div>									
								</div>
								<table class="step-table" border="1" style="width: 100%" ng-switch="step.type">
					                <thead>
					                    <tr>
					                        <th ng-if="step.type=='DYNAMIC'">
					                    		<input type="checkbox" name="allStepCheckBox4{{step.id}}" ng-model="step.allCheckBox" ng-change="allCheckBoxCheck(step.reference.steps, step.allCheckBox)">
					                        </th>
					                        <th ng-if="step.type=='DYNAMIC' || step.type=='FIXED'" nowrap="nowrap">
					                    		序号
					                        </th>
					                        <th nowrap="nowrap">步骤名称</th>
					                        <th nowrap="nowrap">步骤说明</th>
					                        <th nowrap="nowrap">参数名称</th>
					                        <th nowrap="nowrap">参数值</th>
					                        <th ng-if="step.type=='DYNAMIC'" nowrap="nowrap">
					                        	<span class="cui-icon" title="上移步骤" style="font-size:12pt;color:#545454;cursor:pointer;" ng-click="up(step)">&#xf062;</span>&nbsp;&nbsp;
			                                	<span class="cui-icon" title="下移步骤" style="font-size:12pt;color:#545454;cursor:pointer;" ng-click="down(step)">&#xf063;</span>&nbsp;&nbsp;
					                        	<span class="cui-icon" title="批量删除步骤" style="font-size:14pt;color:rgb(255, 68, 0);cursor:pointer;" ng-click="batchDeleteStepReference(step)">&#xf00d;</span>
					                        </th>
					                    </tr>
					                </thead>
					                <!-- 组合步骤（动态） -->
			                        <tbody ng-switch-when="DYNAMIC" ng-repeat="subStep in step.reference.steps track by $index" ng-switch="subStep.arguments != null">
			                            <!-- 步骤有参数 -->
			                            <tr ng-switch-when="true" ng-repeat="arg in subStep.arguments">
			                            	<td ng-if="$index == 0" rowspan="{{(subStep.arguments.length + 1)}}" style="text-align:center; width: 1.5%;">
			                                    <input type="checkbox" name="{{'step'+($index + 1)}}" ng-model="subStep.check" ng-change="checkBoxCheck($parent.step)">
			                                </td>
			                                <td ng-if="$index == 0" rowspan="{{(subStep.arguments.length + 1)}}" style="text-align:center; width: 2%">
					                    		{{$parent.$parent.$index + 1}}
					                        </td>
			                            	<td ng-if="$index == 0" style="text-align:center; width: 12%; {{subStep.containCustomizedStep ? 'color: red':''}}" rowspan="{{(subStep.arguments.length + 1)}}">
			                                    {{subStep.name}}
			                                </td>
			                                <td ng-if="$index == 0" style="text-align:center; width: 12%; {{subStep.containCustomizedStep ? 'color: red':''}}" rowspan="{{(subStep.arguments.length + 1)}}">
			                                    {{subStep.description}}
			                                </td>
			                                <td style="text-align:center; width: 12%">
			                                    {{arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name}}
			                                </td>
			                                <td style="text-align:center; width: 25%; padding: 0 2px;">
			                                    <span cui_clickinput ng-model="arg.value" name="{{arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name}}" on_iconclick="openSelectedTestDictionaryWin" width="100%" editable="true" stepId="{{step.id}}" subStepId="{{subStep.id}}" subStepIndex="{{$parent.$index}}" subName="{{subStep.name}}"></span>
			                                </td>
			                                <td ng-if="$index == 0" style="text-align:center; width: 5%;" rowspan="{{(subStep.arguments.length + 1)}}">
			                                	<span class="cui-icon" title="删除步骤" style="font-size:14pt;color:rgb(255, 68, 0);cursor:pointer;" ng-click="deleteStepReference($parent.step, $parent.$parent.$index)">&#xf00d;</span>
			                                </td>
			                            </tr>
			                            <!-- 步骤没参数 -->
			                            <tr ng-switch-default>
			                            	<td style="text-align:center; width: 1.5%">
			                            		<input type="checkbox" name="{{'step'+($index + 1)}}" ng-model="subStep.check" ng-change="checkBoxCheck($parent.step)">
			                                </td>
			                                <td style="text-align:center; width: 2%">
					                    		{{$index + 1}}
					                        </td>
			                            	<td style="text-align:center; width: 12%;{{subStep.containCustomizedStep ? 'color: red':''}}">
			                                    {{subStep.name}}
			                                </td>
			                                <td style="text-align:center; width: 12%;{{subStep.containCustomizedStep ? 'color: red':''}}">
			                                    {{subStep.description}}
			                                </td>
			                                <td style="text-align:center; width: 12%">
			                                </td>
			                                <td style="text-align:center; width: 25%">
			                                </td>
			                                <td style="text-align:center; width: 5%;">
			                                </td>
			                            </tr>
			                       </tbody>
			                       <!-- 组合步骤（固定） -->
			                        <tbody ng-switch-when="FIXED" ng-repeat="subStep in step.reference.steps track by $index" ng-switch="subStep.arguments != null">
			                            <!-- 步骤有参数 -->
			                            <tr ng-switch-when="true" ng-repeat="arg in subStep.arguments">
			                            	<td ng-if="$index == 0" rowspan="{{(subStep.arguments.length + 1)}}" style="text-align:center; width: 2%">
					                    		{{$parent.$parent.$index + 1}}
					                        </td>
			                            	<td ng-if="$index == 0" style="text-align:center; width: 14%;{{subStep.containCustomizedStep ? 'color: red':''}}" rowspan="{{(subStep.arguments.length + 1)}}">
			                                    {{subStep.name}}
			                                </td>
			                                <td ng-if="$index == 0" style="text-align:center; width: 14%;{{subStep.containCustomizedStep ? 'color: red':''}}" rowspan="{{(subStep.arguments.length + 1)}}">
			                                    {{subStep.description}}
			                                </td>
			                                <td style="text-align:center; width: 15%">
			                                    {{arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name}}
			                                </td>
			                                <td style="text-align:center; width: 25%; padding: 0 2px;">
			                                    <span cui_clickinput ng-model="arg.value" name="{{arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name}}" on_iconclick="openSelectedTestDictionaryWin" width="100%" editable="true" stepId="{{step.id}}" subStepId="{{subStep.id}}" subStepIndex="{{$parent.$index}}" subName="{{subStep.name}}"></span>
			                                </td>
			                            </tr>
			                            <!-- 步骤没参数 -->
			                            <tr ng-switch-default>
			                            	<td style="text-align:center; width: 2%">
					                    		{{$index + 1}}
					                        </td>
			                            	<td style="text-align:center; width: 14%;{{subStep.containCustomizedStep ? 'color: red':''}}">
			                                    {{subStep.name}}
			                                </td>
			                                <td style="text-align:center; width: 14%;{{subStep.containCustomizedStep ? 'color: red':''}}">
			                                    {{subStep.description}}
			                                </td>
			                                <td style="text-align:center; width: 15%">
			                                </td>
			                                <td style="text-align:center; width: 25%">
			                                </td>
			                            </tr>
			                       </tbody>
								   <!-- 基本步骤 -->
			                       <tbody ng-switch-default ng-switch="step.reference.arguments != null && step.reference.arguments.length > 0">
			                            <tr ng-switch-when="true" ng-repeat="arg in step.reference.arguments">
			                            	<td ng-if="$index == 0" style="text-align:center; width: 15%;{{step.containCustomizedStep ? 'color: red':''}}" rowspan="{{(step.reference.arguments.length + 1)}}">
			                                    {{step.name}}
			                                </td>
			                                <td ng-if="$index == 0" style="text-align:center; width: 15%;{{step.containCustomizedStep ? 'color: red':''}}" rowspan="{{(step.reference.arguments.length + 1)}}">
			                                    {{step.description}}
			                                </td>
			                                <td style="text-align:center; width: 15%">
			                                    {{arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name}}
			                                </td>
			                                <td style="text-align:center; width: 25%; padding: 0 2px;">
			                                    <cui_basic_step ng-step="step" ng-arguments="arg"></cui_basic_step>
			                                </td>
			                            </tr>
			                            <tr ng-switch-default>
			                            	<td style="text-align:center; width: 15%;{{step.containCustomizedStep ? 'color: red':''}}">
			                                    {{step.name}}
			                                </td>
			                                <td style="text-align:center; width: 15%;{{step.containCustomizedStep ? 'color: red':''}}">
			                                    {{step.description}}
			                                </td>
			                                <td style="text-align:center; width: 15%">
			                                </td>
			                                <td style="text-align:center; width: 25%">
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
				            </div>
			            </div>
		            </div>                                                    
		            <div class="item" style="overflow: hidden; height:100%;" ng-show="active=='script'">
		            	 <div id="scriptText">
	                        <div class="script-box" style='background: #fff;height: 100%;overflow: auto'>
	                        	<div id="code"></div>
	                        </div>		                	
		                </div>	
		            	<div class="cIndicator">
		            		<div class="loading"><img src="Images/loading.gif" style="position: relative; top:3px; border:none;"/><span>加载中，请稍等...</span></div>
		            	</div>
		            </div>          
		     	</div>  
		     	<div class="cui-tab-head" style="margin: 0px;">        
		            <ul class="cui-tab-nav">                        
	                 	<li title="测试步骤" ng-class="{'step':'cui-active'}[active]" style="width:65px" ng-click="showPanel('step')">  
	                    	<span class="cui-tab-title">测试步骤</span>           
	                 	</li>                      
	                 	<li title="测试脚本" ng-class="{'script':'cui-active'}[active]" style="width:65px" ng-click="showPanel('script')">                
	                    	<span class="cui-tab-title">测试脚本</span>         
	                 	</li>                    
		            </ul>        
		     	</div>  
			</div>
		</div> 
		
		<!-- 基本步骤属性表单模版  -->
		<script id="stepBasicStepTmpl" type="text/template">
			<!---
				var ctrl = this.arg.ctrl;
				var options = ctrl.optionMap;
				if(options && !$.isEmptyObject(options)){
					var attr = "";
					if(this.arg.required){
						attr = ' validate="[{\'type\':\'required\', \'rule\':{\'m\': \''+ this.arg.description +'不能为空\'}}]" ';
					}
					for(var key in options){
						var val = options[key];
						if(key == 'id' || key === 'name'){
							val = this.stepId + '_' + val;
						}
						attr += key + '="' + val + '" ';
					}
				}
			-->
			<span +-directiveUI[ctrl.type]-+ ng-model="ngArguments.value" +-attr-+ width="100%">
		</script>
		<script type="text/javascript"> 
			var modelId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		    var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		    var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
		    var pageSession = new cap.PageStorage(modelId);
		    var testCaseVO = pageSession.get("testCase");
		    var toolsData = pageSession.get("toolsData");
		    var triggerDataChangePage = 'currPage';//哪个页面触发数据变更（默认值是本页面）
		    window.addEventListener("message", messageHandle, false);
			/**
			 * 接收消息回调方法
			 * @param e 回调数据
			 */
			function messageHandle(e) {
		    	if(e.data.type === 'pageDesigner'){
		    		triggerDataChangePage = 'parentPage';
		    		//重排步骤集顺序时,steps值不变，但顺序变了，所以要执行脏值检查，让view重新布局
		    		if(e.data.reSort){
		    			triggerDataChangePage = 'currPage';
		    		} else {
			    		setStepArgReferenceVariables(scope.testCaseVO.steps);
		    		}
		    		cap.digestValue(scope);
		    	} 
		    }
		    
		    var scope = {};
			var compile = {};
			//基本步骤指令
			CUI2AngularJS.directive('cuiBasicStep', ['$interpolate','$compile', function ($interpolate, $compile) {
			    return {
			    	restrict: 'AE',
			        transclude: true,
			        scope: {
			        	ngStep: '=',
			        	ngArguments: '='
			        },
			        link: function (scope, element, attrs, controller) {
			        	scope.data = {};
			        	var reference = scope.ngStep != null ? scope.ngStep.reference : null;
			        	if(reference && reference.type){
				        	var stepDefinition = getTestStepDefinitionsByModelId(toolsData, reference.type, 'BASIC');
				        	if(stepDefinition && stepDefinition.arguments && stepDefinition.arguments.length > 0){
					        	var arg = _.find(stepDefinition.arguments, function(n){return (n.ctrl != null && n.ctrl.optionMap != null && n.ctrl.optionMap.name === scope.ngArguments.name) || n.name === scope.ngArguments.name});
					        	if(arg){
						        	var ctrl = arg.ctrl;
									var options = ctrl.optionMap;
									if(ctrl.script && $.trim(ctrl.script) != ''){
										try{
								    		$("<script type='text/javascript'>" + ctrl.script + "<\/script>").appendTo("head");  //动态加载	
								    	}catch(e){
								    		console.log("function不规范：\n" + ctrl.script);
								    	}
									}
									//初始化绑定对象
									var argName = arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name;
									scope.data[argName] = scope.ngArguments.value != null ? scope.ngArguments.value : scope.ngArguments.defaultValue;
						        	//构建模版以及渲染动态节点
									var jct = new jCT($('#stepBasicStepTmpl').html());
									jct.arg = arg;
									jct.stepId = scope.ngStep.id;
									var domStr = jct.Build().GetView();
									jQuery(element).append(domStr);
			   		            	$compile(element.contents())(scope);
					        	}
				        	}
			        	}
			        }
			    };
			}]);
			
			angular.module('testStepsPropertiesEdit', ["cui"]).controller('testStepsPropertiesEditCtrl', function ($scope, $compile, $timeout) {
				//默认显示属性tab标签
		    	$scope.active='step';
				$scope.testCaseVO=testCaseVO;
				$scope.stepArgReferenceMap={};
				
				$scope.ready=function(){
					var initheight=$(window).height()-$(".tableIframe .cui-tab-head").height()-11;
					$(".tableIframe .cui-tab-content").height(initheight);
					$("#scriptText").height(initheight-10);
					$(window).resize(function() {
						var height = $(window).height()-$(".tableIframe .cui-tab-head").height()-11;
						$(".tableIframe .cui-tab-content").height(height);
						$("#scriptText").height(height-10);
						/**resize表格高度**/
						$(".tableIframe .cui-tab-content .teststep-table").height(height - 50);
					});
		    		comtop.UI.scan();
		    		scope = $scope;
		    		compile = $compile;
		    		//设置步骤参数引用变量
					$timeout(function(){setStepArgReferenceVariables($scope.testCaseVO.steps);}, 0);
			    }
		    	
				//监控全选checkbox，如果选择则联动选中列表所有数据
		    	$scope.allCheckBoxCheck=function(steps, isCheck){
		    		if(steps != null){
		    			for(var i=0, len=steps.length; i<len; i++){
			    			if(isCheck){
			    				steps[i].check=true;
				    		}else{
				    			steps[i].check=false;
				    		}
			    		}	
		    		}
		    	}
				
		    	//监控选中，如果列表所有行都被选中则选中allCheckBox
		    	$scope.checkBoxCheck=function(currStep){
		    		if(currStep.reference.steps != null){
		    			var steps = currStep.reference.steps;
		    			var checkCount=0;
		    			var allCount=steps.length;
			    		for(var i=0; i<allCount; i++){
			    			if(steps[i].check){
			    				checkCount++;
				    		}
			    		}
			    		currStep.allCheckBox = checkCount == allCount;
		    		}
		    	}
				
		    	//批量删除子步骤
		    	$scope.batchDeleteStepReference=function(currStep){
		    		var steps = currStep.reference.steps;
		    		if(steps != null){
			    		var notDelStepReference = [];
			    		var delStepReferenceName = [];
			    		for(var i=0, len=steps.length; i<len; i++){
			    			if(!steps[i].check){
			    				notDelStepReference.push(steps[i]);
			    			} else {
			    				delStepReferenceName.push(steps[i].description);
			    			}
			    		}
			    		if(notDelStepReference.length == 0){
			    			$scope.delLastStepReferenceBefore(currStep);
			    		} else if(notDelStepReference.length != steps.length){
			    			cui.confirm("确定要删除【" + delStepReferenceName.join("、") + "】步骤吗？", {
			    				onYes : function() {
			    					currStep.reference.steps = notDelStepReference;
			    					currStep.containCustomizedStep = _.find(notDelStepReference, {containCustomizedStep: true}) != null;
			    					currStep.reference.containCustomizedStep = currStep.containCustomizedStep;
			    					customizedStep(currStep.id, currStep.containCustomizedStep, window.parent);
					    			resetRenderDynamic(currStep.id, currStep.reference.steps, window.parent, true);
					    			setStepArgReferenceMap(currStep);
						    		cap.digestValue(scope);
			    				}
			    			});
			    		} else {
			    			cui.alert("请选择要删除的步骤.");
			    		}
		    		}
		    	}
				
		    	//删除子步骤
		    	$scope.deleteStepReference=function(currStep, index){
		    		if(currStep.reference.steps.length == 1){
		    			$scope.delLastStepReferenceBefore(currStep);
		    		} else {
		    			cui.confirm("确定要删除【" + currStep.reference.steps[index].description + "】步骤吗？", {
		    				onYes : function() {
		    					currStep.reference.steps.splice(index, 1); 
		    					currStep.containCustomizedStep = _.find(currStep.reference.steps, {containCustomizedStep: true}) != null;
		    					currStep.reference.containCustomizedStep = currStep.containCustomizedStep;
		    					customizedStep(currStep.id, currStep.containCustomizedStep, window.parent);
					    		resetRenderDynamic(currStep.id, currStep.reference.steps, window.parent, true);
					    		setStepArgReferenceMap(currStep);
					    		cap.digestValue(scope);
		    				}
		    			});
		    		}
		    	}
		    	
		    	//删除动态步骤最后一个子步骤之前
		    	$scope.delLastStepReferenceBefore=function(currStep){
		    		cui.confirm("如果动态步骤没了子步骤，则会把当前步骤一并删除，确定要删除吗？", {
	    				onYes : function() {
	    					delete scope.stepArgReferenceMap[currStep.id];
				    		window.parent.Config.DelDrapDiv($("#"+currStep.id)[0]);
	    				}
	    			});
		    	}
		    	
		    	//切换面板
		    	$scope.showPanel=function(flag){
		    		$scope.active = flag;
		    		if(flag === 'script'){
		    			$(".cIndicator").show();
		    			//切换到目标界面在加载数据，（避免页面还没加载完，tab项还没切换过去）
		    			$timeout($scope.refreshScript, 0);
		    		} else {
		    			$(".cIndicator").hide();
		    		}
			    }
		    	
		    	//监听data数据
				$scope.$watch("testCaseVO.steps", function(newValue, oldValue){
					if(newValue != oldValue){
						if(triggerDataChangePage === 'currPage'){
							//步骤参数引用值处理（值针对组合控件）
							$scope.stepArgReferenceValueHandler($scope.testCaseVO.steps);
							//给父页面（绘制页面）发送通知
							$scope.postMessageToParent($scope.testCaseVO);
						} else {
							triggerDataChangePage = 'currPage';
							$timeout(function(){scrolltoTop(window.parent.scope.data.currSelectedStepId)}, 0);
						}
					} 
		    	}, true);
		    	
				//子步骤展开
		    	$scope.expandStepPanelToggleEvent=function(currStepScope){
					$("#step-panel-"+currStepScope.step.id).next().toggle();
	               	$("#step-panel-"+currStepScope.step.id).find(".icon-expand").toggleClass("rotate180");
		    	}

		    	//选中当前节点
		    	$scope.findParentSteps=function(currStepScope){
		    		window.parent.postMessage({action: "selectedStep", stepId: currStepScope.step.id}, "*");
		    	}
		    	
				//步骤参数引用值处理
				$scope.stepArgReferenceValueHandler=function(steps){
					for(var i in steps){
						var step = steps[i];
						if(step.type === 'BASIC'){
							continue;
						}
						var stepArgReferMap = $scope.stepArgReferenceMap[step.id];
						if(stepArgReferMap == null || $.isEmptyObject(stepArgReferMap)){
							continue;
						}
						for(var j in step.reference.arguments){
							var arg = step.reference.arguments[j];
							var argName = arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name;
							if(stepArgReferMap[argName] != null){
								//多对一情况判断，多个子步骤中的参数引用同一个主步骤的参数变量
								var otherReferObj = [];
								var hasUpdate = false;
								for(var k in stepArgReferMap[argName]){
									var stepRefer = stepArgReferMap[argName][k];
									var argRefer = _.find(step.reference.steps[stepRefer.index].arguments, function(n){return (n.ctrl != null && n.ctrl.optionMap != null && n.ctrl.optionMap.name === stepRefer.name) || n.name === stepRefer.name});
									if(arg.value != argRefer.value && !hasUpdate){
										arg.value = argRefer.value;
										hasUpdate = true;
									} else {
										otherReferObj.push(argRefer);
									}
								}
								if(otherReferObj.length > 0){
									for(var f in otherReferObj){
										otherReferObj[f].value = arg.value;
									}
								}
							}
						}
					}
		    	}
		    	
		    	//给父页面（绘制页面）发送通知
				$scope.postMessageToParent=function(testCaseVO){
		    		window.parent.postMessage({action: "stepsDataChange", data: testCaseVO}, "*");
		    	}
		    	
		    	//刷新测试脚本
		    	$scope.refreshScript=function(){
		    		var scriptText = "";
		    		var valid = window.parent.parent.validateAll();
		    		if(!valid.result){
		    			scriptText = "测试用例信息不完整,无法获取测试脚本！\n校验失败项如下：\n  " + valid.message.replace(/&diams;/g, '').replace(/<br\/>/g, '\n  ');
		    			$("#scriptText").addClass("error_border_color");
		    			$("#scriptText #code").css("color","red");
			   		} else {
			   			$("#scriptText").removeClass("error_border_color");	
			   			$("#scriptText #code").css("color","#bb8844")
			   			scriptText = getTestcaseScript();
			   		}
			   		var str =scriptText 
				    var arr = str.split("\n");
				    var resources = "";  
				    for (var i = 0; i < arr.length; i++) {  
				        var arr1 = arr[i].split("\n"); 
				        for (var j = 0; j < arr1.length; j++) {  
				            if (jQuery.trim(arr1[j]) != "") { 
				                resources+="<div class='line'>"+arr1[j]+"</div>"; 
				            }  
				        }  
				    }   
				    $("#code").html(resources) 
					for (var i = 0; i< document.getElementById('code').childNodes.length; i++){
				        p = document.getElementById('code').childNodes[i];
				        var strp = p.innerHTML 
					    var arrp = strp.split(" ");
					    var Presources = "";  
					    for (var j = 0; j < arrp.length; j++) {  
				            if (jQuery.trim(arrp[j]) != "") { 
				                Presources+="<span>"+arrp[j]+"</span>";  
				            }
				        } 
				         $(p).empty().append(Presources); 
					};	   		 
					var firstLetter = $("#code .line").find("span:first");
					var lastLetter = $("#code .line").find("span:last");
					var eachLetter = $("#code .line").find("span");
					var eachLine = $("#code .line")
					/**工具箱字典***/
					var listArray = [];
					var basicArray = eachStep(toolsData.BASIC);
					var dynamicArray = eachStep(toolsData.DYNAMIC);
					var fixedArray = eachStep(toolsData.FIXED);
					listArray = listArray.concat(fixedArray,dynamicArray,basicArray);
				    /**颜色样式处理**/
					for(var i=0;i<firstLetter.length;i++){
						var dataFirst = firstLetter[i];
						var htmlFirst = dataFirst.innerHTML;
                        if (listArray.indexOf(htmlFirst)>=0){
                           $(dataFirst).css("color",'#990000')
                        }else if(htmlFirst.indexOf("#")>=0){
                      	   $(dataFirst).css({"color":'#000'});
                        }else if(htmlFirst.indexOf("[")==0 && htmlFirst.indexOf("]")>=0 && listArray.indexOf($(dataFirst).next().html())>=0){
                      	    $(dataFirst).css({"color":'#000',"font-weight":'bold'});
                      	   	$(dataFirst).next().css("color",'#990000')
                        }else if(listArray.indexOf(htmlFirst)<0 && htmlFirst.indexOf("#")<0 && listArray.indexOf($(dataFirst).next().html())>=0){
                        	  $(dataFirst).css({'color':'#000','font-weight':'bold'})
                        	  $(dataFirst).next().css({'color':'#990000'})
                        }else if(listArray.indexOf(htmlFirst)<0 && htmlFirst.indexOf("#")<0 && listArray.indexOf($(dataFirst).next().html())<0){
                        	 $(dataFirst).closest("div").find("span").css("color","#888")
                        }                      
					}

					for(var i=0;i<lastLetter.length;i++){
						var dataLast = lastLetter[i];
						var htmlLast = dataLast.innerHTML;
					    if(dataLast.innerHTML.indexOf(testCaseVO.name)==0){
					   	   $(dataLast).css({"font-size":'13px','color':'#000'});
					   	   $(dataLast).closest("div").prevAll().css({"margin-left":'5px','color':'#888'});
					   	   $(dataLast).closest("div").css({"margin-left":'5px',"font-weight":"bold"});
					   	   $(dataLast).closest("div").prev().css({"margin-top":'10px'});
					   	   $(dataLast).closest("div").prev().find('span').css({"margin-right":'20px'});
					    }
                        if(htmlLast.indexOf("#")>=0){
                      	   $(dataLast).css("color",'#000')
                        }
                        if($("#scriptText").hasClass('error_border_color') && htmlLast.indexOf("测试用例信息不完整,无法获取测试脚本！")==0 || htmlLast.indexOf("校验失败项如下：")==0){
                       	     $(dataLast).css({"margin-left":'-15px','color':"#000"});
                       	     $(dataLast).closest("div").nextAll().find("span").css("color",'red')
                        }
					}
					for(var i=0;i<eachLetter.length;i++){
                        var dataEach = eachLetter[i];
						var htmlEach = dataEach.innerHTML;
                        if(htmlEach.indexOf('\${')==0){
                       	   $(dataEach).css("color",'#008080')
                        }
                        if($(dataEach).closest("div").height()>22){
                        	$(dataEach).nextAll().css('margin-left','15px');
                        }      
					}
					$(".cIndicator").hide();
			    }
		    	
		    	//上移子步骤（动态步骤）
				$scope.up=function(currStep){
		    		var referenceSteps = currStep.reference.steps;
		    		if(referenceSteps.length > 0 && referenceSteps[0].check){
		    			return;
		    		}
		    		var checkIndexs = [];
		    		_.forEach(referenceSteps, function (step, key) {
		    			if(step.check){
		    				checkIndexs.push(key);
		    			}
		    		});
		    		_.forEach(checkIndexs, function (value, key) {
		    			var currIndex = 0;
						for(var i in referenceSteps){
							if(i == value){
								currIndex = i;
								break;
							}
						}
						if(currIndex > 0){
							var currStep = referenceSteps[value];
							var frontStep = referenceSteps[currIndex - 1];
							referenceSteps.splice(currIndex - 1, 2, currStep);
							referenceSteps.splice(currIndex, 0, frontStep);
						} 
		    		});
		    		if(checkIndexs.length > 0){
						setStepArgReferenceMap(currStep);
						resetRenderDynamic(currStep.id, referenceSteps, window.parent, false);
		    		} else {
		    			cui.alert("请选择要重新排序的步骤.");
		    		}
				}
				
				//下移子步骤（动态步骤）
				$scope.down=function(currStep){
		    		var referenceSteps = currStep.reference.steps;
		    		var len = referenceSteps.length;
		    		if(len > 0 && referenceSteps[len-1].check){
		    			return;
		    		}
		    		var checkIndexs = [];
		    		_.forEach(referenceSteps, function (step, key) {
		    			if(step.check){
		    				checkIndexs.push(key);
		    			}
		    		});
		    		checkIndexs = checkIndexs.reverse();
		    		_.forEach(checkIndexs, function (value, key) {
		    			var currIndex = 0;
						for(var i in referenceSteps){
							if(i == value){
								currIndex = i;
								break;
							}
						}
						if(currIndex < len-1){
							var currStep = referenceSteps[value];
							var nextStep = referenceSteps[parseInt(currIndex) + 1];
							referenceSteps.splice(parseInt(currIndex) + 1, 1, currStep);
							referenceSteps.splice(currIndex, 1, nextStep);
						}
		    		});
		    		if(checkIndexs.length > 0){
						setStepArgReferenceMap(currStep);
						resetRenderDynamic(currStep.id, referenceSteps, window.parent, false);
		    		} else {
		    			cui.alert("请选择要重新排序的步骤.");
		    		}
				}
			});

            /**
			 * 根据name查找节点
			 * @param stepType 步骤类型
			 */
			function eachStep(stepType){
				var stepArray=[],stepList = [];
				var stepName = [];
				for(var i=0;i<stepType.length;i++){
		             stepArray[i] = stepType[i].steps;             
		             for(var j=0;j<stepArray[i].length;j++){
		             	 stepName.push(stepArray[i][j].name);
		             }           
				}
				return stepName;
			}

			/**
			 * 设置步骤参数引用变量
			 * @param steps 步骤集合（testCaseVO.steps）
			 */
			function setStepArgReferenceVariables(steps){
				scope.stepArgReferenceMap = {};
	    		_.forEach(steps != null ? steps : [], function (step, key) {
					setStepArgReferenceMap(step);
				});
	    	}
			
			/**
			 * 给stepArgReferenceMap赋值  [格式：{主步骤Id：stepId，主步骤参数变量：[{index：子步骤数组下标，name：子步骤参数变量}]}]
			 * @param step 步骤
			 */
			function setStepArgReferenceMap(step){
    			scope.stepArgReferenceMap[step.id] = {};
				var subSteps = step.reference.steps != null ? step.reference.steps : [];
				_.forEach(subSteps, function (subStep, subKey) {
					var arguments = subStep.arguments != null ? subStep.arguments : [];
					_.forEach(arguments, function (arg, argKey) {
						var argName = arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null ? arg.ctrl.optionMap.name : arg.name;
						if(arg.reference){
							if(scope.stepArgReferenceMap[step.id][arg.reference] == null){
								scope.stepArgReferenceMap[step.id][arg.reference] = [];
							} 
							scope.stepArgReferenceMap[step.id][arg.reference].push({index: subKey, name: argName});
						} else {//扫描具有相同名称的变量
							var argReference = _.find(step.reference.arguments, function(n){return (n.ctrl != null && n.ctrl.optionMap != null && n.ctrl.optionMap.name === argName) || n.name === argName});
							if(argReference){
								if(scope.stepArgReferenceMap[step.id][argName] == null){
									scope.stepArgReferenceMap[step.id][argName] = [];
								} 
								scope.stepArgReferenceMap[step.id][argName].push({index: subKey, name: argName});
							}
						}
					})
				});
			}
			
			/**
			 * 打开选择数据字典页面
			 * @param event
			 * @param self
			 */
			function openSelectedTestDictionaryWin(event, self){
				var width=800; //窗口宽度
			    var height=600; //窗口高度
			    var top=(window.screen.availHeight-height)/2;
			    var left=(window.screen.availWidth-width)/2;
			    selectedTestDictionaryCallback_wrap = _.bind(selectedTestDictionaryCallback, {stepId: self.options.stepid, subStepId: self.options.substepid, subStepIndex: self.options.substepindex, subName: self.options.subname, argName: self.options.name});
			    var url='../preference/SelectTestDictionary.jsp?callbackMethod=selectedTestDictionaryCallback_wrap&sourceModuleId=' + packageId +'&code='+self.$input.val();
			    var winName = "selectTestDictionary";
			    var winAttrs = "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left;
	          	//判断是否打开 (在新窗口打开页面（浏览器中只打开一次）)
	            if (typeof objWin === 'undefined' || objWin.closed) { 
	            	objWin = window.open(url, winName, winAttrs); 
	            } else { 
	            	objWin.location.replace(url); 
	            } 
	            objWin.focus(); 
			}
			
			/**
			 * 选择数据字典回调函数
			 * @param data 回调数据
			 */
			function selectedTestDictionaryCallback(data){
				var step = _.find(scope.testCaseVO.steps, {id: this.stepId});
				if(step){
					var subStep = step.reference.steps[this.subStepIndex];
					var argName = this.argName;
					if(subStep){
						var arg = _.find(subStep.arguments, function(n){return (n.ctrl != null && n.ctrl.optionMap != null && n.ctrl.optionMap.name === argName) || n.name === argName});
						arg.value = data != null && data != '' ? ("\${" + data.dictionaryCode + "}") : '';
						triggerDataChangePage = 'currPage';
						cap.digestValue(scope);
					}
				}
			}
			
			//获取测试脚本
		   	function getTestcaseScript(){
		   		var ret = '';
		   		if(!saveTestCase()){
		   			return;
		   		}
		   		dwr.TOPEngine.setAsync(false);
				TestCaseFacade.previewTestcaseScript(testCaseVO.modelId, function(result){
					ret = result;
				});
				dwr.TOPEngine.setAsync(true);
				return ret;
		   	}
			
		   	/**
			 * 从工具箱拖拽步骤，测试步骤页面定位到当前的步骤节点上
			 * @param id 步骤Id
			 */
			function scrolltoTop(id){
		   		if(id && id != ""){
				   	var container = $(".teststep-table");  
				   	var scrollTo = $("#"+id);				   
				   	$(scrollTo).find(".step-table").show();
	               	$(scrollTo).siblings().find(".step-table").hide();
                   	$(scrollTo).find(".step-title .icon-expand").addClass("rotate180")
                   	$(scrollTo).siblings().find(".step-title .icon-expand").removeClass("rotate180");
               		$("step-table").each(function(){
	                	if($("step-table").is(":visible")){
	                		$(".teststep-head").find("span").html("全部折叠");
	                	}else{
	                		$(".teststep-head").find("span").html("展开");
	                	}
               		});
	                container.scrollTop( 
				    	scrollTo.offset().top - container.offset().top + container.scrollTop() - 8
				  	);
		   		}
			}
		   	
		    //统一校验
			function validateAll() {
		    	var result = true;
				_.forEach(testCaseVO.steps, function (step, key) {
					var line = _.find(testCaseVO.lines, function(obj){
						return obj.form === step.id || obj.to === step.id;
					});
					if(line == null){
						result = false;
					}
				});
				return result;
			}
		</script>
		<!--7-21new 折叠功能-->
		<script type="text/javascript">
			$(function(){
				$(".teststep-table").height($("#teststep").height()-$(".teststep-head").height()-5);		 
				$(".teststep-head").click(function(e){
					$(this).find("img").toggleClass("rotate180");					
					if($(this).find("img").hasClass("rotate180")){
						$(this).find("span").html("全部折叠");
						$(".teststep-table table").show();
						$(".step-title .icon-expand").addClass("rotate180");
					}else{
						$(this).find("span").html("全部展开");
						$(".teststep-table table").hide();
						$(".step-title .icon-expand").removeClass("rotate180")						 
					}
				});			 	
			})
		</script>
	</body>
</html>