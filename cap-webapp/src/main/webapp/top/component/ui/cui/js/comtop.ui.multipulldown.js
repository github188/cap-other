/**
 * 模块: CUI组件 MultiPullDown类
 * 创建: 王伟3
 * 日期: 13-10-9
 * 描述: 继承自PullDown组件基础。传址引用了部分SinglePullDown类中的方法。
 */
;(function(C){
    "use strict";
    var $ = C.cQuery,
        SinglePullDown = C.UI.SinglePullDown.prototype;
    C.UI.MultiPullDown = C.UI.PullDown.extend({
        options : {
            uitype:'MultiPullDown',
            name:'MultiPullDownName'
        },
        /**
         * 必需
         * 初始化模块
         * @private
         */
        __initMode: function (rendered) {

            this.index = [];
            this.checkAll = false;
            this.__createList(rendered);
        },
        /**
         * 必需
         * 文本模式
         * @private
         */
        __renderTextMode: function () {
            var opts = this.options,
                value = opts.value.split(/;|；/),
                len = value.length,
                labelField = opts.label_field,
                valueField = opts.value_field,
                data = this.data,
                dataI, i, j,
                html = [],
                length = data.length;
            if (!len) {
                return;
            }
            //文字模式显示文字拼凑
            for (i = 0; i < length; i++) {
                dataI = data[i];
                for (j = 0; j < len; j ++) {
                    if (dataI[valueField] === value[j]) {
                        html.push(dataI[labelField]);
                    }
                }
            }
            this.$el.html(html.join(";"));
        },
        /**
         * 创建下拉模块Dom
         * @private
         */
        __createList: function (rendered) {
            var data = this.data,
                $box = this.$box,
                size = this.size = data.length,
                html = [],
                label = this.options.label_field,
                i, j, $list, list, indexList, text;
            //拼凑HTML字符串
            for (i = 0; i < size; i++) {
                text = data[i][label];
                html.push(
                    '<a class="pulldown-list" href="javascript:;" index="',
                    i,
                    '" title="',
                    text,
                    '">',
                    text,
                    '</a>'
                );
            }
            if (!rendered) {
                //第一次渲染
                $box.addClass("multi-pulldown-box").append('<div class="pulldown-list-all">' +
                    '<a href="javascript:;" class="pulldown-list">全选</a></div>');
                this.allCheckDom = $box.find(".pulldown-list-all").eq(0).find(".pulldown-list").eq(0);
                this.__bindAllAcitveEvent();
            } else {
                this.__setAllCheck(false);
            }
            //空数据时，隐藏全选。
            if (size) {
                $box.find(".pulldown-list-all").eq(0).show();
            } else {
                $box.find(".pulldown-list-all").eq(0).hide();
            }
            //列表dom存入数组
            $list = this.$boxInner.html(html.join("")).find(".pulldown-list");
            list = this.list = [];
            indexList = this.indexList = [];
            //组合dom列表
            for (j = 0; j < size; j ++) {
                list[j] = $list.eq(j);
                indexList[j] = j;
            }
        },
        /**
         * 全选事件绑定
         * @private
         */
        __bindAllAcitveEvent: function () {
            var self = this,
                index,
                i;
            this.allCheckDom.on("click", function (event) {
                event.stopPropagation();
                if (self.checkAll) {
                    self.index = [];
                } else {
                    index = [];
                    for (i = self.size; i--; ) {
                        index[i] = true;
                    }
                    self.index = index;
                }
                self.__setInputProp();
            });
        },
        /**
         * 是否全选状态设置
         * @param {boolean} flag
         * @private
         */
        __setAllCheck: function (flag) {
            var allCheck = "全选",
                allCancelCheck = "取消";
            this.checkAll = flag;
            if (flag) {
                this.allCheckDom.addClass("pulldown-checked").html(allCancelCheck);
            } else {
                this.allCheckDom.removeClass("pulldown-checked").html(allCheck);
            }
        },
        /**
         * 下拉框显示回调
         * 滚动到当前选中行的第一个在显示范围内。
         * @private
         */
        __showBoxCallBack: function () {
            var index = this.index,
                len = index.length,
                i = 0;
            if(len) {
                for (; i < len; i++) {
                    if (index[i] === true) {
                        this.__scrollHoverPosition(i);
                        break;
                    }
                }
            } else {
                this.__scrollHoverPosition(0);
            }
        },
        /**
         * 下拉隐藏回调
         * @private
         */
        __hideBoxCallBack: function () {
            //清除高亮
            this.__clearHover();
            //匹配输入
            if (this.options.editable) {
                this.__setIndex(undefined, this.$text.val());
            }
        },
        /**
         * 根据值或者字段获得index
         * 必需有一个参数
         * @param {string} value
         * @param {string} label
         * @private
         */
        __setIndex: function (value, label) {
            var opts = this.options,
                field = opts.value_field,
                comparisonValue = value === undefined ? label : value,
                index, data, size, i, j, len;
            if (typeof comparisonValue !== "string") {
                return ;
            }
            index = this.index = [];
            data = this.data;
            size = this.size;
            if (value === undefined) {
                field = opts.label_field;
            }
            comparisonValue = comparisonValue.split(/;|；/);
            len = comparisonValue.length;
            //匹配出选择第几条
            for (i = 0; i < size; i++) {
                for (j = 0; j < len; j ++) {
                    if (data[i][field] === comparisonValue[j]) {
                        index[i] = true;
                    }
                }
            }
            this.__setInputProp();
        },
        /**
         * 根据this.index设置输入框和隐藏域的值。
         * @private
         */
        __setInputProp: function () {
            var opts = this.options,
                labelField = opts.label_field,
                valueField = opts.value_field,
                size = this.size,
                data = this.data,
                index = this.index,
                list = this.list,
                dataIndex, i, checkNum = 0,
                text = [], value = [], selectData = [];
            //组合出显示文字和值
            for (i = 0; i < size; i++) {
                dataIndex = data[i];
                if (index[i]) {
                    checkNum++;
                    list[i].addClass("pulldown-checked");
                    text.push(dataIndex[labelField]);
                    value.push(dataIndex[valueField]);
                    selectData.push(dataIndex);
                } else {
                    list[i].removeClass("pulldown-checked");
                }
            }
            this.__setAllCheck(checkNum === size && size !== 0);
            this._setProp({
                text: text.join(";"),
                value: value.join(";"),
                data: selectData
            });
        },
        /**
         * 清除高亮
         * @private
         */
        __clearHover: SinglePullDown.__clearHover,
        /**
         * 必需
         * 设置值
         * @param {string} value
         */
        __setValue: function (value) {
            this.__setIndex(value);
        },
        /**
         * 选中
         * @param {number} newIndex
         * @private
         */
        __checkSelect: function (newIndex) {
            var index = this.index;
            if (newIndex < 0 || newIndex >= this.size) {
                return;
            }
            index[newIndex] = !index[newIndex];
            this.__setInputProp();
        },
        /**
         * 必需
         * 鼠标选择事件回调
         * @param {object} event 事件event对象
         * @private
         */
        __mouseUpHandler: function (event) {
            var target = $(event.target),
                index;
            if (target.hasClass("pulldown-list")) {
                index = target.attr("index");
                if (index) {
                    this.__checkSelect(index - 0);
                }
            }
            this.$text.focus();
        },
        /**
         * 按向上
         * @private
         */
        __keyDownUPHandler: SinglePullDown.__keyDownUPHandler,
        /**
         * 按向下
         * @private
         */
        __keyDownDownHandler: SinglePullDown.__keyDownDownHandler,
        /**
         * 滚动到焦点位置
         * @param positionIndex
         * @private
         */
        __scrollHoverPosition: function (positionIndex) {
            var lineHeight = 23,
                $box = this.$box,
                hoverPo = positionIndex * lineHeight,
                newScrollTop = hoverPo + lineHeight * 2 - $box.height();
            if ($box.scrollTop() < newScrollTop) {
                $box.scrollTop(newScrollTop);
            } else if ($box.scrollTop() > hoverPo){
                $box.scrollTop(hoverPo);
            }
        },
        /**
         * 回车
         * @private
         */
        __keyDownEnterHandler: function(){
            var hoverIndex = this.hoverIndex;
            if (typeof hoverIndex !== "undefined") {
                this.__checkSelect(this.indexList[hoverIndex]);
            }
        },
        /**
         * 获取输入框文字,以数组的形式返回
         * @returns {Array}
         * @private
         */
        __getText: function () {
            if (this.text === "") {
                return [];
            }
            return this.text.split(";");
        }
    });
})(window.comtop);