<%
/**********************************************************************
* entitytype属性(EditableGrid控件中的属性)
* 2015-07-14 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='customEditableGridEntityType'>
<head>
	<title>entitytype属性</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <style type="text/css">
    	.custom-div {
    		height: 546px;
    		overflow: auto;
    	}
    	.properties-div {
    		height: 460px;
    		overflow: auto;
    	}
    	.form_table{
		    width:310px;
		}
    	.tab_panel{
    		overflow-x:hidden;
    	}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cip_common.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/selectDataModel.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/grid.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
</head>
<body ng-controller="customEditableGridEntityTypeCtrl" data-ng-init="ready()">
<div>
	<div class="cap-area" style="padding: 2px">
		<table class="cap-table-fullWidth">
			<tr>
		        <td class="cap-td" style="text-align: right;height: 35px" colspan="3">
		        	<span cui_button id="saveButton" ng-click="save()" label="确定"></span>
		        </td>
		    </tr>
		    <tr style="border-top:1px solid #ddd;">
		        <td class="cap-td" style="text-align: center; padding: 2px; width: 45%;">
		        	<div class="custom-div">
			        	<table class="custom-grid" style="width: 100%;">
			                <thead>
			                    <tr>
			                    	<th style="width:30px">
			                    		<input type="checkbox" name="bindNamesCheckAll" ng-model="bindNamesCheckAll" ng-change="allCheckBoxCheck(culomnsBindNames,bindNamesCheckAll)">
			                        </th>
			                        <th>
		                            	bindName
			                        </th>
			                        <th>
		                            	编辑控件
			                        </th>
			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="culomnsBindNameVo in culomnsBindNames track by $index" style="background-color: {{culomnsBindNameVo.check==true ? '#99ccff':'#ffffff'}}">
	                                <td style="text-align: center;">
	                                    <input type="checkbox" name="{{'check'+($index + 1)}}" ng-model="culomnsBindNameVo.check" ng-change="checkBoxCheck(culomnsBindNames,'bindNamesCheckAll')">
	                                </td>
	                                <td style="text-align:left;cursor:pointer" ng-click="gridCulomnsBindNameTdClick(culomnsBindNameVo)">
	                                    {{culomnsBindNameVo.bindName}}
	                                </td>
	                                <td style="text-align:left;cursor:pointer" ng-click="gridCulomnsBindNameTdClick(culomnsBindNameVo)">
	                                    {{culomnsBindNameVo.data.uitype}}
	                                </td>
	                            </tr>
	                            <tr>
							        <td class="cap-form-td" style="text-align: left;" colspan="3">
								        <span id="remark" style="font-weight:bold;color:red ">备注:</span>
								        <span id="remarkContent" style="font-weight:bold;">勾选多个复选框实现批量修改,点击行或单选复选框实现单个修改</span>
							        </td>
							    </tr>
	                       </tbody>
			            </table>
		            </div>
		        </td>
		        <td style="text-align: left;border-right:1px solid #ddd;">
		        </td>
		        <td class="cap-td" style="text-align: center; padding: 2px; width: 55%; " nowrap="nowrap">
		        	<table class="cap-table-fullWidth">
						<tr>
					        <td class="cap-td" style="text-align: left;height: 35px;border-bottom:1px solid #ddd;">
					        	控件类型：&nbsp;&nbsp;
					        	<span cui_pulldown id="uitype" name="uitype" ng-model="uitype" datasource="initUItypeData" value_field="id" label_field="text"></span>
					        </td>
					        <td class="cap-td" style="text-align: left;height: 35px;border-bottom:1px solid #ddd;">
					        	<span cui_button id="batchUpdateBtn" ng-show="hasBatchOperation" ng-click="batchUpdate()" label="批量修改"></span>
					        </td>
					    </tr>
					    <tr>
					    	<td class="cap-td" style="text-align: left;">
						    <div id="attr_area">
								<ul class="tab"> 
									<li ng-class="{'attr':'active'}[active]" ng-click="showPanel('attr')">属性</li>
									<li ng-class="{'action':'active'}[active]" ng-click="showPanel('action')">行为</li>
								</ul>
								<div id="properties-div" class="properties-div"></div>
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
		var propertyName = "<c:out value='${param.propertyName}'/>";
		var initValue = window.opener.getValue(propertyName);
		initValue = initValue != null && initValue != '' ? eval("("+initValue+")") : {};
		var pageSession = window.opener.pageSession;
		var pageId = window.opener.pageId;
		var packageId = window.opener.packageId;
		
		var columns = window.opener.scope.data.columns;
		columns = columns != null && columns != '' ? eval("("+columns+")") : {};
		var entityType = window.opener.scope.data.entityType;
		entityType = entityType != null && entityType != '' ? eval("("+entityType+")") : {};
		
		var extras = window.opener.scope.data.extras;
		extras = extras != null && extras != '' ? JSON.parse(extras) : {};
		var selectedEntityId = extras.entityId != null ? extras.entityId : '';
		
		var pageDataStores = pageSession.get("dataStore");
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
	    var scope = {};
	    
		angular.module('customEditableGridEntityType', ["cui"]).controller('customEditableGridEntityTypeCtrl', function ($scope, $compile) {
	    	//数据模型属性（左侧表格数据源）
			$scope.culomnsBindNames=[];
			$scope.culomnsBindNameVo = {};
			$scope.batchEditBindNames = [];
			$scope.batchEditBindNameVo = {};
	    	//被选中的数据模型属性对象
	    	$scope.bindNamesCheckAll　=　false;
	    	$scope.component　=　{};
	    	$scope.uitype;
	    	$scope.batchEditProperties = {};
	    	$scope.hasBatchOperation = false;
	    	$scope.attributes = getAttributesByCondition(selectedEntityId, pageDataStores);
	    	
	    	//默认显示属性tab标签
	    	$scope.active='attr';
	    	$scope.componentlayout = {"height":"auto","overflow-y": "auto"}
	    	
	    	$scope.ready=function(){
    			$scope.culomnsBindNames = [];
	    		for(var i in columns){
	    			if(_.isArray(columns[i])){
	    				for(var j in columns[i]){
	    					$scope.initCulomnsBindNames(columns[i][j], j);
	    				}
	    			} else {
	    				$scope.initCulomnsBindNames(columns[i], i);
	    			}
	    		}
	    		$scope.culomnsBindNames[0].check = true;
	    		$scope.culomnsBindNameVo = $scope.culomnsBindNames.length >0 ? $scope.culomnsBindNames[0] : {};
	    		$scope.uitype = $scope.culomnsBindNameVo.data != null ? $scope.culomnsBindNameVo.data.uitype : '';
		    	scope=$scope;
				$(window).resize(function() {
		    		$(".custom-div").height(getBodyHeight);
	    		});
		    };
	    	
		    $scope.initCulomnsBindNames=function(columnVo, id){
		    	if(columnVo.bindName != null){
    				var data = null;
    				for(var key in initValue){
    					if(columnVo.bindName === key){
    						data = {};
    						data = initValue[key]; 
    						break;
    					}
    				}
    				var culomnsBindNameVo = {id:id, bindName:columnVo.bindName};
    				if(data != null){
    					culomnsBindNameVo.data = data;
    				}
    				$scope.culomnsBindNames.push(culomnsBindNameVo);
    			}
		    }
		    
		    //切换Tab标签
	    	$scope.showPanel=function(msg){
	    		$scope.active=msg;
	    	}
		    
	    	//剔除属性值为空或null的值
	    	$scope.filterBlankAndEmpty=function(obj){
	    		for(var key in obj){
    				if(obj[key] === null || obj[key] === '' || typeof(obj[key]) === 'function' 
    						|| obj[key] === 'null'){
    					delete obj[key];
    				}
	    		}
	    	}
		  
	    	//保存
			$scope.save=function(){
				if(cui("#saveButton").options.disable){
					return ;
				}
				var result = validateAll();
	     	  	if(!result.validFlag){
	     	  		cui.alert(result.message); 
	     	  		return;
	     	  	}
				var culomnsBindNames = jQuery.extend(true, [], $scope.culomnsBindNames);
				var jsonToEntityType = "";
	    		for(var i in culomnsBindNames){
	    			var culomnsBindName = culomnsBindNames[i];
	    			var entityType = culomnsBindName.data;
	    			if(entityType != null){
	    				//剔除属性值为空或null的值
	    				$scope.filterBlankAndEmpty(entityType);
	    				var propertiesType = culomnsBindName.propertiesType;
	    	    		//根据控件属性类型转换
	    	    		for(var key in propertiesType){
	        				var type = propertiesType[key];
	        				if(entityType[key] == null){
	        					continue;
	        				}
	        				if(type === 'Number'){
	        					entityType[key] = Number(entityType[key]);
	        				} else if(type === "Boolean"){
	        					entityType[key] = entityType[key] === "true" ? true : false;
	        				} else if(type === "Json"){
	        					try{
	        						entityType[key] = eval("("+ entityType[key] +")");
	        					} catch (e){
	        						entityType[key] = entityType[key];
	        					}
	        				} else {
	        					entityType[key] = entityType[key];
	        				} 
	        			}
	    	    		var hasThrdUI = hasThrdComponent(entityType.uitype);
		    			if(hasThrdUI){
		    				entityType.thrdui = true;
		    			}
		    			//wrapOptions(entityType);
	    				jsonToEntityType += '"'+culomnsBindName.bindName+'":'+JSON.stringify(entityType)+',';
	    			}
	    		}
	    		if(jsonToEntityType != ''){
	    			jsonToEntityType = "{"+jsonToEntityType.substring(0,jsonToEntityType.length-1)+"}";
	    		}
	    		window.opener[callbackMethod](propertyName, jsonToEntityType);
	    		//importIncludeFileList(jsonToEntityType != '' ? eval("("+jsonToEntityType+")") : {}, pageSession.get("page"));//根据控件定义类型是否用人员或组织、数字字典，引用相关文件(js\css)
	    		window.close();
			};
			
			//批量修改
			$scope.batchUpdate=function(){
				cui.confirm('您确定要执行批量修改操作？',{
					onYes:function(){
						if($scope.uitype != ''){
							var commonProperyVo = {};
			    			for(var key in $scope.batchEditProperties){
			    				if($scope.batchEditProperties[key] === true){
				    				commonProperyVo[key] = $scope.batchEditBindNameVo.data[key];
			    				}
				    		}
			    			if(!$scope.hasChangeComponent){
			    				for(var i in $scope.batchEditBindNames){
			    					$scope.batchEditBindNames[i].propertiesType = $scope.batchEditBindNameVo.propertiesType;
					    			$scope.batchEditBindNames[i].data = jQuery.extend(true, {}, $scope.batchEditBindNames[i].data, commonProperyVo);
					    		}
			    			} else {
			    				for(var i in $scope.batchEditBindNames){
			    					$scope.batchEditBindNames[i].propertiesType = $scope.batchEditBindNameVo.propertiesType;
					    			$scope.batchEditBindNames[i].data = jQuery.extend(true, {uitype:$scope.uitype}, commonProperyVo);
					    		}
			    			}
						} else {
							for(var i in $scope.batchEditBindNames){
								delete $scope.batchEditBindNames[i].propertiesType;
								delete $scope.batchEditBindNames[i].data;
				    		}
						}
			    		cui.message('批量修改成功！', 'success');
			    		$scope.gridCulomnsBindNameTdClick($scope.culomnsBindNames[0]);
			    		cap.digestValue(scope);
					}
				});
			}
			
	    	//选中属性(数据模型属性)
	    	$scope.gridCulomnsBindNameTdClick=function(culomnsBindNameVo){
	    		$scope.culomnsBindNameVo = culomnsBindNameVo;
	    		if($scope.batchEditBindNames.length > 0){//此前是批量操作
	    			$scope.batchEditBindNames = [];
    				$scope.uitype = culomnsBindNameVo.data != null && culomnsBindNameVo.data.uitype != null ? culomnsBindNameVo.data.uitype : '';
    				if($scope.uitype != ''){
		    			$scope.loadComponent($scope.uitype);
	    			} 
	    		} else if(culomnsBindNameVo.data != null){
	    			if($scope.uitype === culomnsBindNameVo.data.uitype){//单个操作，但控件类型一样
		    			$scope.loadComponent($scope.uitype);
		    		} else {//不同控件类型
		    			$scope.uitype = culomnsBindNameVo.data.uitype != null ? culomnsBindNameVo.data.uitype : '';
		    		}
	    		} else {
	    			$scope.uitype = '';
	    		}
	    		for(var i in $scope.culomnsBindNames){
    				$scope.culomnsBindNames[i].check = false;
	    		}
	    		$scope.bindNamesCheckAll = false;
	    		$scope.culomnsBindNameVo.check = true;
	    		$scope.hasBatchOperation = false;
	    		cui("#uitype").setReadonly(false);
		    };
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheck=function(ar,isCheck){
	    		if(ar!=null){
	    			$scope.batchEditBindNames = [];
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
		    				$scope.batchEditBindNames.push(ar[i]);
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}
	    			if(isCheck){
		    			if($scope.hasSameType() === true){
			    			var selectedValue = $scope.batchEditBindNames[0].data != null ? $scope.batchEditBindNames[0].data.uitype : '';
			    			$scope.culomnsBindNameVo = {data: {uitype: selectedValue}};
			    			if($scope.uitype === selectedValue){
				    			$scope.loadComponent(selectedValue);
				    		} else {
				    			$scope.uitype = selectedValue;
				    		}
	    				} else {
			    			$scope.hasBatchOperation = false;
	    					$scope.culomnsBindNameVo = {};
	    					$scope.uitype = '';
		    				$('#propertyEditorUI').html('');
	    				}
		    		} else {
		    			$scope.hasBatchOperation = false;
		    			$scope.culomnsBindNameVo = {};
		    			$scope.uitype = '';
		    			$('#propertyEditorUI').html('');
		    		}
	    		}
	    	};
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheck=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=0;
	    			var selectedValue = '';
	    			$scope.batchEditBindNames = [];
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
		    				$scope.batchEditBindNames.push(ar[i]);
			    		}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
		    		if(checkCount == 1) {
		    			selectedValue = ($scope.batchEditBindNames[0].data != null && $scope.batchEditBindNames[0].data.uitype != null) ? $scope.batchEditBindNames[0].data.uitype : selectedValue;
			    		$scope.culomnsBindNameVo = $scope.batchEditBindNames[0];
			    		$scope.batchEditBindNames = [];
		    		} else if(checkCount > 1 && $scope.hasSameType() == true){
			    		selectedValue = $scope.batchEditBindNames[0].data != null ? $scope.batchEditBindNames[0].data.uitype : '';
		    			$scope.culomnsBindNameVo = {data: {uitype: selectedValue}};
		    		} else {
		    			$scope.culomnsBindNameVo = {};
		    			$scope.hasBatchOperation = false;
		    		}
		    		if($scope.uitype === selectedValue){
		    			$scope.loadComponent(selectedValue);
		    		} else {
		    			$scope.uitype = selectedValue;
		    		}
	    		}
	    	};
	    	
	    	//批量修改编辑控件，判断是否是同一类控件类型
	    	$scope.hasSameType=function(){
	    		var ret = true;
	    		if($scope.batchEditBindNames.length > 0){
	    			var selectedValue = $scope.batchEditBindNames[0].data != null ? $scope.batchEditBindNames[0].data.uitype : '';
	    			for(var i=1;i<$scope.batchEditBindNames.length;i++){
	    				var culomnsBindNameVo = $scope.batchEditBindNames[i];
	    				if((culomnsBindNameVo.data == null && selectedValue != '') || 
	    						(culomnsBindNameVo.data != null && culomnsBindNameVo.data.uitype != selectedValue)){
	    					ret = false;
	    					break;
	    				} 
		    		}
	    		} else {
	    			ret = false;
	    		}
    			return ret;
	    	}
	    	
	    	$scope.$watch("uitype", function(newValue, oldValue){
	    		if(newValue != null && newValue != ""){
	    			if(!$scope.culomnsBindNameVo.data || $scope.culomnsBindNameVo.data.uitype != newValue){//同一个列表更改控件定义类型，需要重新初始化$scope.data.edittype.data
	    				$scope.culomnsBindNameVo.data = {uitype: newValue};
	    			}
	    			//实体属性默认值绑定到控件对应的属性中（目前只有数据字典和枚举）
	    			setAttrDefault2ComponentOptions(newValue, $scope.attributes, $scope.culomnsBindNameVo.bindName, $scope.culomnsBindNameVo.data);
	    			$scope.loadComponent(newValue);
	    		} else {
	    			if($scope.batchEditBindNames.length == 0){
		    			delete $scope.culomnsBindNameVo.data;
		    		} 
	    			$('#properties-div').html("");
	    		}
	    	}, false);
	    	
	    	//通过监控控制控件类型下拉框状态
	    	$scope.$watch("batchEditBindNames", function(newValue, oldValue){
	    		var readnoly = false;
	    		if(newValue.length > 1){
		    		var hasSameType = $scope.hasSameType();
		    		readnoly = !hasSameType;
	    		} else {
	    			readnoly = !$scope.culomnsBindNameVo.check;
	    		}
	    		cui("#uitype").setReadonly(readnoly);
	    	});
	    	
	    	//通过监控控制确认按钮状态
	    	$scope.$watch("hasBatchOperation", function(newValue, oldValue){
	    		cui("#saveButton").disable(newValue);
	    	});
	    	
	    	//加载控件属性
	    	$scope.loadComponent=function(componentName){
	    		if(componentName != null && componentName != ''){
	    			var group = componentName == 'ChooseOrg' || componentName == 'ChooseUser' ? 'expand' : 'common';
		    		var modelId = "uicomponent."+ group +".component."+componentName.substring(0, 1).toLowerCase()+componentName.substring(1);
	    			$scope.component = getComponentByModelId(modelId, window.opener.parent.toolsdata);
	    			//常用事件
    				$scope.component.commonEvents = [];
    				//非常用事件
    				$scope.component.notCommonEvents = [];
    				for(var i in $scope.component.events){
    					if($scope.component.events[i].commonAttr){
    						$scope.component.commonEvents.push($scope.component.events[i]);
    					} else {
    						$scope.component.notCommonEvents.push($scope.component.events[i]);
    					}
    				}
    				
    				//常用属性
    				$scope.component.commonProperties = [];
    				//非常用属性
    				$scope.component.notCommonProperties = [];
    				var properties = _.remove($scope.component.properties, function(n) {
  					  	return n.ename != 'databind' && n.ename != 'id';
  					});
    				$scope.component.properties = properties;
    				for(var i in properties){
    					if(properties[i].commonAttr){
    						$scope.component.commonProperties.push(properties[i]);
    					} else {
    						$scope.component.notCommonProperties.push(properties[i]);
    					}
    				}
    				
	    			if($scope.batchEditBindNames.length > 0){
	    				$scope.hasBatchOperation = true;
	    				if($scope.batchEditBindNames[0].data == null 
	    						|| $scope.batchEditBindNames[0].data.uitype != componentName){
	    					$scope.hasChangeComponent = true;
	    				} else {
	    					$scope.hasChangeComponent = false;
	    				}
	    			} else {
	    				$scope.hasBatchOperation = false;
	    				if(componentName === 'RadioGroup' 
    						&& ($scope.culomnsBindNameVo.data.name == null || $scope.culomnsBindNameVo.data.name == '')){
    						$scope.culomnsBindNameVo.data.name = $scope.culomnsBindNameVo.bindName;
    					}
	    			}
	    			$scope.compileTmpl();
	    		}
	    	}
	    	
	    	//加载模版以及解析dom
	    	$scope.compileTmpl=function(){
	    		//var domStr = '<div id="propertyEditorUI" ng-controller="componentPropertiesCtrl" data-ng-init="ready()">'+new jCT($("#"+($scope.hasBatchOperation ? 'propertiesBatchEditTmpl':'propertiesEditTmpl')).html()).Build().GetView()+'</div>';
	    		
	    		var proNode = new jCT($("#"+($scope.hasBatchOperation ? 'propertiesBatchEditTmpl':'propertiesEditTmpl')).html()).Build().GetView();
	    		var eventNode = new jCT($("#"+($scope.hasBatchOperation ? 'eventBatchEditTmpl':'eventEditTmpl')).html()).Build().GetView();
	    		var domStr = '<div class="tab_panel" ng-style="componentlayout" ng-controller="componentPropertiesCtrl" data-ng-init="ready()">'+
					'<div id="tab_property" ng-show="active==\'attr\'" class="tab_property">'+proNode+'</div>'+
					'<div id="tab_event" ng-show="active==\'action\'" class="tab_event">'+eventNode+'</div>'+
					'</div>';
	    		$('#properties-div').html(domStr);
        		$compile($('#properties-div').contents())($scope);
        		$(".tab_panel td").css("background-color", $scope.component.length > 0 ? "#e0ffff" : "#fff");
	    	}
	    	
	    	$scope.hasHideNotCommonProperties = true;
	    	//切换展现非常用属性开关
	    	$scope.switchHideArea=function(flag){
	    		$scope[flag] = !$scope[flag];
	    	}
	    	
	    }).controller('componentPropertiesCtrl', function($scope){
	    	$scope.data = {};
	    	$scope.batchEditProperties = {};
	    	
	    	//初始化data数据
	    	$scope.initData=function(){
	    		$scope.setProsData();
	    		$scope.setEventsData();
	    		if(scope.batchEditBindNames.length == 0){
		    		scope.culomnsBindNameVo.data = $scope.data;
		    	} else {
		    		if(!$scope.hasChangeComponent){
		    			$scope.data = jQuery.extend(true, {}, $scope.data, $scope.commonPropertyValue());
    				} 
		    		scope.batchEditBindNameVo.data = $scope.data;
		    		scope.batchEditProperties = $scope.batchEditProperties;
		    	}
	    	}
	    	
	    	//属性数据值设置
	    	$scope.setProsData=function(){
	    		var propertiesType = {};
	    		if(scope.batchEditBindNames.length > 0){
					scope.batchEditBindNameVo.propertiesType = propertiesType;
				} else {
					scope.culomnsBindNameVo.propertiesType = propertiesType;
				}
	    		var properties = scope.component.properties;
			    var properties = _.remove(scope.component.properties, function(n) {
					  return n.ename != 'databind';
					});
			    scope.component.properties = properties;
		    	for(var i in properties){
					properties[i].propertyEditorUI.script = eval("("+properties[i].propertyEditorUI.script+")");
					var key = properties[i].propertyEditorUI.script.name;
					if(key === 'uitype'){
						$scope.data[key] = properties[i].defaultValue;
					} else if(scope.culomnsBindNameVo.data != null 
							&& scope.batchEditBindNames.length == 0 
							&& scope.culomnsBindNameVo.data[key] != null){
						var value = scope.culomnsBindNameVo.data[key];
						if(properties[i].type === 'Json' && typeof value === 'object'){
							$scope.data[key] = JSON.stringify(value);
						} else {
							$scope.data[key] = value + '';
						} 
					}
					propertiesType[key] = properties[i].type;
				}
		    	//添加控件模型Id
    			$scope.data.componentModelId = scope.component.modelId;
	    	}
	    	
	    	//行为数据值设置
	    	$scope.setEventsData=function(){
	    		var events = scope.component.events;
		    	for(var i in events){
		    		var key = events[i].ename;
					if(scope.culomnsBindNameVo.data != null && scope.batchEditBindNames.length == 0 && scope.culomnsBindNameVo.data[key] != null){
						$scope.data[key] = scope.culomnsBindNameVo.data[key];
						$scope.data[key+"_id"] = scope.culomnsBindNameVo.data[key+"_id"];
					}
				}
	    	}
	    	
		    $scope.ready=function(){
        		$scope.initData();
		    	//scope.data数据模型选择回调使用到
		    	scope.data = $scope.data;
		    	if(($scope.data.uitype === 'ChooseUser' || $scope.data.uitype === 'ChooseOrg') 
		    			&& $scope.data.chooseMode != null){//针对值不在pulldown数据源内的值处理
		    		setTimeout(function () {
			    		var propertyVo = _.find(scope.component.properties,{ename: 'chooseMode'});
		    			var id = propertyVo.propertyEditorUI.script.id;
		    			if(cui("#"+id).selectData == null){
		    				cui("#"+id).$text[0].value = $scope.data.chooseMode;
		    				cui("#"+id).setValue($scope.data.chooseMode);
		    			}
		    		}, 0);
		    	}
		    };
		 	
		    //获取值相同的属性
	    	$scope.commonPropertyValue=function(){
		    	var commonPropertyVo = {};
		    	var properties = scope.component.properties;
		    	for(var i in properties){
		    		var key = properties[i].propertyEditorUI.script.name;
		    		var compareValue = scope.batchEditBindNames[0].data != null ? scope.batchEditBindNames[0].data[key] : '';
		    		for(var j=1, len=scope.batchEditBindNames.length; j < len; j++){
		    			if(compareValue != scope.batchEditBindNames[j].data[key]){
		    				compareValue = null;
		    				break;
		    			}
		    		}
		    		if(compareValue != null){
		    			commonPropertyVo[key] = compareValue;
		    		}
		    	}
	    		return commonPropertyVo;
	    	}
		    
		    //点击属性控件，联动选中对应的复选框
	    	$scope.clickEvent=function(ename){
	    		$scope.batchEditProperties[ename] = true;
	    	}
		    
	    	//打开行为选择页面
		    $scope.openSelectAction=function(obj){
	    	   var node = cui('#'+obj).options;
	    	   var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionSelect.jsp?modelId='+pageId+'&packageId='+packageId+"&flag="+obj+"&methodTemplate="+node.methodtemplate+"&actionType="+node.actiontype;
			   var width=800; //窗口宽度
			   var height=650;//窗口高度
			   var top=(window.screen.height-30-height)/2;
			   var left=(window.screen.width-10-width)/2;
			   window.open(url, "pageActionEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		    }
	    });
		
		/**
		* 取消行为事件
		* @param obj 当前dom节点
		*/
	    function clearEvent(obj){
	    	scope.data[obj] = '';
	    	delete scope.data[obj+"_id"];
	    	cap.digestValue(scope);
	    }
		 
	    //选中的行为数据回调
		function selectPageActionData(objAction,flag){
			//获取方法名称
			var actionEname = objAction.ename;
			cui('#'+flag).setValue(actionEname);
			var actionId = flag + "_id";
			scope.data[actionId] = objAction.pageActionId;
			cap.digestValue(scope);
		}
		
		//选中的行为数据回调
		function cleanSelectPageActionData(flag){
			scope.data[flag] = '';
	    	delete scope.data[flag+"_id"];
	    	cap.digestValue(scope);
		}
		
		//直接新增行为
    	function openAddAction(obj){
    		 var node = cui('#'+obj).options;
    		 var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionEdit.jsp?modelId='+pageId+'&packageId='+packageId+"&flag="+obj+"&operationType=insert&methodTemplate="+node.methodtemplate+"&actionType="+node.actionType;
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
	    	 var pageActionId = scope.data.edittype.data[obj+"_id"];
	    	 if(pageActionId == actionValue){
	    		 return;
	    	 }
	    	 var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionEdit.jsp?modelId='+pageId+'&packageId='+packageId+"&flag="+obj+"&operationType=edit&methodTemplate="+node.methodtemplate+"&actionType="+node.actionType+"&selectActionId="+pageActionId;
			 var width=850; //窗口宽度
			 var height=650;//窗口高度
			 var top=(window.screen.height-30-height)/2;
			 var left=(window.screen.width-10-width)/2;
			 window.open(url, "pageActionEdit", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	    }

		function getBodyHeight () {
            return (document.documentElement.clientHeight || document.body.clientHeight) - 52;
        }
		
		//统一校验函数
		   function validateAll(){
		       var validate = new cap.Validate();
		       var result = {validFlag: true, message: ''};
		       //循环所有控件校验规则
		       var componentValidRuleList = getAllComponentValidRule();
		 	    for(var i in scope.culomnsBindNames){
		 	    	//表头对象(包含控件信息)
		 	    	var talbleheader = scope.culomnsBindNames[i];
		 	    	//判断控件类型是否存在，如果不存在则不校验
		 	    	if(talbleheader.data){
		 	    		//控件信息
			 	    	var componentInfo = talbleheader.data;
			 	    	var name = talbleheader.bindName != '' ? talbleheader.bindName : talbleheader.id;
					    var validDataList = _.get(componentValidRuleList, componentInfo.componentModelId);
					    var iLineNum = (parseInt(i)+1);
					    if(!$.isEmptyObject(validDataList)){
					    	_.forEach(validDataList, function (value, key) {
					    		var validData = eval(value);
					    		//grid中id属性不需要进行验证
					    		if(key !== 'id' && key !== 'databind' ){
						    		var required = _.find(validData, {type: 'required'});
						    		if(componentInfo[key]){
						    			var valRule = {};
						    			valRule[key] = validData;
						    	    	validateResult = validate.validateAllElement(componentInfo, valRule);
						    	    	result.validFlag = result.validFlag && validateResult.validFlag;
						    			if(!validateResult.validFlag){
						    				result.message += "&diams;第【"+iLineNum+"】行【" + name + "】控件“"+key+"”属性" + validateResult.message + "<br/>";
						    			}
						    		} else if(required){
						    			result.validFlag = false;
						    			result.message += "&diams;第【"+iLineNum+"】行【" + name + "】控件“"+key+"”属性" + required.rule.m + "<br/>";
						    		}
					    		}
						    });
					    }
		 	    	}
		 		}
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
	</script>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/EventsEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesBatchEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/EventsBatchEditTmpl.jsp" %>
</body>
</html>
