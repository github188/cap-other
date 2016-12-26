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
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth" >
			    <tr>
			        <td class="cap-form-td" style="text-align: left;padding-left:5px;" width="30%">
						<span class="cap-group">SELECT属性选择</span>
			        </td>
			        <td ng-if="!isShowGridBtn" class="cap-form-td" style="text-align: right;padding-right:5px" width="70%">
						<span cui_button id="confim" ng-click="confim()" label="确定"></span>
						<span cui_button id="addExpression" ng-show="isShowExpBtn" ng-click="addExpression()" label="添加表达式"></span>
						<span cui_button id="close" ng-click="close()" label="关闭"></span>
			        </td>

	                <td ng-if="isShowGridBtn" class="cap-form-td" style="text-align: right;padding-right:5px" width="70%">
	        			<span cui_button id="confim2" ng-click="confirm2()" label="确定"></span>
	        			<span cui_button id="close" ng-click="close()" label="关闭"></span>
	                </td>
			    </tr>

			    <tr ng-if="root.entityAttributes.length == 0">
			    	<td class="cap-form-td">
			    		<font color="red">*</font>查询结果别名:
			    	</td>
			    	<td class="cap-form-td" style="text-align:left;">
			    		<span cui_input id ="columnAlias" ng-model="selectAttribute.columnAlias" />
			    	</td>
			    </tr>

			    <tr ng-if="isShowAlias">
			    	<td class="cap-form-td">
			    		<font color="red">*</font>查询结果别名:
			    	</td>
			    	<td class="cap-form-td" style="text-align:left;">
			    		<span cui_clickinput id ="columnAlias" ng-model="selectAttribute.columnAlias" ng-click="columnAliasClick()" />
			    	</td>
			    </tr>

			    <tr ng-if="isShowExpression">
			    	<td class="cap-form-td">
			    		查询表达式:
			    		<div style="color:red;">(注:如果填写了表达式会覆盖当前查询列的属性值)</div>
			    	</td>
			    	<td class="cap-form-td" style="text-align:left;">
			    		<span cui_textarea  id ="sqlScript" ng-model="selectAttribute.sqlScript"  height="200px"/>
			    	</td>
			    </tr>
			</table>

       		<table class="custom-grid" style="width: 100%" ng-if="isShowGrid">
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
                        <td style="text-align:left;cursor:pointer" ng-click="attributeTdClick(entityAttributeVo)">
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
		var isShowGrid = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("isShowGrid"))%>;
		var relationEntityId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("relationEntityId"))%>;
		relationEntityId = relationEntityId == "none" ? null : relationEntityId;
		var isShowExpression = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("isShowExpression"))%>;

		//拿到angularJS的scope
		var scope = null;
		var selectAttribute = window.opener.scope.selectAttribute;
		var root = {};
		angular.module('selectAttribute', ["cui"]).controller('selectAttributeController', ['$scope', function($scope) {

			//Angular初始化
			$scope.ready = function() {
				comtop.UI.scan();
				$scope.selectAttribute = $.extend(true, {}, selectAttribute);
				$scope.root = root;
				scope = $scope;
				$scope.init();
			};

			$scope.init = function() {
				$scope.isShowAlias = false;
				$scope.isShowExpression = false;
				$scope.isShowGrid = true;
				$scope.isShowGridBtn = false;

				if (!relationEntityId) {
					$scope.isShowExpression = true;
					$scope.root.entityAttributes = [];
					$scope.isShowGrid = false;
					return;
				}
				if (isShowGrid) {
					$scope.isShowGrid = true;
					$scope.isShowGridBtn = true;
					$scope.isShowMain = false;
				}

				dwr.TOPEngine.setAsync(false);
				EntityFacade.loadEntity(relationEntityId, "", function(result) {
					$scope.root.entityAttributes = result.attributes;
					$scope.setSelectedValue(selectAttribute.columnAlias);

				});
				dwr.TOPEngine.setAsync(true);

				if (isShowExpression) {
					$scope.showExpression();
				} else {
					$scope.isShowExpBtn = ($scope.root.entityAttributes.length > 0);
				}
			};

			//设置默认选中
			$scope.setSelectedValue = function(columnAlias) {
				var attributes = $scope.root.entityAttributes;
				for (var i = 0; i < attributes.length; i++) {
					if (attributes[i].engName == columnAlias) {
						$scope.selectedAttribute = attributes[i];
						attributes[i].check = true;
					}
				}
			};

			//确定
			$scope.confim = function() {
				if ($scope.selectedAttribute) {
					$scope.selectAttribute.columnAlias = $scope.selectedAttribute.engName;
				}
				var oldColumnAlias = selectAttribute.columnAlias;
				var newColumnAlias = $scope.selectAttribute.columnAlias;
				var isPass = window.opener.selectAttributeCallBack(newColumnAlias, oldColumnAlias, $scope.selectAttribute);
				if (!isPass) {
					cui.alert("当前查询结果别名存在重复,请重新填写.");
				} else {
					window.close();
				}
			};

			//添加表达式
			$scope.addExpression = function() {
				$scope.showExpression();
				if ($scope.selectedAttribute) {
					$scope.selectAttribute.columnAlias = $scope.selectedAttribute.engName;
				}
			}

			$scope.showExpression = function() {
				$scope.isShowExpression = true;
				$scope.isShowAlias = true;
				$scope.isShowGrid = false;
				$scope.isShowExpBtn = false;
			}

			$scope.columnAliasClick = function() {
				var url = 'SelectAttribute.jsp?modelId=' + modelId + '&packageId=' + packageId + '&isShowGrid=true' + '&relationEntityId=' + relationEntityId;
				var width = 600; //窗口宽度
				var height = 500; //窗口高度
				var top = (window.screen.height - 30 - height) / 2;
				var left = (window.screen.width - 10 - width) / 2;
				window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width=" + width + " ,Height=" + height + ",top=" + top + ",left=" + left);
			}

			$scope.confirm2 = function() {
				if (!$scope.selectedAttribute) {
					cui.alert("请选择属性.");
					return;
				}
				window.opener.scope.confirm2CallBack($scope.selectedAttribute);
				window.close();
			}

			$scope.confirm2CallBack = function(selectedAttribute) {
				$scope.selectAttribute.columnAlias = selectedAttribute.engName;
				$scope.selectedAttribute = selectedAttribute;
				$scope.$digest();
			}

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