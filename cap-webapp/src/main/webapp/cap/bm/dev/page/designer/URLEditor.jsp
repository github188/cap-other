<%
/**********************************************************************
* URL生成器
* 2015-7-10 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='urlEditor'>
<head>
    <meta charset="UTF-8">
    <title>URL生成器</title>
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
	<top:script src="/cap/bm/dev/page/designer/js/pageaction.js"></top:script>
	
    <script type="text/javascript">
    
    var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
    var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
    var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
    var from=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("from"))%>;
    var constantName=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("constantName"))%>;
    var openType=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("openType"))%>;
    var link=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("link"))%>;
    var pageSession = new cap.PageStorage(modelId);
	var dataStore = pageSession.get("dataStore");
	var pageConstantList=dataStore[3].pageConstantList;
    
    var scope=null;
    
    angular.module('urlEditor', ["cui"]).controller('urlEditorCtrl', function ($scope) {
    	$scope.pageURL="";
    	$scope.pageModelId="";
    	$scope.pageAttributeVOList=[];
    	$scope.pageConstantName="";
    	$scope.pageConstantDes="";
    	
    	if(pageConstantList!=null){
    		for(var i=0;i<pageConstantList.length;i++){
    			if(constantName==pageConstantList[i].constantName){
    				if(pageConstantList[i].constantValue!=null && pageConstantList[i].constantValue!=""){
    					$scope.pageURL=pageConstantList[i].constantValue;
        				$scope.pageURL=pageConstantList[i].constantOption.url;
        				$scope.pageModelId=pageConstantList[i].constantOption.pageModelId;
        		    	$scope.pageAttributeVOList=cui.utils.parseJSON(pageConstantList[i].constantOption.pageAttributeVOList);
    				}
    			}
    		}
    	}
    	
    	$scope.ready=function(){
    		comtop.UI.scan();
        	scope=$scope;
        	$scope.iniDate();
            $scope.initCopyPageListMain(openType,link);
	    }
    	
    	//选中表达式行
    	$scope.catalogVoTdClick=function(catalogVO){
    		$scope.selectCatalogVO=catalogVO;
    		$scope.checkBoxCheck($scope.rights,"rightsCheckAll");
	    }
    	
    	$scope.iniDate=function(){
        }

        //处理 openCopyPageListMain 页面回调过来的数据
        $scope.initCopyPageListMain = function(openType,link) {
            if (openType && openType == "openCopyPageListMain") {
                if (link) {
                    var selectData = window.opener.scope.copyPage.selectData;
                    $scope.selectPageData(selectData);
                    if (!isHaveParam()) {
                        $scope.importURLCallBack();
                    }
                } else {
                    $scope.openPageSelect();
                }
            }
        }

         //注入 selectPageData
        $scope.selectPageData =function(selectPageDate){
            scope.pageURL=selectPageDate.url;
            scope.pageModelId=selectPageDate.modelId;
            scope.pageConstantName=selectPageDate.modelName;
            scope.pageConstantDes=selectPageDate.cname;
            var ar=[];
            for(var i=0;i<selectPageDate.pageAttributeVOList.length;i++){
                var pageAttributeVO=selectPageDate.pageAttributeVOList[i];
                ar.push({attributeName:pageAttributeVO.attributeName,attributeDescription:pageAttributeVO.attributeDescription,attributeValue:''});
            }
            scope.pageAttributeVOList=ar;
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
    	
    	//打开页面选择界面
    	$scope.openPageSelect=function() {

    		var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
            if(!from){
               var url ='CopyPageListMain.jsp?systemModuleId='+packageId+'&openType='+openType+'&modelId='+modelId+'&flag='+flag+'&constantName='+constantName;
               window.location.href =url;
           }else{
                window.open('CopyPageListMain.jsp?systemModuleId='+packageId+"&openType="+openType,"copyPageWin",'height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no'); 
           }
    	}
    	
    	$scope.importURLCallBack=function(){
    		if($scope.pageModelId==""){
    			cui.alert('请选选择页面！', function(){});
    		}else{
    			var result={flag:flag,url:"",pageConstantName:"",pageConstantDes:"",constantOption:{url:'',pageAttributeVOList:[]}};
        		result.url="'"+$scope.pageURL+"'"+cap.buildPageAttrString($scope.pageAttributeVOList);
        		result.pageConstantName = $scope.pageConstantName;
        		result.pageConstantDes = $scope.pageConstantDes;
        		result.constantOption.url=$scope.pageURL;
        		result.constantOption.pageAttributeVOList=cui.utils.stringifyJSON($scope.pageAttributeVOList);
        		result.constantOption.pageModelId=$scope.pageModelId;
    			window.opener.importURLCallBack(result);
    			window.close();
    		}
    	}
    });
    
    //校验是否存在参数
    function isHaveParam() {
        if (scope.pageAttributeVOList && scope.pageAttributeVOList.length > 0) {
            return true;
        }
        return false;
    }

  	//页面选择，回调
    function selectPageData(selectPageDate){
    	scope.pageURL=selectPageDate.url;
    	scope.pageModelId=selectPageDate.modelId;
    	scope.pageConstantName=selectPageDate.modelName;
    	scope.pageConstantDes=selectPageDate.cname;
    	var ar=[];
    	for(var i=0;i<selectPageDate.pageAttributeVOList.length;i++){
    		var pageAttributeVO=selectPageDate.pageAttributeVOList[i];
    		ar.push({attributeName:pageAttributeVO.attributeName,attributeDescription:pageAttributeVO.attributeDescription,attributeValue:''});
    	}
    	scope.pageAttributeVOList=ar;
    	scope.$digest();
    }
  	
  	//打开数据模型选择界面
    function openDataStoreSelect(flag,isWrap) {
    	var url = 'DataStoreSelect.jsp?packageId=' + packageId+"&modelId="+modelId+"&flag="+flag+"&isWrap="+isWrap;
    	var top=(window.screen.availHeight-600)/2;
    	var left=(window.screen.availWidth-800)/2;
    	window.open (url,'openDataStoreSelectURL','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    }

    //数据模型选择回调
    function  importDataStoreVariableCallBack(variableSelect,flag,isWrap){
        if(!variableSelect || variableSelect === '') {
                scope.selectPageActionVO.methodOption[flag] = null;
        } else if(typeof(variableSelect) == "object"){
    		var value=variableSelect.ename;
    		if(isWrap=="true"){
    			value="@{"+value+"}";
    		}
    		eval("scope."+flag+"='"+value+"';")
    	}else{
    		var value=variableSelect;
    		if(isWrap=="true"){
    			value="@{"+value+"}";
    		}
    		eval("scope."+flag+"='"+value+"';");
    	}
    	scope.$digest();
    }
    
    
    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="urlEditorCtrl" data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" >
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="URL生成器" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		        	<span id="code" uitype="Button" label="确定" ng-click="importURLCallBack()"></span>
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
									<font color="red">*</font>页面：
						        </td>
						        <td class="cap-td" style="text-align: left;">
						        	<span cui_clickinput  id="pageURL" ng-model="pageURL" width="100%" ng-click="openPageSelect()"></span>
						        </td>
                            </tr>
                            <tr>
                               <td  class="cap-td" style="text-align: left;width:100px" colspan="2">
									<font color="red">*</font>页面参数：
						        </td>
                            </tr>
                            <tr>
                               <td  class="cap-td" style="text-align: left;" colspan="2">
									<span page_attribute  ng-model="pageAttributeVOList"></span>
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