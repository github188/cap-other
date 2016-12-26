<%
/**********************************************************************
* 异常选择页面
* 2015-10-14 凌晨
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='exceptionsList'>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>异常选择</title>
	<top:link href="/cap/bm/common/base/css/base.css"/>
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
		
	</style>
	<script type="text/javascript" charset="UTF-8">
		//获得传递参数
		var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		var fromServiceObject=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("fromServiceObject"))%>;

		//拿到angularJS的scope
		var scope=null;
		angular.module('exceptionsList', ["cui"]).controller('exceptionsCtrl',['$scope',function ($scope) {
		   	
		   	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    	$scope.init();
		    };
		   	
		   	$scope.init=function(){
		   		//读出此模块的所有异常
		   		dwr.TOPEngine.setAsync(false);
		   		ExceptionFacade.queryExceptionList(packageId,function(result){
		   			$scope.exceptionList = result;
		   		});
		 		dwr.TOPEngine.setAsync(true);
		 		$scope.initChkItem();
		   	};
			
		   	
		  	//声明变量来控制表格的多选、全选、反选。初始化全选为false
	 		$scope.check = {'chkAll':false,'chkItem':[]};
			
			//初始化check.chkItem数组。只初始化一次。数组的元素个数与显示的数据有多少行一致。全部初始化为false。
			$scope.initChkItem = function(){
				//如果当前有数据，并且check.chkItem数组里面没值，则对check.chkItem进行初始化。下次进来则不再初始化（只初始化一次）
				if($scope.check.chkItem.length == 0 && $scope.exceptionList.length > 0){
					for(var i=0 , len = $scope.exceptionList.length; i < len; i++){
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
		   	 *
		   	 */
		   	$scope.chooseConfirm = function(){
		   		//选中的异常数组
		   		var choosedExceptions = [];
		   		//取得所有被选中的异常对象
		   		$scope.check.chkItem.forEach(function(item,index,arr){
		   			if(item){
		   				choosedExceptions.push($scope.exceptionList[index]);
		   			}
		   		});
		   		//来自服务实体
		   		if(fromServiceObject=='true'){
		   			window.parent.selExceptionBack(choosedExceptions);
		   			window.parent.dialog.hide();
		   		}else{//来自实体
			   		window.opener.scope.confirmExceptions(choosedExceptions);
			   		//渲染父页面
		   			cap.digestValue(window.opener.scope);
			   		$scope.close();
		   		}
		   	};
		   	
		   	/**
		   	 * 删除异常
		   	 *
		   	 */
		   	$scope.deleteExceptions = function(){
		   		//取得需要删除的异常的modelId的集合
		   		var delExceptionsId = [];
		   		//组装需要删除的异常的简单对象
		   		var delExceptionObjs = [];
		   		var existIndex = [];
		   		$scope.check.chkItem.forEach(function(item, index, arr){
		   			if(item){
		   				delExceptionsId.push($scope.exceptionList[index].modelId);
		   				delExceptionObjs.push({modelId : $scope.exceptionList[index].modelId});
		   				existIndex.push(index);
		   			}
		   		});
		   		if(delExceptionsId.length <=0 ){
		   			cui.alert('请选择需要删除的异常！');
		   			return;
		   		}
		   		cui.confirm('异常的影响范围是整个模块，确定要删除这些异常吗？', {
		   			onYes: function(){
				   		//删除这些异常
				   		var result = true;
				   		dwr.TOPEngine.setAsync(false);
				   		ExceptionFacade.delExceptions(delExceptionsId,function(_result){
				   			result = _result;
				   		});
				 		dwr.TOPEngine.setAsync(true);
				   		
				 		if(!result){
				 			cui.error('删除异常失败！');
				 			return;
				 		}else{
							//逆序遍历$scope.check.chkItem。existIndex里面存放的索引号就是$scope.check.chkItem需要删除的元素的索引
				 			for(var i = $scope.check.chkItem.length-1; i >= 0; i--){
				 				for(var j = 0, _len = existIndex.length; j < _len; j++){
				 					if(i == existIndex[j]){
				 						$scope.check.chkItem.splice(i,1);
				 					}
				 				}
				 			}
				 			cap.array.remove($scope.exceptionList, delExceptionObjs, true);
				 			//把数据全部删除后，全选按钮设为false
				 			if($scope.check.chkItem.length <= 0){
				 				$scope.check.chkAll = false;
				 			}
				 			cap.digestValue(scope);
				 		}
		   			},
		   			onNo: function(){
		   				return;
		   			}
		   		});
		   	};
		   	
		   	/**
		   	 * 新增或编辑本模块的异常
		   	 *
		   	 * @param <code>exceptionModelId</code>异常的modelId
		   	 */
		   	$scope.editException = function(exceptionModelId){
		   		var url='ExceptionEdit.jsp?packageId=' + packageId +'&fromServiceObject='+fromServiceObject;
		   		if(exceptionModelId){
		   			url += '&modelId=' + exceptionModelId;
		   		}
		   		
		   		window.location.href = url;
			    //window.open(url, "_self", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes");
		   	};
		   	
		   	/**
		   	 * 关闭窗口
		   	 */
		   	$scope.close = function(){
		   		if(fromServiceObject=='true'){
		   			window.parent.dialog.hide();
		   		}else{
			   		window.close();
		   		}
		   	};
		}]);
	</script>
</head>
<body class="body_layout" ng-controller="exceptionsCtrl" data-ng-init="ready()">
	<div class="cap-page">
	    <div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth">
			    <tr>
			        <td  class="cap-form-td" style="text-align: left;padding-left:5px; width:90px">
						<span class="cap-group">异常列表</span>
			        </td>
			        <td  class="cap-form-td" style="text-align: right;padding-right:5px">
						<span cui_button id="confim" ng-click="chooseConfirm()" label="确定"></span>
						<span cui_button id="addException" ng-click="editException()" label="新增"></span>
						<span cui_button id="deleteExceptions" ng-click="deleteExceptions()" label="删除"></span>
						<span cui_button id="close" ng-click="close()" label="关闭"></span>
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
			                        <th style="width:30%">
		                            	异常名称
			                        </th>
			                        <th style="width:30%">
		                            	包名
			                        </th>
			                        <th>
		                            	提示信息
			                        </th>
			                    </tr>
			                </thead>
	                        <tbody>
	                            <tr ng-repeat="exceptionVo in exceptionList track by $index" style="background-color: {{check.chkItem[$index] ? '#99ccff' : '#ffffff'}}">
	                            	<td style="text-align: center;">
	                                    <input type="checkbox" id="{{'exceptionVo'+($index + 1)}}" ng-click="clickItem(exceptionVo, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)" ng-checked="check.chkItem[$index]">
	                                </td>
	                                <td style="text-align:center;"  ng-click="clickItem(exceptionVo, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    <a ng-click="editException(exceptionVo.modelId)" style="color:#2b71d9;">{{exceptionVo.engName}}</a>
	                                </td>
	                                <td style="text-align: left;" ng-click="clickItem(exceptionVo, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{exceptionVo.modelPackage}}
	                                </td>
	                                <td style="text-align: left;" ng-click="clickItem(exceptionVo, check.chkItem[$index] == undefined ? false : check.chkItem[$index], $index)">
	                                    {{exceptionVo.description}}
	                                </td>
	                            </tr>
	                            <tr ng-if="exceptionList.length == 0 ">
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