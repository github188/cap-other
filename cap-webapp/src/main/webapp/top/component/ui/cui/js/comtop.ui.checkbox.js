/**
 * 2013年 8月 9日 By CUI团队-王伟
 * CheckboxGroup组件代码重写
 * 继承于RadioboxGroup组件
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
     * 设置类型
     * @returns {string}
     * @private
     */
    _setType : function () {
        this.type = "checkbox";
        return "checkbox";
    },
    /**
     * 删除值
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
     * 渲染完成回调
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
     * change回调
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
     * 判断是否全选
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
     * 单击事件绑定
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
                    //只读
                    event.preventDefault();
                } else {
                    //非只读
                    if (isAll && self.allId === target.attr("id")) {
                        //全选
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
     * 获取值，字符串
     * @param split
     * @returns {string}
     */
    getValueString : function (split) {
        var value = this.getValue();
        if (!value) {
            return "";
        }
        return value.join(split || "、");
    },
    /**
     * 获取label，字符串
     * @param split
     * @returns {string}
     */
    getTextString : function (split) {
        var text = this.getText();
        if (!text) {
            return "";
        }
        return this.getText().join(split || "、");
    },
    /**
     * 全选
     */
    selectAll : function () {
        this.setValue(this.values);
    },
    /**
     * 全取消
     */
    unSelectAll : function () {
        this.setValue([]);
    }
});
})(window.comtop);