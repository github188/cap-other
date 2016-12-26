<%
/**********************************************************************
* 页面数据集选择
* 2015-7-9 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='pageDataStoreSelect'>
<head>
    <meta charset="UTF-8">
    <title>页面数据集选择</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
    	
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
    <script type="text/javascript">
    
    var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
    var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
    
    var root={};
    
    dwr.TOPEngine.setAsync(false);
    PageFacade.queryPageListAndDataStoreVO(packageId, modelId, function(result) {
    	if(result == null){
    		root.pages = [];
    	}else{
			root.pages=result;
    	}
	})
	dwr.TOPEngine.setAsync(true);
    
    angular.module('pageDataStoreSelect', []).controller('pageDataStoreSelectCtrl', function ($scope) {
    	$scope.ready=function(){
	    	comtop.UI.scan();
	    }
    	
    	$scope.root=root;
    	$scope.selectPageVO=root.pages.length>0?root.pages[0]:{};
    	
    	//选中页面
    	$scope.pageTdClick=function(pageVO){
    		$scope.selectPageVO=pageVO;
	    }
    	
    	//监控全选checkbox，如果选择则联动选中列表所有数据
    	$scope.allCheckBoxCheck=function(ar,isCheck){
    		if(ar!=null){
    			for(var i=0;i<ar.length;i++){
	    			if(isCheck && (ar[i].modelType =='list' || ar[i].modelType =='object')){
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
	    			
	    			if(ar[i].modelType =='list' || ar[i].modelType =='object'){
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
    	
    	//导入表达式
    	$scope.importPageDataStore=function(){
    		var ar=[];
    		for(var i=0;i<$scope.root.pages.length;i++){
    			var dataStoreVOList=$scope.root.pages[i].dataStoreVOList;
    			for(var j=0;j<dataStoreVOList.length;j++){
        			if(dataStoreVOList[j].check){
        				ar.push(dataStoreVOList[j]);
        			}
                }
            }
    		window.opener.importPageDataStoreCallBack(ar);
    		window.close();
    	}
    });

    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="pageDataStoreSelectCtrl" data-ng-init="ready()">
<div class="cap-page" style="width:780px;">
	<div class="cap-area" >
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:180px">
		        	<span id="formTitle" uitype="Label" value="页面数据集选择" class="cap-label-title"></span>
		        </td>
		         <td class="cap-td" style="text-align: right;">
		        	<span id="code" uitype="Button" label="确定" ng-click="importPageDataStore()"></span>
		        	<span id="code" uitype="Button" label="关闭" onClick="window.close()"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:200px">
		        	<table class="custom-grid" style="width: 100%">
		                <thead>
		                    <tr>
		                        <th>
	                            	页面名称
		                        </th>
		                    </tr>
		                </thead>
                        <tbody>
                            <tr ng-repeat="pageVO in root.pages track by $index" style="background-color: {{selectPageVO.modelId==pageVO.modelId ? '#99ccff':'#ffffff'}}">
                                <td style="text-align:left;cursor:pointer" ng-click="pageTdClick(pageVO)" >
                                    {{pageVO.modelName}}
                                </td>
                            </tr>
                       </tbody>
		            </table>
		        </td>
		        <td style="text-align: left;border-right:1px solid #ddd;padding-top:10px">
		        </td>
		        <td class="cap-td" style="text-align: left;width:600px">
       				<table class="custom-grid" style="width: 100%">
		                <thead>
		                    <tr>
		                    	<th style="width:30px">
		                    		<input type="checkbox" name="dataStoreCheckAll" ng-model="selectPageVO.checkAll" ng-change="allCheckBoxCheck(selectPageVO.dataStoreVOList,selectPageVO.checkAll)">
		                        </th>
		                        <th>
	                            	数据集中文名
		                        </th>
		                        <th>
	                            	数据集英文名
		                        </th>
		                    </tr>
		                </thead>
                        <tbody>
                            <tr style="cursor:pointer" ng-repeat="dataStoreVO in selectPageVO.dataStoreVOList track by $index" ng-show="dataStoreVO.modelType =='list' || dataStoreVO.modelType =='object'">
                            	<td style="text-align: center;">
                                    <input type="checkbox" name="{{'dataStoreVO'+($index + 1)}}" ng-model="dataStoreVO.check" ng-change="checkBoxCheck(selectPageVO.dataStoreVOList,'selectPageVO.checkAll')">
                                </td>
                                <td style="text-align:left;" ng-click="dataStoreVO.check=!dataStoreVO.check;checkBoxCheck(selectPageVO.dataStoreVOList,'selectPageVO.checkAll')">
                                    {{dataStoreVO.cname}}
                                </td>
                                <td style="text-align: center;" ng-click="dataStoreVO.check=!dataStoreVO.check;checkBoxCheck(selectPageVO.dataStoreVOList,'selectPageVO.checkAll')">
                                    {{dataStoreVO.ename}}
                                </td>
                            </tr>
                       </tbody>
		            </table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        </td>
		    </tr>
		</table>
	</div>
</div>
</body>
</html>