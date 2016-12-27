;(function($, C) {
    C.UI.Input = C.UI.Base.extend({
        options: {
            uitype: 'Input',        //???????
            width: '200px',              //?????
            readonly: false,       //??????
            maxlength: -1,          //????-1??????????
            value: '',              //???????
            emptytext: '',          //?????????????????
            name: '',               //?????
            type: 'text',           //???????text/password
            mask: '',               //inputmask???????
            maskoptions: {},        //inputmask??????
            textmode: false,        //?????????
            align: 'left',          //input??????????
            on_change: null,        //???????
            on_focus: null,         //?????????
            on_blur: null,          //??????????
            on_keyup: null,         //keyup???
            on_keydown: null,        //keydown???
            on_keypress: null       //keypress???
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
        },

        /**
         * ?????????
         * @private
         */
        _create: function() {
            var self = this,
                opts = self.options;
            this.$input = $('#' + opts.id).css('textAlign', opts.align);

            //?????????
            if (opts.mask !== '') {
                var settings = $.extend({}, opts.maskoptions, {callback: function() {
                    self._removeEmptyText(false);
                }});
                C.UI.InputMask.doMask(this.$input, opts.mask, settings);
            }

            if (opts.value === "" && opts.emptytext !== "") {
                this.$input.val(opts.emptytext);
                opts.el.addClass('cui_inputCMP_empty');
            }
            if(opts.maxlength > -1){
                this.$input.on("input propertychange", function(e){
                    self._textCounter();
                });
            }
        },
        /**
         * ??????
         * @param width {String|Number}???
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
         * ?????
         * @param value {String | Number} ?
         * @param isInit {Boolean} ???????????????????¨°?????change
         */
        setValue: function(value, isInit) {
            var $input = this.$input,
                opts = this.options;
            value = (value == null || value == undefined) ? '' : value;
            $input.val(value);
            //????????????????
            if(opts.maxlength > 0){
                this._textCounter();
            }

            //??????emptyText
            if (value !== "") {
                opts.el.removeClass('cui_inputCMP_empty');
                //?????????
                if (opts.mask !== '') {
                    var settings = $.extend({}, opts.maskoptions, {callback: function() {
                        this._removeEmptyText(false);
                    }});
                    C.UI.InputMask.doMask(this.$input, opts.mask, settings);
                }
            } else if (opts.emptytext !== '') {
                $input.val(opts.emptytext);
                opts.el.addClass("cui_inputCMP_empty");
            }
            //???ie8????????????
            /*if(C.Browser.isIE8){
             var self = this;
             setTimeout(function(){
             //????????change???
             self._triggerHandler('change');
             },1);
             }else{*/
            if(isInit){
                this.onValid();
            }else{
                this._triggerHandler('change');
            }

            //}
        },

        /**
         * ????
         */
        getValue: function() {
            var $input = this.$input;
            var opts = this.options;
            var value = $input.val();
            var emptyText = opts.emptytext;
            if ($.trim(value) === emptyText) {
                return '';
            } else {
                if (opts.mask !== '') {
                    return C.UI.InputMask.unMaskValue($input, opts.mask, opts.maskoptions);
                }
                return value;
            }
        },

        /**
         * ?????????????????
         * @param maxlength
         */
        setMaxLength: function(maxlength) {
            this.options.maxlength = maxlength;
        },

        /**
         * ???????
         * @param flag ??????
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
         * ??????
         * @return {*}
         */
        focus: function(){
            var opts = this.options;
            if(!opts.readonly){
                opts.el.find(':text, :password').focus();
            }
            return this;
        },

        /**
         * ???????
         * @param e
         * @private
         */
        _changeHander: function(e) {
            var opts = this.options;
            var $input = this.$input;
            if (opts.readonly) {
                return false;
            }
            //??????emptyText
            if (this.getValue() !== "") {
                opts.el.removeClass('cui_inputCMP_empty');
            } else if (opts.emptytext !== "") {
                $input.val(opts.emptytext);
                opts.el.addClass("cui_inputCMP_empty");
            }
            //????????change???
            this._triggerHandler('change');
            //????????????
            this._customHandler('on_change', e);
        },

        /**
         * ?????????
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
            //??????
            this._removeEmptyText(true);

            //??????
            opts.el.addClass('cui_inputCMP_focus');

            //????????????????
            this.onValid();

            //?????????
            this._customHandler('on_focus', e);
        },

        /**
         * ?????????
         * @param e
         * @private
         */
        _blurHandler: function(e) {
            var opts = this.options;
            //var $input = this.$input;

            if (opts.readonly) {
                return false;
            }
            //??????
            this._removeEmptyText(false);
            //??????
            opts.el.removeClass('cui_inputCMP_focus');
            this._textCounter();

            //????????????????????????change
            var value = this.getValue();
            if(value !== '' && value != null){
                this._triggerHandler('change');
            }

            //?????????
            this._customHandler('on_blur', e);
        },

        /**
         * keyup???
         * @param e
         * @private
         */
        _keyupHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) {return false;}
            //????????????????
            this._textCounter();
            //?????????
            this._customHandler('on_keyup', e);
        },

        /**
         * keydown???
         * @param e
         * @private
         */
        _keydownHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) {return false;}
            //????????????????
            //this._textCounter();
            //?????????
            this._customHandler('on_keydown', e);
        },

        /**
         * keypress???
         * @param e
         * @private
         */
        _keypressHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //????????????????
            //this._textCounter();
            //?????????
             if(opts.maxlength>-1){
                 var len =C.String.getBytesLength(this.getValue());
                 if(len  >= opts.maxlength && e.which > 14 && !e.ctrlKey ) {
                     e.preventDefault();
                 }
             }
            this._customHandler('on_keypress', e);
        },

        /**
         * ??????
         * @param type ???????
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
         * ???????????emptyText
         * @param isHide true/false??????
         * @private
         */
        _removeEmptyText: function(isHide) {
            var $input = this.$input;
            var emptyText = this.options.emptytext;
            var inputValue = this.getValue();
            var opts = this.options;
            if (emptyText === '' || inputValue.length !== 0) return;
            if (isHide) {
                $input.val("");
                opts.el.removeClass('cui_inputCMP_empty');
            } else {
                $input.val(emptyText);
                opts.el.addClass('cui_inputCMP_empty');
            }
        },

        /**
         * ??????????
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
         * ????????????????
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
        },

        /**
         * ????????????????
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
                //???????
                var $cuiTip = cui.tipList[tipID];
                typeof $cuiTip !== 'undefined' && $cuiTip.hide();
            }
            opts.el.attr("tip", opts.tipTxt);
        }
    });
})(window.comtop.cQuery, window.comtop);