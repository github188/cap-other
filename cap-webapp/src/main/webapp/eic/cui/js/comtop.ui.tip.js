/**
 *
 * Tip???
 *
 * @author ???§Ú?
 * @since 2012-08-29
 * @updata 2013-04-01 by linchaoqun
 */
;(function($, C){

    C.UI.Tip = C.UI.Base.extend({

        options: {
            uitype: 'Tip',
            pointee: true,      //?????????
            position: 'auto',   //tip?????¦Ë??
            live: false,        //?????live??????????
            trigger: 'hover',   //????tip???????
            x: false,           //???????????
            maxWidth: 150,       //?????

            fade: false, 		//??????? todo
            opacity: 1,          //????? todo

            tipEl: null,         //??????'tip'????????,????????validate?????????

            content_cls: '.ctip-msg',
            close_cls: '.ctip-x'
        },

        _init: function() {
            this.options.uid = 'tip_' + comtop.guid();
            var o = this.options;
            this.$el = $(o.el);
            this.$tipEl = o.tipEl ? $(o.tipEl) : this.$el;
            //this.content = o.content ? o.content : this.$el.attr('tip');
            this._bindElEvent();
            this._fixTitle();
        },

        _create: function() {
            if(this.options.trigger=='onload') {
                this.show();
            }
        },

        /**
         * ??????tip??dom????????????
         */
        _bindElEvent: function() {
            var _self = this, o = this.options;
            var binder = (o.live=='true' || o.live ===true) ? 'live' : 'bind',
                eventIn = o.trigger == 'hover' ? 'mouseenter' : o.trigger == 'click' ? 'click' : 'focus',
                eventOut = o.trigger == 'hover' ? 'mouseleave' : o.trigger == 'click' ? '' : 'blur';

            this.$el[binder](eventIn, function(){
                _self.show();
                return false;
            })[binder](eventOut, function(){
                _self.hide();
                return false;
            });
        },

        /**
         * ???????tip
         */
        _lazyCreate: function() {
            if(!this.created){
                var o = this.options;
                $(document.body).append(this._getView());
                this.$tip = $('#' + o.uid);
                //this.setContent(this.content);
                this._bindEvent();
                //this._fixTitle();
                this.created = true;
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
         * ???????tip??html???
         */
        _getView: function() {
            return this._buildTemplateStr('tip', this.options);
        },

        /**
         * ??tip?????
         */
        _bindEvent: function() {
            var _self = this, o = this.options;
            //?????
            if(o.x===true){
                this.$tip.find(o.close_cls).bind('click', function(){
                    _self.hide();
                    return false;
                });
            }

        },

        /**
         * ???????tip??dom????title????
         */
        _fixTitle: function() {
            this.$el.removeAttr('title');
        },

        /**
         * ????tip??????¦Ë??
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


            //????ie6 ?????css max-width?????????
            if( C.Browser.isIE && tipWidth > o.maxWidth){
                $tip.width(o.maxWidth);
                tipWidth = $tip[0].offsetWidth; //??????????
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
         * ??????????????¦Ë??????????tip?????¦Ë??
         */
        _calAutoPosition: function(elePos) {
            var windowSize = C.Dom.windowSize();
            var tb = elePos.top > ($(document).scrollTop() + windowSize.height / 2) ? 't' : 'b';
            var lr = '',
                minDistance = this.options.maxWidth / 2, //??????????????§³????
                farToLeft = elePos.left + elePos.width / 2 - $(document).scrollLeft(), //???????????
                farToRight = windowSize.width - farToLeft; //?????????????

            if(farToLeft < minDistance){
                lr = 'l';
            } else if(farToRight < minDistance){
                lr = 'r';
            }
            return lr + tb;
        },

        /**
         * ???tip??????
         */
        getContent: function() {
            var o = this.options;
            return o.content ? o.content : this.$tipEl.attr('tip');
        },

        /*
         *????tip??????
         */
        setContent: function() {
            var content = this.getContent();
            this.$tip.find(this.options.content_cls).html(content);
        },

        /**
         * ???tip
         */
        show: function() {
            this._lazyCreate();
            if($.trim(this.getContent())=='') { //???tip??????????????
                return;
            }

            this.setContent();
            //?????????
            this.$tip[0].className = 'ctip';
            this.$tip.css({top: 0, left: 0, display: 'block'});
            this._setMaxWidth();
            this._setPosition();
            //this.$tip.show();
        },

        /**
         * ????tip
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