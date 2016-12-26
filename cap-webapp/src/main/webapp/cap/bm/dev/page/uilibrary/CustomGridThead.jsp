<%
/**********************************************************************
* GridTable属性
* 2015-05-07 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='customGridThead'>
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
<body ng-controller="customGridTheadCtrl" data-ng-init="ready()">
<div>
	<div class="cap-area" style="padding: 2px;">
		<table class="cap-table-fullWidth">
			<tr>
		        <td class="cap-td" style="text-align: left;height: 35px;min-width:245px" nowrap="nowrap">
		        	选择数据对象：
					<span uitype="button" label="数据对象" id="selectEntity" menu="getDataStores" style="size: 150"></span> 
					&nbsp;&nbsp;<a title="添加" style="cursor:pointer;" onclick="openDataStoreSelect()"><span class="cui-icon" style="font-size:12pt; color:#333;">&#xf067;</span></a>
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
	                                    {{attributeVo.attributeEname}}({{attributeVo.attributeCname}})
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
		                            	列名
			                        </th>
			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="customHeaderVo in customHeaders track by $index" style="background-color: {{customHeaderVo.check == true ? '#99ccff':'#ffffff'}}">
	                            	<td style="text-align: center;">
	                                    <input type="checkbox" name="{{'customHeader'+($index + 1)}}" ng-model="customHeaderVo.check" ng-change="checkBoxCheckCustomHeader(customHeaders,'customHeadersCheckAll')">
	                                </td>
	                                <td style="text-align:left;cursor:pointer" ng-click="customHeaderTdClick(customHeaderVo)">
	                                  {{customHeaderVo.indent}}&nbsp;{{customHeaderVo.bindName}}{{customHeaderVo.name != '' ? '('+customHeaderVo.name+')' : ''}}
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
						<li class="active">表头属性</li>
					</ul>
					<div ng-show="data.check">
						<div id="tab_property" class="tab_panel"></div>
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
		//initValue可以去除，目前为了兼容此前的版本保留着
		var initValue = window.opener.getValue(propertyName);
		var pageSession = new cap.PageStorage(pageId);
		var pageDataStores = pageSession.get("dataStore");
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var extras = window.opener.scope.data.extras;
		extras = extras != null && extras != '' ? JSON.parse(extras) : {};
		var selectedDataStoreEname = extras.dataStoreEname;
		var selectedEntityId = extras.entityId != null ? extras.entityId : '';
		var selectrows = window.opener.scope.data.selectrows;
	    var scope = {};
	    var increasingNumber = 0;
	    
		angular.module('customGridThead', ["cui"]).controller('customGridTheadCtrl', function ($scope, $compile) {
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
				ComponentFacade.query('uicomponent.common.component.grid', "properties[ename='columns']", function(data){
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
						$scope.attributes.push({attributeId:attributes[i].engName,attributeCname:attributes[i].chName, attributeEname:attributes[i].engName, attributeType:attributes[i].attributeType.type, isFilter:false});
					}
	    		}
	    	}
	    	
	    	//初始化表头数据列
	    	$scope.initTableHeaders = function (){
	    		if(extras.tableHeader != null){
		    		$scope.customHeaders = eval("("+extras.tableHeader+")");
					var q = new cap.CollectionUtil($scope.attributes);
		    		for(var i = 0, len=$scope.customHeaders.length; i < len; i++){
		    			var customHeaders = $scope.customHeaders[i];
		    			if(_.isArray(customHeaders)){
			    			for(var j in customHeaders){
			    				q.update("this.attributeEname == '" + customHeaders[j].bindName + "'", {"isFilter": true});
			    			}
		    			} else {
		    				q.update("this.attributeEname == '" + customHeaders.bindName + "'", {"isFilter": true});
		    			}
					}
	    		} 
	    		if($scope.customHeaders.length > 0){
					$scope.data = $scope.customHeaders[0];
					$scope.customHeaders[0].check = true;
	    		}
	    	}
	    	
	    	//保存
			$scope.saveCustomHeader=function(){
	    		if($scope.customHeaders.length > 0 && selectedEntityId == ''){
					cui.alert("请选择数据对象。"); 
					return ;
	    		}
	    		
				var result = validateAll();
	     	  	if(!result.validFlag){
	     	  		cui.alert(result.message); 
	     	  		return;
	     	  	}
				result = nameValidate();
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
				var data = window.opener.scope.data;
				if(customHeaders.length > 0){
					data[propertyName] = JSON.stringify(customHeaders);
					extras = {entityId: selectedEntityId, dataStoreEname: selectedDataStoreEname, tableHeader: customHeaders.length > 0 ? JSON.stringify($scope.customHeaders) : ''};
					data.extras = JSON.stringify(extras);
					var attributesByPrimaryKey = _.find(_.find(entityList, {modelId: selectedEntityId}).attributes, {primaryKey: true});
					data.primarykey = attributesByPrimaryKey != null ? attributesByPrimaryKey.engName : '';
				} else {
					data[propertyName] = '';
					data.extras = '';
					data.primarykey = '';
				}
				cap.digestValue(window.opener.scope);
				window.close(); 
			}
			
	    	//显示隐藏数据
	    	$scope.showAttributeVO=function(attributeIds){
	    		for(var i=0, len=attributeIds.length; i<len; i++){
	    			for(var j=0, len2=$scope.attributes.length; j<len2; j++){
	    				if($scope.attributes[j].attributeId == attributeIds[i]){
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
                $scope.customHeadersCheckAll = false;
                $scope.data = {};
	    	}
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckAttribute=function(ar,isCheck){
	    		if(ar!=null){
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
		    				for(var i=0, len=ar.length; i<len; i++){
		    					if(!ar[i].isFilter){
		    						ar[i].isFilter=true;
		    						ar[i].check=false;
			    					$scope.addCustomHeader({customHeaderId: ar[i].attributeId, name: ar[i].attributeCname, bindName: ar[i].attributeEname, sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', format: (ar[i].attributeType === 'java.sql.Date' || ar[i].attributeType === 'java.sql.Timestamp' ? 'yyyy-MM-dd' : '')});
		    					}
		                    }
			    		}else{
			    			ar[i].check=false;
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
		    				ar[i].isFilter=true;
		    				ar[i].check=false;
			    			$scope.addCustomHeader({customHeaderId: ar[i].attributeId, name: ar[i].attributeCname, bindName: ar[i].attributeEname, sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', format: (ar[i].attributeType === 'java.sql.Date' || ar[i].attributeType === 'java.sql.Timestamp' ? 'yyyy-MM-dd' : '')});
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
	    		attributeVo.isFilter=true;
	    		attributeVo.check=false;
	    		$scope.addCustomHeader({customHeaderId: attributeVo.attributeId, name: attributeVo.attributeCname, bindName: attributeVo.attributeEname, sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', format: (attributeVo.attributeType === 'java.sql.Date' || attributeVo.attributeType === 'java.sql.Timestamp' ? 'yyyy-MM-dd' : '')});
		    }
	    	
	    	//选中(定义表头表格)
	    	$scope.customHeaderTdClick=function(customHeaderVo){
	    		for(var i in $scope.customHeaders){
    				$scope.customHeaders[i].check = false;
	    		}
	    		customHeaderVo.check = true;
	    		$scope.data = customHeaderVo;
	    		$scope.level = customHeaderVo.level;
		    }
	    	
	    	//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckCustomHeader=function(ar,isCheck){
	    		if(ar!=null){
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
			    		}else{
			    			ar[i].check=false;
			    		}
		    		}	
	    		}
	    		$scope.data={};
	    		$scope.level = '';
	    	}
	    	
	    	//监控选中，如果列表所有行都被选中则选中allCheckBox
	    	$scope.checkBoxCheckCustomHeader=function(ar,allCheckBox){
	    		if(ar!=null){
	    			var checkCount=0;
	    			var allCount=0;
		    		for(var i=0;i<ar.length;i++){
		    			if(ar[i].check){
		    				checkCount++;
		    				$scope.data = ar[i];
			    		}
		    		}
		    		if(checkCount==allCount && checkCount!=0){
		    			eval("$scope."+allCheckBox+"=true");
		    		}else{
		    			eval("$scope."+allCheckBox+"=false");
		    		}
	    		}
	    		if(checkCount > 1){
	    			$scope.data={};
	    		} 
	    		$scope.level = '';
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
	 				item = {id: getRandomId("uiid"), label: entityVO.engName+"("+dataStoreEname+")", entityId: entityVO.modelId, dataStoreEname: dataStoreEname};
	 				
		 			var subEntity = pageDataStores[i].subEntity;
		 			if(typeof(subEntity) != 'undefined' && subEntity != null){
		 				for(var i in subEntity){
		 					entityList.push(subEntity[i]);
			 				item.items = typeof(item.items) == 'undefined' ? [] : item.items;
			 				item.items.push({id: getRandomId("uiid"), label: subEntity[i].engName, entityId: subEntity[i].modelId, dataStoreEname: dataStoreEname});
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
		        	initAttributeGrid(obj.entityId);
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
        	return label.substring(0, len) + ellipsis;
	 	}
	 	
		//选择实体属性回调
		function initAttributeGrid(entityId){
			selectedEntityId = entityId;
			var q = new cap.CollectionUtil(entityList);
			var entityVO = q.query("this.modelId =='"+entityId+"'");
			var attributes = entityVO[0].attributes;
			scope.attributes = [];
			for(var i in attributes){
				var sourceType = attributes[i].attributeType.source;
				if(sourceType != "primitive" && sourceType != "dataDictionary" && sourceType != "enumType"){
					continue;
				}
				scope.attributes.push({attributeId:attributes[i].engName,attributeCname:attributes[i].chName, attributeEname:attributes[i].engName, attributeType:attributes[i].attributeType.type});
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
	            {id:'insertBlankCol',label:'添加空白列'}
	        ],
	        on_click : function(obj){
	        	if(obj.id === 'insertSerialCol'){
	        		scope.addCustomHeader({customHeaderId: increasingNumber++, name: '序号', sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:'', bindName:'1'});
	        	}else if(obj.id === 'insertBlankCol'){
	        		scope.addCustomHeader({customHeaderId: increasingNumber++, name: '', sort: 'false', hide: 'false', disabled: 'false', level: 1, indent:''});
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
	    function openDataStoreSelect() {
	    	var url='../designer/EditPageDataStoreSelect.jsp?packageId=' + packageId+'&modelId='+pageId+'&callbackMethod=openDataStoreSelectCallback&timestamp='+new Date().getTime();
	    	var top=(window.screen.availHeight-600)/2;
	    	var left=(window.screen.availWidth-800)/2;
	    	window.open (url,'importRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
	    }
	    
	    //打开数据模型选择界面回调方法
	    function openDataStoreSelectCallback(data){
	    	pageDataStores.push(data);
	    	pageDataStores = pageSession.get("dataStore");
	    	cui("#selectEntity").getMenu().setDatasource(getDataStores().datasource);
			cui("#selectEntity").setLabel(longTextOmittedProcessing(data.entityVO.engName+"("+data.ename+")"));
			selectedDataStoreEname = data.ename;
	    	initAttributeGrid(data.entityVO.modelId);
	    }
	    
	    
	    var bindNameValRule = [{type:'format', rule:{pattern:'^\\w+$', m:'只能输入由字母、数字或者下划线组成的字符串'}}];
	    //var nameValRule = [{type:'format', rule:{pattern:'^[a-zA-Z_0-9()（）\u4e00-\u9fa5]+$',  m:'只能输入由字母、数字、汉字或者下划线组成的字符串'}}];
	    var nameValRule = [{type:'required',rule:{m:'列名称不能为空'}},{type:'exclusion', rule:{within:['\\'], partialMatch:true, caseSensitive:true, allowNull: true, m:'不能输入‘\\’字符'}}];
	    
	    //统一校验函数
		function validateAll(){
	    	var validate = new cap.Validate();
	    	var valRule = {bindName: bindNameValRule};
	    	//, name:nameValRule
	    	var gridCloumns = scope.customHeaders;
	    	return validate.validateAllElement(gridCloumns, valRule);
	  }
	  	//统一校验函数
		function nameValidate(){
	    	var validate = new cap.Validate();
	    	var valRule = {name: nameValRule};
	    	//, name:nameValRule
	    	var gridCloumns = scope.customHeaders;
	    	return validate.validateAllElement(gridCloumns, valRule);
	  }
	</script>
	<%@ include file="/cap/bm/dev/page/uilibrary/PropertiesEditTmpl.jsp" %>
</body>
</html>
