
<%
/**********************************************************************
* 元数据建模：实体关系列表
* 2015-9-22 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='entityRelationShipList'>
<!doctype html>
<html>
<head>
	<meta charset="UTF-8"/>
    <title>实体关系列表页</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	<script language="javascript">
	//获得传递参数
    var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
    var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
    var modelPackage=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelPackage"))%>;
    var globalReadState=eval(<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>);
	var PageStorage = new cap.PageStorage(modelId);
	var entity = PageStorage.get("entity");
	var entityAttributes = entity.attributes==null?[]:entity.attributes;//源实体属性初始化数据
	var initData;
	//当表达式为空时，初始化为数组
	entity.lstRelation = entity.lstRelation==null?[]:entity.lstRelation;
	var root = {
			lstRelation:entity.lstRelation
		}
	
	//拿到angularJS的scope
	var scope=null;
	//属性选择界面
	var attributeDialog;
	angular.module('entityRelationShipList', ["cui"]).controller('entityRelationShipCtrl', function ($scope, $timeout) {
	   	$scope.root=root;
	   	$scope.entityRelationCheckAll=false;
	   	$scope.selectEntityRelationVO=root.lstRelation.length>0?root.lstRelation[0]:{};
	   	
	 	//关系过滤关键字
    	$scope.relationshipFilter="";
	 	
	   	$scope.ready=function(){
	    	comtop.UI.scan();
	    	$scope.setReadonlyAreaState(globalReadState);
	    	scope=$scope;
	    	$scope.init();
	    }
	   	
	   	/**
		 * 设置区域读写状态
		 * @param globalReadState 状态标识
		 */
		$scope.setReadonlyAreaState=function(globalReadState){
			//设置为控件为自读状态（针对于CAP测试建模）
		   	if(globalReadState){
		    	$timeout(function(){
		    		cap.setReadonlyArea("unReadonlyArea", ["*:not([class^='notUnbind'])"], ["input[type='checkbox']"]);
		    	}, 0);
	    	}
		}
	   	
	   	$scope.init=function(){
	   		//第一个关系为多对多时，初始化中间对象的目标属性
	   		if($scope.selectEntityRelationVO.multiple=="Many-Many"){
		   		var entitymodelId = $scope.selectEntityRelationVO.associateEntityId;
				  dwr.TOPEngine.setAsync(false);
				   EntityFacade.loadEntity(entitymodelId,"",function(entity){
					   initData = getBaseEntityAttributes(entity.attributes);
				   });
				dwr.TOPEngine.setAsync(true);
	   		}
	   	}

	   	$scope.entityRelationTdClick=function(entityRelationVo){
	   		$scope.selectEntityRelationVO=entityRelationVo;
	   		if($scope.selectEntityRelationVO.multiple=="Many-Many"){
	   		    initAssociateTargetField();
	   		}
	   		$scope.setReadonlyAreaState(globalReadState);
	    }
	   	
	    //属性列表过滤
    	$scope.$watch("relationshipFilter",function(){
    		for(var i=0;i<$scope.root.lstRelation.length;i++){
    			if($scope.relationshipFilter==""){
    				$scope.root.lstRelation[i].isFilter=false;
    			}else if($scope.root.lstRelation[i].engName.indexOf($scope.relationshipFilter)==-1&&$scope.root.lstRelation[i].chName.indexOf($scope.relationshipFilter)==-1){
    				$scope.root.lstRelation[i].isFilter=true;
    			}else{
    				$scope.root.lstRelation[i].isFilter=false;
    			}
            }
    		$scope.checkBoxCheck($scope.root.lstRelation,"entityRelationCheckAll");
    	});
	    
	   	//监控全选checkbox，如果选择则联动选中列表所有数据
	   	$scope.allCheckBoxCheck=function(ar,isCheck){
	   		if(ar!=null){
	   			for(var i=0;i<ar.length;i++){
	    			if(isCheck&& !ar[i].isFilter){
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
	    			
	    			if(!ar[i].isFilter){
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
	   	
	   	//新增属性
	   	$scope.addEntityRelation=function(){
	   		var relationTempId = new Date().valueOf();
	   		var newEntityRelation = {
	   				relationId:relationTempId,engName:"",chName:'',sourceEntityId:entity.modelId,description:"",multiple:"One-One",sourceField:"",targetField:"",targetEntityId:"",associateEntityId:"",associateSourceField:"",associateTargetField:""};
			
			$scope.root.lstRelation.push(newEntityRelation);
			$scope.selectEntityRelationVO=newEntityRelation;
			$scope.checkBoxCheck($scope.root.lstRelation,"entityRelationCheckAll");
			if(modelId.indexOf(modelPackage)<0){//新增属性，实体没有保存，此时变动，源实体属性框还没有，新增时需要初始化源实体属性
				entityAttributes = entity.attributes;
			}
	   	}
	   	
	   	//目标实体属性选择
	   	$scope.targetEntityAttributeSel=function(){
	   		var selModelId = modelId; 
			   if($scope.selectEntityRelationVO.targetEntityId!=""&&$scope.selectEntityRelationVO.targetEntityId!=null){
				   selModelId = $scope.selectEntityRelationVO.targetEntityId;
			   }
			var selTargetField   = $scope.selectEntityRelationVO.targetField;
	   		var url = "SelectionAttrMain.jsp?packageId=" + packageId + "&modelId=" + selModelId+"&selectFlag=targetField&selData="+selTargetField;
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
	   	$scope.targetEntityAttributeSel1=function(){
	   		var selModelId = modelId;
			   if($scope.selectEntityRelationVO.associateEntityId!=""&&$scope.selectEntityRelationVO.associateEntityId!=null){
				   selModelId = $scope.selectEntityRelationVO.associateEntityId;
			   }
			   var selAssociateSourceField   = $scope.selectEntityRelationVO.associateSourceField;
	   		var url = "SelectionAttrMain.jsp?packageId=" + packageId + "&modelId=" + selModelId+"&selectFlag=associateSourceField&selData="+selAssociateSourceField;
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
	  
	   	//删除属性
	   	$scope.deleteEntityRelation=function(){
	   		var deleteArr = [];
	   		var newArr=[];//需要删除的数据序号
	        for(var i=0;i<$scope.root.lstRelation.length;i++){
		        if($scope.root.lstRelation[i].check){
		        		newArr.push(i);
		        		deleteArr.push($scope.root.lstRelation[i]);
		          }
		     }
	   		
	        var deleteTitle = "";
			for(var k=0;k<deleteArr.length;k++){
				 deleteTitle += deleteArr[k].engName+"<br/>";
			}
			
			if(deleteArr.length>0){
				cui.confirm("确定要删除<br/>"+deleteTitle+"这些关系吗？",{
					onYes:function(){ 
			        //根据坐标删除数据
			        for(var j=newArr.length-1;j>=0;j--){
			        	$scope.root.lstRelation.splice(newArr[j],1);
			        }
			      
			        //如果当前选中的行被删除则默认选择第一行
			        var isSelectIsDelete=true;
			        for(var i=0;i<$scope.root.lstRelation.length;i++){
				        if($scope.root.lstRelation[i]==$scope.selectEntityRelationVO){
				            isSelectIsDelete=false;
				            break;
				        }
			        }
			        if(isSelectIsDelete){
						$scope.selectEntityRelationVO=$scope.root.lstRelation[0];
			        }
			        $scope.checkBoxCheck($scope.root.lstRelation,"entityRelationCheckAll");
			        $scope.$digest();
			        cui.message("删除成功.");
					}
				});
			}
	   	}
	   	
	});
	
	//监听属性变动，填充源实体属性下拉框
	function watchAttributes(){
		cap.addObserve(entityAttributes,watchAttributes);
		if(cui("#sourceField")){
		var baseEntityAttributes = getBaseEntityAttributes(entityAttributes);
		cui("#sourceField").setDatasource(baseEntityAttributes);
		cui("#sourceField").setValue(scope.selectEntityRelationVO.sourceField);
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
		    	scope.selectEntityRelationVO.targetEntityId = nodeId;
				scope.selectEntityRelationVO.targetField = nodeTitle;
		    }else if(selectFlag=="associateSourceField"){
		    	scope.selectEntityRelationVO.associateEntityId = nodeId;
				scope.selectEntityRelationVO.associateSourceField = nodeTitle;
				initAssociateTargetField();
		    }else if(selectFlag=="associateTargetField"){
		    	scope.selectEntityRelationVO.associateEntityId = nodeId;
				scope.selectEntityRelationVO.associateTargetField = nodeTitle;
		    }
		
		scope.$digest();
		if(attributeDialog){
			attributeDialog.hide();
		}
	}
	
	//初始化中间实体的目标属性选择
	function initAssociateTargetField(){
		var entitymodelId = scope.selectEntityRelationVO.associateEntityId;
		  dwr.TOPEngine.setAsync(false);
		   EntityFacade.loadEntity(entitymodelId,"",function(entity){
			   var baseEntityAttributes =getBaseEntityAttributes(entity.attributes);
			   cui("#associateTargetField").setDatasource(baseEntityAttributes);
				scope.selectEntityRelationVO.associateTargetField = baseEntityAttributes[0].engName;
		   });
		dwr.TOPEngine.setAsync(true);
		
		
	}
	
	//关联属性取消回调
	function closeAttrWindow(){
		if(attributeDialog){
			attributeDialog.hide();
		}
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
		for ( var i in root.lstRelation) {
			if (engName == root.lstRelation[i].engName) {
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
		for(var i=0;i<root.lstRelation.length;i++){
			var result;
			if(root.lstRelation[i].multiple=="Many-Many"){
				 result = validate.validateAllElement(root.lstRelation[i], valRuleManyToMany);
			}else{
				 result = validate.validateAllElement(root.lstRelation[i], valRule);
			}
			resultAll.push(result);
		}
		
		return  cap.finalValiResComposite(resultAll);
	}
	</script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="entityRelationShipCtrl" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:350px;padding-right: 5px">
		        	<table class="cap-table-fullWidth" style="width:100%;">
					    <tr>
					        <td  class="cap-form-td" style="text-align: left;">
								<span class="cap-group">实体关系列表</span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-form-td" style="text-align: left;width：165px;">
					        	<span cui_input  id="relationshipFilter" ng-model="relationshipFilter" width="210px" emptytext="请输入关系英文名、中文名过滤"></span>
					        </td>
					    	<td class="cap-form-td" style="text-align: right;" nowrap="nowrap">
					            <span cui_button id="add" ng-click="addEntityRelation()" label="新增"></span>
					            <span cui_button id="delete" ng-click="deleteEntityRelation()" label="删除"></span>
					        </td>
					    </tr>
					    <tr>
					    	<td class="cap-form-td" colspan="2">
					            <table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="entityRelationCheckAll" ng-model="entityRelationCheckAll" ng-change="allCheckBoxCheck(root.lstRelation,entityRelationCheckAll)">
					                        </th>
					                        <th>
				                            	关系名称
					                        </th>
					                        <th>
				                            	中文名称
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="entityRelationVo in root.lstRelation track by $index" ng-hide="entityRelationVo.isFilter" style="background-color: {{selectEntityRelationVO==entityRelationVo? '#99ccff':'#ffffff'}}">
			                            	<td style="text-align: center;">
			                                    <input type="checkbox" name="{{'entityRelation'+($index + 1)}}" ng-model="entityRelationVo.check" ng-change="checkBoxCheck(root.lstRelation,'entityRelationCheckAll')">
			                                </td>
			                                <td style="text-align:left;cursor:pointer" class="notUnbind" ng-click="entityRelationTdClick(entityRelationVo)">
			                                    {{entityRelationVo.engName}}
			                                </td>
			                                <td style="text-align: center;" class="notUnbind" ng-click="entityRelationTdClick(entityRelationVo)">
			                                    {{entityRelationVo.chName}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					    	</td>
					    </tr>
					</table>
		        </td>
		        <td style="text-align: center;border-left:1px solid #ddd;vertical-align:middle">
		        	<span style="opacity: 0.2;font-size:18px" ng-if="!selectEntityRelationVO.multiple">请新增实体关系</span>
		        </td>
		        <td class="cap-td" style="text-align: left" ng-show="selectEntityRelationVO.multiple">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td  class="cap-form-td" style="text-align: left;">
								<span class="cap-group">基本信息</span>
					        </td>
					    </tr>
					    <tr>
					    	<td style="text-align: left;">
					    		<table class="cap-table-fullWidth">
								     <tr>
								        <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="多重性："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								            <span cui_pulldown id="multiple" readonly="false" ng-model="selectEntityRelationVO.multiple" value_field="id" label_field="text" width="100%">
													<a value="One-One">One-One</a>
													<a value="One-Many">One-Many</a>
													<a value="Many-One">Many-One</a>
													<a value="Many-Many">Many-Many</a>
										    </span>
								        </td>
								         <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="描述："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" rowspan="3" nowrap="nowrap">
			      		                   <span cui_textarea id="description" ng-model="selectEntityRelationVO.description" width="100%" height="100px" ></span>
								        </td>
								    </tr>
								     <tr>
								        <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="关系名称："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        	<span cui_input id="engName" ng-model="selectEntityRelationVO.engName" validate="validateRelationEngName" width="100%"/>
								        </td>
								    </tr>
								     <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="中文名称："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
							   				<span cui_input id="chName" ng-model="selectEntityRelationVO.chName" validate="validateRelationChName" width="100%"/>
								        </td>
								    </tr>
								</table>
					    	</td>
					    </tr>
					    <tr>
					        <td  class="cap-form-td" style="text-align: left;">
								<span class="cap-group">关联信息</span>
					        </td>
					         <tr>
					    	<td style="text-align: left;">
					    		<table class="cap-table-fullWidth">
					    		<tr >
								      <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="源实体属性："></span>
								      </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								            <span cui_pulldown id="sourceField" readonly="false" ng-model="selectEntityRelationVO.sourceField" datasource="entityAttributes" editable="false" validate="validateSourceField" value_field="engName" label_field="engName" width="100%">
										    </span>
										</td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        </td>
								    </tr>
								    <tr >
								      <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="目标实体属性："></span>
								      </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								             <span cui_clickinput id="targetField" ng-model="selectEntityRelationVO.targetField" ng-click="targetEntityAttributeSel()" validate="validateTargetField"  width="100%"></span>	
										</td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="目标实体："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								       	<span cui_input id="targetEntityId" readOnly="true" ng-model="selectEntityRelationVO.targetEntityId" width="100%"/>
								        </td>
								    </tr>
								    <tr ng-show="selectEntityRelationVO.multiple=='Many-Many'">
								       <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="中间实体源属性："></span>
								      </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
										    <span cui_clickinput id="associateSourceField" ng-model="selectEntityRelationVO.associateSourceField" ng-click="targetEntityAttributeSel1()" validate="validateAssociateSourceField" width="100%"></span>	
										</td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="中间实体："></span>
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								         	<span cui_input id="associateEntityId" readOnly="true" ng-model="selectEntityRelationVO.associateEntityId" width="100%"/>
								        </td>
								    </tr>
								    <tr ng-show="selectEntityRelationVO.multiple=='Many-Many'">
								       <td class="cap-td" style="text-align: right;width:150px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="中间实体目标属性："></span>
								      </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
										  <span cui_pulldown id="associateTargetField" readonly="false" ng-model="selectEntityRelationVO.associateTargetField" editable="false" datasource="initData" validate="validateAssociateTargetField" value_field="engName" label_field="engName" width="100%">
										</td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        </td>
								         <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        </td>
								    </tr>
					    		</table>
					    		 </br>
					    	</td>
					    </tr>
					</table>
		        </td>
		    </tr>
		</table>
	</div>	
</div>
</body>
</html>