<%
/**********************************************************************
* 页面建模基本信息
* 2015-5-13 肖威 新建
* 2015-6-10 郑重 修改
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@page import="com.comtop.cap.bm.metadata.page.desinger.model.PageUITypeEnum" %>
<!DOCTYPE html>
<html ng-app='pageInfoEdit'>
<head>
<meta charset="UTF-8">
<title>页面建模基本信息</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	 
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/PageAttributePreferenceFacade.js'></top:script>
	<script type="text/javascript">
	
	//获得传递参数
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
   	var modelPackage=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelPackage"))%>;
   	var globalReadState=eval(<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("globalReadState"))%>);
   	var saveType = window.parent.saveType;
   	var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	var pageSession = new cap.PageStorage(modelId);
	var page = pageSession.get("page");
	
	var pageUITypeData=[
	                    {id:'<%=PageUITypeEnum.FRAME_PAGE.getPageUIType()%>',text:'框架界面'},
	                    {id:'<%=PageUITypeEnum.LIST_PAGE.getPageUIType()%>',text:'列表查询界面'},
	                    {id:'<%=PageUITypeEnum.EIDT_PAGE.getPageUIType()%>',text:'编辑界面'},
	                    {id:'<%=PageUITypeEnum.TO_ENTRY_LIST_PAGE.getPageUIType()%>',text:'待上报列表查询界面'},
	                    {id:'<%=PageUITypeEnum.ENTRYED_LIST_PAGE.getPageUIType()%>',text:'已上报列表查询界面'},
	                    {id:'<%=PageUITypeEnum.TODO_LIST_PAGE.getPageUIType()%>',text:'待办列表查询界面'},
	                    {id:'<%=PageUITypeEnum.DONE_LIST_PAGE.getPageUIType()%>',text:'已办列表查询界面'},
	                    {id:'<%=PageUITypeEnum.VIEW_PAGE.getPageUIType()%>',text:'展现界面'}
	                    ];
	var _ = cui.utils;
	//拿到angularJS的scope
    var scope=null;
  	//监听页面参数变化，如果页面参数里面有包含配置的参数，则这些配置的参数在menu里面设为disable
    function disableMenu(){
    	//如果配置参数菜单没初始化，则把配置参数菜单进行初始化
		if(!wasInIted){
			cui('#configParam').setDatasource(pagePrametersData());
		}
		var _paramList = scope.page.pageAttributeVOList;
		//遍历menu菜单项
		_.each(parametersArray,function(config){
			//默认把菜单项先设为可操作
			cui('#configParam').disable(config.id,false);
			//遍历页面参数集合,看是否能找的到和当前菜单项一样的参数
    		var _tempObj = _.find(_paramList,function(item){
    			return item.attributeName == config.id;
    		});
    		//如果找到了，则菜单项设为disable。（如果没找到 _tempObj为undefined）
    		if(_tempObj){
    			cui('#configParam').disable(config.id,true);
    		}
		});
    }

  	/**
     * 选择页面参数。从元数据配置文件pageParameters.pageParameter.json中读取选择。
     * 读取defaultReference为false的数据。配在配置文件中的数据，userDefined应该也为false。
     */
    var parametersArray;
    var wasInIted = false; //表示menu是否初始化
    var pagePrametersData=function(){
    	wasInIted = true;
    	parametersArray = []; // 每次初始化之前都把parametersArray清空
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
		return parametersArray;
	};
	/**
	 * 点击选择参数图标的下拉选项，增加一条页面参数
	 *
	 */
	function insertReferenceAttribute(obj){
		scope.page.pageAttributeVOList.push({
			attributeName:obj.attributeName,
			attributeType:obj.attributeType,
			attributeValue:obj.attributeValue,
			attributeDescription:obj.attributeDescription,
			defaultReference:obj.defaultReference,
			userDefined:obj.userDefined,
			attributeSelectValues:obj.attributeSelectValues
		});
		cap.digestValue(scope);
		window.parent.sendMessage('pageStateFrame',{type:'pageAttributeChange',data:page.pageAttributeVOList});
	}
	
	angular.module('pageInfoEdit', [ "cui"]).controller('pageInfoEditCtrl', function ($scope, $timeout) {
		$scope.page=page;
		$scope.isCreateNewPage = ((!page.modelId || !page.modelName || saveType == "pageTemplate")) ? true : false;
		$scope.displayFlag = false;
		$scope.ready=function(){
	    	comtop.UI.scan();
	    	$scope.setReadonlyAreaState(globalReadState);
	    	$scope.initDefaultValue();
	    	scope=$scope;
	    	var reg = new RegExp("^100%|1024px|1280px$");
		    var minWidth = page.minWidth;
		   	if(!reg.test(minWidth)){
		    	setTimeout(function () {//minWidth值不在数据源中
			    	cui("#minWidth").$text[0].value = page.minWidth;
					cui("#minWidth").setValue(page.minWidth);
		    	});
		   	}
		   	var regPageMinWidth = new RegExp("^100%|600px|800px|1024px$");
		    var pageMinWidth = page.pageMinWidth;
		   	if(pageMinWidth && !regPageMinWidth.test(pageMinWidth)){
		    	setTimeout(function () {//minWidth值不在数据源中
			    	cui("#pageMinWidth").$text[0].value = page.pageMinWidth;
					cui("#pageMinWidth").setValue(page.pageMinWidth);
		    	});
		   	}
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
		    		cap.setReadonlyArea("unReadonlyArea", ["*:not([class^='notUnbind'],[id='actionType'])"], ["input[type='checkbox']"]);
		    	}, 0);
	    	}
		}
		
		//初始化默认值
		$scope.initDefaultValue=function(){
			$scope.page.hasPermission=$scope.page.modelId!=null?$scope.page.hasPermission:true;
			$scope.page.menuType=$scope.page.modelId!=null?$scope.page.menuType:1;
		}
		
		$scope.includeFileCheckAll=false;
		
		//监控全选checkbox，如果选择则联动选中列表所有数据
    	$scope.allCheckBoxCheck=function(ar,isCheck){
    		if(ar!=null){
    			for(var i=0;i<ar.length;i++){
	    			if(isCheck && !ar[i].defaultReference){
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
	    			
	    			if(!ar[i].defaultReference){
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
    	
    	$scope.batchDeleteIncludeFile=function(){
    		var newArr=[];
    		for(var i=0;i<$scope.page.includeFileList.length;i++){
    			if(!$scope.page.includeFileList[i].check){
    				newArr.push($scope.page.includeFileList[i]);
    			}
    		}
    		$scope.page.includeFileList=newArr;
    		$scope.preferenceFileChangeNotice();
    	}
    	
    	$scope.deleteIncludeFile=function(index){
    		page.includeFileList.splice(index,1); 
    		$scope.preferenceFileChangeNotice();
    	}
    	
    	$scope.deletePageAttribute=function(){
    		/* var newArr=[];
    		for(var i=0;i<$scope.page.pageAttributeVOList.length;i++){
    			if(!$scope.page.pageAttributeVOList[i].check){
    				newArr.push($scope.page.pageAttributeVOList[i]);
    			}
    		}
    		$scope.page.pageAttributeVOList=newArr; */
    		var iSize= $scope.page.pageAttributeVOList.length
    		for(var i=iSize-1;i>=0;i--){
    			if($scope.page.pageAttributeVOList[i].check){
    				$scope.page.pageAttributeVOList.splice(i,1);
    			}
    		}
    		
    	}
    	
    	$scope.insertAttribute=function(){
    		$scope.page.pageAttributeVOList.push({attributeName:'',attributeType:'String',attributeValue:'',attributeDescription:'',defaultReference:false,userDefined:true});
    	}
    	
    	//导入引入文件
    	$scope.importIncludeFileFile=function(){
    		var fileJsp = "${pageScope.cuiWebRoot}/cap/bm/dev/page/preference/IncludeFilePreference.jsp";
    		var params = "?fileType="+""
    		var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-800)/2;
    		window.open (fileJsp+params,'importIncludeFileFileWin','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
    	}
    	
    	$scope.insertIncludeFileFile=function(){
    		$scope.page.includeFileList.push({fileName:'',filePath:'',fileType:'js'});
    	}
    	
    	$scope.setFileName=function(includeFileVo){
    		if(includeFileVo.filePath!="" && includeFileVo.filePath!=null){
    			var filePaths=includeFileVo.filePath.split("/");
    			includeFileVo.fileName=filePaths[filePaths.length-1];
    		}
    		$scope.preferenceFileChangeNotice();
    	}
    	
    	//根据modelName生成页面URL和页面编码
    	$scope.$watch("page.modelName",function(){
    		if($scope.page.modelName!=null){
    			var prefix = pageSession.get("pageUrlPrefix");
    			var prefixReg = new RegExp(prefix);
    			var suffix = pageSession.get("pageUrlSuffix");
    			
    			var rootPath=modelPackage.replace(prefixReg,"");
        		rootPath=rootPath.replace(/\./g,"/");
        		$scope.page.url="/"+rootPath+"/"+$scope.page.modelName.replace(/(\w)/,function(v){return v.toLowerCase()})+suffix;
        		
        		var rootCode=modelPackage.replace("com.comtop.","");
        		rootCode=rootCode.replace(/\./g,"_");
        		$scope.page.code=rootCode+"_"+$scope.page.modelName.replace(/(\w)/,function(v){return v.toLowerCase()});
        		$scope.page.modelId=$scope.page.modelPackage+"."+page.modelType+"."+$scope.page.modelName;
        		//通知行为页面更新行为action调用名称
        		window.parent.sendMessage('actionFrame',{type:'pageModelNameChange',data:$scope.page.modelName});
    		}
    		
    		//新建保存之后，页面文件名称不能修改
        	if($scope.page.pageId && $scope.page.modelName){
        		$scope.isCreateNewPage=false;
    		}else{
    			$scope.isCreateNewPage=true;
    		}
        	cap.digestValue($scope);
    	});
    	
    	//当前页面是菜单时，菜单名称和菜单类型可填写
    	$scope.$watch("page.hasMenu",function(){
    		var hasMenu=$scope.page.hasMenu;
    		if(hasMenu){
    			cui("#menuType").setReadonly(false);
    			cui("#menuName").setReadonly(false);
    			
    			cap.validater.disValid('menuName', false);
    			cap.validater.validElement('required', ['menuName']);
    			
    		}else{
    			cap.validater.disValid('menuName', true);
    			//取消校验的对象需要被触发才可以取消红色校验框(不使用focus是因为文本框会高亮)
    			cui("#menuName").setValue('');
    			
    			cui("#menuType").setReadonly(true);
    			cui("#menuName").setReadonly(true);
    			
    		}
    		cap.digestValue($scope);
    	});
    	
    	$scope.$watch("page.pageAttributeVOList",function(){
    		disableMenu();
    	}, true);
    	
    	//从其他页面导入表达式
    	$scope.openCatalogSelect=function(){
    		var top=(window.screen.availHeight-600)/2;
    		var left=(window.screen.availWidth-400)/2;
    		window.open ('CatalogSelect.jsp?parentId='+scope.page.parentId,'CatalogSelectWin','height=600,width=400,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
    	}
    	
    	//关联界面原型
    	$scope.openCrudeUIIdsSelect=function(){
    		var top=(window.screen.availHeight-700)/2;
    		var left=(window.screen.availWidth-800)/2;
            var ptModelIds = cui("#crudeUIIds").getValue();
    		window.open ("${pageScope.cuiWebRoot}/cap/bm/req/prototype/design/uilibrary/SelectUrl.jsp?modelIds=" + ptModelIds + "&callbackMethod=chooseReqPageCallback",'ReqPageMulChooseWin','height=700,width=1000,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
    	}
    	
    	//引用文件更变通知
    	$scope.preferenceFileChangeNotice=function(){
    		window.parent.document.getElementById("desingerFrame").contentWindow.document.getElementById("ui-attr").contentWindow.postMessage({type:'pagePreferenceFileChange',data:null},"*");
    	}
    	
    	//显示和隐藏引入文件的列表
    	$scope.showOrHidenIncludeFiles=function(flag){
    		if(flag == undefined){
    			flag = false;
    		}
    		$scope.displayFlag = flag ? false : true;
    	}
    	
    });
	
	//选择界面原型
	function chooseReqPageCallback(propertyName, reqPageList){
		if(!reqPageList){
			return;
		}
		
        if(typeof reqPageList === "object") {
            reqPageList = [reqPageList];
        }

		var ids = "";
		var names="";
		reqPageList.forEach(function(item,index,_arr){
			ids += item.modelId + ";";
			names += item.cname + ";";
		});
		
		if(ids != ""){
			cui("#crudeUINames").setValue(names);
			cui("#crudeUIIds").setValue(ids);
		}
	}
	
	//选择文件后回调函数 selectedFiles为数组对象
	function refreshFiles(selectedFiles){
		//需要对文件列表进行操作，更新文件列表
		for(var i=0;i<selectedFiles.length;i++){
			var isAdd=true;
			for(var j=0;j<page.includeFileList.length;j++){
				if(page.includeFileList[j].filePath==selectedFiles[i].filePath){
					isAdd=false;
					break;
				}
			}
			
			if(isAdd){
				page.includeFileList.push(selectedFiles[i]);
				scope.preferenceFileChangeNotice();
			}
		}
		scope.$digest();
	}
	
	//设置上级目录
	function setCatalog(node){
		scope.page.parentName=node.title;
		scope.page.parentId=node.key;
		scope.$digest();
	}
	//添加页面监听 ，通过消息通讯处理方法回调等问题 
	window.addEventListener("message", messageHandle, false);
	
	/**
	 * 接收消息回调方法
	 * @param e 回调数据
	 */
	function messageHandle(e) {
    	if(e.data.type === 'pageAction'){
    		cap.digestValue(scope);
    	} 
    }
	
	//参数路径不能重复校验
    function validateIncludeFilePath(filePath){
    	return isExistValidate(page.includeFileList, 'filePath', filePath);
    }
    
    //参数名称不能重复校验
    function validatePageAttrName(attributeName){
    	return isExistValidate(page.pageAttributeVOList, 'attributeName', attributeName);
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
	
    //新增或修改的页面文件名是否已存在
    function isExistNewModelName(modelName){
    	var result = true;
    	if(scope.isCreateNewPage){
	    	dwr.TOPEngine.setAsync(false);
	    	PageFacade.isExistNewModelName(modelName,function(data){
	    		result = !data;
			});	
			dwr.TOPEngine.setAsync(true);
    	}
		return result;
    }
    
    //验证规则
    var pageModelNameValRule = [{type:'required',rule:{m:'页面属性->页面文件名不能为空'}},{type:'format', rule:{pattern:'\^[A-Z]\\w+\$', m:'页面属性->页面文件名只能输入由字母、数字或者下划线组成的字符串,且首字符必须为大写字母'}},{type:'custom',rule:{against:'isExistNewModelName', m:'页面属性->页面文件名称已存在'}}];
    var pageCnameValRule = [{type:'required',rule:{m:'页面属性->页面标题不能为空'}}];
    var pageParentNameValRule = [{type:'required',rule:{m:'菜单权限->上级菜单/目录不能为空'}}];
    var pageMenuNameValRule = [{type:'required',rule:{m:'菜单权限->菜单名称不能为空'}}];
    var includeFilePathValRule = [{type:'required',rule:{m:'文件路径不能为空'}},{type:'custom',rule:{against:'validateIncludeFilePath', m:'文件路径不能重复'}}];
    var pageAttrNameValRule = [{'type':'required', 'rule':{'m': '参数名称不能为空'}},{'type':'custom','rule':{'against':'validatePageAttrName', 'm':'参数名称不能重复'}}];
    var pageAttrDesValRule = [{'type':'required', 'rule':{'m': '参数描述不能为空'}}];
    var pageDesValRule = [{'type':'length', 'rule':{"max":500,"maxm":"页面描述长度不能大于500个字符"}}];
    
    //统一校验函数
	function validateAll(){
    	var validate = new cap.Validate();
    	
    	var valRule2Page = {modelName:pageModelNameValRule, cname:pageCnameValRule, parentName:pageParentNameValRule,description:pageDesValRule};
    	if(scope.page.hasMenu){
	    	valRule2Page.menuName = pageMenuNameValRule;
    	}
    	
    	var result = validate.validateAllElement(page,valRule2Page);
    	
    	var valRule2IncFilePath={filePath:includeFilePathValRule};
    	var validateResult = validate.validateAllElement(page.includeFileList,valRule2IncFilePath, "&diams;引入文件->第【{value}】行：");
    	result.validFlag=result.validFlag && validateResult.validFlag;
		if(!validateResult.validFlag){
			result.message+=validateResult.message+"<br/>";
		}
    	
    	var valRule2PageAttr={attributeName:pageAttrNameValRule, attributeDescription:pageAttrDesValRule};
    	validateResult = validate.validateAllElement(page.pageAttributeVOList,valRule2PageAttr, "&diams;页面参数->第【{value}】行：");
    	result.validFlag=result.validFlag && validateResult.validFlag;
		if(!validateResult.validFlag){
			result.message+=validateResult.message+"<br/>";
		}
		
		return result;
	}
	
	//保存按钮调用
    function validataPageInfoRequired(){
		var validate = new cap.Validate();
    	var valRule = {modelName:pageModelNameValRule,cname:pageCnameValRule, parentName:pageParentNameValRule};
    	return validate.validateAllElement(page,valRule);
    }
	</script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="pageInfoEditCtrl" data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" style="width:100%; height: 100%; text-align: center; overflow-y: auto">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="页面基本信息" class="cap-label-title" size="12pt"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>页面属性</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td>
		        	<table class="cap-table-fullWidth">
					    <tr>
					    	<td  class="cap-td" style="text-align: right;width:100px">
								<font color="red">*</font>页面文件名：
					        </td>
					        <td class="cap-td" style="text-align: left;" ng-switch="isCreateNewPage">
					        	<span cui_input ng-switch-when="true" id="modelName" ng-model="page.modelName" width="100%" validate="pageModelNameValRule"></span>
					        	<span cui_input ng-switch-default readonly="true" id="modelName" ng-model="page.modelName" width="100%"></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:100px">
					        	<font color="red">*</font>页面标题：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input  id="cname" ng-model="page.cname" width="100%" validate="pageCnameValRule"></span>
					        </td>
					    </tr>
					    <tr>
					        <td class="cap-td" style="text-align: right;width:100px">
					        	<font color="red">*</font>页面编码：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_pulldown id="charEncode" ng-model="page.charEncode" width="100%" value_field="id" label_field="text">
									<a value="UTF-8">UTF-8</a>
									<a value="GBK">GBK</a>
								</span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:100px">
					        	<font color="red">*</font>最小分辨率：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_pulldown id="minWidth" ng-model="page.minWidth" width="100%" must_exist="false" value_field="id" label_field="text" validate="[{'type':'format', 'rule':{'pattern': '^([0-9]*|100%|1024px|1280px)$', 'm':'自定义宽度必须为数字，系统默认以像素(px)为单位'}}]">
									<a value="100%">自适应</a>
									<a value="1024px">1024px</a>
									<a value="1280px">1280px</a>
								</span>
					        </td>
					    </tr>
					    <tr>
					    	 <td class="cap-td" style="text-align: right;width:100px">
					        	<font color="red">*</font>界面分类：
					        </td>
					        <td class="cap-td unReadonlyArea" style="text-align: left;">
					        	<span cui_pulldown id="pageUIType" class="notUnbind" ng-model="page.pageUIType" width="100%" value_field="id" label_field="text" datasource="pageUITypeData" select="1">
								</span>
					        </td>
					         <td  class="cap-td" style="text-align: right;width:100px">
					         	<span ng-if="page.minWidth=='100%'"><font color="red">*</font>最小宽度：</span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span  ng-if="page.minWidth=='100%'" cui_pulldown id="pageMinWidth" ng-model="page.pageMinWidth" width="100%" must_exist="false" value_field="id" label_field="text" validate="[{'type':'format', 'rule':{'pattern': '^([0-9]*|100%|600px|800px|1024px)$', 'm':'自定义宽度必须为数字，系统默认以像素(px)为单位'}}]">
									<a value="100%">自适应</a>
									<a value="600px">600px</a>
									<a value="800px">800px</a>
									<a value="1024px">1024px</a>
								</span>
					        </td>
					    </tr>
					    <tr>
					    	<td  class="cap-td" style="text-align: right;width:100px">
								引入文件：
					        </td>
					        <td class="cap-td" style="text-align: left;" colspan="5">
					        	<table class="custom-grid" style="width: 100%">
					                <thead>
					                    <tr>
					                    	<th style="width:30px">
					                    		<input type="checkbox" name="includeFileCheckAll" ng-model="includeFileCheckAll" ng-change="allCheckBoxCheck(page.includeFileList,includeFileCheckAll)">
					                        </th>
					                        <th class="notUnbind" ng-click="showOrHidenIncludeFiles(displayFlag)" style="cursor:pointer;">
				                            	文件路径(<a>点击{{displayFlag?'隐藏':'展开'}}默认引入文件</a>)
					                        </th>
					                        <th style="width:100px">
				                            	文件类型
					                        </th>
					                        <th style="width:150px">
				                            	<span class="cui-icon" title="选择引入文件" style="font-size:12pt;color:#545454;cursor:pointer;padding-right:10px" ng-click="importIncludeFileFile()">&#xf022;</span>
				                            	<span class="cui-icon" title="添加引入文件" style="font-size:12pt;color:#545454;cursor:pointer;padding-right:10px" ng-click="insertIncludeFileFile()">&#xf067;</span>
				                            	<span class="cui-icon" title="删除引入文件" style="font-size:14pt;color:rgb(255, 68, 0);cursor:pointer;padding-right:10px" ng-click="batchDeleteIncludeFile()">&#xf00d;</span>
				                            	<!-- <span class="cui-icon" title="展开/隐藏默认引入文件" style="font-size:12pt;color:#545454;cursor:pointer;" ng-init="displayFlag=true" ng-click="showOrHidenIncludeFiles(displayFlag)">{{displayFlag?'&#xf078;':'&#xf077;'}}</span> -->
					                        </th>
					                    </tr>
					                </thead>
			                        <tbody>
			                            <tr ng-repeat="includeFileVo in page.includeFileList track by $index" style="background-color: {{includeFileVo.check? '#99ccff':'#ffffff'}}" ng-hide="displayFlag==false && includeFileVo.defaultReference" >
			                            	<td style="text-align: center;" ng-if="!includeFileVo.defaultReference">
			                                    <input type="checkbox" name="{{'includeFileVo'+($index + 1)}}" ng-model="includeFileVo.check" ng-change="checkBoxCheck(page.includeFileList,'includeFileCheckAll')">
			                                </td>
			                                <td style="text-align:left;" ng-if="!includeFileVo.defaultReference">
			                                    <span cui_input  id="{{'filePath'+($index + 1)}}" ng-model="includeFileVo.filePath" width="100%" ng-change="setFileName(includeFileVo)" validate="includeFilePathValRule"></span>
			                                </td>
			                                <td style="text-align: center;" ng-if="!includeFileVo.defaultReference">
			                                	<span cui_pulldown id="{{'fileType'+($index + 1)}}" ng-model="includeFileVo.fileType" value_field="id" label_field="text" width="100%">
													<a value="js">js</a>
													<a value="css">css</a>
													<a value="jsp">jsp</a>
												</span>
			                                </td>
			                                <td style="text-align: center;" ng-if="!includeFileVo.defaultReference">
			                                	<span class="cui-icon" title="删除引入文件" style="font-size:14pt;cursor:pointer;color:rgb(255, 68, 0)" ng-click="deleteIncludeFile($index)">&#xf00d;</span>
			                                </td>
			                                
			                                <td style="text-align: center;" ng-if="includeFileVo.defaultReference">
			                                </td>
			                                <td style="text-align:left;" ng-if="includeFileVo.defaultReference">
			                                	{{includeFileVo.filePath}}
			                                </td>
			                                <td style="text-align: center;" ng-if="includeFileVo.defaultReference">
			                                	{{includeFileVo.fileType}}
			                                </td>
			                                <td style="text-align: center;" ng-if="includeFileVo.defaultReference">
			                                </td>
			                            </tr>
			                       </tbody>
					            </table>
					        </td>
					    </tr>
					    <!-- <tr>
							<td  class="cap-td" style="text-align: right;width:100px">
								<span id="remark" style="font-weight:bold;color:red ">说明：</span>
					        </td>
					        <td class="cap-td" style="text-align: left;">
					         	<span style="font-weight:bold;">点击<span class="cui-icon" title="展开/隐藏默认引入文件" style="font-size:12pt;color:#545454;cursor:pointer;" ng-click="showOrHidenIncludeFiles(displayFlag)">{{displayFlag?'&#xf078;':'&#xf077;'}}</span>{{displayFlag?'展开':'隐藏'}}默认引入文件</span>
					        </td>
					    </tr> -->
					</table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<hr/>
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>页面参数</span>
						</blockquote>
					</span>
					<hr/>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:100%">
		        	<table class="custom-grid" style="width: 100%">
		                <thead>
		                    <tr>
		                    	<th style="width:30px">
		                    		<input type="checkbox" name="pageAttributeCheckAll" ng-model="pageAttributeCheckAll" ng-change="allCheckBoxCheck(page.pageAttributeVOList,pageAttributeCheckAll)">
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
		                        <th style="width:200px">
	                            	默认值
		                        </th>
		                        <th style="width:150px">
                            		<span uitype="Menu" id="configParam" trigger="mouseover"  datasource="pagePrametersData" on_click="insertReferenceAttribute" class="cui-icon" style="font-size:11pt;color:#545454;cursor:pointer;padding-right:10px;" title="添加配置参数">&#xf03a;</span> 
	                            	<span class="cui-icon" style="font-size:12pt;color:#545454;cursor:pointer;padding-right:10px" ng-click="insertAttribute()" title="添加自定义参数">&#xf067;</span>
	                            	<span class="cui-icon" style="font-size:14pt;color:rgb(255, 68, 0);cursor:pointer;" ng-click="deletePageAttribute()" title="删除参数">&#xf00d;</span>
		                        </th>
		                    </tr>
		                </thead>
                        <tbody>
                            <tr ng-repeat="pageAttributeVo in page.pageAttributeVOList" style="background-color: {{pageAttributeVo.check ? '#99ccff':'#ffffff'}}">
                            	<td style="text-align: center;" >
                                    <input type="checkbox" name="{{'pageAttribute'+($index + 1)}}" ng-model="pageAttributeVo.check" ng-change="checkBoxCheck(page.pageAttributeVOList,'pageAttributeCheckAll')">
                                </td>
                                <td style="text-align:left;" >
                                    <span cui_input  id="{{'attributeName'+($index + 1)}}" ng-model="pageAttributeVo.attributeName" width="100%" validate="pageAttrNameValRule" readonly="{{!pageAttributeVo.userDefined}}" ></span>
                                </td>
                                <td style="text-align: left;" >
                                	<span cui_input  id="{{'attributeDescription'+($index + 1)}}" ng-model="pageAttributeVo.attributeDescription" width="100%" validate="pageAttrDesValRule" readonly="{{!pageAttributeVo.userDefined}}"></span>
                                </td>
                                <td style="text-align: center;" >
                                	<span cui_pulldown id="{{'attributeType'+($index + 1)}}" ng-model="pageAttributeVo.attributeType"  value_field="id" label_field="text" width="100%" readonly="{{!pageAttributeVo.userDefined}}">
										<a value="String">String</a>
										<a value="int">int</a>
										<a value="boolean">boolean</a>
										<a value="double">double</a>
									</span>
                                </td>
                                <td style="text-align: left;" ng-if="pageAttributeVo.userDefined">
                                	<span cui_input  id="{{'attributeValue'+($index + 1)}}" ng-model="pageAttributeVo.attributeValue" width="100%"></span>
                                </td>
                                
                                <td style="text-align: center;" ng-if="!pageAttributeVo.userDefined">
                                	<span cui_pulldown ng-if="pageAttributeVo.attributeSelectValues.length != 0" id="{{'attributeValue'+($index + 1)}}"  ng-model="pageAttributeVo.attributeValue" value_field="id" label_field="text" width="100%" datasource="{{pageAttributeVo.attributeSelectValues}}">
										<!-- <a value="readonly">只读模式</a>
										<a value="edit">编辑模式</a>
										<a value="textmode">文本模式</a> -->
									</span>
									<span cui_input ng-if="pageAttributeVo.attributeSelectValues.length == 0"  id="{{'attributeValue'+($index + 1)}}" ng-model="pageAttributeVo.attributeValue" width="100%"></span>
                                </td>
                                
                                <td style="text-align: center;">
                                	<span class="cui-icon" style="font-size:14pt;cursor:pointer;color:rgb(255, 68, 0)" ng-click="page.pageAttributeVOList.splice($index,1);" title="删除参数">&#xf00d;</span>
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
		        	<hr/>
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>菜单权限</span>
						</blockquote>
					</span>
					<hr/>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td>
		        	<table class="cap-table-fullWidth">
		        		 <tr>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	<font color="red">*</font>菜单/权限：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<input type="checkbox" name="hasPermission" ng-model="page.hasPermission"/><span style="font-size: 12px">是否需要授权</span>
					        	<input type="checkbox" name="hasMenu" ng-model="page.hasMenu"/><span style="font-size: 12px">是否是菜单</span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	<font color="red">*</font>菜单分类：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_radiogroup id="menuType" ng-model="page.menuType" name="menuType">
									<input type="radio" name="menuType" value="1" />业务菜单
									<input type="radio" name="menuType" value="2" />查询菜单
									<input type="radio" name="menuType" value="3" />统计菜单
								</span>
					        </td>
					    </tr>
					    <tr>
					    	<td  class="cap-td" style="text-align: right;width:120px">
								<font color="red">*</font>上级菜单/目录：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_clickinput id="parentName" ng-model="page.parentName" ng-click="openCatalogSelect()" width="100%" validate="pageParentNameValRule"></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	<font color="red">*</font>菜单名称：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input  id="menuName" ng-model="page.menuName" width="100%" validate="pageMenuNameValRule"></span>
					        </td>
					    </tr>
					    <tr>
					    	<td  class="cap-td" style="text-align: right;width:120px">
								访问url：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input  id="url" ng-model="page.url" readonly="true" width="100%"></span>
					        </td>
					        <td class="cap-td" style="text-align: right;width:120px">
					        	编码：
					        </td>
					        <td class="cap-td" style="text-align: left;">
					        	<span cui_input  id="code" ng-model="page.code" readonly="true" width="100%"></span>
					        </td>
					    </tr>
					</table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<hr/>
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>原型</span>
						</blockquote>
					</span>
					<hr/>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		     <tr>
		    	<td  class="cap-td" style="text-align: right;width:120px">
					界面原型：
		        </td>
		        <td class="cap-td" style="text-align: left;">
		        	<span cui_clickinput id="crudeUINames" ng-model="page.crudeUINames" ng-click="openCrudeUIIdsSelect()" width="42%"></span>
		        	<span cui_input id="crudeUIIds" ng-model="page.crudeUIIds" ng-show="false"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<hr/>
		        	<span>
			        	<blockquote class="cap-form-group">
							<span>描述</span>
						</blockquote>
					</span>
					<hr/>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;width:100%">
		        	<span cui_textarea id="description" ng-model="page.description" width="100%" height="50px"  validate="pageDesValRule"  maxlength="500"></span>
		        </td>
		    </tr>
		</table>
	</div>
</div>
</body>
</html>