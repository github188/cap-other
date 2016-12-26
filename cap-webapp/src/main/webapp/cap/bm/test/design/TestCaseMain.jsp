<%
    /**********************************************************************
	 * 测试用例主页面
	 * 2016-7-1  李小芬  新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
	<head>
		<meta charset="UTF-8">
		<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/bm/test/index/image/function.png">
		<title>测试用例主页面</title>
		<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<style type="text/css">
			.cui-tab{
			  border:solid 1px #e6e6e6;
			  background:#f5f5f5
			}
			.cui-tab ul.cui-tab-nav{
			  height:40px;
			  width:100%;
			  padding:0px 0 0 0px;
			  background-color:#f5f5f5
			}
			.cui-tab ul.cui-tab-nav li{
			  padding:0 5px;
			  margin-right:5px
			}
		</style>
	
		<top:script src="/cap/bm/test/js/jquery.min.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/comtop.ui.min.js"></top:script>
		<top:script src="/cap/bm/test/js/comtop.cap.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/cui.utils.js"></top:script>
		<top:script src="/cap/bm/test/js/lodash.min.js"></top:script>
		<top:script src="/cap/dwr/engine.js"></top:script>
		<top:script src="/cap/dwr/util.js"></top:script>
		<top:script src="/cap/dwr/interface/TestCaseFacade.js"></top:script>
		<top:script src="/cap/dwr/interface/StepFacade.js"></top:script>
		<script type="text/javascript">
		   	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		  	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		   	//全路径 
		   	var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
		   	var modelPackage="";
		   	var testCaseVO;
		   	var pageStorage = null;
		   	//存放用例设计中的工具箱数据
		    var	toolsData = [];
		  	//存放所有步骤控件数据
		    var stepDefinitionsMap = {};
		    
		   	jQuery(document).ready(function(){
				jQuery("#tabBodyDiv").css("height",$(window).height()-61);
			    	$(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
			        	jQuery("#tabBodyDiv").css("height",$(window).height()-61);
			    });
		       	comtop.UI.scan();
		       	initLinkHref();
		       	initTestCaseData();
		       	initToolsData();
		       	if(testCaseVO != null){
			       	document.title = testCaseVO.name + document.title;
		       	}
		       	jumpToTab("testCaseInfo");
		       	//数据一般不会马上用到，所以可以用异步加载，从而避免页面加载时间
		       	setTimeout(getStepDefinitions, 0);
		   	});
		   	
		   	//从工具箱中所有步骤控件元数据封装到stepDefinitionsMap变量中，便于使用（ps：扁平模式）
		   	function getStepDefinitions(){
		   		_.forEach(toolsData, function (obj) {
		   			if(obj){
		   				setStepDefinitionsMap(obj);
		   			}
				});
		   	}
		   	
		   	/**
			 * 给stepDefinitionsMap变量赋值
			 * @param steps 步骤集合
			 */
		   	function setStepDefinitionsMap(steps){
		   		_.forEach(steps, function (step, key) {
   					if(step.modelType){
   						stepDefinitionsMap[step.modelId] = step;
   					} else {
   						setStepDefinitionsMap(step.steps);
   					}
   				});
		   	}
		   	
			//设置窗口tilte图标		   
		   	function initLinkHref(){
		   	   	var strHref = "${pageScope.cuiWebRoot}/cap/bm/test/index/image/dictionary.png";
			   	jQuery("link[rel='shortcut icon']").attr('href', strHref);
		   	}
			
			//初始化测试用例  
		   	function initTestCaseData(){
			   	dwr.TOPEngine.setAsync(false);
			   	TestCaseFacade.loadTestCaseAndSetMetadataById(modelId,function(testCase){
				   	testCaseVO = testCase;
				   	if(testCaseVO.steps == null){
				   		testCaseVO.steps = [];
				   		testCaseVO.lines = [];
				   	}
				   	modelPackage = testCase.modelPackage;
				   	if(pageStorage == null){
					   	pageStorage = new cap.PageStorage(modelId);
				   	}
				   	pageStorage.createPageAttribute("testCase",testCaseVO);
				   	initIframe(testCaseVO.type);
			   	});
				dwr.TOPEngine.setAsync(true);
		   	}
		   
		    //获取所有步骤类型及分组(工具箱数据)
		    function initToolsData(){
		    	dwr.TOPEngine.setAsync(false);
		    	StepFacade.queryALLStepsWithGroup(function(_data){
		    		toolsData = _data;
		    		if(pageStorage == null){
					   	pageStorage = new cap.PageStorage(modelId);
				   	}
		    		pageStorage.createPageAttribute("toolsData", _data);
			   	});
		    	dwr.TOPEngine.setAsync(true);
		    }
			
		   	//初始化iframe
		   	function initIframe(entityType){
			   	var attr="modelId="+modelId+"&packageId="+packageId+"&moduleCode="+moduleCode;
			   	jQuery("#testCaseInfoFrame").attr("src","TestCaseEdit.jsp?" + attr);
			   	jQuery("#testCaseDesignFrame").attr("src","PageDesigner.jsp?" + attr);
		   	}
		   
		   	//tab页点击事件
		   	function tabClick(frameId){
			   	var ar = ['testCaseInfo', 'testCaseDesign'];
			   	for(var i=0;i<ar.length;i++){
				   	if (frameId == ar[i]) {
					   	jQuery("#"+ ar[i]+"Tab").css("background-color","");
					   	jQuery("#"+ ar[i]+"Tab").addClass("cui-active");
		               	jQuery("#"+ ar[i]+"Frame").css("display", "block");
		           	} else {
		        	   	jQuery("#"+ ar[i]+"Tab").css("background-color","#f5f5f5");
		               	jQuery("#"+ ar[i]+"Tab").removeClass("cui-active");
		               	jQuery("#"+ ar[i]+"Frame").css("display", "none");
		           	}
			   	}
		   	}
		   	
			//生成本地脚本
			function generateScript(){
				var valid = validateAll();
		   		if(!valid.result){
		   			cui.error("测试用例保存失败，无法进一步执行生成脚本操作！<br/>" + valid.message); 
		   			return;
		   		}
		   		var isSucceed = requestSaveTestCase(testCaseVO);
				if(isSucceed){
					dwr.TOPEngine.setAsync(false);
					TestCaseFacade.genScriptByTestcaseIds([testCaseVO.modelId],function(data){
						if(data){
							cui.message("生成脚本成功。","success");
							var targerWindow = cap.searchParentWindow("refreshWindowByOperateType");
							if(targerWindow != null && targerWindow.refreshWindowByOperateType != null){
								targerWindow.refreshWindowByOperateType("testCase");
							}
						}else{
							cui.message("生成脚本失败。","error");
						}
					});
					dwr.TOPEngine.setAsync(true);
				} else {
					cui.message("测试用例保存失败，无法进一步执行生成脚本操作！", "error");
				}
			}
			
			//生成脚本并发送服务器
			function sendTest(){
				var valid = validateAll();
		   		if(!valid.result){
		   			cui.error("测试用例保存失败，无法进一步执行发送脚本操作！<br/>" + valid.message); 
		   			return;
		   		}
				cui.handleMask.show();
				dwr.TOPEngine.setAsync(false);
				TestCaseFacade.sendTestcases(modelPackage, function(data){
					if(data && data.uploadScript){
						cui.message("发送用例成功。", "success");
						var targerWindow = cap.searchParentWindow("refreshWindowByOperateType");
						if(targerWindow != null && targerWindow.refreshWindowByOperateType != null){
							targerWindow.refreshWindowByOperateType("testCase");
						}
					} else {
						cui.message("发送用例失败。", "error");
					}
				});
				dwr.TOPEngine.setAsync(true);
				cui.handleMask.hide();
			}
		   
			//测试用例保存
		   	function saveTestCase(){
		   		var valid = validateAll();
		   		if(!valid.result){
		   			cui.error("保存失败！<br/>" + valid.message); 
		   			return;
		   		}
				var isSucceed = requestSaveTestCase(testCaseVO);
				if(isSucceed){
					cui.message('保存成功！', 'success');
				} else {
					cui.error("保存失败！"); 
				}
		   	}
			
		 	//请求后台保存测试用例
			function requestSaveTestCase(testCaseVO){
		 		var ret = false;
				dwr.TOPEngine.setAsync(false);
				TestCaseFacade.saveTestCase(testCaseVO, function(result){
					ret = result;
				});
				dwr.TOPEngine.setAsync(true);
				return ret;
			}
			
			//关闭窗口
		   	function closeWindow(){
			   	if(window.parent){
				   	window.parent.close();
			   	}else{
				   	window.close();
			   	}
		   	}
		   
		   	//定位到具体的tab页，以后扩展
		   	function jumpToTab(tabId){
			   	if(tabId){tabClick(tabId);}
		   	}
		   
		   	//开启全屏模式
		   	function fullscreen(){
		   		toggleFullscreenBtnState(true);
				var docElm = document.documentElement;
				// 判断各种浏览器，找到正确的方法
			    var requestMethod = docElm.requestFullScreen || //W3C
			    docElm.webkitRequestFullScreen ||    //Chrome等
			    docElm.mozRequestFullScreen || //FireFox
			    docElm.msRequestFullScreen; //IE11
			    if (requestMethod) {
			        requestMethod.call(docElm);
			    }
			    else if (typeof window.ActiveXObject !== "undefined") {//for Internet Explorer
			        var wscript = new ActiveXObject("WScript.Shell");
			        if (wscript !== null) {
			            wscript.SendKeys("{F11}");
			        }
			    }
			}
		   	
		    //退出全屏模式
		   	function cancelFullscreen(){
		   		toggleFullscreenBtnState(false);
		   		// 判断各种浏览器，找到正确的方法
		   	    var exitMethod = document.exitFullscreen || //W3C
		   	    document.mozCancelFullScreen ||    //Chrome等
		   	    document.webkitExitFullscreen || //FireFox
		   	    document.msExitFullscreen; //IE11
		   	    if (exitMethod) {
		   	        exitMethod.call(document);
		   	    }
		   	    else if (typeof window.ActiveXObject !== "undefined") {//for Internet Explorer
		   	        var wscript = new ActiveXObject("WScript.Shell");
		   	        if (wscript !== null) {
		   	            wscript.SendKeys("{F11}");
		   	        }
		   	    }
		   	}
			
		   	/**
			 * 切换控件状态
			 * @param isFullScreen 是否全屏
			 */
		    function toggleFullscreenBtnState(isFullScreen){
		    	if(isFullScreen){
		    		cui("#fullscreenBtn").hide();
			   		cui("#cancelFullscreenBtn").show();
		    	} else {
		    		cui("#cancelFullscreenBtn").hide();
			   		cui("#fullscreenBtn").show();
		    	}
		    }
		    //统一校验
			function validateAll() {
				var globalValidResult = validateTestCaseBasicInfo();
				var validResult = validateTestCaseDesigner();
				if(!validResult.result){
					if(!globalValidResult.result){
						globalValidResult.message += "<br/>" + validResult.message;
					} else {
						globalValidResult.message = validResult.message;
					}
					globalValidResult.result = validResult.result;
				}
				globalValidResult.message = globalValidResult.message.replace(/(<br\/>)+/g, '<br/>');
				return globalValidResult;
			}
		    
			//校验用例信息模块
		    function validateTestCaseBasicInfo(){
				var message = "";
				message += $.trim(testCaseVO.name) == "" ? "【用例中文名称】不能为空.<br/>" : "";
				message += $.trim(testCaseVO.type) == "" ? "【用例类型】不能为空.<br/>" : "";
// 				if(testCaseVO.type != ""){
// 					message += $.trim(testCaseVO.metadata) == "" ? "【" + (testCaseVO.type === 'FUNCTION' ? "界面" : testCaseVO.type === 'API' ? "后台" : "业务") + "行为】不能为空.<br/>" : "";
// 				}
				return {result: message == "", message: "&diams;用例信息<br/>" + message};
		    }
			
		  	//校验用例设计模块
		    function validateTestCaseDesigner(){
		    	var globalValidResult = validateFlowChart();
				var validResult = validateStepRequired();
				if(!validResult.result){
					globalValidResult.result = validResult.result;
					globalValidResult.message += (globalValidResult.message != "" ? "<br/>" : "") + validResult.message;
				}
				globalValidResult.message = "&diams;用例设计<br/>" + globalValidResult.message;
				return globalValidResult;
		    }
		    
		    //校验流程图
		    function validateFlowChart(){
				//封装校验信息
				var message = "";
				//流程图至少要有两个步骤节点
				if(testCaseVO.steps.length <= 1){
					message += "测试用例至少要有2个步骤节点.<br/>";
				} else {
					//包装步骤连接线数据，用于数据校验
					var stepLineMsg = wrapperFlowChartConnLine();
					//判断步骤是否有连接线
					_.forEach(stepLineMsg, function (stepMsg, key) {
						var count = stepMsg.form + stepMsg.to;
						if(count === 0){
							message += "【" + stepMsg.name + "】步骤未链接连接线.<br/>";
						} 
					});
					if(message == ""){
						//判断是否只有一个开始步骤节点和一个结束步骤节点
						var startStepNode = _.filter(stepLineMsg, function(n) {
							  return n.to == 0;
							});//开始节点
						var endStepNode = _.filter(stepLineMsg, function(n) {
							  return n.form == 0;
							});//结束节点
						//判断是否只有一个开始步骤节点和一个结束步骤节点（即：节点配置是否正确）
						message += validateFlowChartNodeConfig(startStepNode, endStepNode);
						//判断是否有多个流程图
						message += validateIsExistMultiFlowChart(startStepNode, endStepNode);
						//校验是否流程图步骤节点是否有3条以上的连接线
						message += validateIsExistMultiConnLine(stepLineMsg);
					}
				}
				return {result: message == "", message: message};
		    }
		    
		    //包装步骤连接线数据，用于数据校验
		    function wrapperFlowChartConnLine(){
		    	var stepLineMsg = {};
		    	_.forEach(testCaseVO.steps, function (step, key) {
					stepLineMsg[step.id] = {id: step.id, name: step.name, form: 0, to: 0};
					_.forEach(testCaseVO.lines, function (line, lineKey) {
						if(line.form === step.id){
							++stepLineMsg[step.id].form;
						} 
						if(line.to === step.id){
							++stepLineMsg[step.id].to;
						} 
					});
				});
		    	return stepLineMsg;
		    }
		    
		    /**
			 * 校验是否流程图步骤节点是否有3条以上的连接线
			 * @param stepLineMsg 用于校验流程图的校验数据
			 */
		    function validateIsExistMultiConnLine(stepLineMsg){
		    	var message = "";
				var stepMultiLines = _.filter(stepLineMsg, function(n) {
				  return n.to + n.form > 2;
				});
				if(stepMultiLines.length > 0){
					_.forEach(stepMultiLines, function (value, key) {
						message += "【" + value.name + "】步骤有" + (value.form + value.to) + "条连接线.<br/>";
					});
				}
				return message;
		    }
		    
		    /**
			 * 判断是否只有一个开始步骤节点和一个结束步骤节点（即：节点配置是否正确）
			 * @param startStepNode 开始步骤节点
			 * @param endStepNode 结束步骤节点
			 */
		    function validateFlowChartNodeConfig(startStepNode, endStepNode){
		    	var message = "", startStepNodeCount = startStepNode.length, endStepNodeCount = endStepNode.length;
		    	var startStepNodeCount = startStepNode.length, endStepNodeCount = endStepNode.length;
				if(startStepNodeCount === 0 && endStepNodeCount === 0){
					message += "测试用例流程图不能是闭环流程.<br/>";
				} else {
					if(startStepNodeCount > 1){
						message += "测试用例只能有一个开始步骤节点.<br/>";
					} else if(startStepNodeCount == 0){
						message += "测试用例必须有一个开始步骤节点.<br/>";
					}
					if(endStepNodeCount > 1){
						message += "测试用例只能有一个结束步骤节点.<br/>";
					} else if(endStepNodeCount == 0){
						message += "测试用例必须有一个结束步骤节点.<br/>";
					}
					if(startStepNode[0].form > 1 && endStepNode[0].to > 1){
						message += "测试用例流程图不能是闭环流程.<br/>";
					}
				}
		    	return message;
		    }
		    
		    /**
			 * 判断是否有多个流程图
			 * @param startStepNode 开始步骤节点
			 * @param endStepNode 结束步骤节点
			 */
		    function validateIsExistMultiFlowChart(startStepNode, endStepNode){
		    	var message = "", startStepNodeCount = startStepNode.length, endStepNodeCount = endStepNode.length;
		    	if(startStepNodeCount === 1 && endStepNodeCount === 1 && 
		    			startStepNode[0].form == 1 && endStepNode[0].to == 1 && testCaseVO.steps.length > 3){
					var startStepId = startStepNode[0].id, endStepId = endStepNode[0].id;
					var intermediateStepLineNode = _.filter(testCaseVO.lines, function(line, key){
						return line.form != startStepId && line.to != endStepId;
					});
					var bool = false;
					for(var i in testCaseVO.steps){
						var step = testCaseVO.steps[i];
						if(step.id != startStepId && step.id != endStepId){
							var index = _.findIndex(intermediateStepLineNode, function(n){return n.form === step.id || n.to === step.id});
							if(index < 0){
								bool = true;
								break;
							} 
						}
					}
					//第二个条件是处理多个流程图，一个闭环一个正确流程，而正确流程只有两个步骤节点的情况
					if(bool || _.filter(testCaseVO.lines, function(line, key){return line.form === startStepId && line.to === endStepId;}).length > 0){
						message += "测试用例不能出现多个流程图.<br/>";
					}	
				}
		    	return message;
		    }
		    
		    /**
		     * 根据模型Id获取测试步骤定义
		     * @param type 步骤类型（BASIC、FIXED、DYNAMIC）
		     * @param modelId 模型Id
		     */
		    function getTestStepDefinitionsByModelId(modelId, type) {
		    	var stepDefinition = stepDefinitionsMap[modelId];
		    	if(stepDefinition == null){
			    	for(var i in toolsData[type]){
			    		stepDefinition = _.find(toolsData[type][i].steps, {
			    			modelId : modelId
			    		});
			    		if(stepDefinition){
			    			break;
			    		}
			    	}
		    	}
		    	return stepDefinition;
		    }
		    
			//校验必填项
			function validateStepRequired() {
				var stepsValilMsg = {};
				//扫描所有测试步骤校验失败的参数变量
				_.forEach(testCaseVO.steps, function (step, stepKey) {
					stepsValilMsg[step.id] = {name: step.name, description: step.description, step: [], childStep: []};
					var stepDefinition = getTestStepDefinitionsByModelId(step.reference.type, step.type);
					if(step.reference.arguments){
						_.forEach(step.reference.arguments, function (arg, argKey) {
							var hasName4OptionMap = arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null;
							var argName = hasName4OptionMap ? arg.ctrl.optionMap.name : arg.name;
							var stepDefinitionArg = _.find(stepDefinition.arguments, function(n){return (hasName4OptionMap && n.ctrl.optionMap.name === argName) || n.name === argName});
							if(stepDefinitionArg && stepDefinitionArg.required && $.trim(arg.value) == ""){
								stepsValilMsg[step.id].step.push(stepDefinitionArg.name);
							}
						});
					}
					if(step.reference.steps){
						_.forEach(step.reference.steps, function (childStep, childStepKey) {
							var stepDefinition = getTestStepDefinitionsByModelId(step.reference.type, "BASIC");
							_.forEach(childStep.arguments, function (arg, argKey) {
								var hasName4OptionMap = arg.ctrl != null && arg.ctrl.optionMap != null && arg.ctrl.optionMap.name != null;
								var argName = hasName4OptionMap ? arg.ctrl.optionMap.name : arg.name;
								var stepDefinitionArg = _.find(stepDefinition.arguments, function(n){return (hasName4OptionMap && n.ctrl.optionMap.name === argName) || n.name === argName});
								if(stepDefinitionArg && stepDefinitionArg.required && $.trim(arg.value) == ""){
									stepsValilMsg[step.id].childStep.push(stepDefinitionArg.name);
								}
							});
						});
					}
				});
				//封装校验信息
				var message = "";
				_.forEach(stepsValilMsg, function (stepMsg, key) {
					if(stepMsg.step.length > 0){
						message += "【" + stepMsg.description + "】步骤中的参数：" + stepMsg.step.join("、") + "是必填项，不能为空.<br/>"; 
					}
					if(stepMsg.childStep.length > 0){
						message += "【" + stepMsg.description + "】步骤的子步骤中的参数：" + stepMsg.childStep.join("、") + "是必填项，不能为空.<br/>"; 
					}
				});
				return {result: message == "", message: message};
			}
			
		</script>
	</head>
	<body style="background-color:#f5f5f5">
	 	<div class="cui-tab" style="border:solid 1px #e6e6e6;background:#f5f5f5">
	 		<span class="tabs-scroller-left cui-icon" style="display: none;"></span>
	 		<span class="tabs-scroller-right cui-icon" style="display: none; right: 22px;"></span>
	        <div class="cui-tab-head" style="margin: 0px;font-size:11pt">
	        	<table style="width:100%;border-spacing: 0px">
	        		<tr>
	        			<td style="text-align:left;padding:0px">
	        				<ul id="testCaseUl" class="cui-tab-nav" style="height:40px;width:100%;padding:0px 0 0 0px;background-color:#f5f5f5">
				                <li id="testCaseInfoTab" title="用例信息" class="cui-active" style="width:65px;height:40px;line-height:40px;margin-left:8px" onclick="tabClick('testCaseInfo')">
				                	<span class="cui-tab-title">用例信息</span>
				                    <a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
				                </li>
				                <li id="testCaseDesignTab" title="用例设计" class="" style="width:65px;height:40px;line-height:40px;background-color:#f5f5f5" onclick="tabClick('testCaseDesign')">
				                	<span class="cui-tab-title">用例设计</span>
				                	<a href="#" class="cui-tab-close cui-icon" style="display:none;"></a>
				                </li>
				            </ul>
	        			</td>
	        			<td style="text-align:right;padding-right:0px;">
<!-- 	        				<span uitype="Button" id="fullscreenBtn" label="全屏" icon="expand" on_click="fullscreen"></span> -->
<!-- 	        				<span uitype="Button" id="cancelFullscreenBtn" label="退出全屏" icon="compress" hide="true" on_click="cancelFullscreen"></span> -->
							<span uitype="button" id="generateScript" label="生成脚本" icon="file-o" on_click="generateScript"></span>
							<span uitype="button" id="sendTest" label="发送脚本"  icon="sign-in" on_click="sendTest" ></span>
	        				<span id="save" uitype="Button" label="保存" icon="file-text-o" onclick="saveTestCase()"></span>
				        	<span id="close" uitype="Button" label="关闭" onclick="closeWindow()"></span>
	        			</td>
	        		</tr>
	        	</table>
	        </div>
	        <div class="cui-tab-content"  id="tabBodyDiv" style="border-top:3px solid #4585e5">
	        	<iframe id="testCaseInfoFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:block"></iframe>
	        	<iframe id="testCaseDesignFrame"   frameborder="0"  style="height: 100%; width: 100%; position: static; left: 0px; top: 0px;display:none"></iframe>
	        </div>
	   	</div>
	</body>
</html>
