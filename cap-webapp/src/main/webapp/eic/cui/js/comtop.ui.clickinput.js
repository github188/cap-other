;(function($, C) {
    C.UI.ClickInput = C.UI.Base.extend({
        options: {
            uitype: 'ClickInput',     //???????
            name: '',                 //?????
            value: '',                //???????
            emptytext: '',            //?????????????????
            width: '',                //?????
            maxlength: -1,            //????-1??????????
            readonly: false,          //??????
            icon: '',                 //??¡¤???????????
            iconwidth: '',            //??????
            enterable: false,         //??????????????????
            editable: false,          //?????
            textmode: false,          //?????????
            on_iconclick: null,       //????????
            on_change: null,          //???????
            on_focus: null,           //?????????
            on_blur: null,            //??????????
            on_keyup: null,           //keyup???
            on_keydown: null          //keydown???
        },

        //??????????????
        relation: "data-relation-value",
        
        tipPosition: '.click_input_base',

        _init: function() {
            var opts = this.options;
            opts.id = C.guid();
            if (opts.name == '') {
                opts.name = C.guid() + "_" + opts.uitype;
            }
        },

        _create: function() {
            var opts = this.options;
            this.$inputWrap = $('#' + opts.id + '_wrap');
            this.$inputBox = $('#' + opts.id + '_box');
            this.$input = $('#' + opts.id);
            this.$iconspan = $('#' + opts.id + '_icon');

            if (opts.icon != '') {
                if (opts.icon.indexOf("/") != -1 || opts.icon.indexOf(".") != -1) {
                    this.$iconspan.css({
                        backgroundImage: 'url('+opts.icon+')'
                    });
                } else {
                    this.$iconspan.addClass(opts.icon);
                }
            }

            this.setWidth(opts.width);

            //???????
            if (opts.readonly) {
                this.setReadOnly(true);
            }

            if (opts.value == "" && opts.emptytext != "") {
                this.$input.val(opts.emptytext);
                this.$input.addClass('input_tipcolor');
            }

            //????????§Õ
            this.setEditAble(opts.editable);
        },

        /**
         * ??????
         * @param width ???
         */
        setWidth: function(width) {
            this.$inputWrap.css({
                width: C.Tools.fixedNumber(width)
            });
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
            if ($.type(value) == "string") {
                $input.removeAttr(this.relation);
                $input.val(value);
            } else if ($.type(value) == "array") {
                if (value.length > 0) {
                    $input.val(value[0]);
                    value.splice(0, 1);
                    $input.attr(this.relation, value.join("|"));
                }
            }

            //??????emptyText
            if ((value != "" && value != null) || ($.type(value) == "array" && value.length > 0)) {
                $input.removeClass('input_tipcolor');
            } else if (opts.emptytext != "") {
                $input.val(opts.emptytext);
                $input.addClass("input_tipcolor");
            }

            //????????change???
            if(isInit){
                this.onValid();
            }else{
                this._triggerHandler('change');
            }

//            $input.trigger('change');
        },

        /**
         * ????
         */
        getValue: function() {
            var $input = this.$input;
            var opts = this.options;
            var value = $.trim($input.val());
            var relation = $input.attr(this.relation);
            var emptyText = opts.emptytext;
            if (value === emptyText) {
                return '';
            } else if (relation) {
                value = value + "|" + relation;
                return value.split("|");
            } else {
                return value;
            }
        },

        /**
         * ?????????????????????????
         */
        getLabelValue: function() {
            var value = this.options.value;
            if ($.type(value) == 'string') {
                return value;
            } else if ($.type(value) == 'array') {
                if (value.length > 0) {
                    return value[0];
                } else {
                    return "";
                }
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
         * ?????????????????
         * @param flag
         */
        setReadOnly: function(flag) {
            this.setReadonly(flag);
        },

        setReadonly: function(flag){
            var opts = this.options;
            var $input = this.$input;
            var $inputBox = this.$inputBox;

            opts.readonly = flag;
            if (flag) {
                $input.attr('readonly', true);
                $input.addClass('input_garybg');
                $inputBox.addClass('input_garybg');
                this._removeEmptyText(true);
            } else {
                if (opts.editable) {
                    $input.attr('readonly', false);
                }
                $input.removeClass('input_garybg');
                $inputBox.removeClass('input_garybg');
                this._removeEmptyText(false);
            }

            this.$iconspan.css({
                display: flag ? 'none' : 'inline-block'
            });
            var width = "22px";
            if (opts.iconwidth != "") {
                width = (parseFloat(opts.iconwidth) + 5) + "px";
            }
            this.$inputBox.css({
                marginRight: flag ? 0 : width
            });
        },

        /**
         * ?????????
         * @param flag
         */
        setEditAble: function(flag) {
            var opts = this.options;
            var $input = this.$input;
            if (opts.readonly) return false;
            opts.editable = flag;
            if (flag) {
                $input.attr('readonly', false);
            } else {
                $input.attr('readonly', true);
            }
        },

        /**
         * ???????
         * @param e
         * @private
         */
        _changeHander: function(e) {
            var opts = this.options;
            var $input = this.$input;
            if (opts.readonly) return false;
            //??????emptyText
            if (this.getValue() != "") {
                $input.removeClass('input_tipcolor');
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
            //????????????????????????????
            if (!opts.editable || opts.readonly) {
                this.$input.blur();
                return false;
            }

            //??????
            this._removeEmptyText(true);
            //??????
            this.$inputBox.addClass('input_focus');

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
            var $inputBox = this.$inputBox;
            if (opts.readonly) return false;
            //??????
            this._removeEmptyText(false);
            //??????
            $inputBox.removeClass('input_focus');
            this._textCounter();

            var value = this.getValue();
            switch ($.type(value)){
                case 'string':
                    if(value !== '' && value != null){
                        this._triggerHandler('change');
                    }
                    break;
                case 'array':
                    if(value.length !== 0){
                        this._triggerHandler('change');
                    }
                    break;
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
            //var $input = this.$input;
            if (opts.readonly) return false;
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
            if (opts.readonly) return false;
            if (opts.enterable && e.keyCode == 13) {
                this._iconclickHandler(e);
                return false;
            }
            //????????????????
            //this._textCounter();
            //?????????
            this._customHandler('on_keydown', e);
        },

        /**
         * ????????
         * @param e
         * @return {Boolean}
         * @private
         */
        _iconclickHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //?????????
            this._customHandler("on_iconclick", e);
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
            if ($.type(handler) == 'string') {
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
            if (emptyText == '' || inputValue.length != 0) return;
            if (isHide) {
                $input.val("");
                $input.removeClass('input_tipcolor');
            } else {
                $input.val(emptyText);
                $input.addClass('input_tipcolor');
            }
        },

        /**
         * ??????????
         * @return {Boolean}
         * @private
         */
        _textCounter: function() {
            var opts = this.options;
            var value = this.getValue();
            if (typeof value === "object") {
                value = this.$input.val();
            }
            if (opts.maxlength > 0) {
                var currentLen = C.String.getBytesLength(value);
                if (currentLen > opts.maxlength) {
                    this.setValue(C.String.intercept(value, opts.maxlength));
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
            self.$inputBox.addClass("click_input_invalid");
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
            self.$inputBox.removeClass("click_input_invalid");
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