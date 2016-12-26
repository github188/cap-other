<!-- 
* 模块快速构建：代码生成（第四步）
* 2015-08-03 杨赛
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html lang="en" ng-app='codeGeneration'>
<head>
	<meta charset="UTF-8">
	<title>代码生成</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/NewPageAction.js'></top:script>
	<top:script src='/cap/dwr/interface/EntityOperateAction.js'></top:script>
	<top:script src='/cap/dwr/interface/WorkflowWorkbenchAction.js'></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<style type="text/css">
		.app_items{
			
		}
		.app_item{
			float:left;
		}
		.app_item li.first{
			float: left;
		    margin: 5px 0px 3px 5px;
		    background-color: #fff;
		    border: 0px ;
		    position: relative;
		    transition: all 0.8s cubic-bezier(0.175, 0.885, 0.32, 1);
		    padding: 4px 2px 5px 3px;
		    border-radius: 3px;
		    width:auto;
		}
		
		.app_item li.first:hover {
		  border: 0px solid #808080;
		  cursor: pointer;
		  background-color: #e5e5e5;
		}
		
		.app_item li.main {
		  float: left;
		  margin: 5px 5px 3px 0px;
		  background-color: #fff;
		  position: relative;
		  transition: all 0.8s cubic-bezier(0.175, 0.885, 0.32, 1);
		  padding: 3px;
		  border-radius: 3px;
		  width: 225px;
		  height: 22px;
		  white-space:nowrap;
		  }
		.app_item li.main:hover {
		  border: 1px solid #808080;
		  cursor: pointer;
		  background-color: #e5e5e5;
		}
		.app_item li.main:hover .colsebtn {
		  display: block;
		}
		
		.item_content {
			white-space:nowrap;
			text-overflow:ellipsis;
			overflow: hidden;
			height:30px;
		}
		
		.app_box{
			border: 0;
		}
		.app-category {
		  height: 20px;
		  border-left: 0px ;
		  padding-left: 10px;
		  margin: 3px 0;
		  cursor: pointer;
		  -webkit-user-select: none;
		  -moz-user-select: none;
		  -ms-user-select: none;
		  -o-user-select: none;
		  user-select: none;
		}
		.app_attr{
			padding: 5px;
			border: 1px solid #cccccc;
			background-color: #fff;
		    margin:0 0 10px 0;
		}
		
		.app-category .place-left em {
		    background-color: #03a41d;
		    color: #fff;
		    border-radius: 12px;
		    padding: 0px 7px;
		    margin: 0 0 0 5px;
		}
		
		.app-category .place-right {
		  float: right;
		  margin-right: 10px;
		  margin-top:5px;
		}
		
		.item_content img{
			float:left;
			margin-top:3px;
		}
	
	</style>
	<script type="text/javascript">
		//获得传递参数
		var modelId;
	    
	    //工作台配置生成相关参数 start
	  	//生成代码路径key 
	    var GEN_CODE_PATH_CNAME = "GEN_CODE_PATH_CNAME";
		//代码生成路径
	    var codePath= cui.utils.getCookie(GEN_CODE_PATH_CNAME);
	    var workflowWorkbenchVO = {"todo_url":"","done_url":"","processId":"","processName":"","processName":""};
		//工作台配置生成相关参数 end
		
		var entity = {};
	    var packageId;
	    var modelPackage;
		//页面
		var pageList = [];
		var selectedPage=[];
	    //当前操作实体关系对象
	    //拿到angularJS的scope
		 var scope=null;
		 var pageSession=null;
		 var entityDialog;
		 var genPagesResult={};
		 var parentWindow = cap.searchParentWindow("genPageJsonResult");
		//系统目录树的，应用模块编码
		var moduleCode = parentWindow["moduleCode"];
		 
		 var objHandleMask;
		 //生成遮罩层
		 function createCustomHM(type){
			 if(!objHandleMask){
				 objHandleMask = cui.handleMask({
					 html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在生成代码，预计需要2~3分钟，请耐心等待。</div>'
				 });
			 }
		 	 objHandleMask.show();
		 }
		 
		 angular.module('codeGeneration', ['cui']).controller('codeGenerationctrl', ['$scope', '$window',function($scope, $window, EntityServer, ComponentServer){
			// 获取父页面的pageSession
			 $scope.pageSession =pageSession;
			//参数定义
			 $scope.entity= entity;
			 $scope.pageList=pageList;
			 
			 //初始化方法
			$scope.ready=function(){
				pageSession =  $window.parent.pageSession;
				entity = pageSession.get("page_session_entity");
			 	init();
		    	comtop.UI.scan();
				scope=$scope;
		    	scope.entity = entity;
		    	scope.pageList = pageList;
			   	scope.packageId=packageId;
				scope.modelPackage=modelPackage;
		    };

			//编辑实体
			$scope.editEntityInfo=function(){
				//实体编辑URL
				var editEntityUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityMain.jsp?packageId=" + packageId+"&moduleCode="+moduleCode;
				editEntityUrl= editEntityUrl+"&modelId="+entity.modelId+"&entityType=biz_entity";
				window.open(editEntityUrl);
			};
			
			//编辑页面
			$scope.editPageInfo=function(index){
				//页面编辑URL
				var selectedPage = pageList[index]; 
				var editPageMainUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageMain.jsp?packageId=" + packageId;
				editPageMainUrl = editPageMainUrl+"&modelId="+selectedPage.modelId;
				window.open(editPageMainUrl);
			};
					 
		 	//生成代码
			$scope.generatCode=function(){
				
				createCustomHM("code");
				var messages = [];
				// var ePromise = generateEntityCode();
				// 先生成实体代码
				var pPromise = generateEntityCode().then(function (entityMessage) {
					messages.push(entityMessage);
					return $.when(generatePageCode(), saveWorkbench())
				}, function (failMessage) {
					messages.push(failMessage);
					return $.when(generatePageCode(), saveWorkbench())
				});

				pPromise.always(function (pageMessage, workInfoMessage) {
    				$window.objHandleMask.hide();
    				messages.push(pageMessage);
    				messages.push(workInfoMessage);
    				$window.top.cui.message(messages.join("<br/>"),'success');
    			});

    			// $.when(generateEntityCode(), generatePageCode(), saveWorkbench())
    			// .always(function (entityMessage, pageMessage, workInfoMessage) {
    			// 	$window.objHandleMask.hide();
    			// })
    			// .done(function(entityMessage, pageMessage, workInfoMessage){
    			// 	if(entityMessage || pageMessage) {
    			// 		var messages = [];
	    		// 		messages.push(entityMessage);
	    		// 		messages.push(pageMessage);
	    		// 		messages.push(workInfoMessage);
	    		// 		$window.top.cui.message(messages.join("<br/>"),'success');
    			// 	} else {
    			// 		$window.top.cui.alert("请选择要生成的实体或者页面。",'warn');
    			// 	}
    				
    			// })
    			// .fail(function(entityMessage, pageMessage, workInfoMessage){
    			// 	var messages = [];
    			// 	messages.push(entityMessage);
    			// 	messages.push(pageMessage);
    			// 	messages.push(workInfoMessage);
    			// 	$window.top.cui.message(messages.join("<br/>"),'error');
    			// });
    			
			};

			// 生成工作台配置
			function saveWorkbench() {
				if(entity.hasWorkInfo){
					var def = $.Deferred();
					WorkflowWorkbenchAction.saveAction(moduleCode,codePath,packageId,workflowWorkbenchVO, function(modelId) {
						if (modelId) {
							def.resolve("生成工作台配置成功。");
						} else {
							def.reject("生成工作台配置失败。");
						}
					});
					return def.promise();
    			}else{
    				return undefined;
    			}
			}

			// 生成实体
			function generateEntityCode() {
				if(entity.check){
					var def = $.Deferred();
					var type = 0;
					
		 			EntityOperateAction.executeGenerateCode([queryEntity()],packageId, type, function(msg){
						if (!msg){
							def.resolve("生成实体代码成功。");
						}else{
							def.resolve(msg);
						}
					});
					return def.promise();
		 		}else{
		 			return undefined;
		 		}
			}

			function queryEntity() {
		 		var re_entity;
				EntityFacade.loadEntity(entity.modelId, {
		    		callback:function (result) {
		    			re_entity = result;
		    		},
		    		async:false
		    	});
		    	return re_entity;
		 	}

			// 生成页面
			function generatePageCode() {
				var selectData = [];
				for(var i=0; i<pageList.length;i++){
					if(pageList[i].check){
						selectData.push(pageList[i].modelId);
					}
				}
				if(selectData.length > 0 ){
					var def = $.Deferred();
					NewPageAction.generateByIdList(selectData, modelPackage, function(result){
						if (!result){
							// window.top.cui.message('生成界面代码成功。','success');
							def.resolve('生成界面代码成功。');
						}else{
							// window.top.cui.message(result,'success');
							def.resolve(result);
						}
					});
					return def.promise();
				}else{
					return undefined;
				}
			}
			 
			 //完成
			 $scope.wizardEnd=function(){
			 	if(window.parent.parent.opener) {
			 		window.parent.parent.opener.location.reload();	
			 	} 
			 	window.parent.parent.close();
			 };
			 
		 }]);
		
		//初始化默认值
		function init(){
			entity.check = true;
		    packageId = entity.packageId;
		    modelPackage=entity.modelPackage;
			workflowWorkbenchVO.processId = entity.processId;
			workflowWorkbenchVO.processName=entity.processName;
			//初始化页面数组即需要生成的页面名称
		    if(parentWindow){
				var currentEntityModelId = parentWindow.scope.selectedEntity.modelId;
				genPagesResult = parentWindow["genPageJsonResult"][currentEntityModelId];
			}
			
			if(genPagesResult != null && genPagesResult.pageModelIds != null && genPagesResult.pageModelIds.length >0){
				var pageData =  eval(genPagesResult.pageModelIds);
				dwr.TOPEngine.setAsync(false);
		    	PageFacade.loadModelByModelId(pageData,function(data){
		    		if(data!=null){
		    			pageList = data;
		    			
		    			
		    			//获取页面名称,设置选中
		    			for(var i = 0; i < pageList.length; i++){
		    				var pagemodelId = pageList[i].modelId;
		    				var pageName = pagemodelId.substr(pagemodelId.lastIndexOf(".")+1,pagemodelId.length);
		    				pageList[i].pageName = pageName;
		    				pageList[i].check = true;
		    				if( _.endsWith(pagemodelId,"ToDoListPage")){
		    					workflowWorkbenchVO.todo_url=pageList[i].url;
		    				}
		    				if( _.endsWith(pagemodelId,"DoneListPage")){
		    					workflowWorkbenchVO.done_url=pageList[i].url;
		    				}
		    			}
		    			selectedPage = data;
		    		}
				});	
				dwr.TOPEngine.setAsync(true);
			}
		}
	</script>
</head>
<body style="margin:0px auto;padding:0px 10px 10px;" ng-controller="codeGenerationctrl"  data-ng-init="ready()">
<div style="text-align:right;padding:0px 10px;">
	<span cui_button id="nextStep" name="nextStep" label="生成代码" ng-click="generatCode()" ></span>
	<span cui_button id="wizardEnd" name="wizardEnd" label="完&nbsp;成" ng-click="wizardEnd()" ></span>
</div>
<div class="app_box">
	<div class="app_attr clearfix">
		<div class="app-category clearfix">
			<div class="place-left"><font color="">实体</font><em id="entityPanelCount">1</em></div>
		</div>
		<div class="app_items"  id="entityPanel">
			<div style="clear:both;" ></div> 
			<div class="app_items_content"  id="entityPanelArea">
				<ul>
					<li>
						<ul class="app_item">
							<li class="first">
								<input type="checkbox" name="entity" ng-model="entity.check">
							</li>
							<li class="main" target="_blank"  ng-click="editEntityInfo()" >
								<div class="item_content" >
									<img src="<%=request.getContextPath() %>\cap\ptc\index\image\biz_entity.png">
									<span>{{entity.engName}}</span>
								</div>
							</li>
						</ul>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<div class="app_attr clearfix">
		<div class="app-category clearfix">
			<div class="place-left"><font color="">界面</font><em id="pagePanelCount" >{{pageList.length}}</em></div>
		</div>
		<div class="app_items"  id="pagePanel">
			<div style="clear:both;" ></div> 
			<div class="app_items_content"  id="pagePanelArea">
				<span ng-repeat="pageInfo in pageList track by $index"  >
					<ul class="app_item">
							<li class="first">
								<input type="checkbox" name="{{'pageInfo'+($index + 1)}}" ng-model="pageInfo.check">
							</li>
							<li class="main" target="_blank" ng-click="editPageInfo($index);">
								<div class="item_content"  >
									<img src="<%=request.getContextPath() %>\cap\ptc\index\image\page.png">
									[页面]<span >{{pageInfo.pageName}}</span>
								</div>
						</li>
					</ul>
				</span>
			</div>
		</div>
	</div>
</div>
</body>
</html>
