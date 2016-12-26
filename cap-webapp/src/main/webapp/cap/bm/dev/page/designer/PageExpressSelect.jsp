<%
/**********************************************************************
* 页面表达式选择
* 2015-5-27 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='pageExpressSelect'>
<head>
    <meta charset="UTF-8">
    <title>页面表达式选择</title>
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
    
    /*var pageComponentStateList=[
			{componentId:'button1',cname:'确定',ename:'ok',state:'edit',isValidate:true},
			{componentId:'input1',cname:'缺陷名称',ename:'defectName',state:'readOnly',isValidate:true},
			{componentId:'input2',cname:'描述',ename:'description',state:'hide',isValidate:false}
                               
    ];
    
    var expressions=[
                 {expressionId:(new Date()).valueOf(),checkAll:false,expression:'edit & add',expressionType:'java',pageComponentStateList:pageComponentStateList},
                 {expressionId:(new Date()).valueOf()+1,expression:'readOnly & tempCheck',expressionType:'js',pageComponentStateList:pageComponentStateList},
                 {expressionId:(new Date()).valueOf()+2,expression:'!tempCheck',expressionType:'java',pageComponentStateList:pageComponentStateList}
    ];
    
    var expressions1=[
                     {expressionId:(new Date()).valueOf(),checkAll:false,expression:'edit & add',expressionType:'java',pageComponentStateList:pageComponentStateList}
        ];
    
    var pages=[{modelId:'defect',modelName:'defect',pageComponentExpressionVOList:expressions},{modelId:'defectDevice',modelName:'defectDevice',pageComponentExpressionVOList:expressions1}];
    
    */
    
    var root={
    }
    
    dwr.TOPEngine.setAsync(false);
    PageFacade.queryPageList(packageId,function(result) {
		root.pages=result;
	})
	dwr.TOPEngine.setAsync(true);
    
    angular.module('pageExpressSelect', []).controller('pageExpressSelectCtrl', function ($scope) {
    	$scope.ready=function(){
	    	comtop.UI.scan();
	    }
    	
    	$scope.root=root;
    	$scope.selectPageVO=root.pages.length>0?root.pages[0]:{};
    	//表达式过滤关键字
    	$scope.expressionFilter="";
    	
    	//选中页面
    	$scope.pageTdClick=function(pageVO){
    		$scope.selectPageVO=pageVO;
    		$scope.expressionFilter="";
	    }
    	
    	//监控全选checkbox，如果选择则联动选中列表所有数据
    	$scope.allCheckBoxCheck=function(ar,isCheck){
    		if(ar!=null){
    			for(var i=0;i<ar.length;i++){
	    			if(isCheck && !ar[i].isFilter){
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
    	
    	//表达式列表过滤
    	$scope.$watch("expressionFilter",function(){
    		for(var i=0;i<$scope.selectPageVO.pageComponentExpressionVOList.length;i++){
    			if($scope.expressionFilter==""){
    				$scope.selectPageVO.pageComponentExpressionVOList[i].isFilter=false;
    			}else if($scope.selectPageVO.pageComponentExpressionVOList[i].expression.indexOf($scope.expressionFilter)==-1){
    				$scope.selectPageVO.pageComponentExpressionVOList[i].isFilter=true;
    			}
            }
    		$scope.checkBoxCheck($scope.selectPageVO.pageComponentExpressionVOList,"selectPageVO.checkAll");
    	});
    	
    	//导入表达式
    	$scope.importExpression=function(){
    		var ar=[];
    		for(var i=0;i<$scope.root.pages.length;i++){
    			var expressions=$scope.root.pages[i].pageComponentExpressionVOList;
    			for(var j=0;j<expressions.length;j++){
        			if(expressions[j].check){
        				ar.push(expressions[j]);
        			}
                }
            }
    		window.opener.importExpression(ar);
    		window.close();
    	}
    });

    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="pageExpressSelectCtrl" data-ng-init="ready()">
<div class="cap-page" style="width:780px;">
	<div class="cap-area" >
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:180px">
		        	<span id="formTitle" uitype="Label" value="页面表达式选择" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: left;vertical-align: middle">
		        	表达式过滤：<span id="expressionFilter" class="cui_inputCMP_wrap" style="width:150px">
				        <div class="cui_inputCMP" style="margin:0px">
				            <input type="text" name="expressionFilter" class="cui_inputCMP_input" ng-model="expressionFilter" placeholder="请输入过滤条件"
				            onfocus="jQuery('#expressionFilter').addClass('cui_inputCMP_focus')"
				            onblur="jQuery('#expressionFilter').removeClass('cui_inputCMP_focus')">
				        </div>
				    </span>
		        </td>
		         <td class="cap-td" style="text-align: right;">
		        	<span id="code" uitype="Button" label="确定" ng-click="importExpression()"></span>
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
                            <tr ng-repeat="pageVO in root.pages track by $index" ng-hide="expressionVo.isFilter" style="background-color: {{selectPageVO.modelId==pageVO.modelId ? '#99ccff':'#ffffff'}}">
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
		                    		<input type="checkbox" name="expressionsCheckAll" ng-model="selectPageVO.checkAll" ng-change="allCheckBoxCheck(selectPageVO.pageComponentExpressionVOList,selectPageVO.checkAll)">
		                        </th>
		                        <th>
	                            	表达式
		                        </th>
		                        <th style="width:100px">
	                            	表达式类型
		                        </th>
		                    </tr>
		                </thead>
                        <tbody>
                            <tr style="cursor:pointer" ng-repeat="expressionVo in selectPageVO.pageComponentExpressionVOList track by $index" ng-hide="expressionVo.isFilter">
                            	<td style="text-align: center;">
                                    <input type="checkbox" name="{{'expression'+($index + 1)}}" ng-model="expressionVo.check" ng-change="checkBoxCheck(selectPageVO.pageComponentExpressionVOList,'selectPageVO.checkAll')">
                                </td>
                                <td style="text-align:left;" ng-click="expressionVo.check=!expressionVo.check;checkBoxCheck(selectPageVO.pageComponentExpressionVOList,'selectPageVO.checkAll')">
                                    {{expressionVo.expression}}
                                </td>
                                <td style="text-align: center;" ng-click="expressionVo.check=!expressionVo.check;checkBoxCheck(selectPageVO.pageComponentExpressionVOList,'selectPageVO.checkAll')">
                                    {{expressionVo.expressionType}}
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