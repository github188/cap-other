/**
 * 2013�� 8�� 9�� By CUI�Ŷ�-��ΰ
 * CheckboxGroup���������д
 * �̳���RadioboxGroup���
 */
(function (C) {
"use strict";
var $ = C.cQuery;

C.UI.CheckboxGroup = C.UI.RadioGroup.extend({
    options : {
        uitype:"CheckboxGroup",
        name : "",
        checkbox_list : [],
        direction : "horizontal",
        value :[],
        color : "#4585e5",
        textmode: false,
        allselect: "",
        br : [],
        readonly : false,
        border: false
    },
    /**
     * ��������
     * @returns {string}
     * @private
     */
    _setType : function () {
        this.type = "checkbox";
        return "checkbox";
    },
    /**
     * ɾ��ֵ
     * @param val
     * @returns {*}
     * @private
     */
    _deleteVal : function (val) {
        var value = this.value,
            len = value.length,
            i = 0;
        for (; i < len; i++) {
            if (value[i] === val) {
                value.splice(i, 1);
                break;
            }
        }
        return value;
    },
    /**
     * ��Ⱦ��ɻص�
     * @private
     */
    _renderComplete: function () {
        if (!this.options.allselect) {
            return;
        }
        var opts = this.options,
            allId = this.allId = this.guid + "all",
            type = this.type,
            allLabel = this.allLabel = $("<label>");
        allLabel.attr("for", allId);
        allLabel.html(['<input id="', allId, '" type="', type, '" hidefocus="true" />', opts.allselect ].join(""));
        if (opts.br.length || opts.direction === "vertical") {
            this.inner.prepend('<br />');
        }
        this.inner.prepend(allLabel);
        this.allInput = $("#" + allId);
        this._checkAllSelect();
    },
    /**
     * change�ص�
     * @private
     */
    _changeHander: function () {
        var opts = this.options,
            changeHander = opts.on_change;
        if (opts.allselect) {
            this._checkAllSelect();
        }
        this._triggerHandler('change');
        if (typeof changeHander === "function") {
            changeHander(this.getValue());
        }
    },
    /**
     * �ж��Ƿ�ȫѡ
     * @private
     */
    _checkAllSelect: function () {
        if (this.value.length === this.size) {
            this.allInput.prop("checked", true);
            this.allLabel.css("color", "#f60");
        } else {
            this.allInput.prop("checked", false);
            this.allLabel.css("color", "");
        }
    },
    /**
     * �����¼���
     * @private
     */
    _clickEventBind : function () {
        var self = this, isAll = !!self.options.allselect;
        this.el.off("click").on("click", function (event) {
            var target = $(event.target),
                index, val,
                checked = target.prop("checked"),
                readonlyList = self.readonly_list;
            if (target.prop("tagName") === "INPUT") {
                index = target.attr("index") - 0;
                val = target.val();
                if (typeof readonlyList[val] !== "undefined") {
                    //ֻ��
                    event.preventDefault();
                } else {
                    //��ֻ��
                    if (isAll && self.allId === target.attr("id")) {
                        //ȫѡ
                        if (checked) {
                            self.selectAll();
                        } else {
                            self.unSelectAll();
                        }
                    } else {
                        if (checked) {
                            self._checked(index);
                            self.value.push(val);
                            $.unique(self.value);
                        } else {
                            self._deleteVal(val);
                            self.labels.eq(index).removeClass(this.type + "-group-checked").css({"color": "", "fontWeight" : ""});
                        }
                        self._changeHander();
                    }
                }
            }
        });
    },
    /**
     * ��ȡֵ���ַ���
     * @param split
     * @returns {string}
     */
    getValueString : function (split) {
        var value = this.getValue();
        if (!value) {
            return "";
        }
        return value.join(split || "��");
    },
    /**
     * ��ȡlabel���ַ���
     * @param split
     * @returns {string}
     */
    getTextString : function (split) {
        var text = this.getText();
        if (!text) {
            return "";
        }
        return this.getText().join(split || "��");
    },
    /**
     * ȫѡ
     */
    selectAll : function () {
        this.setValue(this.values);
    },
    /**
     * ȫȡ��
     */
    unSelectAll : function () {
        this.setValue([]);
    }
});
})(window.comtop);