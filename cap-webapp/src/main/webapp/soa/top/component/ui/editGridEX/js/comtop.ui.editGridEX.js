/**
 *
 * 分页组件
 *
 * @author 柯尚福
 * @since 2012-09-05
 *
 */

;(function($, C){

    /**
     * 分页组件抽象类
     */
    C.UI.BasePaginationEX = C.UI.Base.extend({

        _init: function(options){
            //$.extend({}, this.opitons, options);
            this.options.pagesize_list = typeof options.pagesize_list === 'string' ?
                this._convertTo(options.pagesize_list, 'object', [25,50,100]) :
                this.options.pagesize_list;
            this.$container = $(this.options.el);
            this.setInitData(this.options);
        },

        _create: function() {
            if(this.totalItems<=0) {
                this.$container.empty();
                return;
            }
            this.setInitData(this.options);
            this._calTotalPage();
            this._draw();
            this._bindEvent(this.$container);
        },

        _draw: function() {

        },

        _bindEvent: function(){

        },

        /**
         * 计算总共有多少页
         */
        _calTotalPage: function() {
            this.totalPage = Math.ceil(this.totalItems / this.itemsPerPage);
            if(this.currentPage >= this.totalPage){
                this.currentPage = this.totalPage;
            }
        },

        /**
         * 供外部调用的重绘
         */
        reDraw: function(){
            this._create();
            return this;
        },

        /**
         * 设置总记录数,供外部调用
         */
        setCount: function(count) {
            this.options.count = this.totalItems = count;
            return this;
        },

        /**
         * 废弃，但保留支持
         */
        setPagesize: function(pagesize) {
            return this.setPageSize(pagesize);
        },
        /**
         * 设置每页显示记录数,供外部调用
         * @param pagesize
         */
        setPageSize: function(pagesize){
            if(typeof pagesize !== 'number' || pagesize <= 0){
                return this;
            }
            var hasPS = false;
            for (var i = 0; i < this.options.pagesize_list.length; i++) {
                if(this.options.pagesize_list[i] === pagesize){
                    hasPS = true;
                    break;
                }
            }
            this.itemsPerPage = this.options.pagesize = pagesize;
            if(!hasPS){
                var psList = $.extend([], this.options.pagesize_list);
                psList.push(pagesize);
                psList.sort(sortNumber);
                psList.splice(3, 1);
                this.options.pagesize_list = psList
            }
            function sortNumber(a, b){
                return a - b;
            }
            this.reDraw();
            return this;
        },

        /**
         * 设置分页条所需的数据，包括总记录数，每页显示记录数，当前页码等
         */
        setInitData: function( data ){

            this.options = $.extend(true, this.options, data);
            if(data.pagesize_list){
                this.options.pagesize_list = data.pagesize_list;
            }
            data = this.options;

            this.totalItems = data.count != null ? data.count : null;
            this.itemsPerPage = data.pagesize != null ? data.pagesize : null;
            this.currentPage = data.pageno != null ? data.pageno : null;
            //判断数据的有效范围，并纠正
            this.currentPage = data.pageno = data.pageno < 1 ? 1 : data.pageno;
            this.itemsPerPage = data.pagesize = data.pagesize < 1 ? data.pagesize_list[1] : data.pagesize;

            //如果用户设置的pagesize不在pagesize_list内部，则在pagesize_list内部追加一个项
            var isAdd = true;
            for (var i = 0; i < data.pagesize_list.length; i++) {
                var item = data.pagesize_list[i];
                //过滤小于1的分页项
                if(item < 1){
                    data.pagesize_list.splice(i,1);
                    i --;
                    continue;
                }
                if(item === this.itemsPerPage){
                    isAdd = false;
                }
            }
            if(isAdd){
                data.pagesize_list.push(this.itemsPerPage);
                data.pagesize_list.sort(function(a, b){
                    return a - b;
                });
            }
            return this;
        },

        /**
         * 跳到某一页
         */
        go: function(num) {
            if(typeof num !== 'number'){
                return this;
            }
            if(num > this.totalPage){
                num = this.totalPage;
            }
            this.options.pageno = this.currentPage = num;
            this._click(num, this.itemsPerPage);
            return this;
        },

        /**
         * 跳到下一页
         */
        next: function() {
            if(this.currentPage === this.totalPage){
                return this;
            }
            this.currentPage ++;
            this.options.pageno = this.currentPage;
            this._click(this.currentPage, this.itemsPerPage);
            return this;
        },

        /**
         * 跳到上一页
         */
        prev: function() {
            if(this.currentPage === 1){
                return this;
            }
            this.currentPage --;
            this.options.pageno = this.currentPage;
            this._click(this.currentPage, this.itemsPerPage);
            return this;
        },

        /**
         * 获取分页组件当前处于第几页
         *
         * @return
         */
        getCurrentPage: function(){
            return this.currentPage;
        },

        /**
         *
         * @param list
         * @param pagesize
         */
        setPageSizeList: function(list, pagesize){
            if($.type(list) !== 'array'){
                return this;
            }
            if(typeof pagesize !== 'number' || pagesize <= 0){
                pagesize = this.options.pagesize;
            }
            this.options.pagesize_list = $.extend(true, this.options.pagesize_list, list);
            this.options.pagesize_list.splice(3);

            var hasPS = false;
            for(var i = 0; i < this.options.pagesize_list.length; i ++){
                if(this.options.pagesize_list[i] === pagesize){
                    hasPS = true;
                    break;
                }
            }
            this.itemsPerPage = this.options.pagesize = hasPS ? pagesize : this.options.pagesize_list[1];
            this.reDraw();
            return this;
        },

        /**
         * 点击某一页时执行函数
         *
         */
        _click: function(currentPage, itemsPerPage) {
            if(this.options.on_page_change){
                this.options.on_page_change.call(this, currentPage, itemsPerPage);
            }
            //this.reDraw();
        },

        /**
         * 设置每页显示多少条记录
         *
         */
        _setItemsPerPage: function(itemsPerPage) {
            this.itemsPerPage = itemsPerPage;
        }


    });


    C.UI.PaginationEX = C.UI.BasePaginationEX.extend({
        options: {
            uitype: 'PaginationEX',
            cls: 'paginationEX',
			template: 'gridEX.html',
            count: 0,        //总记录数
            display_page: 4, //分页条中间显示多少页
            pagesize: 25, //每页显示多少条
            pageno: 1, //当前在第几页
            pagesize_list: [25,50,100], //可选每页显示多少条
            on_page_change: null
        },

        _draw: function() {

            var displayPage = this.options.display_page;
            if(displayPage > this.totalPage) displayPage = this.totalPage;
            if(displayPage <= 3) displayPage = 3;

            var displayPreCount = Math.floor( (displayPage-1) / 2 ),
                displayNextCount = Math.ceil( (displayPage-1) / 2 );

            //为了均匀显示页数，不至于有时显示的页数过少，做的一些处理
            if(this.currentPage-2< displayPreCount) {
                displayNextCount = displayNextCount + displayPreCount - (this.currentPage-2);
            } else if(this.totalPage - this.currentPage-1 < displayNextCount)  {
                displayPreCount = displayPreCount + displayNextCount - (this.totalPage - this.currentPage-1);
            }
            //dispalyPreCount 最多显示(this.currentPage-1 )页
            if(displayPreCount > this.currentPage-1 ) {
                displayPreCount = this.currentPage-1;
            }
            //displayNextCount 最多显示(this.totalPage - this.currentPage) 页
            if(displayNextCount > this.totalPage - this.currentPage) {
                displayNextCount = this.totalPage - this.currentPage;
            }

            var toFirst = this.currentPage - displayPreCount,
                toLast = this.currentPage + displayNextCount;
            var data = {
                totalItems: this.totalItems,
                totalPage: this.totalPage,
                currentPage: this.currentPage,
                itemsPerPage: this.itemsPerPage,
                selectList: this.options.pagesize_list,
                displayPreCount: displayPreCount,
                displayNextCount: displayNextCount,
                toFirst: toFirst,
                toLast: toLast
            };

            this.$container.html(this._buildTemplateStr('paginationEX', data)).addClass(this.options.cls).addClass('cui');
            if(C.Browser.isQM && C.Browser.isIE) { //处理IE怪异模式的问题
                this.$container.addClass('paginationEX-qm');
            }

        },

        _bindEvent: function(){
            var _self = this, $ct = this.$container;
            //点击某一页
            $ct.find('[act="numPage"]').bind('click', function(){
                _self.go(parseInt($(this).text(), 10));
                return false;
            });
            //点击上一页
            $ct.find('[act="prevPage"]').bind('click', function(){
                _self.prev();
                return false;
            });
            //点击下一页
            $ct.find('[act="nextPage"]').bind('click', function(){
                _self.next();
                return false;
            });

            //跳到某一页
            $ct.find('[act="goPage"]').bind('click', go);

            //回车事件跳到某一页
            $ct.find('[act="cusPage"]').bind('keydown', function(event) {
                if(event.keyCode === 13){
                    go();
                }
            });

            //选择每页显示条数
            this.$container.find('[act="sizePage"]').bind('click', function(){
                _self._setItemsPerPage(parseInt($(this).text(), 10));
                _self._calTotalPage();
                _self.go(_self.currentPage);
                return false;
            });

            //跳到某一页执行函数
            function go() {
                var num = parseInt( _self.$container.find('.page-skip-num').val(), 10);
                if(isNaN(num) || num<=0 ) num = 1;
                if(num > _self.totalPage) num = _self.totalPage;
                _self.go(num);
                return false;
            }

        }


    });

})(window.comtop.cQuery, window.comtop);

/**
 * Created with JetBrains WebStorm.
 * User: wuxiaobing
 * Date: 12-11-17
 * Time: 下午4:08
 * To change this template use File | Settings | File Templates.
 */
;(function($, C) {
    C.UI.GridEX = C.UI.Base.extend({
        options: {
            uitype: "GridEX",                       //组件类别
            gridwidth: "600px",                   //组件宽度
            gridheight: "500px",                  //组件高度
            tablewidth: '',                       //表格宽度
            ellipsis: true,                       //文本过长是否自动截取
            primarykey: "ID",                     //主键
            allboxname: 'allbox',                 //为多选模式时全选按钮的名称
            checkboxname: 'idList',               //为多选或者单选模式时checkbox或radio的名称
            datasource: null,                     //数据源
            selectrows: "multi",                  //是否可以选择行multi/single/no
            sortstyle: 1,                         //支持几列题头排序
            sortname: [],                         //默认排序字段
            sorttype: [],                         //默认排序方式
            pageno: 1,                            //默认显示第几页
            pagesize: 50,                         //默认每页显示记录数
            adaptive: true,                       //表格是否自适应
            pagesize_list: [25, 50, 100],         //用户可选每页显示数据条数
            colrender: null,                      //单元格渲染
            colstylerender: null,                 //单元格样式渲染
            rowstylerender: null,                 //行样式渲染
            resizeheight: null,                   //自适应高度计算方法
            resizewidth: null,                    //自适应宽度计算方法
            fixcolumnnumber: 0,                   //锁定的列数
            oddevenrow: false,                    //是否显示奇偶色
            oddevenclass: 'cardinal_row',         //奇数行颜色样式
            selectedrowclass: 'selected_row',     //选中行样式名
            titlerender: null,                    //用户自定义title写法

            pagination: true,                     //是否使用分页组件
            loadtip: true,                          //是否使用加载提示
            pagination_model: 'paginationEX_min_1', //分页模板，可设置的值为pagination/pagination_min_1
            titlelock: true,                      //是否锁定题头
            colhidden: true,                      //是否使用列隐藏功能 OK
            adddata_callback: null,               //添加数据时回调函数
            removedata_callback: null,            //删除数据时回调函数
            rowclick_callback: null,              //点击行时的回调
            loadcomplate_callback: null,          //grid完成加载时的回调函数
            selectall_callback: null,             //全选按钮的回调函数

            on_dragstart: null,                   //拖动开始时的回调
            on_drag: null,                        //拖动中的回调
            on_dragend: null,                      //拖动结束时的回调
			template: 'gridEX.html'
        },

        /**
         * 初始化对象
         * @private
         */
        _init: function() {
            var self = this,
                opts = self.options;

            //查询条件
            self.query = {
                sortType: opts.sorttype || [],
                sortName: opts.sortname || [],
                pageSize: self._contains(opts.pagesize_list, opts.pagesize) >= 0 ?
                    opts.pagesize : (self.options.pagesize_list[1] || self.options.pagesize_list[0]),
                pageNo: opts.pageno > 1 ? opts.pageno : 1
            };

            self.id = C.guid();
            if (opts.gridwidth.indexOf("%") != -1) {
                opts.gridwidth = "500px";
            }

            //存储数据
            self.data = null;
            //表格头集合
            self.headList = [];
            //数据总条数
            self.totalSize = 0;
            //resize列宽参数
            self.widthConfig = {
                th: null,
                prevTh: null,
                x: 0,
                thWidth: 0,
                prevWidth: 0
            };
            //复合表头时记录表头层级关系
            self.thLayer = "th-layer";
            //临时存储过滤列
            self.tempFilterCols = {};
            //记录原始th宽度
            self.oriThWidth = [];
            //记录原始table宽度
            self.oriTableWidth = 0;
            //是否为复合题头
            self.complexHead = false;

            self.thListNum = [];


            //获取滚动条的宽度
            self.scrollWidth = opts.gridheight === 'auto' ? 0 : getScrollWidth();
        },

        /**
         * 生成模板
         * @private
         */
        _create: function() {
            var opts = this.options;
            this.$tablehead = opts.el;
            //解析表格头部;
            this._analyzeTable();

            //包装表格 ie6 15mm
            this._wrapTable();

            //渲染表头 ie6 31mm
            this._renderTHead();

            //创建菜单menu、数据在加载时的层以及拖动列宽时显示的基线  ie 32mm
            this._createDom();

            //添加事件
            this._addEventLisenter();

            //加载数据 ie6 3800mm(10*1000)
            this.loadData();
        },

        /************************************头部解析**********************************************/

        /**
         * 解析表格头，收集配置的表格属性
         * @private
         */
        _analyzeTable: function() {
            var self = this,
                opts = self.options,
                oldtable = opts.el;

            var headTrList = oldtable.find("tr");
            var headThList = null;
            if (headTrList.length === 1) {
                headThList = oldtable.find("th");
            } else {
                self.complexHead = true;
                headThList = this._getComplexHead(headTrList, 0);
            }

            $(headThList).each(function(i, item) {
                var head = {};
                var $item = $(item);
                head.bindName = $item.attr("bindName");
                head.render = $item.attr("render");
                head.renderStyle = $item.attr("renderStyle");
                head.format = $item.attr("format");
                head.text = $item.text();
                head.el = item;
                self.headList.push(head);
            });
        },

        _getComplexHead: function(headTrList, trNum) {
            var thList = $(headTrList[trNum]).children("th");
            var headThList = [];
            for (var i = 0; i < thList.length; i++) {
                var currColspan = $(thList[i]).attr("colspan");
                //记录层级关系
                $(thList[i]).attr(this.thLayer, "lay-" + i);
                if (currColspan && parseInt(currColspan) > 1) {
                    this._getSubHead(headTrList, trNum + 1, parseInt(currColspan), headThList, "lay-" + i);
                } else {
                    headThList.push(thList[i]);
                }
            }
            return headThList;
        },

        _getSubHead: function(headTrList, trNum, colspan, headThList, thLayer) {
            var thList = $(headTrList[trNum]).children("th");
            var sumColspan = 0;
            var thNum = 0;
            if (this.thListNum[trNum]) {
                thNum = this.thListNum[trNum] + 1;
            }
            for (var i = thNum; i < thList.length; i++) {
                var currColspan = $(thList[i]).attr("colspan");
                //记录层级关系
                $(thList[i]).attr(this.thLayer, thLayer + "-" + i);
                if (currColspan && parseInt(currColspan) > 1) {
                    this._getSubHead(headTrList, trNum + 1, parseInt(currColspan), headThList, thLayer + "-" + i);
                } else {
                    headThList.push(thList[i]);
                }
                sumColspan += currColspan ? parseInt(currColspan) : 1;
                this.thListNum[trNum] = i;
                if (sumColspan == colspan) {
                    break;
                }
            }
        },

        /******************************************表格渲染***************************************/

        /**
         * 包装表格
         * @private
         */
        _wrapTable: function() {
            var self = this,
                opts = self.options,
                oldtable = opts.el;

            //计算表格组件外包容器宽高
            if (opts.resizewidth) {
                opts.gridwidth = opts.resizewidth();
            }
            if (opts.resizeheight) {
                opts.gridheight = opts.resizeheight();
            }

            //包装表格原始table
            var wrapWidth, wrapHeight, boxHeight;
            wrapWidth = parseFloat(opts.gridwidth) + "px";
            if(opts.gridheight !== 'auto'){
                wrapHeight = parseFloat(opts.gridheight) + "px";
                boxHeight = parseFloat(opts.gridheight) - (opts.pagination ? 40 : 0) + "px";
            }else{
                wrapHeight = 'auto';
                boxHeight = 'auto';
            }
            //添加position:relative解决IE6下，grid受父级align="center"的影响
            var tableWrap = [
                '<div id="', self.id, '_wrap" class="cui_gridEX_wrap" style="', (C.Browser.isIE6 ? "position:relative;" : ""),
                'width:', wrapWidth, ';height:', wrapHeight, ';',
                opts.gridheight == 'auto' ? 'border-width:1px;' : '' ,'">',
                '<div id="', self.id, '_box" class="gridEX_list_box" style="width:', wrapWidth, ';height:', boxHeight, '">',
                '<div id="', self.id, '_tableData" class="cui_gridEX_tableData" style="width:', wrapWidth, ';height:', boxHeight, '">',
                '</div></div>'
            ];
            oldtable.after(tableWrap.join(''));

            //获取wrap与box对象
            self.$tableWrap = $("#"+self.id+"_wrap");
            self.$tableBox = $("#"+self.id+"_box");
            self.$tableData = $("#" + self.id + "_tableData");
            self.$tableData.append(oldtable);

            self.$tableWrap.show();

            var thList = self.headList,
                isSetThWidth = $(thList[0].el).width() == 0;
            //缓存列原始宽度
            $.each(thList, function(i, item) {
                if (isSetThWidth) {
                    self.oriThWidth.push(150);
                } else {
                    self.oriThWidth.push($(item.el).width());
                }
            });

            if (opts.adaptive || (opts.tablewidth === '' && isSetThWidth)) {
                var tableWidth = parseFloat(opts.gridwidth) - self.scrollWidth;
                oldtable.width(tableWidth);
            } else if (opts.tablewidth !== '') {
                oldtable.width(opts.tablewidth);
            }
            if (isSetThWidth) {
                var thWidth = oldtable.width()/thList.length;
                $.each(thList, function(i, item) {
                    var $th = $(item.el);
                    $th.width(thWidth - 1);
                });
            } else if (opts.adaptive) {
                var widthList = [],
                    totalWidth = 0,
                    tableWidth = parseFloat(opts.gridwidth) - self.scrollWidth;
                $.each(thList, function(i, item) {
                    var thWidth = $(item.el).width();
                    widthList.push(thWidth);
                    totalWidth += thWidth;
                });
                $.each(thList, function(i, item) {
                    $(item.el).width(widthList[i] * tableWidth / totalWidth - 1);
                });
            }

            self.oriTableWidth = oldtable.width();
        },

        /**
         * 渲染表头
         * @private
         */
        _renderTHead: function() {
            var self = this,
                opts = self.options,
                headList = self.headList;

            $.each(headList, function(i, head) {
                var item = head.el;
                if (i == 0 && opts.selectrows == "multi") {
                    var $input = $(item).find(":checkbox");
                    $input.attr("name", opts.allboxname);
                } else if (i != 0 || opts.selectrows != "single") {
                    var $item = $(item);
                    var $itemHtml = $item.html();

                    var tHeadDiv = self._buildTemplateStr("gridHeadRender", {
                        headSpanSort: $item.attr("sort") == "true" ? "head_sp_sort" : "",
                        text: $itemHtml,
                        bindName: head.bindName
                    });
                    $item.html(tHeadDiv);
                    if($.trim($itemHtml) !== ''){
                        $item.attr('title', $.trim($.trim($itemHtml).replace(/<.*?>/g,'')));
                    }

                    //判断是否有初始化题头排序
                    var index = self._contains(self.query.sortName, head.bindName);
                    if (index != -1) {
                        //添加排序图标
                        var sortName = self.query.sortName[index];
                        var sortType = self.query.sortType[index];
                        if (!sortType) {
                            sortType = 'DESC';
                            self.query.sortType[index] = sortType;
                        }
                        self._createImg(sortName, sortType, $item.find("span"));
                    }
                }
                if (opts.ellipsis) {
                    $(item).find("p").css({
                        "cursor" : "col-resize"
                    });
                }
            });
        },

        /**
         * 渲染表格body
         * @private
         */
        _renderTBody: function() {
            var self = this,
                opts = self.options,
                oldtable = opts.el,
                data = self.data;

            var tBodyIn = [];
            if (!data || data.length == 0) {
                //获取页脚模板
                tBodyIn.push(self._buildTemplateStr("emptyRow", $.extend({}, opts, {emptycolspan: self.headList.length, id:self.id})));
            } else {
                //ie6 1290mm(10*1000)
                for (var i = 0; i < data.length; i++) {
                    tBodyIn.push(self._renderRow(data[i], i));
                }
            }

            tBodyIn = tBodyIn.join('');
            if (self.$tBody) {
                //ie6 6000(10*1000)
                self.$tBody.html(tBodyIn); //TODO 寻求优化
            } else {
                self.$tBody = $('<tbody></tbody>').append(tBodyIn);
                //将表格体插入文档
                oldtable.append(self.$tBody);
                if(C.Browser.isIE && opts.selectrows !== 'no'){
                    //IE浏览器，对于页面缓存时造成的勾选，自动加上样式
                    $(window).bind('load', function(){
                        self._reChecked();
                    });
                }
            }
        },

        _reChecked: function(){
            var self = this;
            var opts = this.options;
            var $chked = self.$tableBox.find(':checked');
            if(opts.fixcolumnnumber){
                var $chkedFix = self.$tableColumnClone.find(':checked');
            }
            for(var ck = 0; ck < $chked.length; ck ++){
                $chked.eq(ck).parents('tr:eq(0)').addClass(opts.selectedrowclass);
                if(opts.fixcolumnnumber){
                    $chkedFix.eq(ck).parents('tr:eq(0)').addClass(opts.selectedrowclass);
                }
            }
            $chked = undefined;
            $chkedFix = undefined;

        },

        /**
         * 调整表格
         */
        _adjustTable: function() {
            var self = this,
                opts = self.options;
            if (opts.colhidden) {
                //隐藏被隐藏的列
                $.each(self.$subPopMenu.find("input"), function(i, item) {
                    if (!item.checked) {
                        self._filterCols(item);
                    }
                });
            }

            //去掉全选按钮勾选
            var $allBox = $("input[name='"+opts.allboxname+"']", self.$tableWrap);
            if ($allBox && $allBox.length > 0) {
                $allBox.attr("checked", false);
            }

            self._createTableFix();
        },

        /**
         * 生成固定列和锁定题头
         */
        _createTableFix: function() {
            var self = this,
                opts = self.options,
                oldtable = opts.el;

            var headHeight = 0;
            if(opts.titlelock){
                //题头锁定
                if (!self.$tableHead) {
                    var tableHeadHtml = [
                        '<div id="', self.id, '_tableHead" class="cui_gridEX_tableHead">',
                        '<table id="', self.id ,'_tableHeadClone" class="cui_gridEX_list" style="width:',
                        oldtable.width() ,'px;"></table></div>'
                    ];
                    self.$tableBox.append(tableHeadHtml.join(''));

                    self.$tableHead = $("#" + self.id + "_tableHead");
                    self.$tableHead.width(self.$tableData[0].clientWidth);

                    self.$tableHeadClone = $("#" + self.id + "_tableHeadClone");
                    var tableHeadClone = oldtable.children("thead").clone(true);
                    self.$tableHeadClone.append(tableHeadClone);

                    headHeight = tableHeadClone.height();


                    self.$tableHeadClone.height(headHeight);
                    self.$tableHead.height(headHeight + 1);

                    self.$tableHead.css('visibility', 'visible');
                    self.$tableHeadClone.css('visibility', 'visible');

                    self.$tableData.scroll(function () {
                        self.$tableHead.scrollLeft(self.$tableData.scrollLeft());
                    });

                    //容器定位
                    var offset = self.$tableBox.offset();
                    self.$tableData.offset(offset);
                } else {
                    self.$tableHead.width(self.$tableData[0].clientWidth);
                }
            }

            //列锁定
            var columnsWidth = 0;
            if (opts.fixcolumnnumber > 0 && !self.$tableColumn) {
                //创建列投影
                var tableColumnHtml = [
                    '<div id="', self.id, '_tableColumn" class="cui_gridEX_tableColumn"',
                    'style="height:', self.$tableData[0].clientHeight, 'px"></div>'
                ];
                self.$tableBox.append(tableColumnHtml.join(''));
                self.$tableColumn = $("#" + self.id + "_tableColumn");

                //去掉复制后的uitype，防止多次扫描而重复实例化组件
                var tableColumnClone = oldtable.clone(true).removeAttr('uitype');
                tableColumnClone.attr("id", self.id + "_tableColumnClone");

                self.$tableColumn.append(tableColumnClone);
                self.$tableColumnClone = tableColumnClone;

                self.$tableColumn.css('visibility', 'visible');
                self.$tableColumnClone.css('visibility', 'visible');

                //设定列锁定投影容器宽度
                columnsWidth = self._getColumnWidth();
                self.$tableColumn.width(columnsWidth);
                //设置同步滚动
                self.$tableData.scroll(function () {
                    self.$tableColumn.scrollTop(self.$tableData.scrollTop());
                });
            } else if (opts.fixcolumnnumber > 0) {
                var tbodyClone = oldtable.find("tbody").clone(true);
                self.$tableColumnClone.children("tbody").replaceWith(tbodyClone);
                self.$tableColumn.height(self.$tableData[0].clientHeight);
            }

            if (self.$tableHead && self.$tableColumn && !self.$tableFix) {
                //创建题头行列交叉投影
                var tableFixHtml = [
                    '<div id="', self.id, '_tableFix" class="cui_gridEX_tableFix" style="width:', self.$tableHead.width(), 'px;">',
                    '<table id="', self.id, '_tableFixClone" class="cui_gridEX_list" style="width:',
                    oldtable.width(), 'px"></table></div>'
                ];
                self.$tableBox.append(tableFixHtml.join(''));

                self.$tableFix = $("#" + self.id + "_tableFix");
                self.$tableFixClone = $("#" + self.id + "_tableFixClone");


                var tableFixClone = oldtable.children("thead").clone(true);
                self.$tableFixClone.append(tableFixClone);

                self.$tableFixClone.height(headHeight);
                self.$tableFix.height(headHeight + 1);

                self.$tableFix.css('visibility', 'visible');
                self.$tableFixClone.css('visibility', 'visible');

                //设定题头交叉投影容器宽度
                self.$tableFix.width(columnsWidth);
            }

            //创建事件
            if (!self.resizeFlag) {
                $(window).bind('resize.grid', function(){
                    self.resize();
                });
                self.resizeFlag = true;
            }
        },

        _resizeGrid: function(resizeWidth) {
            var self = this,
                opts = self.options,
                oldtable = opts.el;

            self.$tableHead && self.$tableHead.hide();

            var thList = self.headList,
                showThList = [],
                widthList = [],
                totalWidth = 0,
                tableWidth = self.oriTableWidth = resizeWidth - self.scrollWidth;
            oldtable.width(tableWidth);
            $.each(thList, function(i, item) {
                var th = item.el,
                    $th = $(th);
                if ($th.css("display") != "none") {
                    var thWidth = self.oriThWidth[i];
                    widthList.push(thWidth);
                    totalWidth += thWidth;
                    showThList.push(th);
                }
            });
            $.each(showThList, function(i, item) {
                $(item).width(widthList[i] * tableWidth / totalWidth - 1);
            });

            var oldtableThead = oldtable.children("thead");
            if (opts.titlelock) {
                self.$tableHeadClone.children("thead").replaceWith(oldtableThead.clone(true));
                self.$tableHeadClone.width(tableWidth);
            }

            var columnsWidth = 0;
            if (self.$tableColumn) {
                self.$tableColumnClone.width(tableWidth);
                self.$tableColumnClone.children("thead").replaceWith(oldtableThead.clone(true));

                columnsWidth = self._getColumnWidth();
                self.$tableColumn.width(columnsWidth);
                self.$tableColumn.height(self.$tableData[0].clientHeight);
            }
            if (self.$tableFix) {
                self.$tableFixClone.width(tableWidth);
                self.$tableFixClone.children("thead").replaceWith(oldtableThead.clone(true));
                self.$tableFix.width(columnsWidth);
            }

            if (opts.titlelock) {
                self.$tableHead.show();
            }
            setTimeout(function() {
                if (opts.titlelock) {
                    self.$tableHead.offset(self.$tableBox.offset());
                }
                if (self.$tableFix) {
                    self.$tableFix.offset(self.$tableBox.offset());
                }
            }, 10);
        },

        /**
         *
         * @return {Number}
         * @private
         */
        _getColumnWidth: function() {
            var self = this,
                opts = self.options,
                columnsWidth = 0,
                columnsNumber = 0;

            var $td = $("#" + self.id + "_tableData thead>tr>th:lt(" + opts.fixcolumnnumber + ")");
            //var $td = $("#" + self.id + "_tableColumn tr:last td:lt(" + opts.fixcolumnnumber + ")");
            //这里的outerWidth在IE下测及到一个性能问题
            for(var i = 0; i < $td.length; i ++){
                //columnsWidth += $(this).width(true);//有性能问题
                if($td.eq(i)[0].style.display == "none") continue;
                columnsWidth += ($td.eq(i)[0].clientWidth || $td.eq(i)[0].offsetWidth) + 1;
                columnsNumber++;
            }

            if(C.Browser.isIE8 && columnsNumber >= 3){
                columnsWidth++;
            }
            return columnsWidth;
        },

        _getGridRow: function(options){
            var rowIndex = options.rowIndex,
                canSelect = options.selectrows == "multi" || options.selectrows == "single",
                isCardinal = rowIndex % 2 == 0,
                innerHtml = options.innerHtml,
                pKey = options.pKey,
                rowStyle = options.rowStyle;
            var html = [];
            if (canSelect) {
                if (!isCardinal && options.oddevenrow) {

                    html = [
                        '<tr pKey="', pKey ,'" rowIndex="', rowIndex,'" events="click=_rowClickHandler" class="',
                        options.oddevenclass,'" style="',rowStyle,'">'
                    ];

                } else {

                    html = [
                        '<tr pKey="', pKey ,'" rowIndex="',rowIndex,'" events="click=_rowClickHandler" style="',rowStyle,'">'
                    ];

                }
            } else {
                if (!isCardinal && options.oddevenrow) {

                    html = [
                        '<tr pKey="', pKey ,'" rowIndex="',rowIndex,'" class="',options.oddevenclass,'" style="',rowStyle,'">'
                    ];

                } else {

                    html = [
                        '<tr pKey="', pKey ,'" rowIndex="',rowIndex,'" style="',rowStyle,'">'
                    ];

                }
            }

            html.push(innerHtml, '</tr>');
            return html.join('');
        },
        /**
         * 单行渲染
         * @param rowData 数据
         * @param index 第几行
         * @private
         */
        _renderRow: function(rowData, index) {
            var opts = this.options,
                headList = this.headList,
                rowStyleRender = opts.rowstylerender;

            var trInnerHtml = [];
            for (var i = 0; i < headList.length; i++) {
                trInnerHtml.push(this._renderCol(headList[i], i, opts, rowData, index));
            }

            var rowStyle = "";
            if (rowStyleRender) {
                var style = "";
                if ($.type(rowStyleRender) == "string" && window[rowStyleRender]) {
                    style = window[rowStyleRender](rowData);
                } else if ($.type(rowStyleRender) == "function") {
                    style = rowStyleRender(rowData);
                }
                if (style) {
                    rowStyle = style;
                }
            }
            var params = $.extend({}, opts,
                {
                    innerHtml: trInnerHtml.join(''),
                    pKey: rowData[opts.primarykey],
                    rowIndex: index,
                    rowStyle: rowStyle
                }
            );
            //优化 弃用模板 this._buildTemplateStr("gridRow", params);
            var tr = this._getGridRow(params);
            tr = this._bindTplEvent(tr);
            return tr;
        },

        _getGridColHTML: function(options){
            var rowData = options.rowData,
                rowIndex = options.rowIndex,
                renderStyle = options.renderStyle,
                idData = rowData[options.primarykey];
            var html = [];
            if (options.selectrows == "multi") {
                html = [
                    '<td style="', renderStyle, ';text-align: center;">',
                    '<input pKey="', idData,'" rowIndex="',
                    rowIndex, '" type="checkbox" id="', new Date().getTime(),
                    '" events="click=_inputClickHandler" name="', options.checkboxname , '" /></td>'
                ];
            } else if (options.selectrows == "single") {
                html = [
                    '<td style="', renderStyle,';text-align: center;">',
                    '<input pKey="',idData,'" rowIndex="',rowIndex,
                    '" type="radio" events="click=_inputClickHandler" name="',options.checkboxname,'"/></td>'
                ];
            }
            return html.join('');
        },

        /**
         * 渲染单元格
         * @param col 单元格属性
         * @param i 第几个单元格
         * @param opts 配置信息
         * @param rowData 行数据
         * @param index 第几行
         * @return {String}
         * @private
         */
        _renderCol: function(col, i, opts, rowData, index) {
            var self = this,
                selectRows = opts.selectrows,
                renderStyle = col.renderStyle;
            if (renderStyle == "undefined" || renderStyle == null) {
                renderStyle = "";
            }
            var td = "";
            if (i == 0 && (selectRows == "multi" || selectRows == "single")) {
                var params = $.extend({}, opts, {
                    rowData: rowData,
                    renderStyle: renderStyle,
                    rowIndex: index
                });
                //性能优化，去除模板生成 self._buildTemplateStr("gridCol", params);
                td = self._getGridColHTML(params);
                td = self._bindTplEvent(td);
            } else {
                var bnList;
                var colValue = null;
                //支持.写法
                if(typeof col.bindName === 'string' && (bnList = col.bindName.split('.')).length > 1){
                    for(var bn = 0; bn < bnList.length; bn ++){
                        colValue = colValue == null ? rowData[bnList[bn]] : colValue[bnList[bn]];
                    }
                }else{
                    colValue = rowData[col.bindName];
                }
                //格式化数据
                if (colValue == null || colValue == "undefined" || colValue === "") {
                    colValue = "";
                } else if (col.format) {
                    if (/money/.test(col.format)) {
                        var moneyLength = col.format.match(/money-(\d*)/);
                        //colValue = currencyFormat(colValue - 0, moneyLength ? moneyLength[0] : 0);
                        colValue = C.Number.money(colValue - 0, moneyLength ? moneyLength[1] - 0 : 2);
                    } else if ($.type(colValue) == 'date') {
                        colValue = C.Date.format(colValue, col.format);
                    }
                }
                var innerHtml = "&nbsp;" + colValue;

                //用户自定义渲染单元格
                var colsRender = opts.colrender;
                if (col.render) {
                    innerHtml = self._getRenderMode(rowData, col, index);
                    if (innerHtml === "") {
                        innerHtml = "&nbsp;" + colValue;
                    }
                } else if (colsRender) {
                    var tempHtml = "";
                    if ($.type(colsRender) === "string" && window[colsRender]) {
                        tempHtml = window[colsRender](rowData, col.bindName, col, index);
                    } else if ($.type(colsRender) === "function") {
                        tempHtml = colsRender(rowData, col.bindName, col, index);
                    }
                    if (tempHtml) {
                        innerHtml = tempHtml;
                    }
                }

                //用户自定义渲染title
                var title = colValue,
                    titleRender = opts.titlerender;

                //如果是自定义渲染单元格，则要去掉HTML标签，获取文字
                if((col.render || colsRender) && !titleRender){
                    //title = innerHtml.replace(/<\/?[!\w\-:]+(\s+\w+\s*(=\s*(\'[^\']*\'|\"[^\"]*\"))*)*\/?\s*>/g,'');
                    title = innerHtml.replace(/<.*?>/g,'');
                }

                if (titleRender) {
                    var tempTitle = "";
                    if ($.type(titleRender) === "string" && window[titleRender]) {
                        tempTitle = window[titleRender](rowData, col.bindName);
                    } else if ($.type(titleRender) === "function") {
                        tempTitle = titleRender(rowData, col.bindName);
                    }
                    if (tempTitle) {
                        title = tempTitle;
                    }
                }

                //用户自定义单元格样式渲染
                var colStyleRender = opts.colstylerender;
                if (colStyleRender) {
                    var colStyle = "";
                    if ($.type(colStyleRender) === "string" && window[colStyleRender]) {
                        colStyle = window[colStyleRender](rowData, col.bindName, index);
                    } else if ($.type(colStyleRender) === "function") {
                        colStyle = colStyleRender(rowData, col.bindName, index);
                    }
                    if (colStyle) {
                        renderStyle += (renderStyle === "" ? "" : ";") + colStyle;
                    }
                }
                if (col.render && (col.render === "image" || col.render === "button")) {
                    renderStyle += (renderStyle === "" ? "" : ";") + "text-align:center";
                }
                //title去除 ><" 在种字符串，避免影响DOM结构生成
                if(typeof title === 'string'){
                    title = title.replace(/>/g, '＞').replace(/</g, '＜').replace(/"/g, '＂');
                }
                td = ['<td style="', renderStyle ,'"', (opts.ellipsis ? ' class="ellipsis"' : ''),
                    ($.trim(title) === '' ? '' : (' title="' + title + '"')) , '>', innerHtml, '</td>'];
                td = td.join('');
            }
            return td;
        },

        _getGridRenderMode: function(options){
            var renderMode = options.renderMode,
                rowData = options.rowData,
                col = options.col,
                value = options.value ? options.value : rowData[col.bindName],
                rowIndex = options.rowIndex;
            var html = [];
            if (renderMode === "image") {
                var url = options.url,
                    relation = options.relation ? options.relation : col.bindName,
                    compare = options.compare,
                    title = options.title,
                    data = rowData[relation];
                if (compare) {
                    url = compare[data];
                }
                if (title) {
                    if (comtop.cQuery.type(title) != "string") {
                        title = title[data];
                    }
                } else {
                    title = data;
                }
                html = [
                    '<img src="',url,'"  title="',title,'" on_click="',options.click,
                    '" class="',options.className,'" events="click=_renderClick" rowIndex="', rowIndex,'"/>'
                ];

            } else if (renderMode === "button") {
                html = [
                    '<input type="button" value="',value,'" on_click="',options.click,'" class="',
                    options.className,'" events="click=_renderClick" rowIndex="',rowIndex,'">'
                ];

            } else if (renderMode === "a") {
                var conditions = "",
                    params = options.params,
                    url = options.url,
                    target = options.targets;
                if (params) {
                    params = params.split(";");
                    for (var i = 0; i < params.length; i++) {
                        conditions += (conditions === "" ? "" : "&") + (params[i] + "=" + rowData[params[i]]);
                    }
                }
                if (url && conditions) {
                    var idx = options.url.lastIndexOf("?");
                    if (idx != -1) {
                        if (idx == url.length - 1) {
                            url += conditions;
                        } else {
                            url += "&" + conditions;
                        }
                    } else {
                        url += "?" + conditions;
                    }
                }
                if (!target) {
                    target = "_self";
                }
                html = [
                    '<a href="',url,'" target="',target,'" on_click="',options.click,'" class="',options.className,
                    '" events="click=_renderClick" rowIndex="',rowIndex,'">',value,'</a>'
                ];
            }
            return html.join('');
        },

        /**
         * 获取默认渲染模式
         * @param rowData
         * @param col 表头单元格对象
         * @param index
         * @return {*}
         * @private
         */
        _getRenderMode: function(rowData, col, index) {
            var opts = this.options;

            var modelHtml = "";
            if (window[col.render]) {
                modelHtml = window[col.render](rowData, index, col);
            } else {
                var params = $.extend({}, opts, {
                    renderMode: col.render,
                    rowData: rowData,
                    col: col,
                    rowIndex: index
                });
                if (col.renderOptions) {
                    params = $.extend(params, col.renderOptions);
                } else {
                    var el = col.el,
                        rOptions = $(el).attr("options"),
                        jsonReg = /^(?:\{.*\}|\[.*\])$/;
                    if (rOptions && jsonReg.test(rOptions)) {
                        rOptions = $.parseJSON(rOptions.replace(/\\'/g, '#@@#').replace(/'/g, '"').replace(/#@@#/g, '\''));
                        params = $.extend(params, rOptions);
                        col.renderOptions = rOptions;
                    }
                }
                //优化 弃用模板 this._buildTemplateStr("gridRenderMode", params);
                var tempModeHtml = this._getGridRenderMode(params);
                tempModeHtml = this._bindTplEvent(tempModeHtml);
                if (tempModeHtml != "") {
                    modelHtml = tempModeHtml;
                }
            }
            return modelHtml;
        },

        /**
         * 渲染页脚
         * @private
         */
        _renderTFoot: function() {
            var self = this,
                opts = self.options;

            //将页脚模板并插入文档
            var tFoot = self._buildTemplateStr("tFootDom", opts);
            self.$tFoot = $(tFoot).insertAfter(self.$tableBox);
        },

        /**
         * 根据bindName获取对应的列
         * @param bindName
         * @return {*}
         * @private
         */
        _readHead: function(bindName) {
            var headList = this.headList;
            for (var i = 0; i < headList.length; i++) {
                var head = headList[i];
                if (head.bindName == bindName) {
                    return {idx: i, elem: head};
                }
            }
            return null;
        },

        /**
         * 过滤列
         * @param obj
         * @private
         */
        _filterCols: function(obj) {
            var self = this,
                opts = self.options,
                thText = $(obj).attr("textValue"),
                oldtable = self.options.el,
                headList = self.headList,
                idx = -1,
                thObj = null;
            for (var i = 0; i < headList.length; i++) {
                var head = headList[i];
                if ($.trim(head.text) == $.trim(thText)) {
                    idx = i;
                    thObj = head.el;
                }
            }

            if (idx != -1) {
                if (obj.checked) {
                    $(thObj).show();
                } else {
                    $(thObj).hide();
                }
                self._showComplexTitle(thObj, obj.checked, oldtable.find("thead"));

                self.$tBody.find("tr").each(function(i, tr) {
                    var targetTd = $(tr).children("td").get(idx);
                    if (obj.checked) {
                        $(targetTd).show();
                    } else {
                        $(targetTd).hide();
                    }
                });

                //更新浮动表头
                var oldtableThead = oldtable.children("thead"),
                    oldtableWidth = oldtable.width();
                if (opts.titlelock) {
                    self.$tableHeadClone.width(oldtableWidth);
                    self.$tableHeadClone.html(oldtableThead.clone(true));
                }
                var columnsWidth = 0;
                if (self.$tableColumn) {
                    self.$tableColumnClone.html(oldtable.html());
                    columnsWidth = self._getColumnWidth();
                    self.$tableColumn.width(columnsWidth);
                }
                if (self.$tableFix) {
                    self.$tableFixClone.width(oldtableWidth);
                    self.$tableFixClone.html(oldtableThead.clone(true));
                    self.$tableFix.width(columnsWidth);
                }
            }
        },

        /**
         * 处理复合表头
         * @param head 当前表头
         * @param isShow 是否显示
         * @param thead 所属thead
         * @private
         */
        _showComplexTitle: function(head, isShow, thead) {
            var thLayer = $(head).attr(this.thLayer);
            if (thLayer) {
                thLayer = thLayer.substring(0, thLayer.lastIndexOf("-"));
                var parent = $("th["+this.thLayer+"='"+thLayer+"']", thead);
                while(parent[0]) {
                    if (isShow) {
                        var colspan = parent.attr("colspan");
                        if (!colspan) colspan = 1;
                        parent.attr("colspan", parseInt(colspan) + 1);
                        parent.show();
                    } else {
                        parent.attr("colspan", parseInt(parent.attr("colspan")) - 1);

                        //判断是否需要隐藏父表头
                        var childrens = $("th["+this.thLayer+"*='"+thLayer+"-']", thead);
                        var flag = true;
                        for (var i = 0; i < childrens.length; i ++) {
                            if (childrens[i].style.display != "none") {
                                flag = false;
                                break;
                            }
                        }
                        if (flag) {
                            parent.hide();
                        }
                    }
                    thLayer = thLayer.substring(0, thLayer.lastIndexOf("-"));
                    parent = $("th["+this.thLayer+"='"+thLayer+"']", thead);
                }
            }
        },

        /**
         * 页面跳转与翻页
         * @param pageNo 页号
         * @param pageSize 每页显示条数
         * @private
         */
        _changePage: function(pageNo, pageSize) {
            this.query.pageNo = pageNo;
            this.query.pageSize = pageSize;

            this.loadData();
        },

        /**
         * 重置排序图标
         * @private
         */
        _resetSortIcon: function(){
            var self = this;
            if($.type(self.query.sortName) == 'array' && $.type(self.query.sortType) == 'array'){
                var $spSort = $('#' + self.id + '_wrap span.head_sp_sort');
                $spSort.children('em').remove();

                for(var i = 0, len = self.query.sortName.length; i < len; i ++){
                    switch(self.query.sortType[i].toLocaleUpperCase()){
                        case 'ASC':
                            this._createImg(self.query.sortName[i], 'ASC',
                                $spSort.filter('[bindName="'+ self.query.sortName[i] +'"]'));
                            break;
                        case 'DESC':
                            this._createImg(self.query.sortName[i], 'DESC',
                                $spSort.filter('[bindName="'+ self.query.sortName[i] +'"]'));
                            break;
                    }
                }
            }
        },

        /**
         * 题头排序
         * @param obj 点击的对象
         * @param strSortName 名称
         * @param strSortType 排列顺序
         */
        _sortTitle: function(obj, strSortName, strSortType) {
            var opts = this.options,
                sortStyle = opts.sortstyle;

            var sortName = this.query.sortName;
            var sortType = this.query.sortType;
            if (!strSortType && strSortType != "DESC" && strSortType != "ASC") {
                strSortType = "DESC";
            }

            //判断排序是否已满
            var index = this._contains(sortName, strSortName);
            if (index != -1) {//该列存在排序记录
                var currSortType = sortType[index];
                if (currSortType == "ASC" || currSortType == "asc") {
                    sortType[index] = "DESC";
                } else {
                    sortType[index] = "ASC";
                }
                this._changeImg(strSortName, sortType[index]);
            } else {//该列不存在排序记录
                //添加排序图标
                this._createImg(strSortName, strSortType, obj);

                if (sortName.length == sortStyle) {//排序数组已经存满
                    //移除最先加入的排序信息且移除排序图标
                    $('span.head_sp_sort em[name="' + sortName[0] + '_sort_icon"]', this.$tableBox).remove();
                    sortName.splice(0, 1);
                    sortType.splice(0, 1);
                    //将新的排序信息添加到队列的末尾
                    sortName[sortStyle - 1] = strSortName;
                    sortType[sortStyle - 1] = strSortType;
                } else {//排序数组未满
                    sortName[sortName.length] = strSortName;
                    sortType[sortType.length] = strSortType;
                }
            }

            this.loadData();
        },

        /**
         * 添加排序图片
         * @param sortName
         * @param sortType
         * @param obj
         * @private
         */
        _createImg: function(sortName, sortType, obj) {
            var className = sortType == "DESC" ? "gridEX_sort_title_down" : "gridEX_sort_title_up";
            var iconHtml = "<em class='" + className + "' name='"+sortName+"_sort_icon'></em>"
            var self = this;
            //清空前排序图标
            $("th[bindName='" + sortName + "'] span.head_sp em", self.$tableBox).remove();
            //为隐藏的题头添加题头
            $(iconHtml).appendTo($("th[bindName='" + sortName + "'] span.head_sp", self.$tableBox));
        },

        /**
         * 更新排序图片
         * @param sortName
         * @param sortType
         * @private
         */
        _changeImg: function(sortName, sortType) {
            if (sortType == "DESC") {
                $("em[name='" + sortName + "_sort_icon']", this.$tableWrap)
                    .removeClass("gridEX_sort_title_up")
                    .addClass("gridEX_sort_title_down");
            } else {
                $("em[name='" + sortName + "_sort_icon']", this.$tableWrap)
                    .removeClass("gridEX_sort_title_down")
                    .addClass("gridEX_sort_title_up");
            }
        },

        /**
         * 判断数组中是否包含指定字符串
         * @param map 数组
         * @param str 字符串
         * @return {Integer}
         * @private
         */
        _contains: function(map, str) {
            var index = -1;
            for (var i = 0; i < map.length; i++) {
                if (str == map[i]) {
                    index = i;
                    break;
                }
            }
            return index;
        },

        /**************************************创建元素*********************************************/

        /**
         * 创建菜单、加载时的背景以及拖动列宽时的基线
         */
        _createDom: function() {
            if (this.options.colhidden) {
                this._createMenu();
            }
            this._createLoading();
            //创建拖动时显示的基线
            this.$line = $("<div class='gridEX_line'></div>").appendTo(document.body);
        },

        /**
         * 创建菜单
         * @private
         */
        _createMenu: function() {
            var self = this,
                opts = self.options;

            // 创建子菜单
            var subPopMenuHtml = self._buildTemplateStr("subPopMenu", $.extend({}, opts, {headList: self.headList}));
            subPopMenuHtml = self._bindTplEvent(subPopMenuHtml);
            self.$subPopMenu = $(subPopMenuHtml).appendTo(document.body);
            self.$subPopMenu.bind('click', function(e) {
                var elem = e.target || e.srcElement,
                    isA  = elem.nodeName.toLowerCase() === 'a';
                e = $.event.fix(e);

                e.stopPropagation();
                if(isA || elem.nodeName.toLowerCase() === 'input'){
                    var $input = isA
                            ? $(elem).find("input")
                            : $(elem),
                        bindName  = $input.attr("bindName");
                    if ($input[0].disabled) return;

                    isA && ($input[0].checked = (!$input[0].checked));

                    var textValue = $input.attr("textValue");
                    if (!self.tempFilterCols[textValue]) {
                        self.tempFilterCols[textValue] = {el: $input[0], checked: !$input[0].checked};
                    }
                }
            });
        },

        /**
         * 创建加载时的背景
         * @private
         */
        _createLoading: function() {
            var self = this;
            var loadingBgHtml = "<div class='cui_gridEX_loading'><div class='cui_gridEX_loaddiv'><div class='cui_gridEX_loadgif'>Loading...</div></div>";
            self.$loading = $(loadingBgHtml).appendTo(self.$tableWrap);
        },

        /*****************************************事件*********************************************/

        /**
         * 确定过滤列菜单
         */
        _filterClickHandler: function(event) {
            var self = this,
                opts = self.options,
                oldtable = opts.el,
                headList = self.headList,
                filterFlag = false,
                thList = null;

            $.each(self.tempFilterCols, function(index, item) {
                if (item.el.checked != item.checked) {
                    var thText = $(item.el).attr("textValue"),
                        idx = -1,
                        thObj = null;

                    for (var i = 0; i < headList.length; i++) {
                        var head = headList[i];
                        if ($.trim(head.text) == $.trim(thText)) {
                            idx = i;
                            thObj = head.el;
                            break;
                        }
                    }

                    if (idx != -1) {
                        filterFlag = true;

                        if (item.el.checked) {
                            $(thObj).show();
                        } else {
                            $(thObj).hide();
                        }
                        self._showComplexTitle(thObj, item.el.checked, oldtable.find("thead"));

                        if (!thList) thList = self.$tBody.find("tr");
                        if(self.data.length > 0){
                            thList.each(function(i, tr) {
                                var targetTd = $(tr).children("td").get(idx);
                                if (item.el.checked) {
                                    $(targetTd).show();
                                } else {
                                    $(targetTd).hide();
                                }
                            });
                        }

                    }
                }
            });

            if (filterFlag) {
                var thList = self.headList,
                    showThList = [],
                    widthList = [],
                    totalWidth = 0,
                    tableWidth = self.oriTableWidth;

                $.each(thList, function(i, item) {
                    var th = item.el,
                        $th = $(th);
                    if ($th.css("display") != "none") {
                        var thWidth = self.oriThWidth[i];
                        widthList.push(thWidth);
                        totalWidth += thWidth;
                        showThList.push(th);
                    }
                });

                $.each(showThList, function(i, item) {
                    $(item).width(widthList[i] * tableWidth / totalWidth - 1);
                });

                //更新浮动表头
                var oldtableThead = oldtable.children("thead"),
                    oldtableWidth = oldtable.width();
                if (opts.titlelock) {
                    self.$tableHeadClone.width(oldtableWidth);
                    self.$tableHeadClone.html(oldtableThead.clone(true));
                }

                var columnsWidth = 0;
                if (self.$tableColumn) {
                    self.$tableColumnClone.html(oldtable.html());
                    columnsWidth = self._getColumnWidth();
                    self.$tableColumn.width(columnsWidth);

                }
                if (self.$tableFix) {
                    self.$tableFixClone.width(oldtableWidth);
                    self.$tableFixClone.html(oldtableThead.clone(true));
                    self.$tableFix.width(columnsWidth);
                }
            }

            self.tempFilterCols = {};
            self._filterCancelHandler(event);
        },

        /**
         * 取消过滤列菜单
         */
        _filterCancelHandler: function(event) {
            var self = this,
                opts = self.options;
            $.each(self.tempFilterCols, function(i, obj) {
                var el = obj.el;
                el.checked = obj.checked;
            });
            //隐藏菜单
            self.$subPopMenu.hide().css('zIndex', 1);
            if(self.isMenuOpen){
                $(document).unbind('click.grid');
                $(self.isMenuOpen).removeClass('theadfocus');
                $(self.isMenuOpen).find("a").hide();
            }
            if (self.menuDisabled) {
                self.menuDisabled.attr("disabled", false);
                $(self.menuDisabled[0].parentNode.parentNode).removeClass("disabled");
            }
            self.menuDisabled = null;
            self.isMenuOpen = false;
            self.tempFilterCols = {};
        },

        /**
         * 单击行选择事件
         * @param event
         * @param eventEl
         * @param target
         * @private
         */
        _rowClickHandler: function(event, eventEl, target) {
            var self = this,
                opts = self.options,
                $input = $("input:eq(0)", eventEl),
                targetName, rowsData;
            //如果target 不等于空
            if(target !== undefined){
                targetName = target.nodeName.toLowerCase();
                if(targetName !== 'td'){
                    //如果是通过click()方法触发事件
                    if(!(targetName === 'tr' && event.button === undefined)){
                        return false;
                    }
                }
            }

            switch (opts.selectrows){
                case 'no':
                    break;
                default:
                    self._inputClickHandler(event, $input[0]);
            }
        },

        /**
         * 选择单一checkbox或radio
         * @param event {Event} event对象
         * @param eventEl {HTMLElement} 事件的HTML对象
         * @param target {HTMLElement} 点击HTML对象
         * @private
         */
        _inputClickHandler: function(event, eventEl, target) {
            var self = this,
                opts = self.options,
                elem = event.target,
                elemName,
                rowsData;

            if(elem !== undefined){
                elemName = elem.nodeName.toLowerCase();
                if (elemName === "input") {
                    event.stopPropagation();
                }
            }
            var isChecked = target == undefined ? !eventEl.checked : eventEl.checked;
            var $eventEl = $(eventEl),
                rowIndex = $eventEl.attr("rowIndex");
            rowsData = self._selectRows([parseInt(rowIndex)], isChecked)[0];
            //点击行回调
            $.type(opts.rowclick_callback) === 'function' &&
            opts.rowclick_callback.call(this, rowsData, isChecked, rowIndex);
        },

        /**
         * 选择指定行
         * @param rowIndex {Array} 行数组
         * @param isChecked {Boolean} 是否选择
         * @returns {Array}
         * @private
         */
        _selectRows: function(rowIndex, isChecked){
            var self = this,
                opts = self.options,
                inputType, rowsData = [], $tr, $input,
                classOP = isChecked ? 'addClass' : 'removeClass';
            //如果是单选，先清空之前选择的行
            if(opts.selectrows === 'single'){
                $('tr.' + opts.selectedrowclass, self.$tableBox).removeClass(opts.selectedrowclass);
            }
            for(var i = 0; i < rowIndex.length; i ++){
                $tr = $("tr[rowIndex=" + rowIndex[i] + "]", self.$tableBox);
                $tr[classOP](opts.selectedrowclass);
                switch (opts.selectrows){
                    case 'multi':
                        inputType = 'checkbox';
                        break;
                    case 'single':
                        inputType = 'radio'
                }
                $input = $(':' + inputType, $tr);
                $input.prop('checked', isChecked);
                rowsData.push(self._getDataByPrimaryKey($input.attr('pkey')));
            }
            if(opts.selectrows === 'multi'){
                //这里还要检查一个是否要全选
                self._checkSelectAll();
            }

            return rowsData;
        },

        /**
         * 全选检测
         * @private
         */
        _checkSelectAll: function(){
            var self = this,
                opts = self.options,
                listLength = $('input[name="' + opts.checkboxname + '"]:checked', self.$tableData).length;
            var $allBox = $("th input[name='" + opts.allboxname + "']", self.$tableBox);

            if(listLength === self.data.length && $allBox.prop('checked') === false && listLength !== 0){
                $allBox.prop('checked', true);
                typeof opts.selectall_callback == 'function' &&
                opts.selectall_callback.call(this, self.data, true);
            }else if(listLength !== self.data.length && $allBox.prop('checked') === true){
                $allBox.prop('checked', false);
                typeof opts.selectall_callback == 'function' &&
                opts.selectall_callback.call(this, self.data, false);
            }
        },

        _renderClick: function(event, eventEl) {
            event.stopPropagation();
            var self = this,
                rowIndex = $(eventEl).attr("rowIndex"),
                click = $(eventEl).attr("on_click"),
                rowData = self.data[rowIndex];
            window[click] && window[click](rowData);
        },

        /**
         * 选择所有checkbox
         * @param obj 全选按钮对象allBox
         * @param name 关联按钮名
         * @private
         */
        _selectAllBox: function(obj, name) {
            var self = this,
                opts = self.options,
                idList = $("input[name='" + name + "']", self.$tableBox);

            //当题头浮动起来，将两次allBox都要勾选或者取消勾选
            $("input[name='" + obj.name + "']").each(function(i, item) {
                item.checked = obj.checked;
            });
            idList.each(function(i, checkbox) {
                if (!checkbox.disabled) {
                    checkbox.checked = obj.checked;
                    if (checkbox.checked) {
                        $(checkbox).parents('tr').eq(0).addClass(opts.selectedrowclass);
                        //$("tr[rowIndex=" + i + "]", self.$tableBox).addClass(opts.selectedrowclass);
                    } else {
                        $(checkbox).parents('tr').eq(0).removeClass(opts.selectedrowclass);
                        //$("tr[rowIndex=" + i + "]", self.$tableBox).removeClass(opts.selectedrowclass);
                    }
                }
            });
            typeof opts.selectall_callback == 'function' && opts.selectall_callback.call(this, self.data, obj.checked);
        },

        /**
         * 为表格题头添加事件
         * @private
         */
        _addEventLisenter: function() {
            var self = this,
                opts = self.options,
                oldtable = opts.el,
                th = oldtable.find("th");
            //开启隐藏列功能才绑定mouseover、mouseout事件
            if(opts.colhidden){
                th.bind('mouseover', function() {
                    //如果是复合头直接返回
                    var $t = $(this);
                    var colspan = $t.attr("colspan");
                    if (colspan && parseInt(colspan) > 1) return;

                    $t.addClass("theadfocus").find("a").show();
                }).bind('mouseout', function() {
                        var $t = $(this);
                        var colspan = $t.attr("colspan");
                        //如果是复合头直接返回
                        if (colspan && parseInt(colspan) > 1) return;

                        var thisBindName = $t.attr("bindName");
                        if (self.isMenuOpen) {
                            var menuOpenBindName = $(self.isMenuOpen).attr("bindName");
                            if (thisBindName == menuOpenBindName) return;
                        }
                        $t.removeClass("theadfocus").find("a").hide();
                    });
            }


            th.bind("click", function(e) {
                var elem = e.target || e.srcElement,
                    elemName  = elem.nodeName.toLowerCase();
                e = $.event.fix(e);
                /*
                 * 如果点击的是表头中的 A 标签，则弹出菜单
                 */
                if (elemName === 'a') {
                    /*
                     * 当在菜单外面点击的时候会执行 改函数
                     * 用于清空 document的 click事件   隐藏层 去掉td,a的样式
                     */
                    function documentClick(){
                        self._filterCancelHandler(e);
                    }

                    var pos  = $(elem).offset(),
                    //left = pos.left + $(window).scrollLeft(),
                        left = pos.left,
                    //top  = pos.top + $(window).scrollTop() + elem.offsetHeight,
                        top  = pos.top + elem.offsetHeight,
                        th = elem.parentNode.parentNode;

                    //如果this.isMenuOpen是真 表示 层是打开状态的  执行关闭相关的处理
                    self.isMenuOpen&&documentClick();
                    e.stopPropagation();
                    //当显示层的时候 吧该td附到this.isMenuOpen上
                    self.isMenuOpen = th;
                    $(document).bind('click.grid',documentClick);

                    //disable与本菜单相同的bindName
                    var menuOpenText = $(self.isMenuOpen).find("span.head_sp").text();
                    self.menuDisabled = self.$subPopMenu.find("input[textValue='" + $.trim(menuOpenText) + "']");
                    self.menuDisabled.attr("disabled", true);
                    $(self.menuDisabled[0].parentNode.parentNode).addClass("disabled");

                    //定位菜单
                    self.$subPopMenu.css({
                        left: left + "px",
                        top: top + "px",
                        display: "block",
                        zIndex: 99999999999
                    });
                    var menuHeight = self.$subPopMenu.height();
                    var tableHeight = self.$tableData[0].clientHeight;
                    if (tableHeight < 230) {
                        //self.$subPopMenu.height(tableHeight - 30);
                        self.$subPopMenu.children("div:first").height(tableHeight);
                    } else if (menuHeight < 200) {
                        //self.$subPopMenu.height(200);
                        self.$subPopMenu.children("div:first").height(170);
                    }
                    var clientWidth = document.documentElement.clientWidth || document.body.clientWidth;
                    if (self.$subPopMenu.width() + left > clientWidth) {
                        self.$subPopMenu.css({
                            left: left - self.$subPopMenu.width() + "px"
                        });
                    }
                } else if (elemName === "span") {
                    if ($(this).attr("sort") == "true") {
                        self._sortTitle(elem, $(this).attr("bindName"), null);
                    }
                } else if (elemName === "input") {
                    //绑定点击按钮，勾选即会全选事件
                    self._selectAllBox($(this).find("input")[0], self.options.checkboxname);
                }
            });

            if (opts.ellipsis) {
                //用于调整列宽
                th.bind('mousedown', function(e) {
                    var elem = e.target || e.srcElement;
                    if(elem.nodeName.toLowerCase() === "p"){
                        /*
                         遍历 当前选中的列的 前面所有的列
                         如果没有 或 全部是隐藏的   则返回
                         */
                        var bindName = $(this).attr("bindName"),
                            headList = self.headList,
                            flag = true;
                        for (var i = 0; i < headList.length; i++) {
                            var head = headList[i];
                            if (head.bindName == bindName) {
                                break;
                            } else if ($(head.el).css("display") != "none") {
                                flag = false;
                                break;
                            }
                        }
                        if (flag) return;

                        var th = this,
                            widthConfig = self.widthConfig;

                        widthConfig.x = e.clientX;
                        var readTh = self._readHead(bindName);
                        widthConfig.th = readTh.elem.el;

                        C.Browser.isIE ? oldtable[0].setCapture(false) : e.preventDefault();

                        //是否为复合题头，如果是判断th与前一个th是否为同父题头，如果不是直接返回
                        var thLayer = $(widthConfig.th).attr(self.thLayer);
                        var prevTh = null;
                        for (var i = readTh.idx - 1; i >= 0; i--) {
                            var head = headList[i];
                            if ($(head.el).css("display") != "none") {
                                prevTh = head.el;
                                break;
                            } else {
                                continue;
                            }
                        }

                        widthConfig.prevTh = prevTh;

                        widthConfig.thWidth   = ~~$(widthConfig.th).width();
                        widthConfig.prevWidth = ~~$(widthConfig.prevTh).width();
                        var height = Math.min(self.$tableBox[0].offsetHeight, oldtable[0].offsetHeight),
                            scrollHeight = self.$tableBox[0].offsetHeight>=oldtable[0].offsetHeight?0:18;

                        self.$line.css({
                            left: e.clientX + $(window).scrollLeft() + 'px',
                            height: height-scrollHeight +"px",
                            //top: self.$tableBox.offset().top + $(window).scrollTop() + 'px'
                            top: self.$tableBox.offset().top + 'px'
                        });
                        $(document).bind("mousemove.grid", function(e) {
                            window.getSelection
                                ? window.getSelection().removeAllRanges()
                                : document.selection.empty();
                            var widthConfig = self.widthConfig,
                                left = e.clientX,
                                clientX = left,
                                cellMinWidth = 0;//50;

                            if(clientX > widthConfig.x && e.clientX - widthConfig.x > widthConfig.thWidth - cellMinWidth){
                                left = widthConfig.x + widthConfig.thWidth - cellMinWidth;
                            }

                            if(clientX < widthConfig.x && widthConfig.x - clientX > widthConfig.prevWidth - cellMinWidth){
                                left = widthConfig.x - widthConfig.prevWidth + cellMinWidth;
                            }
                            self.$line.css({
                                left    : left + $(window).scrollLeft() + "px",
                                display : "block"
                            });
                        })
                            .bind("mouseup.grid", function(e) {
                                self.$line.hide();
                                var widthConfig = self.widthConfig,
                                    x = parseInt(self.$line[0].style.left)- $(window).scrollLeft() - widthConfig.x;
                                oldtable.width(oldtable.width() + x);
                                $(widthConfig.prevTh).width(~~widthConfig.prevWidth + x);

                                //复制题头给浮动题头
                                var oldtableThead = oldtable.children("thead"),
                                    oldtableWidth = oldtable.width();
                                if (opts.titlelock) {
                                    self.$tableHeadClone.width(oldtableWidth);
                                    self.$tableHeadClone.html(oldtableThead.clone(true));
                                }

                                var columnsWidth = 0;
                                if (self.$tableColumn) {
                                    self.$tableColumnClone.width(oldtableWidth);
                                    self.$tableColumnClone.children("thead").replaceWith(oldtableThead.clone(true));

                                    columnsWidth = self._getColumnWidth();
                                    self.$tableColumn.width(columnsWidth);
                                    self.$tableColumn.height(self.$tableData[0].clientHeight);
                                }
                                if (self.$tableFix) {
                                    self.$tableFixClone.width(oldtableWidth);
                                    self.$tableFixClone.html(oldtableThead.clone(true));
                                    self.$tableFix.width(columnsWidth);
                                    self.$tableFix.offset(self.$tableBox.offset());
                                }
                                if (opts.titlelock) {
                                    self.$tableHead.width(self.$tableData[0].clientWidth);
                                    C.Browser.isIE && self.$tablehead[0].releaseCapture();
                                }
                                $(document).unbind("mousemove.grid").unbind("mouseup.grid");
                            });
                    }
                });
            }
        },

        /**
         * 根据主键获取数据
         * @param value
         * @returns {*}
         * @private
         */
        _getDataByPrimaryKey: function(value){
            var self = this,
                opts = self.options,
                selectedData;
            for(var i = 0, len = self.data.length; i < len; i ++){
                if(self.data[i][opts.primarykey] + '' == value){
                    selectedData = self.data[i];
                }
            }

            return selectedData;
        },

        /***************************************用户接口****************************************/

        /**
         * 重设表格高宽
         */
        resize: function(){
            var self = this,
                opts = self.options;
            if (opts.resizeheight) {
                self.setHeight(opts.resizeheight());
            }
            if (opts.resizewidth) {
                var resizeWidth = opts.resizewidth();
                self.$tableWrap.width(resizeWidth);
                self.$tableBox.width(resizeWidth);
                self.$tableData.width(resizeWidth);
                if (self.$tableHead) self.$tableHead.width(self.$tableData[0].clientWidth);
                if (opts.adaptive) {
                    self._resizeGrid(resizeWidth);
                }
            }
        },

        /**
         * 获取选中行数据
         * @return {Array}
         */
        getSelectedRowData: function() {
            var self = this;
            var selectedRows = [];
            var idList = $("input[name='" + this.options.checkboxname + "']:checked", this.$tableData);
            idList.each(function(i, input) {
                selectedRows.push(self._getDataByPrimaryKey($(input).attr('pkey')));
            });
            return selectedRows;
        },

        /**
         * 获取选中行对应的主键
         * @return {Array}
         */
        getSelectedPrimaryKey: function() {
            var self = this,
                opts = self.options,
                selectedRows,
                selectedRowsPK = [];
            selectedRows = self.getSelectedRowData();
            for(var i = 0, len = selectedRows.length; i < len; i ++){
                selectedRowsPK.push(selectedRows[i][opts.primarykey]);
            }
            return selectedRowsPK;
        },

        /**
         * 获取选中行对应的索引号
         * @returns {Array}
         */
        getSelectedIndex: function(){
            var index = [];
            var idList = $("input[name='" + this.options.checkboxname + "']", this.$tableData);
            idList.each(function(i, input) {
                if (input.checked) {
                    index.push(i);
                }
            });
            return index;
        },

        /**
         * 获取指定索引号行的数据
         * @param index {Number | Array} 索引号
         * @returns {Array}
         */
        getRowsDataByIndex: function(index){
            var self = this,
                type = $.type(index),
                selectedRows = [];
            if(type == 'undefined' || type == 'null'){
                return [];
            }

            index = type == 'array' ? index : [index];

            for(var i = 0; i < index.length; i ++){
                selectedRows.push(self.data[index[i]]);
            }
            return selectedRows;

        },
        /**
         * 获取指定索引号行的数据
         * @param primaryKey {Array | String}
         * @return {Array} 返回选中的行的数据
         */
        getRowsDataByPK: function(primaryKey){
            var self = this,
                opts = self.options,
                type = $.type(primaryKey),
                selectedRows = [];
            if(type == 'undefined' || type == 'null'){
                return [];
            }

            primaryKey = type == 'array' ? primaryKey : [primaryKey];

            for(var k = 0, kLen = self.data.length; k < kLen; k ++){
                for(var i = 0; i < primaryKey.length; i ++){
                    if(self.data[k][opts.primarykey] == primaryKey[i]){
                        selectedRows.push(self.data[k]);
                    }
                }
            }
            return selectedRows;
        },

        /**
         * 根据主键选择行
         * @param primaryKey {Array | String}
         * @param isChecked {Boolean} checked类型
         * @return {Array} 返回选中的行的数据
         */
        selectRowsByPK: function(primaryKey, isChecked){
            var self = this,
                opts = self.options,
                type = $.type(primaryKey),
                $input,
                selectedRows = [];
            isChecked = isChecked == undefined ? true : isChecked;
            if(type == 'undefined' || type == 'null'){
                return [];
            }

            primaryKey = type == 'array' ? primaryKey : [primaryKey];
            if(opts.selectrows == 'single'){
                primaryKey = [primaryKey[0]];
                $("tr." + opts.selectedrowclass, self.$tableBox).removeClass();
            }

            for(var i = 0; i < primaryKey.length; i ++){
                $input = $("input[pKey='"+primaryKey[i]+"']", this.$tableBox);
                selectedRows.push($input.attr('rowIndex'));
            }

            return self._selectRows(selectedRows, isChecked);
        },

        /**
         * 根据索引号选择行
         * @param index {Array | Number} 选择的行号
         * @param isChecked {Boolean} checked类型
         * @returns {Array}
         */
        selectRowsByIndex: function(index, isChecked){
            var self = this,
                opts = self.options,
                type = $.type(index);
            isChecked = isChecked == undefined ? true : isChecked;
            if(type == 'undefined' || type == 'null'){
                return [];
            }
            index = type == 'array' ? index : [index];
            if(opts.selectrows == 'single'){
                index = [index[0]];
                $("tr." + opts.selectedrowclass, self.$tableBox).removeClass();
            }
            return self._selectRows(index, isChecked);
        },

        /**
         * 设置数据源并且渲染表格
         * @param data Json数组
         * @param totalSize 数据总量
         */
        setDatasource: function(data, totalSize) {
            var self = this,
                opts = self.options;
            if($.type(data) !== 'array'){
                self.data = [];
            }else{
                self.data = data;
            }
            //重置滚动条
            self.$tableData.scrollLeft(0);
            self.$tableData.scrollTop(0);

            //重置排序标记
            self._resetSortIcon();

            //渲染表格数据 ie6 3156mm(10*1000)
            self._renderTBody();

            //ie6 1234mm(10*1000)
            self._adjustTable();

            if(opts.gridheight === 'auto' && (C.Browser.isIE6 || C.Browser.isIE7)){
                self.$tableData.height(self.$tableData.children('table').height() + 20);
                //self.$tableBox.height(self.$tableWrap.height() - 40 + 20);
            }

            self.setPagination(totalSize);
            self.$loading.hide();

            //完成加载时的回调
            typeof opts.loadcomplate_callback == 'function' && opts.loadcomplate_callback.call(self, self);
        },

        /**
         * 设置分页组件属性
         * @param totalSize {Number} 总数据量
         */
        setPagination: function(totalSize){
            var self = this,
                opts = this.options,
                type = typeof totalSize;

            self.totalSize = type === 'number' ? totalSize : self.totalSize;

            //分页版块是否已经存在，不存在的创建
            if(opts.pagination && !this.$tFoot){
                this._renderTFoot();
            }

            if(type !== 'number'){
                $('.cui_gridEX_pagination_tip', self.$tFoot).show();
            }

            if(opts.pagination){
                if(self.cuiPagination){
                    self.cuiPagination.setInitData({
                        count: self.totalSize,
                        pageno: self.query.pageNo,
                        pagesize: self.query.pageSize
                    }).reDraw();
                    $('.cui_gridEX_pagination_tip', self.$tFoot).hide();
                }else{
                    self.cuiPagination = cui($('.paginationEX_wrap', self.$tFoot)).paginationEX({
                        count: self.totalSize,
                        pagesize: self.query.pageSize,
                        pageno: self.query.pageNo,
                        pagesize_list: opts.pagesize_list,
                        on_page_change: function(pageNo, pageSize){
                            self._changePage(pageNo, pageSize);
                        },
                        cls: opts.pagination_model,
                        tpls: {paginationEX: opts.pagination_model}
                    });
                }
            }

            self._emptyDataCtrl();
        },

        /**
         * 空数据时，grid的高控制
         * @private
         */
        _emptyDataCtrl: function(){
            var self = this,
                opts = self.options;
            //如果数据为空，隐藏页脚
            if (self.data.length === 0) {
                //是否启用分页，如果不启用分页，脚部隐藏
                opts.pagination && self.$tFoot.hide();
                //固定列是否存在，如果存在，则隐藏
                if(self.$tableColumn){
                    self.$tableColumn.hide();
                    //self.$tableFix.hide();
                }
                //去掉脚部，调整高度
                if(opts.gridheight !== 'auto'){
                    self.$tableBox.height(self.$tableWrap.height());
                    self.$tableData.height(self.$tableWrap.height());
                }
            } else {
                if(opts.pagination){
                    if(opts.gridheight !== 'auto'){// && (C.Browser.isIE6 || C.Browser.isIE7)
                        self.$tableData.height(self.$tableWrap.height() - 40);
                        self.$tableBox.height(self.$tableWrap.height() - 40);
                    }
                    self.$tFoot.show();
                }
                if(self.$tableColumn){
                    self.$tableColumn.height(self.$tableData[0].clientHeight).show();
                }
            }
        },

        /**
         * 请求数据
         */
        loadData: function() {
            var self = this,
                opts = self.options,
                dataSource = opts.datasource;
            opts.loadtip && self.$loading.show();
            if ($.type(dataSource) == "string") {
                window[dataSource] && window[dataSource](self, $.extend(true, {}, self.query));
            } else if ($.type(dataSource) == "function") {
                dataSource(self, $.extend(true, {}, self.query));
            }
        },

        /**
         * 获取所有数据
         * @returns {*}
         */
        getAllData: function(){
            return $.extend(true, [], this.data);
        },

        /**
         * 是否可以拖动表格
         * @param isDrag true/false
         */
        dragSort: function(isDrag) {
            var self = this,
                opts = self.options;

            if (!self.dragObj) {
                var tbody = self.$tablehead.find('tbody');
                self.dragObj = cui(tbody).dragTable({
                    dragClass: 'drag_highlight',
                    onDragStart: opts.on_dragstart,
                    onDrag: opts.on_drag,
                    onDragEnd: opts.on_dragend,
                    childEL: function() {
                        return $(tbody).children("tr");
                    }
                });
            }
            if (isDrag) {
                self.dragObj.doDrag(self.$tableData[0].clientWidth, self.$tableData.offset().left);
            } else {
                self.dragObj.unDrag();
            }
        },

        /**
         * 获取pageSize、pageNo以及题头排序sortName与sortType
         * @return {Object}
         */
        getQuery: function() {
            return $.extend(true, {}, this.query);
        },

        /**
         * 设置pageSize、pageNo以及题头排序sortName与sortType
         * @param {Object} query 查询条件
         */
        setQuery: function(query) {
            if ($.type(query) === 'object') {
                this.query = $.extend(true, this.query, query);
                if (query.pageSize) {
                    this.query.pageSize = query.pageSize;
                }
                if (query.pageNo) {
                    this.query.pageNo = query.pageNo;
                }
                if (query.sortName) {
                    this.query.sortName = query.sortName;
                }
                if (query.sortType) {
                    this.query.sortType = query.sortType;
                }
            }
        },

        /**
         * 根据主键设置高亮
         * @param primaryKey
         */
        setHighLight: function(primaryKey) {
            var self = this;
            $("input[pKey='"+primaryKey+"']", this.$tableBox).each(function(i, item) {
                $(item.parentNode.parentNode).addClass(self.options.selectedrowclass);
            });
        },


        /**
         * 设置组件高度
         * @param height
         */
        setHeight: function(height) {
            if(height === undefined || height == null){
                return;
            }
            height = parseFloat(height);
            var opts = this.options;
            this.$tableWrap.height(height);
            if(this.data.length == 0){
                height = height;
            }else{
                height = height - (opts.pagination ? 40 : 0);
            }
            this.$tableBox.height(height);
            this.$tableData.height(height);
            //var offset = this.$tableBox.offset();
            if (this.$tableColumn) {
                this.$tableColumn.height(this.$tableData[0].clientHeight);
                //this.$tableColumn.offset(offset);
                //this.$tableFix.offset(offset);
            }
            //this.$tableHead.offset(offset);
        },

        /**
         * 追加数据
         * @param data
         */
        addData: function(data){
            var self = this,
                opts = self.options,
                callBack = opts.adddata_callback,
                rowNum = 0,
                appendTr = "";

            if (!self.data) {
                self.data = [];
            }

            //如果列表为空，删除空提示行
            var $emptyCell = $("#" + self.id + "_empty_cell", self.$tBody);
            var isEmptyed = false;
            if ($emptyCell.length > 0) {
                isEmptyed = true;
                $emptyCell.parent().remove();
                if (opts.fixcolumnnumber > 0) {
                    $("#" + self.id + "_empty_cell", self.$tableColumnClone).parent().remove();
                }
            }

            var lastTr = self.$tBody.children("tr:last");
            if (lastTr[0]) {
                var rIndex = lastTr.attr("rowIndex");
                if (rIndex) rowNum = parseInt(rIndex);
            }

            if ($.type(data) === "array") {
                data = $.extend(true, [], data);
                $.each(data, function(i, item) {
                    appendTr += self._renderRow(item, rowNum + i + 1);
                });
            } else {
                data = $.extend(true, {}, data);
                appendTr = self._renderRow(data, rowNum + 1);
            }
            self.$tBody.append(appendTr);
            if (opts.fixcolumnnumber > 0) {
                var lockTbody = self.$tableColumnClone.find("tbody:last");
                lockTbody.append(appendTr);
                self.$tableColumn.height(self.$tableData[0].clientHeight);
            }
            opts.oddevenrow && self._redrawRowBG();
            $('input[name="'+ opts.allboxname +'"]', self.$tableWrap).prop('checked', false);

            //将数据添加到data缓存中
            if ($.type(data) === "array") {
                $.each(data, function(i, item) {
                    self.data.push(item);
                });
            } else {
                self.data.push(data);
            }

            if(isEmptyed){
                self._emptyDataCtrl();
            }

            if (!callBack) return;
            if ($.type(callBack) == "string") {
                window[callBack] && window[callBack](data);
            } else if ($.type(callBack) == "function") {
                callBack(data);
            }
        },

        /**
         * 移除数据
         */
        removeData: function(rowIndex){
            var self = this,
                opts = self.options,
                callBack = opts.removedata_callback,
                delRowIndex = [],
                delRowData = [];


            if ($.type(rowIndex) === "array") {
                delRowIndex = rowIndex;
            } else {
                delRowIndex.push(rowIndex);
            }

            if (delRowIndex.length > 0) {
                var cloneTBody = null;
                var delIndex;
                for (var i = 0; i < delRowIndex.length; i++) {
                    delIndex = i === 0 ? delRowIndex[i] : delRowIndex[i] - i;
                    //var data = self.data[delRowIndex[i]];
                    self.$tableData.find('tbody:last>tr:eq('+ delIndex +')').remove();
                    if (opts.fixcolumnnumber > 0) {
                        if (!cloneTBody) cloneTBody = self.$tableColumnClone.children("tbody:last");
                        cloneTBody.children('tr:eq('+ delIndex +')').remove();
                    }
                }
            }
            opts.oddevenrow && self._redrawRowBG();
            delRowIndex = delRowIndex.sort(sortNumber);
            //移除缓存data中的数据
            for(var i = 0; i < delRowIndex.length; i ++){
                if(i === 0){
                    self.data.splice(delRowIndex[i], 1);
                }else{
                    self.data.splice(delRowIndex[i] - i, 1);
                }
            }

            if(self.data.length === 0){
                self.query.pageNo = self.query.pageNo <= 1 ? 1 : self.query.pageNo - 1;

                if($('#' + self.id + '_empty_cell').length === 0) {
                    //获取页脚模板
                    var emptyCell = self._buildTemplateStr("emptyRow", $.extend({}, opts, {emptycolspan: self.headList.length, id: self.id}));
                    self.$tBody.append(emptyCell);
                }

                $('input[name="'+ opts.allboxname +'"]', self.$tableWrap).prop('checked', false);

                self._emptyDataCtrl();
            }

            if (!callBack) return;
            if ($.type(callBack) === "string") {
                window[callBack] && window[callBack](delRowData);
            } else if ($.type(callBack) === "function") {
                callBack(delRowData);
            }
            function sortNumber(a, b){
                return a - b;
            }
        },

        /**
         * 更新指定行数据
         * @param new_data {Object} 更新数据
         * @param index {Number} 行索引号
         */
        changeData: function (new_data, index) {
            if ($.type(new_data) !== "object") {
                return;
            }
            var self = this,
                opts = self.options,
                primarykey = opts.primarykey,
                pk_value = new_data[primarykey];

            //如果存在主键，则按主键更新数据行
            if (typeof pk_value !== "undefined") {
                for(var i = 0, len = self.data.length; i < len; i ++){
                    if(self.data[i][primarykey] === pk_value){
                        index = i;
                        break;
                    }
                }
            }else{
                if (typeof index !== "number" || index < 0 || index >= self.data.length) {
                    return;
                }
            }
            self.data[index] = $.extend(true, self.data[index], new_data);
            var html = self._renderRow(self.data[index], index);

            self.$tableData.find('tbody:last>tr:eq('+ index +')').replaceWith(html);
            if (opts.fixcolumnnumber > 0) {
                self.$tableColumnClone.children('tbody:last').find('tr:eq('+ index +')').replaceWith(html);
            }
        },

        /**
         * 重新绘制隔行色
         * @private
         */
        _redrawRowBG: function(){
            var self = this,
                opts = self.options;
            self.$tableData.find('tbody:last>tr').each(function(i, item){
                if(i % 2 === 0 || i === 0){
                    $(item).removeClass('cardinal_row');
                }else{
                    $(item).addClass('cardinal_row');
                }
            });
            if(opts.fixcolumnnumber > 0){
                self.$tableColumn.find('tbody:last>tr').each(function(i, item){
                    if(i % 2 === 0 || i === 0){
                        $(item).removeClass('cardinal_row');
                    }else{
                        $(item).addClass('cardinal_row');
                    }
                });
            }
        }
    });

    /*
     * 获取浏览器竖向滚动条宽度
     * 首先创建一个用户不可见、无滚动条的DIV，获取DIV宽度后，
     * 再将DIV的Y轴滚动条设置为永远可见，再获取此时的DIV宽度
     * 删除DIV后返回前后宽度的差值
     *
     * @return    Integer     竖向滚动条宽度
     */
    function getScrollWidth() {
        var noScroll, scroll, oDiv = document.createElement("DIV");
        oDiv.style.cssText = "position:absolute; top:-1000px; width:100px; height:100px; overflow:hidden;";
        noScroll = document.body.appendChild(oDiv).clientWidth;
        oDiv.style.overflowY = "scroll";
        scroll = oDiv.clientWidth;
        document.body.removeChild(oDiv);
        return noScroll-scroll;
    }
})(window.comtop.cQuery, window.comtop);

;(function($, C){
    C.UI.EditGridEX = C.UI.Base.extend({
        options: {
            uitype: 'EditGridEX',
            id: 'editGridEx_' + C.guid(),
            grid: null,
            editMode: false,
            tmpl: []
        },
        _init: function(){
        	this._thStyle = [];
            this._idList = [];
            this._cuiList = [];
            this._autoNumber = undefined;//自动编号
            this._autoNumberStart = undefined;//自动编号配置，格式[起始编号，增长步长]
			this._validate = null;
        },
        /**
         * 删除编辑表单
         * @private
         */
        _clear: function(){
            for(var i = 0, iLen = this._idList.length; i < iLen; i ++){
                $('#egex_tr_' + this._idList[i]).remove();
                window['egex' + this._idList[i]] = undefined;
            }
            this._autoNumber = this._autoNumberStart - 1;
            this._validate = null;
            this._idList = [];
            this._cuiList = [];
        },
        /**
         * 数据绑定
         * @param $el {jQuery} 组件占位符
         * @param db {String} 绑定数据
         * @private
         */
        _bindData: function($el, db){
            //数据绑定
            if (db) {
                var chain = db.split('.');
                if(chain.length < 2){
                    alert('[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' +
                        ':绑定的数据必须为JSON格式里的成员变量;\n');
                    return false;
                }
                var dataSourceName = [];
                var dataSource;
                var propName;
                for(var i = 0, iLen = chain.length; i < iLen; i++){
                    if(i < iLen - 1){
                        dataSourceName.push(chain[i]);
                    }else{
                        propName = chain[i];
                    }
                }
                dataSource = C.namespace(dataSourceName.join('.'));

                if(dataSource.nodeName){
                    alert('[' + $el.attr('uitype') + ':' + $el.attr('id') + ']' +
                        ':数据'+ dataSourceName +'与页面的标签ID名相同，请更名;\n');
                    return false;
                }
                var databinder = cui(dataSource).databind();
                databinder.addBind($el, propName);
            }
        },
        /**
         * 验证绑定
         * @param $el {jQuery} 组件占位符
         * @param vd {Array | String}  验证配置
         * @private
         */
        _bindValidate: function($el, vd){
            if(vd){
                switch ($.type(vd)){
                    case 'array':
                        for(var i = 0; i < vd.length; i ++){
                            if(vd[i].rule){
                                this._validate.add(cui($el), vd[i].type, vd[i].rule);
                            }else{
                                this._validate.add(cui($el), vd[i].type);
                            }
                        }
                        break;
                    case 'string':
                        this._validate.add(cui($el), vd);
                }
            }
        },
        /**
         * 提示绑定
         * @param $el {jQuery} 组件占位符
         * @param opts {Object} 配置参数
         * @param $tipPos {String}  提示绑定位置
         * @private
         */
        _bindTip: function($el, opts, $tipPos){
            $tipPos = $($tipPos, $el);
            if(cui($el).options.textmode != undefined && opts.tip == undefined){
                $el.attr('tip', '');
                opts.tip = '';
            }
            if(opts.tip != undefined){
                $el.attr('tip', opts.tip);
                cui.tip($tipPos, {
                    trigger: opts.trigger,
                    tipEl: $el
                });
            }
        },
        _getAllData: function(){
            var allData = [];
            for(var i = 0, iLen = this._idList.length; i < iLen; i ++){
                if(typeof window['egex' + this._idList[i]] !== 'undefined'){
                    allData.push(cui(window['egex' + this._idList[i]]).databind().getValue());
                }
            }
            this._clear();
            this.options.grid.addData(allData);
            return allData;
        },
        add: function(){
            var data, clickElement;
            switch(arguments.length){
                case 1:
                    if(arguments[0].outerHTML !== undefined && arguments[0].nodeName !== undefined){
                        clickElement = arguments[0];
                    }else{
                        data = arguments[0];
                    }
                    break;
                case 2:
                    data = arguments[1];
                    clickElement = arguments[0];
            }
            var html = [],
                tmpl = this.options.tmpl,
                grid = this.options.grid,
                reg_autoNumber = /#autoNumber\((\d+)\)#/,
                item, uitype, $cui,
                i, len, k, kLen,
                addType = 'APPEND',
                guid = C.guid().replace('-','');

            //看是否有为空提示，如果有，就删除
            $('#' + grid.id + '_empty_cell').parent().remove();

            //创建验证对象，与其它表单区不同
            this._validate = this._validate || cui().validate();

            //为了加快渲染速度，只有当CUI全部创建完成后才进行数据绑定和验证绑定
            //生成tr空行
            for (i = 0; i < tmpl.length; i++){
                item = tmpl[i];
                uitype = item.uitype || item.uiType || (reg_autoNumber.test(item.htmlElement) ? 'autoNumber' : 'htmlElement');

                item.id = 'EGEX_' + guid + '_' + i;
                item.el = '#egex_cmp_wrap_' + item.id;
                item.width = "100%";
                item.databind = 'egex' + guid + '.' + item.bindname;
                item.name && (item.name = item.name + guid);

                if(reg_autoNumber.test(item.htmlElement) && typeof this._autoNumberStart === 'undefined'){
                    var autoNumber = item.htmlElement.match(reg_autoNumber);
                    this._autoNumberStart = Number(autoNumber[1]);
                    this._autoNumber = Number(autoNumber[1]) - 1;
                }
				//console.log(this._thStyle);
                html.push('<td style="padding:5px;', (this._thStyle[i] || '') ,'"><div id="egex_cmp_wrap_', item.id ,'"></div></td>');
            }
            //根据data的类型分流tr的插入操作
            if(data !== undefined){
                window['egex' + guid] = $.extend(true, {}, data);
            }
            if(clickElement === undefined){
                this._idList.push(guid);
                grid.$tBody.append('<tr id="egex_tr_' + guid + '" guid="' + guid + '">' + html.join('') + '</tr>');
                addType = 'APPEND';
            }else if(clickElement !== undefined){
                //如果data是HTMLElement，则在当前tr后添加
                var $tr = $(clickElement).parents('tr').eq(0);
                var $trID = $tr.attr('id').replace('egex_tr_', '');
                //插入ID
                for(k = 0, kLen = this._idList.length; k < kLen; k ++){
                    if($trID === this._idList[k]){
                        this._idList.splice(k + 1, 0, guid);
                    }
                }
                $tr.after('<tr id="egex_tr_' + guid + '" guid="' + guid + '">' + html.join('') + '</tr>');
                addType = 'AFTER';
            }
            //创建组件或htmlElement
            for (i = 0; i < tmpl.length; i++){
                item = tmpl[i];
                if(typeof item.htmlElement === 'undefined'){
                    //直接写数据，不创建组件
                    if(item.bindname && typeof item.uitype === 'undefined'){
                        if(data){
                            $(item.el).html(data[item.bindname]);
                        }
                        continue;
                    }else{
                        //创建CUI组件
                        uitype = item.uitype || item.uiType;
                        uitype = uitype.charAt(0).toLowerCase() + uitype.substring(1);
                        cui(item.el)[uitype](item);
                        continue;
                    }
                }
                if(typeof item.htmlElement === 'string'){
                    //创建自定义html元素
                    var htmlElement = item.htmlElement;
                    if(reg_autoNumber.test(item.htmlElement)){
                        htmlElement = this._autoNumber = this._autoNumber + 1;
                        switch(addType){
                            case 'APPEND':
                                $(item.el).css('textAlign','center').html(htmlElement);
                                break;
                            case 'AFTER':
                                var $TrID = $(item.el).parents('tr').eq(0).attr('id').replace('egex_tr_', '');
                                var isReplace = false;
                                for(k = 0, kLen = this._idList.length; k < kLen; k ++){
                                    if($TrID === this._idList[k]){
                                        isReplace = true;
                                    }
                                    if(isReplace){
                                        $('#egex_cmp_wrap_EGEX_' + this._idList[k] + '_' + i).css('textAlign','center').html(k);
                                    }
                                }
                        }
                    }else{
                        $(item.el).html(htmlElement);
                    }
                }
            }


            //数据绑定
            for (i = 0; i < tmpl.length; i++){
                item = tmpl[i];
                if(typeof item.htmlElement === 'undefined' && typeof item.uitype !== 'undefined'){
                    this._bindData($(item.el), item.databind);
                }
            }
            //验证绑定和tip绑定
            if(!C.UI.scan.textmode && !comtop.UI.scan.disable){
                for(i = 0, len = tmpl.length; i < len; i ++){
                    item = tmpl[i];
                    if(typeof item.htmlElement === 'undefined'){
                        $cui = $(item.el).data('uitype');
                        if($cui && !$cui.options.textmode && !$cui.options.disable){
                            this._bindValidate($cui.options.el, item.validate);
                            this._bindTip($cui.options.el, item, $cui.tipPosition || $cui.options.el);
                        }
                    }
                }
            }
        },
        remove: function(param){
            var type = $.type(param),
                tmpl = this.options.tmpl,
                reg_autoNumber = /#autoNumber\((\d+)\)#/,
                item;

            //remove(this)
            if(type === 'object'){
                var $tr = $(param).parents('tr').eq(0);
                var $tbody = $tr.parent();
                var $trId = $tr.attr('id').replace('egex_tr_', '');
                var autoNumberIndex = 0;
				var step = 0;
                for(var i = 0; i < tmpl.length; i ++){
                    item = tmpl[i];
                    if(typeof item.htmlElement === 'undefined'){
                        this._validate.disValid('EGEX_' + (item.uitype || item.uiType) + $trId + '_' + i, true);
                    }
                    if(reg_autoNumber.test(item.htmlElement)){
						step = item.htmlElement.match(reg_autoNumber)[1] - 0;
                        autoNumberIndex = i;
                    }
                }

                var isReplace = false;
                for(var k = 0, kLen = this._idList.length; k < kLen; k ++){

                    if($trId === this._idList[k]){
                        this._idList.splice(k, 1);
                        isReplace = true;
                    }
                    if(isReplace){
                        $('#egex_cmp_wrap_EGEX_' + this._idList[k] + '_' + autoNumberIndex).html(step);
                    }
					step ++;
                }

                if(!C.Browser.isIE){
                    delete window['egex' + $trId];
                }else{
                    window['egex' + $trId] = undefined;
                }

                $tr.remove();
                this._autoNumber --;
                if($tbody.children('tr').length === 0){
                    $tbody.append('<tr><td class="td_empty" colspan="' + $tbody.parent('table').eq(0).find('th').length + '" id="' + this.options.grid.id + '_empty_cell"><table width="100%" border="0"><tr>' +
                        '<td align="center" style="font-size: 12px;color: #191970;border: 0 none;">本  列  表  暂  无  记  录</td></tr></table></td></tr>');
                    this._autoNumber = this._autoNumberStart - 1;
                }
            }
        },
        edit: function(obj){
            this._clear();
            this.options.grid = obj;
            if(this.options.editMode){
                var data = this.options.grid.data;
				//获取table的th原渲染样式
                	var $ths = this.options.grid.$tableData.find('table>thead th');
					for(var i = 0, iLen = $ths.length; i < iLen; i ++){
						this._thStyle.push($ths.eq(i).attr('renderstyle'));
					}
                if(data.length > 0){
                    this.options.grid.$tableData.find('table>tbody').empty();
                }
                for(var i = 0, iLen = data.length; i < iLen; i ++){
                    this.add(data[i]);
                }
            }
        },
        submit: function(){
            var allData = [];

            if(this._validate === null){
                allData = this._getAllData();
            }else{
                var map = this._validate.validElement();
                if(map[2]){
                    allData = this._getAllData();
                }
            }

            return {
                valid: map ? map[2] : true,
                data: allData,
                validMsg: map ? map[1] : [],
                inValidMsg: map ? map[0] : []
            };
        },
		validElement: function(){
			if(this._validate){
                return this._validate.validElement();
            }
            return true;
		},
        getCUI: function(row, index){
            row = row || 0;
            index = index || 0;
            var id = this.options.grid.$tableData.find('table>tbody>tr').eq(row).attr('guid');
            return cui('#egex_cmp_wrap_EGEX_' + id + '_' + index);
        },
        getRowIndex: function($cui){
            var $cuiTR = $cui.options.el.parents('tr').eq(0);
            var $cuiTRS = $cuiTR.parent('tbody').children('tr');
            return $cuiTRS.index($cuiTR);
        }
    });
    C.UI.EditGridEX.version = 'v2.1';
})(window.comtop.cQuery, window.comtop);