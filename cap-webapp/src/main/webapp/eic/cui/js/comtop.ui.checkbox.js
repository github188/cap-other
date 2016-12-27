/**
 * 2013?? 8?? 9?? By CUI???-???
 * CheckboxGroup?????????§Õ
 * ?????RadioboxGroup???
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
        color : "#f60",
        textmode: false,
        br : [],
        readonly : false,
        border: false
    },

    _setType : function () {
        this.type = "checkbox";
        return "checkbox";
    },

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

    _clickEventBind : function () {
        var self = this;
        this.el.off("click").on("click", function (event) {
            var target = $(event.target),
                index, val,
                readonly_list = self.readonly_list;
            if (target.prop("tagName") === "INPUT") {
                index = target.attr("index") - 0;
                val = target.val();
                if (typeof readonly_list[val] !== "undefined") {//???
                    target.prop("checked", !target.prop("checked"));
                } else {
                    if (target.prop("checked")) {
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
        });
    },

    getValueString : function (split) {
        var value = this.getValue();
        if (!value) {
            return "";
        }
        return value.join(split || "??");
    },

    getTextString : function (split) {
        var text = this.getText();
        if (!text) {
            return "";
        }
        return this.getText().join(split || "??");
    },

    selectAll : function () {
        this.setValue(this.values);
    },

    unSelectAll : function () {
        this.setValue([]);
    }
});
})(window.comtop);