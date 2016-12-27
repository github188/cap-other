/**
 * 对话框组件
 * @author chenxuming
 * @since 2013-11-11
 * @require jQuery
 */
(function ($, win) {
    'use strict';
    if (!win.cui) {
        win.cui = {};
    }
    var msgOBJ = function () { },
        cui = win.cui,
        isIE=$.browser.msie,
        isIE6=isIE&&$.browser.version==="6.0",
        isIEQ=isIE&&!$.support.boxModel,doc=win.document;
    msgOBJ.prototype = {
        /**
         * 构建模板
         * @returns {string}
         */
        _template: function () {
            var op = this.options,extendClass =op.boxType==="message"?op.boxType+"-"+op.messageType:op.boxType;

            var html = ['<div class="msg-box cui-msg-extend-',extendClass,'"'];
            html.push(' id="' + this.buildId + '" style="');
            if (op.width) {
                html.push('width:' + op.width + 'px;');
            }
            if (op.height) {
                html.push('height:' + op.height + 'px;');
            }
            html.push('">');
            if (op.canClose === true) {
                html.push('<a href="#" hidefocus="true" title="关闭" class="msgbox-close-btn cui-icon"><span class="msgbox-close-btn-span"></span></a>');
            }
            html.push('<div class="msgbox-titlebar">');
            html.push('<span class="msgbox-title" title="' + op.title.replace(/<.*?>/g, '').replace('"', '＂') + '">' + op.title + '</span>');
            html.push('</div>');
            html.push('<div class="msgbox-content">');
            html.push('<div class="box-icon cui-icon ' + op.iconCls + '">', op.fontIcon ,'</div>');
            html.push('<div class="box-msg">');
            html.push(op.msg, '</div>');
            if ($.isArray(op.buttons)) {
                html.push('<div class="msgbox-ft">');
                this._buildButtons(html);
                html.push('</div>');
            }
            html.push('</div>');
            html.push('</div>');
            return html.join('');
        },
        /**
         *构建button 模板
         * @param html {array} 模板数组
         */
        _buildButtons: function (html) {
            var op = this.options;
            for (var i = 0, len = op.buttons.length; i < len; i++) {
                var proxyIndex = "",buttonClazz="btn-normal ";
                if (typeof op.buttons[i].handler === "function") {
                    proxyIndex += i;
                }
                if(op.buttons[i].focus === true){
                    op._buttonFocusIndex = i; // 按钮focus的index,多次设置后边的覆盖前面的
                }
                if(op.buttons[i]._ok_){
                    buttonClazz+=" btn-normal-ok";
                }
                else if(op.buttons[i]._cancel_){
                    buttonClazz+=" btn-normal-cancel";
                }
                html.push('<a proxyIndex="' + proxyIndex + '" class="cui-button '+buttonClazz+'" href="#">');
                html.push('<span class="button-icon">&nbsp;</span>');
                html.push(op.buttons[i].name + '</a>');
            }
        },

        /**
         * 设置样式
         * @private
         */
        _addClass: function () {
            var op = this.options,
                container = this.$container;
            if (op.position === "rb") {
                container.addClass("msg-box-rb");
                if(!isIE6&&isIEQ){
                    container.css({"bottom":"",top:$(doc).scrollTop()+$(win).height()-container.outerHeight()});
                }
            } else if (op.position === "center") {
                container.addClass("msg-box-center").css({
                    "margin-left": -container.width() / 2,
                    "margin-top": -container.height() / 2
                });
            } else if (op.position === "custom") {
                container.addClass("msg-box-custom").css(op.customPos);
            }
        },

        /**
         * 显示 overlay
         * @private
         */
        _showOverlay: function () {
            if(isIE6||isIEQ){
                this._ieQScrollTop=$(doc).scrollTop();
                $(doc).scrollTop(0);  // 此处ie6会自动设置为0
                $("html,body").addClass("cui_overlay_ie6");
                if(this._$iframecover){
                    this._$iframecover.show();
                }
            }
            this.$overlay.show();
        },
        /**
         * 隐藏 overlay
         * @private
         */
        _hideOverlay: function () {
            if(isIE6||isIEQ){
                $("html,body").removeClass("cui_overlay_ie6");
                if(this._$iframecover){
                    this._$iframecover.hide();
                }
                if(this.options.scrollBack === true){
                    $(doc).scrollTop(this._ieQScrollTop);
                }
               // $(doc).scrollTop(this._ieQScrollTop);  //循环调用msgbox会出现滚动条闪动，去掉
            }
            this.$overlay.hide();
        },
        /**
         *动画显示
         */
        _doAnimate: function () {
            var msgboxContainer = this.$container,
                innerHeight = msgboxContainer.height();
            msgboxContainer.height(0).animate({height: innerHeight, opacity: 'show'}, 350);
        },
        /**
         * 绑定事件
         * @returns {boolean}
         * @private
         */
        _bindEvent: function () {
            var op = this.options, self = this;
            this.$container.delegate("a.btn-normal,span.msgbox-close-btn-span", "click", function (e) {
                var target = $(e.target), index = target.attr("proxyIndex");
                self.hide();
                if (index && index !== "") {
                    index = parseInt(index, 10);
                    op.buttons[index].handler.call(null);
                }
                return false;
            });
            if (op.dragAble) {
                this._doDrag();
            }
            if(typeof op._buttonFocusIndex === "number"){
                this.$container.find(".btn-normal").eq(op._buttonFocusIndex).focus();
            }
            return false;
        },
        /**
         * 拖动处理函数
         * @private
         */
        _doDrag: function () {
            var op = this.options,
                flag = false,
                self = this,
                detal = {
                    top: 0,
                    left: 0
                },
                w = this.$container.outerWidth(),
                h = this.$container.outerHeight(),
                checkBorder = function (pos) {
                    var winHeight = $(win).height(),
                        winWidth = $(win).width();
                    if (pos.left + w >= winWidth) {
                        pos.left = winWidth - w;
                    }
                    if (pos.top + h >= winHeight) {
                        pos.top = winHeight - h;
                    }
                },
                offEvent = function () {
                    flag = false;
                    $(doc).off("mousemove.msgBoxdrag").off("mouseup.msgBoxdrag");
                    self._disableSelect(false);
                },
                move = function (e) {
                    if (flag) {
                        var pos = {left: e.clientX - detal.left, top: e.clientY - detal.top};
                        pos.left = pos.left < 0 ? 0 : pos.left;
                        pos.top = pos.top < 0 ? 0 : pos.top;
                        checkBorder(pos);
                        self._setPosition(pos);
                    }
                };
            $(op.dragClass,this.$container).on("mousedown.msgBoxdrag",function (e) {
                var offset = this.getBoundingClientRect();
                detal.top = e.clientY - offset.top;
                detal.left = e.clientX - offset.left;
                flag = true;
                $(doc).on("mousemove.msgBoxdrag",function (e) {
                    move(e);
                }).on("mouseup.msgBoxdrag", function () {
                        offEvent();
                    });
                self._disableSelect(true);
            }).on("mouseup.msgBoxdrag", offEvent);
            /*                .on("mouseleave.msgBoxdrag",function(){
             offEvent();
             });*/
        },
        /**
         *禁用文本选择
         * @param flag  {boolean} 是否禁用选择
         */
        _disableSelect: function (flag) {
            if (flag) {
                $(doc.body).addClass("cui-userselectnone");
                $(doc).on("selectstart", function (e) {
                    return false;
                });
            } else {
                $(doc.body).removeClass("cui-userselectnone");
                $(doc).off("selectstart");
            }
        },
        /**
         * 设置位置
         * @param pos {left:xxx,top:xxx}
         */
        _setPosition: function (pos) {
            var op = this.options;
            pos = $.extend({
                top: "",
                left: "",
                right: "",
                "margin-left": "",
                "margin-top": "",
                bottom: ""
            }, pos);
            this.$container.css(pos);
        },
        /**
         * 通用配置
         */
        _commonOptions: {
            msg: "",                                  //消息
            modal: true,                              //是否为模态
            canClose: true,                           //是否可关闭
            autoClose: false,                         //是否自动关闭
            animate: false,                           //是否动画显示
            position: "center",                       //消息框显示位置
            customPos: {},                              //自定义位置
            opacity: 0.5,                            //透明度
            title: "",                              //消息框的标题
            width: 330,                               //宽度
            height: 0,                               //高度
            onClose: null,                            //消息框关闭时的回调函数
            dragAble: true,
            scrollBack:false,                         // 是否需要滚动回来
            dragClass: ".msgbox-titlebar"
        },
        /**
         * 包装options
         * @param msg {string} 提示消息
         * @param onClose {function} 关闭回调
         * @param options  {json}
         * @returns {合并后options}
         */
        wrapOptions: function (msg, onClose, options) {
            var op = options || {};
            op.msg = msg;
            op.onClose = onClose;
            return op;
        },
        /**
         *合并options
         * @param defaultOp 默认设置
         * @param options 用户设置
         * @returns 合并后的设置
         */
        setOptions: function (defaultOp, options) {
            var cusOptions = $.extend({}, this._commonOptions, defaultOp, options || {});
            this.options = cusOptions;
            return  cusOptions;
        },
        /**
         * 显示msgbox
         */
        show: function () {
            var op = this.options;
            this._addClass();
            if (op.modal) {
                this._showOverlay();
            }
            if (op.animate && !isIEQ) {
                this._doAnimate();
            } else {
                this.$container.show();
            }
            if (typeof op.autoClose === "number") {
                var self = this;
                win.setTimeout(function () {
                    self.hide();
                }, op.autoClose);
            }
            this._bindEvent();
        },
        /**
         * 隐藏msgbox
         */
        hide: function () {
            var op = this.options;
            if (op.modal) {
                this._hideOverlay();
            }
            this.$container.hide();
            if (typeof op.onClose === "function") {
                op.onClose.call(null);
            }
        },

        /**
         * 生成html
         */
        buildHtml: function () {
            var id = (900 * Math.random() + 100).toString().replace(".", ""), op = this.options;
            var docFragment = doc.createDocumentFragment();
            this.buildId = id;
            if (op.modal) {
                this.$overlay = $(doc.createElement("div")).addClass("cui_overlay").css("opacity",op.opacity);
                if(isIE6){
                    this._$iframecover=$(doc.createElement("iframe")).addClass("cui_overlay_iframe");
                    $(docFragment).append(this._$iframecover);
                }
                $(docFragment).append(this.$overlay);
            }
            $(docFragment).append(this._template());
            if(this.options.boxType==="message"){
                $(doc.body).prepend(docFragment);
            }else{
                $(doc.body).append(docFragment);
            }
            this.$container = $("#" + this.buildId);
        },
        /**
         * 重置html
         */
        reBuildHtml: function () {
            var op = this.options;
            this.$container.unbind().replaceWith(this._template());
            this.$container = $("#" + this.buildId);
            if(op.boxType!=="message"){ //避免和dialog冲突,放到最后
                if(this._$iframecover){
                    this._$iframecover.appendTo(doc.body);
                }
                if(this.$overlay){
                    this.$overlay.appendTo(doc.body);
                }
                this.$container.appendTo(doc.body);
            }
        }
    };


    /**
     * 根据弹出类型设置class样式
     * @param type
     * @param op
     */
    var setIconClass = function (type, op) {
            var iconClsMap={"alert":"box-icon-alert","success":"box-icon-success",
                   "confirm":"box-icon-confirm","error":"box-icon-error",
                   "warn":"box-icon-warn" };
            op.iconCls = iconClsMap[type]||"box-icon-alert";
        },
        /**
         * 创建msgbox object
         */
        createObj = function (msg, onClose, options, defaultOptions, type) {
            var msgObj = null;
            if (!cui[type].builded) {
                msgObj = new msgOBJ();
                options = msgObj.wrapOptions(msg, onClose, options);
                options.boxType=type;
                msgObj.setOptions(defaultOptions, options);
                msgObj.buildHtml();
                cui[type].builded = msgObj;
            } else {
                msgObj = cui[type].builded;
                options = msgObj.wrapOptions(msg, onClose, options);
                options.boxType=type;
                msgObj.setOptions(defaultOptions, options);
                msgObj.reBuildHtml();
            }
            msgObj.show();
        };

   // 以下为用户接口
    /**
     *  alert 弹出框
     * @param msg {String} 提示内容
     * @param onClose {function} 关闭回调
     * @param options {json}其它配置
     */
    cui.alert = function (msg, onClose, options) {
        var defaultOptions = {
            title: "提示",
            buttons: [ { name: "确定",focus:true,_ok_:true } ],
            iconCls: "box-icon-alert",
            fontIcon: "&#xf05a;"
        };
        createObj(msg, onClose, options, defaultOptions, "alert");
    };
    /**
     *  warn 弹出框
     * @param msg {String} 提示内容
     * @param onClose {function} 关闭回调
     * @param options {json}其它配置
     */
    cui.warn = function (msg, onClose, options) {
        var defaultOptions = {
            title: "警告",
            buttons: [ { name: "确定" ,focus:true,_ok_:true } ],
            iconCls: "box-icon-warn",
            fontIcon: "&#xf06a;"
        };
        createObj(msg, onClose, options, defaultOptions, "warn");
    };
    /**
     *  success 提示框
     * @param msg {String} 提示内容
     * @param onClose {function} 关闭回调
     * @param options {json}其它配置
     */
    cui.success = function (msg, onClose, options) {
        var defaultOptions = {
            title: "提示",
            buttons: [ { name: "确定" ,focus:true ,_ok_:true} ],
            iconCls: "box-icon-success",
            fontIcon: "&#xf058;"
        };
        createObj(msg, onClose, options, defaultOptions, "success");
    };
    /**
     *  error 提示框
     * @param msg {String} 提示内容
     * @param onClose {function} 关闭回调
     * @param options {json}其它配置
     */
    cui.error = function (msg, onClose, options) {
        var defaultOptions = {
            title: "错误",
            buttons: [ { name: "确定",focus:true,_ok_:true  } ],
            iconCls: "box-icon-error",
            fontIcon: "&#xf057;"
        };
        createObj(msg, onClose, options, defaultOptions, "error");
    };
    /**
     *  message 提示框
     * @param msg {String} 提示内容
     * @param type {String} 提示类型
     * @param options {json}其它配置
     */
    cui.message = function (msg, type, options) {
        var defaultOptions = {
            modal: false,
            canClose: false,
            autoClose: 1500,
            animate: true,
            width: 180,
            position: "rb",
            title: "提示",
            dragAble: false,
            buttons: null
        },
            fontIcon = {
                error: "&#xf057;",
                success: "&#xf058;",
                warn: "&#xf06a;",
                alert: "&#xf05a;"
            };

        options = options || {};
        setIconClass(type, options);
        options.messageType = type ? type : "alert";
        options.fontIcon = fontIcon[options.messageType];
        createObj(msg, null, options, defaultOptions, "message");
    };
    /**
     *  confirm 提示框
     * @param msg {String} 提示内容
     * @param options {json}其它配置
     */
    cui.confirm = function (msg, options) {
        var defaultOptions = {
            title: "确认",
            iconCls: "box-icon-confirm",
            fontIcon: "&#xf059;"
        };
        options = options || {};
        options.buttons = options.buttons || [
            {
                name: "确定",
                handler: options.onYes,
                focus:true,_ok_:true
            },
            {
                name: "取消",
                handler: options.onNo,_cancel_:true
            }
        ];
        createObj(msg, null, options, defaultOptions, "confirm");

    };


})(window.comtop ? window.comtop.cQuery : window.jQuery, window);