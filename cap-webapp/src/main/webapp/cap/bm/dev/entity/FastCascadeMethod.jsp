<%
/**********************************************************************
* 快速新建级联方法
* 2016-09-22 凌晨
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='cascadeMethod'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>快速创建级联方法</title>
	<top:link href="/cap/bm/common/base/css/base.css"/>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/easy.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<style type="text/css">
	</style>
	<script type="text/javascript" charset="UTF-8">
		//获得传递参数
		var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		var pageStorage = new cap.PageStorage(modelId);
		var entity = pageStorage.get("entity");
		var _ = cui.utils;
		//拿到angularJS的scope
		var scope=null;
		angular.module('cascadeMethod', ["cui"]).controller('cascadeMethodCtrl',['$scope',function ($scope) {
		   	
			//默认方法名
			$scope.defaultMethodNameObj = {cascadeQuery : "cascadeQuery", cascadeDel : "cascadeDel", cascadeSave : "cascadeSave"};
			
		   	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
		   	
		   	$scope.init=function(){
		   		//读出此实体的所有一级级联属性
		   		dwr.TOPEngine.setAsync(false);
				//取得当前实体的所有级联属性（一级一级往下找，直到没有级联属性为止）
				EntityFacade.getCascadeAttribute(entity, null, '-1', 0, null, function(_result) {
					$scope.cascadeVOList = _result;
					//初始化级联属性全部选中
					if($scope.cascadeVOList && $scope.cascadeVOList.length > 0){
						$scope.cascadeVOList.forEach(function(item,index,arr){
							item.queryCheck = true;
							item.delCheck = true;
							item.saveCheck = true;
						});
					}
				});
		 		dwr.TOPEngine.setAsync(true);
		   	};
		   	
		   	//等待加入到实体方法集合中的级联方法数组
		   	$scope.waitAddMethods = new comtop.ArrayList();
		   	/**
		   	 * 确定创建级联方法
		   	 */
		   	$scope.confirm = function(){
		   		var methodArray = new comtop.ArrayList();
		   		//级联读取方法
		   		var queryMethod = $scope.createBaseVO($scope.defaultMethodNameObj.cascadeQuery, "级联查询", "级联查询", "query", [{
		   			"chName":"查询的实体Id",
		   			"dataType":{
		   				"source":"primitive",
		   				"type":"String"
		   				},
		   				"description":"查询的实体Id",
		   				"engName":"entityId",
		   				"parameterId":((new Date()).valueOf()+1).toString(),
		   				"sortNo":0}],
		   				{
		   					"source":"entity",
							"type":"entity",
							"value":modelId
						}, true, 1);
		   		methodArray.add(queryMethod);
		   		//级联删除方法
		   		var deleteMethod = $scope.createBaseVO($scope.defaultMethodNameObj.cascadeDel, "级联删除", "级联删除", "delete", [{
		   			"chName":"删除的实体VO集合",
		   			"dataType":{
		   				"generic":[{
		   					"source":"entity",
		   					"type":"entity",
		   					"value":modelId}],
		   				"source":"collection",
		   				"type":"java.util.List"
		   			},
		   			"description":"删除的实体VO集合",
		   			"engName":"lstDelVO",
		   			"parameterId":((new Date()).valueOf()+2).toString(),
		   			"sortNo":0}],
		   			{
						"source":"primitive",
						"type":"boolean"
					}, false, 2);
		   		methodArray.add(deleteMethod);
		   		//级联保存方法
		   		var saveMethod = $scope.createBaseVO($scope.defaultMethodNameObj.cascadeSave, "级联保存", "级联保存", "save", [{
					"chName":"保存的实体VO",
					"dataType":{
						"source":"entity",
						"type":"entity",
						"value":modelId
					},
					"description":"保存的实体VO",
					"engName":"saveVO",
					"parameterId":((new Date()).valueOf()+3).toString(),
					"sortNo":0}],
	   				{
			   			"source":"primitive",
						"type":"String"
					}, false, 3);
		   		methodArray.add(saveMethod);
		   		var iterator = methodArray.iterator();
		   		//each methods 把方法的级联属性补全
		   		while(iterator.hasNext()){
		   			var methodObj = iterator.next();
		   			//each级联属性
		   			$scope.cascadeVOList.forEach(function(item, index, arr){
		   				//只做一级级联
		   				var temp = _.parseJSON(_.stringifyJSON(item));
   						temp.lstCascadeAttribute = null;
		   				switch (methodObj.methodOperateType) {
		   					case "query": 
			   					if(temp.queryCheck){
			   						methodObj.lstCascadeAttribute.push(temp);
			   					}
			   					break;
		   					case "delete": 
		   						if(temp.delCheck){
			   						methodObj.lstCascadeAttribute.push(temp);
			   					}
			   					break;
		   					case "save": 
		   						if(temp.saveCheck){
			   						methodObj.lstCascadeAttribute.push(temp);
			   					}
			   					break;
			   				default :
			   					//do nothing
		   				}
		   				//删除多余的属性
		   				$scope.delExtraAttri(temp); 
			   		});
		   		}
		   		//保存时，清空
		   		$scope.waitAddMethods = new comtop.ArrayList();
		   		
		   		iterator = methodArray.iterator(); //重新获取iterator
		   		//如果某个级联方法里面没级联属性，则不生成这个级联方法
		   		while(iterator.hasNext()){
		   			var temp = iterator.next();
		   			if(temp.lstCascadeAttribute.length > 0){
		   				$scope.waitAddMethods.add(temp);
		   			}
		   		}
		   		
		   		//vallidate
		   		var vali = validateAll();
		   		if(!vali.validFlag){
		   			cui.warn("方法名称不合法，请修改。");
		   			return;
		   		}
		   		
		   		var it = $scope.waitAddMethods.iterator();
		   		while(it.hasNext()){
			   		entity.methods.push(it.next());
		   		}
		   		
		   		window.parent.cap.digestValue(window.parent.scope);
		   		$scope.cancel();
		   	};
		   	
		   	/**
		   	 * 删除对象的额外属性。
		   	 *
		   	 * @param cascadeVo 被删除额外属性的对象
		   	 */ 
		   	$scope.delExtraAttri = function(cascadeVo){
		   		delete cascadeVo.queryCheck;
		   		delete cascadeVo.delCheck;
		   		delete cascadeVo.saveCheck;
		   	};
		   	
		   	/**
		   	 * 创建一个基本的vo。后面再针对不同级联方法设置不同的属性值。
			 *
			 * @param ename 方法英文名称
			 * @param cname 方法中文名称
			 * @param desc 方法描述
			 * @param methodOperateType 方法操作类型
			 * @param parameters 方法参数
			 * @param returnType 方法返回值
			 * @param transaction 标注只读事务
			 * @param n 防id重复的数字
		   	 * @return 返回一个方法VO（只包括一些基本信息）。
		   	 */
		   	$scope.createBaseVO = function(ename,cname,desc,methodOperateType,parameters,returnType,transaction,n){
		   		var method = {
		   				"accessLevel":"public",
		   				"aliasName":ename,
		   				"assoMethodName":"",
		   				"autoMethod":false,
		   				"chName":cname,
		   				"constraint":"",
		   				"description":desc,
		   				"engName":ename,
		   				"exceptions":[],
		   				"expPerformance":"",
		   				"features":"",
		   				"privateService":"false",
		   				"lstCascadeAttribute":[
		   				],//
		   				"methodId":((new Date()).valueOf() + n).toString(),
		   				"methodOperateType":methodOperateType,
		   				"methodSource":"entity",
		   				"methodType":"cascade",
		   				"needCount":false,
		   				"needPagination":false,
		   				"parameters":parameters,
		   				"returnType":returnType,
		   				"serviceEx":"none",
		   				"transaction":transaction
		   		};
		   		
		   		return method;
		   	};
		   	

		   	/**
		   	 * 关闭窗口
		   	 */
		   	$scope.cancel = function(){
		   		window.parent.fastCascadeMethodDialog.hide();
		   	};
		   	
		   	
		   	$scope.validateEngName = function(){
				cap.validater.validOneElement("cascadeQuery");
				cap.validater.validOneElement("cascadeDel");
				cap.validater.validOneElement("cascadeSave");
			};
			
		}]);
		
		//方法input控件的Id与级联属性是否在该方法中存在的标识
		var _map = {cascadeQuery:"queryCheck",cascadeDel:"delCheck",cascadeSave:"saveCheck"};
		
		/**
		 * 校验方法别名是否重复
		 */
		function checkAlisNameIsExist(self, engName) {
			var type = _map[self];
			//方法名是否需要校验
			var isNeedCheck = false;
			//判断当前这个方法是否需要校验，只要有选择一个级联属性，就要校验
			for(var i = 0, len = scope.cascadeVOList.length; i < len; i++){
				var obj = scope.cascadeVOList[i];
				if(obj[type]){
					isNeedCheck = true;
					break;
				}
			}
			
			//如果不需要校验，直接返回
			if(!isNeedCheck){
				return true;
			}
			
			//获取当前页面三个方法中需要校验的方法名的对象
			//clone
			var needCheckMethod = _.parseJSON(_.stringifyJSON(scope.defaultMethodNameObj));
			//循环三个方法
			for(var _attr in _map){
				var methodNeedCheckFlag = false;
				//判断当前方法是否有选中任何一个级联属性，有选择，就表示该方法需要参与校验，直接返回。
				for(var k = 0, len = scope.cascadeVOList.length; k < len; k++){
					if(scope.cascadeVOList[k][_map[_attr]]){
						methodNeedCheckFlag = true;
						break;
					}
				}
				//没有选中任何一个级联属性，表示不参与校验，剔除
				if(!methodNeedCheckFlag){
					delete needCheckMethod[_attr];
				}
			}
			
			//在需要校验的几个级联方法中进行判断是否有名称重复
			for(var attr in needCheckMethod){
				if(engName == needCheckMethod[attr] && self != attr){
					return false;
				}
			}
			
			//遍历当前实体方法判断是否存在重复别名
			for (var i = 0; i < entity.methods.length; i++) {
				if (entity.methods[i].aliasName == engName) {
					return false;
				}
			}
			//遍历实体的父实体方法
			for (var k = 0; k < parent.scope.parentEntityMethods.length; k++) {
				if (parent.scope.parentEntityMethods[k].aliasName == engName) {
					return false;
				}
			}
			return true;
		}

		/**
		 * 校验方法是否为空和是否存在特殊字符
		 */
		function checkBlankOrSpecialChars(self, engName){
			var type = _map[self];
			//方法名是否需要校验
			var isNeedCheck = false;
			//判断当前这个方法是否需要校验，只要有选择一个级联属性，就要校验
			for(var i = 0, len = scope.cascadeVOList.length; i < len; i++){
				var obj = scope.cascadeVOList[i];
				if(obj[type]){
					isNeedCheck = true;
					break;
				}
			}
			
			//如果不需要校验，直接返回
			if(!isNeedCheck){
				return true;
			}
			
			if(comtop.StringUtil.isBlank(engName)){
				return false;
			}
			
			var regEx = "^[a-z]\\w*$";
			var reg = new RegExp(regEx);
			return reg.test(engName);
		}
		
		
		/**
		 * 校验级联查询的方法
		 */
		function checkQueryMethodAliasNameIsExist(engName){
			return checkAlisNameIsExist("cascadeQuery", engName);
		}
		/**
		 * 校验级联查询的方法
		 */
		function checkQueryMethodBlankOrSpecialChars(engName){
			return checkBlankOrSpecialChars("cascadeQuery", engName);
		}
		
		/**
		 * 校验级联删除的方法
		 */
		function checkDeleteMethodAliasNameIsExist(engName){
			return checkAlisNameIsExist("cascadeDel", engName);
		}
		/**
		 * 校验级联删除的方法
		 */
		function checkDeleteMethodBlankOrSpecialChars(engName){
			return checkBlankOrSpecialChars("cascadeDel", engName);
		}
		
		/**
		 * 校验级联保存的方法
		 */
		function checkSaveMethodAliasNameIsExist(engName){
			return checkAlisNameIsExist("cascadeSave", engName);
		}
		/**
		 * 校验级联保存的方法
		 */
		function checkSaveMethodOrSpecialChars(engName){
			return checkBlankOrSpecialChars("cascadeSave", engName);
		}
		
		var queryMethodValidateRegular = [{
			'type': 'custom',
			'rule': {
				'against': checkQueryMethodBlankOrSpecialChars,
				'm': '方法名称不能为空且必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'
			}
		}, {
			'type': 'custom',
			'rule': {
				'against': checkQueryMethodAliasNameIsExist,
				'm': '与实体其他方法(包括父实体方法)别名重复。'
			}
		}];
		
		var deleteMethodValidateRegular = [{
			'type': 'custom',
			'rule': {
				'against': checkDeleteMethodBlankOrSpecialChars,
				'm': '方法名称不能为空且必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'
			}
		}, {
			'type': 'custom',
			'rule': {
				'against': checkDeleteMethodAliasNameIsExist,
				'm': '与实体其他方法(包括父实体方法)别名重复。'
			}
		}];
		
		var saveMethodValidateRegular = [{
			'type': 'custom',
			'rule': {
				'against': checkSaveMethodOrSpecialChars,
				'm': '方法名称不能为空且必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'
			}
		}, {
			'type': 'custom',
			'rule': {
				'against': checkSaveMethodAliasNameIsExist,
				'm': '与实体其他方法(包括父实体方法)别名重复。'
			}
		}];
		
		var validate = new cap.Validate();
		//统一校验函数
		function validateAll() {
			var validateRule = {
				cascadeQuery: queryMethodValidateRegular,
				cascadeDel: deleteMethodValidateRegular,
				cascadeSave: saveMethodValidateRegular
			};
			return validate.validateAllElement(scope.defaultMethodNameObj, validateRule);
		}
		
	</script>
</head>
<body class="body_layout" ng-controller="cascadeMethodCtrl" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td  class="cap-form-td" style="text-align: left;padding-left:5px; width:50%;">
						<span class="cap-group">快速创建级联方法</span>
			        </td>
			        <td  class="cap-form-td" style="text-align: right;padding-right:5px;">
						<span cui_button id="confim" button_type="green-button" ng-click="confirm()" label="确定" ng-if="cascadeVOList && cascadeVOList.length>0"></span>
						<span cui_button id="close" ng-click="cancel()" label="取消"></span>
			        </td>
			    </tr>
			    <tr>
			    	<td class="cap-form-td" colspan="2">
			            <table class="custom-grid" style="width: 100%;">
			                <thead>
			                    <tr>
			                    	<th>
		                            	级联属性名称
			                        </th>
			                        <th style="width:25%;">
		                            	级联读取方法
			                        </th>
			                        <th style="width:25%;">
		                            	级联删除方法
			                        </th>
			                        <th style="width:25%;">
		                            	级联保存方法
			                        </th>
			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="cascadeVo in cascadeVOList track by $index" >
	                                <td style="text-align:left;">
	                                    {{cascadeVo.name}}
	                                </td>
	                                <td style="text-align: center;">
	                                   <input type="checkbox" id="{{'queryCheck'+($index + 1)}}" ng-model="cascadeVo.queryCheck" ng-change="validateEngName()">
	                                </td>
	                                <td style="text-align: center;">
	                                   <input type="checkbox" id="{{'delCheck'+($index + 1)}}" ng-model="cascadeVo.delCheck" ng-change="validateEngName()">
	                                </td>
	                                <td style="text-align: center;">
	                                   <input type="checkbox" id="{{'saveCheck'+($index + 1)}}" ng-model="cascadeVo.saveCheck" ng-change="validateEngName()">
	                                </td>
	                            </tr>
	                            <tr ng-if="cascadeVOList && cascadeVOList.length>0">
	                            	<td style="text-align: left;font-weight:bold;">方法名</td>
	                            	<td style="text-align: left;"><span cui_input id="cascadeQuery" ng-model="defaultMethodNameObj.cascadeQuery" validate="queryMethodValidateRegular" width="100%" ng-change="validateEngName()"></span></td>
	                            	<td style="text-align: left;"><span cui_input id="cascadeDel" ng-model="defaultMethodNameObj.cascadeDel" validate="deleteMethodValidateRegular" width="100%" ng-change="validateEngName()"></span></td>
	                            	<td style="text-align: left;"><span cui_input id="cascadeSave" ng-model="defaultMethodNameObj.cascadeSave" validate="saveMethodValidateRegular" width="100%" ng-change="validateEngName()"></span></td>
	                            </tr>
	                            <tr ng-if="!cascadeVOList || cascadeVOList.length==0">
	                            	<td colspan="4" class="grid-empty">本列表暂无记录</td>
	                            </tr>
	                       </tbody>
			            </table>
			    	</td>
			    </tr>
			</table>
		</div>	
	</div>
</body>
</html>