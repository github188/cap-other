<!-- 
* 模块快速构建：实体信息编辑（第一步）
* 2015-08-03 杨赛
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='entityEditForWizard'>
<head>
<meta charset="UTF-8"/>
<title>实体信息编辑</title>
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
	<top:script src='/cap/bm/dev/wizard/js/entityRelationWatcher.js'></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<script type="text/javascript">
	//获得传递参数
	var modelId;
    var packageId;
    var modelPackage;
    //系统目录树的，应用模块编码
    var moduleCode = window.parent.moduleCode;
    
    //工作台配置生成相关参数 start
	//代码生成路径
	var codePath="";
    var workflowWorkbenchVO = {"done_url":"","processId":"","processName":"","processName":""};
	//工作台配置生成相关参数 end
	
	var entity = {};
    //源实体属性初始化数据
    var entityAttributes = [];//= entity.attributes==null?[]:entity.attributes;
    var initData; 
    //当前操作实体关系对象
    var selectedRelationVO ={};
    //拿到angularJS的scope
	 var scope=null;
	 var entityDialog;
	 angular.module('entityEditForWizard', ['cui']).
	 controller('entityEditForWizardCtrl', ['$scope', '$window',function($scope, $window){
		
			// 获取父页面的pageSession
			var pageSession = $window.parent.pageSession;
			 //参数定义
			$scope.entity = pageSession.get("page_session_entity");
			$scope.selectedRelationVO = selectedRelationVO;
			entity = pageSession.get("page_session_entity");
			var relationWatcher;
			//初始化方法
			$scope.ready=function(){
		    	initDefaultValue();
		    	initProcessName();
		    	comtop.UI.scan();
				scope=$scope;
				scope.entity = entity;
		    	//控制关联流程的显示
				if(checkparentEntityIsProcess($scope.entity.parentEntityId)){
					$scope.showProcess=true;
				}else{
					$scope.showProcess=false;
				}
				//第一个关系为多对多时，初始化中间对象的目标属性
		   		if($scope.entity.multiple=="Many-Many"){
			   		var entitymodelId = $scope.entity.associateEntityId;
					  dwr.TOPEngine.setAsync(false);
					   EntityFacade.loadEntity(entitymodelId,"",function(entity){
						   initData = getBaseEntityAttributes(entity.attributes);
					   });
					dwr.TOPEngine.setAsync(true);
		   		}

		   		relationWatcher = new RelationWatcher(entity);
		    }
			
			//选择父实体弹出窗口
			$scope.selParentEntity=function(){
				packageId = scope.entity.packageId;
				var parentEntityId=scope.entity.parentEntityId;
				var selfEntityId = scope.entity.modelId;
				var url = "<%=request.getContextPath() %>/cap/bm/dev/entity/SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=false&sourceEntityId="+parentEntityId+"&selfEntityId="+selfEntityId+"&operateNodeDisable=true";
				var title="选择目标实体";
				var height = 600; //600
				var width =  400; // 680;
				
				entityDialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
				entityDialog.show(url);
			}
			
			//选择工作流
			$scope.selProcess=function(){
				var callfrom = "entityWizard";
				var url = "<%=request.getContextPath() %>/cap/bm/dev/entity/WorkFlowSelection.jsp?dirCode="+moduleCode+"&callfrom="+callfrom;
				var title="选择流程";
				var height = 600;
				var width =  680;
				var newWin = window.open(url,'selectWorkflow','left=350,top=200,scrollbars=auto,resizable=yes,width=800,height=650');
				newWin.focus();
	 		}
			
			//新增关联关系
			$scope.addRelation=function(){
				var objRelation = {"associateEntityId":"","associateSourceField":"","associateTargetField":"","chName":"","description":"",
					"engName":"","multiple":"One-One","relationId":"","sourceEntityId":"","sourceField":"","targetEntityId":"","targetField":""};
				objRelation.relationId = getRandomId();
				objRelation.sourceEntityId = entity.modelId;
				if(typeof(entity.lstRelation) =="undefined" || entity.lstRelation=="" || entity.lstRelation==null){
					entity.lstRelation=[];
				}
				entity.lstRelation.push(objRelation);
				scope.selectedRelationVO = objRelation;
				// 增加objRelation对象的观察以便能同步更新关系属性
				relationWatcher.watchRelation(objRelation);
	 		}
			
			//删除关联关系
			$scope.deleteRelation = function(relationVO){
				var selectedRelationId = relationVO.relationId;
				entity.lstRelation = _.filter(entity.lstRelation, function(relationvo) { 
					return relationvo.relationId != selectedRelationId; 
				});
				scope.selectedRelationVO = {};
				relationWatcher.deleteAttr(relationVO);
			}
			
			//目标实体属性选择
		   	$scope.targetEntityAttributeSel=function(relationVO){
		   		var selModelId = modelId;
		   		$scope.selectedRelationVO = relationVO;
			    if($scope.selectedRelationVO.targetEntityId != "" && $scope.selectedRelationVO.targetEntityId != null){
					selModelId = $scope.selectedRelationVO.targetEntityId;
				}
				var selTargetField   = $scope.selectedRelationVO.targetField;
		   		var url = webPath + "/cap/bm/dev/entity/SelectionAttrMain.jsp?packageId=" + packageId + "&modelId=" + selModelId + "&selectFlag=targetField&selData="+selTargetField;
		   		var title="选择目标实体属性";
				var height = 650; 
				var width =  700; 
				
				attributeDialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
				attributeDialog.show(url);
		   	}
			
			//中间实体属性选择
		   	$scope.middleEntityAttributeSel=function(relationVO, index){
		   		var selModelId = modelId;
		   		$scope.selectedRelationVO = relationVO;
		   		relationVO._index = index;
			    if($scope.selectedRelationVO.associateEntityId!=""&&$scope.selectedRelationVO.associateEntityId!=null){
					selModelId = $scope.selectedRelationVO.associateEntityId;
			    }
			   	var selAssociateSourceField  = $scope.selectedRelationVO.associateSourceField;
		   		var url = webPath + "/cap/bm/dev/entity/SelectionAttrMain.jsp?packageId=" + packageId + "&modelId=" + selModelId+"&selectFlag=associateSourceField&selData="+selAssociateSourceField;
				var title="选择中间实体源属性";
				var height = 650; 
				var width =  700; 
				
				attributeDialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
				attributeDialog.show(url);
		   	}
			
			//实体保存
		    $scope.saveEntity = function(){
		 		if(save()) {
		 			cui.message('实体保存成功！', 'success');
		 		}
		    }
			
			//跳转下一步
			$scope.goToNextStep = function(){
				if(save()) {
					window.parent.nextStep();
				}
			}

			// 供父页面下一步的时候调用
			$window.save = function () {
				return save();
			}
			
			
			//清空流程选择
		 	$window.cleanProcess = function() {
		 		$scope.entity.processId = "";
				$scope.entity.processName = "";
				$scope.$digest();
		 	};
			
		 	$scope.cleanProcess = $window.cleanProcess;
		 	
			function save() {
				//校验关系
				var valiResult = validateAll();
			    if(!valiResult.validFlag){
			    	cui.alert(valiResult.message);
			    	return;
			    }
			    
				var result;
				dwr.TOPEngine.setAsync(false);
		 	    EntityFacade.saveEntity(entity, function(data){
		 			  result = data;
		 	    });
		 		dwr.TOPEngine.setAsync(true);
		 		if(result){
	 				return true;
	 			}else{
	 				cui.error("实体保存失败！"); 
	 				return false;
	 			}
			}
	 }]);
	 	
		 function initProcessName(){
		   if(entity.processId != null && entity.processId != "" && entity.processId != "null") {
				dwr.TOPEngine.setAsync(false);
				EntityFacade.queryProcessNameById(entity.processId,function(pName){
					entity.processName = pName;
				});
				dwr.TOPEngine.setAsync(true);
			}
		 }
		 
		//初始化默认值
		function initDefaultValue(){
			modelId=entity.modelId;
		    packageId = entity.packageId;
		    modelPackage=entity.modelPackage;
		    if(entity.attributes!=null){
		    	entityAttributes = entity.attributes;
		    }
		}
	 
	 	//实体选择回调
		function selEntityBack(selectNodeData) {
			if(selectNodeData) {
				scope.entity.parentEntityId = selectNodeData.modelId;
				scope.entity.parentEntity = selectNodeData;
			}else {
				scope.entity.parentEntityId = null;
				scope.entity.parentEntity = null;
			}
			//控制关联流程的显示
			if(checkparentEntityIsProcess(scope.entity.parentEntityId)){
				scope.showProcess=true;
			}else{
				scope.showProcess=false;
				scope.entity.processId = "";
				scope.entity.processName = "";
			}
			scope.$digest();
			closeEntityWindow();
		}

		function closeEntityWindow() {
			if(entityDialog){
				entityDialog.hide();
			}
		}

		// 实体选择页面清空回调
		function setDefault(propertyName) {
			selEntityBack(null);
		}
	 
		//检查父实体是否是工作流实体
	    function checkparentEntityIsProcess(strParentEntityId){
	    	if(strParentEntityId != null && strParentEntityId != ""){
	    		var lstParentEntity = [];
		    	dwr.TOPEngine.setAsync(false);
		   		EntityFacade.getAllParentEntity(strParentEntityId, function(result){
		   			lstParentEntity = result;
		   		});
		 		dwr.TOPEngine.setAsync(true);
		 		if(lstParentEntity!=null&&lstParentEntity.length>0){
		 			for(var i=0;i<lstParentEntity.length;i++){
		 				if(lstParentEntity[i].modelId=="com.comtop.cap.runtime.base.entity.CapWorkflow"){
		 					return true;
		 				}
		 			}
		 		}
			}
	    	return false;
	    }
		
	  //选择关联流程回调
	 	function selProcessBack(data) {
			scope.entity.processId = data.processId;
			scope.entity.processName = data.name;
			scope.$digest();
	 	}
	
	 	//监听属性变动，填充源实体属性下拉框
		function watchAttributes(){
			cap.addObserve(entityAttributes,watchAttributes);
			if(cui("#sourceField")){
			var baseEntityAttributes = getBaseEntityAttributes(entityAttributes);
			cui("#sourceField").setDatasource(baseEntityAttributes);
			cui("#sourceField").setValue(scope.entity.sourceField);
			}
		}
		cap.addObserve(entityAttributes,watchAttributes);
		
		//获取基础的实体属性
		function getBaseEntityAttributes(entityAttributes){
			var retEntityAttributes = [];
			for(var i=0;i<entityAttributes.length;i++){
				var entityAttribute = entityAttributes[i];
				if(entityAttribute.relationId==""||entityAttribute.relationId==null){
					retEntityAttributes.push(entityAttribute);
				}
			}
			return retEntityAttributes;
		}
		
		//关联属性选择回调
		function editCallBackOtherTypeSelect(nodeId, nodeTitle, otherType, attributeType,selectFlag) {
			    if(selectFlag=="targetField"){
			    	scope.selectedRelationVO.targetEntityId = nodeId;
					scope.selectedRelationVO.targetField = nodeTitle;
			    }else if(selectFlag=="associateSourceField"){
			    	scope.selectedRelationVO.associateEntityId = nodeId;
					scope.selectedRelationVO.associateSourceField = nodeTitle;
					initAssociateTargetField();
			    }else if(selectFlag=="associateTargetField"){
			    	scope.selectedRelationVO.associateEntityId = nodeId;
					scope.selectedRelationVO.associateTargetField = nodeTitle;
			    }
			scope.$digest();
			if(attributeDialog){
				attributeDialog.hide();
			}
		}
		
		//初始化中间实体的目标属性选择
		function initAssociateTargetField(){
			var entitymodelId = scope.selectedRelationVO.associateEntityId;
			var index = scope.selectedRelationVO._index;
			delete scope.selectedRelationVO._index;	// 用完删除index防止多余属性引起数据混乱
			dwr.TOPEngine.setAsync(false);
		   	EntityFacade.loadEntity(entitymodelId,"",function(entity){
			   	var baseEntityAttributes = getBaseEntityAttributes(entity.attributes);
			   	cui("#associateTargetField_" + index ).setDatasource(baseEntityAttributes);
				scope.selectedRelationVO.associateTargetField = baseEntityAttributes[0].engName;
		   	});
			dwr.TOPEngine.setAsync(true);
		}
		
		//关联属性取消回调
		function closeAttrWindow(){
			if(attributeDialog){
				attributeDialog.hide();
			}
		}

     /**
      * 获取随机数
      * @param prefix 前缀
      */
     function getRandomId(){
   		return ""+new Date().getTime();
     }
	 
   //关系名称检测
 	var validateRelationEngName = [
 	      {'type':'required','rule':{'m':'关系名称不能为空。'}},
 	      {'type':'custom','rule':{'against':checkRelNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以英文字符开头。'}},
 	      {'type':'custom','rule':{'against':checkRelEnNameIsExist, 'm':'关系名称已经存在（不区分大小写）。'}}
 	    ];
 	
 	//关系中文名称检测
 	var validateRelationChName = [
 	      {'type':'required','rule':{'m':'中文名称不能为空。'}}
 	    ];
 	
 	//源实体属性检测
 	var validateSourceField = [
 	      {'type':'required','rule':{'m':'源实体属性不能为空。'}}
 	    ];
 	
 	//目标实体属性检测
 	var validateTargetField = [
 	      {'type':'required','rule':{'m':'目标实体属性不能为空。'}}
 	    ];
 	
 	//中间实体源属性检测
 	var validateAssociateSourceField = [
 	      {'type':'required','rule':{'m':'中间实体源属性不能为空。'}}
 	    ];
 	
 	//中间实体目标属性检测
 	var validateAssociateTargetField = [
 	      {'type':'required','rule':{'m':'中间实体目标属性不能为空。'}}
 	    ];
 	
 	//检查英文关系名称是否存在
 	function checkRelEnNameIsExist(engName) {
 		var ret = true;
 		var num = 0;
 		if (typeof (engName) == 'undefined') {
 			engName = cui("#engName").getValue();
 		}
 		for ( var i in entity.lstRelation) {
 			if (engName == entity.lstRelation[i].engName) {
 				num++;
 			}
 			if (num > 1) {
 				ret = false;
 				break;
 			}
 		}
 		return ret;
 	}
 	
 	//检查关系名称字符
 	function checkRelNameChar(data) {
 		var regEx = "^(?![0-9_])[a-zA-Z0-9_]+$";
 		if(data){
 			var reg = new RegExp(regEx);
 			return (reg.test(data));
 		}
 		return true;
 	}
 	
 	//检查关系名称命名
 	function checkRelName(data) {
 		if("ID" == data.toUpperCase()) {
 			return false;
 		}
 		return true;
 	}
 	
 	//检测关联流程是否为空，当为普通实体，并且父实体为CapWorkflowVO时，必须要选择关联流程
	function checkProcessId(){
		var strClassPattern= entity.classPattern;
		var strParentEntityId = entity.parentEntityId;
		var strProcessId = entity.processId;
		if(strProcessId==null||strProcessId==="null"){
			strProcessId="";
		}
		var lstParentEntity = [];
		if(strParentEntityId!=""){
	    	dwr.TOPEngine.setAsync(false);
	   		EntityFacade.getAllParentEntity(strParentEntityId, function(result){
	   			lstParentEntity = result;
	   		});
	 		dwr.TOPEngine.setAsync(true);
	 		if(lstParentEntity!=null&&lstParentEntity.length>0){
	 			for(var i=0;i<lstParentEntity.length;i++){
	 				if(lstParentEntity[i].modelId=="com.comtop.cap.runtime.base.entity.CapWorkflow"&&strClassPattern=="common"&&strProcessId==""){
	 					return true;
	 				}
	 			}
	 		}
		}
		return false;
	}
 	
 	//统一校验函数
 	function validateAll() {
 		var validate = new cap.Validate();
 		var valRule = {
 				engName: validateRelationEngName,
 				chName : validateRelationChName,
 				sourceField:validateSourceField,
 				targetField:validateTargetField,
 			};
 		var valRuleManyToMany = {
 			engName: validateRelationEngName,
 			chName : validateRelationChName,
 			sourceField:validateSourceField,
 			targetField:validateTargetField,
 			associateSourceField:validateAssociateSourceField,
 			associateTargetField:validateAssociateTargetField
 		};
 		var resultAll =[];
 		//校验关联流程
 		var hasProcessId = checkProcessId();
 		if(hasProcessId){
 			resultAll.push({validFlag:false,message:"关联流程不能为空。"});
 		}
 		//校验关系
 		if(entity.lstRelation && entity.lstRelation.length > 0){
	 		for(var i=0;i<entity.lstRelation.length;i++){
	 			var result;
	 			if(entity.lstRelation[i].multiple=="Many-Many"){
	 				 result = validate.validateAllElement(entity.lstRelation[i], valRuleManyToMany);
	 			}else{
	 				 result = validate.validateAllElement(entity.lstRelation[i], valRule);
	 			}
	 			resultAll.push(result);
	 		}
	 	}
 		
 		return  cap.finalValiResComposite(resultAll);
 	}
 	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 50;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 340;
	}
	</script>
</head>
<body class="cap-page" ng-controller="entityEditForWizardCtrl"  data-ng-init="ready()">
	<table  class="cap-table-fullWidth">
		<tr>
			<td class="cap-td" style="text-align: right;width:100px">
			</td>
			<td class="cap-td" style="text-align: left;width:30%">
			</td>
			<td class="cap-td" style="text-align: right;width:100px">
			</td>
			<td  class="cap-td" style="text-align: right;width:50%">
				<span cui_button id="saveEntity" name="saveEntity" label="保存" ng-click="saveEntity()" ></span>
				<!-- <span cui_button id="nextStep" name="nextStep" label="下一步" ng-click="goToNextStep()" ></span> -->
			</td>
		</tr>
		<tr>
			<td class="cap-td" style="text-align: right;width:100px">
				父实体
			</td>
			<td class="cap-td" style="text-align: left;">
				<span cui_clickinput id="parentEntityId"  name="parentEntityId" ng-model="entity.parentEntityId" ng-click="selParentEntity()" width="100%" ></span>
			</td>
			<td class="cap-td" style="text-align: right;width:100px">
				关联流程
			</td>
			<td  class="cap-td" style="text-align: left;">
				<span uitype="input" type="hidden" id="processId" name="processId" databind="entity.processId"></span>
	            <span cui_input readOnly="true" id="processName" ng-model="entity.processName"  width="50%" ng-if="showProcess == false" ></span>
	            <span cui_clickinput id="processName" ng-model="entity.processName" ng-click="selProcess()"  width="50%" ng-if="showProcess==true"></span>
				<span cui_button id="resetworkflowId" name="resetworkflowId" label="清空" ng-click="cleanProcess()"  ng-if="showProcess==true" ></span>
				<input type="checkbox" name="hasWorkInfo" ng-model="entity.hasWorkInfo"  ng-if="showProcess ==true" /><span style="font-size: 12px" ng-if="showProcess ==true">生成桌面待办、已办</span>
			</td>
		</tr>
	</table>
	<table  class="cap-table-fullWidth">
		<tr>
			<td class="cap-td" style="text-align: right;width:100px" >
				<span>关联关系</span>
			</td>
			<td class="cap-td" style="text-align: left;" >
				<img src="<%=request.getContextPath() %>\cap\rt\common\cui\themes\default\images\button\add.gif" ng-click="addRelation()" />
				<span cui_button id="addRelation" name="addRelation" label="添加关系" ng-click="addRelation()" ></span>
			</td>
			<td class="cap-td" style="text-align: right;width:100pz" >
			</td>
			<td class="cap-td" style="text-align: left;" >
			</td>
		</tr>
		<tr>
			<td class="cap-td" colspan="4">
				<table ng-repeat="relationVO in entity.lstRelation track by $index"  class="cap-table-fullWidth">
				     <tr>
				        <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
				        	<img src="<%=request.getContextPath() %>\cap\rt\common\cui\themes\default\images\button\cancel.gif" 
				        	ng-click="deleteRelation(relationVO)"><font color="red">*</font><span>关系名称：</span>
				        </td>
				        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
				        	<span cui_input id="engName" ng-model="relationVO.engName" validate="validateRelationEngName" width="100%"/>
				        </td>
				        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
				        	<font color="red">*</font><span>中文名称：</span>
				        </td>
				         <td class="cap-td" style="text-align: left;" nowrap="nowrap">
			   				<span cui_input id="chName" ng-model="relationVO.chName" validate="validateRelationChName" width="100%"/>
				        </td>
			    	</tr>
				    <tr>
				        <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
				        	<font color="red">*</font><span>多重性：</span>
				        </td>
				        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
				            <span cui_pulldown id="multiple" readonly="false" ng-model="relationVO.multiple" value_field="id" label_field="text" editable="false" width="100%">
									<a value="One-One">One-One</a>
									<a value="One-Many">One-Many</a>
									<a value="Many-One">Many-One</a>
									<a value="Many-Many">Many-Many</a>
						    </span>
			        	</td>
		        	</tr>
			         <tr>
					      <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
					        	<font color="red">*</font><span>源实体属性：</span>
					      </td>
					        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
					            <span cui_pulldown id="sourceField" readonly="false" ng-model="relationVO.sourceField" datasource="entityAttributes" editable="false" validate="validateSourceField" value_field="engName" label_field="engName" width="100%">
							    </span>
							</td>
					        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
					        </td>
					         <td class="cap-td" style="text-align: left;" nowrap="nowrap">
					        </td>
					    </tr>
					    <tr >
					      <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
					        	<font color="red">*</font><span>目标实体属性：</span>
					      </td>
					        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
					             <span cui_clickinput id="targetField" ng-model="relationVO.targetField" ng-click="targetEntityAttributeSel(relationVO)" validate="validateTargetField"  width="100%"></span>	
							</td>
					        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
					        	<font color="red">*</font><span>目标实体：</span>
					        </td>
					         <td class="cap-td" style="text-align: left;" nowrap="nowrap">
					       	<span cui_input id="targetEntityId" readOnly="true" ng-model="relationVO.targetEntityId" width="100%"/>
					        </td>
					    </tr>
					    <tr ng-show="relationVO.multiple=='Many-Many'">
					       <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
					        	<font color="red">*</font><span>中间实体源属性：</span>
					      </td>
					        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
							    <span cui_clickinput id="associateSourceField" ng-model="relationVO.associateSourceField" ng-click="middleEntityAttributeSel(relationVO, $index)" validate="validateAssociateSourceField" width="100%"></span>	
							</td>
					        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
					        	<font color="red">*</font><span>中间实体：</span>
					        </td>
					         <td class="cap-td" style="text-align: left;" nowrap="nowrap">
					         	<span cui_input id="associateEntityId" readOnly="true" ng-model="relationVO.associateEntityId" width="100%"/>
					        </td>
					    </tr>
					    <tr ng-show="relationVO.multiple=='Many-Many'">
					       <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
					        	<font color="red">*</font><span>中间实体目标属性：</span>
					      </td>
					        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
							  <span cui_pulldown id="associateTargetField_{{$index}}" readonly="false" ng-model="relationVO.associateTargetField" editable="false" datasource="initData" validate="validateAssociateTargetField" value_field="engName" label_field="engName" width="100%">
							</td>
					        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
					        </td>
					         <td class="cap-td" style="text-align: left;" nowrap="nowrap">
					        </td>
					    </tr>
					    <tr>
						    <td colspan="4">
								<hr size="3" style="color: black">
						    </td>
					    </tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>