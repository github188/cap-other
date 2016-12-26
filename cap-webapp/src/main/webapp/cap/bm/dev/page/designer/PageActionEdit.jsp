<%
/**********************************************************************
* 功能行为设计页面
* 2015-5-13 诸焕辉
* 2015-7-2	郑重 修改
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html ng-app='actionList'>
<head>
	<meta charset=UTF-8"/>
    <title>页面行为设计</title>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>
    <style type="text/css">
    	.codeArea{
    		width:100%; 
    		background: whitesmoke;
    		border-radius: 3.01px;
    		transition: border .3s linear 0s;
    		border: 1px solid #ccc;
    		padding: 4px 0;
    		margin-bottom: 5px;
			-moz-transition:border .3s linear 0s;
			-webkit-transition:border .3s linear 0s;
			-o-transition:border .3s linear 0s
		}
		.CodeMirror {
			width:100%;
			height: auto;
			background: rgb(232, 229, 229);
		}
		.code_btn_area {
			position: relative;
			float: right;
			margin-bottom: -15px;
			z-index: 10000;
			cursor: pointer;
		}
    </style>
    <top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/pageaction.js"></top:script>
	<top:script src="/cap/bm/common/zeroclipboard/ZeroClipboard.min.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ActionDefineFacade.js"></top:script>
	<top:script src="/cap/bm/req/prototype/js/common.js"></top:script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="actionListCtrl" data-ng-init="ready()">
<div class="cap-page">
	<div class="cap-area" style="width:100%;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span id="formTitle" uitype="Label" value="页面行为编辑" class="cap-label-title"></span>
		        </td>
		        <td class="cap-td" style="text-align: right; padding-right: 10px;">
		        	<span id="save" uitype="Button" label="确定" onclick="save()"></span>
		        	<span id="backToList" ng-show="showGobackBtn" uitype="Button" label="返回" onclick="backToList()"></span>
		        	<span id="cancle" uitype="Button" label="关闭" onclick="cancel()"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left">
		        	<table class="cap-table-fullWidth">
					    <tr>
					    	<td style="text-align: left;">
					    		<table class="cap-table-fullWidth">
								   <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="行为模板："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;width:35%" nowrap="nowrap">
								        	<span cui_clickinput id="methodTemplate" width="100%" ng-model="selectPageActionVO.actionDefineVO.modelName" ng-click="openSelectActionTmpWin()"></span>
									    </td>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<span uitype="Label" value="描述："></span>
								        </td>
								        <td class="cap-td" valign="top" style="text-align: left;width:35%; padding-right: 5px;" rowspan="3">
							   				<span cui_textarea id="description" ng-model="selectPageActionVO.description" height="92" width="100%"></span>
								        </td>
								    </tr>
								    <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="行为英文名称："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;" ng-if="selectPageActionVO.actionDefineVO.specialMethod==null||selectPageActionVO.actionDefineVO.specialMethod==false">
								         	<span cui_input id="ename" ng-model="selectPageActionVO.ename" width="100%" validate="actionEnameValRule"/>
								        </td>
								        <td class="cap-td" style="text-align: left;" ng-if="selectPageActionVO.actionDefineVO.specialMethod!=null&&selectPageActionVO.actionDefineVO.specialMethod==true">
								         	<span readonly="true" cui_input id="ename" ng-model="selectPageActionVO.ename" width="100%" validate="actionEnameValRule"/>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px">
								        </td>
								    </tr>
								    <tr>
								        <td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">
								        	<font color="red">*</font><span uitype="Label" value="行为中文名称："></span>
								        </td>
								        <td class="cap-td" style="text-align: left;">
							   				<span cui_input id="cname" ng-model="selectPageActionVO.cname" width="100%" validate="actionCnameValRule"/>
								        </td>
								        <td class="cap-td" style="text-align: right;width:100px">
								        </td>
								    </tr>
								</table>
								<table ng-if="selectPageActionVO.actionDefineVO.modelId!=null" class="cap-table-fullWidth" cui_property id="newProperty" ng-model="selectPageActionVO"></table>
								<table class="cap-table-fullWidth">
								    <tr>
								        <td class="cap-td" style="text-align: left;padding-right: 7px;">
								        	<div class="code_btn_area">
								        		<input type="button" id="transferActionBtn" ng-if="hasShowTransferActionBtn" onclick="wrapTransferCustomAction()" value="转自定义行为"/>
									        	<input type="button" class="copyToClipboardBtn" ng-show="codemirrors[selectPageActionVO.pageActionId].length > 0" id="copyToClipboardBtn" value="复制"/>
								        	</div>
								        	<div class="codeArea" ng-if="codemirrors[selectPageActionVO.pageActionId].length > 0">
								        		<span cui_code ng-repeat='codemirrorVO in codemirrors[selectPageActionVO.pageActionId]' id="{{codemirrorVO.id}}" ng-model="codemirrorVO.form" ng-code="codemirrorVO.code" ng-out="codemirrorVO.out"></span>
								        	</div>
								        </td>
								    </tr>
								</table>
					    	</td>
					    </tr>
					</table>
		        </td>
		    </tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	var pageId="<%=request.getParameter("modelId")%>";
	var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	//绑定控件的id标示
	var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
	var operationType=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("operationType"))%>;
	//返回用
	var methodTemplate=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("methodTemplate"))%>;
	//行为类型
	var actionType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("actionType"))%>;
	//行为编辑用，选中的行为ID
	var selectActionId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("selectActionId"))%>;
	var pageSession = new cap.PageStorage(pageId);
	var pageActions = pageSession.get("action");
	var type = "<c:out value='${param.type}'/>";
	var root = {
		pageActions: operationType == "edit" ? jQuery.extend(true, [], pageActions) : pageActions
	}
	
	//点击确定后，通知到行为页面
	function updateActions(objPageAction){
		setMethodBody();
		setPageAttribute();
		cap.MessageManager.getInstance("sendMessage").sendMessage('actionFrame',{type:'pageActionChange',data:objPageAction});
	}
	
	//拿到angularJS的scope
	var scope=null;
	angular.module('actionList', ["cui"]).controller('actionListCtrl', function ($scope) {
	   	$scope.root=root;
	   	$scope.codemirrors={};
	   	$scope.pageActionsCheckAll=false;
	   	$scope.hasShowTransferActionBtn=false;
	   	$scope.showGobackBtn = cui.utils.param.showGobackBtn ? cui.utils.param.showGobackBtn === 'true' : window.history.length > 1;
	   	$scope.ready=function(){
	    	comtop.UI.scan();
	    	scope=$scope;
	    	if(operationType=="insert"){
		   		$scope.selectPageActionVO={};	
		   	}else if(operationType=="edit"){
		   		if(root.pageActions.length>0){
		   			for(var i in root.pageActions){
		   				if(root.pageActions[i].pageActionId == selectActionId){
		   					$scope.selectPageActionVO = root.pageActions[i];
		   					break;
		   				}
		   			}
		   		}
		   	}else{
		   		$scope.selectPageActionVO=root.pageActions.length>0?root.pageActions[0]:{};
		    }
	    	
	    	$scope.init();
	    	//自动新增一个行为
	    	if(operationType=="insert"){
	    		addPageAction();
	    		initSelectActionTmp();
	    	} 
	    	setTimeout(transferActionBtnState, 0);
	    	loadActionPropertyjs($scope.selectPageActionVO);
	    }
	   	
	   	$scope.init=function(){
	   		for(var i=0;i<$scope.root.pageActions.length;i++){
	   			var pageAction=$scope.root.pageActions[i];
	   			initCodemirrors(pageAction,pageAction.actionDefineVO);
	   		}
	   	}
	   	
	   	/**
		 * 打开window原生窗口
		 * @param event
		 * @param self
		 */
		 $scope.openSelectActionTmpWin=function(){
			var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/actionlibrary/ActionTemplateList.jsp?callbackMethod=selectActionTmp&type=' + type;
			var width=650; //窗口宽度
		    var height=550;//窗口高度
		    var top=(window.screen.height-30-height)/2;
		    var left=(window.screen.width-10-width)/2;
		    window.open(url, "_blank", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}
	});
	
	//动态加载行为属性控件中的js函数
	function loadActionPropertyjs(actionVO){
		if(actionVO.actionDefineVO&&actionVO.actionDefineVO.properties){
			for(var k=0;k<actionVO.actionDefineVO.properties.length;k++){
				var objProperty = actionVO.actionDefineVO.properties[k];
				if(objProperty&&objProperty.propertyEditorUI&&objProperty.propertyEditorUI.operation&&$.trim(objProperty.propertyEditorUI.operation) != ''){
					try{
						$("<script type='text/javascript'>" + objProperty.propertyEditorUI.operation + "<\/script>").appendTo("head");  //动态加载函数	
					}catch(e){
						console.log("function不规范：\n"+objProperty.propertyEditorUI.operation);
					}
				}
			}
		}
	}

	//新增行为
	function addPageAction(){
		var pageActionId=(new Date()).valueOf();
		var newPageAction = {
				pageActionId:pageActionId+"",cname:'',ename:'',
				description:'',methodTemplate:'',methodTemplateId:'',methodOption:{},methodBodyExtend:{},
				methodBody:'',actionDefineVO:{}
			};
		//scope.root.pageActions.push(newPageAction);
		scope.selectPageActionVO=newPageAction;

	}
	
	//根据行为控件绑定的行为模板初始化
	function initSelectActionTmp(){
		//根据行为控件绑定的行为模板初始化
		if(methodTemplate && methodTemplate != "" && methodTemplate != "null"){
			var data;
			dwr.TOPEngine.setAsync(false);
			ActionDefineFacade.loadModelByModelId(methodTemplate, function(_data){
				data = _data;
			});
			dwr.TOPEngine.setAsync(true);
			if(data){
				selectActionTmp(data);
			}
		}
	}

	/**
	 * 选择行为类型回调函数
	 * @param obj 行为模版对象
	 */
	function selectActionTmp(obj){
		if(obj.specialMethod!=null && obj.specialMethod===true){
			scope.selectPageActionVO.ename=obj.methodName;
			scope.selectPageActionVO.cname=obj.methodCname;
			scope.selectPageActionVO.description=obj.methodDescription;
		} else {
			if(scope.selectPageActionVO.ename == null || scope.selectPageActionVO.ename == ''){
				scope.selectPageActionVO.ename=obj.modelName;
			}
			if(scope.selectPageActionVO.cname == null || scope.selectPageActionVO.cname == ''){
				scope.selectPageActionVO.cname=obj.cname;
			}
			if(scope.selectPageActionVO.description == null || scope.selectPageActionVO.description  == ''){
				scope.selectPageActionVO.description=obj.description;
			}
		}
		
		//读取依赖行为信息，同时新增依赖行为
		if(obj.dependActions!=null && obj.dependActions!=undefined && obj.dependActions.length>0){
			for(var i=0; i<obj.dependActions.length; i++){
				var dependActionsrc = obj.dependActions[i];
				var pageActionId=(new Date()).valueOf();
				var denpendPageAction = {
						pageActionId:pageActionId+"",cname:'',ename:'',
						description:'',methodTemplate:'',methodTemplateId:'',methodOption:{},methodBodyExtend:{},
						methodBody:'',actionDefineVO:{}};
				
				denpendPageAction.cname = dependActionsrc.cname;
				denpendPageAction.ename = dependActionsrc.modelName;
				denpendPageAction.description = dependActionsrc.description;
				denpendPageAction.methodTemplate = dependActionsrc.modelId;
				denpendPageAction.methodOption = {};
				denpendPageAction.methodBodyExtend = {};
				denpendPageAction.actionDefineVO = dependActionsrc;
				initCodemirrors(denpendPageAction,dependActionsrc);
				scope.root.pageActions.push(denpendPageAction);
			}
		}
		
		scope.selectPageActionVO.actionDefineVO=obj;
		scope.selectPageActionVO.initPropertiesCount=obj.properties.length;
		scope.selectPageActionVO.methodTemplate = obj.modelId;
		//清空行为参数和用户输入代码
		scope.selectPageActionVO.methodOption={};
		scope.selectPageActionVO.methodBodyExtend={};
		//获取行为模版属性集合
		var properties=scope.selectPageActionVO.actionDefineVO.properties;
		if(properties != null && properties != ''){
			for(var i in properties){
				scope.selectPageActionVO.methodOption[properties[i].ename] = properties[i].defaultValue;
			}
		}
		initCodemirrors(scope.selectPageActionVO,obj);
		//加载行为属性控件中绑定的js函数
   		loadActionPropertyjs(scope.selectPageActionVO);
		cap.digestValue(scope);
		transferActionBtnState();
	}
	
	//打开实体服务选择界面
	function openEntityMethodSelectWindow(isGenerateParameterForm,isTree,actionReLoadMethodName,objHtml) {
		var b=isGenerateParameterForm!=null?isGenerateParameterForm:true;
		var f=actionReLoadMethodName!=null?actionReLoadMethodName:false;
		var propertyName = "";
		if(objHtml&&objHtml!=null&&objHtml!=""){
		  propertyName = objHtml.id;
	    }
	    var url = "${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/EntityServiceSelect.jsp?packageId="+packageId+"&isGenerateParameterForm="+b+"&propertyName="+propertyName;
	    if(isTree){
			url = "${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/EntityServiceSelect.jsp?packageId="+packageId+"&isGenerateParameterForm="+b+"&isTree=true"+"&actionReLoadMethodName="+f+"&propertyName="+propertyName;
		}
		if(f!=false){
			url  += ("&isTree=false&actionReLoadMethodName="+f);
		}
	    var top=(window.screen.availHeight-600)/2;
	    var left=(window.screen.availWidth-800)/2;
	    window.open (url,'EntityServiceSelectWin','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
	}
	
	//选择实体方法回调
	function entityServiceSelectCallBack(data,isGenerateParameterForm,isTree,actionReLoadMethod,propertyName) {
		scope.selectPageActionVO.methodOption.isGenerateParameterForm=isGenerateParameterForm;
		var f=actionReLoadMethod!=null?actionReLoadMethod:false;
		if(f=="saveAndAudit"){
			scope.selectPageActionVO.methodOption.actionReLoadMethodName=data.aliasName;
			//设置方法ID
			scope.selectPageActionVO.methodOption.actionReLoadMethodId=data.entity.modelId + "/" + data.engName; 
			cap.digestValue(scope);
			return;
		}
		var propertiesAr=[];
		var initPropertiesCount=scope.selectPageActionVO.initPropertiesCount;
		for(var i=0;i<initPropertiesCount;i++){
			propertiesAr.push(scope.selectPageActionVO.actionDefineVO.properties[i]);
		}
		//设置实体方法名
		if(propertyName&&propertyName!=null&&propertyName!=""){
			scope.selectPageActionVO.methodOption[propertyName]=data.aliasName;
		}else{
		    scope.selectPageActionVO.methodOption.actionMethodName=data.aliasName;
		}
		//设置方法ID
		scope.selectPageActionVO.methodOption.methodId=data.entity.modelId + "/" + data.engName; 
		//设置实体别名Id
		if(data.entity.aliasName){
			var aliasEntityId="";
			var modelIds=data.entity.modelId.split(".");
			for(var i=0;i<modelIds.length;i++){
				if(i==(modelIds.length-1)){
					aliasEntityId += data.entity.aliasName.charAt(0).toUpperCase() + data.entity.aliasName.substring(1);
				}else{
					aliasEntityId += modelIds[i]+".";
				}
			}
			scope.selectPageActionVO.methodOption.aliasEntityId=aliasEntityId;
		}
		//设置实体ID
		scope.selectPageActionVO.methodOption.entityId=data.entity.modelId;
		
		//设置方法返回值来源
		scope.selectPageActionVO.methodOption.returnSource=data.returnType.source;
		//设置方法返回类型
		//scope.selectPageActionVO.methodOption.returnType=data.returnType;
		//设置方法参数类型
		scope.selectPageActionVO.methodOption.paramType = data.parameters ? JSON.stringify(data.parameters) : '';
		if(isGenerateParameterForm!="false"){
			//设置返回值
			var isReturnType=data.returnType.type != "void";
			if(isReturnType){
				scope.selectPageActionVO.methodOption.returnValueBind="";
				var property={cname:'返回值',ename:"returnValueBind",type:'String',requried:true,'default':'',propertyEditorUI:{componentName:'cui_clickinput',script:'{"ng-model":"returnValueBind","onclick":"openDataStoreSelect(\'returnValueBind\')"}'}};
				propertiesAr.push(property);
			}
			
			if(data.parameters){
				var parameterCount=data.parameters.length;
				var methodParameter="";
				if(parameterCount>0){
					for(var i=1;i<=parameterCount;i++){
						scope.selectPageActionVO.methodOption["methodParameter"+i]="";
						methodParameter += "{{"+"methodOption.methodParameter"+i+"}}"+",";
						var property={cname:"参数"+i,peopertName:data.parameters[i-1].engName,ename:"methodParameter"+i,type:'String',requried:true,'default':'',propertyEditorUI:{componentName:'cui_clickinput',script:'{"ng-model":"methodParameter'+i+'","onclick":"openDataStoreSelect(\'methodParameter'+i+'\')"}'}};
	                    propertiesAr.push(property);
					}
				}
				scope.selectPageActionVO.methodOption.methodParameter=methodParameter.substring(0,methodParameter.length-1);
			}
			scope.selectPageActionVO.actionDefineVO.properties=propertiesAr;
		}
		initCodemirrors(scope.selectPageActionVO,scope.selectPageActionVO.actionDefineVO);
		cap.digestValue(scope);
	}
	
	/**
	 * 初始化文本域
	 * @param obj 行为对象
	 */
	function initCodemirrors(pageActionVO,obj){
		if(obj.script!=null){
			//1、替换scrip模版常量占位符，值在page对象中取（重新加载页面时候）
			var attr=pageSession.get("page");
			var script="";
			script = replaceScriptTmpPlaceholders(obj.script,attr);
			script = replaceScriptTmpPlaceholders(script,pageActionVO.methodOption);
			var array = script.split("\n");
			//2、获取可编辑区域占位块，如：（<script name="before"/>）
			var patt = new RegExp(/<script name=\"\w+\"\/>/);
			//新增codemirrors数组，每一个数组存放一个js文本域，cui_code指令使用到该数组
			scope.codemirrors[pageActionVO.pageActionId]=[];
			//3、行为方法体扩展methodBodyExtend和codemirrors赋值步骤；codemirrors数组对象中的id是序号即是不可编辑文本域，id=key则是可编辑部分；
			var code = '';
			var index = 0;
			for(var i=0, len=array.length; i<len; i++){
				if(patt.test(array[i])){
					var startIndex = array[i].indexOf('"')+1;
					var endIndex = array[i].lastIndexOf('"');
					var key = array[i].substring(startIndex, endIndex);
					//行为方法体扩展（用于开发人员扩展代码）
					if(pageActionVO.methodBodyExtend[key]==null){
						pageActionVO.methodBodyExtend[key]="";
					}else{
						pageActionVO.methodBodyExtend[key]=pageActionVO.methodBodyExtend[key];
					}
					scope.codemirrors[pageActionVO.pageActionId].push({id:index++, form:pageActionVO, code:code, out: ""});
					scope.codemirrors[pageActionVO.pageActionId].push({id:key, form:pageActionVO, code:'', out: pageActionVO.methodBodyExtend[key]});
					code ='';
				} else {
					code += (code != '' ? "\n": '') + array[i];
					if(i == len-1){
						scope.codemirrors[pageActionVO.pageActionId].push({id:index++, form:pageActionVO, code:code, out: ""});
					}
				} 
			}
			//cap.digestValue(scope);
		}
	}
	
	/**
	 * 替换script模版常量占位符
	 * @param script js函数模版
	 */
	function replaceScriptTmpPlaceholders(script,object){
		if(script!=null){
			var constantPlaceholders = script.match(/\\${\w+}/g);
			for(var i in constantPlaceholders){
				//去除'${'和'}'
				var name = constantPlaceholders[i].substring(2, constantPlaceholders[i].length-1);
				if(eval("object."+name)!=null){
					script = script.replace(constantPlaceholders[i], eval("object."+name));
				}
			}
		}
		return script;
	}
	
	//打开数据模型选择界面
	function openDataStoreSelect(flag,isWrap,objHtml) {
		if(type == 'req') {
			openReqProtoTypePageSelect(flag, isWrap);
			return;
		}

		var url = 'DataStoreSelect.jsp?packageId=' + packageId+"&modelId="+pageId+"&isWrap="+isWrap;
		if(flag=="pageURL"||flag=="forwardUrl"){
			url += "&selectType=url";
		}else if(flag=="dataStore"||flag=="queryCondition"){
			url += "&selectType=dataStore";
		}else if(flag=="returnValueBind"){
			var returnValueSource = scope.selectPageActionVO.methodOption.returnSource;
			url += getReturnValueBindSelectSource(returnValueSource);
		}else if(flag.indexOf("methodParameter")>-1){
			var methodParameterType = eval("("+ scope.selectPageActionVO.methodOption.paramType +")");
			url += getMethodParameterSelectType(methodParameterType,flag);
		}
		if(objHtml&&objHtml!=null&&objHtml!=""){
			flag = objHtml.id;
		}
		url += "&flag="+flag;
		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
		window.open (url,'openDataStoreSelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
	}

	//打开数据模型选择界面
	function openReqProtoTypePageSelect(flag,isWrap) {
		var url;
		if(flag == 'pageURL' || flag=="forwardUrl" ) {
			url = webPath + '/cap/bm/req/prototype/design/uilibrary/SelectUrl.jsp'+ '?callbackMethod=pageSelectCallBack&propertyName=' + flag + '&value=' + scope.selectPageActionVO.methodOption.pageURL;
			url += '&reqFunctionSubitemId=' + pageSession.get('page').functionSubitemId;
		}
		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
		window.open (url,'openDataStoreSelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
	}
		
	function pageSelectCallBack(propertyName, value) {
		// console.log(propertyName, value);
		scope.selectPageActionVO.methodOption[propertyName] = '"' + cap.getRelativeURL(value.url, pageSession.get('page').modelPackage) + '"';
		cap.digestValue(scope);
	}
	
	//根据方法返回值类型获取选择数据的方式
	function getReturnValueBindSelectSource(returnValueSource){
		if(returnValueSource){
			if(returnValueSource == "javaObject" || returnValueSource == "collection" || returnValueSource == "entity" || returnValueSource == "thirdPartyType"){
				return "&selectType=dataStore";
			}else{
				return "&selectType=attribute";
			}
		}
	}
	
	//根据方法参数类型获取选择数据的方式
	function getMethodParameterSelectType(methodParameterType,flag){
		if(methodParameterType && methodParameterType.length && methodParameterType.length > 0) {
			for(var i=0;i<methodParameterType.length;i++){
				var objParameter = methodParameterType[i];
				var count = 1+i;
				var parameter = "methodParameter" + count;
				if(flag==parameter){
					if(objParameter.dataType.source=="javaObject"||objParameter.dataType.source=="collection"||objParameter.dataType.source=="entity"||objParameter.dataType.source=="thirdPartyType"){
						return "&selectType=dataStore";
					}else{
						return "&selectType=attribute";
					}
				}
			}
		}
	}
	
	//数据模型选择回调
	function importDataStoreVariableCallBack(variableSelect,flag,isWrap){
		if(!variableSelect || variableSelect === '') {
				scope.selectPageActionVO.methodOption[flag] = null;
		} else if(typeof(variableSelect) == "object"){
			var value=variableSelect.ename;
			if(isWrap=="true"){
				value="@{"+value+"}";
			}
			eval("scope.selectPageActionVO.methodOption."+flag+"='"+value+"';")
		}else{
			var value=variableSelect;
			if(isWrap=="true"){
				value="@{"+value+"}";
			}
			eval("scope.selectPageActionVO.methodOption."+flag+"='"+value+"';");
		}
		cap.digestValue(scope);
	}
	
	//打开页面选择界面
	function openPageSelect() {
		if(type == 'req') {
			openReqProtoTypePageSelect('pageURL', null);
			return;
		}

		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
		window.open('CopyPageListMain.jsp?systemModuleId='+packageId,"copyPageWin",'height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
	}
	
	//页面选择，回调
	function selectPageData(selectPageDate){
		scope.selectPageActionVO.methodOption.pageURL=selectPageDate.url;
		var ar=[];
		for(var i=0;i<selectPageDate.pageAttributeVOList.length;i++){
			var pageAttributeVO=selectPageDate.pageAttributeVOList[i];
			ar.push({attributeName:pageAttributeVO.attributeName,attributeDescription:pageAttributeVO.attributeDescription,attributeValue:''});
		}
		scope.selectPageActionVO.methodOption.pageAttributeVOList=ar;
		cap.digestValue(scope);
	}
	
	//设置方法体
	function setPageAttribute(){
		if(scope.selectPageActionVO.methodOption!=null){
			var pageAttributeVOList=scope.selectPageActionVO.methodOption.pageAttributeVOList;
			if(pageAttributeVOList!=null){
				scope.selectPageActionVO.methodOption.pageAttributeVOString=cui.utils.stringifyJSON(pageAttributeVOList);
			}
		}
	}
	
	//打开页面控件选择页面
	function openComponentSelect(selectMode,objHtml){
		var propertyName = "";
		if(objHtml&&objHtml!=null&&objHtml!=""){
		 propertyName = objHtml.id;
		}
		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-500)/2;
		window.open ('PageComponentSelect.jsp?pageId='+pageId+"&selectMode="+selectMode+"&propertyName="+propertyName,'pageComponentSelect','height=600,width=600,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
	}
	
	//导入控件
	function getSelectData(node,propertyName){
		var uiData=node.getData();
		var uiId="";
		if(uiData.options.id!=null){
			uiId=uiData.options.id;
		}else{
			uiId=uiData.id;
		}
		if(propertyName&&propertyName!=null&&propertyName!=""){
			scope.selectPageActionVO.methodOption[propertyName]=uiId
		}else{
			scope.selectPageActionVO.methodOption.relationGridId=uiId;	
		}
		cap.digestValue(scope);
	}
	
	//返回行为元数据
	function getActionList(type){
		var pageActions=scope.root.pageActions;
		var ar=[];
		for(var i=0;i<pageActions.length;i++){
			if(type!=null){
				for(var j=0;j<type.length;j++){
					if(pageActions[i].methodTemplate==type[j]){
						ar.push({id:pageActions[i].ename,text:pageActions[i].ename});
					}
				}
			}else{
				ar.push({id:pageActions[i].ename,text:pageActions[i].ename});
			}
		}
		return ar;
	}
	
	//行为英文名称校验对象
	var actionEnameValRule = [{'type':'required', 'rule': {'m':'行为英文名称：不能为空'}},{'type':'custom', 'rule':{'against':'isExistActionEname', 'm':'行为英文名称：已存在'}}];
	var actionCnameValRule = [{'type':'required', 'rule':{'m': '行为中文名称：不能为空'}}];
	
	/**
	 * 行为英文名称是否重复检验
	 * @param ename 行为英文名称
	 */
	function isExistActionEname(ename) {
		var ret = true;
		var cuiVal = cui("#ename").getValue();
		if (typeof (ename) == 'undefined') {
			ename = cuiVal;
		} else if(ename != cuiVal){
			return ret;
		}
		if(operationType=="insert"){
			for ( var i in root.pageActions) {
				if (ename == root.pageActions[i].ename) {
					ret = false;
					break;
				}
			}
		}else if(operationType=="edit"){
			//num=1表示当前值
			var num = 0;
			for ( var i in root.pageActions) {
				if (ename == root.pageActions[i].ename) {
					num++;
				}
				if (num > 1) {
					ret = false;
					break;
				}
			}
		}
		return ret;
	}
	
	//统一校验函数
	function validateAll() {
		var validate = new cap.Validate();
		var valRule = {
			ename : actionEnameValRule,
			cname : actionCnameValRule
		};
		var result = validate.validateAllElement(root.pageActions, valRule);
		return result;
	}
	
	//返回到行为选择页面
	function backToList(){
		var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionSelect.jsp?modelId='+pageId+'&packageId='+packageId+"&flag="+ flag+"&methodTemplate="+methodTemplate+"&actionType="+actionType;
		window.location = url;
	}
	
	//取消按钮，当是新增时的取消时，需要把行为给删除掉
	function cancel(){
		window.close();
	}
	
	//确定，把新增的行为直接添加到控件上
	function save(){
		if(!isExistActionEname()){
			cui.alert("行为英文名称：已存在");
			return ;
		}
	    var result=validateAll();
	    if(!result.validFlag){
			cui.alert(result.message);
			return false;
		}else{
			//通知行为被修改了
			updateActions(scope.selectPageActionVO);
			window.opener.selectPageActionData(scope.selectPageActionVO,flag);
			window.close();
		}
	}
	
	//转为自定义行为模版
	function wrapTransferCustomAction(){
		setMethodBody();
		setPageAttribute();
		transferCustomAction();
	}
	
	//先拼接函数代码，在判断是否要隐藏“转自定义行为”按钮
	function transferActionBtnState(){
		setMethodBody();
		cap.digestValue(scope);
	}
	
	var clip = new ZeroClipboard(document.getElementById("copyToClipboardBtn"));
	clip.on("copy",function(e){
		setMethodBody();
		clip.setText(scope.selectPageActionVO.methodBody);
		cui.message('已成功复制到剪切板。', 'success');
	});
</script>
</body>
</html>