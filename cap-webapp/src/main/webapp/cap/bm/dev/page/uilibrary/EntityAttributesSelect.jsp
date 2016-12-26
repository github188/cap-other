<%
/**********************************************************************
* GridTable属性
* 2015-05-07 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='entityAttributesSelect'>
<head>
	<title>选择实体属性</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
    	.custom-div {
    		height: 548px;
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
</head>
<body ng-controller="entityAttributesSelectCtrl" data-ng-init="ready()">
<div>
	<div class="cap-area">
		<table class="cap-table-fullWidth">
			<tr>
		        <td class="cap-td" style="text-align: right; padding-bottom:5px">
		        	<span cui_button id="saveButton" ng-click="save()" label="确定"></span>
		        </td>
		    </tr>
		    <tr style="border-top:1px solid #ddd;">
		        <td class="cap-td" style="text-align: center; padding: 2px; width: 30%;">
	        		<div class="custom-div">
			        	<table class="custom-grid" style="width: 100%;">
			                <thead>
			                    <tr>
			                    	<th style="width:30px">
			                    		<input type="checkbox" name="attributesCheckAll" ng-model="attributesCheckAll" ng-change="allCheckBoxCheckAttribute(attributes,attributesCheckAll)">
			                        </th>
			                        <th>
		                            	英文名
			                        </th>
			                        <th>
		                            	中文名
			                        </th>
			                        <th>
		                            	类型
			                        </th>
			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="attributeVo in attributes track by $index" style="background-color: {{attributeVo.check==true ? '#99ccff':'#ffffff'}}">
	                            	<td style="text-align: center;">
	                                    <input type="checkbox" name="{{'attribute'+($index + 1)}}" ng-model="attributeVo.check" ng-change="checkBoxCheckAttribute(attributes,'attributesCheckAll')">
	                                </td>
	                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
	                                    {{attributeVo.engName}}
	                                </td>
	                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
	                                    {{attributeVo.chName}}
	                                </td>
	                                <td style="text-align:left;cursor:pointer" ng-click="gridAttributeTdClick(attributeVo)">
	                                    {{attributeVo.attributeType}}
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
		var propertyName = "<c:out value='${param.propertyName}'/>";
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		var attributes = window.opener.opener.scope.attributes;
		attributes = attributes != null ? attributes : [];
		
	    var scope = {};
		angular.module('entityAttributesSelect', ["cui"]).controller('entityAttributesSelectCtrl', function ($scope, $compile) {
			$scope.attributes = [];
			$scope.params;
			$scope.attributesCheckAll　=　false;
			
			$scope.ready=function(){
				comtop.UI.scan();
				//初始化属性
				$scope.initAttributes();
	    	}
			
			// 初始化属性，兼容grid与editgrid属性获取  edit by linyuqian
			$scope.initAttributes = function(){
				for(var i = 0; i < attributes.length; i++){
					var attributesCopy = jQuery.extend(true, {}, attributes[i]);
					if(!attributesCopy.engName){
						$scope.attributes.push({engName:attributesCopy.attributeEname,chName:attributesCopy.attributeCname,attributeType:attributesCopy.attributeType});
					}else{
						$scope.attributes.push({engName:attributesCopy.engName,chName:attributesCopy.chName,attributeType:attributesCopy.attributeType.type});
					}
				}
			}
			
			
			//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheckAttribute=function(ar,isCheck){
	    		if(ar!=null){
	    			for(var i=0;i<ar.length;i++){
		    			if(isCheck){
		    				ar[i].check=true;
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
	    	    		}
	        			
	        			if(true){
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
	    		attributeVo.check = !attributeVo.check;
		    }
	    	
			//保存
			$scope.save=function(){
				var params='';
				for(var i in $scope.attributes){
					var attributeVo = $scope.attributes[i];
					if(attributeVo.check){
						params += attributeVo.engName + ";";
					}
				}
				if(params != ''){
					params = params.substring(0, params.length-1);
				}
				window.opener[callbackMethod](propertyName, params);
				window.close();
			}
		});
	</script>
</body>
</html>
