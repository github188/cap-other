/**
 * ???: CUI??? MultiPullDown??
 * ????: ???3
 * ????: 13-10-9
 * ????: ?????PullDown?????????????????SinglePullDown???§Ö??????
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
         * ????
         * ????????
         * @private
         */
        __initMode: function (rendered) {

            this.index = [];
            this.checkAll = false;
            this.__createList(rendered);
        },
        /**
         * ????
         * ?????
         * @private
         */
        __renderTextMode: function () {
            var opts = this.options,
                value = opts.value.split(/;|??/),
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
            //????????????????
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
         * ???????????Dom
         * @private
         */
        __createList: function (rendered) {
            var data = this.data,
                $box = this.$box,
                size = this.size = data.length,
                html = [],
                label = this.options.label_field,
                i, j, $list, list, indexList, text;
            //???HTML???
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
                //????????
                $box.addClass("multi-pulldown-box").append('<div class="pulldown-list-all">' +
                    '<a href="javascript:;" class="pulldown-list">??</a></div>');
                this.allCheckDom = $box.find(".pulldown-list-all").eq(0).find(".pulldown-list").eq(0);
                this.__bindAllAcitveEvent();
            } else {
                this.__setAllCheck(false);
            }
            //????????????????
            if (size) {
                $box.find(".pulldown-list-all").eq(0).show();
            } else {
                $box.find(".pulldown-list-all").eq(0).hide();
            }
            //?§Ò?dom????????
            $list = this.$boxInner.html(html.join("")).find(".pulldown-list");
            list = this.list = [];
            indexList = this.indexList = [];
            //???dom?§Ò?
            for (j = 0; j < size; j ++) {
                list[j] = $list.eq(j);
                indexList[j] = j;
            }
        },
        /**
         * ???????
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
         * ???????????
         * @param {boolean} flag
         * @private
         */
        __setAllCheck: function (flag) {
            var allCheck = "??",
                allCancelCheck = "???";
            this.checkAll = flag;
            if (flag) {
                this.allCheckDom.addClass("pulldown-checked").html(allCancelCheck);
            } else {
                this.allCheckDom.removeClass("pulldown-checked").html(allCheck);
            }
        },
        /**
         * ????????????
         * ?????????????§Ö????????????¦¶???
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
         * ??????????
         * @private
         */
        __hideBoxCallBack: function () {
            //??????
            this.__clearHover();
            //???????
            if (this.options.editable) {
                this.__setIndex(undefined, this.$text.val());
            }
        },
        /**
         * ??????????¦Ë??index
         * ?????????????
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
            comparisonValue = comparisonValue.split(/;|??/);
            len = comparisonValue.length;
            //???????????
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
         * ???this.index????????????????????
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
            //?????????????
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
         * ??????
         * @private
         */
        __clearHover: SinglePullDown.__clearHover,
        /**
         * ????
         * ?????
         * @param {string} value
         */
        __setValue: function (value) {
            this.__setIndex(value);
        },
        /**
         * ???
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
         * ????
         * ????????????
         * @param {object} event ???event????
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
         * ??????
         * @private
         */
        __keyDownUPHandler: SinglePullDown.__keyDownUPHandler,
        /**
         * ??????
         * @private
         */
        __keyDownDownHandler: SinglePullDown.__keyDownDownHandler,
        /**
         * ??????????¦Ë??
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
         * ???
         * @private
         */
        __keyDownEnterHandler: function(){
            var hoverIndex = this.hoverIndex;
            if (typeof hoverIndex !== "undefined") {
                this.__checkSelect(this.indexList[hoverIndex]);
            }
        },
        /**
         * ????????????,??????????????
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