/**
 * 模块: CUI组件 SinglePullDown类
 * 创建: 王伟3
 * 日期: 13-10-9
 * 描述: 继承自PullDown组件基础。
 */
;(function(C){
"use strict";
var $ = C.cQuery;
C.UI.SinglePullDown = C.UI.PullDown.extend({
    options : {
        name: "pullDownName",
        uitype: "SinglePullDown"
    },
    /**
     * 必需
     * 初始化下拉模块
     * @param {Boolean} rendered
     * @private
     */
    __initMode: function (rendered) {
        this.index = -1;
        if (!rendered) {
            this.$hideListBox = $(document.createElement("div"));
        } else {
            //重置数据，需要重置隐藏div的内容
            this.$hideListBox.html("");
        }
        this.__createList();
    },
    /**
     * 必需
     * 渲染文本模式
     * @private
     */
    __renderTextMode: function () {
        var opts = this.options,
            data = this.data,
            index;
        this.size = data.length;
        index = this.__getIndex(opts.value);
        if (index > -1) {
            this.$el.html(data[index][opts.label_field]);
        }
    },
    /**
     * 创建下拉模块Dom
     * @private
     */
    __createList: function () {
        var $boxInner = this.$boxInner,
            data = this.data,
            size = this.size = data.length,
            html = [],
            labelField = this.options.label_field,
            i, j, $list, list, indexList, text;
        //拼凑字符串
        for (i = 0; i < size; i++) {
            text = data[i][labelField];
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
        $boxInner.html(html.join(""));
        $list = $boxInner.find(".pulldown-list");
        list = this.list = [];
        indexList = this.indexList = [];
        //更新dom列表
        for (j = 0; j < size; j ++) {
            list[j] = $list.eq(j);
            indexList[j] = j;
        }
    },
    /**
     * 组件默认过滤列
     * @param {string} value
     * @private
     */
    __filterList: function (value) {
        var opts, data, dataList, $boxInner, size, label, filterFields,
            filterFieldsList, len, $hideListBox, i, j, list, indexList;
        //空值
        if (value === "") {
            this.__recoverBox();
            return;
        }
        //通过接口自定义过滤
        if (this.__filterCustom(value) || this.__filterCustomData(value)) {
            return;
        }
        //赋值
        opts = this.options;
        data = this.data;
        $boxInner = this.$boxInner;
        size = this.size;
        label = opts.label_field;
        filterFields = opts.filter_fields;
        len = filterFields.length;
        $hideListBox = this.$hideListBox;
        list = this.list;
        indexList = this.indexList = [];
        //过滤
        outer: for (i = 0; i < size; i++) {
            dataList = data[i];
            if (dataList[label].indexOf(value) !== -1) {
                //文字字段过滤
                $boxInner.append(list[i]);
                indexList.push(i);
            } else {
                if (len) {
                    //过滤字段过滤
                    for (j = 0; j < len; j++) {
                        filterFieldsList = dataList[filterFields[j]];
                        if (typeof filterFieldsList === "string" &&
                            filterFieldsList.indexOf(value) !== -1) {
                            $boxInner.append(list[i]);
                            indexList.push(i);
                            continue outer;
                        }
                    }
                }
                //过滤字段过滤
                $hideListBox.append(list[i]);
            }
        }
    },
    /**
     * 用户数据过滤，已经废弃
     * 根据返回对象的值与现有data的值进行恒等匹配
     * @param {string} value
     * @returns {boolean|undefined}
     * @private
     */
    __filterCustomData: function (value) {
        var opts = this.options,
            valueField, $boxInner, indexList, $hideListBox, list,
            i, data, size, dataI, newData, k, newDataK,
            onFilterData = opts.on_filter_data;
        if (typeof onFilterData === "function") {
            //newData 应该为过滤出来的数据 Json
            newData = onFilterData.call(this, this, value);
            if ($.type(newData) === "array") {
                data = this.data;
                size = this.size;
                $boxInner = this.$boxInner;
                indexList = this.indexList = [];
                $hideListBox = this.$hideListBox;
                list = this.list;
                valueField = opts.value_field;
                //过滤
                outer: for (i = 0; i < size; i++) {
                    dataI = data[i];
                    //过滤出来的数据重新调整dom
                    for (k = newData.length; k--;) {
                        newDataK = newData[k];
                        if (dataI[valueField] === newDataK[valueField]) {
                            $boxInner.append(list[i]);
                            indexList.push(i);
                            continue outer;
                        }
                    }
                    $hideListBox.append(list[i]);
                }
            }
            return true;
        }
    },
    /**
     * 用户匹配数据过滤
     * 根据用户返回的Boolean数组对每一行数据进行匹配判断
     * @param {string} value
     * @returns {boolean|undefined}
     * @private
     */
    __filterCustom: function (value) {
        var opts = this.options,
            onFilterShow = opts.on_filter,
            $boxInner, indexList, $hideListBox, list,
            i, newData;
        if (typeof onFilterShow === "function") {
            //newData 应该为[boolean, boolean, ...]
            newData = onFilterShow.call(this, this, value);
            if ($.type(newData) === "array") {
                $boxInner = this.$boxInner;
                indexList = this.indexList = [];
                $hideListBox = this.$hideListBox;
                list = this.list;
                //过滤dom
                for (i = this.size; i--;) {
                    if (newData[i] === true) {
                        $boxInner.append(list[i]);
                        indexList.push(i);
                    } else {
                        $hideListBox.append(list[i]);
                    }
                }
            }
            return true;
        }
    },
    /**
     * 根据值，或者字段获取index
     * @param {string} value
     * @param {string} label
     * @returns {number}
     * @private
     */
    __getIndex: function (value, label) {
        var opts = this.options,
            comparisonValue = value || label,
            field = opts.value_field,
            data = this.data,
            size = this.size,
            i;
        if (value === undefined) {
            field = opts.label_field;
        }
        for (i = 0; i < size; i++) {
            //预防比较值为Number类型，所以做了类型转换 超群 2013-11-07
            if (data[i][field] === comparisonValue + '') {
                return i;
            }
        }
        return -1;
    },
    /**
     * 下拉框显示回调
     * 滚动到当前选中行在显示范围内。
     * @private
     */
    __showBoxCallBack: function () {
        //滚动到选中值位置
        var index = this.index;
        if (index !== -1) {
            this.__scrollHoverPosition(index);
        }
    },
    /**
     * 下拉隐藏回调
     * @private
     */
    __hideBoxCallBack: function () {
        //this.selectEvent： 是否是选中事件后的及时隐藏，如果否表示用户输入后的隐藏
        if ( this.options.editable && !this.selectEvent) {
            this.__checkSelect(this.__getIndex(undefined, this.$text.val()));
        }
        this.selectEvent = false;
        //初始化下拉列表dom
        this.__recoverBox();
        //清除高亮
        this.__clearHover();
    },
    /**
     * 清除高亮
     * @private
     */
    __clearHover: function () {
        var hoverIndex = this.hoverIndex;
        if (typeof hoverIndex !== "undefined") {
            this.list[this.indexList[hoverIndex]].removeClass("pulldown-hover");
            delete this.hoverIndex;
        }
    },
    /**
     * 还原下拉框内容
     * @private
     */
    __recoverBox: function () {
        var list = this.list,
            indexList = this.indexList = [],
            size = this.size,
            $boxInner = this.$boxInner, i;
        for (i = 0; i < size; i++) {
            if (!$boxInner.find(list[i]).length) {
                $boxInner.append(list[i]);
            }
            indexList.push(i);
        }
    },
    /**
     * 必需
     * 设置值
     * @param value
     */
    __setValue: function (value) {
        this.__checkSelect(this.__getIndex(value));
    },
    /**
     * 选中
     * @private
     */
    __checkSelect: function (newIndex) {
        var opts = this.options,
            labelField = opts.label_field,
            valueField = opts.value_field,
            dataIndex,
            list = this.list,
            index = this.index;
        //清除上一次选中的行
        if (index !== -1) {
            list[index].removeClass("pulldown-checked");
        }
        if (newIndex !== -1) {
            //处理当前选中的行
            list[newIndex].addClass("pulldown-checked");
            dataIndex = this.data[newIndex];
            this._setProp({
                text: dataIndex[labelField],
                value: dataIndex[valueField],
                data: dataIndex
            });
        } else {
            //没有任何选中
            this._setProp({
                value: "",
                text: opts.must_exist ? "" : this.$text.val(),
                data: null
            });
        }
        this.index = newIndex;
    },
    /**
     * 必需
     * 鼠标选择事件up回调
     */
    __mouseUpHandler: function (event) {
        var target = $(event.target),
            index;
        this.selectEvent = true;
        if (target.hasClass("pulldown-list")) {
            index = target.attr("index");
            if (index) {
                this.__checkSelect(index - 0);
            }
            this.$text.blur();
        } else if (!this.size) {
            this.$text.blur();
        }
    },
    /**
     * 按向上键
     * @private
     */
    __keyDownUPHandler: function () {
        var indexList = this.indexList,
            len = indexList.length,
            list, hoverIndex;
        if (len) {
            list = this.list;
            hoverIndex = this.hoverIndex;
            if (typeof hoverIndex === "undefined") {
                //刚展开状态
                hoverIndex = len - 1;
                list[indexList[hoverIndex]].addClass("pulldown-hover");
            } else {
                //移除前一条高亮
                list[indexList[hoverIndex] || 0].removeClass("pulldown-hover");
                //实现循环
                if (--hoverIndex === -1) {
                    hoverIndex = len - 1;
                }
                list[indexList[hoverIndex]].addClass("pulldown-hover");
            }
            this.hoverIndex = hoverIndex;
            this.__scrollHoverPosition(hoverIndex);
        }
    },
    /**
     * 按向下键
     * @private
     */
    __keyDownDownHandler: function () {
        var indexList = this.indexList,
            len = indexList.length,
            list,
            hoverIndex;
        if (len) {
            list = this.list;
            hoverIndex = this.hoverIndex;
            if (typeof hoverIndex === "undefined") {
                //刚展开状态
                hoverIndex = 0;
                list[indexList[0]].addClass("pulldown-hover");
            } else {
                //移除前一条高亮
                list[indexList[hoverIndex] || 0].removeClass("pulldown-hover");
                //实现循环
                if (len === ++hoverIndex) {
                    hoverIndex = 0;
                }
                list[indexList[hoverIndex]].addClass("pulldown-hover");
            }
            this.hoverIndex = hoverIndex;
            this.__scrollHoverPosition(hoverIndex);
        }
    },
    /**
     * 滚动到焦点位置
     * @param {number} positionIndex
     * @private
     */
    __scrollHoverPosition: function (positionIndex) {
        var lineHeight = 28,
            $box = this.$box,
            hoverPo = positionIndex * lineHeight,
        newScrollTop = hoverPo + lineHeight - $box.height();
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
        this.selectEvent = true;
        if (typeof hoverIndex !== "undefined") {
            this.__checkSelect(this.indexList[hoverIndex]);
        }
        this.$text.blur();
    },
    /**
     * 输入按键回调
     * @param {object} event 传入的event对象
     * @private
     */
    __keyUpHandler: function (event) {
        var keyCode = event.keyCode;
        //13：enter 37：left， 38：up 39：right 40：down
        if (!this.options.auto_complete ||
            keyCode === 13 || keyCode === 37 || keyCode === 38 || keyCode === 39 || keyCode === 40) {
            return;
        }
        this.__clearHover();
        this.__filterList(this.$text.val());
    },
    /**
     * 获取输入框文字
     * @returns {string}
     * @private
     */
    __getText: function () {
        return this.text;
    }
});
})(window.comtop);