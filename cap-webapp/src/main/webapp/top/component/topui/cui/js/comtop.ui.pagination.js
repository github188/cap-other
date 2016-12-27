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
	C.UI.BasePagination = C.UI.Base.extend({
		
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
	
	
	C.UI.Pagination = C.UI.BasePagination.extend({
		options: {
			uitype: 'Pagination',
			cls: 'pagination',
			count: 0,        //总记录数
			display_page: 4, //分页条中间显示多少页
			pagesize: 25, //每页显示多少条
			pageno: 1, //当前在第几页
			pagesize_list: [25,50,100], //可选每页显示多少条
			on_page_change: null,
            customerText:''
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
                customerText:this.options.customerText,
				displayPreCount: displayPreCount,
				displayNextCount: displayNextCount,
				toFirst: toFirst,
				toLast: toLast
			};
			
			this.$container.html(this._buildTemplateStr('pagination', data)).addClass(this.options.cls).addClass('cui');
			if(C.Browser.isQM && C.Browser.isIE) { //处理IE怪异模式的问题
				this.$container.addClass('pagination-qm');
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



