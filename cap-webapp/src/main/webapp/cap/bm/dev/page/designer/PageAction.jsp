﻿<%
/**********************************************************************
* 功能行为设计页面
* 2015-5-13 诸焕辉
* 2015-7-2	郑重 修改
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='actionList'>
<head>
	<meta charset=UTF-8"/>
    <title>页面行为设计</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>
    <style type="text/css">
    	.codeArea{
    		width:100%; 
    		background: whitesmoke;
    		border-radius: 3.01px;
    		transition: border .3s linear 0s;
    		border: 1px solid #ccc;
    		padding: 4px 0;
    		margin-bottom: 5px;
			-moz-transition:border .3s linear 0s;
			-webkit-transition:border .3s linear 0s;
			-o-transition:border .3s linear 0s
		}
		.CodeMirror {
			width:100%;
			height: auto;
			background: rgb(232, 229, 229);
		}
		.code_btn_area {
			position: relative;
			float: right;
			margin-bottom: -15px;
			z-index: 10000;
			cursor: pointer;
		}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/pageaction.js"></top:script>
	<top:script src="/cap/bm/common/zeroclipboard/ZeroClipboard.min.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ActionDefineFacade.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/pageactioncommon.js"></top:script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="actionListCtrl" data-ng-init="ready()">
	<div class="cap-page">
		<div class="cap-area" style="width:100%; height: 100%; overflow-y: auto">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td class="cap-td" style="text-align: left;">
			        	<span id="formTitle" uitype="Label" value="页面行为设计" class="cap-label-title"></span>
			        </td>
			    </tr>
			</table>
			<table class="cap-table-fullWidth" style="width:100%; height: 95%;">
			    <tr>
			        <td class="cap-td" style="text-align: left;width:277px;padding-right: 5px">
			        	<table class="cap-table-fullWidth" style="width:100%;">
						    <tr>
						        <td  class="cap-form-td" style="text-align: left;">
									<span class="cap-group">行为列表</span>
						        </td>
						    </tr>
						    <tr>
						    	<td class="cap-form-td" style="text-align: right;" nowrap="nowrap">
						            <span cui_button id="add" ng-click="addPageAction()" label="新增"></span>
					        		<!-- <span cui_button id="copyOtherPageMethod" label="复制其他页面方法" onClick="sss()"></span>  -->
					        		<span cui_button id="copy" label="复制" ng-click="copyPageAction()"></span>
					        		<span cui_button id="delete" ng-click="deletePageAction()" label="删除"></span>
						    		<span cui_button id="upButton" ng-click="up()" label="上移"></span>
						    		<span cui_button id="downButton" ng-click="down()" label="下移"></span>
						        </td>
						    </tr>
						    <tr>
						    	<td class="cap-form-td">
						            <table class="custom-grid" style="width: 100%">
						                <thead>
						                    <tr>
						                    	<th style="width:30px">
						                    		<input type="checkbox" name="pageActionsCheckAll" ng-model="pageActionsCheckAll" ng-change="allCheckBoxCheck(root.pageActions,pageActionsCheckAll)">
						                        </th>
						                        <th>
					                            	中文名称
						                        </th>
						                        <th>
					                            	英文名称
						                        </th>
						                    </tr>
						                </thead>
				                        <tbody>
				                            <tr ng-repeat="pageActionVo in root.pageActions track by $index" style="background-color: {{selectPageActionVO.pageActionId==pageActionVo.pageActionId ? '#99ccff':'#ffffff'}}">
				                            	<td style="text-align: center;">
				                                    <input type="checkbox" name="{{'pageAction'+($index + 1)}}" ng-model="pageActionVo.check" ng-change="checkBoxCheck(root.pageActions,'pageActionsCheckAll')">
				                                </td>
				                                <td class="notUnbind" style="text-align:left;cursor:pointer" ng-click="pageActionTdClick(pageActionVo)">
				                                    {{pageActionVo.cname}}
				                                </td>
				                                <td class="notUnbind" style="text-align: center;" ng-click="pageActionTdClick(pageActionVo)">
				                                    {{pageActionVo.ename}}
				                                </td>
				                            </tr>
				                       </tbody>
						            </table>
						    	</td>
						    </tr>
						</table>
			        </td>
			        <td style="text-align: center;border-left:1px solid #ddd;vertical-align:middle">
			        	<span style="opacity: 0.2;font-size:18px" ng-if="!selectPageActionVO.pageActionId">请新增行为</span>
			        </td>
			        <td class="cap-td" style="text-align: left" ng-show="selectPageActionVO.pageActionId">
			        	<table class="cap-table-fullWidth">
						    <tr>
						        <td  class="cap-form-td" style="text-align: left;">
									<span class="cap-group">行为编辑</span>
						        </td>
						    </tr>
						    <tr>
						    	<td style="text-align: left;">
						    		<table class="cap-table-fullWidth">
									   <tr>
									        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
									        	<span uitype="Label" value="行为模板："></span>
									        </td>
									        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        		<span cui_clickinput id="methodTemplate" width="100%" ng-model="selectPageActionVO.actionDefineVO.modelName" ng-click="openSelectActionTmpWin()"></span>
										    </td>
									        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
									        	<span uitype="Label" value="描述："></span>
									        </td>
									        <td class="cap-td" valign="top" style="text-align: left;width:35%; padding-right: 5px;" rowspan="3" nowrap="nowrap">
								   				<span cui_textarea id="description" ng-model="selectPageActionVO.description" height="92" width="100%"></span>
									        </td>
									    </tr>
									    <tr>
									        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
									        	<font color="red">*</font><span uitype="Label" value="行为英文名称："></span>
									        </td>
									        <td class="cap-td" nowrap="nowrap" style="text-align: left;" ng-if="selectPageActionVO.actionDefineVO.specialMethod==null||selectPageActionVO.actionDefineVO.specialMethod==false">
									         	<span cui_input id="ename" ng-model="selectPageActionVO.ename" validate="actionEnameValRule" width="100%"/>
									        </td>
									        <td class="cap-td" nowrap="nowrap" style="text-align: left;" ng-if="selectPageActionVO.actionDefineVO.specialMethod!=null&&selectPageActionVO.actionDefineVO.specialMethod==true">
									         	<span readonly="true" cui_input id="ename" ng-model="selectPageActionVO.ename" validate="actionEnameValRule" width="100%"/>
									        </td>
									        <td class="cap-td" style="text-align: right;width:100px">
									        </td>
									    </tr>
									    <tr>
									        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
									        	<font color="red">*</font><span uitype="Label" value="行为中文名称："></span>
									        </td>
									        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
								   				<span cui_input id="cname" ng-model="selectPageActionVO.cname" validate="actionCnameValRule" width="100%"/>
									        </td>
									        <td class="cap-td" style="text-align: right;width:100px">
									        </td>
									    </tr>
									</table>
									<table ng-if="selectPageActionVO.actionDefineVO.modelId!=null" class="cap-table-fullWidth" cui_property id="newProperty" ng-model="selectPageActionVO"></table>
									<table class="cap-table-fullWidth">
									    <tr>
									        <td class="cap-td" style="text-align: left;padding-right: 7px;">
									        	<div class="code_btn_area">
									        		<input type="button" id="transferActionBtn" ng-if="hasShowTransferActionBtn" onclick="transferCustomAction()" value="转自定义行为"/>
										        	<input type="button" class="copyToClipboardBtn" ng-show="codemirrors[selectPageActionVO.pageActionId].length > 0" id="copyToClipboardBtn" value="复制"/>
									        	</div>
									        	<div class="codeArea" ng-if="codemirrors[selectPageActionVO.pageActionId].length > 0">
									        		<span cui_code ng-repeat='codemirrorVO in codemirrors[selectPageActionVO.pageActionId]' id="{{codemirrorVO.id}}" ng-model="codemirrorVO.form" ng-code="codemirrorVO.code" ng-out="codemirrorVO.out"></span>
									        	</div>
									        </td>
									    </tr>
									</table>
						    	</td>
						    </tr>
						</table>
			        </td>
			    </tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
		var pageId="<%=request.getParameter("modelId")%>";
		var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var globalReadState=eval(<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>);
		var pageSession = new cap.PageStorage(pageId);
		var pageActions = pageSession.get("action");
		var page = pageSession.get("page");
		var root = {pageActions:pageActions};
		//监听变量变化后自动保存
		function watchPageActions(){
		 	setPageAttribute();
			cap.addObserve(root,watchPageActions);
		}
		cap.addObserve(root,watchPageActions);
		
		function messageHandle(e) {
			if(e.data.type=="pageActionChange"){
				if(e.data.data != null){
					var pageActionId = e.data.data.pageActionId;
					var isExitAction = false;
					var isExitActionNum = -1;
					for(var i = 0;i<pageActions.length;i++){
						if(pageActionId == pageActions[i].pageActionId){
							isExitActionNum = i;
							isExitAction = true;
							break;
						}
					}
					if(isExitAction){//存在行为时更新
					    pageActions[isExitActionNum] = e.data.data;
						scope.selectPageActionVO=pageActions[isExitActionNum];
				   		scope.checkBoxCheck(scope.root.pageActions,"pageActionsCheckAll");
				   		initCodeArea();
					}else{//不存在行为时新增
						e.data.data.hasAuto = true;
						scope.addPageActionFromMessage(e.data.data);
					}
				}
				cap.digestValue(scope);
			}else if(e.data.type=="pageModelNameChange"){
				if(scope){
					scope.init();
					cap.digestValue(scope);
				}
			}else if(e.data.type=="codeEditorRefresh") {
				if(scope){
					scope.$broadcast('codeEditorRefresh');
				}
			}
		}
	
		window.addEventListener("message", messageHandle, false);
	
		//拿到angularJS的scope
		var scope=null;
		angular.module('actionList', ["cui"]).controller('actionListCtrl', function ($scope, $timeout) {
		   	$scope.root=root;
		   	$scope.codemirrors={};
		   	$scope.pageActionsCheckAll=false;
		   	$scope.hasShowTransferActionBtn=false;
		   	$scope.selectPageActionVO=root.pageActions.length>0?root.pageActions[0]:{};
		   	
		   	$scope.ready=function(){
		   		$(".cap-page").css("height", $(window).height()-20);
				$(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
			       jQuery(".cap-page").css("height", $(window).height()-20);
			    });
		    	comtop.UI.scan();
		    	$scope.setReadonlyAreaState(globalReadState);
		    	scope=$scope;
		    	$scope.init();
		    	loadActionPropertyjs($scope.selectPageActionVO);
		    }
		   	
		   	/**
			 * 设置区域读写状态
			 * @param globalReadState 状态标识
			 */
			$scope.setReadonlyAreaState=function(globalReadState){
				//设置为控件为自读状态（针对于CAP测试建模）
			   	if(globalReadState){
			    	$timeout(function(){
			    		cap.setReadonlyArea("unReadonlyArea", ["*:not([class^='notUnbind'],[id='actionType'])"], ["input[type='checkbox'], input[type='button']"], ["#actionType"]);
			    	}, 0);
		    	}
			}
		   	
		   	$scope.init=function(){
		   		for(var i=0;i<$scope.root.pageActions.length;i++){
		   			var pageAction=$scope.root.pageActions[i];
		   			initCodemirrors(pageAction,pageAction.actionDefineVO);
		   		}
		   	}
		
		   	$scope.pageActionTdClick=function(pageActionVo){
		   		$scope.selectPageActionVO=pageActionVo;
		   		setTransferActionBtnState($scope);
		   		$scope.setReadonlyAreaState(globalReadState);
		   		//加载行为属性控件中绑定的js函数
		   		loadActionPropertyjs($scope.selectPageActionVO);
		    }
		   	
		   	/**
		   	 * 监听codemirrors的变化，重新设置方法体
		   	 */
			$scope.$watch("codemirrors",function(){
				setMethodBody();
			},true);
		   	
		   	//监控全选checkbox，如果选择则联动选中列表所有数据
		   	$scope.allCheckBoxCheck=function(ar,isCheck){
		   		if(ar!=null){
		   			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}	
		   		}
		   	}
		   	
		   	//监控选中，如果列表所有行都被选中则选中allCheckBox
		   	$scope.checkBoxCheck=function(ar,allCheckBox){
		   		if(ar!=null){
		   			var checkCount=0;
		   			var allCount=0;
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
			    		}
		    			
		    			if(true){
		    				allCount++;
		    			}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
		   		}
		   	}
		   	
		   	//复制选中的行为
		   	$scope.copyPageAction=function(){
			    for(var i=0;i<$scope.root.pageActions.length;i++){
			        if($scope.root.pageActions[i].check){
			        	var newPageAction=jQuery.extend(true,{},$scope.root.pageActions[i]);
				 		newPageAction.pageActionId=(new Date()).valueOf()+i;
				 		newPageAction.check = false;
				 		newPageAction.ename = "copy_" + newPageAction.ename;
				 		while(_.find($scope.root.pageActions, {ename: newPageAction.ename})){
				 			newPageAction.ename += _.random(1000, false);
				 		}
				 		$scope.root.pageActions.push(newPageAction);
			        }
			    }
			    $scope.checkBoxCheck($scope.root.pageActions,"pageActionsCheckAll");
			    $scope.init();
		   	}
		   	
		   	//新增行为
		   	$scope.addPageAction=function(){
		   		var pageActionId=(new Date()).valueOf();
				var newPageAction = {
						pageActionId:pageActionId+"",cname:'',ename:'',
						description:'',methodTemplate:'',methodTemplateId:'',methodOption:{},methodBodyExtend:{},
						methodBody:'',actionDefineVO:{}};
				
				$scope.root.pageActions.push(newPageAction);
				$scope.selectPageActionVO=newPageAction;
				$scope.checkBoxCheck($scope.root.pageActions,"pageActionsCheckAll");
				$scope.hasShowTransferActionBtn = false;
		   	}
		   	
		  	//从界面设计器控件事件接收消息并新增行为
		   	$scope.addPageActionFromMessage=function(data){
		   		$scope.root.pageActions.push(data);
		   		$scope.selectPageActionVO=data;
		   		$scope.checkBoxCheck($scope.root.pageActions,"pageActionsCheckAll");
		   		//初始化代码区域
		   		initCodeArea();
		   	}
		   	
		   	//删除行为
		   	$scope.deletePageAction=function(){
		   		var deleteArr=[];
		   		var message = '';
		   		var newArr=[];//需要删除的数据序号
		        for(var i=0;i<$scope.root.pageActions.length;i++){
			        if($scope.root.pageActions[i].check){
			        	var result = $scope.deletePageActionBefore($scope.root.pageActions[i]);
			        	if(!result.validFlag){
			        		message += result.message;
			        	}else{
			        		newArr.push(i);
			        		deleteArr.push($scope.root.pageActions[i]);
			        	}
			          }
			     }
		   		
		        var deleteTitle = "";
				for(var k=0;k<deleteArr.length;k++){
					 deleteTitle += deleteArr[k].ename+"<br/>";
				}
				if(deleteArr.length>0){
					cui.confirm("确定要删除<br/>"+deleteTitle+"这些行为吗？",{
						onYes:function(){ 
					        //根据坐标删除数据
					        for(var j=newArr.length-1;j>=0;j--){
					        	$scope.root.pageActions.splice(newArr[j],1);
					        }
					
					        //如果当前选中的行被删除则默认选择第一行
					        var isSelectIsDelete=true;
					        for(var i=0;i<$scope.root.pageActions.length;i++){
						        if($scope.root.pageActions[i].pageActionId==$scope.selectPageActionVO.pageActionId){
						            isSelectIsDelete=false;
						            break;
						        }
					        }
					        if(isSelectIsDelete){
								$scope.selectPageActionVO=$scope.root.pageActions[0];
					        }
					        $scope.checkBoxCheck($scope.root.pageActions,"pageActionsCheckAll");
					        cap.digestValue(scope);
						}
					});
				}    
				if(message != ''){
			        cui.alert(message+"删除失败！");
			    }
		   	}
		   	
		   	//执行删除之前
		   	$scope.deletePageActionBefore=function(pageAction){
		   		var result = {validFlag: false, message:''};
		 	    var errorMessage = [];
		   	    var uiConfig = window.parent.document.getElementById("desingerFrame").contentWindow._cdata.getUIData();
		 	    for(var i in uiConfig){
		 		   var componentVo = getComponentByModelId(uiConfig[i].componentModelId, window.parent.toolsdata);
		 		   var events = componentVo.events != null ? componentVo.events : [];
		 		   for(var j in events){
		 			   var ename = events[j].ename;
		 			   var pageActionId = uiConfig[i].options[ename+"_id"];
		 			   if(pageActionId === pageAction.pageActionId){
		 				   errorMessage.push(uiConfig[i].options.label+"控件"+ename+ "属性"); 
		 			   }
		 			}
		 		}
		 	    
		 	    if(errorMessage.length > 0){
		 	    	result.validFlag = false;
		 	    	result.message = pageAction.ename+"已被以下的控件绑定"+JSON.stringify(errorMessage)+"<br/>";
		 	    } else {
		 	    	result.validFlag = true;
		 	    }
			    return result;
			    
		   	}
		   	
		   	/**
			 * 打开window原生窗口
			 * @param event
			 * @param self
			 */
			$scope.openSelectActionTmpWin=function(){
				var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/actionlibrary/ActionTemplateList.jsp?callbackMethod=selectActionTmp';
				var width=800; //窗口宽度
			    var height=600;//窗口高度
			    var top=(window.screen.height-30-height)/2;
			    var left=(window.screen.width-10-width)/2;
			    window.open(url, "SelectActionTmp", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
			}
		   	
			//上移
			$scope.up=function(){
	    		if($scope.root.pageActions.length > 0 && $scope.root.pageActions[0].check){
	    			return;
	    		}
	    		var pageActions = [];
	    		for(var i in $scope.root.pageActions){
	    			if($scope.root.pageActions[i].check){
	    				pageActions.push($scope.root.pageActions[i]);
	    			}
	    		}
	    		for(var i in pageActions){
	    			var currentData = pageActions[i];
					if(currentData.pageActionId != null){
						var currentIndex = 0;
						var frontData = {};
						for(var i in $scope.root.pageActions){
							if($scope.root.pageActions[i].pageActionId == currentData.pageActionId){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex > 0){
							frontData = $scope.root.pageActions[currentIndex - 1];
							$scope.root.pageActions.splice(currentIndex - 1, 2, currentData);
							$scope.root.pageActions.splice(currentIndex, 0, frontData);
						} 
					}
	    		}
			}
			
			//下移
			$scope.down=function(){
				var len = $scope.root.pageActions.length;
	    		if(len > 0 && $scope.root.pageActions[len-1].check){
	    			return;
	    		}
	    		var pageActions = [];
	    		for(var i in $scope.root.pageActions){
	    			if($scope.root.pageActions[i].check){
	    				pageActions.push($scope.root.pageActions[i]);
	    			}
	    		}
	    		pageActions = pageActions.reverse();
	    		for(var i in pageActions){
	    			var currentData = pageActions[i];
					if(currentData.pageActionId != null){
						var currentIndex = 0;
						var nextData = {};
						for(var i in $scope.root.pageActions){
							if($scope.root.pageActions[i].pageActionId == currentData.pageActionId){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex < len-1){
							nextData = $scope.root.pageActions[parseInt(currentIndex) + 1];
							$scope.root.pageActions.splice(parseInt(currentIndex) + 1, 1, currentData);
							$scope.root.pageActions.splice(currentIndex, 1, nextData);
						}
					}
	    		}
			}
		});
		
		//动态加载行为属性控件中的js函数
		function loadActionPropertyjs(actionVO){
			if(actionVO.actionDefineVO&&actionVO.actionDefineVO.properties){
				for(var k=0;k<actionVO.actionDefineVO.properties.length;k++){
					var objProperty = actionVO.actionDefineVO.properties[k];
					if(objProperty&&objProperty.propertyEditorUI&&objProperty.propertyEditorUI.operation&&$.trim(objProperty.propertyEditorUI.operation) != ''){
						try{
							$("<script type='text/javascript'>" + objProperty.propertyEditorUI.operation + "<\/script>").appendTo("head");  //动态加载函数	
						}catch(e){
							console.log("function不规范：\n"+objProperty.propertyEditorUI.operation);
						}
					}
				}
			}
		}
		
		/**
		 * 从工具箱获取控件信息
		 * @param componentModelId 控件ID
		 */
		function getComponentByModelId(componentModelId, toolsdata){
			return _.cloneDeep(_.find(getAllComponent4Toolsdata(toolsdata),{"modelId":componentModelId}));
		}
		
		/**
		 * 从工具箱中过滤出所有控件（工具箱包括控件类型子节点LayoutVo，需过滤掉）
		 * @param data 控件数据源（ComponentTypeFacade.queryList获取的数据，即工具箱数据源）
		 */
		function getAllComponent4Toolsdata(data){
		  var ary = [];
		  _.forEach(data,function(n){
		      if(n.isFolder){
		        ary = ary.concat(getAllComponent4Toolsdata(n.children));
		      }else{
		        ary.push(n.componentVo);
		      }
		  })
		  return ary; 
		}
		
		//打开URL编辑器
		function openURLEditor(flag,constantName) {
			flag="pageConstantList["+flag+"]"
			var url = 'URLEditor.jsp?packageId=' + packageId+"&modelId="+pageId+"&flag="+flag+"&constantName="+constantName;
			var top=(window.screen.availHeight-600)/2;
			var left=(window.screen.availWidth-800)/2;
			window.open (url,'URLEditor','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		}
		
		//URL编辑器值
		function importURLCallBack(result){
			var flag=result.flag;
			var url=result.url;
			var constantOption=result.constantOption;
			scope.selectPageActionVO.methodOption.pageURL=url;
			cap.digestValue(scope);
		}	
		
		/**
		 * 选择行为类型回调函数
		 * @param obj 行为模版对象
		 */
		function selectActionTmp(obj){
			if(obj.specialMethod!=null && obj.specialMethod===true){
				scope.selectPageActionVO.ename=obj.methodName;
				scope.selectPageActionVO.cname=obj.methodCname;
				scope.selectPageActionVO.description=obj.methodDescription;
			} else {
				if(scope.selectPageActionVO.ename == null || scope.selectPageActionVO.ename == ''){
					scope.selectPageActionVO.ename=obj.modelName;
				}
				if(scope.selectPageActionVO.cname == null || scope.selectPageActionVO.cname == ''){
					scope.selectPageActionVO.cname=obj.cname;
				}
				if(scope.selectPageActionVO.description == null || scope.selectPageActionVO.description  == ''){
					scope.selectPageActionVO.description=obj.description;
				}
			}
			
			scope.selectPageActionVO.actionDefineVO=obj;
			scope.selectPageActionVO.initPropertiesCount=obj.properties.length;
			scope.selectPageActionVO.methodTemplate = obj.modelId;
			//默认生成行为时，行为的默认属性的值，这里主要为工作流默认回退等方法(设计器控件拖出自动生成行为具有默认值)
			var pageActionProperties = [];
			if(scope.selectPageActionVO.hasAuto){
				for(var name in scope.selectPageActionVO.methodOption){
					var pageActionPropertie = {ename:name,defaultValue:scope.selectPageActionVO.methodOption[name]};
					pageActionProperties.push(pageActionPropertie);
				}
				delete scope.selectPageActionVO.hasAuto;
			}
			//清空行为参数和用户输入代码
			scope.selectPageActionVO.methodOption=scope.selectPageActionVO.methodOption || {};
			scope.selectPageActionVO.methodBodyExtend=scope.selectPageActionVO.methodBodyExtend || {};
			var validProKeys = [];
			//获取行为模版属性集合
			var properties=scope.selectPageActionVO.actionDefineVO.properties;
			//初始化行为模板对应的参数对象变量
			_.forEach(properties, function(propertyVo) {
				validProKeys.push(propertyVo.ename);
				scope.selectPageActionVO.methodOption[propertyVo.ename] = scope.selectPageActionVO.methodOption[propertyVo.ename] || propertyVo.defaultValue;
			})
			//控件默认行为中的methodOption对象中有个别或全部输入参是有固定值的
			_.forEach(pageActionProperties, function(propertyVo) {
				validProKeys.push(propertyVo.ename);
				scope.selectPageActionVO.methodOption[propertyVo.ename] = scope.selectPageActionVO.methodOption[propertyVo.ename] || propertyVo.defaultValue;	
			})
			//删除垃圾数据
			_.forEach(scope.selectPageActionVO.methodOption, function(value, key) {
				if(!_.find(validProKeys, function(n){return n === key})){
					delete scope.selectPageActionVO.methodOption[key];
				}
			})
			
			initCodemirrors(scope.selectPageActionVO,obj);
			//加载行为属性控件中绑定的js函数
	   		loadActionPropertyjs(scope.selectPageActionVO);
			cap.digestValue(scope);
		}
		
		//打开实体服务选择界面
		function openEntityMethodSelectWindow(isGenerateParameterForm,isTree,actionReLoadMethodName,objHtml) {
			var b=isGenerateParameterForm!=null?isGenerateParameterForm:true;
			var f=actionReLoadMethodName!=null?actionReLoadMethodName:false;
			var propertyName = "";
			if(objHtml&&objHtml!=null&&objHtml!=""){
			  propertyName = objHtml.id;
		    }
			var url = "${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/EntityServiceSelect.jsp?packageId="+packageId+"&isGenerateParameterForm="+b+"&propertyName="+propertyName;
			if(isTree){
				url = "${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/EntityServiceSelect.jsp?packageId="+packageId+"&isGenerateParameterForm="+b+"&isTree=true"+"&actionReLoadMethodName="+f+"&propertyName="+propertyName;
			}
			if(f!=false){
				url  += ("&isTree=false&actionReLoadMethodName="+f);
			}
		    var top=(window.screen.availHeight-600)/2;
		    var left=(window.screen.availWidth-800)/2;
		    window.open (url,'EntityServiceSelectWin','height=600,width=900,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
		}
		
			
		//选择实体方法回调
		function entityServiceSelectCallBack(data,isGenerateParameterForm,isTree,actionReLoadMethod,propertyName) {
			var f=actionReLoadMethod!=null?actionReLoadMethod:false;
			if(f=="saveAndAudit"){
				scope.selectPageActionVO.methodOption.actionReLoadMethodName=data.aliasName;
				//设置方法ID
				scope.selectPageActionVO.methodOption.actionReLoadMethodId=data.entity.modelId + "/" + data.engName; 
				cap.digestValue(scope);
				return;
			}
			scope.selectPageActionVO.methodOption.isGenerateParameterForm=isGenerateParameterForm;
			var propertiesAr=[];
			var initPropertiesCount=scope.selectPageActionVO.initPropertiesCount;
			for(var i=0;i<initPropertiesCount;i++){
				propertiesAr.push(scope.selectPageActionVO.actionDefineVO.properties[i]);
			}
			//设置实体方法名
			//scope.selectPageActionVO.methodOption.actionMethodName=data.engName;
			if(propertyName&&propertyName!=null&&propertyName!=""){
				scope.selectPageActionVO.methodOption[propertyName]=data.aliasName;
			}else{
			    scope.selectPageActionVO.methodOption.actionMethodName=data.aliasName;
			}
			//设置方法ID
			scope.selectPageActionVO.methodOption.methodId=data.entity.modelId + "/" + data.engName; 
			//设置实体别名Id
			if(data.entity.aliasName){
				var aliasEntityId="";
				var modelIds=data.entity.modelId.split(".");
				for(var i=0;i<modelIds.length;i++){
					if(i==(modelIds.length-1)){
						aliasEntityId += data.entity.aliasName.charAt(0).toUpperCase() + data.entity.aliasName.substring(1);
					}else{
						aliasEntityId += modelIds[i]+".";
					}
				}
				scope.selectPageActionVO.methodOption.aliasEntityId=aliasEntityId;
			}
			//设置实体ID
			scope.selectPageActionVO.methodOption.entityId=data.entity.modelId;
			
			//设置方法返回值来源
			scope.selectPageActionVO.methodOption.returnSource=data.returnType.source;
			//scope.selectPageActionVO.methodOption.returnType=data.returnType.type;
			//设置方法参数类型
			scope.selectPageActionVO.methodOption.paramType = data.parameters ? JSON.stringify(data.parameters) : '';
			if(isGenerateParameterForm!="false"){
				//设置返回值
				var isReturnType = data.returnType.type != 'void';
				if(isReturnType){
					scope.selectPageActionVO.methodOption.returnValueBind="";
					var property={cname:'返回值',ename:"returnValueBind",type:'String',requried:true,'default':'',propertyEditorUI:{componentName:'cui_clickinput',script:'{"ng-model":"returnValueBind","onclick":"openDataStoreSelect(\'returnValueBind\')"}'}};
					propertiesAr.push(property);
				}
				
				if(data.parameters){
					var parameterCount=data.parameters.length;
			 		var methodParameter = "";
					if(parameterCount > 0){
						for(var i = 1; i <= parameterCount; i++){
							scope.selectPageActionVO.methodOption["methodParameter" + i]="";
							methodParameter +="{{"+"methodOption.methodParameter"+i+"}}"+",";
							var property={cname:"参数"+i,peopertName:data.parameters[i-1].engName,ename:"methodParameter"+i,type:'String',requried:true,'default':'',propertyEditorUI:{componentName:'cui_clickinput',script:'{"ng-model":"methodParameter'+i+'","onclick":"openDataStoreSelect(\'methodParameter'+i+'\')"}'}};
							if(isTree){
								property={cname:"<a style=\"color:red;\">*</a>参数"+i,peopertName:data.parameters[i-1].engName,ename:"methodParameter"+i,type:'String',requried:true,'default':'',propertyEditorUI:{componentName:'cui_clickinput',script:'{"ng-model":"methodParameter'+i+'","onclick":"openDataStoreSelect(\'methodParameter'+i+'\')"}'}};
							}
			                propertiesAr.push(property);
						}
					}
					scope.selectPageActionVO.methodOption.methodParameter=methodParameter.substring(0,methodParameter.length-1);
				}
				scope.selectPageActionVO.actionDefineVO.properties=propertiesAr;
			}
			initCodemirrors(scope.selectPageActionVO,scope.selectPageActionVO.actionDefineVO);
			cap.digestValue(scope);
		}
		
		//行为新增页面新增行为后，初始化文本域
		function initCodeArea(){
			if(scope.selectPageActionVO.actionDefineVO==null){
				var action ={};
				dwr.TOPEngine.setAsync(false);
				ActionDefineFacade.loadModelByModelId(scope.selectPageActionVO.methodTemplate, function(data){
					scope.selectPageActionVO.actionDefineVO=data;
				});
				dwr.TOPEngine.setAsync(true);
				selectActionTmp(scope.selectPageActionVO.actionDefineVO);
			}else{
				initCodemirrors(scope.selectPageActionVO,scope.selectPageActionVO.actionDefineVO);
				cap.digestValue(scope);
			}
		}
		
		/**
		 * 初始化文本域
		 * @param obj 行为对象
		 */
		function initCodemirrors(pageActionVO,obj){
			if(obj.script!=null){
				//1、替换scrip模版常量占位符，值在page对象中取（重新加载页面时候）
				var script="";
				var pageMatchRule={regExp:/\\${\w+}/g,startNum:2,endNum:1};
				script = replaceScriptTmpPlaceholders(obj.script,page,pageMatchRule);
				script = replaceScriptTmpPlaceholders(script,pageActionVO.methodOption,pageMatchRule);
				//行为模板中有些属性默认值，可能在FTL模板中没有，将此属性及其默认值添加到页面行为方法属性中
	        	setDefalutMethodOption(pageActionVO,obj);
				var array = script.split("\n");
				//2、获取可编辑区域占位块，如：（<script name="before"/>）
				var patt = new RegExp(/<script name=\"\w+\"\/>/);
				//新增codemirrors数组，每一个数组存放一个js文本域，cui_code指令使用到该数组
				scope.codemirrors[pageActionVO.pageActionId]=[];
				//3、行为方法体扩展methodBodyExtend和codemirrors赋值步骤；codemirrors数组对象中的id是序号即是不可编辑文本域，id=key则是可编辑部分；
				var code = '';
				var index = 0;
				for(var i=0, len=array.length; i<len; i++){
					if(patt.test(array[i])){
						var startIndex = array[i].indexOf('"')+1;
						var endIndex = array[i].lastIndexOf('"');
						var key = array[i].substring(startIndex, endIndex);
						//行为方法体扩展（用于开发人员扩展代码）
						if(pageActionVO.methodBodyExtend[key]==null){
							pageActionVO.methodBodyExtend[key]="";
						}else{
							pageActionVO.methodBodyExtend[key]=pageActionVO.methodBodyExtend[key];
						}
						scope.codemirrors[pageActionVO.pageActionId].push({id:index++, form:pageActionVO, code:code, out: ""});
						scope.codemirrors[pageActionVO.pageActionId].push({id:key, form:pageActionVO, code:'', out: pageActionVO.methodBodyExtend[key]});
						code ='';
					} else {
						code += (code != '' ? "\n": '') + array[i];
						if(i == len-1){
							scope.codemirrors[pageActionVO.pageActionId].push({id:index++, form:pageActionVO, code:code, out: ""});
						}
					} 
				}
				//cap.digestValue(scope);
			}
		}
		
		
		//打开数据模型选择界面
		function openDataStoreSelect(flag,isWrap,objHtml) {
			var url = 'DataStoreSelect.jsp?packageId=' + packageId+"&modelId="+pageId+"&isWrap="+isWrap;
			if(flag=="pageURL"||flag=="forwardUrl"){
				url += "&selectType=url";
			}else if(flag=="dataStore"||flag=="queryCondition"){
				url += "&selectType=dataStore";
			}else if(flag=="returnValueBind"){
				var returnValueSource = scope.selectPageActionVO.methodOption.returnSource;
				url += getReturnValueBindSelectSource(returnValueSource);
			}else if(flag==1){
				url += "&selectType=dataStoreAttribute";
			}
			else if(flag=="treeIdParam" || flag=="treeParentIdParam" || flag=="treeNameParam"){
				url += "&selectType=dataStoreAttribute";
			}
			else if(flag.indexOf("methodParameter")>-1){
				var methodParameterType = eval("("+ scope.selectPageActionVO.methodOption.paramType +")");
				url += getMethodParameterSelectType(methodParameterType,flag);
			}
			if(objHtml&&objHtml!=null&&objHtml!=""){
				flag = objHtml.id;
			}
			url += "&flag="+flag;
			var top=(window.screen.availHeight-600)/2;
			var left=(window.screen.availWidth-800)/2;
			window.open (url,'openDataStoreSelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		}
		
		//根据方法返回值类型获取选择数据的方式
		function getReturnValueBindSelectSource(returnValueSource){
			if(returnValueSource){
				if(returnValueSource == "javaObject" || returnValueSource == "collection" || returnValueSource == "entity" || returnValueSource == "thirdPartyType"){
					return "&selectType=dataStore";
				}else{
					return "&selectType=attribute";
				}
			}
		}
		
		//根据方法参数类型获取选择数据的方式
		function getMethodParameterSelectType(methodParameterType,flag){
			if(methodParameterType && methodParameterType.length && methodParameterType.length > 0) {
				for(var i=0;i<methodParameterType.length;i++){
					var objParameter = methodParameterType[i];
					var count = 1+i;
					var parameter = "methodParameter" + count;
					if(flag==parameter){
						if(objParameter.dataType.source=="javaObject"||objParameter.dataType.source=="collection"||objParameter.dataType.source=="entity"||objParameter.dataType.source=="thirdPartyType"){
							return "&selectType=dataStore";
						}else{
							return "&selectType=attribute";
						}
					}
				}
			}
		}
		
		//数据模型选择回调
		function  importDataStoreVariableCallBack(variableSelect,flag,isWrap,selectDataStoreVO){
			if(!variableSelect || variableSelect === '') {
				scope.selectPageActionVO.methodOption[flag] = null;
			}else if(typeof(variableSelect) == "object"){
				var value=variableSelect.ename;
				if(isWrap=="true"){
					value="@{"+value+"}";
				}
				eval("scope.selectPageActionVO.methodOption."+flag+"='"+value+"';")
			}else if(flag==1){
				flag ="columnAttribute";
				if(variableSelect && variableSelect.indexOf(".")>-1 
					&& variableSelect.split(".").length>1){
					
					var value=variableSelect.split(".")[1];
				}
		        eval("scope.selectPageActionVO.methodOption."+flag+"='"+value+"';");
			}
			else{
				var value=variableSelect;
				if(isWrap=="true"){
					value="@{"+value+"}";
				}
				eval("scope.selectPageActionVO.methodOption."+flag+"='"+value+"';");
			}
			cap.digestValue(scope);
		}
		
		//打开页面选择界面
		function openPageSelect() {
			var top=(window.screen.availHeight-600)/2;
			var left=(window.screen.availWidth-800)/2;
			window.open('CopyPageListMain.jsp?systemModuleId='+packageId,"copyPageWin",'height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
		}
		
		//页面选择，回调
		function selectPageData(selectPageDate){
			scope.selectPageActionVO.methodOption.pageURL=selectPageDate.url;
			var ar=[];
			for(var i=0;i<selectPageDate.pageAttributeVOList.length;i++){
				var pageAttributeVO=selectPageDate.pageAttributeVOList[i];
				ar.push({attributeName:pageAttributeVO.attributeName,attributeDescription:pageAttributeVO.attributeDescription,attributeValue:''});
			}
			scope.selectPageActionVO.methodOption.pageAttributeVOList=ar;
			cap.digestValue(scope);
		}
		
		//设置方法体
		function setPageAttribute(){
			if(scope.selectPageActionVO!=null && scope.selectPageActionVO.methodOption!=null){
				var pageAttributeVOList=scope.selectPageActionVO.methodOption.pageAttributeVOList;
				if(pageAttributeVOList!=null){
					scope.selectPageActionVO.methodOption.pageAttributeVOString=cui.utils.stringifyJSON(pageAttributeVOList);
				}
			}
		}
		
		//打开页面控件选择页面
		function openComponentSelect(selectMode,objHtml){
			var propertyName = "";
			if(objHtml&&objHtml!=null&&objHtml!=""){
			 propertyName = objHtml.id;
			}
			var top=(window.screen.availHeight-600)/2;
			var left=(window.screen.availWidth-500)/2;
			window.open ('PageComponentSelect.jsp?pageId='+pageId+"&selectMode="+selectMode+"&propertyName="+propertyName,'pageComponentSelect','height=500,width=600,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
		}
		
		//导入控件
		function getSelectData(node,propertyName){
			var uiData=node.getData();
			var uiId="";
			if(uiData.options.id!=null){
				uiId=uiData.options.id;
			}else{
				uiId=uiData.id;
			}
			if(propertyName&&propertyName!=null&&propertyName!=""){
				scope.selectPageActionVO.methodOption[propertyName]=uiId
			}else{
				scope.selectPageActionVO.methodOption.relationGridId=uiId;	
			}
			cap.digestValue(scope);
		}
		
		//返回行为元数据
		function getActionList(type){
			var pageActions=scope.root.pageActions;
			var ar=[];
			for(var i=0;i<pageActions.length;i++){
				if(type!=null){
					for(var j=0;j<type.length;j++){
						if(pageActions[i].methodTemplate==type[j]){
							ar.push({id:pageActions[i].ename,text:pageActions[i].ename});
						}
					}
				}else{
					ar.push({id:pageActions[i].ename,text:pageActions[i].ename});
				}
			}
			return ar;
		}
		
		//行为英文名称校验对象
		var actionEnameValRule = [{'type':'required', 'rule': {'m':'行为英文名称不能为空'}},{'type':'custom', 'rule':{'against':'isExistActionEname', 'm':'行为英文名称已存在'}},{type:'format', rule:{pattern:'\^[A-Za-z_$][A-Za-z0-9_$]*\$', m:'由大小写英文字母、数字、_、$组成，且首字母不能为数字'}}];
		var actionCnameValRule = [{'type':'required', 'rule':{'m': '行为中文名称不能为空'}}];
		
		/**
		 * 行为英文名称是否重复检验
		 * @param ename 行为英文名称
		 */
		function isExistActionEname(ename) {
			var ret = true;
			//num=1表示当前值
			var num = 0;
			if (typeof (ename) == 'undefined') {
				ename = cui("#ename").getValue();
			}
			for ( var i in root.pageActions) {
				if (ename == root.pageActions[i].ename) {
					num++;
				}
				if (num > 1) {
					ret = false;
					break;
				}
			}
			return ret;
		}
		
		//统一校验函数
		function validateAll() {
			var validate = new cap.Validate();
			var valRule = {
				ename : actionEnameValRule,
				cname : actionCnameValRule
			};
			var result = validate.validateAllElement(root.pageActions, valRule, "&diams;行为列表->第【{value}】行：");
			return result;
		}
		
		var clip = new ZeroClipboard(document.getElementById("copyToClipboardBtn"));
		clip.on("copy",function(e){
			clip.setText(scope.selectPageActionVO.methodBody);
			cui.message('已成功复制到剪切板。', 'success');
		});
	</script>
</body>
</html>
