/**
 * 2013�� 8�� 9�� By CUI�Ŷ�-��ΰ
 * RadioGroup���������д
 * checkboxGroup����̳��ڴ����
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
            color: "#4585e5",
            br: [],
            border: false,
            textmode: false,
            on_change : null
        },
        /**
         * ��ʼ������
         * @private
         */
        _init: function () {
            var opts = this.options,
                value = opts.value,
                type =  this._setType();
            //config
            this.textmode = opts.textmode;
            this.guid = type + "group-" + C.guid() + "-";
            this.tipPosition = this.el;
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
         * ��������,���ڼ�������
         * @private
         */
        _setType: function () {
            this.type = "radio";
            return "radio";
        },
        /**
         * ��ʼ��Ⱦ
         * @private
         */
        _create: function () {
            if (this.create) {
                return ;
            }
            var type = this.type,
                list = this.options[type + "_list"],
                listType = $.type(list),
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
            //�ж�����
            if (listType === "function") {//�ص�����
                list(this);
            } else if (listType === "array" && !this.size) {//Json
                this._setDatasource(list);
            } else if (this.size) {
                this._setDatasource(this._initData());
            } else {//������
                throw new Error(type + "_list's type not is a array or a function.");
            }
            this.create = true;
        },
        /**
         * ��ʼ������
         * @private
         */
        _initData: function () {
            var inputs = this.inputs,
                length = this.size,
                i, inputsI, valueI, dataI, readonlyI, nextText,
                notVal = 0,
                newData = [];
            //ƴ������
            for (i = 0; i < length; i++) {
                inputsI = inputs.eq(i);
                valueI = inputsI.attr("value");
                nextText = inputsI[0].nextSibling;
                if (valueI) {
                    dataI = {
                        text :inputsI.attr("text") || (nextText.nodeType === 3 ? nextText.nodeValue.replace(/\s*|\n*/g, "") : ""),
                        value : valueI
                    };
                    readonlyI = inputsI.attr("readonly");
                    if (readonlyI && (readonlyI === "true" || readonlyI.toLowerCase() === "readonly")) {
                        dataI.readonly = "readonly";
                    }
                    if (inputsI.attr("color")) {
                        dataI.color = inputsI.attr("color");
                    }
                    newData.push(dataI);
                } else {
                    notVal++;
                }
            }
            this.size -= notVal;
            return newData;
        },
        /**
         * ����3������������������
         * �໥�Ž�
         * @param data
         */
        _setDatasource: function (data) {//��ʼ������
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
            //��ʼ������
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
         * ��ȾHTMLģ��
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
                brLen = br.length,
                brPosition = {},
                type = this.type,
                guid = this.guid,
                i, j,
                html = [],
                valueI, textI,
                readonlyList = this.readonly_list;
            //ȷ������λ��
            if (brLen) {
                for (j = brLen; j--;) {
                    brPosition[br[j]] = true;
                }
            }
            //����ģ��
            for (i = 0; i < length; i ++) {
                if (i !== 0 && direction === "vertical" || brPosition[i]) {
                    html.push ('<br />');
                }
                valueI = values[i] = data[i].value;
                textI = texts[i] = data[i].text;
                if (readonly || data[i].readonly) {
                    readonlyList[valueI] = i;
                }
                colors[i] = data[i].color;
                html.push(
                    '<label for="', guid, i,'">',
                    '<input id="', guid, i, '" type="', type, '" name="', name, '" value="', valueI, '" index="', i, '" hidefocus="true" />',
                    textI,
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
         * ��Ⱦ����ģʽ����
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
         * input����
         * @private
         */
        _inputsAction: function () {
            //��ʼ��ֵ
            this._initValue();
            //����ֵ
            this._setValue(undefined);
            if (this.options.textmode) {
                this._renderText();
            }
            //���¼�
            this._clickEventBind();
            //����ֻ��
            this._setReadonly();
            if (this._renderComplete) {
                this._renderComplete();
            }
        },
        /**
         * ��ʼ��ֵ
         * @private
         */
        _initValue: function (value) {
            value = (value || this.value).sort();
            var valLen = value.length,
                values = this.values,
                length = this.size,
                i, j,
                newValue = [];
            //���õ�ֵ����Ҫ����֪���б��д��ڣ������޳���
            for (i = 0; i < valLen; i++) {
                for (j = 0; j < length; j++) {
                    if (values[j] === value[i] + "") {
                        newValue.push(values[j]);
                        break;
                    }
                }
            }
            this.value = $.unique(newValue);
        },
        /**
         * change�ص�
         * @private
         */
        _changeHander: function () {
            var changeHander = this.options.on_change;
            this._triggerHandler('change');
            if (typeof changeHander === "function") {
                changeHander(this.getValue());
            }
        },
        /**
         * ��ȡֵ
         * @private
         */
        getValue: function () {
            return this._getEle(this.values);
        },
        /**
         *��ȡѡ�е�����
         */
        getText: function () {
            return this._getEle(this.texts);
        },
        /**
         * ��ȡֵ�������ִ�����
         * @private
         */
        _getEle: function (arr) {
            var value = this.value.sort(function (a, b) {
                    return a > b ? 1 : -1;
                }) ,
                valLen = value.length,
                index = this.size,
                type = this.type,
                i, newArr = [], new_str;
            //ƴ��ֵ�������ַ���
            for (i = 0; i < valLen; i++) {
                index = this._valueToIndex(value[i]);
                if (!isNaN(index)) {
                    newArr.push(arr[index]);
                    new_str = arr[index];
                }
            }
            if (type === "radio") {
                return new_str || null;
            }
            return newArr.length ? newArr : null;
        },
        /**
         * �����¼���
         * @private
         */
        _clickEventBind: function () {
            var self = this;
            this.el.off("click").on("click", function (event) {
                var target = $(event.target),
                    index, val,
                    readonlyList = self.readonly_list,
                    oldIndex;
                if (target.prop("tagName") === "INPUT") {
                    index = target.attr("index") - 0;
                    val = target.val();
                    oldIndex = self._valueToIndex(self.value[0]);
                    if (typeof readonlyList[val] !== "undefined") {
                        //ֻ��Ԫ�صĵ���
                        if (!isNaN(oldIndex)) {
                            self.inputs.eq(oldIndex).prop("checked", true);
                        } else {
                            self.inputs.eq(index).prop("checked", false);
                            return false;
                        }
                    } else {
                        if (oldIndex === index) {
                            return;
                        }
                        self._checked(index);
                        self.value = [val];
                        self.labels.eq(oldIndex).removeClass(this.type + "-group-checked").css({"color": "", "fontWeight" : ""});
                        self._changeHander();
                    }
                }
            });
        },
        /**
         * ֵ��ȡindex
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
         * ѡ��
         * @private
         */
        _checked: function (index) {
            var labelsIndex = this.labels.eq(index),
                colorsIndex = this.colors[index];
            labelsIndex.addClass(this.type + "-group-checked");
            if (colorsIndex) {
                labelsIndex.css("color", colorsIndex);
            } else {
                labelsIndex.css("color", this.options.color);
            }
        },
        /**
         * ��ʾ
         */
        show: function () {
            this.inner.show();
        },
        /**
         * ����
         */
        hide: function () {
            this.inner.hide();
        },
        /**
         * ����ֵ
         * @param val
         * @param isInit
         */
        setValue: function (val, isInit) {
            if (this.textmode) {
                return;
            }
            var oldValue = $.extend([], this.value),
                value, len, i;
            this._setValue(val);
            if (!isInit) {
                value = this.value;
                len = value.length;
                if (len === oldValue.length) {
                    //�ж��Ƿ���Ҫ����change
                    for (i = 0; i < len; i++) {
                        if (oldValue[i] !== value[i]) {
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
            var valType = $.type(val);
            if (valType !== "undefined") {
                if (valType === "array" ) {
                    this._initValue(val);
                } else if (val !== ""){
                    this._initValue([String(val)]);
                } else {
                    this.value = [""];
                }
            }
            var length = this.size,
                values = this.values,
                value  = this.value,
                valueLen = value.length,
                inputs = this.inputs,
                labels = this.labels,
                type = this.type,
                i, j;
            inputsLoop: for (i = 0; i < length; i ++) {
                for (j = 0; j < valueLen; j++) {
                    if (value[j].toString() === values[i]) {
                        inputs.eq(i).prop("checked", true);
                        this._checked(i);
                        continue inputsLoop;
                    }
                }
                inputs.eq(i).prop("checked", false);
                labels.eq(i).removeClass(type + "-group-checked").css("color", "");
            }
        },
        /**
         * ����ֻ��
         * @param flag
         * @param value_list
         */
        setReadonly: function (flag, value_list) {
            if (this.textmode) {
                return;
            }
            var type = $.type(value_list),
                readonlyList = this.readonly_list,
                values = this.values,
                length = this.size,
                listLen ,
                i, j, valuesJ;
            if (typeof flag !== "boolean" || type !== "array" && type !== "undefined" ) {
                return ;
            }
            //��ѡ����δ����
            if (type === "undefined") {
                value_list = values;
            }
            listLen = value_list.length;
            //�������readonly
            for (i = listLen; i--;) {
                for (j = length; j--;) {
                    valuesJ = values[j];
                    if (value_list[i].toString() === valuesJ) {
                        if (flag) {
                            readonlyList[valuesJ] = j;
                        } else {
                            delete readonlyList[valuesJ];
                        }
                        this._setReadonlyAction(j, flag);
                        break;
                    }
                }
            }
        },
        /**
         * ����ֻ��
         * @private
         */
        _setReadonly: function () {
            var readonlyList = this.readonly_list,
                v;
            for (v in readonlyList) {
                if (readonlyList.hasOwnProperty(v)) {
                    this._setReadonlyAction(readonlyList[v], true);
                }
            }
        },
        /**
         * ����ֻ��
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
         * �ж��Ƿ�ֻ��
         * @param val
         * @returns {boolean}
         */
        isReadonly : function (val) {
            var readonlyList = this.readonly_list, i = 0, v;
            if (typeof val === "undefined") {
                for (v in readonlyList) {
                    if (readonlyList.hasOwnProperty(v)) {
                        i ++;
                    }
                }
                return this.size === i;
            }
            return readonlyList.hasOwnProperty(val);
        },

        /**
         * ��֤ʧ��ʱ���������
         * @param obj
         * @param message
         */
        onInValid: function(obj, message) {
            this.el.addClass( this.type + "-group-error").attr("tip", message);
            //����tip���ͣ�����
            this.el.attr('tipType', 'error');
        },

        /**
         * ��֤�ɹ�ʱ���������
         */
        onValid: function() {
            var el = this.el,
                tipID = el.find(this.tipPosition).eq(0).attr('tipID'),
                $cuiTip;
            el.removeClass(this.type +  "-group-error");
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
            //����tip���ͣ�����
            el.attr('tipType', 'normal');
        }
    });
})(window.comtop);