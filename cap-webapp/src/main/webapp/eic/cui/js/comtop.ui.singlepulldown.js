/**
 * ???: CUI??? SinglePullDown??
 * ????: ???3
 * ????: 13-10-9
 * ????: ?????PullDown?????
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
     * ????
     * ????????????
     * @param {Boolean} rendered
     * @private
     */
    __initMode: function (rendered) {
        this.index = -1;
        if (!rendered) {
            this.$hideListBox = $(document.createElement("div"));
        } else {
            //???????????????????div??????
            this.$hideListBox.html("");
        }
        this.__createList();
    },
    /**
     * ????
     * ????????
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
     * ???????????Dom
     * @private
     */
    __createList: function () {
        var $boxInner = this.$boxInner,
            data = this.data,
            size = this.size = data.length,
            html = [],
            labelField = this.options.label_field,
            i, j, $list, list, indexList, text;
        //??????
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
        //????dom?§Ò?
        for (j = 0; j < size; j ++) {
            list[j] = $list.eq(j);
            indexList[j] = j;
        }
    },
    /**
     * ???????????
     * @param {string} value
     * @private
     */
    __filterList: function (value) {
        var opts, data, dataList, $boxInner, size, label, filterFields,
            filterFieldsList, len, $hideListBox, i, j, list, indexList;
        //???
        if (value === "") {
            this.__recoverBox();
            return;
        }
        //?????????????
        if (this.__filterCustom(value) || this.__filterCustomData(value)) {
            return;
        }
        //???
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
        //????
        outer: for (i = 0; i < size; i++) {
            dataList = data[i];
            if (dataList[label].indexOf(value) !== -1) {
                //??????¦É???
                $boxInner.append(list[i]);
                indexList.push(i);
            } else {
                if (len) {
                    //??????¦É???
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
                //??????¦É???
                $hideListBox.append(list[i]);
            }
        }
    },
    /**
     * ?????????????????
     * ?????????????????data??????§Ü?????
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
            //newData ???????????????? Json
            newData = onFilterData.call(this, this, value);
            if ($.type(newData) === "array") {
                data = this.data;
                size = this.size;
                $boxInner = this.$boxInner;
                indexList = this.indexList = [];
                $hideListBox = this.$hideListBox;
                list = this.list;
                valueField = opts.value_field;
                //????
                outer: for (i = 0; i < size; i++) {
                    dataI = data[i];
                    //???????????????????dom
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
     * ????????????
     * ???????????Boolean???????????????????§Ø?
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
            //newData ????[boolean, boolean, ...]
            newData = onFilterShow.call(this, this, value);
            if ($.type(newData) === "array") {
                $boxInner = this.$boxInner;
                indexList = this.indexList = [];
                $hideListBox = this.$hideListBox;
                list = this.list;
                //????dom
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
     * ????????????¦Ë??index
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
            //????????Number???????????????????? ??? 2013-11-07
            if (data[i][field] === comparisonValue + '') {
                return i;
            }
        }
        return -1;
    },
    /**
     * ????????????
     * ?????????????????????¦¶???
     * @private
     */
    __showBoxCallBack: function () {
        //??????????¦Ë??
        var index = this.index;
        if (index !== -1) {
            this.__scrollHoverPosition(index);
        }
    },
    /**
     * ??????????
     * @private
     */
    __hideBoxCallBack: function () {
        //this.selectEvent?? ????????????????????????????????????????
        if ( this.options.editable && !this.selectEvent) {
            this.__checkSelect(this.__getIndex(undefined, this.$text.val()));
        }
        this.selectEvent = false;
        //??????????§Ò?dom
        this.__recoverBox();
        //??????
        this.__clearHover();
    },
    /**
     * ??????
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
     * ?????????????
     * @private
     */
    __recoverBox: function () {
        var list = this.list,
            indexList = this.indexList = [],
            size = this.size,
            $boxInner = this.$boxInner, i;
        for (i = 0; i < size; i++) {
            $boxInner.append(list[i]);
            indexList.push(i);
        }
    },
    /**
     * ????
     * ?????
     * @param value
     */
    __setValue: function (value) {
        this.__checkSelect(this.__getIndex(value));
    },
    /**
     * ???
     * @private
     */
    __checkSelect: function (newIndex) {
        var opts = this.options,
            labelField = opts.label_field,
            valueField = opts.value_field,
            dataIndex,
            list = this.list,
            index = this.index;
        //??????????§Ö???
        if (index !== -1) {
            list[index].removeClass("pulldown-checked");
        }
        if (newIndex !== -1) {
            //???????§Ö???
            list[newIndex].addClass("pulldown-checked");
            dataIndex = this.data[newIndex];
            this._setProp({
                text: dataIndex[labelField],
                value: dataIndex[valueField],
                data: dataIndex
            });
        } else {
            //????¦Ê????
            this._setProp({
                value: "",
                text: opts.must_exist ? "" : this.$text.val(),
                data: null
            });
        }
        this.index = newIndex;
    },
    /**
     * ????
     * ?????????up???
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
     * ???????
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
                //???????
                hoverIndex = len - 1;
                list[indexList[hoverIndex]].addClass("pulldown-hover");
            } else {
                //???????????
                list[indexList[hoverIndex] || 0].removeClass("pulldown-hover");
                //??????
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
     * ???????
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
                //???????
                hoverIndex = 0;
                list[indexList[0]].addClass("pulldown-hover");
            } else {
                //???????????
                list[indexList[hoverIndex] || 0].removeClass("pulldown-hover");
                //??????
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
     * ??????????¦Ë??
     * @param {number} positionIndex
     * @private
     */
    __scrollHoverPosition: function (positionIndex) {
        var lineHeight = 23,
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
     * ???
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
     * ????????
     * @param {object} event ?????event????
     * @private
     */
    __keyUpHandler: function (event) {
        var keyCode = event.keyCode;
        //13??enter 37??left?? 38??up 39??right 40??down
        if (!this.options.auto_complete ||
            keyCode === 13 || keyCode === 37 || keyCode === 38 || keyCode === 39 || keyCode === 40) {
            return;
        }
        this.__clearHover();
        this.__filterList(this.$text.val());
    },
    /**
     * ????????????
     * @returns {string}
     * @private
     */
    __getText: function () {
        return this.text;
    }
});
})(window.comtop);