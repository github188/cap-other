/**
 *
 * ��ҳ���
 * 
 * @author ���и�
 * @since 2012-09-05
 * 
 */

;(function($, C){
	
	/**
	 * ��ҳ���������
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
		 * �����ܹ��ж���ҳ
		 */
		_calTotalPage: function() {
			this.totalPage = Math.ceil(this.totalItems / this.itemsPerPage);
			if(this.currentPage >= this.totalPage){
				this.currentPage = this.totalPage;
			}
		},
		
		/**
		 * ���ⲿ���õ��ػ�
		 */
		reDraw: function(){
			this._create();
			return this;
		},
		
		/**
		 * �����ܼ�¼��,���ⲿ����
		 */
		setCount: function(count) {
			this.options.count = this.totalItems = count;
			return this;
		},
		
		/**
		 * ������������֧��
		 */
		setPagesize: function(pagesize) {
            return this.setPageSize(pagesize);
		},
        /**
         * ����ÿҳ��ʾ��¼��,���ⲿ����
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
		 * ���÷�ҳ����������ݣ������ܼ�¼����ÿҳ��ʾ��¼������ǰҳ���
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
            //�ж����ݵ���Ч��Χ��������
            this.currentPage = data.pageno = data.pageno < 1 ? 1 : data.pageno;
            this.itemsPerPage = data.pagesize = data.pagesize < 1 ? data.pagesize_list[1] : data.pagesize;

            //����û����õ�pagesize����pagesize_list�ڲ�������pagesize_list�ڲ�׷��һ����
            var isAdd = true;
            for (var i = 0; i < data.pagesize_list.length; i++) {
                var item = data.pagesize_list[i];
                //����С��1�ķ�ҳ��
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
		 * ����ĳһҳ
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
		 * ������һҳ
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
		 * ������һҳ
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
		 * ��ȡ��ҳ�����ǰ���ڵڼ�ҳ
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
		 * ���ĳһҳʱִ�к���
		 * 
		 */
		_click: function(currentPage, itemsPerPage) {
			if(this.options.on_page_change){
				this.options.on_page_change.call(this, currentPage, itemsPerPage);
			}
			//this.reDraw();
		},
		
		/**
		 * ����ÿҳ��ʾ��������¼
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
			count: 0,        //�ܼ�¼��
			display_page: 4, //��ҳ���м���ʾ����ҳ
			pagesize: 25, //ÿҳ��ʾ������
			pageno: 1, //��ǰ�ڵڼ�ҳ
			pagesize_list: [25,50,100], //��ѡÿҳ��ʾ������
			on_page_change: null
		},

		_draw: function() {
			
			var displayPage = this.options.display_page;
			if(displayPage > this.totalPage) displayPage = this.totalPage;
			if(displayPage <= 3) displayPage = 3;
			
			var displayPreCount = Math.floor( (displayPage-1) / 2 ),
				displayNextCount = Math.ceil( (displayPage-1) / 2 );
			
			//Ϊ�˾�����ʾҳ������������ʱ��ʾ��ҳ�����٣�����һЩ����
			if(this.currentPage-2< displayPreCount) { 
				displayNextCount = displayNextCount + displayPreCount - (this.currentPage-2);
			} else if(this.totalPage - this.currentPage-1 < displayNextCount)  {
				displayPreCount = displayPreCount + displayNextCount - (this.totalPage - this.currentPage-1);
			}
			//dispalyPreCount �����ʾ(this.currentPage-1 )ҳ
			if(displayPreCount > this.currentPage-1 ) {
				displayPreCount = this.currentPage-1;
			}
			//displayNextCount �����ʾ(this.totalPage - this.currentPage) ҳ
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
			
			this.$container.html(this._buildTemplateStr('pagination', data)).addClass(this.options.cls).addClass('cui');
			if(C.Browser.isQM && C.Browser.isIE) { //����IE����ģʽ������
				this.$container.addClass('pagination-qm');
			}
			
		},
		
		_bindEvent: function(){
			var _self = this, $ct = this.$container;
			//���ĳһҳ
			$ct.find('[act="numPage"]').bind('click', function(){
				_self.go(parseInt($(this).text(), 10));
				return false;
			});
			//�����һҳ
			$ct.find('[act="prevPage"]').bind('click', function(){
				_self.prev();
				return false;
			});
			//�����һҳ
			$ct.find('[act="nextPage"]').bind('click', function(){
				_self.next();
				return false;
			});
			
			//����ĳһҳ
			$ct.find('[act="goPage"]').bind('click', go);

			//�س��¼�����ĳһҳ
			$ct.find('[act="cusPage"]').bind('keydown', function(event) {
				if(event.keyCode === 13){
					go();
				}
			});
			
			//ѡ��ÿҳ��ʾ����
			this.$container.find('[act="sizePage"]').bind('click', function(){
				_self._setItemsPerPage(parseInt($(this).text(), 10));
				_self._calTotalPage();
				_self.go(_self.currentPage);
				return false;
			});
			
			//����ĳһҳִ�к���
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