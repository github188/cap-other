/**
 * 新grid
 * @author 王伟
 * @since 2013-6-31
 */
;(function (C) {
    'use strict';
    var $ = C.cQuery,
        UI = C.UI,
        fiexNumber = C.Tools.fixedNumber || function (a) {return a;},
        /*匹配编辑Grid支持的类型*/
        editUiType = /^((i|I)nput|(c|C)lickInput|(p|((s|S)ingle|(m|M)ulti)?P)ullDown|(c|C)alender|(t|T)extarea)|((c|C)heckbox|(r|R)adio)Group$/,
        dictType = /(ullDown|Group)$/,
        inputType = /(nput|textarea)$/,
        rule = {
            /**
             * 验证是否存在(扩展字段 req)
             * 参数 解释数据
             * m: 出错信息字符串
             * emptyVal:包含在其中的也算为空
             */
            required: function (value, paramsObj) {
                var params = $.extend({
                        m: "不能为空!"
                    }, paramsObj || {}),
                    emptyVal = params.emptyVal,
                    msg = params.m,
                    i, len, valueI;
                if(value === '' || value === null || value === undefined) {
                    return msg;
                }
                if (emptyVal) {
                    for (i = 0, len = emptyVal.length; i < len; i++) {
                        if (value === emptyVal[i]) {
                            return msg;
                        }
                    }
                }
                if ($.type(value) === 'array') {
                    len = value.length;
                    if (len === 0) {
                        return msg;
                    }
                    for (i = 0; i < len; i++) {
                        valueI = value[i];
                        if (valueI === '' || valueI === null || valueI === undefined) {
                            return msg;
                        }
                    }
                }
                return true;
            },

            /**
             * 验证数值类型(扩展字段 num)
             * 参数 解释                                 数据
             *  oi： 是否只能为Integer （onlyInteger）     true/false
             *  min: 最小数                               数字
             *  max: 最大数                               数字
             *  is:  必须和该数字相等                      数字
             *  wrongm: 输入不和 is 相等的数字时提示信息       数字
             *  notnm：不为数字时提示信息                    字符串
             *  notim：不为整数时提示信息                    字符串
             *  minm：小于 min 数字时提示信息               字符串
             *  maxm：大于 max 数字时提示信息               字符串
             */
            numeric: function (value, paramsObj) {
                if ('' === value) {
                    return true;
                }
                var suppliedValue = value,
                    params, msg;
                value = Number(value);
                paramsObj = paramsObj || {};
                params = {
                    notANumberMessage:  paramsObj.notnm || "必须为数字!",
                    notAnIntegerMessage: paramsObj.notim || "必须为整数!",
                    wrongNumberMessage: paramsObj.wrongm || "必须为 " + paramsObj.is + "!",
                    tooLowMessage: paramsObj.minm || "必须大于 " + paramsObj.min + "!",
                    tooHighMessage: paramsObj.maxm || "必须小于 " + paramsObj.max + "!",
                    is: (paramsObj.is || paramsObj.is === 0) ? paramsObj.is : null,
                    minimum: (paramsObj.min || paramsObj.min === 0) ? paramsObj.min : null,
                    maximum: (paramsObj.max || paramsObj.max === 0) ? paramsObj.max : null,
                    onlyInteger:  paramsObj.oi || false
                };
                if (!isFinite(value)) {
                    return params.notANumberMessage;
                }
                if (params.onlyInteger && !/^\d+$/.test(String(suppliedValue))) {
                    return params.notAnIntegerMessage;
                }
                switch(true){
                    case (params.is !== null):
                        if( value !== Number(params.is) ) {
                            return params.wrongNumberMessage;
                        }
                        break;
                    case (params.minimum !== null && params.maximum !== null):
                        msg = this.numeric(value, {minm: params.tooLowMessage, min: params.minimum});
                        if (msg !== true) {
                            return msg;
                        }
                        msg = this.numeric(value, {maxm: params.tooHighMessage, max: params.maximum});
                        if (msg !== true) {
                            return msg;
                        }
                        break;
                    case (params.minimum !== null):
                        if( value < Number(params.minimum) ) {
                            return params.tooLowMessage;
                        }
                        break;
                    case (params.maximum !== null):
                        if( value > Number(params.maximum) ) {
                            return params.tooHighMessage;
                        }
                        break;
                }
                return true;
            },

            /**
             * 正则表达式验证 (扩展字段 format)
             *  参数   解释                                 数据
             *  m:     出错信息                             字符串
             *  pattern: 验证正则表达式                     字符串
             *  negate: 是否忽略本次验证（negate）           true/false
             */
            format: function(value, paramsObj){
                if ('' === value) {
                    return true;
                }
                value = String(value);
                var params = $.extend({
                    m: "不符合规定格式!",
                    pattern:  /./ ,
                    negate: false
                }, paramsObj || {});
                params.pattern = $.type(params.pattern) === "string" ?
                    new RegExp(params.pattern) : params.pattern;
                if(!params.negate && !params.pattern.test(value)) {//不忽略
                    return params.m;
                }
                return true;
            },

            /**
             * 邮箱格式验证 (扩展字段 email)
             * 参数 解释                                 数据
             *  m:   出错信息                             字符串
             */
            email: function(value, paramsObj){
                if ('' === value) {
                    return true;
                }
                var params = $.extend({
                    m: "邮箱格式输入不合法!"
                }, paramsObj || {}),
                msg = this.format(value, {
                    m: params.m,
                    pattern: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
                });
                if (msg !== true) {
                    return msg;
                }
                return true;
            },

            /**
             * 日期格式验证 (扩展字段 date)考虑了闰年、二月等因素
             * 参数 解释                                 数据
             *  m:   出错信息                            字符串
             */
            dateFormat : function(value, paramsObj) {
                var params = $.extend({
                    m: "日期格式必须为yyyy-MM-dd形式！"
                }, paramsObj || {}),
                msg = this.format(value, {
                    m: params.m,
                    pattern: /^((((((0[48])|([13579][26])|([2468][048]))00)|([0-9][0-9]((0[48])|([13579][26])|([2468][048]))))-02-29)|(((000[1-9])|(00[1-9][0-9])|(0[1-9][0-9][0-9])|([1-9][0-9][0-9][0-9]))-((((0[13578])|(1[02]))-31)|(((0[1,3-9])|(1[0-2]))-(29|30))|(((0[1-9])|(1[0-2]))-((0[1-9])|(1[0-9])|(2[0-8]))))))$/i
                });
                if (msg !== true) {
                    return msg;
                }
                return true;
            },

            /**
             * 长度验证(扩展字段 len)
             * 参数 解释                               数据
             *  m:   出错信息                          字符串
             *  min: 最小长度                          数字
             *  max: 最大长度                          数字
             *  is:  必须和该长度相等                     数字
             *  wrongm: 输入长度和 is 不相等时提示信息        数字
             *  minm：长度小于 min 数字时提示信息            字符串
             *  maxm：长度大于 max 数字时提示信息            字符串
             */
            length: function(value, paramsObj){
                value = String(value);
                paramsObj = paramsObj || {};
                var params = {
                    wrongLengthMessage: paramsObj.wrongm || "长度必须为 " + paramsObj.is + " 字节!",
                    tooShortMessage:      paramsObj.minm || "长度必须大于 " + paramsObj.min + " 字节!",
                    tooLongMessage:       paramsObj.maxm || "长度必须小于 " + paramsObj.max + " 字节!",
                    is: (paramsObj.is || paramsObj.is === 0) ? paramsObj.is : null,
                    minimum: (paramsObj.min || paramsObj.min === 0) ? paramsObj.min : null,
                    maximum: (paramsObj.max || paramsObj.max === 0) ? paramsObj.max : null
                }, msg;
                switch(true){
                    case (params.is !== null):
                        if( value.replace(/[^\x00-\xff]/g, "xx").length !== Number(params.is) ) {
                            return params.wrongLengthMessage;
                        }
                        break;
                    case (params.minimum !== null && params.maximum !== null):
                        msg = this.length(value, {minm: params.tooShortMessage, min: params.minimum});
                        if (msg !== true) {
                            return msg;
                        }
                        msg = this.length(value, {maxm: params.tooLongMessage, max: params.maximum});
                        if (msg !== true) {
                            return msg;
                        }
                        break;
                    case (params.minimum !== null):
                        if( value.replace(/[^\x00-\xff]/g, "xx").length < Number(params.minimum) ) {
                            return params.tooShortMessage;
                        }
                        break;
                    case (params.maximum !== null):
                        if( value.replace(/[^\x00-\xff]/g, "xx").length > Number(params.maximum) ) {
                            return params.tooLongMessage;
                        }
                        break;
                    default:
                        return "长度验证必须提供长度值!";
                }
                return true;
            },

            /**
             * 包含验证 (扩展字段 inc)
             * 参数 解释                                 数据
             *  m:   出错信息                             字符串
             *  negate: 是否忽略                          true/false
             *  caseSensitive: 大小写敏感(caseSensitive)   true/false
             *  allowNull: 是否可以为空                    数字
             *  within:  集合                             数组
             *  partialMatch: 是否部分匹配                 true/false
             */
            inclusion: function(value, paramsObj){
                var params = $.extend({
                        m: "",
                        within: [],
                        allowNull: false,
                        partialMatch: false,
                        caseSensitive: true,
                        negate: false
                    }, paramsObj || {}),
                    within = params.within, lowerWithin,
                    i, len, item,
                    found = false,
                    msg = params.m || (value + "没有包含在数组" + params.within.join(',') + "中");
                if(params.allowNull && !value) {
                    return true;
                }
                if(!params.allowNull && !value) {
                    return params.m;
                }
                //if case insensitive, make all strings in the array lowercase, and the value too
                if(!params.caseSensitive){
                    lowerWithin = [];
                    for (i = 0, len = within; i < len; i++ ) {
                        item = within[i];
                        if(typeof item === 'string') {
                            item = item.toLowerCase();
                        }
                        lowerWithin.push(item);
                    }
                    params.within = lowerWithin;
                    if(typeof value === 'string') {
                        value = value.toLowerCase();
                    }
                }
                for (i = 0, len = within; i < len; i++ ) {
                    item = within[i];
                    if(item === value || params.partialMatch && value.indexOf(item) !== -1) {
                        found = true;
                        break;
                    }
                }
                if( params.negate === found ) {
                    return msg;
                }
                return true;
            },

            /**
             * 不包含验证 (扩展字段 exc)
             * 参数 解释                                 数据
             *  m:   出错信息                             字符串
             *  caseSensitive: 大小写敏感(caseSensitive)   true/false
             *  allowNull: 是否可以为空                    数字
             *  within:  集合                             数组
             *  partialMatch: 是否部分匹配                 true/false
             */
            exclusion: function(value, paramsObj){
                var params = $.extend({
                        m: "",
                        within: [],
                        allowNull: false,
                        partialMatch: false,
                        caseSensitive: true
                    }, paramsObj || {}),
                    msg;
                params.m = params.m || value + "不应该在数组" + params.within.join(',') + "中！";
                params.negate = true;// set outside of params so cannot be overridden
                msg = this.inclusion(value, params);
                if (msg !== true) {
                    return msg;
                }
                return true;
            },
            /**
             * 组合匹配一致验证，如用户名和密码 (扩展字段 confirm)
             * 参数 解释                                 数据
             *  m:   出错信息                             字符串
             *  match: 验证与之匹配的元素引用              元素或元素id
             */
            /* confirmation: function(value, paramsObj){
                if(!paramsObj.match) {
                    return "与之匹配的元素引用或元素id必须被提供!";
                }
                var params = $.extend({
                    m: "两者不一致!",
                    match: null
                }, paramsObj || {});
                params.match = $.type(params.match) === 'string' ? cui('#' + params.match) : params.match;
                if(!params.match || params.match.length == 0) {
                    throw new Error("Validate::Confirmation - 与之匹配的元素引用或元素不存在!");
                }
                if(value !== params.match.getValue()) {
                    Validate.fail(params.m);
                }
                return true;
            },*/
            /**
             * 验证值是否为true 主要是验证checkbox (扩展字段 accept)
             * 参数 解释                                 数据
             *  m:   出错信息                             字符串
             */
            acceptance: function(value, paramsObj){
                var params = $.extend({
                    m: "必须选择!"
                }, paramsObj || {});
                if(!value) {
                    return params.m;
                }
                return true;
            },
            /**
             * 自定义验证函数 (扩展字段 custom)
             * 参数 解释                                 数据
             *  m:   出错信息                             字符串
             *  against:  自定义的函数                    function
             *  args:   自定义的函数的参数                 对象
             * */
            custom: function(value, paramsObj){
                var params = $.extend({
                    against: function(){ return true; },
                    args: {},
                    m: "不合法!"
                }, paramsObj || {}),
                    cusFunction = params.against;
                if ($.type(cusFunction) === 'string') {
                    cusFunction = window[cusFunction];
                }
                if(!cusFunction(value, params.args)) {
                    return params.m;
                }
                return true;
            }
        },
        ruleType = /required|numeric|format|email|dateFormat|length|inclusion|exclusion|confirmation|acceptance|custom/;
    C.UI.EditableGrid = C.UI.Base.extend({
        options: {
            uitype                : "EditableGrid",
            gridwidth             : "600px",
            gridheight            : "500px",
            tablewidth            : "",
            primarykey            : "",
            ellipsis              : true,
            titleellipsis         : true,
            adaptive              : true,
            oddevenrow            : false,
            selectrows            : "multi",
            fixcolumnnumber       : 0,
            config                : null,
            onstatuschange        : null,
            datasource            : null,
            titlerender           : null,
            colhidden             : true,
            colmove               : false,
            loadtip               : true,
            resizeheight          : null,
            resizewidth           : null,
            rowstylerender        : null,
            colstylerender        : null,
            colrender             : null, //可编辑列不能渲染
            sortstyle             : 1,
            sortname              : [],
            sorttype              : [],
            pageno                : 1,
            pagesize              : 50,
            pagesize_list         : [25, 50, 100],
            pagination            : true,
            pagination_model      : 'pagination_min_1',

            rowclick_callback     : null,
            loadcomplete_callback : null,//未确定
            selectall_callback    : null,
            rowdblclick_callback  : null,
            /*编辑Grid*/
            edittype              : {},
            submitdata            : null,
            editbefore          : null,
            editafter           : null,
            deletebefore        : null,
            deleteafter        : null
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
                    "' target='", options.targets || "-self",
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
            if (!opts.primarykey) {
                window.alert("EditableGrid need the property: primarykey!");
            }
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
            this.colRender        = []; //单元格渲染函数集中
            this.bindName         = []; // -1 单选多选; 0,1 序号; "" 没有绑定; "string" 绑定了
            this.left    = 0; //滚动到左边的scrollLeft
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
            this.guid              = "eg-" + C.guid();
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

            //判断标识
            this.renderComplete   = false;
            this.odd               = false;
            this.unRender         = true;
            this.autoHeight       = false;
            this.isIttab          = false;
            this.arrIndex         = Array.prototype.indexOf;
            this.isQm             = C.Browser.isQM;
            this.persistence       = typeof onstatuschange === "function" && typeof config === "function";
            this.oddEvenClass          = "eg-even-row";
            this.selectedRowClass      = "eg-select-row";
            //判断是否动态写入style标签
            try {
                var head = $("head");
                head.append('<style type="text/css"></style>');
                head.find("style").last()[0].innerHTML = "";//如果style只读这行报错
                this.writeStyle = true;
            } catch (e) {
                this.writeStyle = false;
            }

            //可编辑Grid属性
            this.editType = {};
            this.editDict = {};
            this.editObj = null;
            this.changeEditData = {
                "insertData" : {},
                "updateData" : {},
                "deleteData" : []
            };

            /**验证对象结构
            this.validateState = {
                "insert": {
                    "insertId" : {
                        "bindName1" : "错误提示1",
                        "bindName2" : "错误提示2",
                    }
                },
                "update": {
                    "pkValue" : {
                        "bindName1" : "错误提示1",
                        "bindName2" : "错误提示2",
                    }
                },
            }*/
            this.validateState = {
                "insert": {},
                "update": {}
            };
            this.insertId = 0; //给插入行的数据设置一个不重复的id；见insertRow方法

            //备份data，用于是否被修改的比较
            this.dataBackup = {};
            this.isChanged = false;
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
                    emptyTh.className = "eg-empty-th";
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
            this.__tbodyMouseEventBind();
            this.__tbodyKeyEventBind();
            //回调
            this.__imitateScroll();
            this._resizeEventBind();
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
            container.className = "eg-container";
            var html = [
                '<div class="eg-style"></div>',
                '<div class="eg-box">',
                '<div class="eg-head">',
                '<table class="eg-head-table"></table>',
                '</div>',
                '<div class="eg-body">',
                '<div class="eg-empty">本列表暂无记录</div>',
                '<div class="eg-table-box"><div class="eg-table-hide"></div></div>',
                '</div>',
                '<div class="eg-scroll">',
                '<div></div>',
                '</div>',
                '<div class="eg-line"></div>',
                '<div class="eg-overlay"></div>',
                '</div>',
                '<div class="eg-tfoot"></div>',
                '<div class="eg-loading-bg eg-loading-bg-over"></div>',
                '<div class="eg-loading-box"><span>正在加载...</span></div>'
            ];
            container.innerHTML = html.join("");
            el[0].parentNode.insertBefore(container, el[0]);
            //创建jq对象
            var gridContainer   = this.gridContainer = $(container).addClass(this.guid);
            if (this.isQm) {
                gridContainer.addClass("eg-container-qm");
            }
            this.gridTableBox  = $(".eg-table-box", gridContainer);
            var gridBox         = this.gridBox = gridContainer.children(".eg-box");
            this.gridStyle      = gridContainer.find(".eg-style").eq(0);
            this.gridHead       = gridBox.find(".eg-head").eq(0);
            this.gridBody       = gridBox.children(".eg-body").eq(0);
            this.gridOverlay    = gridBox.children(".eg-overlay").eq(0);
            this.gridHeadTable = this.gridHead.children(".eg-head-table").eq(0);
            this.gridLine       = gridBox.children(".eg-line").eq(0);
            this.gridScroll     = gridBox.children(".eg-scroll").eq(0);
            this.gridTfoot      = gridContainer.children(".eg-tfoot").eq(0);
            this.gridEmpty      = this.gridBody.children(".eg-empty").eq(0);
            this.loading         = gridContainer.children(".eg-loading-bg").next().andSelf();
            //调整dom属性
            this.gridTableHide = $(".eg-table-hide", gridContainer).eq(0).append(el.addClass("eg-body-table"));
            if (opts.ellipsis) { //是否能换行
                el.addClass("eg-ellipsis");
            }
            if (opts.titleellipsis) {//题头是否换行
                this.gridHeadTable.addClass("eg-ellipsis");
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
                if (className === "eg-select" || className === "eg-ittab") {
                    return;//这里 可以调用 隐藏列 函数
                }
                //全选

                if (target.hasClass("eg-all-checkbox")) {
                    var domTr           = self.domTr,
                        multiChecked    = self.multiChecked,
                        selectedRowClass = self.selectedRowClass,
                        allCheckClass    = "eg-all-checkbox-checked",
                        rowSize         = self.rowSize,
                        checkAll = target.hasClass(allCheckClass),
                        disabledIndex = self.disabledIndex,
                        rows = 0,
                        data = self.data,
                        dataK;
                    // $(target).blur();
                    if (checkAll) {
                        for (var j = rowSize; j--;) {
                            multiChecked[j] = false;
                            $(domTr[j]).removeClass(selectedRowClass);
                        }
                        target.removeClass(allCheckClass);
                        self.multiCheckedNum = 0;
                    } else {
                        for (var k = rowSize; k--;) {
                            dataK = data[k];
                            if (dataK.hasOwnProperty(primarykey) && disabledIndex[k]) {
                                continue;
                            }
                            rows++;
                            multiChecked[k] = true;
                            $(domTr[k]).addClass(selectedRowClass);
                        }
                        target.addClass(allCheckClass);
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
                var gridSort = target.parents(".eg-sort");
                if (gridSort.length && className === "eg-thead-text") {
                    var sortType       = self.sortType,
                        bindNameI     = bindName[self._thIndex(gridSort[0])],
                        sortTypeI     = sortType[bindNameI],// || "ASC",
                        newSortTypeI = sortTypeI !== "DESC" ? "DESC" : "ASC";
                    self._setOptsSortNameAndSoryType(bindNameI, newSortTypeI);
                    //持久化排序
                    if (self.persistence) {
                        self._triggerStatusChange();
                    }
                    //提交，如不需要提交则直接加载
                    if (self.submit() === "notChange") {
                        self.loadData();
                    }
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
                var gridFixedS = target.closest(".eg-fixed-s").eq(0);
                if (gridFixedS.length) {
                    gridFixedS.parents("th").addClass("eg-thead-mouseover");
                }
            }).on("mouseout", function (event) {
                    var target = $(event.target);
                    var gridFixedS = target.closest(".eg-fixed-s").eq(0);
                    if (gridFixedS.length) {
                        gridFixedS.parents("th").removeClass("eg-thead-mouseover");
                    }
                });
        },
        /**
         * 表格主体鼠标事件
         * @private
         */
        __tbodyMouseEventBind: function () {
            var self = this,
                opts = this.options,
                editType = this.editType,
                td, tr, rowIndex, editing,
                bindNameI, editTypeI, rowData,
                rowdblclickCallback = opts.rowdblclick_callback,
                selectrows = opts.selectrows,
                timeout, retainTags = "A;BUTTON;IMG";
            this.el.on("mouseover", function (event) {
                var newTd, newTr, cellIndex, isEdit;
                event.stopPropagation();
                newTd = $(event.target).closest("td").eq(0);
                if (!newTd.length || newTd === td) {
                    return;
                }
                newTr = newTd.closest("tr").eq(0);
                if (!newTr.closest("tbody").length) {
                    return;
                }
                td = newTd;
                tr = newTr;
                rowIndex = tr[0].rowIndex - 1;
                rowData = self.data[rowIndex];
                cellIndex = newTd[0].cellIndex;
                bindNameI = self.bindName[cellIndex];
                editTypeI = editType[bindNameI];
                //高亮行
                tr.addClass("eg-tr-over");
                //正在编辑ing
                editing = td.hasClass("eg-editing");
                if (editing) {
                    return;
                }
                //可编辑，
                if (editTypeI) {
                    isEdit = true;
                    td.addClass("eg-editable-td");
                }
                //渲染title
                self._renderTitle(td, bindNameI, rowIndex, isEdit);
            })
            .on("mouseout", function (event) {
                event.stopPropagation();
                if (td) {
                    tr.removeClass("eg-tr-over");
                    td.removeClass("eg-editable-td");
                    tr = td = editing = rowIndex = bindNameI = editTypeI = undefined;
                }
            })
            .on("dblclick", function (event) {
                event.stopPropagation();
                if (typeof opts.rowdblclick_callback === "function" && td && !editTypeI) {
                    clearTimeout(timeout);
                    opts.rowdblclick_callback.call(self, rowData, rowIndex);
                }
            });
            this.gridBody.on("click", function (event) {
                var target = $(event.target),
                    tagName, clickid;
                event.stopPropagation();
                if (td) {
                    if (editing) {
                        return;
                    }
                    //完成上一个编辑
                    if (self.editObj) {
                        self._destroyFormEle();
                    }
                    if (editTypeI) {
                        //编辑单元格
                        self.__startEdit(editTypeI, td, rowIndex, bindNameI);
                        return;
                    }
                    //非编辑单元格
                    tagName = target.prop("tagName");
                    clickid = target.attr("clickid") || "";
                    if (retainTags.indexOf(tagName) !== -1) {
                        if (clickid !== "") {
                            self.fixedFnClick[clickid](rowData, rowIndex);
                        }
                        return;
                    }
                    if (tagName === "INPUT"){
                        return;
                    }

                    if (target.hasClass("eg-select-input")) {
                        self._selectRows(rowIndex, undefined);
                    }

                    //单击
                    if (rowdblclickCallback) {
                        clearTimeout(timeout);
                        timeout = setTimeout(function () {
                            clickCallback(rowIndex);
                        }, 300);
                    } else {
                        clickCallback(rowIndex);
                    }
                }
                //完成上一个编辑
                if (self.editObj) {
                    self._destroyFormEle();
                }
            });
            function clickCallback(rowIndex) {
                //选择行回调
                var flag = false;
                if (selectrows === "multi") {
                    flag = self.multiChecked[rowIndex];
                } else if (selectrows === "single") {
                    flag = rowIndex === self.singleChecked;
                }
                if (typeof opts.rowclick_callback === "function") {
                    opts.rowclick_callback.call(self, rowData, flag, rowIndex);
                }
            }
        },
        /**
         * 按键，用于编辑时的tab切换
         * @private
         */
        __tbodyKeyEventBind: function () {
            var self = this;
            $(document).on("keydown", function (event) {
                var editObj = self.editObj,
                    index;
                if (editObj) {
                    if (event.keyCode === 9) {
                        event.preventDefault();
                        self._destroyFormEle();
                        index = editObj.index;
                        if (!self.__createNextEditObj(index, editObj.bindName) &&
                            (index + 1) < self.rowSize) {
                            //切换到下一行
                            self.__createNextEditObj(index + 1, self.bindName[0]);
                        }
                    }
                }
            });
        },
        /**
         * 创建下一个编辑
         * @private
         */
        __createNextEditObj: function (index, bindNameP) {
            var colSize = this.colSize,
                i, bindNameI, editTypeI,
                bindName = this.bindName,
                editType = this.editType,
                gridTableBox = this.gridTableBox,
                isNext, td;
            for (i = 0; i < colSize; i++) {
                bindNameI = bindName[i];
                editTypeI = editType[bindNameI];
                if (editTypeI) {
                    if (isNext) {
                        td = $(this.domTd[index][i]);
                        if (this.__startEdit(editTypeI, td, index, bindNameI, true)) {
                            //this.gridScroll[0].scrollLeft =  td[0].offsetLeft + td.outerWidth() - this.gridWidth;
                            this.gridScroll.scrollLeft(gridTableBox.scrollLeft() + this.left);
                            gridTableBox.scrollLeft(0);
                            return true;
                        } else {
                            continue;
                        }
                    }
                }
                if (bindNameI === bindNameP) {
                    isNext = true;
                }
            }
        },
        /**
         * 为单元格渲染title属性
         * @private
         */
        _renderTitle: function (td, bindNameI, rowIndex, isEdit) {
            var titlerender = this.options.titlerender,
                title, fixedS;
            if (typeof bindNameI !== "number" && !td.attr("title")) {
                fixedS = td.find(".eg-fixed-s");
                fixedS = fixedS.length ? fixedS : null;
                if (typeof titlerender === "function") {
                    title = titlerender(this.data[rowIndex], bindNameI);
                    if (title) {
                        td.attr("title", title);
                    } else {
                        title = $.trim((fixedS || td).text());
                    }
                } else {
                    title = $.trim((fixedS || td).text());
                }
            }
            if (title) {
                if (isEdit) {
                    title = title + " (点击编辑)";
                }
                td.attr("title", title);
            }
        },
        /**
         * 开始编辑渲染
         * @param editTypeI
         * @param td
         * @param rowIndex
         * @param bindNameI
         * @param isTab
         * @returns {boolean}
         * @private
         */
        __startEdit: function (editTypeI, td, rowIndex, bindNameI, isTab) {
            var editbefore = this.options.editbefore,
                newEditObj, uiType;
            if (typeof editbefore === "function") {
                newEditObj = editbefore(this.data[rowIndex], bindNameI);
                if ($.type(newEditObj) === "object") {
                    uiType = newEditObj.uitype;
                    newEditObj.uitype = uiType.charAt(0).toLowerCase() + uiType.slice(1);
                    editTypeI = newEditObj;
                }
            }
            if (newEditObj !== false) {
                td.removeAttr("title");
                this._createFormEle(td, editTypeI, rowIndex, bindNameI, isTab);
                return true;
            } else {
                return false;
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
                    this.gridAllCheck.removeClass("eg-all-checkbox-checked");
                } else {
                    tr.addClass(selectedRowClass);
                    this.multiCheckedNum += 1;
                    if (this.multiCheckedNum === this.rowSize) {
                        this.gridAllCheck.addClass("eg-all-checkbox-checked");
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
                    left = self.left = this.scrollLeft;
                    if (leftCache === left) {
                        return ;
                    }
                    leftCache = left;
                    gridStyle.innerHTML = [
                        '<style type="text/css">.',
                        guid,
                        ' .eg-fixed .eg-fixed-s{left:',
                        left,
                        'px}.',
                        guid,
                        ' .eg-body-table, .',
                        guid,
                        ' .eg-head-table{margin-left:-',
                        left,
                        'px}</style>'
                    ].join("");
                });
            } else {
                this.gridScroll.on("scroll", function () {
                    left = self.left = this.scrollLeft;
                    left = left + "px";
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
            //竖向滚动，清除编辑渲染
            this.gridBody.on("scroll", function () {
                if (self.editObj) {
                    self._destroyFormEle();
                }
            });
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
                if (typeof height === 'number' && height > 0) {
                    this._setHeight(height);
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
                this.gridContainer.find(".eg-loading-bg").removeClass("eg-loading-bg-over");
            }
        },
        /**
         * 属性初始创建
         * @private
         */
        _createPropertys : function () {
            //获取表头中的属性
            this.__getTagsPropertys();
            //初始化编辑对象
            this._initEditType();
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
                sort           = this.sort = [],
                theadText     = this.theadText,
                colwidth      = this.colWidth,
                colRender     = this.colRender,
                fixedFnClick = this.fixedFnClick,
                colHidden = this.colHidden,
                disabled = this.disabled,
                i;
            //设置列宽备份
            for (i = 0; i < colSize; i += 1) {
                //设置colIndex
                var thI = domTh[i];
                colwidth.push(thI.style.width || thI.getAttribute("width") || "");
                //初始状态为隐藏
                colHidden[i] = thI.getAttribute("hide") === "true" || $(thI).css("display") === "none";
                //不可隐藏设置
                disabled[i] = thI.getAttribute("disabled");
                thI.removeAttribute("disabled")
                //获取渲染样式。
                var renderStyleAttrI = thI.getAttribute("renderStyle") || "";
                var renderStyleI = renderStyleAttrI
                    .replace(/padding.+?(;|$)/, "")
                    .replace(/display\s*?:\s*?none\s*?(;|$)/, "") + ";";
                renderStyle.push(renderStyleI);
                //获取bindName
                var bindNameI = thI.getAttribute("bindName") || "";
                bindName[i] = bindNameI;
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
                titleellipsis     = opts.titleellipsis,
                bindName = this.bindName,
                editType =this.editType,
                editTypeI,
                i, j, len;
            tr.className = "eg-width-norm";
            if (theadMapLen) {
                //控制空th的emptyth，多行表头需要。
                var emptyTh = document.createElement("th");
                emptyTh.className = "eg-empty-th";
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
            for (i = 0; i < colSize; i += 1) {
                //生成控制宽度的dom
                var th = domHeadCol[i] = document.createElement("th");
                tr.appendChild(th);
                //渲染th
                var domThI = domTh[i];
                if (i < fixcolumnnumber) {
                    $(domThI).addClass("eg-fixed");
                }
                if (sort[i]) {
                    $(domThI).addClass("eg-sort");
                }
                //CSS
                domThI.removeAttribute("width");
                domThI.style.width = "";
                //html
                var theadTextI = theadText[i],
                    thHtml = [
                    '<div class="eg-fixed-d">',
                    '<span class="eg-fixed-s'
                    ];

                //判断可编辑列,并判断是否为必需
                editTypeI = editType[bindName[i]];
                if(editTypeI) {
                    $(domThI).addClass("eg-editable");
                    if (editTypeI.validate) {
                        editTypeI = editTypeI.validate;
                        for (j = 0, len = editTypeI.length; j < len; j++)  {
                            if (editTypeI[j].type === "required") {
                                theadTextI = '<i>*</i>' + theadTextI;
                                break;
                            }
                        }
                    }
                }

                thHtml.push('">');
                if (sort[i]) {
                    thHtml.push('<b class="eg-sort-icon-desc cui-icon">&#xf0d7;</b><b class="eg-sort-icon-asc cui-icon">&#xf0d8;</b>');
                }
                thHtml.push('<a class="eg-thead-text');
                if (titleellipsis) {
                    thHtml.push('" title="', $.trim(theadTextI.replace(/<.*?>/g, "")));
                }
                thHtml.push('">', theadTextI ,'</a>');

                thHtml.push( );
                if (colhidden) {
                    thHtml.push('<a class="eg-select cui-icon">&#xf0b0;</a>');
                }
                thHtml.push('<em class="eg-ittab"></em>');
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
            for (j = 0; j < fixcolumnnumber; j += 1) {
                domTh[j].getElementsByTagName("div")[0].style.zIndex = fixcolumnnumber + 1 - j;
                domFixedJ.push(domTh[j].getElementsByTagName("span")[0]);
            }
            //多选设置
            var domTh0 = $(domTh[0]);
            if (opts.selectrows === "multi") {
                domTh0.find(".eg-select").eq(0).remove();
                domTh0.find(".eg-fixed-s").addClass("eg-no-move");
                var gridTheadText = $(domTh[0]).find(".eg-thead-text").addClass("eg-all-checkbox");
                gridTheadText.html(gridTheadText.text() + "<b></b>");
                this.gridAllCheck = gridTheadText;
            }
            //单选设置 去掉隐藏列按钮
            if (opts.selectrows === "single") {
                domTh0.find(".eg-select").eq(0).remove();
                domTh0.find(".eg-fixed-s").addClass("eg-no-move");
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
            tr.className = "eg-width-norm";
            for (var i = 0; i < colSize; i += 1) {
                var th = domBodyCol[i] = document.createElement("th");
                tr.appendChild(th);
            }
            el.html("<thead></thead><tbody></tbody>");
            el.find("thead").append(tr);
            this.gridTbody = el.find("tbody").eq(0);
        },
        /**
         * 加快tbody的渲染速度,生成每一行的模板.
         */
        __packageTds: function () {
            var opts            = this.options,
                fixcolumnnumber = opts.fixcolumnnumber,
                renderStyle    = this.renderStyle,
                selectrows      = opts.selectrows,
                selectrowsClass = this.selectrowsClass = {
                    "no"    : "",
                    "multi" : "eg-checkbox",
                    "single": "eg-radio"
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
                        '<div class="eg-fixed-d" style="z-index:',
                        fixcolumnnumber + 1,
                        ';"><span class="eg-fixed-s ',
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
                        '<div class="eg-fixed-d" style="z-index:',
                        fixcolumnnumber + 1 - i,
                        ';"><span class="eg-fixed-s" style="' ,
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
            var rowSize         = this.rowSize,
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
                        for (var m = rowSize; m--;) {
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
                        for (var n = rowSize; n--;) {
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
                var tableHeight = Math.max(gridTableBox.height() || this.rowSize * lineHeight, 50);
                this._setHeight(tableHeight + marginBottom + this.theadHeight + (this.options.pagination && this.rowSize ? 41 : 0) + 2);
            }
        },
        /**
         * 布局:包括外框宽高设置,col宽度设置.
         * @private
         */
        _setLayout: function (notSetScrolling) {
            if (this.editObj) {
                //销毁可编辑
                this._destroyFormEle();
            }
            this._setStyleWidth();
            //重设题头高度
            if (this.options.fixcolumnnumber || !this.options.titleellipsis) {
                this._setTheadHeight();
            }
            this._setStyleHeight();

            if (!notSetScrolling) {
                this._isScrolling();
            }
            this._setAutoHeight();
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
                    //totalSize变化,重载分页
                    this._changepages();
                }
            }
            this._isEmpty();
            //渲染开始
            this._initProperty();
            this._renderTbody(NaN, NaN);
            if(this.autoHeight && typeof this.options.resizewidth === "function") {
                this.resize();
            } else {
                this._setLayout();
            }
            this._loading("hide");
            this._loadCompleteCallBack();
            this.__setSortStyle();
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
                index, sortName,sortType, hide, width, i,
                bindName = this.bindName,
                editType = this.editType;
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
                        //可编辑列不能隐藏
                        for (i = 0; i < colSize; i ++) {
                            if (editType[bindName[i]]) {
                                hide[i] = false;
                            } else {
                                hide[i] = !!hide[i];
                            }
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
                this.gridTableBox.hide();
                this.paginationHeight = 0;
            } else {
                this.gridEmpty.hide();
                this.gridTableBox.show();
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
            var self = this;
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
            this.renderComplete  = false;
            if (this.gridAllCheck) {
                this.gridAllCheck.removeClass("eg-all-checkbox-checked");
            }
            this.gridTbody.html("");
            //可编辑相关数据初始化
            this.editObj = null;
            this.changeEditData = {
                "insertData" : {},
                "updateData" : {},
                "deleteData" : []
            };
            this.insertId = 0;
            this.validateState = {
                "insert": {},
                "update": {}
            };
            this.isChanged = false;
            this.dataBackup = {};
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
        _addData: function (data, position) {
            if ($.type(data) === "object") {
                data = [data];
            }
            var opts = this.options,
                disabledIndex = this.disabledIndex,
                len = data.length;
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
            if(this.autoHeight && typeof opts.resizewidth === "function") {
                this.resize();
            } else {
                this._setLayout();
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
                on_page_change: function (pageno, pagesize) {
                    var result = self.submit();
                    if (result === "ban") {
                        //验证不过
                        self._changepages();
                        return false;
                    }
                    query.pageNo = pageno;
                    query.pageSize = pagesize;
                    //提交，如不需要提交则直接加载
                    if (result === "notChange") {
                        self.loadData();
                    }
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
                rowSize    = this.rowSize,
                oldRowSize = rowSize - addSize,
                gridTbody = this.gridTbody[0];
            if (rowSize === 0) {
                this.renderComplete      = true;
                return;
            }
            this.renderComplete = false;
            if (!isNaN(addSize)) {

                //全选取消选中
                if (this.gridAllCheck) {
                    this.gridAllCheck.removeClass("eg-all-checkbox-checked");
                }
                if (typeof position === "number" && position < oldRowSize) {
                    //删除index属性.
                    var dom = this._dataToDom(data, position, position + addSize),
                        addTr = dom.domTr,
                        domTr = this.domTr,
                        domTrPosition = domTr[position];
                    for (var j = position; j < oldRowSize; j += 1) {
                        domTr[j].removeAttribute("index");
                    }
                    //获取dom
                    this._spliceArray(this.domTr, position, addTr);
                    this._spliceArray(this.domTd, position, dom.domTd);
                    this._spliceArray(this.domFixed, position + 1, dom.domFixed);
                    for (var i = 0; i < addSize; i += 1) {
                        gridTbody.insertBefore(addTr[i], domTrPosition);
                    }
                    this._setOddEven(position);
                    this._setNum(position);
                } else {
                    this._appendRows(oldRowSize, rowSize);
                }
                this._setAutoHeight();
            } else {
                this._appendRows(0, rowSize);
            }
        },
        /**
         * 渲染完成回调
         * @private
         */
        _loadCompleteCallBack: function () {
            var loadcompleteCallback = this.options.loadcomplete_callback;
            if (typeof loadcompleteCallback === "function") {
                loadcompleteCallback.call(this, this);
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
                i, j, domThJ, bindNameJ,
                sortStr = {"DESC":"desc", "ASC" : "asc"};
            loopOuter: for (j = this.colSize; j--;) {
                bindNameJ = bindName[j];
                domThJ = $(domTh[j]);
                for (i = 0; i < len; i++) {
                    if (sortName[i] === bindNameJ) {
                        domThJ.find("b").hide();
                        domThJ.find(".eg-sort-icon-" + sortStr[sortType[i]].toLocaleLowerCase()).show();
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
                    table.push(" eg-highlight");
                }
                table.push('"');
                var dataJ = data[j];
                if (dataJ.hasOwnProperty(primarykey)) {
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
                    table.push('<td class="eg-select-input ');
                    if (fixcolumnnumber > 0) {
                        table.push('eg-fixed');
                        table.push('" style="', tdsPackage0.style, '">', tdsPackage0.html, '</td>');
                    } else {
                        table.push(tdsPackage0.className);
                        table.push('" style="', tdsPackage0.style, '"></td>');
                    }

                }
                var tdsPackageI   = "",
                    colstyle        = "",
                    bindNameI     = "",
                    value           = "",
                    render          = "",
                    colRenderI    = null,
                    colRenderI0  = null,
                    colRenderI1  = null,
                    colJson        = null;
                for (var i = colStart; i < fixcolumnnumber; i += 1) {
                    bindNameI = bindName[i];
                    //渲染文字
                    if (numCol === i) {
                        value = j + bindNameI;
                    } else {
                        if (!bindNameI) {
                            value = "";
                        } else {
                            value = dataJ[bindNameI];
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
                    table.push('<td class="eg-fixed" style="', tdsPackageI.style, '">');
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
                    tdsPackageI = tdsPackage[i];
                    if (numCol === i) {
                        value = j + bindNameI;
                    } else {
                        if (!bindNameI) {
                            value = "";
                        } else {
                            value = dataJ[bindNameI];
                        }
                    }
                    colRenderI   = colRender[i];
                    colRenderI0 = colRenderI[0];
                    colRenderI1 = colRenderI[1];
                    if (colRenderI1) {
                        value = colRenderI1.callback(value, colRenderI1.format) || value;
                    }
                    if (colRenderI0) {
                        render = colRenderI0.render;
                        switch (render) {
                            case "colrenderFn" :
                                value = colRenderI0.callback(dataJ, bindNameI) || value;
                                break;
                            case "renderFn" :
                                colJson          = colRenderI0.colJson;
                                colJson.el       = domTh[i];
                                colJson.bindName = bindNameI;
                                value             = colRenderI0.callback(dataJ, j, colJson) || value;
                                break;
                            case "fiexdFn" :
                                value = renderMethod[colRenderI0.method](dataJ, colRenderI0.options, value) || value;
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
                domTd.push(domTdM);
                domFixed.push(domFixedM);
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
            var dom        = this._dataToDom(this.data, start, end);
            this.domTr    = this.domTr.concat(dom.domTr);
            this.domTd    = this.domTd.concat(dom.domTd);
            this.domFixed = this.domFixed.concat(dom.domFixed);
            var domTr     = this.domTr;
            var gridTbody = this.gridTbody[0];
            for (var i = start; i < end; i += 1) {
                gridTbody.appendChild(domTr[i]);
            }
            this.renderComplete = true;
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
                rowSize      = this.rowSize,
                oddEvenClass = this.oddEvenClass,
                odd          = this.odd = position % 2 === 0,
                i            = position;
            for (; i < rowSize; i += 1) {
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
                rowSize   = this.rowSize;
            if (this.options.fixcolumnnumber > numCol) {
                for (; i < rowSize; i += 1) {
                    var domFixedI = domFixed[i + 1][numCol];
                    var value = i + start;
                    domFixedI.innerHTML = value;
                    domFixedI.nextSibling.nodeValue = value;
                }
            } else {
                for (; i < rowSize; i += 1) {
                    domTd[i][numCol].innerHTML = i + start;
                }
            }
        },
        /**
         * 隐藏列,需要判断是否属于可编辑列，可编辑列不能被隐藏
         * @param hideBindName
         */
        hideCols: function (hideBindName) {
            if ($.type(hideBindName) !== "object") {
                return;
            }
            var colHidden = this.colHidden,
                colSize   = this.colSize,
                bindName  = this.bindName,
                bindNameI, falg,
                editType = this.editType;
            for (var i = 0; i < colSize; i += 1) {
                bindNameI = bindName[i];
                falg = hideBindName[bindNameI];
                if (editType[bindNameI]) {
                    colHidden[i] = false;
                } else if (typeof falg === "boolean") {
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
            if (typeof height !== "number" || height - 2 === this.gridHeight) {
                return false;
            }
            height          -= 2;
            this.boxHeight -= this.gridHeight - height;
            this.gridHeight = height;
            //this.isIttab = false;
            //高度改变,触发延迟加载
            this._setLayout();
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
            var index = this._pkToIndex(pk, false)[0];
            if (index === undefined) {
                return;
            }
            if (flag !== false) {
                $(this.domTr[index]).addClass("eg-highlight");
            } else {
                $(this.domTr[index]).removeClass("eg-highlight");
            }
            this.heightLight[index] = flag !== false;
        },
        /**
         * 通过序列选择行
         * @param index
         * @param flag
         * @returns {Array}
         */
        _selectRowsByIndex: function (index, flag) {
            flag = flag !== false;
            var opts = this.options,
                selectrows = opts.selectrows,
                data = this.data,
                dataI,
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
         * @param getInvalid 是否在匹配不上的时候返回-1
         * @returns {Array}
         * @private
         */
        _pkToIndex: function (pks, getInvalid) {
            var data = this.data,
                rowSize = this.rowSize,
                primarykey = this.options.primarykey;
            if (pks === undefined) {
                return [];
            }
            if ($.type(pks) !== "array") {
                pks = [pks];
            }
            var len = pks.length;
            var indexs = [];
            for (var i = 0; i < len; i += 1) {
                var pksI = pks[i] + "",
                    hasVal = false;
                for (var j = rowSize; j--;) {
                    if (data[j][primarykey] + "" === pksI) {
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
         * 通过主键选择行
         * @param pks
         * @param flag
         * @returns {*}
         */
        selectRowsByPK: function (pks, flag) {
            var opts = this.options;
            if ("array string number".indexOf($.type(pks)) === -1 ||
                opts.selectrows === "no" || !this.rowSize) {
                return [];
            }
            return this._selectRowsByIndex(this._pkToIndex(pks, true), flag);
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
                opts.selectrows === "no" || !this.rowSize) {
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
                    tr.addClass("eg-disable-row");
                } else {
                    tr.removeClass("eg-disable-row");
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
        _removeData: function (rows) {
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
                    selectrows     = opts.selectrows;
                for (var i = 0; i < len; i += 1) {
                    var rowsI = rows[i] - i;
                    var thisRowSize = this.rowSize;
                    if (isNaN(rowsI) || rowsI >= thisRowSize) {
                        rows[i] = 0;
                        break;
                    }
                    this.rowSize = thisRowSize - 1;
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
                            this.gridAllCheck.addClass("eg-all-checkbox-checked");
                        } else {
                            this.gridAllCheck.removeClass("eg-all-checkbox-checked");
                        }
                    }
                    //重设index
                    var domTr = this.domTr;
                    for (var j = this.rowSize; j--;) {
                        domTr[j].removeAttribute("index");
                    }
                    var rows0 = rows[0] - 0;
                    this._setOddEven(rows0);
                    this._setNum(rows0);
                }
                if(this.autoHeight && typeof this.options.resizewidth === "function") {
                    this.resize();
                } else {
                    this._setLayout();
                }
            }
        },
        /**
         * 改变某行数据
         * @param newData
         * @param index
         * @param currBindName
         * @private
         */
        _changeValue: function (newData, index, currBindName) {
            if ($.type(newData) !== "object") {
                return;
            }

            var opts = this.options,
                item,
                primarykey = opts.primarykey,
                pkValue = newData[primarykey],
                dom, newDomTd, oldDomTd,
                dataIndex,
                bindName= this.bindName,
                bindNameI, oldTdI,
                fixcolumnnumber = opts.fixcolumnnumber;
            if (index === undefined) {
                index = this._pkToIndex(pkValue, false)[0];
            }
            if (index < 0 || index >= this.rowSize) {
                return;
            }
            oldDomTd = this.domTd[index];
            dataIndex = this.data[index];
            for (var i in newData) {
                item = newData[i];

                if (!dataIndex.hasOwnProperty(i) || item === undefined || item === dataIndex[i]) {
                    continue;
                }

                if (typeof item === "object" ) {
                    dataIndex[i] = item.value;
                    newData[i] = item.text;
                } else {
                    dataIndex[i] = item;
                }
            }
            newData = $.extend({}, dataIndex, newData);
            dom = this._dataToDom([newData], 0, 1);
            newDomTd = dom.domTd[0];
            //替换数据
            this.odd = !this.odd;
            for (var i = this.colSize; i--;) {
                bindNameI = bindName[i];
                if (bindNameI === currBindName || dataIndex[bindNameI] === newData[bindNameI]) {
                    //当前触发列不修改
                    continue;
                }
                oldTdI = $(oldDomTd[i]);
                oldTdI.removeAttr("title");
                if (i < fixcolumnnumber) {
                    if (typeof bindNameI !== "number") {
                        var oldSpan = oldTdI.find(".eg-fixed-s")[0];
                        var value    = $(newDomTd[i]).find(".eg-fixed-s")[0].innerHTML;
                        oldSpan.innerHTML = value;
                        oldSpan.nextSibling.nodeValue = value;
                    }
                } else if (typeof bindNameI !== "number") {
                    oldTdI.html(newDomTd[i].innerHTML);
                }
            }
            this.data[index] = newData;
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
         * 获取选中行主键,新增行没有主键
         * @returns {Array}
         */
        getSelectedPrimaryKey: function () {
            var opts        = this.options,
                selectrows  = opts.selectrows,
                primarykey  = opts.primarykey,
                selectData = this.getSelectedRowData(),
                len         = selectData.length,
                pkValue;
            if (selectrows === "no" || !len) {
                return [];
            }
            var ret = [];
            for (var i = 0; i < len; i += 1) {
                pkValue = selectData[i][primarykey];
                if (pkValue !== undefined) {
                    //新增行没有pk，过滤掉
                    ret.push(selectData[i][primarykey]);
                }
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
         * 根据主键获取对象
         * @param pks
         * @returns {*}
         */
        getRowsDataByPK: function (pks) {
            var primarykey = this.options.primarykey;
            var data = this.data;
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
            var i = this.rowSize;
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
                self.gridHeadTable.find(".eg-ittab").show();
                self.gridHeadTable.on("mousedown", function (event) {
                    var target = event.target;
                    end = 0;
                    if (target.className === "eg-ittab") {
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
                var
                    hideCol = this.hideCol = document.createElement("div"),
                    theadHeight   = self.theadHeight,
                    banHideHtml, ban = 0;
                hideCol.className = "eg-hidecol";
                hideCol.style.top = theadHeight + "px";
                hideCol.tabIndex  = "1";
                self.gridContainer.append(hideCol);

                hideCol     = $(hideCol);
                var colSize = self.colSize,
                    text     = self.theadText,
                    bindName = self.bindName,
                    editType = self.editType || {},
                    textI   = "",
                    disabled = self.disabled,
                    i        = 0;
                if (self.selectrowsClass !== "") {
                    i += 1;
                }
                var html = ['<div class="eg-hidecol-list" hidefocus="true" >'];
                for (; i < colSize; i += 1) {
                    textI = $.trim(text[i].replace(/<.*?>/g, ""));
                    if (editType[bindName[i]] || disabled[i]) {
                        banHideHtml = ' class="eg-hidecol-hide" banHide="true">';
                        ban++;
                    } else {
                        banHideHtml = '>';
                    }
                    html.push(
                        '<a href="javascript:;" hidefocus="true" title=',
                        textI,
                        //编辑列，不可隐藏
                        banHideHtml,
                        textI,
                        '</a>'
                    );
                }
                html.push(
                    '</div>',
                    '<div class="eg-hidecol-button">',
                    '<a href="javascript:;" hidefocus="true" class="cui-button blue-button eg-hidecol-confirm">确定</a>',
                    '<a href="javascript:;" hidefocus="true" class="cui-button red-button eg-hidecol-cancel">取消</a>',
                    '</div>'
                );
                hideCol.html(html.join(""));
                this.gridHidecolList = hideCol.find(".eg-hidecol-list")[0];
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
                    if (target.hasClass("eg-select")) {
                        if (parent) {
                            obj.blur();
                        }
                        //inputs = obj.find("input");
                        parent = target.parents("th").addClass("eg-thead-select");
                        var offsetLeft = target.offset().left;
                        var left = offsetLeft - gridOffsetLeft + 2;
                        if (offsetLeft > centerPoint) {
                            left -= 126;
                        }
                        var height = Math.max(self.boxHeight + self.paginationHeight - 50, 60);
                        if (28 * (colSize - that.ban) > height) {
                            obj.children(".eg-hidecol-list").css("height", height);
                        } else {
                            obj.children(".eg-hidecol-list").css("height", "");
                        }
                        obj.css({"left": left, "top": self.theadHeight}).show().focus().attr("hidefocus", "true");
                        reStart();
                        var index = self._thIndex(parent[0]) - start;
                        $(domA[prevIndex]).removeClass("eg-hidecol-disabled");
                        $(domA[index]).addClass("eg-hidecol-disabled");
                        //编辑列不能隐藏，这里需要做判断
                        prevIndex = domA[index].getAttribute("banHide") ? -1 : index;
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
                        parent.removeClass("eg-thead-select");
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
                    if (target.hasClass("eg-hidecol-confirm")) {
                        for (var i = start; i < colSize; i += 1) {
                            hideCol[i] = $(domA[i - start]).hasClass("eg-hidecol-nochecked");
                        }
                        focus = false;
                        self._colHidden(false);
                        $(this).blur();
                        return false;
                    }
                    if (target.hasClass("eg-hidecol-cancel")) {
                        reStart();
                        focus = false;
                        $(this).blur();
                        return false;
                    }
                    if (target.prop("tagName") === "A") {
                        if (!target.hasClass("eg-hidecol-disabled")) {
                            target.toggleClass("eg-hidecol-nochecked");
                        }
                        return false;
                    }
                    this.focus();
                });

                function reStart () {
                    for (var j = start; j < colSize; j+=1) {
                        if(hideCol[j]) {
                            $(domA[j - start]).addClass("eg-hidecol-nochecked");
                        } else {
                            $(domA[j - start]).removeClass("eg-hidecol-nochecked");
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
                    gridHeadTable      = self.gridHeadTable.addClass("eg-col-move");
                gridColMoveInsert.addClass("eg-col-move-insert");
                gridColMoveTag.addClass("eg-col-move-tag");
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
                    if (!target.hasClass("eg-fixed-s") || target.hasClass("eg-no-move")) {
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
                    }).html(target.find(".eg-thead-text").eq(0).html());
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
         * 编辑Grid
         */
        /**
         * 初始化编辑对象，在获取bindName后执行
         * @private
         */
        _initEditType: function () {
            var opts = this.options,
                optEditType = opts.edittype,
                editType = this.editType,
                bindName = this.bindName,
                colRender = this.colRender,
                bindNameI, optEditTypeI, uiType,
                i, j, datasource,
                fixcolumnnumber,
                editDict = this.editDict;
            for (i = 0, j = this.colSize; i < j; i++) {
                bindNameI = bindName[i];
                optEditTypeI = optEditType[bindNameI];
                if (typeof bindNameI === "string" && optEditTypeI) {
                    if (editUiType.test(optEditTypeI.uitype)) {
                        //内置编辑方法
                        uiType = optEditTypeI.uitype;
                        uiType = uiType.charAt(0).toLowerCase() + uiType.slice(1);
                        optEditTypeI.uitype = uiType;
                        editType[bindNameI] = optEditTypeI;
                        /**
                         * Pulldown需要渲染label
                         * 由这里定义渲染函数
                         * 看#2184 ，#2177，#1156
                         * @type {Array}
                         */
                        if (dictType.test(uiType)) { //pullDownType 看#13
                            datasource = optEditTypeI.datasource;
                            editDict[bindNameI] = datasource;
                            colRender[i] = [{
                                "render"  : "renderFn",
                                "colJson": {
                                    "bindName": bindNameI,
                                    "editType": optEditTypeI
                                },
                                "callback": singleCallback
                            }];
                            switch(uiType) {
                                case "multiPullDown":
                                    colRender[i][0].callback = multiCallback;
                                    break;
                                case "pullDown":
                                    if (optEditTypeI.mode === "Multi") {
                                        colRender[i][0].callback = multiCallback;
                                    }
                                    break;
                                case "checkboxGroup":
                                    colRender[i][0].callback = checkboxCallback;
                                    editDict[bindNameI] = optEditTypeI.checkbox_list;
                                    break;
                                case "radioGroup":
                                    colRender[i][0].callback = radioCallback;
                                    editDict[bindNameI] = optEditTypeI.radio_list;
                            }
                        }
                        //可编辑列不能被固定
                        if (fixcolumnnumber === undefined) {
                            fixcolumnnumber = i;
                        }
                    } else if (typeof optEditTypeI.create === "function" && typeof optEditTypeI.returnValue === "function") {
                        //第三方编辑方法
                        editType[bindNameI] = optEditTypeI;
                        delete optEditTypeI.uitype;
                        //可编辑列不能被固定
                        if (fixcolumnnumber === undefined) {
                            fixcolumnnumber = i;
                        }
                    }
                }
            }
            //可编辑列不能被固定
            if (fixcolumnnumber !== undefined && opts.fixcolumnnumber >= fixcolumnnumber ) {
                opts.fixcolumnnumber = fixcolumnnumber;
            }
        },
        /**
         * 创建一个表单元素,用于编辑
         * @param td
         * @param editOpts
         * @param index
         * @param bindNameI
         * @param isTab
         * @private
         */
        _createFormEle: function (td, editOpts, index, bindNameI, isTab) {
            var editCarrier = $("<div>").addClass("eg-edit-box"),
                type = editOpts.uitype,
                rowData = this.data[index],
                value = rowData[bindNameI] + "";
            td.addClass("eg-editing").html(editCarrier);
            if (type) {
                //内置编辑方法
                type = type.charAt(0).toLowerCase() + type.slice(1);
                if (type === "checkboxGroup") {
                    value = value.split(";");
                }
                this.editObj = {
                    cuiObj: window.cui(editCarrier)[type]($.extend({
                        width: "100%",
                        name: Math.random() + "",
                        value: value
                    }, editOpts)),
                    editTdObj: td,
                    bindName: bindNameI,
                    index: index,
                    editOpts: editOpts
                };
                if (inputType.test(type)) {
                    editCarrier.find("input,textarea").select();
                } else if (isTab) {
                    td.find(":text").eq(0).focus();
                }
            } else {
                //第三方编辑方法
                editOpts.create(editCarrier[0], rowData);
                this.editObj = {
                    cuiObj: null,
                    editTdObj: td,
                    bindName: bindNameI,
                    index: index,
                    editOpts: editOpts
                };
            }
        },
        /**
         * 编辑完成，销毁一个表单元素
         * 把值html()到td
         * 实现联动
         * 更新编辑状态
         * @private
         */
        _destroyFormEle: function () {
            var editObj = this.editObj,
                bindName = this.bindName,
                bindNameP,
                bindNameI = editObj.bindName,
                editTdObj = editObj.editTdObj,
                tds,
				editCarrier = editTdObj.find(".eg-edit-box").eq(0),
                cuiObj = editObj.cuiObj,
                value,
                editOpts = editObj.editOpts,
                validate = editOpts.validate,
                uitype = editOpts.uitype,
                label, dType,
                newRowData = this.data[editObj.index],//用于修改后的数据对象
                rowData = $.extend({}, newRowData),//原始数据对象
                editafter, afterRowData, pk, pkValue,
                i, dataBackup, dataBackupI, isChange;
			if (cuiObj) {
				//内置创建方法
				value = "checkboxGroup" === uitype ? cuiObj.getValueString(";") : cuiObj.getValue();
                //更新数据
                newRowData[bindNameI] = value;
				if (dictType.test(uitype)) {
					//如果为pullDown，则需要把value转换成label
                    switch(uitype) {
                        case "singlePullDown":
                            dType = "single";
                            break;
                        case "multiPullDown":
                            dType = "multi";
                            break;
                        case "pullDown":
                            dType = editOpts.mode === "Multi" ? "multi" : "single";
                            break;
                        case "checkboxGroup":
                            label = checkboxCallback (newRowData, undefined, {
                                "bindName": bindNameI,
                                "editType": editOpts
                            });
                            break;
                        case "radioGroup":
                            label =  radioCallback (newRowData, undefined, {
                                "bindName": bindNameI,
                                "editType": editOpts
                            });
                    }
                    if (dType === "single") {
                        label = singleCallback(newRowData, undefined, {
                            "bindName": bindNameI,
                            "editType": editOpts
                        });
                        cuiObj.$box.remove();
                    } else if (dType === "multi") {
                        label = multiCallback(newRowData, undefined, {
                            "bindName": bindNameI,
                            "editType": editOpts
                        });
                        cuiObj.$box.remove();
                    }
				}
				cuiObj.destroy();
			} else {
				value = editOpts.returnValue(editCarrier[0], rowData);
                //更新数据
                if ($.type(value) === "object") {
                    label = value.text;
                    value = value.value;
                }
                newRowData[bindNameI] = value;
				editCarrier.remove();
				if (value === undefined) {
					return;
				}
			}
            editTdObj.html(label || value).removeClass("eg-editing");
            this.editObj = null;
            if (rowData[bindNameI] === value && value !== "") {
                //未改变，后面的内容不需要执行
                return;
            }
            //验证不过，后面的内容不执行
            if (validate && !this._validate(bindNameI, newRowData, validate, editTdObj)) {
                return;
            }
            pk = this.options.primarykey;
            pkValue = rowData[pk];
            //非新增行,需要备份原数据
            dataBackup = this.dataBackup;
            if (pkValue !== undefined && !dataBackup[pkValue]) {
                //第一次修改数据，才进行备份
                dataBackup[pkValue] = rowData;
            }

            //编辑联动
            editafter = this.options.editafter;
            if (typeof editafter === "function") {
                afterRowData = editafter($.extend({}, newRowData), bindNameI);
                if ($.type(afterRowData) === "object") {
                    newRowData = afterRowData;
                    //防止pk被改。
                    if (pkValue === undefined) {
                        delete newRowData[pk];
                    } else {
                        newRowData[pk] = pkValue;
                    }
                    this._changeValue(newRowData,
                        newRowData[pk] !== undefined ? undefined : editObj.index, bindNameI);
                }
            }

            // 判断当前行是否已经被修改。
            if (pkValue === undefined) {
                //新增的行被编辑
                this.changeEditData.insertData[rowData.__insertId__] = newRowData;
            } else {
                //有主键的行被编辑
                dataBackupI = dataBackup[pkValue];
                tds = editTdObj.closest("tr").find("td");
                for (i = this.colSize; i--;) {
                    bindNameP = bindName[i];
                    if (dataBackupI[bindNameP] !== newRowData[bindNameP]) {
                        //变化
                        tds.eq(i).addClass("eg-update");
                        isChange = true;
                    } else {
                        tds.eq(i).removeClass("eg-update");
                    }
                }
                if (isChange) {
                    this.changeEditData.updateData[pkValue] = newRowData;
                } else {
                    delete this.changeEditData.updateData[pkValue];
                }
            }
        },
        /**
         * 验证,并把验证状态更新到 validateState
         * @param bindName
         * @param rowData
         * @param validate
         * @param td
         * @returns {boolean}
         * @private
         */
        _validate: function (bindName, rowData, validate, td) {
            var lenValidate = validate.length,
                p, validateType, validateResult,
                pkValue = rowData[this.options.primarykey],
                vObj = pkValue !== undefined ? this.validateState.update : this.validateState.insert,
                vk = pkValue || rowData.__insertId__;
            for (p = 0; p < lenValidate; p++) {
                validateType = validate[p].type;
                if (rule[validateType]) {
                    validateResult = rule[validateType](rowData[bindName], validate[p].rule);
                    if (validateResult !== true) {
                        vObj[vk] = vObj[vk] || {};
                        vObj[vk][bindName] = validateResult;
                        if (td.attr("tip") === undefined) {
                            window.cui.tip(td);
                        }
                        td.attr("tip", validateResult).addClass("eg-error");
                        return false;
                    }
                }
            }
            //验证通过
            if (vObj[vk]) {
                delete vObj[vk][bindName];
                if (this._isNullObj(vObj[vk]) === undefined) {
                    delete vObj[vk];
                }
            }
            td.attr("tip", "").removeClass("eg-error");
            return true;
        },
        /**
         * 插入一条数据
         * @param rowData
         * @param position
         */
        insertRow: function (rowData, position) {
            var editType = this.editType,
                bindName = this.bindName,
                bindNameP,
                colSize = this.colSize,
                rowSize = this.rowSize,
                insertId = this.insertId,
                rowDom,
                p, editBindNames = [], hasNullValue,
                currTd, validate;
            if ($.type(rowData) !== "object") {
                return;
            }
            for (p in editType) {
                if (rowData[p] === undefined) {
                    rowData[p] = "";
                    hasNullValue = true;
                }
                editBindNames[p] = true;
            }
            //防止新增数据里面含有主键，导致冲突
            //delete rowData[this.options.primarykey];
            rowData.__insertId__ = insertId + "";

            if(typeof position !== "number" || position >= rowSize || position < 0) {
                position = rowSize;
            }
            this._addData(rowData, position);
            //给新增行增加样式
            rowDom = this.domTr[position];
            for (p = 0; p < colSize; p++) {
                bindNameP = bindName[p];
                if (editBindNames[bindNameP]) {
                    currTd =  $(rowDom.cells[p]);
                    validate = editType[bindNameP].validate;
                    currTd.addClass("eg-insert");
                    if (validate) {
                        this._validate(bindNameP, rowData, validate, currTd);
                    }
                }
            }
            this.insertId = insertId + 1;
            //当所有数据都预定义的时候，新增行数据保存为对象
            if (!hasNullValue) {
                this.changeEditData.insertData[insertId] = rowData;
            }
        },
        /**
         * 是否是空对象,如果不是返回第一条
         * @param obj
         * @returns {*}
         * @private
         */
        _isNullObj: function (obj) {
            var p;
            for (p in obj) {
                break;
            }
            if (p === undefined) {
                return undefined;
            }
            return [p, obj[p]];
        },
        /**
         * 删除行数据
         * @param pk
         */
        deleteRow: function (pk/*pks*/) {
            this.deleteRowByIndex(this._pkToIndex(pk, false));
        },
        /**
         * 根据行数删除行
         * @param index
         * @private
         */
        deleteRowByIndex: function (index) {
            var data = this.data,
                opts = this.options,
                changeEditData = this.changeEditData,
                deletebefore = opts.deletebefore,
                isBefore = typeof deletebefore === "function",
                deleteafter = opts.deleteafter,
                isAfter = typeof deleteafter === "function",
                i, indexI, dataI,
                pk = opts.primarykey,
                insertId, pkValue,
                indexType = $.type(index);
            if (indexType === "number") {
                index = [index];
            } else if (indexType !== "array"){
                return;
            }
            for (i = index.length ; i--;) {
                indexI = index[i];
                if (typeof indexI !== "number") {
                    continue;
                }
                dataI = data[indexI];
                if (!dataI) {
                    continue;
                }
                pkValue = dataI[pk];
                if (isBefore && pkValue !== undefined && deletebefore(dataI) === false) {
                    continue;
                }
                insertId = dataI.__insertId__;
                if (insertId !== undefined) {
                    delete changeEditData.insertData[insertId];
                    delete this.validateState.insert[insertId];
                }
                if (pkValue !== undefined) {
                    delete changeEditData.updateData[pkValue];
                    changeEditData.deleteData.push(dataI);
                    delete this.validateState.update[pkValue];
                }
                this._removeData(indexI);
                if (isAfter) {
                    deleteafter(dataI);
                }
            }
        },
        /**
         * 删除选择行
         */
        deleteSelectRow: function () {
            this.deleteRowByIndex(this.getSelectedIndex());
        },
        /**
         * 获取新增行的index
         */
        getInsertedIndex: function () {
            var data = this.data,
                rowSize = this.rowSize,
                i, ret = [];
            for (i = 0; i < rowSize; i++) {
                if (data[i].hasOwnProperty("__insertId__")) {
                    ret.push(i);
                }
            }
            return ret;
        },
        /**
         * 获取增删改数据
         */
        getChangeData: function () {
            var changeEditData = this.changeEditData,
                insertData = changeEditData.insertData, //object
                updateData = changeEditData.updateData, //object
                deleteData = changeEditData.deleteData, //array
                newInsert = [],
                newInsertI,
                newUpdate = [],
                newDelete = null,
                p;
            //拼凑insert
            for (p in insertData) {
                newInsertI = $.extend({}, insertData[p]);
                delete newInsertI.__insertId__;
                newInsert.push(newInsertI);

            }
            if (p !== undefined) {
                this.isChanged = true;
            } else {
                newInsert = null;
            }
            //拼凑update
            for (p in updateData) {
                newUpdate.push($.extend({}, updateData[p]));
            }
            if (p !== undefined) {
                this.isChanged = true;
            } else {
                newUpdate = null;
            }
            if ( deleteData.length) {
                this.isChanged = true;
                newDelete = $.extend(true, [], deleteData);
            }
            //拼凑delete,无
            return {
                "insertData": newInsert, //array
                "updateData": newUpdate, //array
                "deleteData": newDelete  //array
            };
        },
        /**
         * 提交数据
         * @returns {*}
         */
        submit: function () {
            if (this.editObj) {
                this._destroyFormEle();
            }
            var changeData = this.getChangeData(),
                vInsert, vUpdate, bindName, i, colSize,
                theadText, _isNullObj, vilidateResult, index, vBindName;
            //判断是否全部验证通过
                vInsert = this.validateState.insert;
                vUpdate = this.validateState.update;
                bindName = this.bindName;
                theadText = this.theadText;
                _isNullObj = this._isNullObj;
                vilidateResult = _isNullObj(vInsert);
                index = -1;
            if (vilidateResult !== undefined) {
                index = this._insertIdToIndex(vilidateResult[0]);
                //插入行，存在验证不过
            } else {
                vilidateResult = _isNullObj(vUpdate);
                if (vilidateResult !== undefined) {
                    index = this._pkToIndex(vilidateResult[0], true)[0];
                }
            }
            if (index > -1) {
                vBindName = _isNullObj(vilidateResult[1]);
                for (i = 0, colSize = this.colSize; i < colSize; i++) {
                    if(bindName[i] === vBindName[0]) {
                        cui.error(
                            ["第\"", index + 1, "\"行，\"", theadText[i], "\" 列有错误：", vBindName[1]].join(""),
                            null,
                            {title: "不能提交", opacity:0.8}
                        );
                        return "ban";
                    }
                }
            }
            //没有改变,返回false;
            if (!this.isChanged) {
                return "notChange";
            }

            this.isSaveing = true;
            this._loading("show");
            this.options.submitdata(this, changeData);
            return "success";
        },
        /**
         * 通过插入ID获取index
         * @param id
         * @private
         */
        _insertIdToIndex: function (id) {
            var data = this.data,
                i, rowSize = this.rowSize;
            for (i = 0; i < rowSize; i++) {
                if (data[i].__insertId__ === id) {
                    return i;
                }
            }
            return -1;
        },
        /**
         * 提交完成
         */
        submitComplete: function () {
            if(!this.isSaveing) {
                return;
            }
            this.isSaveing = false;
            this._loading("hide");
            this.loadData();
        }
    });

    /**
     * 可编辑Grid单选下拉列渲染函数
     * @param dataJ
     * @param j
     * @param colJson
     * @returns {*}
     */
    function singleCallback(dataJ, j, colJson) {
        var k, l,
            value = dataJ[colJson.bindName] || "",
            editType = colJson.editType,
            datasource =  editType.datasource,
            singlePullDownOpt = UI.SinglePullDown.prototype.options,
            id = editType.value_field || singlePullDownOpt.value_field,
            text = editType.label_field || singlePullDownOpt.label_field;
        for (k = 0, l = datasource.length; k < l; k++) {
            if (datasource[k][id] === value) {
                return datasource[k][text];
            }
        }
    }
    /**
     * 多选下拉渲染纠正
     * @param dataJ
     * @param j
     * @param colJson
     * @returns {*}
     */
    function multiCallback(dataJ, j, colJson) {
        var k, l, m, n,
            value = dataJ[colJson.bindName] || "",
            editType, datasource, singlePullDownOpt, id, text,
            ret;
        if (value === "") {
            return "";
        }
        value = value.split(";");
        editType = colJson.editType;
        datasource =  editType.datasource;
        singlePullDownOpt = UI.SinglePullDown.prototype.options;
        id = editType.value_field || singlePullDownOpt.value_field;
        text = editType.label_field || singlePullDownOpt.label_field;
        ret = [];
        for (m = 0, n = value.length; m < n; m++) {
            for (k = 0, l = datasource.length; k < l; k++) {
                if (datasource[k][id] === value[m]) {
                    ret.push(datasource[k][text]) ;
                }
            }
        }
        return ret.join(";");
    }

    /**
     * 单选渲染纠正
     * @param dataJ
     * @param j
     * @param colJson
     * @returns {*}
     */
    function radioCallback (dataJ, j, colJson) {
        var k, l,
            value = dataJ[colJson.bindName] || "",
            editType = colJson.editType,
            radioList =  editType.radio_list;
        for (k = 0, l = radioList.length; k < l; k++) {
            if (radioList[k].value === value) {
                return radioList[k].text;
            }
        }
    }

    /**
     * 多选渲染纠正
     * @param dataJ
     * @param j
     * @param colJson
     * @returns {string}
     */
    function checkboxCallback (dataJ, j, colJson) {
        var k, l, m, n,
            value = dataJ[colJson.bindName] || "",
            editType, checkboxList,
            ret;
        if (value === "") {
            return "";
        }
        value = value.split(";");
        editType = colJson.editType;
        checkboxList =  editType.checkbox_list;
        ret = [];
        for (m = 0, n = value.length; m < n; m++) {
            for (k = 0, l = checkboxList.length; k < l; k++) {
                if (checkboxList[k].value === value[m]) {
                    ret.push(checkboxList[k].text) ;
                }
            }
        }
        return ret.join(";");
    }
})(window.comtop);