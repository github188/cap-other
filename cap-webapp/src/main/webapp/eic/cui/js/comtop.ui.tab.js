/**
 * comtop.ui.Tab???????
 *
 */
;(function($, C){
    // ????????
    /**
     * Tab
     * @type {}
     */
    comtop.UI.Tab = comtop.UI.Base.extend({
        options: {
            uitype: "Tab",
            /**
             ?????????????tab??????tab????????????
             ??????tab?????????tab????????=tab????????-tab_height??
             */
            width: 0,
            height: 0,
            tab_width:65,
            active_index: 0,
            /**
             * ????????tab????.<br>
             * ???:
             * {
			 *     "title": "title", 
			 *     "html": "innerHTML", //div; ????????innerHTML???,?????????DOM???|jQuery????.
			 *     "url": "url", //iframe; html,url????
			 *     "closeable": "true|false", 
			 *     "tab_width": "" //??????height. ??????tab??????;
			 * }
             *
             * @type {Array}
             */
            tabs: [],
            fill_height : false,
            reload_on_active: true, //????????????????
            closeable: false, //??????
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
         * ???????tab?
         * @type {Number}
         */
        active_index: 0,

        /**
         * tab???????
         * @type {Array} [DOM, DOM, ...]
         */
        navs: [],

        /**
         * tab????????????
         * @type {Array} [DOM, DOM, ...]
         */
        titles: [],

        /**
         * tab???????
         * @type {Array} [DOM, DOM, ...]
         */
        contents: [],

        /**
         * tab???iframe??url,??????iframe???,????iframe????false
         * @type {Array}
         */
        urls: [],

        /**
         * ????????§Ò?
         * @type {Array} [string, ...]
         */
        events: ["switch"],

        _initUrl:function(){
            this.urls = $.map(this.options.tabs, function(tab) {
                return tab.url || false;
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
            if(this.options.el.html().replace(/\s+/g,"")!=""){//??????el?????html????????????????html???
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
            //?????tab¦Ä?????¦Ê???????????
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
         * ????DOM,???????navs, titles, contents????????
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
         *  ??????
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
            //????????DIV???
            opt.content_height=contentHeight;

        },
        ////////////////////////////////////////////////
        //
        //   Public
        //
        ////////////////////////////////////////////////
        /**
         * ???tab????????????tab???????
         *
         * @param {string} ???tab???????????
         * @param {} ???tab???????????
         * @param {json} ????tab???????,return {this}
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
         * ?§Ý????????tab?
         *
         * @param {number} index  ?§Ý????????
         * @return {this}         ???????, //chain
         */
        switchTo: function(index) {
            this._switchTo(index);
            return this;
        },

        /**
         * ????
         */
        next: function() {
            this.switchTo((this.active_index + 1) % this.navs.length);
            return this;
        },

        /**
         * ????
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
         * resize tab?
         *
         * @param  { number} height tab?????
         * @param  { number} width (???)tab??????????????????????????????
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
         * ??????tab<br>
         * ???¡Â??:
         * 1. addTab("????1", "/web/abc.jsp");
         * 2. addTab({"title":"Test","url": "/web/abc.jsp", "width": "300px"});
         * @param {string} title Tab??????
         * @param {string} url  Tab???url
         *
         * @param { object}    Tab???json????
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
         * ??????tab
         * @param {number} index   ??i??tab?
         */
        removeTab: function(index) {
            if(index < this.navs.length&&this.navs.length>1) {
                if(this.active_index === index) {
                    this.next();
                }
                this.navs.eq(index).remove();
                this.contents.eq(index).remove();
                this.urls.splice(index,1);
                // ????tab???????tab????,???-1; ???????????????.
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
         * ???????????tab
         * @return {DOM} ????????tab
         */
        getActiveTab: function() {
            return this.getTab(this.active_index);
        },

        /**
         * ???tab? ???? tab?????????
         *
         * @param  {number} index ?????tab?
         * @param  {string} name  (???)??????tab????????
         * @return {DOM | string} ??????name?????tab??DOM???; ?????name?????????????;
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
         * ???tab?????
         * @param  {number} index ?????tab?
         * @return {DOM }  ????tab?????DOM???;
         */
        getContent:function(index){
            var index=index===undefined?this.active_index:index;
            return this.contents[index];

        },
        /**
         * ????tab??????? <br>
         * ????????????: setTab(index, prop, value); <br>
         * ???????????: setTab(index, {prop1: value1, prop2: value2});
         *
         * @param {number} index ??i??tab?
         * @param {string | object} name  ????????????;????????????????????????????
         * @param {string} value ???????????;
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
         * ????????
         * @return {[type]} [description]
         */
        _bindTriggers: function() {
            var self = this;
            // hover???
            this.navs.hover(function() {
                if( self.navs.index($(this)) !== self.active_index ) {
                    $(this).addClass(self._className.hoverTriggerCls);
                }
            }, function() {
                $(this).removeClass(self._className.hoverTriggerCls);
            });

            // ?????????
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
         * ????iframe.
         * iframe????????§Ö?url?????????,?????????active_index???
         *
         * @param {number} index 		????????tab?
         * @param {number} indexToHide  ????????tab?,???
         */
        _loadFrame: function(index, indexToHide) {
            var self = this, opt=this.options,
                isIframe = this.urls.length > 0 && this.urls[index];
            // ???????????,?????????????????
            if(indexToHide != undefined && opt.reload_on_active) {
                var hideIframe=this.contents.eq(indexToHide).unbind().removeData("_binded");
                if(this.urls[indexToHide]){
                    hideIframe.attr("src", "about:blank");
                }
            }
            if(isIframe) {
                var $frame = this.contents.eq(index).show();
                // ????url  url???????????¦Æ????????
                if($frame.attr("src")=="about:blank" || opt.reload_on_active) {
                    $frame.attr("src", this.urls[index]);
                    if(!$frame.data("_binded")) { //?????????
                        $frame.bind("load", function() {
                            //????????????
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
                                if (!opt.height) {//¦Ä??????
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
         * ????????
         *
         * @param  {boolean} init ????????????;??set()?????§Ý???????????,?????false;
         */
        _initView: function(init) {
            // show active index.
            this.contents.hide();
            this.contents.eq(this.active_index).show();

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

                if(opt.tabs.length > 0) { // ??tabs????????,??????????tab; closeBtn????????tab?§Ô????.
                    this._initTabs(init);

                } else { // ??tabs???????,????????????closeable;
                    this._initCloseBtns();
                }
            }
            this._initContents();
        },

        /**
         * ?????????tab???????
         *
         * @param {boolean} init ???????????;??setTab()?????§Ý???????????,?????false;
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
         * ????tabs????????.
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
                    else {// ????????DOM???,????????
                        content.append($(tab.html).show());
                    }
                    tab.__isLoad_=true;
                }
            }else if(tab.url){
                this._loadFrame(aindex,from);
            }
        },

        /**
         * ??????????.
         * ??????¦Ì????,???????????;???????¦Ì???????????????????_initTab(),????????tab????.
         * ?????????set()????????????closeable??????.
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
         * ??????????
         * @param  {Event} e ?????????
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
         * ??????????????,???navCls??????????(??:???????)
         * @param  {DOMElement} el ????????????:target
         * @return {jQuery}    ???????????jQuery????
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
         * ??????
         * @param  {Event} e ?????????
         */
        _onMouseover: function(e) {
            var idx = this.navs.index(e.currentTarget);
            this._switchTo(idx, e);
        },

        /**
         * ?§Ø????????????§¹; ??????????
         * @param  {number} index ???
         * @return {boolean}       ?????§¹
         */
        _triggerIsValid: function(index) {
            return this.active_index != index&&index<this.navs.length;
        },

        /**
         * ?§Ý?????index?
         * @param  {number}   index    ???
         * @param  {Event}   e        ???????
         * @param  {Function} callback ???????
         * @return {this}            ???????, //chain
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
                toPanel = this.contents.eq(to);
            this.active_index = this.options.active_index = to;
            this._switchTrigger(fromTrigger, toTrigger)
                ._switchView(fromPanel, toPanel);

            // this._loadFrame(this.active_index, from);
            this._initContents(this.active_index, from);
            callback && callback.call(this);

            // ????????§Ý????.
            $(this).triggerHandler("switch", [{"fromTab": from, "toTab": to}]);

            return this;
        },

        /**
         * ?§Ý?????
         * @param  {jQuery} fromTrigger ?§Ý?????tab???
         * @param  {jQuery} toTrigger   ?§Ý??????tab???
         * @return {this}               ??????? //chain
         */
        _switchTrigger: function(fromTrigger, toTrigger) {
            fromTrigger.removeClass(this._className.activeTriggerCls);
            toTrigger.addClass(this._className.activeTriggerCls);
            return this;
        },

        /**
         * ?§Ý????.(???????????,??????????§Ý?,????????,????????)
         *
         * @param  {jQuery}   fromPanel   ?§Ý????????
         * @param  {jQuery}   toPanel     ?§Ý?????????
         * @return {this}               ??????? //chain
         */
        _switchView: function(fromPanel, toPanel) {
            fromPanel.hide();
            toPanel.show();
            return this;
        },


        /**
         * ??????tab<br>
         *
         * @param {object} options ????????options??tabs?????§Ö???tab???.
         *  ???:{
		 *     "title": "title", 
		 *     "html": "innerHTML", //div
		 *     "url": "url", //iframe; html,url????
		 *     "closeable": "true|false", 
		 *     "width": "" //??????height. ??????tab??????;
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

            } else { //?????,???clone???
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
                 // ????????DOM???,????????.
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
         * ???????
         *
         * @param {number} index ??i??tab?
         * @param {jQuery} nav   [???]??????,???????index????nav???.??????tab?,?????????tab??????,?????????
         */
        _addCloseBtn: function(index, nav) {
            if(!nav) {
                nav = this.navs.eq(index);
            }
            nav.addClass("closeable").append(this._generateCloseBtn(index));
        },

        /**
         * ???????????
         *
         * @param {number} index ??i??tab?
         * @return {String}
         */
        _generateCloseBtn: function(index) {
            // var btn = $("<a href='javascript:;'>").addClass(this._className.closeTriggerCls);
            var btn="<a href='javascript:;' class='"+this._className.closeTriggerCls+"'></a>";
            return btn;
        },

        /**
         * ???????
         *
         * @param  {number|jQuery} index ??i??tab?/?????????jQuery????????
         */
        _removeCloseBtn: function(index) {
            var context = typeof(index) === 'number' ?
                this.navs.eq(index) :
                index;
            $("." + this._className.closeTriggerCls, context).remove();
        },

        /**
         * ??????????????
         * @param  {boolean} closeable ??????????????
         * @return {number}           ??????,?????????index;?????,????-1.
         */
        _findClone: function(closeable) {
            return  $.inArray(closeable,this._getCloseBtns());

        },

        /**
         * ????????????.
         * @return {Array<boolean>} ????????,?????tab??????.true/false???????§Û????
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