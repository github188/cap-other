;(function($, C) {
    C.UI.Textarea = C.UI.Base.extend({
        options: {
            uitype: 'Textarea',     //组件类型
            name: '',               //组件名
            relation: '',           //剩余可输入字符数显示的元素ID
            value: '',              //默认文本值
            width: '300',         //文本域组件宽度
            height: '57',        //文本域高度
            readonly: false,       //是否是只读
            maxlength: -1,          //最大能输入字符数，-1表示不限制
            byte: true,             //输入字符计算方式，true表示使用字节计算，false表示使用字符计算
            emptytext: '',          //为空时提示的内容
            autoheight: false,      //是否随着输入文本域自动增高
            maxheight: '',          //当文本域自动增高时限制最大增大高度
            textmode: false,        //是否为只读模式
            on_change: null,           //值改变事件
            on_focus: null,            //获得焦点事件
            on_blur: null,             //丢失焦点事件
            on_keyup: null,            //keyup事件
            on_keydown: null           //keydown事件
        },

        tipPosition: '.textarea_textarea',

        _init: function() {
            var opts = this.options;
            opts.width = C.Tools.fixedNumber(opts.width);
            opts.height = C.Tools.fixedNumber(opts.height);
            opts.id = C.guid();
            if (opts.name === '') {
                opts.name = C.guid() + "_" + opts.uitype;
            }
            opts.maxheight = /^(\d)+(px|PX)*$/.test(opts.maxheight) ? opts.maxheight.replace('px','') : '';

        },

        _create: function() {
            var self = this, $textarea,
                opts = self.options;
            $textarea = this.$textarea = $('#' + opts.id);
            this.$box = opts.el.find(".cui_textarea_box");
            this.$empty = opts.el.find(".cui_textarea_empty").eq(0).on("mousedown", function () {
                $textarea.focus();
            });
            //处理剩余可输入字符
            if (opts.relation !== '' && opts.maxlength !== -1) {
                this.$relation = $("#" + opts.relation);
                var reLength = opts.maxlength - self._getStringLength(opts.value) < 0 ?
                    0 : opts.maxlength - self._getStringLength(opts.value);
                this.$relation.text(reLength);
            }
            if(opts.maxlength !== -1){
                this._textCounter();
                opts.byte || $textarea.attr('maxlength', opts.maxlength);
            }

            if (opts.emptytext !== "" && opts.value === "") {
                this.$empty.html(opts.emptytext);
            }

            if (opts.height === '') {
                opts.height = "51";
            }
            this.setHeight(opts.height);

            if (opts.width === '') {
                opts.width = "300";
            }
            this.setWidth(opts.width);

            //设置只读
            if (opts.readonly) {
                this.setReadOnly(true);
            }


            if(opts.maxlength > -1){
                this.$textarea.on("input propertychange", function(e){
                    opts.byte && self._textCounter();
                });
            }
            this.$textarea.on("keypress",function(e){
                self._keyPressHandler(e);
            });


            if (opts.autoheight) {
                this.$textarea.css({
                    overflow: 'hidden'
                });
                if(C.Browser.isIE9){
                    this.$textarea.on('input change', function() {
                        self._autoHeight();
                    });
                    this.$textarea.on('keydown', function(event) {
                        if(event.keyCode === 46 || event.keyCode === 8){
                            self._autoHeight();
                        }
                    });
                } else{
                    var self = this;
                    self.$textarea.bind('input', function() {
                        self._autoHeight();
                    });

                    self.$textarea.bind('propertychange', function() {

                        if (window.event.propertyName === "value") {
                            self._autoHeight();
                        }
                    });

                }

                //如果存在值，则执行高度计算
                if(opts.value){
                    self._autoHeight();
                }
            }
        },

        /**
         * 设置宽度
         * @param width 宽度
         */
        setWidth: function(width) {
            width = width + "";
            if (C.Browser.isQM || width.indexOf("%") != -1) {
                this.$box.css({
                    width: width
                });
            } else {
                this.$box.css({
                    width: parseFloat(width) + "px"
                });
            }
        },

        /**
         * 设置高度
         * @param height
         */
        setHeight: function(height){
            height = height + "";
            if (C.Browser.isQM || height.indexOf("%") != -1) {
                this.$textarea.css({
                    height: height
                });
            } else {
                this.$textarea.css({
                    height: parseFloat(height) - 10 + "px"
                });
            }
        },

        /**
         * 设置值
         * @param value {String | Number} 值
         * @param isInit {Boolean} 是否是清空重置，清空重置不触发change
         */
        setValue: function(value, isInit) {
            var $textarea = this.$textarea,
                opts = this.options;
            value = (value == null || value == undefined) ? '' : value;
            $textarea.val(value);

            //是否显示emptyText
            if (value !== "") {
                this.$empty.html("");
            } else if (opts.emptytext !== "") {
                this.$empty.html(opts.emptytext);
            }
            //可输入字符提示
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
            if(opts.maxlength !== -1){
                this._textCounter();
            }

            //触发对象change事件
            if(isInit){
                this.onValid();
            }else{
                this._triggerHandler('change');
            }
            //在执行setValue接口时，自动修改高度
            var self = this;
            if(opts.autoheight){
                self._autoHeight();
            }
        },

        /**
         * 获取值
         */
        getValue: function() {
            var value = this.$textarea.val();
            var emptyText = this.options.emptytext;
            if ($.trim(value) === emptyText) {
                return '';
            } else {
                return value;
            }
        },

        /**
         * 设置可输入最大字节数
         * @param maxlength
         */
        setMaxLength: function(maxlength) {
            var opts = this.options;
            opts.maxlength = maxlength;
            opts.byte || this.$textarea.attr('maxlength', maxlength);
            this._textCounter();
            //可输入字符提示
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
        },

        /**
         * 获取上可以输入的字符数
         * @return
         */
        _getRemainLength: function() {
            var reLength = this.options.maxlength - this._getStringLength(this.getValue());
            return reLength < 0 ? 0 : reLength;
        },

        /**
         * 设置只读，保留兼容
         * @param flag 是否只读
         */
        setReadOnly: function(flag) {
            this.setReadonly(flag);
        },
        setReadonly: function(flag){
            var opts = this.options;
            opts.readonly = flag;
            this.$textarea.attr('readonly', flag);
            if (flag) {
                opts.el.addClass('textarea_garybg');
                //this._removeEmptyText(true);
            } else {
                opts.el.removeClass('textarea_garybg');
                //this._removeEmptyText(false);
            }
        },

        /**
         * 输入框获焦
         * @return {*}
         */
        focus: function(){
            var opts = this.options;
            if(!opts.readonly){
                opts.el.find('textarea').focus();
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
            if (opts.readonly) return false;
            //是否显示emptyText
            if (this.getValue() !== "") {
                this.$textarea.removeClass('textarea_tipcolor');
            } else if (opts.emptytext !== "") {
                this.$empty.html(opts.emptytext);
            }
            //可输入字符提示
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
            //触发对象change事件
            this._triggerHandler('change');
            //执行用户回调
            this._customHandler('on_change', e);
        },

        /**
         * 获得焦点事件
         * @param e
         * @private
         */
        _focusHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) {
                //this.$textarea.blur();
                return false;
            }
            //移除提示
            this._removeEmptyText(true);
            //添加样式
            this.$box.addClass('textarea_textareafocus');
            //去掉错误提示
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
            if (opts.readonly) return false;
            //添加提示
            this._removeEmptyText(false);
            //删除样式
            this.$box.removeClass('textarea_textareafocus');
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
         * keypress事件
         * @param e
         * @private
         */
        _keyPressHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            this._customHandler('on_keypress', e);
        },

        /**
         * keyup事件
         * @param e
         * @private
         */
        _keyupHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //限制最大输入字节数
            opts.byte && this._textCounter();
            //可输入字符提示
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
            //执行用户回调
            this._customHandler('on_keyup', e);
        },

        _keydownHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //限制最大输入字节数
            opts.byte && this._textCounter();
            //执行用户回调
            this._customHandler('on_keydown', e);
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
            var areaValue = this.getValue();
            if (emptyText === '' || areaValue.length !== 0) {
                return;
            }
            if (isHide) {
                this.$empty.html("");
            } else {
                this.$empty.html(this.options.emptytext);
            }
        },

        /**
         * 限制输入长度
         * @return {Boolean}
         * @private
         */
        _textCounter: function() {
            var opts = this.options;
            if (opts.maxlength > -1) {
                var currentLen = this._getStringLength(this.getValue());
                if (currentLen > opts.maxlength) {
                    this.setValue(this._interceptString(this.getValue(), opts.maxlength));
                    if (this.autoheight) {
                        this._autoHeight();
                    }
                }
            }
            return false;
        },
        /**
         * 计算字符串长度
         * @param value
         * @returns {Number|*}
         * @private
         */
        _getStringLength: function(value){
            var opts = this.options;
            return opts.byte ? C.String.getBytesLength(value) : value.length;
        },
        /**
         * 截取字符串
         * @param value
         * @param length
         * @returns {*}
         * @private
         */
        _interceptString: function(value, length){
            var opts = this.options;
            return opts.byte ? C.String.intercept(value, length) : C.String.interceptString(value, length);
        },

        /**
         * 自动高度
         * @private
         */
        _autoHeight: function() {
             var  self = this,
                  $textarea = self.$textarea;
            if(C.Browser.notIE){
                if (!$textarea.data('origin-height')) {
                    $textarea.data('origin-height', $textarea.outerHeight());
                }
                $textarea.height($textarea.data('origin-height'));
            }
            var opts = self.options,
                overflow ='hidden',
                scrollHeight = $textarea.get(0).scrollHeight;

            if(C.Browser.isIE){ //  IE 前后取得的scrollHeight不一致。
                $textarea.get(0).scrollHeight!==scrollHeight?(scrollHeight=$textarea.get(0).scrollHeight):"";
            }
            scrollHeight= scrollHeight<opts.height?opts.height:scrollHeight;
            if(opts.maxheight){
                if(scrollHeight>opts.maxheight){
                    scrollHeight = opts.maxheight;
                    overflow ='auto';
                }
            }

            $textarea.css({"height":scrollHeight,"overflow":overflow});


            //是否有最大高度限制
    /*        if(opts.maxheight){
                //判断高度是否已经达到最大高度
                if(opts.maxheight - 10 >= $textarea[0].scrollHeight){
                    this.$textarea.css({
                        overflow: 'hidden'
                    });
                    __resetHeight();
                }else{
                    this.$textarea.css({
                        overflow: 'auto'
                    });
                    $textarea.height(opts.maxheight - 10);
                }
            }else{
                __resetHeight();
            }

            function __resetHeight(){

                scrollHeight = $textarea[0].scrollHeight;
                if(opts.height - 10 <= scrollHeight){
                    if($textarea.height() !== scrollHeight){
                        $textarea.height(scrollHeight);
                    }
                }
            }*/
        },

        /**
         * 验证失败时组件处理方法
         * @param obj
         * @param message
         */
        onInValid: function(obj, message) {
            var self = this,
                opts = self.options;
            self.$box.addClass("textarea_invalid");
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
            self.$box.removeClass("textarea_invalid");
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