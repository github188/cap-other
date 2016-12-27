/* ============================================================
 * bootstrap-dropdown.js v2.3.2
 * http://getbootstrap.com/2.3.2/javascript.html#dropdowns
 * ============================================================
 * 基于bootstrap修改
 * ============================================================ */
!function ($) {

  "use strict"; // jshint ;_;


 /* DROPDOWN CLASS DEFINITION
  * ========================= */
 
  var toggle = '[data-toggle=dropdown]'
    , Dropdown = function (element) {
        var $el = $(element).off('click.dropdown.workbench').on('click.dropdown.workbench', this.toggle)
        $('html').off('click.dropdown.workbench').on('click.dropdown.workbench', function () {
          $el.parent().removeClass('open')
        })
      }

  Dropdown.prototype = {

    constructor: Dropdown

  , toggle: function (e) {
      if(clearTimeout){
          window.clearTimeout(clearTimeout);
      }
      var $this = $(this)
        , $parent
        , isActive

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      clearMenus()
      if (!isActive) {
        if ('ontouchstart' in document.documentElement) {
          // if mobile we we use a backdrop because click events don't delegate
          $('<div class="dropdown-backdrop"/>').insertBefore($(this)).off('click').on('click', clearMenus)
        }
        $parent.toggleClass('open')
        $this.siblings('.dropdown-menu').attr('tabindex','-1').focus();
      }
 
      //$this.focus();
      return false;
    }

  , keydown: function (e) {
      var $this
        , $items
        , $active
        , $parent
        , isActive
        , index

      if (!/(38|40|27)/.test(e.keyCode)) return

      $this = $(this)

      e.preventDefault()
      e.stopPropagation()

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      if (!isActive || (isActive && e.keyCode == 27)) {
        if (e.which == 27) $parent.find(toggle).focus()
        return $this.click()
      }

      $items = $('[role=menu] li:not(.divider):visible a', $parent)

      if (!$items.length) return

      index = $items.index($items.filter(':focus'))

      if (e.keyCode == 38 && index > 0) index--                                        // up
      if (e.keyCode == 40 && index < $items.length - 1) index++                        // down
      if (!~index) index = 0

      $items
        .eq(index)
        .focus()
    }

  }

  function clearMenus() {
    $('.dropdown-backdrop').remove()
    $(toggle).each(function () {
      getParent($(this)).removeClass('open')
    })
  }

  function getParent($this) {
    var selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = selector && $(selector)

    if (!$parent || !$parent.length) $parent = $this.parent()
    return $parent
  }

  /* APPLY TO STANDARD DROPDOWN ELEMENTS
   * =================================== */
  var clearTimeout = null;
  $(document)
    //.off('click.dropdown.workbench').on('click.dropdown.workbench', clearMenus)
    .off('blur.dropdown.workbench','.dropdown-menu').on('blur.dropdown.workbench','.dropdown-menu', function(){
        //设置延迟是为了先执行click事件然后再执行失焦事件
        clearTimeout = window.setTimeout(clearMenus,200);
    })
    .off('click.dropdown.workbench'  , toggle).on('click.dropdown.workbench'  , toggle, Dropdown.prototype.toggle)
    .off('keydown.dropdown.workbench', toggle + ', [role=menu]').on('keydown.dropdown.workbench', toggle + ', [role=menu]' , Dropdown.prototype.keydown)
    .off('click.dropdown.workbench','.menu a').on('click.dropdown.workbench','.menu a',function(){
        var $this = $(this);
        if ($this.hasClass('dropdown-toggle')) {
            return;
        }
        clearMenus();
        $this.parents('li').addClass('active').siblings().removeClass('active').find('li').removeClass('active');
        //$this.closest('li').addClass('active').siblings().removeClass('active').filter('.dropdown,.dropdown-submenu').find('li').removeClass('active');
        //$this.closest('.dropdown').addClass('active').siblings().removeClass('active');
    });
}(window.jQuery);

/* ========================================================================
 * Bootstrap: scrollspy.js v3.1.0
 * http://getbootstrap.com/javascript/#scrollspy
 * ========================================================================
 * 基于bootstrap修改
 * ======================================================================== */
+function ($) {
    'use strict';

    // SCROLLSPY CLASS DEFINITION
    // ==========================

    function ScrollSpy(element, options) {
        var href
        var process  = $.proxy(this.process, this)

        this.$element       = $(element).is('body') ? $(window) : $(element)
        this.$body          = $('body')
        this.$scrollElement = this.$element.on('scroll.bs.scroll-spy.data-api', process)
        this.options        = $.extend({}, ScrollSpy.DEFAULTS, options)
        this.selector       = (this.options.target
            || ((href = $(element).attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
            || '') + ' .nav li > a'
        this.offsets        = $([])
        this.targets        = $([])
        this.activeTarget   = null

        this.refresh()
        this.process()
    }

    ScrollSpy.DEFAULTS = {
        offset: 10
    }

    ScrollSpy.prototype.refresh = function () {
        var offsetMethod = this.$element[0] == window ? 'offset' : 'position'

        this.offsets = $([])
        this.targets = $([])

        var self     = this
        var $targets = this.$body
            .find(this.selector)
            .map(function () {
                var $el   = $(this)
                var href  = $el.data('target') || $el.attr('href')
                var $href = /^#./.test(href) && $(href)

                return ($href
                    && $href.length
                    && $href.is(':visible')
                    && [[ $href[offsetMethod]().top + (!$.isWindow(self.$scrollElement.get(0)) && self.$scrollElement.scrollTop()), href ]]) || null
            })
            .sort(function (a, b) { return a[0] - b[0] })
            .each(function () {
                self.offsets.push(this[0])
                self.targets.push(this[1])
            })
    }

    ScrollSpy.prototype.process = function () {
        var scrollTop    = this.$scrollElement.scrollTop() + this.options.offset
        var scrollHeight = this.$scrollElement[0].scrollHeight || this.$body[0].scrollHeight
        var maxScroll    = scrollHeight - this.$scrollElement.height()
        var offsets      = this.offsets
        var targets      = this.targets
        var activeTarget = this.activeTarget
        var i

        if (scrollTop >= maxScroll) {
            return activeTarget != (i = targets.last()[0]) && this.activate(i)
        }

        if (activeTarget && scrollTop <= offsets[0]) {
            return activeTarget != (i = targets[0]) && this.activate(i)
        }

        for (i = offsets.length; i--;) {
            activeTarget != targets[i]
                && scrollTop >= offsets[i]
                && (!offsets[i + 1] || scrollTop <= offsets[i + 1])
            && this.activate( targets[i] )
        }
    }

    ScrollSpy.prototype.activate = function (target) {
        this.activeTarget = target

        $(this.selector)
            .parentsUntil(this.options.target, '.active')
            .removeClass('active')

        var selector = this.selector +
            '[data-target="' + target + '"],' +
            this.selector + '[href="' + target + '"]'

        var active = $(selector)
            .parents('li')
            .addClass('active')

        if (active.parent('.dropdown-menu').length) {
            active = active
                .closest('li.dropdown')
                .addClass('active')
        }

        active.trigger('activate.bs.scrollspy')
    }


    // SCROLLSPY PLUGIN DEFINITION
    // ===========================

    var old = $.fn.scrollspy

    $.fn.scrollspy = function (option) {
        return this.each(function () {
            var $this   = $(this)
            var data    = $this.data('bs.scrollspy')
            var options = typeof option == 'object' && option

            if (!data) $this.data('bs.scrollspy', (data = new ScrollSpy(this, options)))
            if (typeof option == 'string') data[option]()
        })
    }

    $.fn.scrollspy.Constructor = ScrollSpy


    // SCROLLSPY NO CONFLICT
    // =====================

    $.fn.scrollspy.noConflict = function () {
        $.fn.scrollspy = old
        return this
    }


    // SCROLLSPY DATA-API
    // ==================

    $(window).on('load', function () {
        $('[data-spy="scroll"]').each(function () {
            var $spy = $(this)
            $spy.scrollspy($spy.data())
        })
    })

}(jQuery);

//重新定义console,解决调试代码问题
window.console = window.console || (function(){  
    var c = {}; c.log = c.warn = c.debug = c.info = c.error = c.time = c.dir = c.profile  
    = c.clear = c.exception = c.trace = c.assert = function(){};  
    return c;  
})();
var css = {
    load: function(url) {
        var nowDate = new Date();
        var link = document.createElement("link");
        link.type = "text/css";
        link.rel = "stylesheet";
        link.href = url + '?v=' + nowDate.getFullYear() + nowDate.getMonth() + nowDate.getDate();
        document.getElementsByTagName("head")[0].appendChild(link);
        return this;
    }
};
/**jquery扩展,设置最小高度**/
!function($){
    var ieVersion = navigator.userAgent.toLowerCase().match(/msie ([\d.]+)/);
    $.fn.setMinHeight = function(minHeight){
        $this = $(this);
        $this.each(function(index,item){
            var $item = $(item);
            $item.css({'min-height':minHeight});
            if(ieVersion && ieVersion[1] == '6.0'){
                $item.css({'height':minHeight});
            }
        });
    };
}(window.jQuery);

var Workbench = {
    mainFrameUrl:'/top/workbench/app.ac',
    formatUrl:function(url){
        if(!url){
            return '';
        }
        url +='';
        try{
        	//出现无法解码的额问题（但是这里为什么要界面呢？没看见有编码的地方啊，先catch处理吧）
            url = decodeURIComponent(url);
        }catch(e){
        	
        }

        //IE缓存问题,每次请求加一个随机数
        if(url.indexOf('?')>0){//含有'?'
            url =url+'&tSession='+new Date().getTime(); 
         }else{
        	 url =url+'?tSession='+new Date().getTime(); 
         }
        if(url.indexOf('http')==0){
            return url;
        }
        if(url.indexOf('/')!=0){//非'/'开头
           url = '/' + url; 
        }
        if(url.indexOf(webPath)==0){
            return url;
        }
        return webPath + url;
    },
    openInMainFrame:function(url,target,appCode,showNav){
        target = target || '_top';
        //如果已存在主框架页面,且指定在主框架页面中打开
        var $iframe = $('iframe[name=mainFrame]');
        if($iframe.length>0 && target=='mainFrame'){
            $iframe.attr('src',this.formatUrl(url));
        }else{
            if(url.indexOf(this.mainFrameUrl)>-1){
                window.open(Workbench.formatUrl(url),target);
            }else{
                var baseUrl = webPath + this.mainFrameUrl;
                baseUrl += appCode?('?appCode=' + appCode + (showNav===false?('&showNav=' + showNav):'')):'';
                var _menuCode = encodeURIComponent('@bMenuCode=');
                var _a =encodeURIComponent('@');
                var menuCode =url.indexOf(_menuCode)!=-1?
                		(url.substring(url.indexOf(_menuCode)+_menuCode.length, 
                				url.indexOf(_a,url.indexOf(_menuCode)+_menuCode.length))):'';
                if(menuCode!=''){
                	baseUrl+="&bMenuCode="+menuCode;
                	url = url.substring(0,url.indexOf(_menuCode))+url.substring(url.indexOf(_a,url.indexOf(_menuCode)+_menuCode.length)+_a.length,url.length);
                }
                window.open(baseUrl + '#url=' +this.formatUrl(url),target); 
            }
        }
    }
};

/**
 *统一页面打开监听,方便以后设置新页面打开还是当前页面打开 
 */
!function($){
    $(document).on('click','[data-url]',function(){
        var $this = $(this);
        var target = $this.attr('target') || '_top';
        var data = $this.data();
        if(!data||!data.url){
            return;
        }
        //判断url配置中是否有参数openType
        var exp = /(openType=(\w+))/i;
        var hash = data.url.match(exp);
        //url中包含openType并且点击的一级菜单没有二级菜单，不做iframe刷新
        if(hash){
        	if(!hasSecondMenu){
        		return false;
        	}
        }
        
        //判断是否主框架页面打开
        if(data.mainframe!==false){
            Workbench.openInMainFrame(data.url,target,data.appcode,data.shownav);
        }else{
            window.open(Workbench.formatUrl(data.url),target);
        }
        return false;
    });
}(window.jQuery);

/**
 *回到顶部 
 */
!function($){
    $(function(){
        $(window).scroll(function(){
            if($(window).scrollTop() > 0){
                $('.goto-top').show();
            }else{
                $('.goto-top').hide();
            }
        });
        $('.goto-top').click(function(){
            $(window).scrollTop(0);
        });
    });
}(window.jQuery);

//特殊字符转义
function replaceSpecialSymbols(text){
	if(text != null){
    	text = text.replace(/&/g,'&amp;');
    	text = text.replace(/"/g,'&quot;');
    	text = text.replace(/</g,'&lt;');
    	text = text.replace(/>/g,'&gt;');
    	text = text.replace(/ /g,'&nbsp;');
	}
	return text;
}

//URL中特殊字符转义
function replaceSpecialSymbolsInUrl(text){
	if(text !=null){
		text = text.replace(/%/g,'%25');
		text = text.replace(/ /g,'%20');
		text = text.replace(/\+/g,'%2B');
		text = text.replace(/\//g,'%2F');
		text = text.replace(/\?/g,'%3F');
		text = text.replace(/#/g,'%23');
		text = text.replace(/&/g,'%26');
		text = text.replace(/=/g,'%3D');
		text = text.replace(/"/g,'%22');
		text = text.replace(/@/g,'%40');
		text = text.replace(/\\/g,'%5C');
	}
	return text;
}