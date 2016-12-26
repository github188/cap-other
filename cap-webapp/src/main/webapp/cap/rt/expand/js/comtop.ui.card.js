/**
 * CardLayout
 * @author liangpei
 * @since 2016-6-13
 */
(function($, C) {
    'use strict';

    C.UI.CardLayout = C.UI.Base.extend({
        options: {
            uitype: "CardLayout",
            layoutMinWidth: "1000px",
            column: 1,
            datasource: null,
            primarykey: "ID",
            content: "",
            pageno: 1,
            pagesize: 5,
            pagesize_list: [5, 10, 25],
            custom_pagesize: false,
            pagination: true,
            pagination_model: 'pagination_min_1',
            addCard_callback: null,
            removeCard_callback: null,
            changeCard_callback: null,
            hideCard_callback: null,
            loadcomplate_callback: null
        },

        /**
         * 初始化参数和属性
         */
        _init: function() {
            var opts = this.options,
                content = opts.content,
                datasource = opts.datasource;
            //设置初始属性
            this.$el = opts.el;
            this.container = null;
            this.unRender = true;
            this.query = {
                pageSize: opts.pagesize,
                pageNo: opts.pageno,
                custom_pagesize: opts.custom_pagesize
            };

            //初始化pagesize
            this._setPageSize();

            if (typeof datasource === "string" && typeof window[datasource] === "function") {
                opts.datasource = window[datasource];
            }

            if (typeof content === "string" && typeof window[content] === "function") {
                opts.content = window[content];
            }
        },

        /**
         * 初始化方法
         * @private
         */
        _create: function() {
            var datasource = this.options.datasource;

            if (typeof datasource !== "function") {
                this.data = datasource;
            } else {
                datasource(this, this.getQuery());
            }

        },

        loadData: function() {
            this.options.datasource(this, this.getQuery());
        },

        /**
         * 设置数据源
         * @param {object} data - 数据对象
         * @param {number} totalSize - 数据条目总数
         * @param {boolean} render - 是否立即渲染
         * @public
         */
        setDatasource: function(data, totalSize) {
            data = data || [];
            totalSize = totalSize || 0;
            this.totalSize = totalSize;
            this.data = $.extend(true, [], data);

            this._renderCard();
        },

        _renderCard: function() {

            this._createContent();

            //处理分页
            if (this.options.pagination) {
                //第一次渲染,加载分页
                if (this.unRender) {
                    this._createFooter();
                    this.__createPagination();
                } else {
                    this._changepages();
                }
            }
            delete this.unRender;
        },

        _createFooter: function() {
            this.cardfoot = document.createElement("div");
            this.cardfoot.className = 'cardfoot';
            this.cardfoot.style.background = "#fff";
            this.cardfoot.style.height = "30px";
            this.cardfoot.style.padding = "10px 20px";
            this.$el[0].appendChild(this.cardfoot);
        },

        _createContent: function() {
            var self = this,
                colNum = self.options.column,
                content = self.options.content,
                container = this.$el.find(".cardLayout")[0],
                columns = [];

            if (container) {
                this.destroy();
            } else {
                container = document.createElement("div");
                container.className = 'cardLayout';
                container.style["min-width"] = self.options.layoutMinWidth;
                container.style.margin = "0 auto";
                container.style.overflow = "hidden";
                self.container = container;
                self.$el[0].appendChild(container);
            }


            if (typeof content === "function" && self.data.length > 0) {
                columns = self._createcolumns(container, colNum);
                self._createCard(content, columns, colNum)(self.data, self.options.primarykey);
            } else {
                self._createWarnCard(container, colNum);
            }
        },

        /**
         * 在container中设置Card列容器，并返回列DOM数组
         * @private
         */
        _createcolumns: function(container, colNum) {
            var columnWidth = (100 / colNum).toFixed(6) + '%',
                columns = [];

            for (var i = 0; i < colNum; i++) {
                var column = document.createElement("div");
                column.className = 'column';
                column.style.width = columnWidth;
                column.style.float = 'left';
                columns.push(column);
                container.appendChild(column);
            }
            return columns;
        },

        /**
         * 创建卡片
         * @private
         */
        _createCard: function(content, cols, colNum) {
            var columns = cols,
                num = colNum,
                content = content;

            return function(cards, key) {
                for (var i = 0; i < cards.length; i++) {
                    var card = $('<div>').addClass('card').css({
                        "box-sizing": "border-box",
                        "line-height": "100%",
                        "overflow": "hidden",
                        "background-color": "#fff"
                    }).html(content(cards[i]));
					
                    columns[(i % num)].appendChild(card[0]);
                }
            };
        },

        _createWarnCard: function(container, cols) {
            var msg = '本列表暂无数据',
                card = $('<div>').addClass('card').css({
                    "margin": "10px",
                    "padding": "10px",
                    "text-align": "center",
                    "height": "100px",
                    "line-height": "100px",
                    "border": "1px solid #ccc"
                }).html(msg);

            container.appendChild(card[0]);

        },

        /**
         * 设置pagesize
         * @private
         */
        _setPageSize: function() {
            var opts = this.options,
                query = this.query,
                pagesizeList = opts.pagesize_list,
                pageSize = query.pageSize;
            for (var i = pagesizeList.length; i--;) {
                if (pageSize === pagesizeList[i]) {
                    return;
                }
            }
            query.pageSize = pagesizeList[1];
        },

        setPagerText: function(text) {
            if (typeof text === "string") {
                this.customerText = text;
            }
        },

        /**
         * 渲染分页
         * @private
         */
        __createPagination: function() {
            var opts = this.options,
                query = this.query;
            if (!opts.pagination) {
                return;
            }
            var self = this;
            window.cui(this.cardfoot).pagination({
                count: this.totalSize,
                pagesize: query.pageSize,
                pageno: query.pageNo,
                pagesize_list: opts.pagesize_list,
                tpls: { pagination: opts.pagination_model },
                cls: opts.pagination_model,
                customerText: this.customerText,
                custom_pagesize: query.custom_pagesize,
                on_page_change: function(pageno, pagesize) {
                    query.pageNo = pageno;
                    query.pageSize = pagesize;
                    self.loadData();
                }
            });
            this.paginationObj = window.cui(this.cardfoot);
        },

        /**
         * 翻页事件
         * @private
         */
        _changepages: function() {
            var query = this.query;
            this.paginationObj.setInitData({
                custom_pagesize: query.custom_pagesize,
                count: this.totalSize,
                pagesize: query.pageSize,
                pageno: query.pageNo
            });
            this.paginationObj.reDraw();
        },

        destroy: function() {
            var container = this.$el.find(".cardLayout")[0];

            while (container && container.lastChild) {
                container.removeChild(container.lastChild);
            }
        },

        /**
         * 设置查询条件
         * @param {object} query - 查询对象.
         * @public
         */
        setQuery: function(query) {
            var q = this.query;
            for (var val in query) {
                if (q.hasOwnProperty(val)) {
                    q[val] = query[val];
                }
            }
        },

        /**
         * 获取查询条件
         * @public
         */
        getQuery: function() {
            return this.query;
        },

        /**
         * 新增卡片
         * @param {object} data - 数据对象
         * @public
         */
        addCard: function(data) {
            var opts = this.options;
            if (typeof opts.content === 'function') {
                this.container.appendChild(opts.content(data));
            }
            if (typeof opts.addCard_callback === "function") {
                opts.addCard_callback.call(this, data);
            }
        },

        /**
         * 删除卡片
         * @param {string} pk - 卡片主键
         * @public
         */
        removeCard: function(pk) {
            var card = $(this.container).find('[pkey="' + pk + '"]'),
                opts = this.options;

            if (card.length > 0) {
                card.remove();
            }
            if (typeof opts.removeCard_callback === "function") {
                opts.removeCard_callback.call(this, pk);
            }
        },

        /**
         * 修改卡片
         * @param {object} data - 数据对象
         * @param {string} pk - 卡片主键
         * @public
         */
        changeCard: function(data, pk) {
            var card = $(this.container).find('[pkey="' + pk + '"]');

            if (card.length > 0) {
                card.html(this.content(data));
            } else {
                this.addCard(data);
            }
            if (typeof changeCard_callback === "function") {
                this.changeCard_callback.call(this, data, pk);
            }
        },

        /**
         * 隐藏卡片
         * @param {string} pk - 卡片主键
         * @public
         */
        hideCard: function(pk) {
            var card = $(this.container).find('[pkey="' + pk + '"]');

            if (card.length > 0) {
                card.hide();
            }
            if (typeof hideCard_callback === "function") {
                this.hideCard_callback.call(this, pk);
            }
        },

        /**
         * 设置数据源
         * @param {string} pk - 卡片主键
         * @public
         */
        getData: function(pk) {
            var data = [];
            if (pk) {
                $.each(this.data, function(i, val) {
                    if (val[this.primarykey] === pk) {
                        data.push(val);
                        return;
                    }
                });
            } else {
                data = this.data;
            }
            return data;
        },

        /**
         * 设置卡片高亮
         * @param {string} pk - 卡片主键
         * @public
         */
        setHeighlight: function(pk) {

        }
    });
})(window.comtop.cQuery, window.comtop);
