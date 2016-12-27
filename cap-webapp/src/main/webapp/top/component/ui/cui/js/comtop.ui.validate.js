?;(function($, C) {
    C.UI.Validate = C.UI.Base.extend({

        options: {
            uitype: 'Validate',
            onValid: null,
            onInValid: null
        },

        /***  Ĭ����ʾ����ʽ��  ***/
        invalidClass: 'validate_invalid',
        messageClass: 'validate_validation_message',
        invalidFieldClass: 'validate_invalid_field',

        _create: function() {
            $.extend(this, this.options);
        },

        /**
         * �������
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
         * ���Ԫ����֤����
         * @param element Ԫ��id��Ԫ�ض���
         * @param validateMethod ��֤����
         * @param validateParamsObj ����
         */
        add: function(element, validateMethod, validateParamsObj) {
            var $cui = $.type(element) == 'string' ? cui('#' + element) : element;
            if (!$cui.options) return;
            var $el = $cui.options.el;

            //������֤����
            var validations = $el.data('validateRule') || [];
            var validJson = null;
            //����û�û����֤��������������validateMethod��Validate�������Ҳ���
            //Ĭ����Ϊ�û�ѡ����required��֤����validateMethodΪ��֤ʧ��ʱ����Ϣ
            if (!validateParamsObj && !Validate[validateMethod]) {
                validJson = {type: 'required', params: {m: validateMethod}};
            } else {
                validJson = {type: validateMethod, params: validateParamsObj || {}};
            }
            validations.push(validJson);
            $el.data('validateRule', validations);

            //������֤��Ԫ��
            var validateEl = $.data(this.options.el, 'validateEl') || [];
            if (!this._contains($el[0], validateEl)) {
                //Ϊelementע���¼�
                $cui.bind('change', this, this._validateEvent);
                validateEl.push($el[0]);
            }
            $.data(this.options.el, 'validateEl', validateEl);
        },
        /**
         * �޸�Ԫ����֤��ʾ
         * @param element Ԫ��id��Ԫ�ض���
         * @param validateParamsObj ��֤�Ĳ���
         */
        setTips: function(element,validateParamsObj) {
            if(!element || !validateParamsObj){
                return;
            }
            var $cui = $.type(element) === 'string' ? cui('#' + element) : element;
            if (!$cui.options) return;
            var $el = $cui.options.el;

            //������֤����
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
         * ��ȡ�����������
         * @param obj ����
         */
        _getPropertyNames: function(obj) {
            var result = [];
            for(key in obj){
                result.push(key);
            }
            return result;

        },
        /**
         * �Ƿ���ָ��Ԫ�ص���֤ʧЧ
         * @param element Ԫ��id��Ԫ��cui����
         * @param flag �Ƿ�ʧЧtrue/false
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
         * ��������������
         * @param obj����Ԫ��
         * @param array����
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
         * �Ƴ�Ԫ�ع���
         * @param element Ԫ��id��Ԫ�ض���
         * @param validateMethod ��֤����
         * @param validateParamsObj ����
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

                //�Ƴ���֤Ԫ��
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
         * ��֤�¼�
         * @param e
         * @param {Boolean} isReset �Ƿ�������������ã��������ݲ�ִ����֤
         * @private
         */
        _validateEvent: function(e, isReset) {
            var self = e.data;
            //!!isReset��undefinedתΪfalse
            self._validate(this, !!isReset);
        },

        /**
         * ��֤����Ԫ��
         * @return {Boolean}
         */
        validAllElement: function() {
            return this._validElement($.data(this.options.el, 'validateEl'));
        },

        /**
         * ��֤һ��Ԫ���Ƿ�ɹ�
         * @param element Ԫ��id��Ԫ�ض���
         * @return {Boolean}
         */
        validOneElement: function(element) {
            var $cui = $.type(element) == 'string' ? cui('#' + element) : element;
            if (!$cui.options) return false;

            return this._validate($cui);
        },

        /**
         * ��֤Ԫ��
         * @param type {String} ��֤��ʽ���ֱ��ṩ"ALL"��ȫ����֤��, "AREA"���ֲ���֤��, "CUSTOM"���Զ�����֤Ԫ�أ�
         * @param range {String|jQuery|HTMLElement} ��֤��Χ
         * @param include {Boolean} �Ƿ����
         */
        validElement: function(type, range, include){
            var $range = [],
                i, len;
            //Ĭ����ȫ����֤
            type = type || 'ALL';
            type = type.toLocaleUpperCase(type);
            switch (type){
                //������֤
                case 'AREA':
                    var $setRange = $(range);
                    var $tmpAllRange = [];
                    var $tmpRange = [];
                    var $list = C.UI.componentList;
                    for(i = 0, len = $list.length; i < len; i ++){
                        //���������ڵı�Ԫ��
                        if($setRange.find($list[i].options.el).length){
                            if(typeof $list[i].options.textmode !== 'undefined'){
                                $tmpRange.push($list[i].options.el[0]);
                            }
                        }
                        //�������б�Ԫ��
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
         * ��֤Ԫ��
         * @param {CUI} $cui Ԫ��cui����
         * @param {Boolean} isReset �Ƿ�������������ã��������ݲ�ִ����֤
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
                //�ж��Ƿ���֤��Ԫ�أ�������ֱ֤�ӷ�����֤��ȷ
                var result = null;
                var disValid = $cui.options.el.data("disValid");
                if (disValid && disValid == "true") {
                    result = {valid: true, message: ''};
                } else {
                    result = this._doValidate($cui);
                }
                var isValid = result.valid;
                if (isValid) {
                    // �������֤�������onValid����ִ�и÷���
                    // ����ִ��validate����Դ���onValid����
                    if ($cui.onValid && !this.options.onValid) {
                        $cui.onValid($cui);
                    }else if(!$cui.onValid && !this.options.onValid){
                        this.onValid($el);
                    }else{
                        this.options.onValid.apply(this, [$el]);
                    }
                } else {
                    // �������֤�������onInvalid����ִ�и÷���
                    // ����ִ��validate����Դ���onInvalid����
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
         * ��֤ĳһԪ�ص����й���
         * @param $cui Ԫ��cui����
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
         * ��֤ĳһԪ�صĵ�һ����
         * @param $cui Ԫ��cui����
         * @param validation ����
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
         * ��֤ʧ���������Ĭ�Ϸ���
         * @param element
         * @param message
         */
        onInValid: function(element, message){
            this._insertMessage(element, this._createMessageSpan(message));
            this._addFieldClass(element);
        },

        /**
         * ��֤�ɹ��������Ĭ�Ϸ���
         * @param element
         */
        onValid: function(element){
            this._removeMessageAndFieldClass(element)
        },

        /**
         * ����һ��span���������ʧ�ܻ��߳ɹ���Ϣ
         * @param message
         * @return {Element}
         * @private
         */
        _createMessageSpan: function(message) {
            return $("<span></span>").html(message);
        },

        /**
         * ����ʧ����ʾ��Ϣ
         * @param element ��֤��Ԫ��
         * @param elementToInsert ��Ϣ����
         * @private
         */
        _insertMessage: function(element, elementToInsert) {
            this._removeMessage(element);
            $(elementToInsert).addClass(this.messageClass + (' ' + this.invalidClass));
            $(elementToInsert).insertAfter(element);
        },

        /**
         * Ϊ��֤��Ԫ�������ʽ
         * @param element ��֤��Ԫ��
         * @private
         */
        _addFieldClass: function(element) {
            this._removeFieldClass(element);
            $(element).addClass(this.invalidFieldClass);
        },

        /**
         * �Ƴ�ʧ����ʾ
         * @param element ��֤��Ԫ��
         * @private
         */
        _removeMessage: function(element) {
            if (nextEl = $(element).next('.' + this.messageClass)) {
                $(nextEl).remove();
            }
        },

        /**
         * �Ƴ���ʽ
         * @param element ��֤��Ԫ��
         * @private
         */
        _removeFieldClass: function(element) {
            $(element).removeClass(this.invalidFieldClass);
        },

        /**
         * �Ƴ�ʧ����Ϣ�Լ��Ƴ���ʽ
         * @param element ��֤��Ԫ��
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
         * ��֤�Ƿ����(��չ�ֶ� req)
         * ���� ��������
         * m: ������Ϣ�ַ���
         * emptyVal:���������е�Ҳ��Ϊ��
         */
        required: function(value, paramsObj){
            var params = $.extend({
                m: "����Ϊ��!"
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
         * ��֤��ֵ����(��չ�ֶ� num)
         * ���� ����                                 ����
         *  oi�� �Ƿ�ֻ��ΪInteger ��onlyInteger��     true/false
         *  min: ��С��                               ����
         *  max: �����                               ����
         *  is:  ����͸��������                      ����
         *  wrongm: ���벻�� is ��ȵ�����ʱ��ʾ��Ϣ       ����
         *  notnm����Ϊ����ʱ��ʾ��Ϣ                    �ַ���
         *  notim����Ϊ����ʱ��ʾ��Ϣ                    �ַ���
         *  minm��С�� min ����ʱ��ʾ��Ϣ               �ַ���
         *  maxm������ max ����ʱ��ʾ��Ϣ               �ַ���
         */
        numeric: function(value, paramsObj){
            var suppliedValue = value;
            if ('' === value) return true;
            var value = Number(value);
            var paramsObj = paramsObj || {};
            var params = {
                notANumberMessage:  paramsObj.notnm || "����Ϊ����!",
                notAnIntegerMessage: paramsObj.notim || "����Ϊ����!",
                wrongNumberMessage: paramsObj.wrongm || "����Ϊ " + paramsObj.is + "!",
                tooLowMessage:         paramsObj.minm || "������� " + paramsObj.min + "!",
                tooHighMessage:        paramsObj.maxm || "����С�� " + paramsObj.max + "!",
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
         * ������ʽ��֤ (��չ�ֶ� format)
         *  ����   ����                                 ����
         *  m:     ������Ϣ                             �ַ���
         *  pattern: ��֤������ʽ                     �ַ���
         *  negate: �Ƿ���Ա�����֤��negate��           true/false
         */
        format: function(value, paramsObj){
            var value = String(value);
            if ('' == value) return true;
            var params = $.extend({
                m: "�����Ϲ涨��ʽ!",
                pattern:           /./ ,
                negate:            false
            }, paramsObj || {});
            params.pattern = $.type(params.pattern) == "string" ? new RegExp(params.pattern) : params.pattern;
            if(!params.negate) {//������
                if(!params.pattern.test(value)) { //������,����֤����
                    Validate.fail(params.m);
                }
            }
            return true;
        },

        /**
         * �����ʽ��֤ (��չ�ֶ� email)
         * ���� ����                                 ����
         *  m:   ������Ϣ                             �ַ���
         */
        email: function(value, paramsObj){
            if ('' == value) return true;
            var params = $.extend({
                m: "�����ʽ���벻�Ϸ�!"
            }, paramsObj || {});
            Validate.format(value, {
                m: params.m,
                pattern: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
            });
            return true;
        },

        /**
         * ���ڸ�ʽ��֤ (��չ�ֶ� date)���������ꡢ���µ�����
         * ���� ����                                 ����
         *  m:   ������Ϣ                            �ַ���
         */
        dateFormat : function(value, paramsObj) {
            var params = $.extend({
                m: "���ڸ�ʽ����Ϊyyyy-MM-dd��ʽ��"
            }, paramsObj || {});
            Validate.format(value, {
                m: params.m,
                pattern: /^((((((0[48])|([13579][26])|([2468][048]))00)|([0-9][0-9]((0[48])|([13579][26])|([2468][048]))))-02-29)|(((000[1-9])|(00[1-9][0-9])|(0[1-9][0-9][0-9])|([1-9][0-9][0-9][0-9]))-((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30))|(((0[1-9])|(1[0-2]))-((0[1-9])|(1[0-9])|(2[0-8]))))))$/i
            });
            return true;
        },

        /**
         * ������֤(��չ�ֶ� len)
         * ���� ����                               ����
         *  m:   ������Ϣ                          �ַ���
         *  min: ��С����                          ����
         *  max: ��󳤶�                          ����
         *  is:  ����͸ó������                     ����
         *  wrongm: ���볤�Ⱥ� is �����ʱ��ʾ��Ϣ        ����
         *  minm������С�� min ����ʱ��ʾ��Ϣ            �ַ���
         *  maxm�����ȴ��� max ����ʱ��ʾ��Ϣ            �ַ���
         */
        length: function(value, paramsObj){
            var value = String(value);
            var paramsObj = paramsObj || {};
            var params = {
                wrongLengthMessage: paramsObj.wrongm || "���ȱ���Ϊ " + paramsObj.is + " �ֽ�!",
                tooShortMessage:      paramsObj.minm || "���ȱ������ " + paramsObj.min + " �ֽ�!",
                tooLongMessage:       paramsObj.maxm || "���ȱ���С�� " + paramsObj.max + " �ֽ�!",
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
                    throw new Validate.error("Validate::Length - ������֤�����ṩ����ֵ!");
            }
            return true;
        },

        /**
         * ������֤ (��չ�ֶ� inc)
         * ���� ����                                 ����
         *  m:   ������Ϣ                             �ַ���
         *  negate: �Ƿ����                          true/false
         *  caseSensitive: ��Сд����(caseSensitive)   true/false
         *  allowNull: �Ƿ����Ϊ��                    ����
         *  within:  ����                             ����
         *  partialMatch: �Ƿ񲿷�ƥ��                 true/false
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
            params.m = params.m || value + "û�а���������" + params.within.join(',') + "��";
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
         * ��������֤ (��չ�ֶ� exc)
         * ���� ����                                 ����
         *  m:   ������Ϣ                             �ַ���
         *  caseSensitive: ��Сд����(caseSensitive)   true/false
         *  allowNull: �Ƿ����Ϊ��                    ����
         *  within:  ����                             ����
         *  partialMatch: �Ƿ񲿷�ƥ��                 true/false
         */
        exclusion: function(value, paramsObj){
            var params = $.extend({
                m: "",
                within:             [],
                allowNull:          false,
                partialMatch:     false,
                caseSensitive:   true
            }, paramsObj || {});
            params.m = params.m || value + "��Ӧ��������" + params.within.join(',') + "�У�";
            params.negate = true;// set outside of params so cannot be overridden
            Validate.inclusion(value, params);
            return true;
        },

        /**
         * ���ƥ��һ����֤�����û��������� (��չ�ֶ� confirm)
         * ���� ����                                 ����
         *  m:   ������Ϣ                             �ַ���
         *  match: ��֤��֮ƥ���Ԫ������              Ԫ�ػ�Ԫ��id
         */
        confirmation: function(value, paramsObj){
            if(!paramsObj.match) {
                throw new Error("Validate::Confirmation - ��֮ƥ���Ԫ�����û�Ԫ��id���뱻�ṩ!");
            }
            var params = $.extend({
                m: "���߲�һ��!",
                match:            null
            }, paramsObj || {});
            params.match = $.type(params.match) == 'string' ? cui('#' + params.match) : params.match;
            if(!params.match || params.match.length == 0) {
                throw new Error("Validate::Confirmation - ��֮ƥ���Ԫ�����û�Ԫ�ز�����!");
            }
            if(value != params.match.getValue()) {
                Validate.fail(params.m);
            }
            return true;
        },

        /**
         * ��ֵ֤�Ƿ�Ϊtrue ��Ҫ����֤checkbox (��չ�ֶ� accept)
         * ���� ����                                 ����
         *  m:   ������Ϣ                             �ַ���
         */
        acceptance: function(value, paramsObj){
            var params = $.extend({
                m: "����ѡ��!"
            }, paramsObj || {});
            if(!value) {
                Validate.fail(params.m);
            }
            return true;
        },

        /**
         * �Զ�����֤���� (��չ�ֶ� custom)
         * ���� ����                                 ����
         *  m:   ������Ϣ                             �ַ���
         *  against:  �Զ���ĺ���                    function
         *  args:   �Զ���ĺ����Ĳ���                 ����
         * */
        custom: function(value, paramsObj){
            var params = $.extend({
                against: function(){ return true; },
                args: {},
                m: "���Ϸ�!"
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