?;(function($, C) {
    C.UI.ClickInput = C.UI.Base.extend({
        options: {
            uitype: 'ClickInput',     //�������
            name: '',                 //�����
            value: '',                //Ĭ���ı�ֵ
            emptytext: '',            //��ǰû������ʱ��ʾ��ֵ
            width: '',                //Ĭ�Ͽ��
            maxlength: -1,            //��󳤶�-1Ϊ�����Ƴ���
            readonly: false,          //�Ƿ�ֻ��
            icon: '',                 //ͼƬ·��������ʽ��
            iconwidth: '',            //ͼƬ����
            enterable: false,         //����س��Ƿ񴥷�ͼƬ����¼�
            editable: false,          //�Ƿ�ɱ༭
            textmode: false,          //�Ƿ�Ϊ�ı�ģʽ
            on_iconclick: null,       //ͼƬ����¼�
            on_change: null,          //ֵ�ı��¼�
            on_focus: null,           //��ý����¼�
            on_blur: null,            //��ʧ�����¼�
            on_keyup: null,           //keyup�¼�
            on_keydown: null          //keydown�¼�
        },

        //����Ԫ���ϵ����ֵ
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
            var opts = this.options, $input;
            var cIcon = C.icon;
            var icon = opts.icon;
            this.$inputWrap = $('#' + opts.id + '_wrap');
            this.$inputBox = $('#' + opts.id + '_box');
            $input = this.$input = $('#' + opts.id);
            this.$iconspan = $('#' + opts.id + '_icon');
            this.$iconWarp = $('#' + opts.id + '_warp');
            this.$empty = opts.el.find(".cui_clickinput_empty").eq(0).on("click", function () {
                $input.focus();
            });

            if (/\./.test(icon)) {
                this.$iconspan.css("backgroundImage", "url(" + icon + ")");
            } else {
                this.$iconspan.html(cIcon[icon] || "&#xf03a;");
            }
            this.setWidth(opts.width);

            //����ֻ��
            if (opts.readonly) {
                this.setReadOnly(true);
            }

            if (opts.value == "" && opts.emptytext != "") {
                this.$empty.html(opts.emptytext);
            }

            //�����Ƿ��д
            this.setEditAble(opts.editable);
        },

        /**
         * ���ÿ��
         * @param width ���
         */
        setWidth: function(width) {
            this.$inputWrap.css({
                width: C.Tools.fixedNumber(width)
            });
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

            //�Ƿ���ʾemptyText
            if ((value != "" && value != null) || ($.type(value) == "array" && value.length > 0)) {
                this.$empty.html("");
            } else if (opts.emptytext != "") {
                this.$empty.html(opts.emptytext);
            }

            //��������change�¼�
            if(isInit){
                this.onValid();
            }else{
                this._triggerHandler('change');
            }

//            $input.trigger('change');
        },

        /**
         * ��ȡֵ
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
         * ֻ��ģʽʱ��ɨ�������ã���ȡ���ֵ
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
         * ���ÿ���������ֽ���
         * @param maxlength
         */
        setMaxLength: function(maxlength) {
            this.options.maxlength = maxlength;
        },

        /**
         * ����ֻ������������
         * @param flag
         */
        setReadOnly: function(flag) {
            this.setReadonly(flag);
        },

        setReadonly: function(flag){
            var opts = this.options;
            var $inputWrap = this.$inputWrap;
            var $input = this.$input;

            opts.readonly = flag;
            if (flag) {
                $input.attr('readonly', true);
                $inputWrap.addClass('input_garybg');
                this._removeEmptyText(true);
            } else {
                if (opts.editable) {
                    $input.attr('readonly', false);
                }
                $inputWrap.removeClass('input_garybg');
                this._removeEmptyText(false);
            }

            this.$iconWarp.css({
                display: flag ? 'none' : 'inline-block'
            });
//            var width = "22px";
//            if (opts.iconwidth != "") {
//                width = (parseFloat(opts.iconwidth) + 5) + "px";
//            }
//            this.$inputBox.css({
//                marginRight: flag ? 0 : width
//            });
            flag && this.$inputBox.css("marginRight", 0)
        },

        /**
         * �����Ƿ�ɱ༭
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
         * ֵ�ı��¼�
         * @param e
         * @private
         */
        _changeHander: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //�Ƿ���ʾemptyText
            if (this.getValue() != "") {
                this.$empty.html("");
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
            //�������򲻿�������������ܻ�ȡ����
            if (opts.readonly) {
                return false;
            }
            //�Ƴ���ʾ
            this._removeEmptyText(true);
            //�����ʽ
            this.$inputBox.addClass('input_focus');

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
            var $inputBox = this.$inputBox;
            if (opts.readonly) return false;
            //�����ʾ
            this._removeEmptyText(false);
            //ɾ����ʽ
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
            //var $input = this.$input;
            if (opts.readonly) return false;
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
            if (opts.readonly) return false;
            if (opts.enterable && e.keyCode == 13) {
                this._iconclickHandler(e);
                return false;
            }
            //������������ֽ���
            //this._textCounter();
            //ִ���û��ص�
            this._customHandler('on_keydown', e);
        },

        /**
         * ͼƬ����¼�
         * @param e
         * @return {Boolean}
         * @private
         */
        _iconclickHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //ִ���û��ص�
            this._customHandler("on_iconclick", e);
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
            if ($.type(handler) == 'string') {
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
            var $input = this.$input;
            var emptyText = this.options.emptytext;
            var inputValue = this.getValue();
            if (emptyText == '' || inputValue.length != 0) return;
            if (isHide) {
                this.$empty.html("");
            } else {
                this.$empty.html(emptyText);
            }
        },

        /**
         * �������볤��
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
         * ��֤ʧ��ʱ���������
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
            self.$inputBox.removeClass("click_input_invalid");
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