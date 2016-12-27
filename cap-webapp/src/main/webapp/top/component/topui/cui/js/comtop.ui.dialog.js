/**
 * 对话框组件
 * @author chenxuming
 * @since 2013-11-11
 * @require jQuery
 */
(function (win) {
    'use strict';
    if (!win.cui) {
        win.cui = {};
    }
    var C = win.comtop, $ = C && C.cQuery ? C.cQuery : win.jQuery, cui = win.cui,doc=win.document;
    var isIE = $.browser.msie,
        isIE6 = isIE && $.browser.version === "6.0",
        isIEQ = isIE && !$.support.boxModel;
    var creatEventProxyLay=function(){
        var body = $("body"),obj=body.data("cui_dialog_eventproxylay");
        if(!obj){
            obj= $(doc.createElement("div")).addClass("cui_dialog_eventproxylay").appendTo(body);
            body.data("cui_dialog_eventproxylay",obj);
        }
        return obj;
    };
    var Dialog = function (options) {
        options = options || {};
        this.opt = $.extend(true, {}, this.options, options);
        this._init();
    };
    Dialog.prototype = {
        options: {
            uitype: "Dialog",
            id: "",
            title: "",                     //窗口标题
            modal: true,                   //是否模态窗口
            opacity: 0.5,                  //遮罩层透明度
            canClose: true,                //是否可以关闭
            outClose: false,                //点击窗口以外是否可以关闭（chaoqun.lin 新增）
            width: 350,                    //宽度
            height: 100,                   //高度
            left: "50%",                       //横向位置
            top: "50%",                       //纵向位置
            draggable: true,               //是否可以拖动
            hideContent:false,             // 拖动时是否隐藏内容
            onClose: null,                 //窗口关闭时的回调函数
            beforeClose: null,             //窗口关闭之前执行的函数
            src: "",                     //如果窗口的内容是一个iframe，则使用该配置项
            html: "",                    //弹窗内容，此属性和 iframe只能选其一
            buttons: [],
            page_scroll: true,
            refresh:false,               //当dialog是iframe时，使用cui.dialog 显示是否需要重新请求url
            dragClass: ".dialog-titlebar"
        },
        /**
         * 组件初始化
         * @private
         */
        _init: function () {
            this._preProcessSettings();
            this._buildHTML();
            this._markUp();
            this._setContent();
            this._setUpSize();
            this._bindEvent();
        },
        /**
         *处理left ,top, id
         * @private
         */
        _preProcessSettings: function () {
            var op = this.opt,
                guid = function () {
                    return (900 * Math.random() + 100).toString().replace(".", "");
                };
            if(typeof op.width==="string"){
                op.width =win.parseInt(op.width);
            }
            if(typeof op.height==="string"){
                op.height =win.parseInt(op.height);
            }
            op.id = op.id === "" ? "dialog_" + guid() : op.id;
            op.left = op.left.toString();
            op.top = op.top.toString();
            op.left = op.left.indexOf("%") !== -1 ? op.left : parseInt(op.left, 10) + "px";
            op.top = op.top.indexOf("%") !== -1 ? op.top : parseInt(op.top, 10) + "px";
        },
        /**
         * 构建模板
         * @private
         */
        _buildHTML: function () {
            var op = this.opt,
                html = [];
            if (op.modal) {
                if(isIE6){
                    html.push('<iframe id="cui_overlay_iframe_',op.id,'" class="cui_overlay_iframe"></iframe>');
                }
                html.push('<div class="cui_overlay" id="cui_overlay_', op.id, '"></div>');
            }
            html.push('<div class="cui-dialog-container" id="', op.id, '" style="');
            html.push('left:', op.left, '; top:', op.top, ';">');
            if (op.canClose) {
                html.push('<a href="#" title="关闭" hidefocus="true" class="dialog-close-btn"></a>');
            }
            html.push('<div class="dialog-titlebar"><span class="dialog-title" title="' + op.title.replace(/<.*?>/g, '').replace('"', '＂') + '">');
            html.push(op.title, '</span></div>');
            html.push('<div class="dialog-content" >');
            if (typeof op.html === "string" && op.html !== "") {
                html.push('<div class="dialog-content-inner">');
                html.push(op.html);
                html.push('</div>');
            } else if (typeof op.src === "string" && op.src !== "") {
                html.push('<iframe class="dialog-content-iframe" frameborder="no" border="0" src="about:blank" ></iframe><div class="dialog-iframe-loading"></div>');
            } else {
                html.push('<div class="dialog-content-inner"></div>');
            }
            if ($.isArray(op.buttons) && op.buttons.length > 0) {
                html.push('<div class="dialog-ft">');
                html.push(this._buildButtons());
                html.push('</div>');
            }
            html.push('</div>');

            html.push('</div>');

            $("body").append(html.join(""));

        },
        /**
         * 解析成员变量
         * @private
         */
        _markUp: function () {
            var op = this.opt;
            this._$dialogContainer = $("#" + op.id);
            this._$dialogContent = this._$dialogContainer.find(".dialog-content-inner");
            this._$iframe = this._$dialogContainer.find(".dialog-content-iframe");
            this._$loadingLay = this._$dialogContainer.find(".dialog-iframe-loading");
            this._$buttonContainer = this._$dialogContainer.find(".dialog-ft");
            this._$overlay = $("#cui_overlay_" + op.id);
            this._$iframecover=$("#cui_overlay_iframe_" + op.id);
            this._$mousemoveProxyLay= creatEventProxyLay();
        },
        /**
         * 加载dialog内容，opt.html为dom时或者使用cui("#XXX")时调用
         * @private
         */
        _setContent: function () {
            var op = this.opt;
            if (typeof op.el === "object") {
                this._$dialogContent.prepend($(op.el).show());
            }
            else if (typeof op.html === "object") {
                this._$dialogContent.prepend($(op.html).show());
            }
        },
        /**
         * 设置高度，宽度
         * @private
         */
        _setUpSize: function () {
            var op = this.opt;
            if (op.height) {
                if (this._$iframe.length) {
                    this._$iframe.height(op.height);
                } else {
                    this._$dialogContent.height(op.height);
                }
            }
            if (op.width) {
                this._$dialogContainer.width(op.width);
            }
        },
        /**
         * 绑定事件
         * @private
         */
        _bindEvent: function () {
            var op = this.opt,
                self = this;
            this._$dialogContainer.delegate("a.cui-btn-generate-by-dg,a.dialog-close-btn", "click", function (e) {
                var target = $(e.target), index = target.attr("proxyIndex");
                //可用按钮
                if (index && index !== "") {
                    if(!op.buttons[index].disable){
                        index = parseInt(index, 10);
                        op.buttons[index].handler.call(self);
                    }
                    return false;
                }
                //关闭按钮
                self.hide();
                return false;

            });
            //阻止mouseup冒泡
            this._$dialogContainer.on('mouseup.dialog', function(e){
                e.stopPropagation();
            });

            //窗口以外具备关闭窗口功能
            if(op.outClose && op.canClose){
                //如果不使用modal，则document需要添加关闭监听
                if(!op.modal){
                    $(document).bind('mouseup.dialog', function(){
                        self.hide();
                        return false;
                    });
                }
                //如果使用modal，只需要在overlay上添加关闭监听
                this._$overlay.bind('click', function(){
                    self.hide();
                    return false;
                });
            }

            if (op.draggable) {
                this._doDrag();
            } else {
                this._$dialogContainer.find(".dialog-titlebar").css("cursor", "default");
            }
        },
        /**
         * 拖动
         * @private
         */
        _doDrag: function () {
            var op = this.opt, flag = false,hide=false, self = this, detal = { top: 0, left: 0 },
                checkBorder = function (pos) {
                    var winHeight = $(win).height(), winWidth = $(win).width(), w = self._dialogContainerOuterWidth,
                        h = self._dialogContainerOuterHeight;
                    if (pos.left + w >= winWidth) {
                        pos.left = winWidth - w;
                    }
                    if (pos.top + h >= winHeight) {
                        pos.top = winHeight - h;
                    }
                },
                offEvent = function (e) {
                    e.stopPropagation();
                    flag = false; hide=false;
                   // $(doc).off("mousemove.dialogDrag").off("mouseup.dialogDrag");
                    self._$mousemoveProxyLay.hide().off();
                    self._showContent(true);
                },
                move = function (e) {
                    if (flag) {
                        var pos = {left: e.clientX - detal.left, top: e.clientY - detal.top,
                            "margin-left": "", "margin-top": "", "bottom": "", "right": ""};
                        pos.left = pos.left < 0 ? 0 : pos.left;
                        pos.top = pos.top < 0 ? 0 : pos.top;
                        checkBorder(pos);
                        self._$dialogContainer.css(pos);
                        op.left = pos.left;
                        op.top = pos.top;
                        if(!hide){
                            self._showContent(false);
                            hide=true;
                        }

                    }
                };
            $(op.dragClass, this._$dialogContainer).on("mousedown.dialogDrag",function (e) {
                var offset = this.getBoundingClientRect();
                detal.top = e.clientY - offset.top;
                detal.left = e.clientX - offset.left;
                flag = true;
                self._$mousemoveProxyLay.show().off().on("mousemove.dialogDrag",function (e) {
                    move(e);
                }).on("mouseup.dialogDrag", offEvent);
              return false;
            }).on("mouseup.dialogDrag", offEvent);

        },
        /**
         * 是否显示内容
         * @param flag {boolean}是否显示
         * @private
         */
        _showContent: function (flag) {
            if (flag) {
                if(this.opt.hideContent){
                    this._$dialogContent.css("visibility","visible");
                    this._$iframe.css("visibility","visible");
                }
            } else {
                if(this.opt.hideContent){
                    this._$dialogContent.css("visibility","hidden");
                    this._$iframe.css("visibility","hidden");
                }
            }
        },
        /**
         * 构建按钮
         * @returns {string}
         * @private
         */
        _buildButtons: function () {
            var op = this.opt,
                bOp = {
                    hide: false,
                    disable: false,
                    handler: function () {},
                    name: "按钮"
                },
                html = [];
            for(var i= 0,len=op.buttons.length;i<len;i++){
                op.buttons[i]=$.extend({}, bOp, op.buttons[i]);
                var button= op.buttons[i], classzz = "cui-button cui-btn-generate-by-dg ";
                classzz += button.disable ? " disable-button " : "";
                classzz += button.hide ? " btn-normal-hide " : "";
                html.push('<a href="#" hidefocus="true" onclick="return false;" class="', classzz, '" proxyIndex="', i, '">', button.name, '</a>');
            }
            return html.join("");
        },
        /**
         *计算dialog位置
         * @returns {{margin-left: number, margin-top: number}}
         * @private
         */
        _calPosition: function () {
            var op = this.opt;
            return {"margin-left": -op.width / 2, "margin-top": -this._$dialogContainer.height() / 2};
        },
        /**
         * 设置dialog弹出的位置
         * @private
         */
        _setPosition: function () {
            var op = this.opt,container=this._$dialogContainer,pos;
            if (op.left === "50%" && op.top === "50%") {
                container.css(this._calPosition());
            } else if (op.left === "100%" && op.top === "100%") {
                container.css({left: "", top: "", right: 0, bottom: 0});
            }else if(op.left==="50%"&& op.top!=="50%"){
                pos =this._calPosition();
                container.css({"margin-left":pos["margin-left"]});
            }
        },
        /**
         * 显示overlay
         * @private
         */
        _showOverLay: function () {
            if (this._$overlay.length === 0) {
                return;
            }
            if (isIE6 || isIEQ) {
                this._ieQScrollTop=$(doc).scrollTop();
                $(doc).scrollTop(0);
                $("html,body").addClass("cui_overlay_dialog_ie6");
                if(this._$iframecover.length){
                    this._$iframecover.show();
                }
            }
            this._$overlay.css("opacity", this.opt.opacity).show();
        },
        /**
         * 隐藏遮罩层
         * @private
         */
        _hideOverLay: function () {
            if (this._$overlay.length === 0) {
                return;
            }
            if (isIE6 || isIEQ) {
                $("html,body").removeClass("cui_overlay_dialog_ie6");
                if(this._$iframecover.length){
                    this._$iframecover.hide();
                }
                $(doc).scrollTop(this._ieQScrollTop);
            }
            this._$overlay.hide();
        },
        /**
         * 初始化iframe
         * @private
         */
        _initIframeSrc: function () {
            if (this._$iframe.length) {
                if(!this._srcSetted||this.opt.refresh){
                    this._loadIframe(this.opt.src);
                    this._srcSetted = true;
                }
            }
        },
        /**
         * 缓存dialog的width,height
         * @private
         */
        _cacheDialogSize: function () {
            this._dialogContainerOuterWidth = this._$dialogContainer.outerWidth();
            this._dialogContainerOuterHeight = this._$dialogContainer.outerHeight();
        },
        /**
         * 加载iframe
         * @param src   iframe的src
         * @private
         */
        _loadIframe:function(src){
            var self = this;
            this._$loadingLay.height(this._$iframe.height()).show();
            this._$iframe.one("load", function () { this.setAttribute("src",src); });
            this._$iframe.css("visibility","hidden").attr("src", "about:blank");
            setTimeout(function(){
                self._$iframe.css("visibility","visible");
                self._$loadingLay.hide();
            },500);
        },


        /**
         * 显示dialog
         * @param src {String}  url 地址
         * @returns {*}
         */
        show: function (src) {
            if (!this.opt.page_scroll) {
                $("html").addClass("cui-dialog-noscroll");
            }
            this._setPosition();
            this._showOverLay();
            if (!src) {
                this._initIframeSrc();
            } else {
                this.reload(src);
            }
            this._$dialogContainer.show();
/*            if(this._$mousemoveProxyLay){
                this._$mousemoveProxyLay.appendTo(doc.body);
            }*/
            this._cacheDialogSize();
            return this;
        },
        /**
         * 重新加载iframe
         * @param src
         * @returns {*}
         */
        reload: function (src) {
            if (!this._$iframe.length || !src) {
                return this;
            }
            this._loadIframe(src);
            this.opt.src = src;
            return this;
        },
        /**
         * 隐藏dialog
         * @returns {*}
         */
        hide: function () {
            //如果beforeClose是function，且返回true，则执行关闭，否则，中止关闭操作
            if (typeof this.opt.beforeClose === "function") {
                if (this.opt.beforeClose.call(this) === false) {
                    return this;
                }
            }
            this._hideOverLay();
            this._$dialogContainer.hide();
            if (!this.opt.page_scroll) {
                $("html").removeClass("cui-dialog-noscroll");
            }
            if (typeof this.opt.onClose === "function") {
                this.opt.onClose.call(this);
            }
            //如果关闭窗口，且dialog没有modal，则移除mouseup的监听
            if(!this.opt.modal && this.opt.outClose && this.opt.canClose){
                $(document).unbind('mouseup.dialog');
            }
            return this;
        },
        setTitle: function (value) {
            var type = typeof value;
            if (type === "number" || type === "string") {
                this.opt.title = value;
                $("span.dialog-title", this._$dialogContainer).html(value);
            }
            return this;
        },
        /**
         * 设置按钮属性。本方法允许两种传入参数方式
         *  @param index {number}  按钮index
         *  @param setting {number} 按钮设置
         * or 修改所有按钮设置
         * @param setting {Array[setting]} 按钮设置
         */
        setButton: function (index, setting) {
            var paramLength = arguments.length,
                op = this.opt, self = this,
                rebuildButtons = function () {
                    if (self._$buttonContainer.length) {
                        self._$buttonContainer.html(self._buildButtons());
                    }
                };
            if (paramLength === 1 && $.type(index) === "array") {
                $.extend(op.buttons, index);
                rebuildButtons();
            } else if (paramLength === 2 && typeof index === "number") {
                if (index > op.buttons.length) {
                    return;
                }
                $.extend(op.buttons[index], setting);
                rebuildButtons();
            }
            return this;
        },
        /**
         * 设置Dialog高宽
         * @param size {Object} 高宽配置参数 {width: xxxx, height: xxxx}
         * @returns {Dialog}
         */
        setSize: function (size) {
            if ($.type(size) !== "object") {
                return this;
            }
            if (size.width) {
                this.opt.width = size.width;
            }
            if (size.height) {
                this.opt.height = size.height;
            }
            this._setUpSize();
            this._setPosition();
            this._cacheDialogSize();
            return this;
        },
        /**
         * 获取dialog内iframe内部成员变量
         * @param name
         * @returns {*}
         */
        getIframeMember: function (name) {
            if (this._$iframe.length) {
                return this._$iframe.get(0).contentWindow[name];
            } else {
                return null;
            }
        },
        /**
         * 获取dialog内iframe          *
         * @returns iframe
         */
        getIframe: function () {
            if (this._$iframe.length) {
                return this._$iframe.get(0);
            } else {
                return null;
            }
        },
        /**
         *移动dialog
         * @param top
         * @param left
         */
        move:function(top,left){
            var cssObj={};
            if(typeof top ==="number"){
                cssObj.top = top;
                cssObj["margin-top"] = "";
                this.opt.top = top;
            }
            if(typeof left ==="number"){
                cssObj.left = left;
                cssObj["margin-left"] = "";
                this.opt.left = left;
            }
            if($.isEmptyObject(cssObj)){return this;}
            cssObj = $.extend({bottom:"",right:""},cssObj);
            this._$dialogContainer.css(cssObj);
            return this;
        },
        /**
         * 销毁dialog
         *
         */
        destroy: function () {
            this._$dialogContainer.remove();
            this._hideOverLay();

            if (this._$overlay.length) {
                this._$overlay.remove();
            }
            if(this._$iframecover.length){
                this._$iframecover.remove();
            }
            this._$mousemoveProxyLay=this._$iframecover=null;
            this._$dialogContainer =this._$overlay=null;
            this._$dialogContent =this._$iframe=null;
            this._$loadingLay=this._$buttonContainer=null;
            this.opt=null;
        }
    };
    Dialog.prototype.constructor = Dialog;
    /**
     * 兼容cui base代码
     */
    if (C && C.UI && C.cQuery) {
        C.UI.Dialog = Dialog;
        C.cQuery.fn.dialog = function(options){
            var obj = this.data("uitype");
            options = options||{};
            options.html = this.get(0);
            if(typeof obj !== "object"){
                obj = new C.UI.Dialog(options);
                obj.isCUI = true;
                this.data("uitype",obj);
            }
            return obj;
        };
    }
    //export
    /**
     * 用户创建dialog接口
     * @param options {json} dialog配置
     * @returns {Dialog}
     */
    cui.dialog = function (options) {
        var customerId = options.id,
            oldDialog = cui("#"+customerId);
        if(oldDialog instanceof Dialog){
             if(typeof options.title==="string"&&oldDialog.opt.title!==options.title){
                 oldDialog.setTitle(options.title);
             }
             if(typeof options.src==="string"){
                 if(oldDialog.opt.src!==options.src){
                     oldDialog.reload(options.src);
                 }
             }
            return oldDialog;
        }
        var dialog = new Dialog(options);
        if (typeof C === "object" && customerId) {
            dialog.isCUI = true;
            C.cQuery("#" + customerId).data("uitype", dialog);
        }
        return dialog;
    };
    /**
     * 配置默认options
     * @param opts {Object} 配置对象
     */
    cui.dialog.setOpt = function(opts){
        if($.type(opts) !== 'object'){
            return;
        }
        $.extend(Dialog.prototype.options, opts);
    };
})(window);