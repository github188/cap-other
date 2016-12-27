;(function($, C){
    /**
     * @class C.UI.Button
     * @extends C.UI.Base
     * 菜单UI组件<br>
     *
     * 1.通过属性配置能生成菜单。<br>
     * 2.通过配置可设置按钮的宽度。<br>
     * 3.配置数据源获取数据。<br>
     * 4.通过配置显示菜单。<br>
     * 5.动态添加或删除菜单。<br>
     * 6.动态禁用菜单项。<br>
     * 7.动态设置菜单项的名称。<br>
     * @author 谭国华
     * @version 1.0
     * @history 2012-10-19 谭国华 新建
     * @demo demo/menuDemo.html
     */
    C.UI.Menu = C.UI.Base.extend({
        options: {
            uitype: 'Menu',//组件类型，menu
            trigger: 'click',//组件触发的方式，click|| hover
            width: '',//菜单的宽度
            on_click: null,//点击事件
            datasource: null//菜单的数据源
        },
        _init: function(){
            var self = this;
            self.objMenu = null;//下拉菜单的对象
            self.objItemMap = {};//缓存item的对象，在响应点击事件的时候用到。
            self.hideTimeout = null;//鼠标移开el时候的timeout
        },
        
        /**
         * 初始化模板方法
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
         * 加载模板
         * @param {dom} $parent  要用到的父节点
         * @param {dom} datasource 数据源
         */
        _loadTemplate:function($parent, datasource){
        	var menuDom = this._buildTemplateStr('menuDom', datasource);
        	menuDom = this._bindTplEvent(menuDom);
        	var $menuDom = $(menuDom);
        	$parent.append($menuDom);
        	var $children = $menuDom.find('li');
        	for (var i = 0; i < datasource.length; i ++) {
        		var item = datasource[i];
        		this.objItemMap[item.id] 	= item;//缓存item的对象，在响应点击事件的时候用到。
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
         * 加载菜单
         */
        _loadMenu:function(){
        	if(this.objMenu == null){
        		var opts = this.options;
        		if($.isFunction(opts.datasource)){//如果传入的是一个方法就执行方法获得数据
        			opts.datasource = opts.datasource();
            	}
        		this.setDatasource(opts.datasource);
        		
        	}
        },
        /**
         * 设置数据源的方法
         */
        setDatasource:function(datasource){
        	if(datasource){
        		var opts = this.options;
	        	this.objMenu = this._loadTemplate($('body'), datasource);
	        	var self = this;
	        	this.objMenu.bind('mouseover',function(e){
	        		self.hideTimeout && clearTimeout(self.hideTimeout);
                    if(typeof  window._cui_button_timer!=="undefined"){
                        clearTimeout(window._cui_button_timer);
                    }
	        	});
	        	this.objMenu.bind('mouseout',function(e){
	        		self.hideTimeout = setTimeout(function(){
	        			self.objMenu.hide();
	        		},100);
	        	});
        	}
        },
        /**
         * 鼠标移过菜单响应方法,显示子菜单
         * @param {event} e mouseover事件
         * @param {dom} eventEl  指向绑定事件的原生DOM对象
         * @param {dom} target 指向事件捕捉到的原生DOM对象
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
         * 鼠标移开菜单响应方法，隐藏子菜单
         * @param {event} e mouseout事件
         * @param {dom} eventEl  指向绑定事件的原生DOM对象
         * @param {dom} target 指向事件捕捉到的原生DOM对象
         */
        _mouseoutHandler:function(e, eventEl, target){
        	if($('#' + eventEl.id).attr('disabled'))return;
        	var $subMenu = $(eventEl).children('.menu_box');
        	eventEl.mouseTimeout = setTimeout(function(){
        		$subMenu.hide();
        	},100);
        },
        /**
         * 点击菜单响应方法
         * @param {event} e click事件
         * @param {dom} eventEl  指向绑定事件的原生DOM对象
         * @param {dom} target 指向事件捕捉到的原生DOM对象
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
        	//执行回调函数
        	this.options.on_click && this.options.on_click(this.objItemMap[eventEl.id]);//objItemMap在载入menu的时候缓存了。
        },
        /**
         * 设置子菜单的显示位置，做了碰边处理
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
        	//如果右边位置不够位置显示，而左边够位置显示，就显示在左边。小于10是避免临界滚动条占位。
        	if(winWidth - (itemOffestPosition.left + elWidth + subMenuWidth) < 10 && (itemOffestPosition.left - elWidth) > 0){
        		cssObj.left = 0 -  subMenuWidth + 4;//加4是规范要实现重叠的效果
        		cssObj.right = "auto";
        	}else{//显示在右边
        		cssObj.left = "auto";
        		cssObj.right = 4;
        	}
        	//如果下边位置不够位置显示，而左边够位置显示，就显示在上边。
    		if(winHeight - (itemOffestPosition.top + elHeight + subMenuHeight) < 10 && (itemOffestPosition.top - subMenuHeight) > 0){
    			cssObj.bottom = 0 + subMenuHeight - 4;//-4是减掉ul的padding和border
    			cssObj.top =  "auto";
    		}else{//显示在下边
    			cssObj.bottom =  "auto";
    			cssObj.top =  -1;
    		}
    		$menuBox.css(cssObj);
        },
        /**
         * 设置菜单的位置
         * @param {dom} el 作为位置参考的元素
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
        	//如果下边位置不够位置显示，而左边够位置显示，就显示在上边。
        	if(winHeight - (elOffestPosition.top + elHeight + menuHeight) < 0 && (elOffestPosition.top  - menuHeight) > 0){
        		menuTop = elOffestPosition.top - menuHeight;
        	}else{//显示在下边
        		menuTop = elOffestPosition.top + elHeight;
        	}
        	//如果右边位置不够位置显示，而左边够位置显示，就显示在左边。
        	if(winWidth - (elOffestPosition.left + menuWidth) < 0 && (elOffestPosition.left + elWidth - menuWidth) > 0){
        		menuLeft = elOffestPosition.left  + elWidth - menuWidth;
        	}else{//显示在右边
        		menuLeft = elOffestPosition.left;
        	}
        	this.objMenu.css({
        		left:menuLeft,
        		top:menuTop
        	});
        },
        /**
         * 设置菜单项宽度,自适应宽度，因为万恶的ie6不能用minWidth属性，所以只能自己实现
         * @param {dom} el 作为宽度参考的元素
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
         * 设置菜单iframe项宽高，为万恶的ie6而设的
         * @param {dom} $menu menu元素
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
         * 设置菜单宽度
         * @param {dom} el 作为宽度参考的元素
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
         * 禁用菜单,把事件移除，字体置灰
         * @param {dom} $menuItem 要禁用的item的元素
         */
        _disable:function($menuItem){
            var $a = $menuItem.children('a');
    		$a.attr('cui_href', $a.attr('href')).attr('href', 'javascript:;').css('cursor','default')
                .children('span').addClass('menu_item_disable');
    		$menuItem.attr('disabled', true);
        },
        /**
         * 启用菜单
         * @param {dom} $menuItem 要启用的item的元素
         */
        _enable:function($menuItem){
            var $a = $menuItem.children('a');
            $a.attr('href', $a.attr('cui_href')).removeAttr('cui_href').css('cursor','pointer')
                .children('span').removeClass('menu_item_disable');
        	$menuItem.attr('disabled', false);
        },
        /**
         * 显示菜单
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
         * 隐藏菜单
         */
        hide:function(){
        	this.objMenu && this.objMenu.hide();
        },
        /**
         * 禁用或启用单个菜单
         * @param {string} itemId 要禁用的item的元素的id
         * @param {boolean} flag 标记是否禁用
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
         * 设置菜单的label
         */
        setLabel:function(itemId,label){
        	this._loadMenu();
        	var menuItem = $("#" + itemId);
        	menuItem.children('a').children('span').html(label);
        }
    })
})(window.comtop.cQuery, window.comtop);
