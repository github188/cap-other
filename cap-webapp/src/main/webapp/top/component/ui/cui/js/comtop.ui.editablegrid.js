/**
 * ��grid
 * @author ��ΰ
 * @since 2013-6-31
 */
;(function (C) {
    'use strict';
    var $ = C.cQuery,
        UI = C.UI,
        fiexNumber = C.Tools.fixedNumber || function (a) {return a;},
        /*ƥ��༭Grid֧�ֵ�����*/
        editUiType = /^((i|I)nput|(c|C)lickInput|(p|((s|S)ingle|(m|M)ulti)?P)ullDown|(c|C)alender|(t|T)extarea)|((c|C)heckbox|(r|R)adio)Group$/,
        dictType = /(ullDown|Group)$/,
        inputType = /(nput|textarea)$/,
        rule = {
            /**
             * ��֤�Ƿ����(��չ�ֶ� req)
             * ���� ��������
             * m: ������Ϣ�ַ���
             * emptyVal:���������е�Ҳ��Ϊ��
             */
            required: function (value, paramsObj) {
                var params = $.extend({
                        m: "����Ϊ��!"
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
             * ��֤��ֵ����(��չ�ֶ� num)
             * ���� ����                                 ����
             *  oi�� �Ƿ�ֻ��ΪInteger ��onlyInteger��     true/false
             *  min: ��С��                               ����
             *  max: �����                               ����
             *  is:  ����͸��������                      ����
             *  wrongm: ���벻�� is ��ȵ�����ʱ��ʾ��Ϣ       ����
             *  notnm����Ϊ����ʱ��ʾ��Ϣ                    �ַ���
             *  notim����Ϊ����ʱ��ʾ��Ϣ                    �ַ���
             *  minm��С�� min ����ʱ��ʾ��Ϣ               �ַ���
             *  maxm������ max ����ʱ��ʾ��Ϣ               �ַ���
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
                    notANumberMessage:  paramsObj.notnm || "����Ϊ����!",
                    notAnIntegerMessage: paramsObj.notim || "����Ϊ����!",
                    wrongNumberMessage: paramsObj.wrongm || "����Ϊ " + paramsObj.is + "!",
                    tooLowMessage: paramsObj.minm || "������� " + paramsObj.min + "!",
                    tooHighMessage: paramsObj.maxm || "����С�� " + paramsObj.max + "!",
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
             * ������ʽ��֤ (��չ�ֶ� format)
             *  ����   ����                                 ����
             *  m:     ������Ϣ                             �ַ���
             *  pattern: ��֤������ʽ                     �ַ���
             *  negate: �Ƿ���Ա�����֤��negate��           true/false
             */
            format: function(value, paramsObj){
                if ('' === value) {
                    return true;
                }
                value = String(value);
                var params = $.extend({
                    m: "�����Ϲ涨��ʽ!",
                    pattern:  /./ ,
                    negate: false
                }, paramsObj || {});
                params.pattern = $.type(params.pattern) === "string" ?
                    new RegExp(params.pattern) : params.pattern;
                if(!params.negate && !params.pattern.test(value)) {//������
                    return params.m;
                }
                return true;
            },

            /**
             * �����ʽ��֤ (��չ�ֶ� email)
             * ���� ����                                 ����
             *  m:   ������Ϣ                             �ַ���
             */
            email: function(value, paramsObj){
                if ('' === value) {
                    return true;
                }
                var params = $.extend({
                    m: "�����ʽ���벻�Ϸ�!"
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
             * ���ڸ�ʽ��֤ (��չ�ֶ� date)���������ꡢ���µ�����
             * ���� ����                                 ����
             *  m:   ������Ϣ                            �ַ���
             */
            dateFormat : function(value, paramsObj) {
                var params = $.extend({
                    m: "���ڸ�ʽ����Ϊyyyy-MM-dd��ʽ��"
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
             * ������֤(��չ�ֶ� len)
             * ���� ����                               ����
             *  m:   ������Ϣ                          �ַ���
             *  min: ��С����                          ����
             *  max: ��󳤶�                          ����
             *  is:  ����͸ó������                     ����
             *  wrongm: ���볤�Ⱥ� is �����ʱ��ʾ��Ϣ        ����
             *  minm������С�� min ����ʱ��ʾ��Ϣ            �ַ���
             *  maxm�����ȴ��� max ����ʱ��ʾ��Ϣ            �ַ���
             */
            length: function(value, paramsObj){
                value = String(value);
                paramsObj = paramsObj || {};
                var params = {
                    wrongLengthMessage: paramsObj.wrongm || "���ȱ���Ϊ " + paramsObj.is + " �ֽ�!",
                    tooShortMessage:      paramsObj.minm || "���ȱ������ " + paramsObj.min + " �ֽ�!",
                    tooLongMessage:       paramsObj.maxm || "���ȱ���С�� " + paramsObj.max + " �ֽ�!",
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
                        return "������֤�����ṩ����ֵ!";
                }
                return true;
            },

            /**
             * ������֤ (��չ�ֶ� inc)
             * ���� ����                                 ����
             *  m:   ������Ϣ                             �ַ���
             *  negate: �Ƿ����                          true/false
             *  caseSensitive: ��Сд����(caseSensitive)   true/false
             *  allowNull: �Ƿ����Ϊ��                    ����
             *  within:  ����                             ����
             *  partialMatch: �Ƿ񲿷�ƥ��                 true/false
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
                    msg = params.m || (value + "û�а���������" + params.within.join(',') + "��");
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
             * ��������֤ (��չ�ֶ� exc)
             * ���� ����                                 ����
             *  m:   ������Ϣ                             �ַ���
             *  caseSensitive: ��Сд����(caseSensitive)   true/false
             *  allowNull: �Ƿ����Ϊ��                    ����
             *  within:  ����                             ����
             *  partialMatch: �Ƿ񲿷�ƥ��                 true/false
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
                params.m = params.m || value + "��Ӧ��������" + params.within.join(',') + "�У�";
                params.negate = true;// set outside of params so cannot be overridden
                msg = this.inclusion(value, params);
                if (msg !== true) {
                    return msg;
                }
                return true;
            },
            /**
             * ���ƥ��һ����֤�����û��������� (��չ�ֶ� confirm)
             * ���� ����                                 ����
             *  m:   ������Ϣ                             �ַ���
             *  match: ��֤��֮ƥ���Ԫ������              Ԫ�ػ�Ԫ��id
             */
            /* confirmation: function(value, paramsObj){
                if(!paramsObj.match) {
                    return "��֮ƥ���Ԫ�����û�Ԫ��id���뱻�ṩ!";
                }
                var params = $.extend({
                    m: "���߲�һ��!",
                    match: null
                }, paramsObj || {});
                params.match = $.type(params.match) === 'string' ? cui('#' + params.match) : params.match;
                if(!params.match || params.match.length == 0) {
                    throw new Error("Validate::Confirmation - ��֮ƥ���Ԫ�����û�Ԫ�ز�����!");
                }
                if(value !== params.match.getValue()) {
                    Validate.fail(params.m);
                }
                return true;
            },*/
            /**
             * ��ֵ֤�Ƿ�Ϊtrue ��Ҫ����֤checkbox (��չ�ֶ� accept)
             * ���� ����                                 ����
             *  m:   ������Ϣ                             �ַ���
             */
            acceptance: function(value, paramsObj){
                var params = $.extend({
                    m: "����ѡ��!"
                }, paramsObj || {});
                if(!value) {
                    return params.m;
                }
                return true;
            },
            /**
             * �Զ�����֤���� (��չ�ֶ� custom)
             * ���� ����                                 ����
             *  m:   ������Ϣ                             �ַ���
             *  against:  �Զ���ĺ���                    function
             *  args:   �Զ���ĺ����Ĳ���                 ����
             * */
            custom: function(value, paramsObj){
                var params = $.extend({
                    against: function(){ return true; },
                    args: {},
                    m: "���Ϸ�!"
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
            colrender             : null, //�ɱ༭�в�����Ⱦ
            sortstyle             : 1,
            sortname              : [],
            sorttype              : [],
            pageno                : 1,
            pagesize              : 50,
            pagesize_list         : [25, 50, 100],
            pagination            : true,
            pagination_model      : 'pagination_min_1',

            rowclick_callback     : null,
            loadcomplete_callback : null,//δȷ��
            selectall_callback    : null,
            rowdblclick_callback  : null,
            /*�༭Grid*/
            edittype              : {},
            submitdata            : null,
            editbefore          : null,
            editafter           : null,
            deletebefore        : null,
            deleteafter        : null
        },
        //��ʽ�� money, date
        formatFn: {
            "date": C.Date.simpleformat,
            "money": C.Number.money
        },
        //����Ⱦ
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
         * ��ʼ������������
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
            //���sort����,������������sort����.
            opts.sortname.length = Math.min(opts.sortname.length, sortstyle);
            opts.sorttype.length = Math.min(opts.sorttype.length, sortstyle);
            //ȡ���ݺ���
            if (typeof config === "string" && typeof window[config] === "function") {
                opts.config = window[config];
            }
            if (typeof onstatuschange === "string" && typeof window[onstatuschange] === "function") {
                opts.onstatuschange = window[onstatuschange];
            }
            if (typeof datasource === "string" && typeof window[datasource] === "function") {
                opts.datasource = window[datasource];
            }
            //���ó�ʼ����
            this.el                = opts.el;
            this.elCache          = null; //dom�浽�ڴ棬��ΪIE��tableֻ��
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
            //��������
            this.domTh            = [];
            this.domTr            = [];
            this.domTd            = [];
            this.domFixed         = [];
            this.domHeadCol      = [];
            this.domBodyCol      = [];
            this.theadMap         = [];
            this.extendTh         = [];
            this.trFrag           = document.createElement("tbody");
            //����
            this.data              = [];
            this.backupQuery      = null;
            this.query             = null;
            this.customQuery      = null;
            //����
            this.rowSize          = 0;
            this.colSize          = 0;
            //����
            this.sortType         = {};
            this.theadText        = [];
            this.renderStyle      = [];
            this.colRender        = []; //��Ԫ����Ⱦ��������
            this.bindName         = []; // -1 ��ѡ��ѡ; 0,1 ���; "" û�а�; "string" ����
            this.left    = 0; //��������ߵ�scrollLeft
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
            //��ʽ
            this.gridWidth        = 0;
            this.gridHeight       = 0;
            this.tableWidth       = 0;
            this.theadHeight      = 30;
            this.boxHeight        = 0;
            this.paginationHeight = opts.pagination ? 41 : 0;
            //htmlƬ��
            this.selectrowsClass   = "";
            this.tdsPackage       = [];

            //�жϱ�ʶ
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
            //�ж��Ƿ�̬д��style��ǩ
            try {
                var head = $("head");
                head.append('<style type="text/css"></style>');
                head.find("style").last()[0].innerHTML = "";//���styleֻ�����б���
                this.writeStyle = true;
            } catch (e) {
                this.writeStyle = false;
            }

            //�ɱ༭Grid����
            this.editType = {};
            this.editDict = {};
            this.editObj = null;
            this.changeEditData = {
                "insertData" : {},
                "updateData" : {},
                "deleteData" : []
            };

            /**��֤����ṹ
            this.validateState = {
                "insert": {
                    "insertId" : {
                        "bindName1" : "������ʾ1",
                        "bindName2" : "������ʾ2",
                    }
                },
                "update": {
                    "pkValue" : {
                        "bindName1" : "������ʾ1",
                        "bindName2" : "������ʾ2",
                    }
                },
            }*/
            this.validateState = {
                "insert": {},
                "update": {}
            };
            this.insertId = 0; //�������е���������һ�����ظ���id����insertRow����

            //����data�������Ƿ��޸ĵıȽ�
            this.dataBackup = {};
            this.isChanged = false;
            //����query
            this._backupQuery();
            //��ʼ��pagesize
            this._setPageSize();
            //�����������
            this._setSortTypeObj();
            //��ȡ��ͷdom
            this.__getDomTh();
            //��ʼ��������
            this.__initWidthAndHeight();

        },
        /**
         * ���ݲ�ѯ����
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
         * ����pagesize
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
         * �����������Ե�sorttype����
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
         * ��ȡ��ͷth,����������ͷmap
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
            //��ȡ�ڴ������tr
            this.elCache = elChache;
            tr = elChache.find("tr");
            trLen = tr.length;
            if (trLen === 1) {//������ͷ
                var ths = elChache[0].getElementsByTagName("th"),
                    domTh = [];
                for (var g = 0, h = ths.length; g < h; g += 1) {
                    domTh.push(ths[g]);
                    colIndex[g] = g;
                }
                this.domTh = domTh;
            } else {//������ͷ
                var theadMap = this.theadMap = [],
                    i, j, l,
                    theadMapL;
                //colSpan�滻
                for (i = 0; i < trLen; i += 1) {//ÿһ��
                    var trI = tr.eq(i)[0],
                        thI = trI.cells,
                        lenThI = thI.length,
                        allCellSpan = 0;
                    extendTh[i] = [];
                    if (!theadMap[i]) {
                        theadMap[i] = [];
                    }
                    for (j = 0; j < lenThI; j += 1) {//ÿһ��
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
                //rowSpan�滻
                for (i = trLen; i --;) {//ÿһ��
                    var mapI = theadMap[i],
                        lenMapI = mapI.length;
                    for (j = 0; j < lenMapI; j += 1) {//ÿһ��
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
         * �����ʼ�Ŀ��
         * @private
         */
        __initWidthAndHeight: function () {
            var opts        = this.options,
            //����ȸ߶�
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
            //table�Ŀ��
            this.theadHeight = this.elCache.find("tr").length * 30;
            this.boxHeight   = this.gridHeight - this.paginationHeight - this.theadHeight;
            this.tableWidth  = opts.adaptive ? this.gridWidth - 17 : fiexNumber(opts.tablewidth) || this.gridWidth;
        },

        /**
         * �������dom
         * @private
         */
        _create: function () {
            //�������
            this.__createLayoutDom();
            //�¼�ί��
            this.__theadClickEventBind();
            this.__theadMouseEventBind();
            this.__tbodyMouseEventBind();
            this.__tbodyKeyEventBind();
            //�ص�
            this.__imitateScroll();
            this._resizeEventBind();
            //���ó�ʼ�����ʽ
            this._setStyleWidth();
            this._setStyleHeight();
            //���û�г־û���ֱ����Ⱦ����
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
         * ������� div
         * @private
         */
        __createLayoutDom: function () {
            var opts            = this.options,
                el              = this.el,
            //����dom
                container       = document.createElement("div");
            container.className = "eg-container";
            var html = [
                '<div class="eg-style"></div>',
                '<div class="eg-box">',
                '<div class="eg-head">',
                '<table class="eg-head-table"></table>',
                '</div>',
                '<div class="eg-body">',
                '<div class="eg-empty">���б����޼�¼</div>',
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
                '<div class="eg-loading-box"><span>���ڼ���...</span></div>'
            ];
            container.innerHTML = html.join("");
            el[0].parentNode.insertBefore(container, el[0]);
            //����jq����
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
            //����dom����
            this.gridTableHide = $(".eg-table-hide", gridContainer).eq(0).append(el.addClass("eg-body-table"));
            if (opts.ellipsis) { //�Ƿ��ܻ���
                el.addClass("eg-ellipsis");
            }
            if (opts.titleellipsis) {//��ͷ�Ƿ���
                this.gridHeadTable.addClass("eg-ellipsis");
            }
        },
        /**
         * ��ͷ����¼�
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
                    return;//���� ���Ե��� ������ ����
                }
                //ȫѡ

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
                //����
                var gridSort = target.parents(".eg-sort");
                if (gridSort.length && className === "eg-thead-text") {
                    var sortType       = self.sortType,
                        bindNameI     = bindName[self._thIndex(gridSort[0])],
                        sortTypeI     = sortType[bindNameI],// || "ASC",
                        newSortTypeI = sortTypeI !== "DESC" ? "DESC" : "ASC";
                    self._setOptsSortNameAndSoryType(bindNameI, newSortTypeI);
                    //�־û�����
                    if (self.persistence) {
                        self._triggerStatusChange();
                    }
                    //�ύ���粻��Ҫ�ύ��ֱ�Ӽ���
                    if (self.submit() === "notChange") {
                        self.loadData();
                    }
                }
            });
        },
        /**
         * ��ȡ��ǰ�е�����,��ͷ������ֻ���ô˺���
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
         * ����this.query��sortname��sorttype
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
         * th���over,out�¼�
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
         * �����������¼�
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
                //������
                tr.addClass("eg-tr-over");
                //���ڱ༭ing
                editing = td.hasClass("eg-editing");
                if (editing) {
                    return;
                }
                //�ɱ༭��
                if (editTypeI) {
                    isEdit = true;
                    td.addClass("eg-editable-td");
                }
                //��Ⱦtitle
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
                    //�����һ���༭
                    if (self.editObj) {
                        self._destroyFormEle();
                    }
                    if (editTypeI) {
                        //�༭��Ԫ��
                        self.__startEdit(editTypeI, td, rowIndex, bindNameI);
                        return;
                    }
                    //�Ǳ༭��Ԫ��
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

                    //����
                    if (rowdblclickCallback) {
                        clearTimeout(timeout);
                        timeout = setTimeout(function () {
                            clickCallback(rowIndex);
                        }, 300);
                    } else {
                        clickCallback(rowIndex);
                    }
                }
                //�����һ���༭
                if (self.editObj) {
                    self._destroyFormEle();
                }
            });
            function clickCallback(rowIndex) {
                //ѡ���лص�
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
         * ���������ڱ༭ʱ��tab�л�
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
                            //�л�����һ��
                            self.__createNextEditObj(index + 1, self.bindName[0]);
                        }
                    }
                }
            });
        },
        /**
         * ������һ���༭
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
         * Ϊ��Ԫ����Ⱦtitle����
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
                    title = title + " (����༭)";
                }
                td.attr("title", title);
            }
        },
        /**
         * ��ʼ�༭��Ⱦ
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
         * ѡ����
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
                //��ǰ�б�����ѡ��
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
         * ģ�������
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
            //�������������༭��Ⱦ
            this.gridBody.on("scroll", function () {
                if (self.editObj) {
                    self._destroyFormEle();
                }
            });
        },
        /**
         * resize�¼�
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
         * ���ݻص����ÿ��
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
         * ������������ʽ.
         * @private
         */
        _setStyleWidth: function () {
            this.gridContainer.css("width", this.gridWidth);
            this.el.css("width", this.tableWidth);
            this.gridHeadTable.css("width", this.tableWidth);
        },
        /**
         * ��������߶���ʽ.
         * @private
         */
        _setStyleHeight: function () {
            this.gridContainer.css("height", this.gridHeight);
            this.gridHead.css("height", this.theadHeight);
            this.gridOverlay.css("height", this.theadHeight);
            this.gridBody.css("height", this.boxHeight);
        },
        /**
         * ������...
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
         * ���Գ�ʼ����
         * @private
         */
        _createPropertys : function () {
            //��ȡ��ͷ�е�����
            this.__getTagsPropertys();
            //��ʼ���༭����
            this._initEditType();
            //��ʼ��ÿһ�п��
            this.__initColWidth();
        },
        /**
         * �����ʼ����
         * @private
         */
        _createContent: function () {
            //��Ⱦhead��body
            this.__renderHead();
            this.__renderBody();
            //�����п�
            this._setColWidthStyle();
            //tbody������Ⱦ���
            this.__packageTds();
            //��ʼ������
            this._colHidden(true);
            //��չ����,�϶��п��������
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
         * ��ȡģ���е�������.
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
            //�����п���
            for (i = 0; i < colSize; i += 1) {
                //����colIndex
                var thI = domTh[i];
                colwidth.push(thI.style.width || thI.getAttribute("width") || "");
                //��ʼ״̬Ϊ����
                colHidden[i] = thI.getAttribute("hide") === "true" || $(thI).css("display") === "none";
                //������������
                disabled[i] = thI.getAttribute("disabled");
                thI.removeAttribute("disabled")
                //��ȡ��Ⱦ��ʽ��
                var renderStyleAttrI = thI.getAttribute("renderStyle") || "";
                var renderStyleI = renderStyleAttrI
                    .replace(/padding.+?(;|$)/, "")
                    .replace(/display\s*?:\s*?none\s*?(;|$)/, "") + ";";
                renderStyle.push(renderStyleI);
                //��ȡbindName
                var bindNameI = thI.getAttribute("bindName") || "";
                bindName[i] = bindNameI;
                if (isNaN(this.numCol) && bindNameI.length && !isNaN(bindNameI - 0)) {//�����
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
                //��ͷ����
                theadText.push(thI.innerHTML);
                //��Ⱦ����. ���ȼ� format < colRender < render  �̶�render������������ȡ;
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
                //��Ԫ����Ⱦ�ܺ���
                if (typeof colrender === "function") {
                    colRender[i][0] = {
                        "render": "colrenderFn",
                        "callback": colrender
                    };
                }
                //���й̶���Ⱦ
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
            //����bindName
            var selectrows = opts.selectrows;
            if (selectrows === "multi" || selectrows === "single") {
                bindName[0] = -1;
            }
        },
        /**
         * �����ʼÿһ�еĿ�ȡ�
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
                } else {//����
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
         * ��Ⱦ��ͷ ���������dom
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
                //���ƿ�th��emptyth�����б�ͷ��Ҫ��
                var emptyTh = document.createElement("th");
                emptyTh.className = "eg-empty-th";
                tr.appendChild(emptyTh);
                //ȥ�����
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
                //���ɿ��ƿ�ȵ�dom
                var th = domHeadCol[i] = document.createElement("th");
                tr.appendChild(th);
                //��Ⱦth
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

                //�жϿɱ༭��,���ж��Ƿ�Ϊ����
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
            this.elCache.parent().remove(); //�ڴ����������û�����ˣ�ɾ����
            delete this.elCache;
            //����fixed dom ����z-index��ʽ
            for (j = 0; j < fixcolumnnumber; j += 1) {
                domTh[j].getElementsByTagName("div")[0].style.zIndex = fixcolumnnumber + 1 - j;
                domFixedJ.push(domTh[j].getElementsByTagName("span")[0]);
            }
            //��ѡ����
            var domTh0 = $(domTh[0]);
            if (opts.selectrows === "multi") {
                domTh0.find(".eg-select").eq(0).remove();
                domTh0.find(".eg-fixed-s").addClass("eg-no-move");
                var gridTheadText = $(domTh[0]).find(".eg-thead-text").addClass("eg-all-checkbox");
                gridTheadText.html(gridTheadText.text() + "<b></b>");
                this.gridAllCheck = gridTheadText;
            }
            //��ѡ���� ȥ�������а�ť
            if (opts.selectrows === "single") {
                domTh0.find(".eg-select").eq(0).remove();
                domTh0.find(".eg-fixed-s").addClass("eg-no-move");
            }
        },
        /**
         * ����tbody����don
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
         * �ӿ�tbody����Ⱦ�ٶ�,����ÿһ�е�ģ��.
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
            //����ÿһ��ģ�塣
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
         * �����п�,�����в�������.
         * adaptive === true, �� gridWidth === tableWidth ��ʱ���õ�.
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
                if (colHidden[i] === false) { //��ʾ
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
         * ����ÿ�п��
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
         * ������
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
                //����Ӧ���
                this.isIttab = false;
            }
            this._setLayout();
            //�־û�����
            if (this.persistence && !init) {
                this._triggerStatusChange();
            }
        },
        /**
         * �־û�����
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
         * �жϺ��������Ƿ��й�����
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
                //��������
                if (boxHeight < contentHeight) {
                    tableWidth = this.tableWidth = gridWidth - 17;
                } else {//û�й�����
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
                //ֻ�����������
                if (boxHeight < contentHeight &&
                    gridWidth >= tableWidth + 17) {
                    this.gridTableHide.css("marginBottom", 0);
                    gridScroll.css({"left": "-999999px", "width" : gridWidth - 17});
                }
                //ֻ�к��������
                if (gridWidth < tableWidth &&
                    boxHeight >= contentHeight + 17) {
                    gridScroll.css({"width": gridWidth, "left" : 0, "bottom": ""});
                    gridScroll.css("bottom", 0);
                    this.gridTableHide.css("marginBottom", 17);
                }
                //˫�������;
                if (gridWidth < tableWidth + 17 &&
                    boxHeight < contentHeight || gridWidth < tableWidth &&
                    boxHeight < contentHeight + 17) {
                    gridScroll.css({"width": gridWidth - 17, "left" : 0, "bottom": ""});
                    gridScroll.css("bottom", 0); //����Grid�߶ȸı�ʱ��gridScroll��λ�ò������Ÿı䣨IE6��
                    this.gridTableHide.css("marginBottom", 17); //�к���
                }
                //û�й�����
                if (boxHeight >= contentHeight &&
                    gridWidth >= tableWidth) {
                    this.gridTableHide.css("marginBottom", 0);
                    gridScroll.css({"left": "-999999px", "width" : gridWidth});
                }
            }
            gridScroll.find("div").eq(0).css("width", tableWidth);
            //���ù�����
            clearTimeout(this.sc);
            this.sc = setTimeout (function () {
                gridScroll.scroll();
            }, 10);
        },
        /**
         * �߶�����Ӧ��ʱ��,�������ø߶�
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
         * ����:�������������,col�������.
         * @private
         */
        _setLayout: function (notSetScrolling) {
            if (this.editObj) {
                //���ٿɱ༭
                this._destroyFormEle();
            }
            this._setStyleWidth();
            //������ͷ�߶�
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
         * ��ͷ������ʱ��Ҫ����
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
         * ���ó־û�����
         * @param {String} config
         */
        setConfig: function (config) {
            if (this.persistence && this.unRender) {
                this._setPersistence(config);
            }
            this.options.datasource(this, this.getQuery());
        },
        /**
         * ��������
         */
        setDatasource: function (data, totalSize, persistenceConf) {
            if (this.persistence && this.unRender && typeof persistenceConf === "string") {
                this._setPersistence(persistenceConf);
            }
            data = data || [];
            totalSize = totalSize || 0;
            this.rowSize = data.length;
            this.data = $.extend(true, [], data);
            //�����ҳ
            if (this.options.pagination) {
                this.totalSize = totalSize;
                //��һ����Ⱦ,���ط�ҳ
                if (this.unRender) {
                    this.__createPagination();
                } else {
                    //totalSize�仯,���ط�ҳ
                    this._changepages();
                }
            }
            this._isEmpty();
            //��Ⱦ��ʼ
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
         * �־û���ԭ����
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
                        this.gridHeadTable.css("width", this.tableWidth);//�Ƿ�Ҫ����table�Ŀ��
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
                        //�ɱ༭�в�������
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
                        colSize === width.length) {//����Ӧģʽ�£���֧���п�־û���
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
         * �־û���������
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
         * �Ƿ������ǿ�
         * @private
         */
        _isEmpty: function () {
            var opts = this.options;
            var rowSize = this.rowSize;
            //�ж��Ƿ���ʾ��ҳ
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
            //���ݷ�ҳ ����boxHeight
            this.boxHeight = this.gridHeight - this.paginationHeight - this.theadHeight;
        },
        /**
         * ��������,��Ҫ��ʼ������
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
            //�ɱ༭������ݳ�ʼ��
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
         * ��������
         */
        loadData: function () {
            this._loading("show");
            this.options.datasource(this, this.getQuery());
        },
        /**
         * ׷������
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
            if (this.unRender) { //���δ setDatasource��.
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
         * ��Ⱦ��ҳ
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
                        //��֤����
                        self._changepages();
                        return false;
                    }
                    query.pageNo = pageno;
                    query.pageSize = pagesize;
                    //�ύ���粻��Ҫ�ύ��ֱ�Ӽ���
                    if (result === "notChange") {
                        self.loadData();
                    }
                    self._changepages();
                }
            });
            this.paginationObj = window.cui(this.gridTfoot);
        },
        /**
         * ��ҳ�¼�
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
         * �м��������
         * @private
         */
        _spliceArray: function (source, position, target) {
            Array.prototype.splice.apply(source, [position, 0].concat(target));
            return source;
        },
        /**
         * ��Ⱦtbody
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

                //ȫѡȡ��ѡ��
                if (this.gridAllCheck) {
                    this.gridAllCheck.removeClass("eg-all-checkbox-checked");
                }
                if (typeof position === "number" && position < oldRowSize) {
                    //ɾ��index����.
                    var dom = this._dataToDom(data, position, position + addSize),
                        addTr = dom.domTr,
                        domTr = this.domTr,
                        domTrPosition = domTr[position];
                    for (var j = position; j < oldRowSize; j += 1) {
                        domTr[j].removeAttribute("index");
                    }
                    //��ȡdom
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
         * ��Ⱦ��ɻص�
         * @private
         */
        _loadCompleteCallBack: function () {
            var loadcompleteCallback = this.options.loadcomplete_callback;
            if (typeof loadcompleteCallback === "function") {
                loadcompleteCallback.call(this, this);
            }
        },
        /**
         * ����������ʽ
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
         * dataת����ÿһ�е�dom
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
                //��Ԫ��������Ⱦ
                colRender          = this.colRender,
                //��ʽ��Ⱦ
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
                    //��Ⱦ����
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
                    //��td��ʽ
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
         * ���������
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
         * ������������ż������ʽ
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
         * �����к�
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
         * ������,��Ҫ�ж��Ƿ����ڿɱ༭�У��ɱ༭�в��ܱ�����
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
         * ��ȡ��ѯ����
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
         * ���ò�ѯ����
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
         * �ڲ��õ����ø߶�
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
            //�߶ȸı�,�����ӳټ���
            this._setLayout();
            if (this.options.colhidden && this.hideCol.hideCol) {
                this.hideCol.hideCol.blur();
            }
            return true;
        },
        /**
         * ��������߶�
         */
        setHeight: function (height) {//������� Ҫ���Ƿ�ҳ���ֵĸ߶�.
            this.autoHeight = !this._setHeight(height);
        },
        /**
         * ����������
         */
        setWidth: function (width) {
            if (typeof width !== "number" || width - 2 === this.gridWidth) {
                return;
            }
            var ittab = this.ittab; //�޸�IE������ֹ�����������resize��bug
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
         * �����и���
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
         * ͨ������ѡ����
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
         * ͨ��������ȡ�к�
         * @param pks
         * @param getInvalid �Ƿ���ƥ�䲻�ϵ�ʱ�򷵻�-1
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
         * ͨ������ѡ����
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
         * ����pkΪɶɶɶ�Ĳ��ܱ�ѡ��ѡ�еı�ȡ����
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
         * ɾ���в���.
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
         * ɾ����
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
                    //ѡ������
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
                //�ж��Ƿ���Ҫ��ת��һҳ
                if (rowSize <= 0) {
                    if (this.query.pageNo > 1) {
                        this.query.pageNo -= 1;
                    }
                    this.rowSize = 0;
                    this._isEmpty();
                } else {
                    //�ж��Ƿ�ȫѡ
                    if (opts.selectrows === "multi") {
                        if (this.multiCheckedNum === rowSize) {
                            this.gridAllCheck.addClass("eg-all-checkbox-checked");
                        } else {
                            this.gridAllCheck.removeClass("eg-all-checkbox-checked");
                        }
                    }
                    //����index
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
         * �ı�ĳ������
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
            //�滻����
            this.odd = !this.odd;
            for (var i = this.colSize; i--;) {
                bindNameI = bindName[i];
                if (bindNameI === currBindName || dataIndex[bindNameI] === newData[bindNameI]) {
                    //��ǰ�����в��޸�
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
         * ��ȡ����
         */
        getData: function () {
            return $.extend(true, [], this.data);
        },
        /**
         * ��ȡѡ�������ݼ�
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
         * ��ȡѡ��������,������û������
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
                    //������û��pk�����˵�
                    ret.push(selectData[i][primarykey]);
                }
            }
            return ret;
        },
        /**
         * ��ȡ��ѡ�е�����
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
         * ����������ȡ����
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
         * ������
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
            //����
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
            //������λ��ȷ��
            if (!isNaN(numCol)) {
                if (start === numCol) {
                    this.numCol = end - (start > end ? 0 : 1);
                } else if (start > numCol && end <= numCol){
                    this.numCol = numCol + 1;
                } else if (start < numCol && end > numCol) {
                    this.numCol = numCol - 1;
                }
            }
            //dom�滻
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
            //dom����
            this._switchArrayValue(domTh, start, end);
            if (start < fixcolumnnumber || end < fixcolumnnumber) {
                //���ù̶��е�zIndex
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
            //�־û�
            if (this.persistence) {
                this._triggerStatusChange();
            }
        },
        /**
         * ���������ֵ
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
        //�п��϶�
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
        //������
        hideCol: {
            /**
             * ��ʼ��
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
                        //�༭�У���������
                        banHideHtml,
                        textI,
                        '</a>'
                    );
                }
                html.push(
                    '</div>',
                    '<div class="eg-hidecol-button">',
                    '<a href="javascript:;" hidefocus="true" class="cui-button blue-button eg-hidecol-confirm">ȷ��</a>',
                    '<a href="javascript:;" hidefocus="true" class="cui-button red-button eg-hidecol-cancel">ȡ��</a>',
                    '</div>'
                );
                hideCol.html(html.join(""));
                this.gridHidecolList = hideCol.find(".eg-hidecol-list")[0];
                this.domA             = this.gridHidecolList.getElementsByTagName("a");
                this.bindEvent(self, hideCol);
                this.ban = ban;
            },
            /**
             * �¼���
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
                        //�༭�в������أ�������Ҫ���ж�
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
         * ���϶�
         */
        moveCol: {
            _init: function (self) {
                //����dom
                var gridColMoveInsert = $("<div></div>"),
                    gridColMoveTag    = $("<div></div>"),
                    gridHeadTable      = self.gridHeadTable.addClass("eg-col-move");
                gridColMoveInsert.addClass("eg-col-move-insert");
                gridColMoveTag.addClass("eg-col-move-tag");
                self.gridHead.append(gridColMoveTag).append(gridColMoveInsert);
                //��ȡ����
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
                    //��ȡ����
                    moveTrigger         = false;
                    colHidden           = self.colHidden;
                    var colwidth        = self.colWidth,
                        colSize         = self.colSize,
                        domTh           = self.domTh,
                        domFixed0      = self.domFixed[0],
                        headOffsetLeft = Math.round(gridHeadTable.offset().left),
                        scrollLeft      = self.gridScroll[0].scrollLeft,
                        end              = 0,
                    //��ȡ��ǰth
                        height           = self.theadHeight,
                        parent           = target.parent().parent();
                    index                = self._thIndex(parent[0]);
                    //�����th��λ��
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
                    //���ÿ�λ�úʹ�С
                    gridColMoveTag.show().css({
                        left       : leftIndex,
                        width      : parent.width(),
                        height     : height - 1,
                        lineHeight : height - 1 + "px"
                    }).html(target.find(".eg-thead-text").eq(0).html());
                    gridColMoveInsert.show().css("height", height - 5);
                    gridOverlay.show().css("cursor", "move");
                    var start = event.pageX;
                    //�¼�
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
         * �༭Grid
         */
        /**
         * ��ʼ���༭�����ڻ�ȡbindName��ִ��
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
                        //���ñ༭����
                        uiType = optEditTypeI.uitype;
                        uiType = uiType.charAt(0).toLowerCase() + uiType.slice(1);
                        optEditTypeI.uitype = uiType;
                        editType[bindNameI] = optEditTypeI;
                        /**
                         * Pulldown��Ҫ��Ⱦlabel
                         * �����ﶨ����Ⱦ����
                         * ��#2184 ��#2177��#1156
                         * @type {Array}
                         */
                        if (dictType.test(uiType)) { //pullDownType ��#13
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
                        //�ɱ༭�в��ܱ��̶�
                        if (fixcolumnnumber === undefined) {
                            fixcolumnnumber = i;
                        }
                    } else if (typeof optEditTypeI.create === "function" && typeof optEditTypeI.returnValue === "function") {
                        //�������༭����
                        editType[bindNameI] = optEditTypeI;
                        delete optEditTypeI.uitype;
                        //�ɱ༭�в��ܱ��̶�
                        if (fixcolumnnumber === undefined) {
                            fixcolumnnumber = i;
                        }
                    }
                }
            }
            //�ɱ༭�в��ܱ��̶�
            if (fixcolumnnumber !== undefined && opts.fixcolumnnumber >= fixcolumnnumber ) {
                opts.fixcolumnnumber = fixcolumnnumber;
            }
        },
        /**
         * ����һ����Ԫ��,���ڱ༭
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
                //���ñ༭����
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
                //�������༭����
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
         * �༭��ɣ�����һ����Ԫ��
         * ��ֵhtml()��td
         * ʵ������
         * ���±༭״̬
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
                newRowData = this.data[editObj.index],//�����޸ĺ�����ݶ���
                rowData = $.extend({}, newRowData),//ԭʼ���ݶ���
                editafter, afterRowData, pk, pkValue,
                i, dataBackup, dataBackupI, isChange;
			if (cuiObj) {
				//���ô�������
				value = "checkboxGroup" === uitype ? cuiObj.getValueString(";") : cuiObj.getValue();
                //��������
                newRowData[bindNameI] = value;
				if (dictType.test(uitype)) {
					//���ΪpullDown������Ҫ��valueת����label
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
                //��������
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
                //δ�ı䣬��������ݲ���Ҫִ��
                return;
            }
            //��֤��������������ݲ�ִ��
            if (validate && !this._validate(bindNameI, newRowData, validate, editTdObj)) {
                return;
            }
            pk = this.options.primarykey;
            pkValue = rowData[pk];
            //��������,��Ҫ����ԭ����
            dataBackup = this.dataBackup;
            if (pkValue !== undefined && !dataBackup[pkValue]) {
                //��һ���޸����ݣ��Ž��б���
                dataBackup[pkValue] = rowData;
            }

            //�༭����
            editafter = this.options.editafter;
            if (typeof editafter === "function") {
                afterRowData = editafter($.extend({}, newRowData), bindNameI);
                if ($.type(afterRowData) === "object") {
                    newRowData = afterRowData;
                    //��ֹpk���ġ�
                    if (pkValue === undefined) {
                        delete newRowData[pk];
                    } else {
                        newRowData[pk] = pkValue;
                    }
                    this._changeValue(newRowData,
                        newRowData[pk] !== undefined ? undefined : editObj.index, bindNameI);
                }
            }

            // �жϵ�ǰ���Ƿ��Ѿ����޸ġ�
            if (pkValue === undefined) {
                //�������б��༭
                this.changeEditData.insertData[rowData.__insertId__] = newRowData;
            } else {
                //���������б��༭
                dataBackupI = dataBackup[pkValue];
                tds = editTdObj.closest("tr").find("td");
                for (i = this.colSize; i--;) {
                    bindNameP = bindName[i];
                    if (dataBackupI[bindNameP] !== newRowData[bindNameP]) {
                        //�仯
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
         * ��֤,������֤״̬���µ� validateState
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
            //��֤ͨ��
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
         * ����һ������
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
            //��ֹ�����������溬�����������³�ͻ
            //delete rowData[this.options.primarykey];
            rowData.__insertId__ = insertId + "";

            if(typeof position !== "number" || position >= rowSize || position < 0) {
                position = rowSize;
            }
            this._addData(rowData, position);
            //��������������ʽ
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
            //���������ݶ�Ԥ�����ʱ�����������ݱ���Ϊ����
            if (!hasNullValue) {
                this.changeEditData.insertData[insertId] = rowData;
            }
        },
        /**
         * �Ƿ��ǿն���,������Ƿ��ص�һ��
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
         * ɾ��������
         * @param pk
         */
        deleteRow: function (pk/*pks*/) {
            this.deleteRowByIndex(this._pkToIndex(pk, false));
        },
        /**
         * ��������ɾ����
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
         * ɾ��ѡ����
         */
        deleteSelectRow: function () {
            this.deleteRowByIndex(this.getSelectedIndex());
        },
        /**
         * ��ȡ�����е�index
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
         * ��ȡ��ɾ������
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
            //ƴ��insert
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
            //ƴ��update
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
            //ƴ��delete,��
            return {
                "insertData": newInsert, //array
                "updateData": newUpdate, //array
                "deleteData": newDelete  //array
            };
        },
        /**
         * �ύ����
         * @returns {*}
         */
        submit: function () {
            if (this.editObj) {
                this._destroyFormEle();
            }
            var changeData = this.getChangeData(),
                vInsert, vUpdate, bindName, i, colSize,
                theadText, _isNullObj, vilidateResult, index, vBindName;
            //�ж��Ƿ�ȫ����֤ͨ��
                vInsert = this.validateState.insert;
                vUpdate = this.validateState.update;
                bindName = this.bindName;
                theadText = this.theadText;
                _isNullObj = this._isNullObj;
                vilidateResult = _isNullObj(vInsert);
                index = -1;
            if (vilidateResult !== undefined) {
                index = this._insertIdToIndex(vilidateResult[0]);
                //�����У�������֤����
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
                            ["��\"", index + 1, "\"�У�\"", theadText[i], "\" ���д���", vBindName[1]].join(""),
                            null,
                            {title: "�����ύ", opacity:0.8}
                        );
                        return "ban";
                    }
                }
            }
            //û�иı�,����false;
            if (!this.isChanged) {
                return "notChange";
            }

            this.isSaveing = true;
            this._loading("show");
            this.options.submitdata(this, changeData);
            return "success";
        },
        /**
         * ͨ������ID��ȡindex
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
         * �ύ���
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
     * �ɱ༭Grid��ѡ��������Ⱦ����
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
     * ��ѡ������Ⱦ����
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
     * ��ѡ��Ⱦ����
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
     * ��ѡ��Ⱦ����
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