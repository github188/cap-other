<%
/**********************************************************************
* 新增权限
* 2015-7-9 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='rightsAdd'>
<head>
    <meta charset="UTF-8">
    <title>新增权限</title>
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
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/top/sys/dwr/engine.js"></top:script>
	<top:script src="/top/sys/dwr/util.js"></top:script>
	<top:script src="/top/sys/dwr/interface/FuncAction.js"></top:script>
    <script type="text/javascript">
    
    var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
    var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
    // 获取url参数funcId
    var funcId = cui.utils.param.funcId;
    var pageSession = new cap.PageStorage(modelId);
    var page = pageSession.get("page");
    
    var scope=null;
    var catalog=[];
    var rightVO={};
    var funcList=[];
    
    angular.module('rightsAdd', ["cui"]).controller('rightsAddCtrl', function ($scope) {
    	$scope.catalog=catalog;
    	$scope.rightVO=rightVO;
    	
    	$scope.ready=function(){
    		comtop.UI.scan();
        	scope=$scope;
        	$scope.iniDate();
	    }
    	
    	//选中表达式行
    	$scope.catalogVoTdClick=function(catalogVO){
    		$scope.selectCatalogVO=catalogVO;
    		$scope.checkBoxCheck($scope.rights,"rightsCheckAll");
	    }
    	
    	$scope.iniDate=function(){
        	dwr.TOPEngine.setAsync(false);
        	var rootFuncId = "";
        	var rootTitle = "";
        	var rootFunc={};
        	if(packageId && packageId !== '') {
        		FuncAction.readFuncByModuleId(packageId,function(result){
	        		rootFunc=result;
	        		rootFuncId=result.funcId;
	        		rootTitle=result.funcName;
	        	});
        	}else if(funcId && funcId !== '') {
	            FuncAction.readFunc(funcId,function(funcObj){
	                rootFunc = funcObj;
	                rootFuncId = funcObj.funcId;
	                rootTitle = funcObj.funcName;
	            });
        	}else {
        		throw new Error("页面参数缺失，请至少传入packageId或funcId。");
        	}
        	

        	catalog.push({id:rootFuncId,text:rootTitle});
        	
        	var condition={};
        	condition.parentFuncId = rootFuncId;
    		FuncAction.queryAllFunc(condition,function(result){
    			funList=result;
    		});
    		
    		dwr.TOPEngine.setAsync(true);
    		for(var i=0;i<funList.length;i++){
				if(funList[i].funcNodeType!=5){
					catalog.push({id:funList[i].funcId,text:funList[i].funcName});
				}
			}
    		funList.push(rootFunc);
    		$scope.rightVO.parentFuncId=page.pageId;
        }
    	
    	$scope.rightsCheckAll=false;
    	
    	//监控全选checkbox，如果选择则联动选中列表所有数据
    	$scope.allCheckBoxCheck=function(ar,isCheck){
    		if(ar!=null){
    			for(var i=0;i<ar.length;i++){
	    			if(isCheck && ($scope.selectCatalogVO.funcId==0 || $scope.selectCatalogVO.funcId==ar[i].parentFuncId)){
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
	    			if(ar[i].check && ($scope.selectCatalogVO.funcId==0 || $scope.selectCatalogVO.funcId==ar[i].parentFuncId)){
	    				checkCount++;
		    		}
	    			
	    			if($scope.selectCatalogVO.funcId==0 || $scope.selectCatalogVO.funcId==ar[i].parentFuncId){
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
    	
    	$scope.importRightsVariableCallBack=function(){
    		var map = cap.validater.validElement();
		    var inValid = map[0];
		    var valid = map[1]; //放置成功信息
		    if (inValid.length > 0) {
	            var str = "";
	            for (var i = 0; i < inValid.length; i++) {
	 				str +=  inValid[i].message + "<br/>";
	 			}
	 			cui.alert(str);
	        } else {
	    		var funVO={};
	    		for(var i=0;i<funList.length;i++){
					if(funList[i].funcId==$scope.rightVO.parentFuncId){
						funVO=funList[i];
						break;
					}
				}
	    		$scope.rightVO.parentFuncName=funVO.funcName;
	    		$scope.rightVO.parentFuncCode=funVO.funcCode;
	    		$scope.rightVO.funcNodeType=5;
	    		$scope.rightVO.permissionType=2;
	    		$scope.rightVO.status=1;
	    		FuncAction.saveFunc($scope.rightVO,function(funcId){
	    			$scope.rightVO.funcId=funcId;
	    			var selectRights=[$scope.rightVO];
	           		window.opener.importRightsVariableCallBack(selectRights);
	           		window.close();
	    		});
	        }
    	}
    	
    	$scope.$watch("rightVO.parentFuncId", function(newValue, oldValue){
    		if(oldValue != '' && newValue !='' && newValue != oldValue){
    			cap.validater.validAllElement();
    		}
    	}, true);
    });
    
    
    //判断名称是否满足规范
	function checkName(data){
		var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_/\(（\)）]+$");
		return (reg.test(data));
	}
	
	//判断名称是否重复
	function isExistRename(data){
		if(data){
			var flag = true;
			dwr.TOPEngine.setAsync(false);
			var conditionVO = {parentFuncId:scope.rightVO.parentFuncId, funcName:data};
			FuncAction.judgeNameRepeat(conditionVO, function(data){
				if(data == 'NameExists'){
					flag = false;
				}else{
					flag = true;
				}
			});	
			dwr.TOPEngine.setAsync(true);
			return flag;
		}
	}
	
	//只能为 英文、数字、下划线
	function checkCode(data) {
		if(data){
			var reg = new RegExp("^(?![0-9_])[a-zA-Z0-9_]+$");
			return (reg.test(data));
		}
		return true;
	}
	
	/**
	* 检查编码全局是否唯一
	**/
	function isExistCode(data){
		var flag = true;
		dwr.TOPEngine.setAsync(false);
		var conditionVO = {funcCode:data};
		conditionVO.parentFuncId = scope.rightVO.parentFuncId; 
		FuncAction.judgeCodeRepeat(conditionVO, function(data){
			if(data == 'CodeExists'){
				flag = false; //存在重复的编码	
			}else{
				flag = true;
			}
		});
		dwr.TOPEngine.setAsync(true);
		return flag;
	}
    
    //验证规则
    var funcNameValRule = [{'type':'required','rule':{'m':'操作名称不能为空'}}, {'type':'custom','rule':{'against':'checkName','m':'操作名称只能为汉字、数字、字母、下划线、正斜杠、中英文括号'}}, {'type':'custom','rule':{'against':'isExistRename','m':'名称已被占用。'}}];
    var funcCodeValRule = [{'type':'required','rule':{'m':'操作编码不能为空'}}, {'type':'custom','rule':{'against':'checkCode','m':'必须为英文字符、数字或者下划线，且必须以英文字符开头。'}}, {'type':'custom','rule':{'against':'isExistCode','m':'操作编码已被占用'}}];
	
    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="rightsAddCtrl" data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" >
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="新增权限" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="code" uitype="Button" label="保存" ng-click="importRightsVariableCallBack()"></span>
		        	<span id="code" uitype="Button" label="关闭" onClick="window.close()"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:30%">
		        	<table class="custom-grid" style="width: 100%">
                        <tbody>
                            <tr>
                                <td  class="cap-td" style="text-align: right;width:100px">
									<font color="red">*</font>操作名称：
						        </td>
						        <td class="cap-td" style="text-align: left;">
						        	<span cui_input  id="modelName" ng-model="rightVO.funcName" width="100%" validate="funcNameValRule"></span>
						        </td>
						        <td class="cap-td" style="text-align: right;width:100px">
						        	<font color="red">*</font>上级页面/菜单：
						        </td>
						        <td class="cap-td" style="text-align: left;">
						        	<span cui_pulldown  id="cname" ng-model="rightVO.parentFuncId" datasource="catalog" width="100%" editable="false" must_exist="true"></span>
						        </td>
                            </tr>
                            <tr>
                               <td  class="cap-td" style="text-align: right;width:100px">
									<font color="red">*</font>操作编码：
						        </td>
						        <td class="cap-td" style="text-align: left;" colspan="3">
						        	<span cui_input  id="modelName" ng-model="rightVO.funcCode" width="100%" validate="funcCodeValRule"></span>
						        </td>
                            </tr>
                            <tr>
                               <td  class="cap-td" style="text-align: right;width:100px">
									描述：
						        </td>
						        <td class="cap-td" style="text-align: left;" colspan="3">
						        	<div>
										<font id="applyRemarkLengthFont">(您还能输入<label id="remarkLength" style="color:red;">500</label>&nbsp; 字符)</font>
									</div>
						        	<span cui_textarea  id="modelName" ng-model="rightVO.description" maxlength="500" autoheight="true" relation="remarkLength" width="100%" ></span>
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