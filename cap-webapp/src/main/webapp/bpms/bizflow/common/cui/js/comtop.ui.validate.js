;(function($, C) {
    C.UI.Validate = C.UI.Base.extend({

        options: {
            uitype: 'Validate',
            onValid: null,
            onInValid: null
        },

        /***  默认提示的样式名  ***/
        invalidClass: 'validate_invalid',
        messageClass: 'validate_validation_message',
        invalidFieldClass: 'validate_invalid_field',

        _create: function() {
            $.extend(this, this.options);
        },

        /**
         * 销毁组件
         */
        destroy: function() {
            var self = this;

            var validateEl = $.data(this.options.el, 'validateEl') || [];
            $.each(validateEl, function(index, element) {
                var $cui = cui('#' + element.id);
                var $el = $cui.options.el;

                $cui.unbind('change', self._validateEvent);
                $el.removeData('validateRule');
            });
            $.removeData(this.options.el, 'validateEl');
        },

        /**
         * 添加元素验证规则
         * @param element 元素id或元素对象
         * @param validateMethod 验证方法
         * @param validateParamsObj 参数
         */
        add: function(element, validateMethod, validateParamsObj) {
            var $cui = $.type(element) == 'string' ? cui('#' + element) : element;
            if (!$cui.options) return;
            var $el = $cui.options.el;

            //缓存验证规则
            var validations = $el.data('validateRule') || [];
            var validJson = null;
            //如果用户没传验证参数，且所传的validateMethod在Validate对象中找不到
            //默认认为用户选择了required验证，且validateMethod为验证失败时的信息
            if (!validateParamsObj && !Validate[validateMethod]) {
                validJson = {type: 'required', params: {m: validateMethod}};
            } else {
                validJson = {type: validateMethod, params: validateParamsObj || {}};
            }
            validations.push(validJson);
            $el.data('validateRule', validations);

            //缓存验证的元素
            var validateEl = $.data(this.options.el, 'validateEl') || [];
            if (!this._contains($el[0], validateEl)) {
                //为element注册事件
                $cui.bind('change', this, this._validateEvent);
                validateEl.push($el[0]);
            }
            $.data(this.options.el, 'validateEl', validateEl);
        },
        /**
         * 修改元素验证提示
         * @param element 元素id或元素对象
         * @param validateParamsObj 验证的参数
         */
        setTips: function(element,validateParamsObj) {
            if(!element || !validateParamsObj){
                return;
            }
            var $cui = $.type(element) === 'string' ? cui('#' + element) : element;
            if (!$cui.options) return;
            var $el = $cui.options.el;

            //缓存验证规则
            var validations = $el.data('validateRule') || [],validataParams = [],that = this;

            if($.type(validateParamsObj) === 'string') {
                $.each(validations,function(i){
                    var obj = validations[i];
                    if(obj.type === 'required'){
                        obj.params.m = validateParamsObj;
                    }
                });
                if($cui.options.el.attr("tip")){
                    this.validOneElement($cui);
                }
                return;
            }
            if(!$.isArray(validateParamsObj)){
                validataParams.push(validateParamsObj);
            }else{
                validataParams = validateParamsObj;
            }
            $.each(validataParams,function(i){
                var newTips =  validataParams[i];
                $.each(validations,function(j){
                    var rule = validations[j];
                    if(newTips.type === rule.type){
                        var tipName = that._getPropertyNames(newTips)[1] || "m";
                        rule.params[tipName] && (rule.params[tipName] = newTips[tipName]);
                    }
                })
            });
            if($cui.options.el.attr("tip")){
                this.validOneElement($cui);
            }
        },
        /**
         * 获取对象的属性名
         * @param obj 对象
         */
        _getPropertyNames: function(obj) {
            var result = [];
            for(key in obj){
                result.push(key);
            }
            return result;

        },
        /**
         * 是否让指定元素的验证失效
         * @param element 元素id或元素cui对象
         * @param flag 是否失效true/false
         */
        disValid: function(element, flag) {
            var $cui = $.type(element) == 'string' ? cui('#' + element) : element;
            if (!$cui.options) return;
            var $el = $cui.options.el;
            if (flag) {
                $el.data("disValid", "true");
            } else {
                $el.removeData("disValid");
            }
        },

        /**
         * 对象数组包含检查
         * @param obj对象元素
         * @param array数组
         * @return {Boolean}
         * @private
         */
        _contains: function(obj, array) {
            var flag = false;
            $.each(array, function(index, item) {
                if (obj === item) {
                    flag = true;
                    return;
                }
            });
            return flag;
        },

        /**
         * 移除元素规则
         * @param element 元素id或元素对象
         * @param validateMethod 验证方法
         * @param validateParamsObj 参数
         */
        remove: function(element, validateMethod) {
            var $cui = $.type(element) == 'string' ? cui('#' + element) : element;
            if (!$cui.options) return;
            var $el = $cui.options.el;

            var validations = [];
            if (validateMethod) {
                validations = $el.data('validateRule') || [];

                var idx = -1;
                $.each(validations, function(index, item) {
                    if (item.type == validateMethod) {
                        idx = index;
                    }
                });
                if (idx >= 0) {
                    validations.splice(idx, 1);
                }
            }

            if (validations.length < 1) {
                $el.removeData('validateRule');
                $cui.unbind('change', this, this._validateEvent);

                //移除验证元素
                var validateEl = $.data(this.options.el, 'validateEl') || [];
                var label = -1;
                $.each(validateEl, function(index, item) {
                    if (item.id == $el[0].id) {
                        label = index;
                    }
                });
                if (label >= 0) {
                    validateEl.splice(label, 1);
                }

                if (validateEl.length < 1) {
                    $.removeData(this.options.el, 'validateEl');
                } else {
                    $.data(this.options.el, 'validateEl', validateEl);
                }

            } else {
                $el.data('validateRule', validations);
            }
        },

        /**
         * 验证事件
         * @param e
         * @param {Boolean} isReset 是否是组件数据重置，重置数据不执行验证
         * @private
         */
        _validateEvent: function(e, isReset) {
            var self = e.data;
            //!!isReset把undefined转为false
            self._validate(this, !!isReset);
        },

        /**
         * 验证所有元素
         * @return {Boolean}
         */
        validAllElement: function() {
            return this._validElement($.data(this.options.el, 'validateEl'));
        },

        /**
         * 验证一个元素是否成功
         * @param element 元素id或元素对象
         * @return {Boolean}
         */
        validOneElement: function(element) {
            var $cui = $.type(element) == 'string' ? cui('#' + element) : element;
            if (!$cui.options) return false;

            return this._validate($cui);
        },

        /**
         * 验证元素
         * @param type {String} 验证方式，分别提供"ALL"（全部验证）, "AREA"（局部验证）, "CUSTOM"（自定义验证元素）
         * @param range {String|jQuery|HTMLElement} 验证范围
         * @param include {Boolean} 是否包含
         */
        validElement: function(type, range, include){
            var $range = [],
                i, len;
            //默认是全部验证
            type = type || 'ALL';
            type = type.toLocaleUpperCase(type);
            switch (type){
                //区域验证
                case 'AREA':
                    var $setRange = $(range);
                    var $tmpAllRange = [];
                    var $tmpRange = [];
                    var $list = C.UI.componentList;
                    for(i = 0, len = $list.length; i < len; i ++){
                        //查找区域内的表单元素
                        if($setRange.find($list[i].options.el).length){
                            if(typeof $list[i].options.textmode !== 'undefined'){
                                $tmpRange.push($list[i].options.el[0]);
                            }
                        }
                        //查找所有表单元素
                        if($list[i].options.el){
                            if(typeof $list[i].options.textmode !== 'undefined'){
                                $tmpAllRange.push($list[i].options.el[0]);
                            }
                        }
                    }

                    include = typeof include === 'undefined' ? true : false;
                    if(include){
                        $range = $tmpRange;
                    }else{
                        var check = false;
                        for (i = 0, len = $tmpAllRange.length; i < len; i++) {
                            for (var j = 0, jLen = $tmpRange.length; j < jLen; j ++) {
                                if($($tmpRange[j]).attr('id') == $($tmpAllRange[i]).attr('id')){
                                    check = true;
                                    break;
                                }
                            }
                            if(!check){
                                $range.push($tmpAllRange[i]);
                            }
                            check = false;
                        }
                    }

                    break;
                case 'CUSTOM':
                    include = typeof include === 'undefined' ? true : false;
                    if(include){
                        for (i = 0, len = range.length; i < len; i++) {
                            $range.push($('#' + range[i])[0]);
                        }
                    }else{
                        var $list = C.UI.componentList;
                        var $tmpRange = [];
                        for(i = 0, len = $list.length; i < len; i ++){
                            if($list[i].options.el){
                                if(typeof $list[i].options.textmode !== 'undefined'){
                                    $tmpRange.push($list[i].options.el[0]);
                                }
                            }
                        }

                        var check = false;
                        for (i = 0, len = $tmpRange.length; i < len; i++) {
                            for (var j = 0, jLen = range.length; j < jLen; j ++) {
                                if($($tmpRange[i]).attr('id') == range[j]){
                                    check = true;
                                    break;
                                }
                            }
                            if(!check){
                                $range.push($tmpRange[i]);
                            }
                            check = false;
                        }
                    }
                    break;
                case 'ALL':
                default:
                    $range = $.data(this.options.el, 'validateEl');
            }
            return this._validElement($range);
        },

        _validElement: function(validateEl) {
            validateEl = validateEl || [];
            var validList = [];
            var inValidList = [];
            var isValid = true;

            for (var i = 0; i < validateEl.length; i++) {
                var element = validateEl[i];
                var $cui = cui(element);
                if(typeof $cui.options === 'undefined'){
                    continue;
                }
                var result = this._validate($cui);
                result = $.extend(result, {id: element.id});
                if (result.valid) {
                    validList.push(result);
                } else {
                    isValid = false;
                    inValidList.push(result);
                }
            }
            return [inValidList, validList, isValid];
        },

        /**
         * 验证元素
         * @param {CUI} $cui 元素cui对象
         * @param {Boolean} isReset 是否是组件数据重置，重置数据不执行验证
         * @return {Boolean}
         * @private
         */
        _validate: function($cui, isReset) {
            var $el = $cui.options.el;
            if(isReset){
                $cui.onValid($cui);
                return false;
            }
            if (!$el[0].disabled) {
                //判断是否不验证该元素，若不验证直接返回验证正确
                var result = null;
                var disValid = $cui.options.el.data("disValid");
                if (disValid && disValid == "true") {
                    result = {valid: true, message: ''};
                } else {
                    result = this._doValidate($cui);
                }
                var isValid = result.valid;
                if (isValid) {
                    // 如果所验证的组件有onValid方法执行该方法
                    // 否则执行validate组件自带的onValid方法
                    if ($cui.onValid && !this.options.onValid) {
                        $cui.onValid($cui);
                    }else if(!$cui.onValid && !this.options.onValid){
                        this.onValid($el);
                    }else{
                        this.options.onValid.apply(this, [$el]);
                    }
                } else {
                    // 如果所验证的组件有onInvalid方法执行该方法
                    // 否则执行validate组件自带的onInvalid方法
                    if ($cui.onInValid && !this.options.onInValid) {
                        $cui.onInValid($cui, result.message);
                    }else if(!$cui.onInValid && !this.options.onInValid){
                        this.onInValid($el, result.message);
                    }else{
                        this.options.onInValid.apply(this, [$el, result.message]);
                    }
                }
                return result;
            }
        },

        /**
         * 验证某一元素的所有规则
         * @param $cui 元素cui对象
         * @return {}
         * @private
         */
        _doValidate: function($cui) {
            var $el = $cui.options.el;
            var validateFailed = false;

            var validations = $el.data('validateRule') || [];
            for (var i = 0; i < validations.length; i++) {
                var validation = validations[i];
                var result = this._validateElement($cui, validation);
                validateFailed = !result.valid;
                if (validateFailed) return {valid: false, message: result.message};
            }
            return {valid: true, message: ''};
        },

        /**
         * 验证某一元素的单一规则
         * @param $cui 元素cui对象
         * @param validation 规则
         * @return {}
         * @private
         */
        _validateElement: function($cui, validation) {
            var validateMethod = validation.type;
            var validateParamsObj = validation.params;

            var value = $cui.getValue();
            var isValid = true;
            var message = '';
            try {
                Validate[validateMethod](value, validateParamsObj);
            } catch (error) {
                message = error.message;
                isValid = false;
            } finally {
                return {valid: isValid, message: message};
            }
        },

        /**
         * 验证失败组件处理默认方法
         * @param element
         * @param message
         */
        onInValid: function(element, message){
            this._insertMessage(element, this._createMessageSpan(message));
            this._addFieldClass(element);
        },

        /**
         * 验证成功组件处理默认方法
         * @param element
         */
        onValid: function(element){
            this._removeMessageAndFieldClass(element)
        },

        /**
         * 创建一个span容器，填充失败或者成功消息
         * @param message
         * @return {Element}
         * @private
         */
        _createMessageSpan: function(message) {
            return $("<span></span>").html(message);
        },

        /**
         * 插入失败提示消息
         * @param element 验证的元素
         * @param elementToInsert 消息容器
         * @private
         */
        _insertMessage: function(element, elementToInsert) {
            this._removeMessage(element);
            $(elementToInsert).addClass(this.messageClass + (' ' + this.invalidClass));
            $(elementToInsert).insertAfter(element);
        },

        /**
         * 为验证的元素添加样式
         * @param element 验证的元素
         * @private
         */
        _addFieldClass: function(element) {
            this._removeFieldClass(element);
            $(element).addClass(this.invalidFieldClass);
        },

        /**
         * 移除失败提示
         * @param element 验证的元素
         * @private
         */
        _removeMessage: function(element) {
            if (nextEl = $(element).next('.' + this.messageClass)) {
                $(nextEl).remove();
            }
        },

        /**
         * 移除样式
         * @param element 验证的元素
         * @private
         */
        _removeFieldClass: function(element) {
            $(element).removeClass(this.invalidFieldClass);
        },

        /**
         * 移除失败消息以及移除样式
         * @param element 验证的元素
         * @private
         */
        _removeMessageAndFieldClass: function(element) {
            this._removeMessage(element);
            this._removeFieldClass(element);
        }
    });

    var Validate = null;
    C.UI.Validate.rule = Validate = {

        /**
         * 验证是否存在(扩展字段 req)
         * 参数 解释数据
         * m: 出错信息字符串
         * emptyVal:包含在其中的也算为空
         */
        required: function(value, paramsObj){
            var params = $.extend({
                m: "不能为空!"
            }, paramsObj || {});
            if($.trim(value) === '' || value === null || value === undefined) {
                Validate.fail(params.m);
            }
            if (params.emptyVal) {
                $.each(params.emptyVal, function(i, item) {
                    if (value == item) {
                        Validate.fail(params.m);
                    }
                });
            }
            if ($.type(value) === 'array' && value.length === 0) {
                Validate.fail(params.m);
            } else if ($.type(value) === 'array') {
                for (var i = 0; i < value.length; i++) {
                    if ($.trim(value[i]) === '' || value[i] === null || value[i] === undefined) {
                        Validate.fail(params.m);
                        break;
                    }
                }
            }
            return true;
        },

        /**
         * 验证数值类型(扩展字段 num)
         * 参数 解释                                 数据
         *  oi： 是否只能为Integer （onlyInteger）     true/false
         *  min: 最小数                               数字
         *  max: 最大数                               数字
         *  is:  必须和该数字相等                      数字
         *  wrongm: 输入不和 is 相等的数字时提示信息       数字
         *  notnm：不为数字时提示信息                    字符串
         *  notim：不为整数时提示信息                    字符串
         *  minm：小于 min 数字时提示信息               字符串
         *  maxm：大于 max 数字时提示信息               字符串
         */
        numeric: function(value, paramsObj){
            var suppliedValue = value;
            if ('' === value) return true;
            var value = Number(value);
            var paramsObj = paramsObj || {};
            var params = {
                notANumberMessage:  paramsObj.notnm || "必须为数字!",
                notAnIntegerMessage: paramsObj.notim || "必须为整数!",
                wrongNumberMessage: paramsObj.wrongm || "必须为 " + paramsObj.is + "!",
                tooLowMessage:         paramsObj.minm || "必须大于 " + paramsObj.min + "!",
                tooHighMessage:        paramsObj.maxm || "必须小于 " + paramsObj.max + "!",
                is:                            ((paramsObj.is) || (paramsObj.is == 0)) ? paramsObj.is : null,
                minimum:                   ((paramsObj.min) || (paramsObj.min == 0)) ? paramsObj.min : null,
                maximum:                  ((paramsObj.max) || (paramsObj.max == 0)) ? paramsObj.max : null,
                onlyInteger:               paramsObj.oi || false
            };
            if (!isFinite(value))  Validate.fail(params.notANumberMessage);
//            if (params.onlyInteger && ( ( /\.0+$|\.$/.test(String(suppliedValue)) )  || ( value != parseInt(value) ) ) ) {
//                Validate.fail(params.notAnIntegerMessage);
//            }
            if (params.onlyInteger && !/^\d+$/.test(String(suppliedValue))) {
                Validate.fail(params.notAnIntegerMessage);
            }
            switch(true){
                case (params.is !== null):
                    if( value != Number(params.is) ) Validate.fail(params.wrongNumberMessage);
                    break;
                case (params.minimum !== null && params.maximum !== null):
                    Validate.numeric(value, {minm: params.tooLowMessage, min: params.minimum});
                    Validate.numeric(value, {maxm: params.tooHighMessage, max: params.maximum});
                    break;
                case (params.minimum !== null):
                    if( value < Number(params.minimum) ) Validate.fail(params.tooLowMessage);
                    break;
                case (params.maximum !== null):
                    if( value > Number(params.maximum) ) Validate.fail(params.tooHighMessage);
                    break;
            }
            return true;
        },

        /**
         * 正则表达式验证 (扩展字段 format)
         *  参数   解释                                 数据
         *  m:     出错信息                             字符串
         *  pattern: 验证正则表达式                     字符串
         *  negate: 是否忽略本次验证（negate）           true/false
         */
        format: function(value, paramsObj){
            var value = String(value);
            if ('' == value) return true;
            var params = $.extend({
                m: "不符合规定格式!",
                pattern:           /./ ,
                negate:            false
            }, paramsObj || {});
            params.pattern = $.type(params.pattern) == "string" ? new RegExp(params.pattern) : params.pattern;
            if(!params.negate) {//不忽略
                if(!params.pattern.test(value)) { //不忽略,且验证不过
                    Validate.fail(params.m);
                }
            }
            return true;
        },

        /**
         * 邮箱格式验证 (扩展字段 email)
         * 参数 解释                                 数据
         *  m:   出错信息                             字符串
         */
        email: function(value, paramsObj){
            if ('' == value) return true;
            var params = $.extend({
                m: "邮箱格式输入不合法!"
            }, paramsObj || {});
            Validate.format(value, {
                m: params.m,
                pattern: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
            });
            return true;
        },

        /**
         * 日期格式验证 (扩展字段 date)考虑了闰年、二月等因素
         * 参数 解释                                 数据
         *  m:   出错信息                            字符串
         */
        dateFormat : function(value, paramsObj) {
            var params = $.extend({
                m: "日期格式必须为yyyy-MM-dd形式！"
            }, paramsObj || {});
            Validate.format(value, {
                m: params.m,
                pattern: /^((((((0[48])|([13579][26])|([2468][048]))00)|([0-9][0-9]((0[48])|([13579][26])|([2468][048]))))-02-29)|(((000[1-9])|(00[1-9][0-9])|(0[1-9][0-9][0-9])|([1-9][0-9][0-9][0-9]))-((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30))|(((0[1-9])|(1[0-2]))-((0[1-9])|(1[0-9])|(2[0-8]))))))$/i
            });
            return true;
        },

        /**
         * 长度验证(扩展字段 len)
         * 参数 解释                               数据
         *  m:   出错信息                          字符串
         *  min: 最小长度                          数字
         *  max: 最大长度                          数字
         *  is:  必须和该长度相等                     数字
         *  wrongm: 输入长度和 is 不相等时提示信息        数字
         *  minm：长度小于 min 数字时提示信息            字符串
         *  maxm：长度大于 max 数字时提示信息            字符串
         */
        length: function(value, paramsObj){
            var value = String(value);
            var paramsObj = paramsObj || {};
            var params = {
                wrongLengthMessage: paramsObj.wrongm || "长度必须为 " + paramsObj.is + " 字节!",
                tooShortMessage:      paramsObj.minm || "长度必须大于 " + paramsObj.min + " 字节!",
                tooLongMessage:       paramsObj.maxm || "长度必须小于 " + paramsObj.max + " 字节!",
                is:                           ((paramsObj.is) || (paramsObj.is == 0)) ? paramsObj.is : null,
                minimum:                  ((paramsObj.min) || (paramsObj.min == 0)) ? paramsObj.min : null,
                maximum:                 ((paramsObj.max) || (paramsObj.max == 0)) ? paramsObj.max : null
            }
            switch(true){
                case (params.is !== null):
                    if( value.replace(/[^\x00-\xff]/g, "xx").length != Number(params.is) ) {
                        Validate.fail(params.wrongLengthMessage);
                    }
                    break;
                case (params.minimum !== null && params.maximum !== null):
                    Validate.length(value, {minm: params.tooShortMessage, min: params.minimum});
                    Validate.length(value, {maxm: params.tooLongMessage, max: params.maximum});
                    break;
                case (params.minimum !== null):
                    if( value.replace(/[^\x00-\xff]/g, "xx").length < Number(params.minimum) ) {
                        Validate.fail(params.tooShortMessage);
                    }
                    break;
                case (params.maximum !== null):
                    if( value.replace(/[^\x00-\xff]/g, "xx").length > Number(params.maximum) ) {
                        Validate.fail(params.tooLongMessage);
                    }
                    break;
                default:
                    throw new Validate.error("Validate::Length - 长度验证必须提供长度值!");
            }
            return true;
        },

        /**
         * 包含验证 (扩展字段 inc)
         * 参数 解释                                 数据
         *  m:   出错信息                             字符串
         *  negate: 是否忽略                          true/false
         *  caseSensitive: 大小写敏感(caseSensitive)   true/false
         *  allowNull: 是否可以为空                    数字
         *  within:  集合                             数组
         *  partialMatch: 是否部分匹配                 true/false
         */
        inclusion: function(value, paramsObj){
            var params = $.extend({
                m: "",
                within:           [],
                allowNull:        false,
                partialMatch:   false,
                caseSensitive: true,
                negate:          false
            }, paramsObj || {});
            params.m = params.m || value + "没有包含在数组" + params.within.join(',') + "中";
            if(params.allowNull && !value) return true;
            if(!params.allowNull && !value) Validate.fail(params.m);
            //if case insensitive, make all strings in the array lowercase, and the value too
            if(!params.caseSensitive){
                var lowerWithin = [];
                $.each(params.within, function(index, item){
                    if(typeof item == 'string') item = item.toLowerCase();
                    lowerWithin.push(item);
                });
                params.within = lowerWithin;
                if(typeof value == 'string') value = value.toLowerCase();
            }

            var found = false;
            $.each(params.within, function(index, item) {
                if (item == value) found = true;
                if (params.partialMatch) {
                    if (value.indexOf(item) != -1) {
                        found = true;
                    }
                }
            });
            if( (!params.negate && !found) || (params.negate && found) ) Validate.fail(params.m);
            return true;
        },

        /**
         * 不包含验证 (扩展字段 exc)
         * 参数 解释                                 数据
         *  m:   出错信息                             字符串
         *  caseSensitive: 大小写敏感(caseSensitive)   true/false
         *  allowNull: 是否可以为空                    数字
         *  within:  集合                             数组
         *  partialMatch: 是否部分匹配                 true/false
         */
        exclusion: function(value, paramsObj){
            var params = $.extend({
                m: "",
                within:             [],
                allowNull:          false,
                partialMatch:     false,
                caseSensitive:   true
            }, paramsObj || {});
            params.m = params.m || value + "不应该在数组" + params.within.join(',') + "中！";
            params.negate = true;// set outside of params so cannot be overridden
            Validate.inclusion(value, params);
            return true;
        },

        /**
         * 组合匹配一致验证，如用户名和密码 (扩展字段 confirm)
         * 参数 解释                                 数据
         *  m:   出错信息                             字符串
         *  match: 验证与之匹配的元素引用              元素或元素id
         */
        confirmation: function(value, paramsObj){
            if(!paramsObj.match) {
                throw new Error("Validate::Confirmation - 与之匹配的元素引用或元素id必须被提供!");
            }
            var params = $.extend({
                m: "两者不一致!",
                match:            null
            }, paramsObj || {});
            params.match = $.type(params.match) == 'string' ? cui('#' + params.match) : params.match;
            if(!params.match || params.match.length == 0) {
                throw new Error("Validate::Confirmation - 与之匹配的元素引用或元素不存在!");
            }
            if(value != params.match.getValue()) {
                Validate.fail(params.m);
            }
            return true;
        },

        /**
         * 验证值是否为true 主要是验证checkbox (扩展字段 accept)
         * 参数 解释                                 数据
         *  m:   出错信息                             字符串
         */
        acceptance: function(value, paramsObj){
            var params = $.extend({
                m: "必须选择!"
            }, paramsObj || {});
            if(!value) {
                Validate.fail(params.m);
            }
            return true;
        },

        /**
         * 自定义验证函数 (扩展字段 custom)
         * 参数 解释                                 数据
         *  m:   出错信息                             字符串
         *  against:  自定义的函数                    function
         *  args:   自定义的函数的参数                 对象
         * */
        custom: function(value, paramsObj){
            var params = $.extend({
                against: function(){ return true; },
                args: {},
                m: "不合法!"
            }, paramsObj || {});
            var cusFunction = params.against;
            if ($.type(cusFunction) == 'string') {
                cusFunction = window[cusFunction];
            }
            if(!cusFunction(value, params.args)) {
                Validate.fail(params.m);
            }
            return true;
        },


        error: function(errorMessage){
            this.message = errorMessage;
            this.name = 'ValidationError';
        },

        fail: function(errorMessage){
            throw new Validate.error(errorMessage);
        }

    }
})(window.comtop.cQuery, window.comtop);