<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>实体枚举属性编辑</title>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <!-- <top:link href="/cap/bm/dev/page/template/css/base.css"/> -->
    <top:link href="/cap/bm/dev/wizard/css/stepNav.css"></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.all.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/dev/wizard/js/entityService.js"></top:script>
	<!-- dwr -->
    <!-- <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/MetadataGenerateFacade.js"></top:script> -->
</head>
<body class="body_layout" ng-app="enumEdit" ng-controller="enumEditCtrl">
	<!-- <div class="cap-page">
		<div class="cap-area" style="width:100%;text-align:left;">
			枚举类名：<span width="100%" cui-input ng-model="enumValue"></span>
			<span cui_button label="确定" ng-click="ensure()" ></span>
		    <span cui_button label="清空" ng-click="clear()"></span>
		</div>
	</div> -->
	<div class="cap-page">
	    <div class="cap-area" style="border-top:1px solid #ccc;width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td  class="cap-form-td" style="text-align: left;">
			        	<table class="cap-table-fullWidth">
			        		<tr>
			        			<td  class="cap-form-td" style="text-align: left;padding-left:5px; width:250px">
									<span class="cap-group" style="font-weight:bold">设置实体枚举类名</span>
						        </td>
			        			<td  class="cap-form-td" style="text-align: right;padding-right:5px">
									<span cui_button label="确定" ng-click="ensure()" ></span>
		    						<span cui_button label="清空" ng-click="clear()"></span>
						        </td>
			        		</tr>
			        	</table>
			        </td>
			    </tr>
			    <tr>
			        <td style="text-align: left;">
			    		<table class="cap-table-fullWidth">
			    		    <tr>
						        <td class="cap-td" style="text-align: right;width:25%" nowrap="nowrap">
						        	枚举类名:
						        </td>
						        <td class="cap-td" style="text-align: left;width:75%" nowrap="nowrap">
						        	<span width="100%" cui-input ng-model="enumValue"></span>
						        </td>
						    </tr>
						  </table>
						  </br>
					 </td>
			    </tr>
			</table>
		</div>	
	</div>
</body>
</html>
<script type="text/javascript">
	angular.module('enumEdit', ['cui']).controller('enumEditCtrl', ['$scope', '$window', function($scope, $window){

		$scope.enumValue = cui.utils.param.enumValue;
		var callbackFunc = cui.utils.param.callback;
		$scope.clear = function () {
			$scope.enumValue = "";
			callback();
		}

		$scope.ensure = function () {
			callback();
		}

		function callback() {
			if(typeof $window.opener[callbackFunc] === 'function') {
				$window.opener[callbackFunc]($scope.enumValue);
				$window.close();
			}

		}
	}])
</script>