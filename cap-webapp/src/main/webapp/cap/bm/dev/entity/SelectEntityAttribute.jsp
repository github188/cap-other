<%
/**********************************************************************
* 实体属性选择页面
* 2015-10-20 凌晨
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='entityAttrList'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>实体属性选择</title>
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
	<top:script src="/cap/dwr/interface/ExceptionFacade.js"></top:script>
	<style type="text/css">
		.attrMsg{
			font-family: Microsoft yahei;
		} 
	</style>
	<script type="text/javascript" charset="UTF-8">
		//获得传递参数
		var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
		var methodId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("methodId"))%>;
		var type=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("type"))%>;
		var PageStorage = new cap.PageStorage(modelId);
		var entity = PageStorage.get("entity");
		var currentMethodVO;
		entity.methods.some(function(item){
			if(item.methodId == methodId){
				currentMethodVO = item;
				return true;
			}
			return false;
		});
		
		//拿到angularJS的scope
		var scope=null;
		var entityAttrListApp = angular.module('entityAttrList', ["cui"]).controller('entityAttrCtrl',['$scope',function ($scope) {
		   	
			$scope.entity = entity;
			
		   	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
		   	
		   	$scope.init=function(){
		   		//初始化控制表格的多选、全选、反选的对象
		   		$scope.initChkItem();
				
		   		$scope.filterChar = "";
		   		//之前已选中的属性，初始化成选中状态
		   		eval("currentMethodVO.userDefinedSQL." + type).forEach(function(_item, _index, _arr){
					$scope.entity.attributes.forEach(function(item, index, arr){
		   					if(item.engName == _item){
		   						$scope.check.chkItem[index] = true;
		   					}
		   				});
		   			});
		   		
		   		//是否需要把全选选中
		   		var needChkAll = false;
		   		//当数组长度为0的时候，使用every返回的是true，所以要先做下数组长度是否为0
		   		if($scope.check.chkItem.length > 0){
		   			needChkAll = $scope.check.chkItem.every(function(item){
			   			if(item == false){
			   				return false;
			   			}
			   			return true;
			   		});
		   		}
		   		if(needChkAll){
		   			$scope.check.chkAll = true;
		   		}
		   	};
		   	
		   	/**
		   	 * 快速查找（过滤）
		   	 * 注意：过滤动作不会改变原数据的选中状态
		   	 *
		   	 */
	    	$scope.$watch("filterChar",function(){
	    		$scope.isNotEmpty = false;
	    		for(var i = 0, len = $scope.entity.attributes.length; i < len; i++){
	    			if($scope.filterChar == "" || $scope.entity.attributes[i].engName.indexOf($scope.filterChar) > -1){
	    				$scope.entity.attributes[i].isFilter=false;
	    				$scope.isNotEmpty = true;
	    			}else{
	    				$scope.entity.attributes[i].isFilter=true;
	    			}
                }
	    	});
			
		  	//声明变量来控制表格的多选、全选、反选。初始化全选为false
	 		$scope.check = {'chkAll':false,'chkItem':[]};
			
			//初始化check.chkItem数组。只初始化一次。数组的元素个数与显示的数据有多少行一致。全部初始化为false。
			$scope.initChkItem = function(){
				//如果当前有数据，并且check.chkItem数组里面没值，则对check.chkItem进行初始化。下次进来则不再初始化（只初始化一次）
				if($scope.check.chkItem.length == 0 && $scope.entity.attributes.length > 0){
					for(var i=0 , len = $scope.entity.attributes.length; i < len; i++){
						//把每行数据的checkbox都初始化为false（未选中状态）
						$scope.check.chkItem[i]=false;
					}
				}
			};
			
			/**
			 * 点击单条数据的checkbox 
			 *
			 * @param vo 当前行的数据
			 * @param chkflag 当前行点击之前的选中状态
			 * @param index 当前行的索引号
			 *
			 */
			$scope.clickItem = function(vo, chkflag, index){
				$scope.initChkItem();
				$scope.check.chkItem[index] = !chkflag;
				//当前选中就去做判断是否所有都选中，若是，则全选设为选中。
				//当前取消选中，则直接把全选设为不选中
				if(!$scope.check.chkItem[index]){
					$scope.check.chkAll = false;
				}else{
					var isAllChecked = true;
					for(var i=0; i<$scope.check.chkItem.length; i++){
						if(!$scope.check.chkItem[i]){
							isAllChecked = false;
							break;
						}
					}
					if(isAllChecked){
						$scope.check.chkAll = true;
					}
				}
				//if you need do something,write here.
			};
			
			//全选和全反选
			$scope.clickAllObj = function(flag){
				$scope.initChkItem();
				for(var i=0; i<$scope.check.chkItem.length; i++){
					$scope.check.chkItem[i] = flag;
				}
				//if you need do something,write here.
			};
		   	
		   	/**
		   	 * 选择实体属性确定方法
		   	 *
		   	 */
		   	$scope.selectConfirm = function(){
		   		if(type == 'queryParams'){
		   			//每次选择都先清空数组，再往里添加。
					currentMethodVO.userDefinedSQL.queryParams = [];
					//每次选择都先清空,再赋值。
   					window.opener.scope.queryParams= "";
		   		}else if(type == 'returnResult'){
		   			//每次选择都先清空数组，再往里添加。
   					currentMethodVO.userDefinedSQL.returnResult = [];
   					//每次选择都先清空,再赋值。
   					window.opener.scope.returnResult= "";
		   		}
		   		
		   		
		   		//取得所有被选中的属性对象
		   		$scope.check.chkItem.forEach(function(item,index,arr){
		   			if(item){
		   				if(type == 'queryParams'){
		   					currentMethodVO.userDefinedSQL.queryParams.push($scope.entity.attributes[index].engName);
			   				window.opener.scope.queryParams += ($scope.entity.attributes[index].engName + ";");
		   				}else if(type == 'returnResult'){
		   					currentMethodVO.userDefinedSQL.returnResult.push($scope.entity.attributes[index].engName);
		   					window.opener.scope.returnResult += ($scope.entity.attributes[index].engName + ";");
		   				}
		   			}
		   		});
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
		
	</script>
</head>
<body class="body_layout" ng-controller="entityAttrCtrl" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td  class="cap-form-td" style="text-align: left;padding-left:5px; width:90px">
						<span cui_input  id="filterChar" ng-model="filterChar" width="190px" emptytext="请输入属性英文名称"></span>
			        </td>
			        <td  class="cap-form-td" style="text-align: right;padding-right:5px">
						<span cui_button id="select" ng-click="selectConfirm()" label="确定"></span>
						<span cui_button id="close" ng-click="close()" label="关闭"></span>
			        </td>
			    </tr>
			    <tr>
			    	<td class="cap-form-td" colspan="2">
			            <table class="custom-grid" style="width: 100%">
			                <thead>
			                    <tr>
			                    	<th style="width:30px">
			                    		<input type="checkbox"  ng-click="check.chkAll = !check.chkAll; clickAllObj(check.chkAll)" ng-checked="check.chkAll" ng-hide="filterChar"/><!-- 如果正在过滤操作，则把全选checkbox隐藏起来 -->
			                        </th>
			                        <th style="width:20%">
		                            	属性名称
			                        </th>
			                        <th style="width:30%">
		                            	中文名称
			                        </th>
			                        <th>
		                            	属性类型
			                        </th>
			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="attributeVo in entity.attributes track by $index" ng-hide="attributeVo.isFilter" style="background-color: {{check.chkItem[$index] ? '#99ccff' : '#ffffff'}}">
	                            	<td style="text-align: center;">
	                                    <input type="checkbox" id="{{'attributeVo'+($index + 1)}}" ng-click="clickItem(attributeVo, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)" ng-checked="check.chkItem[$index]">
	                                </td>
	                                <td style="text-align:center;"  ng-click="clickItem(attributeVo, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{attributeVo.engName}}
	                                </td>
	                                <td style="text-align: left;" ng-click="clickItem(attributeVo, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{attributeVo.chName}}
	                                </td>
	                                <td style="text-align: left;" ng-click="clickItem(attributeVo, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{attributeVo.attributeType.type}}
	                                </td>
	                            </tr>
	                            <tr ng-if="entity.attributes.length == 0 || !isNotEmpty">
	                            	<td colspan="4" class="grid-empty"> 本列表暂无记录</td>
	                            </tr>
	                       </tbody>
			            </table>
			    	</td>
			    </tr>
			    <tr>
			        <td  class="cap-form-td" colspan="2" style="text-align: left;padding-left:5px; width:90px">
						<span class= "attrMsg" style="color:red">提示：</span><span class= "attrMsg">过滤动作不会取消之前选中的数据。</span>
			        </td>
			    </tr>
			</table>
		</div>	
	</div>
</body>
</html>