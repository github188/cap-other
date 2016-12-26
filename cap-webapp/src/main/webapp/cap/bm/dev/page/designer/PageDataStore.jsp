<%
/**********************************************************************
* 数据模型
* 2015-5-13 肖威 新建
* 2015-6-29 郑重 修改
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='pageDataStore'>
<head>
<meta charset="UTF-8">
<title>数据模型</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	 
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
	<top:script src='/cap/dwr/interface/PageAttributePreferenceFacade.js'></top:script>
	<script type="text/javascript">
	
	//获得传递参数
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
   	var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
   	var globalReadState=eval(<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>);
	var pageSession = new cap.PageStorage(modelId);
	var dataStore = pageSession.get("dataStore");

	var environmentVariableVO=dataStore[0];
	var pageParamVO=dataStore[1];
	var rightsVariableVO=dataStore[2];
	var pageConstantDataStore=dataStore[3];
	
	var _ = cui.utils;
	
	//页面
	var page = pageSession.get("page");

	var pageAttributeRoot={pageAttributeVOList:page.pageAttributeVOList};
	//监听变量变化后通知页面基本信息
    function watchPageAttribute(){
    	//页面参数变化后，去设置配置参数的menu
    	disableMenu();
    	window.parent.sendMessage('pageStateFrame',{type:'pageAttributeChange',data:pageAttributeRoot.pageAttributeVOList});
    	cap.addObserve(pageAttributeRoot,watchPageAttribute);
    	//基本信息页面属性变动后，数据渲染
    	cap.digestValue(scope);
	}
    cap.addObserve(pageAttributeRoot,watchPageAttribute);
    
	//如果页面参数里面有包含配置的参数，则这些配置的参数在menu里面设为disable
    function disableMenu(){
    	var _paramList = pageAttributeRoot.pageAttributeVOList;
		//遍历menu菜单项
		_.each(parametersArray,function(config){
			//默认把菜单项先设为可操作
			cui('#choosePageParameters').getMenu().disable(config.id,false);
			//遍历页面参数集合,看是否能找的到和当前菜单项一样的参数
    		var _tempObj = _.find(_paramList,function(item){
    			return item.attributeName == config.id;
    		});
    		//如果找到了，则菜单项设为disable。（如果没找到 _tempObj为undefined）
    		if(_tempObj){
    			cui('#choosePageParameters').getMenu().disable(config.id,true);
    		}
		});
    }
    
    //监听数据集变化
    function watchDataStoreChange(){
    	cap.addObserve(dataStore,watchDataStoreChange);
    	//tab组件，grid组件，frame组件，borderlayout组件选择url时新增的数据同步刷新
    	//快速布局新增数据的渲染
    	cap.digestValue(scope);
	}
    cap.addObserve(dataStore,watchDataStoreChange);
    
  	//监听变量变化后通知pageState页面
    function watchRights(){
   		window.parent.sendMessage('pageStateFrame',{type:'pageAttributeChange',data:pageAttributeRoot.pageAttributeVOList});
    	cap.addObserve(rightsVariableVO,watchRights);
	}
    cap.addObserve(rightsVariableVO,watchRights);
    
	//环境变量
	var environmentVariableVOList=[];
	
	var root={
		dataStore:dataStore
    }
	
	//监听变量变化后自动保存,通知pageState页面
    function watchDataStore(){
    	window.parent.sendMessage('pageStateFrame',{type:'pageAttributeChange',data:pageAttributeRoot.pageAttributeVOList});
    	cap.addObserve(root,watchDataStore);
	}
    cap.addObserve(root,watchDataStore);
    
    /**
     * 选择页面参数。页面加载的时候就执行此函数。从元数据配置文件pageParameters.pageParameter.json中读取选择。   
     * 读取defaultReference为false的数据。配在配置文件中的数据，userDefined应该也为false。
     */
    var parametersArray = [];
    var pagePrametersData=function(){
    	parametersArray = []; //每次初始化都设置为空。因为parametersArray为全局变量
    	dwr.TOPEngine.setAsync(false);
		PageAttributePreferenceFacade.queryOptionalParameters(function(data) {
			for(var i = 0;i < data.length; i++){
				parametersArray.push({id:data[i].attributeName,label:data[i].attributeName,
					attributeName:data[i].attributeName,
					attributeType:data[i].attributeType,
					attributeValue:data[i].attributeValue,
					defaultReference:data[i].defaultReference,
					userDefined:data[i].userDefined,
					attributeDescription:data[i].attributeDescription,
					attributeSelectValues:data[i].attributeSelectValues
					});
			}
		});
		dwr.TOPEngine.setAsync(true);
		
		return {
			datasource:parametersArray,
			on_click: function(obj){
				scope.pageAttributeRoot.pageAttributeVOList.push({
					attributeName:obj.attributeName,
					attributeType:obj.attributeType,
					attributeValue:obj.attributeValue,
					attributeDescription:obj.attributeDescription,
					defaultReference:obj.defaultReference,
					userDefined:obj.userDefined,
					attributeSelectValues:obj.attributeSelectValues
					});
				window.parent.sendMessage('pageStateFrame',{type:'pageAttributeChange',data:pageAttributeRoot.pageAttributeVOList});
			 }
		}; 
    		
	};
    
    //拿到angularJS的scope
    var scope=null;
	
	angular.module('pageDataStore', [ "cui"]).controller('pageDataStoreCtrl', function ($scope, $timeout) {
		$scope.root=root;
		$scope.pageAttributeRoot=pageAttributeRoot;
		$scope.pageParamVO=pageParamVO;
		$scope.environmentVariableVO=environmentVariableVO;
		$scope.rightsVariableVO=rightsVariableVO;
		$scope.environmentVariableVOList=environmentVariableVOList;
		$scope.pageConstantDataStore=pageConstantDataStore;
		
		$scope.ready=function(){
			$scope.resizePageHeight();
			//保存到session字段从boolean转换为字符串，为了ridio按钮自动选中
	   		for(var i in root.dataStore){
	   		  root.dataStore[i].saveToSession = root.dataStore[i].saveToSession+"";
	   		}
	    	comtop.UI.scan();
	    	$scope.setReadonlyAreaState(globalReadState);
	    	scope=$scope;
	    	$scope.dataStoreTdClick(root.dataStore[0]);
	    };
		
	    $scope.resizePageHeight=function(){
	    	$(".cap-page").css("height", $(window).height()-20);
			$(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
		       jQuery(".cap-page").css("height", $(window).height()-20);
		    });
	    }
	    
	    /**
		 * 设置区域读写状态
		 * @param globalReadState 状态标识
		 */
		$scope.setReadonlyAreaState=function(globalReadState){
			//设置为控件为自读状态（针对于CAP测试建模）
		   	if(globalReadState){
		    	$timeout(function(){
		    		cap.setReadonlyArea("unReadonlyArea", ["*:not([class^='notUnbind'],[id='actionType'])"], ["input[type='checkbox'], input[type='button'], input[type='radio']"]);
		    	}, 0);
	    	}
		}
	    
		$scope.dataStoreCheckAll=false;
    	
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
    	};
    	
    	//监控全选checkbox，如果选择则联动选中列表所有数据
    	$scope.allDataStoreCheckBoxCheck=function(ar,isCheck){
    		if(ar!=null){
    			for(var i=0;i<ar.length;i++){
	    			if(isCheck && (ar[i].modelType=='list' || ar[i].modelType=='object')){
	    				ar[i].check=true;
		    		}else{
		    			ar[i].check=false;
		    		}
	    		}	
    		}
    	};
    	
    	//监控选中，如果列表所有行都被选中则选中allCheckBox
    	$scope.checkDataStoreBoxCheck=function(ar,allCheckBox){
    		if(ar!=null){
    			var checkCount=0;
    			var allCount=0;
	    		for(var i=0;i<ar.length;i++){
	    			if(ar[i].check){
	    				checkCount++;
		    		}
	    			
	    			if(ar[i].modelType=='list' || ar[i].modelType=='object'){
	    				allCount++;
	    			}
	    		}
	    		if(checkCount==allCount && checkCount!=0){
	    			eval("$scope."+allCheckBox+"=true");
	    		}else{
	    			eval("$scope."+allCheckBox+"=false");
	    		}
    		}
    	};
    	
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
    	};
    	
    	//选中表达式行
    	$scope.dataStoreTdClick=function(dataStoreVo){
    		if(dataStoreVo.modelType=='environmentVariable'){
    			$scope.loadEnvironmentVariableVOList();
    		}
    		$scope.selectDataStoreVO=dataStoreVo;
	    };
    	
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
    	};
    	
    	//新增表达式
    	$scope.addDataStore=function(){
    		var newDataStore={ename:'',cname:'',modelType:'object',saveToSession:'false'};
    		$scope.selectDataStoreVO=newDataStore;
    		$scope.root.dataStore.push(newDataStore);
    		$scope.checkBoxCheck($scope.root.dataStore,"dataStoreCheckAll");
    	};
    	
    	//删除表达式
    	$scope.deleteDataStore=function(){
    		var deleteArr=[];
    		var newArr=[];
            for(var i=0;i<$scope.root.dataStore.length;i++){
                if($scope.root.dataStore[i].check){
                    newArr.push(i);
                    deleteArr.push($scope.root.dataStore[i]);
                }
            }
            var deleteTitle = "";
			for(var k=0;k<deleteArr.length;k++){
				 deleteTitle += deleteArr[k].ename+"<br/>";
			}
			if(deleteArr.length>0){
				cui.confirm("确定要删除<br/>"+deleteTitle+"这些数据集吗？",{
    				onYes:function(){ 
		            //根据坐标删除数据
		            for(var j=newArr.length-1;j>=0;j--){
		            	$scope.root.dataStore .splice(newArr[j],1);
		            }
		            //如果当前选中的行被删除则默认选择第一行
		            var isSelectIsDelete=true;
		            for(var i=0;i<$scope.root.dataStore.length;i++){
		                if($scope.root.dataStore[i].ename==$scope.selectDataStoreVO.ename){
		                    isSelectIsDelete=false;
		                    break;
		                }
		            }
		            if(isSelectIsDelete){
		            	$scope.selectDataStoreVO=$scope.root.dataStore[0];
		            }
		            $scope.checkBoxCheck($scope.root.dataStore,"dataStoreCheckAll");
		            
    				}
    			});
			}    
    	};
    	
    	$scope.pageAttributeCheckAll=false;
    	
    	$scope.deletePageAttribute=function(){
    		var newArr=[];
    		for(var i=0;i<$scope.pageAttributeRoot.pageAttributeVOList.length;i++){
    			if($scope.pageAttributeRoot.pageAttributeVOList[i].check){
    				newArr.push(i);
    			}
    		}
            //根据坐标删除数据
            for(var j=newArr.length-1;j>=0;j--){
            	$scope.pageAttributeRoot.pageAttributeVOList.splice(newArr[j],1);
            }
    	};
    	
    	$scope.insertAttribute=function(){
    		$scope.pageAttributeRoot.pageAttributeVOList.push({attributeName:'',attributeType:'String',attributeValue:'',attributeDescription:'',defaultReference:false,userDefined:true});
    	};
    	
    	var rightCheckAll=false;
    	
    	//打开导入权限界面
		$scope.openAddRightSelect = function () {
			var url = 'RightsAdd.jsp?funcId=' + page.parentId+"&modelId="+modelId;
			var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
			window.open (url,'addRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		};
    	
    	//打开导入权限界面
		$scope.openRightSelect = function () {
			var url = 'RightsSelect.jsp?funcId=' + page.parentId;
			var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
			window.open (url,'importRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		};
    	
		//删除页面权限
    	$scope.deleteRight = function (){
    		var newArr=[];
            for(var i=0;i<rightsVariableVO.verifyIdList.length;i++){
            	if(rightsVariableVO.verifyIdList[i].check){
            		newArr.push(i);
            	}
            }
            //根据坐标删除数据
            for(var j=newArr.length-1;j>=0;j--){
            	rightsVariableVO.verifyIdList.splice(newArr[j],1);
            }
            $scope.checkBoxCheck(rightsVariableVO.verifyIdList,"rightCheckAll");
    	};
		
		/**
		 * 选择实体
		 *
		 */
    	$scope.openEntitySelect=function(){
    		var url = "EntityListSelectionMain.jsp?packageId=" + packageId;
			var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
			window.open (url,'entitySelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
    	};
    	
    	/**
    	 * 导入数据集
    	 *
    	 */
		$scope.openPageDataStoreSelect = function () {
			var url = 'PageDataStoreSelect.jsp?packageId=' + packageId + '&modelId=' + page.modelId;
			var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
			window.open (url,'importRoleAccess','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
		};
    	
    	//打开导入常量界面
    	$scope.openPageConstantVOSelect = function(){
    		var url = 'PageConstantSelect.jsp?packageId=' + packageId;
    		var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
    		window.open (url,'importPageConstant','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
    	};
    	
    	//页面常量
		$scope.pageConstantCheckAll=false;
    	
		//新增页面常量
		$scope.insertPageConstantVO=function(){
    		$scope.pageConstantDataStore.pageConstantList.push({constantName:'',constantType:'String',constantValue:'',constantDescription:'',constantOption:{}});
    	};
		
		//删除页面常量
    	$scope.deletePageConstantVO = function (){
    		var newArr=[];
            for(var i=0;i<$scope.pageConstantDataStore.pageConstantList.length;i++){
            	if($scope.pageConstantDataStore.pageConstantList[i].check){
            		newArr.push(i)
            	}
            }
            //根据坐标删除数据
            for(var j=newArr.length-1;j>=0;j--){
            	$scope.pageConstantDataStore.pageConstantList.splice(newArr[j],1);
            }
            $scope.checkBoxCheck($scope.pageConstantDataStore.pageConstantList,"pageConstantCheckAll");
    	};
		
    	$scope.constantTypeChangeEvent=function(columnsNo){
        	currOperaConstantColId = 'constantValue'+columnsNo;
        	var constantType = cui("#constantType"+columnsNo).getValue();
        	if("boolean"==constantType){
        		cui("#constantValue"+columnsNo).setValue("true");
        	}
        	cap.validater.validOneElement(currOperaConstantColId);
        };
        
    	$scope.$watch("pageAttributeRoot.pageAttributeVOList",function(){
    		disableMenu();
    	});
	});
	
	//导入权限
	function  importRightsVariableCallBack(selectRights){
		for(var i=0;i<selectRights.length;i++){
			var isAdd=true;
			selectRights[i].check=false;
			for(var j=0;j<rightsVariableVO.verifyIdList.length;j++){
				if(selectRights[i].funcId==rightsVariableVO.verifyIdList[j].funcId){
					isAdd=false;
					break;
				}
			}
			if(isAdd){
				rightsVariableVO.verifyIdList.push(selectRights[i]);
			}
		}
		scope.$digest();
	}
	
	//导入实体
	function importEntityCallBack(entityVO){
		scope.selectDataStoreVO.entityVO=entityVO;
		scope.selectDataStoreVO.entityId=entityVO.modelId;
		dwr.TOPEngine.setAsync(false);
		PageFacade.dealRelationEntity(entityVO,function(result){
			scope.selectDataStoreVO.subEntity = result;
		});
		dwr.TOPEngine.setAsync(true);
		//自动初始化数据集的中英文名称
		setNames(scope);
	}
	
	//设置数据集的中英文名称
	function setNames(scope){
		var cname = scope.selectDataStoreVO.entityVO.chName;
		var ename = scope.selectDataStoreVO.entityVO.engName;
		if(ename !="" && ename != null){
			ename = ename.substring(0,1).toLowerCase() + ename.substring(1);
		}
		
		if(scope.selectDataStoreVO.modelType == "object"){
			scope.selectDataStoreVO.cname = (cname == "" || cname == null) ? "" : cname;				
			scope.selectDataStoreVO.ename = ename;				
		}else if(scope.selectDataStoreVO.modelType == "list"){
			scope.selectDataStoreVO.cname = (cname == "" || cname == null) ? "集合" : cname + "集合";				
			scope.selectDataStoreVO.ename = ename + "List";				
		}
		cap.digestValue(scope);
	}
	
	/**
	 * 点击数据类型radio改变中英文名称
	 * 在当前选中的radio上点击，不执行任何操作。
	 * 当点击当前未选中的radio时，如果点击的radiao是object，则去掉中文名称后面的“集合”，去掉英文名称后面的“List”，前提是中英文名称分别是以“集合”、“List”结尾。
	 * 当点击当前未选中的radio时，如果点击的radiao是List，则在中文名称后面添加“集合”，在英文名称后面添加“List”。
	 */
	function modelTypeClick(type){
		if(scope.selectDataStoreVO.modelType != type){
			var cname = scope.selectDataStoreVO.cname;
			var ename = scope.selectDataStoreVO.ename;
			if(type == "object"){
				scope.selectDataStoreVO.cname = (cname == "" || cname == null) ? "" : (cname.substring(cname.length-2) == "集合" ? cname.substring(0,cname.length-2) : cname);
				scope.selectDataStoreVO.ename = (ename == "" || ename == null) ? "" : (ename.substring(ename.length-4) == "List" ? ename.substring(0,ename.length-4) : ename);
			}else if(type == "list"){
				scope.selectDataStoreVO.cname = (cname == "" || cname == null ) ? "集合" : (cname.substring(cname.length-2) == "集合" ? cname : cname + "集合");
				scope.selectDataStoreVO.ename = (ename == "" || ename == null ) ? "List" : (ename.substring(ename.length-4) == "List" ? ename : ename + "List");
			}
		}
	}
	
	//导入数据集测试
	function  importPageDataStoreCallBack(ar){
		for(var i=0;i<ar.length;i++){
			ar[i].check=false;
    		scope.root.dataStore.push(ar[i]);
    		scope.checkBoxCheck(scope.root.dataStore,"dataStoreCheckAll");
    	}
		scope.$digest();
	}
	
	//导入常量集
	function importPageConstantCallBack(selectConstants){
		//这里是全部导入
		//for(var i=0;i<ar.length;i++){
		//	ar[i].check = false;
		//	scope.pageConstantDataStore.pageConstantList.push(ar[i]);
		//}
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
	
	//打开URL编辑器
	function openURLEditor(flag,constantName) {
		flag="pageConstantList["+flag+"]"
		var url = 'URLEditor.jsp?packageId=' + packageId+"&modelId="+modelId+"&flag="+flag+"&constantName="+constantName;
		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
		window.open (url,'URLEditor','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
	}

    //页面选择界面
	function openCopyPageListMain(flag, constantName) {
		flag = "pageConstantList[" + flag + "]"
		// var url = 'URLEditor.jsp?packageId=' + packageId + "&modelId=" + modelId + "&flag=" + flag + "&constantName=" + constantName+"&openType=openCopyPageListMain";
		// var top = (window.screen.availHeight - 600) / 2;
		// var left = (window.screen.availWidth - 800) / 2;
		// window.open(url, 'URLEditor', 'height=600,width=800,top=' + top + ',left=' + left + ',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')

		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
        var url ='CopyPageListMain.jsp?systemModuleId='+packageId+'&openType=openCopyPageListMain&modelId='+modelId+'&flag='+flag+'&constantName='+constantName;
        window.open(url, 'CopyPageListMain', 'height=600,width=800,top=' + top + ',left=' + left + ',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
	}

    //存储CopyPageListMain页面的数据
    function storeCopyPageListMain(selectData, openType, flag) {
    	var copyPage = {
    		selectData: selectData,
    		openType: openType,
    		flag: flag
    	};
    	scope.copyPage = copyPage;
    	scope.$digest();
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
		var localPageConstantName = eval("pageConstantDataStore."+flag+".constantName");
		var localPageConstantDes = eval("pageConstantDataStore."+flag+".constantDescription");
		//如果常量名称，常量描述为空就自动添加
		if(localPageConstantName==""){
		eval("pageConstantDataStore."+flag+".constantName=pageConstantName;");
		}
		if(localPageConstantDes==""){
		eval("pageConstantDataStore."+flag+".constantDescription=pageConstantDes;");
		}
		eval("pageConstantDataStore."+flag+".constantValue=url;");
		eval("pageConstantDataStore."+flag+".constantOption=constantOption;");
		scope.$digest();
	}
	
 	//参数路径不能重复校验
    function validateDataStoreEname(ename){
    	return isExistValidate(scope.root.dataStore, 'ename', ename);
    }
    
    //参数名称不能重复校验
    function validatePageAttrName(attributeName){
    	return isExistValidate(pageAttributeRoot.pageAttributeVOList, 'attributeName', attributeName);
    }
	
 	//常量名称不能重复校验
    function validatePageConstantName(constantName){
    	return isExistValidate(pageConstantDataStore.pageConstantList, 'constantName', constantName);
    }
 	
    var currOperaConstantColId=0;
    //数据常量新增、编辑时的行号id，便于校验
    function getOperaConstantColId(id){
    	currOperaConstantColId = id;
    }
    
    function constantValueKeyDownHandler(id, event){
    	var e = event || window.event || arguments.callee.caller.arguments[0];  
    	if(e.keyCode == 9){
    		getOperaConstantColId(id);
    	}
    }
    
    //常量值不能重复校验
    function validatePageConstantValue(constantValue){
    	var ret = true;
    	var reg=/^{{/;   
        if(constantValue != '' && currOperaConstantColId != 0 && !reg.test(currOperaConstantColId)){    
       		var idConstantType = currOperaConstantColId.replace('constantValue', 'constantType');
           	var constantType = cui("#"+idConstantType).getValue();
           	ret = validateConstantType(constantType, constantValue);
        }
 		return ret;
    }
    
    //常量数据集校验
    function constantValidate(obj){
    	return validateConstantType(obj.constantType, obj.constantValue);
    }
    
    function validateConstantType(constantType, constantValue){
    	var ret = true;
    	if(constantType === 'String' || constantType === 'url'){
   		} else if(constantType === 'int'){
   			ret = cap.isInt(constantValue);
   		} else if(constantType === 'boolean'){
   			ret = cap.isBoolean(constantValue);
   		} else if(constantType === 'double'){
   			ret = cap.isDouble(constantValue);
   		} 
    	return ret;
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
    
    //验证规则(页面常量校验)
    var pageConstantNameValRule = [{'type':'required', 'rule':{'m': '常量名称不能为空'}},{type:'format', rule:{pattern:'\^[a-z_$][a-zA-Z0-9_$]*\$', m:'常量名称只能输入字母、数字、美元符号‘$’或下划线‘_’，如首字符为字母，必须小写，遵循java变量命名规则'}},{'type':'custom','rule':{'against':'validatePageConstantName', 'm':'常量名称不能重复'}}];
    var pageConstantValueValRule = [{'type':'required', 'rule':{'m': '常量值不能为空'}},{'type':'custom','rule':{'against':'validatePageConstantValue', 'm':'常量值格式错误'}}];
    var constantValidateRule = [{'type':'required', 'rule':{'m': '常量值不能为空'}},{'type':'custom','rule':{'against':'constantValidate', 'm':'常量值格式错误'}}];

	//验证规则
    var pageAttrNameValRule = [{'type':'required', 'rule':{'m': '参数名称不能为空'}},{'type':'custom','rule':{'against':'validatePageAttrName', 'm':'参数名称不能重复'}}];
    var pageAttrDesValRule = [{'type':'required', 'rule':{'m': '参数描述不能为空'}}];
    var dataStoreCnameValRule = [{'type':'required', 'rule':{'m': '数据集中文名称不能为空'}}];
    var dataStoreEnameValRule = [{'type':'required', 'rule':{'m': '数据集英文名称不能为空'}},{type:'format', rule:{pattern:'\^[a-z_$][a-zA-Z0-9_$]*\$', m:'数据集英文名称只能输入字母、数字、美元符号‘$’或下划线‘_’，如首字符为字母，必须小写，遵循java变量命名规则'}},{type:'custom',rule:{against:'validateDataStoreEname', m:'数据集英文名称不能重复'}}];
   
    //统一校验函数
	function validateAll(){
    	var validate = new cap.Validate();
    	var valRule2Page = {attributeName:pageAttrNameValRule, attributeDescription:pageAttrDesValRule};
    	var result = validate.validateAllElement(pageAttributeRoot.pageAttributeVOList, valRule2Page, "&diams;页面传入参数->第【{value}】行：");
    	
    	var validateResult = '';
    	for(var i in scope.pageConstantDataStore.pageConstantList){
    		var pageConstantVO = scope.pageConstantDataStore.pageConstantList[i];
    		var temp = [{constantName:pageConstantVO.constantName, pageConstantVO:pageConstantVO.constantValue != '' ? pageConstantVO : ''}];
        	validateResult = validate.validateAllElement(temp, {constantName:pageConstantNameValRule, pageConstantVO:constantValidateRule}, "&diams;页面常量->第【"+(parseInt(i)+1)+"】行：");
        	result.validFlag=result.validFlag && validateResult.validFlag;
     	    if(!validateResult.validFlag){
      		    result.message+=validateResult.message;
      	    }
    	}
    	
    	var valRule2DataStore={cname:dataStoreCnameValRule, ename:dataStoreEnameValRule};
    	validateResult = validate.validateAllElement(scope.root.dataStore,valRule2DataStore, "&diams;数据集列表->第【{value}】行：");
    	result.validFlag=result.validFlag && validateResult.validFlag;
		if(!validateResult.validFlag){
			result.message+=validateResult.message+"<br/>";
		}
		return result;
	}
</script>
</head>
<body style="background-color:#f5f5f5;"  ng-controller="pageDataStoreCtrl" data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" style="width:100%; height: 100%; overflow-y: auto">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="页面数据模型设计" class="cap-label-title" size="12pt"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth" style="width:100%; height: 95%;">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:350px">
		        	<table class="cap-table-fullWidth">
					    <tr>
					        <td  class="cap-form-td" style="text-align: left;">
								<span class="cap-group">数据集列表</span>
					        </td>
					        <td class="cap-form-td" style="text-align: right;">
					        	<span cui_button id="addExpression"  label="新增" ng-click="addDataStore()"></span>
					        	<span cui_button id="openImportExpression"  label="导入数据集" ng-click="openPageDataStoreSelect()"></span>
					        	<span cui_button id="deleteExpression"  label="删除" ng-click="deleteDataStore()"></span>
					        </td>
					    </tr>
					    <tr>
					    	<td class="cap-form-td" colspan="2">
					            <table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="dataStoreCheckAll" ng-model="dataStoreCheckAll" ng-change="allDataStoreCheckBoxCheck(root.dataStore,dataStoreCheckAll)">
					                        </th>
					                        <th>
				                            	中文名称
					                        </th>
					                        <th style="width:150px">
				                            	英文名称
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="dataStoreVo in root.dataStore track by $index" class="notUnbind" ng-click="dataStoreTdClick(dataStoreVo)" style="cursor:pointer;background-color: {{selectDataStoreVO.ename==dataStoreVo.ename ? '#99ccff':'#ffffff'}}">
			                            	<td style="text-align: center;">
			                            		<div ng-show="dataStoreVo.modelType=='list' || dataStoreVo.modelType=='object'">
			                                    <input type="checkbox" name="{{'dataStore'+($index + 1)}}" ng-model="dataStoreVo.check" ng-change="checkDataStoreBoxCheck(root.dataStore,'dataStoreCheckAll')">
			                                	</div>
			                                </td>
			                                <td style="text-align:left;cursor:pointer">
			                                    {{dataStoreVo.cname}}
			                                </td>
			                                <td style="text-align: left;">
			                                    {{dataStoreVo.ename}}
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
					                        <th style="width:250px">
				                            	参数名称
					                        </th>
					                        <th>
				                            	描述
					                        </th>
					                        <th style="width:100px">
				                            	类别
					                        </th>
					                        <th style="width:100px">
				                            	类型
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="environmentVariableVO in environmentVariableVOList track by $index">
			                                <td style="text-align:left;">
			                                    {{environmentVariableVO.attributeName}}
			                                </td>
			                                <td style="text-align: left;">
			                                    {{environmentVariableVO.attributeDescription}}
			                                </td>
			                                <td style="text-align:center;">
			                                    {{environmentVariableVO.attributeClass}}
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
					        <td class="cap-form-td" style="text-align: right;" colspan="2">
					        	
								<span cui_button id="insertAttribute"  label="新增" ng-click="insertAttribute()"></span>
								<span uitype="button" label="选择" id="choosePageParameters"  menu="pagePrametersData"></span>
					        	<span cui_button id="deletePageAttribute"  label="删除" ng-click="deletePageAttribute()"></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="pageAttributeCheckAll" ng-model="pageAttributeCheckAll" ng-change="allCheckBoxCheck(pageAttributeRoot.pageAttributeVOList,pageAttributeCheckAll)">
					                        </th>
					                        <th style="width:200px">
				                            	参数名称
					                        </th>
					                        <th>
				                            	参数描述
					                        </th>
					                        <th style="width:100px">
				                            	参数类型
					                        </th>
					                        <th style="width:150px">
				                            	默认值
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="pageAttributeVO in pageAttributeRoot.pageAttributeVOList">
			                                <td style="text-align: center;">
			                                    <input type="checkbox" name="{{'pageAttribute'+($index + 1)}}" ng-model="pageAttributeVO.check" ng-click="checkBoxCheck(pageAttributeRoot.pageAttributeVOList,'pageAttributeCheckAll')">
			                                </td>
			                                <td style="text-align:left;">
			                                	 <span cui_input  id="{{'attributeName'+($index + 1)}}" ng-model="pageAttributeVO.attributeName" width="100%" validate="pageAttrNameValRule" readonly="{{!pageAttributeVO.userDefined}}"></span>
			                                </td>
			                                <td style="text-align: left;">
			                                	<span cui_input  id="{{'attributeDescription'+($index + 1)}}" ng-model="pageAttributeVO.attributeDescription" width="100%" validate="pageAttrDesValRule" readonly="{{!pageAttributeVO.userDefined}}"></span>
			                                </td>
			                                <td style="text-align:center;cursor:pointer">
			                                	<span cui_pulldown id="{{'attributeType'+($index + 1)}}" ng-model="pageAttributeVO.attributeType" value_field="id" label_field="text" width="100%" readonly="{{!pageAttributeVO.userDefined}}">
													<a value="String">String</a>
													<a value="int">int</a>
													<a value="boolean">boolean</a>
													<a value="double">double</a>
												</span>
			                                </td>
			                                <td style="text-align: left;"  ng-if="pageAttributeVO.userDefined">
			                                	<span cui_input  id="{{'attributeValue'+($index + 1)}}" ng-model="pageAttributeVO.attributeValue" width="100%"></span>
			                                </td>
			                                
			                                 <td style="text-align: center;" ng-if="!pageAttributeVO.userDefined">
			                                	<span cui_pulldown ng-if="pageAttributeVO.attributeSelectValues.length != 0" id="{{'attributeValue'+($index + 1)}}"  ng-model="pageAttributeVO.attributeValue" value_field="id" label_field="text" width="100%" datasource="{{pageAttributeVO.attributeSelectValues}}">
													<!-- <a value="readonly">只读模式</a>
													<a value="edit">编辑模式</a>
													<a value="textmode">文本模式</a> -->
												</span>
												<span cui_input ng-if="pageAttributeVO.attributeSelectValues.length == 0"  id="{{'attributeValue'+($index + 1)}}" ng-model="pageAttributeVo.attributeValue" width="100%"></span>
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
					        <td class="cap-form-td" style="text-align: right;" colspan="2">
								<span cui_button id="addPageAttribute"  label="新增权限" ng-click="openAddRightSelect()"></span>
					        	<span cui_button id="deletePageAttribute"  label="导入模块权限" ng-click="openRightSelect()"></span>
					        	<span cui_button id="deletePageAttribute"  label="删除" ng-click="deleteRight()"></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="rightCheckAll" ng-model="rightCheckAll" ng-change="allCheckBoxCheck(rightsVariableVO.verifyIdList,rightCheckAll)">
					                        </th>
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
			                            <tr ng-repeat="rightVO in rightsVariableVO.verifyIdList track by $index" ng-click="checkBoxCheck(rightsVariableVO.verifyIdList,'rightCheckAll')">
			                                <td style="text-align: center;">
			                                    <input type="checkbox" name="{{'rightVO'+($index + 1)}}" ng-model="rightVO.check">
			                                </td>
			                                <td style="text-align:left;" ng-click="rightVO.check=!rightVO.check">
			                                    {{rightVO.funcCode}}
			                                </td>
			                                <td style="text-align: left;" ng-click="rightVO.check=!rightVO.check">
			                                    {{rightVO.funcName}}
			                                </td>
			                                <td style="text-align:left;cursor:pointer" ng-click="rightVO.check=!rightVO.check">
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
					        <td class="cap-form-td" style="text-align: right;" colspan="2">
								<span cui_button id="addPageConstantVO"  label="新增" ng-click="insertPageConstantVO()"></span>
					        	<span cui_button id="openPageConstantVOSelect"  label="导入常量" ng-click="openPageConstantVOSelect()"></span>
					        	<span cui_button id="deletePageConstantVO"  label="删除" ng-click="deletePageConstantVO()"></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="pageConstantCheckAll" ng-model="pageConstantCheckAll" ng-change="allCheckBoxCheck(pageConstantDataStore.pageConstantList,pageConstantCheckAll)">
					                        </th>
					                         <th style="width:150px">
				                            	常量类型
					                        </th>
					                        <th>
				                            	常量值
					                        </th>
					                        <th style="width:150px">
				                            	常量名称
					                        </th>
					                        <th>
				                            	常量描述
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="pageConstantVO in pageConstantDataStore.pageConstantList track by $index">
			                                <td style="text-align: center;">
			                                    <input type="checkbox" name="{{'pageConstantVO'+($index + 1)}}" ng-model="pageConstantVO.check" ng-click="checkBoxCheck(pageConstantDataStore.pageConstantList,'pageConstantCheckAll')">
			                                </td>
			                               <td style="text-align:center;cursor:pointer">
			                                	<span cui_pulldown id="{{'constantType'+($index + 1)}}" ng-model="pageConstantVO.constantType" value_field="id" label_field="text" width="100%" ng-change="constantTypeChangeEvent('{{($index + 1)}}')">
													<a value="String">String</a>
													<a value="int">int</a>
													<a value="boolean">boolean</a>
													<a value="double">double</a>
													<a value="url">url</a>
												</span>
			                                </td>
			                                <td style="text-align: left;">
			                                	<span cui_input  id="{{'constantValue'+($index + 1)}}" ng-if="(pageConstantVO.constantType!='url'  && pageConstantVO.constantType!='boolean' )" ng-model="pageConstantVO.constantValue" width="100%" onclick="getOperaConstantColId(this.id)" onkeydown="constantValueKeyDownHandler(this.id)" validate="pageConstantValueValRule"></span>
			                                	<span cui_pulldown  id="{{'constantValue'+($index + 1)}}" ng-if="pageConstantVO.constantType=='boolean'" ng-model="pageConstantVO.constantValue" bind="{{$index}}" constantName="{{pageConstantVO.constantName}}"  width="100%">
			                                		<a value="true">true</a>
													<a value="false">false</a>
			                                	</span>
			                                	<span cui_clickinput  id="{{'constantValue'+($index + 1)}}" ng-if="pageConstantVO.constantType=='url'" ng-model="pageConstantVO.constantValue" bind="{{$index}}" constantName="{{pageConstantVO.constantName}}"  onclick="openCopyPageListMain(jQuery(this).attr('bind'),jQuery(this).attr('constantName'))" width="100%"></span>
			                                </td>
			                                <td style="text-align:left;">
			                                	 <span cui_input  id="{{'constantName'+($index + 1)}}" ng-model="pageConstantVO.constantName" width="100%" validate="pageConstantNameValRule"></span>
			                                </td>
			                                <td style="text-align: left;">
			                                	<span cui_input  id="{{'constantDescription'+($index + 1)}}" ng-model="pageConstantVO.constantDescription" width="100%" ></span>
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
								<span class="cap-group">数据模型编辑</span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	<font color="red">*</font>数据类型：
					        </td>
					        <td class="cap-td" style="text-align: left;">
								<input type="radio" name="modelType"  ng-model="selectDataStoreVO.modelType" value="object" onclick="modelTypeClick('object')"/>对象
								<input type="radio" name="modelType"  ng-model="selectDataStoreVO.modelType" value="list" onclick="modelTypeClick('list')"/>集合
								<input type="radio" name="modelType"  ng-model="selectDataStoreVO.modelType" value="pageParam" style="display:none"/>
								<input type="radio" name="modelType"  ng-model="selectDataStoreVO.modelType" value="environmentVariable" style="display:none"/>
					        	<input type="radio" name="modelType"  ng-model="selectDataStoreVO.modelType" value="rightsVariable" style="display:none"/>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	<font color="red">*</font>保存到session：
					        </td>
					        <td class="cap-td" style="text-align: left;">
								<input type="radio" name="saveToSession"  ng-model="selectDataStoreVO.saveToSession" value="false"/>否
								<input type="radio" name="saveToSession"  ng-model="selectDataStoreVO.saveToSession" value="true"/>是
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	<font color="red">*</font>实体：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_clickinput id="parentName" ng-model="selectDataStoreVO.entityVO.engName" ng-click="openEntitySelect()" width="100%"></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	<font color="red">*</font>数据集英文名称：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input  id="ename" ng-model="selectDataStoreVO.ename" width="100%" validate="dataStoreEnameValRule"></span>
					        </td>
					    </tr>
					    <tr>
					        <td  class="cap-td" style="text-align: right;width:120px">
								<font color="red">*</font>数据集中文名称：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input  id="cname" ng-model="selectDataStoreVO.cname" width="100%" validate="dataStoreCnameValRule"></span>
					        </td>
					    </tr>
					    
					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        	<span class="cap-group">{{selectDataStoreVO.entityVO.chName}}({{selectDataStoreVO.entityVO.engName}})模型结构</span>
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
					                        <th style="width:150px">
				                            	类型
					                        </th>
					                        <th style="width:150px">
				                            	初始值
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="entityAttributeVO in selectDataStoreVO.entityVO.attributes track by $index">
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
					    <tr  ng-repeat="entityVO in selectDataStoreVO.subEntity track by $index">
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
<!-- 					    <tr>
					        <td class="cap-td" style="text-align: left;" colspan="2">
					        </td>
					    </tr> -->
					</table>
		        </td>
		    </tr>
		</table>
	</div>
</div>
</body>
</html>
