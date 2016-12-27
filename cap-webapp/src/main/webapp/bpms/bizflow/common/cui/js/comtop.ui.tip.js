/**
 *
 * Tip组件
 *
 * @author 柯尚福
 * @since 2012-08-29
 * @updata 2013-04-01 by linchaoqun
 */
;(function($, C){

    C.UI.Tip = C.UI.Base.extend({

        options: {
            uitype: 'Tip',
            pointee: true,      //是否显示箭头
            position: 'auto',   //tip的显示位置
            live: false,        //是否以live的方式注册事件
            trigger: 'hover',   //触发tip显示的方式
            x: false,           //是否显示关闭按钮
            maxWidth: 150,       //最大宽度
            fade: false, 		//是否淡入淡出 todo
            opacity: 1,          //透明度 todo
            tipEl: null,         //指定获取'tip'属性的元素,为扫描器和validate所做的处理
            content_cls: '.ctip-msg',
            close_cls: '.ctip-x',
            tipType: 'normal'      //默认是绿色 包含值 normal error
        },

        _init: function() {
            this.options.uid = 'tip_' + comtop.guid();
            var o = this.options;
            this.$el = $(o.el);
            this.$tipEl = o.tipEl ? $(o.tipEl) : this.$el;
            this._fixTitle();
        },

        _create: function() {
            if(this.options.trigger === 'onload') {
                this.show();
            } else {
                this._bindElEvent();
            }
        },

        /**
         * 创建TipDOM结构
         * @private
         */
        _createDOM: function(){
            var self = this,
                opts = self.options,
                html = [];
            html.push('<div class="ctip" id="', opts.uid, '">');
            opts.pointee && html.push('<div class="ctip-arrow"><span class="tip-arrow-border">&#9670</span><span class="tip-arrow-bg">&#9670</span></div>');
            html.push('<div class="ctip-content ', (opts.x === true ? 'ctip-closed' : '') ,'">');
            opts.x && html.push('<a class="ctip-x cui-icon" href="#">&#xf00d;</a>');
            html.push('<div class="ctip-msg"></div></div></div>');
            $('body').append(html.join(''));
        },

        /**
         * 在要显示tip的dom元素上绑定相应事件
         */
        _bindElEvent: function() {
            var _self = this, o = _self.options;
            var binder = (o.live=='true' || o.live ===true) ? 'live' : 'bind',
                eventIn = o.trigger == 'hover' ? 'mouseenter' : o.trigger == 'click' ? 'click' : 'focus',
                eventOut = o.trigger == 'hover' ? 'mouseleave' : o.trigger == 'click' ? '' : 'blur';

            _self.$el[binder](eventIn, function(){
                _self.show(_self.$el.attr('tipType'));
                if (o.trigger !== 'hover') {
                    return false;
                }
            })[binder](eventOut, function(){
                _self.hide();
                if (o.trigger !== 'hover') {
                    return false;
                }
            });
        },

        /**
         * 延时创建tip
         */
        _lazyCreate: function() {
            var self = this,
                opts = self.options;
            if(!this.created){
                this._createDOM();
                self.$tip = $('#' + opts.uid);
                self._bindEvent();
                self.created = true;
            }
        },

        _setMaxWidth: function(){
            var $tip = this.$tip,
                o = this.options;
            if(C.Browser.isIE6){
                var width = $tip.find('.ctip-msg').width() > o.maxWidth ? o.maxWidth : 'auto';
                if(C.Browser.isQM && width != 'auto'){
                    width = width + 16;
                }
                $tip.children('.ctip-content').css('width', width);
            }else{
                $tip.children('.ctip-content').css('maxWidth', o.maxWidth);
            }
        },

        /**
         * 绑定tip的事件
         */
        _bindEvent: function() {
            var _self = this, o = this.options;
            //关闭按钮
            if(o.x === true){
                this.$tip.find(o.close_cls).bind('click', function(){
                    _self.hide();
                    return false;
                });
            }

        },

        /**
         * 移除要显示tip的dom元素的title属性
         */
        _fixTitle: function() {
            this.$el.removeAttr('title');
        },

        /**
         * 设置tip要显示的位置
         */
        _setPosition: function() {
            var $tip = this.$tip,
                $ele = this.$el,
                o = this.options;
            var elePos = $.extend({},$ele.offset(),{
                width: $ele[0].offsetWidth,
                height: $ele[0].offsetHeight
            });
            var tipWidth = $tip[0].offsetWidth,
                tipHeight = $tip[0].offsetHeight,
                position = o.position;


            //处理ie6 不支持css max-width属性的问题
            if( C.Browser.isIE && tipWidth > o.maxWidth){
                $tip.width(o.maxWidth);
                tipWidth = $tip[0].offsetWidth; //重新获取宽高度
                tipHeight = $tip[0].offsetHeight;
            }

            if(position == 'auto'){
                position = this._calAutoPosition(elePos);
            }

            var tipPos = {};
            switch(position){
                case 't':
                    tipPos = {left: elePos.left + elePos.width / 2 - tipWidth / 2, top: elePos.top -tipHeight - 5};
                    break;
                case 'b':
                    tipPos = {left: elePos.left + elePos.width / 2 - tipWidth / 2, top: elePos.top + elePos.height + 5};
                    break;
                case 'l':
                    tipPos = {left: elePos.left - tipWidth - 5, top: elePos.top + elePos.height / 2 - tipHeight / 2};
                    break;
                case 'r':
                    tipPos = {left: elePos.left + elePos.width + 5 , top: elePos.top + elePos.height / 2 - tipHeight / 2};
                    break;
                case 'lt':
                    tipPos = {left: elePos.left, top: elePos.top - tipHeight - 5};
                    break;
                case 'lb':
                    tipPos = {left: elePos.left, top: elePos.top + elePos.height  + 5};
                    break;
                case 'rt':
                    tipPos = {left: elePos.left + elePos.width  - tipWidth, top: elePos.top - tipHeight - 5};
                    break;
                case 'rb':
                    tipPos = {left: elePos.left + elePos.width  - tipWidth, top: elePos.top + elePos.height + 5};
                    break;
            }

            $tip.css(tipPos).addClass('ctip-' + position);

        },

        /**
         * 如果用户不指定显示位置，自动计算tip的显示位置
         */
        _calAutoPosition: function(elePos) {
            var $win = $(window);
            var windowSize = {
                width: $win.width(),
                height: $win.height()
            };
            var tb = elePos.top > ($(document).scrollTop() + windowSize.height / 2) ? 't' : 'b';
            var lr = '',
                minDistance = this.options.maxWidth / 2, //距离左右窗边的最小距离
                farToLeft = elePos.left + elePos.width / 2 - $(document).scrollLeft(), //元素到左窗边的距离
                farToRight = windowSize.width - farToLeft; //元素到右窗边的距离

            if(farToLeft < minDistance){
                lr = 'l';
            } else if(farToRight < minDistance){
                lr = 'r';
            }
            return lr + tb;
        },

        /**
         * 获取tip的内容
         */
        getContent: function() {
            var o = this.options;
            return o.content ? o.content : this.$tipEl.attr('tip');
        },

        /**
         * 设置tip的内容
         * @param content {String} tip内容
         */
        setContent: function(content) {
            var content = content || this.getContent();

            //如果tip没有创建，则先创建tip
            if(!this.created){
                this._lazyCreate();
            }

            this.$tip.find(this.options.content_cls).html(content);
            this.$tipEl.attr('tip', content);
        },

        /**
         * 设置tip类型
         * @param tipType {String} tip状态类型，分别有'normal/error'
         */
        setType: function(tipType){
            var self = this,
                opts = self.options;
            self.$tip.removeClass('ctip-' + opts.tipType);
            self.$tip.addClass('ctip-' + tipType);
            opts.tipType = tipType;
        },

        /**
         * 显示tip
         * @param tipType {String} 显示色彩类型，值与options.tipType一致
         */
        show: function(tipType) {
            var self = this;
            self._lazyCreate();
            if($.trim(self.getContent())==='') { //如果tip内容为空，就不显示
                return;
            }

            self.setContent();
            //先重置样式
            self.$tip[0].className = 'ctip';
            self.$tip.css({top: 0, left: 0, display: 'block'});
            self._setMaxWidth();
            self._setPosition();
            self.setType(tipType || self.options.tipType);
            //this.$tip.show();
        },

        /**
         * 隐藏tip
         */
        hide: function() {
            if(this.$tip) {
                this.$tip.hide();
            }
        }

    });

    cui.tipList = {};
    cui.tip = function(el, options) {
        options = options || {};
        options.el = $(el);
        var tiper = new C.UI.Tip(options);

        cui.tipList[tiper.options.uid] = tiper;
        options.el.attr('tipID', tiper.options.uid);
        return tiper;
    };
})(window.comtop.cQuery, window.comtop);