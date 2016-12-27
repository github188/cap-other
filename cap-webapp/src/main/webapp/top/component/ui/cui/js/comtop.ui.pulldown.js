/**
 * ģ��: CUI��� PullDown��
 * ����: ��ΰ3
 * ����: 13-10-9
 * ����: PullDown���������������SinglePullDown��MultiPullDown����̳С�
 * ��չģ����跽����
 * __initMode������׼����������Ⱦ�������
 * __renderTextMode������׼����������Ⱦ����ģʽ
 * __mouseUpHandler��������ص��¼���
 * __getText����ȡ���������
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
            empty_text: "��ѡ��",
            value: '',
            readonly: false,
            textmode: false,
            width: "200",
            height: "200",
            editable: true,
            on_select_data: null,
            //������Ⱦģʽ����ʱ����Ϊ"Single"��"Multi"��
            mode : "Single",
            datasource: null,
            //����Ϊ�̳в��ֲ������ݡ�
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
         * ��ʼ��������Base���Զ�����
         * @param {object} op �û�������δ��ʽ��
         * @param {object} customOpt �û��������Ѿ�δ��ʽ��
         * @private
         */
        _init: function (op, customOpt) {
            var opts = this.options;
            //�������PullDown�������̳�����������
            if (opts.uitype.toLocaleLowerCase() === "pulldown") {
                this._extendMode(customOpt);
            }
            //��ʼ���������
            this._initWidthAndHeight(
                (op.width || opts.width).toString(),
                (op.height || opts.height).toString()
            );
            this.$el = opts.el.addClass("pulldown-main").css("width", opts.width);
            this.ltIE8 = Browser.isIE6 || Browser.isIE7;
            if (Browser.isQM && this.ltIE8) {
                this.$el.addClass("pulldown-main-qm");
            }
            //��ռλ���е�����ת�Ƶ�һ���ڴ��е�Ԫ�����档
            this.templateBox = $(document.createElement("div")).html(this.$el.html());
            this.guid = C.guid();
            this.text = "";
            this.value = "";
            this.valueCache = "";
            this.isHide = true;//��ǰ�������Ƿ�Ϊ����״̬��

            this.top = window.location === window.parent.location;
            this.eqEmptyText = false; //�����б��Ƿ�����Ĭ��������ȵ�ѡ��
            this.rendered = false; //�Ƿ��Ѿ���Ⱦ���
            this.oldData = null;
            this.position = {};
        },
        /**
         * ��ԭ����ͨ�����Կ����̳�����ģ�����
         * ��uitype="PullDown"����ʱ���á�
         * @param {object} customOpt Base��������û����õĲ���
         * @private
         */
        _extendMode: function (customOpt) {
            var constr, proto, v,
                mode = this.options.mode;
            mode = mode.charAt(0).toUpperCase() + mode.slice(1).toLocaleLowerCase() + "PullDown";
            constr = C.UI[mode];
            if (constr) {
                proto = constr.prototype;
                //���Կ���
                for (v in proto) {
                    if (proto.hasOwnProperty(v) && !this[v]) {
                        this[v] = proto[v];
                    }
                }
                //�ϲ�����options
                //proto.options��ΪĬ�ϲ�����
                this.options = $.extend({}, proto.options, customOpt);
            } else {
                throw new Error("mode���Դ���");
            }
        },
        /**
         * �����û�����Ŀ�ߣ��Զ���"px"��
         * @param {string} width ���
         * @param {string} height �߶�
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
         * ����ģʽ����������ģʽ�²��ٵ���_create()��
         * ��Base�е���
         */
        setTextMode: function(){
            this._initData();
        },
        /**
         * ����Dom�ȣ���Base�е���
         * @private
         */
        _create: function () {
            //tip��������
            this.tipPosition = '.pulldown-inner';
            this.tipText = this.$el.attr("tip");
            //����DOM�Ͱ��¼�
            this._createDom();
            this._bindFocusBlurEvent();
            this._bindMouseEvent();
            this._bindKeyEvent();
            this._resetLayoutEvent();
            //��ʼ��Json���ݲ���Ⱦ�������
            this._initData();
            //����renadOnly
            this.setReadonly(this.options.readonly);
        },
        /**
         * ����������������ݵ�����domԪ��
         * ����DOM����Root������
         * @private
         */
        _createDom: function () {
            var opts = this.options,
                $el = this.$el,
                inputHtml,
                pullBox, iframe = "";
            //Ԫ�ؽṹ
            inputHtml = [
                '<div class="pulldown-inner pulldown-readonly">',
                    '<input class="pulldown-text" readonly="readonly" type="text" autocomplete="off" value="',
                        opts.empty_text, '" />',
                    '<a href="javascript:;" hidefocus="true" class="pulldown-btn pulldown-loading cui-icon">&#xf107;</a>',
                '</div>',
                '<input type="hidden" class="pulldown-hidden" name="', opts.name, '" />'
            ];
            $el.html(inputHtml.join(""));
            //���������������Box
            pullBox = $(document.createElement("div")).addClass("pulldown-box");
            if (Browser.isIE6) {
                //���IE6�£����������޷�����select��ǩflash���ݡ�
                iframe = '<iframe scrolling="no" frameborder="no"></iframe>';
            }
            pullBox.html(iframe + '<div class="pulldown-box-inner"></div>');
            $("body").append(pullBox);
            //Dom�����ڴ棬��ֹ��α���
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
         * ����򽹵��¼�
         * ��ȡ������ʾ������ʧȥ��������������
         * @private
         */
        _bindFocusBlurEvent: function () {
            var self = this;
            this.$text.on("focus", function () {
                if (self.inValid) {
                    self.onValid();
                }
                self._showBox();
            }).on("blur", function () {
                self._hideBox();
            });
        },
        /**
         * ��ʾ������һ����������ȡ����ʱ����
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
            //�����������λ�úͿ��
            this._setBoxLayout(this._setBoxPosition(rect));
            this.listenPosition();
            this._isEmpty();
            this.$inner.addClass("pulldown-inner-focus");
            if (!this.rendered) {
                //�첽����
                this._callDataSource();
            } else {
                //����չ��֮ǰ��ֵ���Ա�����onchange��
                //��¼�ϵ�״̬
                this.setOldData();
                //��ȡ�������ɫ�߿�
                if (this.__showBoxCallBack) {
                    this.__showBoxCallBack();
                }
            }
        },
        /**
         * �Ƴ�
         */
        destroy: function () {
            this.$box.remove();
            this.$el.remove();
        },
        /**
         * ���������λ��
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
         * �첽��������
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
         * �Ƿ��ǿ�ֵ,����������ֵ״̬�µ���ʾ����
         * @private
         */
        _isEmpty: function () {
            var $text = this.$text,
                val, isHide, emptyText;
            if (this.rendered && (this.eqEmptyText || this._isEqEmptyText())) {
                //��������������������ѡ����������ֱͬ�ӷ���
                $text.addClass("pulldown-text-value");
                return ;
            }
            val = $text.val();
            isHide = this.isHide;
            emptyText = this.options.empty_text;
            switch (val) {
                case "":
                    if (isHide) {//������������
                        $text.val(emptyText).removeClass("pulldown-text-value");
                    }
                    break;
                case emptyText:
                    if (!isHide) {//����������
                        $text.val("").addClass("pulldown-text-value");
                    }
                    break;
                default:
                    $text.addClass("pulldown-text-value");
            }
        },
        /**
         * �ж����������Ƿ���������empty_text��ͬ
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
            //ƥ��
            for (; i < len; i++) {
                if (emptyText === data[i][labelField]) {
                    this.eqEmptyText = true;
                    return true;
                }
            }
            return false;
        },
        /**
         * ������������ʾλ��left��topֵ
         * @returns {number} ��������ĸ߶�
         * @private
         */
        _setBoxPosition: function (rect) {
            var mainHeight = 28, borderWidth = (isQM ? 0 : 2), marginBottom = 10,
                //��ȡԪ�ص��������Ͻǵ����ꡣ
                left = rect.left + $(window).scrollLeft(),
                //����������Ӧ�еĸ߶ȣ���С23��
                height = this._getRealHeight(),
                totalHeight = height + mainHeight + borderWidth,
                //topֵ����Ԫ�ص�����չ��
                top = rect.top + $(window).scrollTop() + mainHeight;

            //���������ʾ�Ŀ׼Ҳ�������Ԫ�ص�����չ��
            if (top > Math.max($.page.height(), $.client.height()) - height - marginBottom &&
                top > height + mainHeight) {
                top -= totalHeight;
            }
            //IE6-IE7�� getBoundingClientRect��2px�Ĳ���
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
         * ����������Ӧ��Ҫ��ʾ�ĸ߶�
         * @returns {number} �����߶�
         * @private
         */
        _getRealHeight: function () {
            //���ݳ����������ø߶���ʾ������������������Ӧ��û������Ĭ����ʾ23px��
            return Math.min(this.height, this.$boxInner.css("height", "auto").outerHeight() || 28); //23Ϊ�иߡ�
        },
        /**
         * �����������Ⱥ͸߶�
         * @param {Number} height ����ĸ߶ȡ�
         * @private
         */
        _setBoxLayout: function (height) {
            this.$box.css({
                height: height,
                width: this.$el.width() - (isQM ? 0 : 2) // 2�����ұ߿���
            });
        },
        /**
         * ����������
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
                //����onchange
                this._triggerChange(false, false);
            } else {
                this._isEmpty();
            }
        },
        /**
         * ������һ��ѡ��ֵ
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
         * �ֶ�����onChange�¼�
         * ������base�е���֤����
         * @param {boolean} isInit
         * @param {boolean} isDatabind
         * @private
         */
        _triggerChange: function (isDatabind, isInit) {
            var on_select_data, on_change, opts;
            if (this.valueCache !== this.value && !isDatabind) {
                //��������͹ر�������ֵ�иı�, �Ϸ���������
                opts = this.options;
                on_select_data = opts.on_select_data;
                //���ǳ�ʼ��ʱ
                if (!isInit) {
                    //Base������֤�ú���
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
         * ��������ť�������������¼�
         * @private
         */
        _bindMouseEvent: function () {
            var self = this,
                $text = this.$text,
                relatedTarget,
                disableHideHandler = function () {
                    //�����Ժ� $textԪ�ش���blur��
                    //����hideAble = false��ֹ����������
                    self.hideAble = false;
                };
            //������ť����¼�
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
            //����������¼�
            this.$box.on("mouseout", function (event) {
                //���뵽ĳ��Ԫ��
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
         * �����İ����¼�
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
                        if (!opts.editable) { //��ֹIE����
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
         * ���ָı��¼�����
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
         * ��ʼ������
         * @private
         */
        _initData: function () {
            var opts = this.options,
                datasource, type,
                list = this.templateBox.find("a[value]"),
                len = list.length,
                i, item, valueField, labelField;
            //ͨ��ģ�洴��
            if (len) {
                valueField = opts.value_field;
                labelField = opts.label_field;
                datasource = [];
                //��ȡģ�壬ת��������
                for (i = 0; i < len; i++) {
                    item = datasource[i] = {};
                    item[valueField] = list.eq(i).attr("value");
                    item[labelField] = $.trim(list.eq(i).html());
                }
            }
            datasource = datasource || opts.datasource;
            type = $.type(datasource);
            if (type === "function") {
                //�첽���ó��ã����û������ֵ���Ȳ����ã����ʱ�ٵ��á�
                if(opts.value !== '' || opts.select !== -1) {
                    this._callDataSource();
                } else {
                    //����loading
                    this.$btn.removeClass("pulldown-loading");
                }
            } else if(type === "array"){
                this.setDatasource(datasource);
            } else {
                this.setDatasource([]);
            }
        },
        /**
         * ��ʼ���������ݺ��������ݡ� rendered�ж��Ƿ�����������
         * @param {Array} data
         * @returns {object} new C.UI.PullDown()
         */
        setDatasource: function (data) {
            var opts = this.options,
                rendered, select, value;
            //��������ģʽ
            this.data = $.extend(true, [], data);
            if (opts.textmode) {
                //����ģʽ,��Ⱦģ�������ģʽ
                this.__renderTextMode();
                this.$el.addClass("pulldown-textmode")
            } else {
                //����loading
                this.$btn.removeClass("pulldown-loading");
                //��Ⱦ����ģ��
                rendered = this.rendered;
                this.__initMode(rendered);
                if (rendered) { //��������
                    this._emptyStat();
                } else {
                    this.rendered = true;
                    //���ó�ʼֵ���ʼѡ��ڼ���
                    value = opts.value;
                    select = opts.select;
                    if (value) {
                        this.setValue(value, false, true);
                    } else if (select > -1 && select < data.length ) { //Ĭ��ѡ��ڼ���
                        this.setValue(data[select][opts.value_field], false, true);
                    }
                    // ������Ա༭
                    if (opts.editable) {
                        this.$text.removeAttr("readonly");
                    }
                }
                //����������û���������������������Ҫ�����������¼���߶ȡ�
                if (!this.isHide) {
                    this._setBoxLayout(this._setBoxPosition(this.$el[0].getBoundingClientRect()));
                }
            }
            return this;
        },
        /**
         * ͬ�ϣ���������
         * @param {Array} data
         * @returns {object} new C.UI.PullDown()
         */
        setDataSource : function (data) {
            return this.setDatasource(data);
        },
        /**
         * ��������ʱ�����״̬��
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
         * ��������
         * @param {object} data
         * @returns {object} new C.UI.PullDown()
         */
        resetDataSource: function (data) {
            this.setDatasource(data);
            return this;
        },
        /**
         * ������������֡��������ֵ�͵�ǰѡ�еĶ���
         * ��Ҫ��������ģ�����ݽ���ʱ����
         * ����{text: string, value: string, Data: object}
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
         * �������б�
         * @returns {object} new C.UI.PullDown()
         */
        open: function () {
            this.$text.focus();
            return this;
        },
        /**
         * ���ÿ��
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
         * ����ֵ
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
         * ��ȡֵ
         * @returns {string}
         */
        getValue: function () {
            return this.rendered ? this.value : this.options.value;
        },
        /**
         * ��ǰѡ������ݵ�����,��Ҫ������
         * @returns {null|Array|object}
         */
        getData: function () {
            var selectData = this.selectData,
                type = $.type(selectData);
            switch (type) {
                case "array": //��ѡ
                    return $.extend(true, [], this.selectData);
                case "object": //��ѡ
                    return $.extend(true, {}, this.selectData);
                default :
                    return null;
            }
        },
        /**
         * ��ȡ��ʾֵ
         * @returns ����ģ�鶨
         */
        getText: function () {
            return this.__getText();
        },
        /**
         * ����ֻ��
         * @param flag
         * @returns {object} new C.UI.PullDown()
         */
        setReadonly: function (flag) {
            if (flag === true) {
                this.readonly = true;
                this.$inner.addClass("pulldown-readonly");
                this.$text.attr("disabled", "disabled");
                this.$text.blur();
            } else if (flag === false) {
                this.readonly = false;
                this.$inner.removeClass("pulldown-readonly");
                this.$text.removeAttr("disabled");
            }
            return this;
        },
        /**
         * ���ÿɷ񱻱༭
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
         * ��֤ʧ��ʱ���������
         * @param {object} obj
         * @param {string} message
         */
        onInValid: function(obj, message) {
            this.$inner.addClass("pulldown-error");
            this.$el.attr("tip", message);
            //����tip���ͣ�����
            $(this.tipPosition, this.options.el).attr('tipType', 'error');
            this.inValid = true;
        },

        /**
         * ��֤�ɹ�ʱ���������
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
            //����tip���ͣ���ȷ
            $(this.tipPosition, this.options.el).attr('tipType', 'normal');
            this.inValid = false;
        }
    };
}());
})(window.comtop);