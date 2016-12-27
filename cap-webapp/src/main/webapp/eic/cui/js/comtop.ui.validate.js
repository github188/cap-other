;(function($, C) {
    C.UI.Validate = C.UI.Base.extend({

        options: {
            uitype: 'Validate',
            onValid: null,
            onInValid: null
        },

        /***  ?????????????  ***/
        invalidClass: 'validate_invalid',
        messageClass: 'validate_validation_message',
        invalidFieldClass: 'validate_invalid_field',

        _create: function() {
            $.extend(this, this.options);
        },

        /**
         * ??????
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
         * ?????????????
         * @param element ???id????????
         * @param validateMethod ???????
         * @param validateParamsObj ????
         */
        add: function(element, validateMethod, validateParamsObj) {
            var $cui = $.type(element) == 'string' ? cui('#' + element) : element;
            if (!$cui.options) return;
            var $el = $cui.options.el;

            //???????????
            var validations = $el.data('validateRule') || [];
            var validJson = null;
            //?????????????????????validateMethod??Validate???????????
            //??????????????required???????validateMethod?????????????
            if (!validateParamsObj && !Validate[validateMethod]) {
                validJson = {type: 'required', params: {m: validateMethod}};
            } else {
                validJson = {type: validateMethod, params: validateParamsObj || {}};
            }
            validations.push(validJson);
            $el.data('validateRule', validations);

            //????????????
            var validateEl = $.data(this.options.el, 'validateEl') || [];
            if (!this._contains($el[0], validateEl)) {
                //?element??????
                $cui.bind('change', this, this._validateEvent);
                validateEl.push($el[0]);
            }
            $.data(this.options.el, 'validateEl', validateEl);
        },

        /**
         * ????????????????§¹
         * @param element ???id?????cui????
         * @param flag ????§¹true/false
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
         * ???????????
         * @param obj???????
         * @param array????
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
         * ?????????
         * @param element ???id????????
         * @param validateMethod ???????
         * @param validateParamsObj ????
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

                //?????????
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
         * ??????
         * @param e
         * @param {Boolean} isReset ??????????????????????????????
         * @private
         */
        _validateEvent: function(e, isReset) {
            var self = e.data;
            //!!isReset??undefined??false
            self._validate(this, !!isReset);
        },

        /**
         * ??????????
         * @return {Boolean}
         */
        validAllElement: function() {
            return this._validElement($.data(this.options.el, 'validateEl'));
        },

        /**
         * ??????????????
         * @param element ???id????????
         * @return {Boolean}
         */
        validOneElement: function(element) {
            var $cui = $.type(element) == 'string' ? cui('#' + element) : element;
            if (!$cui.options) return false;

            return this._validate($cui);
        },

        /**
         * ??????
         * @param type {String} ?????????????"ALL"??????????, "AREA"??????????, "CUSTOM"??????????????
         * @param range {String|jQuery|HTMLElement} ?????¦¶
         * @param include {Boolean} ????
         */
        validElement: function(type, range, include){
            var $range = [],
                i, len;
            //???????????
            type = type || 'ALL';
            type = type.toLocaleUpperCase(type);
            switch (type){
                //???????
                case 'AREA':
                    var $setRange = $(range);
                    var $tmpAllRange = [];
                    var $tmpRange = [];
                    var $list = C.UI.componentList;
                    for(i = 0, len = $list.length; i < len; i ++){
                        //???????????????
                        if($setRange.find($list[i].options.el).length){
                            if(typeof $list[i].options.textmode !== 'undefined'){
                                $tmpRange.push($list[i].options.el[0]);
                            }
                        }
                        //???????§Ò????
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
         * ??????
         * @param {CUI} $cui ???cui????
         * @param {Boolean} isReset ??????????????????????????????
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
                //?§Ø????????????????????????????????
                var result = null;
                var disValid = $cui.options.el.data("disValid");
                if (disValid && disValid == "true") {
                    result = {valid: true, message: ''};
                } else {
                    result = this._doValidate($cui);
                }
                var isValid = result.valid;
                if (isValid) {
                    // ???????????????onValid??????§Ú¡Â???
                    // ???????validate???????onValid????
                    if ($cui.onValid && !this.options.onValid) {
                        $cui.onValid($cui);
                    }else if(!$cui.onValid && !this.options.onValid){
                        this.onValid($el);
                    }else{
                        this.options.onValid.apply(this, [$el]);
                    }
                } else {
                    // ???????????????onInvalid??????§Ú¡Â???
                    // ???????validate???????onInvalid????
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
         * ????????????§Û???
         * @param $cui ???cui????
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
         * ???????????????
         * @param $cui ???cui????
         * @param validation ????
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
         * ???????????????????
         * @param element
         * @param message
         */
        onInValid: function(element, message){
            this._insertMessage(element, this._createMessageSpan(message));
            this._addFieldClass(element);
        },

        /**
         * ???????????????????
         * @param element
         */
        onValid: function(element){
            this._removeMessageAndFieldClass(element)
        },

        /**
         * ???????span????????????????????
         * @param message
         * @return {Element}
         * @private
         */
        _createMessageSpan: function(message) {
            return $("<span></span>").html(message);
        },

        /**
         * ?????????????
         * @param element ????????
         * @param elementToInsert ???????
         * @private
         */
        _insertMessage: function(element, elementToInsert) {
            this._removeMessage(element);
            $(elementToInsert).addClass(this.messageClass + (' ' + this.invalidClass));
            $(elementToInsert).insertAfter(element);
        },

        /**
         * ???????????????
         * @param element ????????
         * @private
         */
        _addFieldClass: function(element) {
            this._removeFieldClass(element);
            $(element).addClass(this.invalidFieldClass);
        },

        /**
         * ?????????
         * @param element ????????
         * @private
         */
        _removeMessage: function(element) {
            if (nextEl = $(element).next('.' + this.messageClass)) {
                $(nextEl).remove();
            }
        },

        /**
         * ??????
         * @param element ????????
         * @private
         */
        _removeFieldClass: function(element) {
            $(element).removeClass(this.invalidFieldClass);
        },

        /**
         * ??????????????????
         * @param element ????????
         * @private
         */
        _removeMessageAndFieldClass: function(element) {
            this._removeMessage(element);
            this._removeFieldClass(element);
        }
    });

    var Validate = {

        /**
         * ?????????(?????? req)
         * ???? ???????
         * m: ??????????
         * emptyVal:???????§Ö???????
         */
        required: function(value, paramsObj){
            var params = $.extend({
                m: "???????!"
            }, paramsObj || {});
            if(value === '' || value === null || value === undefined) {
                Validate.fail(params.m);
            }
            if (params.emptyVal) {
                $.each(params.emptyVal, function(i, item) {
                    if (value == item) {
                        Validate.fail(params.m);
                    }
                });
            }
            if ($.type(value) == 'array' && value.length == 0) {
                Validate.fail(params.m);
            } else if ($.type(value) == 'array') {
                for (var i = 0; i < value.length; i++) {
                    if (value[i] === '' || value[i] === null || value[i] === undefined) {
                        Validate.fail(params.m);
                        break;
                    }
                }
            }
            return true;
        },

        /**
         * ??????????(?????? num)
         * ???? ????                                 ???
         *  oi?? ???????Integer ??onlyInteger??     true/false
         *  min: ??§³??                               ????
         *  max: ?????                               ????
         *  is:  ?????????????                      ????
         *  wrongm: ?????? is ???????????????       ????
         *  notnm????????????????                    ???
         *  notim????????????????                    ???
         *  minm??§³?? min ???????????               ???
         *  maxm?????? max ???????????               ???
         */
        numeric: function(value, paramsObj){
            var suppliedValue = value;
            if ('' === value) return true;
            var value = Number(value);
            var paramsObj = paramsObj || {};
            var params = {
                notANumberMessage:  paramsObj.notnm || "?????????!",
                notAnIntegerMessage: paramsObj.notim || "?????????!",
                wrongNumberMessage: paramsObj.wrongm || "????? " + paramsObj.is + "!",
                tooLowMessage:         paramsObj.minm || "??????? " + paramsObj.min + "!",
                tooHighMessage:        paramsObj.maxm || "????§³?? " + paramsObj.max + "!",
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
         * ?????????? (?????? format)
         *  ????   ????                                 ???
         *  m:     ???????                             ???
         *  pattern: ??????????                     ???
         *  negate: ??????????????negate??           true/false
         */
        format: function(value, paramsObj){
            var value = String(value);
            if ('' == value) return true;
            var params = $.extend({
                m: "?????ÕÇ???!",
                pattern:           /./ ,
                negate:            false
            }, paramsObj || {});
            params.pattern = $.type(params.pattern) == "string" ? new RegExp(params.pattern) : params.pattern;
            if(!params.negate) {//??????
                if(!params.pattern.test(value)) { //??????,?????????
                    Validate.fail(params.m);
                }
            }
            return true;
        },

        /**
         * ????????? (?????? email)
         * ???? ????                                 ???
         *  m:   ???????                             ???
         */
        email: function(value, paramsObj){
            if ('' == value) return true;
            var params = $.extend({
                m: "?????????????!"
            }, paramsObj || {});
            Validate.format(value, {
                m: params.m,
                pattern: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
            });
            return true;
        },

        /**
         * ????????? (?????? date)???????????????????
         * ???? ????                                 ???
         *  m:   ???????                            ???
         */
        dateFormat : function(value, paramsObj) {
            var params = $.extend({
                m: "???????????yyyy-MM-dd?????"
            }, paramsObj || {});
            Validate.format(value, {
                m: params.m,
                pattern: /^((((((0[48])|([13579][26])|([2468][048]))00)|([0-9][0-9]((0[48])|([13579][26])|([2468][048]))))-02-29)|(((000[1-9])|(00[1-9][0-9])|(0[1-9][0-9][0-9])|([1-9][0-9][0-9][0-9]))-((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30))|(((0[1-9])|(1[0-2]))-((0[1-9])|(1[0-9])|(2[0-8]))))))$/i
            });
            return true;
        },

        /**
         * ???????(?????? len)
         * ???? ????                               ???
         *  m:   ???????                          ???
         *  min: ??§³????                          ????
         *  max: ????                          ????
         *  is:  ?????¨®??????                     ????
         *  wrongm: ??????? is ????????????        ????
         *  minm??????§³?? min ???????????            ???
         *  maxm????????? max ???????????            ???
         */
        length: function(value, paramsObj){
            var value = String(value);
            var paramsObj = paramsObj || {};
            var params = {
                wrongLengthMessage: paramsObj.wrongm || "???????? " + paramsObj.is + " ???!",
                tooShortMessage:      paramsObj.minm || "?????????? " + paramsObj.min + " ???!",
                tooLongMessage:       paramsObj.maxm || "???????§³?? " + paramsObj.max + " ???!",
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
                    throw new Validate.error("Validate::Length - ??????????????????!");
            }
            return true;
        },

        /**
         * ????? (?????? inc)
         * ???? ????                                 ???
         *  m:   ???????                             ???
         *  negate: ??????                          true/false
         *  caseSensitive: ??§³§Õ????(caseSensitive)   true/false
         *  allowNull: ?????????                    ????
         *  within:  ????                             ????
         *  partialMatch: ???????                 true/false
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
            params.m = params.m || value + "??§Ñ???????" + params.within.join(',') + "??";
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
         * ??????? (?????? exc)
         * ???? ????                                 ???
         *  m:   ???????                             ???
         *  caseSensitive: ??§³§Õ????(caseSensitive)   true/false
         *  allowNull: ?????????                    ????
         *  within:  ????                             ????
         *  partialMatch: ???????                 true/false
         */
        exclusion: function(value, paramsObj){
            var params = $.extend({
                m: "",
                within:             [],
                allowNull:          false,
                partialMatch:     false,
                caseSensitive:   true
            }, paramsObj || {});
            params.m = params.m || value + "???????????" + params.within.join(',') + "?§µ?";
            params.negate = true;// set outside of params so cannot be overridden
            Validate.inclusion(value, params);
            return true;
        },

        /**
         * ?????????????????????????? (?????? confirm)
         * ???? ????                                 ???
         *  m:   ???????                             ???
         *  match: ?????????????????              ???????id
         */
        confirmation: function(value, paramsObj){
            if(!paramsObj.match) {
                throw new Error("Validate::Confirmation - ??????????????????id??????!");
            }
            var params = $.extend({
                m: "????????!",
                match:            null
            }, paramsObj || {});
            params.match = $.type(params.match) == 'string' ? cui('#' + params.match) : params.match;
            if(!params.match || params.match.length == 0) {
                throw new Error("Validate::Confirmation - ???????????????????????!");
            }
            if(value != params.match.getValue()) {
                Validate.fail(params.m);
            }
            return true;
        },

        /**
         * ????????true ????????checkbox (?????? accept)
         * ???? ????                                 ???
         *  m:   ???????                             ???
         */
        acceptance: function(value, paramsObj){
            var params = $.extend({
                m: "???????!"
            }, paramsObj || {});
            if(!value) {
                Validate.fail(params.m);
            }
            return true;
        },

        /**
         * ???????????? (?????? custom)
         * ???? ????                                 ???
         *  m:   ???????                             ???
         *  against:  ?????????                    function
         *  args:   ?????????????                 ????
         * */
        custom: function(value, paramsObj){
            var params = $.extend({
                against: function(){ return true; },
                args: {},
                m: "?????!"
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