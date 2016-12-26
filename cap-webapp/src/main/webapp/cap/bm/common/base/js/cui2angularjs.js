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
    var render = function () {
    	if(!this.controller.$viewValue){//实现对select属性的支撑
    		var options = cui(this.element).options, selectIndex = cui(this.element).options.select;
    		this.controller.$viewValue = selectIndex > -1 && cui(this.element).data && cui(this.element).data.length > selectIndex ? cui(this.element).data[selectIndex][options.value_field] : this.defaultValue;
    	}
    	cui(this.element).setValue(this.controller.$viewValue);
    	this.scope.ngModel = cui(this.element).getValue();
    }
	return CUI2AngularJS.getDirectiveCode("pullDown","",["on_change","on_keyup"],{datasource:true,select:"number",readonly:true,editable:true,must_exist:true,auto_complete:true}, render);
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
                    var watchEvent = 'on_click';    // 处理button的onclick事件
                    if(options[watchEvent] && typeof options[watchEvent] === 'string') {
                        // 兼容以前将事件写在module外的写法（不推荐这样写）
                        // 只有当scope中存在且window中不存在的时候才绑定对应的值
                        if(typeof scope.$parent[options[watchEvent]] === 'function' && !(typeof window[options[watchEvent]] === 'function')) {
                            options[watchEvent] = scope.$parent[options[watchEvent]];
                        }
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

            //控件事件绑定到scope里的方法中 add by yangsai 2016年7月21日11:29:01
            for(var i=0;i<watchEvent.length;i++){
                //对应事件为string而不是function
                if(options[watchEvent[i]] && typeof options[watchEvent[i]] === 'string') {
                    // 兼容以前将事件写在module外的写法（不推荐这样写）
                    // 只有当scope中存在且window中不存在的时候才绑定对应的值
                    if(typeof scope.$parent[options[watchEvent[i]]] === 'function' && !(typeof window[options[watchEvent[i]]] === 'function')) {
                        options[watchEvent[i]] = scope.$parent[options[watchEvent[i]]];
                    }
                }
            }
			
            cui(element).tree(options);
            
            controller.$render = function () {
            	cui("#"+attrs.id).setDatasource(controller.$viewValue || []);
                if(controller.$viewValue && controller.$viewValue.expandKey) {   //tree 需要默认展开的节点key
                    var sourceModuleId = controller.$viewValue.expandKey;
                    var sourceNode = sourceModuleId ? cui("#"+attrs.id).getNode(sourceModuleId) : null;
                    if(sourceNode) {    //需要自动定位到对应实体应用方便于用户选择
                        sourceNode.activate();
                        sourceNode.expand();
                        // 滚动到对应的展开并选中的节点，方便用户选择
                        // 1. 获取展开并选中的节点偏移量
                        var nodeOffset = $(".dynatree-active", "#"+attrs.id).offset().top;
                        // 2.首先确定有滚动条的父元素 判断方式：元素scrollHeight>clientHeight
                        var parentsel = $("#" + attrs.id).parents();
                        for (var i = 0; i < parentsel.length; i++) {
                            var parentel = parentsel[i];
                            if(parentel.scrollHeight > parentel.clientHeight) {     //有滚动
                                console.debug("scroll element %s height : %s - %s",parentel, parentel.scrollHeight, parentel.clientHeight);
                                // 滚动到对应区域
                                $(parentel).scrollTop($(".dynatree-active").offset().top - $(".module-choose-container").offset().top);
                                // 再次计算展开并选中的节点偏移量判断是否滚动成功
                                if($(".dynatree-active").offset().top != nodeOffset) {
                                    console.debug("scroll before %d : after %d ", nodeOffset, $(".dynatree-active").offset().top);
                                    break;
                                }
                            }
                        }
                    }
                }
            };
        }
    };
});

/**
 * uiType:CUI构建组件的方法名
 * defaultValue:当绑定属性为null时的默认值
 * watchEvent:监听的组件的事件
 */
CUI2AngularJS.getDirectiveCode=function(uiType,defaultValue,watchEvent,JSONAttr, render){
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
			//控件事件绑定到scope里的方法中 add by yangsai 2016年7月21日11:29:01
            for(var i=0;i<watchEvent.length;i++){
                //对应事件为string而不是function
                if(options[watchEvent[i]] && typeof options[watchEvent[i]] === 'string') {
                    // 兼容以前将事件写在module外的写法（不推荐这样写）
                    // 只有当scope中存在且window中不存在的时候才绑定对应的值
                    if(typeof scope.$parent[options[watchEvent[i]]] === 'function' && !(typeof window[options[watchEvent[i]]] === 'function')) {
                        options[watchEvent[i]] = scope.$parent[options[watchEvent[i]]];
                    }
                }
            }
            //初始化cui对象
            cui(element)[uiType](options);
            //增加校验
            var validate=options.validate;
            // validates可以定义在scope里且可以使用scope里的变量，参考EntityAttrEdit.jsp的 validateAttrEnName 方法的使用
            var validates = scope.$parent.$eval(validate) || eval(validate);
            if(validates){
                // console.log(validates, validate);
				for(var i=0;i<validates.length;i++){
					cap.validater.add(cui(element), validates[i].type, validates[i].rule);
	            }
				cui.tip(element, {tipEl: cui(element).options.el});
			}
			//渲染时设置控件值
            controller.$render = (render && render.bind({scope:scope,element:element,attrs:attrs,controller:controller,uiType:uiType,defaultValue:defaultValue,watchEvent:watchEvent,JSONAttr:JSONAttr})) || function () {
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
