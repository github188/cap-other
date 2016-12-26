<%
/**********************************************************************
* 控件属性设置页面
* 2016-11-11 刘城 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='componentAttrApp'>
<head>
<style>

</style>
<meta charset="UTF-8">
<title> 控件属性设置页面</title>
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
			height: auto;
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
	//类型 控件或者行为
	var type=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("type"))%>;
	//行数 父页面properties[flag] 为当前对象
	var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
	var data=jQuery.extend(true, {}, window.parent.scope.properties[flag]);
	var valionclickRule = [{type:'required',rule:{m:'onclick方法名不能为空'}},{ 'type':'custom','rule':{'against':'checkPropertyReg', 'm':'onclick方法名必须包含()!'}}];
	var value_fieldRule = [{type:'required',rule:{m:'value_field不能为空'}}];
	var label_fieldRule = [{type:'required',rule:{m:'label_field不能为空'}}];
	function validataRequired() {
		var validate = new cap.Validate();
		var valRule = {
				onclick: valionclickRule,
				value_field: value_fieldRule,
				label_field: label_fieldRule
		};
		return validate.validateAllElement(scope.script, valRule);
	}
	var componectTypeData =  [
			{id:'cui_input',text:'cui_input'},        
	      	{id:'cui_clickinput',text:'cui_clickinput'},
	      	{id:'cui_pulldown',text:'cui_pulldown'},
	      	{id:'cui_radiogroup',text:'cui_radiogroup'}
	      ]
	var scope;
	var editor;
	angular.module('componentAttrApp', ["cui"]).controller('customActionEditCtrl', function ($scope) {
		$scope.data={};
		$scope.propertyEditorUI ={};
		$scope.type=type;
		$scope.script = {};
		
		$scope.ready=function(){
			scope=$scope;
			initData();
			//initComponectType();
			comtop.UI.scan();
	    	initCodeMirror();
	    };
	    
	    
		//改变下拉框值时，清空
	    $scope.$watch("propertyEditorUI.componentName", function(newVal, oldVal, scope) {
	    	if (newVal != oldVal) {
	    		deleteProperty('on_iconclick',scope.script);
	    		deleteProperty('onclick',scope.script);
	    		deleteProperty('validate',scope.script);
	    		deleteProperty('editable',scope.script);
	    		deleteProperty('mode',scope.script);
	    		deleteProperty('select',scope.script);
	    		deleteProperty('value_field',scope.script);
	    		deleteProperty('label_field',scope.script);
	    		deleteProperty('datasource',scope.script);
	    		//deleteProperty('value',scope.script);
	    		deleteProperty('must_exist',scope.script);
	    		deleteProperty('readonly',scope.script);
	    		deleteProperty('emptytext',scope.script);
	    		deleteProperty('radio_list',scope.script);
	    		deleteProperty('operation',scope.propertyEditorUI);
    			editor.setValue("");
    			if (scope.propertyEditorUI.componentName=='cui_input') {
    				scope.script["readonly"] = "false";
    			}
    			if (scope.propertyEditorUI.componentName=='cui_pulldown') {
    				scope.script["editable"] = "false";
    				scope.script["must_exist"] = "false";
    				scope.script["value_field"] ="id";
    				scope.script["label_field"] ="text";
    				scope.script["mode"] ="Single";
    			}
    			if (scope.propertyEditorUI.componentName=='cui_clickinput') {
    				scope.script["editable"] = "true";
    			}
	    	}
	    	
	    }, true);
	});
	
	//删除对象属性
	function deleteProperty(id,obj){
		if (obj[id]!==undefined) {
			delete obj[id];
		}
	}

	//初始化参数
	function initData(){
		scope.data = data;
		scope.propertyEditorUI = data.propertyEditorUI;
		if (scope.propertyEditorUI.script!=null&&scope.propertyEditorUI.script!="") {
			var script = eval("("+scope.propertyEditorUI.script+")");
			scope.script = script;
		}
		scope.script.id = scope.data.ename;
		scope.script.name = scope.data.ename;
		scope.script["ng-model"] = scope.data.ename;
		if (type == "component") {
			scope.script["ng-model"] = "data." + scope.data.ename;
		}

		if (scope.propertyEditorUI.componentName=="cui_input"&&scope.script["readonly"] == null) {
			scope.script["readonly"] = "false";
		}
		

	}

	
	//页面装载方法
	function initCodeMirror(){
		var scriptText = "";
		if(scope.propertyEditorUI!=null&&scope.propertyEditorUI!=""&&scope.propertyEditorUI.operation){
			scriptText =scope.propertyEditorUI.operation;
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
	
	var selectJSActionDialog;
	//group设置为action、all、component 三组
	function selectJSAction(event, obj) {
		//打开控件编辑界面
		if(type=="action"){
			var url = 'PropertyUIFunctionList.jsp';	
		}else{
		var url = 'SelectJSActionList.jsp?group='+type;
		}
		if (!selectJSActionDialog) {
			selectJSActionDialog = cui.dialog({
				title: '已有函数选择页面',
				src: url,
				width: 750,
				height: 350
			});
		} else {
			selectJSActionDialog.reload(url);
		}
		selectJSActionDialog.show();
	}
	
	function propertyFunctionCallBack(onclick){
		scope.script.onclick=onclick;
		scope.$digest();
		selectJSActionDialog.hide();
	}
	
	function propertyFunctionCancel(){
		selectJSActionDialog.hide();
	}

	//回调函数
	function fromCallBack(selectData){
		//alert(selectData);
		if (scope.type=='component') {
			scope.script.on_iconclick=selectData[0].functionName;
		}else{
			scope.script.onclick=selectData[0].functionFullName;
		}
		
		scope.$digest();
	}
	
	//查看所有脚本
	function allScript(){
		var png = $("#unflod").attr("src");
		if(png=="images/unfold.png"){
			$("#unflod").attr("src","images/fold.png");
			$("#unflod").attr("title","收起脚本");
			$("#code").height("100%");
		}else{
			$("#unflod").attr("src","images/unfold.png");
			$("#unflod").attr("title","展开全部脚本");	
			$("#code").height(200);
		}
	}


	//validate契合页面使用
	var currSelectDataModelVal;
	/**
	 * 跳转到校验组件界面(js/css/dom)
	 * @param event
	 * @param self
	 */
	function openValidateAreaWindow(event, self){
		var param = '?propertyName='+self.options.name + '&callbackMethod=openWindowCallback';
		var url = '../../../bm/dev/page/uilibrary/ValidateComponent.jsp' + param;
		var width=800; //窗口宽度
	    var height=600; //窗口高度
	    var top=(window.screen.availHeight-height)/2;
	    var left=(window.screen.availWidth-width)/2;
	    currSelectDataModelVal=scope.script.validate;
	    window.open(url, "validateArea", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	}



	/**
	 * 跳转到编写代码文本域界面(js/css/dom)
	 * @param event 事件
	 * @param self 组件本身对象
	 */
	function openCodeEditAreaWindow(event, self){
		var width=800; //窗口宽度
	    var height=600; //窗口高度
	    var top=(window.screen.availHeight-height)/2;
	    var left=(window.screen.availWidth-width)/2;
	    var propertyName="datasource";

	    var uitype = "PullDown";
	    if (self.options['ng-model']=="script.radio_list") {
	    	uitype = "RadioGroup";
	    	propertyName = "radio_list";
	    }
	    var url='./CustomDataModel.jsp?propertyName='+propertyName+'&callbackMethod=openWindowCallback&uitype='+uitype+'&propertyType=Json';
	    window.open(url, "codeEditArea", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	}

	/**
	 * 公共的回调函数
	 * @param propertyName
	 * @param propertyValue
	 */
	function openWindowCallback(propertyName,propertyValue){
		scope.script[propertyName] = propertyValue.replace(new RegExp(/\"/g),"\'");
		scope.$digest();
	}

	//保存
	function save(){
		//校验必填项
		if(!validataRequired().validFlag)
			return;
		if (type=='action'&&scope.propertyEditorUI.componentName == 'cui_clickinput') {
			
			if (/^[a-zA-Z$_][\w$]*$/.test(scope.script.onclick)) {
				scope.script.onclick += "()";
			}
		}
		///^[a-zA-Z$_][\w$]*$/.test(scope.script.onclick)
		
		
		scope.data.propertyEditorUI.script=JSON.stringify(scope.script);
		scope.propertyEditorUI.operation=editor.getValue();
		window.parent.scope.properties[flag] = scope.data;
		if(scope.script.validate==""||scope.script.validate==null||eval(scope.script.validate).length==0){
			window.parent.scope.properties[flag].requried="false";
		}
		window.parent.editorUIDialog.hide();
		cap.digestValue(window.parent.scope);
	}


	//onclick是否包含括号，防止只写方法名没有加括号
	function checkPropertyReg() {
		if (type=='action'&&scope.propertyEditorUI.componentName == 'cui_clickinput') {
			//var reg = new RegExp("^[a-z][\\w|$]+\\(\.*\\)$");
			if (/^[a-zA-Z$_][\w$]*[(](?![(]).*[)][;]?$/.test(scope.script.onclick) || /^[a-zA-Z$_][\w$]*$/.test(scope.script.onclick)) {
				return true;
			} else {
				//cui.alert("onclick方法名不能为空且必须包含(),请修改后保存!<br/>");
				return false;
			}
		}
		return true;
	}

	//检查属性是否为空
	/* function checkIsNull(){
		var msg = "";
		var flag = false;
		if (scope.propertyEditorUI.componentName=='cui_pulldown') {
				if (scope.script["value_field"]==null||scope.script["value_field"]=='') {
				 		msg = "控件类型为cui_pulldown时，value_field不能为空，请改正后再保存!<br/>";
				 		flag = true;
				 	}
				if (scope.script["label_field"]==null||scope.script["label_field"]=='') {
				  		msg = "控件类型为cui_pulldown时，label_field不能为空，请改正后再保存!<br/>";
				  		flag = true;
				  	}
			}
		if (flag) {
			cui.alert(msg);
		}
		return flag;
	} */
	
	
	//返回
	function back(){
		window.parent.editorUIDialog.hide();
	}
		
		
	</script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="customActionEditCtrl" data-ng-init="ready()">
<div id="pageRoot" class="cap-page">
	<div id="chooseCopyPage" class="cap-area" style="width:100%;dispaly:none;">
		<table class="cap-table-fullWidth" style="padding-bottom: 5px;">
		    <tr>
    	        <td class="cap-td" style="text-align: left;">
    	        	<span>
    		        	<blockquote class="cap-form-group">
    						<span class="cap-label-title" size="12pt">控件属性编辑:</span>
    					</blockquote>
    				</span>
    	        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	<span id="save" uitype="Button" onclick="save()" label="保存"></span> 
					<span id="back" uitype="Button" onclick="back()" label="关闭"></span> 
		        </td>
		    </tr>
		</table>
		<table class="form_table" style="table-layout:fixed;">
						<tr>
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>控件类型：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span  cui_pulldown id="componentName"  mode="Single" value_field="id" label_field="text"   editable="false" ng-model="propertyEditorUI.componentName" select="0"  datasource="componectTypeData"  width="90%">
					        	</span>
					        </td>
							<td  class="td_label" style="text-align: right;width:15%">
								&nbsp;&nbsp;
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					            &nbsp;&nbsp;
					        </td>
						</tr>

						<!--input行为/控件  -->
						<tr ng-if="propertyEditorUI.componentName == 'cui_input'">
							<td  class="td_label" style="text-align: right;width:15%">
								id：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input  id="id" readonly="true" ng-model="script.id" width="90%"  ></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								name：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input id="name" readonly="true" width="90%" ng-model="script.name" ></span>
					        </td>
						</tr>
						<tr ng-if="propertyEditorUI.componentName == 'cui_input'">
							<td  class="td_label" style="text-align: right;width:15%">
								readonly：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_radioGroup id="readonly" ng-model="script['readonly']" value="1" name="readonly" width="100%" >
	        	              		<input type="radio" name="readonly" value="true" />是
	        						<input type="radio" name="readonly" value="false" />否
	        	              	</span>
					        </td>
			        		<td  class="td_label" style="text-align: right;width:15%">
			        			emptytext：
			                </td>
			                <td class="td_content" style="text-align: left;width:40%">
			                	<span cui_input id="emptytext" width="90%" ng-model="script.emptytext" emptytext="请输入为空提示语" ></span>
			                	
			                </td>
						</tr>
						<tr ng-if="propertyEditorUI.componentName == 'cui_input'">
							<td  class="td_label" style="text-align: right;width:15%">
								validate：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<!-- <span cui_input id="validate" width="90%" emptytext="[{type:'required',rule:{m:'不能为空'}}]" ng-model="script.validate"  ></span> -->
					        	<span cui_clickinput id="validate"  name="validate" ng-model ="script.validate" emptytext="[{type:'required',rule:{m:'不能为空'}}]" width="90%"  on_iconclick="openValidateAreaWindow"></span>
					        </td>
			        		<td  class="td_label" style="text-align: right;width:15%">
			        			&nbsp;&nbsp;
			                </td>
			                <td class="td_content" style="text-align: left;width:40%">
			                	&nbsp;&nbsp;
			                </td>
						</tr>

						
							
						<tr ng-if="propertyEditorUI.componentName == 'cui_clickinput'">
							<td  class="td_label" style="text-align: right;width:15%">
								id：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input  id="id" ng-model="script.id" readonly="true" width="90%"  ></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								name：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input id="name" width="90%" ng-model="script.name" readonly="true"  ></span>
					        </td>
						</tr>
						<tr ng-if="propertyEditorUI.componentName == 'cui_clickinput'">
							<td  class="td_label" style="text-align: right;width:15%">
								editable：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_radioGroup id="editable" ng-model="script.editable" value="1" name="editable" width="100%" >
	        	              		<input type="radio" name="editable" value="true" />是
	        						<input type="radio" name="editable" value="false" />否
	        	              	</span>
					        </td>
							<td  class="td_label" style="text-align: right;width:15%">
								validate：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_clickinput id="validate"  name="validate" ng-model ="script.validate" emptytext="[{type:'required',rule:{m:'不能为空'}}]" width="90%"  on_iconclick="openValidateAreaWindow"></span>
					        	<!-- <span cui_input id="validate" width="90%" ng-model="script.validate" emptytext="[{type:'required',rule:{m:'不能为空'}}]" ></span> -->
					        </td>
						</tr>
						<tr ng-if="propertyEditorUI.componentName == 'cui_clickinput'">
							<td ng-if="type == 'action'" class="td_label" style="text-align: right;width:15%">
								onclick：
					        </td>
					        <td ng-if="type == 'action'" class="td_content" style="text-align: left;width:40%">
					        	<span cui_clickinput id="onclick"  name="onclick" ng-model ="script.onclick" width="90%" editable="true" on_iconclick="selectJSAction" validate="valionclickRule"></span>
					        </td>


							<td ng-if="type == 'component'" class="td_label" style="text-align: right;width:15%">
								on_iconclick:
					        </td>
					        <td ng-if="type == 'component'" class="td_content" style="text-align: left;width:40%">
					        	<span cui_clickinput id="on_iconclick"  name="onclick" ng-model ="script.on_iconclick" width="90%" editable="true" on_iconclick="selectJSAction"></span>
					        </td>
			        		<td  class="td_label" style="text-align: right;width:15%">
			        			&nbsp;&nbsp;
			                </td>
			                <td class="td_content" style="text-align: left;width:40%">
			                	&nbsp;&nbsp;
			                </td>
						</tr>
						<tr ng-hide="propertyEditorUI.componentName != 'cui_clickinput'">
							<td  class="td_label" style="text-align: right;width:10%">脚本：
							</td>
							<td class="td_content" colspan="3" style="text-align: left;">
							    <div class="code_btn_area">
								    <img id="unflod" src="images/unfold.png" title="展开全部脚本" onclick="allScript()" style="padding-right:5px"></img>
									<!-- <img src="images/help.png" title="帮助" onclick="scriptHelp()" style="padding-right:5px;padding-top:10px;"></img> -->
								</div>
								<div id="code" class="codeArea" style="width:96%;height:200px;overflow:auto;">
										<textarea id="script" ng-model="propertyEditorUI.operation" name="script"></textarea>
								</div>
							</td>
						</tr> 

	
						<tr ng-if="propertyEditorUI.componentName == 'cui_pulldown'">
							<td  class="td_label" style="text-align: right;width:15%">
								id：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input  id="id" ng-model="script.id" width="90%"  readonly="true" ></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								name：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input id="name" width="90%" ng-model="script.name" readonly="true" ></span>
					        </td>
						</tr>
						<tr ng-if="propertyEditorUI.componentName == 'cui_pulldown'">
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>value_field:
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input id="value_field" width="90%" ng-model="script.value_field" emptytext="id" validate="value_fieldRule" ></span>
					        </td>
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>label_field：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input id="label_field" width="90%" ng-model="script.label_field"  emptytext="text" validate="label_fieldRule"></span>
					        </td>
							
						</tr>
						<tr ng-if="propertyEditorUI.componentName == 'cui_pulldown'">
							<td  class="td_label" style="text-align: right;width:15%">
								mode：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
	        	             	<span cui_pulldown id="mode" ng-model="script.mode" value_field="id" label_field="text" width="90%" >
	        	             		<a value=Single>单选</a>
	        	             		<a value=Multi>多选</a>
	        					</span>
					        </td>
							<td  class="td_label" style="text-align: right;width:15%">
								datasource：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_clickinput id="datasource"  name="onclick" ng-model ="script.datasource" width="90%"  on_iconclick="openCodeEditAreaWindow"></span>
					        </td>
						</tr>
						<tr ng-if="propertyEditorUI.componentName == 'cui_pulldown'">
    						
							<td  class="td_label" style="text-align: right;width:15%">
								editable:
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_radioGroup id="editable" ng-model="script.editable" value="1" name="readonly" width="100%" >
	        	              		<input type="radio" name="editable" value="true" />是
	        						<input type="radio" name="editable" value="false" />否
	        	              	</span>
					        </td>
    						<td  class="td_label" style="text-align: right;width:15%">
    							must_exist:
    				        </td>
    				        <td class="td_content" style="text-align: left;width:40%">
    				        	<span cui_radioGroup id="must_exist" ng-model="script['must_exist']" value="1" name="must_exist" width="100%" >
            	              		<input type="radio" name="must_exist" value="true" />是
									<input type="radio" name="must_exist" value="false" />否
            	              	</span>
    				        </td>
						</tr>

						<!--cui_radiogroup-->
						<tr ng-if="propertyEditorUI.componentName == 'cui_radiogroup'">
							<td  class="td_label" style="text-align: right;width:15%">
								id：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input  id="id" ng-model="script.id" width="90%" readonly="true"  ></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								name：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_input id="name" width="90%" ng-model="script.name" readonly="true" ></span>
					        </td>
						</tr>
						<tr ng-if="propertyEditorUI.componentName == 'cui_radiogroup'">
							<td  class="td_label" style="text-align: right;width:15%">
								radio_list：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span cui_clickinput id="radio_list" width="90%" ng-model="script.radio_list" on_iconclick="openCodeEditAreaWindow" ></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								&nbsp;&nbsp;
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	&nbsp;&nbsp;
					        </td>
						</tr>
				</table>
	</div>
</div>
</body>
</html>