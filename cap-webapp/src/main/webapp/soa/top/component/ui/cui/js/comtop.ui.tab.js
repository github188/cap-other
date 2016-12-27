
/**
 * comtop.ui.Tab标签页组件
 *
 */
;(function($, C){
    // 常量定义
    /**
     * Tab
     * @type {}
     */
    comtop.UI.Tab = comtop.UI.Base.extend({
        options: {
            uitype: "Tab",
            /**
             父容器无高度时，tab的高度根据tab页的内容自适应
             此高度是tab页整体的高度，tab页内容的高度=tab页整体的高度-tab_height；
             */
            width: 0,
            height: 0,
            tab_width:65,
            active_index: 0,
            /**
             * 传进来的tab参数.<br>
             * 格式:
             * {
			 *     "title": "title", 
			 *     "html": "innerHTML", //div; 这里可以传innerHTML字符串,也可以传一个DOM节点|jQuery对象.
			 *     "url": "url", //iframe; html,url二选一
			 *     "closeable": "true|false", 
			 *     "tab_width": "" //注意没有height. 因为每个tab高度一致;
			 * }
             *
             * @type {Array}
             */
            tabs: [],
            fill_height : false,
            reload_on_active: true, //激活时重新加载内容
            closeable: false, //是否可关闭
            trigger_type: "click"
        },
        _className:{
            parentCls:"cui-tab",
            navCls: "cui-tab-nav",
            contentCls: "cui-tab-content",
            titleCls: "cui-tab-title",
            activeTriggerCls: "cui-active",
            hoverTriggerCls: "cui-tab-hover",
            closeTriggerCls: "cui-tab-close"
        },
        /**
         * 当前正激活的tab页
         * @type {Number}
         */
        active_index: 0,

        /**
         * tab页导航条
         * @type {Array} [DOM, DOM, ...]
         */
        navs: [],

        /**
         * tab导航条上的标题
         * @type {Array} [DOM, DOM, ...]
         */
        titles: [],

        /**
         * tab页的内容
         * @type {Array} [DOM, DOM, ...]
         */
        contents: [],

        /**
         * tab页中iframe的url,如果存在iframe的话,不是iframe则保存为false
         * @type {Array}
         */
        urls: [],

        /**
         * 支持的事件列表
         * @type {Array} [string, ...]
         */
        events: ["switch"],

        /**
         * tabs里面on_switch的处理函数，如果有就是函数的赋值，如果没有则保存为false；
         * @type {Array} [string, ...]
         */
        handles: [],

        _initUrl:function(){
            this.urls = $.map(this.options.tabs, function(tab) {
                return tab.url || false;
            });
        },
        _initHandles:function(){
            this.handles = $.map(this.options.tabs, function(tab) {
                return tab.on_switch || false;
            });
        },
        _init: function() {
            var op= this.options;
            op.tab_width=C.Tools.fixedNumber(op.tab_width);
            op.width=C.Tools.fixedNumber(op.width);
            op.height=C.Tools.fixedNumber(op.height);
            this.active_index = this.options.active_index || 0;
            $.each(op.tabs,function(index,tab){
                if(typeof tab.html=="object"){
                    $(tab.html).hide();
                }
                tab.tab_width=C.Tools.fixedNumber(tab.tab_width);
            });
            if(this.options.el.html().replace(/\s+/g,"")!=""){//初始化时el内部有html代码，此时认为使用的是html模板
              this._isHTMLTemplate=true;
            }

        },

        _create: function() {
            var opt=this.options,
                container = opt.el,
                DOT = ".",
                _self = this;
            if(this._isHTMLTemplate){
                this._initStructures();
            }
            this._initUrl();
            this._initHandles();
            //此高度为tab未加载任何外部资源时的高度
            this._navHeight=$(DOT + this._className.parentCls,container).height();
            if(opt.fill_height) {
                var parent=opt.el.parent();
                if(parent.prop("tagName") === 'BODY') {
                    var h = $.client.height(),
                        margin = parseInt(parent.css("marginTop")) + parseInt(parent.css("marginBottom"));
                    opt.height =h- margin;
                    this._resizeHandle();
                }else{
                    opt.height =parent.height();
                }

            }
            this._parseMarkup();
            this._setUpHeight();
            this._initView(true);
            this._bindTriggers();
        },
        _initStructures:function(){
            var tabs= [],
                opt=this.options;
            $.each(opt.el.children(),function(){
                var data=$(this).attr("data-options");
                try{
                   data= $.parseJSON(data);
                }catch(e){
                    data={};
                }
                if(typeof data.closeable=="string"){
                    data.closeable=data.closeable==="true";
                }
                if(typeof data.tab_width=="string"){
                    data.tab_width=parseInt(data.tab_width);
                }
                if(!data.url){
                    data.html=$(this).children();
                }
                tabs.push(data);
            });
            this.options= $.extend({},this.options,{tabs:tabs});
            this.options.el.children().hide();
            this._buildTemplate(this.options.el,"tab",this.options,true);
        },
        _resizeHandle : function () {
            var self = this;
            var opt = this.options;
            self.h = $.client.height();
            function resize () {
                var h = $.client.height();
                self.resize(opt.el.height() + h - self.h);
                self.h = h;
            }
            $(window).on("resize", resize);
        },
        /**
         * 解析DOM,并初始化navs, titles, contents等成员变量
         */
        _parseMarkup: function() {
            var cls=this._className,
                container = this.options.el,
                DOT = ".",
                navsContainer=$(DOT + cls.navCls, container),
                contentsContainer=$(DOT + cls.contentCls, container);
            this.navs = navsContainer.children(); //li
            this.titles = $(DOT + cls.titleCls, container); //span
            this.contents = contentsContainer.children(); //div
        },
        /**
         *  设置高度
         */
        _setUpHeight:function(){
            var opt=this.options,
                contentHeight;
            if (!opt.height) {
                this.contents.each(function(){
                   var node= $(this).get(0);
                     if(node.nodeName==="DIV"||node.nodeName==="IFRAME"){
                         node.style.height="";
                     }
                });
                return;
            }
            contentHeight=opt.height-this._navHeight;
            contentHeight=contentHeight<10?10:contentHeight;
            //设置内容DIV高度
            opt.content_height=contentHeight;

        },
        ////////////////////////////////////////////////
        //
        //   Public
        //
        ////////////////////////////////////////////////
        /**
         * 获取tab页的属性或设置tab页的属性
         *
         * @param {string} 获取tab页的某一个属性
         * @param {} 获取tab页的所有属性
         * @param {json} 设置tab页的属性,return {this}
         */
        attr:function(){
            var args=arguments;
            if(args.length==0){
                return $.extend(true,{},this.options);
            }else if(args.length==1){
                if(typeof args[0]==="string"){
                    var res=this.options[args[0]];
                    if(args[0]=="width"){
                        res=$(this.options.el).width();
                    }
                    if(args[0]=="height"){
                        res=$(this.options.el).height();
                    }
                    return res;

                }else if(typeof args[0]==="object"){
                    var opt = this.options;
                    $.extend(this.options, args[0]);
                    this._setUpHeight();
                    this._initView(false);
                    /*
                     if (args[0].height !== undefined) {
                     opt.el.css("height", opt.height);
                     }
                     if (args[0].width !== undefined) {
                     opt.el.css("width", opt.width)
                     }
                     */
                    return this;
                }
            }
        },
        /**
         * 切换到指定的tab页
         *
         * @param {number} index  切换到的页面
         * @return {this}         当前对象, //chain
         */
        switchTo: function(index) {
            this._switchTo(index);
            return this;
        },

        /**
         * 下一页
         */
        next: function() {
            this.switchTo((this.active_index + 1) % this.navs.length);
            return this;
        },

        /**
         * 上一页
         */
        prev: function() {
            var len = this.navs.length;
            this.switchTo((this.active_index - 1 + len) % len);
            return this;
        },
        onClose:function(fn){
            $(this).bind("close",fn);
            return this;
        },
        /**
         * resize tab页
         *
         * @param  { number} height tab页的高度
         * @param  { number} width (可选)tab页的宽度，不指定默认自动适应父容器的宽度
         */
        resize:function(height,width){
            var obj={};
            if(typeof height=="number"){obj.height=height;}
            if(typeof width=="number"){obj.width=width;}
            $.extend(this.options,obj);
            this._setUpHeight();
            var opt = this.options,
                content = $("." + this._className.contentCls, opt.el),
                Browser = C.Browser;
            if(opt.width) {
                opt.el.width(opt.width);
                var opt_width = typeof opt.width === "number" ? (opt.width - ( Browser.isIE && Browser.isQM ? 0 : 6 ) ) : opt.width;
                content.width(opt_width);
            }
            if(opt.content_height) {
                content.height(opt.content_height + ( Browser.isIE && Browser.isQM ? 10 : 0 ));
            }
        },
        /**
         * 添加一个tab<br>
         * 调用方式:
         * 1. addTab("标题1", "abc.jsp");
         * 2. addTab({"title":"Test","url": "abc.jsp", "width": "300px"});
         * @param {string} title Tab页的标题
         * @param {string} url  Tab页的url
         *
         * @param { object}    Tab页的json配置
         *
         *
         *
         */
        addTab: function() {
            var selfOptions=this.options;
            var opts = {
                    title:"",
                    closeable:selfOptions.closeable,
                    tab_width:selfOptions.tab_width
                }, arg=arguments,
                len = this.navs.length;
            if(arg.length==2){
                opts["title"] = arg[0];
                opts["url"] = arg[1];
            }else if(arg.length==1&&typeof(arg[0])=="object"){
                $.extend(opts, arg[0]);
            }
            selfOptions.tabs[len] = opts;
            this._add(opts);
            return this;
        },

        /**
         * 移除一个tab
         * @param {number} index   第i个tab页
         */
        removeTab: function(index) {
            if(index < this.navs.length&&this.navs.length>1) {
                if(this.active_index === index) {
                    this.next();
                }
                this.navs.eq(index).remove();
                this.contents.eq(index).remove();
                this.urls.splice(index,1);
                // 移除的tab如果在当前tab左边时,需要-1; 如果是在右边则不需要.
                if(this.active_index > 0 && index < this.active_index) {
                    this.active_index--;
                }

                var tab=this.options.tabs.splice(index, 1);

                // re init memebers: navs, contents, titles
                this._parseMarkup();
                $(this).triggerHandler("close", tab);

            }
            return this;
        },

        /**
         * 获取当前激活的tab
         * @return {DOM} 当前激活的tab
         */
        getActiveTab: function() {
            return this.getTab(this.active_index);
        },

        /**
         * 获取tab页 或者 tab的相关属性
         *
         * @param  {number} index 第几个tab页
         * @param  {string} name  (可选)要获取的tab的属性名
         * @return {DOM | string} 如果不指定name，则返回tab的DOM元素; 指定了name则返回相应的属性值;
         */
        getTab: function(index, name) {
            if(!name){ return this.navs.get(index);}
            var ret;
            switch(name) {
                case "tab_width":
                    ret = this.navs.eq(index).width();
                    break;
                case "title":
                    ret = this.titles.eq(index).html();
                    break;
                case "html":
                    ret = this.options.tabs[index].html;
                    break;
                case "url":
                    ret = this.options.tabs[index].url;
                    break;
                case "closeable":
                    ret = this.navs.eq(index).hasClass(this._className.closeTriggerCls);
                    break;
            }
            return ret;
        },
        /**
         * 获取tab页内容
         * @param  {number} index 第几个tab页
         * @return {DOM }  返回tab内容的DOM元素;
         */
        getContent:function(index){
            var index=index===undefined?this.active_index:index;
            return this.contents[index];

        },
        /**
         * 设置tab相关属性 <br>
         * 设置单个属性值: setTab(index, prop, value); <br>
         * 设置多个属性值: setTab(index, {prop1: value1, prop2: value2});
         *
         * @param {number} index 第i个tab页
         * @param {string | object} name  要设置的属性名;如果传一个键值对对象则批量设置属性
         * @param {string} value 要设置的属性值;
         */
        setTab: function(index, name, value) {
            if(typeof(name) === "string") {
                this.options.tabs[index][name] = value;
            } else {
                $.extend(this.options.tabs[index], name);
            }
            this._initTabs();
            this._initUrl();
            if(this.active_index==index){
                this._loadFrame(this.active_index, this.active_index);
            }
            return this;
        },
        index: function () {
            return this.active_index;
        },
        ////////////////////////////////////////////////
        //
        //   Private
        //
        ////////////////////////////////////////////////

        /**
         * 绑定触发事件
         * @return {[type]} [description]
         */
        _bindTriggers: function() {
            var self = this;
            // hover样式
            this.navs.hover(function() {
                if( self.navs.index($(this)) !== self.active_index ) {
                    $(this).addClass(self._className.hoverTriggerCls);
                }
            }, function() {
                $(this).removeClass(self._className.hoverTriggerCls);
            });

            // 使用事件委派
            if(this.options.trigger_type == "click") {
                $("." + this._className.navCls, this.options.el).bind("click", $.proxy(this, "_onTrigger"));
            }
            else if(this.options.trigger_type == "mouseover") {
                this.navs.bind("mouseover", $.proxy(this, "_onMouseover"));
            }
            var closeButton="."+this._className.closeTriggerCls;
            $("." + this._className.navCls+" > li", this.options.el).delegate(closeButton,"click",function(e){
                var nav = self._findNav(e.target),
                    idx = self.navs.index(nav);
                self.removeTab(idx);
                return false;
            }) ;

        },

        /**
         * 加载iframe.
         * iframe不会把所有的url一次性载入,而是只载入active_index一个
         *
         * @param {number} index 		需要加载的tab页
         * @param {number} indexToHide  需要隐藏的tab页,可选
         */
        _loadFrame: function(index, indexToHide) {
            var self = this, opt=this.options,
                isIframe = this.urls.length > 0 && this.urls[index];
            // 如果需要隐藏页,且配置为每次重新加载
            if(indexToHide != undefined && opt.reload_on_active) {
                var hideIframe=this.contents.eq(indexToHide).unbind().removeData("_binded");
                if(this.urls[indexToHide]){
                    hideIframe.attr("src", "about:blank");
                }
            }
            if(isIframe) {
                var $frame = this.contents.eq(index).show();
                // 载入url  url不存在或者每次都重新加载
                if($frame.attr("src")=="about:blank" || opt.reload_on_active) {
                    $frame.attr("src", this.urls[index]);
                    if(!$frame.data("_binded")) { //防止重复注册
                        $frame.bind("load", function() {
                            //防止跨域报错问题
                            try {
                                var doc = $frame.get(0).contentWindow.document,
                                    height = $(doc).height();
                                /* height0 = doc.body.scrollHeight,
                                 height1 = doc.documentElement.scrollHeight,  */
                                if(C.Browser.isIE6){
                                    var cssH=parseInt($frame.css("height").replace("px",""));
                                    if(cssH&&height>cssH){
                                        $(doc).find("head").append('<style type="text/css">html{overflow-y:scroll}</style>');
                                    }
                                }
                                if($(doc).width()>$frame.width()){
                                    height+=17;
                                }
                                if (!opt.height) {//未设置高度
                                    $frame.height(height);
                                }
                            }
                            catch (e) {

                            }

                        }).data("_binded", true);


                    }
                }
            }
        },

        /**
         * 初始化视图
         *
         * @param  {boolean} init 是否是系统初始化;在set()方法中会手动调此方法,此时是false;
         */
        _initView: function(init) {
            // show active index.
            this.contents.css({
                "position": "absolute",
                "left": -999999
            });
            this.contents.eq(this.active_index).css({
                "position": "static",
                "left": 0
            });

            // set style from options.
            var opt = this.options,
                content = $("." + this._className.contentCls, opt.el),
                Browser = C.Browser;
            if(opt.width) {
                opt.el.width(opt.width);
                var opt_width = typeof opt.width === "number" ? (opt.width - ( Browser.isIE && Browser.isQM ? 0 : 6 ) ) : opt.width;
                content.width(opt_width);
            }
            if(opt.content_height) {
                content.height(opt.content_height + ( Browser.isIE && Browser.isQM ? 10 : 0 ));
            }
            if(!init){
                if(opt.tab_width) {
                    this.navs.width(opt.tab_width);
                }

                if(opt.tabs.length > 0) { // 当tabs的参数存在,才初始化各个tab; closeBtn延迟到各个tab中初始化.
                    this._initTabs(init);

                } else { // 当tabs参数不存在,必须初始化全局的closeable;
                    this._initCloseBtns();
                }
            }
            this._initContents();
        },

        /**
         * 初始化各个tab页的属性
         *
         * @param {boolean} init 否是系统初始化;在setTab()方法中会手动调此方法,此时是false;
         */
        _initTabs: function(init) {
            var self = this,
                opt = self.options;
            if(opt.tabs.length > 0) {
                $.each(opt.tabs, function(idx, tab) {
                    if(tab.tab_width) {
                        self.navs.eq(idx).width(tab.tab_width);
                    }
                   // if(tab.closeable !== undefined || opt.closeable !== undefined) {}
                    var closeable = tab.closeable !== undefined ? tab.closeable : opt.closeable;
                    if(closeable) {
                        self._addCloseBtn(idx);
                    } else {
                        self._removeCloseBtn(idx);
                    }

                    if(tab.title) {
                        self.titles.eq(idx).html(tab.title);
                    }


                });

            }
        },

        /**
         * 加载tabs里边的内容.
         *
         */
        _initContents:function(active_index, from){
            var aindex=active_index||this.active_index;
            var tab=this.options.tabs[aindex],
                content=this.contents.eq(aindex);
            if(!tab){
                return;
            }
            if(tab.html){
                if(!tab.__isLoad_){
                    if(typeof(tab.html) === 'string') {
                        content.html(tab.html);
                    }
                    else {// 认为是一个DOM节点,整个移进来
                        content.append($(tab.html).show());
                    }
                    tab.__isLoad_=true;
                }
            }else if(tab.url){
                this._loadFrame(aindex,from);
            }
        },

        /**
         * 初始化关闭按钮.
         * 系统第一次加载时,并不执行这里;因为第一次加载对于关闭按钮的初始化放到_initTab(),初始化每个tab时去做.
         * 这里只用于set()方法时更改全局的closeable属性用.
         */
        _initCloseBtns: function() {
            var opt = this.options,
                len = this.navs.length;
           // if(opt.closeable !== undefined) {  }
                for (var i = 0; i < len; i++) {
                    if(opt.closeable === true) {
                        this._addCloseBtn(i);
                    }else{
                        this._removeCloseBtn(i);
                    }
                }

        },

        /**
         * 触发时的事件
         * @param  {Event} e 触发的事件
         */
        _onTrigger: function(e) {
            var nav = this._findNav(e.target);
            if(nav) {
                idx = this.navs.index(nav);
                this._switchTo(idx, e);
                // this.navs.eq(idx).removeClass(this._className.hoverTriggerCls);
            }
        },

        /**
         * 从当前元素往上遍历,找到navCls的一级子元素(即:导航元素)
         * @param  {DOMElement} el 事件触发的元素:target
         * @return {jQuery}    返回找到的后的jQuery对象
         */
        _findNav: function(el) {
            while(!(el == this.options.el || el == document.body)) {
                if($(el).parent().hasClass(this._className.navCls)) {
                    return el;
                }
                el = el.parentNode;
            }
            return null;
        },

        /**
         * 鼠标事件
         * @param  {Event} e 触发的事件
         */
        _onMouseover: function(e) {
            var idx = this.navs.index(e.currentTarget);
            this._switchTo(idx, e);
        },

        /**
         * 判断当前触发是否有效; 防止重复触发
         * @param  {number} index 序号
         * @return {boolean}       是否有效
         */
        _triggerIsValid: function(index) {
            return this.active_index != index&&index<this.navs.length;
        },

        /**
         * 切换到第index页
         * @param  {number}   index    页数
         * @param  {Event}   e        事件对象
         * @param  {Function} callback 回调函数
         * @return {this}            当前对象, //chain
         */
        _switchTo: function(index, e, callback) {
            if(!this._triggerIsValid(index)) {
                return ;
            }

            var from = this.active_index,
                to = index,
                fromTrigger = this.navs.eq(from),
                toTrigger = this.navs.eq(to),
                fromPanel = this.contents.eq(from),
                handle = this.handles[index],
                toPanel = this.contents.eq(to);
            this.active_index = this.options.active_index = to;
            this._switchTrigger(fromTrigger, toTrigger)
                ._switchView(fromPanel, toPanel);

            // this._loadFrame(this.active_index, from);
            this._initContents(this.active_index, from);
            callback && callback.call(this);
            // 触发一个切换事件.
            $(this).triggerHandler("switch", [{"fromTab": from, "toTab": to}]);
            if($.type(handle) === "function"){   //单个事件触发
                handle.call(this,{"fromTab": from, "toTab": to});
            }else if($.type(handle) === "string"){
                window[handle] && window[handle]({"fromTab": from, "toTab": to});
            }
            return this;
        },

        /**
         * 切换触点
         * @param  {jQuery} fromTrigger 切换的开始tab标签
         * @param  {jQuery} toTrigger   切换的结束tab标签
         * @return {this}               当前对象 //chain
         */
        _switchTrigger: function(fromTrigger, toTrigger) {
            fromTrigger.removeClass(this._className.activeTriggerCls);
            toTrigger.addClass(this._className.activeTriggerCls);
            return this;
        },

        /**
         * 切换视图.(默认是最简单的方式,如果实现动画切换,通过插件方式,覆盖此方法)
         *
         * @param  {jQuery}   fromPanel   切换的开始面板
         * @param  {jQuery}   toPanel     切换的结束面板
         * @return {this}               当前对象 //chain
         */
        _switchView: function(fromPanel, toPanel) {
            fromPanel.css({
                "position": "absolute",
                "left": -999999,
                "top": -99999
            });
            toPanel.css({
                "position": "static",
                "left": 0,
                "top": 0
            });
            return this;
        },


        /**
         * 添加一个tab<br>
         *
         * @param {object} options 对应初始化options中tabs参数中单个tab的值.
         *  格式:{
		 *     "title": "title", 
		 *     "html": "innerHTML", //div
		 *     "url": "url", //iframe; html,url二选一
		 *     "closeable": "true|false", 
		 *     "width": "" //注意没有height. 因为每个tab高度一致;
		 *  }
         */
        _add: function(options) {
            var opt = this.options,
                len = this.navs.length;

            // clone tab nav & append to last.
            var closeable = !!options.closeable,
                indexToClone = this._findClone(closeable),
                nav;
            if(indexToClone !== -1) {
                nav = this.navs.eq(indexToClone).clone(true);

            } else { //找不到,随便clone一个
                nav = this.navs.eq(0).clone(true);
                if(closeable) { // add close btn.
                    this._addCloseBtn(len, nav);
                } else { // remove close btn
                    this._removeCloseBtn(nav);
                }
            }
            if(nav.hasClass(this._className.activeTriggerCls)) {
                nav.removeClass(this._className.activeTriggerCls);
            }
           // if(options.tab_width || opt.tab_width){ }
                nav.width(options.tab_width|| opt.tab_width);

            $("." + this._className.titleCls, nav).html(options.title);
            this.navs.eq(len - 1).after(nav);


            // add content.
            var content,iframeHeight=opt.content_height||this._minHeight;
            if(options.url) {

                content = $('<iframe src="about:blank" frameborder="0" style="display:none;width:100%;height:100%"></iframe>');

                this.urls[len] = options.url;
            } else {
                if(typeof options.html=="object"){$(options.html).hide();}
                content = $('<div style="display: none;width:100%;overflow:auto;height:100%"></div>');
                /*				if(typeof(options.html) === 'string') {
                 content.html(options.html);
                 }
                 // 认为是一个DOM节点,整个移进来.
                 else {
                 content.append($(options.html));
                 }*/
            }
            // content.hide();
            this.contents.eq(len - 1).after(content);

            // re init memebers: navs, contents, titles
            this._parseMarkup();
        },

        /**
         * 添加关闭按钮
         *
         * @param {number} index 第i个tab页
         * @param {jQuery} nav   [可选]导航条,不传则取index所在nav元素.动态添加tab时,因为待添加的tab不存在,需要传进来
         */
        _addCloseBtn: function(index, nav) {
            if(!nav) {
                nav = this.navs.eq(index);
            }
            nav.addClass("closeable").append(this._generateCloseBtn(index));
        },

        /**
         * 生成一个关闭按钮
         *
         * @param {number} index 第i个tab页
         * @return {String}
         */
        _generateCloseBtn: function(index) {
            // var btn = $("<a href='javascript:;'>").addClass(this._className.closeTriggerCls);
            var btn="<a href='javascript:;' class='"+this._className.closeTriggerCls+"'></a>";
            return btn;
        },

        /**
         * 删除关闭按钮
         *
         * @param  {number|jQuery} index 第i个tab页/或者是一个jQuery的上下文
         */
        _removeCloseBtn: function(index) {
            var context = typeof(index) === 'number' ?
                this.navs.eq(index) :
                index;
            $("." + this._className.closeTriggerCls, context).remove();
        },

        /**
         * 查找合适的克隆对象
         * @param  {boolean} closeable 是否指定需要关闭按钮
         * @return {number}           如果找到,返回相应的index;找不到,返回-1.
         */
        _findClone: function(closeable) {
            return  $.inArray(closeable,this._getCloseBtns());

        },

        /**
         * 返回关闭按钮数组.
         * @return {Array<boolean>} 返回数组,长度为tab页的长度.true/false表示是否含有关闭按钮
         */
        _getCloseBtns: function() {
            var globalCloseable = !!this.options.closeable,
                len = this.navs.length,
                tabs = this.options.tabs,
                tab,
                btns = [];

            for (var i = 0; i < len; i++) {
                tab = tabs[i];
                btns.push( (tab && tab.closeable !== undefined) ? tab.closeable : globalCloseable );
            };

            return btns;
        }


        /*,
        _indexOf : function (arr, elt) {
            var len = arr.length;
            var from = Number(arguments[1]) || 0;
            from = (from < 0)
                ? Math.ceil(from)
                : Math.floor(from);
            if (from < 0){
                from += len;
            }
            for (; from < len; from++) {
                if (from in arr && arr[from] === elt) {
                    return from;
                 }
            }
            return -1;
        }  */

    });


})(window.comtop.cQuery, window.comtop);