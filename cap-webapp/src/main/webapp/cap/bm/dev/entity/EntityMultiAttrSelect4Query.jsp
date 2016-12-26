<%
/**********************************************************************
* GridTable属性
* 2016-07-29 刘城2  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='customEditableGridThead'>
<head>
	<title>数据模型属性</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <style type="text/css">
    	.tab_panel {
    		height: 502px;
    		overflow: auto;
    	}
    	.properties-div{
    		height: 420px;
    		overflow: auto;
    	}
    	.custom_div{
    		height: 540px;
    		overflow: auto;
    	}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
</head>
<body ng-controller="customEditableGridTheadCtrl" data-ng-init="ready()">
<div>
	<div class="cap-area" style="padding: 2px;">
		<table class="cap-table-fullWidth">
				<tr>
			        <td class="cap-td" style="text-align: left;height: 35px;min-width:245px" nowrap="nowrap">
			        </td>
			        <td style="text-align: left;">
			        </td>
			        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
					    <!-- <span cui_button id="customHeaderUpButton" label="上移" ng-click="up()"></span> 
    						<span cui_button id="customHeaderDownButton" label="下移" ng-click="down()"></span> 
    						<span cui_button id="topCustom" label="置顶" ng-click="setTop()"></span> 
    						<span cui_button id="buttomCustom" label="置底" ng-click="setBottom()"></span> -->
			        </td>
			        <td class="cap-td" style="text-align: right;">
			        	<span cui_button id="saveButton" ng-click="saveCustomHeader()" label="确定"></span>
			        	<span cui_button id="deleteCustomHeader" label="删除" ng-click="deleteCustomHeader()"></span>
			        </td>
			    </tr>
			    <tr style="border-top:1px solid #ddd;">
			        <td class="cap-td" style="text-align: center; padding: 2px; width: 30%;">
			        	<div class="custom_div">
				        	<table class="custom-grid" style="width: 100%;">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="attributesCheckAll" ng-model="attributesCheckAll" ng-change="allCheckBoxCheckAttribute(attributes,attributesCheckAll)">
				                        </th>
				                        <th>
			                            	数据属性
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="attributeVo in attributes track by $index" ng-hide="attributeVo.isFilter">
		                            	<td style="text-align: center;">
		                                   <div ng-cloak><input type="checkbox" name="{{'attribute'+($index + 1)}}" ng-model="attributeVo.check" ng-change="checkBoxCheckAttribute(attributes,'attributesCheckAll')"></div>
		                                </td>
		                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
		                                   <div ng-cloak> {{attributeVo.engName}}({{attributeVo.chName}})</div>
		                                </td>
		                            </tr>
		                       </tbody>
				            </table>
			            </div>
			        </td>
			        <td style="text-align: left;border-right:1px solid #ddd;">
			        </td>
			        <td class="cap-td" style="text-align: center; padding: 2px; width: 60%" colspan="2">
			        	<div class="custom_div">
				        	<table class="custom-grid" style="width: 100%">
				                <thead>
				                    <tr>
				                    	<th style="width:30px">
				                    		<input type="checkbox" name="customHeadersCheckAll" ng-model="customHeadersCheckAll" ng-change="allCheckBoxCheckCustomHeader(customHeaders,customHeadersCheckAll)">
				                        </th>
				                        <th>
			                            	列名(columnName)
				                        </th>
				                        <th>
			                            	别名(Alias)
				                        </th>
				                    </tr>
				                </thead>
		                        <tbody>
		                            <tr ng-repeat="customHeaderVo in customHeaders track by $index" style="background-color: {{customHeaderVo.check == true ? '#99ccff':'#ffffff'}}">
		                            	<td style="text-align: center;">
		                                   <div ng-cloak> <input type="checkbox" name="customHeaderId" ng-model="customHeaderVo.check" ng-change="checkBoxCheckCustomHeader(customHeaders,'customHeadersCheckAll')"></div>
		                                </td>
		                                <td style="text-align:left;cursor:pointer" ng-dblclick="deleteCustomHeader()" ng-click="customHeaderTdClick(customHeaderVo)">
		                                   <div ng-cloak>{{customHeaderVo.chName}}</div>
		                                </td>
		                                <td class="cap-td" style="text-align: center;">
								        	<span cui_input validate="checkAliasNameRule" ng-model="customHeaderVo.aliasName"  width="100%"></span>
								        </td>
		                            </tr>
		                       </tbody>
				            </table>
			            </div>
			        </td>
			    </tr>
		</table>
	</div>
</div>

<script type="text/javascript">
var modelId = "${param.modelId}";
var scope = {};
var extras = window.parent.extras;
var actionType = "${param.actionType}";
var tableName = ""; //用来保存当前实体对应的 tableName
var tableAlias = "${param.tableAlias}"; //保存当前实体对应的tableAlias
var tableAliasDataArr = window.parent.scope.tableAttributes; //tableAttributes tableAliasDataArr
var selectAttrDataArr = window.parent.selectAttrDataArr;
var tableAliasData = {};
 var checkAliasNameRule = [{'type':'required', 'rule':{'m': '别名不能为空！'}},{ 'type':'custom','rule':{'against':rule_checkAliasName, 'm':'别名不能重复'}}];

 //保存按钮调用
 function validataRequired() {
	var validate = new cap.Validate();
	var valRule = {
		aliasName: checkAliasNameRule
	};
	return validate.validateAllElement(selectAttrDataArr, valRule);
}
angular.module('customEditableGridThead', ["cui"]).controller('customEditableGridTheadCtrl', function($scope, $compile) {
	//数据模型属性（左侧表格数据源）
	$scope.attributes　 = 　 [];
	$scope.attributesCheckAll　 = 　false;
	$scope.customHeadersCheckAll　 = 　false;
	$scope.isRefQueryModel = false;
	$scope.refQueryModel = {};
	//列头属性（右侧表格数据源）
	$scope.customHeaders　 = 　 [];
	$scope.ready = function() {
		scope = $scope;
		comtop.UI.scan();
		$scope.loadEntity();
		$scope.checkIsRefQueryModel();
		$scope.initAttributes();
		$scope.initTableAlias();
		$scope.initTableHeaders();
		$(window).resize(function() {
			$(".custom-div").height(getBodyHeight);
		});
	}

	//判断是否子查询
	$scope.checkIsRefQueryModel=function(){
		if (tableAlias!= null && tableAlias != "") {
			var allDataArr = getAllTableAlias();
			var index = _.findIndex(allDataArr,'subTableAlias', tableAlias);
			if (index>-1 && allDataArr[index].refQueryModel) {
				$scope.isRefQueryModel = true;
				$scope.refQueryModel =allDataArr[index].refQueryModel;
			};
		}
	}

	$scope.initRefQueryAttributes = function(refQueryModel) {
		var selectAttrDataArr = [];
		if (isEmptyObject(refQueryModel.select)) {
			return;
		}
		var selectAttrArr = refQueryModel.select.selectAttributes;
		for (var i = 0; i < selectAttrArr.length; i++) {
			//处理数据
			var newCustomHeaderVo = window.parent.createCustomHeaderVoByExtra(selectAttrArr[i]);
			//子查询中字段为别名
			newCustomHeaderVo.dbFieldId = newCustomHeaderVo.aliasName;
			selectAttrDataArr.push(newCustomHeaderVo);
		}
		return selectAttrDataArr;
	}


	$scope.initTableAlias = function() {
		//1、点开左边树链接都认为是新增 从FROM
		if (tableAlias == null || tableAlias == "") {
			tableAlias = getTableAlias();
			tableAliasData = {
				tableAlias: tableAlias,
				tableName: tableName,
				entityId: modelId,
			};
			tableAliasData.primarykey = $scope.attributes.length > 0 ? $scope.attributes[0].dbFieldId : "";
		}else{
			var tempArr = $.extend(true, [], window.parent.scope.tableAttributes);
			for (var i = 0; i < tempArr.length; i++) {
				if (tempArr[i].tableAlias == tableAlias) {
					tableAliasData = tempArr[i];
					break;
				}
			}
		}
		
	}
	
	//根据实体加载表名信息
	$scope.loadEntity = function() {
		dwr.TOPEngine.setAsync(false);
		EntityFacade.loadEntity(modelId, "", function(data) {
			if (data) {
				tableName = data.objBaseTableVO.engName
			}
		});
		dwr.TOPEngine.setAsync(true);
	}

	//初始化数据属性表格
	$scope.initAttributes = function() {
		if ($scope.isRefQueryModel) {
			$scope.attributes=$scope.initRefQueryAttributes($scope.refQueryModel);
		}else{
		dwr.TOPEngine.setAsync(false);
		EntityFacade.queryDbFieldAttributes(modelId, function(data) {
				$scope.attributes = data.list ? data.list : [];
		});
		dwr.TOPEngine.setAsync(true);
		}

	}

	//根据别名初始化表头数据列 只显示了当前实体的属性
	$scope.initTableHeaders = function() {
		var tempArr = $.extend(true, [], selectAttrDataArr);
		for (var i = 0; i < tempArr.length; i++) {
			//选择实体id相等的放入
			var objSelectAttr = tempArr[i];
			//修改为根据实体别名来判断
			if (objSelectAttr.tableAlias == tableAlias) {
				//处理数据
				var newCustomHeaderVo = $scope.createCustomHeaderVoByExtra(objSelectAttr);
				$scope.addCustomHeaderForInit(newCustomHeaderVo);
			}
		}
		$scope.customHeadersCheckAll　 = 　false;
	}

	//监控全选checkbox，如果选择则联动选中列表所有数据
	$scope.allCheckBoxCheckAttribute = function(ar, isCheck) {
		if (ar != null && isCheck) {
			for (var i = 0, len = ar.length; i < len; i++) {
				if (!ar[i].isFilter) {
					var newCustomHeaderVo = $scope.createCustomHeaderVo(ar[i]);
					$scope.addCustomHeader(newCustomHeaderVo,true);
				}
			}
		}
		$scope.attributesCheckAll = false;
	}

	//监控选中，如果列表所有行都被选中则选中allCheckBox
	$scope.checkBoxCheckAttribute = function(ar, allCheckBox) {
		if (ar != null) {
			var checkCount = 0;
			var allCount = 0;
			for (var i = 0; i < ar.length; i++) {
				if (ar[i].check) {
					checkCount++;
					var newCustomHeaderVo = $scope.createCustomHeaderVo(ar[i]);
					$scope.addCustomHeader(newCustomHeaderVo);
				}

				if (!ar[i].isFilter) {
					allCount++;
				}
			}


			if (checkCount == allCount && checkCount != 0) {
				eval("$scope." + allCheckBox + "=true");
			} else {
				eval("$scope." + allCheckBox + "=false");
			}
		}
	}

	//选中属性(数据模型属性)
	$scope.gridAttributeTdClick = function(attributeVo) {
		var newCustomHeaderVo = $scope.createCustomHeaderVo(attributeVo);
		$scope.addCustomHeader(newCustomHeaderVo);
	}

	//监控全选checkbox，如果选择则联动选中列表所有数据
	$scope.allCheckBoxCheckCustomHeader = function(ar, isCheck) {
		if (ar != null) {
			for (var i = 0; i < ar.length; i++) {
				if (isCheck) {
					ar[i].check = true;
				} else {
					ar[i].check = false;
				}
			}
		}
	}



	//监控选中，如果列表所有行都被选中则选中allCheckBox
	$scope.checkBoxCheckCustomHeader = function(ar, allCheckBox) {

	}


	//选中(定义表头表格)
	$scope.customHeaderTdClick = function(customHeaderVo) {
		for (var i in $scope.customHeaders) {
			$scope.customHeaders[i].check = false;
		}
		customHeaderVo.check = true;
		$scope.customHeadersCheckAll　 = 　$scope.customHeaders.length == 1 ? true : false;
	}

	//创建componentVo对象
	$scope.createCustomHeaderVo = function(attributeVo) {
		attributeVo.isFilter = true;
		attributeVo.check = false;
		return {
			customHeaderId: attributeVo.engName,
			chName: attributeVo.chName,
			engName: attributeVo.engName,
			aliasName: attributeVo.engName,
			dbFieldId: attributeVo.dbFieldId,
			entityId: modelId,
			tableName: tableName,
			tableAlias: tableAlias
		};
	}

	//根据objSelectAttrVo 过滤左侧数据显示
	$scope.createCustomHeaderVoByExtra = function(objSelectAttrVo) {
		var attributeVo = null;
		for (var i = 0; i < $scope.attributes.length; i++) {
			var tmpAttributeVo = $scope.attributes[i];
			if (tmpAttributeVo.dbFieldId == objSelectAttrVo.dbFieldId) {
				attributeVo = tmpAttributeVo;
				tmpAttributeVo.isFilter = true;
				tmpAttributeVo.check = false;
			}
		}
		return objSelectAttrVo;
	}

	//新增列
	$scope.addCustomHeader = function(customHeaderVo,isAllCheck) {
		$scope.customHeaders.push(customHeaderVo);
		for (var i in $scope.customHeaders) {
			$scope.customHeaders[i].check = false;
		}
		if (!isAllCheck) {
			customHeaderVo.check = true;
		}
		$scope.customHeadersCheckAll　 = 　false;

		//将结果放入容器数组 第一套方案
		/*var storeCustomHeaderVo = $.extend(true,{},customHeaderVo);
		storeCustomHeaderVo.check = false;
		selectAttrDataArr.push(storeCustomHeaderVo);//add
		console.log('selectAttrDataArradd',selectAttrDataArr);*/
	}

	//新增列
	$scope.addCustomHeaderForInit = function(customHeaderVo) {
		$scope.customHeaders.push(customHeaderVo);
		$scope.customHeadersCheckAll　 = 　false;
	}

	//删除自定义表头
	$scope.deleteCustomHeader = function() {
		var newArr = [];
		var delCustomHeaderIds = [];
		for (var i = 0, len = $scope.customHeaders.length; i < len; i++) {
			if (typeof($scope.customHeaders[i].check) == 'undefined' || !$scope.customHeaders[i].check) {
				newArr.push($scope.customHeaders[i]);
			} else {
				delCustomHeaderIds.push($scope.customHeaders[i].customHeaderId);
				//同时删除已保存的指定数据
				//var queryCustomVo = {};

				//第一套方案
				/*var storeCustomHeaderVo = $.extend(true,{},$scope.customHeaders[i]);
				storeCustomHeaderVo.check = false;
				var index = _.findIndex(selectAttrDataArr,storeCustomHeaderVo);
				console.log('index',index);
				console.log('selectAttrDataArr',selectAttrDataArr);
				selectAttrDataArr.splice(index,1);
				console.log('selectAttrDataArr',selectAttrDataArr);*/
			}
		}
		if(delCustomHeaderIds.length<1){
			cui.alert("请选择需要删除的属性!");
			return false;
		}
		$scope.customHeaders = newArr;
		$scope.showAttributeVO(delCustomHeaderIds);
		$scope.customHeadersCheckAll = false;


	}

	//显示隐藏数据
	$scope.showAttributeVO = function(engNames) {
		for (var i = 0, len = engNames.length; i < len; i++) {
			for (var j = 0, len2 = $scope.attributes.length; j < len2; j++) {
				if ($scope.attributes[j].engName == engNames[i]) {
					$scope.attributes[j].isFilter = false;
					break;
				}
			}
		}
		$scope.checkBoxCheckAttribute($scope.attributes, false);
		$scope.attributesCheckAll = false;
	}

	//上移
	$scope.up = function() {
		if ($scope.customHeaders.length > 0 && $scope.customHeaders[0].check) {
			return;
		}
		var mobileHeaders = [];
		for (var i in $scope.customHeaders) {
			if ($scope.customHeaders[i].check) {
				mobileHeaders.push($scope.customHeaders[i]);
			}
		}
		for (var i in mobileHeaders) {
			var currentData = mobileHeaders[i];
			if (currentData.customHeaderId != null) {
				var currentIndex = 0;
				var frontData = {};
				for (var i in $scope.customHeaders) {
					if ($scope.customHeaders[i].customHeaderId == currentData.customHeaderId) {
						currentIndex = i;
						break;
					}
				}
				if (currentIndex > 0) {
					frontData = $scope.customHeaders[currentIndex - 1];
					$scope.customHeaders.splice(currentIndex - 1, 2, currentData);
					$scope.customHeaders.splice(currentIndex, 0, frontData);
				}
			}
		}
	}

	//下移
	$scope.down = function() {
		var len = $scope.customHeaders.length;
		if (len > 0 && $scope.customHeaders[len - 1].check) {
			return;
		}
		var mobileHeaders = [];
		for (var i in $scope.customHeaders) {
			if ($scope.customHeaders[i].check) {
				mobileHeaders.push($scope.customHeaders[i]);
			}
		}
		mobileHeaders = mobileHeaders.reverse();
		for (var i in mobileHeaders) {
			var currentData = mobileHeaders[i];
			if (currentData.customHeaderId != null) {
				var currentIndex = 0;
				var nextData = {};
				for (var i in $scope.customHeaders) {
					if ($scope.customHeaders[i].customHeaderId == currentData.customHeaderId) {
						currentIndex = i;
						break;
					}
				}
				if (currentIndex < len - 1) {
					nextData = $scope.customHeaders[parseInt(currentIndex) + 1];
					$scope.customHeaders.splice(parseInt(currentIndex) + 1, 1, currentData);
					$scope.customHeaders.splice(currentIndex, 1, nextData);
				}
			}
		}
	}

	//置顶
	$scope.setTop = function() {
		var selectedComponents = [];
		var notSelectedComponents = [];
		for (var i in $scope.customHeaders) {
			if ($scope.customHeaders[i].check) {
				selectedComponents.push($scope.customHeaders[i]);
			} else {
				notSelectedComponents.push($scope.customHeaders[i]);
			}
		}
		$scope.customHeaders = _.union(selectedComponents, notSelectedComponents);
	}

	//置底
	$scope.setBottom = function() {
		var selectedComponents = [];
		var notSelectedComponents = [];
		for (var i in $scope.customHeaders) {
			if ($scope.customHeaders[i].check) {
				selectedComponents.push($scope.customHeaders[i]);
			} else {
				notSelectedComponents.push($scope.customHeaders[i]);
			}
		}
		$scope.customHeaders = _.union(notSelectedComponents, selectedComponents);
	}

	//根据要求，所有别名相同的属性放在一起 选用第二套方案
	$scope.updateParentSelectAttrDataArr = function(curArr) {
		var headArr = []; //当前别名之前的数据
		var endArr = []; //当前别名之后的数据
		var breakFlag = false; //截断标志
		for (var i = 0; i < selectAttrDataArr.length; i++) {
			if (selectAttrDataArr[i].tableAlias == tableAlias) {
				breakFlag = true;
			} else {
				if (!breakFlag) {
					headArr.push(selectAttrDataArr[i]);
				} else {
					endArr.push(selectAttrDataArr[i])
				}
			}
		}

		var tmpCurArr = $.extend(true, [], curArr);
		for (var i = 0; i < tmpCurArr.length; i++) {
			tmpCurArr[i].check = false;
		}

		var middle = _.union(headArr, tmpCurArr);
		//如果用selectAttrDataArr = _.union(middle,endArr); 则改变了selectAttrDataArr的指向
		window.parent.selectAttrDataArr = _.union(middle, endArr);
		selectAttrDataArr = window.parent.selectAttrDataArr;
	}

	//检查selectAttrDataArr属性里是否有当前别名 将别名信息添加入
	$scope.updateParenttableAliasDataArr = function() {
		var index = _.findIndex(selectAttrDataArr, 'tableAlias', tableAlias);
		var aliasIndex = _.findIndex(tableAliasDataArr, tableAliasData);
		//如果selectAttrDataArr不存在当前实体对应别名的值
		if (index == -1) {
			if (aliasIndex != -1) {
				//如果primarykey存在则说明是新建的，可以删除 
				if (tableAliasData.primarykey) {
					tableAliasDataArr.splice(aliasIndex, 1);
					window.parent.scope.selectEntity = {};
					window.parent.scope.$digest();
				}
				
			}
		} else {
			if (aliasIndex == -1) {
				tableAliasDataArr.push(tableAliasData);
				window.parent.scope.selectEntity = tableAliasData;
				window.parent.scope.$digest();
			}
		}
	}

	//监控右侧已选数据的变化 attributes customHeaders
	$scope.$watch("customHeaders", function(newArr, oldArr, scope) {
		if (newArr != oldArr) {
			//处理 window.parent.selectAttrDataArr的数据
			$scope.updateParentSelectAttrDataArr(newArr);
			//检查selectAttrDataArr属性里是否有当前别名 将别名信息添加入
			if (actionType == 'select') $scope.updateParenttableAliasDataArr();
		}
	}, true);

	//保存
	$scope.saveCustomHeader = function() {
		var reData = {};
		reData.selectAttrData = selectAttrDataArr;
		if (actionType == 'select'){
			reData.tableAliasDataArr = tableAliasDataArr;
		}
		
		//校验必填项
		if(!validataRequired().validFlag){
			//判断查询结果字段别名的唯一性
			var aliasNameRepeatData = getSelectAttributeRepeatAliasName(reData);
			if(aliasNameRepeatData.length>0){
				var nameString = "";
				for(var i = 0;i < aliasNameRepeatData.length;i++){
					if(i == aliasNameRepeatData.length-1){
						nameString = nameString + aliasNameRepeatData[i]
					}else{
						nameString = nameString + aliasNameRepeatData[i] + ",";
					}
				}
				cui.alert("当前查询结果别名"+ nameString +"存在重复,请重新填写!");
			}
			return false;
		}
		if (cui("#saveButton").options.disable) { //按钮设置为禁止，但控件所绑定的事件并没取消绑定
			return;
		}
		if (selectAttrDataArr.length == 0 || modelId == '') {
			cui.alert("请选择数据对象。");
			return;
		}

		
		//回调
		if (actionType=='select') {
			window.parent.parent.selectCallBack(reData);
		}else if (actionType=='where') {
			window.parent.parent.whereCallBack(reData);
		}else if (actionType=='orderBy') {
			window.parent.parent.orderByCallBack(reData);
		}else if (actionType=='groupBy') {
			window.parent.parent.groupByCallBack(reData);
		}
		
	}

});


//判断对象不为空
function isNotEmptyObject(obj) {
	for (var name in obj) {
		return true;
	}
	return false;
}

//判断对象是否为空
function isEmptyObject(obj) {
	for (var name in obj) {
		return false;
	}
	return true;
}


//获取表别名，默认规则为t+数字
function getTableAlias() {
	var tableAlias = "t";
	var allDataArr = getAllTableAlias();
	var sortNo = 1;
	for (var i = 0; i < allDataArr.length; i++) {
		var index = allDataArr[i].subTableAlias.substring(1);
		if (isNaN(index)) {
			continue;
		}
		if (parseInt(index) == sortNo) {
			sortNo = parseInt(index) + 1;
		}
	}
	for (var i = 0; i < tableAliasDataArr.length; i++) {
		var index = tableAliasDataArr[i].tableAlias.substring(1);
		if (isNaN(index)) {
			continue;
		}
		if (parseInt(index) >= sortNo) {
			sortNo = parseInt(index) + 1;
		}
	}
	return tableAlias + sortNo;
}

/**
 *合并子查询和主查询数据
 */
function getAllTableAlias() {
	/*var dataArr = [];
	var pTable = extras.from.primaryTable;
	if (pTable) {
		//pTable.subTableAlias = pTable.subTableAlias;
		dataArr.push(pTable);
	}
	var subQuerys = extras.from.subquerys;
	if (subQuerys) {
		dataArr = _.union(dataArr, subQuerys);
	}
	return dataArr;*/
	return window.parent.getAllTableAlias();
}


function rule_checkAliasName(aliasName) {
	return isExistValidate(selectAttrDataArr, 'aliasName', aliasName);
}


//是否已存在
function isExistValidate(objList, key, value) {
	var ret = true;
	//num=1表示当前值
	var num = 0;
	for (var i in objList) {
		if (objList[i][key] == value) {
			num++;
		}
		if (num > 1) {
			ret = false;
			break;
		}
	}
	return ret;
}

/**
 * select属性的别名唯一校验  
 * @param retData select 属性列表
 */
function getSelectAttributeRepeatAliasName(reData) {
	var selectAttrData = reData.selectAttrData;
	var result = new Array();
	if(selectAttrData){
		for(var i = 0;i < selectAttrData.length;i++){
			var selectAttribute = selectAttrData[i];
			for(var k = 0;k < selectAttrData.length;k++){
				if(i == k){
					continue;
				}
				if(selectAttribute.aliasName == selectAttrData[k].aliasName){
					result.push(selectAttribute.aliasName);
				}
			}
		}
	}
	//去掉数组重复元素
	result = _.uniq(result);
	return result;
}
</script>
</body>
</html>
