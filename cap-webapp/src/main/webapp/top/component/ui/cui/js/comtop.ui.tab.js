?
/**
 * comtop.ui.Tab��ǩҳ���
 *
 */
;(function($, C){
    // ��������
    /**
     * Tab
     * @type {}
     */
    comtop.UI.Tab = comtop.UI.Base.extend({
        options: {
            uitype: "Tab",
            /**
             �������޸߶�ʱ��tab�ĸ߶ȸ���tabҳ����������Ӧ
             �˸߶���tabҳ����ĸ߶ȣ�tabҳ���ݵĸ߶�=tabҳ����ĸ߶�-tab_height��
             */
            width: 0,
            height: 0,
            tab_width:65,
            active_index: 0,
            /**
             * ��������tab����.<br>
             * ��ʽ:
             * {
			 *     "title": "title", 
			 *     "html": "innerHTML", //div; ������Դ�innerHTML�ַ���,Ҳ���Դ�һ��DOM�ڵ�|jQuery����.
			 *     "url": "url", //iframe; html,url��ѡһ
			 *     "closeable": "true|false", 
			 *     "tab_width": "" //ע��û��height. ��Ϊÿ��tab�߶�һ��;
			 * }
             *
             * @type {Array}
             */
            tabs: [],
            fill_height : false,
            reload_on_active: true, //����ʱ���¼�������
            closeable: false, //�Ƿ�ɹر�
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
         * ��ǰ�������tabҳ
         * @type {Number}
         */
        active_index: 0,

        /**
         * tabҳ������
         * @type {Array} [DOM, DOM, ...]
         */
        navs: [],

        /**
         * tab�������ϵı���
         * @type {Array} [DOM, DOM, ...]
         */
        titles: [],

        /**
         * tabҳ������
         * @type {Array} [DOM, DOM, ...]
         */
        contents: [],

        /**
         * tabҳ��iframe��url,�������iframe�Ļ�,����iframe�򱣴�Ϊfalse
         * @type {Array}
         */
        urls: [],

        /**
         * ֧�ֵ��¼��б�
         * @type {Array} [string, ...]
         */
        events: ["switch"],

        /**
         * tabs����on_switch�Ĵ�����������о��Ǻ����ĸ�ֵ�����û���򱣴�Ϊfalse��
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
            if(this.options.el.html().replace(/\s+/g,"")!=""){//��ʼ��ʱel�ڲ���html���룬��ʱ��Ϊʹ�õ���htmlģ��
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
            //�˸߶�Ϊtabδ�����κ��ⲿ��Դʱ�ĸ߶�
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
         * ����DOM,����ʼ��navs, titles, contents�ȳ�Ա����
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
         *  ���ø߶�
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
            //��������DIV�߶�
            opt.content_height=contentHeight;

        },
        ////////////////////////////////////////////////
        //
        //   Public
        //
        ////////////////////////////////////////////////
        /**
         * ��ȡtabҳ�����Ի�����tabҳ������
         *
         * @param {string} ��ȡtabҳ��ĳһ������
         * @param {} ��ȡtabҳ����������
         * @param {json} ����tabҳ������,return {this}
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
         * �л���ָ����tabҳ
         *
         * @param {number} index  �л�����ҳ��
         * @return {this}         ��ǰ����, //chain
         */
        switchTo: function(index) {
            this._switchTo(index);
            return this;
        },

        /**
         * ��һҳ
         */
        next: function() {
            this.switchTo((this.active_index + 1) % this.navs.length);
            return this;
        },

        /**
         * ��һҳ
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
         * resize tabҳ
         *
         * @param  { number} height tabҳ�ĸ߶�
         * @param  { number} width (��ѡ)tabҳ�Ŀ�ȣ���ָ��Ĭ���Զ���Ӧ�������Ŀ��
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
         * ���һ��tab<br>
         * ���÷�ʽ:
         * 1. addTab("����1", "");
         * 2. addTab({"title":"Test","url": "", "width": "300px"});
         * @param {string} title Tabҳ�ı���
         * @param {string} url  Tabҳ��url
         *
         * @param { object}    Tabҳ��json����
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
         * �Ƴ�һ��tab
         * @param {number} index   ��i��tabҳ
         */
        removeTab: function(index) {
            if(index < this.navs.length&&this.navs.length>1) {
                if(this.active_index === index) {
                    this.next();
                }
                this.navs.eq(index).remove();
                this.contents.eq(index).remove();
                this.urls.splice(index,1);
                // �Ƴ���tab����ڵ�ǰtab���ʱ,��Ҫ-1; ��������ұ�����Ҫ.
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
         * ��ȡ��ǰ�����tab
         * @return {DOM} ��ǰ�����tab
         */
        getActiveTab: function() {
            return this.getTab(this.active_index);
        },

        /**
         * ��ȡtabҳ ���� tab���������
         *
         * @param  {number} index �ڼ���tabҳ
         * @param  {string} name  (��ѡ)Ҫ��ȡ��tab��������
         * @return {DOM | string} �����ָ��name���򷵻�tab��DOMԪ��; ָ����name�򷵻���Ӧ������ֵ;
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
         * ��ȡtabҳ����
         * @param  {number} index �ڼ���tabҳ
         * @return {DOM }  ����tab���ݵ�DOMԪ��;
         */
        getContent:function(index){
            var index=index===undefined?this.active_index:index;
            return this.contents[index];

        },
        /**
         * ����tab������� <br>
         * ���õ�������ֵ: setTab(index, prop, value); <br>
         * ���ö������ֵ: setTab(index, {prop1: value1, prop2: value2});
         *
         * @param {number} index ��i��tabҳ
         * @param {string | object} name  Ҫ���õ�������;�����һ����ֵ�Զ�����������������
         * @param {string} value Ҫ���õ�����ֵ;
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
         * �󶨴����¼�
         * @return {[type]} [description]
         */
        _bindTriggers: function() {
            var self = this;
            // hover��ʽ
            this.navs.hover(function() {
                if( self.navs.index($(this)) !== self.active_index ) {
                    $(this).addClass(self._className.hoverTriggerCls);
                }
            }, function() {
                $(this).removeClass(self._className.hoverTriggerCls);
            });

            // ʹ���¼�ί��
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
         * ����iframe.
         * iframe��������е�urlһ��������,����ֻ����active_indexһ��
         *
         * @param {number} index 		��Ҫ���ص�tabҳ
         * @param {number} indexToHide  ��Ҫ���ص�tabҳ,��ѡ
         */
        _loadFrame: function(index, indexToHide) {
            var self = this, opt=this.options,
                isIframe = this.urls.length > 0 && this.urls[index];
            // �����Ҫ����ҳ,������Ϊÿ�����¼���
            if(indexToHide != undefined && opt.reload_on_active) {
                var hideIframe=this.contents.eq(indexToHide).unbind().removeData("_binded");
                if(this.urls[indexToHide]){
                    hideIframe.attr("src", "about:blank");
                }
            }
            if(isIframe) {
                var $frame = this.contents.eq(index).show();
                // ����url  url�����ڻ���ÿ�ζ����¼���
                if($frame.attr("src")=="about:blank" || opt.reload_on_active) {
                    $frame.attr("src", this.urls[index]);
                    if(!$frame.data("_binded")) { //��ֹ�ظ�ע��
                        $frame.bind("load", function() {
                            //��ֹ���򱨴�����
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
                                if (!opt.height) {//δ���ø߶�
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
         * ��ʼ����ͼ
         *
         * @param  {boolean} init �Ƿ���ϵͳ��ʼ��;��set()�����л��ֶ����˷���,��ʱ��false;
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

                if(opt.tabs.length > 0) { // ��tabs�Ĳ�������,�ų�ʼ������tab; closeBtn�ӳٵ�����tab�г�ʼ��.
                    this._initTabs(init);

                } else { // ��tabs����������,�����ʼ��ȫ�ֵ�closeable;
                    this._initCloseBtns();
                }
            }
            this._initContents();
        },

        /**
         * ��ʼ������tabҳ������
         *
         * @param {boolean} init ����ϵͳ��ʼ��;��setTab()�����л��ֶ����˷���,��ʱ��false;
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
         * ����tabs��ߵ�����.
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
                    else {// ��Ϊ��һ��DOM�ڵ�,�����ƽ���
                        content.append($(tab.html).show());
                    }
                    tab.__isLoad_=true;
                }
            }else if(tab.url){
                this._loadFrame(aindex,from);
            }
        },

        /**
         * ��ʼ���رհ�ť.
         * ϵͳ��һ�μ���ʱ,����ִ������;��Ϊ��һ�μ��ض��ڹرհ�ť�ĳ�ʼ���ŵ�_initTab(),��ʼ��ÿ��tabʱȥ��.
         * ����ֻ����set()����ʱ����ȫ�ֵ�closeable������.
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
         * ����ʱ���¼�
         * @param  {Event} e �������¼�
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
         * �ӵ�ǰԪ�����ϱ���,�ҵ�navCls��һ����Ԫ��(��:����Ԫ��)
         * @param  {DOMElement} el �¼�������Ԫ��:target
         * @return {jQuery}    �����ҵ��ĺ��jQuery����
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
         * ����¼�
         * @param  {Event} e �������¼�
         */
        _onMouseover: function(e) {
            var idx = this.navs.index(e.currentTarget);
            this._switchTo(idx, e);
        },

        /**
         * �жϵ�ǰ�����Ƿ���Ч; ��ֹ�ظ�����
         * @param  {number} index ���
         * @return {boolean}       �Ƿ���Ч
         */
        _triggerIsValid: function(index) {
            return this.active_index != index&&index<this.navs.length;
        },

        /**
         * �л�����indexҳ
         * @param  {number}   index    ҳ��
         * @param  {Event}   e        �¼�����
         * @param  {Function} callback �ص�����
         * @return {this}            ��ǰ����, //chain
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
            // ����һ���л��¼�.
            $(this).triggerHandler("switch", [{"fromTab": from, "toTab": to}]);
            if($.type(handle) === "function"){   //�����¼�����
                handle.call(this,{"fromTab": from, "toTab": to});
            }else if($.type(handle) === "string"){
                window[handle] && window[handle]({"fromTab": from, "toTab": to});
            }
            return this;
        },

        /**
         * �л�����
         * @param  {jQuery} fromTrigger �л��Ŀ�ʼtab��ǩ
         * @param  {jQuery} toTrigger   �л��Ľ���tab��ǩ
         * @return {this}               ��ǰ���� //chain
         */
        _switchTrigger: function(fromTrigger, toTrigger) {
            fromTrigger.removeClass(this._className.activeTriggerCls);
            toTrigger.addClass(this._className.activeTriggerCls);
            return this;
        },

        /**
         * �л���ͼ.(Ĭ������򵥵ķ�ʽ,���ʵ�ֶ����л�,ͨ�������ʽ,���Ǵ˷���)
         *
         * @param  {jQuery}   fromPanel   �л��Ŀ�ʼ���
         * @param  {jQuery}   toPanel     �л��Ľ������
         * @return {this}               ��ǰ���� //chain
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
         * ���һ��tab<br>
         *
         * @param {object} options ��Ӧ��ʼ��options��tabs�����е���tab��ֵ.
         *  ��ʽ:{
		 *     "title": "title", 
		 *     "html": "innerHTML", //div
		 *     "url": "url", //iframe; html,url��ѡһ
		 *     "closeable": "true|false", 
		 *     "width": "" //ע��û��height. ��Ϊÿ��tab�߶�һ��;
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

            } else { //�Ҳ���,���cloneһ��
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
                 // ��Ϊ��һ��DOM�ڵ�,�����ƽ���.
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
         * ��ӹرհ�ť
         *
         * @param {number} index ��i��tabҳ
         * @param {jQuery} nav   [��ѡ]������,������ȡindex����navԪ��.��̬���tabʱ,��Ϊ����ӵ�tab������,��Ҫ������
         */
        _addCloseBtn: function(index, nav) {
            if(!nav) {
                nav = this.navs.eq(index);
            }
            nav.addClass("closeable").append(this._generateCloseBtn(index));
        },

        /**
         * ����һ���رհ�ť
         *
         * @param {number} index ��i��tabҳ
         * @return {String}
         */
        _generateCloseBtn: function(index) {
            // var btn = $("<a href='javascript:;'>").addClass(this._className.closeTriggerCls);
            var btn="<a href='javascript:;' class='"+this._className.closeTriggerCls+"'></a>";
            return btn;
        },

        /**
         * ɾ���رհ�ť
         *
         * @param  {number|jQuery} index ��i��tabҳ/������һ��jQuery��������
         */
        _removeCloseBtn: function(index) {
            var context = typeof(index) === 'number' ?
                this.navs.eq(index) :
                index;
            $("." + this._className.closeTriggerCls, context).remove();
        },

        /**
         * ���Һ��ʵĿ�¡����
         * @param  {boolean} closeable �Ƿ�ָ����Ҫ�رհ�ť
         * @return {number}           ����ҵ�,������Ӧ��index;�Ҳ���,����-1.
         */
        _findClone: function(closeable) {
            return  $.inArray(closeable,this._getCloseBtns());

        },

        /**
         * ���عرհ�ť����.
         * @return {Array<boolean>} ��������,����Ϊtabҳ�ĳ���.true/false��ʾ�Ƿ��йرհ�ť
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