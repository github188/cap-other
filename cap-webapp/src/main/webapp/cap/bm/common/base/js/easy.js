/**
 * defined global namespace
 * @author lingchen WWW.SZCOMTOP.COM
 * @version 1.0
 * @type {{}}
 */
var comtop = comtop || {};

/**
 * if the iteratively window has parent and the parent is not itself and the parent is not current window,
 * then judge the parent window has or hasn't we need <code>key</code>.
 * if has,return immediately,else assignment the parent window to the iteratively window,then enter the next each.
 *
 * else if the iteratively window has opener and the opener is not itself and the opener is not current window,
 * then judge the opener window has or hasn't we need <code>key</code>.
 * if has,return immediately,else assignment the opener window to the iteratively window,then enter the next each.
 *
 * if the iteratively window has not parent and opener,return null.
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2015-09-02
 * @param key the key for search parent window
 */
(function(comtop){
    comtop.searchParentWindow = function(key){
        //get key from current window
        if(window[key]){
            return window;
        }

        var _window = window;
        //each window
        while(true){
        	try{
	            if(_window.parent && _window.parent != _window && _window.parent != window){
	                if(_window.parent[key]){
	                    return _window.parent;
	                }else{
	                    _window = _window.parent;
	                }
	            }else if(_window.opener && _window.opener != _window && _window.opener != window){
	                if(_window.opener[key]){
	                    return _window.opener;
	                }else{
	                    _window = _window.opener;
	                }
	            }else if(_window == window){
	                return null;
	            }else{
	                return null;
	            }
        	}catch(err){
        		return null;
        	}
        }
    };
})(comtop || (comtop = {}));

/**
 *
 * 本函数实现数组删除元素的功能。
 *
 * 说明：
 * 1.支持js原始类型数据的删除，e.g.: boolean\number(包括Infinity和-Infinity,但不包括NaN)\string\null\undefined
 * 2.支持js中typeof运算后为object的对象数据删除。但不支持使用原始数据类型的包装器类型new出的对象(e.g.: new Number(1)\new Boolean(false)\new String("hello"))以及空对象(e.g.: new Oject()\{})
 * 3.支持js中自定义的类对象删除，要求对象必须至少有一个属性来承担比较的key.注意：本函数只支持单key比较，key为对象元素for in出来的第一个属性，即target数组里面的对象元素for in出来的第一个属性为key，若有多个属性，除第一个属性外，其他属性将被忽略。
 * 4.不支持function类型元素的删除。
 * 5.不支持对多维数组元素的删除，只支持一纬数组。
 * <pre>
 * function Human(name,age){
 * 		this.name = name;
 * 		this.age = age;
 * }
 *
 * var source = [1,2,3,1,4,3,5,true,"false",null,undefined,Infinity,new Human("z3",20),new Human("w5",22),{id:20,text:"some data"}];
 * var target = [0,1,3,5,"false","true",null,undefined,Infinity,new Human("z3",55),{name:"w5"},{id:20}];
 *
 * var result = comtop.array.remove(source,target,true);
 *
 * result:[2,4,true]
 * </pre>
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2015-09-16
 *
 * @param source 需要删除元素的数组 (必须) e.g.: [1,2,5,3,4,3,5]
 * @param target 哪些元素需要删除组成的数组 (必须) e.g.: [3,5,6],3、5、6就是需要从source里面准备删除的元素
 * @param flag 是否从source里面一并删除重复的元素 true or false （可选） e.g.: source里面的重复项3、5在删除的时候是全部删掉还是只删除第一个。(号外：如果target里面也有两个3、5，则就算falg = false，也会把source里面的重复项3、5一起删除)
 * @return source经过删除后的结果（同一引用）。
 */
(function(comtop){
    comtop.array = {
        remove : function(source,target,flag) {
            //验证输入合法性
            if(arguments.length < 2){
                throw new Error("the remove() function must have two parameters of the array type at least.");
            }
            if(Object.prototype.toString.call(arguments[0]) !== "[object Array]" || Object.prototype.toString.call(arguments[1]) !== "[object Array]"){
                throw new Error("the first two parameters for the remove() function must all be the type of array.");
            }
            if(arguments.length >= 3 && typeof arguments[2] != "boolean"){
                throw new Error("the thirdly parameter for the remove() function must be the type of boolean, e.g.: true or false.");
            }

            //定义是否匹配到了源数组的元素。
            var matched = false;

            //开始进行匹配
            for(var i = 0, len = target.length; i < len; i++){
                for(var k = 0, _len = source.length; k < _len; k++){
                    //对象类型匹配,不支持new Boolean(true)\new String("123")\new Number(123)\new Object或{}空对象\function类型\NaN进行匹配。
                    //不支持多维数组匹配。
                    if(target[i] && typeof target[i] == "object"){
                        if(source[k] && typeof source[k] == "object"){

                            //深度遍历对象属性进行匹配
                            var recursion = function(_target,_source){
                                var key;
                                for(var attr in _target){
                                    key = attr;
                                    break;
                                }
                                if(key){
                                    if(typeof _target[key] == "object" && typeof _source[key] == "object"){
                                        return arguments.callee(_target[key],_source[key]); //递归深度遍历属性
                                    }else{
                                        return _target[key] === _source[key]
                                    }
                                }
                                return false;
                            }

                            var result = recursion(target[i],source[k]);

                            if(result){
                                matched = true;
                                source.splice(k,1);//删除
                                break;
                            }
                        }
                    }else{ //原始类型匹配
                        if(target[i] === source[k]){
                            matched = true;
                            source.splice(k,1);//删除
                            break;
                        }
                    }
                }
                if(matched && flag){ //开启源数组重复项全部删除
                    --i;
                    matched = false;
                }
            }

            return source;
        },
        /**
         * 在数组的指定位置插入一个元素
         *
         * @param item 待插入的元素
         * @param index 插入的位置
         * @param arr 插入到arr数组中
         */
        insert : function(item,index,arr){
            //验证输入合法性
            if(arguments.length < 3){
                throw new Error("the insert() function must have three parameters of the array type at least.");
            }
            //验证输入合法性
            if(!/^\d+$/.test(arguments[1])){
                throw new Error("the second parameter must be a digit.");
            }
            //验证输入合法性
            if(Object.prototype.toString.call(arguments[2]) !== "[object Array]"){
                throw new Error("the thirdly parameter must be an array.");
            }
            arr.splice(index, 0, item);
        }
    };
})(comtop || (comtop = {}));



/**
 * 从页面的访问url去获取指定的参数
 * 
 * @param paramName 参数的名称。必填
 * @param url 页面的url，可不传。不传默认使用window.location.href去获取
 * @return 参数对应的值
 * @exception 当调用此方法，没有传任何参数，将抛出异常
 */
(function(comtop){
	comtop.getURLParameter = function(paramName, url){
		if(arguments.length == 0){
			throw new Error("the function named 'getParameter' must has one argument at least.");
		}
		var url = url ? url : window.location.href;
		var urlSplit = url.split("?");
		if(urlSplit.length == 1 || !urlSplit[1]){
			return null;
		}

		var params = urlSplit[1].split("&");
		for(var i = 0, len = params.length; i < len; i++){
			if(!params[i] || params[i].split("=").length < 2){
				continue;
			}
			if(paramName === params[i].split("=")[0]){
				return params[i].split("=")[1];
			}
		}

		return null;
	};
})(comtop || (comtop = {}));

/**
 *
 * 本函数实现对目标对象中的字符串属性进行trim操作。
 *
 * 目标对象：可以是基础类型的字符串，可以是String对象，也可以是数组或Object。
 *
 * 该函数支持是否对目标对象的属性（如对象中的Object、Array、String属性）深度遍历进行trim操作。但永远不会对原型链上的属性进行trim。
 *
 * 调用方式如下：
 * <pre>
 *
 * var result = comtop.trim(target);
 * 或
 * var result = comtop.trim(target, true);
 * 或
 * var result = comtop.trim(target, false);
 *
 * </pre>
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-05-10
 *
 * @param target 目标对象
 * @param true/false 是否对目标对象进行深入遍历trim(若不传此参数，则默认为深度遍历)
 * @return target经过trim后的结果（同一引用）。
 */
(function(comtop){
    comtop.trim = function(){
        //trim函数必须至少要有一个参数
        if(arguments.length === 0){
            throw new Error("the trim() function needs to have at least one parameter.");
        }
        //有第二个参数，就必须是boolean类型
        if(arguments.length >= 2 && typeof arguments[1] !== "boolean"){
            throw new Error("the second parameter of the trim() function must be a boolean variable.");
        }

        //默认为深度遍历
        var flag = true;
        if(arguments.length >= 2){
            flag = arguments[1];
        }
        var target = arguments[0];
        //处理字符串类型
        if(typeof target === "string"){
            return target.replace(/^(\s|\u00A0)+/,'').replace(/(\s|\u00A0)+$/,'');
        }
        //处理对象类型
        if(Object.prototype.toString.call(target) === "[object Object]"){
            for(var attr in target){
                //原型链上的属性不处理
                if(Object.prototype.hasOwnProperty.call(target,attr) && !( /^jQuery\d+$/.test(attr))){
                    if(flag || typeof target[attr] === "string"){
                        target[attr] = arguments.callee(target[attr]);
                    }
                }
            }
        }
        //处理String对象
        if(Object.prototype.toString.call(target) === "[object String]"){
            target = new String(target.replace(/^(\s|\u00A0)+/,'').replace(/(\s|\u00A0)+$/,''));
        }
        //处理数组类型
        if(Object.prototype.toString.call(target) === "[object Array]"){
            for(var k = 0; k < target.length; k++){
                if(flag || typeof target[k] === "string"){
                    target[k] = arguments.callee(target[k]);
                }
            }
        }

        return target;
    };
})(comtop || (comtop = {}));

/**
 * comtop.money.format实现对金额的格式化;
 * comtop.money.parse实现对格式化的金额字符串转number类型。
 *
 * 格式化规则为从整数末尾计算，每三位后加个英文逗号分隔符，如12,735,920.64
 * 解析金额字符串规则为去英文逗号
 *
 * 格式化函数支持接收string类型和number类型的金额格式化，支持正负数，支持.52这种格式的参数。
 * 格式化校验规则，以下被认定为非法金额数：
 * 1、number类型的NaN|Infinity|-Infinity；
 * 2、string类型包含两个及以上的小数点；
 * 3、string类型不包含任何数字。
 *
 * e.g.:
 * <pre>
 *     var formatStr = comtop.money.format("+123456.520"); ==> +123,456.520
 *     var formatStr = comtop.money.format("+.520"); ==> +.520
 *     var formatStr = comtop.money.format(+123456.520); ==> 123,456.52
 *     var formatStr = comtop.money.format("123a456b.52d0"); ==> 123,456.520
 *
 *     var parseNum = comtop.money.parse("123,456.520"); ==> 123456.52
 *     var parseNum = comtop.money.parse("+12a3,4b56.5d20"); ==> 123456.52
 *     var parseNum = comtop.money.parse("-123,456.5"); ==> -123456.5
 *     var parseNum = comtop.money.parse("+123,456.5"); ==> 123456.5
 *     var parseNum = comtop.money.parse("+.5"); ==> 0.5
 * </pre>
 *
 * 解析函数只支持接收string类型参数。
 * 解析校验规则，以下被认定为非法金额数：
 * 1、非string类型；
 * 2、string类型包含两个及以上的小数点；
 * 3、string类型不包含任何数字。
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-05-26
 *
 * @param money 金额的字符串表现形式或number类型的数据
 *
 * @return 金额格式化后的字符串表现形式或解析后的金额的number类型数值
 */
(function(comtop){
    comtop.money = {
        format : function() {
            //must have on parameter at least
            if(arguments.length == 0){
                throw new Error("the format() function must have one parameter at least.");
            }
            //parameter must be string or number
            if(Object.prototype.toString.call(arguments[0]) !== "[object String]" && Object.prototype.toString.call(arguments[0]) !== "[object Number]"){
                throw new Error("the parameter is illegal.");
            }
            //exclude NaN|Infinity|-Infinity
            if(arguments[0] !== arguments[0] || arguments[0] === Infinity || arguments[0] === -Infinity){
                throw new Error("the parameter is illegal.");
            }

            //validate and process
            var moneyStr = this._innerFunction(arguments[0]);

            var _array = /([\d\-\+]*)[.]?(\d*)/g.exec(moneyStr);
            //process integer
            var integer = '';
            if(_array[1]){
                //string reverse
                var _revers = _array[1].split("").reverse().join("");
                for(var i = 1; i <= _revers.length; i++){
                    integer += _revers.charAt(i-1);
                    if(i % 3 === 0 && i !== _revers.length && /[^\-\+]/.test(_revers.charAt(i))){
                        integer += ",";
                    }
                }
            }
            //reverse ingeter
            if(integer){
                integer = integer.split("").reverse().join("");
            }
            //append decimals and return
            return integer + (_array[2] ? ("." + _array[2]) : "");
        },
        parse : function() {
            //must have on parameter at least
            if(arguments.length == 0){
                throw new Error("the parse() function must have one parameter at least.");
            }

            //parameter must be string
            if(Object.prototype.toString.call(arguments[0]) !== "[object String]"){
                throw new Error("the parameter is illegal.");
            }

            //validate and process
            var moneyStr = this._innerFunction(arguments[0]);
            //drop "," char
            moneyStr = moneyStr.replace(/[,]/g,"");

            return parseFloat(moneyStr);
        },
        _innerFunction : function() {
            //case to string
            var moneyStr = arguments[0] + "";
            //exclude have two point
            var matcher = moneyStr.match(/\./g);
            if(matcher && matcher.length > 1){
                throw new Error("the parameter is illegal.");
            }

            //drop the illegal chars
            moneyStr = moneyStr.replace(/[^\d\.\-\+]/g, '');
            if(moneyStr === ''){
                throw new Error("the parameter is illegal.");
            }

            //drop extra '-' and '+' chars
            var moneyFirstChar = moneyStr.substring(0, 1);
            moneyStr = moneyFirstChar + moneyStr.substring(1).replace(/[\-\+]/g, '');

            //if the last char is point, drop it
            if(moneyStr.charAt(moneyStr.length-1) === "."){
                moneyStr = moneyStr.substring(0, moneyStr.length-1);
                if(moneyStr === ''){
                    throw new Error("the parameter is illegal.");
                }
            }
            return moneyStr;
        }
    };
})(comtop || (comtop = {}));

/**
 * 重置当前活动的元素的焦点(即让当前获得焦点的元素先失去焦点，然后再获取焦点，常用于让元素能失去焦点而获取最新的值)
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-05-26
 */
(function(comtop){
    comtop.resetFocus = function(){
        var _element = document.activeElement;
        if(_element){
            _element.blur();
            _element.focus();
        }
    };
})(comtop || (comtop = {}));

/**
 * 继承服务提供者
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-06-13
 */
(function(comtop){
    /**
     * 定义继承服务提供者。
     * 它有一个静态方法extend，实现两个类之间建立继承关系。
     * 一旦两个类之间建立起继承关系，则子类就继承了父类原型对象上的属性和方法，子类自己原型对象上的属性和方法不会丢失。
     * 同时，子类的构造函数额外的具备了一个属性superClass，此属性不可枚举，值为父类的构造函数，其作用是供子类构造器中调用，以继承父类构造器中定义的属性和方法。
     * 可以在子类的构造器中像这样使用来继承父类构造器中定义的属性和方法，如下：
     * <pre>
     *     arguments.callee.superClass.call(this,param1, param2, param3, ...);
     * <pre>
     * @type {{extend: Function}}
     */
    comtop.ExtendProvider = {
        /**
         * ExtendProvider的静态方法，实现两个类之间的继承。
         * @param _subClass 子类
         * @param _supClass 父类
         */
        extend : function(_subClass, _supClass){
            //validate arguments
            if(arguments.length < 2){
                throw new Error("the extend() function must have two parameters.");
            }
            if(Object.prototype.toString.call(arguments[0]) !== "[object Function]" || Object.prototype.toString.call(arguments[1]) !== "[object Function]"){
                throw new Error("the extend() function first two parameters type must be Function.");
            }
            //create mediator
            var Mediator = new Function();
            //set supClass's prototype to mediator
            Mediator.prototype = _supClass.prototype;
            //create a instance of Mediator
            var _mediator = new Mediator();

            //set the attributes of subClass's prototype to Mediator instance
            for(var _attr in _subClass.prototype){
                Object.defineProperty(_mediator, _attr, {
                    value : _subClass.prototype[_attr]
                });
            }
            //set Mediator instance to subClass's prototype
            _subClass.prototype = _mediator;

            //restore the subClass's constructor
            Object.defineProperty(_subClass.prototype, "constructor", {
                enumerable : false,
                value : _subClass
            });

            //add a attribute what is supClass's constructor to subClass. you can use this attribute in subClass's constructor like this "arguments.callee.superClass"
            Object.defineProperty(_subClass, "superClass", {
               enumerable : false,
               value : _supClass
            });
        }
    };
})(comtop || (comtop = {}));

/**
 * 对单个字符串参数判断是否为空
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-06-07
 */
(function(comtop){
    comtop.StringUtil = {
        /**
         * 是否为空（包含判断null、undefined、空串<code>""</code>以及空字符串<code>"    "</code>）。
         *
         * @returns {boolean}
         */
        isBlank : function(){
            if(arguments.length == 1){
                var _str = arguments[0];
                if(_str === null || _str === undefined){
                    return true;
                }else if(Object.prototype.toString.call(_str) === "[object String]"){
                    if(_str.length === 0){
                        return true;
                    }
                    for(var i = 0; i < _str.length; i++){
                        if(_str.charAt(i) !== '\u0020'){
                            return false;
                        }
                    }
                    return true;
                }
            }
            throw new Error("the isBlank() function must be only have one parameter, and the type of the parameter is a string.");
        },
        isNotBlank : function(_str){
            return !this.isBlank(_str);
        },
        /**
         * 是否为空（包含判断null、undefined、空串<code>""</code>）。
         *
         * @returns {boolean}
         */
        isEmpty : function(){
            if(arguments.length == 1){
                var _str = arguments[0];
                if(_str === null || _str === undefined){
                    return true;
                }else if(Object.prototype.toString.call(_str) === "[object String]"){
                    return _str.length === 0;
                }
            }
            throw new Error("the isEmpty() function must be only have one parameter, and the type of the parameter is a string.");
        },
        isNotEmpty : function(_str){
            return !this.isEmpty(_str);
        }
    };
})(comtop || (comtop = {}));

/**
 * 让指定对象的指定属性不能被枚举
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-06-07
 */
(function(comtop){
    /**
     * 让指定对象的指定属性不能被枚举
     * @param obj 指定的对象
     * @param arr 属性数组，字符串类型的数组
     */
    comtop.canNotEnumerable = function(obj, arr){
        for(var i = 0; i < arr.length; i++){
            Object.defineProperty(obj,arr[i],{
                enumerable : false
            });
        }
    };
})(comtop || (comtop = {}));

/**
 * uuid生成器（实现源自jquery）。
 */
(function(comtop){
    var CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    comtop.Math = {
        uuid : function (len, radix) {
            var chars = CHARS, uuid = [], i;
            radix = radix || chars.length;

            if (len) {
                // Compact form
                for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
            } else {
                // rfc4122, version 4 form
                var r;

                // rfc4122 requires these characters
                uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
                uuid[14] = '4';

                // Fill in random data.  At i==19 set the high bits of clock sequence as
                // per rfc4122, sec. 4.1.5
                for (i = 0; i < 36; i++) {
                    if (!uuid[i]) {
                        r = 0 | Math.random()*16;
                        uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
                    }
                }
            }
            return uuid.join('');
        }
    };
})(comtop || (comtop = {}));


/**********************************************String 扩展*********************************
 * 在String的原型上进行扩展，实现String的常用函数。                                           *
 *                                                                                        *
 * @author lingchen WWW.SZCOMTOP.COM                                                      *
 * @Date 2016-06-07                                                                       *
 *******************************************************************************************/

/**
 * 字符串逆序函数
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-06-07
 */
String.prototype.reverse = function(){
    return this.split("").reverse().join("");
};
comtop.canNotEnumerable(String.prototype, ["reverse"]);

/**
 * 将字符串首字母转大写
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-06-07
 */
String.prototype.firstCharToUpperCase = function(){
    var charArray = this.split("");
    if(charArray.length > 0){
        charArray[0] = charArray[0].toUpperCase();
    }
    return charArray.join("");
};
comtop.canNotEnumerable(String.prototype, ["firstCharToUpperCase"]);

/**
 * 将字符串首字母转小写
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-06-07
 */
String.prototype.firstCharToLowerCase = function(){
    var charArray = this.split("");
    if(charArray.length > 0){
        charArray[0] = charArray[0].toLowerCase()
    }
    return charArray.join("");
};
comtop.canNotEnumerable(String.prototype, ["firstCharToLowerCase"]);

/**
 * 将字符串前后去空格
 *
 * @author lingchen WWW.SZCOMTOP.COM
 * @Date 2016-06-07
 */
String.prototype.trim = function(){
    return this.replace(/^(\s|\u00A0)+/,'').replace(/(\s|\u00A0)+$/,'');
};
comtop.canNotEnumerable(String.prototype, ["trim"]);


/**********************************************封装HashMap**********************************
 * 封装HashMap，实现put、get、remove、clear、size、isEmpty、containsKey、keySet等方法。       *
 *                                                                                        *
 * @author lingchen WWW.SZCOMTOP.COM                                                      *
 * @Date 2016-06-07                                                                       *
 *******************************************************************************************/
(function(comtop){
    comtop.HashMap = (function(){
        /**
         * 声明Map类
         * @param _namespace 可选，Map的命名空间,在整个window上必须唯一，字符串类型
         * @constructor Map
         */
        var Map = function(_namespace){
            if(comtop.StringUtil.isNotBlank(_namespace)){
                this.namespace = _namespace;
            }else{
                this.namespace = comtop.Math.uuid().replace(/[-]/g, '_'); //get default namespace from uuid
            }
            //create an object on the window
            window[this.namespace] = window[this.namespace] || {};
        };

        /**
         *  定义Map的常用方法，与java中Map使用方式一致
         */
        Map.prototype = {
            constructor : Map,
            /**
             * 往map中添加键值对。支持链式编程。
             * @param key 键
             * @param value 值
             */
            put : function(key, value){
                if(Object.prototype.toString.call(key) === "[object String]"){
                    window[this.namespace][key] = value;
                }else if(typeof key === "object"){
                    var _hashCode = comtop.Math.uuid().replace(/[-]/g, '_');
                    key._hashCode = _hashCode;
                    //make the attribute of key object can not enumerable
                    comtop.canNotEnumerable(key, ["_hashCode"]);
                    window[this.namespace][_hashCode] = value;
                }else{
                    throw new Error("the key is illegal of HashMap.put() function.");
                }
                return this;
            },
            /**
             * 从map中按键取值
             * @param key 键
             * @returns {*} 值
             */
            get : function(key){
                if(Object.prototype.toString.call(key) === "[object String]"){
                    return window[this.namespace][key] === undefined ? null : window[this.namespace][key];
                }else if(typeof key === "object"){
                    return key._hashCode === undefined ? null : (window[this.namespace][key._hashCode] === undefined ? null : window[this.namespace][key._hashCode]);
                }

                throw new Error("the key is illegal of HashMap.get() function.");
            },
            /**
             * 从map中按键删除键值对
             * @param key 键
             * @returns {*} 删除前的键对应的值
             */
            remove : function(key){
                if(Object.prototype.toString.call(key) === "[object String]"){
                    var _value = window[this.namespace][key];
                    if(this.containsKey(key)){
                        delete window[this.namespace][key];
                    }
                    return _value;
                }else if(typeof key === "object"){
                    var _hashCode = key._hashCode;
                    var _result =  window[this.namespace][_hashCode];
                    if(_hashCode){
                        delete key._hashCode;
                        delete window[this.namespace][_hashCode];
                    }
                    return _result;
                }

                throw new Error("the key is illegal of HashMap.remove() function.");
            },
            /**
             * 清空map的键值对
             */
            clear : function(){
                window[this.namespace] = {};
            },
            /**
             * 返回map中的键-值映射关系数。
             * @returns {number} 键值对数目
             */
            size : function(){
                var size = 0;
                for(var attr in window[this.namespace]){
                    if(window[this.namespace].hasOwnProperty(attr)){
                        size++;
                    }
                }
                return size;
            },
            /**
             * 如果map中不包含键-值映射关系，则返回 true。
             * @returns {boolean} 不包含键值对则返回true，否则返回false
             */
            isEmpty : function(){
                return this.size() === 0 ;
            },
            /**
             * 如果map中包含对于指定键的映射关系，则返回 true。
             * @param key 指定的键
             * @returns {boolean} 存在映射关系，则返回true，否则返回false
             */
            containsKey : function(key){
                if(Object.prototype.toString.call(key) === "[object String]"){
                    return window[this.namespace].hasOwnProperty(key);
                }else if(typeof key === "object"){
                    return key._hashCode === undefined ? false : (window[this.namespace].hasOwnProperty(key._hashCode));
                }

                throw new Error("the key is illegal of HashMap.containsKey() function.");
            },
            /**
             * 返回map中所包含的键的 Set 视图。
             * @returns {comtop.HashSet} map中键的HashSet视图
             */
            keySet : function(){
                var _keySet = new comtop.HashSet(this.namespace);
                _keySet.canAdd = false;
                return _keySet;
                //return Object.keys(window[this.namespace]);
            }
        };

        //make the attributes of Map.prototype can not enumerable
        comtop.canNotEnumerable(Map.prototype, ["constructor","put","get","remove","clear","size","isEmpty","containsKey","keySet"]);

        return Map;
    })();
})(comtop || (comtop = {}));

/**********************************************封装ArrayList********************************
 * 封装ArrayList，实现add、get、set、remove、clear、size、isEmpty、contains、toArray、insert  *
 * iterator等方法。                                                                         *
 * @author lingchen WWW.SZCOMTOP.COM                                                       *
 * @Date 2016-06-07                                                                        *
 *******************************************************************************************/
(function(comtop){
    comtop.ArrayList = (function(){
        /**
         * 声明ArrayList类
         * @constructor ArrayList
         */
        var ArrayList = function(){
            this.collection = [];
        };

        /**
         *  定义ArrayList的常用方法，与java中ArrayList使用方式一致
         */
        ArrayList.prototype = {
            constructor : ArrayList,
            /**
             * 将指定的元素添加到此列表的尾部。支持链式编程。
             * @param _element 指定的元素
             */
            add : function(_element){
                this.collection.push(_element);
                return this;
            },
            /**
             * 将指定的元素添加到此列表的指定位置。支持链式编程。
             * @param _index 指定的位置
             * @param _element 指定的元素。可变参数，允许传入多个元素。如：insert(5,element1,element2,element3)
             */
            insert : function(_index, _element){
                for(var i = 1; i < arguments.length; i++){
                    this.collection.splice(_index, 0, arguments[i]);
                    _index++;
                }
                return this;
            },
            /**
             * 返回指定索引位置的元素，索引位置是从0开始的。如果索引位置大于当前list的最大索引值，则返回null。
             * @param _index 指定的索引位置
             * @returns {*} 指定索引位置上的元素
             */
            get : function(_index){
                if(_index > this.size() - 1){
                    throw new Error("occur an IndexOutOfBoundsException when used the get() function of comtop.ArrayList class.");
                }
                //return _index > this.size() - 1 ? null : this.collection[_index]
                return this.collection[_index];
            },
            /**
             * 用指定的元素替代此列表中指定的位置上的元素。位置从0开始的。
             * @param _index 指定的位置
             * @param _element 指定的元素
             * @returns {*} 返回替代之前的元素
             * @Exception 当指定的索引位置大于当前列表的最大索引值时，将抛出IndexOutOfBoundsException
             */
            set : function(_index, _element){
                if(_index > this.size() - 1){
                    throw new Error("occur an IndexOutOfBoundsException when used the set() function of comtop.ArrayList class.");
                }
                var _value = this.collection[_index];
                this.collection[_index] = _element;
                return _value;
            },
            /**
             * 移除此列表中指定位置上的元素。位置从0开始的。
             * @param _index 要移除的元素的索引
             * @returns {*} 从列表中移除的元素
             * @Exception 当指定的索引位置大于当前列表的最大索引值时，将抛出IndexOutOfBoundsException
             */
            remove : function(_index){
                if(_index > this.size() - 1){
                    throw new Error("occur an IndexOutOfBoundsException when used the remove() function of comtop.ArrayList class");
                }
                var _value = this.collection[_index];
                this.collection.splice(_index,1);
                return _value;
            },
            /**
             * 移除此列表中的所有元素
             */
            clear : function(){
                this.collection = [];
            },
            /**
             * 返回此列表中的元素数。
             * @returns {Number} 列表的元素总数
             */
            size : function(){
                return this.collection.length;
            },
            /**
             * 如果此列表中没有元素，则返回 true
             * @returns {boolean} 没有元素则返回true，否则返回false
             */
            isEmpty : function(){
                return this.size() === 0;
            },
            /**
             * 如果此列表中包含指定的元素，则返回 true
             * @param _element 指定的元素
             * @returns {*} 有则返回true，否则返回false
             */
            contains : function(_element){
                for(var i = 0; i < this.size(); i++){
                    if(_element === this.get(i)){
                        return true;
                    }
                }
                return false;
            },
            /**
             * 以数组的形式把列表的内容返回
             * @returns {Array} 列表的内容
             */
            toArray : function(){
                return this.collection;
            },
            /**
             * 返回在此列表的元素上进行迭代的迭代器。
             * @returns {Iterator}
             */
            iterator : function(){
                return new Iterator(this);
            },
            /**
             * 返回此 arrayList 的字符串表示形式。
             * 该字符串表示形式由 arrayList 元素的列表组成，并用方括号 ("[]") 括起来。相邻元素由字符 ","分隔。
             * @returns {string}
             */
            toString :function(){
                return "[" + this.collection.toString() + "]";
            }
        };

        //make the attributes of ArrayList.prototype can not enumerable
        comtop.canNotEnumerable(ArrayList.prototype, ["constructor","add","insert","get","set","remove","clear","size","isEmpty","contains","toArray","iterator","toString"]);

        /**
         * 声明ArrayList类的迭代器
         * @param _lstInstance
         * @constructor Iterator
         */
        var Iterator = function(_lstInstance){
            this.cursor = 0;
            this.canRemove = false;
            this._lstInstance = _lstInstance;
        };


        /**
         *  定义ArrayList迭代器的常用方法，与java中ArrayList的迭代器使用方式一致
         */
        Iterator.prototype = {
            constructor : Iterator,
            /**
             * 返回迭代的下一个元素
             * @returns {*} 迭代的下一个元素
             */
            next : function(){
                var _nextObj = this._lstInstance.get(this.cursor);
                this.cursor++;
                this.canRemove = true;
                return _nextObj;
            },
            /**
             * 如果仍有元素可以迭代，则返回 true。
             * @returns {boolean} 有下一个元素，返回true，否则返回false
             */
            hasNext : function(){
                return this.cursor < this._lstInstance.size();
            },
            /**
             * 从迭代器指向的 ArrayList 中移除列表中的元素。
             */
            remove : function(){
                if(this.canRemove === false){
                    throw new Error("occur an IllegalStateException when used the remove() function of comtop.ArrayList'Iterator class. you must call the next() function first, and then call the remove() function. call once next() and call once remove().");
                }
                this._lstInstance.remove(this.cursor - 1);
                this.cursor--;
                this.canRemove = false;
            }
        };
        //make the attributes of Iterator.prototype can not enumerable
        comtop.canNotEnumerable(Iterator.prototype, ["constructor","next","hasNext","remove"]);

        return ArrayList;
    })();
})(comtop || (comtop = {}));

/**********************************************封装HashSet**********************************
 * 封装HashSet，实现add、remove、clear、size、isEmpty、contains、iterator等方法。              *
 *                                                                                         *
 * @author lingchen WWW.SZCOMTOP.COM                                                       *
 * @Date 2016-06-08                                                                        *
 *******************************************************************************************/
(function(comtop){
    comtop.HashSet = (function(){

        /**
         * 声明ArrayList类
         * @param _namespace 可选，Set的命名空间,在整个window上必须唯一，字符串类型
         * @constructor Set
         */
        var Set = function(_namespace){
            this.map = new comtop.HashMap(_namespace);
        };

        /**
         *  定义Set的常用方法，与java中HashSet使用方式一致
         */
        Set.prototype = {
            constructor : Set,
            constant : {},
            /**
             * 如果此 set 中尚未包含指定元素，则添加指定元素。
             * @param _element
             * @returns {Set}
             */
            add : function(_element){
                if(this.canAdd === false){
                    throw new Error("occur an UnsupportedOperationException when used the add() function of comtop.HashSet class.");
                }
                this.map.put(_element, this.constant);
                return this;
            },
            /**
             * 如果指定元素存在于此 set 中，则将其移除。
             * @param _element 需要移除的元素
             * @returns {boolean} 如果元素存在，移除成功，返回true，如果元素不存在，则返回false
             */
            remove : function(_element){
                return  this.contains(_element) ? (this.map.remove(_element) ? true : true) : false;
            },
            /**
             * 从此 set 中移除所有元素。此调用返回后，该 set 将为空。
             */
            clear : function(){
                this.map.clear();
            },
            /**
             * 返回此 set 中的元素的数量（set 的容量）。
             * @returns {*|number|Number} set的容量
             */
            size : function(){
                return this.map.size();
            },
            /**
             * 如果此 set 不包含任何元素，则返回 true。
             * @returns {*|boolean} 不包含任何元素，则返回true，否则返回false
             */
            isEmpty : function(){
                return this.map.isEmpty();
            },
            /**
             * 如果此 set 包含指定元素，则返回 true。
             * @param _element 指定的元素
             * @returns {*|boolean} 包含则返回true，不包含则返回false
             */
            contains : function(_element){
                return this.map.containsKey(_element);
            },
            /**
             * 返回对此 set 中元素进行迭代的迭代器。当set中的元素发生变化，需要重新调用此函数获取新的迭代器
             * @returns {*|Iterator} 迭代器
             */
            iterator : function(){
                return new Iterator(this.map.keySet());
                //return this.map.keySet().iterator();
            }
        };

        //make the attributes of Set.prototype can not enumerable
        comtop.canNotEnumerable(Set.prototype, ["constructor","constant","add","remove","clear","size","isEmpty","contains","iterator"]);

        /**
         * 声明HashSet类的迭代器
         * @param _setInstance
         * @constructor Iterator
         */
        var Iterator = function(_setInstance){
            this.cursor = 0;
            this.canRemove = false;
            this._setInstance = _setInstance;
            this.keyArray = [];
            if(window[_setInstance.map.namespace]){
                for(var _attr in window[_setInstance.map.namespace]){
                    if(window[_setInstance.map.namespace].hasOwnProperty(_attr)){
                        this.keyArray.push(_attr);
                    }
                }
            }
        };

        /**
         *  定义HashSet迭代器的常用方法，与java中HashSet的迭代器使用方式一致
         */
        Iterator.prototype = {
            constructor : Iterator,
            /**
             * 返回迭代的下一个元素
             * @returns {*} 迭代的下一个元素
             */
            next : function(){
                var _nextObj = this.keyArray[this.cursor];
                this.cursor++;
                this.canRemove = true;
                return _nextObj;
            },
            /**
             * 如果仍有元素可以迭代，则返回 true。
             * @returns {boolean} 有下一个元素，返回true，否则返回false
             */
            hasNext : function(){
                return this.cursor < this.keyArray.length;
            },
            /**
             * 从迭代器指向的 ArrayList 中移除列表中的元素。
             */
            remove : function(){
                if(this.canRemove === false){
                    throw new Error("occur an IllegalStateException when used the remove() function of comtop.HashSet'Iterator class. you must call the next() function first, and then call the remove() function. call once next() and call once remove().");
                }
                this._setInstance.map.remove(this.keyArray[this.cursor - 1]);
                this.keyArray.splice(this.cursor - 1, 1);
                this.cursor--;
                this.canRemove = false;
            }
        };
        //make the attributes of Iterator.prototype can not enumerable
        comtop.canNotEnumerable(Iterator.prototype, ["constructor","next","hasNext","remove"]);

        return Set;
    })();
})(comtop || (comtop = {}));

/**********************************************封装SimpleDateFormat*************************
 * 封装SimpleDateFormat，实现applyPattern、format、parse、toPattern等方法。                  *
 *                                                                                        *
 * @author lingchen WWW.SZCOMTOP.COM                                                      *
 * @Date 2016-06-11                                                                       *
 *******************************************************************************************/
(function(comtop){
    /**
     * 用以处理日期和时间的格式化及解析。其中核心为格式化及解析的模式。SimpleDateFormat中模式定义了以下字符：
     *
     * --------------------------------------------------------------------------------------------------
     * 字母        占位          日期或时间元素              表示                示例
     *  y         1-4位              年                    Year              1996; 96
     *  M         1-2位           年中的月份                Month               7; 07
     *  d         1-2位           月份中的天数              Number               10
     *  E         1-3位           星期中的天数              Text            三; 周三; 星期三
     *  H         1-2位           一天中的小时数（0-23）     Number               23
     *  h         1-2位           am/pm中的小时数（1-12)     Number              10
     *  m         1-2位           小时中的分钟数             Number               30
     *  s         1-2位           分钟中的秒数               Number               55
     *  S          1位              毫秒数                  Number               978
     *  q         1-2位           一年中的季度数             Number              2; 02
     * ---------------------------------------------------------------------------------------------------
     * e.g.:
     * new comtop.SimpleDateFormat().format(new Date()); ==> 2016-06-12 14:41:07
     * new comtop.SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date()); ==> 2016/06/12 14:41:07
     * new comtop.SimpleDateFormat("yyyy/MM/dd hh:mm:ss").format(new Date()); ==> 2016/06/12 02:41:07
     * new comtop.SimpleDateFormat("yyyy/M/dd h:mm:ss").format(new Date()); ==> 2016/6/12 2:41:07
     * new comtop.SimpleDateFormat("yyyy年MM月dd日 HH:mm:ss.S").format(new Date()); ==> 2016年06月12日 14:41:07.356
     * new comtop.SimpleDateFormat("yyyy年MM月dd日 E HH:mm:ss.S").format(new Date()); ==> 2016年06月12日 日 14:41:07.356
     * new comtop.SimpleDateFormat("yyyy年MM月dd日 EE HH:mm:ss.S").format(new Date()); ==> 2016年06月12日 周日 14:41:07.356
     * new comtop.SimpleDateFormat("yyyy年MM月dd日 EEE HH:mm:ss.S 第 qq 季度").format(new Date()); ==> 2016年06月12日 星期日 14:41:07.356 第 02 季度
     *
     * new comtop.SimpleDateFormat("yyyy年MM月dd日 EEE HH:mm:ss.S 第 qq 季度").parse("2016年06月12日 星期日 14:41:07.356 第 02 季度"); ==> Sun Jun 12 2016 14:41:07 GMT+0800 (中国标准时间) (Date类型)
     *
     */
    comtop.SimpleDateFormat = (function(){

        /**
         * 声明SimpleDateFormat类
         * @param _pattern 可选，描述日期和时间格式的模式，字符串类型
         * @constructor SimpleDateFormat
         */
        var SimpleDateFormat = function(_pattern){
            if(comtop.StringUtil.isBlank(_pattern)){
                //default pattern
                this._pattern = "yyyy-MM-dd HH:mm:ss";
            }else if(Object.prototype.toString.call(_pattern) === "[object String]"){
                this._pattern = _pattern;
            }else{
                //throw a exception when have an illegal pattern.
                throw new Error("the parameter of the SimpleDateFormat() constructor is illegal.");
            }
        };

        /**
         * 定义SimpleDateFormat的常用方法，与java中SimpleDateFormat使用方式一致
         * @type {{constructor: Function, applyPattern: Function, format: Function, parse: Function, toPattern: Function}}
         */
        SimpleDateFormat.prototype = {
            constructor : SimpleDateFormat,
            /**
             * 将给定模式字符串应用于此日期格式。
             * @param _pattern 给定的模式字符串
             */
            applyPattern : function(_pattern){
                this._pattern = _pattern;
            },
            /**
             * 将一个 Date 格式化为日期/时间字符串
             * @param _date 要格式化为时间字符串的时间值
             * @returns {*} 已格式化的时间字符串
             */
            format : function(_date){
                //validate the arguments
                if(arguments.length === 0){
                    throw new Error("the format() function need one Date type parameter at least.");
                }
                if(Object.prototype.toString.call(arguments[0]) !== "[object Date]"){
                    throw new Error("the parameter type of the format() function must be Date.");
                }

                var _format = this._pattern;

                //define subPattern and the match mapping for it
                var _subPattern = {
                    "M+" : _date.getMonth() + 1, //month
                    "d+" : _date.getDate(), //day
                    "h+" : _date.getHours() % 12 == 0 ? 12 : _date.getHours() % 12, //hours of 12 radix
                    "H+" : _date.getHours(), //hours of 24 radix
                    "m+" : _date.getMinutes(), //minutes
                    "s+" : _date.getSeconds(), //seconds
                    "q+" : Math.floor((_date.getMonth() + 3 ) / 3), // quarter
                    "S" : _date.getMilliseconds() //milliseconds
                };

                //define Chinese description for the day of week
                var _week = {
                    "0" : "\u65e5", //日
                    "1" : "\u4e00", //一
                    "2" : "\u4e8c", //二
                    "3" : "\u4e09", //三
                    "4" : "\u56db", //四
                    "5" : "\u4e94", //五
                    "6" : "\u516d" //六
                };
                //process year
                if(/(y+)/.test(_format)){
                    _format = _format.replace(RegExp.$1, (_date.getFullYear() + "").substr(4 - RegExp.$1.length));
                }
                //process _week
                if(/(E+)/.test(_format)){
                    _format = _format.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f" : "\u5468") : "") + _week[_date.getDay() + ""]);
                }
                //process month,day,hours,minutes,seconds,milliseconds,quarter
                for(var _attr in _subPattern){
                    if(new RegExp("("+ _attr +")").test(_format) && _subPattern.hasOwnProperty(_attr)){
                        _format = _format.replace(RegExp.$1, (RegExp.$1.length === 1) ? (_subPattern[_attr]) : (("00" + _subPattern[_attr]).substr(("" + _subPattern[_attr]).length)));
                    }
                }
                return _format;
            },
            /**
             * 根据给定的解析位置开始解析日期/时间字符串。
             * 此方法进行的解析是严格的：如果输入的形式不是此对象的格式化方法使用的形式，则不能进行解析，抛出ParseException。
             * 此方法解析字符串的前提，年份必须是4位，小时必须是24小时制。
             * 此方法试图解析从 _position 给定的索引（从0开始）处开始的文本。若_position大于原始传入的字符串长度，则初始化_position等于_position与字符串长度求余的结果。若未传入_position，则_position初始化为0。
             * 若当前SimpleDateFormat实例的pattern中，没有年、月、日、时、分、秒、毫秒中任意一个匹配的子模式，则缺失的这个子模式对应的“时间”为当前“时间”。例如，缺失yyyy，则解析出的日期为当前年份；缺失HH，则解析出的日期为当前小时，等等。
             *
             * @param _text 要解析的日期/时间字符串
             * @param _position 开始进行解析的位置
             * @returns {Date} 解析字符串得到的 Date
             */
            parse : function(_text, _position){
                if(arguments.length === 0){
                    throw new Error("the parse() function must be have one parameter at least.");
                }
                if(Object.prototype.toString.call(arguments[0]) !== "[object String]"){
                    throw new Error("the first parameter type of the parse() function must be String.");
                }
                if(_position !== undefined && Object.prototype.toString.call(_position) !== "[object Number]"){
                    throw new Error("the second parameter type of the parse() function must be Number.");
                }

                //init the start position of substring
                _position = _position === undefined ? 0 : _position % _text.length;

                var _format = this._pattern;

                //define subPattern and the match mapping for it
                var _subPattern = [
                    {key : "d+", value : "(\\d{1,2})"},
                    {key : "y+", value : "(\\d{4})"},
                    {key : "M+", value : "(\\d{1,2})"},
                    {key : "H+", value : "(\\d{1,2})"},
                    {key : "m+", value : "(\\d{1,2})"},
                    {key : "s+", value : "(\\d{1,2})"},
                    {key : "S", value : "(\\d{1,3})"},
                    {key : "q+", value : "\\d{1,2}"},
                    {key : "E+", value : ".{1,3}"}
                ];

                //process "." for milliseconds
                _format = _format.replace(/[.]/g, "\\.");

                //put each subPattern group information
                var _timeMapping = [];
                for(var i = 0; i < _subPattern.length; i++){
                    var _exec = new RegExp("(" + _subPattern[i].key + ")").exec(this._pattern);
                    if(_exec !== null){
                        if(_subPattern[i].key !== "q+" && _subPattern[i].key !== "E+"){ //exclude quarter and week
                            _timeMapping.push({"index" : _exec["index"], "type" : _subPattern[i].key.substring(0,1)});
                        }
                        _format = _format.replace(RegExp.$1, _subPattern[i].value);
                    }
                }
                // append the pattern for full match
                _format = "^" + _format + "$";

                //check the need parse string
                if(!new RegExp(_format).test(_text.substring(_position))){
                    throw new Error("the parse() function throw a ParseException, please check the pattern of the SimpleDateFormat's instance and the text of ready to parse.");
                }

                //use bubble to sort the subPatterns
                for(var m = 0; m < _timeMapping.length-1; m++){
                    for(var n = m+1; n < _timeMapping.length; n++){
                        if(_timeMapping[m].index > _timeMapping[n].index){
                            var _temp = _timeMapping[n];
                            _timeMapping[n] = _timeMapping[m];
                            _timeMapping[m] = _temp;
                        }
                    }
                }
                //get each subPattern group number and convert the _timeMapping to a simple object
                var _o = {};
                for(var j = 1; j <= _timeMapping.length; j++){
                    _o[_timeMapping[j-1].type] = j;
                }

                //create a current date
                var _date  = new Date();
                // if the subPattern is not exist, take the current time to replace
                if(_o.y){
                    _date.setFullYear(parseInt(eval("RegExp.$" + _o.y)));
                }
                if(_o.M){
                    _date.setMonth(parseInt(eval("RegExp.$" + _o.M)) - 1);
                }
                if(_o.d){
                    _date.setDate(parseInt(eval("RegExp.$" + _o.d)));
                }
                if(_o.H){
                    _date.setHours(parseInt(eval("RegExp.$" + _o.H)));
                }
                if(_o.m){
                    _date.setMinutes(parseInt(eval("RegExp.$" + _o.m)));
                }
                if(_o.s){
                    _date.setSeconds(parseInt(eval("RegExp.$" + _o.s)));
                }
                if(_o.S){
                    _date.setMilliseconds(parseInt(eval("RegExp.$" + _o.S)));
                }

                return _date;

            },
            /**
             * 返回描述此日期格式的模式字符串。
             * @returns {*} 模式字符串
             */
            toPattern : function(){
                return this._pattern;
            }
        };

        //make the attributes of Iterator.prototype can not enumerable
        comtop.canNotEnumerable(SimpleDateFormat.prototype, ["constructor", "applyPattern", "format", "parse", "toPattern"]);

        return SimpleDateFormat;
    })();
})(comtop || (comtop = {}));