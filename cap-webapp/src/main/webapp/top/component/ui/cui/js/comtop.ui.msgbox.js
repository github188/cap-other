/**
 * �Ի������
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
         * ����ģ��
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
                html.push('<a href="#" hidefocus="true" title="�ر�" class="msgbox-close-btn cui-icon"><span class="msgbox-close-btn-span"></span></a>');
            }
            html.push('<div class="msgbox-titlebar">');
            html.push('<span class="msgbox-title" title="' + op.title.replace(/<.*?>/g, '').replace('"', '��') + '">' + op.title + '</span>');
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
         *����button ģ��
         * @param html {array} ģ������
         */
        _buildButtons: function (html) {
            var op = this.options;
            for (var i = 0, len = op.buttons.length; i < len; i++) {
                var proxyIndex = "",buttonClazz="btn-normal ";
                if (typeof op.buttons[i].handler === "function") {
                    proxyIndex += i;
                }
                if(op.buttons[i].focus === true){
                    op._buttonFocusIndex = i; // ��ťfocus��index,������ú�ߵĸ���ǰ���
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
         * ������ʽ
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
         * ��ʾ overlay
         * @private
         */
        _showOverlay: function () {
            if(isIE6||isIEQ){
                this._ieQScrollTop=$(doc).scrollTop();
                $(doc).scrollTop(0);  // �˴�ie6���Զ�����Ϊ0
                $("html,body").addClass("cui_overlay_ie6");
                if(this._$iframecover){
                    this._$iframecover.show();
                }
            }
            this.$overlay.show();
        },
        /**
         * ���� overlay
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
               // $(doc).scrollTop(this._ieQScrollTop);  //ѭ������msgbox����ֹ�����������ȥ��
            }
            this.$overlay.hide();
        },
        /**
         *������ʾ
         */
        _doAnimate: function () {
            var msgboxContainer = this.$container,
                innerHeight = msgboxContainer.height();
            msgboxContainer.height(0).animate({height: innerHeight, opacity: 'show'}, 350);
        },
        /**
         * ���¼�
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
         * �϶�������
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
         *�����ı�ѡ��
         * @param flag  {boolean} �Ƿ����ѡ��
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
         * ����λ��
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
         * ͨ������
         */
        _commonOptions: {
            msg: "",                                  //��Ϣ
            modal: true,                              //�Ƿ�Ϊģ̬
            canClose: true,                           //�Ƿ�ɹر�
            autoClose: false,                         //�Ƿ��Զ��ر�
            animate: false,                           //�Ƿ񶯻���ʾ
            position: "center",                       //��Ϣ����ʾλ��
            customPos: {},                              //�Զ���λ��
            opacity: 0.5,                            //͸����
            title: "",                              //��Ϣ��ı���
            width: 330,                               //���
            height: 0,                               //�߶�
            onClose: null,                            //��Ϣ��ر�ʱ�Ļص�����
            dragAble: true,
            scrollBack:false,                         // �Ƿ���Ҫ��������
            dragClass: ".msgbox-titlebar"
        },
        /**
         * ��װoptions
         * @param msg {string} ��ʾ��Ϣ
         * @param onClose {function} �رջص�
         * @param options  {json}
         * @returns {�ϲ���options}
         */
        wrapOptions: function (msg, onClose, options) {
            var op = options || {};
            op.msg = msg;
            op.onClose = onClose;
            return op;
        },
        /**
         *�ϲ�options
         * @param defaultOp Ĭ������
         * @param options �û�����
         * @returns �ϲ��������
         */
        setOptions: function (defaultOp, options) {
            var cusOptions = $.extend({}, this._commonOptions, defaultOp, options || {});
            this.options = cusOptions;
            return  cusOptions;
        },
        /**
         * ��ʾmsgbox
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
         * ����msgbox
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
         * ����html
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
         * ����html
         */
        reBuildHtml: function () {
            var op = this.options;
            this.$container.unbind().replaceWith(this._template());
            this.$container = $("#" + this.buildId);
            if(op.boxType!=="message"){ //�����dialog��ͻ,�ŵ����
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
     * ���ݵ�����������class��ʽ
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
         * ����msgbox object
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

   // ����Ϊ�û��ӿ�
    /**
     *  alert ������
     * @param msg {String} ��ʾ����
     * @param onClose {function} �رջص�
     * @param options {json}��������
     */
    cui.alert = function (msg, onClose, options) {
        var defaultOptions = {
            title: "��ʾ",
            buttons: [ { name: "ȷ��",focus:true,_ok_:true } ],
            iconCls: "box-icon-alert",
            fontIcon: "&#xf05a;"
        };
        createObj(msg, onClose, options, defaultOptions, "alert");
    };
    /**
     *  warn ������
     * @param msg {String} ��ʾ����
     * @param onClose {function} �رջص�
     * @param options {json}��������
     */
    cui.warn = function (msg, onClose, options) {
        var defaultOptions = {
            title: "����",
            buttons: [ { name: "ȷ��" ,focus:true,_ok_:true } ],
            iconCls: "box-icon-warn",
            fontIcon: "&#xf06a;"
        };
        createObj(msg, onClose, options, defaultOptions, "warn");
    };
    /**
     *  success ��ʾ��
     * @param msg {String} ��ʾ����
     * @param onClose {function} �رջص�
     * @param options {json}��������
     */
    cui.success = function (msg, onClose, options) {
        var defaultOptions = {
            title: "��ʾ",
            buttons: [ { name: "ȷ��" ,focus:true ,_ok_:true} ],
            iconCls: "box-icon-success",
            fontIcon: "&#xf058;"
        };
        createObj(msg, onClose, options, defaultOptions, "success");
    };
    /**
     *  error ��ʾ��
     * @param msg {String} ��ʾ����
     * @param onClose {function} �رջص�
     * @param options {json}��������
     */
    cui.error = function (msg, onClose, options) {
        var defaultOptions = {
            title: "����",
            buttons: [ { name: "ȷ��",focus:true,_ok_:true  } ],
            iconCls: "box-icon-error",
            fontIcon: "&#xf057;"
        };
        createObj(msg, onClose, options, defaultOptions, "error");
    };
    /**
     *  message ��ʾ��
     * @param msg {String} ��ʾ����
     * @param type {String} ��ʾ����
     * @param options {json}��������
     */
    cui.message = function (msg, type, options) {
        var defaultOptions = {
            modal: false,
            canClose: false,
            autoClose: 1500,
            animate: true,
            width: 180,
            position: "rb",
            title: "��ʾ",
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
     *  confirm ��ʾ��
     * @param msg {String} ��ʾ����
     * @param options {json}��������
     */
    cui.confirm = function (msg, options) {
        var defaultOptions = {
            title: "ȷ��",
            iconCls: "box-icon-confirm",
            fontIcon: "&#xf059;"
        };
        options = options || {};
        options.buttons = options.buttons || [
            {
                name: "ȷ��",
                handler: options.onYes,
                focus:true,_ok_:true
            },
            {
                name: "ȡ��",
                handler: options.onNo,_cancel_:true
            }
        ];
        createObj(msg, null, options, defaultOptions, "confirm");

    };


})(window.comtop ? window.comtop.cQuery : window.jQuery, window);