/**
 * ????????
 * @author ??????
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
            title: "",                     //???????
            modal: true,                   //?????????
            opacity: 0.7,                  //??????????
            canClose: true,                //????????
            width: 350,                    //???
            height: 100,                   //???
            left: "50%",                       //????¦Ë??
            top: "50%",                       //????¦Ë??
            draggable: true,               //?????????
            onClose: null,                 //???????????????
            beforeClose: null,             //??????????§Ö????
            src: "",                     //??????????????iframe??????????????
            html: "",                    //???????????????? iframe???????
            buttons: [],
            page_scroll: true,
            dragClass: ".dialog-titlebar"
        },
        _init: function () {
            this._preProcessSettings();
            this._buildHTML();
            this._markUp();
            this._setContent();
            this._setUpSize();
            this._bindEvent();
        },
        /**
         *????left ,top, id
         * @private
         */
        _preProcessSettings: function () {
            var op = this.opt,
                guid = function () {
                    return (900 * Math.random() + 100).toString().replace(".", "");
                };
            op.id = op.id === "" ? "dialog_" + guid() : op.id;
            op.left = op.left.toString();
            op.top = op.top.toString();
            op.left = op.left.indexOf("%") !== -1 ? op.left : parseInt(op.left, 10) + "px";
            op.top = op.top.indexOf("%") !== -1 ? op.top : parseInt(op.top, 10) + "px";
        },
        /**
         * ???????
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
                html.push('<a href="#" onclick="return false;" title="???" class="dialog-close-btn"><span class="dialog-close-btn-span"></span></a>');
            }
            html.push('<div class="dialog-titlebar"><span class="dialog-title" title="' + op.title.replace(/<.*?>/g, '').replace('"', '??') + '">');
            html.push(op.title, '</span></div>');
            html.push('<div class="dialog-content" >');
            if (typeof op.html === "string" && op.html !== "") {
                html.push('<div class="dialog-content-inner">');
                html.push(op.html);
                html.push('</div>');
            } else if (typeof op.src === "string" && op.src !== "") {
                html.push('<iframe class="dialog-content-iframe" frameborder="no" border="0" src="about:blank;" ></iframe><div class="dialog-iframe-loading"></div>');
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
         * ???????????
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
         * ????dialog?????opt.html?dom????????cui("#XXX")?????
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
         * ??????????
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
         * ?????
         * @private
         */
        _bindEvent: function () {
            var op = this.opt,
                self = this;
            this._$dialogContainer.delegate("a.btn-normal,span.dialog-close-btn-span,a.dialog-close-btn", "click", function (e) {
                var target = $(e.target), index = target.attr("proxyIndex");
                if (index && index !== "") {
                    index = parseInt(index, 10);
                    op.buttons[index].handler.call(self);
                    return;
                }
                if (typeof op.beforeClose === "function") {
                    if (op.beforeClose.call(self) !== false) {
                        self.hide();
                    }
                } else {
                    self.hide();
                }
                return false;
            });
            if (op.draggable) {
                this._doDrag();
            } else {
                this._$dialogContainer.find(".dialog-titlebar").css("cursor", "default");
            }
        },
        /**
         * ???
         * @private
         */
        _doDrag: function () {
            var op = this.opt, flag = false, self = this, detal = { top: 0, left: 0 },
                checkBorder = function (pos) {
                    var winh = $(win).height(), winw = $(win).width(), w = self._dialogContainerOuterWidth,
                        h = self._dialogContainerOuterHeight;
                    if (pos.left + w >= winw) {
                        pos.left = winw - w;
                    }
                    if (pos.top + h >= winh) {
                        pos.top = winh - h;
                    }
                },
                offEvent = function () {
                    flag = false;
                   // $(doc).off("mousemove.dialogDrag").off("mouseup.dialogDrag");
                    self._$mousemoveProxyLay.off();
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
                    }
                };
            $(op.dragClass, this._$dialogContainer).on("mousedown.dialogDrag",function (e) {
                var offset = this.getBoundingClientRect();
                detal.top = e.clientY - offset.top;
                detal.left = e.clientX - offset.left;
                flag = true;
                self._showContent(false);
                self._$mousemoveProxyLay.off().on("mousemove.dialogDrag",function (e) {
                    move(e);
                }).on("mouseup.dialogDrag", function () {
                        offEvent();
                 });
              return false;
            }).on("mouseup.dialogDrag", offEvent);

        },
        /**
         * ??????????
         * @param flag {boolean}??????
         * @private
         */
        _showContent: function (flag) {
            if (flag) {
                this._$mousemoveProxyLay.hide();  //???? ????????
                this._$dialogContent.css("visibility","visible");
                this._$iframe.css("visibility","visible");
            } else {
                this._$mousemoveProxyLay.show(); //??? ????????
                this._$dialogContent.css("visibility","hidden");
                this._$iframe.css("visibility","hidden");
            }
        },
        /**
         * ???????
         * @returns {string}
         * @private
         */
        _buildButtons: function () {
            var op = this.opt,
                bOp = {hide: false, disable: false, handler: function () {
                }, name: "???"},
                html = [];
            for(var i= 0,len=op.buttons.length;i<len;i++){
                op.buttons[i]=$.extend({}, bOp, op.buttons[i]);
                var button= op.buttons[i],classzz = "btn-normal ";
                classzz += button.disable ? " btn-normal-dis " : "";
                classzz += button.hide ? " btn-normal-hide " : "";
                html.push('<a href="#" hidefocus="true" onclick="return false;" class="', classzz, '" proxyIndex="', i, '">', button.name, '</a>');
            }
            return html.join("");
        },
        _calPosition: function () {
            var op = this.opt;
            return {"margin-left": -op.width / 2, "margin-top": -this._$dialogContainer.height() / 2};
        },
        _setPosition: function () {
            var op = this.opt,container=this._$dialogContainer;
            if (op.left === "50%" && op.top === "50%") {
                container.css(this._calPosition());
            } else if (op.left === "100%" && op.top === "100%") {
                container.css({left: "", top: "", right: 0, bottom: 0});
            }
        },
        _showOverLay: function () {
            if (this._$overlay.length === 0) {
                return;
            }
            if (isIE6 || isIEQ) {
                this._ieQScrollTop=$(doc).scrollTop();
                $(doc).scrollTop(0);
                $("html,body").addClass("cui_overlay_ie6");
                if(this._$iframecover.length){
                    this._$iframecover.show();
                }
            }
            this._$overlay.css("opacity", this.opt.opacity).show();
        },
        _hideOverLay: function () {
            if (this._$overlay.length === 0) {
                return;
            }
            if (isIE6 || isIEQ) {
                $("html,body").removeClass("cui_overlay_ie6");
                if(this._$iframecover.length){
                    this._$iframecover.hide();
                }
                $(doc).scrollTop(this._ieQScrollTop);
            }
            this._$overlay.hide();
        },
        _initIframeSrc: function () {
            if (this._$iframe.length && !this._srcSetted) {
                this._loadIframe(this.opt.src);
                this._srcSetted = true;
            }
        },
        _cacheDialogSize: function () {
            this._dialogContainerOuterWidth = this._$dialogContainer.outerWidth();
            this._dialogContainerOuterHeight = this._$dialogContainer.outerHeight();
        },
        _loadIframe:function(src){
            var self = this;
            this._$loadingLay.height(this._$iframe.height()).show();
            this._$iframe.css("visibility","hidden").attr("src", src);
            /*   .on("load", function () { }); ??????????load???*/
            setTimeout(function(){
                self._$iframe.css("visibility","visible");
                self._$loadingLay.hide();
            },500);
        },
        /**
         * ???dialog
         * @param src {String}  url ???
         * @returns {*}
         */
        show: function (src) {
            if (!src) {
                this._initIframeSrc();
            } else {
                this.reload(src);
            }
            if (!this.opt.page_scroll) {
                $("html").addClass("cui-dialog-noscroll");
            }
            this._setPosition();
            this._showOverLay();
            this._$dialogContainer.show();
            this._cacheDialogSize();
            return this;
        },
        /**
         * ???????iframe
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
         * ????dialog
         * @returns {*}
         */
        hide: function () {
            this._hideOverLay();
            this._$dialogContainer.hide();
            if (!this.opt.page_scroll) {
                $("html").removeClass("cui-dialog-noscroll");
            }
            if (typeof this.opt.onClose === "function") {
                this.opt.onClose.call(this);
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
         * ????????????????????????????????
         *  @param index {number}  ???index
         *  @param setting {number} ???????
         * or ??????§Ñ??????
         * @param setting {Array[setting]} ???????
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
         * ????Dialog???
         * @param size {Object} ??????¨°??? {width: xxxx, height: xxxx}
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

        getIframeMember: function (name) {
            if (this._$iframe.length) {
                return this._$iframe.get(0).contentWindow[name];
            } else {
                return null;
            }
        },
        getIframe: function () {
            if (this._$iframe.length) {
                return this._$iframe.get(0);
            } else {
                return null;
            }
        },
        destroy: function () {
            this._$dialogContainer.remove();
            this._hideOverLay();
            if (this._$overlay.length) {
                this._$overlay.remove();
            }
        }
    };
    Dialog.prototype.constructor = Dialog;
    if (C && C.UI && C.cQuery) {
        C.UI.dialog = Dialog;
        C.cQuery.fn.dialog=function(options){
            var obj=this.data("uitype");
            options=options||{};
            options.html=this.get(0);
            if(typeof obj !== "object"){
                obj= new C.UI.dialog(options);
                this.data("uitype",obj);
            }
            return obj;
        };
    }
    cui.dialog = function (options) {
        var customerId = options.id, dialog = new Dialog(options);
        if (typeof C === "object" && customerId) {
            C.cQuery("#" + customerId).data("uitype", dialog);
        }
        return dialog;
    };
})(window);