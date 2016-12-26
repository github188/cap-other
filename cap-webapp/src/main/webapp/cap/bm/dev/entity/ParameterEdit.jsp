<%
/**********************************************************************
* 方法参数编辑页面
* 2015-10-13 凌晨
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='methodParamsList'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>方法参数编辑</title>
	<top:link href="/cap/bm/common/base/css/base.css"/>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/validate.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	<style type="text/css">
		
	</style>
	<script type="text/javascript" charset="UTF-8">
		//获得传递参数
		var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		var pId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("parameterId"))%>;
		var mId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("methodId"))%>;
		var methodType=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("methodType"))%>;
		var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var _=cui.utils;
		var PageStorage = new cap.PageStorage(modelId);
		var entity = PageStorage.get("entity");
		var currentMethodVO;
		entity.methods.some(function(item){
			if(item.methodId == mId){
				currentMethodVO = item;
				return true;
			}
			return false;
		});
		if(!currentMethodVO.parameters){
			currentMethodVO.parameters = [];
		}
		
		//拿到angularJS的scope
		var scope=null;
		angular.module('methodParamsList', ["cui"]).controller('methodParamsCtrl',['$scope',function ($scope) {
		   	$scope.currentParamVO = {};
			$scope.readOnly = methodType == 'cascade' || methodType == 'queryExtend' || methodType =='procedure' || methodType == 'function'? true : false;
			$scope.queryExtendReadOnly = methodType == 'queryExtend' ? true : "";
			$scope.queryReadOnly = methodType == 'queryExtend'|| methodType =='procedure' || methodType == 'function' ? true : "";
		   	
		   	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
		   	
		   	$scope.init=function(){
		   		
		   		//新增
		   		if(!pId){
		   			//创建一个参数对象。
			   		var newMethodParameter = {
			   				parameterId : (new Date()).valueOf(),
			   				engName : '',
			   				chName : '',
			   				description : '',
			   				sortNo : currentMethodVO.parameters.length, //初始化排序的序号为数组的长度（序号从0开始）
			   				dataType : {generic : null, type : 'String', value : null, source : 'primitive'}
			   		};
			   		$scope.currentParamVO = newMethodParameter;
		   		}else{ //编辑
		   			currentMethodVO.parameters.some(function(item){
		   				if(item.parameterId == pId){
		   					$scope.currentParamVO = _.parseJSON(_.stringifyJSON(item)); //把item转一下，否则编辑页面改变，父页面也会跟着变
		   					return true;
		   				}
		   				return false;
		   			});
		   		}
		   	};
			
		   	/**
		   	 * 改变参数类型
		   	 * 
		   	 * @param <code>paramType</code>参数类型
		   	 */
		   	$scope.changeParamType = function(paramType){
		   		//设置返回值类型
		   		$scope.currentParamVO.dataType.type = paramType;
		   		switch(paramType){
			   		case 'java.util.List' :
			   			var listValue = 'java.util.List<'+modelId+'>';
			   			$scope.setCurrentParamVODataType('collection', paramType, listValue, [{generic : null, type : 'entity', value : modelId, source : 'entity'}]);
			   			break;
			   		case 'java.util.Map' :
			   			var mapValue = 'java.util.Map<String,'+modelId+'>';
			   			$scope.setCurrentParamVODataType('collection', paramType, mapValue, [{generic : null, type : 'String', value : null, source : 'primitive'},{generic : null, type : 'entity', value : modelId, source : 'entity'}]);
			   			break;
			   		case 'entity' :
			   			$scope.setCurrentParamVODataType('entity', paramType, modelId, null);
			   			break;
			   		case 'java.lang.Object' :
			   			$scope.setCurrentParamVODataType('javaObject', paramType, '', null);
			   			break;
			   		case 'thirdPartyType' :
			   			$scope.setCurrentParamVODataType('thirdPartyType', paramType, '', null);
			   			break;
			   		default :
			   			$scope.setCurrentParamVODataType('primitive', paramType, null, null);
		   		}
		   	};
		   	
		   	/**
		   	 * 设置参数类型
		   	 *
		   	 * @param source 来源
		   	 * @param type 类型
		   	 * @param value 值
		   	 * @param generic 泛型
		   	 */
		   	$scope.setCurrentParamVODataType = function(source, type, value, generic){
		   		$scope.currentParamVO.dataType.source = source;
		   		$scope.currentParamVO.dataType.type = type;
		   		$scope.currentParamVO.dataType.value = value;
		   		$scope.currentParamVO.dataType.generic = generic;
		   	};
		   	
		   	/**
		   	 * 保存方法参数
		   	 *
		   	 */
		   	$scope.save = function(){
		   		//保存校验中、英文名称
		   		var result = validateAll();
		   		//校验泛型
		   		var _result = validateGeneric($scope.currentParamVO.dataType.type);
		   		
		   		//校验结果
		   		var finalResult = cap.finalValiResComposite([result, _result]);
		   		if(!finalResult.validFlag){
					cui.alert(finalResult.message);
					return;
				}
		   		
		   		var result = currentMethodVO.parameters.some(function(item,index,arr){
	   				if(item.parameterId == $scope.currentParamVO.parameterId){
	   					//更新
	   					arr[index] = $scope.currentParamVO;
	   					return true;
	   				}
	   				return false;
	   			});
	   			if(!result){ //新增
	   				currentMethodVO.parameters.push($scope.currentParamVO);
	   			}
	   			//新增成功后，去校验全选checkbox的状态（列表全部选中，再新增，成功后，全选checkbox状态应该为未选中）
	   			window.opener.scope.checkBoxCheck(window.opener.scope.selectEntityMethodVO.parameters, 'objCheckAll.methodParamsCheckAll');
	   			//渲染父页面
	   			cap.digestValue(window.opener.scope);
	   			$scope.close();
		   	};
		   	
		   	/**
		   	 * 关闭窗口
		   	 */
		   	$scope.close = function(){
		   		window.close();
		   	};

		}]);


     //关联实体属性选择界面
	var setAttributeGeneric=function(){
		var url = "SetEntityAttributeGeneric.jsp?packageId=" + packageId + "&modelId=" + modelId+"&openType=newWin";
		var title="属性泛型设置";
		var width=700; //窗口宽度
	    var height=600;//窗口高度
	    var top=(window.screen.height-30-height)/2;
	    var left=(window.screen.width-10-width)/2;
	    window.open(url, "ParameterEdit_setGeneric", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	};
   	
	//其他实体选择界面
	var selEntity=function(){
		var url = "SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=true&sourceEntityId="+modelId+"&openType=newWin";
		var title="选择目标实体";
		var height = 600; 
		var width =  400; 
	    var top=(window.screen.height-30-height)/2;
	    var left=(window.screen.width-10-width)/2;
	    window.open(url, "ParameterEdit_setEntity", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	}
		
		/**
		 * 校验是否已存在同名参数
		 *
		 * @param <code>eName</code> 参数英文名称
		 * @return <code>result</code>校验结果.true:存在同名参数;false:不存在同名参数
		 */
		var isExistSameNameParam = function(eName){
			var result = currentMethodVO.parameters.some(function(item){
				if(item.engName == eName && pId != item.parameterId){
					return true;
				}
				return false;
			});
			return !result;
		};		

		//验证规则
		var paramEngNameValRule = [{'type' : 'required', 'rule' : {'m': '参数名称不能为空'}}, {type : 'custom', rule : {against : 'isExistSameNameParam', m : '已存在同名的参数'}}, {'type':'custom','rule':{'against':checkEnNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以英文字符开头。'}}];
	    var paramChNameValRule = [{'type' : 'required', 'rule' : {'m': '中文名称不能为空'}}];
		
		var validate = new cap.Validate();
		//统一校验函数
		function validateAll(){
	    	var validateRule = {engName : paramEngNameValRule, chName : paramChNameValRule};
			return validate.validateAllElement([scope.currentParamVO],validateRule);
		}
		
		
		//参数实体校验规则
		var paramEntityValRule = [{'type' : 'required', 'rule' : {'m': '参数实体不能为空'}}];
		//参数泛型
		var paramGenericValRule = [{'type' : 'required', 'rule' : {'m': '参数泛型不能为空'}}];
		
		var paramThirdPartyTypeRule = [{'type' : 'required', 'rule' : {'m': '第三方类型不能为空'}},{'type' : 'custom', 'rule' : {'against':'checkClassExist', 'm': '第三方类型不存在'}}];
		
		function checkClassExist(){
			var isExist = false;
			dwr.TOPEngine.setAsync(false);
			EntityFacade.checkClassExist(scope.currentParamVO.dataType.value,function(result){
				isExist = result;
			});
			dwr.TOPEngine.setAsync(true);
			return isExist;
		}

		/**
		 * 校验参数对象中的参数泛型和参数实体
		 *
		 * @param <code>paramType</code>参数类型
		 */
		function validateGeneric(paramType){
			var validateRule = {};
			var validateObjs = [];
			//判断参数类型，如果是List、Map、Entity、第三方类型，均需校验
			switch(paramType){
				/***
				case 'java.util.List' :
					validateRule = {value : paramGenericValRule};
					validateObjs.push(scope.currentParamVO.dataType.generic[0]);
					break;
				case 'java.util.Map' :
					validateRule = {value : paramGenericValRule};
					validateObjs.push(scope.currentParamVO.dataType.generic[1]);
					break;
					****/
				case 'entity' :
					validateRule = {value : paramEntityValRule};
					validateObjs.push(scope.currentParamVO.dataType);
					break;
				case 'thirdPartyType' :
					validateRule = {value : paramThirdPartyTypeRule};
					validateObjs.push(scope.currentParamVO.dataType);
					break;

				
			}
			return validate.validateAllElement(validateObjs,validateRule);
		}
		 
		//实体选择回调
			function selEntityBack(selectNodeData) {
				scope.currentParamVO.dataType.value = selectNodeData.modelId;
				scope.$digest();
			}
			
			//泛型设置回调
			function setGeneric(genericString,genericDataList){
				scope.currentParamVO.dataType.value = genericString;
				scope.currentParamVO.dataType.generic = genericDataList;
				scope.$digest();
			}
			
			function getGenericList(){
				return scope.currentParamVO.dataType==null?[]:scope.currentParamVO.dataType.generic;
			}
			
			function getType(){
				return scope.currentParamVO.dataType.type;
			}
	</script>
</head>
<body class="body_layout" ng-controller="methodParamsCtrl" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td  class="cap-form-td" style="text-align: left;padding-left:5px; width:90px">
						<span class="cap-group">参数编辑</span>
			        </td>
			        <td  class="cap-form-td" style="text-align: right;padding-right:5px">
						<span cui_button id="save" ng-click="save()" label="确定"></span>
						<span cui_button id="close" ng-click="close()" label="关闭"></span>
			        </td>
			    </tr>
			    <tr>
			        <td class="cap-td" style="text-align: right;" nowrap="nowrap">
			        	<font color="red">*</font>参数名称：
			        </td>
			        <td class="cap-td" style="text-align: left;">
			        	<span cui_input  id="engName" ng-model="currentParamVO.engName" readonly ="{{queryReadOnly}}" width="100%" validate="paramEngNameValRule" ></span>
			        </td>
			    </tr>
			    <tr>
			    	<td class="cap-td" style="text-align: right;" nowrap="nowrap">
			        	<font color="red">*</font>中文名称：
			        </td>
			        <td class="cap-td" style="text-align: left;">
			        	<span cui_input  id="chName" ng-model="currentParamVO.chName" readonly ="{{queryExtendReadOnly}}" width="100%" validate="paramChNameValRule" ></span>
			        </td>
			    </tr>
			    <tr>
			    	<td class="cap-td" style="text-align: right;" nowrap="nowrap">
			        	<font color="red">*</font>参数类型：
			        </td>
			        <td class="cap-td" style="text-align: left;">
			        	<span cui_pulldown id="type" mode="Single" value_field="id" label_field="text" editable="false" ng-model="currentParamVO.dataType.type" ng-change="changeParamType(currentParamVO.dataType.type)" readonly="{{readOnly}}" width="100%">
							<a value="int">int</a>
							<a value="double">double</a>
							<a value="boolean">boolean</a>
							<a value="String">String</a>
							<a value="java.lang.Object">Object</a>
							<a value="java.util.List">java.util.List</a>
							<a value="java.util.Map">java.util.Map</a>
							<a value="java.sql.Timestamp">java.sql.Timestamp</a>
							<a value="entity">Entity</a>
							<a value="thirdPartyType">第三方类型</a>
						</span>
			        </td>
			    </tr>
			    <tr>
			    	<td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-if="currentParamVO.dataType.type == 'entity'" >
			        	<font color="red">*</font>参数实体：
			        </td>
			        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-if="currentParamVO.dataType.type == 'entity'" >
						<span cui_clickinput id="generic" readonly ="{{queryExtendReadOnly}}"  ng-model="currentParamVO.dataType.value" validate="paramEntityValRule" on_iconclick="selEntity" ng-click="" width="100%"></span>
					</td>
			        <td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-if="currentParamVO.dataType.type == 'java.util.List' || currentParamVO.dataType.type == 'java.util.Map'" >
			        	<font color="red"></font>参数泛型：
			        </td>
			        <td class="cap-td" style="text-align: left;" nowrap="nowrap" ng-if="currentParamVO.dataType.type == 'java.util.List' || currentParamVO.dataType.type == 'java.util.Map'" >
						<span cui_clickinput id="generic" readonly ="{{queryExtendReadOnly}}" ng-model="currentParamVO.dataType.value" ng-click="" width="100%" on_iconclick ="setAttributeGeneric"></span>
					</td>
			        <td class="cap-td" style="text-align: right;" nowrap="nowrap" ng-if="currentParamVO.dataType.type == 'thirdPartyType'" >
			        	<font color="red">*</font>第三方类型：
			        </td>
			        <td class="cap-td" style="text-align: left;" ng-if="currentParamVO.dataType.type == 'thirdPartyType'">
			        	<span cui_input id="generic" ng-model="currentParamVO.dataType.value" validate="paramEntityValRule" width="100%" readonly="{{readOnly}}"/>
			        </td>
			    </tr>
			    <tr>
			    	<td class="cap-td" style="text-align: right;" nowrap="nowrap">
			        	描述：
			        </td>
			        <td class="cap-td" style="text-align: left;">
			        	<span cui_textarea id="description" ng-model="currentParamVO.description" width="100%" readonly ="{{queryExtendReadOnly}}" height="60px" ></span>
			        </td>
			    </tr>
			</table>
		</div>	
	</div>
</body>
</html>