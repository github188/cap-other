<%
/**********************************************************************
* GridTable属性
* 2015-05-07 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='customGridSortName'>
<head>
	<title>数据模型属性</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
    	.custom-div {
    		height: 405px;
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
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
</head>
<body ng-controller="customGridSortNameCtrl" data-ng-init="ready()">
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
			                    		<input type="checkbox" name="sortNamesCheckAll" ng-model="sortNamesCheckAll" ng-change="allCheckBoxCheck(sortNames,sortNamesCheckAll)">
			                        </th>
			                        <th>
		                            	数据属性
			                        </th>
			                        <th>
		                            	排序方式
			                        </th>
			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="entityVo in sortNames track by $index">
	                            	<td style="text-align: center;">
	                                    <input type="checkbox" name="{{'sortName'+($index + 1)}}" ng-model="entityVo.check" ng-change="checkBoxCheck(sortNames,'sortNamesCheckAll')">
	                                </td>
	                                <td style="text-align:left;cursor:pointer">
	                                    {{entityVo.sortName}}
	                                </td>
	                                <td style="text-align:left;cursor:pointer">
	                                    <span cui_pulldown id="{{'sort'+($index + 1)}}" ng-model="entityVo.sortType" value_field="id" label_field="text" width="100%">
											<a value="ASC">ASC</a>
											<a value="DESC">DESC</a>
										</span>
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
		var columns = window.opener.scope.data.columns;
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		
	    var scope = {};
		angular.module('customGridSortName', ["cui"]).controller('customGridSortNameCtrl', function ($scope, $compile) {
			$scope.sortNames=[];
			$scope.sortNamesCheckAll　=　false;
			
			$scope.ready=function(){
	    		if(columns != null && columns !=''){
	    			columns = eval(columns);
		    		for(var i in columns){
		    			if(columns[i].bindName != null && columns[i].bindName !=''){
		    				$scope.sortNames.push({sortName: columns[i].bindName, sortType:'ASC'});
		    			}
		    		}
	    		}
	    		
	    		$(window).resize(function() {
		    		$(".custom-div").height(getBodyHeight);
	    		});
		    	
		    	function getBodyHeight () {
		            return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
		        }
	    	}
			
			//监控全选checkbox，如果选择则联动选中列表所有数据
	    	$scope.allCheckBoxCheck=function(ar,isCheck){
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
	    	
	    	$scope.save=function(){
	    		var sortNames = $scope.sortNames;
	    		var sortNameArray = [];
	    		var sortTypeArray = [];
	    		for(var i in sortNames){
	    			if(sortNames[i].check){
	    				sortNameArray.push(sortNames[i].sortName);
	    				sortTypeArray.push(sortNames[i].sortType);
	    			}
	    		}
	    		window.opener[callbackMethod]('sortname', sortNameArray.length==0?"":JSON.stringify(sortNameArray));
	    		window.opener[callbackMethod]('sorttype', sortTypeArray.length==0?"":JSON.stringify(sortTypeArray));
				window.close();
	    	}
		});
		
	</script>
</body>
</html>
