/**
 * ???: CUI??? PullDown??
 * ????: ???3
 * ????: 13-10-9
 * ????: PullDown???????????SinglePullDown??MultiPullDown?????§³?
 * ????????õÕ????
 * __initMode????????????????????????
 * __renderTextMode???????????????????????
 * __mouseUpHandler???????????????
 * __getText??????????????
 */
;(function(C){
"use strict";
var $ = C.cQuery,
    Browser = C.Browser;
C.UI.PullDown = C.UI.Base.extend(function () {
    return {
        options : {
            uitype : "PullDown",
            empty_text: "?????",
            value: '',
            readonly: false,
            textmode: false,
            width: "200",
            height: "200",
            editable: true,
            on_select_data: null,
            //???????????????????"Single"??"Multi"??
            mode : "Single",
            datasource: null,
            //???????§Ó???????????
            name : "",
            select: -1,
            must_exist: true,
            auto_complete: false,
            value_field : "id",
            label_field : "text",
            filter_fields : [],
            on_filter_data: null,
            on_filter: null
        },
        /**
         * ?????????Base?????????
         * @param {object} op ???????¦Ä?????
         * @param {object} customOpt ??????????¦Ä?????
         * @private
         */
        _init: function (op, customOpt) {
            var opts = this.options;
            //???????PullDown???????????????????
            if (opts.uitype.toLocaleLowerCase() === "pulldown") {
                this._extendMode(customOpt);
            }
            //????????????
            this._initWidthAndHeight(
                (op.width || opts.width).toString(),
                (op.height || opts.height).toString()
            );
            this.$el = opts.el.addClass("pulldown-main").css("width", opts.width);
            //???¦Ë???§Ö????????????????§Ö???????µµ
            this.templateBox = $(document.createElement("div")).html(this.$el.html());
            this.guid = C.guid();
            this.text = "";
            this.value = "";
            this.valueCache = "";
            this.isHide = true;//?????????????????????
            this.ltIE8 = Browser.isIE6 || Browser.isIE7;
            this.top = window.location === window.parent.location;
            this.eqEmptyText = false; //?????§Ò??????????????????????
            this.rendered = false; //????????????
        },
        /**
         * ??????????????????????????????
         * ??uitype="PullDown"????????¨¢?
         * @param {object} customOpt Base?????????????????
         * @private
         */
        _extendMode: function (customOpt) {
            var constr, proto, v,
                mode = this.options.mode;
            mode = mode.charAt(0).toUpperCase() + mode.slice(1).toLocaleLowerCase() + "PullDown";
            constr = C.UI[mode];
            if (constr) {
                proto = constr.prototype;
                //???????
                for (v in proto) {
                    if (proto.hasOwnProperty(v) && !this[v]) {
                        this[v] = proto[v];
                    }
                }
                //???????options
                //proto.options?????????
                this.options = $.extend({}, proto.options, customOpt);
            } else {
                throw new Error("mode???????");
            }
        },
        /**
         * ????????????????????"px"??
         * @param {string} width ???
         * @param {string} height ???
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
         * ????????????????????????_create()??
         * ??Base?§Ö???
         */
        setTextMode: function(){
            this._initData();
        },
        /**
         * ????Dom?????Base?§Ö???
         * @private
         */
        _create: function () {
            //tip????????
            this.tipPosition = '.pulldown-inner';
            this.tipText = this.$el.attr("tip");
            //????DOM??????
            this._createDom();
            this._bindFocusBlurEvent();
            this._bindMouseEvent();
            this._bindKeyEvent();
            this._resetLayoutEvent();
            //?????Json??????????????
            this._initData();
            //????renadOnly
            this.setReadonly(this.options.readonly);
        },
        /**
         * ??????????????????????dom???
         * ????DOM????Root??????
         * @private
         */
        _createDom: function () {
            var opts = this.options,
                $el = this.$el,
                inputHtml,
                pullBox, iframe = "";
            //????
            inputHtml = [
                '<div class="pulldown-inner pulldown-readonly">',
                    '<input class="pulldown-text" readonly="readonly" type="text" autocomplete="off" value="',
                        opts.empty_text, '" />',
                '</div>',
                '<span class="pulldown-btn pulldown-loading"></span>',
                '<input type="hidden" class="pulldown-hidden" name="', opts.name, '" />'
            ];
            $el.html(inputHtml.join(""));
            //???????????????Box
            pullBox = $(document.createElement("div")).addClass("pulldown-box");
            if (Browser.isIE6) {
                //???IE6??????????????????select???flash?????
                iframe = '<iframe scrolling="no" frameborder="no"></iframe>';
            }
            pullBox.html(iframe + '<div class="pulldown-box-inner"></div>');
            $("body").append(pullBox);
            //Dom??????—¨?????¦Á???
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
         * ?????????
         * ????????????????????????????????
         * @private
         */
        _bindFocusBlurEvent: function () {
            var self = this;
            this.$text.on("focus", function () {
                self._showBox();
            }).on("blur", function () {
                self._hideBox();
            });
        },
        /**
         * ??????????????????????????????
         * @private
         */
        _showBox: function () {
            if (this.isHide === false) {
                return;
            }
            this.isHide = false;
            //???????????¦Ë?¨²???
            this._setBoxLayout(this._setBoxPosition());
            this._isEmpty();
            if (!this.rendered) {
                //??????
                this._callDataSource();
            } else {
                //?????????????????????onchange??
                this.valueCache = this.value;
                //??????????????
                this.$inner.addClass("pulldown-inner-focus");
                if (this.__showBoxCallBack) {
                    this.__showBoxCallBack();
                }
            }
        },
        /**
         * ?????????
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
         * ???????,???????????????????????
         * @private
         */
        _isEmpty: function () {
            var $text = this.$text,
                val, isHide, emptyText;
            if (this.rendered && (this.eqEmptyText || this._isEqEmptyText())) {
                //??????????????????????????????????????
                $text.addClass("pulldown-text-value");
                return ;
            }
            val = $text.val();
            isHide = this.isHide;
            emptyText = this.options.empty_text;
            switch (val) {
                case "":
                    if (isHide) {//????????????
                        $text.val(emptyText).removeClass("pulldown-text-value");
                    }
                    break;
                case emptyText:
                    if (!isHide) {//??????????
                        $text.val("").addClass("pulldown-text-value");
                    }
                    break;
                default:
                    $text.addClass("pulldown-text-value");
            }
        },
        /**
         * ?§Ø????????????????????empty_text???
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
            //???
            for (; i < len; i++) {
                if (emptyText === data[i][labelField]) {
                    this.eqEmptyText = true;
                    return true;
                }
            }
            return false;
        },
        /**
         * ?????????????¦Ë??left??top?
         * @returns {number} ???????????
         * @private
         */
        _setBoxPosition: function () {
            var mainHeight = 23, borderWidth = 2, marginBottom = 10,
                //????????????????????
                rect = this.$el[0].getBoundingClientRect(),
                left = rect.left + $(window).scrollLeft(),
                //????????????§Ö??????§³23??
                height = this._getRealHeight(),
                totalHeight = height + mainHeight + borderWidth,
                //top????????????????
                top = rect.top + $(window).scrollTop() + mainHeight;
            //????????????????????????????????
            if (top > Math.max($.page.height(), $.client.height()) - height - marginBottom &&
                top > height + mainHeight) {
                top -= totalHeight;
            }
            //IE6-IE7?? getBoundingClientRect??2px?????
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
         * ?????????????????????
         * @returns {number} ???????
         * @private
         */
        _getRealHeight: function () {
            //??????????????????????????????????????????????????????23px??
            return Math.min(this.height, this.$boxInner.css("height", "auto").outerHeight() || 23); //23??§Ú??
        },
        /**
         * ???????????????
         * @param {Number} height ????????
         * @private
         */
        _setBoxLayout: function (height) {
            this.$box.css({
                height: height,
                width: this.$el.width() - 2 // 2??????????
            });
        },
        /**
         * ??????????
         * @private
         */
        _hideBox: function () {
            if (this.hideAble === false || this.isHide === true) {
                this.$text.focus();
                return;
            }
            this.isHide = true;
            this.$box.css("top", "-999999px");
            this.$inner.removeClass("pulldown-inner-focus");
            if (this.rendered) {
                if (this.__hideBoxCallBack) {
                    this.__hideBoxCallBack();
                }
                //????onchange
                this._triggerChange();
            } else {
                this._isEmpty();
            }
        },
        /**
         * ???????onChange???
         * ??????base?§Ö????????
         * @private
         */
        _triggerChange: function () {
            var on_select_data;
            if (this.valueCache !== this.value) {
                //???????????????????§Ú??
                on_select_data = this.options.on_select_data;
                if (typeof on_select_data === "function") {
                    on_select_data.call(this, this.selectData);
                }
                //Base????????¨²???
                this._triggerHandler('change');
            }
        },
        /**
         * ????????????????????????
         * @private
         */
        _bindMouseEvent: function () {
            var self = this,
                $text = this.$text,
                relatedTarget,
                disableHideHandler = function (event) {
                    //??????? $text??????blur??
                    //????hideAble = false?????????????
                    self.hideAble = false;
                };
            //?????????????
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
            //????????????
            this.$box.on("mouseout", function (event) {
                //??????????
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
         * ????????????
         * @private
         */
        _bindKeyEvent: function() {
            var self = this,
                keyCode,
                editable = this.options.editable;
            this.$text.on("keydown", function (event) {
                keyCode = event.keyCode;
                switch(keyCode) {
                    case 8:
                        if (!editable) { //???IE????
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
                if (editable && self.__keyUpHandler) {
                    self.__keyUpHandler(event);
                }
            });
        },
        /**
         * ?????????????
         * @private
         */
        _resetLayoutEvent: function () {
            var self = this;
            $(window).on("resize scroll", function () {
                if (!self.isHide) {
                    self._setBoxPosition();
                }
            });
        },
        /**
         * ????????
         * @private
         */
        _initData: function () {
            var opts = this.options,
                datasource, type,
                list = this.templateBox.find("a[value]"),
                len = list.length,
                i, item, valueField, labelField;
            //?????›¯??
            if (len) {
                valueField = opts.value_field;
                labelField = opts.label_field;
                datasource = [];
                //?????ÈÉ????????
                for (i = 0; i < len; i++) {
                    item = datasource[i] = {};
                    item[valueField] = list.eq(i).attr("value");
                    item[labelField] = $.trim(list.eq(i).html());
                }
            }
            datasource = datasource || opts.datasource;
            type = $.type(datasource);
            if (type === "function") {
                //?????¨®?????????????????????????????????¨¢?
                if(opts.value !== '' || opts.select !== -1) {
                    this._callDataSource();
                } else {
                    //????loading
                    this.$btn.removeClass("pulldown-loading");
                }
            } else if(type === "array"){
                this.setDatasource(datasource);
            } else {
                this.setDatasource([]);
            }
        },
        /**
         * ????????????????????? rendered?§Ø?????????????
         * @param {Array} data
         * @returns {object} new C.UI.PullDown()
         */
        setDatasource: function (data) {
            var opts = this.options,
                rendered, select, value;
            //??????????
            this.data = $.extend(true, [], data);
            if (opts.textmode) {
                //??????,?????????????
                this.__renderTextMode();
            } else {
                //????loading
                this.$btn.removeClass("pulldown-loading");
                //??????????
                rendered = this.rendered;
                this.__initMode(rendered);
                if (rendered) { //???????
                    this._emptyStat();
                } else {
                    this.rendered = true;
                    //???¨®??????????????
                    value = opts.value;
                    select = opts.select;
                    if (value) {
                        this.setValue(value);
                    } else if (select > -1 && select < data.length ) { //??????????
                        this.setValue(data[select][opts.value_field]);
                    }
                    // ???????
                    if (opts.editable) {
                        this.$text.removeAttr("readonly");
                    }
                }
                //???????????????????????????????????????????????
                if (!this.isHide) {
                    this._setBoxLayout(this._setBoxPosition());
                }
            }
            return this;
        },
        /**
         * ????????????
         * @param {Array} data
         * @returns {object} new C.UI.PullDown()
         */
        setDataSource : function (data) {
            return this.setDatasource(data);
        },
        /**
         * ?????????????????
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
         * ???????
         * @param {object} data
         * @returns {object} new C.UI.PullDown()
         */
        resetDataSource: function (data) {
            this.setDatasource(data);
            return this;
        },
        /**
         * ????????????????????????????§Ö????
         * ?????????????????????????
         * ????{text: string, value: string, Data: object}
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
         * ???????§Ò?
         * @returns {object} new C.UI.PullDown()
         */
        open: function () {
            this.$text.focus();
            return this;
        },
        /**
         * ??????
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
         * ?????
         * @param {string} value
         * @returns {object} new C.UI.PullDown()
         * @param isInit
         */
        setValue: function (value, isInit) {
            if (!this.rendered) {
                this.options.value = value;
                this.$hide.val(value);
                this._callDataSource();
            } else {
                this.valueCache = this.value;
                this.__setValue(
                    typeof value === "undefined" ? this.options.value : value
                );
                if (!isInit) {
                    this._triggerChange();
                }
            }
            return this;
        },
        /**
         * ????
         * @returns {string}
         */
        getValue: function () {
            return this.rendered ? this.value : this.options.value;
        },
        /**
         * ???????????????,?????????
         * @returns {null|Array|object}
         */
        getData: function () {
            var selectData = this.selectData,
                type = $.type(selectData);
            switch (type) {
                case "array": //???
                    return $.extend(true, [], this.selectData);
                case "object": //???
                    return $.extend(true, {}, this.selectData);
                default :
                    return null;
            }
        },
        /**
         * ???????
         * @returns ?????úE
         */
        getText: function () {
            return this.__getText();
        },
        /**
         * ???????
         * @param flag
         * @returns {object} new C.UI.PullDown()
         */
        setReadonly: function (flag) {
            if (flag === true) {
                this.$text.blur();
                this.readonly = true;
                this.$inner.addClass("pulldown-readonly");
                this.$text.attr("disabled", "disabled");
            } else if (flag === false) {
                this.readonly = false;
                this.$inner.removeClass("pulldown-readonly");
                this.$text.removeAttr("disabled");
            }
            return this;
        },
        /**
         * ????????????????
         * @param {object} obj
         * @param {string} message
         */
        onInValid: function(obj, message) {
            this.$inner.addClass("pulldown-error");
            this.$el.attr("tip", message);
        },

        /**
         * ????????????????
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
        }
    };
}());
})(window.comtop);