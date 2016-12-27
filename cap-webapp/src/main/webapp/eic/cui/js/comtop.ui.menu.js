;(function($, C){
    /**
     * @class C.UI.Button
     * @extends C.UI.Base
     * ???UI???<br>
     *
     * 1.????????????????????<br>
     * 2.???????????????????<br>
     * 3.???????????????<br>
     * 4.???????????????<br>
     * 5.??????????????<br>
     * 6.??????¨°???þŸ<br>
     * 7.??????¨°?????????<br>
     * @author ???
     * @version 1.0
     * @history 2012-10-19 ??? ???
     * @demo demo/menuDemo.html
     */
    C.UI.Menu = C.UI.Base.extend({
        options: {
            uitype:'Menu',//????????menu
            trigger:'click',//?????????????click|| hover
            width:'',//???????
            on_click:null,//??????
            datasource:null//?????????
        },
        _init: function(){
            var self = this;
            self.objMenu = null;//????????????
            self.objItemMap = {};//????item??????????????????????????
            self.hideTimeout = null;//??????el????timeout
        },
        
        /**
         * ???????Ùã??
         */
        _create:function(){
        	var self = this;
        	var el = this.options.el;
        	var trigger = self.options.trigger;
        	
        	el.bind(trigger,function(e){
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
         * ???????
         * @param {dom} $parent  ??????????
         * @param {dom} datasource ????
         */
        _loadTemplate:function($parent, datasource){
        	var menuDom = this._buildTemplateStr('menuDom', datasource);
        	menuDom = this._bindTplEvent(menuDom);
        	var $menuDom = $(menuDom);
        	$parent.append($menuDom);
        	var $children = $menuDom.find('li');
        	for (var i = 0; i < datasource.length; i ++) {
        		var item = datasource[i];
        		this.objItemMap[item.id] 	= item;//????item??????????????????????????
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
         * ??????
         */
        _loadMenu:function(){
        	if(this.objMenu == null){
        		var opts = this.options;
        		if($.isFunction(opts.datasource)){//???????????????????§Ù?????????
        			opts.datasource = opts.datasource();
            	}
        		this.setDatasource(opts.datasource);
        		
        	}
        },
        /**
         * ?????????????
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
         * ???????????????,???????
         * @param {event} e mouseover???
         * @param {dom} eventEl  ????????????DOM????
         * @param {dom} target ????????????????DOM????
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
         * ??????????????????????????
         * @param {event} e mouseout???
         * @param {dom} eventEl  ????????????DOM????
         * @param {dom} target ????????????????DOM????
         */
        _mouseoutHandler:function(e, eventEl, target){
        	if($('#' + eventEl.id).attr('disabled'))return;
        	var $subMenu = $(eventEl).children('.menu_box');
        	eventEl.mouseTimeout = setTimeout(function(){
        		$subMenu.hide();
        	},100);
        },
        /**
         * ?????????????
         * @param {event} e click???
         * @param {dom} eventEl  ????????????DOM????
         * @param {dom} target ????????????????DOM????
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
        	//??§Ý??????
        	this.options.on_click && this.options.on_click(this.objItemMap[eventEl.id]);//objItemMap??????menu?????????
        },
        /**
         * ?????????????¦Ë??????????????
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
        	//??????¦Ë?¨°???¦Ë?????????????¦Ë??????????????????§³??10??????????????¦Ë??
        	if(winWidth - (itemOffestPosition.left + elWidth + subMenuWidth) < 10 && (itemOffestPosition.left - elWidth) > 0){
        		cssObj.left = 0 -  subMenuWidth + 4;//??4??œZ?????????§¹??
        		cssObj.right = "auto";
        	}else{//????????
        		cssObj.left = "auto";
        		cssObj.right = 4;
        	}
        	//????¡À?¦Ë?¨°???¦Ë?????????????¦Ë??????????????????
    		if(winHeight - (itemOffestPosition.top + elHeight + subMenuHeight) < 10 && (itemOffestPosition.top - subMenuHeight) > 0){
    			cssObj.bottom = 0 + subMenuHeight - 4;//-4?????ul??padding??border
    			cssObj.top =  "auto";
    		}else{//??????¡À?
    			cssObj.bottom =  "auto";
    			cssObj.top =  - 4;
    		}
    		$menuBox.css(cssObj);
        },
        /**
         * ???¨°????¦Ë??
         * @param {dom} el ???¦Ë?¨°¦Ï??????
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
        	//????¡À?¦Ë?¨°???¦Ë?????????????¦Ë??????????????????
        	if(winHeight - (elOffestPosition.top + elHeight + menuHeight) < 0 && (elOffestPosition.top  - menuHeight) > 0){
        		menuTop = elOffestPosition.top - menuHeight;
        	}else{//??????¡À?
        		menuTop = elOffestPosition.top + elHeight;
        	}
        	//??????¦Ë?¨°???¦Ë?????????????¦Ë??????????????????
        	if(winWidth - (elOffestPosition.left + menuWidth) < 0 && (elOffestPosition.left + elWidth - menuWidth) > 0){
        		menuLeft = elOffestPosition.left  + elWidth - menuWidth;
        	}else{//????????
        		menuLeft = elOffestPosition.left;
        	}
        	this.objMenu.css({
        		left:menuLeft,
        		top:menuTop
        	});
        },
        /**
         * ???¨°??????,????????????????ie6??????minWidth??????????????????
         * @param {dom} el ??????¦Ï??????
         */
        _setItemsWidth:function($ul,menuWidth){
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
         * ???¨°??iframe??????????ie6?????
         * @param {dom} $menu menu???
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
         * ???¨°?????
         * @param {dom} el ??????¦Ï??????
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
         * ???¨°??,???????????????
         * @param {dom} $menuItem ??????item?????
         */
        _disable:function($menuItem){
    		 $menuItem.children('a').children('span').addClass('menu_item_disable');
    		 $menuItem.attr('disabled',true);
        },
        /**
         * ???¨°??
         * @param {dom} $menuItem ??????item?????
         */
        _enable:function($menuItem){
        	 $menuItem.children('a').children('span').removeClass('menu_item_disable');
        	 $menuItem.attr('disabled',false);
        },
        /**
         * ??????
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
         * ??????
         */
        hide:function(){
        	this.objMenu && this.objMenu.hide();
        },
        /**
         * ???????????????
         * @param {string} itemId ??????item??????id
         * @param {boolean} flag ?????????
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
         * ???¨°????label
         */
        setLabel:function(itemId,label){
        	this._loadMenu();
        	var menuItem = $("#" + itemId);
        	menuItem.children('a').children('span').html(label);
        }
    })
})(window.comtop.cQuery, window.comtop);