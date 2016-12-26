<%
/**********************************************************************
* 查询建模-select属性选择页面
* 2016-08-12 许畅 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='selectAttribute'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>SELECT属性选择</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"/>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/EntityFacade.js"></top:script>
	<style type="text/css">
	.cap-form-td{
		padding: 2px 0px 2px 0px;
	}
	</style>
</head>
<body class="body_layout" ng-controller="selectAttributeController" data-ng-init="ready()">
	<div style="margin-top: 10px;">
		<span class="cap-group" style="text-align: left">SELECT属性选择</span>
	</div>
	<div class="cap-page">
		<div style="position:fixed; top:5px;right:10px;z-index: 100">
	        			<span cui_button id="confim" ng-click="confirm()" label="确定"></span>
	        			<span cui_button id="close" ng-click="close()" label="关闭"></span>
		</div>
	    <div class="cap-area" style="width:100%;">
       		<table class="custom-grid" style="width: 100%">
            	<thead>
                	<tr>
                    	<th style="width:30px">
                        </th>
                        <th>
                        	属性名称
                        </th>
                        <th>
                        	数据库列名
                        </th>
                        <th>
                        	中文名称
                        </th>
                	</tr>
            	</thead>
                <tbody>
                    <tr ng-repeat="entityAttributeVo in root.entityAttributes" style="background-color: {{selectedAttribute==entityAttributeVo ? '#99ccff':'#ffffff'}}">
                    	<td style="text-align: center;">
                            <input type="radio" name="{{'entityAttributeVo'+($index + 1)}}" ng-click="attributeTdClick(entityAttributeVo)" ng-checked="entityAttributeVo.check" >
                        </td>
                        <td style="text-align:left;cursor:pointer" ng-click="attributeTdClick(entityAttributeVo)">
                            {{entityAttributeVo.engName}}
                        </td>
                        <td style="text-align: center;" ng-click="attributeTdClick(entityAttributeVo)">
                            {{entityAttributeVo.dbFieldId}}
                        </td>
                        <td style="text-align: center;" ng-click="attributeTdClick(entityAttributeVo)">
                            {{entityAttributeVo.chName}}
                        </td>
                    </tr>
                    <tr ng-if="root.entityAttributes.length == 0">
                    	<td colspan="3" class="grid-empty"> 本列表暂无记录</td>
                    </tr>
               </tbody>
        	</table>

		</div>	
	</div>
</body>

<script type="text/javascript" charset="UTF-8">
		//实体id
		var modelId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;

		//拿到angularJS的scope
		var scope = null;
		var root = {};
		angular.module('selectAttribute', ["cui"]).controller('selectAttributeController', ['$scope', function($scope) {

			//Angular初始化
			$scope.ready = function() {
				comtop.UI.scan();
				$scope.root = root;
				scope = $scope;
				$scope.init();
			};

			$scope.init = function() {
				if(modelId){
					dwr.TOPEngine.setAsync(false);
					EntityFacade.loadEntity(modelId, "", function(entity) {
						$scope.root.entityAttributes = entity.attributes;
					});
					dwr.TOPEngine.setAsync(true);
				}else{
					$scope.root.entityAttributes = [];
				}
			};

			//确定
			$scope.confirm = function() {
				window.opener.scope.confirmCallBack($scope.selectedAttribute);
				window.close();
			};

			//关闭窗口
			$scope.close = function() {
				window.close();
			}

			//属性选择点击
			$scope.attributeTdClick = function(entityAttributeVo) {
				$scope.selectedAttribute = entityAttributeVo;
				var attributes = $scope.root.entityAttributes;
				for (var i = 0; i < attributes.length; i++) {
					var attr = attributes[i];
					if (attr.engName == entityAttributeVo.engName) {
						attr.check = true;
					} else {
						attr.check = false;
					}
				}
			}

		}]);
</script>

</html>