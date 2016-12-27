?;(function($, C) {
    C.UI.ClickInput = C.UI.Base.extend({
        options: {
            uitype: 'ClickInput',     //组件类型
            name: '',                 //组件名
            value: '',                //默认文本值
            emptytext: '',            //当前没有输入时显示的值
            width: '',                //默认宽度
            maxlength: -1,            //最大长度-1为不限制长度
            readonly: false,          //是否只读
            icon: '',                 //图片路径或者样式名
            iconwidth: '',            //图片长度
            enterable: false,         //点击回车是否触发图片点击事件
            editable: false,          //是否可编辑
            textmode: false,          //是否为文本模式
            on_iconclick: null,       //图片点击事件
            on_change: null,          //值改变事件
            on_focus: null,           //获得焦点事件
            on_blur: null,            //丢失焦点事件
            on_keyup: null,           //keyup事件
            on_keydown: null          //keydown事件
        },

        //绑定在元素上的相关值
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

            //设置只读
            if (opts.readonly) {
                this.setReadOnly(true);
            }

            if (opts.value == "" && opts.emptytext != "") {
                this.$empty.html(opts.emptytext);
            }

            //设置是否可写
            this.setEditAble(opts.editable);
        },

        /**
         * 设置宽度
         * @param width 宽度
         */
        setWidth: function(width) {
            this.$inputWrap.css({
                width: C.Tools.fixedNumber(width)
            });
        },

        /**
         * 设置值
         * @param value {String | Number} 值
         * @param isInit {Boolean} 是否是清空重置，清空重置不触发change
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

            //是否显示emptyText
            if ((value != "" && value != null) || ($.type(value) == "array" && value.length > 0)) {
                this.$empty.html("");
            } else if (opts.emptytext != "") {
                this.$empty.html(opts.emptytext);
            }

            //触发对象change事件
            if(isInit){
                this.onValid();
            }else{
                this._triggerHandler('change');
            }

//            $input.trigger('change');
        },

        /**
         * 获取值
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
         * 只读模式时供扫描器调用，获取组件值
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
         * 设置可输入最大字节数
         * @param maxlength
         */
        setMaxLength: function(maxlength) {
            this.options.maxlength = maxlength;
        },

        /**
         * 设置只读，保留兼容
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
         * 设置是否可编辑
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
         * 值改变事件
         * @param e
         * @private
         */
        _changeHander: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //是否显示emptyText
            if (this.getValue() != "") {
                this.$empty.html("");
            } 
            //触发对象change事件
            this._triggerHandler('change');
            //执行用户事件回调
            this._customHandler('on_change', e);
        },

        /**
         * 获得焦点事件
         * @param e
         * @private
         */
        _focusHandler: function(e) {
            var opts = this.options;
            //如果输入框不可输入让输入框不能获取焦点
            if (opts.readonly) {
                return false;
            }
            //移除提示
            this._removeEmptyText(true);
            //添加样式
            this.$inputBox.addClass('input_focus');

            this.onValid();
            //执行用户回调
            this._customHandler('on_focus', e);
        },

        /**
         * 失去焦点事件
         * @param e
         * @private
         */
        _blurHandler: function(e) {
            var opts = this.options;
            var $inputBox = this.$inputBox;
            if (opts.readonly) return false;
            //添加提示
            this._removeEmptyText(false);
            //删除样式
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

            //执行用户回调
            this._customHandler('on_blur', e);
        },

        /**
         * keyup事件
         * @param e
         * @private
         */
        _keyupHandler: function(e) {
            var opts = this.options;
            //var $input = this.$input;
            if (opts.readonly) return false;
            //限制最大输入字节数
            this._textCounter();
            //执行用户回调
            this._customHandler('on_keyup', e);
        },

        /**
         * keydown事件
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
            //限制最大输入字节数
            //this._textCounter();
            //执行用户回调
            this._customHandler('on_keydown', e);
        },

        /**
         * 图片点击事件
         * @param e
         * @return {Boolean}
         * @private
         */
        _iconclickHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //执行用户回调
            this._customHandler("on_iconclick", e);
        },

        /**
         * 用户事件
         * @param type 事件类型
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
         * 显示或者隐藏emptyText
         * @param isHide true/false是否显示
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
         * 限制输入长度
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
         * 验证失败时组件处理方法
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
            //设置tip类型，错误
            $(self.tipPosition, opts.el).attr('tipType', 'error');
        },

        /**
         * 验证成功时组件处理方法
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
                //隐藏提示
                var $cuiTip = cui.tipList[tipID];
                typeof $cuiTip !== 'undefined' && $cuiTip.hide();
            }
            opts.el.attr("tip", opts.tipTxt);
            //设置tip类型，正常
            $(self.tipPosition, opts.el).attr('tipType', 'normal');
        }
    });
})(window.comtop.cQuery, window.comtop);