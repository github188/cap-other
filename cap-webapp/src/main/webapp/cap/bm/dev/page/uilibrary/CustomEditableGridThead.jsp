<%
/**********************************************************************
* GridTable属性
* 2015-05-07 诸焕辉  
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
    <top:script src="/cap/bm/common/jct/js/jct.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cip_common.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/selectDataModel.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/grid.js"></top:script>
	<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
</head>
<body ng-controller="customEditableGridTheadCtrl" data-ng-init="ready()">
<div>
	<div class="cap-area" style="padding: 2px;">
		<table class="cap-table-fullWidth">
			<tr>
		        <td class="cap-td" style="text-align: left;height: 35px;min-width:245px" nowrap="nowrap">
		        	选择数据对象：
					<span uitype="button" label="数据对象" id="selectEntity" menu="getDataStores" style="size: 150"></span> 
					&nbsp;&nbsp;<a title="添加" style="cursor:pointer;" onclick="openEditDataStoreSelect()"><span class="cui-icon" style="font-size:12pt; color:#333;">&#xf067;</span></a>
		        </td>
		        <td style="text-align: left;">
		        </td>
		        <td class="cap-td" style="text-align: left;" nowrap="nowrap">
		        	<span uitype="button" id="customColumn" label="添加" menu="customColumnButtonGroup"></span> 
				    <span cui_button id="deleteCustomHeader" label="删除" ng-click="deleteCustomHeader()"></span>
				    <span cui_button id="customHeaderUpButton" label="上移" ng-click="up()"></span> 
					<span cui_button id="customHeaderDownButton" label="下移" ng-click="down()"></span> 
					<a title="上一级" style="cursor:pointer;" ng-click="upGrade()">&nbsp;<span class="cui-icon" style="font-size:12pt; color:#333;">&#xf0d9;</span></a>
				    <span cui_pulldown id="level" ng-change="setLevel()" ng-model="level" value_field="id" label_field="text" empty_text="级别" width="45px">
						<a value="1">1</a>
						<a value="2">2</a>
						<a value="3">3</a>
						<a value="4">4</a>
						<a value="5">5</a>
					</span>
				    <a title="下一级" style="cursor:pointer;" ng-click="downGrade()"><span class="cui-icon" style="font-size:12pt; color:#333;">&#xf0da;</span></a>
		        </td>
		        <td style="text-align: left;">
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span cui_button id="saveButton" ng-click="saveCustomHeader()" label="确定"></span>
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
	                                    <input type="checkbox" name="{{'attribute'+($index + 1)}}" ng-model="attributeVo.check" ng-change="checkBoxCheckAttribute(attributes,'attributesCheckAll')">
	                                </td>
	                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
	                                    {{attributeVo.engName}}({{attributeVo.chName}})
	                                </td>
	                            </tr>
	                       </tbody>
			            </table>
		            </div>
		        </td>
		        <td style="text-align: left;border-right:1px solid #ddd;">
		        </td>
		        <td class="cap-td" style="text-align: center; padding: 2px; width: 30%">
		        	<div class="custom_div">
			        	<table class="custom-grid" style="width: 100%">
			                <thead>
			                    <tr>
			                    	<th style="width:30px">
			                    		<input type="checkbox" name="customHeadersCheckAll" ng-model="customHeadersCheckAll" ng-change="allCheckBoxCheckCustomHeader(customHeaders,customHeadersCheckAll)">
			                        </th>
			                        <th>
		                            	列名(columns)
			                        </th>
			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="customHeaderVo in customHeaders track by $index" style="background-color: {{customHeaderVo.check == true ? '#99ccff':'#ffffff'}}">
	                            	<td style="text-align: center;">
	                                    <input type="checkbox" name="{{'customHeader'+($index + 1)}}" ng-model="customHeaderVo.check" ng-change="checkBoxCheckCustomHeader(customHeaders,'customHeadersCheckAll')">
	                                </td>
	                                <td style="text-align:left;cursor:pointer" ng-click="customHeaderTdClick(customHeaderVo)">
	                                   {{customHeaderVo.indent}}&nbsp;{{customHeaderVo.bindName}}{{customHeaderVo.name != '' ? '('+customHeaderVo.name+')' : ''}}{{customHeaderVo.edittype.data.uitype != null ? '-['+customHeaderVo.edittype.data.uitype+']' : ''}}
	                                </td>
	                            </tr>
	                       </tbody>
			            </table>
		            </div>
		        </td>
		        <td style="text-align: left;border-right:1px solid #ddd;">
		        </td>
		        <td class="cap-td" style="text-align: left; padding: 2px; width: 40%;">
		       		<ul class="tab">
						<li ng-class="{'property':'active'}[active]" ng-click="showPanel('property', 'active')">表头属性</li>
						<li ng-class="{'componentType':'active'}[active]" ng-click="showPanel('componentType', 'active')">控件类型定义</li>
					</ul>
					<div>
						<div id="tab_property" class="tab_panel" ng-show="active=='property' && data.check && batchEdittype.length == 0"></div>
						<div id="tab_componentType" class="tab_panel" ng-show="active=='componentType'">
							<table class="cap-table-fullWidth">
								<tr>
							        <td class="cap-td" style="text-align: left;height: 35px;border-bottom:1px solid #ddd;" nowrap="nowrap">
							        	控件类型：
							        	<span cui_pulldown id="uitype" name="uitype" width="103" ng-model="uitype" datasource="initUItypeData" value_field="id" label_field="text"></span>
							        	<span cui_button id="batchUpdateBtn" ng-show="hasBatchEdittypeOperation && data.bindName != null" ng-click="batchUpdate()" label="批量修改"></span>
							        </td>
							    </tr>
							</table>
							<div id="attr_area">
								<ul class="tab"> 
									<li ng-class="{'attr':'active'}[component_active]" ng-click="showPanel('attr', 'component_active')">属性</li>
									<li ng-class="{'action':'active'}[component_active]" ng-click="showPanel('action', 'component_active')">行为</li>
								</ul>
								<div id="properties-div" class="properties-div"></div>
							</div>
						</div>
					</div>
		        </td>
		    </tr>
		</table>
	</div>
</div>

	<script type="text/javascript">
		var pageId = "<%=request.getParameter("pageId")%>";
		var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var propertyName = "<c:out value='${param.propertyName}'/>";
		var initValue = window.opener.getValue(propertyName);
		var edittype = window.opener.getValue('edittype');
		var primarykey = window.opener.getValue('primarykey');
		var pageSession = new cap.PageStorage(pageId);
		var pageDataStores = pageSession.get("dataStore");
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var extras = window.opener.scope.data.extras;
		extras = extras != null && extras != '' ? JSON.parse(extras) : {};
		var selectedDataStoreEname = extras.dataStoreEname;
		var selectedEntityId = extras.entityId != null ? extras.entityId : '';
		var selectrows = window.opener.scope.data.selectrows;
		var databind = window.opener.scope.data.databind;
	    var scope = {};
	    var increasingNumber = 0;
	    
		angular.module('customEditableGridThead', ["cui"]).controller('customEditableGridTheadCtrl', function ($scope, $compile) {
	    	//数据模型属性（左侧表格数据源）
			$scope.attributes　=　[];
	    	$scope.attributesCheckAll　=　false;
	    	$scope.customHeadersCheckAll　=　false;
	    	//列头属性（右侧表格数据源）
	    	$scope.customHeaders　=　[];
	    	//被选中的列头属性对象
	    	$scope.data　=　{};
	    	$scope.component　=　{};
	    	$scope.propertyTypeMap =　new HashMap();
	    	$scope.hasHideNotCommonProperties = true;
	    	$scope.hasBatchEdittypeOperation = false;
	    	//批量修改只能修改edittype对象
	    	$scope.batchEdittype = [];
	    	$scope.batchEditProperties = {};
	    	$scope.batchEditBindNameVo = {};
	    	$scope.uitype;
			//默认显示属性tab标签
	    	$scope.active='property';
	    	$scope.component_active='attr';
	    	
	    	$scope.ready=function(){
		    	scope=$scope;
		    	$scope.loadColumnProperties();
		    	comtop.UI.scan();
		    	$scope.initAttributes();
				$scope.initTableHeaders();
				$(window).resize(function() {
		    		$(".custom-div").height(getBodyHeight);
	    		});
		    }
	    	
	    	//加载表头属性
	    	$scope.loadColumnProperties=function(){
	    		dwr.TOPEngine.setAsync(false);
				ComponentFacade.query('uicomponent.common.component.editableGrid', "properties[ename='columns']", function(data){
					$scope.component = data.propertyEditorUI;
					//常用属性
					$scope.component.commonProperties = [];
					//非常用属性
					$scope.component.notCommonProperties = [];
					var properties = $scope.component.properties;
					for(var i in properties){
						$scope.propertyTypeMap.put(properties[i].ename, properties[i].type);
						properties[i].propertyEditorUI.script = eval("("+properties[i].propertyEditorUI.script+")");
						var key = properties[i].propertyEditorUI.script.name;
						if(typeof($scope.data[key]) == 'undefined'){
							$scope.data[key] = properties[i].defaultValue;
						}
						if($scope.data[key] != null){
							$scope.data[key] = $scope.data[key] + '';
						}
						if(properties[i].commonAttr){
							$scope.component.commonProperties.push(properties[i]);
						} else {
							$scope.component.notCommonProperties.push(properties[i]);
						}
					}
				});
				dwr.TOPEngine.setAsync(true);
				$('#tab_property').html(new jCT($('#propertiesEditTmpl').html()).Build().GetView()); 
            	$compile($('#tab_property').contents())($scope);
	    	}
	    	
	    	//初始化数据属性表格
	    	$scope.initAttributes = function (){
	    		if(selectedEntityId != ''){
		    		var q = new cap.CollectionUtil(entityList);
					var entityVO = q.query("this.modelId =='"+selectedEntityId+"'");
					var attributes = entityVO[0].attributes;
		    		cui("#selectEntity").setLabel(entityVO[0].engName);
					$scope.attributes = [];
					for(var i in attributes){
						var sourceType = attributes[i].attributeType.source;
						if(sourceType != "primitive" && sourceType != "dataDictionary" && sourceType != "enumType"){
							continue;
						}
						$scope.attributes.push(jQuery.extend(true, {}, attributes[i]));
					}
	    		}
	    	}
	    	
	    	//初始化表头数据列
	    	$scope.initTableHeaders = function (){
	    		if(extras.tableHeader != null){
		    		$scope.customHeaders = eval("("+extras.tableHeader+")");
					var q = new cap.CollectionUtil($scope.attributes);
		    		edittype = edittype != '' ? eval("("+edittype+")") : {};
		    		for(var i = 0, len=$scope.customHeaders.length; i < len; i++){
		    			var customHeaders = $scope.customHeaders[i];
		    			if(_.isArray(customHeaders)){
			    			for(var j in customHeaders){
			    				q.update("this.engName == '" + customHeaders[j].bindName + "'", {"isFilter": true});
			    				var componentType = _.get(edittype, customHeaders[j].bindName);
								componentType = componentType != null ? componentType : {};
								customHeaders[j].edittype = {data: componentType};
			    			}
		    			} else {
		    				q.update("this.engName == '" + customHeaders.bindName + "'", {"isFilter": true});
		    				var componentType = _.get(edittype, customHeaders.bindName);
							componentType = componentType != null ? componentType : {};
							customHeaders.edittype = {data: componentType};
		    			}
					}
		    		//默认选中第一行
		    		if($scope.customHeaders.length > 0){
		    			$scope.customHeaders[0].check = true;
						$scope.data = $scope.customHeaders[0];
						$scope.uitype = $scope.customHeaders[0].edittype.data.uitype != null ? $scope.customHeaders[0].edittype.data.uitype : '';
		    		}
	    		} 
	    	}
	    	
	    	//处理表头列所对应的控件类型
	    	$scope.saveEdittypeBefore=function(_customHeaders){
	    		var customHeaders = jQuery.extend(true, [], _customHeaders);
	    		var edittype = {};
				for(var i in customHeaders){
					var customHeader = customHeaders[i];
		    		if(customHeader.bindName != null && _.size(customHeader.edittype.data) > 0){
		    			deleteNullAndEmpty(customHeader.edittype.data);
		    			if(customHeader.edittype.propertiesType != null){
			    			transformEdittype(customHeader.edittype.data, customHeader.edittype.propertiesType);
		    			}
		    			var hasThrdUI = hasThrdComponent(customHeader.edittype.data.uitype);
		    			if(hasThrdUI){
		    				customHeader.edittype.data.thrdui = true;
		    			}
		    			//wrapOptions(customHeader.edittype.data);
		    			edittype[customHeader.bindName] = customHeader.edittype.data;
		    		}
				}
				return edittype;
	    	}
	    	
	    	//保存
			$scope.saveCustomHeader=function(){
				if(cui("#saveButton").options.disable){//按钮设置为禁止，但控件所绑定的事件并没取消绑定
					return ;
				}
				if($scope.customHeaders.length > 0 && selectedEntityId == ''){
					cui.alert("请选择数据对象。"); 
					return ;
	    		}
				var result = validateAll();
	     	  	if(!result.validFlag){
	     	  		cui.alert(result.message); 
	     	  		return;
	     	  	}
				var hasMultiTableHeader = _.pluck(_.sortBy($scope.customHeaders, 'level'), 'level').reverse()[0] > 1 ? true : false;
				var customHeaders = [];
				if(hasMultiTableHeader){//多表头
					customHeaders = getMultiLineHeaders($scope.customHeaders);
					if(customHeaders.length > 0){
						var addSelectrowsColumnVo = {};
						if(selectrows == null || selectrows == '' || selectrows == 'multi'){
							addSelectrowsColumnVo = {rowspan:customHeaders.length,width:60,type:'checkbox'};
							customHeaders[0] = _.union([addSelectrowsColumnVo], customHeaders[0]);
						} else if(selectrows == 'single'){
							addSelectrowsColumnVo = {rowspan:customHeaders.length,width:60,name:''};
							customHeaders[0] = _.union([addSelectrowsColumnVo], customHeaders[0]);
						} 
						for(var i in customHeaders){
							var customHeader = customHeaders[i];
							transformColumns(customHeader, $scope.propertyTypeMap);
						}
					} else {
						cui.error("多表头结构设置有误。"); 
						return;
					}
				} else {
					customHeaders = jQuery.extend(true, [], $scope.customHeaders);
					transformColumns(customHeaders, $scope.propertyTypeMap);
				}
				for(var i in $scope.customHeaders){
					$scope.customHeaders[i].check = false;
				}
				var edittype = $scope.saveEdittypeBefore($scope.customHeaders);
				var data = window.opener.scope.data;
				if(customHeaders.length > 0){
					data.databind = databind;
					data.edittype =  _.size(edittype) > 0 ? JSON.stringify(edittype) : '';
					data[propertyName] = customHeaders.length > 0 ? JSON.stringify(customHeaders) : '';
					//1、实体更改，则重新设置primarykey值； 2、primarykey为空时，自动赋值
					if(selectedEntityId != extras.entityId || primarykey == ''){
						var attributesByPrimaryKey = _.find(_.find(entityList, {modelId: selectedEntityId}).attributes, {primaryKey: true});
						data.primarykey = attributesByPrimaryKey != null ? attributesByPrimaryKey.engName : primarykey;
					}
					extras = {entityId: selectedEntityId, dataStoreEname: selectedDataStoreEname, tableHeader: customHeaders.length > 0 ? JSON.stringify($scope.customHeaders) : ''};
					data.extras = JSON.stringify(extras);
				} else {
					data.databind = '';
					data.edittype = '';
					data[propertyName] = '';
					data.extras = '';
					data.primarykey = '';
				}
				cap.digestValue(window.opener.scope);
				//importIncludeFileList(edittype, pageSession.get("page"));//根据控件定义类型是否用人员或组织、数字字典，引用相关文件(js\css)
				window.close(); 
			}
	    	
	    	//显示隐藏数据
	    	$scope.showAttributeVO=function(engNames){
	    		for(var i=0, len=engNames.length; i<len; i++){
	    			for(var j=0, len2=$scope.attributes.length; j<len2; j++){
	    				if($scope.attributes[j].engName == engNames[i]){
	    					$scope.attributes[j].isFilter = false;
	    					break;
	    				}
	    			}
	    		}
	    		$scope.checkBoxCheckAttribute($scope.attributes, false);
	    		$scope.attributesCheckAll=false;
	    	}
	    	
	    	//新增列
	    	$scope.addCustomHeader=function(customHeaderVo){
	    		$scope.data = customHeaderVo;
	    		$scope.customHeaders.push(customHeaderVo);
	    		for(var i in $scope.customHeaders){
    				$scope.customHeaders[i].check = false;
	    		}
	    		customHeaderVo.check = true;
	    		$scope.batchEdittype = [];
	    		if($scope.uitype != $scope.data.edittype.uitype){
		    		$scope.uitype = $scope.data.edittype.uitype;
		    		$scope.loadComponent($scope.data.edittype.uitype);
	    		}
	    		$scope.customHeadersCheckAll　=　false;
	    	}
	    	
	     	//删除自定义表头
	    	$scope.deleteCustomHeader=function(){
               	var newArr=[];
               	var delCustomHeaderIds=[];
                for(var i=0, len=$scope.customHeaders.length; i<len; i++){
                    if(typeof($scope.customHeaders[i].check) == 'undefined' || !$scope.customHeaders[i].check){
                    	newArr.push($scope.customHeaders[i]);
                    } else {
                    	delCustomHeaderIds.push($scope.customHeaders[i].customHeaderId);
                    }
                }
                $scope.customHeaders = newArr;
                $scope.showAttributeVO(delCustomHeaderIds);
                var isExist = (_.filter(delCustomHeaderIds, function(chr) { return chr == $scope.data.customHeaderId;})).length > 0 ? true : false;
                if(isExist){
                	$scope.data = {};
                }
                $scope.customHeadersCheckAll = false;
                $scope.hasBatchEdittypeOperation = false;
	    	}
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckAttribute=function(ar,isCheck){
	    		if(ar!=null && isCheck){
	    			for(var i=0, len=ar.length; i<len; i++){
	    				if(!ar[i].isFilter){
	    					var newComponentVo = createComponentVo4Attribute(ar[i]);
		    	    		$scope.addCustomHeader(newComponentVo);
		    	    		$scope.uitype = newComponentVo.edittype.data.uitype;
    					}
		    		}	
	    		}
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckAttribute=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=0;
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
		    				var newComponentVo = createComponentVo4Attribute(ar[i]);
		    	    		$scope.addCustomHeader(newComponentVo);
		    	    		$scope.uitype = newComponentVo.edittype.data.uitype;
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
	    	
	    	//选中属性(数据模型属性)
	    	$scope.gridAttributeTdClick=function(attributeVo){
	    		var newComponentVo = createComponentVo4Attribute(attributeVo);
	    		$scope.addCustomHeader(newComponentVo);
	    		$scope.uitype = newComponentVo.edittype.data.uitype;
		    }
	    	
	    	//选中(定义表头表格)
	    	$scope.customHeaderTdClick=function(customHeaderVo){
    			$scope.data = customHeaderVo;
	    		if($scope.batchEdittype.length > 0){//此前是批量操作
	    			$scope.batchEdittype = [];
    				$scope.uitype = customHeaderVo.edittype.data.uitype != null ? customHeaderVo.edittype.data.uitype : '';
    				if($scope.uitype != ''){
		    			$scope.loadComponent($scope.uitype);
	    			} 
	    		} else if($scope.uitype === customHeaderVo.edittype.data.uitype){//单个操作，但控件类型一样
	    			$scope.loadComponent($scope.uitype);
	    		} else {//不同控件类型
	    			$scope.uitype = customHeaderVo.edittype.data.uitype != null ? customHeaderVo.edittype.data.uitype : '';
	    		}
	    		for(var i in $scope.customHeaders){
    				$scope.customHeaders[i].check = false;
	    		}
	    		customHeaderVo.check = true;
	    		$scope.customHeadersCheckAll　=　$scope.customHeaders.length == 1 ? true : false;
	    		$scope.level = customHeaderVo.level;
		    }
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckCustomHeader=function(ar,isCheck){
	    		if(ar!=null){
	    			$scope.batchEdittype = [];
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
		    				$scope.batchEdittype.push(ar[i]);
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}
	    			
	    			if(isCheck){
		    			if(ar.length > 1 && $scope.hasSameType() === true){
			    			var data = jQuery.extend(true, {}, $scope.batchEdittype[0]);
			    			data.edittype.data = {};
			    			$scope.data = jQuery.extend(true, {}, data);
			    			var selectedValue = $scope.batchEdittype[0].edittype.data.uitype != null ? $scope.batchEdittype[0].edittype.data.uitype : '';
		    				if($scope.uitype === selectedValue){
				    			$scope.loadComponent(selectedValue);
				    		} else {
				    			$scope.uitype = selectedValue;
				    		}
	    				} else if (ar.length == 1){
	    					$scope.data = ar[0];
	    					$scope.uitype = ar[0].edittype.data.uitype != null ? ar[0].edittype.data.uitype : '';
	    				} else {
	    					$scope.uitype = '';
	    					$scope.data = {};
		    				$('#propertyEditorUI').html('');
	    				}
		    		} else {
		    			$scope.data = {};
		    			$scope.uitype = '';
		    			$('#propertyEditorUI').html('');
		    		}
	    		}
	    		$scope.level = '';
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckCustomHeader=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=ar.length;
	    			var selectedValue = '';
	    			$scope.batchEdittype = [];
		    		for(var i=0;i<allCount;i++){
		    			if(ar[i].check){
		    				checkCount++;
		    				$scope.batchEdittype.push(ar[i]);
			    		}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
		    		
		    		if(checkCount == 1) {//单个操作
		    			selectedValue = $scope.batchEdittype[0].edittype.data.uitype != null ? $scope.batchEdittype[0].edittype.data.uitype : '';
			    		$scope.data = $scope.batchEdittype[0];
			    		$scope.batchEdittype = [];
		    		} else if(checkCount > 1 && $scope.hasSameType() == true){//批量操作
		    			var data = jQuery.extend(true, {}, $scope.batchEdittype[0]);
		    			data.edittype.data = {};
		    			$scope.data = jQuery.extend(true, {}, data);
		    			selectedValue = $scope.batchEdittype[0].edittype.data.uitype != null ? $scope.batchEdittype[0].edittype.data.uitype : '';
		    		} else {//选中了多个复选框，但控件类型不一致、未选中任何表头行
		    			$scope.data = {};
		    			$scope.hasBatchEdittypeOperation = false;
		    		}
		    		if($scope.uitype === selectedValue){
		    			$scope.loadComponent(selectedValue);
		    		} else {
		    			$scope.uitype = selectedValue;
		    		}
	    		}
	    		$scope.level = '';
	    	}
	    	
	    	//批量修改编辑控件，判断是否是同一类控件类型
	    	$scope.hasSameType=function(){
	    		var ret = true;
	    		if($scope.customHeaders.length > 0){
	    			var q = new cap.CollectionUtil($scope.customHeaders);
	    			var customHeaders = q.query("this.check==true");
	    			var uitype = customHeaders[0].edittype.data.uitype != null ? customHeaders[0].edittype.data.uitype : '';
	    			for(var i=1, len=customHeaders.length; i<len; i++){
	    				var nextuitype = customHeaders[i].edittype.data.uitype != null ? customHeaders[i].edittype.data.uitype : '';
	    				if(uitype != nextuitype){
	    					ret = false;
	    					break;
	    				} 
		    		}
	    		} else {
	    			ret = false;
	    		}
    			return ret;
	    	}
	    	
	    	//上移
			$scope.up=function(){
	    		if($scope.customHeaders.length > 0 && $scope.customHeaders[0].check){
	    			return;
	    		}
	    		var mobileHeaders = [];
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check){
	    				mobileHeaders.push($scope.customHeaders[i]);
	    			}
	    		}
	    		for(var i in mobileHeaders){
	    			var currentData = mobileHeaders[i];
					if(currentData.customHeaderId != null){
						var currentIndex = 0;
						var frontData = {};
						for(var i in $scope.customHeaders){
							if($scope.customHeaders[i].customHeaderId == currentData.customHeaderId){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex > 0){
							frontData = $scope.customHeaders[currentIndex - 1];
							$scope.customHeaders.splice(currentIndex - 1, 2, currentData);
							$scope.customHeaders.splice(currentIndex, 0, frontData);
						} 
					}
	    		}
			}
			
			//下移
			$scope.down=function(){
				var len = $scope.customHeaders.length;
	    		if(len > 0 && $scope.customHeaders[len-1].check){
	    			return;
	    		}
	    		var mobileHeaders = [];
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check){
	    				mobileHeaders.push($scope.customHeaders[i]);
	    			}
	    		}
	    		mobileHeaders = mobileHeaders.reverse();
	    		for(var i in mobileHeaders){
	    			var currentData = mobileHeaders[i];
					if(currentData.customHeaderId != null){
						var currentIndex = 0;
						var nextData = {};
						for(var i in $scope.customHeaders){
							if($scope.customHeaders[i].customHeaderId == currentData.customHeaderId){
								currentIndex = i;
								break;
							}
						}
						if(currentIndex < len-1){
							nextData = $scope.customHeaders[parseInt(currentIndex) + 1];
							$scope.customHeaders.splice(parseInt(currentIndex) + 1, 1, currentData);
							$scope.customHeaders.splice(currentIndex, 1, nextData);
						}
					}
	    		}
			}
			
			//切换展现非常用属性开关
	    	$scope.switchHideArea=function(flag){
	    		$scope[flag] = !$scope[flag];
	    	}
			
	    	$scope.$watch("uitype", function(newValue, oldValue){
	    		if(newValue != null && newValue != ""){
	    			if($scope.data.edittype.data.uitype != newValue){//同一个列表更改控件定义类型，需要重新初始化$scope.data.edittype.data
	    				$scope.data.edittype.data = {uitype: newValue};
	    			}
	    			//实体属性默认值绑定到控件对应的属性中（目前只有数据字典和枚举）
	    			setAttrDefault2ComponentOptions(newValue, $scope.attributes, $scope.data.customHeaderId, $scope.data.edittype.data);
	    			$scope.loadComponent(newValue);
	    		} else {
	    			cui("#uitype").setReadonly($scope.data.bindName != '' ? false : true);
	    			if(_.size($scope.data) > 0 && $scope.data.edittype != null){
		    			$scope.data.edittype.data = {};
	    			}
	    			$('#properties-div').html("");
	    		}
	    	}, false);
	    	
	    	$scope.$watch("data.bindName", function(newValue, oldValue){
	    		if(newValue == null || newValue == ''){
	    			if($scope.uitype != ''){
		    			$scope.uitype = '';
	    			} else {
	    				cui("#uitype").setReadonly($scope.data.bindName != '' ? false : true);
	    			}
	    		} else if(cui("#uitype").readonly){
	    			cui("#uitype").setReadonly(false);
	    		}
	    	}, false);
	    	
	    	//通过监控控制确认按钮状态
	    	$scope.$watch("hasBatchEdittypeOperation", function(newValue, oldValue){
	    		cui("#saveButton").disable(newValue);
	    	});
	    	
	    	//通过监控控制控件类型下拉框状态
	    	$scope.$watch("batchEdittype", function(newValue, oldValue){
	    		var len  = newValue.length;
	    		if(len > 0){
		    		var hasSameType = $scope.hasSameType();
		    		cui("#uitype").setReadonly(!hasSameType);
	    		} else {
	    			$scope.hasBatchEdittypeOperation = false;
	    		}
	    	});
	    	
	    	//加载控件属性
	    	$scope.loadComponent=function(componentName){
	    		if(componentName != null && componentName != ''){
	    			var group = componentName == 'ChooseOrg' || componentName == 'ChooseUser' ? 'expand' : 'common';
		    		var modelId = "uicomponent."+ group +".component."+componentName.substring(0, 1).toLowerCase()+componentName.substring(1);
	    			$scope.component = getComponentByModelId(modelId, window.opener.parent.toolsdata);
	    			//常用属性
    				$scope.component.commonProperties = [];
    				//非常用属性
    				$scope.component.notCommonProperties = [];
    				var properties = _.remove($scope.component.properties, function(n) {
  					  	return n.ename != 'databind' && n.ename != 'id' ;
  					});
    				$scope.component.properties = properties;
    				for(var i in properties){
    					if(properties[i].commonAttr){
    						$scope.component.commonProperties.push(properties[i]);
    					} else {
    						$scope.component.notCommonProperties.push(properties[i]);
    					}
    				}
    				
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
    				
	    			if($scope.batchEdittype.length > 0){
	    				$scope.hasBatchEdittypeOperation = true;
	    			} else {
	    				$scope.hasBatchEdittypeOperation = false;
	    				if(componentName === 'RadioGroup' 
	    						&& ($scope.data.edittype.data.name == null || $scope.data.edittype.data.name == '')){
	    					$scope.data.edittype.data.name = $scope.data.bindName;
	    				}else if((componentName === 'ChooseOrg' || componentName === 'ChooseUser')
    						&& ($scope.data.edittype.data.idName == null || $scope.data.edittype.data.idName == '')){
    						$scope.data.edittype.data.idName = $scope.data.bindName;
    					}
	    			}
	    			//添加modelId属性
	    			$scope.data.edittype.data.componentModelId = $scope.component.modelId;
	    			$scope.compileTmpl();
	    		}
	    	}
	    	
	    	//加载模版以及解析dom
	    	$scope.compileTmpl=function(){
	    		$scope.component.prefix = 'edittype';
	    		//var domStr = '<div id="propertyEditorUI" ng-controller="componentPropertiesCtrl" data-ng-init="ready()">'+new jCT($("#"+($scope.hasBatchEdittypeOperation ? 'propertiesBatchEditTmpl':'propertiesEditTmpl')).html()).Build().GetView()+'</div>';
	    		var proNode = new jCT($("#"+($scope.hasBatchEdittypeOperation ? 'propertiesBatchEditTmpl':'propertiesEditTmpl')).html()).Build().GetView();
	    		var eventNode = new jCT($("#"+($scope.hasBatchEdittypeOperation ? 'eventBatchEditTmpl':'eventEditTmpl')).html()).Build().GetView();
	    		var domStr = '<div id="propertyEditorUI" ng-controller="componentPropertiesCtrl" data-ng-init="ready()">'+
					'<div id="tab_pro" ng-show="component_active==\'attr\'" class="tab_property">'+proNode+'</div>'+
					'<div id="tab_event" ng-show="component_active==\'action\'" class="tab_event">'+eventNode+'</div>'+
					'</div>';
	    		$('#properties-div').html(domStr);
        		$compile($('#properties-div').contents())($scope);
        		//cap.validater.destroy();
        		//cap.validater.add('bindName', 'format', {pattern:'^\\w+$', m:'只能输入由字母、数字或者下划线组成的字符串'});
        		//cap.validater.add('name', 'exclusion', {within:[ '\\','$' ], partialMatch:true, caseSensitive:true , m:'不能输入$\字符'});
        		
	    	}
	    	
	    	//批量修改
			$scope.batchUpdate=function(){
				cui.confirm('您确定要执行批量修改操作？',{
					onYes:function(){
						var commonProperyVo = {};
						if($scope.uitype != ''){
			    			for(var key in $scope.batchEditProperties){
			    				if($scope.batchEditProperties[key] === true){
				    				commonProperyVo[key] = $scope.data.edittype.data[key];
			    				}
				    		}
			    			commonProperyVo.uitype = $scope.uitype;
						} 
						for(var i in $scope.batchEdittype){
			    			$scope.batchEdittype[i].edittype.data = jQuery.extend(true, $scope.uitype == $scope.batchEdittype[i].edittype.data.uitype ? $scope.batchEdittype[i].edittype.data : {}, commonProperyVo);
			    			$scope.batchEdittype[i].edittype.propertiesType = $scope.data.edittype.propertiesType;
			    		}
			    		cui.message('批量修改成功！', 'success');
			    		scope.customHeaderTdClick($scope.customHeaders[0]);
						scope.$digest();
					}
				});
			}
	    	
			//点击属性控件，联动选中对应的复选框
	    	$scope.clickEvent=function(ename){
	    		$scope.batchEditProperties[ename] = true;
	    	}
	    	
	    	//切换Tab标签
	    	$scope.showPanel=function(msg, arr){
	    		$scope[arr]=msg;
	    	}
	    	
	    	//设置级别
	    	$scope.setLevel=function(){
	    		var level = $scope.level;
	    		for(var i in $scope.customHeaders){
					if($scope.customHeaders[i].check){
		    			$scope.customHeaders[i].level = parseInt(level);
		    			var indent = '';
		    			for(var j=1; j<level; j++){
		    				indent += '~';
		    			}
		    			$scope.customHeaders[i].indent = indent;
					}
	    		}
	    	}
	    	
	    	//升级
	    	$scope.upGrade=function(){
	    		for(var i in $scope.customHeaders){
	    			if($scope.customHeaders[i].check && $scope.customHeaders[i].level > 1){
		    			$scope.customHeaders[i].level--;
		    			$scope.customHeaders[i].indent = $scope.customHeaders[i].indent.substr(0, $scope.customHeaders[i].indent.length-1);
					}
	    		}
	    	}
	    	
	    	//降级
			$scope.downGrade=function(){
				for(var i in $scope.customHeaders){
					if($scope.customHeaders[i].check){
		    			$scope.customHeaders[i].level++;
		    			$scope.customHeaders[i].indent += '~';
					}
	    		}
	    	}
	    }).controller('componentPropertiesCtrl', function($scope){
	    	$scope.edittype = {data:scope.data.edittype.data};
	    	$scope.batchEditProperties = {};
	    	
		    $scope.ready=function(){
		    	$scope.initData();
		    	if(($scope.edittype.data.uitype === 'ChooseUser' || $scope.edittype.data.uitype === 'ChooseOrg') 
		    			&& $scope.edittype.data.chooseMode != null){//针对值不在pulldown数据源内的值处理
		    		setTimeout(function () {
			    		var propertyVo = _.find(scope.component.properties,{ename: 'chooseMode'});
		    			var id = propertyVo.propertyEditorUI.script.id;
		    			if(cui("#"+id).selectData == null){
		    				cui("#"+id).$text[0].value = $scope.edittype.data.chooseMode;
		    				cui("#"+id).setValue($scope.edittype.data.chooseMode);
		    			}
		    		}, 0);
		    	}
		    };
		    
		    //初始化data数据
	    	$scope.initData=function(){
	    		scope.data.edittype.propertiesType = new HashMap();
	    		$scope.setProsData();
	    		$scope.setEventsData();
	    		if(scope.batchEdittype.length > 0){
		    		scope.batchEditProperties = $scope.batchEditProperties;
		    		scope.batchEditProperties.uitype = true;
		    		$scope.edittype.data = jQuery.extend(true, $scope.edittype.data, $scope.commonPropertyValue());
		    	}
	    	}
		    
		    //属性数据值设置
	    	$scope.setProsData=function(){
		    	var properties = scope.component.properties;
		    	for(var i in properties){
					properties[i].propertyEditorUI.script = eval("("+properties[i].propertyEditorUI.script+")");
					var key = properties[i].propertyEditorUI.script.name;
					scope.data.edittype.propertiesType.put(key, properties[i].type);
					if(key === 'uitype'){
						$scope.edittype.data[key] = properties[i].defaultValue;
					} else if(scope.data.edittype.data[key] != null){
						var value = scope.data.edittype.data[key];
						if(properties[i].type === 'Json' && typeof value === 'object'){
							$scope.edittype.data[key] = JSON.stringify(value);
						} else {
							$scope.edittype.data[key] = value + '';
						}
					}
				}
	    	}
	    	
	    	//行为数据值设置
	    	$scope.setEventsData=function(){
	    		var events = scope.component.events;
		    	for(var i in events){
		    		var key = events[i].ename;
		    		scope.data.edittype.propertiesType.put(key, 'Json');
				    if(scope.data.edittype.data != null){
						$scope.edittype.data[key] = scope.data.edittype.data[key];
						$scope.edittype.data[key+"_id"] = scope.data.edittype.data[key+"_id"];
					}
				}
	    	}
		    
		    //获取值相同的属性
	    	$scope.commonPropertyValue=function(){
		    	var commonPropertyVo = {};
		    	var properties = scope.component.properties;
		    	for(var i in properties){
		    		var key = properties[i].propertyEditorUI.script.name;
		    		var compareValue = scope.batchEdittype[0].edittype.data != null ? scope.batchEdittype[0].edittype.data[key] : '';
		    		for(var j=1, len=scope.batchEdittype.length; j < len; j++){
		    			if(compareValue != scope.batchEdittype[j].edittype.data[key]){
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
		
		var entityList = [];
		
	 	//实体列表按钮组(页面数据集)
	 	function getDataStores(){
	 		var datasource = [];
	 		for(var i in pageDataStores){
	 			var item = {};
	 			var entityId = pageDataStores[i].entityId;
	 			var dataStoreEname = pageDataStores[i].ename;
	 			//排除页面全局参数/页面传入参数/页面用户权限
	 			if(entityId != '' && entityId != null){
	 				var entityVO = pageDataStores[i].entityVO;
	 				entityList.push(entityVO);
	 				item = {id: getRandomId("uiid"), label: entityVO.engName+"("+dataStoreEname+")", entityId: entityVO.modelId, dataStoreEname: dataStoreEname, hasSubEntity:false};
	 				
		 			var subEntity = pageDataStores[i].subEntity;
		 			if(typeof(subEntity) != 'undefined' && subEntity != null){
		 				for(var j in subEntity){
		 					entityList.push(subEntity[j]);
			 				item.items = typeof(item.items) == 'undefined' ? [] : item.items;
			 				item.items.push({id: getRandomId("uiid"), label: subEntity[j].engName, entityId: subEntity[j].modelId, dataStoreEname: dataStoreEname, hasSubEntity: true});
		 				}
		 			}
		 			datasource.push(item);
	 			}
	 		}
	 		_.unique(entityList, 'modelId');//去重
	 		var menudata = {
 		        datasource: datasource,
 		        on_click : function(obj){ 
 		        	cui("#selectEntity").setLabel(longTextOmittedProcessing(obj.label));
 		        	selectedDataStoreEname = obj.dataStoreEname;
 		        	databind = obj.dataStoreEname;
 		        	if(obj.hasSubEntity){//是否是子实体
 		        		var entityVO = _.find(_.filter(pageDataStores, function(){ return entityId != ''}), {ename: obj.dataStoreEname}).entityVO;
 		        		var relationId = _.find(entityVO.lstRelation, {targetEntityId: obj.entityId}).relationId;
 		        		var engName = _.find(entityVO.attributes, {relationId: relationId}).engName;//父实体关联子实体的关联属性名称
 		        		databind += '.' + engName;
 		        	}
		        	initAttributeGrid(obj.entityId);
		        	scope.attributesCheckAll　=　false;
			    	scope.customHeadersCheckAll　=　false;
			    	scope.batchEdittype　=　[];
			    	scope.$digest();
 		        }
 		    };
	 		return menudata;
	 	}
	 	
	 	/**
		 * 过长的文本省略处理
		 * @param label 文本
		 */
	 	function longTextOmittedProcessing(label){
	 		var len = label.length;
        	var ellipsis = '';
        	if(len > 10){
        		ellipsis = '...';
        		len = 10;
        	}
        	return label.substring(0, len) + ellipsis;;
	 	}
	 	
		//选择实体属性回调
		function initAttributeGrid(entityId){
			selectedEntityId = entityId;
			var q = new cap.CollectionUtil(entityList);
			var entityVO = q.query("this.modelId =='"+entityId+"'");
			var attributes = entityVO[0].attributes;
			scope.attributes = [];
			for(var i in attributes){
				if(attributes[i].attributeType.source != "primitive" && attributes[i].attributeType.source != "dataDictionary" && attributes[i].attributeType.source != "enumType"){
					continue;
				}
				scope.attributes.push(jQuery.extend(true, {}, attributes[i]));
			}
			scope.customHeaders = [];
			scope.data = {};
			scope.$digest();
		}
		
		function getBodyHeight () {
            return (document.documentElement.clientHeight || document.body.clientHeight) - 52;
        }
		
		//列表按钮组
    	var customColumnButtonGroup = {
	        datasource: [
	            {id:'insertSerialCol',label:'添加序号列'},
	            {id:'insertBlankCol',label:'添加空白列'},
	            {id:'insertOperationCol',label:'添加行操作列'}
	        ],
	        on_click : function(obj){
	        	if(obj.id === 'insertSerialCol'){
	        		scope.addCustomHeader({customHeaderId: increasingNumber++, name: '序号', sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', bindName:'1', edittype:{data:{}}});
	        	}else if(obj.id === 'insertBlankCol'){
	        		scope.addCustomHeader({customHeaderId: increasingNumber++, name: '', sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', edittype:{data:{}}});
	        	}else if(obj.id === 'insertOperationCol'){
	        		scope.addCustomHeader({customHeaderId: increasingNumber++, name: '行操作', sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', edittype:{data:{}}});
	        	}
	        	scope.$digest();
	        }
	    };
		
    	/**
		 * 复杂模型回调函数
		 * @param propertyName 属性名称
		 * @param propertyValue 属性值
		 */
		function openWindowCallback(propertyName, propertyValue){
			cui("#"+propertyName).setValue(propertyValue);
		}
    	
		function openRenderWindow(event, self){
			var width=800; //窗口宽度
		    var height=600; //窗口高度
		    var top=(window.screen.availHeight-height)/2;
		    var left=(window.screen.availWidth-width)/2;
		    var bindName = scope.data.bindName;
			var url='CustomGridColumnsRender.jsp?callbackMethod=openWindowCallback&bindName='+bindName;
		    window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}
		
		//打开数据模型选择界面
	    function openEditDataStoreSelect() {
	    	var url='../designer/EditPageDataStoreSelect.jsp?packageId=' + packageId+'&modelId='+pageId+'&callbackMethod=openEditDataStoreSelectCallback&timestamp='+new Date().getTime();
	    	var top=(window.screen.availHeight-600)/2;
	    	var left=(window.screen.availWidth-800)/2;
	    	window.open (url,'importRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
	    }
	    
	    //打开数据模型选择界面回调方法
	    function openEditDataStoreSelectCallback(data){
	    	pageDataStores.push(data);
	    	pageDataStores = pageSession.get("dataStore");
	    	cui("#selectEntity").getMenu().setDatasource(getDataStores().datasource);
			cui("#selectEntity").setLabel(longTextOmittedProcessing(data.entityVO.engName+"("+data.ename+")"));
			selectedDataStoreEname = data.ename;
			databind = data.ename;
	    	initAttributeGrid(data.entityVO.modelId);
	    }
	    
	   var bindNameValRule = [{type:'format', rule:{pattern:'^\\w+$', m:'只能输入由字母、数字或者下划线组成的字符串'}}];
	   //var nameValRule = [{type:'format', rule:{pattern:'^[a-zA-Z_()0-9\u4e00-\u9fa5]+$', m:'只能输入由字母、数字、汉字或者下划线组成的字符串'}}];
	   var nameValRule = [{type:'required',rule:{m:'列名称不能为空'}},{type:'exclusion', rule:{within:['\\'], partialMatch:true, caseSensitive:true, allowNull: true, m:'不能输入‘\\’字符'}}];
	    
	   //统一校验函数
	   function validateAll(){
	       var validate = new cap.Validate();
	       var valRule = {bindName: bindNameValRule,name:nameValRule};
	       var gridCloumns = scope.customHeaders;
	       var result = validate.validateAllElement(gridCloumns, valRule);
	       //循环所有控件校验规则
	       var componentValidRuleList = getAllComponentValidRule();
	 	    for(var i in scope.customHeaders){
	 	    	//表头对象(包含控件信息)
	 	    	var talbleheader = scope.customHeaders[i];
	 	    	
	 	    	//控件信息
	 	    	var componentInfo = talbleheader.edittype.data;
	 	    	var name = talbleheader.name != '' ? talbleheader.name : talbleheader.bindName != '' ? talbleheader.bindName : talbleheader.customHeaderId;
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
		* 取消行为事件
		* @param obj 当前dom节点
		*/
	    function clearEvent(obj){
	    	scope.data.edittype.data[obj] = '';
	    	delete scope.data.edittype.data[obj+"_id"];
	    	cap.digestValue(scope);
	    }
		 
	    //选中的行为数据回调
		function selectPageActionData(objAction,flag){
			//获取方法名称
			var actionEname = objAction.ename;
			cui('#'+flag).setValue(actionEname);
			var actionId = flag + "_id";
			scope.data.edittype.data[actionId] = objAction.pageActionId;
			cap.digestValue(scope);
		}
		
		//选中的行为数据回调
		function cleanSelectPageActionData(flag){
			scope.data[flag] = '';
	    	delete scope.data.edittype.data[flag+"_id"];
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
   		
		
	</script>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/EventsEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesBatchEditTmpl.jsp" %>
	<%@ include file="/cap/bm/dev/page/uilibrary/EventsBatchEditTmpl.jsp" %>
</body>
</html>
