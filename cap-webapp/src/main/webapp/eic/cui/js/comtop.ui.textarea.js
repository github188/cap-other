;(function($, C) {
    C.UI.Textarea = C.UI.Base.extend({
        options: {
            uitype: 'Textarea',     //???????
            name: '',               //?????
            relation: '',           //?????????????????????ID
            value: '',              //???????
            width: '300',         //???????????
            height: '57',        //???????
            readonly: false,       //????????
            maxlength: -1,          //??????????????-1?????????
            emptytext: '',          //?????????????
            autoheight: false,      //???????????????????????
            maxheight: '',          //????????????????????????????
            textmode: false,        //?????????
            on_change: null,           //???????
            on_focus: null,            //?????????
            on_blur: null,             //??????????
            on_keyup: null,            //keyup???
            on_keydown: null           //keydown???
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
        },

        _create: function() {
            var self = this,
                opts = self.options;
            this.$textarea = $('#' + opts.id);

            //???????????????
            if (opts.relation != '' && opts.maxlength != -1) {
                    this.$relation = $("#" + opts.relation);
                    var reLength = opts.maxlength - C.String.getBytesLength(opts.value) < 0 ?
                        0 : opts.maxlength - C.String.getBytesLength(opts.value)
                    this.$relation.text(reLength);
            }

            if (opts.emptytext !== "" && opts.value === "") {
                this.$textarea.val(opts.emptytext);
                this.$textarea.addClass('textarea_tipcolor');
            }
            
            if (opts.height === '') {
                opts.height = "51";
            }
            this._setHeight(opts.height);
            
            if (opts.width === '') {
                opts.width = "300";
            }
            this.setWidth(opts.width);

            //???????
            if (opts.readonly) {
                this.setReadOnly(true);
            }

            if (opts.autoheight) {
                this.$textarea.css({
                    overflow: 'hidden'
                });
                this.$textarea.bind('propertychange', function(e) {
                    //?§Ø???????????????????????????????
                    if (!e.originalEvent || e.originalEvent.propertyName != 'value') return;
                    self._autoHeight();
                });
                this.$textarea.bind('input change', function() {
                    self._autoHeight();
                });
            }
            if(opts.maxlength > -1){
                this.$textarea.on("input propertychange", function(e){
                    self._textCounter();
                });
            }
            this.$textarea.on("keypress",function(e){
                self._keyPressHandler(e);
            });

        },

        /**
         * ??????
         * @param width ???
         */
        setWidth: function(width) {
            width = width + "";
            if (C.Browser.isQM || width.indexOf("%") != -1) {
                this.$textarea.css({
                    width: width
                });
            } else {
                this.$textarea.css({
                    width: parseFloat(width) - 7 + "px"
                });
            }
        },

        /**
         * ??????
         * @param height ???
         */
        _setHeight: function(height) {
            height = height + "";
            if (C.Browser.isQM || height.indexOf("%") != -1) {
                this.$textarea.css({
                    height: height
                });
            } else {
                this.$textarea.css({
                    height: parseFloat(height) - 6 + "px"
                });
            }
        },

        /**
         * ?????
         * @param value {String | Number} ?
         * @param isInit {Boolean} ???????????????????¨°?????change
         */
        setValue: function(value, isInit) {
            var $textarea = this.$textarea,
                opts = this.options;
            value = (value == null || value == undefined) ? '' : value;
            $textarea.val(value);

            //??????emptyText
            if (value != "") {
                $textarea.removeClass('textarea_tipcolor');
            } else if (opts.emptytext != "") {
                $textarea.val(opts.emptytext);
                $textarea.addClass("textarea_tipcolor");
            }
            //????????????
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }

            //????????change???
            if(isInit){
                this.onValid();
            }else{
                this._triggerHandler('change');
            }
        },

        /**
         * ????
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
         * ?????????????????
         * @param maxlength
         */
        setMaxLength: function(maxlength) {
            this.options.maxlength = maxlength;
            //????????????
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
        },
        
        /**
         * ??????????????????
         * @return 
         */
        _getRemainLength: function() {
            var reLength = this.options.maxlength - C.String.getBytesLength(this.getValue())
            return reLength < 0 ? 0 : reLength;
        },

        /**
         * ?????????????????
         * @param flag ??????
         */
        setReadOnly: function(flag) {
            this.setReadonly(flag);
        },
        setReadonly: function(flag){
            var opts = this.options;
            opts.readonly = flag;
            this.$textarea.attr('readonly', flag);
            if (flag) {
                this.$textarea.addClass('textarea_garybg');
                this._removeEmptyText(true);
            } else {
                this.$textarea.removeClass('textarea_garybg');
                this._removeEmptyText(false);
            }
        },

        /**
         * ??????
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
         * ???????
         * @param e
         * @private
         */
        _changeHander: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //??????emptyText
            if (this.getValue() != "") {
                this.$textarea.removeClass('textarea_tipcolor');
            } else if (opts.emptytext != "") {
                this.$textarea.val(opts.emptytext);
                this.$textarea.addClass("textarea_tipcolor");
            }
            //????????????
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
            //????????change???
            this._triggerHandler('change');
            //?????????
            this._customHandler('on_change', e);
        },

        /**
         * ?????????
         * @param e
         * @private
         */
        _focusHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) {
                this.$textarea.blur();
                return false;
            }
            //??????
            this._removeEmptyText(true);
            //??????
            this.$textarea.addClass('textarea_textareafocus');
            //??????????
            this.onValid();
            //?????????
            this._customHandler('on_focus', e);
        },

        /**
         * ?????????
         * @param e
         * @private
         */
        _blurHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //??????
            this._removeEmptyText(false);
            //??????
            this.$textarea.removeClass('textarea_textareafocus');
            this._textCounter();
          //  clearInterval(this._mousedownListener);

            //????????????????????????change
            var value = this.getValue();
            if(value !== '' && value != null){
                this._triggerHandler('change');
            }

            //?????????
            this._customHandler('on_blur', e);
        },
        /**
         * keypress???
         * @param e
         * @private
         */
        _keyPressHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //????????????????
            //this._textCounter();
            //?????????
            if(opts.maxlength > -1){
                var len =C.String.getBytesLength(this.getValue());
                if(len  >= opts.maxlength && e.which > 14 && !e.ctrlKey ) {
                    e.preventDefault();
                }
            }
            this._customHandler('on_keypress', e);
        },

        /**
         * keyup???
         * @param e
         * @private
         */
        _keyupHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //????????????????
            this._textCounter();
            //????????????
            if (this.$relation) {
                this.$relation.text(this._getRemainLength());
            }
            //?????????
            this._customHandler('on_keyup', e);
        },

        _keydownHandler: function(e) {
            var opts = this.options;
            if (opts.readonly) return false;
            //????????????????
            this._textCounter();
            //???????????? TODO ??¦Ä????????????????????????????
//            if (this.$relation) {
//                this.$relation.text(this._getRemainLength());
//            }
            //?????????
            this._customHandler('on_keydown', e);
        },

        /**
         * ??????
         * @param type ??????? 
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
         * ???????????emptyText
         * @param isHide true/false??????
         * @private
         */
        _removeEmptyText: function(isHide) {
            var emptyText = this.options.emptytext;
            var areaValue = this.getValue();
            if (emptyText === '' || areaValue.length != 0) return;
            if (isHide) {
                this.$textarea.val("");
                this.$textarea.removeClass('textarea_tipcolor');
            } else {
                this.$textarea.val(emptyText);
                this.$textarea.addClass('textarea_tipcolor');
            }
        },

        /**
         * ??????????
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
         * ??????
         * @private
         */
        _autoHeight: function() {
            var height, padding = 0;
            var textarea = this.$textarea[0];
            var opts = this.options;
            style = textarea.style;

            //?§Ø??????????
            if (textarea._length === textarea.value.length) return;
            textarea._length = textarea.value.length;

            if ($.browser.msie && !C.Browser.isQM) {
                padding = parseInt(this.$textarea.css('paddingTop')) +
                    parseInt(this.$textarea.css('paddingBottom'));
            }

            this.$textarea.css({
                height: opts.height
            });

            var scrollHeight = textarea.scrollHeight;
            if ($.browser.mozilla) {
                if (C.Browser.isQM) {
                    scrollHeight = scrollHeight + 6; //??????????????
                }
            } else if (window.navigator.userAgent.indexOf("Chrome") !== -1){
                if (C.Browser.isQM) {
                    scrollHeight = scrollHeight + 2;  //????????
                } else {
                    scrollHeight = scrollHeight - 4;  //???????
                }
            }

            if (scrollHeight > parseFloat(opts.height)) {
                if (opts.maxheight != '' && scrollHeight > parseFloat(opts.maxheight)) {
//                    height = parseFloat(opts.maxheight) - padding;
                    height = C.Browser.isQM ?
                        (parseFloat(opts.maxheight) + 6) : parseFloat(opts.maxheight);
                    style.overflowY = 'auto';
                } else {
                    height = scrollHeight - padding;
                    style.overflowY = 'hidden';
                }
                style.height = height + 'px';
            }

        },

        /**
         * ????????????????
         * @param obj
         * @param message
         */
        onInValid: function(obj, message) {
            var self = this,
                opts = self.options;
            self.$textarea.addClass("textarea_invalid");
            if (opts.tipTxt == null) {
                opts.tipTxt = opts.el.attr("tip") || "";
            }
            opts.el.attr("tip", message);
        },

        /**
         * ????????????????
         * @param obj
         */
        onValid: function(obj) {
            var self = this,
                opts = self.options,
                tipID = $(self.tipPosition, opts.el).attr('tipID');
            self.$textarea.removeClass("textarea_invalid");
            if (opts.tipTxt == null) {
                opts.tipTxt = opts.el.attr("tip") || "";
            }
            if(tipID !== undefined){
                //???????
                var $cuiTip = cui.tipList[tipID];
                typeof $cuiTip !== 'undefined' && $cuiTip.hide();
            }
            opts.el.attr("tip", opts.tipTxt);
        }
    });
})(window.comtop.cQuery, window.comtop);