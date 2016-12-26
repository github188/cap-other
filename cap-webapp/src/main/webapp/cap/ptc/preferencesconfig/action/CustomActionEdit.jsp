<%
/**********************************************************************
* 自定义行为编辑页面
* 2015-11-1 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='customActionEdit'>
<head>
<style>

</style>
<meta charset="UTF-8">
<title> 自定义行为编辑页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
    <top:link href="/cap/bm/test/css/icons.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>  
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>      
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>   
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>	
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>	  	
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ActionDefineFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/ResourceFacade.js"></top:script>	
	<style type="text/css">
    	.codeArea{
    		width:98%; 
    		background: whitesmoke;
    		border-radius: 3.01px;
    		transition: border .3s linear 0s;
    		border: 1px solid #ccc;
			-moz-transition:border .3s linear 0s;
			-webkit-transition:border .3s linear 0s;
			-o-transition:border .3s linear 0s
		}
		.CodeMirror {
			width:100%;
			height: 99.5%;
			background: rgb(232, 229, 229);
		}
		.code_btn_area {
			position: relative;
			float: right;
			margin-bottom: -30px;
			margin-right:45px;
			z-index: 10000;
			cursor: pointer;
		}
    </style> 
	<script type="text/javascript">
	var modelId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("modelId"))%>;
	var data={};
	//需要删除的文件
	var jsAndCssArr =[];
	var editor;
	var scope;
	angular.module('customActionEdit', ["cui"]).controller('customActionEditCtrl', function ($scope) {
		$scope.properties=[];
		$scope.files=[];
		
		$scope.ready=function(){
			scope=$scope;
			if(modelId!=null&&modelId!=""){
				initData();
			}else{
				data.properties = [];
				data.js=[];
				data.css=[];
				data.script='/*\n* {{cname}} {{description}}\n*/\nfunction {{ename}}() { \n \n\t<script name="content"/>\n    \n}';
				$scope.properties = data.properties;
			}
	    	initCodeMirror();
	    	comtop.UI.scan();
	    	if(modelId!=null&&modelId!=""){
	    	cui("#modelName").setReadonly(true);
	    	cui("#modelPackageCnName").setReadonly(true);
	    	}
	    };
	    
		//全选
		$scope.allCheckBoxCheck=function(arr,isCheck){
			if(arr!=null){
				for(var i=0;i<arr.length;i++){
					if(isCheck){
						arr[i].check=true;
					}else{
						arr[i].check = false;
					}
				}
			}
		}
		
		$scope.fileTdClick=function(fileVO){
			if(fileVO.check){
				fileVO.check=false;
			}else{
				fileVO.check=true;
			}
			$scope.checkBoxCheck($scope.files,'fileCheckAll');
		}
		
		
		 $scope.changeRequried=function(requried,flag){
			 if(requried=="true"){
				 var script = eval("("+scope.properties[flag].propertyEditorUI.script+")");
				 if(script.validate!=""&&script.validate!=null){
					 var propertyValidate = eval(script.validate);
					 var validate = {type:'required',rule:{m:'不能为空'}};
					 propertyValidate.push(validate);
					 script.validate=JSON.stringify(propertyValidate);
					 script.validate = script.validate.replace(new RegExp(/\"/g),"\'");
			    	 scope.properties[flag].propertyEditorUI.script =JSON.stringify(script);
				 }else{//如果validate为空
					 var validate = {type:'required',rule:{m:'不能为空'}};
				     var propertyValidate = [];
					 propertyValidate.push(validate);
					 script.validate=JSON.stringify(propertyValidate);
					 script.validate = script.validate.replace(new RegExp(/\"/g),"\'");
			    	 scope.properties[flag].propertyEditorUI.script =JSON.stringify(script);
				 }
			 }else{
				 var script = eval("("+scope.properties[flag].propertyEditorUI.script+")");
				 if(script.validate!=""&&script.validate!=null){
				    var propertyValidate = eval(script.validate);
				    var iDelFlag = -1;
				    for(var i=0;i<propertyValidate.length;i++){
				    	var validate = propertyValidate[i];
				    	if(validate.type==="required"&&validate.rule&&validate.rule.m&&validate.rule.m=="不能为空"){
				    		iDelFlag = i;
				    		break;
				    	}
				    }
				    if(iDelFlag != -1){
				    	propertyValidate.splice(iDelFlag,1);
			    		script.validate=JSON.stringify(propertyValidate);
			    		script.validate = script.validate.replace(new RegExp(/\"/g),"\'");
			    		scope.properties[flag].propertyEditorUI.script =JSON.stringify(script);
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
    	
    	$scope.changePropertyVOType=function(type,index){
    		$scope.properties[index].defaultValue = "";
    	}
	    
	});
	
	function initData(){
		//读取行为对象
		dwr.TOPEngine.setAsync(false);
		ActionDefineFacade.loadModel(modelId, function(result){
			for(var i in result.properties){
 				result.properties[i].requried = result.properties[i].requried+"";
 				if(result.properties[i].ename=="code"||result.properties[i].ename=="relationGridId"||result.properties[i].ename=="queryCondition"||
 						result.properties[i].ename=="pageURL"||result.properties[i].ename=="columnAttribute"||result.properties[i].ename=="dataStore"||
 						result.properties[i].ename=="actionMethodName"||result.properties[i].ename=="treeIdParam"||result.properties[i].ename=="treeParentIdParam"
 							||result.properties[i].ename=="treeNameParam"){
 					result.properties[i].readonly="true";
 				}else{
 					result.properties[i].readonly="false";
 				}
 		   	}
			data = result;
			scope.properties = result.properties;
 		})
 		dwr.TOPEngine.setAsync(true);
		initFile();
	}
	//初始化文件
	function initFile(){
		var fileArr = [];
		for(var i=0;i<data.js.length;i++){
			fileArr.push(data.js[i]);
		}
		for(var j=0;j<data.css.length;j++){
			fileArr.push(data.css[j]);
		}
		dwr.TOPEngine.setAsync(false);
		ResourceFacade.readResouces(fileArr, function(result){
			for(var i=0;i<result.length;i++){
				if(result[i].content==null){
					result[i].content ="";
				}
			}
			scope.files = result;
		})
		dwr.TOPEngine.setAsync(true);
	}
	
	//页面装载方法
	function initCodeMirror(){
		var scriptText = "";
		if(data!=null&&data!=""&&data.script){
			scriptText =data.script;
		}
	   	var textarea = document.getElementById("script");
	   	 editor = CodeMirror.fromTextArea(textarea, { //script_once_code为你的textarea的ID号
	   		       lineNumbers: true,//是否显示行号
	   		       mode: {name: "javascript", globalVars: true},
	   		       lineWrapping:true, //是否强制换行
	               theme:'eclipse',
	               viewportMargin:1000 //默认只显示11行数据，这里设置显示一千行数据
	   		 });
	   	editor.on('keypress', function(instance, event) {
	        if(event.charCode>=46 || (event.charCode>=65 && event.charCode<=90) || (event.charCode>=97 && event.charCode<=122)){
	            setTimeout(function(){
	              editor.showHint();  //满足自动触发自动联想功能  
	            },1)
	        }         
	    }); 
	   	$("#code").find('.CodeMirror').css({background: "#F5F5F5"});//设置背景色
	   	editor.setValue(scriptText);
	}
	
		//保存
		function save(){
			var map = window.validater.validAllElement();
		    var inValid = map[0];
		    var valid = map[1];
		   	//验证消息
			if(inValid.length > 0){//验证失败
				var str = "";
		        for (var i = 0; i < inValid.length; i++) {
					str += inValid[i].message + "<br />";
				}
			}else{
				//属性中英文名称校验
				var validataResult = validataProperty();
				if (!validataResult.validFlag) {
					cui.alert(validataResult.message); 
					return;
				}
				//属性数字校验
				var validataNumberResult = validataPropertyNumberValue();
				if (!validataNumberResult.validFlag) {
					cui.alert(validataNumberResult.message); 
					return;
				}
				//属性Json格式校验
				var validateJsonResut = validataPropertyJsonValue();
				if (!validateJsonResut.validFlag) {
					cui.alert(validateJsonResut.message); 
					return;
				}
				
				 //检测属性英文名称不能为uitype				
				if(validataPropertyValue()){
					cui.alert("属性英文名称不能为:aliasEntityId");
					return;
				};
				setPropertyUI();
				var saveData = cui(data).databind().getValue();
				saveData.script = editor.getValue();
				saveData.modelId = modelId;
				//删除文件
		        delFileByPath(jsAndCssArr);
				dwr.TOPEngine.setAsync(false);
				ActionDefineFacade.saveModel(saveData, function(data){
		 			if(data){
		 				if(modelId==null||modelId==""){
		 					cui.message('行为新增成功。',"success");	
		 				}else{
			 			   cui.message('行为修改成功。',"success");
		 				}
		 			}else{
		 				if(modelId==null||modelId==""){
		 				   cui.message('行为新增失败。',"error");
		 				}else{
		 				   cui.message('行为修改失败。',"error");
		 				}
		 			}
		 		})
		 		dwr.TOPEngine.setAsync(true);
				setTimeout("back()",600);
			}
		  }
		
		
		//检测属性英文名称不能为uitype
		function validataPropertyValue(){
			for(var i=0;i<scope.properties.length;i++){
				var propertyVO = scope.properties[i];
				if(propertyVO.ename==="aliasEntityId"){
					return true;
				}
			}
			return false;
		}
		
		//打开控件编辑界面
		var editorUIDialog;
		function openEditorUI(flag){
			var propertyEName = scope.properties[flag].ename;
			if(propertyEName==""||propertyEName==null){
				cui.alert("请先设置属性英文名称!");
				return ;
			}
			
			var url = 'ComponentAttrSetEdit.jsp?flag='+flag+'&type=action';
			if(!editorUIDialog){
				editorUIDialog = cui.dialog({
				  	title : '属性控件编辑界面',
				  	src : url,
				    width : 850,
				    height : 450
				});
			}else{
				editorUIDialog.reload(url);
			} 
			editorUIDialog.show();
		}
		
		//文件内容编辑界面
		var contentDialog;
		function openScriptcontent(flag){
			var url = 'BaseTestStepControlScriptEdit.jsp?flag='+flag;
			if(!contentDialog){
				contentDialog = cui.dialog({
				  	title : '文件内容编辑',
				  	src : url,
				    width : 650,
				    height : 650
				});
			} 
			contentDialog.show(url);
		}
		
		//资源文件编辑
		function openResourceFileEdit(flag){
			
		}
		
		//新增文件
		var addFileDialog;
		function editFile(flag){
			var url = "ResourceFileEdit.jsp";
			if(typeof(flag)=="undefined"){
			     url+= "?editType=add";
			}else{
				  url+= "?editType=edit&flag="+flag;
			}
			if(!addFileDialog){
				addFileDialog = cui.dialog({
				  	title : "新增文件",
				  	src : url,
				    width : 750,
				    height : 540
				});
			} 
			addFileDialog.show(url);
		}
		
		//文件编辑回调，flag为-1为新增
		function fileEditCallback(fileData,editType,flag){
			if(editType=="add"){//新增
				//维护控件对象关联的js，css集合
				var fileType = fileData.fileType;
				if(fileType=="js"){
					data.js.push(fileData.fullFilePath);
				}else if(fileType=="css"){
					data.css.push(fileData.fullFilePath);
				} 
				scope.files.push(fileData);
			}else{//编辑
				scope.files[flag].content= fileData.content;
			}
			cap.digestValue(scope);
		}
		
		//上传文件
		var uploadFileDialog;
		function uploadFile(){
			var url = 'UploadResourceFileEdit.jsp?editType=add';
			if(!uploadFileDialog){
				uploadFileDialog = cui.dialog({
				  	title : '文件上传',
				  	src : url,
				    width : 650,
				    height : 200
				});
			} 
			uploadFileDialog.show(url);
		}
		
		//返回
		function back(){
			var attr="modelId="+modelId;
			window.location="CustomActionList.jsp?"+attr;	  
		}
		
		function getBodyWidth() {
		    return (document.documentElement.clientWidth || document.body.clientWidth) - 45;
		}
		
		function getBodyHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 410;
		}
		
	  var validateModelName=[
	                          {'type':'required','rule':{'m':'英文名称不能为空。'}},
	                          {'type':'length','rule':{'max':'80','maxm':'长度不能大于80'}},
	         	              {'type':'custom','rule':{'against':checkModelName, 'm':'英文名称只能为数字、字母、下划线。'}},
	                          {'type':'custom','rule':{'against':isExistModelName, 'm':'英文名称已存在。'}}
	         		    ];
	  var validatecName = [{'type':'required','rule':{'m':'中文名称不能为空。'}},
	                       {'type':'length','rule':{'max':'80','maxm':'长度不能大于80'}}];
	  
	  var validateCustomPackage = [ {'type':'custom','rule':{'against':checkCustomPackage, 'm':'分包名称只能为中文'}}//,
	                               // {'type':'custom','rule':{'against':validateModelName, 'm':'22'}}
	                              ];
	  var validatePropertyEName=[{'type':'required','rule':{'m':'英文名称不能为空。'}},
	  	                       {'type':'length','rule':{'max':'20','maxm':'长度不能大于20'}},
	                           {'type':'custom','rule':{'against':checkModelName, 'm':'英文名称只能为数字、字母、下划线。'}},
	  	                       {'type':'custom','rule':{'against':isExistPropertyEName, 'm':'属性英文名称不能重复。'}}
	                            ];
	  var validatePropertyCName=[{'type':'required','rule':{'m':'中文名称不能为空。'}},
		  	                       {'type':'length','rule':{'max':'20','maxm':'长度不能大于20'}}];
	  
	  var validatePropertyNumber = [{ 'type':'numeric','rule':{'oi':true,'notim':'默认值请输入整数'}}];
	  var validatePropertyJson = [{'type':'custom','rule':{'against':isJson,'m':'默认值Json格式不对'}}];
	  
	  function validataProperty(){
		  var validate = new cap.Validate();
	    	var valRulePropertyEName = {ename:validatePropertyEName,cname:validatecName};
	    	var result = validate.validateAllElement(scope.properties, valRulePropertyEName, "&diams;属性列表->第【{value}】行：");
	    	return result;
	  }
	  
	  function validataPropertyNumberValue(){
		 var  allProperties = jQuery.extend(true, [], scope.properties);
		   var propertiesNumber = [];
		   for(var i=0;i<allProperties.length;i++){
			   if(scope.properties[i].type==="Number"){
				   propertiesNumber.push(allProperties[i]);
			   }else{
				   var propertyVO = allProperties[i];
				   propertyVO.defaultValue = 9999;
				   propertiesNumber.push(propertyVO);  
			   }
		   }
		    var validate = new cap.Validate();
	    	var valRulePropertyEName = {defaultValue:validatePropertyNumber};
	    	var result = validate.validateAllElement(propertiesNumber, valRulePropertyEName, "&diams;属性列表->第【{value}】行：");
	    	return result;
	  }
	  
	  //校验属性Json格式
	  function validataPropertyJsonValue(){
			 var  allProperties = jQuery.extend(true, [], scope.properties);
			   var propertiesNumber = [];
			   for(var i=0;i<allProperties.length;i++){
				   if(scope.properties[i].type==="Json"){
					   propertiesNumber.push(allProperties[i]);
				   }else{
					   var propertyVO = allProperties[i];
					   propertyVO.defaultValue = "";
					   propertiesNumber.push(propertyVO);  
				   }
			   }
			    var validate = new cap.Validate();
		    	var valRulePropertyJson = {defaultValue:validatePropertyJson};
		    	var result = validate.validateAllElement(propertiesNumber, valRulePropertyJson, "&diams;属性列表->第【{value}】行：");
		    	return result;
		  }
	  
	  function checkPackageModelName(){
		  cap.validater.validOneElement("modelName");
	  }
	  

	  //检测属性对应ui控件
	  function setPropertyUI(){
		  for(var i=0;i<scope.properties.length;i++){
			  var propertyEname = scope.properties[i].ename;
			  var script = eval("("+scope.properties[i].propertyEditorUI.script+")");
			  script.id = propertyEname;
			  //script.name = propertyEname;
			  script["ng-model"] = propertyEname;
			  scope.properties[i].propertyEditorUI.script = JSON.stringify(script);
		  }
	  }
	  
	  //属性重复名称检测
	  function isExistPropertyEName(value){
		  var ret = true;
		  var num =0;
		  for(var i in scope.properties){
			  if(scope.properties[i].ename==value){
				  num++;
			  }
			  if(num>1){
				  ret=false;
				  break;
			  }
		  }
		 
		  return ret;
	  }
		//只能为 英文、数字、下划线
		function checkModelName(data) {
			if(data){
				var reg = new RegExp("^[A-Za-z0-9_]+$");
				return (reg.test(data));
			}
			return true;
		}
		
		//只能为 中文
		function checkCustomPackage(data) {
			if(data){
				var reg = new RegExp("^[\u4e00-\u9fa5]+$");// /[\u4E00-\u9FA5\uF900-\uFA2D]|[.]+/; 
				return (reg.test(data));
			}
			return true;
		}
		
		//不能有.
		function checkPackage(data){
			if(data){
				var reg = /./;
				return !(reg.test(data));
			}
			return true;	
		}
		
		   //Json格式校验
		  function isJson(value){
			  var ret = true;
			 if(value==""||isJson==null){
				 return ret;
			 }
			 try{
				 var JsonValue = eval("("+value+")");
				}catch(e){
					ret = false;
				}
			  return ret;
		  }
		
		/**     
		 * 自定义行为名称是否存在
		 */  
		function isExistModelName(definition){
			var isExist = true;
			if(data.modelId&&data.modelId!=null&&data.modelId!=""){
				return isExist;
			}
			var modelName = cui("#modelName").getValue();
			var modelPackageCnName = cui("#modelPackageCnName").getValue();
 			dwr.TOPEngine.setAsync(false);
			ActionDefineFacade.isExistSameAction(modelName,modelPackageCnName, function(data){
				isExist = !data;
			});
			dwr.TOPEngine.setAsync(true); 
			return isExist;
		}
		
		//行为帮助页面
		function help(){
			window.open('CustomActionHelpMain.jsp',"acionHelp");
		}
		
		//脚本帮助页面
		function scriptHelp(){
			window.open('CustomActionScriptHelpMain.jsp', "acionScriptHelp");
		}
		
		
		//查看所有脚本
		function allScript(){
			var png = $("#unflod").attr("src");
			if(png=="images/unfold.png"){
				$("#unflod").attr("src","images/fold.png");
				$("#unflod").attr("title","收起脚本");
				$("#code").css("overflow","hidden");
				$("#code").height("100%");
			}else{
				$("#unflod").attr("src","images/unfold.png");
				$("#unflod").attr("title","展开全部脚本");	
				$("#code").css("overflow","auto");
				$("#code").height(200);
			}
		}
		
		//新增属性
	  function addProperty(){
		  var propertyVO = {ename:'',cname:'',type:'String',requried:"true",readonly:"false",defaultValue:'',description:'',propertyEditorUI:{componentName:'cui_input',script:"{'id':'','ng-model':'','validate':\"[{'type':'required','rule':{'m':'不能为空'}}]\"}"}};
		  scope.properties.push(propertyVO);
	      cap.digestValue(scope);
		}
		
		//导入已有属性
		var importPropertyDialog;
	  function importProperty(){
			var url = 'ExistCustomPropertyList.jsp';
			if(!importPropertyDialog){
				importPropertyDialog = cui.dialog({
				  	title : '属性选择界面',
				  	src : url,
				    width : 800,
				    height : 600
				});
			} 
			importPropertyDialog.show(url);
	  }
	  
	 //属性选择取消回调
	  function importPropertyCancel(){
		  importPropertyDialog.hide();
	  }
	 
	  //属性选择确定回调,如果数据重复？不再导入
	  function importPropertyCallBack(selData){
		  var insertProperty = [];
		  if(selData&&selData.length>0){
			  for(var i=0;i<selData.length;i++){
				  var selPropertyVO = selData[i];
				  var bFlag = true;
				  for(var k=0;k<scope.properties.length;k++){
					  var propertyVO = scope.properties[k];
					  if(selPropertyVO.cname==propertyVO.cname){
						  bFlag = false;
					  }
				  }
				  if(bFlag){
					  insertProperty.push(selPropertyVO); 
				  }
			  }
		  }
		  if(insertProperty.length>0){
			  for(var j=0;j<insertProperty.length;j++){
				  scope.properties.push(insertProperty[j]); 
			  }
		  }
		  cap.digestValue(scope);//数据扫描
		  //关闭窗口
		  importPropertyCancel();
	  }
		//删除属性
     function delProperty(){
    	 var newArr=[];
 		for(var i=0;i<scope.properties.length;i++){
 			if(scope.properties[i].check){
 				newArr.push(i);
 			}
 		}
         //根据坐标删除数据
         for(var j=newArr.length-1;j>=0;j--){
        	 scope.properties.splice(newArr[j],1);
         }
         if(scope.properties==null||scope.properties.length==0){
        	 eval("scope.propertyCheckAll=false");
         }
         cap.digestValue(scope);
        // cui.message('属性删除成功。',"success");	
     }
		
		//删除文件
     function delFile(){
    	 var newArr=[];//界面数据
    	 var delJsAndCssArr = [];
  		for(var i=0;i<scope.files.length;i++){
  			if(scope.files[i].check){
  				newArr.push(i);
  				var fullFilePath = "/"+scope.files[i].packagePath.replace(/\./g,"/")+"/"+scope.files[i].fileName +"."+scope.files[i].fileType;
  				delJsAndCssArr.push(fullFilePath);
  				 jsAndCssArr.push(fullFilePath);
  			}
  		}
          cap.array.remove(data.js,delJsAndCssArr);  
          cap.array.remove(data.css,delJsAndCssArr); 
          //根据坐标删除数据
          for(var j=newArr.length-1;j>=0;j--){
         	 scope.files.splice(newArr[j],1);
          }
          if(scope.files==null||scope.files.length==0){
         	 eval("scope.fileCheckAll=false");
          }
          cap.digestValue(scope);
         // cui.message('文件删除成功。',"success");	
     }
       
		//删除文件
	function delFileByPath(delJsAndCssArr){
		dwr.TOPEngine.setAsync(false);
		ResourceFacade.deleteResoucesByPath(delJsAndCssArr,function(result){

		})
		dwr.TOPEngine.setAsync(true);
	}
	</script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="customActionEditCtrl" data-ng-init="ready()">
<div id="pageRoot" class="cap-page">
	<div id="" class="cap-area" style="width:100%;dispaly:none;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	<span id="save" uitype="Button" onclick="save()" label="保存"></span> 
					<span id="back" uitype="Button" onclick="back()" label="返回"></span> 
					<span id="help" uitype="Button" onclick="help()" label="帮助"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span class="cap-label-title" size="12pt">自定义行为基本信息</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
		</table>
		<table class="form_table" style="table-layout:fixed;">
						<tr>
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>英文名称：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input"  id="modelName" databind="data.modelName" width="90%" validate="validateModelName"  readOnly="false"></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>中文名称：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					           <span uitype="input"  id="cname" databind="data.cname" width="90%" validate="validatecName"  readOnly="false"></span>
					        </td>
						</tr>
						<tr>
							<td  class="td_label" style="text-align: right;width:15%">
								分组中文名：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input"  id="modelPackageCnName" databind="data.modelPackageCnName" width="90%" on_blur="checkPackageModelName" validate="validateCustomPackage" readOnly="false"></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								描述：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input" id="description" width="90%" databind="data.description" readOnly="false"></span>
					        </td>
						</tr>
						<tr>
							<td  class="td_label" style="text-align: right;width:10%">脚本：
							</td>
							<td class="td_content" colspan="3" style="text-align: left;">
							    <div class="code_btn_area">
								    <img id="unflod" src="images/unfold.png" title="展开全部脚本" onclick="allScript()" style="padding-right:5px"></img>
									<img src="images/help.png" title="帮助" onclick="scriptHelp()" style="padding-right:15px;padding-top:10px;"></img>
								</div>
								<div id="code" class="codeArea" style="width:96%;height:200px;overflow:auto;">
									<!-- <span uitype="textarea" name="script" databind="data.script" 
										relation="remarkLength" maxlength="500" width="100%"></span> -->
										<textarea id="script" name="script"></textarea>
								</div>
							</td>
						</tr> 
				</table>
	
<div>
    <table class="cap-table-fullWidth">
		<tr>
		     <td class="cap-td" style="text-align: left;padding:5px">
				  <blockquote class="cap-form-group">
					 <span class="cap-label-title" size="12pt">属性列表</span>
				  </blockquote>
		     </td>
		     <td class="cap-td" style="text-align: right;padding:5px">
		          <span id="importProperty" uitype="Button" onclick="importProperty()" label="导入"></span> 
		          <span id="addProperty" uitype="Button" onclick="addProperty()" label="新增"></span> 
				  <span id="delProperty" uitype="Button" onclick="delProperty()" label="删除"></span> 
		     </td>
		</tr>
	</table>
    <div style="padding:5px">
   <table class="custom-grid" style="width: 100%">
       <thead>
           <tr>
                <th style="width:30px">
				 <input type="checkbox" name="propertyCheckAll" ng-model="propertyCheckAll" ng-change="allCheckBoxCheck(properties,propertyCheckAll)">
				</th>
           	    <th style="width:30px">序号</th>
                <th style="width:150px"><font color="red">*</font>英文名称</th>
                <th style="width:150px"><font color="red">*</font>中文名称</th>
               <th style="width:80px"><font color="red">*</font>值类型 </th>
               <th style="width:90px"><font color="red">*</font>是否必填</th>
               <th style="width:150px">默认值</th>
               <th style="width:80px"><font color="red">*</font>对应ui控件</th>
               <th>描述</th>
           </tr>
       </thead>
        <tbody>
            <tr ng-repeat="propertyVO in properties track by $index">
                <td style="text-align: center;">
	                   <input type="checkbox" name="{{'property'+($index + 1)}}" ng-model="propertyVO.check" ng-change="checkBoxCheck(properties,'propertyCheckAll')">
			    </td>
                <td style="text-align: center;">
                    {{($index + 1)}}
                </td>
               <td style="text-align:center;" ng-if="propertyVO.readonly=='true'">
               <span cui_input id="{{'ename'+($index + 1)}}" ng-model="propertyVO.ename" validate="validatePropertyEName" readonly="true" width="100%">
              </td>
               <td style="text-align:center;" ng-if="propertyVO.readonly=='false'">
               <span cui_input id="{{'ename'+($index + 1)}}" ng-model="propertyVO.ename" validate="validatePropertyEName" width="100%">
              </td>
              <td style="text-align:center;">
               <span cui_input id="{{'cname'+($index + 1)}}" ng-model="propertyVO.cname" validate="validatePropertyCName" width="100%">
              </td>
               <td style="text-align:left;" ng-if="propertyVO.readonly=='true'">
               	<span cui_pulldown id="{{'type'+($index + 1)}}" ng-model="propertyVO.type" editable="false" readonly="true"  width="100%">
              		<a value="String">String</a>
     			    <a value="Number">Number</a>
     			    <a value="Boolean">Boolean</a>
     			    <a value="Json">Json</a>
              	</span>
             </td>
               <td style="text-align:left;" ng-if="propertyVO.readonly=='false'">
               	<span cui_pulldown id="{{'type'+($index + 1)}}" ng-model="propertyVO.type" editable="false" width="100%" ng-change="changePropertyVOType(propertyVO.type,$index)" >
              		<a value="String">String</a>
     			    <a value="Number">Number</a>
     			    <a value="Boolean">Boolean</a>
     			    <a value="Json">Json</a>
              	</span>
             </td>
              <td style="text-align: left;">
              	<span cui_radioGroup id="{{'requried'+($index + 1)}}" ng-model="propertyVO.requried" ng_change="changeRequried(propertyVO.requried,$index)" name="{{'requried'+($index + 1)}}" width="100%" readOnly="false">
              		<input type="radio" name="{{'requried'+($index + 1)}}" value="true" />是
					<input type="radio" name="{{'requried'+($index + 1)}}" value="false" />否
              	</span>
             </td>
              <td style="text-align:center;" ng-if="propertyVO.type==='String'">
               <span cui_input id="{{'defaultValue'+($index + 1)}}" ng-model="propertyVO.defaultValue" width="100%">
              </td>
               <td style="text-align:center;" ng-if="propertyVO.type==='Boolean'">
               <span cui_radioGroup id="{{'defaultValue'+($index + 1)}}" ng-model="propertyVO.defaultValue" name="{{'defaultValue'+($index + 1)}}" width="100%" readOnly="false">
              		<input type="radio" name="{{'defaultValue'+($index + 1)}}" value="true" />true
					<input type="radio" name="{{'defaultValue'+($index + 1)}}" value="false" />false
              	</span>
              </td>
               <td style="text-align:center;" ng-if="propertyVO.type==='Number'">
               <span cui_input id="{{'defaultValue'+($index + 1)}}" ng-model="propertyVO.defaultValue" validate="validatePropertyNumber" width="100%">
              </td>
               <td style="text-align:center;" ng-if="propertyVO.type==='Json'">
               <span cui_input id="{{'defaultValue'+($index + 1)}}" ng-model="propertyVO.defaultValue" validate="validatePropertyJson" width="100%">
              </td>
              <td style="text-align: left;">
               &nbsp&nbsp{{propertyVO.ename==null||propertyVO.ename==""?"未配置":"已配置"}}
               <img alt="" style="cursor:pointer" bind="{{$index}}" src="images/edit.png" id="{{'componentName'+($index + 1)}}" onclick="openEditorUI(jQuery(this).attr('bind'));"></img>
             </td>
              <td style="text-align:center;">
               <span cui_input id="{{'description'+($index + 1)}}" ng-model="propertyVO.description" width="100%">
              </td>
            </tr>
             <tr ng-if="!properties || properties.length == 0">
			     <td colspan="9" class="grid-empty"> 本列表暂无记录</td>
			 </tr>
       </tbody>
   </table>
   </div>
   
       <table class="cap-table-fullWidth">
		<tr>
		     <td class="cap-td" style="text-align: left;padding:5px">
				  <blockquote class="cap-form-group">
					 <span class="cap-label-title" size="12pt">运行时js、css列表</span>
				  </blockquote>
		     </td>
		     <td class="cap-td" style="text-align: right;padding:5px">
		          <span id="uploadFile" uitype="Button" onclick="uploadFile()" label="上传"></span> 
		          <span id="addFile" uitype="Button" onclick="editFile()" label="新增"></span> 
				  <span id="delFile" uitype="Button" onclick="delFile()" label="删除"></span> 
		     </td>
		</tr>
	</table>
    <div style="padding:5px">
   <table class="custom-grid" style="width: 100%">
       <thead>
           <tr>
                <th style="width:30px">
				 <input type="checkbox" name="fileCheckAll" ng-model="fileCheckAll" ng-change="allCheckBoxCheck(files,fileCheckAll)">
				</th>
				<th style="width:30px">序号</th>
                <th style="width:15%">文件类型</th>
                <th style="width:25%">文件名称</th>
               <th style="width:35%">包路径 </th>
               <th style="width:90px">文件内容</th>
           </tr>
       </thead>
        <tbody>
            <tr ng-repeat="fileVO in files track by $index" >
                <td style="text-align: center;">
	                   <input type="checkbox" name="{{'fileVO'+($index + 1)}}" ng-model="fileVO.check" ng-change="checkBoxCheck(files,'fileCheckAll')">
			    </td>
                <td style="text-align: center;" ng-click="fileTdClick(fileVO)">
                    {{($index + 1)}}
                </td>
              <td style="text-align:center;" ng-click="fileTdClick(fileVO)">
                 {{fileVO.fileType}}
              </td>
               <td style="text-align:center;" ng-click="fileTdClick(fileVO)">
               {{fileVO.fileName}}
             </td>
              <td style="text-align: center;" ng-click="fileTdClick(fileVO)">
              {{fileVO.packagePath}}
             </td>
              <td style="text-align: center;">
               &nbsp&nbsp{{fileVO.content==null||fileVO.content==""?"未配置":"已配置"}}
               <img alt="" style="cursor:pointer" bind="{{$index}}" src="images/edit.png" id="{{'content'+($index + 1)}}" onclick="editFile(jQuery(this).attr('bind'));"></img>
             </td>
            </tr>
             <tr ng-if="!files || files.length == 0">
			     <td colspan="6" class="grid-empty"> 本列表暂无记录</td>
			 </tr>
       </tbody>
   </table>
   
   </div>
   
</div>
	
	</div>
</div>
</body>
</html>