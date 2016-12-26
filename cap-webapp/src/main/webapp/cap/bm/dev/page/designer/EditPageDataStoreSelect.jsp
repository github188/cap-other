<%
/**********************************************************************
* 数据模型
* 2015-8-5 诸焕辉  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='editPageDataStoreSelect'>
<head>
<meta charset="UTF-8">
<title>数据模型</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<style type="text/css">
    	.list_header_wrap {
    		padding:10px 5px 15px 5px;
    		border-bottom: 1px solid #ccc;
    	}
    	.list_main_wrap {
    		height:545px;
    		margin:0 5px;
    		overflow-y:auto;
    	}
    </style>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/EnvironmentVariablePreferenceFacade.js'></top:script>
	<script type="text/javascript">
	
	//获得传递参数
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
   	var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
   	var hideFlag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("hideFlag"))%>;
   	var callbackMethod="<%=request.getParameter("callbackMethod")%>";
   	
   	var pageSession = new cap.PageStorage(modelId);
// 	var dataStore = pageSession.get("dataStore");
	var dataStore = $.extend(true, {}, pageSession.get("dataStore"));
    //拿到angularJS的scope
    var scope=null;
   
	angular.module('editPageDataStoreSelect', [ "cui"]).controller('editPageDataStoreSelectCtrl', function ($scope) {
		$scope.newDataStoreVO={};
		$scope.hideFlag = hideFlag;
		
		$scope.ready=function(){
	    	comtop.UI.scan();
	    	$scope.newDataStoreVO.modelType='object';
	    	scope=$scope;
	    }
		
		//选择实体
    	$scope.openEntitySelect=function(){
    		var url = "EntityListSelectionMain.jsp?packageId=" + packageId;
			var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
			window.open (url,'entitySelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    	}
    	
    	$scope.selectConfirm=function(){
    		var result = cap.validater.validAllElement();
    		if(result[2]){
   				if(callbackMethod != ""){
	    			window.opener[callbackMethod]($scope.newDataStoreVO);
	    		}
	    		window.close();
    		}
    	}
	});
	
	//导入实体
	function importEntityCallBack(entityVO){
		scope.newDataStoreVO.entityVO=entityVO;
		scope.newDataStoreVO.entityId=entityVO.modelId;
		dwr.TOPEngine.setAsync(false);
		PageFacade.dealRelationEntity(entityVO,function(result){
			scope.newDataStoreVO.subEntity = result == null?[]:result;
		});
		dwr.TOPEngine.setAsync(true);
		//自动初始化数据集的中英文名称
		setNames(scope);
	}
	
	//设置数据集的中英文名称
	function setNames(scope){
		var cname = scope.newDataStoreVO.entityVO.chName;
		var ename = scope.newDataStoreVO.entityVO.engName;
		if(ename !="" && ename != null){
			ename = ename.substring(0,1).toLowerCase() + ename.substring(1);
		}
		
		if(scope.newDataStoreVO.modelType == "object"){
			scope.newDataStoreVO.cname = (cname == "" || cname == null) ? "" : cname;				
			scope.newDataStoreVO.ename = ename;				
		}else if(scope.newDataStoreVO.modelType == "list"){
			scope.newDataStoreVO.cname = (cname == "" || cname == null) ? "集合" : cname + "集合";				
			scope.newDataStoreVO.ename = ename + "List";				
		}

		scope.$digest();
	}
	
	/**
	 * 点击数据类型radio改变中英文名称
	 * 在当前选中的radio上点击，不执行任何操作。
	 * 当点击当前未选中的radio时，如果点击的radiao是object，则去掉中文名称后面的“集合”，去掉英文名称后面的“List”，前提是中英文名称分别是以“集合”、“List”结尾。
	 * 当点击当前未选中的radio时，如果点击的radiao是List，则在中文名称后面添加“集合”，在英文名称后面添加“List”。
	 */
	function modelTypeClick(type){
		if(scope.newDataStoreVO.modelType != type){
			var cname = scope.newDataStoreVO.cname;
			var ename = scope.newDataStoreVO.ename;
			if(type == "object"){
				scope.newDataStoreVO.cname = (cname == "" || cname == null) ? "" : (cname.substring(cname.length-2) == "集合" ? cname.substring(0,cname.length-2) : cname);
				scope.newDataStoreVO.ename = (ename == "" || ename == null) ? "" : (ename.substring(ename.length-4) == "List" ? ename.substring(0,ename.length-4) : ename);
			}else if(type == "list"){
				scope.newDataStoreVO.cname = (cname == "" || cname == null ) ? "集合" : (cname.substring(cname.length-2) == "集合" ? cname : cname + "集合");
				scope.newDataStoreVO.ename = (ename == "" || ename == null ) ? "List" : (ename.substring(ename.length-4) == "List" ? ename : ename + "List");
			}
		}
	}
	
	//英文名称不能重复校验
    function validateDataStoreEname(ename){
    	var ret = true;
    	for(var i in dataStore){
    		if(dataStore[i].ename==ename){
    			ret=false;
        		break;
        	}
    	}
    	//cui("#saveBtn").disable(!ret);
    	return ret;
    }
	
	var dataStoreCnameValRule = [{'type':'required', 'rule':{'m': '数据集中文名称：不能为空'}}];
    var dataStoreEnameValRule = [{'type':'required', 'rule':{'m': '数据集英文名称：不能为空'}},{type:'format', rule:{pattern:'\^[a-z_$][a-zA-Z0-9_$]*\$', m:'数据集英文名称：只能输入字母、数字、美元符号‘$’或下划线‘_’，如首字符为字母，必须小写，遵循java变量命名规则'}},{type:'custom',rule:{against:'validateDataStoreEname', m:'数据集英文名称：不能重复'}}];
   
</script>
</head>
<body ng-controller="editPageDataStoreSelectCtrl" data-ng-init="ready()">
<div>
	<div class="list_header_wrap">
		<div class="top_float_left">
			<span id="formTitle" uitype="Label" value="页面数据模型设计" class="cap-label-title" size="12pt"></span>
		</div>
		<div class="top_float_right">
			<span id="saveBtn" uitype="Button" label="确定" ng-click="selectConfirm()"></span>
			<span id="colseBtn" uitype="Button" label="关闭" onClick="window.close()"></span>
		</div>
	</div>
	<div class="list_main_wrap">
       	<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-form-td" style="text-align: left;" colspan="2">
					<span class="cap-group">数据模型编辑</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: right;width:120px">
		        	<font color="red">*</font>数据类型：
		        </td>
		        <td class="cap-td" style="text-align: left;" ng-if="hideFlag == 'true' || hideFlag == true" >
					<input type="radio" name="modelType" ng-model="newDataStoreVO.modelType" value="object" onclick="modelTypeClick('object')"/>对象
		        </td>
		        <td class="cap-td" style="text-align: left;" ng-if="hideFlag == null" >
					<input type="radio" name="modelType" ng-model="newDataStoreVO.modelType" value="object" onclick="modelTypeClick('object')"/>对象
					<input type="radio" name="modelType" ng-model="newDataStoreVO.modelType" value="list" onclick="modelTypeClick('list')" />集合
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: right;width:120px">
		        	<font color="red">*</font>实体：
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span cui_clickinput id="parentName" ng-model="newDataStoreVO.entityVO.engName" ng-click="openEntitySelect()" width="100%"></span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: right;width:120px">
		        	<font color="red">*</font>数据集英文名称：
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span cui_input id="ename" ng-model="newDataStoreVO.ename" width="100%" validate="dataStoreEnameValRule"></span>
		        </td>
		    </tr>
		    <tr>
		        <td  class="cap-td" style="text-align: right;width:120px">
					<font color="red">*</font>数据集中文名称：
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span cui_input id="cname" ng-model="newDataStoreVO.cname" width="100%" validate="dataStoreCnameValRule"></span>
		        </td>
		    </tr>
		    
		    <tr>
		        <td class="cap-td" style="text-align: left;" colspan="2">
		        	<span class="cap-group">{{newDataStoreVO.entityVO.chName}}({{newDataStoreVO.entityVO.engName}})模型结构</span>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;" colspan="2">
		        	<table class="custom-grid" style="width: 100%">
		                <thead>
		                    <tr>
		                        <th>
	                            	中文名
		                        </th>
		                        <th>
	                            	英文名
		                        </th>
		                        <th style="width:100px">
	                            	类型
		                        </th>
		                        <th style="width:150px">
	                            	初始值
		                        </th>
		                    </tr>
		                </thead>
                        <tbody>
                            <tr ng-repeat="entityAttributeVO in newDataStoreVO.entityVO.attributes track by $index">
                                <td style="text-align:left;">
                                    {{entityAttributeVO.chName}}
                                </td>
                                <td style="text-align: left;">
                                    {{entityAttributeVO.engName}}
                                </td>
                                <td style="text-align:center;">
                                    {{entityAttributeVO.attributeType.type}}
                                </td>
                                <td style="text-align:left;">
                                    {{entityAttributeVO.defaultValue}}
                                </td>
                            </tr>
                       </tbody>
		            </table>
		        </td>
		    </tr>
		    <tr ng-repeat="entityVO in newDataStoreVO.subEntity track by $index">
		        <td class="cap-td" style="text-align: left;" colspan="2">
		        	<table class="cap-table-fullWidth">
                           <tr>
                               <td style="text-align:left;">
                               	<span class="cap-group">{{entityVO.chName}}({{entityVO.engName}})模型结构</span>
                               </td>
                           </tr>
		            </table>
		        	<table class="custom-grid" style="width: 100%">
		                <thead>
		                    <tr>
		                        <th>
	                            	中文名
		                        </th>
		                        <th>
	                            	英文名
		                        </th>
		                        <th style="width:150px">
	                            	类型
		                        </th>
		                        <th style="width:150px">
	                            	初始值
		                        </th>
		                    </tr>
		                </thead>
                        <tbody>
                            <tr ng-repeat="entityAttributeVO in entityVO.attributes track by $index">
                                <td style="text-align:left;">
                                    {{entityAttributeVO.chName}}
                                </td>
                                <td style="text-align: left;">
                                    {{entityAttributeVO.engName}}
                                </td>
                                <td style="text-align:center;">
                                    {{entityAttributeVO.attributeType.type}}
                                </td>
                                <td style="text-align:left;">
                                    {{entityAttributeVO.defaultValue}}
                                </td>
                            </tr>
                       </tbody>
		            </table>
		        </td>
		    </tr>
<!-- 		    <tr>
		        <td class="cap-td" style="text-align: left;" colspan="2">
		        </td>
		    </tr> -->
		</table>
	</div>
</div>
</body>
</html>
