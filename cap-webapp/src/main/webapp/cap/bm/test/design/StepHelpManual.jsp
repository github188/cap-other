<%
    /**********************************************************************
	 * 
	 * 2016-7-26 诸焕辉 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='stepHelpManual'>
	<head>
		<meta charset="UTF-8">
		<title>步骤帮助手册</title>
		<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/bm/test/design/css/table-layout.css"></top:link>
		<top:link href="/cap/bm/test/design/css/pageDesigner.css"></top:link>
		<top:link href="/cap/bm/test/design/css/icons.css"></top:link>
		<style type="text/css">
			.title {
				padding-left: 5px;
			    text-align: left;
			    color: #666;
			}
			.center-container{
				padding: 5px;
			}
			.w_lzemay {
				cursor:pointer;
			}
			.selected {
				color: red;
			}
			.step-table { 
				border:solid #ddd; 
				border-width:1px 0px 0px 1px;
				background: #ffffff;
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
			.title-group{
				color: #000000;
    			padding: 2px 5px;
    			border-left: solid 6px #f0f0f0;
    			background: #ffffff;
    			font-size: 14;
				font-weight: bold;
			}
			.form-area{
				padding: 5px 5px 5px 10px; 
				background: #f0f0f0;
			}
			
			.center-container ul {
				list-style-type: disc;
			 	list-style-position: inside;
			}
			
			.left-container .list ,.left-container .list .unfold{
			    display: block;
			}
			.left-menu {
				overflow: auto;
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
		<top:script src="/cap/bm/test/js/lodash.min.js"></top:script>
		<top:script src="/cap/dwr/engine.js"></top:script>
		<top:script src="/cap/dwr/util.js"></top:script>
		<top:script src="/cap/dwr/interface/StepFacade.js"></top:script>
	</head>
	<body style="background-color:#f5f5f5;">
		<div uitype="Borderlayout" id="border" is_root="true" gap="10px 10px 10px 10px">
			<div position="top" class="top-container" height="45px">
		        <div class="title"><div class="cui-icon" title="帮助说明" style="font-size:22pt; color:#666;">&#xf0eb;&nbsp;帮助中心</div></div>                                     
		    </div>   
			<div position="left"class="left-container" width="240" show_expand_icon="true" collapsable="true" style="backgrounp-color:rgba(204, 204, 204, 0.5)">
		      	<div id="leftTools" ng-controller="leftCtrl" data-ng-init="ready()">
		          	<div class="title u-search">
		             	<span id="treesearch" uitype="ClickInput" enterable='true' editable='true' icon='search' width='220' on_iconclick="clickQuery" on_keydown="keyDownQuery" style="margin: 10px 0 0 10px;" emptytext="请输入步骤名称关键字查询"></span>
		          	</div> 
		          	<div class="left-menu" id="left-menu">
		              	<div class='type component fix' id="component">
		                	<div class="title">
		                   		<p>组合步骤</p>
		                   		<img src="Images/list_arrow.png">
		                	</div>
		                	<ul class="list fix"></ul>                             
		              	</div>
		              	<div class='type basic fix' id="basic">
		                	<div class="title">
		                  		<p>基本步骤</p>
		                   		<img src="Images/list_arrow.png">
		                	</div>
		                	<ul class="list fix"></ul>
		              	</div>                  
		          	</div>
		          	<div class="list fix" id="fastQueryList" style="display: none;"></div>                 
		      	</div>
		    </div>
		    <div position="center" class="center-container" ng-controller="centerCtrl" data-ng-init="ready()" ng-switch="selectedStep.stepType">
		    	<div class="step-title" ng-if="selectedStep.name != null">
		    		<div class="title-group">步骤中文名称</div>
		    		<div class="form-area">【{{selectedStep.name}}】</div>
		    	</div>
		    	<div class="step-title">
		    		<div class="title-group">步骤英文名称</div>
		    		<div class="form-area">{{selectedStep.modelName}}</div>
		    	</div>
		    	<div class="step-libraries">
		    		<div class="title-group">引用库</div>
		    		<ul class="form-area">                        
	                 	<li ng-repeat="lib in selectedStep.libraries">  
	                    	{{lib}}          
	                 	</li>                      
		            </ul>        
		    	</div>
		    	<div class="step-resources">
		    		<div>
		    			<div class="title-group">引用资源</div>
		    		</div>
		    		<ul class="form-area">                        
	                 	<li ng-repeat="res in selectedStep.resources">  
	                    	{{res}}          
	                 	</li>                      
		            </ul>        
		    	</div>
		    	<div class="step-arg">
		    		<div class="title-group">参数列表</div>
		    		<div class="form-area" style="padding-left: 5px;">
				        <table class="step-table" border="1" style="width: 100%">
			                <thead>
			                    <tr>
			                        <th>参数名称</th>
			                        <th>参数类型</th>
			                        <th>参数默认值</th>
			                        <th>是否必填</th>
			                        <th>控件</th>
			                        <th>参数说明</th>
			                    </tr>
			                </thead>
		                    <tbody>
		                        <tr ng-repeat="arg in selectedStep.arguments">
		                        	<td style="text-align:center; width: 20%;">
		                                {{arg.name}}
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                                {{arg.valueType}}
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                                {{arg.defaultValue}}
		                            </td>
		                            <td style="text-align:center; width: 10%;">
		                                {{arg.required == true ? "是" : "否"}}
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                                {{arg.ctrl.type}}
		                            </td>
		                            <td style="text-align:center; width: 25%;">
		                                {{arg.description}}
		                            </td>
		                        </tr>
		                   </tbody>
		                </table>  
	                </div>
                </div>   
                <!-- 固定步骤引用基本步骤集列表 -->
                <div ng-switch-when="FIXED" class="step-reference">
		    		<div class="title-group">引用基本步骤列表</div>
		    		<div class="form-area" style="padding-left: 5px;">
				        <table ng-repeat="childStep in selectedStep.steps" ng-switch="childStep.arguments != null" class="step-table" border="1" style="width: 100%; margin-bottom: 5px;">
			                <thead>
			                    <tr>
			                        <th>步骤名称</th>
			                        <th>参数名称</th>
			                        <th>参数类型</th>
			                        <th>参数默认值</th>
			                        <th>引用参数名称</th>
			                        <th>控件</th>
			                        <th>参数说明</th>
			                    </tr>
			                </thead>
		                    <tbody>
		                        <!-- 步骤有参数 -->
		                        <tr ng-switch-when="true" ng-repeat="arg in childStep.arguments">
		                        	<td ng-if="$index == 0" rowspan="{{(childStep.arguments.length + 1)}}" style="text-align:center; width: 15%;">
		                                {{childStep.name}}
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                                {{arg.name}}
		                            </td>
		                            <td style="text-align:center; width: 10%;">
		                                {{arg.valueType != null ? arg.valueType : 'STRING'}}
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                                {{arg.defaultValue}}
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                                {{arg.reference}}
		                            </td>
		                            <td style="text-align:center; width: 10%;">
		                                ClickInput
		                            </td>
		                            <td style="text-align:center; width: 20%;">
		                                {{arg.description}}
		                            </td>
		                        </tr>
		                        <!-- 步骤没参数 -->
	                            <tr ng-switch-default>
	                            	<td style="text-align:center; width: 15%;">
		                                {{childStep.name}}
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                            </td>
		                            <td style="text-align:center; width: 10%;">
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                            </td>
		                            <td style="text-align:center; width: 15%;">
		                            </td>
		                            <td style="text-align:center; width: 10%;">
		                            </td>
		                            <td style="text-align:center; width: 20%;">
		                            </td>
	                            </tr>
		                   </tbody>
		                </table>  
	                </div>
                </div>
                <!-- 动态步骤扫描器-->
                <div ng-switch-when="DYNAMIC" class="step-reference">
		    		<div class="title-group">扫描类</div>
		    		<div class="form-area">{{selectedStep.scan}}</div>
                </div>
                <div class="step-macro">
		    		<div>
		    			<div class="title-group">脚本模版</div>
		    		</div>
		    		<div class="form-area">{{selectedStep.macro}}</div>
		    	</div>     
		    	<div class="step-help">
		    		<div>
		    			<div class="title-group">帮助</div>
		    		</div>
		    		<div class="form-area">{{selectedStep.help}}</div>
		    	</div>   
		    	<div class="step-description">
		    		<div>
		    			<div class="title-group">备注</div>
		    		</div>
		    		<div class="form-area">{{selectedStep.description}}</div>
		    	</div>                               
		    </div>                          
		</div>
		<!--模板-->
		<script id="basicTemplate" type="text/template">
			<!---
				for(var i in this.data){
			-->
			<div class="fold">
	        	<div class="icon-img icon-fold icon-arrowhead-pointing-to-the-right"></div>
	       		<div class="+-this.data[i].icon-+ icon-img"></div>
	       		<div>+-this.data[i].name-+</div>
	    	</div>  
			<ul class="unfold">
			<!---
	     		for(var j in this.data[i].steps){ 
			-->   
	      		<li ng-click="selectedEvent('+-this.data[i].steps[j].stepType-+', '+-this.data[i].steps[j].modelId-+')" class="w_lzemay lzemay_wMode +-this.data[i].steps[j].stepType-+" modelid="+-this.data[i].steps[j].modelId-+" type="+-this.data[i].steps[j].stepType-+">
	         		<div class="ep_lzemay"></div>                        
	         		<div class="icon-img +-this.data[i].steps[j].icon-+"></div>
	         		<span ng-class="{'+-this.data[i].steps[j].modelId-+':'selected'}[selectedStep.modelId]">+-this.data[i].steps[j].name-+</span>        
	      		</li>      
	     	<!---
	     		} 
			-->  
	    	</ul>   
	    	<!---
				}	 
			-->
		</script>
		<script id="componentTemplate" type="text/template"> 
			<!---
				for(var i in this.data){
			-->
	    	<div class="fold">
	       		<div class="icon-img icon-fold icon-arrowhead-pointing-to-the-right"></div>
	       		<div class="+-this.data[i].icon-+ icon-img"></div>
	       		<div>+-this.data[i].name-+</div>
	    	</div>   
	    	<ul class="unfold">
	     	<!---
	     		for(var j in this.data[i].steps){ 
			-->  
	      		<li ng-click="selectedEvent('+-this.data[i].steps[j].stepType-+', '+-this.data[i].steps[j].modelId-+')" class="w_lzemay lzemay_wMode +-this.data[i].steps[j].stepType-+" modelid="+-this.data[i].steps[j].modelId-+" type="+-this.data[i].steps[j].stepType-+">
	         		<div class="ep_lzemay"></div>                        
	         		<div class="icon-img +-this.data[i].steps[j].icon-+"></div>
	         		<span ng-class="{'+-this.data[i].steps[j].modelId-+':'selected'}[selectedStep.modelId]">+-this.data[i].steps[j].name-+</span>
	         		<div class="sub_options" style="display: none">
	             		<div class="mt15 fix">
	             		<!---
	     					for(var k in this.data[i].steps[j].steps){ 
						-->                
	                 		<div class="icon-img +-this.data[i].steps[j].steps[k].icon-+"></div>
	                 		<div class=" icon-img icon-long-arrow-pointing-to-the-right"></div>             
	              		<!---
							}	 
						-->	
	             		</div>                
	         		</div>      
	      		</li>      
	     		<!---
					}	 
				-->	
	    	</ul> 
			<!---
				}	 
			-->	
		</script>
		
		<script type="text/javascript">
			var modelId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
			var toolsData = {};
			var scope = {};
			initPageData();
			
    		//初始页面数据
			function initPageData(){
				initToolsData();
	    		initLeftNav(toolsData);
			}
    		
    		//获取所有步骤类型及分组(工具箱数据)
		    function initToolsData(){
		    	dwr.TOPEngine.setAsync(false);
		    	StepFacade.queryALLStepsWithGroup(function(_data){
		    		toolsData = _data;
			   	});
		    	dwr.TOPEngine.setAsync(true);
		    }
			
			//初始化左侧工具箱数据
		    function initLeftNav(data){
		    	if(data.BASIC){
		        	var jct4BasicTemplate = new jCT($('#basicTemplate').html());
		        	jct4BasicTemplate.data = data.BASIC;
		        	$(".basic .list").append(jct4BasicTemplate.Build().GetView());
	        	}
	        	if(data.FIXED){
	        		var jct4Fixed = new jCT($('#componentTemplate').html());
		        	jct4Fixed.data = data.FIXED;
		        	$(".component .list").append(jct4Fixed.Build().GetView());
	        	}
	        	if(data.DYNAMIC){
	        		var jct4Dynamic = new jCT($('#componentTemplate').html());
		        	jct4Dynamic.data = data.DYNAMIC;
		        	$(".component .list").append(jct4Dynamic.Build().GetView());
	        	}
		    }
			
		    /**
			 * 根据测试步骤modelId定位到当前的步骤节点上
			 * @param id 步骤Id
			 */
			function scrolltoTop(scrollTo){
		    	var container = $(".left-menu");
		    	container.scrollTop( 
			    	scrollTo.offset().top - container.offset().top + container.scrollTop() - 8
			  	);
			}
			
		    /**
		     * 在步骤分组中，根据模型Id获取测试步骤定义
		     * 
		     * @param toolsData
		     *            工具箱
		     * @param type
		     *            步骤类型（BASIC、FIXED、DYNAMIC）
		     * @param modelId
		     *            模型Id
		     */
		    function getTestStepDefinitions4StepGroup(groups, modelId) {
		    	var ret = null;
		    	for ( var i in groups) {
		    		var stepDefinition = _.find(groups[i].steps, {
		    			modelId : modelId
		    		});
		    		if (stepDefinition) {
		    			ret = stepDefinition;
		    			break;
		    		}
		    	}
		    	return ret;
		    }
		    
		    var leftScope = {}, centerScope = {};
			angular.module('stepHelpManual', ["cui"]).controller('leftCtrl', function ($scope) {
				$scope.selectedStep = {};
				
				$scope.ready=function(){
					$(".left-container #leftTools").height($(window).height() - $(".top-container").height() - 22);
					$(".left-container .left-menu").height($(".left-container").height() - $("#treesearch").height()-27);
					$(window).resize(function() {
						$(".left-container #leftTools").height($(window).height() - $(".top-container").height() - 22);
						$(".left-container .left-menu").height($(".left-container #leftTools").height() - $("#treesearch").height()-27);
					});
					leftScope = $scope;
		    		comtop.UI.scan();
			    }
				
				$scope.selectedEvent=function(type, modelId){
					$scope.selectedStep = initMain(type, modelId);
					centerScope.selectedStep = $scope.selectedStep;
					cap.digestValue(centerScope);
			    }
				
			}).controller('centerCtrl', function ($scope) {
				$scope.selectedStep = leftScope.selectedStep;
				$scope.ready=function(){
					centerScope = $scope;
					if(modelId && modelId != 'undefined'){
			    		var itemNode = $(".left-menu .w_lzemay[modelid='" + modelId + "']");
			    		if(itemNode){
			    			$scope.selectedStep = initMain(itemNode.attr("type"), itemNode.attr("modelid"));
			    			leftScope.selectedStep = $scope.selectedStep;
			    			cap.digestValue(leftScope);
			    		}
			    		scrolltoTop(itemNode);
		    		}
			    }
			});
			
			/**
		     * 初始化框架中的主页面
		     * @param type 步骤类型
		     * @param modelId 步骤模型Id
		     */
			function initMain(type, modelId){
				var selectedStep = getTestStepDefinitions4StepGroup(toolsData[type], modelId);
				if(selectedStep == null){
					return {};
				}
				if(selectedStep.stepType === 'FIXED'){//固定组合步骤
        			//遍历子步骤（子步骤参数对象赋值、引用对象赋默认值）
        			_.forEach(selectedStep.steps, function(step, key) {
        				if(step.arguments == null || step.arguments.length == 0){
        					//获取子步骤参数
        					var basicStep = loadBasicStep(step.type);
        					step.arguments = basicStep.arguments;
        					setArgReferenceValue(selectedStep.arguments, step.arguments);
        				} else {
        					setArgReferenceValue(selectedStep.arguments, step.arguments);
        				}
        			});
        		} else if(type === 'DYNAMIC'){//动态组合步骤
        			_.forEach(selectedStep.steps, function(step, key) {
        				if(step.arguments == null || step.arguments.length == 0){
        					setArgReferenceValue(selectedStep.arguments, step.arguments);
        				}
        			});
        		}
				return selectedStep;
			}
			
			/**
		     * 根据基本步骤的模型Id，获取步骤信息
		     * @param modelId 步骤模型Id
		     */
	        function loadBasicStep(modelId){
	        	var ret = null;
	    		dwr.TOPEngine.setAsync(false);
		    	StepFacade.loadBasicStepById(modelId, function(_data){
		    		ret = _data;
			   	});
		    	dwr.TOPEngine.setAsync(true);
		    	return ret;
	        }
			
	        /**
		     * 设置参数引用值
		     * @param parentArgs 父步骤参数集合对象
		     * @param referenceArgs 子步骤参数集合对象
		     */
		     function setArgReferenceValue(parentArgs, referenceArgs){
	        	//引用值处理
				_.forEach(referenceArgs, function(argObj, argKey) {
					//先判断参数是否有reference属性的引用变量（即：不同变量名称），如果没用，则判断变量名称是否一致
					var refVariableName = argObj.reference != null ? argObj.reference : argObj.name;
					var referenceArg = _.find(parentArgs, {name: refVariableName});
					if(referenceArg){
						if(referenceArg.value != null && referenceArg.value != ""){
							argObj.value = referenceArg.value;
						} else {
							referenceArg.value = argObj.value;
						}
						argObj.reference = refVariableName;
					}
				});
	        }
			
		    /** 菜单* */
		    $(function() {
		    	$(".left-menu .type .title").click(function() {
		    		$(this).next().toggle();
		    		$(this).find("img").toggleClass("rotate180");
		    		if ($(this).next().is(":visible")) {
		    			$(this).next().find(".unfold").hide();
		    			$(this).next().find(".fold .icon-fold").removeClass("rotate90");
		    		}
		    	});
		    	$(".list .fold").click(function() {
		    		$(this).next().toggle();
		    		$(this).find(".icon-fold").toggleClass("rotate90");

		    	});
		    	/** 自定义扩展按钮* */
		    	var arrow = [ "&#xf0d8;", "&#xf0d7;" ];
		    	$("#c-bottom").closest(".bl_bottom").prepend(
		    			"<a class='bl_fold bl_unfold cui-icon test-icon'>" + arrow[0]
		    					+ "</a>")
		    	$(".test-icon").click(function() {
		    		$(this).toggleClass("rotate180 br-down")
		    		var bh = $("#c-bottom").attr('height');
		    		var vh = $("#testlay").height();
		    		if ($("#c-center").closest(".bl_middle").is(":visible")) {
		    			$("#c-bottom").closest(".bl_bottom").height(vh);
		    			$("#c-bottom").closest(".bl_box_bottom").height(vh);
		    			$(".cui-tab-content").height($(window).height())

		    		} else {
		    			$("#c-bottom").closest(".bl_bottom").height(bh);
		    			$("#c-bottom").closest(".bl_box_bottom").height(bh);
		    			$(".cui-tab-content").height($(window).height())
		    		}
		    		$("#c-center").closest(".bl_middle").toggle();
		    	})

		    	function resizeBottom() {
		    		var rh = $("#c-bottom").height();
		    		var ch = $("#c-center").height();
		    		$(".test-icon").click(function() {
		    			$("#c-bottom").closest(".bl_bottom").height(rh);
		    			$("#c-bottom").closest(".bl_box_bottom").height(rh);
		    		})
		    	}
		    })

		    /** 搜索功能** */
		    function clickQuery() {
		    	var keyword = cui('#treesearch').getValue();
		    	var keyword = cui("#treesearch").getValue().replace(new RegExp("/", "gm"),
		    			"//");
		    	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		    	keyword = keyword.replace(new RegExp("_", "gm"), "/_");
		    	keyword = keyword.replace(new RegExp("'", "gm"), "''");

		    	if (keyword == '') {
		    		$('#left-menu').show();
		    		$('#fastQueryList').show();
		    		if ($('#left-menu .list').is(":visible")) {
		    			$('#left-menu .list').show();
		    			$('#left-menu .list .fold').show();
		    			$('#left-menu .list li').show();
		    		}
		    	} else {
		    		$(".left-menu .w_lzemay").hide();
		    		$('#fastQueryList').html("")
		    		$(".fold").hide();
		    		fastQuery();

		    	}
		    	
		    	// 键盘回车键快速查询
		    	function keyDownQuery() {
		    		if (event.keyCode == 13) {
		    			clickQuery();
		    		}
		    	}
		    	
		    	function fastQuery() {
		    		var list = $(".left-menu .w_lzemay");		 
		    		var listArray = [];		 
		    		var basicArray = eachStep(toolsData.BASIC);
		    		var dynamicArray = eachStep(toolsData.DYNAMIC);
		    		var fixedArray = eachStep(toolsData.FIXED);
		    		listArray = listArray.concat(fixedArray,dynamicArray,basicArray);
		    		
		    		var nPos;
		    		var vResult = [];
		    		var mlist = [];
		    		for ( var i in listArray) {
		    			var sTxt = listArray[i] || '';
		    			nPos = find(keyword, sTxt);
		    			if (nPos >= 0) {
		    				vResult[vResult.length] = sTxt;
		    				mlist.push(listArray.indexOf(sTxt))
		    			}
		    		}
		    		var vLen = vResult.length;
		    		if (vLen <= 0) {
		    			$('#left-menu').hide();
		    			$('#fastQueryList').show();
		    			$("#fastQueryList")
		    					.append(
		    							"<div style='text-align:center;padding:30px;margin-left:-15px;font-size:12px;'>没有数据</div>");
		    		} else {
		    			$('#fastQueryList').hide();
		    			$('#left-menu').show();
		    			for (var d = 0; d < mlist.length; d++) {
		    				var mlist_each, listClone, testlist;
		    				mlist_each = mlist[d];
		    				testlist = list[mlist_each];
		    				$(testlist).show();
		    				$(testlist).closest(".unfold").prev().show();
		    				if ($(testlist).is(":hidden")) {
		    					if ($(testlist).closest(".list").is(":hidden")) {
		    						$(testlist).closest(".type").find(".title").trigger(
		    								'click');
		    						$(testlist).closest(".list").find(".fold").trigger(
		    								'click');
		    					} else {
		    						$(testlist).closest(".unfold").prev()
		    								.find(".icon-fold").addClass("rotate90");
		    						$(testlist).closest(".unfold").show();
		    					}
		    				}
		    			}
		    		}
		    	}
		    	/**根据name和description查找节点**/
		    	function eachStep(stepType){
		    		var stepArray=[],stepList = [];
		    		var stepName = [];
		    		for(var i=0;i<stepType.length;i++){
		                 stepArray[i] = stepType[i].steps;             
		                 for(var j=0;j<stepArray[i].length;j++){
		                 	 stepName.push(stepArray[i][j].description+stepArray[i][j].name);
		                 }           
		    		}
		    		return stepName;
		    	}
		    }
		    
		    function find(sFind, sObj) {
		    	var nSize = sFind.length;
		    	var nLen = sObj.length;
		    	var sCompare;
		    	if (nSize <= nLen) {
		    		for (var i = 0, len = nLen - nSize + 1; i <= len; i++) {
		    			sCompare = sObj.substring(i, i + nSize);
		    			if (sCompare == sFind) {
		    				return i;
		    			}
		    		}
		    	}
		    	return -1;
		    }
			
		</script>
	</body>
</html>