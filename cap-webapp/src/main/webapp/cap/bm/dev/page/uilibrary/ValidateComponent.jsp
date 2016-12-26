<%
/**********************************************************************
* validate组件
* 2015-7-8 章尊志 新建、2016-3-4 诸焕辉 重构
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='validateComponent'>
<head>
<meta charset="UTF-8">
<title>validate组件</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	 
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/EnvironmentVariablePreferenceFacade.js'></top:script>
	<script type="text/javascript">
		//设计器页面的validate选择框的名字
		var propertyName = "<c:out value='${param.propertyName}'/>";
		//设计器页面validate选择框的数据类型
		var valuetype = "<c:out value='${param.valuetype}'/>";
		var callbackMethod = "<c:out value='${param.callbackMethod}'/>";
		//设计器页面 validate选择框选择的数据
		var validateDatas = [];
		if(window.opener.currSelectDataModelVal!=""){
			validateDatas = eval("("+window.opener.currSelectDataModelVal+")");
		}
		
	    //封装不同校验类型对应的rule对象属性
	    var validTypeRuleAttrs = {
	    		required: {'m':'String', 'emptyVal':'Array'}, 
	    		numeric: {'oi':'Boolean', 'notnm':'String', 'notim':'String', 'min':'Number', 'minm':'String', 'max':'Number', 'maxm':'String', 'is':'Number', 'wrongm':'String'}, 
	    		format: {'m':'String', 'pattern':'String', 'negate':'Boolean'}, 
	    		email: {'m':'String'}, 
	    		length: {'min':'Number', 'minm':'String', 'max':'Number', 'maxm':'String', 'is':'Number', 'wrongm':'String'}, 
	    		inclusion: {'m':'String', 'negate':'Boolean', 'caseSensitive':'Boolean', 'allowNull':'Boolean', 'within':'Array', 'partialMatch':'Boolean'}, exclusion: {'m':'String', 'caseSensitive':'Boolean', 'allowNull':'Boolean', 'within':'Array', 'partialMatch':'Boolean'},
	    		confirmation: {'m':'String', 'match':'String'}, custom: {'m':'String', 'against':'String', 'args':'String'}};
		
	    var root = {
			validateDatas: initValidateDatas(validateDatas)
		}
		
	    //初始化数据
	    function initValidateDatas(dataList){
	    	var datas = jQuery.extend(true, [], dataList);
	    	_.forEach(datas, function(data, key) {
	    		var ruleAttrs = validTypeRuleAttrs[data.type];
    			_.forEach(data.rule, function(val, k) {
    				if(ruleAttrs[k] === 'Boolean' || ruleAttrs[k] === 'Number' || ruleAttrs[k] === 'Array'){
    					data.rule[k] = JSON.stringify(data.rule[k]);
    				} 
    			});
	    	});
	    	return datas;
	    }
	    
	    //拿到angularJS的scope
	    var scope=null;
	    angular.module('validateComponent', [ "cui"]).controller('validateComponentCtrl', function ($scope) {
	    	$scope.root=root;
	       	$scope.validateCheckAll=false;
	      	$scope.selectValidateVo=root.validateDatas.length>0?root.validateDatas[0]:{};
	       	
	    	$scope.ready=function(){
		    	comtop.UI.scan();
		    	scope=$scope;
		    }
	    	
	    	$scope.validateTdClick=function(validateVo){
	       		$scope.selectValidateVo=validateVo;
	        }
	    	
	    	//新增规则
	    	$scope.addValidateType=function(){
	    		var newValidateVo ={type:"required"};
	    		$scope.root.validateDatas.push(newValidateVo);
	    		$scope.selectValidateVo=newValidateVo;
	    		$scope.checkBoxCheck($scope.root.validateDatas,"validateCheckAll");
	    	}
	    	
	    	//删除规则
	    	$scope.deleteValidateType=function(){
	    		var newArr =[];
	    		for(var i=0;i<$scope.root.validateDatas.length;i++){
	    	        if(!$scope.root.validateDatas[i].check){
	    	            newArr.push($scope.root.validateDatas[i])
	    	        }
	    		}
	            $scope.root.validateDatas = newArr;
	            //如果当前选中的行被删除则默认选择第一行
	            var isSelectIsDelete=true;
	            for(var i=0;i<$scope.root.validateDatas.length;i++){
	    	        if($scope.root.validateDatas[i]==$scope.selectValidateVo){
	    	            isSelectIsDelete=false;
	    	            break;
	    	        }
	            }
	            if(isSelectIsDelete){
	    			$scope.selectValidateVo=$scope.root.validateDatas[0];
	            }
	            $scope.checkBoxCheck($scope.root.validateDatas,"validateCheckAll");
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
	    	
	       	$scope.getValidataComponent = function() {
	       		return $scope.selectValidateVo.type ? 'validataComponent/validate-' + $scope.selectValidateVo.type + '.html' : "";
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
	    });
	    
	    //判断是否是字符串数组
	    function isStringArray(val){
	    	var arr = '';
	    	var reg = /^\[[\"|\,|'|\w]*\]$/;
	    	if(val == ''){
	    		return true;
	    	} else if(reg.test(val)){
    			try{
		    		var arr = eval(val);
				}catch(err){ 
					arr = '';
				}
	    	}
	    	return _.isArray(arr);
	    }
	    
	    //验证规则，在include的html页面定义各自的验证规则
	    var ruleData = {
	    		format: {m: [{'type':'required', 'rule':{'m': 'format->m属性不能为空'}}]},
	    		email: {m: [{'type':'required', 'rule':{'m': 'email->m属性不能为空'}}]},
	    		inclusion: {m: [{'type':'required', 'rule':{'m': 'inclusion->m属性不能为空'}}], within: [{type:'custom',rule:{against:'isStringArray', m:'inclusion->within必须为数组'}}]}, 
	    		exclusion: {m: [{'type':'required', 'rule':{'m': 'exclusion->m属性不能为空'}}], within: [{type:'custom',rule:{against:'isStringArray', m:'exclusion->within必须为数组'}}]},
	    		required: {
	    		        m: [{'type':'required', 'rule':{'m': 'required->m属性不能为空'}}], 
	    		        emptyVal: [{type:'custom',rule:{against:'isStringArray', m:'required->emptyVal必须为数组'}}]
	    		    },
	    		custom: {
	    		        m: [{'type':'required', 'rule':{'m': 'custom->m属性不能为空'}}],
	    		        against: [{'type':'required', 'rule':{'m': 'custom->against属性不能为空'}}]
	    		    },
	    		length: {

	    		        min: [
	    		                {'type':'numeric', 'rule':{'notnm': 'length->min必须为数字'}},
	    		                {'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'length->minm设值后min不能为空','args':'min'}}
	    		            ], 
	    		        minm: [{'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'length->min设值后minm不能为空','args':'minm'}}],
	    		        max: [
	    		                {'type':'numeric', 'rule':{'notnm': 'length->max必须为数字'}},
	    		                {'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'length->maxm设值后max不能为空','args':'max'}}
	    		            ], 
	    		        maxm: [{'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'length->max设值后maxm不能为空','args':'maxm'}}],
	    		        is: [
	    		                {'type':'numeric', 'rule':{'notnm': 'length->is必须为数字'}},
	    		                {'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'length->wrongm设值后is不能为空','args':'is'}}
	    		            ],
	    		        wrongm: [{'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'length->is设值后wrongm不能为空','args':'wrongm'}}]
	    		    },
	    		numeric: {
	    		        min: [
	    		                {'type':'numeric', 'rule':{'notnm': 'numeric->min必须为数字'}},
	    		                {'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'numeric->minm设值后min不能为空','args':'min'}}
	    		            ], 
	    		        minm: [{'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'numeric->min设值后minm不能为空','args':'minm'}}],
	    		        max: [
	    		                {'type':'numeric', 'rule':{'notnm': 'numeric->max必须为数字'}},
	    		                {'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'numeric->maxm设值后max不能为空','args':'max'}}
	    		            ], 
	    		        maxm: [{'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'numeric->max设值后maxm不能为空','args':'maxm'}}],
	    		        is: [
	    		                {'type':'numeric', 'rule':{'notnm': 'numeric->is必须为数字'}},
	    		                {'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'numeric->wrongm设值后is不能为空','args':'is'}}
	    		            ],
	    		        wrongm: [{'type':'custom', 'rule':{'against':'checkNumericMessage','m': 'numeric->is设值后wrongm不能为空','args':'wrongm'}}]
	    		    },
	    		confirmation: {
	    		        m: [{'type':'required', 'rule':{'m': 'confirmation->m属性不能为空'}}],
	    		        match: [{'type':'required', 'rule':{'m': 'confirmation->match属性不能为空'}}]
	    		    }

	    };
	    
	    function checkNumericMessage(val, args) {
	        switch (args) {
	            case 'min' :
	                var min = scope.selectValidateVo.rule.min;
	                var minm = scope.selectValidateVo.rule.minm;
	                return min ? true : (minm ? false : true);
	                break;
	            case 'minm' :
	                var min = scope.selectValidateVo.rule.min;
	                var minm = scope.selectValidateVo.rule.minm;
	                return minm ? true : (min ? false : true);
	                break;
	            case 'max' :
	                var max = scope.selectValidateVo.rule.max;
	                var maxm = scope.selectValidateVo.rule.maxm;
	                return max ? true : (maxm ? false : true);
	                break;
	            case 'maxm' :
	                var max = scope.selectValidateVo.rule.max;
	                var maxm = scope.selectValidateVo.rule.maxm;
	                return maxm ? true : (max ? false : true);
	                break;
	            case 'is' :
	                var is = scope.selectValidateVo.rule.is;
	                var wrongm = scope.selectValidateVo.rule.wrongm;
	                return is ? true : (wrongm ? false : true);
	                break;
	            case 'wrongm' :
	                var is = scope.selectValidateVo.rule.is;
	                var wrongm = scope.selectValidateVo.rule.wrongm;
	                return wrongm ? true : (is ? false : true);
	                break;
	            default :
	                return true;
	        }
	    }
	    
	    //保存
		function saveData(){
	    	//数据校验
			var valid = new cap.Validate();
	    	var resultMessage = "";
	    	var resultValidFlag = false;
	    	for(var j=0, len=root.validateDatas.length; j<len; j++){
	    		console.log(root.validateDatas[j]);
	    		var result = valid.validateAllElement(root.validateDatas[j].rule, ruleData[root.validateDatas[j].type]);
	    	    if(result != "" && !result.validFlag){
	    		  	resultValidFlag = true;
	    		    resultMessage +=  result.message + "<br/>";
	    	    }
	    	}
	    	if(resultValidFlag){
	  		   cui.alert(resultMessage);
	  		   return;
	  	    }
	    	//保存数据
			try{
				if(root.validateDatas.length == 0){
					 window.opener[callbackMethod](propertyName, "");
				}else{
					var cleanValidateData = cleanValidateSaveData();
					var validateSaveData = cui.utils.stringifyJSON(cleanValidateData);
			        window.opener[callbackMethod](propertyName, validateSaveData);
			    }
			    window.close();
			}catch(err){ 
				console.log(err);
			}
	    }
	    
	    //清理过多的属性设置,由于会自动添加多余的属性
		function cleanValidateSaveData(){
	    	var cleanValidate = [];
		    for(i=0, len=root.validateDatas.length; i<len; i++){
		    	var rule = filterValidateRuleData(root.validateDatas[i].rule, root.validateDatas[i].type);
		    	cleanValidate.push({type: root.validateDatas[i].type, rule: rule});
		    }
		    return cleanValidate;
	    }
	    
	    //过滤数据
	    function filterValidateRuleData(originalData, type){
	    	var retData = {};
	    	_.forEach(validTypeRuleAttrs[type], function(value, key) {
	    		if(originalData[key] != null && originalData[key] !=''){
		    		retData[key] = convertDataType(originalData[key], value);
	    		}
	    	});
	    	return retData;
	    }
		
	    //转换数据类型
	    function convertDataType(val, type){
	    	return (type === 'Boolean' || type === 'Number' || type === 'Array') ? eval(val) : val;
	    }
	    
		//取消，关闭窗口
		function cancel(){
			window.close();
		}
    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="validateComponentCtrl" data-ng-init="ready()">
	<div class="cap-page">
		<div class="cap-area" style="width:100%;">
			<table class="cap-table-fullWidth" width="100%">
			    <tr>
			        <td class="cap-td" style="text-align: right;padding-right:10px;padding-top:10px;padding-bottom:0px;">
					<span uitype="button" id="codeformatterBtn" label="确定 " on_click="saveData" ></span>
		            <span uitype="button" on_click=cancel label="关闭" ></span>
			        </td>
			    </tr>
			</table>
			<table class="cap-table-fullWidth">
				<tr>
			        <td class="cap-td" style="text-align: left;width:250px">
			        	<table class="cap-table-fullWidth">
						    <tr>
						        <td class="cap-form-td" style="text-align: left;">
									<span class="cap-group">校验规则列表</span>
						        </td>
						        <td class="cap-form-td" style="text-align: right;">
						        	<span cui_button id="addValidateType"  label="新增" ng-click="addValidateType()"></span>
						        	<span cui_button id="deleteValidateType"  label="删除" ng-click="deleteValidateType()"></span>
						        </td>
						    </tr>
						    <tr>
						    	<td class="cap-form-td" colspan="2">
						            <table class="custom-grid" style="width: 100%">
						                <thead>
						                    <tr>
						                    	<th style="width:30px">
						                    		<input type="checkbox" name="validateCheckAll" ng-model="validateCheckAll" ng-change="allCheckBoxCheck(root.validateDatas,validateCheckAll)">
						                        </th>
						                        <th>
					                            	type
						                        </th>
						                    </tr>
						                </thead>
				                        <tbody>
				                            <tr ng-repeat="validateVo in root.validateDatas track by $index" style="cursor:pointer;background-color: {{selectValidateVo==validateVo ? '#99ccff':'#ffffff'}}">
				                            	<td style="text-align: center;">
				                                    <input type="checkbox" name="{{'validateVo'+($index + 1)}}" ng-model="validateVo.check" ng-change="checkBoxCheck(root.validateDatas,'validateCheckAll')">
				                                </td>
				                                <td style="text-align:left;cursor:pointer" ng-click="validateTdClick(validateVo)">
				                                    {{validateVo.type}}
				                                </td>
				                            </tr>
				                       </tbody>
						            </table>
						    	</td>
						    </tr>
						</table>
			        </td>
			        <td style="text-align: left;border-right:1px solid #ddd;padding-left:5px">
			        </td>
			        <td class="cap-td" style="text-align: left">
			        	<table ng-show="selectValidateVo.type" class="cap-table-fullWidth">
						    <tr>
						        <td class="cap-form-td" style="text-align: left;" colspan="2">
									<span class="cap-group">校验规则编辑</span>
						        </td>
						    </tr>
						    <tr>
						        <td class="cap-td" style="text-align: right;width:120px">
									<font color="red">*</font>type：
						        </td>
						        <td class="cap-td" style="text-align: left;">
						           <span cui_pulldown id="{{'type'+($index + 1)}}" ng-model="selectValidateVo.type" value_field="id" label_field="text" width="100%">
										<a value="required">required</a>
										<a value="numeric">numeric</a>
										<a value="format">format</a>
										<a value="email">email</a>
										<a value="length">length</a>
										<a value="inclusion">inclusion</a>
										<a value="exclusion">exclusion</a>
										<a value="confirmation">confirmation</a>
										<a value="custom">custom</a>
								   </span>
						        </td>
						    </tr>

						    <tbody ng-include="getValidataComponent()">
						    </tbody>
						    <tr>
						        <td class="cap-td" style="text-align: left;" colspan="2">
						        </td>
						    </tr>
						</table>
			        </td>
			    </tr>
			</table>
		</div>
	</div>
</body>
</html>