<%
/**********************************************************************
* 控件属性编辑器页面
* 2015-5-13 诸焕辉
* 2015-08-20 凌晨  添加控件状态tab页
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='component'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>控件属性编辑器</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/designer/css/table-layout.css"/>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <style type="text/css">
    	.tab_panel{
    		overflow-x:hidden;
    	}
    	.form_table{
    		width: 242px;
    	}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
	<top:script src="/cap/bm/common/lodash/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cip_common.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
	<top:script src="/cap/bm/req/prototype/js/common.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/PreferencesFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/BuiltInActionPreferenceFacade.js"></top:script>
</head>
<body class="body_layout" ng-controller="componentCtrl" data-ng-init="ready()" style="overflow:hidden; background-color: {{layoutVOs.length > 0 ? '#e0ffff' : '#fff'}}">
	<div id="attr_area">
		<ul class="tab"> 
			<li ng-class="{'attr':'active'}[active]" class="notUnbind" ng-click="showPanel('attr')">属性</li>
			<li ng-class="{'action':'active'}[active]" class="notUnbind" ng-click="showPanel('action')">行为</li>
			<li ng-if="layoutVOs.length > 0"><a title="批量修改" style="cursor:pointer;" ng-click="batchSave()"><span class="cui-icon" style="font-size:12pt;color:#545454;">&#xf044;</span></a></li>
			<li ng-show="data.uitype != null" class="notUnbind help" ng-click="openHelpDoc()"><span title="{{data.uitype}}帮助文档">{{data.uitype}}</span></li>
		</ul>
		<div id="attr_area_panel" class="tab_panel" ng-style="componentlayout" ng-controller="propertiesCtrl" data-ng-init="ready()">
			<div id="tab_property" ng-show="active=='attr'" class="tab_property"></div>
			<div id="tab_event" ng-show="active=='action'" class="tab_event"></div>
		</div>
	</div>
	<script type="text/javascript">
	 	var namespaces = "<%=request.getParameter("namespaces")%>";
	 	var reqFunctionSubitemId = "<%=request.getParameter("reqFunctionSubitemId")%>";
	 	var pageSession = new cap.PageStorage(namespaces);
	 	var page = pageSession.get("page");
	 	var pageActions = pageSession.get("action");
	 	//公用开发建模代码，变量做冗余
	    var pageId = namespaces, packageId = namespaces;
	 	var modelPackage = page.modelPackage;
	 	var pageActions = pageSession.get("action");
	    var root={};
	    var type = "<c:out value='${param.type}'/>";  // 
	    type = type == "" ? 'dev' : type;

	    //监听变量变化后自动保存
	    function watchPageActions(){
	    	cap.addObserve(pageActions, watchPageActions);
	    	messageHandle4PageAction();
	    	cap.digestValue(scope);
    	}
	    cap.addObserve(pageActions, watchPageActions); 
	    
		function safeDigest(){
			var phase = scope.$root.$$phase;
		    if (phase == '$apply' || phase == '$digest') {
		    } else {
		    	scope.$digest();
		    }
		}
		
		//获取内置行为方法
	    function queryBuiltInActionList(){
	    	var builtInActionList = [];
	    	var page = pageSession.get("page");
			var includeFileList = page.includeFileList;
			var filePaths=[];
			for(var i=0;i<includeFileList.length;i++){
				if(includeFileList[i].fileType === 'js'){
					filePaths.push(includeFileList[i].filePath);
				}
			}
			dwr.TOPEngine.setAsync(false);
			BuiltInActionPreferenceFacade.queryListByFileName(filePaths,function(data){
    			if(data!=null){
    				builtInActionList = data;
    			}
    		});	
    		dwr.TOPEngine.setAsync(true);
    		return builtInActionList;
	    }
		
	    var queryBuiltInAction = new cap.CollectionUtil(queryBuiltInActionList());

		//存储从cui服务上获取的校验信息
		var cuiServerValidationInfo = {};
		var scope = {};
		var compile = {};
		angular.module('component', ["cui"]).controller('componentCtrl', function ($scope, $compile) {
			$scope.layoutVO = {};
			$scope.layoutVOs = [];
			$scope.component = {};
	    	$scope.propertiesMap;
	    	$scope.eventsMap;
	    	$scope.data = {};
	    	$scope.batchEditProperties = {};
	    	$scope.hasLoadComponent = false;
	    	//默认显示属性tab标签
	    	$scope.active='attr';
	    	$scope.componentlayout = {"height":"auto","overflow-y": "auto"};
	    	$scope.hasHideNotCommonProperties = true;
	    	$scope.hasHideNotCommonEvents = true;
	    	$scope.root=root;
	    	$scope.ready=function(){
	    		scope=$scope;
	    		compile=$compile;
		    	comtop.UI.scan();
		    	//页面初始化，原来组件依赖的相关js需要加载进来
		    	initDesignerJs();
		    	getCUIServerTokenData();
		    	//页面初始化时，未选中任何控件，把几个tab页初始化出未选中任何控件的提示。
				if(currentSelectUI.length < 1){
					tip(noUISelectTipMsg);
				}
		    }
	    	
	    	//切换Tab标签
	    	$scope.showPanel=function(msg){
	    		$scope.active=msg;
	    	}
	    	
	    	//帮助文档
	    	$scope.openHelpDoc=function(){
	    		var componentModelId = null;
	    		if(_.has(scope.layoutVO, "componentModelId")){
	    			componentModelId = _.get(scope.layoutVO, "componentModelId")
	    		} else if(scope.layoutVOs.length > 0){
	    			componentModelId = _.find(scope.layoutVOs, 'componentModelId').componentModelId;
	    		}
	    		var objComponentVO = scope.component;
	    		if(objComponentVO.helpDocUrl&&objComponentVO.helpDocUrl!=null){
	    			var url = "${pageScope.cuiWebRoot}" + objComponentVO.helpDocUrl;
	    			window.open(url); 
	    			return ;
	    		}
	    		
	    		if(hasAllowRequestsCUIServer()){
	    			if($scope.data.uitype){
	    				openWin(CUIServerPath + "/CUI/api/index.html?timestamp="+new Date().getTime()+"#"+$scope.data.uitype, "helpDocument", "");
		    		}
	    		} else {
	    			if(componentModelId){
	    				openWin("${pageScope.cuiWebRoot}/cap/bm/dev/page/uilibrary/HelpDocument.jsp?componentModelId="+componentModelId, "helpDocument", "");
		    		} 
	    		}
	    	}
	    	
	    	$scope.$watch("data", function(newValue, oldValue){
	    		if($scope.layoutVOs.length == 0 && !$scope.hasLoadComponent
	    				&& !_.isEqual(newValue, oldValue)){
	    			if((newValue.uitype === 'Grid' || newValue.uitype === 'EditableGrid')
	    					&& oldValue.selectrows != newValue.selectrows 
	    					&& newValue.columns != ''){
		    			updateColumnsBySelectrows(newValue, newValue.selectrows);
		    		} 
	    			$scope.postMessage2Parent(newValue);
	    		}
	    	}, true);
	    	
	    	$scope.postMessage2Parent=function(data){
	    		var options = jQuery.extend(true, {}, data);
	    		//过滤属性值为空或null的属性
	    		$scope.filterData(options);
	    		//根据控件属性类型，值类型转换
    			dataTypeConversion(options, $scope.propertiesMap);
	    		//获取options对象版
    			var objectOptions = wrapperObjectOptions(options2ObjectOptions(options, $scope.propertiesMap), scope.data.uitype);
	    		//过滤objectOptions对象版属性值
    			filterObjectOptionsByRule(objectOptions, $scope.component);
    			$scope.layoutVO.objectOptions = objectOptions;
				$scope.layoutVO.options = options;
		        if(window.parent){
		        	window.parent.postMessage({action:"dataChange", data:$scope.layoutVO}, "*");
		        } 
	    	}

	    	//剔除属性值为空或null的值
	    	$scope.filterData=function(obj){
	    		for(var key in obj){
    				if(obj[key] === null || obj[key] === '' || typeof(obj[key]) === 'function' 
    						|| obj[key] === 'null'){
    					delete obj[key];
    				}
	    		}
	    	}
	    	
	    	//切换展现非常用属性开关
	    	$scope.switchHideArea=function(flag){
	    		if(window.frameElement){
	    			window.parent.switchHideArea && window.parent.switchHideArea($scope[flag]);
	    			$scope.componentlayout = {"height":window.frameElement.offsetHeight-42, "overflow-y": "auto"};
	    		}
	    		$scope[flag] = !$scope[flag];
	    	}
	    	
	    	//打开行为选择页面
		    $scope.openSelectAction=function(obj){
	    	   var node = cui('#'+obj).options;
	    	   var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionSelect.jsp?modelId='+pageId+'&packageId='+packageId+"&flag="+obj+"&methodTemplate="+node.methodtemplate+"&actionType="+node.actiontype+'&type='+type;
			   var width=800; //窗口宽度
			   var height=650;//窗口高度
			   var top=(window.screen.height-30-height)/2;
			   var left=(window.screen.width-10-width)/2;
			   window.open(url, "pageActionSelect", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
			   
			   if($scope.layoutVOs.length > 0){
				   $scope.batchEditProperties[obj] = true;
			   }
		    }
	    	
		    //点击属性控件，联动选中对应的复选框(批量操作)
	    	$scope.clickEvent=function(ename){
	    		$scope.batchEditProperties[ename] = true;
	    	}
		    
		    //批量修改属性确认事件
	    	$scope.batchSave=function(){
	    		if(window.parent){
		    		var commoneData = {};
		    		var text = '';
		    		for(var key in $scope.batchEditProperties){
		    			if($scope.batchEditProperties[key] != null && $scope.batchEditProperties[key] === true){
			    			text += key + '：' + $scope.data[key] + '<br/>';
			    			commoneData[key] = $scope.data[key];
		    			} 
		    		}
		    		if(text != ''){
		    			text = '<strong>确定要修改以下属性</strong><br/>' + text;
		    			window.parent.parent.cui.confirm(text,{
							onYes:function(){
					    		//根据控件属性类型，值类型转换
				    			dataTypeConversion(commoneData, $scope.propertiesMap);
					    		//获取options对象版
				    			var commoneObjOptions = options2ObjectOptions(commoneData, $scope.propertiesMap);
					    		//过滤objectOptions对象版属性值
				    			filterObjectOptionsByRule(commoneObjOptions, $scope.component);
					    		for(var i in $scope.layoutVOs){
					    			var options = jQuery.extend(true, $scope.layoutVOs[i].options, commoneData);
		    						var objectOptions = jQuery.extend(true, $scope.layoutVOs[i].objectOptions, commoneObjOptions);
					    			$scope.filterData(options);
					    			$scope.filterData(objectOptions);
					    			$scope.layoutVOs[i].options = options;
					    			$scope.layoutVOs[i].objectOptions = objectOptions;
							        window.parent.postMessage({action:"dataChange", data:$scope.layoutVOs[i]}, "*");
					    		}
								window.parent.cui.message('批量修改成功！', 'success');
							}
						});
		    		} else {
		    			window.parent.parent.cui.alert('请选择需要修改的属性。');
		    		}
	    		}
	    	}
		    
		    //加载控件状态模板以及解析dom
		    $scope.compileStateTmpl=function(){
				$('#tab_state').html(new jCT($('#stateEditTmpl').html()).Build().GetView()); 
	        	compile($('#tab_state').contents())(scope);
	        	if(!$scope.$$phase) {
	        		$scope.$digest();
	        	}
		    }
		   
		}).controller('propertiesCtrl', function ($scope, $compile, $timeout) {
    		$scope.data = scope.data;
	    	$scope.ready = function(){
	    		if((scope.data.uitype === 'ChooseUser' || scope.data.uitype === 'ChooseOrg') 
		    			&& scope.data.chooseMode != null){//针对值不在pulldown数据源内的值处理
		    		var chooseMode = scope.data.chooseMode;
		    		setTimeout(function () {
		    			var propertyVo = _.find(scope.component.properties,{ename: 'chooseMode'});
		    			var id = eval("("+propertyVo.propertyEditorUI.script+")").id;
		    			if(cui("#"+id).selectData == null){
		    				cui("#"+id).$text[0].value = chooseMode;
		    				cui("#"+id).setValue(chooseMode);
		    			}
		    		}, 0);
		    	}
	    		comtop.UI.scan();
	    	}
	    	
		});
		
		//定义一个没有选中任何控件的提示信息。
		var noUISelectTipMsg="提示：未选中任何控件。"
		var notSupportBatchOperate = "提示：控件状态不支持批量操作。";
		var haveNotAnyState = '提示：暂无控件状态。';
		var notSupBatchOperate4DiffUI = '提示：控件类型不一致，不能执行批量操作。';
		var notSupportAttrEditOperate = '提示：目前该控件属性不支持编辑操作。';
		
		//选中的行为数据回调
		function selectPageActionData(objAction,flag){
			//获取方法名称
			var actionEname = objAction.ename;
			cui('#'+flag).setValue(actionEname);
			var actionId = flag + "_id";
			scope.data[actionId] = objAction.pageActionId;
			safeDigest();
		}
		
		//选中的行为数据回调
		function cleanSelectPageActionData(flag){
			scope.data[flag] = '';
	    	delete scope.data[flag+"_id"];
	    	safeDigest();
		}
		
		var currentUIHasProp = false;
		var currentUIHasEvents = false;
		
		/**
		 * 获取控件属性
		 * @param componentModelId 控件定义模型的唯一ID
		 * @param options 控件属性对象
		 */
		function loadModelComponent(componentModelId, options){
			scope.component = getComponentByModelId(componentModelId, window.parent.toolsdata);
			propertyClassification(options);
			eventClassification(options);
			loadModelComponentDesignerjs(scope.component);
		}
		
		//页面初始化，原来组件依赖的相关js需要加载进来
	    function initDesignerJs(){
		   var uiData= window.parent._cdata.getUIData();
	 	   for(var i in uiData){
	 		  var componentVo = getComponentByModelId(uiData[i].componentModelId, window.parent.toolsdata);
	 		  loadModelComponentDesignerjs(componentVo);
	 	   }
	    }
		
		//加载组件设计时需要的js
		function loadModelComponentDesignerjs(component){
			if(component&&component.designerjs){
			    for(var y=0;y<component.designerjs.length;y++){
			    	try{
			    	$("<script type = 'text/javascript' src='${pageScope.cuiWebRoot}"+component.designerjs[y] + "'><\/script>").appendTo("head");  //动态加载	
			    	}catch(e){
			    		console.log("designerjs src:"+component.designerjs[y]+" not exist");
			    	}
			    }
			}
		}
		
		/**
		 * 属性分类
		 * @param options 数据属性对象
		 */
		function propertyClassification(options){
			scope.propertiesMap = new HashMap();
			//常用属性
			scope.component.commonProperties = [];
			//非常用属性
			scope.component.notCommonProperties = [];
			var properties = scope.component.properties;
			properties = _.sortBy(_.filter(properties, function (chr){ return (chr.hasBatchEdit == null || chr.hasBatchEdit == true)}), function(n){return n.commonAttr === false});
			//当前控件是否有属性
			currentUIHasProp = properties.length > 0 ? true :false;
			
			for(var i in properties){
				scope.propertiesMap.put(properties[i].ename, properties[i]);
				var script = eval("("+properties[i].propertyEditorUI.script+")");
				var key = script.name;
				if(options[key] != null){
					options[key] = options[key] + '';
				}
				if(properties[i].hide == true){
					continue;
				}
				if(scope.component.commonProperties.length <= 5){//前五个
					scope.component.commonProperties.push(properties[i]);
				} else {
					scope.component.notCommonProperties.push(properties[i]);
				}
			}
		}
		
		/**
		 * 事件分类
		 * @param options 数据属性对象
		 */
		function eventClassification(options){
			scope.eventsMap = new HashMap();
			//常用行为
			scope.component.commonEvents = [];
			//非常用行为
			scope.component.notCommonEvents = [];
			var events = scope.component.events;
			events = _.filter(events, function (chr){ return (chr.hasBatchEdit == null || chr.hasBatchEdit == true) });
			//当前控件是否有属性
			currentUIHasEvents = events.length > 0 ? true :false;
			for(var i in events){
				scope.eventsMap.put(events[i].ename, events[i]);
				if(events[i].hide == true){
					continue;
				}
				if(scope.component.commonEvents.length < 5){//前五个
					scope.component.commonEvents.push(events[i]);
				} else {
					scope.component.notCommonEvents.push(events[i]);
				}
			}
		}
		
		//加载模版以及解析dom
		function compileTmpl(){
			if(_.size(scope.layoutVO) == 0 && scope.layoutVOs.length == 0){
				//先销毁所有验证规则
				cap.validater.destroy();
			};
			$('#tab_property').empty();
			$('#tab_event').empty();
			var operationMode = scope.layoutVOs.length > 0 ? 'Batch' : '';
			if(currentUIHasProp){
				$('#tab_property').html(new jCT($('#properties'+operationMode+'EditTmpl').html()).Build().GetView()); 
			}else{
				$('#tab_property').html('<div style="padding:20px; color:#ccc">提示：暂无控件属性</div>'); 
			}
			if(currentUIHasEvents){
	        	$('#tab_event').html(new jCT($('#event'+operationMode+'EditTmpl').html()).Build().GetView()); 
			}else{
				$('#tab_event').html('<div style="padding:20px; color:#ccc">提示：暂无控件行为</div>');
			}
			//切换多属性tab面板
			scope.active = 'attr';
			safeDigest();//编译前必须执行一次脏值检查，否则父作用域和子作用域同时执行脏值检查（scope.data）会导致数据错乱
			compile($('#attr_area_panel'))(scope);
        	scope.hasHideNotCommonProperties = true;
	    	scope.hasHideNotCommonEvents = true;
 	    	$(".tab_panel td").css("background-color", scope.layoutVOs.length > 0 ? "#e0ffff" : "#fff");
		}

	    /**
		 * 取消行为事件
		 * @param obj 当前dom节点
		 */
	    function clearEvent(obj){
	    	scope.data[obj] = '';
	    	delete scope.data[obj+"_id"];
	    	safeDigest();
	    }
	    
	     //直接新增行为
    	function openAddAction(obj){
    		 var node = cui('#'+obj).options;
    		 var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionEdit.jsp?modelId='+pageId+'&packageId='+packageId+"&flag="+obj+"&operationType=insert&methodTemplate="+node.methodtemplate+"&actionType="+node.actionType+'&type='+type;;
			 var width=850; //窗口宽度
			 var height=650;//窗口高度
			 var top=(window.screen.height-30-height)/2;
			 var left=(window.screen.width-10-width)/2;
			 window.open(url, "pageActionEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
    	}
	     
	     //编辑行为
	    function openEditAction(obj){
	    	 var actionValue = cui('#'+obj).getValue();
	    	 if(actionValue==""){
	    		 return;
	    	 }
	    	 var node = cui('#'+obj).options;
	    	 var pageActionId = scope.data[obj+"_id"];
	    	 if(pageActionId == actionValue){
	    		 return;
	    	 }
	    	 var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionEdit.jsp?modelId='+pageId+'&packageId='+packageId+"&flag="+obj+"&operationType=edit&methodTemplate="+node.methodtemplate+"&actionType="+node.actionType+"&selectActionId="+pageActionId+'&type='+type;;
			 var width=850; //窗口宽度
			 var height=650;//窗口高度
			 var top=(window.screen.height-30-height)/2;
			 var left=(window.screen.width-10-width)/2;
			 window.open(url, "pageActionEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	    }

		/**
		 * 给databind属性赋值
		 * @param propertyName 属性名称
		 * @param propertyValue 属性值
		 */
		function attributeNameCallback(attributeName){
			cui("#databind").setValue(attributeName);
		}
		
	    /**
		 * 自定义扩展属性,json对象字符串存储
		 * @param propertyName 属性名称
		 * @param propertyValue 属性值
		 */
		function customExtras(propertyName, propertyValue){
			if(arguments.length == 2){
				extras = cui("#extras").getValue();
				if(extras != ""){
					extras = JSON.parse(extras);
					extras[propertyName] = propertyValue;
				} else{
					extras = {};
					extras[propertyName] = propertyValue;
				}
				cui("#extras").setValue(JSON.stringify(extras));
			}
		}
	    
		//ui控件所有ID属性值，用于校验
		var existComponentIds;
		
		/**
		 * 获取其他所有控件id值（注：后期把id遍历实现移到PageDesigner页面下，控件属性编辑页面不在处理遍历操作）
		 * @param currIdVal 当前ID值
		 */
		function getOtherUIcomponentId(currIdVal){
			existComponentIds = [];
			var uiData = window.parent._cdata.getUIData();
			var repeatNum = 0;
			for(var i in uiData){
				var id = uiData[i].options.id;
				if(typeof(id) != 'undefined'){
					if(id != currIdVal || repeatNum == 1){
						existComponentIds.push(id);
					} else {
						repeatNum++;
					}
				}
			}
		}
		
		//是否要检查所有控件的Id是否重复
		var hasCheckRepeatId = false;
		
		/**
		 * id值是否存在校验
		 * @param newIdVal 当前输入的ID值
		 */
		function isExistComponentId(newIdVal){
			var ret = true;
			if(hasCheckRepeatId){
				var index = _.indexOf(existComponentIds, newIdVal);
		    	var lastIndexOf = _.lastIndexOf(existComponentIds, newIdVal);
		    	ret = index == lastIndexOf ? true : false
			} else {
				ret = _.indexOf(existComponentIds, newIdVal) > 0 ? false : true;
			}
	    	return ret;
		}
		
		//存储设计器页面当前选择的控件的id
		var currentSelectUI=[];
		/**
		 * 接收消息回调方法
		 * @param e 回调数据
		 */
		function messageHandle(e) {
	    	if(e.data.type === 'pageDesigner'){
	    		messageHandle4PageDesigner(e);
	    		//当前选择的控件的id的数组
	    		currentSelectUI = _.uniq(e.data.id);
	    	} else if(e.data.type === 'pagePreferenceFileChange'){
	    		messageHandle4PagePreferenceFile();
	    	}
	    }
		
		/**
		 * 监听设计器事件回调方法
		 * @param e 回调数据
		 */
	    function messageHandle4PageDesigner(e){
	    	scope.hasLoadComponent = true;
	    	scope.layoutVO = {};
	    	scope.layoutVOs = [];
	    	scope.batchEditProperties = {};
	    	var id = _.uniq(e.data.id);
	    	var len = id.length;
	    	if(len == 1){
	    		singleComponentHandle(id[0]);
	    	} else if(len > 1){
		    	batchComponentHandle(id);
	    	} else {
	    		tip(noUISelectTipMsg);
	    	}
        	safeDigest();
	    	scope.hasLoadComponent = false;
	    }
		
		function tip(text){
			var tipNode = '<div style="padding:20px; color:#ccc">'+text+'</div>';
			$('#tab_property').html(tipNode); 
        	$('#tab_event').html(tipNode);
        	if(scope.data){
        		scope.data.uitype = '';
        	}
		}
		
	    /**
		 * 编辑单个控件属性
		 * @param id 控件id
		 */
		function singleComponentHandle(id){
			scope.layoutVO = window.parent._cdata.getTransformData(id);
			if(scope.layoutVO != null && scope.layoutVO != ''){
				var componentModelId = scope.layoutVO.componentModelId;
				if(componentModelId != null){
					var options = jQuery.extend(true, {}, scope.layoutVO.options);
					//获取其他ui控件id,用于校验当前控件id值
					getOtherUIcomponentId(options.id);
					//重置options属性；属性封装在scope.propertiesMap对象中；行为属性封装在scope.eventsMap对象中
					loadModelComponent(componentModelId, options);
					scope.data = options;
					compileTmpl();
				} else {
					tip(notSupportAttrEditOperate);
				}
			}
		}
	    
		/**
		 * 编辑批量控件属性
		 * @param ids 控件id集合
		 */
		function batchComponentHandle(ids){
			var ret = hasComponentsSameType(ids);
			if(ret){
				loadModelComponent(scope.layoutVOs[0].componentModelId, {});
				var commonPropertyVo = commonValue(scope.component.properties, scope.layoutVOs);
				var commonActionVo = commonValue(scope.component.events, scope.layoutVOs);
				scope.data = jQuery.extend(true, commonPropertyVo, commonActionVo);
				compileTmpl();
			} else {
				tip(notSupBatchOperate4DiffUI);
			}
		}
		
		/**
		 * 是否同一类控件(针对批量处理)
		 * @param ids 控件id集合
		 */
		function hasComponentsSameType(ids){
			var ret = true;
			var firstLayoutVO = window.parent._cdata.getTransformData(ids[0]);
			var uitype = firstLayoutVO.options.uitype;
			if(uitype != null){
				scope.layoutVOs.push(firstLayoutVO);
				for(var i=1, len=ids.length; i<len; i++){
					var nextLayoutVO = window.parent._cdata.getTransformData(ids[i]);
					if(uitype === nextLayoutVO.options.uitype){
						scope.layoutVOs.push(nextLayoutVO);
					} else {
						scope.layoutVOs = [];
						ret = false;
						break;
					}
				}
			} else {
				ret = false;
			}
			return ret;
		}
		
	    /**
		 * 根据行为模版，获取行为函数
		 * @param searchField 查询字段
		 * @param q 查询数据集
		 */
	    function getDataSourceByActionTmp(methodTemplate, q){
	    	var dataSource = [];
	    	var result = q.query("this.methodTemplate=='"+methodTemplate+"'");
	    	for(var i in result){
		    	dataSource.push({id:result[i].pageActionId,text:result[i].ename});
		    }
		    return dataSource;
	    }
	    
	    /**
		 * 根据行为类型，获取行为函数
		 * @param searchField 查询字段
		 * @param q 查询数据集
		 */
	    function getDataSourceByActionType(searchField, actionType, q){
	    	var dataSource = [];
	    	var result = q.query("this."+searchField+"=='"+actionType+"'");
	    	if(searchField === 'type'){
		    	for(var i in result){
			    	dataSource.push({id:result[i].actionMethodName,text:result[i].actionMethodName});
			    }
		    } else if(searchField === 'actionDefineVO.type'){
		    	for(var i in result){
			    	dataSource.push({id:result[i].pageActionId,text:result[i].ename});
			    }
		    }
		    return dataSource;
	    }
		
		window.addEventListener("message", messageHandle, false);
		
		//是否是可标识区域类型的控件
		function hasIdentifyAreaComponent(uitype){
			return uitype === 'EditableGrid' || uitype === 'Grid' || uitype === 'formLayout';
		}
		
		//统一校验
		function validateAll(){
			hasCheckRepeatId = true;
			var validate = new cap.Validate();
			var result = {validFlag: true, message: ''}; 
			var uiData = window.parent._cdata.getUIData();
			var componentValidRuleList = getAllComponentValidRule();
	 	    for(var i in uiData){
	 	    	var options = uiData[i].options;
			    var validDataList = _.get(componentValidRuleList, uiData[i].componentModelId);
			    if(!$.isEmptyObject(validDataList)){
			    	var name = options.label != '' ? options.label : options.name != '' ? options.name : options.id != '' ? options.id : uiData[i].id;
			    	_.forEach(validDataList, function (value, key) {
			    		var validData = eval(value);
			    		var required = _.find(validData, {type: 'required'});
			    		if(options[key]){
			    			var valRule = {};
			    			valRule[key] = validData;
			    	    	validateResult = validate.validateAllElement(options, valRule);
			    	    	result.validFlag = result.validFlag && validateResult.validFlag;
			    			if(!validateResult.validFlag){
			    				result.message += "&diams;【" + name + "】控件“"+key+"”属性" + validateResult.message + "<br/>";
			    			}
			    		} else if(required){
			    			result.validFlag = false;
			    			result.message += "&diams;【" + name + "】控件“"+key+"”属性" + required.rule.m + "<br/>";
			    		}
				    });
			    }
	 		}
	 	    hasCheckRepeatId = false;
			return result;
		}
		
		//所有控件校验规则
		function getAllComponentValidRule(){
			var result = [];
			dwr.TOPEngine.setAsync(false);
 		    ComponentFacade.queryAllComponentValidRule(function(_result){
 		    	result = _result;
 		    });
 		    dwr.TOPEngine.setAsync(true);
 		    return result;
		}
		
		/**
		 * 在新窗口打开页面（浏览器中只打开一次）
		 * @param 目标页面
		 */
        function openWin(url, winName, winAttrs) { 
            objWin = window.open("",  winName, winAttrs);
			//判断是否打开 (在新窗口打开页面（浏览器中只打开一次）)
            if (objWin.location.href === "about:blank") {//窗口不存在
            	objWin = window.open(url, winName, winAttrs); 
            } else {//窗口以已经存在了
            	objWin.location.replace(url, winName, winAttrs); 
            } 
            objWin.focus(); 
            
        }
		
		//判断是否可以链接到本地CUI帮助手册页面
		function hasAllowRequestsCUIServer() {
			return cuiServerValidationInfo.status == 200 && _.findIndex(cuiServerValidationInfo.data, function(value){ return value == scope.data.uitype}) > -1 ? true : false;
		}
		
		//获取CUI发布服务地址
		function getCUIServerPath(){
			var ret = null;
			dwr.TOPEngine.setAsync(false);
			PreferencesFacade.getConfig('cuiServerURLPath',function(data){
    			if(data!=null){
    				ret = data != null ? data.configValue : null;
    			}
    		});	
    		dwr.TOPEngine.setAsync(true);
    		return ret;
		}
		
		//获取cui服务校验信息
		function getCUIServerTokenData(){
			if(typeof CUIServerPath === 'undefined'){
				CUIServerPath = getCUIServerPath();
			}
			$.ajax({
	            url: CUIServerPath + '/ajax_roots.json',
	            dataType: 'jsonp',
	            jsonpCallback:"datas",
	            statusCode: {404: function() { 
	                	console.log("请检查CUI服务是否部署以及是否部署正确，如果部署了，请在CAP建模应用下配置CUI发布服务地址（path：首选项配置->常规配置->CUI发布服务地址）！（注：1、CUI服务部署方式必须是应用服务器的根目录；2、如果未配置CUI服务地址，查看CUI控件帮助信息将是控件元数据中配置的帮助信息；）"); 
	            	}
				}, 
	            success: function (data) {
	            	cuiServerValidationInfo = data;
	            },
	            error: function(XMLHttpRequest, textStatus, errorThrown) {
	            	cuiServerValidationInfo = {status: 500};
	            }
	        });
			
		}
		
		//对特殊控件进行特殊处理
		function wrapperObjectOptions(objectOptions, uitype){
			if(uitype === 'Borderlayout' && objectOptions.items){
				_.forEach(objectOptions.items, function (data, key) {
					delete data.url;
				});
			}
			return objectOptions;
		}
		
		/**
		 * 监听行为变更事件回调方法
		 * @param e 回调数据
		 */
	    function messageHandle4PageAction(){
	    	queryPageAction = new cap.CollectionUtil(pageActions);
	    	updateAllEventValue();
	    	safeDigest();
	    }
	    
	    //行为模块有修改时，需更新设计控件对应的绑定行为值
	    function updateAllEventValue(){
	    	//当前控件
	    	var events = scope.component.events;
		 	for(var i in events){
		 		var dataSource = initDataSource(events[i].methodTemplate, events[i].type);
		 		var nodeName = events[i].ename;
		 		var actionNode = cui('#'+events[i].ename);
		 		if(actionValue != ""&&actionValue != null){
			 		var actionValue = actionNode.getValue();
		 			var pageActionId = scope.data[nodeName+"_id"];
		 			var q = new cap.CollectionUtil(dataSource);
					//是否已存在
			 		var selectedData = q.query("this.id=='"+pageActionId+"'");

			 		if(selectedData != null && selectedData.length > 0){
		 				actionNode.setValue(selectedData[0].text);
		 			}
		 		}
			}
		 	//设计器上画好的其他控件
		 	if(queryPageAction != null){
		    	setTimeout(refreshUIData, 1);//异步刷新即可
		 	}
	    }
	    
	    /**
		 * 初始化行为
		 * @param methodtemplate 行为模版类型
		 * @param actionType 行为类型
		 */
	    function initDataSource(methodtemplate, actionType){
			var dataSource = [];
	    	var dataSource4built = getDataSourceByActionType('type', actionType, queryBuiltInAction);
	    	var dataSource4define = getDataSourceByActionType('actionDefineVO.type', actionType, queryPageAction);
	    	var dataSource4template = getDataSourceByActionTmp(methodtemplate, queryPageAction);
	    	//合并
	    	dataSource = _.union(dataSource4template, dataSource4built, dataSource4define);
	    	//过滤重复项
	    	_.uniq(dataSource, "id");
			return dataSource;
	    }
	    
	  	//行为信息变更，刷新UI控件绑定的属性行为
	    function refreshUIData(){
	   	    var uiData= window.parent._cdata.getUIData();
	 	    for(var i in uiData){
	 		   var componentVo = getComponentByModelId(uiData[i].componentModelId, window.parent.toolsdata);
	 		   var events = (componentVo != null && componentVo.events != null) ? componentVo.events : [];
	 		   for(var j in events){
	 			   var ename = events[j].ename;
	 			   var pageActionId = uiData[i].options[ename+"_id"];
	 			   var result = queryPageAction.query("this.pageActionId=='"+pageActionId+"'");
				   if(result.length > 0){
					   uiData[i].options[ename] = result[0].ename;
					   window.parent._cdata.update(uiData[i]);
				   }
	 			}
	 		}
	    }
	</script>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/EventsEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/StateEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesBatchEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/EventsBatchEditTmpl.jsp" %>
	<top:script src="/cap/bm/dev/page/uilibrary/js/selectDataModel.js"></top:script>
	<top:script src="/cap/bm/req/prototype/design/uilibrary/js/selectDataModel.js"></top:script>
</body>
</html>
