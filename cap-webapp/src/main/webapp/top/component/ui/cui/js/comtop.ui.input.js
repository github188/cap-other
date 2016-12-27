?;(function($, C) {
    C.UI.Input = C.UI.Base.extend({
        options: {
            uitype: 'Input',        //组件类型
            width: '200px',              //默认宽度
            readonly: false,       //是否只读
            maxlength: -1,          //最大长度-1为不限制长度
            value: '',              //默认文本值
            emptytext: '',          //当前没有输入时显示的值
            name: '',               //组件名
            type: 'text',           //组件类型text/password
            mask: '',               //inputmask模板属性
            maskoptions: {},        //inputmask模板扩展
            textmode: false,        //是否为只读模式
            align: 'left',          //input框的文字对齐
            on_change: null,        //值改变事件
            on_focus: null,         //获得焦点事件
            on_blur: null,          //丢失焦点事件
            on_keyup: null,         //keyup事件
            on_keydown: null,        //keydown事件
            on_keypress: null       //keypress事件
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
            //value转义
            opts.value = opts.value.replace(/\"/g, '&quot;').replace(/\'/g, '&#39;');
        },

        /**
         * 初始化方法
         * @private
         */
        _create: function() {
            var self = this,
                opts = self.options, $input;
            $input = this.$input = $('#' + opts.id).css('textAlign', opts.align);
            this.$empty = opts.el.find(".cui_input_empty").eq(0).css("text-align", opts.align).on("mousedown", function () {
                $input.focus();
            });
            //执行模板代码
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
         * 设置宽度
         * @param width {String|Number}宽度
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
         * 设置值
         * @param value {String | Number} 值
         * @param isInit {Boolean} 是否是清空重置，清空重置不触发change
         */
        setValue: function(value, isInit) {
            var $input = this.$input,
                opts = this.options;
            value = (value == null || value == undefined) ? '' : value;
            $input.val(value);
            //限制最大输入字节数
            if(opts.maxlength > 0){
                this._textCounter();
            }

            //是否显示emptyText
            if (value !== "") {
                this.$empty.html("");
                //执行模板代码
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
         * 获取值
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
         * 设置占位符文字
         * @param txt {String} 文字
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
         * 设置可输入最大字节数
         * @param maxlength
         */
        setMaxLength: function (maxlength) {
            this.options.maxlength = maxlength;
        },

        /**
         * 设置只读
         * @param flag 是否只读
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
         * 输入框获焦
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
         * 值改变事件
         * @param e
         * @private
         */
        _changeHander: function(e) {
            var opts = this.options;
            var $input = this.$input;
            if (opts.readonly) {
                return false;
            }
            //是否显示emptyText
            if (this.getValue() !== "") {
                this.$empty.html("");
            } else if (opts.emptytext !== "") {
                this.$empty.html(opts.emptytext);
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
            //var $input = this.$input;

            if (opts.readonly) {
                //$input.blur();
                return false;
            }
            //移除提示
            this._removeEmptyText(true);

            //添加样式
            opts.el.addClass('cui_inputCMP_focus');

            //获焦时去掉错误认证信息
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
            //var $input = this.$input;

            if (opts.readonly) {
                return false;
            }
            //添加提示
            this._removeEmptyText(false);
            //删除样式
            opts.el.removeClass('cui_inputCMP_focus');
            this._textCounter();

            //失焦时，如果内容不为空时，触发change
            var value = this.getValue();
            if(value !== '' && value != null){
                this._triggerHandler('change');
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
            if (opts.readonly) {return false;}
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
            if (opts.readonly) {return false;}
            //限制最大输入字节数
            //this._textCounter();
            //执行用户回调
            this._customHandler('on_keydown', e);
        },

        /**
         * keypress事件
         * @param e
         * @private
         */
        _keypressHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //限制最大输入字节数
            //this._textCounter();
            //执行用户回调
            /*             if(opts.maxlength>-1){
             var len =C.String.getBytesLength(this.getValue());
             if(len  >= opts.maxlength && e.which > 14 && !e.ctrlKey ) {
             // e.preventDefault();
             }
             }*/
            this._customHandler('on_keypress', e);
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
            if ($.type(handler) === 'string') {
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
         * 限制输入长度
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
         * 验证失败时组件处理方法
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
            opts.el.removeClass("cui_inputCMP_error");
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