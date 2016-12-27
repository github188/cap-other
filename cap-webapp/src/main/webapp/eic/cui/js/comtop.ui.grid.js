/**
 * ??grid
 * @author ???
 * @since 2013-6-31
 */
(function (C) {
    'use strict';
    var $ = C.cQuery,
        fiexNumber = C.Tools.fixedNumber;
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
            titlelock             : true,
            oddevenrow            : false,
            oddevenclass          : "cardinal_row",
            selectedrowclass      : "selected_row",
            selectrows            : "multi",
            checkboxname          : "idList",
            allboxname            : "allbox",
            fixcolumnnumber       : 0,
            datasource            : null,
            titlerender           : null,
            colhidden             : true,
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
            loadcomplate_callback : null,//¶ƒ???
            selectall_callback    : null,
            rowdblclick_callback  : null,
            onstatuschange        : null
        },
        //????? money, date
        format_fn: {
            "date": C.Date.simpleformat,
            "money": C.Number.money
        },
        //?????
        render_method: {
            "a": function (row_data, options, value) {
                var html = ["<a"];
                var params = options.params;
                var search = "";
                if (params) {
                    params = params.split(";");
                    var arr = [];
                    for (var i = params.length; i--;) {
                        var params_i = params[i];
                        if (row_data.hasOwnProperty(params_i)) {
                            arr.push([params_i, "=", row_data[params_i]].join(""));
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
            "image": function (row_data, options, value) {
                var html = ["<img"];
                html.push(" class='", options.className || "");
                var url      = options.url,
                    compare  = options.compare,
                    relation = options.relation,
                    title    = options.title,
                    t        = value;
                if (typeof relation === "string") {
                    if (/\./.test(relation)) {
                        var arr_relation = relation.split(".");
                        t = row_data[arr_relation[0]][arr_relation[1]];
                    } else {
                        t = row_data[relation];
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
            "button": function (row_data, options, value) {
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
         * ??????????????
         */
        _init: function () {
            var datasource = this.options.datasource;
            if (typeof datasource === "string" && typeof window[datasource] === "function") {
                this.options.datasource = window[datasource];
            }
            //???sort????,??????????sort????.
            var opts             = this.options;
            var sortstyle        = opts.sortstyle;
            opts.sortname.length = Math.min(opts.sortname.length, sortstyle);
            opts.sorttype.length = Math.min(opts.sorttype.length, sortstyle);
            //???®Æ??????
            this.el                = opts.el;
            this.el_cache          = null; //dom?õ‘??ó®???IE??table???
            this.grid_container    = null;
            this.grid_box          = null;
            this.grid_style        = null;
            this.grid_head         = null;
            this.grid_head_table   = null;
            this.grid_table_hide   = null;
            this.grid_body         = null;
            this.grid_table_box    = null;
            this.grid_tbody        = null;
            this.grid_scroll       = null;
            this.grid_line         = null;
            this.grid_empty        = null;
            this.grid_tfoot        = null;
            this.loading           = null;
            this.grid_overlay      = null;
            this.grid_all_check    = null;
            this.create_dom_box    = document.createElement("div");
            //????
            this.dom_th            = [];
            this.dom_tr            = [];
            this.dom_td            = [];
            this.dom_fixed         = [];
            this.dom_head_col      = [];
            this.dom_body_col      = [];
            this.thead_map         = [];
            this.tr_frag           = document.createElement("tbody");
            //???
            this.data              = [];
            this.backup_query      = null;
            this.query             = null;
            this.custom_query      = null;
            //????
            this.row_size          = 0;
            this.col_size          = 0;
            //????
            this.sort_type         = {};
            this.thead_text        = [];
            this.render_style      = [];
            this.col_render        = [];
            this.bind_name         = []; // -1 ??????; 0,1 ???; "" ??ß—?; "string" ????
            this.num_col           = NaN;
            this.bind_dot_name     = [];
            this.col_width         = [];
            this.init_col_width    = [];
            this.col_width_backup  = [];
            this.multi_checked     = [];
            this.multi_checked_num = 0;
            this.single_checked    = NaN;
            this.fixed_fn_click    = [];
            this.col_hidden        = [];
            this.total_size        = 0;
            this.guid              = "grid_" + C.guid();
            this.height_light      = [];
            this.col_index         = [];
            //???
            this.grid_width        = 0;
            this.grid_height       = 0;
            this.table_width       = 0;
            this.thead_height      = 31;
            this.box_height        = 0;
            this.pagination_height = opts.pagination ? 40 : 0;
            //html???
            this.selectrows_html   = "";
            this.tds_package       = [];
            //??????????
            this.end_row           = 0;
            this.tr_start          = 0;
            this.tr_end            = 0;
            //?ßÿ???
            this.render_complete   = false;
            this.odd               = false;
            this.un_render         = true;
            this.auto_height       = false;
            this.is_ittab          = false;
            this.arr_index         = Array.prototype.indexOf;
            this.is_qm             = C.Browser.isQM;
            this.persistence       = typeof opts.onstatuschange === "function";
            //?ßÿ?????ß’??style???
            try {
                var head = $("head");
                head.append("<style type='text/css'></style>");
                head.find("style").last()[0].innerHTML = "";//???style??????ß“???
                this.write_style = true;
            } catch (e) {
                this.write_style = false;
            }
            //????query
            this._backupQuery();
            //?????pagesize
            this._setPageSize();
            //??????????
            this._setSortTypeObj();
            //??????dom
            this.__getDomTh();
            //???????????
            this.__initWidthAndHeight();

        },
        /**
         * ??????????
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
            this.backup_query = $.extend(true, {}, query);
            this.query = query;
        },
        /**
         * ????pagesize
         * @private
         */
        _setPageSize: function () {
            var opts          = this.options,
                query         = this.query,
                pagesize_list = opts.pagesize_list,
                page_size     = query.pageSize;
            for (var i = pagesize_list.length; i--;) {
                if (page_size === pagesize_list[i]) {
                    return;
                }
            }
            query.pageSize = pagesize_list[1];
        },
        /**
         * ?????????????sort_type????
         * @private
         */
        _setSortTypeObj: function () {
            var query     = this.query,
                sortname  = query.sortName,
                sorttype  = query.sortType,
                len       = sortname.length,
                sort_type = this.sort_type = {};
            for (var i = 0; i < len; i += 1) {
                var sorttype_i = sorttype[i].toUpperCase();
                sorttype[i] = sorttype_i;
                sort_type[sortname[i]] = sorttype_i;
            }
        },
        /**
         * ??????th,?????????map
         * @private
         */
        __getDomTh: function () {
            var el = this.el,
                el_chache,
                tr,
                tr_len,
                col_index = this.col_index;
            el_chache = $(document.createElement("div")).html([
                '<table><thead>',
                el.find("thead").html() || el.find("tbody").html() || el.html(),
                '</thead></table>'
            ].join("")).find("table").eq(0);
            //???????????tr
            this.el_cache = el_chache;
            tr = el_chache.find("tr");
            tr_len = tr.length;
            if (tr_len === 1) {//???????
                var ths = el_chache[0].getElementsByTagName("th"),
                    dom_th = [];
                for (var g = 0, h = ths.length; g < h; g += 1) {
                    dom_th.push(ths[g]);
                    col_index[g] = g;
                }
                this.dom_th = dom_th;
            } else {//???????
                var thead_map = this.thead_map = [],
                    i, j, l;
                //colSpan?ùI
                for (i = 0; i < tr_len; i += 1) {//????
                    var tr_i = tr.eq(i)[0],
                        th_i = tr_i.cells,
                        len_th_i = th_i.length,
                        all_cell_span = 0;
                    if (!thead_map[i]) {
                        thead_map[i] = [];
                    }
                    for (j = 0; j < len_th_i; j += 1) {//????
                        var th_i_j = th_i[j],
                            cell_span = th_i_j.colSpan;
                        for (l = 0; l < cell_span; l += 1) {//cell_span
                            thead_map[i][all_cell_span + l] = th_i_j;
                        }
                        all_cell_span += cell_span;
                    }
                    var empty_th = document.createElement("th");
                    empty_th.className = "grid_empty_th";
                    tr_i.insertBefore(empty_th, th_i[0]);
                }
                //rowSpan?ùI
                for (i = 0; i < tr_len; i += 1) {//????
                    var map_i = thead_map[i],
                        len_map_i = map_i.length;
                    for (j = 0; j < len_map_i; j += 1) {//????
                        var map_i_j = map_i[j],
                            row_span = map_i_j.rowSpan;
                        for (l = i + 1; l < row_span; l += 1) {//cell_span
                            if (thead_map[l][j] !== map_i_j) {
                                thead_map[l].splice(j, 0, map_i_j);
                            }
                        }
                    }
                }
                this.dom_th = $.extend([], thead_map[tr_len - 1]);
            }
            this.col_size = this.dom_th.length;
        },

        /**
         * ??????????
         * @private
         */
        __initWidthAndHeight: function () {
            var opts        = this.options,
            //???????
                rewidth     = typeof opts.resizewidth === "function" ? opts.resizewidth() : undefined,
                reheight    = typeof opts.resizeheight === "function" ? opts.resizeheight() : undefined,
                gridwidth = opts.gridwidth = fiexNumber(opts.gridwidth),
                gridheight = opts.gridheight = fiexNumber(opts.gridheight);
            this.grid_width = ( rewidth || gridwidth) - 2;
            if (gridheight === "auto") {
                gridheight       = 500;
                this.auto_height = true;
            }
            this.grid_height  = ( reheight || gridheight ) - 2;
            //table????
            this.thead_height = this.el_cache.find("tr").length * 31;
            this.box_height   = this.grid_height - this.pagination_height - (opts.titlelock ? this.thead_height : 0);
            this.table_width  = opts.adaptive ? this.grid_width - 17 : fiexNumber(opts.tablewidth);
        },

        /**
         * ???????dom
         * @private
         */
        _create: function () {
            //???????
            this.__createLayoutDom();
            //??????
            this.__theadClickEventBind();
            this.__theadMouseEventBind();
            this.__tbodyClickEventBind();
            this.__tbodyMouseEventBind();
            //???
            this.__imitateScroll();
            this._resizeEventBind();
            this.__boxScrollEventBind();
            //???®Æ????????
            this._setStyleWidth();
            this._setStyleHeight();
            //?????ß‘???????????????
            this._loading("show");
            if (!this.persistence) {
                this._createPropertys();
                this._createContent();
            }
            var opts = this.options;
            //???????
            if (typeof opts.datasource === "function") {
                opts.datasource(this, this.getQuery());
            }
        },
        /**
         * ??????? div
         * @private
         */
        __createLayoutDom: function () {
            var opts            = this.options,
                el              = this.el,
            //???dom
                container       = document.createElement("div");
            container.className = "grid_container";
            var titlelock       = opts.titlelock,
                html = [
                    '<div class="grid_style"></div>',
                    '<div class="grid_box">'
                ];
            if (titlelock === true) {
                html.push(
                    '<div class="grid_head">',
                    '<table class="grid_head_table"></table>',
                    '</div>',
                    '<div class="grid_body">'
                );
            } else {
                html.push(
                    '<div class="grid_body">',
                    '<div class="grid_head">',
                    '<table class="grid_head_table"></table>',
                    '</div>'
                );
            }
            html.push(
                '<div class="grid_empty">?? ?? ?? ?? ?? ?? ?</div>',
                '<div class="grid_table_box"><div class="grid_table_hide"></div></div>',
                '</div>',
                '<div class="grid_scroll">',
                    '<div></div>',
                '</div>',
                '<div class="grid_line"></div>',
                '<div class="grid_overlay"></div>',
                '</div>',
                '<div class="grid_tfoot"></div>'
            );
            if (opts.loadtip) { //loading
                html.push("<div class='grid_loading_bg grid_loading_bg_over'></div><div class='grid_loading_box'><span>???????...</span></div>");
            }
            container.innerHTML = html.join("");
            el[0].parentNode.insertBefore(container, el[0]);
            //????jq????
            var grid_container   = this.grid_container = $(container).addClass(this.guid);
            if (this.is_qm) {
                grid_container.addClass("grid_container_qm");
            }
            this.grid_table_box  = $(".grid_table_box", grid_container);
            var grid_box         = this.grid_box = grid_container.children(".grid_box");
            this.grid_style      = grid_container.find(".grid_style").eq(0);
            this.grid_head       = grid_box.find(".grid_head").eq(0);
            this.grid_body       = grid_box.children(".grid_body").eq(0);
            this.grid_overlay    = grid_box.children(".grid_overlay").eq(0);
            this.grid_head_table = this.grid_head.children(".grid_head_table").eq(0);
            this.grid_line       = grid_box.children(".grid_line").eq(0);
            this.grid_scroll     = grid_box.children(".grid_scroll").eq(0);
            this.grid_tfoot      = grid_container.children(".grid_tfoot").eq(0);
            this.grid_empty      = this.grid_body.children(".grid_empty").eq(0);
            this.loading         = grid_container.children(".grid_loading_bg").next().andSelf();
            //????dom????
            this.grid_table_hide = $(".grid_table_hide", grid_container).eq(0).append(el.addClass("grid_body_table"));
            if (opts.ellipsis) { //????????
                el.addClass("grid_ellipsis");
            }
            if (opts.titleellipsis) {//????????
                this.grid_head_table.addClass("grid_ellipsis");
            }
        },
        /**
         * ?????????
         * @private
         */
        __theadClickEventBind: function () {
            var opts      = this.options,
                bind_name = this.bind_name,
                self      = this;
            this.grid_head_table.on("click", function (event) {
                event.stopPropagation();
                var target = event.target;
                var class_name = target.className;
                if (class_name === "grid_select" || class_name === "grid_ittab") {
                    return;//???? ??????? ?????? ????
                }
                //??
                if (class_name === "grid_all_check") {
                    var dom_tr           = self.dom_tr,
                        multi_checked    = self.multi_checked,
                        selectedrowclass = opts.selectedrowclass,
                        end_row          = self.end_row,
                        row_size         = self.row_size;
                    if (!$(target).prop("checked")) {
                        for (var j = end_row; j--;) {
                            multi_checked[j] = false;
                            $(dom_tr[j]).removeClass(selectedrowclass).find("input").eq(0).prop("checked", false);
                        }
                        for (var m = end_row; m < row_size; m += 1) {
                            multi_checked[m] = false;
                        }
                        self.multi_checked_num = 0;
                    } else {
                        for (var k = end_row; k--;) {
                            multi_checked[k] = true;
                            $(dom_tr[k]).addClass(selectedrowclass).find("input").eq(0).prop("checked", true);
                        }
                        for (var n = end_row; n < row_size; n += 1) {
                            multi_checked[n] = true;
                        }
                        self.multi_checked_num = self.row_size;
                    }
                    var selectall_callback = opts.selectall_callback;
                    if (typeof selectall_callback === "function") {
                        var checked = $(target).prop("checked");
                        selectall_callback.call(self, checked ? self.data : [], checked);
                    }
                    return;
                }
                //????
                var grid_sort = $(target).parents(".grid_sort");
                if (grid_sort.length && class_name === "grid_thead_text") {
                    var sort_type       = self.sort_type,
                        bind_name_i     = bind_name[self._thIndex(grid_sort[0])],
                        sort_type_i     = sort_type[bind_name_i],// || "ASC",
                        new_sort_type_i = sort_type_i !== "DESC" ? "DESC" : "ASC";
                    //grid_sort.removeClass("grid_sort_" + sort_type_i.toLowerCase())
                        //.addClass("grid_sort_" + new_sort_type_i.toLowerCase());
                    self._setOptsSortNameAndSoryType(bind_name_i, new_sort_type_i);
                    //????????
                    if (self.persistence) {
                        self._triggerStatusChange();
                    }
                    self.loadData();
                }
            });
        },
        /**
         * ???????ß÷?????,??????????????????
         * @param th_dom
         * @returns {*}
         * @private
         */
        _thIndex: function (th_dom) {
            var dom_th = this.dom_th,
                arr_index = this.arr_index;
            if(arr_index) {
                return arr_index.call(dom_th, th_dom);
            }
            //IE
            for (var i = this.col_size; i--;) {
                if (dom_th[i] === th_dom) {
                    return i;
                }
            }
            return -1;
        },
        /**
         * ????this.query??sortname??sorttype
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
         * th???over,out???
         * @private
         */
        __theadMouseEventBind: function () {
            this.grid_head_table.on("mouseover",function (event) {
                var target       = $(event.target);
                var grid_fixed_s = target.closest(".grid_fixed_s").eq(0);
                if (grid_fixed_s.length) {
                    grid_fixed_s.parents("th").addClass("grid_thead_mouseover");
                }
            }).on("mouseout", function (event) {
                    var target = $(event.target);
                    var grid_fixed_s = target.closest(".grid_fixed_s").eq(0);
                    if (grid_fixed_s.length) {
                        grid_fixed_s.parents("th").removeClass("grid_thead_mouseover");
                    }
                });
        },
        /**
         * ??????????
         * @private
         */
        __tbodyClickEventBind: function () {
            var opts                 = this.options,
                rowdblclick_callback = typeof opts.rowdblclick_callback === "function" ? opts.rowdblclick_callback : null,
                selectrows           = opts.selectrows,
                self                 = this,
                timeout              = null,
                target               = null,
                checkboxname         = opts.checkboxname,
                tag_name;
            self.el.on("click", function (event) {
                event.stopPropagation();
                target = event.target;
                tag_name = target.tagName;
                if (tag_name === "TBODY" || tag_name === "TABLE") {
                    return;
                }
                var tr = $(target).closest("tr").eq(0);
                var tr_index = tr.attr("index") || tr[0].rowIndex - 1 + self.tr_start;
                //???a,button,img??????????
                var clickid = target.getAttribute("clickid") || "";
                var reg_exp = new RegExp(tag_name, "i");
                if (reg_exp.test("a;button;img")) {
                    if (clickid !== "") {
                        self.fixed_fn_click[clickid](self.data[tr_index], tr_index);
                    }
                    return;
                }
                if (reg_exp.test("input") && $(target).attr("name") !== checkboxname) {
                    return;
                }
                if (rowdblclick_callback) {
                    clearTimeout(timeout);
                    timeout = setTimeout(function () {
                        clickCallback(tr_index);
                    }, 300);
                } else {
                    clickCallback(tr_index);
                }
            });
            self.el.on("dblclick", function (event) {
                event.stopPropagation();
                if (rowdblclick_callback) {
                    clearTimeout(timeout);
                    target   = event.target;
                    tag_name = target.tagName;
                    if (tag_name === "TBODY" || tag_name === "TABLE") {
                        return;
                    }
                    var tr       = $(target).closest("tr").eq(0);
                    var tr_index = tr.attr("index") - 0;
                    rowdblclick_callback.call(self, self.data[tr_index], tr_index);
                }
            });
            function clickCallback(tr_index) {
                //?????????
                if (selectrows === "no") {
                    return;
                }
                //?????
                self._selectRows(tr_index, undefined);
                //????ß›??
                if (typeof opts.rowclick_callback === "function") {
                    var flag = false;
                    if (selectrows === "multi") {
                        flag = self.multi_checked[tr_index];
                    }
                    if (selectrows === "single") {
                        flag = tr_index === self.single_checked;
                    }
                    opts.rowclick_callback.call(self, self.data[tr_index], flag, tr_index);
                }
            }
        },
        /**
         * ?????
         * @param index
         * @param flag
         * @private
         */
        _selectRows: function (index, flag) {
            var dom_tr           = this.dom_tr,
                dom_tr_index     = dom_tr[index],
                opts             = this.options,
                selectrows       = opts.selectrows,
                selectedrowclass = opts.selectedrowclass,
                tr               = $(dom_tr_index);
            if (selectrows === "multi") {
                var multi_checked = this.multi_checked;
                var multi_checked_index = multi_checked[index];
                if (flag === undefined) {
                    flag = multi_checked_index !== true;
                } else if (flag === multi_checked_index) {
                    return;
                }
                multi_checked[index] = flag;
                if (!dom_tr_index) {
                    return;
                }
                if (flag === false) {
                    tr.removeClass(selectedrowclass).children("td").find("input").prop("checked", false);
                    this.multi_checked_num--;
                    this.grid_all_check.prop("checked", false);
                } else {
                    tr.addClass(selectedrowclass).children("td").find("input").prop("checked", true);
                    this.multi_checked_num += 1;
                    if (this.multi_checked_num === this.row_size) {
                        this.grid_all_check.prop("checked", true);
                    }
                }
            } else if (selectrows === "single") {
                var single_checked = this.single_checked;
                this.single_checked = single_checked === index && flag === false ? NaN : index;
                if (!dom_tr_index) {
                    return;
                }
                if (flag === false) {
                    tr.removeClass(selectedrowclass).children("td").eq(0).find("input").prop("checked", false);
                } else {
                    if (!isNaN(single_checked)) {
                        $(dom_tr[ single_checked ]).removeClass(selectedrowclass);
                    }
                    tr.addClass(selectedrowclass).children("td").eq(0).find("input").prop("checked", true);
                }
            }
        },
        /**
         * title???
         * @private
         */
        __tbodyMouseEventBind: function () {
            var self            = this,
                bind_name       = this.bind_name,
                titlerender     = this.options.titlerender,
                tr, title;
            self.el.on("mouseover", function (event) {
                var target   = event.target,
                    tag_name = target.tagName;
                if (tag_name === "TR" || tag_name === "TBODY" || tag_name === "TABLE") {
                    return;
                }
                var td           = $(target).closest("td");
                //???IE8???mouseover??event.target?????????
                if(!td.length){
                    return;
                }
                var td_index     = td[0].cellIndex,
                    grid_fixed_s = td.find(".grid_fixed_s"),
                    content_box  = grid_fixed_s.length ? grid_fixed_s : td,
                    bind_name_i  = bind_name[td_index],
                    tr_index;
                if (tr) {
                    tr.removeClass("grid_tr_over");
                }
                tr               = td.closest("tr");
                tr_index         = tr.attr("index");
                if (!tr_index) {
                    tr_index = tr[0].rowIndex - 1 + self.tr_start;
                    tr.attr("index", tr_index);
                }
                tr.addClass("grid_tr_over");
                if (typeof bind_name_i !== "number" && !td.attr("title")) {
                    if (typeof titlerender === "function") {
                        title = titlerender(self.data[tr_index], bind_name_i);
                        if (title) {
                            td.attr("title", title);
                        } else {
                            title = content_box.html().replace(/<.*?>|\s+/g, "");
                            if (title) {
                                td.attr("title", title);
                            }
                        }

                    } else {
                        title = content_box.html().replace(/<.*?>|\s+/g, "");
                        if (title) {
                            td.attr("title", title);
                        }
                    }
                }
            });
        },
        /**
         * ????????
         * @private
         */
        __imitateScroll: function () {
            var self            = this,
                guid            = self.guid,
                grid_head_table = this.grid_head_table[0],
                grid_style      = this.grid_style[0],
                el              = this.el[0],
                left;
            var fixcolumnnumber = this.options.fixcolumnnumber;
            if (this.write_style) {
                this.grid_scroll.on("scroll", function () {
                    left = this.scrollLeft;
                    grid_style.innerHTML = [
                        '<style type="text/css">.',
                        guid,
                        ' .grid_fixed .grid_fixed_s{left:',
                        left,
                        'px}.',
                        guid,
                        ' .grid_body_table, .',
                        guid,
                        ' .grid_head_table{margin-left:-',
                        left,
                        'px}</style>'
                    ].join("");
                });
            } else {
                this.grid_scroll.on("scroll", function () {
                    left = this.scrollLeft + "px";
                    var margin_left = "-" + left;
                    grid_head_table.style.marginLeft = margin_left;
                    el.style.marginLeft = margin_left;
                    var dom_fixed = self.dom_fixed;
                    for (var i = dom_fixed.length; i--;) {
                        var dom_fixed_i = dom_fixed[i];
                        for (var j = fixcolumnnumber; j--;) {
                            dom_fixed_i[j].style.left = left;
                        }
                    }
                    var tds_package = self.tds_package;
                    for (var k = 0; k < fixcolumnnumber; k += 1) {
                        tds_package[k].html = tds_package[k].html.replace(/(style="left:)\d*?px/, "$1" + left);
                    }
                });
            }
        },
        /**
         * resize???
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
         * ???????????
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
         * ????????????
         * @private
         */
        __boxScrollEventBind: function () {
            var self = this;
            this.grid_body.on("scroll", function () {
                self._lazyload(true);
            });
        },
        /**
         * ??????
         * @private
         */
        _lazyload: function (timeout) {
            var self = this,
                opts = this.options,
                scroll_top = this.grid_body[0].scrollTop,
                old_end_row = self.end_row,
                new_start_row = parseInt(scroll_top / 27, 10),
                new_end_row = parseInt(this.box_height / 27, 10) + new_start_row + 20 + 1;
            if (opts.ellipsis) {
                clearTimeout(this.render_timeout);
                if (timeout) {
                    this.render_timeout = setTimeout(function () {
                        self._clearAndLoad(new_start_row - 20, old_end_row, new_end_row);
                    }, 10);
                } else {
                    self._clearAndLoad(new_start_row - 20, old_end_row, new_end_row);
                }
            } else {
                if (!this.render_complete && this.append_rows_complete && new_end_row > old_end_row) {
                    clearTimeout(this.render_timeout);
                    if (timeout) {
                        this.render_timeout = setTimeout(function () {
                            self.append_rows_complete = false;
                            self._appendRows(old_end_row, new_end_row);
                        }, 10);
                    } else {
                        self.append_rows_complete = false;
                        self._appendRows(old_end_row, new_end_row);
                    }
                }
            }
        },
        /**
         * ??????,???????????
         */
        _clearAndLoad: function (new_tr_start, old_end_row, new_tr_end) {
            var row_size = this.row_size,
                dom_tr,
                grid_tbody = this.grid_tbody[0],
                grid_table_box_css = this.grid_table_box[0].style,
                tr_frag = this.tr_frag,
                tr_start = this.tr_start,
                tr_end = this.tr_end;
            new_tr_end = this.tr_end = Math.min(row_size, new_tr_end);
            new_tr_start = this.tr_start = Math.max(new_tr_start, 0);
            var i, j, k, l;
            //?????dom
            if (new_tr_end > old_end_row) {
                var dom        = this._dataToDom(this.data, old_end_row, new_tr_end);
                var tr = dom.dom_tr;
                this.dom_tr    = this.dom_tr.concat(tr);
                this.dom_td    = this.dom_td.concat(dom.dom_td);
                this.dom_fixed = this.dom_fixed.concat(dom.dom_fixed);
                this.end_row   = new_tr_end;
                for ( l = tr.length; l --;) {
                    tr_frag.appendChild(tr[l]);
                }
            }
            dom_tr = this.dom_tr;
            if(new_tr_start > tr_start || new_tr_end > tr_end) { //???????????
                //top???
                for (i = tr_start, j = Math.min(tr_end, new_tr_start); i < j; i ++) {
                    tr_frag.appendChild(dom_tr[i]);
                }
                //bottom???
                for (k = Math.max(new_tr_start, tr_end); k < new_tr_end; k ++) {
                    grid_tbody.appendChild(dom_tr[k]);
                }
            } else if (new_tr_start < tr_start){
                //top????
                var first_row = dom_tr[tr_start];
                for (i = new_tr_start, j = Math.min(tr_start, new_tr_end); i < j; i ++ ) {
                    grid_tbody.insertBefore(dom_tr[i], first_row);
                }
                //bottom???
                for (k = Math.max(tr_start, new_tr_end); k < tr_end; k ++) {
                    tr_frag.appendChild(dom_tr[k]);
                }
            }
            grid_table_box_css.paddingTop = new_tr_start * 27 + "px";
            grid_table_box_css.paddingBottom = ( row_size - new_tr_end) * 27 + "px";
        },
        /**
         * ?????????????.
         * @private
         */
        _setStyleWidth: function () {
            this.grid_container.css("width", this.grid_width);
            this.el.css("width", this.table_width);
            this.grid_head_table.css("width", this.table_width);
        },
        /**
         * ?????????????.
         * @private
         */
        _setStyleHeight: function () {
            this.grid_container.css("height", this.grid_height);
            this.grid_head.css("height", this.thead_height);
            this.grid_body.css("height", this.box_height);
        },
        /**
         * ??????...
         * @param status "show", "hide"
         */
        _loading: function (status) {
            if (!this.options.loadtip) {
                return;
            }
            this.loading[status]().eq(0).css("height", this.grid_height);
            if (this.un_render && status === "hide") {
                this.grid_container.find(".grid_loading_bg").removeClass("grid_loading_bg_over");
            }
        },
        /**
         * ??????????
         * @private
         */
        _createPropertys : function () {
            //???????ß÷?????
            this.__getTagsPropertys();
            //????????ß·??
            this.__initColWidth();
        },
        /**
         * ?????????
         * @private
         */
        _createContent: function () {
            //???head??body
            this.__renderHead();
            this.__renderBody();
            //?????ß·?
            this._setColWidthStyle();
            //tbody??????????
            this.__packageTds();
            //?????????
            this._colHidden(true);
            //???????,????ß·????????
            this.ittab._init(this);
            var opts = this.options;
            if (opts.colhidden) {
                this.hideCol._init(this);
            }
            if (opts.colmove && this.thead_map.length === 0) {
                this.moveCol._init(this);
            }
        },
        /**
         * ???????ß÷???????.
         */
        __getTagsPropertys: function () {
            var dom_th         = this.dom_th,
                opts           = this.options,
                bind_dot_name  = this.bind_dot_name,
                col_size       = this.col_size,

                render_style   = this.render_style,
                bind_name      = this.bind_name,
                sort           = this.sort = [],
                thead_text     = this.thead_text,
                col_width      = this.col_width,
                col_render     = this.col_render,
                fixed_fn_click = this.fixed_fn_click;
            //?????ß·???
            for (var i = 0; i < col_size; i += 1) {
                //????col_index
                var th_i = dom_th[i];
                col_width.push(th_i.style.width || th_i.getAttribute("width") || "");
                //??????????
                this.col_hidden[i] = th_i.getAttribute("hide") === "true" || $(th_i).css("display") === "none";
                //???????????
                var render_style_attr_i = th_i.getAttribute("renderStyle") || "";
                var render_style_i = render_style_attr_i
                    .replace(/padding.+?(;|$)/, "")
                    .replace(/display\s*?:\s*?none\s*?(;|$)/, "") + ";";
                render_style.push(render_style_i);
                //???bind_name
                var bind_name_i = th_i.getAttribute("bindName") || "";
                bind_name[i] = bind_name_i;
                if (/\./.test(bind_name_i)) {
                    bind_dot_name[i] = bind_name_i.split(".");
                } else {
                    bind_dot_name[i] = undefined;
                }
                if (isNaN(this.num_col) && bind_name_i.length && !isNaN(bind_name_i - 0)) {//?????
                    this.num_col = i;
                    bind_name[i] = bind_name_i - 0;
                    bind_name_i = "";
                }
                //sort
                if (bind_name_i === "") {
                    sort[i] = false;
                } else {
                    sort[i] = th_i.getAttribute("sort") === "true" || false;
                }
                //???????
                thead_text.push(th_i.innerHTML);
                //???????. ????? format < colRender < render  ???render??????????;
                var format    = th_i.getAttribute("format"),
                    colrender = opts.colrender,
                    render    = th_i.getAttribute("render");
                col_render[i] = [];
                //format
                if (format !== null) {
                    if (/money/.test(format)) {
                        col_render[i][1] = {
                            "format": Number(format.split("-")[1] || 2),
                            "callback": this.format_fn.money
                        };
                    } else if (/(dd|MM|yy)/i.test(format)) {
                        col_render[i][1] = {
                            "format": format,
                            "callback": this.format_fn.date
                        };
                    }
                }
                //?????????????
                if (typeof colrender === "function") {
                    col_render[i][0] = {
                        "render": "colrender_fn",
                        "callback": colrender
                    };
                }
                //???ß€?????
                if (typeof render === "string") {
                    if (new RegExp(render).test("a;button;image")) {
                        var options = th_i.getAttribute("options");
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
                                options.click = fixed_fn_click.push(click) - 1;
                            } else {
                                options.click = "";
                            }
                            col_render[i][0] = {
                                "render" : "fiexd_fn",
                                "method" : render,
                                "options": options
                            };
                        }
                    } else {
                        var render_fn = window[render];
                        if (render_fn) {
                            var col_json = {
                                "format"     : format || undefined,
                                "render"     : render_fn,
                                "renderStyle": render_style_attr_i,
                                "text"       : thead_text[i]
                            };
                            col_render[i][0] = {
                                "render"  : "render_fn",
                                "col_json": col_json,
                                "callback": render_fn
                            };
                        }
                    }
                }
            }
            //????bind_name
            var selectrows = opts.selectrows;
            if (selectrows === "multi" || selectrows === "single") {
                bind_name[0] = -1;
            }
        },
        /**
         * ?????????ß÷????
         * @private
         */
        __initColWidth: function () {
            var grid_width  = this.grid_width,
                table_width = this.table_width || grid_width,
                col_width   = this.col_width,
                col_width_backup = this.col_width_backup,
                sum_width   = 0,
                seted_width = 0,
                col_size    = this.col_size,
                auto_col    = [];
            for (var i = this.col_size; i--;) {
                var col_width_i = col_width[i];
                col_width_backup[i] = -1;
                if (col_width_i === "") {
                    col_width_i  = 0;
                    col_width[i] = 200;
                    auto_col.push(i);
                } else if (/%/.test(col_width_i)) {
                    col_width_i  = Math.round(table_width * parseInt(col_width_i, 10) / 100);
                    col_width[i] = col_width_i;
                } else {
                    col_width_i  = parseInt(col_width_i, 10);
                    col_width[i] = col_width_i;
                }
                sum_width   += col_width[i];
                seted_width += col_width_i;
            }
            var auto_col_size   = auto_col.length;
            var remaining_width = table_width - seted_width;
            if (auto_col_size > 0 && remaining_width > auto_col_size) {
                var remaining_col_width = Math.round(remaining_width / auto_col_size);
                for (var m = 0; m < auto_col_size; m++) {
                    col_width[auto_col[m]] = remaining_col_width;
                }
                col_width[auto_col[m - 1]] += remaining_width - remaining_col_width * auto_col_size;
                this.table_width = table_width;
            } else {

                if (isNaN(this.table_width) && sum_width >= grid_width) {
                    this.table_width = sum_width;
                } else {//????
                    if (!this.table_width) {
                        this.table_width = grid_width;
                    }
                    var new_col_width = [];
                    var all_width = 0;
                    var last = 0;
                    for (var j = col_size; j--;) {
                        var width = Math.round(col_width[j] * table_width / sum_width);
                        all_width += width;
                        new_col_width[j] = width;
                        last = j;
                    }
                    new_col_width[last] += table_width - all_width;
                    this.col_width = new_col_width;
                }
            }
            this.init_col_width = $.extend([], this.col_width);
        },
        /**
         * ?????? ?????????dom
         * @private
         */
        __renderHead: function () {
            var opts            = this.options,
                dom_th          = this.dom_th,
                thead_map       = this.thead_map,
                thead_map_len   = this.thead_map.length,
                dom_head_col    = this.dom_head_col,
                dom_fixed_j     = this.dom_fixed[0] = [],
                thead_text      = this.thead_text,
                col_size        = this.col_size,
                fixcolumnnumber = opts.fixcolumnnumber,
                colhidden       = this.options.colhidden,
                sort            = this.sort,
                tr           = document.createElement("tr"),
                ellipsis     = opts.ellipsis;
            tr.className = "grid_width_norm";
            if (thead_map_len) {
                //?????th??empty_th?????ß“???????
                var empty_th = document.createElement("th");
                empty_th.className = "grid_empty_th";
                tr.appendChild(empty_th);
                //??????
                for (var k = thead_map_len - 1; k--;) {
                    var thead_map_k = thead_map[k];
                    for (var l = thead_map_k.length; l--;) {
                        var thead_map_k_l = thead_map_k[l];
                        thead_map_k_l.removeAttribute("width");
                        thead_map_k_l.style.width = "";
                    }
                }
            }
            for (var i = 0; i < col_size; i += 1) {
                //?????????dom
                var th = dom_head_col[i] = document.createElement("th");
                tr.appendChild(th);
                //???th
                var dom_th_i = dom_th[i];
                if (i < fixcolumnnumber) {
                    $(dom_th_i).addClass("grid_fixed");
                }
                if (sort[i]) {
                    $(dom_th_i).addClass("grid_sort");
                }
                //CSS
                dom_th_i.removeAttribute("width");
                dom_th_i.style.width = "";
                //html
                var thead_text_i = thead_text[i];
                var th_html = [
                    '<div class="grid_fixed_d">',
                    '<span class="grid_fixed_s">',
                    '<a class="grid_thead_text'
                ];
                if (ellipsis) {
                    th_html.push('" title="', thead_text_i.replace(/<.*?>|\s+/g, ""));
                }
                th_html.push('">' , thead_text_i ,'</a>');
                if (colhidden) {
                    th_html.push('<a class="grid_select"></a>');
                }
                th_html.push('<em class="grid_ittab"></em>');
                th_html.push('</span>');
                if (i < fixcolumnnumber && !ellipsis) {
                    th_html.push(thead_text_i);
                }
                th_html.push('</div>');
                dom_th_i.innerHTML = th_html.join("");
            }

            this.grid_head_table.html(this.el_cache.find("thead").eq(0).prepend(tr));
            this.el_cache.parent().remove(); //???????????????????????
            delete this.el_cache;
            //????fixed dom ????z-index???
            for (var j = 0; j < fixcolumnnumber; j += 1) {
                dom_th[j].getElementsByTagName("div")[0].style.zIndex = fixcolumnnumber + 1 - j;
                dom_fixed_j.push(dom_th[j].getElementsByTagName("span")[0]);
            }
            //???????
            var dom_th_0 = $(dom_th[0]);
            if (opts.selectrows === "multi") {
                dom_th_0.find(".grid_select").eq(0).remove();
                dom_th_0.find(".grid_fixed_s").addClass("grid_no_move");
                var grid_thead_text = $(dom_th[0]).find(".grid_thead_text").addClass("grid_all_check_box"),
                    old_input = grid_thead_text.find("input")[0],
                    new_input = document.createElement("input");
                if(this.is_qm || C.Browser.isIE7 || C.Browser.isIE6) {
                    grid_thead_text.addClass("grid_all_check_box_qm");
                }
                new_input.type = 'checkbox';
                new_input.name = opts.allboxname;
                new_input.className = 'grid_all_check';
                grid_thead_text[0].replaceChild(new_input, old_input);
                var null_text = document.createElement("i");
                null_text.className = "grid_null_text";
                null_text.innerHTML = "&nbsp;";
                grid_thead_text[0].appendChild(null_text);
                this.grid_all_check = grid_thead_text.find(".grid_all_check");
            }
            //??????? ????????ß—??
            if (opts.selectrows === "single") {
                dom_th_0.find(".grid_select").eq(0).remove();
                dom_th_0.find(".grid_fixed_s").addClass("grid_no_move");
            }
        },
        /**
         * ????tbody??don
         * @private
         */
        __renderBody: function () {
            var el           = this.el,
                col_size     = this.col_size,
                dom_body_col = this.dom_body_col,
                tr           = document.createElement("tr");
            tr.className = "grid_width_norm";
            for (var i = 0; i < col_size; i += 1) {
                var th = dom_body_col[i] = document.createElement("th");
                tr.appendChild(th);
            }
            el.html("<thead></thead><tbody></tbody>");
            el.find("thead").append(tr);
            this.grid_tbody = el.find("tbody").eq(0);
        },
        /**
         * ???tbody????????,??????ß÷????.
         */
        __packageTds: function () {
            var opts            = this.options,
                fixcolumnnumber = opts.fixcolumnnumber,
                render_style    = this.render_style,
                selectrows      = opts.selectrows,
                selectrows_html = this.selectrows_html = {
                    "no"    : "",
                    "multi" : "<input type='checkbox' name='" + opts.checkboxname + "' />",
                    "single": "<input type='radio' name='" + opts.checkboxname + "' />"
                }[selectrows],
                col_size = this.col_size,
                left_css = "";
            if (!this.write_style) {
                left_css = "left:0px;";
            }
            //?????????â^
            var first_row = [];
            var start = 0;
            if (selectrows_html !== "") {
                start += 1;
                var td_0 = first_row[0] = {};
                if (fixcolumnnumber > 0) {
                    td_0.html = [
                        '<div class="grid_fixed_d" style="z-index:',
                        fixcolumnnumber + 1,
                        ';"><span class="grid_fixed_s" style="',
                        left_css,
                        render_style[0],
                        '/**/">',
                        selectrows_html,
                        '</span></div>'
                    ].join("");
                    td_0.style = "";
                } else {
                    td_0.style = render_style[0];
                    td_0.html = selectrows_html;
                }
            }
            for (var i = start; i < col_size; i += 1) {
                var td_i = first_row[i] = {};
                if (i < fixcolumnnumber) {
                    td_i.html = [
                        '<div class="grid_fixed_d" style="z-index:',
                        fixcolumnnumber + 1 - i,
                        ';"><span class="grid_fixed_s" style="' ,
                        left_css,
                        render_style[i],
                        '/**/"><!---->',
                        '</div>'
                    ].join("");
                    td_i.style = "";
                } else {
                    td_i.style = render_style[i];
                }
            }
            this.tds_package = first_row;
        },
        /**
         * ?????ß·?,?????ß”???????.
         * adaptive === true, ?? grid_width === table_width ????????.
         * @returns {*}
         * @private
         */
        _setColWidth: function (scrolling) {
            var init_col_width = this.init_col_width,
                col_hidden     = this.col_hidden,
                table_width    = this.table_width,
                col_size       = this.col_size,
                sum_width      = 0;
            for (var i = col_size; i--;) {
                if (col_hidden[i] === false) { //???
                    sum_width += init_col_width[i];
                }
            }
            var new_col_width = [];
            var all_width = 0;
            var last = 0;
            for (var j = col_size; j--;) {
                if (col_hidden[j] === false) {
                    var width        = Math.round(init_col_width[j] * table_width / sum_width);
                    all_width       += width;
                    new_col_width[j] = width;
                    last             = j;
                } else {
                    new_col_width[j] = 0;
                }
            }
            new_col_width[last] += table_width - all_width;
            this.col_width       = new_col_width;
            this._setColWidthStyle();
            if (scrolling) {
                this._isScrolling(true);
            }
        },
        /**
         * ??????ß·??
         * @private
         */
        _setColWidthStyle: function (index) {
            var col_width    = this.col_width,
                dom_head_col = this.dom_head_col,
                dom_body_col = this.dom_body_col,
                k            = this.col_size,
                col_width_k  = "",
                col_width_index;
            if (typeof index === "number") {
                col_width_index = col_width[index] - 1 + "px";
                dom_head_col[index].style.width = col_width_index;
                dom_body_col[index].style.width = col_width_index;
            } else {
                for (; k--;) {
                    col_width_k = col_width[k] === 0 ? 0 : col_width[k] - 1 + "px";
                    dom_head_col[k].style.width = col_width_k;
                    dom_body_col[k].style.width = col_width_k;
                }
            }
        },
        /**
         * ??????
         */
        _colHidden: function (init) {
            var end_row          = this.end_row,
                dom_th           = this.dom_th,
                dom_td           = this.dom_td,
                tds_package      = this.tds_package,
                dom_head_col     = this.dom_head_col,
                dom_body_col     = this.dom_body_col,
                col_hidden       = this.col_hidden,
                col_width        = this.col_width,
                col_width_backup = this.col_width_backup,
                table_width      = this.table_width,
                thead_map        = this.thead_map,
                th               = null,
                change_ths       = [],
                same_th          = false,
                this_dom_th      = null;
            for (var i = this.col_size; i--;) {
                if (col_hidden[i] === true) {
                    if (col_width_backup[i] === -1 || init) {
                        dom_head_col[i].style.display = "none";
                        this_dom_th = dom_th[i];
                        this_dom_th.style.display = "none";
                        if (thead_map.length) {
                            change_ths = [this_dom_th];
                            same_th = false;
                            for (var p = thead_map.length - 1; p--;) {
                                th = thead_map[p][i];
                                for (var x = change_ths.length; x --;) {
                                    if (change_ths[x] === th) {
                                        same_th = true;
                                        break;
                                    }
                                }
                                if (!same_th) {
                                    change_ths.push(th);
                                    if (th.colSpan > 1) {
                                        th.colSpan--;
                                    } else {
                                        th.style.display = "none";
                                    }
                                }
                            }
                        }
                        for (var m = end_row; m--;) {
                            dom_td[m][i].style.display = "none";
                        }
                        dom_body_col[i].style.display = "none";
                        tds_package[i].style += "display:none;";
                        col_width_backup[i] = col_width[i];
                        table_width -= col_width[i];
                        col_width[i] = 0;
                    }
                } else {
                    if (col_width_backup[i] !== -1) {
                        dom_head_col[i].style.display = "";
                        this_dom_th = dom_th[i];
                        this_dom_th.style.display = "";
                        if (thead_map.length) {
                            change_ths = [this_dom_th];
                            same_th = false;
                            for (var q = thead_map.length - 1; q--;) {
                                th = thead_map[q][i];
                                for (var y = change_ths.length; y --;) {
                                    if (change_ths[y] === th) {
                                        same_th = true;
                                        break;
                                    }
                                }
                                if (!same_th) {
                                    change_ths.push(th);
                                    if (th.style.display === "none") {
                                        th.style.display = "";
                                    } else {
                                        th.colSpan += 1;
                                    }
                                }
                            }
                        }
                        for (var n = end_row; n--;) {
                            dom_td[n][i].style.display = "";
                        }
                        dom_body_col[i].style.display = "";
                        tds_package[i].style = tds_package[i].style.replace(/display.*?($|;)/g, "");
                        col_width[i] = col_width_backup[i];
                        table_width += col_width_backup[i];
                        col_width_backup[i] = -1;
                    }
                }
            }
            if (!this.options.adaptive) {
                this.table_width = table_width;
            } else {
                //????????
                this.is_ittab = false;
            }
            this._setLayout();
            //????????
            if (this.persistence && !init) {
                this._triggerStatusChange();
            }
        },
        /**
         * ????????
         * @private
         */
        _triggerStatusChange: function () {
            var opts = this.options,
                query = this.query,
                col_width = this.col_width,
                col_width_backup = this.col_width_backup,
                col_hidden = this.col_hidden,
                col_index = this.col_index,
                is_width = !opts.adaptive,
                is_index = this.thead_map.length === 0 && opts.colmove,
                overall = 0,
                ret, width, index, i,new_json;
            for (i = this.col_size; i--;) {
                if (col_hidden[i]) {
                    col_width[i] = col_width_backup[i];
                }
                overall += col_width[i];
            }
            new_json = {
                "hidden" : col_hidden,
                "sortName" : query.sortName,
                "sortType" : query.sortType,
                "overall" : overall
            };
            if(window.JSON && JSON.stringify) {
                if (is_index){
                    new_json.index = col_index;
                }
                if (is_width) {
                    new_json.width = col_width;
                }
                ret = JSON.stringify(new_json);
            } else {
                ret = ["{",
                    is_index ? ["\"index\":[", col_index.join(","), "],"].join("") : "",
                    is_width ? ["\"width\":[", col_width.join(","), "],"].join("") : "",
                    "\"hidden\":[", col_hidden.join(","), "],",
                    "\"sortName\":[", query.sortName.join(","), "],",
                    "\"sortType\":[", query.sortType.join(","), "],",
                    //"\"width_backup\":[", col_width_backup.join(","), "],",
                    "\"overall\":", overall,
                    "}"
                ].join("");
            }
            this.options.onstatuschange(ret);
        },
        /**
         * ?ßÿ??????????ß€?????
         * @private
         */
        _isScrolling: function (un_set_col_width) {
            var el             = this.el,
                grid_width     = this.grid_width + 2,
                table_width    = this.table_width,
                box_height     = this.box_height,
                content_height = el.height(),
                grid_scroll    = this.grid_scroll;
            if (this.options.adaptive && !this.is_ittab) {
                //???????
                if (box_height < content_height) {
                    table_width = this.table_width = grid_width - 17;
                    grid_scroll.css("width", grid_width - 17);
                } else {//??ß€?????
                    this.table_width = grid_width;
                    table_width = grid_width + 1;
                    grid_scroll.css("width", "");
                }
                el.css("width", table_width);
                this.grid_head_table.css("width", table_width);
               // grid_scroll[0].scrollLeft = 0;
                grid_scroll.css("left", "-999999px");
                if (!un_set_col_width) {
                    this._setColWidth(true);
                    this._setLayout(true);
                }
            } else {

                //????????????
                if (box_height < content_height &&
                    grid_width >= table_width + 17) {
                    this.grid_table_hide.css("marginBottom", 0);
                    grid_scroll.css("left", "-999999px");
                }
                //??ß‹????????
                if (grid_width < table_width &&
                    box_height >= content_height + 17) {
                    grid_scroll.css({"width": "", "left" : 0, "bottom": ""}).children("div").eq(0).css("width", table_width - 1);
                    grid_scroll.css("bottom", 0);
                    this.grid_table_hide.css("marginBottom", 17);
                }
                //????????;
                if (grid_width < table_width + 17 &&
                    box_height < content_height || grid_width < table_width &&
                    box_height < content_height + 17) {
                    grid_scroll.css({"width": grid_width - 17, "left" : 0, "bottom": ""}).children("div").eq(0).css("width", table_width);
                    grid_scroll.css("bottom", 0);
                    this.grid_table_hide.css("marginBottom", 17); //?ß‹???
                }
                //??ß€?????
                if (box_height >= content_height &&
                    grid_width >= table_width) {
                    this.grid_table_hide.css("marginBottom", 0);
                    grid_scroll.css("left", "-999999px");
                }
            }
            //???®¥?????
            grid_scroll.scroll();
        },
        /**
         * ?????????????,??????????
         * @private
         */
        _setAutoHeight: function () {
            var grid_table_box, line_height;
            if (this.auto_height) {
                grid_table_box = this.grid_table_box;
                line_height = 27;
                var margin_bottom = parseInt(grid_table_box.css("marginBottom"), 10) || 0;
                var table_height = Math.max(grid_table_box.height() || this.row_size * line_height, line_height);
                this._setHeight(table_height + margin_bottom + this.thead_height + (this.options.pagination ? 40 : 0) + 2);
            }
        },
        /**
         * ????:?????????????,col???????.
         * @private
         */
        _setLayout: function (not_set_scrolling) {
            this._setStyleWidth();
            //??????????
            if (!this.options.titleellipsis || this.thead_map.length) {
                this._setTheadHeight();
            }
            this._setStyleHeight();

            if (!not_set_scrolling) {
                this._isScrolling();
            }
            this._setAutoHeight();
        },
        /**
         * ?????????????????
         * @private
         */
        _setTheadHeight: function () {
            this.grid_head.css("height", "auto");
            var new_thead_height = this.thead_height = this.grid_head.height(),
                dom_fixed_0      = this.dom_fixed[0],
                titleellipsis    = this.options.titleellipsis;
            this.box_height      = this.grid_height - this.pagination_height - (this.options.titlelock ? new_thead_height : 0);
            for (var i = dom_fixed_0.length; i--;) {
                var dom_fixed_0_i = dom_fixed_0[i];
                var th_height = $(dom_fixed_0_i).parents("th").height() - (this.is_qm ? 0 : 1) + "px";
                dom_fixed_0_i.style.height = th_height;
                if (titleellipsis) {
                    dom_fixed_0_i.style.lineHeight = th_height;
                }
            }
        },
        /**
         * ???????
         */
        setDatasource: function (data, totalSize, persistence_conf) {
            if (this.persistence && this.un_render) {
                this._setPersistence(persistence_conf);
            }
            data = data || [];
            totalSize = totalSize || 0;
            this.row_size = data.length;
            this.data = $.extend(true, [], data);
            //??????
            if (this.options.pagination) {
                //????????,??????
                if (this.un_render) {
                    this.total_size = totalSize;
                    this.__createPagination();
                }
                //totalSize?Å£,??????
                if (this.total_size !== totalSize) {
                    this.total_size = totalSize;
                    this._changepages();
                }
            }
            this._isEmpty();
            //??????
            this._initProperty();
            this._renderTbody(NaN, NaN);
            this._setLayout();
            this._loading("hide");
            this._loadComplateCallBack();
            this.__setSortStyle();
            delete this.un_render;
        },
        /**
         * ???????????
         * @private
         */
        _setPersistence : function (conf) {
            var json,
                opts = this.options,
                col_size = this.col_size,
                index, sortName,sortType, hidden, width;
            if (typeof conf === "string") {
                json = $.parseJSON(conf);
                if (json) {
                    if (json.overall) {
                        this.table_width = json.overall;
                        this.grid_head_table.css("width", this.table_width);//????????table????
                    }
                    index = json.index;
                    if (this.thead_map.length === 0 && opts.colmove &&
                        typeof index === "object" && col_size === index.length) {
                        this.col_index = index;
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
                    hidden = json.hidden;
                    if (typeof hidden === "object" && col_size === hidden.length) {
                        this.col_hidden = hidden;
                    }
                    width = json.width;
                    if (!opts.adaptive && typeof width === "object" &&
                        col_size === width.length) {//????????????????ß·??????
                        this.col_width = width;
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
         * ????????????
         * @private
         */
        _sortPropertys: function (index) {
            var col_size = this.col_size, ths_box,
                dom_th, new_dom_th, i;
            dom_th = this.dom_th;
            new_dom_th = [];
            ths_box = dom_th[0].parentNode;
            for (i = 0; i < col_size; i++) {
                new_dom_th[i] = dom_th[index[i]];
                ths_box.appendChild(new_dom_th[i]);
            }
            this.dom_th = new_dom_th;
        },
        /**
         * ?????????
         * @private
         */
        _isEmpty: function () {
            var opts = this.options;
            var row_size = this.row_size;
            //?ßÿ??????????
            if (row_size === 0) {
                this.grid_empty.show();
                this.grid_tfoot.hide();
                this.el.hide();
                this.pagination_height = 0;
            } else {
                this.grid_empty.hide();
                this.el.show();
                if (opts.pagination) {
                    this.grid_tfoot.show();
                    this.pagination_height = 40;
                }
            }
            //????? ????box_height
            this.box_height = this.grid_height - this.pagination_height - (opts.titlelock ? this.thead_height : 0);
        },
        /**
         * ???????,????????????
         * @private
         */
        _initProperty: function () {
            var self = this;
            setTimeout(function () {
                self.grid_body[0].scrollTop = 0;
                //self.grid_scroll[0].scrollLeft = 0;
            }, 1);
            this.dom_tr           = [];
            this.dom_td           = [];
            this.dom_fixed.length = 1;
            this.multi_checked    = [];
            this.multi_checked_num= 0;
            this.single_checked   = NaN;
            this.odd              = false;
            this.end_row          = 0;
            this.render_complete  = false;
            if (this.grid_all_check) {
                this.grid_all_check.prop("checked", false);
            }
            this.grid_tbody.html("");
            //?????????????????
            this.tr_start = 0;
            this.tr_end = 0;
        },
        /**
         * ???????
         */
        loadData: function () {
            this._loading("show");
            this.options.datasource(this, this.getQuery());
        },
        /**
         * ??????
         * @public
         */
        addData: function (data, position) {
            if ($.type(data) === "object") {
                data = [data];
            }
            var len = data.length;
            if (len === 0) {
                return;
            }
            data = $.extend(true, [], data);
            if (this.un_render) { //???¶ƒ setDatasource??.
                this.setDatasource(data);
                return;
            }
            this.row_size += data.length;
            this._isEmpty();
            var selectrows  = this.options.selectrows;
            if (typeof position === "number" && position < this.row_size) {
                this._spliceArray(this.data, position, data);
                if (selectrows === "multi") {
                    this._spliceArray(this.multi_checked, position, new Array(len));
                } else if (selectrows === "single" && position < this.single_checked) {
                    this.single_checked += len;
                }
            } else {
                this.data = this.data.concat(data);
            }
            this._renderTbody(len, position);
            if (this.pagination_obj) {
                this._changepages();
            }
            this._setLayout();
            var adddata_callback = this.options.adddata_callback;
            if (typeof adddata_callback === "function") {
                adddata_callback.call(this, data);
            }
        },
        /**
         * ??????
         * @private
         */
        __createPagination: function () {
            var opts = this.options,
                query = this.query;
            if (!opts.pagination) {
                return;
            }
            var self = this;
            window.cui(this.grid_tfoot).pagination({
                count         : this.total_size,
                pagesize      : query.pageSize,
                pageno        : query.pageNo,
                pagesize_list : opts.pagesize_list,
                tpls          : {pagination: opts.pagination_model},
                cls           : opts.pagination_model,
                on_page_change: function (pageno, pagesize) {
                    query.pageNo = pageno;
                    query.pageSize = pagesize;
                    self.loadData();
                    self._changepages();
                }
            });
            this.pagination_obj = window.cui(this.grid_tfoot);
        },
        /**
         * ??????
         * @private
         */
        _changepages: function () {
            var query = this.query;
            this.pagination_obj.setInitData({
                count : this.total_size,
                pagesize : query.pageSize,
                pageno   : query.pageNo
            });
            this.pagination_obj.reDraw();
        },
        /**
         * ?ßﬁ????????
         * @private
         */
        _spliceArray: function (source, position, target) {
            Array.prototype.splice.apply(source, [position, 0].concat(target));
            return source;
        },
        /**
         * ???tbody
         * @private
         */
        _renderTbody: function (add_size, position) {
            var data        = this.data,
                end_row     = this.end_row,
                row_size    = this.row_size,
                render_rows = parseInt(this.box_height / 27, 10) + 20,
                ellipsis    = this.options.ellipsis;
            if (row_size === 0) {
                this.render_complete      = true;
                this.append_rows_complete = true;
                return;
            }
            this.render_complete = false;
            if (!isNaN(add_size)) {
                //????????
                if (this.grid_all_check) {
                    this.grid_all_check.prop("checked", false);
                }
                if (typeof position === "number" && position < end_row) { //?ßﬁ??????
                    //???index????.
                    var dom_tr = this.dom_tr;
                    for (var j = position; j < end_row; j += 1) {
                        dom_tr[j].removeAttribute("index");
                    }
                    var position_tr = dom_tr[position],
                    //???dom
                        dom = this._dataToDom(data, position, position + add_size),
                        add_tr = dom.dom_tr;
                    this._spliceArray(this.dom_tr, position, add_tr);
                    this._spliceArray(this.dom_td, position, dom.dom_td);
                    this._spliceArray(this.dom_fixed, position + 1, dom.dom_fixed);
                    //????dom
                    if (position >= this.tr_start && position < this.tr_end || !ellipsis) {
                        var grid_tbody = this.grid_tbody[0];
                        for (var i = 0; i < add_size; i += 1) {
                            grid_tbody.insertBefore(add_tr[i], position_tr);
                        }
                        if (ellipsis) {
                            this.tr_end += add_size;
                        }
                    } else {
                        if (position < this.tr_start && ellipsis) {
                            this.tr_start += add_size;
                            this.tr_end += add_size;
                        }
                        var tr_frag = this.tr_frag;
                        for (var k = 0; k < add_size; k += 1) {
                            tr_frag.appendChild(add_tr[k]);
                        }
                    }
                    this.end_row += add_size;
                    this._setAutoHeight();
                    this._setOddEven(position);
                    this._setNum(position);
                } else {
                    this._lazyload();
                }
            } else {
                var end = Math.min(row_size, end_row + render_rows + 1);
                if (ellipsis) {
                    this.tr_end = end;
                }
                this._appendRows(end_row, end);
            }
        },
        /**
         * ????????
         * @private
         */
        _loadComplateCallBack: function () {
            var loadcomplate_callback = this.options.loadcomplate_callback;
            if (typeof loadcomplate_callback === "function") {
                loadcomplate_callback.call(this, this);
            }
        },
        /**
         * ???????????
         * @private
         */
        __setSortStyle: function () {
            var query = this.query,
                sort_type = query.sortType,
                sort_name = query.sortName,
                len = sort_name.length,
                bind_name     = this.bind_name,
                dom_th        = this.dom_th,
                i, j, dom_th_j, bind_name_j, class_name,
                sort_str = {"DESC":"desc", "ASC" : "asc"};
            loop_outer:for (j = this.col_size; j--;) {
                bind_name_j = bind_name[j];
                dom_th_j = dom_th[j];
                for (i = 0; i < len; i++) {
                    class_name = dom_th_j.className.replace(/grid_sort_\w+/g, "");
                    if (sort_name[i] === bind_name_j) {
                        dom_th_j.className = class_name + " grid_sort_" + sort_str[sort_type[i]];
                        continue loop_outer;
                    }
                    dom_th_j.className = class_name;
                }
            }
        },
        /**
         * data????????ß÷?dom
         * @param data
         * @param start
         * @param end
         * @returns {{dom_td: Array, dom_tr: Array, dom_fixed: Array}}
         * @private
         */
        _dataToDom: function (data, start, end) {
            var opts                = this.options,
                oddevenclass        = opts.oddevenclass,
                oddevenrow          = opts.oddevenrow,
                ellipsis            = opts.ellipsis,
                col_size            = this.col_size,
                dom_th              = this.dom_th,
                tds_package         = this.tds_package,
                bind_name           = this.bind_name,
                bind_dot_name       = this.bind_dot_name,
                fixcolumnnumber     = opts.fixcolumnnumber,
                num_col             = this.num_col,
            //????????????
                col_render          = this.col_render,
            //??????
                rowstylerender      = opts.rowstylerender,
                colstylerender      = opts.colstylerender,
                rowstylerender_able = typeof rowstylerender === "function",
                colstylerender_able = typeof colstylerender === "function",
                render_method       = this.render_method,
                height_light        = this.height_light,
                col_start           = (this.selectrows_html !== "") ? 1 : 0,
                odd                 = this.odd,
                primarykey          = opts.primarykey,
                ispk                = typeof data[0] === "object" && data[0].hasOwnProperty(primarykey),
                create_dom_box      = this.create_dom_box,
                table = ['<table>'];
            for (var j = start; j < end; j += 1) {
                table.push('<tr class="');
                if (oddevenrow) {
                    if (odd) {
                        table.push(oddevenclass);
                    }
                    odd = !odd;
                }
                if (height_light[j]) {
                    table.push(" grid_highlight");
                }
                table.push('"');
                var data_j = data[j];
                if (ispk && data_j.hasOwnProperty(primarykey)) {
                    table.push(' pkey="');
                    table.push(String(data_j[primarykey]));
                    table.push('"');
                }
                if (rowstylerender_able) {
                    var rowstyle = rowstylerender(data_j);
                    if (typeof rowstyle === "string") {
                        table.push(' style="', rowstyle, '"');
                    }
                }
                table.push('>');
                if (col_start === 1) {
                    var tds_package_0 = tds_package[0];
                    table.push('<td class="grid_select_input');
                    if (fixcolumnnumber > 0) {
                        table.push(' grid_fixed');
                    }
                    table.push('" style="', tds_package_0.style, '">', tds_package_0.html, '</td>');
                }
                var tds_package_i   = "",
                    colstyle        = "",
                    bind_name_i     = "",
                    bind_dot_name_i = "",
                    value           = "",
                    render          = "",
                    col_render_i    = null,
                    col_render_i_0  = null,
                    col_render_i_1  = null,
                    col_json        = null;
                for (var i = col_start; i < fixcolumnnumber; i += 1) {
                    bind_name_i = bind_name[i];
                    bind_dot_name_i = bind_dot_name[i];
                    //???????
                    if (num_col === i) {
                        value = j + bind_name_i;
                    } else {
                        if (!bind_name_i) {
                            value = "";
                        } else {
                            if (typeof bind_dot_name_i === "undefined") {
                                value = data_j[bind_name_i];
                            } else {
                                value = data_j[bind_dot_name_i[0]];
                                if (value && typeof value === "object") {
                                    value = value[bind_dot_name_i[1]] || "";
                                } else {
                                    value = "";
                                }
                            }
                        }
                    }
                    var tag_html   = "", method = "";
                    col_render_i   = col_render[i];
                    col_render_i_0 = col_render_i[0];
                    col_render_i_1 = col_render_i[1];
                    if (col_render_i_1) {
                        value = col_render_i_1.callback(value, col_render_i_1.format) || value;
                    }
                    if (col_render_i_0) {
                        render = col_render_i_0.render;
                        method = col_render_i_0.method;
                        switch (render) {
                            case "colrender_fn" :
                                value = col_render_i_0.callback(data_j, bind_name_i) || value;
                                break;
                            case "render_fn" :
                                col_json = col_render_i_0.col_json;
                                col_json.el = dom_th[i];
                                col_json.bindName = bind_name_i;
                                value = col_render_i_0.callback(data_j, j, col_json) || value;
                                break;
                            case "fiexd_fn" :
                                value = render_method[method](data_j, col_render_i_0.options, value) || value;
                                break;
                        }
                    }
                    if (method === "button" || ellipsis) {
                        tag_html = [value, "</span>"].join("");
                     } else {
                        tag_html = [value, "</span>", value].join("");
                    }
                    tds_package_i = tds_package[i];
                    var html = tds_package_i.html.replace("<!---->", tag_html);
                    table.push('<td class="grid_fixed" style="', tds_package_i.style, '">');
                    if (colstylerender_able) {
                        colstyle = colstylerender(data_j, bind_name_i);
                        if (typeof colstyle === "string") {
                            html = html.replace("/**/", colstyle);
                        }
                    }
                    table.push(html, '</td>');
                }
                for (; i < col_size; i += 1) {
                    bind_name_i = bind_name[i];
                    bind_dot_name_i = bind_dot_name[i];
                    tds_package_i = tds_package[i];
                    if (num_col === i) {
                        value = j + bind_name_i;
                    } else {
                        if (!bind_name_i) {
                            value = "";
                        } else {
                            if (typeof bind_dot_name_i === "undefined") {
                                value = data_j[bind_name_i];
                            } else {
                                value = data_j[bind_dot_name_i[0]];
                                if (value && typeof value === "object") {
                                    value = value[bind_dot_name_i[1]] || "";
                                } else {
                                    value = "";
                                }
                            }
                        }
                    }
                    col_render_i   = col_render[i];
                    col_render_i_0 = col_render_i[0];
                    col_render_i_1 = col_render_i[1];
                    if (col_render_i_1) {
                        value = col_render_i_1.callback(value, col_render_i_1.format) || value;
                    }
                    if (col_render_i_0) {
                        render = col_render_i_0.render;
                        switch (render) {
                            case "colrender_fn" :
                                value = col_render_i_0.callback(data_j, bind_name_i) || value;
                                break;
                            case "render_fn" :
                                col_json          = col_render_i_0.col_json;
                                col_json.el       = dom_th[i];
                                col_json.bindName = bind_name_i;
                                value             = col_render_i_0.callback(data_j, j, col_json) || value;
                                break;
                            case "fiexd_fn" :
                                value = render_method[col_render_i_0.method](data_j, col_render_i_0.options, value) || value;
                                break;
                        }
                    }
                    //??td???
                    var td_style = tds_package_i.style;
                    if (colstylerender_able) {
                        colstyle = colstylerender(data_j, bind_name_i);
                        if (typeof colstyle === "string") {
                            td_style += ";" + colstyle;
                        }
                    }
                    table.push('<td style="', td_style, '">', value, '</td>');
                }
                table.push('</tr>');
            }
            this.odd = odd;
            table.push('</table>');
            create_dom_box.innerHTML = table.join("");
            var dom_tr           = [],
                dom_td           = [],
                dom_fixed        = [],
                selectedrowclass = " " + opts.selectedrowclass,
                multi_checked    = this.multi_checked,
                single_checked   = this.single_checked,
                dom_table        = create_dom_box.getElementsByTagName("table")[0];
            for (var m = 0, len = end - start; m < len; m += 1) {
                var dom_tr_m = dom_table.rows[m];
                dom_tr.push(dom_tr_m);
                var dom_td_m = [];
                var dom_fixed_m = [];
                for (var n = 0; n < col_size; n += 1) {
                    var dom_th_n = dom_tr_m.cells[n];
                    dom_td_m.push(dom_th_n);
                    if (n < fixcolumnnumber) {
                        dom_fixed_m.push(dom_th_n.getElementsByTagName("span")[0]);
                    }
                }
                if (multi_checked[m + start]) {
                    dom_tr_m.className += selectedrowclass;
                    dom_tr_m.cells[0].getElementsByTagName("input")[0].setAttribute("checked", "checked");
                }
                dom_td.push(dom_td_m);
                dom_fixed.push(dom_fixed_m);

            }
            if (!isNaN(single_checked) &&
                single_checked >= start &&
                single_checked < end) {
                var select_row = dom_table.rows[single_checked - start];
                select_row.className += selectedrowclass;
                select_row.cells[0].getElementsByTagName("input")[0].setAttribute("checked", "checked");
            }
            return {
                dom_td: dom_td,
                dom_tr: dom_tr,
                dom_fixed: dom_fixed
            };

        },
        /**
         * ?????????
         * @param start
         * @param end
         * @private
         */
        _appendRows: function (start, end) {
            var row_size   = this.row_size;
            if (this.auto_height || !this.options.lazy) {
                end = row_size;
            }
            end            = this.end_row = Math.min(row_size, end);
            var dom        = this._dataToDom(this.data, start, end);
            this.dom_tr    = this.dom_tr.concat(dom.dom_tr);
            this.dom_td    = this.dom_td.concat(dom.dom_td);
            this.dom_fixed = this.dom_fixed.concat(dom.dom_fixed);
            var dom_tr     = this.dom_tr;
            var grid_tbody = this.grid_tbody[0];
            for (var i = start; i < end; i += 1) {
                grid_tbody.appendChild(dom_tr[i]);
            }
            this.grid_table_box.css("paddingBottom", (row_size - end) * 27);
            this.render_complete = end === row_size;
            this.append_rows_complete = true;
            this._setAutoHeight();
        },
        /**
         * ????????????????????
         * @private
         */
        _setOddEven: function (position) {
            var opts         = this.options;
            if (!opts.oddevenrow) {
                return;
            }
            var dom_tr       = this.dom_tr,
                end_row      = this.end_row,
                oddevenclass = opts.oddevenclass,
                odd          = this.odd = position % 2 === 0,
                i            = position;
            for (; i < end_row; i += 1) {
                if (!odd) {
                    $(dom_tr[i]).addClass(oddevenclass);
                } else {
                    $(dom_tr[i]).removeClass(oddevenclass);
                }
                odd = !odd;
            }
        },
        /**
         * ?????ß‹?
         * @private
         */
        _setNum: function (position) {
            if (isNaN(this.num_col)) {
                return;
            }
            var dom_td    = this.dom_td,
                dom_fixed = this.dom_fixed,
                num_col   = this.num_col,
                start     = this.bind_name[num_col],
                i         = position,
                end_row   = this.end_row;
            if (this.options.fixcolumnnumber > num_col) {
                for (; i < end_row; i += 1) {
                    var dom_fixed_i = dom_fixed[i + 1][num_col];
                    var value = i + start;
                    dom_fixed_i.innerHTML = value;
                    dom_fixed_i.nextSibling.nodeValue = value;
                }
            } else {
                for (; i < end_row; i += 1) {
                    dom_td[i][num_col].innerHTML = i + start;
                }
            }
        },
        /**
         * ??????
         * @param hide_bind_name
         */
        hideCols: function (hide_bind_name) {
            if ($.type(hide_bind_name) !== "object") {
                return;
            }
            var col_hidden = this.col_hidden,
                col_size   = this.col_size,
                bind_name  = this.bind_name;
            for (var i = 0; i < col_size; i += 1) {
                var falg = hide_bind_name[bind_name[i]];
                if (typeof falg === "boolean") {
                    col_hidden[i] = falg;
                }
            }
            this._colHidden(false);
        },
        /**
         * ??????????
         */
        getQuery: function () {
            var new_query = $.extend(true, {}, this.query),
                custom_query = this.custom_query;
            if (!custom_query) {
                return new_query;
            }
            custom_query.pageSize = new_query.pageSize;
            custom_query.pageNo = new_query.pageNo;
            custom_query.sortName = $.extend([], new_query.sortName);
            custom_query.sortType = $.extend([], new_query.sortType);
            return custom_query;
        },
        /**
         * ???®∞??????
         * @param query
         */
        setQuery: function (query) {
            if (typeof query === "object") {
                this.custom_query = query;
            }
            query         = query || this.backup_query;
            var sortstyle = this.options.sortstyle,
                new_query = this.query;
            if (typeof query.pageSize === "number") {
                new_query.pageSize = query.pageSize;
            }
            if (typeof query.pageNo === "number") {
                new_query.pageNo = query.pageNo;
            }
            if ($.type(query.sortName) === "array") {
                new_query.sortName = $.extend([], query.sortName);
                if (new_query.sortName.length > sortstyle) {
                    new_query.sortName.length = sortstyle;
                }
            }
            if ($.type(query.sortType) === "array") {
                new_query.sortType = $.extend([], query.sortType);
                if (new_query.sortType.length > sortstyle) {
                    new_query.sortType.length = sortstyle;
                }
            }
            this._setPageSize();
            this._setSortTypeObj();
            if (this.pagination_obj) {
                this._changepages();
            }
        },
        /**
         * ????????????
         * @param height
         * @private
         */
        _setHeight: function (height) {
            if (typeof height !== "number" || height - 2 === this.grid_height) {
                return false;
            }
            height          -= 2;
            this.box_height -= this.grid_height - height;
            this.grid_height = height;
            //this.is_ittab = false;
            //?????,??????????
            this._lazyload();
            this._setLayout();
            if (this.options.colhidden && this.hideCol.hide_col) {
                this.hideCol.hide_col.blur();
            }
            return true;
        },
        /**
         * ??????????
         */
        setHeight: function (height) {//??????? ??????????????.
            this.auto_height = !this._setHeight(height);
        },
        /**
         * ??????????
         */
        setWidth: function (width) {
            if (typeof width !== "number" || width - 2 === this.grid_width) {
                return;
            }
            var ittab = this.ittab; //???IE??????????????????resize??bug
            if (ittab && ittab.ittab_active) {
                return;
            }
            width -= 2;
            if (this.options.adaptive) {
                this.table_width = width - 17;
                this.is_ittab = false;
            }
            this.grid_width = width;
            this._setLayout();
            if (this.options.colhidden && this.hideCol.hide_col) {
                this.hideCol.hide_col.blur();
            }
        },
        /**
         * ?????ß⁄???
         * @param pk
         */
        setHighLight: function (pk) {
            var primarykey = this.options.primarykey,
                data = this.data;
            if (data[0] && data[0].hasOwnProperty(primarykey)) {
                for (var j = this.row_size; j--;) {
                    if (data[j][primarykey] === pk) {
                        if (j < this.end_row) {
                            $(this.dom_tr[j]).addClass("grid_highlight");
                        }
                        this.height_light[j] = true;
                        break;
                    }
                }
            }
        },
        /**
         * ????????????
         * @param index
         * @param flag
         * @returns {Array}
         */
        selectRowsByIndex: function (index, flag) {
            flag = flag !== false;
            var selectrows = this.options.selectrows,
                data = this.data,
                ret = [],
                index_0, index_i;
            if (selectrows === "no" || index >= this.row_size) {
                return [];
            }
            if (flag !== false) {
                flag = true;
            }
            if (typeof index === "number") {
                index = [index];
            }
            if (selectrows === "single") {
                index_0 = index[0];
                this._selectRows(index_0, flag);
                ret.push(data[index_0]);
            } else {
                for (var i = 0, len = index.length; i < len; i += 1) {
                    index_i = index[i];
                    this._selectRows(index_i, flag);
                    ret.push(data[index_i]);
                }
            }
            return ret;
        },
        /**
         * ??????????ß‹?
         * @param pks
         * @param get_invalid
         * @returns {Array}
         * @private
         */
        _pkToIndex: function (pks, get_invalid) {
            if ($.type(pks) !== "array") {
                pks = [pks];
            }
            var data = this.data,
                row_size = this.row_size,
                primarykey = this.options.primarykey;
            if (data[0].hasOwnProperty(primarykey) === false) {
                return [];
            }
            var len = pks.length;
            var indexs = [];
            for (var i = 0; i < len; i += 1) {
                var pks_i = pks[i];
                var has_val = false;
                for (var j = row_size; j--;) {
                    if (data[j][primarykey] === pks_i) {
                        indexs.push(j);
                        has_val = true;
                        break;
                    }
                }
                if (!has_val && get_invalid) {
                    indexs.push(-1);
                }
            }
            return indexs;
        },
        /**
         * ????????????
         * @param pks
         * @param flag
         * @returns {*}
         */
        selectRowsByPK: function (pks, flag) {
            var opts = this.options;
            if (opts.selectrows === "no" || !this.row_size || this.data[0].hasOwnProperty(opts.primarykey) === false) {
                return [];
            }
            return this.selectRowsByIndex(this._pkToIndex(pks, true), flag);
        },
        /**
         * ????ß”???.
         */
        _removeRow: function (row) {
            var data = this.data;
            var removeData = data[row];
            this.data.splice(row, 1);
            $(this.dom_tr[row]).remove();
            this.dom_tr.splice(row, 1);
            this.dom_td.splice(row, 1);
            this.multi_checked.splice(row, 1);
            if (this.single_checked > row){
                this.single_checked--;
            }
            this.dom_fixed.splice(row + 1, 1);
            return removeData;
        },
        /**
         * ?????
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
                    remove_datas   = [],
                    single_checked = this.single_checked,
                    multi_checked  = this.multi_checked,
                    opts           = this.options,
                    selectrows     = opts.selectrows,
                    ellipsis       = opts.ellipsis;
                for (var i = 0; i < len; i += 1) {
                    var rows_i = rows[i] - i;
                    var this_row_size = this.row_size;
                    if (isNaN(rows_i) || rows_i >= this_row_size) {
                        rows[i] = 0;
                        break;
                    }
                    this.row_size = this_row_size - 1;
                    if (rows_i < this.end_row) {
                        if (ellipsis) {
                            if (rows_i < this.tr_end) {
                                this.tr_end--;
                            }
                            if (rows_i < this.tr_start){
                                this.tr_start--;
                            }
                        }
                        this.end_row --;
                    }
                    //???????
                    if (selectrows === "multi") {
                        if (multi_checked[rows_i] === true) {
                            this.multi_checked_num--;
                        }
                    } else if (selectrows === "single" && single_checked === rows_i) {
                        this.single_checked = NaN;
                    }
                    var remove_data = this._removeRow(rows_i);
                    if (remove_data) {
                        remove_datas.push(remove_data);
                    }
                }
                var row_size = this.row_size;
                //?ßÿ??????????????
                if (row_size <= 0) {
                    if (this.query.pageNo > 1) {
                        this.query.pageNo -= 1;
                    }
                    this.row_size = 0;
                    this._isEmpty();
                } else {
                    //?ßÿ??????
                    if (opts.selectrows === "multi") {
                        if (this.multi_checked_num === row_size) {
                            this.grid_all_check.prop("checked", true);
                        } else {
                            this.grid_all_check.prop("checked", false);
                        }
                    }
                    //????index
                    var dom_tr = this.dom_tr;
                    for (var j = this.end_row; j--;) {
                        dom_tr[j].removeAttribute("index");
                    }
                    var rows_0 = rows[0] - 0;
                    this._setOddEven(rows_0);
                    this._setNum(rows_0);
                    this._lazyload();
                }
                this._setLayout();
                //???
                var removedata_callback = opts.removedata_callback;
                if (typeof removedata_callback === "function") {
                    removedata_callback.call(this, remove_datas);
                }
            }
        },
        removeDataByPk: function (pks) {
            this.removeData(this._pkToIndex(pks, false));
        },
        /**
         * ?????????
         * @param new_data
         * @param index
         */
        changeData: function (new_data, index) {
            if ($.type(new_data) !== "object") {
                return;
            }
            var opts = this.options,
                primarykey = opts.primarykey,
                pk_value = new_data[primarykey];
            if (typeof pk_value !== "undefined") {
                var new_index = this._pkToIndex(pk_value, false)[0];
                index = new_index === undefined ? index : new_index;
            }
            if (typeof index !== "number" || index < 0 || index >= this.row_size) {
                return;
            }
            this.data[index] = $.extend(true, this.data[index], new_data);
            if (index >= this.end_row) {
                return;
            }
            //???dom
            var dom             = this._dataToDom([new_data], 0, 1),
                new_dom_td      = dom.dom_td[0],
                old_dom_td      = this.dom_td[index],
                bind_name       = this.bind_name,
                fixcolumnnumber = opts.fixcolumnnumber;
            //?ùI???
            this.odd = !this.odd;
            for (var i = this.col_size; i--;) {
                var bind_name_i = bind_name[i];
                if (i < fixcolumnnumber) {
                    if (typeof bind_name_i !== "number") {
                        var old_span = $(old_dom_td[i]).find(".grid_fixed_s")[0];
                        var value    = $(new_dom_td[i]).find(".grid_fixed_s")[0].innerHTML;
                        old_span.innerHTML = value;
                        old_span.nextSibling.nodeValue = value;
                    }
                } else if (typeof bind_name_i !== "number") {
                    old_dom_td[i].innerHTML = new_dom_td[i].innerHTML;
                }
            }
        },
        /**
         * ??????
         */
        getData: function () {
            return $.extend(true, [], this.data);
        },
        /**
         * ????????????
         * @returns {Array}
         */
        getSelectedRowData: function () {
            var selectrows = this.options.selectrows;
            if (selectrows === "no") {
                return [];
            }
            var data = this.data;
            if (selectrows === "single") {
                return isNaN(this.single_checked) ? [] : [data[this.single_checked]];
            }
            if (this.multi_checked_num === this.row_size) {
                return this.data;
            }
            var multi_checked = this.multi_checked;
            var row_size = this.row_size;
            var ret = [];
            for (var i = 0; i < row_size; i += 1) {
                if (multi_checked[i]) {
                    ret.push(data[i]);
                }
            }
            return ret;
        },
        /**
         * ????????????
         * @returns {Array}
         */
        getSelectedPrimaryKey: function () {
            var opts        = this.options,
                selectrows  = opts.selectrows,
                primarykey  = opts.primarykey,
                select_data = this.getSelectedRowData(),
                len         = select_data.length;
            if (selectrows === "no" ||
                !len ||
                select_data[0].hasOwnProperty(primarykey) === false) {
                return [];
            }
            var ret = [];
            for (var i = 0; i < len; i += 1) {
                ret.push(select_data[i][primarykey]);
            }
            return ret;
        },
        /**
         * ???????ß÷?????
         * @returns {Array}
         */
        getSelectedIndex: function () {
            var selectrows = this.options.selectrows;
            if (selectrows === "no") {
                return [];
            }
            if (selectrows === "single") {
                return [this.single_checked];
            }
            var multi_checked = this.multi_checked;
            var row_size = this.row_size;
            var ret = [];
            for (var i = 0; i < row_size; i += 1) {
                if (multi_checked[i]) {
                    ret.push(i);
                }
            }
            return ret;
        },
        /**
         * ???????????????
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
                    var data_i = data[rows[i]];
                    if (data_i) {
                        ret.push(data_i);
                    }
                }
                return ret;
            }
        },
        /**
         * ?????????????
         * @param pks
         * @returns {*}
         */
        getRowsDataByPK: function (pks) {
            var primarykey = this.options.primarykey;
            var data = this.data;
            if (data[0].hasOwnProperty(primarykey)) {
                if ($.type(pks) !== "array") {
                    pks = [pks];
                }
                var len = pks.length;
                var ret = [];
                for (var i = 0; i < len; i += 1) {
                    var pks_i = pks[i];
                    for (var j = this.row_size; j--;) {
                        if (data[j][primarykey] === pks_i) {
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
         * ??????
         * @param start
         * @param end
         */
        _switchCol: function (start, end) {
            var dom_head_col    = this.dom_head_col,
                dom_body_col    = this.dom_body_col,
                dom_td          = this.dom_td,
                dom_th          = this.dom_th,
                dom_fixed       = this.dom_fixed,
                dom_tr          = this.dom_tr,
                fixcolumnnumber = this.options.fixcolumnnumber,
                num_col         = this.num_col;
            //????
            this._switchArrayValue(this.bind_name, start, end);
            this._switchArrayValue(this.bind_dot_name, start, end);
            this._switchArrayValue(this.col_index, start, end);
            this._switchArrayValue(this.thead_text, start, end);
            this._switchArrayValue(this.render_style, start, end);
            this._switchArrayValue(this.col_render, start, end);
            this._switchArrayValue(this.col_width, start, end);
            this._switchArrayValue(this.init_col_width, start, end);
            this._switchArrayValue(this.col_width_backup, start, end);
            this._switchArrayValue(this.col_hidden, start, end);
            this._switchArrayValue(this.tds_package, start, end);
            //??????¶À?????
            if (!isNaN(num_col)) {
                if (start === num_col) {
                    this.num_col = end - (start > end ? 0 : 1);
                } else if (start > num_col && end <= num_col){
                    this.num_col = num_col + 1;
                } else if (start < num_col && end > num_col) {
                    this.num_col = num_col - 1;
                }
            }
            //dom?ùI
            var dom_td_i = null;
            var i = this.end_row;
            var hide_col = this.hideCol;
            var dom_a = hide_col.dom_a;
            var grid_hidecol_list = hide_col.grid_hidecol_list;
            if (end === this.col_size) {
                var dom_th_start = $(dom_th[start]);
                dom_th_start.appendTo(dom_th_start.parent());
                var dom_body_col_start = $(dom_body_col[start]);
                dom_body_col_start.appendTo(dom_body_col_start.parent());
                var dom_head_col_start = $(dom_head_col[start]);
                dom_head_col_start.appendTo(dom_head_col_start.parent());
                for (; i--;) {
                    dom_td_i = dom_td[i];
                    dom_tr[i].appendChild(dom_td_i[start]);
                    this._switchArrayValue(dom_td_i, start, end);
                }
                if (grid_hidecol_list) {
                    if (this.selectrows_html !== "") {
                        grid_hidecol_list.appendChild(dom_a[start - 1]);
                    } else {
                        grid_hidecol_list.appendChild(dom_a[start]);
                    }
                }
            } else {
                $(dom_th[start]).insertBefore(dom_th[end]);
                $(dom_body_col[start]).insertBefore(dom_body_col[end]);
                $(dom_head_col[start]).insertBefore(dom_head_col[end]);
                for (; i--;) {
                    dom_td_i = dom_td[i];
                    dom_tr[i].insertBefore(dom_td_i[start], dom_td_i[end]);
                    this._switchArrayValue(dom_td_i, start, end);
                }
                if (grid_hidecol_list) {
                    if (this.selectrows_html !== "") {
                        grid_hidecol_list.insertBefore(dom_a[start - 1], dom_a[end - 1]);
                    } else {
                        grid_hidecol_list.insertBefore(dom_a[start], dom_a[end]);
                    }
                }
            }
            //dom????
            this._switchArrayValue(dom_th, start, end);
            if (start < fixcolumnnumber || end < fixcolumnnumber) {
                this._switchArrayValue(dom_fixed[0], start, end);
            }
            this._switchArrayValue(dom_body_col, start, end);
            this._switchArrayValue(dom_head_col, start, end);
            //????
            if (this.persistence) {
                this._triggerStatusChange();
            }
        },
        /**
         * ??????????
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
        //?ß·????
        ittab: {
            ittab_active: false,
            _init: function (self) {
                var that         = this,
                    grid_overlay = self.grid_overlay,
                    grid_line    = self.grid_line,
                    col_width    = [],
                    start        = 0,
                    end          = 0,
                    re_trigger   = true,
                    index        = NaN,
                    adaptive     = self.options.adaptive;
                self.grid_head_table.find(".grid_ittab").show();
                self.grid_head_table.on("mousedown", function (event) {
                    var target = event.target;
                    end = 0;
                    if (target.className === "grid_ittab") {
                        col_width = self.col_width;
                        index     = self._thIndex($(target).parents("th")[0]);
                        grid_overlay.show().css("cursor", "col-resize");
                        var left  = grid_overlay.offset().left;
                        start     = event.pageX - left;
                        grid_line.show().css("left", start);
                        re_trigger = false;
                        grid_overlay.off("mousemove").on("mousemove", function (event) {
                            event.stopPropagation();
                            end = event.pageX - left;
                            if (col_width[index] + end - start < 24) {
                                end = 24 + start - col_width[index];
                            }
                            grid_line.css("left", end);
                            return false;
                        });
                    }
                    return false;
                });
                grid_overlay.on("mouseup mouseout", function () {
                    if (re_trigger || isNaN(index)) {
                        return;
                    }
                    re_trigger = true;
                    $(this).hide();
                    grid_line.hide();
                    if (end === 0) {
                        return;
                    }
                    var change            = end - start;
                    self.is_ittab         = true;
                    self.col_width[index] = col_width[index] + change;
                    self.table_width      = self.table_width + change;
                    that.ittab_active = true;
                    self._setColWidthStyle(!adaptive ? index : undefined);
                    if (self.persistence) {
                        self._triggerStatusChange();
                    }
                    self._setLayout();
                    that.ittab_active = false;
                    start = end = 0;
                    index = NaN;
                });
            }
        },
        //??????
        hideCol: {
            /**
             * ?????
             * @param self
             * @private
             */
            _init: function (self) {
                var hide_col = this.hide_col = document.createElement("div");
                hide_col.className = "grid_hidecol";
                var thead_height   = self.thead_height;
                hide_col.style.top = thead_height + "px";
                hide_col.tabIndex  = "1";
                self.grid_container.append(hide_col);

                hide_col     = $(hide_col);
                var col_size = self.col_size,
                    text     = self.thead_text,
                    i        = 0;
                if (self.selectrows_html !== "") {
                    i += 1;
                }

                var html = ['<div class="grid_hidecol_list" hidefocus="true" >'];
                for (; i < col_size; i += 1) {
                    html.push(
                        '<a href="javascript:;" hidefocus="true" title=',
                        text[i],
                        '><input type="checkbox" checked="checked" />',
                        text[i],
                        '</a>'
                    );
                }
                html.push(
                    '</div>',
                    '<div class="grid_hidecol_button">',
                    '<a href="javascript:;" hidefocus="true" class="grid_hidecol_confirm">???</a>',
                    '<a href="javascript:;" hidefocus="true" class="grid_hidecol_cancel">???</a>',
                    '</div>'
                );
                hide_col.html(html.join(""));
                this.grid_hidecol_list = hide_col.find(".grid_hidecol_list")[0];
                this.dom_a             = this.grid_hidecol_list.getElementsByTagName("a");
                this.bindEvent(self, hide_col);
            },
            /**
             * ?????
             * @param self
             * @param obj
             */
            bindEvent: function (self, obj) {
                var col_size = self.col_size,
                    grid_box = self.grid_box,
                    grid_offset_left,
                    center_point,
                    parent = null,
                    focus = false,
                    start = 0,
                    inputs = obj.find("input"),
                    prev_index = -1,
                    dom_a = this.dom_a,
                    span = document.createElement("span");
                if (self.selectrows_html !== "") {
                    start += 1;
                }
                self.grid_head_table.on("click", function (event) {
                    var target = event.target;
                    grid_offset_left = grid_box.offset().left;
                    center_point = grid_offset_left + self.grid_width / 2;
                    if (target.className === "grid_select") {
                        if (parent) {
                            obj.blur();
                        }
                        inputs = obj.find("input");
                        parent = $(target).parents("th").addClass("grid_thead_select");
                        var offset_left = $(target).offset().left;
                        var left = offset_left - grid_offset_left + 2;
                        if (offset_left > center_point) {
                            left -= 126;
                        }
                        var height = Math.max(self.box_height - self.thead_height - 40, 60);
                        if (22 * col_size > height) {
                            obj.children(".grid_hidecol_list").css("height", height);
                        } else {
                            obj.children(".grid_hidecol_list").css("height", "");
                        }
                        obj.css({"left": left, "top": self.thead_height}).show().focus().attr("hidefocus", "true");
                        reStart();
                        var index = self._thIndex(parent[0]) - start;
                        dom_a[index].appendChild(span);
                        inputs.eq(prev_index).removeAttr("disabled").end().eq(index).attr("disabled", "disabled");
                        prev_index = index;
                        focus = false;
                    } else {
                        $(obj).blur();
                    }
                });
                obj.on("blur", function () {
                    if (focus) {
                        return;
                    }
                    if (parent) {
                        parent.removeClass("grid_thead_select");
                    }
                    $(obj).hide();
                });
                obj.on("mouseover", function () {
                    focus = true;
                });
                obj.on("mouseout", function () {
                    focus = false;
                });

                var hide_col = self.col_hidden;
                obj.on("click", function (event) {
                    var target = $(event.target),
                        class_name = target.prop("className"),
                        tag_name =  target.prop("tagName"),
                        input = target.children("input").eq(0);
                    if (class_name === "grid_hidecol_confirm") {
                        for (var i = start; i < col_size; i += 1) {
                            hide_col[i] = inputs.eq(i - start).prop("checked") === false;
                        }
                        focus = false;
                        self._colHidden(false);
                        $(this).blur();
                        return false;
                    }
                    if (class_name === "grid_hidecol_cancel") {
                        reStart();
                        focus = false;
                        $(this).blur();
                        return false;
                    }
                    if (tag_name === "A") {
                        if (!input.prop("disabled")) {
                            input.prop("checked", !input.prop("checked"));
                        }
                        return false;
                    }
                    this.focus();
                });

                function reStart () {
                    for (var j = start; j < col_size; j+=1) {
                        inputs.eq(j - start).prop("checked", hide_col[j] !== true);
                    }
                }
                setTimeout(reStart, 100);
            }
        },
        /**
         * ?????
         */
        moveCol: {
            _init: function (self) {
                //????dom
                var grid_col_move_insert = $("<div></div>"),
                    grid_col_move_tag    = $("<div></div>"),
                    grid_head_table      = self.grid_head_table.addClass("grid_col_move");
                grid_col_move_insert.addClass("grid_col_move_insert");
                grid_col_move_tag.addClass("grid_col_move_tag");
                self.grid_head.append(grid_col_move_tag).append(grid_col_move_insert);
                //???????
                var opts             = self.options,
                    grid_overlay     = self.grid_overlay,
                    fixcolumnnumber  = opts.fixcolumnnumber,
                    selectrows_html  = self.selectrows_html,
                    col_hidden       = null,
                    fixed_width      = 0,
                    insert_position  = [],
                    mouse_position   = [],
                    index            = NaN,
                    complate         = NaN,
                    is_fixed         = false,
                    move_trigger     = true;
                grid_head_table.on("mousedown", function (event) {
                    var target = $(event.target);
                    if (!target.hasClass("grid_fixed_s") || target.hasClass("grid_no_move")) {
                        return;
                    }
                    if (opts.colhidden) {
                        self.hideCol.hide_col.blur();
                    }
                    //???????
                    move_trigger         = false;
                    col_hidden           = self.col_hidden;
                    var col_width        = self.col_width,
                        col_size         = self.col_size,
                        dom_th           = self.dom_th,
                        dom_fixed_0      = self.dom_fixed[0],
                        head_offset_left = Math.round(grid_head_table.offset().left),
                        scroll_left      = self.grid_scroll[0].scrollLeft,
                        end              = 0,
                    //??????th
                        height           = self.thead_height,
                        parent           = target.parent().parent();
                    index                = self._thIndex(parent[0]);
                    //?????th??¶À??
                    fixed_width          = 0;
                    insert_position      = [];
                    mouse_position       = [];
                    var i = 0, col_width_i = null, position = 0, left_index = 0;
                    if (index < fixcolumnnumber) {
                        is_fixed = true;
                        for (; i < fixcolumnnumber; i += 1) {
                            col_width_i = col_width[i];
                            fixed_width += col_width_i;
                            position = Math.round($(dom_fixed_0[i]).offset().left) - head_offset_left - scroll_left;
                            if (col_hidden[i] === true) {
                                position = -100;
                            }
                            insert_position.push(position);
                            mouse_position.push(position);
                            if (!col_hidden[i]) {
                                mouse_position[i] = position + col_width_i / 2;
                            }
                        }
                        insert_position.push(fixed_width - scroll_left);
                        mouse_position.push(fixed_width - scroll_left - 1);
                        if (selectrows_html) {
                            insert_position[0] = mouse_position[0] = -100;
                        }
                        left_index = insert_position[index] - 1;
                    } else {
                        is_fixed = false;
                        for (i = fixcolumnnumber; i < col_size; i += 1) {
                            col_width_i = col_width[i];
                            position = Math.round($(dom_th[i]).offset().left) - head_offset_left - scroll_left;
                            if (col_hidden[i] === true) {
                                position = -100;
                            }
                            insert_position.push(position);
                            mouse_position.push(position);
                            if (!col_hidden[i]) {
                                mouse_position[i - fixcolumnnumber] = position + col_width_i / 2;
                            }
                        }
                        insert_position.push(self.table_width - scroll_left);
                        mouse_position.push(self.table_width - scroll_left - 1);
                        if (fixcolumnnumber === 0 && selectrows_html) {
                            insert_position[0] = mouse_position[0] = -100;
                        }
                        left_index = insert_position[index - fixcolumnnumber] - 1;
                    }
                    //?????¶À?®≤??ß≥
                    grid_col_move_tag.show().css({
                        left       : left_index,
                        width      : parent.width(),
                        height     : height,
                        lineHeight : height + "px"
                    }).html(target.find(".grid_thead_text").eq(0).html());
                    grid_col_move_insert.show().css("height", height - 4);
                    grid_overlay.show().css("cursor", "move");
                    var start = event.pageX;
                    //???
                    grid_col_move_insert.css("left", -1000);
                    grid_overlay.off("mousemove").on("mousemove", function (event) {
                        event.stopPropagation();
                        end = event.pageX;
                        grid_col_move_tag.css("left", left_index - start + end);
                        var len = mouse_position.length;
                        for (var i = 0; i < len; i += 1) {
                            var mouse_position_i = mouse_position[i];
                            if (mouse_position_i < 0) {
                                continue;
                            }
                            if (end < mouse_position_i) {
                                grid_col_move_insert.css("left", insert_position[i]);
                                if (is_fixed) {
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
                grid_overlay.on("mouseup", function () {
                    if (move_trigger) {
                        return;
                    }
                    move_trigger = true;
                    grid_overlay.hide();
                    grid_col_move_insert.hide();
                    grid_col_move_tag.hide();
                    if (isNaN(complate) || isNaN(index) || complate === index || complate === index + 1) {
                        return;
                    }
                    if (index > complate) {
                        self._switchCol(index, complate);
                        complate = index = NaN;
                        return;
                    }
                    for (var i = index + 1; i < complate; i += 1) {
                        if (!col_hidden[i]) {
                            self._switchCol(index, complate);
                            complate = index = NaN;
                            break;
                        }
                    }

                });
                grid_overlay.on("mouseout", function () {
                    grid_overlay.hide();
                    grid_col_move_insert.hide();
                    grid_col_move_tag.hide();
                    complate = index = NaN;
                });
            }
        }
    });
})(window.comtop);