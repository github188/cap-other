?;(function($, C) {
    C.UI.Input = C.UI.Base.extend({
        options: {
            uitype: 'Input',        //�������
            width: '200px',              //Ĭ�Ͽ��
            readonly: false,       //�Ƿ�ֻ��
            maxlength: -1,          //��󳤶�-1Ϊ�����Ƴ���
            value: '',              //Ĭ���ı�ֵ
            emptytext: '',          //��ǰû������ʱ��ʾ��ֵ
            name: '',               //�����
            type: 'text',           //�������text/password
            mask: '',               //inputmaskģ������
            maskoptions: {},        //inputmaskģ����չ
            textmode: false,        //�Ƿ�Ϊֻ��ģʽ
            align: 'left',          //input������ֶ���
            on_change: null,        //ֵ�ı��¼�
            on_focus: null,         //��ý����¼�
            on_blur: null,          //��ʧ�����¼�
            on_keyup: null,         //keyup�¼�
            on_keydown: null,        //keydown�¼�
            on_keypress: null       //keypress�¼�
        },

        tipPosition: '.cui_inputCMP_wrap',

        _init: function() {
            var opts = this.options;
            opts.id = 'cui_inputCMP_' + C.guid();
            if (opts.type !== 'password' && opts.type !== 'hidden') {
                opts.type = 'text';
            }
            if (opts.name === '') {
                opts.name = C.guid() + "_" + opts.uitype;
            }
            //valueת��
            opts.value = opts.value.replace(/\"/g, '&quot;').replace(/\'/g, '&#39;');
        },

        /**
         * ��ʼ������
         * @private
         */
        _create: function() {
            var self = this,
                opts = self.options, $input;
            $input = this.$input = $('#' + opts.id).css('textAlign', opts.align);
            this.$empty = opts.el.find(".cui_input_empty").eq(0).css("text-align", opts.align).on("mousedown", function () {
                $input.focus();
            });
            //ִ��ģ�����
            if (opts.mask !== '') {
                var settings = $.extend({}, opts.maskoptions, {callback: function() {
                    self._removeEmptyText(false);
                }});
                C.UI.InputMask.doMask(this.$input, opts.mask, settings);
            }

            if (opts.value === "") {
                this.$empty.html(opts.emptytext);
            }
            if(opts.maxlength > -1){
                this.$input.on("input propertychange", function(e){
                    self._textCounter();
                });
            }
        },
        /**
         * ���ÿ��
         * @param width {String|Number}���
         */
        setWidth: function(width) {
            if(typeof width === 'string' && /\d+(\%|px|pt|em)/.test(width)){
                this.options.el.children('div').css({
                    width: width
                });
            }else if(typeof width === 'number'){
                this.options.el.children('div').css({
                    width: width + 'px'
                });
            }
        },

        /**
         * ����ֵ
         * @param value {String | Number} ֵ
         * @param isInit {Boolean} �Ƿ���������ã�������ò�����change
         */
        setValue: function(value, isInit) {
            var $input = this.$input,
                opts = this.options;
            value = (value == null || value == undefined) ? '' : value;
            $input.val(value);
            //������������ֽ���
            if(opts.maxlength > 0){
                this._textCounter();
            }

            //�Ƿ���ʾemptyText
            if (value !== "") {
                this.$empty.html("");
                //ִ��ģ�����
                if (opts.mask !== '') {
                    var settings = $.extend({}, opts.maskoptions, {callback: function() {
                        this._removeEmptyText(false);
                    }});
                    C.UI.InputMask.doMask(this.$input, opts.mask, settings);
                }
            } else if (opts.emptytext !== '') {
                this.$empty.html(opts.emptytext);
            }

            if(isInit){
                this.onValid();
            }else{
                this._triggerHandler('change');
                $input.change();
            }
        },

        /**
         * ��ȡֵ
         */
        getValue: function() {
            var $input = this.$input;
            var opts = this.options;
            var value = $input.val();
            if (opts.mask !== '') {
                return C.UI.InputMask.unMaskValue($input, opts.mask, opts.maskoptions);
            }
            return value;
        },

        /**
         * ����ռλ������
         * @param txt {String} ����
         */
        setEmptyText: function(txt){
            var opts = this.options,
                $input = this.$input;
            if(typeof txt !== 'string'){
                return;
            }
            if($.trim(txt) === ''){
                opts.emptytext = '';
            }else{
                opts.emptytext = txt;
            }
            if(this.getValue() === ''){
                this.$empty.html(opts.emptytext);
            }
        },

        /**
         * ���ÿ���������ֽ���
         * @param maxlength
         */
        setMaxLength: function (maxlength) {
            this.options.maxlength = maxlength;
        },

        /**
         * ����ֻ��
         * @param flag �Ƿ�ֻ��
         */
        setReadOnly: function(flag) {
            var opts = this.options;
            var $input = this.$input;

            opts.readonly = flag;
            $input.attr('readonly', flag);
            if (flag) {
                opts.el.children('div').addClass('cui_inputCMP_readonly');
                this._removeEmptyText(true);
            } else {
                opts.el.children('div').removeClass('cui_inputCMP_readonly');
                this._removeEmptyText(false);
            }
        },
        setReadonly: function(flag) {
            this.setReadOnly(flag);
        },

        /**
         * ������
         * @return {*}
         */
        focus: function(){
            var opts = this.options;
            if(!opts.readonly){
                opts.el.find(':text, :password')[0].focus();
            }
            return this;
        },

        /**
         * ֵ�ı��¼�
         * @param e
         * @private
         */
        _changeHander: function(e) {
            var opts = this.options;
            var $input = this.$input;
            if (opts.readonly) {
                return false;
            }
            //�Ƿ���ʾemptyText
            if (this.getValue() !== "") {
                this.$empty.html("");
            } else if (opts.emptytext !== "") {
                this.$empty.html(opts.emptytext);
            }
            //��������change�¼�
            this._triggerHandler('change');
            //ִ���û��¼��ص�
            this._customHandler('on_change', e);
        },

        /**
         * ��ý����¼�
         * @param e
         * @private
         */
        _focusHandler: function(e) {
            var opts = this.options;
            //var $input = this.$input;

            if (opts.readonly) {
                //$input.blur();
                return false;
            }
            //�Ƴ���ʾ
            this._removeEmptyText(true);

            //�����ʽ
            opts.el.addClass('cui_inputCMP_focus');

            //��ʱȥ��������֤��Ϣ
            this.onValid();

            //ִ���û��ص�
            this._customHandler('on_focus', e);
        },

        /**
         * ʧȥ�����¼�
         * @param e
         * @private
         */
        _blurHandler: function(e) {
            var opts = this.options;
            //var $input = this.$input;

            if (opts.readonly) {
                return false;
            }
            //�����ʾ
            this._removeEmptyText(false);
            //ɾ����ʽ
            opts.el.removeClass('cui_inputCMP_focus');
            this._textCounter();

            //ʧ��ʱ��������ݲ�Ϊ��ʱ������change
            var value = this.getValue();
            if(value !== '' && value != null){
                this._triggerHandler('change');
            }

            //ִ���û��ص�
            this._customHandler('on_blur', e);
        },

        /**
         * keyup�¼�
         * @param e
         * @private
         */
        _keyupHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) {return false;}
            //������������ֽ���
            this._textCounter();
            //ִ���û��ص�
            this._customHandler('on_keyup', e);
        },

        /**
         * keydown�¼�
         * @param e
         * @private
         */
        _keydownHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) {return false;}
            //������������ֽ���
            //this._textCounter();
            //ִ���û��ص�
            this._customHandler('on_keydown', e);
        },

        /**
         * keypress�¼�
         * @param e
         * @private
         */
        _keypressHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //������������ֽ���
            //this._textCounter();
            //ִ���û��ص�
            /*             if(opts.maxlength>-1){
             var len =C.String.getBytesLength(this.getValue());
             if(len  >= opts.maxlength && e.which > 14 && !e.ctrlKey ) {
             // e.preventDefault();
             }
             }*/
            this._customHandler('on_keypress', e);
        },

        /**
         * �û��¼�
         * @param type �¼�����
         * @param e
         * @private
         */
        _customHandler: function(type, e) {
            var opts = this.options;
            var handler = opts[type];
            if ($.type(handler) === 'string') {
                typeof window[handler] === 'function' && window[handler].call(this, e, this);
            } else {
                typeof handler === 'function' && handler.call(this, e, this);
            }
        },

        /**
         * ��ʾ��������emptyText
         * @param isHide true/false�Ƿ���ʾ
         * @private
         */
        _removeEmptyText: function(isHide) {
            var emptyText = this.options.emptytext;
            var inputValue = this.getValue();
            var opts = this.options;
            if (emptyText === '' || inputValue.length !== 0) {
                return;
            }
            if (isHide) {
                this.$empty.html("");
            } else {
                this.$empty.html(opts.emptytext);
            }
        },

        /**
         * �������볤��
         * @return {Boolean}
         * @private
         */
        _textCounter: function() {
            var opts = this.options;
            var value= this.getValue().toString();
            if (opts.maxlength > -1) {
                var currentLen =  C.String.getBytesLength(value);
                if (currentLen > opts.maxlength) {
                    this.$input.val(C.String.intercept(value, opts.maxlength));
                    // this.setValue(C.String.intercept(value, opts.maxlength));
                } else {
                    return false;
                }
            }
            return false;
        },

        /**
         * ��֤ʧ��ʱ���������
         * @param obj
         * @param message
         */
        onInValid: function(obj, message) {
            var self = this,
                opts = self.options;
            opts.el.addClass("cui_inputCMP_error");
            if (opts.tipTxt == null) {
                opts.tipTxt = opts.el.attr("tip") || "";
            }
            opts.el.attr("tip", message);
            //����tip���ͣ�����
            $(self.tipPosition, opts.el).attr('tipType', 'error');
        },

        /**
         * ��֤�ɹ�ʱ���������
         * @param obj
         */
        onValid: function(obj) {
            var self = this,
                opts = self.options,
                tipID = $(self.tipPosition, opts.el).attr('tipID');
            opts.el.removeClass("cui_inputCMP_error");
            if (opts.tipTxt == null) {
                opts.tipTxt = opts.el.attr("tip") || "";
            }
            if(tipID !== undefined){
                //������ʾ
                var $cuiTip = cui.tipList[tipID];
                typeof $cuiTip !== 'undefined' && $cuiTip.hide();
            }
            opts.el.attr("tip", opts.tipTxt);
            //����tip���ͣ�����
            $(self.tipPosition, opts.el).attr('tipType', 'normal');
        }
    });
})(window.comtop.cQuery, window.comtop);