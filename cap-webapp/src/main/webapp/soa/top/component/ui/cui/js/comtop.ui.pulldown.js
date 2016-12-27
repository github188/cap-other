/**
 * 模块: CUI组件 PullDown类
 * 创建: 王伟3
 * 日期: 13-10-9
 * 描述: PullDown组件基础方法，被SinglePullDown和MultiPullDown组件继承。
 * 扩展模块必需方法：
 * __initMode：数据准备就绪，渲染下拉板块
 * __renderTextMode：数据准备就绪，渲染文字模式
 * __mouseUpHandler：鼠标点击回弹事件。
 * __getText：获取输入框文字
 */
;(function(C){
"use strict";
var $ = C.cQuery,
    Browser = C.Browser,
    isQM = Browser.isQM;
C.UI.PullDown = C.UI.Base.extend(function () {
    return {
        options : {
            uitype : "PullDown",
            empty_text: "请选择",
            value: '',
            readonly: false,
            textmode: false,
            width: "200",
            height: "200",
            editable: true,
            on_select_data: null,
            //下拉渲染模式，暂时可以为"Single"和"Multi"。
            mode : "Single",
            datasource: null,
            //下面为继承部分参数内容。
            name : "",
            select: -1,
            must_exist: true,
            auto_complete: false,
            value_field : "id",
            label_field : "text",
            filter_fields : [],
            on_filter_data: null,
            on_change: null,
            on_filter: null
        },
        /**
         * 初始化参数，Base中自动调用
         * @param {object} op 用户参数，未格式化
         * @param {object} customOpt 用户参数，已经未格式化
         * @private
         */
        _init: function (op, customOpt) {
            var opts = this.options;
            //如果是以PullDown创建，继承下拉板块对象
            if (opts.uitype.toLocaleLowerCase() === "pulldown") {
                this._extendMode(customOpt);
            }
            //初始化宽高属性
            this._initWidthAndHeight(
                (op.width || opts.width).toString(),
                (op.height || opts.height).toString()
            );
            this.$el = opts.el.addClass("pulldown-main").css("width", opts.width);
            this.ltIE8 = Browser.isIE6 || Browser.isIE7;
            if (Browser.isQM && this.ltIE8) {
                this.$el.addClass("pulldown-main-qm");
            }
            //把占位符中的内容转移到一个内存中的元素里面。
            this.templateBox = $(document.createElement("div")).html(this.$el.html());
            this.guid = C.guid();
            this.text = "";
            this.value = "";
            this.valueCache = "";
            this.isHide = true;//当前下拉框是否为隐藏状态。

            this.top = window.location === window.parent.location;
            this.eqEmptyText = false; //下拉列表是否有与默认文字相等的选项
            this.rendered = false; //是否已经渲染完成
            this.oldData = null;
            this.position = {};
        },
        /**
         * 在原型中通过属性拷贝继承下拉模块对象
         * 以uitype="PullDown"创建时调用。
         * @param {object} customOpt Base修正后的用户设置的参数
         * @private
         */
        _extendMode: function (customOpt) {
            var constr, proto, v,
                mode = this.options.mode;
            mode = mode.charAt(0).toUpperCase() + mode.slice(1).toLocaleLowerCase() + "PullDown";
            constr = C.UI[mode];
            if (constr) {
                proto = constr.prototype;
                //惰性拷贝
                for (v in proto) {
                    if (proto.hasOwnProperty(v) && !this[v]) {
                        this[v] = proto[v];
                    }
                }
                //合并参数options
                //proto.options，为默认参数。
                this.options = $.extend({}, proto.options, customOpt);
            } else {
                throw new Error("mode属性错误。");
            }
        },
        /**
         * 修正用户传入的宽高，自动加"px"。
         * @param {string} width 宽度
         * @param {string} height 高度
         * @private
         */
        _initWidthAndHeight: function (width, height) {
            var opts = this.options;
            if (typeof width === "string" && !/%/.test(width)) {
                opts.width = width.replace(/\D+/g, "") + "px";
            }
            if (height) {
                this.height = parseInt(height, 10) - 2;
                opts.height = this.height + "px";
            }
        },
        /**
         * 文字模式函数，文字模式下不再调用_create()。
         * 在Base中调用
         */
        setTextMode: function(){
            this._initData();
        },
        /**
         * 创建Dom等，在Base中调用
         * @private
         */
        _create: function () {
            //tip参数设置
            this.tipPosition = '.pulldown-inner';
            this.tipText = this.$el.attr("tip");
            //创建DOM和绑定事件
            this._createDom();
            this._bindFocusBlurEvent();
            this._bindMouseEvent();
            this._bindKeyEvent();
            this._resetLayoutEvent();
            //初始化Json数据并渲染下拉板块
            this._initData();
            //设置renadOnly
            this.setReadonly(this.options.readonly);
        },
        /**
         * 创建除下拉板块内容的所有dom元素
         * 并把DOM存入Root属性中
         * @private
         */
        _createDom: function () {
            var opts = this.options,
                $el = this.$el,
                inputHtml,
                pullBox, iframe = "";
            //元素结构
            inputHtml = [
                '<div class="pulldown-inner pulldown-readonly">',
                    '<input class="pulldown-text" readonly="readonly" type="text" autocomplete="off" value="',
                        opts.empty_text, '" />',
                    '<a href="javascript:;" hidefocus="true" class="pulldown-btn pulldown-loading cui-icon">&#xf107;</a>',
                '</div>',
                '<input type="hidden" class="pulldown-hidden" name="', opts.name, '" />'
            ];
            $el.html(inputHtml.join(""));
            //创建下拉部分外层Box
            pullBox = $(document.createElement("div")).addClass("pulldown-box");
            if (Browser.isIE6) {
                //解决IE6下，弹出内容无法覆盖select标签flash内容。
                iframe = '<iframe scrolling="no" frameborder="no"></iframe>';
            }
            pullBox.html(iframe + '<div class="pulldown-box-inner"></div>');
            $("body").append(pullBox);
            //Dom存入内存，防止多次遍历
            this.$inner = $el.find(".pulldown-inner").eq(0);
            this.$text = $el.find(".pulldown-text").eq(0);
            if (Browser.isQM) {
                this.$text.addClass("pulldown-text-qm");
            }
            this.$btn = $el.find(".pulldown-btn").eq(0);
            this.$hide = $el.find(".pulldown-hidden").eq(0);
            this.$box = pullBox;
            this.$boxInner = pullBox.find(".pulldown-box-inner").eq(0);
        },
        /**
         * 输入框焦点事件
         * 获取焦点显示下拉框，失去焦点隐藏下拉框
         * @private
         */
        _bindFocusBlurEvent: function () {
            var self = this;
            this.$text.on("focus", function () {
                if (self.options.readonly){
                    return;
                }
                if (self.inValid) {
                    self.onValid();
                }
                self._showBox();
            }).on("blur", function () {
                self._hideBox();
            });
        },
        /**
         * 显示下拉框，一般在输入框获取焦点时调用
         * @private
         */
        _showBox: function () {
            var rect = this.$el[0].getBoundingClientRect();
            this.position.top = rect.top;
            this.position.left = rect.left;
            if (this.isHide === false) {
                return;
            }
            this.isHide = false;
            //设置下拉框的位置和宽高
            this._setBoxLayout(this._setBoxPosition(rect));
            this.listenPosition();
            this._isEmpty();
            this.$inner.addClass("pulldown-inner-focus");
            if (!this.rendered) {
                //异步调用
                this._callDataSource();
            } else {
                //缓存展开之前的值，以备触发onchange。
                //记录老的状态
                this.setOldData();
                //获取焦点的蓝色边框
                if (this.__showBoxCallBack) {
                    this.__showBoxCallBack();
                }
            }
        },
        /**
         * 移除
         */
        destroy: function () {
            this.$box.remove();
            this.$el.remove();
        },
        /**
         * 监听输入框位置
         */
        listenPosition: function () {
            var self = this,
            el = self.$el[0];
            clearInterval(this.listenBoxPostion);
            this.listenBoxPostion = setInterval(function () {
                var newPosition = el.getBoundingClientRect(),
                    position = self.position;
                if (newPosition.left !== position.left || newPosition.top !== position.top) {
                    self.$text.blur();
                }
            }, 10);
        },
        /**
         * 异步调用数据
         * @private
         */
        _callDataSource: function () {
            if (this.dataCalling) {
                return;
            }
            this.$btn.addClass("pulldown-loading");
            this.options.datasource.call(this, this);
            this.dataCalling = true;
        },
        /**
         * 是否是空值,处理输入框空值状态下的显示文字
         * @private
         */
        _isEmpty: function () {
            var $text = this.$text,
                val, isHide, emptyText;
            if (this.rendered && (this.eqEmptyText || this._isEqEmptyText())) {
                //如果下拉框的文字与下拉选项文字有相同直接返回
                $text.addClass("pulldown-text-value");
                return ;
            }
            val = $text.val();
            isHide = this.isHide;
            emptyText = this.options.empty_text;
            switch (val) {
                case "":
                    if (isHide) {//隐藏下拉窗口
                        $text.val(emptyText).removeClass("pulldown-text-value");
                    }
                    break;
                case emptyText:
                    if (!isHide) {//打开下拉窗口
                        $text.val("").addClass("pulldown-text-value");
                    }
                    break;
                default:
                    $text.addClass("pulldown-text-value");
            }
        },
        /**
         * 判断下拉项中是否有文字与empty_text相同
         * @returns {boolean}
         * @private
         */
        _isEqEmptyText: function () {
            var data = this.data,
                len = data.length,
                opts = this.options,
                emptyText = opts.empty_text,
                labelField = opts.label_field,
                i = 0;
            //匹配
            for (; i < len; i++) {
                if (emptyText === data[i][labelField]) {
                    this.eqEmptyText = true;
                    return true;
                }
            }
            return false;
        },
        /**
         * 计算下拉框显示位置left和top值
         * @returns {number} 计算出来的高度
         * @private
         */
        _setBoxPosition: function (rect) {
            var mainHeight = 28, borderWidth = (isQM ? 0 : 2), marginBottom = 10,
                //获取元素到窗口左上角的坐标。
                left = rect.left + $(window).scrollLeft(),
                //计算下拉框应有的高度，最小23。
                height = this._getRealHeight(),
                totalHeight = height + mainHeight + borderWidth,
                //top值：在元素的下面展开
                top = rect.top + $(window).scrollTop() + mainHeight;

            //如果下面显示的孔家不够，在元素的上面展开
            if (top > Math.max($.page.height(), $.client.height()) - height - marginBottom &&
                top > height + mainHeight) {
                top -= totalHeight;
            }
            //IE6-IE7的 getBoundingClientRect有2px的差异
            this.$box.css(this.ltIE8 && this.top ? {
                left: left - 2,
                top: top - 2
            } : {
                left: left,
                top: top
            });
            return height;
        },
        /**
         * 计算下拉框应该要显示的高度
         * @returns {number} 下拉高度
         * @private
         */
        _getRealHeight: function () {
            //内容超出按照设置高度显示，不够按照内容自适应，没有内容默认显示23px。
            return Math.min(this.height, this.$boxInner.css("height", "auto").outerHeight() || 28); //23为行高。
        },
        /**
         * 设置下拉框宽度和高度
         * @param {Number} height 传入的高度。
         * @private
         */
        _setBoxLayout: function (height) {
            this.$box.css({
                height: height,
                width: this.$el.width() - (isQM ? 0 : 2) // 2：左右边框宽度
            });
        },
        /**
         * 隐藏下拉框
         * @private
         */
        _hideBox: function () {
            if (this.isHide === true) {
                return;
            }
            if (this.hideAble === false) {
                this.$text.focus();
                return;
            }
            this.isHide = true;
            this.$box.css("top", "-999999px");
            clearInterval(this.listenBoxPostion);
            this.$inner.removeClass("pulldown-inner-focus");
            if (this.rendered) {
                if (this.__hideBoxCallBack) {
                    this.__hideBoxCallBack();
                }
                //触发onchange
                this._triggerChange(false, false);
            } else {
                this._isEmpty();
            }
        },
        /**
         * 设置上一次选择值
         */
        setOldData: function () {
            var selectData = this.selectData,
                type = $.type(selectData);
            this.valueCache = this.value;
            if (type  === "array") {
                this.oldData = $.extend(true, [], selectData);
            } else if (type  === "object") {
                this.oldData = $.extend(true, {}, selectData);
            } else {
                this.oldData = null;
            }
        },
        /**
         * 手动触发onChange事件
         * 并调用base中的验证函数
         * @param {boolean} isInit
         * @param {boolean} isDatabind
         * @private
         */
        _triggerChange: function (isDatabind, isInit) {
            var on_select_data, on_change, opts;
            if (this.valueCache !== this.value && !isDatabind) {
                //打开下拉框和关闭下拉框值有改变, 老方法，弃用
                opts = this.options;
                on_select_data = opts.on_select_data;
                //不是初始化时
                if (!isInit) {
                    //Base类中验证用函数
                    this._triggerHandler('change');
                    on_change = opts.on_change;
                    if (typeof on_change === "function") {
                        on_change.call(this, this.selectData, this.oldData);
                    }
                }
                if (typeof on_select_data === "function") {
                    on_select_data.call(this, this.selectData);
                }
            }
        },
        /**
         * 绑定下拉按钮和下拉框的鼠标事件
         * @private
         */
        _bindMouseEvent: function () {
            var self = this,
                $text = this.$text,
                relatedTarget,
                disableHideHandler = function () {
                    //按下以后 $text元素触发blur，
                    //设置hideAble = false防止隐藏下拉框。
                    self.hideAble = false;
                };
            //下拉按钮鼠标事件
            this.$btn.on("mouseup", function (event) {
                self.hideAble = true;
                event.stopPropagation();
                if(!self.readonly) {
                    if (self.isHide) {
                        $text.focus();
                    } else {
                        $text.blur();
                    }
                }
            }).on("mousedown", disableHideHandler);
            //下拉框鼠标事件
            this.$box.on("mouseout", function (event) {
                //进入到某个元素
                relatedTarget = event.relatedTarget;
                if (self.hideAble === false && !$(this).find(relatedTarget).length &&
                    this !== relatedTarget) {
                    self.hideAble = true;
                    $text.blur();
                }
            }).on("mouseup", function (event) {
                event.stopPropagation();
                self.hideAble = true;
                self.__mouseUpHandler(event);
            }).on("mousedown", disableHideHandler);
        },
        /**
         * 输入框的按键事件
         * @private
         */
        _bindKeyEvent: function() {
            var self = this,
                keyCode,
                opts = this.options;
            this.$text.on("keydown", function (event) {
                keyCode = event.keyCode;
                switch(keyCode) {
                    case 8:
                        if (!opts.editable) { //禁止IE回退
                            event.preventDefault();
                        }
                        break;
                    case 38 : //up
                        if (self.__keyDownUPHandler) {
                            self.__keyDownUPHandler();
                        }
                        break;
                    case 40 : //down
                        if (self.__keyDownDownHandler) {
                            self.__keyDownDownHandler();
                        }
                        break;
                    case 37 : //left
                        if (self.__keyDownLeftHandler) {
                            self.__keyDownLeftHandler();
                        }
                        break;
                    case 39 : //right
                        if (self.__keyDownRightHandler) {
                            self.__keyDownRightHandler();
                        }
                        break;
                    case 13 : //enter
                        if (self.__keyDownEnterHandler) {
                            self.__keyDownEnterHandler();
                        }
                        break;
                    default :
                        if (self.__keyDownHandler) {
                            self.__keyDownHandler();
                        }
                }
            }).on("keyup", function (event) {
                if (opts.editable && self.__keyUpHandler) {
                    self.__keyUpHandler(event);
                }
            });
        },
        /**
         * 布局改变事件调用
         * @private
         */
        _resetLayoutEvent: function () {
            var self = this,
                el = this.$el[0];
            $(window).on("resize scroll", function () {
                var newPosition, position;
                if (!self.isHide) {
                    newPosition = el.getBoundingClientRect();
                    position = self.position;
                    if (newPosition.left !== position.left || newPosition.top !== position.top) {
                        self.$text.blur();
                    }
                }
            });
        },
        /**
         * 初始化数据
         * @private
         */
        _initData: function () {
            var opts = this.options,
                datasource, type,
                list = this.templateBox.find("a[value]"),
                len = list.length,
                i, item, valueField, labelField;
            //通过模版创建
            if (len) {
                valueField = opts.value_field;
                labelField = opts.label_field;
                datasource = [];
                //读取模板，转换成数据
                for (i = 0; i < len; i++) {
                    item = datasource[i] = {};
                    item[valueField] = list.eq(i).attr("value");
                    item[labelField] = $.trim(list.eq(i).html());
                }
            }
            datasource = datasource || opts.datasource;
            type = $.type(datasource);
            if (type === "function") {
                //异步调用常用，如果没有设置值，先不调用，点击时再调用。
                if(opts.value !== '' || opts.select !== -1) {
                    this._callDataSource();
                } else {
                    //隐藏loading
                    this.$btn.removeClass("pulldown-loading");
                }
            } else if(type === "array"){
                this.setDatasource(datasource);
            } else {
                this.setDatasource([]);
            }
        },
        /**
         * 初始化设置数据和重置数据。 rendered判断是否是重置数据
         * @param {Array} data
         * @returns {object} new C.UI.PullDown()
         */
        setDatasource: function (data) {
            var opts = this.options,
                rendered, select, value;
            //调用文字模式
            this.data = $.extend(true, [], data);
            if (opts.textmode) {
                //文字模式,渲染模块的文字模式
                this.__renderTextMode();
                this.$el.addClass("pulldown-textmode")
            } else {
                //隐藏loading
                this.$btn.removeClass("pulldown-loading");
                //渲染下拉模块
                rendered = this.rendered;
                this.__initMode(rendered);
                if (rendered) { //重载数据
                    this._emptyStat();
                } else {
                    this.rendered = true;
                    //设置初始值或初始选择第几条
                    value = opts.value;
                    select = opts.select;
                    if (value) {
                        this.setValue(value, false, true);
                    } else if (select > -1 && select < data.length ) { //默认选择第几条
                        this.setValue(data[select][opts.value_field], false, true);
                    }
                    // 如果可以编辑
                    if (opts.editable) {
                        this.$text.removeAttr("readonly");
                    }
                }
                //适用于数据没来，而打开下拉的情况，需要根据数据重新计算高度。
                if (!this.isHide) {
                    this._setBoxLayout(this._setBoxPosition(this.$el[0].getBoundingClientRect()));
                }
            }
            return this;
        },
        /**
         * 同上，修正名字
         * @param {Array} data
         * @returns {object} new C.UI.PullDown()
         */
        setDataSource : function (data) {
            return this.setDatasource(data);
        },
        /**
         * 重载数据时，清空状态。
         * @private
         */
        _emptyStat: function () {
            this.text = "";
            this.value = "";
            this.valueCache = "";
            this.selectData = null;
            this.$text.val("");
            this.$hide.val("");
            this.eqEmptyText = false;
            this._isEmpty();
        },
        /**
         * 设置数据
         * @param {object} data
         * @returns {object} new C.UI.PullDown()
         */
        resetDataSource: function (data) {
            this.setDatasource(data);
            return this;
        },
        /**
         * 设置输入框文字、隐藏域的值和当前选中的对象
         * 主要用于下拉模块数据交互时调用
         * 参数{text: string, value: string, Data: object}
         * @param prop
         * @private
         */
        _setProp: function (prop) {
            var text = prop.text,
                value = prop.value || text,
                data = prop.data;
            this.text = text;
            this.value = value;

            this.selectData = data;
            this.$text.val(text);
            this.$hide.val(value);
            this._isEmpty();
        },
        /**
         * 打开下拉列表
         * @returns {object} new C.UI.PullDown()
         */
        open: function () {
            this.$text.focus();
            return this;
        },
        /**
         * 设置宽度
         * @param {string} width
         * @returns {object} new C.UI.PullDown()
         */
        setWidth: function (width) {
            var opts = this.options;
            if (typeof width === "string" && /%/.test(width)) {
                opts.width = width;
            } else {
                this._initWidthAndHeight(width + "");
            }
            this.$text.blur();
            this.$el.css("width", opts.width);
            return this;
        },
        /**
         * 设置值
         * @param {string} value
         * @returns {object} new C.UI.PullDown()
         * @param isDatabind
         * @param isInit
         */
        setValue: function (value, isDatabind, isInit) {
            if (!this.rendered) {
                this.options.value = value;
                this.$hide.val(value);
                this._callDataSource();
            } else {
                this.setOldData();
                this.__setValue(
                    typeof value === "undefined" ? this.options.value : value
                );
                this._triggerChange(isDatabind, isInit);
            }
            return this;
        },
        /**
         * 获取值
         * @returns {string}
         */
        getValue: function () {
            return this.rendered ? this.value : this.options.value;
        },
        /**
         * 当前选择的内容的数据,需要拷贝。
         * @returns {null|Array|object}
         */
        getData: function () {
            var selectData = this.selectData,
                type = $.type(selectData);
            switch (type) {
                case "array": //多选
                    return $.extend(true, [], this.selectData);
                case "object": //单选
                    return $.extend(true, {}, this.selectData);
                default :
                    return null;
            }
        },
        /**
         * 获取显示值
         * @returns 根据模块定
         */
        getText: function () {
            return this.__getText();
        },
        /**
         * 设置只读
         * @param flag
         * @returns {object} new C.UI.PullDown()
         */
        setReadonly: function (flag) {
            if (flag === true) {
                this.readonly = true;
                this.$inner.addClass("pulldown-readonly");
                this.$text.attr("readonly", "readonly");
                this.$text.blur();
            } else if (flag === false) {
                this.readonly = false;
                this.$inner.removeClass("pulldown-readonly");
                this.$text.removeAttr("readonly");
            }
            this.options.readonly = flag;
            return this;
        },
        /**
         * 设置可否被编辑
         * @param {boolean} flag
         */
        setEditAble: function (flag) {
            flag = !!flag;
            this.options.editable = flag;
            if (flag) {
                this.$text.removeAttr("readonly");
            } else {
                this.$text.attr("readonly", "readonly");
            }
        },
        /**
         * 验证失败时组件处理方法
         * @param {object} obj
         * @param {string} message
         */
        onInValid: function(obj, message) {
            this.$inner.addClass("pulldown-error");
            this.$el.attr("tip", message);
            //设置tip类型，错误
            $(this.tipPosition, this.options.el).attr('tipType', 'error');
            this.inValid = true;
        },

        /**
         * 验证成功时组件处理方法
         */
        onValid: function() {
            var $el = this.$el,
                tipID = $el.find(this.tipPosition).eq(0).attr('tipID'),
                $cuiTip;
            this.$inner.removeClass("pulldown-error");
            if(tipID !== undefined){
                $cuiTip =  window.cui.tipList[tipID];
                if (typeof $cuiTip !== 'undefined') {
                    $cuiTip.hide();
                }
            }
            $el.attr("tip", this.tipText || "");
            //设置tip类型，正确
            $(this.tipPosition, this.options.el).attr('tipType', 'normal');
            this.inValid = false;
        }
    };
}());
})(window.comtop);