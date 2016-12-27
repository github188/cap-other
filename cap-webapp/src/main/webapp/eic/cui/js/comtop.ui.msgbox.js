/**
 * ????????
 * @author ??????
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
         * ???????
         * @returns {string}
         */
        _template: function () {
            var op = this.options;
            var html = ['<div class="msg-box"'];
            html.push(' id="' + this.buildId + '" style="');
            if (op.width) {
                html.push('width:' + op.width + 'px;');
            }
            if (op.height) {
                html.push('height:' + op.height + 'px;');
            }
            html.push('">');
            if (op.canClose === true) {
                html.push('<a href="#" hidefocus="true" title="???" onclick="return false;" class="msgbox-close-btn"><span class="msgbox-close-btn-span"></span></a>');
            }
            html.push('<div class="msgbox-titlebar">');
            html.push('<span class="msgbox-title" title="' + op.title.replace(/<.*?>/g, '').replace('"', '??') + '">' + op.title + '</span>');
            html.push('</div>');
            html.push('<div class="msgbox-content">');
            html.push('<div class="box-icon  ' + op.iconCls + '"></div>');
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
         *????button ???
         * @param html {array} ???????
         */
        _buildButtons: function (html) {
            var op = this.options;
            for (var i = 0, len = op.buttons.length; i < len; i++) {
                var proxyIndex = "";
                if (typeof op.buttons[i].handler === "function") {
                    proxyIndex += i;
                }
                html.push('<a proxyIndex="' + proxyIndex + '" class="btn-normal" href="#" onclick="return false;">' + op.buttons[i].name + '</a>');
            }
        },

        /**
         * ???????
         */
        _addClass: function () {
            var op = this.options,
                container = this.$container;
            if (op.position === "rb") {
                container.addClass("msg-box-rb");
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
         *???overlay
         */
        _showOverlay: function () {
            if(isIE6||isIEQ){
                this._ieQScrollTop=$(doc).scrollTop();
                $(doc).scrollTop(0);  // ???ie6??????????0
                $("html,body").addClass("cui_overlay_ie6");
                if(this._$iframecover){
                    this._$iframecover.show();
                }
            }
            this.$overlay.show();
        },
        _hideOverlay: function () {
            if(isIE6||isIEQ){
                $("html,body").removeClass("cui_overlay_ie6");
                if(this._$iframecover){
                    this._$iframecover.hide();
                }
               // $(doc).scrollTop(this._ieQScrollTop);  //???????msgbox???????????????????
            }
            this.$overlay.hide();
        },
        /**
         *???????
         */
        _doAnimate: function () {
            var msgboxContainer = this.$container,
                innerHeight = msgboxContainer.height();
            msgboxContainer.height(0).animate({height: innerHeight, opacity: 'show'}, 350);
        },
        _bindEvent: function () {
            var op = this.options, self = this;
            this.$container.delegate("a.btn-normal,span.msgbox-close-btn-span", "click", function (e) {
                var target = $(e.target), index = target.attr("proxyIndex");
                self.hide();
                if (index && index !== "") {
                    index = parseInt(index, 10);
                    op.buttons[index].handler.call(null);
                }
            });
            if (op.dragAble) {
                this._doDrag();
            }
            return false;
        },
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
                    var winh = $(win).height(),
                        winw = $(win).width();
                    if (pos.left + w >= winw) {
                        pos.left = winw - w;
                    }
                    if (pos.top + h >= winh) {
                        pos.top = winh - h;
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
         *??????????
         * @param flag  {boolean} ?????????
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
         * ????¦Ë??
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

        _commonOptions: {
            msg: "",                                  //???
            modal: true,                              //??????
            canClose: true,                           //??????
            autoClose: false,                         //?????????
            animate: false,                           //???????
            position: "center",                       //????????¦Ë??
            customPos: {},                              //?????¦Ë??
            opacity: 0.1,                            //?????
            title: "",                              //?????????
            width: 330,                               //???
            height: 0,                               //???
            onClose: null,                            //????????????????
            dragAble: true,
            dragClass: ".msgbox-titlebar"
        },
        /**
         * ???options
         * @param msg {string} ??????
         * @param onClose {function} ?????
         * @param options  {json}
         * @returns {?????options}
         */
        wrapOptions: function (msg, onClose, options) {
            var op = options || {};
            op.msg = msg;
            op.onClose = onClose;
            return op;
        },
        /**
         *???options
         * @param defaultOp ???????
         * @param options ???????
         * @returns ??????????
         */
        setOptions: function (defaultOp, options) {
            var cusOptions = $.extend({}, this._commonOptions, defaultOp, options || {});
            this.options = cusOptions;
            return  cusOptions;
        },
        /**
         * ???msgbox
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
         * ????msgbox
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
         * ???html
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
            $("body").prepend(docFragment);
            this.$container = $("#" + this.buildId);
        },
        /**
         * ????html
         */
        reBuildHtml: function () {
            var op = this.options;
            this.$container.unbind().replaceWith(this._template());
            this.$container = $("#" + this.buildId);
        }
    };




    var setIconClass = function (type, op) {
            var iconClsMap={"alert":"box-icon-alert","success":"box-icon-success",
                   "confirm":"box-icon-confirm","error":"box-icon-error",
                   "warn":"box-icon-warn" };
            op.iconCls = iconClsMap[type]||"box-icon-alert";
        },
        /**
         *???msg obj
         */
        createObj = function (msg, onClose, options, defaultOptions, type) {
            var msgObj = null;
            if (!cui[type].builded) {
                msgObj = new msgOBJ();
                options = msgObj.wrapOptions(msg, onClose, options);
                msgObj.setOptions(defaultOptions, options);
                msgObj.buildHtml();
                cui[type].builded = msgObj;
            } else {
                msgObj = cui[type].builded;
                options = msgObj.wrapOptions(msg, onClose, options);
                msgObj.setOptions(defaultOptions, options);
                msgObj.reBuildHtml();
            }
            msgObj.show();
        };

    cui.alert = function (msg, onClose, options) {
        var defaultOptions = {
            title: "???",
            buttons: [ { name: "???" } ],
            iconCls: "box-icon-alert"
        };
        createObj(msg, onClose, options, defaultOptions, "alert");
    };

    cui.warn = function (msg, onClose, options) {
        var defaultOptions = {
            title: "????",
            buttons: [ { name: "???" } ],
            iconCls: "box-icon-warn"
        };
        createObj(msg, onClose, options, defaultOptions, "warn");
    };

    cui.success = function (msg, onClose, options) {
        var defaultOptions = {
            title: "???",
            buttons: [ { name: "???" } ],
            iconCls: "box-icon-success"
        };
        createObj(msg, onClose, options, defaultOptions, "success");
    };

    cui.error = function (msg, onClose, options) {
        var defaultOptions = {
            title: "????",
            buttons: [ { name: "???" } ],
            iconCls: "box-icon-error"
        };
        createObj(msg, onClose, options, defaultOptions, "error");
    };

    cui.message = function (msg, type, options) {
        var defaultOptions = {
            modal: false,
            canClose: false,
            autoClose: 1500,
            animate: true,
            width: 180,
            position: "rb",
            title: "???",
            dragAble: false,
            buttons: null
        };
        options = options || {};
        setIconClass(type, options);
        createObj(msg, null, options, defaultOptions, "message");
    };

    cui.confirm = function (msg, options) {
        var defaultOptions = {
            title: "???",
            iconCls: "box-icon-confirm"
        };
        options = options || {};
        options.buttons = options.buttons || [
            {
                name: "???",
                handler: options.onYes
            },
            {
                name: "???",
                handler: options.onNo
            }
        ];
        createObj(msg, null, options, defaultOptions, "confirm");

    };


})(window.comtop ? window.comtop.cQuery : window.jQuery, window);