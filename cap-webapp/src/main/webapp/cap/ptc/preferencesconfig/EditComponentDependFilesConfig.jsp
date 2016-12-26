<%
/**********************************************************************
* 过滤的引入文件
* 2016-3-30 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='replaceIncludeFileConfigInfo'>
<head>
<meta charset="UTF-8">
<title>过滤的引入文件</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	 
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/ComponentDependFilesConfigFacade.js'></top:script>
</head>
<body ng-controller="replaceIncludeFileConfigInfoCtrl" data-ng-init="ready()">
	<div class="cap-page" ng-switch="hasEditState">
		<div style="text-align: left;"><span id="formTitle" uitype="Label" value="控件依赖文件变更配置" class="cap-label-title" size="12pt"></span></div>
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span cui_clickinput id="quickSearch" ng-model="expressionFilter" width="550px" name="clickInput" enterable="true" emptytext="请输入文件路径进行过滤" editable="true" on_iconclick="keyWordQuery" on_keydown="keyDownQuery" icon="search" iconwidth="18px"></span> 
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="saveBtn" cui_button ng-click="toggleState(true)" ng-switch-when="false" label="编辑"></span>
					<span id="saveBtn" cui_button ng-click="save()" ng-switch-default label="保存"></span>&nbsp;
					<span id="saveBtn" cui_button ng-click="batchundoDependFilesConfig()" ng-switch-default label="还原"></span>&nbsp;
					<span id="saveBtn" cui_button ng-click="toggleState(false)" ng-switch-default label="返回"></span>
				</td>
			</tr>
		</table>
		<table class="custom-grid" style="width: 100%">
			<thead>
	        	<tr>
	        		<th style="width:30px">
                		<input type="checkbox" ng-switch-default name="dependFilesConfigCheckAll" ng-model="dependFilesConfigCheckAll" ng-change="allCheckBoxCheck(componentDependFilesConfigVO.dependFilesChangeInfoList,dependFilesConfigCheckAll)">
                    </th>
	        		<th style="text-align:center;" width="80">序号</th>
					<th style="text-align:center;" width="45%">默认依赖文件路径</th>
					<th style="text-align:center;" width="45%">替换依赖文件路径</th>
	                <th style="width:80px">操作</th>
	             </tr>
	         </thead>
	         <tbody>
	         	<tr ng-repeat="dependFilesConfigInfo in componentDependFilesConfigVO.dependFilesChangeInfoList track by $index" ng-hide="dependFilesConfigInfo.isFilter" style="background-color: {{dependFilesConfigInfo.check ? '#99ccff':'#ffffff'}}">
	               	<td style="text-align: center;">
	            		<input type="checkbox" ng-switch-default name="{{'dependFilesConfigInfo'+($index + 1)}}" ng-model="dependFilesConfigInfo.check" ng-change="checkBoxCheck(componentDependFilesConfigVO.dependFilesChangeInfoList,'dependFilesConfigCheckAll')">
	            	</td>
	                <td style="text-align:center;">
	                    {{$index + 1}}
	                </td>
	                <td style="text-align:left;">
	                    {{dependFilesConfigInfo.defaultFilePath}}
	                </td>
	                <td style="text-align: left;">
	               		<span cui_clickinput ng-switch-when="false" id="{{'filePath'+($index + 1)}}" name="{{'filePath'+($index + 1)}}" ng-model="dependFilesConfigInfo.customFilePath" width="100%" readonly="true"></span>
	               		<span cui_clickinput ng-switch-default id="{{'filePath'+($index + 1)}}" name="{{'filePath'+($index + 1)}}" editable="true" ng-model="dependFilesConfigInfo.customFilePath" width="100%" on_iconclick="importIncludeFile"></span>
					</td>
	                <td style="text-align: center;">
	                 	<span class="cui-icon" title="还原" ng-switch-default style="cursor:pointer;" ng-click="undoDependFilesConfig($index)">&#xf0e2;</span>
	                </td>
	        	</tr>
			</tbody>
	    </table>
	</div>
	<script type="text/javascript">
	    var scope=null;
		angular.module('replaceIncludeFileConfigInfo', [ "cui"]).controller('replaceIncludeFileConfigInfoCtrl', function ($scope) {
			//控件依赖文件变更配置
			$scope.componentDependFilesConfigVO = {};
			//编辑时，如果没保存，直接点击返回，这把之前数据存储在tempStorage变量中，便于恢复数据
			$scope.tempStorage = {};
			//是否是编辑状态
			$scope.hasEditState = false;
			$scope.ready=function(){
				$scope.init();
		    	comtop.UI.scan();
		    	scope=$scope;
		    }
			
			$scope.dependFilesConfigCheckAll=false;
			
	    	$scope.init=function(){
	    		dwr.TOPEngine.setAsync(false);
	    		ComponentDependFilesConfigFacade.loadModel('preference.page.componentDependFilesConfig.dependFilesChangeInfo', function(data) {
					if(data){
						$scope.componentDependFilesConfigVO = data;
						$scope.tempStorage = jQuery.extend(true, {}, data);
					}
				});
				dwr.TOPEngine.setAsync(true);
	    	}
			
	    	$scope.toggleState=function(state){
	    		$scope.hasEditState = state;
	    		$scope.componentDependFilesConfigVO = jQuery.extend(true, {}, $scope.tempStorage);
	    		$scope.expressionFilter = "";
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
	        			
	        			if(true){
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
	    	
	    	//批量还原
	    	$scope.batchundoDependFilesConfig=function(){
	    		var selectDataList = _.filter($scope.componentDependFilesConfigVO.dependFilesChangeInfoList, {check: true});
	    		if(selectDataList.length > 0){
	    			for(var i=0,len=selectDataList.length; i<len; i++){
		    			selectDataList[i].customFilePath = null;
	        		}
	    		} else {
	    			cui.alert("请选择要还原的变更配置项。");
	    		}
	    	}
	    	
	    	//还原
	    	$scope.undoDependFilesConfig=function(index){
	    		$scope.componentDependFilesConfigVO.dependFilesChangeInfoList[index].customFilePath = null;
	    	}
	    	
	    	//保存
	    	$scope.save=function(){
	    		var result = validateData();
    		    if(!result.validFlag){
    		   		cui.alert(result.message);
    		     	return;
    	        }
    		    var dependFilesChangeInfoList = $scope.componentDependFilesConfigVO.dependFilesChangeInfoList;
    			for(var i = 0, len = dependFilesChangeInfoList.length; i < len; i++){
        			delete dependFilesChangeInfoList[i].isFilter;
        			delete dependFilesChangeInfoList[i].check;
                }
	    		dwr.TOPEngine.setAsync(false);
	    		ComponentDependFilesConfigFacade.saveModel($scope.componentDependFilesConfigVO, function(result) {
					if(result){
						$scope.hasEditState = false;
						$scope.tempStorage = jQuery.extend(true, {}, $scope.componentDependFilesConfigVO);
						cui.message('保存成功！', 'success');
					} else {
						cui.error("保存失败！");
					}
				});
				dwr.TOPEngine.setAsync(true);
	    	}
	    });
		
		//键盘回车键快速查询 
		function keyDownQuery(event, self) {
			if(event.keyCode ==13){
				query(self.$input[0].value);
			}
		} 

		//快速查询
		function keyWordQuery(event, self){
			query(self.$input[0].value);
		}
		
		//通过sql过滤查询
		function query(expressionFilter){
			var dependFilesChangeInfoList = scope.componentDependFilesConfigVO.dependFilesChangeInfoList;
			for(var i = 0, len = dependFilesChangeInfoList.length; i < len; i++){
    			if(expressionFilter == "" || dependFilesChangeInfoList[i].defaultFilePath.indexOf(expressionFilter) > -1){
    				dependFilesChangeInfoList[i].isFilter=false;
    			}else{
    				dependFilesChangeInfoList[i].isFilter=true;
    			}
    			dependFilesChangeInfoList[i].check = false;
            }
   			scope.dependFilesConfigCheckAll = false;
			cap.digestValue(scope);
		}

		//导入引入文件
    	function importIncludeFile(event, self){
    		refreshFiles = _.bind(importIncludeFileCallBack, {name: self.options.name});
    		var fileJsp = "${pageScope.cuiWebRoot}/cap/bm/dev/page/preference/IncludeFilePreference.jsp";
    		var params = "?selectrows=single&flag=all"
    		var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
    		window.open (fileJsp+params,'importIncludeFileFileWin','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
    	}
		
		//选择文件后回调函数 selectedFiles为数组对象
		function importIncludeFileCallBack(selectedFiles){
			cui("#"+this.name).setValue(selectedFiles[0].filePath);
		}
		
		var filePathValRule = [{type:'required',rule:{m:'文件路径：不能为空'}},{type:'custom',rule:{against:'validateIncludeFilePath', m:'文件路径：不能重复'}}];
		
		//参数路径不能重复校验
	    function validateIncludeFilePath(filePath){
	    	return isExistValidate(scope.componentDependFilesConfigVO.dependFilesChangeInfoList, 'filePath', filePath);
	    }
		
	    //是否已存在
	    function isExistValidate(objList, key, value){
	    	var ret = true;
	    	//num=1表示当前值
	    	var num = 0;
	    	for(var i in objList){
	    		if(objList[i][key]==value){
	    			num++;
	    		}
	    		if(num > 1){
	    			ret=false;
	        		break;
	        	}
	    	}
	    	return ret;
	    }
	    
	    //校验函数
		function validateData(){
	    	var validate = new cap.Validate();
	    	var result = validate.validateAllElement(scope.componentDependFilesConfigVO.dependFilesChangeInfoList, {filePath: filePathValRule});
			return result;
		}
	</script>
</body>
</html>