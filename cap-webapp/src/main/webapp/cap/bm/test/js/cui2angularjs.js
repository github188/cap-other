var CUI2AngularJS = angular.module("cui", []);

var cap = cap?cap:{};
/**
 * 根据模型生成校验对象
 */
cap.validater = cui().validate();

/**
 * 校验表单并弹出校验错误信息
 */
cap.validateForm=function(){
	var result=true;
	var validOjb=cap.validater.validAllElement();
    var validateResult=validOjb[2];
    var validateMessage=validOjb[0];
    var str="";
    if(!validateResult){
        for(var i=0;i<validateMessage.length;i++){
            str=str+validateMessage[i].message+"<br/>";
        }
        result=false;
        cui.error("请修正表单错误再进行操作：<br/>"+str);
    }
    return result;
}

CUI2AngularJS.directive('cuiInput', function () {
	return CUI2AngularJS.getDirectiveCode("input","",["on_change","on_keyup"],{readonly:true});
});

CUI2AngularJS.directive('cuiCheckboxgroup', function () {
	return CUI2AngularJS.getDirectiveCode("checkboxGroup",[],["on_change"]);
});

CUI2AngularJS.directive('cuiRadiogroup', function () {
	return CUI2AngularJS.getDirectiveCode("radioGroup",[],["on_change"],{radio_list:true,readonly:true});
});

CUI2AngularJS.directive('cuiCalender', function () {
	return CUI2AngularJS.getDirectiveCode("calender","",["on_change"]);
});

CUI2AngularJS.directive('cuiTextarea', function () {
	return CUI2AngularJS.getDirectiveCode("textarea","",["on_change","on_keyup"]);
});

CUI2AngularJS.directive('cuiClickinput', function () {
	return CUI2AngularJS.getDirectiveCode("clickInput","",["on_change","on_keyup","on_iconclick"]);
});

CUI2AngularJS.directive('cuiPulldown', function () {
	return CUI2AngularJS.getDirectiveCode("pullDown","",["on_change","on_keyup"],{datasource:true,select:"number",readonly:true,editable:true,must_exist:true,auto_complete:true});
});

CUI2AngularJS.directive('cuiButton', function () {
    return {
        restrict: 'A',
        scope: {
        },
        compile: function (element, attributes) {
            return {
                pre: function preLink(scope, element, attrs) {
                	var options = {};
                	//设置CUI属性值
        			for(var node in element[0].attributes){
        				options[element[0].attributes[node].name]=CUI2AngularJS.getAttrValue({},element[0].attributes[node].name,attrs);
                    }
                    cui(element).button(options);
                }
            };
        }
    }
});

CUI2AngularJS.directive('cuiTree', function () {
    return {
        restrict: 'A',
        require: 'ngModel',
        scope: {
        	ngModel: '=ngModel'
        },
        link: function (scope, element, attrs, controller) {
        	if (!controller) return;

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

            var onChangeValue = function (oldVal, newVal) {
            	scope.ngModel = cui("#"+attrs.id).getDatasource();
            	controller.$setViewValue(scope.ngModel);
                scope.safeApply(function () {
                	scope.ngModel = cui("#"+attrs.id).getDatasource();
                });
            }
            
            var watchEvent=["on_expand","on_click"];
            var options = {};
            for(var i=0;i<watchEvent.length;i++){
            	options[watchEvent[i]]=onChangeValue;
            }
            //设置CUI属性值
			for(var node in element[0].attributes){
				options[element[0].attributes[node].name]=CUI2AngularJS.getAttrValue({},element[0].attributes[node].name,attrs);
            }
			
            cui(element).tree(options);
            
            controller.$render = function () {
            	cui("#"+attrs.id).setDatasource(controller.$viewValue || []);
            };
        }
    };
});

/**
 * uiType:CUI构建组件的方法名
 * defaultValue:当绑定属性为null时的默认值
 * watchEvent:监听的组件的事件
 */
CUI2AngularJS.getDirectiveCode=function(uiType,defaultValue,watchEvent,JSONAttr){
	return {
        restrict: 'A',
        require: 'ngModel',
        scope: {
        	ngModel: '=ngModel'
        },
        link: function (scope, element, attrs, controller) {
            if (!controller) return;
            //调用angularJS脏值检查
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

            //控件值改变事件回调
            var onChangeValue = function (oldVal, newVal) {
            	scope.ngModel = cui(element).getValue();
            	controller.$setViewValue(scope.ngModel);
                scope.safeApply(function () {
                	scope.ngModel = cui(element).getValue();
                });
            }
            
            var options = {};
            //设置CUI控件值变化监控事件
            for(var i=0;i<watchEvent.length;i++){
            	options[watchEvent[i]]=onChangeValue;
            }
            //设置CUI属性值
			for(var node in element[0].attributes){
				options[element[0].attributes[node].name]=CUI2AngularJS.getAttrValue(JSONAttr,element[0].attributes[node].name,attrs);
            }
			//创建控件
            cui(element)[uiType](options);
            //增加校验
            var validate=options.validate;
			if(validate){
				var validates=eval(validate);
				for(var i=0;i<validates.length;i++){
					cap.validater.add(cui(element), validates[i].type, validates[i].rule);
	            }
				cui.tip(element, {tipEl: cui(element).options.el});
			}
			//渲染时设置控件值
            controller.$render = function () {
            	cui(element).setValue(controller.$viewValue || defaultValue);
            };
        }
    };
}

//根据属性名称取值
CUI2AngularJS.getAttrValue=function (JSONAttr,attrName,attrs) {
	//使用angularjs规则转化标签属性
	function getAttrName(attrName,splitFlag,isToLowerCase){
		var angularAttrName=attrName;
		if(attrName!=null){
			angularAttrName="";
			var attrNames=attrName.split(splitFlag);
			var nameIndex=0;
			for(var index in attrNames){
				var name=attrNames[index];
				if(name!=""){
					if(isToLowerCase){
						name=name.toLowerCase();
					}
					if(nameIndex>0){
						name=name.replace(/(\w)/,function(v){return v.toUpperCase()})
					}
					nameIndex++;
				}
				angularAttrName+=name;
			}
		}
		return angularAttrName;
	}
	var name=getAttrName(attrName,"_",true);
	name=getAttrName(name,"-",false);
	var result=null;
	if(JSONAttr && JSONAttr[attrName]){
		if(JSONAttr[attrName]=="number"){
			result=parseInt(attrs[name]);
		}else{
			result=eval(attrs[name]);
		}
	}else{
		result=attrs[name];
	}
	return result;
};