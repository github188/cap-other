<%
/**********************************************************************
* 数据集选择
* 2015-7-1 郑重 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html ng-app='dataStoreSelect'>
<head>
    <meta charset="UTF-8">
    <title>数据集选择</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <style type="text/css">
    	.custom-div {
    		height: 548px;
    		overflow: auto;
    	}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/top/sys/dwr/engine.js"></top:script>
	<top:script src="/top/sys/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/EnvironmentVariablePreferenceFacade.js'></top:script>
    <script type="text/javascript">
    
  	//获得传递参数
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
   	var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
   	var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
   	var isWrap=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("isWrap"))%>;
   	var selectType=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectType"))%>;
	var pageSession = new cap.PageStorage(modelId);
	var dataStore = pageSession.get("dataStore");
	var pageConstantDataStore=dataStore[3];
	var root={
		dataStore:dataStore
    }

	var scope=null;
    
    angular.module('dataStoreSelect', ['cui']).controller('dataStoreSelectCtrl', function ($scope) {
    	$scope.root=root;
    	$scope.environmentVariableVOList=[];
    	$scope.variableSelect="";
    	$scope.dataSotreSelectType=selectType;
    	
    	$scope.ready=function(){
    		comtop.UI.scan();
        	scope=$scope;
        	//页面参数
        	var page = pageSession.get("page");
        	$scope.pageAttributeRoot={pageAttributeVOList:page.pageAttributeVOList};
        	$scope.rightsVariableVO=$scope.root.dataStore[2];
        	$scope.pageConstantDataStore=pageConstantDataStore;
        	if(selectType=="url"){//选择url
        		$scope.dataStoreTdClick(root.dataStore[3]);	
        		cui("#addPageConstantVO").show();
    			cui("#openPageConstantVOSelect").show();
    			cui("#deletePageConstantVO").show();    
    			cui("#importDataStore").hide();
        	}else if(selectType=="dataStore"){//只选择数据集
        		if(root.dataStore.length>4){
        			$scope.dataStoreTdClick(root.dataStore[4]);
        		}
        	    cui("#addPageConstantVO").hide();
    			cui("#openPageConstantVOSelect").hide();
    			cui("#deletePageConstantVO").hide();    
    			cui("#importDataStoreVariable").hide();    
        	}else if(selectType=="attribute"){//选择所有属性
        		$scope.dataStoreTdClick(root.dataStore[0]);
         	    cui("#addPageConstantVO").hide();
     			cui("#openPageConstantVOSelect").hide();
     			cui("#deletePageConstantVO").hide();   
     			cui("#importDataStore").hide();
        	}else if(selectType=="dataStoreAttribute"){//选择数据集中的属性
        	    if(root.dataStore.length>4){
        			$scope.dataStoreTdClick(root.dataStore[4]);
        	    }
        	    cui("#addPageConstantVO").hide();
    			cui("#openPageConstantVOSelect").hide();
    			cui("#deletePageConstantVO").hide();    
    			cui("#importDataStore").hide(); 
        	}else{//所有属性和数据集
        	    $scope.dataStoreTdClick(root.dataStore[0]);
        	    cui("#addPageConstantVO").hide();
    			cui("#openPageConstantVOSelect").hide();
    			cui("#deletePageConstantVO").hide();    
        	}
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
    	
    	//选中表达式行
    	$scope.dataStoreTdClick=function(dataStoreVo){
    		if(dataStoreVo.modelType=='environmentVariable'){
    			$scope.loadEnvironmentVariableVOList();
    		}else if(dataStoreVo.modelType=='list'||dataStoreVo.modelType=='object'){
    			$scope.loadSubEntityVOList(dataStoreVo);
    		}else{
    		   $scope.selectDataStoreVO=dataStoreVo;
    		}
	    }
    	
    	$scope.insertPageConstantVO=function(){
    		$scope.pageConstantDataStore.pageConstantList.push({constantName:'',constantType:'url',constantValue:'',constantDescription:'',constantOption:{}});
    	}
    	
    	$scope.loadSubEntityVOList=function(dataStoreVo){
    		$scope.selectDataStoreVO=dataStoreVo;
    		var relEntityVO = dataStoreVo.entityVO;
    		var relationAttrs = relEntityVO.attributes;
    		//只要存在关联关系，都获取关联对象；
    		//1对1沿用现有逻辑
    		//1对多时 获取时根据泛型中对象ID进行判断，设置别名
    	    //检测是否有一对一的关系存在，存在则去获取一对一的对象
    		/* for(var i=0;i<relEntityVO.lstRelation.length;i++){
    			var objRelation = relEntityVO.lstRelation[i];
    			if(objRelation.multiple=="One-One"){
    				isRelation = true;
    			}
    		} */
	    		dwr.TOPEngine.setAsync(false);
				PageFacade.dealRelationEntity(relEntityVO,function(result){
					if(result!=null){
						//根据对象中的关联集合中的关系ID和属性集合中的关系ID，确定关系属性的名称
						console.log(relEntityVO);				
						for(var j=0;j<result.length;j++){
							for(var k=0;k<relationAttrs.length;k++){
								//1对1，多对1时
								if(relationAttrs[k].relationId!="" && relationAttrs[k].attributeType.source=="entity" && result[j].modelId==relationAttrs[k].attributeType.value){
									result[j].engName = relationAttrs[k].engName;
									console.log(result[j].engName);
								}
								//1对多，多对多时
								if(relationAttrs[k].relationId!="" && relationAttrs[k].attributeType.source=="collection"){
									result[j].engName = relationAttrs[k].engName;
									var relationEntitys =  relationAttrs[k].attributeType.generic;
									for(var h=0; h<relationEntitys.length; h++ ){
										var relationEntity = relationEntitys[h].value;
										if(relationEntity== result[j].modelId){
											result[j].engName = relationAttrs[k].engName;
											break;
										}
									}
									console.log(result[j].engName);
								}
							}
						}
					 $scope.selectDataStoreVO.subEntity=result;
					}
				});
				dwr.TOPEngine.setAsync(true);
    	}
    	
    	$scope.loadEnvironmentVariableVOList=function(){
    		var page = pageSession.get("page");
			var includeFileList=page.includeFileList;
			var filePaths=[];
			for(var i=0;i<includeFileList.length;i++){
				filePaths.push(includeFileList[i].filePath);
			}
    		EnvironmentVariablePreferenceFacade.queryListByFileName(filePaths,function(data){
    			if(data!=null){
    				$scope.environmentVariableVOList=data;
    				$scope.$digest();
    			}
    		});
    	}
    	
    	$scope.importDataStoreVariableCallBack=function(){
    		if(selectType=='url'){
	    		var result = validateAll();
	    		if(result.flag){
	    			cui.alert(result.message);
	    			return;
	    		}
    		}
    		if($scope.variableSelect==""){
        		cui.alert('请先选择属性！', function(){});
        	}else{
        		if($scope.selectDataStoreVO.modelType=='pageConstant'){
        			$scope.variableSelect = $scope.variableSelect.constantName;
        		}
        		window.opener.importDataStoreVariableCallBack($scope.variableSelect,flag,isWrap,$scope.selectDataStoreVO);
        		window.close();
        	}
    	}
    	
    	$scope.importDataStoreCallBack=function(){
    		if(!$scope.selectDataStoreVO){
    			cui.alert('请先在数据模型页面添加数据集！', function(){});
    		}
    		if(!($scope.selectDataStoreVO.modelType=='list' || $scope.selectDataStoreVO.modelType=='object')){
        		cui.alert('请先选择数据集！', function(){});
        	}else{
        		window.opener.importDataStoreVariableCallBack($scope.selectDataStoreVO,flag,isWrap);
        		window.close();
        	}
    	}
    	
    	$scope.importEntityCallBack=function(){
    		if(!($scope.selectDataStoreVO.modelType=='list' || $scope.selectDataStoreVO.modelType=='object')){
        		cui.alert('请先选择数据集！', function(){});
        	}else{
        		if($scope.selectDataStoreVO.entityVO!=null){
        			$scope.selectDataStoreVO.entityVO.ename=$scope.selectDataStoreVO.entityVO.engName;
        			window.opener.importDataStoreVariableCallBack($scope.selectDataStoreVO.entityVO,flag,isWrap);
        		}
        		window.close();
        	}
    	}

        $scope.clear=function(){
            window.opener.importDataStoreVariableCallBack(null,flag,isWrap);
            window.close();
        }
    	
    	$scope.constantTypeChangeEvent=function(columnsNo){
        	currOperaConstantColId = 'constantValue'+columnsNo;
        	var constantType = cui("#constantType"+columnsNo).getValue();
        	cap.validater.validOneElement(currOperaConstantColId);
        }
    	
    	//删除url操作
    	$scope.deletePageConstantVO = function (){
    		if($scope.variableSelect==""){
        		cui.alert('请先选择要删除的url！', function(){});
        	}else{
        		var newArr=[];
        		
                for(var i=0;i<$scope.pageConstantDataStore.pageConstantList.length;i++){
                	var variableSelectName = $scope.pageConstantDataStore.pageConstantList[i];
                	if(variableSelectName==$scope.variableSelect){
                		newArr.push(i)
                	}
                }
                //根据坐标删除数据
                for(var j=newArr.length-1;j>=0;j--){
                	$scope.pageConstantDataStore.pageConstantList.splice(newArr[j],1);
                }
                $scope.variableSelect="";
        	}
    	}
    	
    	//打开导入常量界面
    	$scope.openPageConstantVOSelect = function(){
    		var url = 'PageConstantSelect.jsp?packageId=' + packageId +'&selectType=url' + '&modelId=' + modelId;
    		var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
    		window.open (url,'importPageConstant','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
    	}
    	
    });
    
  //打开URL编辑器
	function openURLEditor(flg,constantName) {
		var flg="pageConstantList["+flg+"]";
		var url = 'URLEditor.jsp?packageId=' + packageId+"&modelId="+modelId+"&flag="+flg+"&constantName="+constantName+"&from="+flag;
		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
		window.open (url,'URLEditor','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
	}
  
	//URL编辑器值
	function  importURLCallBack(result){
		var flag=result.flag;
		var url=result.url;
		var constantOption=result.constantOption;
		var pageConstantName = result.pageConstantName;
		var pageConstantDes = result.pageConstantDes;
		//把常量名称的首字母转换为小写
		pageConstantName = pageConstantName.substring(0,1).toLowerCase() + pageConstantName.substring(1);
		var localPageConstantName = eval("scope.pageConstantDataStore."+flag+".constantName");
		var localPageConstantDes = eval("scope.pageConstantDataStore."+flag+".constantDescription");
		//如果常量名称，常量描述为空就自动添加
		if(localPageConstantName==""){
			eval("scope.pageConstantDataStore."+flag+".constantName=pageConstantName;");
		}
		if(localPageConstantDes==""){
			eval("scope.pageConstantDataStore."+flag+".constantDescription=pageConstantDes;");
		}
		eval("scope.pageConstantDataStore."+flag+".constantValue=url;");
		eval("scope.pageConstantDataStore."+flag+".constantOption=constantOption;");
		scope.$digest();
	}
	
	//导入常量集
	function importPageConstantCallBack(selectConstants){
		//这里是如果有相同的常量名称了，就不导入了
		for(var i=0;i<selectConstants.length;i++){
			var isAdd=true;
			selectConstants[i].check=false;
			for(var j=0;j<scope.pageConstantDataStore.pageConstantList.length;j++){
				if(selectConstants[i].constantName==scope.pageConstantDataStore.pageConstantList[j].constantName){
					isAdd=false;
					break;
				}
			}
			if(isAdd){
				scope.pageConstantDataStore.pageConstantList.push(selectConstants[i]);
			}
		}
		
		scope.$digest();
	}
  
 	//常量名称不能重复校验
    function validatePageConstantName(constantName){
    	return isExistValidate(scope.pageConstantDataStore.pageConstantList, 'constantName', constantName);
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
    
    var pageConstantNameValRule = [{'type':'required', 'rule':{'m': '页面常量->常量名称：常量名称不能为空'}},{type:'format', rule:{pattern:'\^[a-z_$][a-zA-Z0-9_$]*\$', m:'页面常量->常量名称：只能输入字母、数字、美元符号‘$’或下划线‘_’，如首字符为字母，必须小写，遵循java变量命名规则'}},{'type':'custom','rule':{'against':'validatePageConstantName', 'm':'页面常量->常量名称：不能重复'}}];
    var pageConstantValueValRule = [{'type':'required', 'rule':{'m': '页面常量->常量值：不能为空'}}];

    //统一校验函数
	function validateAll(){
    	var validate = new cap.Validate();
    	var result ={flag:false,message:""};
    	var validateResult = '';
    	for(var i in scope.pageConstantDataStore.pageConstantList){
    		var pageConstantVO = scope.pageConstantDataStore.pageConstantList[i];
    		var temp = [{constantName:pageConstantVO.constantName, pageConstantVO:pageConstantVO.constantValue != '' ? pageConstantVO : ''}];
        	validateResult = validate.validateAllElement(temp,{constantName:pageConstantNameValRule, pageConstantVO:pageConstantValueValRule});
     	    if(!validateResult.validFlag){
     	    	result.flag = true;
      		    result.message+=validateResult.message;
      	    }
    	}
    	
		return result;
	}
    </script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="dataStoreSelectCtrl" data-ng-init="ready()">
<div>
	<div class="cap-area" >
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="数据集选择" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;">
		            <span id="addPageConstantVO" uitype="Button" label="新增" ng-click="insertPageConstantVO()"></span>
					<span id="openPageConstantVOSelect" uitype="Button" label="导入常量" ng-click="openPageConstantVOSelect()"></span>
					<span id="deletePageConstantVO" uitype="Button" label="删除" ng-click="deletePageConstantVO()"></span>
		        	<span id="importDataStoreVariable" uitype="Button" label="选择属性" ng-click="importDataStoreVariableCallBack()" button_type="blue-button"></span>
                    <span id="importDataStore" uitype="Button" label="选择数据集" ng-click="importDataStoreCallBack()" button_type="blue-button"></span>
		        	<span id="importDataStore" uitype="Button" label="清空" ng-click="clear()"></span>
                <!--    <span id="importEntityStore" uitype="Button" label="选择实体" ng-click="importEntityCallBack()"></span> -->
		        	<span id="close" uitype="Button" label="关闭" onClick="window.close()"></span>
		        </td>
		    </tr>
		</table>
		<div class="custom-div">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:30%">
		        	<table class="custom-grid" style="width: 100%">
		                <thead>
		                    <tr>
		                        <th>
	                            	名称
		                        </th>
		                    </tr>
		                </thead>
				        <tbody>
                             <tr ng-repeat="dataStoreVo in root.dataStore track by $index" style="background-color: {{selectDataStoreVO.ename==dataStoreVo.ename ? '#99ccff':'#ffffff'}}">
				                  <td style="text-align:left;cursor:pointer" ng-if="dataStoreVo.ename=='pageConstantList'&&$parent.dataSotreSelectType=='url'" ng-click="dataStoreTdClick(dataStoreVo)">
				                      {{dataStoreVo.cname}}({{dataStoreVo.ename}})
				                  </td>
				                  <td style="text-align:left;cursor:pointer" ng-if="dataStoreVo.ename!='environmentVariable'&&dataStoreVo.ename!='pageParam'&&dataStoreVo.ename!='rightsVariable'&&dataStoreVo.ename!='pageConstantList'&&$parent.dataSotreSelectType=='dataStore'" ng-click="dataStoreTdClick(dataStoreVo)">
				                      {{dataStoreVo.cname}}({{dataStoreVo.ename}})
				                  </td>
				                  <td style="text-align:left;cursor:pointer" ng-if="dataStoreVo.ename!='environmentVariable'&&dataStoreVo.ename!='pageParam'&&dataStoreVo.ename!='rightsVariable'&&dataStoreVo.ename!='pageConstantList'&&$parent.dataSotreSelectType=='dataStoreAttribute'" ng-click="dataStoreTdClick(dataStoreVo)">
				                      {{dataStoreVo.cname}}({{dataStoreVo.ename}})
				                  </td>
				                  <td style="text-align:left;cursor:pointer" ng-if="$parent.dataSotreSelectType==''||$parent.dataSotreSelectType==null||$parent.dataSotreSelectType=='attribute'" ng-click="dataStoreTdClick(dataStoreVo)">
				                      {{dataStoreVo.cname}}({{dataStoreVo.ename}})
				                  </td>
				              </tr>
				        </tbody>
		            </table>
		        </td>
		        <td class="cap-td" style="text-align: left" ng-show="selectDataStoreVO.modelType=='environmentVariable'">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-form-td" style="text-align: left;" colspan="2">
								<span class="cap-group">全局环境变量</span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                        <th style="width:200px">
				                            	参数名称
					                        </th>
					                        <th>
				                            	描述
					                        </th>
					                        <th style="width:100px">
				                            	类型
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr style="cursor:pointer;background-color: {{$parent.variableSelect==environmentVariableVO.attributeName? '#99ccff':'#ffffff'}}" ng-click="$parent.variableSelect=environmentVariableVO.attributeName" ng-repeat="environmentVariableVO in environmentVariableVOList track by $index" >
			                                <td style="text-align:left;">
			                                    {{environmentVariableVO.attributeName}}
			                                </td>
			                                <td style="text-align: left;">
			                                    {{environmentVariableVO.attributeDescription}}
			                                </td>
			                                <td style="text-align:center;">
			                                    {{environmentVariableVO.attributeType}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        </td>
					    </tr>
					</table>
		        </td>
		        <td class="cap-td" style="text-align: left" ng-show="selectDataStoreVO.modelType=='pageParam'">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-form-td" style="text-align: left;" colspan="2">
								<span class="cap-group">页面参数</span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                        <th style="width:200px">
				                            	参数名称
					                        </th>
					                        <th>
				                            	描述
					                        </th>
					                        <th style="width:80px">
				                            	类型
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr style="cursor:pointer;background-color: {{$parent.variableSelect==pageAttributeVO.attributeName? '#99ccff':'#ffffff'}}" ng-click="$parent.variableSelect=pageAttributeVO.attributeName" ng-repeat="pageAttributeVO in pageAttributeRoot.pageAttributeVOList track by $index">
			                                <td style="text-align:left;">
			                                	{{pageAttributeVO.attributeName}}
			                                </td>
			                                <td style="text-align: left;">
			                                	{{pageAttributeVO.attributeDescription}}
			                                </td>
			                                <td style="text-align:center;cursor:pointer">
			                                	{{pageAttributeVO.attributeType}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        </td>
					    </tr>
					</table>
		        </td>
		        <td class="cap-td" style="text-align: left" ng-show="selectDataStoreVO.modelType=='rightsVariable'">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-form-td" style="text-align: left;" colspan="2">
								<span class="cap-group">用户操作权限</span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                        <th style="width:150px">
				                            	权限编码
					                        </th>
					                        <th style="width:150px">
				                            	权限名称
					                        </th>
					                        <th>
				                            	权限描述
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="rightVO in rightsVariableVO.verifyIdList track by $index" style="cursor:pointer;background-color: {{$parent.variableSelect==rightVO.funcCode? '#99ccff':'#ffffff'}}" ng-click="$parent.variableSelect=rightVO.funcCode" >
			                                <td style="text-align:left;">
			                                    {{rightVO.funcName}}
			                                </td>
			                                <td style="text-align: left;">
			                                    {{rightVO.funcCode}}
			                                </td>
			                                <td style="text-align:left;cursor:pointer">
			                                    {{rightVO.description}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        </td>
					    </tr>
					</table>
		        </td>
		        <td class="cap-td" style="text-align: left" ng-show="selectDataStoreVO.modelType=='pageConstant'">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-form-td" style="text-align: left;" colspan="2">
								<span class="cap-group">页面常量</span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                        <th style="width:65px">
				                            	常量类型
					                        </th>
					                        <th>
				                            	常量值
					                        </th>
					                        <th style="width:120px">
				                            	常量名称
					                        </th>
					                        <th style="width:100px">
				                            	常量描述
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr style="cursor:pointer;background-color: {{$parent.variableSelect==pageConstantVO? '#99ccff':'#ffffff'}}" ng-click="$parent.variableSelect=pageConstantVO" ng-repeat="pageConstantVO in pageConstantDataStore.pageConstantList track by $index">
			                                <td style="text-align:center;" ng-if="pageConstantVO.constantType=='url'&&$parent.dataSotreSelectType=='url'">
			                                	{{pageConstantVO.constantType}}
			                                </td>
			                                <td style="text-align: left;" ng-if="pageConstantVO.constantType=='url'&&$parent.dataSotreSelectType=='url'">
			                                	<span cui_clickinput  id="{{'constantValue'+($index + 1)}}" ng-model="pageConstantVO.constantValue" bind="{{$index}}" constantName="{{pageConstantVO.constantName}}"  onclick="openURLEditor(jQuery(this).attr('bind'),jQuery(this).attr('constantName'))" width="100%" validate="pageConstantValueValRule"></span>
			                                </td>
			                                <td style="text-align:left;" ng-if="pageConstantVO.constantType=='url'&&$parent.dataSotreSelectType=='url'">
			                                	<span cui_input  id="{{'constantName'+($index + 1)}}" ng-model="pageConstantVO.constantName" width="100%" validate="pageConstantNameValRule"></span>
			                                </td>
			                                <td style="text-align: left;" ng-if="pageConstantVO.constantType=='url'&&$parent.dataSotreSelectType=='url'">
			                                	<span cui_input  id="{{'constantDescription'+($index + 1)}}"  ng-model="pageConstantVO.constantDescription" width="100%"></span>
			                                </td>
			                                
			                                 <td style="text-align:center;" ng-if="$parent.dataSotreSelectType!='url'" >
			                                	{{pageConstantVO.constantType}}
			                                </td>
			                                <td style="text-align: left;" ng-if="$parent.dataSotreSelectType!='url'" >
			                                	{{pageConstantVO.constantValue}}
			                                </td>
			                                 <td style="text-align:left;" ng-if="$parent.dataSotreSelectType!='url'" >
			                                	{{pageConstantVO.constantName}}
			                                </td>
			                                 <td style="text-align: left;" ng-if="$parent.dataSotreSelectType!='url'" >
			                                	{{pageConstantVO.constantDescription}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        </td>
					    </tr>
					</table>
		        </td>
		        <td class="cap-td" style="text-align: left" ng-show="selectDataStoreVO.modelType=='list' || selectDataStoreVO.modelType=='object'">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td class="cap-form-td" style="text-align: left;" colspan="2">
								<span class="cap-group">{{selectDataStoreVO.cname}}({{selectDataStoreVO.ename}}):{{selectDataStoreVO.entityVO.chName}}模型结构 </span>
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
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="entityAttributeVO in selectDataStoreVO.entityVO.attributes track by $index" style="cursor:pointer;background-color: {{$parent.variableSelect==selectDataStoreVO.ename+'.'+entityAttributeVO.engName? '#99ccff':'#ffffff'}}" ng-click="$parent.variableSelect=selectDataStoreVO.ename+'.'+entityAttributeVO.engName">
			                                <td style="text-align:left;">
			                                    {{entityAttributeVO.chName}}
			                                </td>
			                                <td style="text-align: left;">
			                                    {{entityAttributeVO.engName}}
			                                </td>
			                                <td style="text-align:center;">
			                                    {{entityAttributeVO.attributeType.type}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					        </td>
					    </tr>
					    
					    
					    <tr  ng-repeat="subEntityVO in selectDataStoreVO.subEntity track by $index">
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<table class="cap-table-fullWidth">
		                            <tr>
		                                <td style="text-align:left;">
		                                	<span class="cap-group">{{subEntityVO.chName}}({{subEntityVO.engName}}):{{subEntityVO.chName}}模型结构</span>
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
					                        <th style="width:100px">
				                            	类型
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="subEntityAttributeVO in subEntityVO.attributes track by $index" style="cursor:pointer;background-color: {{$parent.$parent.variableSelect==selectDataStoreVO.ename+'.'+subEntityVO.engName+'.'+subEntityAttributeVO.engName? '#99ccff':'#ffffff'}}" ng-click="$parent.$parent.variableSelect=selectDataStoreVO.ename+'.'+subEntityVO.engName+'.'+subEntityAttributeVO.engName">
			                                <td style="text-align:left;">
			                                    {{subEntityAttributeVO.chName}}
			                                </td>
			                                <td style="text-align: left;">
			                                    {{subEntityAttributeVO.engName}}
			                                </td>
			                                <td style="text-align:center;">
			                                    {{subEntityAttributeVO.attributeType.type}}
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					        </td>
					    </tr> 
					    
<!-- 					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        </td>
					    </tr> -->
					</table>
		        </td>
		    </tr>
		    <tr>
		        <td class="cap-td" style="text-align: left;" colspan="2">
		        </td>
		    </tr>
		</table>
		</div>
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
