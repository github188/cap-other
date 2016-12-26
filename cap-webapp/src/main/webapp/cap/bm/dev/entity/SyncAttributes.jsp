<%
/**********************************************************************
* 同步数据库属性选择页面
* 2016-08-09 凌晨
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='syncAttributes'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>同步数据库属性选择</title>
	<top:link href="/cap/bm/common/base/css/base.css"/>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<style type="text/css">
		
	</style>
	<script type="text/javascript" charset="UTF-8">
		//拿到angularJS的scope
		var scope=null;
		angular.module('syncAttributes', ["cui"]).controller('syncAttributesCtrl',['$scope',function ($scope) {
		   	
		   	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
		   	
		   	$scope.init=function(){
		   		//加载所有改变的属性
		   		$scope.changedAttributes = window.parent.scope.changedAttributes ? window.parent.scope.changedAttributes : [];
		 		$scope.initChkItem();
		   	};
		   	
		  	//声明变量来控制表格的多选、全选、反选。初始化全选为false
	 		$scope.check = {'chkAll':false,'chkItem':[]};
			
			//初始化check.chkItem数组。只初始化一次。数组的元素个数与显示的数据有多少行一致。全部初始化为false。
			$scope.initChkItem = function(){
				//如果当前有数据，并且check.chkItem数组里面没值，则对check.chkItem进行初始化。下次进来则不再初始化（只初始化一次）
				if($scope.check.chkItem.length == 0 && $scope.changedAttributes.length > 0){
					for(var i=0 , len = $scope.changedAttributes.length; i < len; i++){
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
		   	 * 选择异常确定方法
		   	 * @param flag 是否同步所有
		   	 */
		   	$scope.chooseConfirm = function(flag){
		   		//选中的异常数组
		   		var choosedChangedAttribues = [];
		   		//取得所有被选中的异常对象
		   		$scope.check.chkItem.forEach(function(item,index,arr){
		   			if(item){
		   				choosedChangedAttribues.push($scope.changedAttributes[index]);
		   			}
		   		});
		   		
		   		if(!flag && choosedChangedAttribues.length == 0){
		   			cui.alert("请选择需要同步的属性");
		   			return;
		   		}
		   		
		   		window.parent.scope.sync(flag,choosedChangedAttribues);
			   	$scope.close();
		   	};
		   	
		   	/**
		   	 * 关闭窗口
		   	 */
		   	$scope.close = function(){
		   		window.parent.scope.removeCompareEntity();
		   		window.parent.syncAttributeDialog.hide();
		   	};
		}]);
	</script>
</head>
<body class="body_layout" ng-controller="syncAttributesCtrl" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td  class="cap-form-td" style="text-align: left;padding-left:5px; width:150px">
						<span class="cap-group">请选择需要同步的属性</span>
			        </td>
			        <td  class="cap-form-td" style="text-align: right;padding-right:5px">
						<span cui_button id="confim" button_type="green-button" ng-click="chooseConfirm(false)" label="同步所选"></span>
						<span cui_button id="confim" button_type="orange-button" ng-click="chooseConfirm(true)" label="同步所有"></span>
						<span cui_button id="close" ng-click="close()" label="取消"></span>
			        </td>
			    </tr>
			    <tr>
			    	<td class="cap-form-td" colspan="2">
			            <table class="custom-grid" style="width: 100%">
			                <thead>
			                    <tr>
			                    	<th style="width:30px">
			                    		<input type="checkbox"  ng-click="check.chkAll = !check.chkAll; clickAllObj(check.chkAll)" ng-checked="check.chkAll"/>
			                        </th>
			                        <th>
		                            	序号
			                        </th>
			                        <th style="width:30%">
		                            	状态
			                        </th>
			                        <th style="width:30%">
		                            	英文名
			                        </th>
			                        <th style="width:30%">
		                            	中文名
			                        </th>

			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="attribute in changedAttributes track by $index" style="background-color: {{check.chkItem[$index] ? '#99ccff' : '#ffffff'}}">
	                            	<td style="text-align: center;">
	                                    <input type="checkbox" id="{{'attribute'+($index + 1)}}" ng-click="clickItem(attribute, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)" ng-checked="check.chkItem[$index]">
	                                </td>
	                                <td style="text-align:center;"  ng-click="clickItem(attribute, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{$index+1}}
	                                </td>
	                                 <td style="text-align: center;" ng-click="clickItem(attribute, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{attribute.state}}
	                                </td>
	                                <td style="text-align: left;" ng-click="clickItem(attribute, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{attribute.ename}}
	                                </td>
	                                <td style="text-align: left;" ng-click="clickItem(attribute, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{attribute.cname}}
	                                </td>
	                            </tr>
	                            <tr ng-if="changedAttributes.length == 0 ">
	                            	<td colspan="4" class="grid-empty"> 本列表暂无记录</td>
	                            </tr>
	                       </tbody>
			            </table>
			    	</td>
			    </tr>
			</table>
		</div>	
	</div>
</body>
</html>