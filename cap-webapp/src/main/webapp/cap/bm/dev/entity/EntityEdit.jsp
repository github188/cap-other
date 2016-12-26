<%
  /**********************************************************************
	* CIP元数据建模----实体信息编辑
	* 2014-9-17 章尊志 新增
	* 2016-5-13 林玉千 添加实体别名
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='entityInfoEdit'>
<head>
<meta charset="UTF-8"/>
<title>实体信息编辑页面</title>
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
	<top:script src='/cap/dwr/interface/BizObjInfoAction.js'></top:script>
	<top:script src='/cap/dwr/interface/BizDomainAction.js'></top:script>
	<script type="text/javascript">
	//获得传递参数
     var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
     var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
     var modelPackage=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelPackage"))%>;
     var globalReadState=eval(<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>);
     //系统目录树的，应用模块编码
     var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("moduleCode"))%>;
	 var PageStorage = new cap.PageStorage(modelId);
	 var entity = PageStorage.get("entity");
	 var regEx = "^([A-Z])[a-zA-Z0-9_]*$";
	 //拿到angularJS的scope
	 var scope=null;
	 var entityDialog;
	 angular.module('entityInfoEdit', [ "cui"]).controller('entityInfoEditCtrl', function ($scope, $timeout) {
			$scope.entity=entity;
			$scope.showProcess = entity.entityType =="biz_entity"?true:false;
			$scope.isCreateNewEntiy = (modelId.indexOf(modelPackage)>-1) ? false : true;
			$scope.ready=function(){
				initProcessName();
		    	comtop.UI.scan();
		    	$scope.setReadonlyAreaState(globalReadState);
		    	//控制关联流程的显示
				if(checkparentEntityIsProcess($scope.entity.parentEntityId)){
					$scope.showProcess=true;
				}else{
					$scope.showProcess=false;
				}
		    	scope=$scope;
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
			
			$scope.selProcess=function(){
				var url = "WorkFlowSelection.jsp?dirCode="+moduleCode;
				var title="选择流程";
				var height = 600;
				var width =  680;
				
				dialog = cui.dialog({
					title : title,
					src : url,
					width : width,
					height : height
				})
				dialog.show(url);
			}
			
			$scope.selParentEntity=function(){
				var parentEntityId=scope.entity.parentEntityId;
				var selfEntityId = scope.entity.modelId;
				var url = "SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=false&sourceEntityId="+parentEntityId+"&selfEntityId="+selfEntityId+"&operateNodeDisable=true";
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
			
			
			$scope.$watch("entity.engName",function(){
			 if($scope.entity.engName!=null||$scope.entity.engName!=""){
				 window.parent.sendMessage('entityMethodFrame',{type:'entityEngNameChange',data:$scope.entity.engName})
			 }	
			});
			
			
	    });
	 
	 
	 function initProcessName(){
	   if(entity.processId != null && entity.processId != "" && entity.processId != "null") {
			dwr.TOPEngine.setAsync(false);
			EntityFacade.queryProcessNameById(entity.processId,function(pName){
				entity.processName = pName;
			});
			dwr.TOPEngine.setAsync(true);
		}
	 }
	 
	    function messageHandle(e) {
	    	if(scope != null){
		    	if(e.data.type=="modelIdChange"){
		    		 modelId = e.data.data;
		    		if(modelId.indexOf(modelPackage)>-1){
		    			scope.isCreateNewEntiy=false;
		    		}
		    		scope.$digest();
		    	}
	    	}
	    }
	    
	    window.addEventListener("message", messageHandle, false);
	 
	    //实体选择回调
		function selEntityBack(selectNodeData) {
// 			if('exist_entity_input' == entity.entitySource){
// 				cui.alert("已有实体不能更改父类");
// 				return false;
// 			}
			scope.entity.parentEntityId = selectNodeData.modelId;
			//控制关联流程的显示
			if(checkparentEntityIsProcess(scope.entity.parentEntityId)){
				scope.showProcess=true;
			}else{
				scope.showProcess=false;
				scope.entity.processId = "";
				scope.entity.processName = "";
			}
			scope.$digest();
			parentEntityIdchange();
			if(entityDialog){
				entityDialog.hide();
			}
		}
	    
	    //检查父实体是否是工作流实体
	    function checkparentEntityIsProcess(strParentEntityId){
	    	if(strParentEntityId!=""){
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
	    
		//实体选择界面清空按钮
		function setDefault(){
			scope.entity.parentEntityId = "";
			scope.$digest();
			parentEntityIdchange();
			if(entityDialog){
				entityDialog.hide();
			}
		}
		//实体选择界面取消按钮
		function closeEntityWindow(){
			if(entityDialog){
				entityDialog.hide();
			}
		}
	    
		//父实体改变通知
		function parentEntityIdchange(){
			cap.MessageManager.getInstance("sendMessage").sendMessage('entityAttributeFrame',{type:'parentEntityIdChange',data:entity.parentEntityId});
			cap.MessageManager.getInstance("sendMessage").sendMessage('entityMethodFrame',{type:'parentEntityIdChange',data:entity.parentEntityId});
		}
		
	    //做实体被循环关联的校验
	    function selEnityValidate(selectNodeData){
	    	if(selectNodeData.modelId){
	    		var lstParentEntity = [];
		    	dwr.TOPEngine.setAsync(false);
		   		EntityFacade.getAllParentEntity(selectNodeData.modelId, function(result){
		   			lstParentEntity = result;
		   		});
		 		dwr.TOPEngine.setAsync(true);
		 		if(lstParentEntity!=null&&lstParentEntity.length>0){
		 			for(var i=0;i<lstParentEntity.length;i++){
		 				if(lstParentEntity[i].modelId==entity.modelId){
		 					cui.alert("实体被循环关联了!");
		 					return false;
		 				}
		 			}
		 		}
	    	}
	    	return true;
	    }
	 
		//选择关联流程回调
	 	function selProcessBack(data) {
			scope.entity.processId = data.processId;
			scope.entity.processName = data.name;
			scope.$digest();
	 	}
		
	 	//清空流程选择
	 	function cleanProcess() {
	 		scope.entity.processId = "";
			scope.entity.processName = "";
			scope.$digest();
	 	}
	 
	 	//实体名称检测
		var validateEntityName = [
		      {'type':'required','rule':{'m':'实体名称不能为空。'}},
		      {'type':'custom','rule':{'against':checkEntityNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以大写英文字符开头。'}},
		      {'type':'custom','rule':{'against':checkEntityNameIsExist, 'm':'实体名称已经存在。'}}
		    ];
		//实体名称检测
		var validateEntityChName = [
		      {'type':'required','rule':{'m':'实体中文名称不能为空。'}},
		      {'type':'custom','rule':{'against':checkEntityChNameIsExist, 'm':'实体中文名称已经存在。'}}
		    ];
		
		//校验实体名称字符
	  	function checkEntityNameChar(data) {
	  		if(data){
				var reg = new RegExp(regEx);
				return (reg.test(data));
			}
			return true;
	  	}
	  	
	  	//检验实体名称是否存在
	  	function checkEntityNameIsExist(engName) {
	  		var flag = true;
	  		dwr.TOPEngine.setAsync(false);
			EntityFacade.isExistSameNameEntity(modelPackage,engName,modelId,function(bResult){
				flag = !bResult;
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	  	}
	  	
	  	//检验实体中文名称是否存在
	  	function checkEntityChNameIsExist(chName) {
	  		var flag = true;
	  		dwr.TOPEngine.setAsync(false);
			EntityFacade.isExistSameChNameEntity(modelPackage,chName,modelId,function(bResult){
				flag = !bResult;
			});
			dwr.TOPEngine.setAsync(true);
			return flag;
	  	}
	  	
		//统一校验函数
		function validateAll() {
			var validate = new cap.Validate();
			var valRule = {
				engName: validateEntityName,
				chName : validateEntityChName
			};
			var result = validate.validateAllElement(entity, valRule);
			return result;
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
		
		//初始化业务对象数据
		function initData(tableObj,query){
			dwr.TOPEngine.setAsync(false);
			BizObjInfoAction.queryBizInfoListByIds(entity.bizObjectIds,function(data){
				tableObj.setDatasource(data, data.length);
				//如果之前保存的业务对象被删除了，则清除绑定的业务对象
				if(data==null||data==""){
					 entity.bizObjectIds=[];
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		////queryDomainById
		function renderDomainName(rd, index, col){
			dwr.TOPEngine.setAsync(false);
			var text="";
			BizDomainAction.queryDomainById(rd.domainId,function(data){
				if(data){
					text =( data.name + "【" +data.code + "】");
				}else{
					text=rd.domainId;
				}
			});
			dwr.TOPEngine.setAsync(true);
			return text;
		}
		
		//新增业务对象
		function btnAdd(){
			var url = "${pageScope.cuiWebRoot}/cap/bm/biz/info/BizObjInfoSelect.jsp?dirCode="+moduleCode;
			var title="业务对象选择";
			var height = 600;
			var width =  680;
			
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			})
			dialog.show(url);
		}
		
		//业务实体选择回调
		 function chooseBizObjInfoCallback(BizObjInfoList){
			 //先找出之前没有添加的对象，然后新增到当前业务对象信息集合中
			 var bizObjectGridData = scope.entity.bizObjectIds!=null?scope.entity.bizObjectIds:[];
			 if(scope.entity.bizObjectIds==null){
				 scope.entity.bizObjectIds=[];
			 }
			 var addBizObjInfo = [];
			 var gridData = cui("#bizObjectGrid").getData();
			 for(var i =0;i<BizObjInfoList.length;i++){
				 var isAdd = true;
				 for(var j= 0;j<bizObjectGridData.length;j++){
					 if(BizObjInfoList[i].id === bizObjectGridData[j]){
						 isAdd = false;
					 }
				 }
				 if(isAdd){
					 gridData.push(BizObjInfoList[i]);
					 addBizObjInfo.push(BizObjInfoList[i]);
				 }
			 }
			 //填充新增的业务对象到grid中
			 
			 cui("#bizObjectGrid").setDatasource(gridData,gridData.length);
			 //根据新增的业务对象，更新实体关联的业务对象ID
			 for(k=0;k<addBizObjInfo.length;k++){
				 scope.entity.bizObjectIds.push(addBizObjInfo[k].id); 
			 }
		 }
		
		//删除业务对象
		function btnDelete(){
			var selectedIndex = cui("#bizObjectGrid").getSelectedIndex();
			if(selectedIndex==null||selectedIndex.length==0){
				cui.alert("请选择需要删除的数据！");
				return ;
			}
			//更新实体中绑定的业务数据
			var deleteArrayIndex =[];
			var selectedRowData = cui("#bizObjectGrid").getSelectedRowData();
			for(var i=0;i<scope.entity.bizObjectIds.length;i++){
				for(var j=0;j<selectedRowData.length;j++){
					if(scope.entity.bizObjectIds[i]==selectedRowData[j].id){
						deleteArrayIndex.push(i);
					}
				}
			}
			for(var k=deleteArrayIndex.length-1;k>=0;k--){
				scope.entity.bizObjectIds.splice(deleteArrayIndex[k],1);
			}
			//删除展示的数据
			cui("#bizObjectGrid").removeData(selectedIndex);
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
<body style="background-color:#f5f5f5;" ng-controller="entityInfoEditCtrl" data-ng-init="ready()">
<div class="cap-page">
    <div class="cap-area" style="width:100%;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>实体基本信息</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td>
		        	<table class="cap-table-fullWidth">
					    <tr>
					    	<td  class="cap-td" style="text-align: right;width:120px">
								<font color="red">*</font>实体名称：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					           <span cui_input ng-if="isCreateNewEntiy" id="engName" ng-model="entity.engName" width="100%" validate="validateEntityName"></span>
					           <span cui_input readonly="true" ng-if="!isCreateNewEntiy" id="engName" ng-model="entity.engName" width="100%" ></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:100px">
					        	<font color="red">*</font>中文名称：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input  id="chName" ng-model="entity.chName" width="100%" validate="validateEntityChName"></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	<font color="red">*</font>类模式：
					        </td>
					        <td class="cap-td" style="text-align: left;width:35%">
								<span cui_radiogroup id="classPattern" ng-model="entity.classPattern" name="classPattern" readonly="{{entity.entityType=='data_entity'}}">
					        	<input type="radio" name="classPattern" value="common" />common
								<input type="radio" name="classPattern" value="abstract" />abstract
								</span>
					        </td>
					    	<td  class="cap-td" style="text-align: right;width:120px">
								<font color="red">*</font>实体别名：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					           	<span cui_input  id="aliasName" ng-model="entity.aliasName" width="100%"  readonly="true"></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:100px">
					        	<!-- <font color="red">*</font>  -->父实体：
					        </td>
								<td class="cap-td" style="text-align: left;">
					        	<span cui_clickinput id="parentEntityId" ng-model="entity.parentEntityId" ng-click="selParentEntity()" width="100%"></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:100px">
					        	关联流程：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					           <span uitype="input" type="hidden" id="processId" name="processId" databind="entity.processId"></span>
					           <span cui_input readOnly="true" ng-if="showProcess ==false" id="processName" ng-model="entity.processName" width="100%"></span>
					           <span cui_clickinput ng-if="showProcess==true" id="processName" ng-model="entity.processName" ng-click="selProcess()" width="100%"></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	对应表：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input readonly="true"  id="dbObjectName" ng-model="entity.dbObjectName" width="100%">
								</span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	包路径：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input readonly="true"  id="modelPackage" ng-model="entity.modelPackage" width="100%">
								</span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:100px">
					                  实体类型：	
					        </td>
					       <td class="cap-td"  style="text-align: left;width:35%">
					        	<span cui_radiogroup readonly="true" id="entityType" ng-model="entity.entityType" name="entityType">
					        	<input type="radio" name="entityType" value="biz_entity" />业务实体
								<input type="radio" name="entityType" value="query_entity" />查询实体
								<input type="radio" name="entityType" value="data_entity" />数据实体
<!-- 								<input type="radio" name="entityType" value="exist_entity" />已有实体 -->
								</span>
						   </td>
						   <td class="cap-td" style="text-align: right;width:100px">
						          实体来源：
					        </td>
					       <td class="cap-td"  style="text-align: left;width:35%">
					         <span cui_radiogroup readonly="true" id="entitySource" ng-model="entity.entitySource" name="entitySource">
					        	<input type="radio" name="entitySource" value="table_metadata_import" />数据表导入
								<input type="radio" name="entitySource" value="view_metadata_import" />视图导入
								<input type="radio" name="entitySource" value="user_create" />用户手工创建
								<input type="radio" name="entitySource" value="exist_entity_input" />已有实体录入
								</span>
						   </td>
					    </tr>
					    <!-- 
					    <tr>
					     <td class="cap-td" style="text-align: right;width:120px">
					        	业务对象：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_clickinput id="bizObjectCodes" ng-model="entity.bizObjectCodes" ng-click="selBizObjInfo()" width="100%"></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:100px">
					        </td>
					       <td class="cap-td"  style="text-align: left;width:35%">
						   </td>
					    </tr> -->
					     <tr>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	描述：
					        </td>
		                     <td class="cap-td" colspan="3" style="text-align: left;width:86%">
			      		         <span cui_textarea id="description" ng-model="entity.description" width="100%" height="50px" ></span>
		                      </td>
			              </tr>
					</table>
		        </td>
		    </tr>
		</table>
		</br>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>业务对象信息</span>
						</blockquote>
					</span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span uitype="button" on_click="btnAdd" label="新增" id="btn_Add"></span> 
		            <span uitype="button" on_click="btnDelete" label="删除" id="btn_Delete"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="padding-left:20px">
			        <table uitype="Grid" id="bizObjectGrid" primarykey="Id" sorttype="1" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
					 	resizewidth="resizeWidth" selectrows="multi" resizeheight="resizeHeight"  colrender="">
					 	 <thead>	
					 	<tr>
							<th style="width:30px"><input type="checkbox"/></th>
							<th bindName="domainId" render="renderDomainName" style="width:30%;" renderStyle="text-align: left;" sort="false">业务域</th>
							<th bindName="code" style="width:30%;" renderStyle="text-align: left;" sort="false">编码</th>
							<th bindName="name" style="width:30%;" renderStyle="text-align: center" sort="false">名称</th>
						</tr>
						</thead>
					</table>
		        </td>
		    </tr>
		</table>        
    </div>
</div>	
</body>
</html>