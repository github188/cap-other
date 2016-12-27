/**
 * 新grid
 * @author 王伟
 * @since 2013-6-31
 */
(function (C) {
    'use strict';
    var $ = C.cQuery,
        fiexNumber = C.Tools.fixedNumber || function (a) {return a;};
    C.UI.Grid = C.UI.Base.extend({
        options: {
            uitype                : "Grid",
            gridwidth             : "600px",
            gridheight            : "500px",
            tablewidth            : "",
            primarykey            : "ID",
            ellipsis              : true,
            titleellipsis         : true,
            adaptive              : true,
            titlelock             : true, //空配置项，修改为一直是锁定的
            oddevenrow            : false,
            selectrows            : "multi",
            fixcolumnnumber       : 0,
            config                : null,
            datasource            : null,
            titlerender           : null,
            colhidden             : true,
            colmaxheight          : 0, //隐藏列下拉框高度
            colmove               : false,
            loadtip               : true,
            resizeheight          : null,
            resizewidth           : null,
            rowstylerender        : null,
            colstylerender        : null,
            colrender             : null,
            lazy                  : true,
            sortstyle             : 1,
            sortname              : [],
            sorttype              : [],
            pageno                : 1,
            pagesize              : 50,
            pagesize_list         : [25, 50, 100],
            pagination            : true,
            pagination_model      : 'pagination_min_1',
            adddata_callback      : null,
            removedata_callback   : null,
            rowclick_callback     : null,
            loadcomplate_callback : null,//未确定
            selectall_callback    : null,
            rowdblclick_callback  : null,
            onstatuschange        : null
        },
        //格式化 money, date
        formatFn: {
            "date": C.Date.simpleformat,
            "money": C.Number.money
        },
        //列渲染
        renderMethod: {
            "a": function (rowData, options, value) {
                var html = ["<a"],
                    params = options.params,
                    search = "";
                if (params) {
                    params = params.split(";");
                    var arr = [];
                    for (var i = params.length; i--;) {
                        var paramsI = params[i];
                        if (rowData.hasOwnProperty(paramsI)) {
                            arr.push([paramsI, "=", rowData[paramsI]].join(""));
                        }
                    }
                    search = "?" + arr.join("&");
                }
                html.push(
                    " href='", (options.url || "") + search,
                    "' class='", options.className || "",
                    "' target='", options.targets || "_self",
                    "' clickid='", options.click,
                    "'>",
                    value,
                    "</a>"
                );
                return html.join("");
            },
            "image": function (rowData, options, value) {
                var html = ["<img"];
                html.push(" class='", options.className || "");
                var url      = options.url,
                    compare  = options.compare,
                    relation = options.relation,
                    title    = options.title,
                    t        = value;
                if (typeof relation === "string") {
                    if (/\./.test(relation)) {
                        var arrRelation = relation.split(".");
                        t = rowData[arrRelation[0]][arrRelation[1]];
                    } else {
                        t = rowData[relation];
                    }
                }
                if (title && title[t]) {
                    title = title[t];
                } else {
                    title = value;
                }
                if (compare) {
                    url = compare[t] || url;
                }
                html.push(
                    "' src='", url,
                    "' title='", title,
                    "' clickid='", options.click,
                    "' />"
                );
                return html.join("");
            },
            "button": function (rowData, options, value) {
                var html = ["<button class='"];
                html.push(
                    options.className || "",
                    "' clickid='", options.click,
                    "'>",
                    options.value || value,
                    "</button>"
                );
                return html.join("");
            }
        },
        /**
         * 初始化参数和属性
         */
        _init: function () {
            var opts = this.options,
                config = opts.config,
                onstatuschange = opts.onstatuschange,
                datasource = opts.datasource,
                sortstyle        = opts.sortstyle;
            //检查sort属性,纠正传入错误的sort属性.
            opts.sortname.length = Math.min(opts.sortname.length, sortstyle);
            opts.sorttype.length = Math.min(opts.sorttype.length, sortstyle);
            //取数据函数
            if (typeof config === "string" && typeof window[config] === "function") {
                opts.config = window[config];
            }
            if (typeof onstatuschange === "string" && typeof window[onstatuschange] === "function") {
                opts.onstatuschange = window[onstatuschange];
            }
            if (typeof datasource === "string" && typeof window[datasource] === "function") {
                opts.datasource = window[datasource];
            }
            //设置初始属性
            this.el                = opts.el;
            this.elCache          = null; //dom存到内存，因为IE的table只读
            this.gridContainer    = null;
            this.gridBox           = null;
            this.gridStyle        = null;
            this.gridHead         = null;
            this.gridHeadTable   = null;
            this.gridTableHide   = null;
            this.gridBody         = null;
            this.gridTableBox    = null;
            this.gridTbody        = null;
            this.gridScroll       = null;
            this.gridLine         = null;
            this.gridEmpty        = null;
            this.gridTfoot        = null;
            this.loading           = null;
            this.gridOverlay      = null;
            this.gridAllCheck    = null;
            this.createDomBox    = document.createElement("div");
            //基础集合
            this.domTh            = [];
            this.domTr            = [];
            this.domTd            = [];
            this.domFixed         = [];
            this.domHeadCol      = [];
            this.domBodyCol      = [];
            this.theadMap         = [];
            this.extendTh         = [];
            this.trFrag           = document.createElement("tbody");
            //数据
            this.data              = [];
            this.backupQuery      = null;
            this.query             = null;
            this.customQuery      = null;
            //个数
            this.rowSize          = 0;
            this.colSize          = 0;
            //属性
            this.sortType         = {};
            this.theadText        = [];
            this.renderStyle      = [];
            this.colRender        = [];
            this.bindName         = []; // -1 单选多选; 0,1 序号; "" 没有绑定; "string" 绑定了
            this.bindDotName      = [];
            this.numCol           = NaN;
            this.colWidth         = [];
            this.initColWidth    = [];
            this.colWidthBackup  = [];
            this.multiChecked     = [];
            this.multiCheckedNum = 0;
            this.singleChecked    = NaN;
            this.disabledIndex = [];

            this.fixedFnClick    = [];
            this.colHidden        = [];
            this.disabled = [];
            this.totalSize        = 0;
            this.guid              = "grid-" + C.guid();
            this.heightLight      = [];
            this.colIndex         = [];
            //样式
            this.gridWidth        = 0;
            this.gridHeight       = 0;
            this.tableWidth       = 0;
            this.theadHeight      = 30;
            this.boxHeight        = 0;
            this.paginationHeight = opts.pagination ? 41 : 0;
            //html片段
            this.selectrowsClass   = "";
            this.tdsPackage       = [];
            //渲染行数相关
            this.endRow           = 0;
            this.trStart          = 0;
            this.trEnd            = 0;
            //判断标识
            this.renderComplete   = false;
            this.odd               = false;
            this.unRender         = true;
            this.autoHeight       = false;
            this.isIttab          = false;
            this.arrIndex         = Array.prototype.indexOf;
            this.isQm             = C.Browser.isQM;
            this.persistence       = typeof onstatuschange === "function" && typeof config === "function";
            this.oddEvenClass          = "cardinal_row";
            this.selectedRowClass      = "selected_row";
            //判断是否动态写入style标签
            try {
                var head = $("head");
                head.append('<style type="text/css"></style>');
                head.find("style").last()[0].innerHTML = "";//如果style只读这行报错
                this.writeStyle = true;
            } catch (e) {
                this.writeStyle = false;
            }
            //备份query
            this._backupQuery();
            //初始化pagesize
            this._setPageSize();
            //生成排序对象
            this._setSortTypeObj();
            //获取表头dom
            this.__getDomTh();
            //初始化整体宽度
            this.__initWidthAndHeight();

        },
        /**
         * 备份查询条件
         * @private
         */
        _backupQuery: function () {
            var opts = this.options,
                query = {
                    pageSize : opts.pagesize,
                    pageNo   : opts.pageno,
                    sortName : $.extend([], opts.sortname),
                    sortType : $.extend([], opts.sorttype)
                };
            this.backupQuery = $.extend(true, {}, query);
            this.query = query;
        },
        /**
         * 设置pagesize
         * @private
         */
        _setPageSize: function () {
            var opts          = this.options,
                query         = this.query,
                pagesizeList = opts.pagesize_list,
                pageSize     = query.pageSize;
            for (var i = pagesizeList.length; i--;) {
                if (pageSize === pagesizeList[i]) {
                    return;
                }
            }
            query.pageSize = pagesizeList[1];
        },
        /**
         * 设置排序属性到sorttype对象
         * @private
         */
        _setSortTypeObj: function () {
            var query     = this.query,
                sortname  = query.sortName,
                sorttype  = query.sortType,
                len       = sortname.length,
                sortType = this.sortType = {};
            for (var i = 0; i < len; i += 1) {
                var sorttypeI = sorttype[i].toUpperCase();
                sorttype[i] = sorttypeI;
                sortType[sortname[i]] = sorttypeI;
            }
        },
        /**
         * 获取题头th,生产多行题头map
         * @private
         */
        __getDomTh: function () {
            var el = this.el,
                elChache,
                tr,
                trLen,
                colIndex = this.colIndex,
                extendTh = this.extendTh;
            elChache = $(document.createElement("div")).html([
                '<table><thead>',
                el.find("thead").html() || el.find("tbody").html() || el.html(),
                '</thead></table>'
            ].join("")).find("table").eq(0);
            //读取内存里面的tr
            this.elCache = elChache;
            tr = elChache.find("tr");
            trLen = tr.length;
            if (trLen === 1) {//单行题头
                var ths = elChache[0].getElementsByTagName("th"),
                    domTh = [];
                for (var g = 0, h = ths.length; g < h; g += 1) {
                    domTh.push(ths[g]);
                    colIndex[g] = g;
                }
                this.domTh = domTh;
            } else {//多行题头
                var theadMap = this.theadMap = [],
                    i, j, l,
                    theadMapL;
                //colSpan替换
                for (i = 0; i < trLen; i += 1) {//每一行
                    var trI = tr.eq(i)[0],
                        thI = trI.cells,
                        lenThI = thI.length,
                        allCellSpan = 0;
                    extendTh[i] = [];
                    if (!theadMap[i]) {
                        theadMap[i] = [];
                    }
                    for (j = 0; j < lenThI; j += 1) {//每一列
                        var thIJ = thI[j],
                            cellSpan = thIJ.colSpan;
                        for (l = 0; l < cellSpan; l += 1) {//cellspan
                            theadMap[i][allCellSpan + l] = thIJ;
                        }
                        allCellSpan += cellSpan;
                    }
                    var emptyTh = document.createElement("th");
                    emptyTh.className = "grid-empty-th";
                    trI.insertBefore(emptyTh, thI[0]);
                }
                //rowSpan替换
                for (i = trLen; i --;) {//每一行
                    var mapI = theadMap[i],
                        lenMapI = mapI.length;
                    for (j = 0; j < lenMapI; j += 1) {//每一列
                        var mapIJ = mapI[j],
                            rowSpan = mapIJ.rowSpan;
                        if (rowSpan > 1 && !extendTh[i][j]) {
                            rowSpan += i;
                            for (l = i + 1; l < rowSpan; l += 1) {//rowspan
                                theadMapL = theadMap[l];
                                if (theadMapL) {
                                    extendTh[l][j] = true;
                                    theadMapL.splice(j, 0, mapIJ);
                                }
                            }
                        }
                    }
                }
                this.domTh = $.extend([], theadMap[trLen - 1]);
            }
            this.colSize = this.domTh.length;
        },

        /**
         * 计算初始的宽高
         * @private
         */
        __initWidthAndHeight: function () {
            var opts        = this.options,
            //外框宽度高度
                rewidth     = typeof opts.resizewidth === "function" ? opts.resizewidth() : undefined,
                reheight    = typeof opts.resizeheight === "function" ? opts.resizeheight() : undefined,
                gridwidth = opts.gridwidth = fiexNumber(opts.gridwidth),
                gridheight = opts.gridheight = fiexNumber(opts.gridheight);
            this.gridWidth = ( rewidth || gridwidth) - 2;
            if (gridheight === "auto") {
                gridheight       = 500;
                this.autoHeight = true;
            }
            this.gridHeight  = ( reheight || gridheight ) - 2;
            //table的宽高
            this.theadHeight = this.elCache.find("tr").length * 30;
            this.boxHeight   = this.gridHeight - this.paginationHeight - this.theadHeight;
            this.tableWidth  = opts.adaptive ? this.gridWidth - 17 : fiexNumber(opts.tablewidth) || this.gridWidth;
        },

        /**
         * 创建组件dom
         * @private
         */
        _create: function () {
            //创建外框
            this.__createLayoutDom();
            //事件委托
            this.__theadClickEventBind();
            this.__theadMouseEventBind();
            this.__tbodyClickEventBind();
            this.__tbodyMouseEventBind();
            //回调
            this.__imitateScroll();
            this._resizeEventBind();
            this.__boxScrollEventBind();
            //设置初始宽高样式
            this._setStyleWidth();
            this._setStyleHeight();
            //如果没有持久化，直接渲染内容
            this._loading("show");
            var opts = this.options,
                datasource = opts.datasource,
                config = opts.config;
            if (typeof datasource !== "function") {
                return;
            }
            if (this.persistence) {
                config(this);
            } else {
                this._createPropertys();
                this._createContent();
                datasource(this, this.getQuery());
            }
        },
        /**
         * 创建外框 div
         * @private
         */
        __createLayoutDom: function () {
            var opts            = this.options,
                el              = this.el,
            //生成dom
                container       = document.createElement("div");
            container.className = "grid-container";
            var html = [
                '<div class="grid-style"></div>',
                '<div class="grid-box">',
                '<div class="grid-head">',
                '<table class="grid-head-table"></table>',
                '</div>',
                '<div class="grid-body">',
                '<div class="grid-empty">本列表暂无记录</div>',
                '<div class="grid-table-box"><div class="grid-table-hide"></div></div>',
                '</div>',
                '<div class="grid-scroll">',
                '<div></div>',
                '</div>',
                '<div class="grid-line"></div>',
                '<div class="grid-overlay"></div>',
                '</div>',
                '<div class="grid-tfoot"></div>',
                '<div class="grid-loading-bg grid-loading-bg-over"></div>',
                '<div class="grid-loading-box"><span>正在加载...</span></div>'
            ];
            container.innerHTML = html.join("");
            el[0].parentNode.insertBefore(container, el[0]);
            //创建jq对象
            var gridContainer   = this.gridContainer = $(container).addClass(this.guid);
            if (this.isQm) {
                gridContainer.addClass("grid-container-qm");
            }
            this.gridTableBox  = $(".grid-table-box", gridContainer);
            var gridBox         = this.gridBox = gridContainer.children(".grid-box");
            this.gridStyle      = gridContainer.find(".grid-style").eq(0);
            this.gridHead       = gridBox.find(".grid-head").eq(0);
            this.gridBody       = gridBox.children(".grid-body").eq(0);
            this.gridOverlay    = gridBox.children(".grid-overlay").eq(0);
            this.gridHeadTable = this.gridHead.children(".grid-head-table").eq(0);
            this.gridLine       = gridBox.children(".grid-line").eq(0);
            this.gridScroll     = gridBox.children(".grid-scroll").eq(0);
            this.gridTfoot      = gridContainer.children(".grid-tfoot").eq(0);
            this.gridEmpty      = this.gridBody.children(".grid-empty").eq(0);
            this.loading         = gridContainer.children(".grid-loading-bg").next().andSelf();
            //调整dom属性
            this.gridTableHide = $(".grid-table-hide", gridContainer).eq(0).append(el.addClass("grid-body-table"));
            if (opts.ellipsis) { //是否能换行
                el.addClass("grid-ellipsis");
            }
            if (opts.titleellipsis) {//题头是否换行
                this.gridHeadTable.addClass("grid-ellipsis");
            }
        },
        /**
         * 表头点击事件
         * @private
         */
        __theadClickEventBind: function () {
            var opts      = this.options,
                bindName = this.bindName,
                primarykey = opts.primarykey,
                self      = this;
            this.gridHeadTable.on("click", function (event) {
                event.stopPropagation();
                var target = $(event.target);
                var className = target.attr("class");

                if (className === "grid-select" || className === "grid-ittab") {
                    return;//这里 可以调用 隐藏列 函数
                }
                //全选

                if (target.hasClass("grid-all-checkbox")) {
                    var domTr           = self.domTr,
                        multiChecked    = self.multiChecked,
                        selectedRowClass = self.selectedRowClass,
                        allCheckClass    = "grid-all-checkbox-checked",
                        endRow          = self.endRow,
                        rowSize         = self.rowSize,
                        checkAll = target.hasClass(allCheckClass) ,
                        disabledIndex = self.disabledIndex,
                        data = self.data,
                        dataK, rows = 0;
                    // $(target).blur();
                    if (checkAll) {
                        for (var j = endRow; j--;) {
                            multiChecked[j] = false;
                            $(domTr[j]).removeClass(selectedRowClass);
                        }
                        target.removeClass(allCheckClass);
                        for (var m = endRow; m < rowSize; m += 1) {
                            multiChecked[m] = false;
                        }
                        self.multiCheckedNum = 0;
                    } else {
                        for (var k = endRow; k--;) {
                            dataK = data[k];
                            if (dataK.hasOwnProperty(primarykey) && disabledIndex[k]) {
                                continue;
                            }
                            rows++;
                            multiChecked[k] = true;
                            $(domTr[k]).addClass(selectedRowClass);
                        }
                        target.addClass(allCheckClass);
                        for (k = endRow; k < rowSize; k += 1) {
                            dataK = data[k];
                            if (dataK.hasOwnProperty(primarykey) && disabledIndex[k]) {
                                continue;
                            }
                            rows++;
                            multiChecked[k] = true;
                        }
                        self.multiCheckedNum = rows;
                    }
                    var selectallCallback = opts.selectall_callback;
                    if (typeof selectallCallback === "function") {
                        var checked = !checkAll;
                        selectallCallback.call(self, checked ? self.data : [], checked);
                    }
                    return;
                }
                //排序
                var gridSort = target.parents(".grid-sort");
                if (gridSort.length && className === "grid-thead-text") {
                    var sortType       = self.sortType,
                        bindNameI     = bindName[self._thIndex(gridSort[0])],
                        sortTypeI     = sortType[bindNameI],// || "ASC",
                        newSortTypeI = sortTypeI !== "DESC" ? "DESC" : "ASC";
                    self._setOptsSortNameAndSoryType(bindNameI, newSortTypeI);
                    //持久化排序
                    if (self.persistence) {
                        self._triggerStatusChange();
                    }
                    self.loadData();
                }
            });
        },
        /**
         * 获取当前列的索引,题头不规则只能用此函数
         * @param thDom
         * @returns {*}
         * @private
         */
        _thIndex: function (thDom) {
            var domTh = this.domTh,
                arrIndex = this.arrIndex;
            if(arrIndex) {
                return arrIndex.call(domTh, thDom);
            }
            //IE
            for (var i = this.colSize; i--;) {
                if (domTh[i] === thDom) {
                    return i;
                }
            }
            return -1;
        },
        /**
         * 设置this.query中sortname和sorttype
         * @private
         */
        _setOptsSortNameAndSoryType: function (name, type) {
            var query      = this.query,
                sortstyle = this.options.sortstyle,
                sortName  = query.sortName,
                sortType  = query.sortType;
            for (var i = sortstyle; i--;) {
                if (name === sortName[i]) {
                    sortType.splice(i, 1);
                    sortName.splice(i, 1);
                    break;
                }
            }
            if (sortName.length === sortstyle) {
                sortType.shift();
                sortName.shift();
            }
            sortName.push(name);
            sortType.push(type);
            this._setSortTypeObj();
        },
        /**
         * th鼠标over,out事件
         * @private
         */
        __theadMouseEventBind: function () {
            this.gridHeadTable.on("mouseover",function (event) {
                var target       = $(event.target);
                var gridFixedS = target.closest(".grid-fixed-s").eq(0);
                if (gridFixedS.length) {
                    gridFixedS.parents("th").addClass("grid-thead-mouseover");
                }
            }).on("mouseout", function (event) {
                    var target = $(event.target);
                    var gridFixedS = target.closest(".grid-fixed-s").eq(0);
                    if (gridFixedS.length) {
                        gridFixedS.parents("th").removeClass("grid-thead-mouseover");
                    }
                });
        },
        /**
         * 单击双击事件
         * @private
         */
        __tbodyClickEventBind: function () {
            var opts                 = this.options,
                rowdblclickCallback = typeof opts.rowdblclick_callback === "function" ? opts.rowdblclick_callback : null,
                selectrows           = opts.selectrows,
                self                 = this,
                timeout              = null,
                target               = null,
                tagName;
            self.el.on("click", function (event) {
                event.stopPropagation();
                target = event.target;
                tagName = target.tagName;
                if (tagName === "TBODY" || tagName === "TABLE") {
                    return false;
                }
                var $target = $(target);
                var tr = $target.closest("tr").eq(0);
                var trIndex = tr.attr("index") || tr[0].rowIndex - 1 + self.trStart;
                //执行a,button,img的自定义事件
                var clickid = target.getAttribute("clickid") || "";
                if (clickid !== "") {
                    return self.fixedFnClick[clickid](self.data[trIndex], trIndex) === false ? false : true;
                }

                if (supportSelect($target) ||
                    (tagName === "SPAN" || tagName === "DIV") && supportSelect($target.parent())) {
                    self._selectRows(trIndex, undefined);
                } else {
                    return;
                }

                if (rowdblclickCallback) {
                    clearTimeout(timeout);
                    timeout = setTimeout(function () {
                        clickCallback(trIndex);
                    }, 300);
                } else {
                    clickCallback(trIndex);
                }
            });
            self.el.on("dblclick", function (event) {
                event.stopPropagation();
                if (rowdblclickCallback) {
                    clearTimeout(timeout);
                    target   = event.target;
                    tagName = target.tagName;
                    if (tagName === "TBODY" || tagName === "TABLE") {
                        return;
                    }
                    var tr       = $(target).closest("tr").eq(0);
                    var trIndex = tr.attr("index") - 0;
                    rowdblclickCallback.call(self, self.data[trIndex], trIndex);
                }
            });

            function supportSelect (target) {
                return (target.prop("tagName") === "TD" || target.hasClass("grid-fixed-s"));
            }

            function clickCallback(trIndex) {
                var flag = false;
                if (selectrows === "multi") {
                    flag = self.multiChecked[trIndex];
                } else if (selectrows === "single") {
                    flag = trIndex === self.singleChecked;
                }
                //选择行回调
                if (typeof opts.rowclick_callback === "function") {
                    opts.rowclick_callback.call(self, self.data[trIndex], flag, trIndex);
                }
            }
        },
        /**
         * 选择行
         * @param index
         * @param flag
         * @private
         */
        _selectRows: function (index, flag) {
            var domTr           = this.domTr,
                domTrIndex     = domTr[index],
                opts             = this.options,
                selectrows       = opts.selectrows,
                selectedRowClass = this.selectedRowClass,
                tr               = $(domTrIndex);
            if (this.disabledIndex[index]) {
                //当前行被禁用选择
                return;
            }
            if (selectrows === "multi") {
                var multiChecked = this.multiChecked;
                var multiCheckedIndex = multiChecked[index];
                if (flag === undefined) {
                    flag = multiCheckedIndex !== true;
                } else if (flag === multiCheckedIndex) {
                    return;
                }
                multiChecked[index] = flag;
                if (!domTrIndex) {
                    return;
                }
                if (flag === false) {
                    tr.removeClass(selectedRowClass);
                    this.multiCheckedNum--;
                    this.gridAllCheck.removeClass("grid-all-checkbox-checked");
                } else {
                    tr.addClass(selectedRowClass);
                    this.multiCheckedNum += 1;
                    if (this.multiCheckedNum === this.rowSize) {
                        this.gridAllCheck.addClass("grid-all-checkbox-checked");
                    }
                }
            } else if (selectrows === "single") {
                var singleChecked = this.singleChecked;
                this.singleChecked = singleChecked === index && flag === false ? NaN : index;
                if (!domTrIndex) {
                    return;
                }
                if (flag === false) {
                    tr.removeClass(selectedRowClass);
                } else {
                    if (!isNaN(singleChecked)) {
                        $(domTr[ singleChecked ]).removeClass(selectedRowClass);
                    }
                    tr.addClass(selectedRowClass);
                }
            }
        },
        /**
         * title渲染
         * @private
         */
        __tbodyMouseEventBind: function () {
            var self            = this,
                bindName       = this.bindName,
                titlerender     = this.options.titlerender,
                tr, title;
            self.el.on("mouseover", function (event) {
                var target   = event.target,
                    tagName = target.tagName;
                if (tagName === "TR" || tagName === "TBODY" || tagName === "TABLE") {
                    return;
                }
                var td           = $(target).closest("td");
                //解决IE8下，mouseover的event.target不精确问题
                if(!td.length){
                    return;
                }
                var tdIndex     = td[0].cellIndex,
                    gridFixedS = td.find(".grid-fixed-s"),
                    contentBox  = gridFixedS.length ? gridFixedS : td,
                    bindNameI  = bindName[tdIndex],
                    trIndex;

                tr               = td.closest("tr");
                trIndex         = tr.attr("index");
                if (!trIndex) {
                    trIndex = tr[0].rowIndex - 1 + self.trStart;
                    tr.attr("index", trIndex);
                }
                tr.addClass("grid-tr-over");
                if (typeof bindNameI !== "number" && !td.attr("title")) {
                    if (typeof titlerender === "function") {
                        title = titlerender(self.data[trIndex], bindNameI);
                        if (title) {
                            td.attr("title", title);
                        } else {
                            title = $.trim(contentBox.text());
                            if (title) {
                                td.attr("title", title);
                            }
                        }

                    } else {
                        title = $.trim(contentBox.text());
                        if (title) {
                            td.attr("title", title);
                        }
                    }
                }
            }).on("mouseout", function () {
                    if (tr) {
                        tr.removeClass("grid-tr-over");
                    }
                });
        },
        /**
         * 模拟滚动条
         * @private
         */
        __imitateScroll: function () {
            var self            = this,
                guid            = self.guid,
                gridHeadTable = this.gridHeadTable[0],
                gridStyle      = this.gridStyle[0],
                el              = this.el[0],
                left, leftCache;
            var fixcolumnnumber = this.options.fixcolumnnumber;
            if (this.writeStyle) {
                this.gridScroll.on("scroll", function () {
                    left = this.scrollLeft;
                    if (leftCache === left) {
                        return ;
                    }
                    leftCache = left;
                    gridStyle.innerHTML = [
                        '<style type="text/css">.',
                        guid,
                        ' .grid-fixed .grid-fixed-s{left:',
                        left,
                        'px}.',
                        guid,
                        ' .grid-body-table, .',
                        guid,
                        ' .grid-head-table{margin-left:-',
                        left,
                        'px}</style>'
                    ].join("");
                });
            } else {
                this.gridScroll.on("scroll", function () {
                    left = this.scrollLeft + "px";
                    if (leftCache === left) {
                        return ;
                    }
                    leftCache = left;
                    var marginLeft = "-" + left;
                    gridHeadTable.style.marginLeft = marginLeft;
                    el.style.marginLeft = marginLeft;
                    var domFixed = self.domFixed;
                    for (var i = domFixed.length; i--;) {
                        var domFixedI = domFixed[i];
                        for (var j = fixcolumnnumber; j--;) {
                            domFixedI[j].style.left = left;
                        }
                    }
                    var tdsPackage = self.tdsPackage;
                    for (var k = 0; k < fixcolumnnumber; k += 1) {
                        tdsPackage[k].html = tdsPackage[k].html.replace(/(style="left:)\d*?px/, "$1" + left);
                    }
                });
            }
        },
        /**
         * resize事件
         * @private
         */
        _resizeEventBind: function () {
            var opts = this.options,
                self = this;
            if (opts.resizeheight || opts.resizewidth) {
                $(window).on("resize", function () {
                    self.resize();
                });
            }
        },
        /**
         * 根据回调设置宽高
         */
        resize: function () {
            var opts = this.options;
            try {
                var height = opts.resizeheight();
                if (typeof height === 'number' && height > 0 && !this.autoHeight) {
                    this.setHeight(height);
                }
            } catch (e) {
            }
            try {
                var width = opts.resizewidth();
                if (typeof width === 'number' && width > 0) {
                    this.setWidth(width);
                }
            } catch (e) {
            }

            if(this.autoHeight){
                this._setAutoHeight();
            }
        },
        /**
         * 滚动触发加载
         * @private
         */
        __boxScrollEventBind: function () {
            var self = this;
            if (!this.options.lazy || this.autoHeight) {
                return;
            }
            this.gridBody.on("scroll", function () {
                self._lazyload(true);
            });
        },
        /**
         * 延迟加载
         * @private
         */
        _lazyload: function (timeout) {
            var self = this,
                opts = this.options,
                scrollTop = this.gridBody[0].scrollTop,
                oldEndRow = self.endRow,
                newStartRow = parseInt(scrollTop / 28, 10),
                newEndRow = parseInt(this.boxHeight / 28, 10) + newStartRow + 20 + 1;
            if (opts.ellipsis) {
                clearTimeout(this.renderTimeout);
                if (timeout) {
                    this.renderTimeout = setTimeout(function () {
                        self._clearAndLoad(newStartRow - 20, oldEndRow, newEndRow);
                    }, 10);
                } else {
                    self._clearAndLoad(newStartRow - 20, oldEndRow, newEndRow);
                }
            } else {
                if (!this.renderComplete && this.appendRowsComplete && newEndRow > oldEndRow) {
                    clearTimeout(this.renderTimeout);
                    if (timeout) {
                        this.renderTimeout = setTimeout(function () {
                            self.appendRowsComplete = false;
                            self._appendRows(oldEndRow, newEndRow);
                        }, 10);
                    } else {
                        self.appendRowsComplete = false;
                        self._appendRows(oldEndRow, newEndRow);
                    }
                }
            }
        },
        /**
         * 不换行,且大数据时调用
         */
        _clearAndLoad: function (newTrStart, oldEndRow, newTrEnd) {
            var rowSize = this.rowSize,
                domTr,
                gridTbody = this.gridTbody[0],
                gridTableBoxCss = this.gridTableBox[0].style,
                trFrag = this.trFrag,
                trStart = this.trStart,
                trEnd = this.trEnd;
            newTrEnd = this.trEnd = Math.min(rowSize, newTrEnd);
            newTrStart = this.trStart = Math.max(newTrStart, 0);
            var i, j, k, l;
            //转换成dom
            if (newTrEnd > oldEndRow) {
                var dom        = this._dataToDom(this.data, oldEndRow, newTrEnd);
                var tr = dom.domTr;
                this.domTr    = this.domTr.concat(tr);
                this.domTd    = this.domTd.concat(dom.domTd);
                this.domFixed = this.domFixed.concat(dom.domFixed);
                this.endRow   = newTrEnd;
                for ( l = tr.length; l --;) {
                    trFrag.appendChild(tr[l]);
                }
            }
            domTr = this.domTr;
            if(newTrStart > trStart || newTrEnd > trEnd) { //滚动条向下滚
                //top删除
                for (i = trStart, j = Math.min(trEnd, newTrStart); i < j; i ++) {
                    trFrag.appendChild(domTr[i]);
                }
                //bottom添加
                for (k = Math.max(newTrStart, trEnd); k < newTrEnd; k ++) {
                    gridTbody.appendChild(domTr[k]);
                }
            } else if (newTrStart < trStart){
                //top插入
                var firstRow = domTr[trStart];
                for (i = newTrStart, j = Math.min(trStart, newTrEnd); i < j; i ++ ) {
                    gridTbody.insertBefore(domTr[i], firstRow);
                }
                //bottom删除
                for (k = Math.max(trStart, newTrEnd); k < trEnd; k ++) {
                    trFrag.appendChild(domTr[k]);
                }
            }
            gridTableBoxCss.paddingTop = newTrStart * 28 + "px";
            gridTableBoxCss.paddingBottom = ( rowSize - newTrEnd) * 28 + "px";
        },
        /**
         * 设置组件宽度样式.
         * @private
         */
        _setStyleWidth: function () {
            this.gridContainer.css("width", this.gridWidth);
            this.el.css("width", this.tableWidth);
            this.gridHeadTable.css("width", this.tableWidth);
        },
        /**
         * 设置组件高度样式.
         * @private
         */
        _setStyleHeight: function () {
            this.gridContainer.css("height", this.gridHeight);
            this.gridHead.css("height", this.theadHeight);
            this.gridOverlay.css("height", this.theadHeight);
            this.gridBody.css("height", this.boxHeight);
        },
        /**
         * 加载中...
         * @param status "show", "hide"
         */
        _loading: function (status) {
            if (!this.options.loadtip) {
                return;
            }
            this.loading[status]();
            if (this.unRender && status === "hide") {
                this.gridContainer.find(".grid-loading-bg").removeClass("grid-loading-bg-over");
            }
        },
        /**
         * 属性初始创建
         * @private
         */
        _createPropertys : function () {
            //获取表头中的属性
            this.__getTagsPropertys();
            //初始化每一列宽度
            this.__initColWidth();
        },
        /**
         * 更多初始创建
         * @private
         */
        _createContent: function () {
            //渲染head和body
            this.__renderHead();
            this.__renderBody();
            //设置列宽
            this._setColWidthStyle();
            //tbody内容渲染相关
            this.__packageTds();
            //初始列隐藏
            this._colHidden(true);
            //扩展功能,拖动列宽和隐藏列
            this.ittab._init(this);
            var opts = this.options;
            if (opts.colhidden) {
                this.hideCol._init(this);
            }
            if (opts.colmove && this.theadMap.length === 0) {
                this.moveCol._init(this);
            }
        },
        /**
         * 获取模版中的列属性.
         */
        __getTagsPropertys: function () {
            var domTh         = this.domTh,
                opts           = this.options,

                colSize       = this.colSize,

                renderStyle   = this.renderStyle,
                bindName      = this.bindName,
                bindDotName  = this.bindDotName,
                sort           = this.sort = [],
                theadText     = this.theadText,
                colwidth      = this.colWidth,
                colRender     = this.colRender,
                fixedFnClick = this.fixedFnClick,
                colHidden = this.colHidden,
                disabled = this.disabled;
            //设置列宽备份
            for (var i = 0; i < colSize; i += 1) {
                //设置colIndex
                var thI = domTh[i];
                colwidth.push(thI.style.width || thI.getAttribute("width") || "");
                //初始状态为隐藏
                colHidden[i] = thI.getAttribute("hide") === "true" || $(thI).css("display") === "none";
                //不可隐藏设置
                disabled[i] = thI.getAttribute("disabled");
                thI.removeAttribute("disabled");
                //获取渲染样式。
                var renderStyleAttrI = thI.getAttribute("renderStyle") || "";
                var renderStyleI = renderStyleAttrI
                    .replace(/padding.+?(;|$)/, "")
                    .replace(/display\s*?:\s*?none\s*?(;|$)/, "") + ";";
                renderStyle.push(renderStyleI);
                //获取bindName
                var bindNameI = thI.getAttribute("bindName") || "";
                bindName[i] = bindNameI;
                if (/\./.test(bindNameI)) {
                    bindDotName[i] = bindNameI.split(".");
                } else {
                    bindDotName[i] = undefined;
                }
                if (isNaN(this.numCol) && bindNameI.length && !isNaN(bindNameI - 0)) {//编号列
                    this.numCol = i;
                    bindName[i] = bindNameI - 0;
                    bindNameI = "";
                }
                //sort
                if (bindNameI === "") {
                    sort[i] = false;
                } else {
                    sort[i] = thI.getAttribute("sort") === "true" || false;
                }
                //题头文字
                theadText.push(thI.innerHTML);
                //渲染函数. 优先级 format < colRender < render  固定render在其他基础上取;
                var format    = thI.getAttribute("format"),
                    colrender = opts.colrender,
                    render    = thI.getAttribute("render");
                colRender[i] = [];
                //format
                if (format !== null) {
                    if (/money/.test(format)) {
                        colRender[i][1] = {
                            "format": Number(format.split("-")[1] || 2),
                            "callback": this.formatFn.money
                        };
                    } else if (/(dd|MM|yy)/i.test(format)) {
                        colRender[i][1] = {
                            "format": format,
                            "callback": this.formatFn.date
                        };
                    }
                }
                //单元格渲染总函数
                if (typeof colrender === "function") {
                    colRender[i][0] = {
                        "render": "colrenderFn",
                        "callback": colrender
                    };
                }
                //单列固定渲染
                if (typeof render === "string") {
                    if (new RegExp(render).test("a;button;image")) {
                        var options = thI.getAttribute("options");
                        if (options !== null) {
                            if (/{/.test(options)) {
                                try {
                                    options = JSON.parse(options);
                                } catch (e) {
                                    options = (new Function('return ' + options + ";"))();
                                } finally {
                                    if (typeof options !== "object") {
                                        options = undefined;
                                    }
                                }
                            } else {
                                options = window[options];
                            }
                        }
                        if (options) {
                            var click = options.click;
                            click = typeof click === "string" ? window[click] : click;
                            if (typeof click === "function") {
                                options.click = fixedFnClick.push(click) - 1;
                            } else {
                                options.click = "";
                            }
                            colRender[i][0] = {
                                "render" : "fiexdFn",
                                "method" : render,
                                "options": options
                            };
                        }
                    } else {
                        var renderFn = window[render];
                        if (renderFn) {
                            var colJson = {
                                "format"     : format || undefined,
                                "render"     : renderFn,
                                "renderStyle": renderStyleAttrI,
                                "text"       : theadText[i]
                            };
                            colRender[i][0] = {
                                "render"  : "renderFn",
                                "colJson": colJson,
                                "callback": renderFn
                            };
                        }
                    }
                }
            }
            //重置bindName
            var selectrows = opts.selectrows;
            if (selectrows === "multi" || selectrows === "single") {
                bindName[0] = -1;
            }
        },
        /**
         * 计算初始每一列的宽度。
         * @private
         */
        __initColWidth: function () {
            var gridWidth  = this.gridWidth,
                tableWidth = this.tableWidth || gridWidth,
                colwidth   = this.colWidth,
                colWidthBackup = this.colWidthBackup,
                sumWidth   = 0,
                setedWidth = 0,
                colSize    = this.colSize,
                autoCol    = [];
            for (var i = this.colSize; i--;) {
                var colwidthI = colwidth[i];
                colWidthBackup[i] = -1;
                if (colwidthI === "") {
                    colwidthI  = 0;
                    colwidth[i] = 200;
                    autoCol.push(i);
                } else if (/%/.test(colwidthI)) {
                    colwidthI  = Math.round(tableWidth * parseInt(colwidthI, 10) / 100);
                    colwidth[i] = colwidthI;
                } else {
                    colwidthI  = parseInt(colwidthI, 10);
                    colwidth[i] = colwidthI;
                }
                sumWidth   += colwidth[i];
                setedWidth += colwidthI;
            }
            var autoColSize   = autoCol.length;
            var remainingWidth = tableWidth - setedWidth;
            if (autoColSize > 0 && remainingWidth > autoColSize) {
                var remainingColwidth = Math.round(remainingWidth / autoColSize);
                for (var m = 0; m < autoColSize; m++) {
                    colwidth[autoCol[m]] = remainingColwidth;
                }
                colwidth[autoCol[m - 1]] += remainingWidth - remainingColwidth * autoColSize;
                this.tableWidth = tableWidth;
            } else {

                if (isNaN(this.tableWidth) && sumWidth >= gridWidth) {
                    this.tableWidth = sumWidth;
                } else {//重设
                    if (!this.tableWidth) {
                        this.tableWidth = gridWidth;
                    }
                    var newColwidth = [];
                    var allWidth = 0;
                    var last = 0;
                    for (var j = colSize; j--;) {
                        var width = Math.round(colwidth[j] * tableWidth / sumWidth);
                        allWidth += width;
                        newColwidth[j] = width;
                        last = j;
                    }
                    newColwidth[last] += tableWidth - allWidth;
                    this.colWidth = newColwidth;
                }
            }
            this.initColWidth = $.extend([], this.colWidth);
        },
        /**
         * 渲染表头 并创建相关dom
         * @private
         */
        __renderHead: function () {
            var opts            = this.options,
                domTh          = this.domTh,
                theadMap       = this.theadMap,
                theadMapLen   = this.theadMap.length,
                domHeadCol    = this.domHeadCol,
                domFixedJ     = this.domFixed[0] = [],
                theadText      = this.theadText,
                colSize        = this.colSize,
                fixcolumnnumber = opts.fixcolumnnumber,
                colhidden       = this.options.colhidden,
                sort            = this.sort,
                tr           = document.createElement("tr"),
                titleellipsis     = opts.titleellipsis;
            tr.className = "grid-width-norm";
            if (theadMapLen) {
                //控制空th的emptyth，多行表头需要。
                var emptyTh = document.createElement("th");
                emptyTh.className = "grid-empty-th";
                tr.appendChild(emptyTh);
                //去掉宽度
                for (var k = theadMapLen - 1; k--;) {
                    var theadMapK = theadMap[k];
                    for (var l = theadMapK.length; l--;) {
                        var theadMapKL = theadMapK[l];
                        theadMapKL.removeAttribute("width");
                        theadMapKL.style.width = "";
                    }
                }
            }
            for (var i = 0; i < colSize; i += 1) {
                //生成控制宽度的dom
                var th = domHeadCol[i] = document.createElement("th");
                tr.appendChild(th);
                //渲染th
                var domThI = domTh[i];
                if (i < fixcolumnnumber) {
                    $(domThI).addClass("grid-fixed");
                }
                if (sort[i]) {
                    $(domThI).addClass("grid-sort");
                }
                //CSS
                domThI.removeAttribute("width");
                domThI.style.width = "";
                //html
                var theadTextI = theadText[i];
                var thHtml = [
                    '<div class="grid-fixed-d">',
                    '<span class="grid-fixed-s">'

                ];
                if (sort[i]) {
                    thHtml.push('<b class="grid-sort-icon-desc cui-icon">&#xf0d7;</b><b class="grid-sort-icon-asc cui-icon">&#xf0d8;</b>');
                }
                thHtml.push('<a class="grid-thead-text');
                if (titleellipsis) {
                    thHtml.push('" title="', $.trim(theadTextI.replace(/<.*?>/g, "")));
                }
                thHtml.push('">' , theadTextI ,'</a>');
                if (colhidden) {
                    thHtml.push('<a class="grid-select cui-icon">&#xf0b0;</a>');
                }
                thHtml.push('<em class="grid-ittab"></em>');
                thHtml.push('</span>');
                if (i < fixcolumnnumber && !titleellipsis) {
                    thHtml.push(theadTextI);
                }
                thHtml.push('</div>');
                domThI.innerHTML = thHtml.join("");
            }

            this.gridHeadTable.html(this.elCache.find("thead").eq(0).prepend(tr));
            this.elCache.parent().remove(); //内存里面的内容没有用了，删除。
            delete this.elCache;
            //创建fixed dom 并设z-index样式
            for (var j = 0; j < fixcolumnnumber; j += 1) {
                domTh[j].getElementsByTagName("div")[0].style.zIndex = fixcolumnnumber + 1 - j;
                domFixedJ.push(domTh[j].getElementsByTagName("span")[0]);
            }
            //多选设置
            var domTh0 = $(domTh[0]);
            if (opts.selectrows === "multi") {
                domTh0.find(".grid-select").eq(0).remove();
                domTh0.find(".grid-fixed-s").addClass("grid-no-move");
                var gridTheadText = $(domTh[0]).find(".grid-thead-text").addClass("grid-all-checkbox");
                gridTheadText.html(gridTheadText.text() + "<b></b>");
                this.gridAllCheck = gridTheadText;
            }
            //单选设置 去掉隐藏列按钮
            if (opts.selectrows === "single") {
                domTh0.find(".grid-select").eq(0).remove();
                domTh0.find(".grid-fixed-s").addClass("grid-no-move");
            }
        },
        /**
         * 创建tbody基础don
         * @private
         */
        __renderBody: function () {
            var el           = this.el,
                colSize     = this.colSize,
                domBodyCol = this.domBodyCol,
                tr           = document.createElement("tr");
            tr.className = "grid-width-norm";
            for (var i = 0; i < colSize; i += 1) {
                var th = domBodyCol[i] = document.createElement("th");
                tr.appendChild(th);
            }
            el.html("<thead></thead><tbody></tbody>");
            el.find("thead").append(tr);
            this.gridTbody = el.find("tbody").eq(0);
        },
        /**
         * 加快tbody的渲染适度,生成每一行的模板.
         */
        __packageTds: function () {
            var opts            = this.options,
                fixcolumnnumber = opts.fixcolumnnumber,
                renderStyle    = this.renderStyle,
                selectrows      = opts.selectrows,
                selectrowsClass = this.selectrowsClass = {
                    "no"    : "",
                    "multi" : "grid-checkbox",
                    "single": "grid-radio"
                }[selectrows],
                colSize = this.colSize,
                leftCss = "";
            if (!this.writeStyle) {
                leftCss = "left:0px;";
            }
            //生成每一行模板。
            var firstRow = [];
            var start = 0;
            if (selectrowsClass !== "") {
                start += 1;
                var td0 = firstRow[0] = {};
                if (fixcolumnnumber > 0) {
                    td0.html = [
                        '<div class="grid-fixed-d" style="z-index:',
                        fixcolumnnumber + 1,
                        ';"><span class="grid-fixed-s ',
                        selectrowsClass,
                        '" style="',
                        leftCss,
                        renderStyle[0],
                        '/**/">',
                        '</span></div>'
                    ].join("");
                    td0.style = "";
                } else {
                    td0.style = renderStyle[0];
                    td0.className = selectrowsClass;
                }
            }
            for (var i = start; i < colSize; i += 1) {
                var tdI = firstRow[i] = {};
                if (i < fixcolumnnumber) {
                    tdI.html = [
                        '<div class="grid-fixed-d" style="z-index:',
                        fixcolumnnumber + 1 - i,
                        ';"><span class="grid-fixed-s" style="' ,
                        leftCss,
                        renderStyle[i],
                        '/**/"><!---->',
                        '</div>'
                    ].join("");
                    tdI.style = "";
                } else {
                    tdI.style = renderStyle[i];
                }
            }
            this.tdsPackage = firstRow;
        },
        /**
         * 分配列宽,隐藏列不分配宽度.
         * adaptive === true, 且 gridWidth === tableWidth 的时候用到.
         * @returns {*}
         * @private
         */
        _setColWidth: function (scrolling) {
            var initColwidth = this.initColWidth,
                colHidden     = this.colHidden,
                tableWidth    = this.tableWidth,
                colSize       = this.colSize,
                sumWidth      = 0;
            for (var i = colSize; i--;) {
                if (colHidden[i] === false) { //显示
                    sumWidth += initColwidth[i];
                }
            }
            var newColwidth = [];
            var allWidth = 0;
            var last = 0;
            for (var j = colSize; j--;) {
                if (colHidden[j] === false) {
                    var width        = Math.round(initColwidth[j] * tableWidth / sumWidth);
                    allWidth       += width;
                    newColwidth[j] = width;
                    last             = j;
                } else {
                    newColwidth[j] = 0;
                }
            }
            newColwidth[last] += tableWidth - allWidth;
            this.colWidth       = newColwidth;
            this._setColWidthStyle();
            if (scrolling) {
                this._isScrolling(true);
            }
        },
        /**
         * 设置每列宽度
         * @private
         */
        _setColWidthStyle: function (index) {
            var colwidth    = this.colWidth,
                domHeadCol = this.domHeadCol,
                domBodyCol = this.domBodyCol,
                k            = this.colSize,
                colwidthK  = "",
                colwidthIndex;
            if (typeof index === "number") {
                colwidthIndex = colwidth[index] - 1 + "px";
                domHeadCol[index].style.width = colwidthIndex;
                domBodyCol[index].style.width = colwidthIndex;
            } else {
                for (; k--;) {
                    colwidthK = colwidth[k] === 0 ? 0 : colwidth[k] - 1 + "px";
                    domHeadCol[k].style.width = colwidthK;
                    domBodyCol[k].style.width = colwidthK;
                }
            }
        },
        /**
         * 隐藏列
         */
        _colHidden: function (init) {
            var endRow         = this.endRow,
                domTh           = this.domTh,
                domTd           = this.domTd,
                tdsPackage      = this.tdsPackage,
                domHeadCol     = this.domHeadCol,
                domBodyCol     = this.domBodyCol,
                colHidden       = this.colHidden,
                colwidth        = this.colWidth,
                colWidthBackup = this.colWidthBackup,
                tableWidth      = this.tableWidth,
                theadMap        = this.theadMap,
                extendTh        = this.extendTh,
                th               = null,
                thisDomTh      = null;
            for (var i = this.colSize; i--;) {
                if (colHidden[i] === true) {
                    if (colWidthBackup[i] === -1 || init) {
                        domHeadCol[i].style.display = "none";
                        thisDomTh = domTh[i];

                        if (theadMap.length) {
                            for (var p = theadMap.length; p--;) {
                                if (!extendTh[p][i]) {
                                    th = theadMap[p][i];
                                    if (th.colSpan > 1) {
                                        th.colSpan--;
                                    } else {
                                        th.style.display = "none";
                                    }
                                }
                            }
                        } else {
                            thisDomTh.style.display = "none";
                        }
                        for (var m = endRow; m--;) {
                            domTd[m][i].style.display = "none";
                        }
                        domBodyCol[i].style.display = "none";
                        tdsPackage[i].style += "display:none;";
                        colWidthBackup[i] = colwidth[i];
                        tableWidth -= colwidth[i];
                        colwidth[i] = 0;
                    }
                } else {
                    if (colWidthBackup[i] !== -1) {
                        domHeadCol[i].style.display = "";
                        thisDomTh = domTh[i];

                        if (theadMap.length) {
                            for (var q = theadMap.length; q--;) {
                                if (!extendTh[q][i]) {
                                    th = theadMap[q][i];
                                    if (th.style.display === "none") {
                                        th.style.display = "";
                                    } else {
                                        th.colSpan += 1;
                                    }
                                }
                            }
                        } else {
                            thisDomTh.style.display = "";
                        }
                        for (var n = endRow; n--;) {
                            domTd[n][i].style.display = "";
                        }
                        domBodyCol[i].style.display = "";
                        tdsPackage[i].style = tdsPackage[i].style.replace(/display.*?($|;)/g, "");
                        colwidth[i] = colWidthBackup[i];
                        tableWidth += colWidthBackup[i];
                        colWidthBackup[i] = -1;
                    }
                }
            }
            if (!this.options.adaptive) {
                this.tableWidth = tableWidth;
            } else {
                //自适应宽度
                this.isIttab = false;
            }
            this._setLayout();
            //持久化触发
            if (this.persistence && !init) {
                this._triggerStatusChange();
            }
        },
        /**
         * 持久化触发
         * @private
         */
        _triggerStatusChange: function () {
            var opts = this.options,
                query = this.query,
                colWidth = this.colWidth,
                colWidthBackup = this.colWidthBackup,
                colHidden = this.colHidden,
                colIndex = this.colIndex,
                isWidth = !opts.adaptive,
                isIndex = this.theadMap.length === 0 && opts.colmove,
                overall = 0,
                ret, width, index, i,newJson,
                hide = [];
            for (i = this.colSize; i--;) {
                if (colHidden[i]) {
                    colWidth[i] = colWidthBackup[i];
                    hide[i] = 1;
                } else {
                    hide[i] = 0;
                }
                overall += colWidth[i];
            }
            newJson = {
                "hide" : colHidden,
                "sortName" : query.sortName,
                "sortType" : query.sortType,
                "overall" : overall
            };
            if(window.JSON && JSON.stringify) {
                if (isIndex){
                    newJson.index = colIndex;
                }
                if (isWidth) {
                    newJson.width = colWidth;
                }
                ret = JSON.stringify(newJson);
            } else {
                ret = ["{",
                    isIndex ? ["\"index\":[", colIndex.join(","), "],"].join("") : "",
                    isWidth ? ["\"width\":[", colWidth.join(","), "],"].join("") : "",
                    "\"hide\":[", hide.join(","), "],",
                    "\"sortName\":[\"", query.sortName.join("\",\""), "\"],",
                    "\"sortType\":[\"", query.sortType.join("\",\""), "\"],",
                    //"\"width-backup\":[", colWidthBackup.join(","), "],",
                    "\"overall\":", overall,
                    "}"
                ].join("");
            }
            this.options.onstatuschange(ret);
        },
        /**
         * 判断横竖方向是否有滚动条
         * @private
         */
        _isScrolling: function (unSetColwidth) {
            var el             = this.el,
                gridWidth     = this.gridWidth + 2,
                tableWidth    = this.tableWidth,
                boxHeight     = this.boxHeight,
                contentHeight = el.height(),
                gridScroll    = this.gridScroll;
            if (this.options.adaptive && !this.isIttab) {
                //竖滚动条
                if (boxHeight < contentHeight) {
                    tableWidth = this.tableWidth = gridWidth - 17;
                } else {//没有滚动条
                    this.tableWidth = gridWidth;
                    tableWidth = gridWidth + 1;
                }
                el.css("width", tableWidth);
                this.gridHeadTable.css("width", tableWidth);
                // gridScroll[0].scrollLeft = 0;
                gridScroll.css("left", "-999999px");
                if (!unSetColwidth) {
                    this._setColWidth(true);
                    this._setLayout(true);
                }
            } else {
                //只有竖向滚动条
                if (boxHeight < contentHeight &&
                    gridWidth >= tableWidth + 17) {
                    this.gridTableHide.css("marginBottom", 0);
                    gridScroll.css({"left": "-999999px", "width" : gridWidth - 17});
                }
                //只有横向滚动条
                if (gridWidth < tableWidth &&
                    boxHeight >= contentHeight + 17) {
                    gridScroll.css({"width": gridWidth, "left" : 0, "bottom": ""});
                    gridScroll.css("bottom", 0);
                    this.gridTableHide.css("marginBottom", 17);
                }
                //双向滚动条;
                if (gridWidth < tableWidth + 17 &&
                    boxHeight < contentHeight || gridWidth < tableWidth &&
                    boxHeight < contentHeight + 17) {
                    gridScroll.css({"width": gridWidth - 17, "left" : 0, "bottom": ""});
                    gridScroll.css("bottom", 0); //由于Grid高度改变时，gridScroll的位置并不跟着改变（IE6）
                    this.gridTableHide.css("marginBottom", 17); //有横向
                }
                //没有滚动条
                if (boxHeight >= contentHeight &&
                    gridWidth >= tableWidth) {
                    this.gridTableHide.css("marginBottom", 0);
                    gridScroll.css({"left": "-999999px", "width" : gridWidth});
                }
            }
            gridScroll.find("div").eq(0).css("width", tableWidth);
            //重置滚动条
            clearTimeout(this.sc);
            this.sc = setTimeout (function () {
                gridScroll.scroll();
            }, 10);
        },
        /**
         * 高度自适应的时候,重新设置高度
         * @private
         */
        _setAutoHeight: function () {
            var gridTableBox, lineHeight;
            if (this.autoHeight) {
                gridTableBox = this.gridTableBox;
                lineHeight = 28;
                var marginBottom = parseInt(gridTableBox.css("marginBottom"), 10) || 1;
                var tableHeight;
                if(this.rowSize===0){
                    tableHeight=50;
                }else{
                    tableHeight = gridTableBox.height() || this.rowSize * lineHeight;
                }
               // var tableHeight = Math.max(gridTableBox.height() || this.rowSize * lineHeight, 50);

                this._setHeight(tableHeight + marginBottom + this.theadHeight + (this.options.pagination && this.rowSize ? 41 : 0) + 2);
            }
        },
        /**
         * 布局:包括外框宽高设置,col宽度设置.
         * @private
         */
        _setLayout: function (notSetScrolling) {
            this._setStyleWidth();
            //重设题头高度
            if (this.options.fixcolumnnumber || !this.options.titleellipsis) {
                this._setTheadHeight();
            }

            if(this.autoHeight){
                this._setAutoHeight();
            }

            this._setStyleHeight();

            if (!notSetScrolling) {
                this._isScrolling();
            }

        },
        /**
         * 题头允许换行时需要调用
         * @private
         */
        _setTheadHeight: function () {
            this.gridHead.css("height", "auto");
            var newTheadHeight = this.theadHeight = this.gridHead.height(),
                domFixed0      = this.domFixed[0],
                isQm = this.isQm;
            this.boxHeight      = this.gridHeight - this.paginationHeight - newTheadHeight - 1;
            this.gridOverlay.css("height", newTheadHeight);
            for (var i = domFixed0.length; i--;) {
                var domFixed0I = domFixed0[i],
                    div = $(domFixed0I).parent(),
                    thHeight = parseInt(div.parent().height(), 10),
                    paddingTop = parseInt((thHeight - (div.height() || 21)) / 2, 10);
                paddingTop = paddingTop < 0 ? 0 : paddingTop;
                domFixed0I.style.paddingTop = paddingTop + "px";
                domFixed0I.style.height = thHeight - (isQm ? 0 : (paddingTop + 1)) + "px";
            }
        },
        /**
         * 设置持久化数据
         * @param {String} config
         */
        setConfig: function (config) {
            if (this.persistence && this.unRender) {
                this._setPersistence(config);
            }
            this.options.datasource(this, this.getQuery());
        },
        /**
         * 加载数据
         */
        setDatasource: function (data, totalSize, persistenceConf) {
            if (this.persistence && this.unRender && typeof persistenceConf === "string") {
                this._setPersistence(persistenceConf);
            }
            data = data || [];
            totalSize = totalSize || 0;
            this.rowSize = data.length;
            this.data = $.extend(true, [], data);
            //处理分页
            if (this.options.pagination) {
                this.totalSize = totalSize;
                //第一次渲染,加载分页
                if (this.unRender) {
                    this.__createPagination();
                } else {
                    this._changepages();
                }
            }
            this._isEmpty();
            //渲染开始
            this._initProperty();
            this._renderTbody(NaN, NaN);

            this._loading("hide");
            this._loadComplateCallBack();
            this.__setSortStyle();

            if(this.autoHeight && typeof this.options.resizewidth === "function") {
                this.resize();
                this._setLayout();
            } else {
                this._setLayout();
            }
            delete this.unRender;
        },
        /**
         * 持久化还原设置
         * @private
         */
        _setPersistence : function (conf) {
            var json,
                opts = this.options,
                colSize = this.colSize,
                index, sortName,sortType, hide, width, i;
            if (typeof conf === "string") {
                try {json = $.parseJSON(conf);} catch(e) {}
                if (json) {
                    if (json.overall) {
                        this.tableWidth = json.overall;
                        this.gridHeadTable.css("width", this.tableWidth);//是否要设置table的宽度
                    }
                    index = json.index;
                    if (this.theadMap.length === 0 && opts.colmove &&
                        typeof index === "object" && colSize === index.length) {
                        this.colIndex = index;
                        this._sortPropertys(index);
                    }
                    this._createPropertys();
                    sortName = json.sortName;
                    sortType = json.sortType;
                    if ($.type(sortName) === "array" && $.type(sortType) === "array") {
                        this.setQuery({
                            sortName : sortName,
                            sortType : sortType
                        });
                    }
                    hide = json.hide;
                    if (typeof hide === "object" && colSize === hide.length) {
                        for (i = 0; i < colSize; i ++) {
                            hide[i] = !!hide[i];
                        }
                        this.colHidden = hide;
                    }
                    width = json.width;
                    if (!opts.adaptive && typeof width === "object" &&
                        colSize === width.length) {//自适应模式下，不支持列宽持久化。
                        this.colWidth = width;
                    }
                } else {
                    this._createPropertys();
                }
            } else {
                this._createPropertys();
            }
            this._createContent();
        },
        /**
         * 持久化设置排序
         * @private
         */
        _sortPropertys: function (index) {
            var colSize = this.colSize, thsBox,
                domTh, newDomTh, i;
            domTh = this.domTh;
            newDomTh = [];
            thsBox = domTh[0].parentNode;
            for (i = 0; i < colSize; i++) {
                newDomTh[i] = domTh[index[i]];
                thsBox.appendChild(newDomTh[i]);
            }
            this.domTh = newDomTh;
        },
        /**
         * 是否数据是空
         * @private
         */
        _isEmpty: function () {
            var opts = this.options;
            var rowSize = this.rowSize;
            //判断是否显示分页

            if (rowSize === 0) {
                this.gridEmpty.show();
                this.gridTfoot.hide();
                this.paginationHeight = 0;
                var self = this;
                this.gridTableBoxTomer=setTimeout(function(){
                    self.gridTableBox.hide();
                },10);
            } else {
                this.gridEmpty.hide();
                this.gridTableBox.show();
                clearTimeout(this.gridTableBoxTomer);
                if (opts.pagination) {
                    this.gridTfoot.show();
                    this.paginationHeight = 41;
                }
            }
            //根据分页 重设boxHeight
            this.boxHeight = this.gridHeight - this.paginationHeight - this.theadHeight;
        },
        /**
         * 重载数据,需要初始化属性
         * @private
         */
        _initProperty: function () {
            var self = this,
                gridTbody,
                hasTrs = this.domTr.length > 0;
            setTimeout(function () {
                self.gridBody[0].scrollTop = 0;
            }, 1);
            this.gridTableBox.removeAttr("style");
            this.domTr           = [];
            this.domTd           = [];
            this.domFixed.length = 1;
            this.multiChecked    = [];
            this.multiCheckedNum= 0;
            this.singleChecked   = NaN;
            this.disabledIndex = [];
            this.odd              = false;
            this.endRow          = 0;
            this.renderComplete  = false;
            if (this.gridAllCheck) {
                this.gridAllCheck.removeClass("grid-all-checkbox-checked");
            }
            if (hasTrs) {
                this.el[0].removeChild(this.gridTbody[0]);
                gridTbody = document.createElement("tbody");
                this.el[0].appendChild(gridTbody);
                this.gridTbody = $(gridTbody);
            }
            //this.gridTbody.html("");
            //大数据量的两个参数
            this.trStart = 0;
            this.trEnd = 0;
        },
        /**
         * 载入数据
         */
        loadData: function () {
            this._loading("show");
            this.options.datasource(this, this.getQuery());
        },
        /**
         * 追加数据
         * @public
         */
        addData: function (data, position) {
            if ($.type(data) === "object") {
                data = [data];
            }
            var len = data.length,
                opts = this.options,
                disabledIndex = this.disabledIndex;
            if (len === 0) {
                return;
            }
            data = $.extend(true, [], data);
            if (this.unRender) { //如果未 setDatasource过.
                this.setDatasource(data);
                return;
            }
            var selectrows  = opts.selectrows;
            if (typeof position === "number" && position < this.rowSize) {
                this._spliceArray(this.data, position, data);
                if (opts.primarykey && disabledIndex.length) {
                    this._spliceArray(disabledIndex, position, new Array(len));
                }
                if (selectrows === "multi") {
                    this._spliceArray(this.multiChecked, position, new Array(len));
                } else if (selectrows === "single" && position < this.singleChecked) {
                    this.singleChecked += len;
                }
            } else {
                this.data = this.data.concat(data);
            }
            this.rowSize += len;
            this._isEmpty();
            this._renderTbody(len, position);
            if (this.paginationObj) {
                this._changepages();
            }

            var adddataCallback = opts.adddata_callback;
            if (typeof adddataCallback === "function") {
                adddataCallback.call(this, data);
            }
            if(this.autoHeight && typeof opts.resizewidth === "function") {
                this.resize();
            } else {
                this._setLayout();
            }
        },
        setPagerText:function(text){
            if(typeof text==="string"){
                this.customerText =text;
            }
        },
        /**
         * 渲染分页
         * @private
         */
        __createPagination: function () {
            var opts = this.options,
                query = this.query;
            if (!opts.pagination) {
                return;
            }
            var self = this;
            window.cui(this.gridTfoot).pagination({
                count         : this.totalSize,
                pagesize      : query.pageSize,
                pageno        : query.pageNo,
                pagesize_list : opts.pagesize_list,
                tpls          : {pagination: opts.pagination_model},
                cls           : opts.pagination_model,
                customerText  : this.customerText,
                on_page_change: function (pageno, pagesize) {
                    query.pageNo = pageno;
                    query.pageSize = pagesize;
                    self.loadData();
                    self._changepages();
                }
            });
            this.paginationObj = window.cui(this.gridTfoot);
        },
        /**
         * 翻页事件
         * @private
         */
        _changepages: function () {
            var query = this.query;
            this.paginationObj.setInitData({
                count : this.totalSize,
                pagesize : query.pageSize,
                pageno   : query.pageNo
            });
            this.paginationObj.reDraw();
        },
        /**
         * 中间插入数组
         * @private
         */
        _spliceArray: function (source, position, target) {
            Array.prototype.splice.apply(source, [position, 0].concat(target));
            return source;
        },
        /**
         * 渲染tbody
         * @private
         */
        _renderTbody: function (addSize, position) {
            var data        = this.data,
                endRow     = this.endRow,
                rowSize    = this.rowSize,
                renderRows = parseInt(this.boxHeight / 28, 10) + 20,
                ellipsis    = this.options.ellipsis;
            if (rowSize === 0) {
                this.renderComplete      = true;
                this.appendRowsComplete = true;
                return;
            }
            this.renderComplete = false;
            if (!isNaN(addSize)) {
                //全选取消选中
                if (this.gridAllCheck) {
                    this.gridAllCheck.removeClass("grid-all-checkbox-checked");
                }
                if (typeof position === "number" && position < endRow) { //中间插入行
                    //删除index属性.
                    var domTr = this.domTr;
                    for (var j = position; j < endRow; j += 1) {
                        domTr[j].removeAttribute("index");
                    }
                    var positionTr = domTr[position],
                    //获取dom
                        dom = this._dataToDom(data, position, position + addSize),
                        addTr = dom.domTr;
                    this._spliceArray(this.domTr, position, addTr);
                    this._spliceArray(this.domTd, position, dom.domTd);
                    this._spliceArray(this.domFixed, position + 1, dom.domFixed);
                    //插入dom
                    if (position >= this.trStart && position < this.trEnd || !ellipsis) {
                        var gridTbody = this.gridTbody[0];
                        for (var i = 0; i < addSize; i += 1) {
                            gridTbody.insertBefore(addTr[i], positionTr);
                        }
                        if (ellipsis) {
                            this.trEnd += addSize;
                        }
                    } else {
                        if (position < this.trStart && ellipsis) {
                            this.trStart += addSize;
                            this.trEnd += addSize;
                        }
                        var trFrag = this.trFrag;
                        for (var k = 0; k < addSize; k += 1) {
                            trFrag.appendChild(addTr[k]);
                        }
                    }
                    this.endRow += addSize;
                    this._setAutoHeight();
                    this._setOddEven(position);
                    this._setNum(position);
                } else {
                    this._lazyload();
                }
            } else {
                var end = Math.min(rowSize, endRow + renderRows + 1);
                if (ellipsis) {
                    this.trEnd = end;
                }
                this._appendRows(endRow, end);
            }
        },
        /**
         * 渲染完成回调
         * @private
         */
        _loadComplateCallBack: function () {
            var loadcomplateCallback = this.options.loadcomplate_callback;
            if (typeof loadcomplateCallback === "function") {
                loadcomplateCallback.call(this, this);
            }
        },
        /**
         * 设置排序样式
         * @private
         */
        __setSortStyle: function () {
            var query = this.query,
                sortType = query.sortType,
                sortName = query.sortName,
                len = sortName.length,
                bindName     = this.bindName,
                domTh        = this.domTh,
                i, j, domThJ, bindNameJ, className,
                sortStr = {"DESC":"desc", "ASC" : "asc"};
            loopOuter:for (j = this.colSize; j--;) {
                bindNameJ = bindName[j];
                //如果是选择列，则跳出
                if(bindNameJ === -1){
                    continue loopOuter;
                }
                domThJ = $(domTh[j]);
                for (i = 0; i < len; i++) {
                    domThJ.find("b").hide();
                    if (sortName[i] === bindNameJ) {
                        domThJ.find(".grid-sort-icon-" + sortStr[sortType[i]].toLocaleLowerCase()).show();
                        continue loopOuter;
                    }
                }
            }
        },
        /**
         * data转换成每一行的dom
         * @param data
         * @param start
         * @param end
         * @returns {{domTd: Array, domTr: Array, domFixed: Array}}
         * @private
         */
        _dataToDom: function (data, start, end) {
            var opts                = this.options,
                oddEvenClass        = this.oddEvenClass,
                oddevenrow          = opts.oddevenrow,
                ellipsis            = opts.ellipsis,
                colSize            = this.colSize,
                domTh              = this.domTh,
                tdsPackage         = this.tdsPackage,
                bindName           = this.bindName,
                bindDotName       = this.bindDotName,
                fixcolumnnumber     = opts.fixcolumnnumber,
                numCol             = this.numCol,
            //单元格内容渲染
                colRender          = this.colRender,
            //样式渲染
                rowstylerender      = opts.rowstylerender,
                colstylerender      = opts.colstylerender,
                rowstylerenderAble = typeof rowstylerender === "function",
                colstylerenderAble = typeof colstylerender === "function",
                renderMethod       = this.renderMethod,
                heightLight        = this.heightLight,
                colStart           = (this.selectrowsClass !== "") ? 1 : 0,
                odd                 = this.odd,
                primarykey          = opts.primarykey,
                ispk                = typeof data[0] === "object" && data[0].hasOwnProperty(primarykey),
                createDomBox      = this.createDomBox,
                table = ['<table>'];
            for (var j = start; j < end; j += 1) {
                table.push('<tr class="');
                if (oddevenrow) {
                    if (odd) {
                        table.push(oddEvenClass);
                    }
                    odd = !odd;
                }
                if (heightLight[j]) {
                    table.push(" grid-highlight");
                }
                table.push('"');
                var dataJ = data[j];
                if (ispk && dataJ.hasOwnProperty(primarykey)) {
                    table.push(' pkey="');
                    table.push(String(dataJ[primarykey]));
                    table.push('"');
                }
                if (rowstylerenderAble) {
                    var rowstyle = rowstylerender(dataJ);
                    if (typeof rowstyle === "string") {
                        table.push(' style="', rowstyle, '"');
                    }
                }
                table.push('>');
                if (colStart === 1) {
                    var tdsPackage0 = tdsPackage[0];
                    table.push('<td class="grid-select-input ');
                    if (fixcolumnnumber > 0) {
                        table.push('grid-fixed');
                        table.push('" style="', tdsPackage0.style, '">', tdsPackage0.html, '</td>');
                    } else {
                        table.push(tdsPackage0.className);
                        table.push('" style="', tdsPackage0.style, '"></td>');
                    }

                }
                var tdsPackageI   = "",
                    colstyle        = "",
                    bindNameI     = "",
                    bindDotNameI = "",
                    value           = "",
                    tmpValue    =    "",
                    render          = "",
                    colRenderI    = null,
                    colRenderI0  = null,
                    colRenderI1  = null,
                    colJson        = null;
                for (var i = colStart; i < fixcolumnnumber; i += 1) {
                    bindNameI = bindName[i];
                    bindDotNameI = bindDotName[i];
                    //渲染文字
                    if (numCol === i) {
                        value = j + bindNameI;
                    } else {
                        if (!bindNameI) {
                            value = "";
                        } else {
                            if (typeof bindDotNameI === "undefined") {
                                value = dataJ[bindNameI];
                            } else {
                                value = dataJ[bindDotNameI[0]];
                                if (value && typeof value === "object") {
                                    value = value[bindDotNameI[1]] || "";
                                } else {
                                    value = "";
                                }
                            }
                        }
                    }
                    var tagHtml   = "", method = "";
                    colRenderI   = colRender[i];
                    colRenderI0 = colRenderI[0];
                    colRenderI1 = colRenderI[1];
                    if (colRenderI1) {
                        value = colRenderI1.callback(value, colRenderI1.format) || value;
                    }
                    if (colRenderI0) {
                        render = colRenderI0.render;
                        method = colRenderI0.method;
                        switch (render) {
                            case "colrenderFn" :
                                value = colRenderI0.callback(dataJ, bindNameI) || value;
                                break;
                            case "renderFn" :
                                colJson = colRenderI0.colJson;
                                colJson.el = domTh[i];
                                colJson.bindName = bindNameI;
                                value = colRenderI0.callback(dataJ, j, colJson) || value;
                                break;
                            case "fiexdFn" :
                                value = renderMethod[method](dataJ, colRenderI0.options, value) || value;
                                break;
                        }
                    }
                    if (method === "button" || ellipsis) {
                        tagHtml = [value, "</span>"].join("");
                    } else {
                        tagHtml = [value, "</span>", value].join("");
                    }
                    tdsPackageI = tdsPackage[i];
                    var html = tdsPackageI.html.replace("<!---->", tagHtml);
                    table.push('<td class="grid-fixed" style="', tdsPackageI.style, '">');
                    if (colstylerenderAble) {
                        colstyle = colstylerender(dataJ, bindNameI);
                        if (typeof colstyle === "string") {
                            html = html.replace("/**/", colstyle);
                        }
                    }
                    table.push(html, '</td>');
                }
                for (; i < colSize; i += 1) {
                    bindNameI = bindName[i];
                    bindDotNameI = bindDotName[i];
                    tdsPackageI = tdsPackage[i];
                    if (numCol === i) {
                        value = j + bindNameI;
                    } else {
                        if (!bindNameI) {
                            value = "";
                        } else {
                            if (typeof bindDotNameI === "undefined") {
                                value = dataJ[bindNameI];
                            } else {
                                value = dataJ[bindDotNameI[0]];
                                if (value && typeof value === "object") {
                                    value = value[bindDotNameI[1]] || "";
                                } else {
                                    value = "";
                                }
                            }
                        }
                    }
                    colRenderI   = colRender[i];
                    colRenderI0 = colRenderI[0];
                    colRenderI1 = colRenderI[1];
                    if (colRenderI1) {
                        tmpValue = colRenderI1.callback(value, colRenderI1.format);
                        value = (tmpValue === null || tmpValue === undefined) ? value : tmpValue;
                    }
                    if (colRenderI0) {
                        render = colRenderI0.render;
                        switch (render) {
                            case "colrenderFn" :
                                tmpValue = colRenderI0.callback(dataJ, bindNameI);
                                value = (tmpValue === null || tmpValue === undefined) ? value : tmpValue;
                                break;
                            case "renderFn" :
                                colJson          = colRenderI0.colJson;
                                colJson.el       = domTh[i];
                                colJson.bindName = bindNameI;
                                tmpValue         = colRenderI0.callback(dataJ, j, colJson);
                                value            = (tmpValue === null || tmpValue === undefined) ? value : tmpValue;
                                break;
                            case "fiexdFn" :
                                tmpValue = renderMethod[colRenderI0.method](dataJ, colRenderI0.options, value);
                                value = (tmpValue === null || tmpValue === undefined) ? value : tmpValue;
                                break;
                        }
                    }
                    //绑定td样式
                    var tdStyle = tdsPackageI.style;
                    if (colstylerenderAble) {
                        colstyle = colstylerender(dataJ, bindNameI);
                        if (typeof colstyle === "string") {
                            tdStyle += ";" + colstyle;
                        }
                    }
                    table.push('<td style="', tdStyle, '">', value, '</td>');
                }
                table.push('</tr>');
            }
            this.odd = odd;
            table.push('</table>');
            createDomBox.innerHTML = table.join("");
            var domTr           = [],
                domTd           = [],
                domFixed        = [],
                selectedRowClass = " " + this.selectedRowClass,
                disableIndex = this.disabledIndex,
                multiChecked    = this.multiChecked,
                singleChecked   = this.singleChecked,
                domTable        = createDomBox.getElementsByTagName("table")[0];
            for (var m = 0, len = end - start; m < len; m += 1) {
                var domTrM = domTable.rows[m];
                domTr.push(domTrM);
                var domTdM = [];
                var domFixedM = [];
                for (var n = 0; n < colSize; n += 1) {
                    var domThN = domTrM.cells[n];
                    domTdM.push(domThN);
                    if (n < fixcolumnnumber) {
                        domFixedM.push(domThN.getElementsByTagName("span")[0]);
                    }
                }
                if (disableIndex[m + start]) {
                    domTrM.addClass("grid-disable-row");
                } else if (multiChecked[m + start]) {
                    domTrM.className += selectedRowClass;
                    //因为此版本已经不存在checkbox，所以要把下面代码删除掉
                    //domTrM.cells[0].getElementsByTagName("input")[0].setAttribute("checked", "checked");
                }
                domTd.push(domTdM);
                domFixed.push(domFixedM);
            }
            if (!isNaN(singleChecked) &&
                singleChecked >= start &&
                singleChecked < end && !disableIndex[singleChecked]) {
                var selectRow = domTable.rows[singleChecked - start];
                selectRow.className += selectedRowClass;
                //因为此版本已经不存在checkbox，所以要把下面代码删除掉
                //selectRow.cells[0].getElementsByTagName("input")[0].setAttribute("checked", "checked");
            }
            return {
                domTd: domTd,
                domTr: domTr,
                domFixed: domFixed
            };

        },
        /**
         * 后面插入行
         * @param start
         * @param end
         * @private
         */
        _appendRows: function (start, end) {
            var rowSize   = this.rowSize;
            if (this.autoHeight || !this.options.lazy) {
                end = rowSize;
            }
            end            = this.endRow = Math.min(rowSize, end);
            var dom        = this._dataToDom(this.data, start, end);
            this.domTr    = this.domTr.concat(dom.domTr);
            this.domTd    = this.domTd.concat(dom.domTd);
            this.domFixed = this.domFixed.concat(dom.domFixed);
            var domTr     = this.domTr;
            var gridTbody = this.gridTbody[0];
            for (var i = start; i < end; i += 1) {
                gridTbody.appendChild(domTr[i]);
            }
            this.gridTableBox.css("paddingBottom", (rowSize - end) * 28);
            this.renderComplete = end === rowSize;
            this.appendRowsComplete = true;
            this._setAutoHeight();
        },
        /**
         * 重新设置奇数偶数行样式
         * @private
         */
        _setOddEven: function (position) {
            var opts         = this.options;
            if (!opts.oddevenrow) {
                return;
            }
            var domTr       = this.domTr,
                endRow      = this.endRow,
                oddEvenClass = this.oddEvenClass,
                odd          = this.odd = position % 2 === 0,
                i            = position;
            for (; i < endRow; i += 1) {
                if (!odd) {
                    $(domTr[i]).addClass(oddEvenClass);
                } else {
                    $(domTr[i]).removeClass(oddEvenClass);
                }
                odd = !odd;
            }
        },
        /**
         * 重设行号
         * @private
         */
        _setNum: function (position) {
            if (isNaN(this.numCol)) {
                return;
            }
            var domTd    = this.domTd,
                domFixed = this.domFixed,
                numCol   = this.numCol,
                start     = this.bindName[numCol],
                i         = position,
                endRow   = this.endRow;
            if (this.options.fixcolumnnumber > numCol) {
                for (; i < endRow; i += 1) {
                    var domFixedI = domFixed[i + 1][numCol];
                    var value = i + start;
                    domFixedI.innerHTML = value;
                    domFixedI.nextSibling.nodeValue = value;
                }
            } else {
                for (; i < endRow; i += 1) {
                    domTd[i][numCol].innerHTML = i + start;
                }
            }
        },
        /**
         * 隐藏列
         * @param hideBindName
         */
        hideCols: function (hideBindName) {
            if ($.type(hideBindName) !== "object") {
                return;
            }
            var colHidden = this.colHidden,
                colSize   = this.colSize,
                bindName  = this.bindName;
            for (var i = 0; i < colSize; i += 1) {
                var falg = hideBindName[bindName[i]];
                if (typeof falg === "boolean") {
                    colHidden[i] = falg;
                }
            }
            this._colHidden(false);
        },
        /**
         * 获取查询参数
         */
        getQuery: function () {
            var newQuery = $.extend(true, {}, this.query),
                customQuery = this.customQuery;
            if (!customQuery) {
                return newQuery;
            }
            customQuery.pageSize = newQuery.pageSize;
            customQuery.pageNo = newQuery.pageNo;
            customQuery.sortName = $.extend([], newQuery.sortName);
            customQuery.sortType = $.extend([], newQuery.sortType);
            return customQuery;
        },
        /**
         * 设置查询参数
         * @param query
         */
        setQuery: function (query) {
            if (typeof query === "object") {
                this.customQuery = query;
            }
            query         = query || this.backupQuery;
            var sortstyle = this.options.sortstyle,
                newQuery = this.query;
            if (typeof query.pageSize === "number") {
                newQuery.pageSize = query.pageSize;
            }
            if (typeof query.pageNo === "number") {
                newQuery.pageNo = query.pageNo;
            }
            if ($.type(query.sortName) === "array") {
                newQuery.sortName = $.extend([], query.sortName);
                if (newQuery.sortName.length > sortstyle) {
                    newQuery.sortName.length = sortstyle;
                }
            }
            if ($.type(query.sortType) === "array") {
                newQuery.sortType = $.extend([], query.sortType);
                if (newQuery.sortType.length > sortstyle) {
                    newQuery.sortType.length = sortstyle;
                }
            }
            this._setPageSize();
            this._setSortTypeObj();
        },
        /**
         * 内部用的设置高度
         * @param height
         * @private
         */
        _setHeight: function (height) {
            if (typeof height !== "number"){// || height - 2 === this.gridHeight) {
                return false;
            }
            height          -= 1;
            this.boxHeight -= this.gridHeight - height;
            this.gridHeight = height;
            //this.isIttab = false;
            //高度改变,触发延迟加载
            this._lazyload();
            //this._setLayout();
            if (this.options.colhidden && this.hideCol.hideCol) {
                this.hideCol.hideCol.blur();
            }
            return true;
        },
        /**
         * 设置组件高度
         */
        setHeight: function (height) {//这个函数 要考虑分页部分的高度.
            this.autoHeight = !this._setHeight(height);
            this._setLayout();
        },
        /**
         * 设置组件宽度
         */
        setWidth: function (width) {
            if (typeof width !== "number" || width - 2 === this.gridWidth) {
                return;
            }
            var ittab = this.ittab; //修复IE下面出现滚动条，触发resize的bug
            if (ittab && ittab.ittabActive) {
                return;
            }
            width -= 2;
            if (this.options.adaptive) {
                this.tableWidth = width - 17;
                this.isIttab = false;
            }
            this.gridWidth = width;
            this._setLayout();
            if (this.options.colhidden && this.hideCol.hideCol) {
                this.hideCol.hideCol.blur();
            }
        },
        /**
         * 设置行高亮
         * @param pk
         * @param flag
         */
        setHighLight: function (pk, flag) {
            var primarykey = this.options.primarykey,
                data = this.data,
                endRow = this.endRow;
            if (data[0] && data[0].hasOwnProperty(primarykey)) {
                for (var j = this.rowSize; j--;) {
                    if (data[j][primarykey] === pk) {
                        if (j < endRow) {
                            if (flag !== false) {
                                $(this.domTr[j]).addClass("grid-highlight");
                            } else {
                                $(this.domTr[j]).removeClass("grid-highlight");
                            }
                        }
                        this.heightLight[j] = flag !== false;
                        break;
                    }
                }
            }
        },
        /**
         * 通过序列选择行
         * @param index
         * @param flag
         * @returns {Array}
         */
        selectRowsByIndex: function (index, flag) {
            flag = flag !== false;
            var opts = this.options,
                selectrows = opts.selectrows,
                data = this.data,
                ret = [],
                index0, indexI,
                disabledIndex = this.disabledIndex;
            if (selectrows === "no" || index >= this.rowSize) {
                return [];
            }
            if (flag !== false) {
                flag = true;
            }
            if (typeof index === "number") {
                index = [index];
            }
            if (selectrows === "single") {
                index0 = index[0];
                if (index0 > -1 && !disabledIndex[index0]) {
                    this._selectRows(index0, flag);
                    ret.push(data[index0]);
                }
            } else {
                for (var i = 0, len = index.length; i < len; i += 1) {
                    indexI = index[i];
                    if (!disabledIndex[i]) {
                        this._selectRows(indexI, flag);
                        ret.push(data[indexI]);
                    }
                }
            }
            return ret;
        },
        /**
         * 通过主键获取行号
         * @param pks
         * @param getInvalid
         * @returns {Array}
         * @private
         */
        _pkToIndex: function (pks, getInvalid) {
            var data = this.data,
                rowSize = this.rowSize,
                primarykey = this.options.primarykey;
            if (data[0].hasOwnProperty(primarykey) === false || pks === undefined) {
                return [];
            }
            if ($.type(pks) !== "array") {
                pks = [pks];
            }
            var len = pks.length;
            var indexs = [];
            for (var i = 0; i < len; i += 1) {
                var pksI = pks[i],
                    hasVal = false;
                for (var j = rowSize; j--;) {
                    if (data[j][primarykey] === pksI) {
                        indexs.push(j);
                        hasVal = true;
                        break;
                    }
                }
                if (!hasVal && getInvalid) {
                    indexs.push(-1);
                }
            }
            return indexs;
        },
        /**
         * 根据主键查找索引号
         * @param pk
         */
        getIndexByPk: function (pk) {
            if (pk === undefined) {
                return;
            }
            return this._pkToIndex(pk, true)[0];
        },

        /**
         * 通过主键选择行
         * @param pks
         * @param flag
         * @returns {*}
         */
        selectRowsByPK: function (pks, flag) {
            var opts = this.options;
            if ("array string number".indexOf($.type(pks)) === -1 ||
                opts.selectrows === "no" || !this.rowSize ||
                this.data[0].hasOwnProperty(opts.primarykey) === false) {
                return [];
            }
            return this.selectRowsByIndex(this._pkToIndex(pks, true), flag);
        },
        /**
         * 禁用pk为啥啥啥的不能被选择，选中的便取消。
         * @param pks
         * @param flag
         */
        disableRows: function (pks, flag) {
            var
                opts = this.options,
                type = $.type(pks),
                indexs, indexsI,
                i, len,
                domTr, tr,
                disabledIndex = this.disabledIndex;
            if ("array string number".indexOf(type) === -1 ||
                opts.selectrows === "no" || !this.rowSize ||
                this.data[0].hasOwnProperty(opts.primarykey) === false) {
                return;
            }
            flag = flag === undefined ? true : flag;
            if (flag) {
                this.selectRowsByPK(pks, false);
            }

            indexs = this._pkToIndex(pks, false);

            domTr = this.domTr;
            for (i = 0, len = indexs.length; i < len; i++) {
                indexsI = indexs[i];
                tr = $(domTr[indexsI]);
                if (flag) {
                    tr.addClass("grid-disable-row");
                } else {
                    tr.removeClass("grid-disable-row");
                }
                disabledIndex[indexsI] = flag;
            }
        },

        /**
         * 删除行操作.
         */
        _removeRow: function (row) {
            var data = this.data;
            var removeData = data[row];
            this.data.splice(row, 1);
            $(this.domTr[row]).remove();
            this.domTr.splice(row, 1);
            this.domTd.splice(row, 1);
            this.multiChecked.splice(row, 1);
            this.disabledIndex.splice(row, 1);
            if (this.singleChecked > row){
                this.singleChecked--;
            }
            this.domFixed.splice(row + 1, 1);
            return removeData;
        },
        /**
         * 删除行
         */
        removeData: function (rows) {
            if (typeof rows === "number" || $.type(rows) === "array") {
                if (typeof rows === "number") {
                    rows = [rows];
                }
                rows.sort(function (a, b) {
                    return a - b;
                });
                var len            = rows.length,
                    removeDatas   = [],
                    singleChecked = this.singleChecked,
                    multiChecked  = this.multiChecked,
                    opts           = this.options,
                    selectrows     = opts.selectrows,
                    ellipsis       = opts.ellipsis,
                    endRow = this.endRow;
                for (var i = 0; i < len; i += 1) {
                    var rowsI = rows[i] - i;
                    var thisRowSize = this.rowSize;
                    if (isNaN(rowsI) || rowsI >= thisRowSize) {
                        rows[i] = 0;
                        break;
                    }
                    this.rowSize = thisRowSize - 1;
                    if (rowsI < endRow) {
                        if (ellipsis) {
                            if (rowsI < this.trEnd) {
                                this.trEnd--;
                            }
                            if (rowsI < this.trStart){
                                this.trStart--;
                            }
                        }
                        this.endRow --;
                    }
                    //选中重设
                    if (selectrows === "multi") {
                        if (multiChecked[rowsI] === true) {
                            this.multiCheckedNum--;
                        }
                    } else if (selectrows === "single" && singleChecked === rowsI) {
                        this.singleChecked = NaN;
                    }
                    var removeData = this._removeRow(rowsI);
                    if (removeData) {
                        removeDatas.push(removeData);
                    }
                }
                var rowSize = this.rowSize;
                //判断是否需要跳转上一页
                if (rowSize <= 0) {
                    if (this.query.pageNo > 1) {
                        this.query.pageNo -= 1;
                    }
                    this.rowSize = 0;
                    this._isEmpty();
                } else {
                    //判断是否全选
                    if (opts.selectrows === "multi") {
                        if (this.multiCheckedNum === rowSize) {
                            this.gridAllCheck.addClass("grid-all-checkbox-checked");
                        } else {
                            this.gridAllCheck.removeClass("grid-all-checkbox-checked");
                        }
                    }
                    //重设index
                    var domTr = this.domTr;
                    for (var j = this.endRow; j--;) {
                        domTr[j].removeAttribute("index");
                    }
                    var rows0 = rows[0] - 0;
                    this._setOddEven(rows0);
                    this._setNum(rows0);
                    this._lazyload();
                }
                if(this.autoHeight && typeof this.options.resizewidth === "function") {
                    this.resize();
                } else {
                    this._setLayout();
                }
                //回调
                var removedataCallback = opts.removedata_callback;
                if (typeof removedataCallback === "function") {
                    removedataCallback.call(this, removeDatas);
                }
            }
        },
        removeDataByPk: function (pks) {
            this.removeData(this._pkToIndex(pks, false));
        },
        /**
         * 改变某行数据
         * @param newData
         * @param index
         */
        changeData: function (newData, index) {
            if ($.type(newData) !== "object") {
                return;
            }
            var opts = this.options,
                primarykey = opts.primarykey,
                pkValue = newData[primarykey];
            if (typeof pkValue !== "undefined") {
                var newIndex = this._pkToIndex(pkValue, false)[0];
                index = newIndex === undefined ? index : newIndex;
            }
            if (typeof index !== "number" || index < 0 || index >= this.rowSize) {
                return;
            }
            this.data[index] = $.extend(true, this.data[index], newData);
            if (index >= this.endRow) {
                return;
            }
            //获取dom
            var dom             = this._dataToDom([newData], 0, 1),
                newDomTd      = dom.domTd[0],
                oldDomTd      = this.domTd[index],
                bindName       = this.bindName,
                fixcolumnnumber = opts.fixcolumnnumber;
            //替换数据
            this.odd = !this.odd;
            for (var i = this.colSize; i--;) {
                var bindNameI = bindName[i],
                    oldTdI = $(oldDomTd[i]);
                oldTdI.removeAttr("title");
                if (i < fixcolumnnumber) {
                    if (typeof bindNameI !== "number") {
                        var oldSpan = oldTdI.find(".grid-fixed-s")[0];
                        var value    = $(newDomTd[i]).find(".grid-fixed-s")[0].innerHTML;
                        oldSpan.innerHTML = value;
                        oldSpan.nextSibling.nodeValue = value;
                    }
                } else if (typeof bindNameI !== "number") {
                    oldTdI.html(newDomTd[i].innerHTML);
                }
            }
        },
        /**
         * 获取数据
         */
        getData: function () {
            return $.extend(true, [], this.data);
        },
        /**
         * 获取选中行数据集
         * @returns {Array}
         */
        getSelectedRowData: function () {
            var selectrows = this.options.selectrows;
            if (selectrows === "no") {
                return [];
            }
            var data = this.data;
            if (selectrows === "single") {
                return isNaN(this.singleChecked) ? [] : [data[this.singleChecked]];
            }
            if (this.multiCheckedNum === this.rowSize) {
                return this.data;
            }
            var multiChecked = this.multiChecked;
            var rowSize = this.rowSize;
            var ret = [];
            for (var i = 0; i < rowSize; i += 1) {
                if (multiChecked[i]) {
                    ret.push(data[i]);
                }
            }
            return ret;
        },
        /**
         * 获取选中行主键
         * @returns {Array}
         */
        getSelectedPrimaryKey: function () {
            var opts        = this.options,
                selectrows  = opts.selectrows,
                primarykey  = opts.primarykey,
                selectData = this.getSelectedRowData(),
                len         = selectData.length;
            if (selectrows === "no" ||
                !len ||
                selectData[0].hasOwnProperty(primarykey) === false) {
                return [];
            }
            var ret = [];
            for (var i = 0; i < len; i += 1) {
                ret.push(selectData[i][primarykey]);
            }
            return ret;
        },
        /**
         * 获取被选中的行数
         * @returns {Array}
         */
        getSelectedIndex: function () {
            var selectrows = this.options.selectrows;
            if (selectrows === "no") {
                return [];
            }
            if (selectrows === "single") {
                return [this.singleChecked];
            }
            var multiChecked = this.multiChecked;
            var rowSize = this.rowSize;
            var ret = [];
            for (var i = 0; i < rowSize; i += 1) {
                if (multiChecked[i]) {
                    ret.push(i);
                }
            }
            return ret;
        },
        /**
         * 通过索引号获取行数据
         * @param rows
         * @returns {*}
         */
        getRowsDataByIndex: function (rows) {
            var data = this.data;
            if (typeof rows === "number") {
                return [data[rows]];
            }
            if ($.type(rows) === "array") {
                var len = rows.length;
                var ret = [];
                for (var i = 0; i < len; i += 1) {
                    var dataI = data[rows[i]];
                    if (dataI) {
                        ret.push(dataI);
                    }
                }
                return ret;
            }
        },
        /**
         * 根据主键获取对象
         * @param pks
         * @returns {*}
         */
        getRowsDataByPK: function (pks) {
            var primarykey = this.options.primarykey;
            var data = this.data;
            if (data[0] && data[0].hasOwnProperty(primarykey)) {
                if ($.type(pks) !== "array") {
                    pks = [pks];
                }
                var len = pks.length;
                var ret = [];
                for (var i = 0; i < len; i += 1) {
                    var pksI = pks[i];
                    for (var j = this.rowSize; j--;) {
                        if (data[j][primarykey] === pksI) {
                            ret.push(data[j]);
                            break;
                        }
                    }
                }
                return ret;
            } else {
                return null;
            }
        },
        /**
         * 交换列
         * @param start
         * @param end
         */
        _switchCol: function (start, end) {
            var domHeadCol    = this.domHeadCol,
                domBodyCol    = this.domBodyCol,
                domTd          = this.domTd,
                domTh          = this.domTh,
                domFixed       = this.domFixed,
                domTr          = this.domTr,
                fixcolumnnumber = this.options.fixcolumnnumber,
                numCol         = this.numCol;
            //属性
            this._switchArrayValue(this.bindName, start, end);
            this._switchArrayValue(this.bindDotName, start, end);
            this._switchArrayValue(this.colIndex, start, end);
            this._switchArrayValue(this.theadText, start, end);
            this._switchArrayValue(this.renderStyle, start, end);
            this._switchArrayValue(this.colRender, start, end);
            this._switchArrayValue(this.colWidth, start, end);
            this._switchArrayValue(this.initColWidth, start, end);
            this._switchArrayValue(this.colWidthBackup, start, end);
            this._switchArrayValue(this.colHidden, start, end);
            this._switchArrayValue(this.tdsPackage, start, end);
            //排序列位置确定
            if (!isNaN(numCol)) {
                if (start === numCol) {
                    this.numCol = end - (start > end ? 0 : 1);
                } else if (start > numCol && end <= numCol){
                    this.numCol = numCol + 1;
                } else if (start < numCol && end > numCol) {
                    this.numCol = numCol - 1;
                }
            }
            //dom替换
            var domTdI = null;
            var i = this.endRow;
            var hideCol = this.hideCol;
            var domA = hideCol.domA;
            var gridHideColList = hideCol.gridHidecolList;
            if (end === this.colSize) {
                var domThStart = $(domTh[start]);
                domThStart.appendTo(domThStart.parent());
                var domBodyColStart = $(domBodyCol[start]);
                domBodyColStart.appendTo(domBodyColStart.parent());
                var domHeadColStart = $(domHeadCol[start]);
                domHeadColStart.appendTo(domHeadColStart.parent());
                for (; i--;) {
                    domTdI = domTd[i];
                    domTr[i].appendChild(domTdI[start]);
                    this._switchArrayValue(domTdI, start, end);
                }
                if (gridHideColList) {
                    if (this.selectrowsClass !== "") {
                        gridHideColList.appendChild(domA[start - 1]);
                    } else {
                        gridHideColList.appendChild(domA[start]);
                    }
                }
            } else {
                $(domTh[start]).insertBefore(domTh[end]);
                $(domBodyCol[start]).insertBefore(domBodyCol[end]);
                $(domHeadCol[start]).insertBefore(domHeadCol[end]);
                for (; i--;) {
                    domTdI = domTd[i];
                    domTr[i].insertBefore(domTdI[start], domTdI[end]);
                    this._switchArrayValue(domTdI, start, end);
                }
                if (gridHideColList) {
                    if (this.selectrowsClass !== "") {
                        gridHideColList.insertBefore(domA[start - 1], domA[end - 1]);
                    } else {
                        gridHideColList.insertBefore(domA[start], domA[end]);
                    }
                }
            }
            //dom变量
            this._switchArrayValue(domTh, start, end);
            if (start < fixcolumnnumber || end < fixcolumnnumber) {
                //配置固定列的zIndex
                var min = Math.min(start, end),
                    max = Math.max(start, end);
                fixcolumnnumber++;
                for (var j = 0, rowSize = this.rowSize + 1; j < rowSize; j++) {
                    this._switchArrayValue(domFixed[j], start, end);
                    for (var k = min; k <= max; k++) {
                        $(domFixed[j][k]).parent().css("zIndex", fixcolumnnumber - k);
                    }
                }
            }
            this._switchArrayValue(domBodyCol, start, end);
            this._switchArrayValue(domHeadCol, start, end);
            //持久化
            if (this.persistence) {
                this._triggerStatusChange();
            }
        },
        /**
         * 交换数组的值
         * @param arr
         * @param start
         * @param end
         * @private
         */
        _switchArrayValue: function (arr, start, end) {
            if (arr.length < end) {
                arr[end] = undefined;
            }
            if (start > end) {
                arr.splice(end, 0, arr.splice(start, 1)[0]);
            } else {
                arr.splice(end - 1, 0, arr.splice(start, 1)[0]);
            }
        },
        //列宽拖动
        ittab: {
            ittabActive: false,
            _init: function (self) {
                var that         = this,
                    gridOverlay = self.gridOverlay,
                    gridLine    = self.gridLine,
                    colwidth    = [],
                    start        = 0,
                    end          = 0,
                    reTrigger   = true,
                    index        = NaN,
                    adaptive     = self.options.adaptive;
                self.gridHeadTable.find(".grid-ittab").show();
                self.gridHeadTable.on("mousedown", function (event) {
                    var target = event.target;
                    end = 0;
                    if (target.className === "grid-ittab") {
                        colwidth = self.colWidth;
                        index     = self._thIndex($(target).parents("th")[0]);
                        gridOverlay.show().css("cursor", "col-resize");
                        var left  = gridOverlay.offset().left;
                        start     = event.pageX - left;
                        gridLine.show().css("left", start);
                        reTrigger = false;
                        gridOverlay.off("mousemove").on("mousemove", function (event) {
                            event.stopPropagation();
                            end = event.pageX - left;
                            if (colwidth[index] + end - start < 24) {
                                end = 24 + start - colwidth[index];
                            }
                            gridLine.css("left", end);
                            return false;
                        });
                    }
                    return false;
                });
                gridOverlay.on("mouseup mouseout", function () {
                    if (reTrigger || isNaN(index)) {
                        return;
                    }
                    reTrigger = true;
                    $(this).hide();
                    gridLine.hide();
                    if (end === 0) {
                        return;
                    }
                    var change            = end - start;
                    self.isIttab         = true;
                    self.colWidth[index] = colwidth[index] + change;
                    self.tableWidth      = self.tableWidth + change;
                    that.ittabActive = true;
                    self._setColWidthStyle(!adaptive ? index : undefined);
                    if (self.persistence) {
                        self._triggerStatusChange();
                    }
                    self._setLayout();
                    that.ittabActive = false;
                    start = end = 0;
                    index = NaN;
                });
            }
        },
        //隐藏列
        hideCol: {
            /**
             * 初始化
             * @param self
             * @private
             */
            _init: function (self) {
                var hideCol = this.hideCol = document.createElement("div"),
                    ban = 0;
                hideCol.className = "grid-hidecol";
                var theadHeight   = self.theadHeight;
                hideCol.style.top = theadHeight + "px";
                hideCol.tabIndex  = "1";
                //self.gridContainer.append(hideCol);
                $('body').append(hideCol);

                hideCol     = $(hideCol);
                var colSize = self.colSize,
                    text     = self.theadText,
                    textI   = "",
                    disabled = self.disabled,
                    i        = 0, banHideHtml = '';
                if (self.selectrowsClass !== "") {
                    i += 1;
                }

                var html = ['<div class="grid-hidecol-list" hidefocus="true" >'];
                for (; i < colSize; i += 1) {
                    textI = $.trim(text[i].replace(/<.*?>/g, ""));
                    if (disabled[i]) {
                        ban++;
                        banHideHtml = ' class="grid-hide-disabled"';
                    } else {
                        banHideHtml = '';
                    }
                    html.push(
                        '<a href="javascript:;" hidefocus="true"', banHideHtml, ' title=',
                        textI,
                        '>',
                        textI,
                        '</a>'
                    );
                }
                html.push(
                    '</div>',
                    '<div class="grid-hidecol-button">',
                    '<a href="javascript:;" hidefocus="true" class="cui-button blue-button grid-hidecol-confirm">确定</a>',
                    '<a href="javascript:;" hidefocus="true" class="cui-button red-button grid-hidecol-cancel">取消</a>',
                    '</div>'
                );
                hideCol.html(html.join(""));
                this.gridHidecolList = hideCol.find(".grid-hidecol-list")[0];
                this.domA             = this.gridHidecolList.getElementsByTagName("a");
                this.bindEvent(self, hideCol);
                this.ban = ban;
            },
            /**
             * 事件绑定
             * @param self
             * @param obj
             */
            bindEvent: function (self, obj) {
                var that = this,
                    colSize = self.colSize,
                    gridBox = self.gridBox,
                    gridOffsetLeft,
                    centerPoint,
                    parent = null,
                    focus = false,
                    start = 0,
                //inputs = obj.find("input"),
                    prevIndex = -1,
                    domA = this.domA,
                    span = document.createElement("span");
                if (self.selectrowsClass !== "") {
                    start += 1;
                }
                self.gridHeadTable.on("click", function (event) {
                    var target = $(event.target);
                    gridOffsetLeft = gridBox.offset().left;
                    centerPoint = gridOffsetLeft + self.gridWidth / 2;
                    if (target.hasClass("grid-select")) {
                        if (parent) {
                            obj.blur();
                        }
                        //inputs = obj.find("input");
                        parent = target.parents("th").addClass("grid-thead-select");
                        var offsetLeft = target.offset().left;
                        //var left = offsetLeft - gridOffsetLeft + 2;
                        var left = offsetLeft + 4;
                        left -= 126;
                        /*if (offsetLeft > centerPoint) {
                            left -= 126;
                        }*/
                        var height,
                            colMaxHeight = C.Tools.fixedNumber(self.options.colmaxheight);

                        //如果设有最大高度，则度最大高度执行
                        switch (colMaxHeight){
                            case 'auto':
                                height = Math.max(self.boxHeight + self.paginationHeight - 50, 60);
                                break;
                            default :
                                //设置隐藏列下拉框高度
                                if(colMaxHeight && colMaxHeight >= 60){
                                    height = colMaxHeight - 50;
                                }
                        }
                        obj.children(".grid-hidecol-list").css("height", 28 * (colSize - that.ban) > height ? height : '');



                        //obj.css({"left": left, "top": self.theadHeight}).show().focus().attr("hidefocus", "true");
                        obj.css({"left": left, "top": target.offset().top + self.theadHeight }).show().focus().attr("hidefocus", "true");
                        reStart();
                        var index = self._thIndex(parent[0]) - start;
                        $(domA[prevIndex]).removeClass("grid-hidecol-disabled");
                        $(domA[index]).addClass("grid-hidecol-disabled");
                        prevIndex = index;
                        focus = false;
                    } else {
                        $(obj).blur();
                    }
                });
                obj.on("blur", function () {
                    if (focus) {
                        obj.focus();
                        return;
                    }
                    if (parent) {
                        parent.removeClass("grid-thead-select");
                    }
                    $(obj).hide();
                });
                obj.on("mouseover", function () {
                    focus = true;
                });
                obj.on("mouseout", function () {
                    focus = false;
                });

                var hideCol = self.colHidden;
                obj.on("click", function (event) {
                    var target = $(event.target);
                    if (target.hasClass("grid-hidecol-confirm")) {
                        for (var i = start; i < colSize; i += 1) {
                            hideCol[i] = $(domA[i - start]).hasClass("grid-hidecol-nochecked");
                        }
                        focus = false;
                        self._colHidden(false);
                        $(this).blur();
                        return false;
                    }
                    if (target.hasClass("grid-hidecol-cancel")) {
                        reStart();
                        focus = false;
                        $(this).blur();
                        return false;
                    }
                    if (target.prop("tagName") === "A") {
                        if (!target.hasClass("grid-hidecol-disabled")) {
                            target.toggleClass("grid-hidecol-nochecked");
                        }
                        return false;
                    }
                    this.focus();
                });

                function reStart () {
                    for (var j = start; j < colSize; j+=1) {
                        if(hideCol[j]) {
                            $(domA[j - start]).addClass("grid-hidecol-nochecked");
                        } else {
                            $(domA[j - start]).removeClass("grid-hidecol-nochecked");
                        }
                    }
                }
                setTimeout(reStart, 100);
            }
        },
        /**
         * 列拖动
         */
        moveCol: {
            _init: function (self) {
                //插入dom
                var gridColMoveInsert = $("<div></div>"),
                    gridColMoveTag    = $("<div></div>"),
                    gridHeadTable      = self.gridHeadTable.addClass("grid-col-move");
                gridColMoveInsert.addClass("grid-col-move-insert");
                gridColMoveTag.addClass("grid-col-move-tag");
                self.gridHead.append(gridColMoveTag).append(gridColMoveInsert);
                //获取属性
                var opts             = self.options,
                    gridOverlay     = self.gridOverlay,
                    fixcolumnnumber  = opts.fixcolumnnumber,
                    selectrowsClass  = self.selectrowsClass,
                    colHidden       = null,
                    fixedWidth      = 0,
                    insertPosition  = [],
                    mousePosition   = [],
                    index            = NaN,
                    complate         = NaN,
                    isFixed         = false,
                    moveTrigger     = true;
                gridHeadTable.on("mousedown", function (event) {
                    var target = $(event.target);
                    if (!target.hasClass("grid-fixed-s") || target.hasClass("grid-no-move")) {
                        return;
                    }
                    if (opts.colhidden) {
                        self.hideCol.hideCol.blur();
                    }
                    //获取属性
                    moveTrigger         = false;
                    colHidden           = self.colHidden;
                    var colwidth        = self.colWidth,
                        colSize         = self.colSize,
                        domTh           = self.domTh,
                        domFixed0      = self.domFixed[0],
                        headOffsetLeft = Math.round(gridHeadTable.offset().left),
                        scrollLeft      = self.gridScroll[0].scrollLeft,
                        end              = 0,
                    //获取当前th
                        height           = self.theadHeight,
                        parent           = target.parent().parent();
                    index                = self._thIndex(parent[0]);
                    //计算各th的位置
                    fixedWidth          = 0;
                    insertPosition      = [];
                    mousePosition       = [];
                    var i = 0, colWidthI = null, position = 0, leftIndex = 0;
                    if (index < fixcolumnnumber) {
                        isFixed = true;
                        for (; i < fixcolumnnumber; i += 1) {
                            colWidthI = colwidth[i];
                            fixedWidth += colWidthI;
                            position = Math.round($(domFixed0[i]).offset().left) - headOffsetLeft - scrollLeft;
                            if (colHidden[i] === true) {
                                position = -100;
                            }
                            insertPosition.push(position);
                            mousePosition.push(position);
                            if (!colHidden[i]) {
                                mousePosition[i] = position + colWidthI / 2;
                            }
                        }
                        insertPosition.push(fixedWidth - scrollLeft);
                        mousePosition.push(fixedWidth - scrollLeft - 1);
                        if (selectrowsClass) {
                            insertPosition[0] = mousePosition[0] = -100;
                        }
                        leftIndex = insertPosition[index] - 1;
                    } else {
                        isFixed = false;
                        for (i = fixcolumnnumber; i < colSize; i += 1) {
                            colWidthI = colwidth[i];
                            position = Math.round($(domTh[i]).offset().left) - headOffsetLeft - scrollLeft;
                            if (colHidden[i] === true) {
                                position = -100;
                            }
                            insertPosition.push(position);
                            mousePosition.push(position);
                            if (!colHidden[i]) {
                                mousePosition[i - fixcolumnnumber] = position + colWidthI / 2;
                            }
                        }
                        insertPosition.push(self.tableWidth - scrollLeft);
                        mousePosition.push(self.tableWidth - scrollLeft - 1);
                        if (fixcolumnnumber === 0 && selectrowsClass) {
                            insertPosition[0] = mousePosition[0] = -100;
                        }
                        leftIndex = insertPosition[index - fixcolumnnumber] - 1;
                    }
                    //设置框位置和大小
                    gridColMoveTag.show().css({
                        left       : leftIndex,
                        width      : parent.width(),
                        height     : height - 1,
                        lineHeight : height - 1 + "px"
                    }).html(target.find(".grid-thead-text").eq(0).html());
                    gridColMoveInsert.show().css("height", height - 5);
                    gridOverlay.show().css("cursor", "move");
                    var start = event.pageX;
                    //事件
                    gridColMoveInsert.css("left", -1000);
                    gridOverlay.off("mousemove").on("mousemove", function (event) {
                        event.stopPropagation();
                        end = event.pageX;
                        gridColMoveTag.css("left", leftIndex - start + end);
                        var len = mousePosition.length;
                        for (var i = 0; i < len; i += 1) {
                            var mousePositionI = mousePosition[i];
                            if (mousePositionI < 0) {
                                continue;
                            }
                            if (end < mousePositionI) {
                                gridColMoveInsert.css("left", insertPosition[i]);
                                if (isFixed) {
                                    complate = i;
                                } else {
                                    complate = i + fixcolumnnumber;
                                }
                                break;
                            }
                        }
                        return false;
                    });
                });
                gridOverlay.on("mouseup", function () {
                    if (moveTrigger) {
                        return;
                    }
                    moveTrigger = true;
                    gridOverlay.hide();
                    gridColMoveInsert.hide();
                    gridColMoveTag.hide();
                    if (isNaN(complate) || isNaN(index) || complate === index || complate === index + 1) {
                        return;
                    }
                    if (index > complate) {
                        self._switchCol(index, complate);
                        complate = index = NaN;
                        return;
                    }
                    for (var i = index + 1; i < complate; i += 1) {
                        if (!colHidden[i]) {
                            self._switchCol(index, complate);
                            complate = index = NaN;
                            break;
                        }
                    }

                });
                gridOverlay.on("mouseout", function () {
                    gridOverlay.hide();
                    gridColMoveInsert.hide();
                    gridColMoveTag.hide();
                    complate = index = NaN;
                });
            }
        },
        /**
         * 销毁
         */
        destroy: function(){
            var self = this,
                opts = self.options;
            self._super();
            $('.' + this.guid).remove();
        }
    });
})(window.comtop);