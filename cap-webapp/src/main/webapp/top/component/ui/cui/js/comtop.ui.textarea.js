?;(function($, C) {
    C.UI.Textarea = C.UI.Base.extend({
        options: {
            uitype: 'Textarea',     //�������
            name: '',               //�����
            relation: '',           //ʣ��������ַ�����ʾ��Ԫ��ID
            value: '',              //Ĭ���ı�ֵ
            width: '300',         //�ı���������
            height: '57',        //�ı���߶�
            readonly: false,       //�Ƿ���ֻ��
            maxlength: -1,          //����������ַ�����-1��ʾ������
            emptytext: '',          //Ϊ��ʱ��ʾ������
            autoheight: false,      //�Ƿ����������ı����Զ�����
            maxheight: '',          //���ı����Զ�����ʱ�����������߶�
            textmode: false,        //�Ƿ�Ϊֻ��ģʽ
            on_change: null,           //ֵ�ı��¼�
            on_focus: null,            //��ý����¼�
            on_blur: null,             //��ʧ�����¼�
            on_keyup: null,            //keyup�¼�
            on_keydown: null           //keydown�¼�
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
            //����ʣ��������ַ�
            if (opts.relation !== '' && opts.maxlength !== -1) {
                this.$relation = $("#" + opts.relation);
                var reLength = opts.maxlength - C.String.getBytesLength(opts.value) < 0 ?
                    0 : opts.maxlength - C.String.getBytesLength(opts.value);
                this.$relation.text(reLength);
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

            //����ֻ��
            if (opts.readonly) {
                this.setReadOnly(true);
            }


            if(opts.maxlength > -1){
                this.$textarea.on("input propertychange", function(e){
                    self._textCounter();
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

                //�������ֵ����ִ�и߶ȼ���
                if(opts.value){
                    self._autoHeight();
                }
            }
        },

        /**
         * ���ÿ��
         * @param width ���
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
         * ���ø߶�
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
         * ����ֵ
         * @param value {String | Number} ֵ
         * @param isInit {Boolean} �Ƿ���������ã�������ò�����change
         */
        setValue: function(value, isInit) {
            var $textarea = this.$textarea,
                opts = this.options;
            value = (value == null || value == undefined) ? '' : value;
            $textarea.val(value);

            //�Ƿ���ʾemptyText
            if (value !== "") {
                this.$empty.html("");
            } else if (opts.emptytext !== "") {
                this.$empty.html(opts.emptytext);
            }
            //�������ַ���ʾ
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }

            //��������change�¼�
            if(isInit){
                this.onValid();
            }else{
                this._triggerHandler('change');
            }
            //��ִ��setValue�ӿ�ʱ���Զ��޸ĸ߶�
            var self = this;
            if(opts.autoheight){
                self._autoHeight();
            }
        },

        /**
         * ��ȡֵ
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
         * ���ÿ���������ֽ���
         * @param maxlength
         */
        setMaxLength: function(maxlength) {
            this.options.maxlength = maxlength;
            //�������ַ���ʾ
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
        },

        /**
         * ��ȡ�Ͽ���������ַ���
         * @return
         */
        _getRemainLength: function() {
            var reLength = this.options.maxlength - C.String.getBytesLength(this.getValue())
            return reLength < 0 ? 0 : reLength;
        },

        /**
         * ����ֻ������������
         * @param flag �Ƿ�ֻ��
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
         * ������
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
         * ֵ�ı��¼�
         * @param e
         * @private
         */
        _changeHander: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //�Ƿ���ʾemptyText
            if (this.getValue() !== "") {
                this.$textarea.removeClass('textarea_tipcolor');
            } else if (opts.emptytext !== "") {
                this.$empty.html(opts.emptytext);
            }
            //�������ַ���ʾ
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
            //��������change�¼�
            this._triggerHandler('change');
            //ִ���û��ص�
            this._customHandler('on_change', e);
        },

        /**
         * ��ý����¼�
         * @param e
         * @private
         */
        _focusHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) {
                //this.$textarea.blur();
                return false;
            }
            //�Ƴ���ʾ
            this._removeEmptyText(true);
            //�����ʽ
            this.$box.addClass('textarea_textareafocus');
            //ȥ��������ʾ
            this.onValid();
            //ִ���û��ص�
            this._customHandler('on_focus', e);
        },

        /**
         * ʧȥ�����¼�
         * @param e
         * @private
         */
        _blurHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //�����ʾ
            this._removeEmptyText(false);
            //ɾ����ʽ
            this.$box.removeClass('textarea_textareafocus');
            this._textCounter();

            //ʧ��ʱ��������ݲ�Ϊ��ʱ������change
            var value = this.getValue();
            if(value !== '' && value != null){
                this._triggerHandler('change');
            }

            //ִ���û��ص�
            this._customHandler('on_blur', e);
        },
        /**
         * keypress�¼�
         * @param e
         * @private
         */
        _keyPressHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            this._customHandler('on_keypress', e);
        },

        /**
         * keyup�¼�
         * @param e
         * @private
         */
        _keyupHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //������������ֽ���
            this._textCounter();
            //�������ַ���ʾ
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
            //ִ���û��ص�
            this._customHandler('on_keyup', e);
        },

        _keydownHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //������������ֽ���
            this._textCounter();
            //ִ���û��ص�
            this._customHandler('on_keydown', e);
        },

        /**
         * �û��¼�
         * @param type �¼�����
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
         * ��ʾ��������emptyText
         * @param isHide true/false�Ƿ���ʾ
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
         * �������볤��
         * @return {Boolean}
         * @private
         */
        _textCounter: function() {
            var opts = this.options;
            if (opts.maxlength > -1) {
                var currentLen = C.String.getBytesLength(this.getValue());
                if (currentLen > opts.maxlength) {
                    this.setValue(C.String.intercept(this.getValue(), opts.maxlength));
                    if (this.autoheight) {
                        this._autoHeight();
                    }
                }
            }
            return false;
        },

        /**
         * �Զ��߶�
         * @private
         */
        _autoHeight: function() {
            var self = this,
                opts = self.options,
                scrollHeight = 0,
                $textarea = self.$textarea;
            // ���߶ȣ��Զ���Ӧ
            if (! $textarea.data('origin-height')) {
                $textarea.data('origin-height', $textarea.outerHeight());
            }

            $textarea.height($textarea.data('origin-height'));

            //�Ƿ������߶�����
            if(opts.maxheight){
                //�жϸ߶��Ƿ��Ѿ��ﵽ���߶�
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
            /**
             * �����߶�
             * @private
             */
            function __resetHeight(){

                scrollHeight = $textarea[0].scrollHeight;
                if(opts.height - 10 <= scrollHeight){
                    if($textarea.height() !== scrollHeight){
                        $textarea.height(scrollHeight);
                    }
                }
            }
        },

        /**
         * ��֤ʧ��ʱ���������
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
            //����tip���ͣ�����
            $(self.tipPosition, opts.el).attr('tipType', 'error');
        },

        /**
         * ��֤�ɹ�ʱ���������
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
                //������ʾ
                var $cuiTip = cui.tipList[tipID];
                typeof $cuiTip !== 'undefined' && $cuiTip.hide();
            }
            opts.el.attr("tip", opts.tipTxt);
            //����tip���ͣ�����
            $(self.tipPosition, opts.el).attr('tipType', 'normal');
        }
    });
})(window.comtop.cQuery, window.comtop);