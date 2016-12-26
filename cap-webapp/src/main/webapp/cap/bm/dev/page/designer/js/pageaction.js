//行为属性参数选项指令
CUI2AngularJS.directive('cuiProperty', ['$interpolate','$compile', function ($interpolate,$compile) {
    return {
    	restrict: 'A',
        require: 'ngModel',
        transclude: true,
        scope: {
        	ngModel: '='
        },
        link: function (scope, element, attrs, controller) {
        	scope.safeApply = function (fn) {
                var phase = this.$root.$$phase;
                if (phase == '$apply' || phase == '$digest') {
                    if (fn && (typeof(fn) === 'function')) {
                        fn();
                    }
                } else {
                    this.$apply(fn);
                }
            };
          var exclude = attrs.exclude + ',';
          scope.$watch("ngModel.actionDefineVO.properties",function(){
        		var properties = _.filter(scope.ngModel.actionDefineVO.properties, function(n){ return n.hide != true;});
        		if(properties!=null){
        			jQuery("#newProperty").html("");
        			var domElmentStr = "";
           			for(var i=0, len=properties.length; i<len; i++){
                      if(isExclude(properties[i])) {
                        continue;
                      }
   	                	var isNewline = i%2 == 0 ? true : false;
   	                	if(isNewline){
   	                		domElmentStr += '<tr>';	
   	                	}
   	                	if(typeof(properties[i].peopertName)=="undefined"){
   	                		var mustMark ="";
   	                		if(properties[i].requried){
   	                			mustMark = "<font color=\"red\">*</font>";
   	                		}
   	                		domElmentStr += '<td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap">'
				                  +mustMark+  properties[i].cname +'：'
				      			  + '</td><td class="cap-td" style="text-align: left;width:35%">';
   	                	}else{
   	                		var mustMark ="";
   	                		if(properties[i].requried){
   	                			mustMark = "<font color=\"red\">*</font>";
   	                		}
   	                		domElmentStr += '<td class="cap-td" style="text-align: right;width:100px" nowrap="nowrap" title="'+properties[i].peopertName+'">'
			                 +mustMark +  properties[i].cname +'：'
			      			  + '</td><td class="cap-td" style="text-align: left;width:35%">';
   	                	}
                   		
   					    var uiConfig=eval("("+properties[i].propertyEditorUI.script+")");
   					    domElmentStr += '<span width="100%"'+properties[i].propertyEditorUI.componentName;
   					    for(var name in uiConfig){
   					    	if(name=='ng-model'){
   					    		domElmentStr +=" "+name+'="ngModel.methodOption.'+uiConfig[name]+'"'
   					    		domElmentStr +=" "+"name"+'="'+uiConfig[name]+'"';
   					    	}else{
   					    		domElmentStr +=" "+name+'="'+uiConfig[name]+'"'
   					    	}
   					    }
   					    domElmentStr +='></span></td>' 
				    	if(i == len-1 && len%2 != 0){
   					    	domElmentStr += '<td class="cap-td" style="width:100px"></td><td class="cap-td" style="width:35%"></td>';
   					    } 
   					    if(!isNewline){
   	                		domElmentStr += '</tr>';	
   	                	}
   	                }
   		            if(domElmentStr!=null && domElmentStr!=""){
   		            	jQuery(element).append(domElmentStr);
   		            	$compile(element.contents())(scope);
   			        }
        		}
            },true);

            function isExclude(propertie) {
              if(propertie == null || propertie.ename == null) {
                return true;
              }

              return exclude.indexOf(propertie.ename + ',') != -1;
            }
        }
    };
}]);
//js自定义文本域指令
CUI2AngularJS.directive('cuiCode', ['$interpolate', '$window',function ($interpolate, $window) {
    return {
        restrict: 'A',
        replace: false,
        require: 'ngModel',
        scope: {
            ngModel: '=',
            ngCode: '=',
            ngOut: '=',
             id:'@'
        },
        template: '<textarea id="textarea_{{id}}" name="code"></textarea>',
        link: function (scope, element, attrs, controller) {
        	scope.safeApply = function (fn) {
                var phase = this.$root.$$phase;
                if (phase == '$apply' || phase == '$digest') {
                    if (fn && (typeof(fn) === 'function')) {
                        fn();
                    }
                } else {
                    this.$apply(fn);
                }
            };
            var editor =null;
            scope.$watch("ngModel",function(newValue, oldValue, scope){
                if(editor==null){
                	var isReadOnly = $.trim(scope.ngCode) == '' && (typeof globalReadState === 'undefined' || globalReadState == false)  ? false : true;//nocursor会禁止copy功能，所以用true
                      editor = CodeMirror.fromTextArea(document.getElementById("textarea_"+attrs.id), {
                    	lineNumbers: false,
    	                extraKeys: {
    	                	"Ctrl-Q": "autocomplete",
    	                	"F11": function(cm) {
      	                      cm.setOption("fullScreen", !cm.getOption("fullScreen"));
      	                    },//全屏
      	                    "Esc": function(cm) {
      	                      if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
      	                    }//全屏
    	                },
    	                mode: {name: "javascript", globalVars: true},
    	                theme:'eclipse',
    	                lineWrapping:true,
    	                readOnly: isReadOnly
                    });
                    if(!isReadOnly){
                        editor.on('keypress', function(instance, event) {
        	                if(event.charCode>=46 || (event.charCode>=65 && event.charCode<=90) || (event.charCode>=97 && event.charCode<=122)){
        	                    setTimeout(function(){
        	                      editor.showHint();  //满足自动触发自动联想功能  
        	                    },1)
        	                }         
        	            }); 
                        
                        editor.on('change', function(instance, changeObj) {
                        	scope.safeApply(function(){
                        		scope.ngOut = instance.getValue();
                        		scope.ngModel.methodBodyExtend[scope.id]=scope.ngOut;
                        	});
        	            });
                    	//editor.setOption("theme", 'ambiance');
                    } else {
                    	$("#"+attrs.id).find('.CodeMirror').css({background: "#F5F5F5"});
                    }
                }
                if(!isNaN(scope.id)){
                	var template=$interpolate(scope.ngCode);
                	scope.ngOut = template(scope.ngModel);
                    editor.setValue(scope.ngOut);
                } else if (newValue == oldValue){
                	editor.setValue(scope.ngOut);
                }
                editor.refresh();//偶然内容显示不全，所以CodeMirror浏览器更新了布局根据新的内容（CodeMirror插件内部bug导致）
            },true);

            scope.$on('codeEditorRefresh', function (event) {
                if(editor) {
                  editor.refresh();
                }
            });
        }
    }
}]);

//js自定义文本域指令
CUI2AngularJS.directive('pageAttribute', function () {
    return {
        restrict: 'A',
        replace: false,
        require: 'ngModel',
        transclude: true,
        scope: {
            ngModel: '='
        },
        templateUrl: 'js/tmp.html',
        link: function (scope, element, attrs, controller) {
        	scope.safeApply = function (fn) {
                var phase = this.$root.$$phase;
                if (phase == '$apply' || phase == '$digest') {
                    if (fn && (typeof(fn) === 'function')) {
                        fn();
                    }
                } else {
                    this.$apply(fn);
                }
            };
        }
    }
});

//打开数据字典选择界面
function openDictionarySelect(objHtml) {
	var propertyName = "code";
	if(objHtml&&objHtml!=null&&objHtml!=""){
		 propertyName = objHtml.id;
	}
	var url = '../dictionary/SelectDictionary.jsp?sourceModuleId=' + packageId + '&propertyName='+propertyName+'&callbackMethod=dicSelectCallback';
	var top=(window.screen.availHeight-600)/2;
	var left=(window.screen.availWidth-800)/2;
	window.open (url,'dictionarySelect','height=600,width=800,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
}

//打开数据字典选择界面回调函数
function dicSelectCallback(propertyName, configItemFullCode){
	scope.selectPageActionVO.methodOption[propertyName] = configItemFullCode;
	scope.$digest();
}

/**
 * 根据行为模版ID，获取行为实例对象
 * @param actionTemplateId 控件ID
 */
function getActionTemplate(actionTemplateId){
	var actionDefine = {};
	dwr.TOPEngine.setAsync(false);
	ActionDefineFacade.loadModelByModelId(actionTemplateId, function(data){
		actionDefine = data;
	});
	dwr.TOPEngine.setAsync(true);
	return actionDefine;
}

//转为自定义行为 模版
function transferCustomAction(){
	cui.confirm("确定要把当前行为模版转为自定义行为模版吗？",{
		onYes:function(){ 
			var actionDefineVO = getActionTemplate('actionlibrary.formAction.action.customParamsAction');
			var selectPageActionVO = {};
			selectPageActionVO.pageActionId = scope.selectPageActionVO.pageActionId;
			selectPageActionVO.cname = scope.selectPageActionVO.cname;
			selectPageActionVO.ename = scope.selectPageActionVO.ename;
			selectPageActionVO.description = scope.selectPageActionVO.description;
			selectPageActionVO.actionDefineVO = actionDefineVO;
			selectPageActionVO.initPropertiesCount = actionDefineVO.properties.length;
			selectPageActionVO.methodTemplate = actionDefineVO.modelId;
			
			//将转换前的模板js列表赋给页面includeFile  ,解决转自定义模板后js文件丢失问题
			addJsToPage(scope.selectPageActionVO.actionDefineVO.js);
			
			selectPageActionVO.methodBodyExtend = {before: ""};
			selectPageActionVO.methodOption = {definedParams: ""};
			var methodBody = scope.selectPageActionVO.methodBody;
			initCodemirrors(selectPageActionVO, actionDefineVO);
			var reg = new RegExp(getMatchFunctionRegular(scope.selectPageActionVO.ename));
			var matchs = methodBody.match(reg);
			if(matchs != null){
				selectPageActionVO.methodBodyExtend.before = methodBody.substring(methodBody.lastIndexOf(matchs[0])+matchs[0].length, methodBody.lastIndexOf("}"));
				selectPageActionVO.methodOption.definedParams = matchs[1];
				scope.codemirrors[scope.selectPageActionVO.pageActionId][1].out = selectPageActionVO.methodBodyExtend.before;
			}
			scope.selectPageActionVO = selectPageActionVO;
			for(var i in scope.root.pageActions){
				if(scope.root.pageActions[i].pageActionId === scope.selectPageActionVO.pageActionId){
					scope.root.pageActions[i] = scope.selectPageActionVO;
					break;
				}
			}
			scope.hasShowTransferActionBtn = false;
			cap.digestValue(scope);
		}
	});
}

//将转换前的模板js列表赋给页面includeFileList
function addJsToPage(jsArray){
	if(jsArray && jsArray.length>0){
		for(var k = 0; k < jsArray.length; k++){
			var includeFile = {fileName:"", filePath:"",  fileType:"", defaultReference:false};
			var jsPath = jsArray[k];
			var jsFile = jsPath.substring(jsPath.lastIndexOf("/")+1);
			var jsFileName = jsFile.substring(0,jsFile.lastIndexOf("."));
			var jsFileType = jsFile.substring(jsFile.lastIndexOf(".")+1);
			includeFile.fileName = jsFileName;
			includeFile.filePath = jsPath;
			includeFile.fileType = jsFileType;
			//判断是否存在相同路劲的文件
			var existFlag = false;
			for(var m = 0; m< page.includeFileList.length; m++){
				if(page.includeFileList[m].filePath == includeFile.filePath){
					existFlag = true;
					break;
				}
			}
			if(!existFlag){
				page.includeFileList.push(includeFile);
			}
		}
		//通过消息通讯的方式刷新pageInfoFrame页面
		if(window.parent){
        	window.parent.$("#pageInfoFrame")[0].contentWindow.postMessage({type: "pageAction"}, "*");
        } 
	}
}

//设置“转自定义行为”按钮显示/隐藏状态
function setTransferActionBtnState(scope){
	var methodTemplate = scope.selectPageActionVO.methodTemplate;
	if(methodTemplate != '' && methodTemplate != 'actionlibrary.formAction.action.customParamsAction'){
		var reg = new RegExp(getMatchFunctionRegular(scope.selectPageActionVO.ename));
		scope.hasShowTransferActionBtn = scope.selectPageActionVO.methodBody.match(reg) != null ? true : false;
	} else {
		scope.hasShowTransferActionBtn = false;
	}
}

/**
 * 获取匹配函数方法的正则表达式
 * @param 函数名称 methodName
 */
function getMatchFunctionRegular(methodName){
	return "function[\\s]+"+methodName+"[\\s]*\\(([\\w,\\s]*)\\)[\\s]*{";
}

//设置方法体
function setMethodBody(){
	if(scope.codemirrors && scope.selectPageActionVO){
		var codemirrors = scope.codemirrors[scope.selectPageActionVO.pageActionId];
		if(codemirrors != null){
			var strCode="";
			for(var i=0, len=codemirrors.length; i<len; i++){
				strCode += codemirrors[i].out + "\n";
			}
			scope.selectPageActionVO.methodBody = strCode;
			setTransferActionBtnState(scope);
		}
	}
}