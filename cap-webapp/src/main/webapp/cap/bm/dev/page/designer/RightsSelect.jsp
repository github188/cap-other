<%
/**********************************************************************
* 模块权限选择
* 2015-6-30 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='rightsSelect'>
<head>
    <meta charset="UTF-8">
    <title>模块权限选择</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
    	.module-choose-container {
            display: inline-block; 
            width: 30%;
            height:670px;
            overflow: auto;
        }
        .rights-choose-container {
            display: inline-block;
            width: 60%;
            vertical-align: top;
            height:670px;
            overflow-y: auto;
        }
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.all.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/top/sys/dwr/engine.js"></top:script>
	<top:script src="/top/sys/dwr/util.js"></top:script>
	<top:script src="/top/sys/dwr/interface/FuncAction.js"></top:script>
    <top:script src="/top/cfg/dwr/interface/ConfigClassifyAction.js"></top:script>
    <top:script src="/cap/dwr/interface/SystemModelAction.js"></top:script>
    <script type="text/javascript">
    
    // 获取url参数packageId
    var packageId = cui.utils.param.packageId;
    // 获取url参数funcId
    var funcId = cui.utils.param.funcId;
    
    var scope=null;
    
    angular.module('rightsSelect', ['cui']).controller('rightsSelectCtrl', function ($scope) {
        //页面模块全部选项
        var catalogAll = {funcId:0,funcName:"全部"};

    	var catalog = $scope.catalog = [];
    	var rights = $scope.rights = [];
        $scope.rootFuncId = "";
        $scope.rootTitle = "";
        $scope.moduleId = packageId;

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
        	
        	if($scope.moduleId && $scope.moduleId !== "") {    // 页面传递过来的是moduleId，通过moduleid查询
                dwr.TOPEngine.setAsync(false);
                FuncAction.readFuncByModuleId($scope.moduleId,function(result){
                    $scope.rootFuncId=result.funcId;
                    $scope.rootTitle=result.funcName;
                });
                dwr.TOPEngine.setAsync(true);
            }else if(funcId && funcId !== "") { // 页面传递过来的是funcId，通过funcId查询
                dwr.TOPEngine.setAsync(false);
                FuncAction.readFunc(funcId,function(funcObj){
                    $scope.moduleId = funcObj.parentFuncId;
                    $scope.rootFuncId=funcObj.funcId;
                    $scope.rootTitle=funcObj.funcName;
                });
                dwr.TOPEngine.setAsync(true);
            }else{
                throw new Error("页面参数缺失，请至少传入packageId或funcId。");
            }

            
            catalog.push(catalogAll);
        	catalog.push({funcId:$scope.rootFuncId,funcName:$scope.rootTitle});

            queryAllFuncId();

    		$scope.selectCatalogVO=$scope.catalog.length>0?$scope.catalog[0]:{};
            queryModuleTreeData();
        }

        // 查询对应module下面的资源
        function queryAllFuncId() {
            dwr.TOPEngine.setAsync(false);
            var condition={};
            condition.parentFuncId = $scope.rootFuncId;
            var funList=[];
            FuncAction.queryAllFunc(condition,function(result){
                funList=result;
            });
            
            dwr.TOPEngine.setAsync(true);
            for(var i=0;i<funList.length;i++){
                if(funList[i].funcNodeType!=5){
                    catalog.push({funcId:funList[i].funcId,funcName:funList[i].funcName});
                }else{
                    rights.push({funcId:funList[i].funcId,funcName:funList[i].funcName,funcCode:funList[i].funcCode,description:funList[i].description,parentFuncId:funList[i].parentFuncId});
                }
            }
        }

        // 查询module数据用于tree显示
        function queryModuleTreeData() {
            dwr.TOPEngine.setAsync(false);
            SystemModelAction.getAllModuleTree(function(data){      //将模块全部查询出来
                if(data == null || data == "") {
                    var emptydata=[{title:"没有数据"}];
                    $scope.moduleTreeData = emptydata;
                } else {
                    var treeData = jQuery.parseJSON(data);
                    treeData.expand = true;
                    treeData.activate = true;
                    treeData.expandKey = $scope.moduleId;   // 需要默认展开的节点key
                    $scope.moduleTreeData = treeData;
                }
             });
            dwr.TOPEngine.setAsync(true);
        }
    	
        //模块树点击节点时的处理方法
        $scope.moduleTreeClick = function (node) {
            if(node.getData().data.moduleType === 2) {    //应用模块才处理
                if($scope.moduleId === node.getData("key")) {
                    return;
                }
                var funcId, funcName;
                $scope.moduleId = node.getData("key");
                dwr.TOPEngine.setAsync(false);
                FuncAction.readFuncByModuleId($scope.moduleId,function(result){
                    funcId=result.funcId;
                    funcName=result.funcName;
                });

                dwr.TOPEngine.setAsync(true);
                $scope.chooseCatalogCallBack(funcId, funcName);
            }
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
    		var selectRights=[];
            var fail = [];
    		for(var i=0;i<rights.length;i++){
    			if(rights[i].check){
                    if(!validataRights(rights[i], fail)) {
    				    selectRights.push(rights[i]);
                    }
    			}
    		}
    		if(fail.length > 0){
                fail.unshift('导入失败，原因如下：');
                cui.alert(fail.join("<br/>"), function(){});
            }else if(selectRights.length==0) {
                cui.alert('请选要导入的权限！', function(){});
        	}else{
        		window.opener.importRightsVariableCallBack(selectRights);
        		window.close();
        	}
    	}

        var reg = new RegExp("^(?![0-9_])[a-zA-Z0-9_]+$");
        function validataRights (rights, fail) {
            if(rights) {
                if(rights.funcCode == null || rights.funcCode == undefined || rights.funcCode === '') {
                    fail.push(rights.funcName + ' : 编码不能为空');
                    return true;
                }
                if(!reg.test(rights.funcCode)) {
                    fail.push(rights.funcName + ' : 必须为英文字符、数字或者下划线，且必须以英文字符开头。');
                    return true;
                }
                return false;
            } else {
                return false;
            }
        }

        $scope.chooseCatalogCallBack = function(funcId, title) {
            $scope.rootFuncId = funcId;
            $scope.rootTitle = title;
            rights.length = 0;
            catalog.length = 0;
            catalog.push(catalogAll);
            catalog.push({funcId:$scope.rootFuncId,funcName:$scope.rootTitle});
            queryAllFuncId();
            $scope.selectCatalogVO=$scope.catalog.length>0?$scope.catalog[0]:{};
            cap.digestValue($scope);
        }
    }).directive('resize', function ($window) {     //增加resize directive
        return function (scope, element) {
            var w = angular.element($window);
            scope.getWindowDimensions = function () {
                return {
                    'h': w.height(),
                    'w': w.width()
                };
            };
            scope.$watch(scope.getWindowDimensions, function (newValue, oldValue) {
                scope.windowHeight = newValue.h;
                scope.windowWidth = newValue.w;
                scope.windowHeightOffset = function (offset) {
                    return {
                        'height': (newValue.h - offset) + 'px'
                    };
                };
            }, true);

            w.bind('resize', function () {
                scope.$apply();
            });
        }
    });
    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="rightsSelectCtrl" data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" >
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="模块权限选择" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="code" uitype="Button" label="确定" ng-click="importRightsVariableCallBack()"></span>
		        	<span id="code" uitype="Button" label="关闭" onClick="window.close()"></span>
		        </td>
		    </tr>
		</table>
        <div class="module-choose-container" resize ng-style="windowHeightOffset(100)">
            <table class="cap-table-fullWidth">
                <tr>
                    <td class="cap-td" style="text-align: left;width:30%">
                        <div id="ClassifyTree" cui_tree ng-model="moduleTreeData" on_click="moduleTreeClick" click_folder_mode="3"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="rights-choose-container" resize ng-style="windowHeightOffset(100)">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:20%">
		        	<table class="custom-grid" style="width: 100%">
                        <tbody>
                            <tr ng-repeat="catalogVo in catalog track by $index" style="background-color: {{selectCatalogVO.funcId==catalogVo.funcId ? '#99ccff':'#ffffff'}}">
                                <td style="text-align:left;cursor:pointer" ng-click="catalogVoTdClick(catalogVo)">
                                    {{catalogVo.funcName}}
                                </td>
                            </tr>
                       </tbody>
		            </table>
		        </td>
		        <td class="cap-td" style="text-align: left;width:40%;"> 
		        	<table class="custom-grid" style="width: 98%;">
		        		<thead>
		                    <tr>
		                    	<th style="width:30px">
		                    		<input type="checkbox" name="rightsCheckAll" ng-model="rightsCheckAll" ng-change="allCheckBoxCheck(rights,rightsCheckAll)">
		                        </th>
		                        <th style="width:150px">
	                            	权限编码
		                        </th>
		                        <th>
	                            	权限名称
		                        </th>
		                    </tr>
		                </thead>
                        <tbody>
                            <tr ng-repeat="rightsVo in rights track by $index" ng-show="selectCatalogVO.funcId==0 || selectCatalogVO.funcId==rightsVo.parentFuncId" style="background-color: {{selectCatalogVO.funcId==catalogVo.funcId ? '#99ccff':'#ffffff'}}">
                               	<td style="text-align: center;">
                                    <input type="checkbox" name="{{'rightsVo'+($index + 1)}}" ng-model="rightsVo.check" ng-click="checkBoxCheck(rights,'rightsCheckAll')">
                                </td>
                                <td style="text-align:left;cursor:pointer" ng-click="rightsVo.check=!rightsVo.check;checkBoxCheck(rights,'rightsCheckAll')"">
                                    {{rightsVo.funcCode}}
                                </td>
                                <td style="text-align:left;cursor:pointer" ng-click="rightsVo.check=!rightsVo.check;checkBoxCheck(rights,'rightsCheckAll')"">
                                    {{rightsVo.funcName}}
                                </td>
                            </tr>
                       </tbody>
		            </table>
		        </td>
		    </tr>
		</table>
        </div>
	</div>
</div>
</body>
</html>