/**
 * 2013?? 8?? 9?? By CUI???-???
 * RadioGroup?????????§Õ
 * checkboxGroup????????????
 */
(function (C) {
    "use strict";
    var $ = C.cQuery;
    C.UI.RadioGroup = C.UI.Base.extend({
        options: {
            uitype: "RadioGroup",
            name: "",
            radio_list: [],
            direction: "horizontal",
            value: '',
            readonly: false,
            color: "#f60",
            br: [],
            border: false,
            textmode: false,
            on_change : null
        },
        /**
         * ????????
         * @private
         */
        _init: function () {
            var opts = this.options,
                value = opts.value,
                type =  this._setType();
            //config
            this.textmode = opts.textmode;
            this.guid = type + "group-" + C.guid() + "-";
            this.tipPosition = '.' + type + 'group-inner';
            //dom
            this.el = opts.el.addClass(this.type + "-group");
            this.tip_text = this.el.attr("tip");
            this.inputs = null;
            this.labels = null;
            //data
            this.data = null;
            if (typeof value === "string" && value !== "") {
                this.value = [String(value)];
            } else if ($.type(value) === "array") {
                this.value = value;
            } else {
                this.value = [];
            }
            this.first = true;
            this.values = [];
            this.texts = [];
            this.colors = [];
            this.size = 0;
            this.readonly_list = {};
            if (opts.textmode) {
                this._create();
            }
        },
        /**
         * ????????,??????????
         * @private
         */
        _setType: function () {
            this.type = "radio";
            return "radio";
        },
        /**
         * ??????
         * @private
         */
        _create: function () {
            if (this.create) {
                return ;
            }
            var type = this.type,
                list = this.options[type + "_list"],
                list_type = $.type(list),
                el = this.el,
                inner = document.createElement("div");
            this.inner = $(inner).html(el.html());
            this.inputs = this.inner.find("input");
            this.size = this.inputs.length;
            inner.className = type + "group-inner";
            if (this.options.border) {
                this.inner.addClass(type + "group-border");
            }
            el.html(inner);
            //?§Ø????
            if (list_type === "function") {//???????
                list(this);
            } else if (list_type === "array" && !this.size) {//Json
                this._setDatasource(list);
            } else if (this.size) {
                this._setDatasource(this._initData());
            } else {//??????
                throw new Error(type + "_list's type not is a array or a function.");
            }
            this.create = true;
        },
        /**
         * ????????
         * @private
         */
        _initData: function () {
            var inputs = this.inputs,
                length = this.size,
                i,inputs_i,value_i, data_i, readonly_i, next_text,
                not_val = 0,
                new_data = [];
            for (i = 0; i < length; i++) {
                inputs_i = inputs.eq(i);
                value_i = inputs_i.attr("value");
                next_text = inputs_i[0].nextSibling;
                if (value_i) {
                    data_i = {
                        text :inputs_i.attr("text") || (next_text.nodeType === 3 ? next_text.nodeValue.replace(/\s*|\n*/g, "") : ""),
                        value : value_i
                    };
                    readonly_i = inputs_i.attr("readonly");
                    if (readonly_i && (readonly_i === "true" || readonly_i.toLowerCase() === "readonly")) {
                        data_i.readonly = "readonly";
                    }
                    if (inputs_i.attr("color")) {
                        data_i.color = inputs_i.attr("color");
                    }
                    new_data.push(data_i);
                } else {
                    not_val++;
                }
            }
            this.size -= not_val;
            return new_data;
        },
        /**
         * ???????
         * @param data
         */
        _setDatasource: function (data) {//?????????
            if ($.type(data) !== "array") {
                throw new Error("data's type not is a array.");
            } else {
                this.data = data;
                this.size = data.length;
                this._renderHtml();
            }
            this.first = false;
        },
        setDatasource: function (data) {
            if (!this.first) {
                this.value = [];
            }
            this.values = [];
            this.texts = [];
            this.readonly_list = {};
            this.colors = [];
            this._setDatasource(data);
        },
        setDataSource : function (data) {
            return this.setDatasource(data);
        },
        /**
         * ???HTML???
         */
        _renderHtml: function () {
            var opts = this.options,
                data = this.data,
                name = opts.name,
                readonly = opts.readonly,
                texts = this.texts,
                values = this.values,
                colors = this.colors,
                length = this.size,
                direction = opts.direction,
                br = opts.br,
                br_len = br.length,
                br_position = {},
                type = this.type,
                guid = this.guid,
                i,j,
                html = [],
                value_i, text_i,
                readonly_list = this.readonly_list;
            //???????¦Ë??
            if (br_len) {
                for (j = br_len; j--;) {
                    br_position[br[j]] = true;
                }
            }
            //??????
            for (i = 0; i < length; i ++) {
                if (i !== 0 && direction === "vertical" || br_position[i]) {
                    html.push ('<br />');
                }
                value_i = values[i] = data[i].value;
                text_i = texts[i] = data[i].text;
                if (readonly || data[i].readonly) {
                    readonly_list[value_i] = i;
                }
                colors[i] = data[i].color;
                html.push(
                    '<label for="', guid, i,'">',
                    '<input id="', guid, i, '" type="', type, '" name="', name, '" value="', value_i, '" index="', i, '" />',
                    text_i,
                    '</label>'
                );
            }
            this.inner.html(html.join(""));
            this.inner = this.el.children().eq(0);
            this.labels = this.el.find("label");
            this.inputs = this.el.find("input");
            this._inputsAction();
        },
        /**
         * ?????????????
         */
        _renderText: function () {
            var text = this.getText();
            if (text !== null) {
                this.inner.html(text.toString());
            } else {
                this.inner.html("");
            }
        },
        setTextMode: function(){},
        /**
         * input????
         * @private
         */
        _inputsAction: function () {
            //??????
            this._initValue();
            //?????
            this._setValue(undefined);
            if (this.options.textmode) {
                this._renderText();
            }
            //?????
            this._clickEventBind();
            //???????
            this._setReadonly();
        },
        /**
         * ??????
         * @private
         */
        _initValue: function (value) {
            value = (value || this.value).sort();
            var val_len = value.length,
                values = this.values,
                length = this.size,
                i, j,
                new_value = [];
            for (i = 0; i < val_len; i++) {
                for (j = 0; j < length; j++) {
                    if (values[j] === value[i] + "") {
                        new_value.push(values[j]);
                        break;
                    }
                }
            }
            this.value = $.unique(new_value);
        },
        /**
         * change???
         * @private
         */
        _changeHander: function () {
            var change_hander = this.options.on_change;
            if (typeof change_hander === "function") {
                change_hander(this.getValue());
            }
            this._triggerHandler('change');
        },
        /**
         * ????
         * @private
         */
        getValue: function () {
            return this._getEle(this.values);
        },
        /**
         *?????§Ö?????
         */
        getText: function () {
            return this._getEle(this.texts);
        },
        /**
         * ?????????????????
         * @private
         */
        _getEle: function (arr) {
            var value = this.value.sort(function (a, b) {
                    return a > b ? 1 : -1;
                }) ,
                val_len = value.length,
                index = this.size,
                type = this.type,
                i, new_arr = [], new_str;
            for (i = 0; i < val_len; i++) {
                index = this._valueToIndex(value[i]);
                if (!isNaN(index)) {
                    new_arr.push(arr[index]);
                    new_str = arr[index];
                }
            }
            if (type === "radio") {
                return new_str || null;
            }
            return new_arr.length ? new_arr : null;
        },
        /**
         * ?????????
         * @private
         */
        _clickEventBind: function () {
            var self = this;
            this.el.off("click").on("click", function (event) {
                var target = $(event.target),
                    index, val,
                    readonly_list = self.readonly_list,
                    old_index;
                if (target.prop("tagName") === "INPUT") {
                    index = target.attr("index") - 0;
                    val = target.val();
                    old_index = self._valueToIndex(self.value[0]);
                    if (typeof readonly_list[val] !== "undefined") {//???
                        if (!isNaN(old_index)) {
                            self.inputs.eq(old_index).prop("checked", true);
                        } else {
                            self.inputs.eq(index).prop("checked", false);
                            return false;
                        }
                    } else {
                        if (old_index === index) {
                            return;
                        }
                        self._checked(index);
                        self.value = [val];
                        self.labels.eq(old_index).removeClass(this.type + "-group-checked").css({"color": "", "fontWeight" : ""});
                        self._changeHander();
                    }
                }
            });
        },
        /**
         * ????index
         * @param val
         * @private
         */
        _valueToIndex: function (val) {
            if (typeof val === "undefined") {
                return NaN;
            }
            var values = this.values,
                length = this.size,
                i = 0;
            for (; i < length; i++) {
                if (val === values[i]) {
                    return i;
                }
            }
            return NaN;
        },
        /**
         * ???
         * @private
         */
        _checked: function (index) {
            var labels_index = this.labels.eq(index),
                colors_index = this.colors[index];
            labels_index.addClass(this.type + "-group-checked");
            if (colors_index) {
                labels_index.css("color", colors_index);
            } else {
                labels_index.css("color", this.options.color);
            }
        },
        /**
         * ???
         */
        show: function () {
            this.inner.show();
        },
        /**
         * ????
         */
        hide: function () {
            this.inner.hide();
        },
        /**
         * ?????
         * @param val
         * @param isInit
         */
        setValue: function (val, isInit) {
            if (this.textmode) {
                return;
            }
            var old_value = $.extend([], this.value),
                value, len, i;
            this._setValue(val);
            //?§Ø???????????change
            if (!isInit) {
                value = this.value;
                len = value.length;
                if (len === old_value.length) {
                    for (i = 0; i < len; i++) {
                        if (old_value[i] !== value[i]) {
                            this._changeHander();
                            break;
                        }
                    }
                } else {
                    this._changeHander();
                }
            }
        },
        /**
         *
         * @private
         */
        _setValue: function (val) {
            var val_type = $.type(val);
            if (val_type !== "undefined") {
                if (val_type === "array" ) {
                    this._initValue(val);
                } else if (val !== ""){
                    this._initValue([String(val)]);
                } else {
                    //val === ""
                    this.value = [""];
                }
            }
            var length = this.size,
                values = this.values,
                value  = this.value,
                value_len = value.length,
                inputs = this.inputs,
                labels = this.labels,
                type = this.type,
                i,j;
            inputs_loop: for (i = 0; i < length; i ++) {
                for (j = 0; j < value_len; j++) {
                    if (value[j].toString() === values[i]) {
                        inputs.eq(i).prop("checked", true);
                        this._checked(i);
                        continue inputs_loop;
                    }
                }
                inputs.eq(i).prop("checked", false);
                labels.eq(i).removeClass(type + "-group-checked").css("color", "");
            }
        },
        /**
         * ???????
         * @param flag
         * @param value_list
         */
        setReadonly: function (flag, value_list) {
            if (this.textmode) {
                return;
            }
            var type = $.type(value_list),
                readonly_list = this.readonly_list,
                values = this.values,
                length = this.size,
                list_len ,
                i, j, values_j;
            if (typeof flag !== "boolean" || type !== "array" && type !== "undefined" ) {
                return ;
            }
            //???????¦Ä????
            if (type === "undefined") {
                value_list = values;
            }
            list_len = value_list.length;
            for (i = list_len; i--;) {
                for (j = length; j--;) {
                    values_j = values[j];
                    if (value_list[i].toString() === values_j) {
                        if (flag) {
                            readonly_list[values_j] = j;
                        } else {
                            delete readonly_list[values_j];
                        }
                        this._setReadonlyAction(j, flag);
                        break;
                    }
                }
            }
        },
        /**
         * ???????
         * @private
         */
        _setReadonly: function () {
            var readonly_list = this.readonly_list,
                v;
            for (v in readonly_list) {
                if (readonly_list.hasOwnProperty(v)) {
                    this._setReadonlyAction(readonly_list[v], true);
                }
            }
        },
        /**
         * ???????
         * @private
         */
        _setReadonlyAction: function (index, flag) {
            var labels = this.labels,
                inputs = this.inputs,
                type = this.type;
            if (flag) {
                labels.eq(index).addClass(type + "-group-readonly");
                inputs.attr("hidefocus", "true");
            } else {
                labels.eq(index).removeClass(type + "-group-readonly");
                inputs.removeAttr("hidefocus");
            }
        },
        /**
         * ?§Ø???????
         * @param val
         * @returns {boolean}
         */
        isReadonly : function (val) {
            var readonly_list = this.readonly_list, i = 0, v;
            if (typeof val === "undefined") {
                for (v in readonly_list) {
                    if (readonly_list.hasOwnProperty(v)) {
                        i ++;
                    }
                }
                return this.size === i;
            }
            return readonly_list.hasOwnProperty(val);
        },

        /**
         * ????????????????
         * @param obj
         * @param message
         */
        onInValid: function(obj, message) {
            this.inner.addClass( this.type + "-group-error");
            this.el.attr("tip", message);
        },

        /**
         * ????????????????
         */
        onValid: function() {
            var el = this.el,
                tipID = el.find(this.tipPosition).eq(0).attr('tipID'),
                $cuiTip;
            this.inner.removeClass(this.type +  "-group-error");
            if(tipID !== undefined){
                $cuiTip = window.cui.tipList[tipID];
                if (typeof $cuiTip !== 'undefined') {
                    $cuiTip.hide();
                }
            }
            if (this.tip_text) {
                el.attr("tip", this.tip_text);
            } else {
                el.attr("tip", "");
            }
        }
    });
})(window.comtop);