/**
 * comtop.ui.Panel???<br>
 *
 * ????????: panel???????,?????/??????;
 */
;
(function ($, C) {

// ????
    var COLLAPSE = 0, // ???
        EXPAND = 1,
        EVT_CHANGE = 'change'; // ??????
    var getPadding = function (dom) {
        if (!dom) {
            return {top: 0, bottom: 0, left: 0, right: 0};
        }
        var style = null;
        if (dom.currentStyle) {
            style = dom.currentStyle;
        } else {
            style = getComputedStyle(dom, false);
        }
        return {top: parseInt(style.paddingTop), bottom: parseInt(style.paddingBottom), left: parseInt(style.paddingLeft), right: parseInt(style.paddingRight)};
    };
    /**
     * Panel
     * @type {[type]}
     */
    comtop.UI.Panel = comtop.UI.Base.extend({

        options: {
            uitype: "Panel",
            header_title: "",
            width: 0,
            height: 0,
            url: "", // iframe
            html: "", // innerHTML/DOM Element; url,html???????.
            on_change: null, // fn 
            collapsible: true, // ????????
            status: EXPAND, // ??????????		 
            animate: "", // ????,????""?????????; ????:"slide"?????งน??;
            containerCls: "cui-panel",
            titleCls: "cui-panel-title",
            triggerCls: "cui-panel-trigger",
            contentCls: "cui-panel-content"
        },

        /**
         * Panel????
         * @type {[type]}
         */
        container: null,

        /**
         * ????
         * @type {jQuery}
         */
        title: null,

        /**
         * ????
         * @type {jQuery}
         */
        trigger: null,

        /**
         * ???????
         * @type {jQuery}
         */
        content: null,

        /**
         * ??????งÝ???
         * @type {[type]}
         */
        status: null,

        /**
         * ???iframe?????????,????????????url
         * @type {Boolean}

        loaded: false,
         */
        /**
         * ????????งา?
         * @type {Array}
         */
        events: [EVT_CHANGE],

        _init: function (options) {
            var opt = this.options;
            options.height=C.Tools.fixedNumber(options.height);
            if (options.height) {
                opt.height = options.height;
            }
            this.status = opt.status;
            if (options.html && window[options.html]) {
                opt.html = window[options.html];
            }
            if (options.header_title && window[options.header_title]) {
                opt.header_title = window[options.header_title];
            }
           /* if (!opt.lazy) this.loaded = true;  */
            opt.el.css({"zoom": 1});
            if (typeof opt.on_change == "function") {
                this.bind("change", opt.on_change);
            }
            if ($.trim(opt.el.html()) !== "") {
                this._needBuildTemp = true;
            }

        },

        _create: function () {
            var opt = this.options, container = opt.el;
            this._navHeight = 30;
            if (this._needBuildTemp) {
                this._initStructures();
            }
            this._parseMarkup();
            this._initView(true);
        },
        /**
         * ????DOM,?????title, trigger, content?????????
         * @return {[type]} [description]
         */
        _parseMarkup: function () {
            var opt = this.options;
            this.container = $("." + opt.containerCls, opt.el);
            this.title = $("." + opt.titleCls, opt.el);
            this.trigger = $("." + opt.triggerCls, opt.el).eq(0);
            this.content = $("." + opt.contentCls, opt.el);
        },
        _initView: function (flag) {
            var opt = this.options;
            this._setUpSize();
            this._bindTriggers();
            if (opt.header_title) {
                this._setTitle(opt.header_title);
            }
            if (opt.html && flag) {
                if (typeof(opt.html) === 'string') {
                    this.content.find("div").html(opt.html);
                } else {
                    this.content.find("div").append($(opt.html));
                }
            } else if (opt.url && flag) {
                this._loadFrame();
            }
            !opt.collapsible?this.trigger.hide():this.trigger.show();
           /* if (opt.collapsible == false)
            {
                this.trigger.hide();
            }
            else {
                this.trigger.show();
            } */
            opt.status === EXPAND?this._showView():this._hideView();

/*         if (opt.status == EXPAND) {
                this._showView();
            }
            else {
                this._hideView();
            }*/
        },
        /**
         *  ??????
         */
        _setUpSize: function () {
            var opt = this.options,
                contentHeight,
                height = opt.height,
                parent = opt.el.parent();
            var pa = getPadding(opt.el.find(".cui-panel-content").get(0)),
                padding = (C.Browser.isQM && C.Browser.isIE && !C.Browser.isIE9) ? 0 : (pa.top + pa.bottom) + 2;
            this._contentPadding = pa;

            if (opt.width) {
                this.container.width(opt.width);
            }
            if (height) {
                if (height === "100%") {
                    if (parent.prop("tagName") === 'BODY') {
                        this.h = $.client.height();
                        opt.el.find(".cui-panel-content").eq(0).css("height", 0);
                        this.margin = parseInt(parent.css("marginTop")) + parseInt(parent.css("marginBottom"));
                        opt.height = height = this.h - this.margin;
                        this._resizeHandle();
                    } else {
                        this.margin = 0;
                        opt.height = height = opt.el.parent().height();
                    }
                }
                contentHeight = height - this._navHeight - padding;
                contentHeight = contentHeight < 10 ? 10 : contentHeight;
                opt.content_height = contentHeight;
                opt.el.find(".cui-panel-content").height(contentHeight);
                opt.el.find(".cui-panel-iframe").height("100%");
                if(C.Browser.isQM && C.Browser.isIE ){
                    this.content.children("div").height("");
                }
            }else{
                this.content.children("div").height("");
            }
        },
        _resizeHandle: function () {
            if (this.margin !== undefined) {
                var self = this;
                var opt = this.options;
                // self.h = $.client.height();
                var pa = this._contentPadding,
                    padding = (C.Browser.isQM && C.Browser.isIE && !C.Browser.isIE9) ? (pa.top + pa.bottom) + 2 : 0;

                function resize() {
                    var h = $.client.height();
                    self.content.css("height", self.content.height() + h - self.h + padding);
                    self.h = h;
                }

                $(window).on("resize", resize);
            }
        },

        ////////////////////////////////////////////////
        //
        //   Public
        //
        ////////////////////////////////////////////////
        /**
         * ????????
         * @param  {string} name ??????
         * @return {string}      ??????????
         */
        get: function (name) {
            var val = this.options[name];

            if (name == "width") {
                val = val || this.container.width();
            }
            else if (name == "height") {
                val = val || this.container.height();
                if (this.status == COLLAPSE) {
                    val = 31;
                }
            }
            else if (!val && name == "header_title") {
                val = this._getTitle();
            }
            else if (name == "status") {
                val = this.status;
            }
            return val;
        },

        /**
         * ?????????
         * ????????????: set(prop, value);
         * ???????????: set({prop: value, xxx: xx});
         *
         * @param {string} name  ??????
         * @param {string} value ?????
         * @return {Panel}       ??????????. for chain
         */
        set: function (name, value) {
            var refreshFlag = false;
            if (typeof(name) === 'string') {
                this.options[name] = value;
                if (name == "url" || name == "html") {
                    refreshFlag = true;
                }
            } else {
                if (name.hasOwnProperty("url") || name.hasOwnProperty("html")) {
                    refreshFlag = true;
                }
                $.extend(this.options, name);
            }
            this._initView(refreshFlag);// for set
            return this;
        },

        /**
         * ???
         * @param {function} callback  [???]???????
         * @return {Panel} ??????????. for chain
         */
        expend: function () {
            if (!this.options.collapsible || this.status == EXPAND) {
                return this;
            }

            this._showView();
            this.status = EXPAND;
            if (this.options.onchange) {
                this.options.onchange.call(null, this.status);
            }
            $(this).triggerHandler(EVT_CHANGE, this.status);
            return this;
        },

        /**
         * ????
         * @param {function} callback  [???]???????
         * @return {Panel} ??????????. for chain
         */
        collapse: function () {
            if (!this.options.collapsible || this.status == COLLAPSE) {
                return this;
            }

            this._hideView();
            this.status = COLLAPSE;
            if (this.options.onchange) {
                this.options.onchange.call(null, this.status);
            }
            $(this).triggerHandler(EVT_CHANGE, this.status);
            return this;
        },
        /**
         * ?????????
         * @parma {className:xxx,callback:fn} settings ??????? ??class????????????
         * @return {Panel} ??????????. for chain
         */
        addIcon: function (settings) {
            if (!settings || !settings.className) {
                return;
            }
            var title= settings.title||"";
            var html = '<a href="#" title="'+title+'" class="cui-panel-trigger-customer ' + settings.className + '" hidefocus="true"></a>';
            var triggerContainer = this.title.find(".cui-panel-trigger-content").append(html);
            if (typeof settings.callback == "function") {
                triggerContainer.find("a." + settings.className).on("click", function () {
                    settings.callback();
                    return false;
                });
            }
            return this;
        },
        /**
         * ?????????
         * @parma {string} ???class???icon
         * @return {Panel} ??????????. for chain
         */
        removeIcon: function (className) {
            if (!className) {
                return;
            }
            this.title.find("a." + className).unbind().remove();
            return this;
        },
        /**
         * ?งÝ????/??????
         * @return {Panel} ??????????. for chain
         */
        toggle: function () {
            if (this.status == EXPAND){
                this.collapse();
            }
            else{
                this.expend();
            }
            return this;
        },
        /**
         * resize
         *
         * @param  { number} height panel????
         * @param  { number} width (???)panel?????????????????????????????
         */
        resize: function (height, width) {
            if (arguments.length == 0) {
                return;
            }
            if (typeof height == "number") {
                this.options.height = height;
                var pa = this._contentPadding,
                    padding = (C.Browser.isQM && C.Browser.isIE && !C.Browser.isIE9) ? 0 : (pa.top + pa.bottom) + 2,
                    computedHeight = height - this._navHeight - padding;
                /*if(this.options.url){
                 this.content.find("iframe").height(computedHeight);
                 }else{

                 } */
                this.content.height(computedHeight);
            }
            if (typeof width == "number") {
                this.options.width = width;
                this.container.width(width);
            }

        },
////////////////////////////////////////////////
//
//   Private
//
////////////////////////////////////////////////

        /**
         * ???????.
         * ???????????????:?????????,??????????,jCT????.
         * ?????????????????,??????????jCT??แห????????.
         *
         * @return {[boolean]} [?????????]
         */
        _initStructures: function () {
            var opt = this.options,
                $root = $(document.createElement("div"));
            this._buildTemplate($root, "panel", opt);
            $(opt.el).before($root).appendTo($("." + opt.contentCls, $root).find("div"));
            /**/opt.el.css("height", "100%");
            this.el = opt.el = $root;
        },

        /**
         * ????iframe
         * @return {[type]} [description]
         */
        _loadFrame: function () {
            var self = this,
                opt = this.options,
                $frame = this.content.find("iframe");
            $frame.attr("src", this.options.url);
            this.loaded = true;
            $frame.one("load", function () {
                var doc = $frame.get(0).contentWindow.document,
                    height0 = doc.body.scrollHeight,
                    height1 = doc.documentElement.scrollHeight,
                    height = Math.max(height0, height1);
                if (opt.content_height)
                    height = height < opt.content_height ? opt.content_height : height;
                if (C.Browser.isIE6 && !C.Browser.isQM) {
                    var cssH = $frame.height();
                    if (cssH && height > cssH) {
                        $(doc).find("head").append('<style type="text/css">html{overflow-y:scroll}</style>');
                    }
                }
                if ($(doc).width() > $frame.width()) {
                    height += 17;
                }
                if (!opt.height) {
                    $frame.height(height);
                }
            });

        },

        /**
         * ????????
         * @return {[type]} [description]
         */
        _bindTriggers: function () {
            var self = this;
            var status = this.options.status;
            this.trigger.toggle(function () {
                if (status == EXPAND) {
                    self.collapse();
                } else {
                    self.expend();
                }
            }, function () {
                if (status == EXPAND) {
                    self.expend();
                } else {
                    self.collapse();
                }
            });
        },

        /**
         * ???????
         * @return {[type]} [description]
         */
        _getTitle: function () {
            return  this.title.find(".cui-panel-title-text").html();
        },

        /**
         * ???????
         * @param {string} name ???????
         */
        _setTitle: function (name) {

            this.title.find(".cui-panel-title-text").html(name);

        },

        /**
         * ??????????
         * @param  {jQuery} content ???????
         * @return {[type]} [description]
         */
        _showView: function () {
            var animate = this.options.animate;
            this.trigger.removeClass("collapse");
            if (animate && animate === "slide") {
                this.content.slideDown(100);
            }else {
                this.content.show();
            }
        },

        /**
         * ???????????
         * @return {[type]} [description]
         */
        _hideView: function () {
            var animate = this.options.animate;
            this.trigger.addClass("collapse");
            if (animate && animate === "slide") {
                this.content.slideUp(100);
            }else {
                this.content.hide();
            }

        }
    });
// ???????????.
    comtop.UI.Panel.EXPAND = EXPAND;
    comtop.UI.Panel.COLLAPSE = COLLAPSE;
})(window.comtop.cQuery, window.comtop);