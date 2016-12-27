?;(function($, C){
    /**
     * @class C.UI.Button
     * @extends C.UI.Base
     * �˵�UI���<br>
     *
     * 1.ͨ���������������ɲ˵���<br>
     * 2.ͨ�����ÿ����ð�ť�Ŀ�ȡ�<br>
     * 3.��������Դ��ȡ���ݡ�<br>
     * 4.ͨ��������ʾ�˵���<br>
     * 5.��̬��ӻ�ɾ���˵���<br>
     * 6.��̬���ò˵��<br>
     * 7.��̬���ò˵�������ơ�<br>
     * @author ̷����
     * @version 1.0
     * @history 2012-10-19 ̷���� �½�
     * @demo demo/menuDemo.html
     */
    C.UI.Menu = C.UI.Base.extend({
        options: {
            uitype: 'Menu',//������ͣ�menu
            trigger: 'click',//��������ķ�ʽ��click|| hover
            width: '',//�˵��Ŀ��
            on_click: null,//����¼�
            datasource: null//�˵�������Դ
        },
        _init: function(){
            var self = this;
            self.objMenu = null;//�����˵��Ķ���
            self.objItemMap = {};//����item�Ķ�������Ӧ����¼���ʱ���õ���
            self.hideTimeout = null;//����ƿ�elʱ���timeout
        },
        
        /**
         * ��ʼ��ģ�巽��
         */
        _create:function(){
        	var self = this;
        	var el = this.options.el;
        	var trigger = self.options.trigger;
        	
        	el.bind(trigger, function(e){
        		e.stopPropagation();
        		self.show();
        	});
        	el.bind('mouseout',function(e){
        		self.hideTimeout = setTimeout(function(){
            		self.hide();
            	},100);
        	});
        	el.bind('mouseover',function(e){
        		clearTimeout(self.hideTimeout);
        	});
        	
        },
        /**
         * ����ģ��
         * @param {dom} $parent  Ҫ�õ��ĸ��ڵ�
         * @param {dom} datasource ����Դ
         */
        _loadTemplate:function($parent, datasource){
        	var menuDom = this._buildTemplateStr('menuDom', datasource);
        	menuDom = this._bindTplEvent(menuDom);
        	var $menuDom = $(menuDom);
        	$parent.append($menuDom);
        	var $children = $menuDom.find('li');
        	for (var i = 0; i < datasource.length; i ++) {
        		var item = datasource[i];
        		this.objItemMap[item.id] 	= item;//����item�Ķ�������Ӧ����¼���ʱ���õ���
        		if(item.disabled){
					this._disable($("#" + item.id));
        		}
        		if (item.items) {
        			var $child = $children.eq(i);
        			$child.find('a').addClass('menu_item_a_background');
        			this._loadTemplate($child, item.items);
        		}
        	}
        	return $menuDom;
        },
        /**
         * ���ز˵�
         */
        _loadMenu:function(){
        	if(this.objMenu == null){
        		var opts = this.options;
        		if($.isFunction(opts.datasource)){//����������һ��������ִ�з����������
        			opts.datasource = opts.datasource();
            	}
        		this.setDatasource(opts.datasource);
        		
        	}
        },
        /**
         * ��������Դ�ķ���
         */
        setDatasource:function(datasource){
        	if(datasource){
        		var opts = this.options;
	        	this.objMenu = this._loadTemplate($('body'), datasource);
	        	var self = this;
	        	this.objMenu.bind('mouseover',function(e){
	        		self.hideTimeout && clearTimeout(self.hideTimeout);
	        	});
	        	this.objMenu.bind('mouseout',function(e){
	        		self.hideTimeout = setTimeout(function(){
	        			self.objMenu.hide();
	        		},100);
	        	});
        	}
        },
        /**
         * ����ƹ��˵���Ӧ����,��ʾ�Ӳ˵�
         * @param {event} e mouseover�¼�
         * @param {dom} eventEl  ָ����¼���ԭ��DOM����
         * @param {dom} target ָ���¼���׽����ԭ��DOM����
         */
        _mouseoverHandler:function(e, eventEl, target){
        	if($('#' + eventEl.id).attr('disabled'))return;
        	if (eventEl.mouseTimeout) {
        		clearTimeout(eventEl.mouseTimeout);
        	}
        	var $subMenu = $(eventEl).children('.menu_box');
        	$(eventEl).parent().children().css('zIndex',1);
        	$(eventEl).css('zIndex',2);
        	if($subMenu){
        		$subMenu.show();
        		this._setItemPosition($subMenu,eventEl);
    			this._setItemsWidth($subMenu.children('.menu'),this.options.width);
        		this._setIframe($subMenu);
        	}
        },
        /**
         * ����ƿ��˵���Ӧ�����������Ӳ˵�
         * @param {event} e mouseout�¼�
         * @param {dom} eventEl  ָ����¼���ԭ��DOM����
         * @param {dom} target ָ���¼���׽����ԭ��DOM����
         */
        _mouseoutHandler:function(e, eventEl, target){
        	if($('#' + eventEl.id).attr('disabled'))return;
        	var $subMenu = $(eventEl).children('.menu_box');
        	eventEl.mouseTimeout = setTimeout(function(){
        		$subMenu.hide();
        	},100);
        },
        /**
         * ����˵���Ӧ����
         * @param {event} e click�¼�
         * @param {dom} eventEl  ָ����¼���ԭ��DOM����
         * @param {dom} target ָ���¼���׽����ԭ��DOM����
         */
        _clickHandler:function(e, eventEl, target){
        	if($('#' + eventEl.id).attr('disabled'))return;
        	e.stopPropagation();
        	if(C.Browser.isIE6 || (C.Browser.isIE && C.Browser.isQM)){
        		var $item = $('#' + eventEl.id);
        		while($item[0].tagName != 'BODY'){
        			if($item[0].tagName == 'DIV'){
        				$item.hide();
        			}
        			$item = $item.parent();
        		}
    		}
        	this.hide();
        	//ִ�лص�����
        	this.options.on_click && this.options.on_click(this.objItemMap[eventEl.id]);//objItemMap������menu��ʱ�򻺴��ˡ�
        },
        /**
         * �����Ӳ˵�����ʾλ�ã��������ߴ���
         */
        _setItemPosition:function($subMenu,eventEl){
        	var $menuBox = $subMenu;
        	$subMenu = $subMenu.children(".menu");
        	var cssObj = {};
        	var $event = $(eventEl);
        	var itemOffestPosition = $event.offset();
        	var elHeight = $event.outerHeight();
        	var elWidth = $event.outerWidth();
        	var subMenuHeight = $subMenu.outerHeight();
        	var subMenuWidth = $subMenu.outerWidth();
        	var winHeight= $(window).height();
        	var winWidth= $(window).width();
        	//����ұ�λ�ò���λ����ʾ������߹�λ����ʾ������ʾ����ߡ�С��10�Ǳ����ٽ������ռλ��
        	if(winWidth - (itemOffestPosition.left + elWidth + subMenuWidth) < 10 && (itemOffestPosition.left - elWidth) > 0){
        		cssObj.left = 0 -  subMenuWidth + 4;//��4�ǹ淶Ҫʵ���ص���Ч��
        		cssObj.right = "auto";
        	}else{//��ʾ���ұ�
        		cssObj.left = "auto";
        		cssObj.right = 4;
        	}
        	//����±�λ�ò���λ����ʾ������߹�λ����ʾ������ʾ���ϱߡ�
    		if(winHeight - (itemOffestPosition.top + elHeight + subMenuHeight) < 10 && (itemOffestPosition.top - subMenuHeight) > 0){
    			cssObj.bottom = 0 + subMenuHeight - 4;//-4�Ǽ���ul��padding��border
    			cssObj.top =  "auto";
    		}else{//��ʾ���±�
    			cssObj.bottom =  "auto";
    			cssObj.top =  -1;
    		}
    		$menuBox.css(cssObj);
        },
        /**
         * ���ò˵���λ��
         * @param {dom} el ��Ϊλ�òο���Ԫ��
         */
        _setPosition:function(el){
        	var elOffestPosition = $(el).offset();
        	var elHeight = $(el).outerHeight();
        	var elWidth = $(el).outerWidth();
        	var winHeight= $(window).height();
        	var winWidth= $(window).width();
        	var menuHeight = this.objMenu.children('.menu').outerHeight();
        	var menuWidth = this.objMenu.children('.menu').outerWidth();
        	var menuTop;
        	var menuLeft;
        	//����±�λ�ò���λ����ʾ������߹�λ����ʾ������ʾ���ϱߡ�
        	if(winHeight - (elOffestPosition.top + elHeight + menuHeight) < 0 && (elOffestPosition.top  - menuHeight) > 0){
        		menuTop = elOffestPosition.top - menuHeight;
        	}else{//��ʾ���±�
        		menuTop = elOffestPosition.top + elHeight;
        	}
        	//����ұ�λ�ò���λ����ʾ������߹�λ����ʾ������ʾ����ߡ�
        	if(winWidth - (elOffestPosition.left + menuWidth) < 0 && (elOffestPosition.left + elWidth - menuWidth) > 0){
        		menuLeft = elOffestPosition.left  + elWidth - menuWidth;
        	}else{//��ʾ���ұ�
        		menuLeft = elOffestPosition.left;
        	}
        	this.objMenu.css({
        		left:menuLeft,
        		top:menuTop
        	});
        },
        /**
         * ���ò˵�����,����Ӧ��ȣ���Ϊ����ie6������minWidth���ԣ�����ֻ���Լ�ʵ��
         * @param {dom} el ��Ϊ��Ȳο���Ԫ��
         */
        _setItemsWidth:function($ul, menuWidth){
        	var $liArray = $ul.children('li');
        	var maxWidth = 0;
        	for(var i = 0; i < $liArray.length; i++){
        		var width = $liArray.eq(i).children('a').children('span').outerWidth();
        		if(width > maxWidth){
        			maxWidth = width;
        		}
        	}
        	if(menuWidth > maxWidth){
        		maxWidth = menuWidth;
        	}else{
        		maxWidth = maxWidth + 10;
        	}
        	$ul.width(maxWidth);
        },
        /**
         * ���ò˵�iframe���ߣ�Ϊ����ie6�����
         * @param {dom} $menu menuԪ��
         */
        _setIframe:function($menu){
        	if(C.Browser.isIE6){
        		$menu.children('iframe').css({
        			width:$menu.find('.menu_item').width(),
        			height:$menu.find('.menu').height()
        		});
        	}
        },
        /**
         * ���ò˵����
         * @param {dom} el ��Ϊ��Ȳο���Ԫ��
         */
        _setWidth:function(el){
        	var menuWidth;
        	if(this.options.width){
        		menuWidth = parseInt(this.options.width,10);
        	}else{
        		menuWidth = $(el).outerWidth() - 2;
        	}
        	this.options.width = menuWidth;
    		this._setItemsWidth(this.objMenu.children('.menu'),menuWidth);
        },
        /**
         * ���ò˵�,���¼��Ƴ��������û�
         * @param {dom} $menuItem Ҫ���õ�item��Ԫ��
         */
        _disable:function($menuItem){
            var $a = $menuItem.children('a');
    		$a.attr('cui_href', $a.attr('href')).attr('href', 'javascript:;').css('cursor','default')
                .children('span').addClass('menu_item_disable');
    		$menuItem.attr('disabled', true);
        },
        /**
         * ���ò˵�
         * @param {dom} $menuItem Ҫ���õ�item��Ԫ��
         */
        _enable:function($menuItem){
            var $a = $menuItem.children('a');
            $a.attr('href', $a.attr('cui_href')).removeAttr('cui_href').css('cursor','pointer')
                .children('span').removeClass('menu_item_disable');
        	$menuItem.attr('disabled', false);
        },
        /**
         * ��ʾ�˵�
         */
        show:function(el){
        	this._loadMenu();
        	this.objMenu.show();
        	if(!el){
        		el = this.options.el;
        	}
        	this._setWidth(el);
    		this._setPosition(el);
        	this._setIframe(this.objMenu);
        	var self = this;
        },
        /**
         * ���ز˵�
         */
        hide:function(){
        	this.objMenu && this.objMenu.hide();
        },
        /**
         * ���û����õ����˵�
         * @param {string} itemId Ҫ���õ�item��Ԫ�ص�id
         * @param {boolean} flag ����Ƿ����
         */
        disable:function(itemId,flag){
        	this._loadMenu();
        	var $menuItem = $("#" + itemId);
        	 if(flag == true){
        		 this._disable($menuItem);
             }else{
            	 this._enable($menuItem);
             }
        },
        /**
         * ���ò˵���label
         */
        setLabel:function(itemId,label){
        	this._loadMenu();
        	var menuItem = $("#" + itemId);
        	menuItem.children('a').children('span').html(label);
        }
    })
})(window.comtop.cQuery, window.comtop);