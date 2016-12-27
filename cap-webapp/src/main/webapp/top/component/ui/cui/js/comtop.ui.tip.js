/**
 *
 * Tip���
 *
 * @author ���и�
 * @since 2012-08-29
 * @updata 2013-04-01 by linchaoqun
 */
;(function($, C){

    C.UI.Tip = C.UI.Base.extend({

        options: {
            uitype: 'Tip',
            pointee: true,      //�Ƿ���ʾ��ͷ
            position: 'auto',   //tip����ʾλ��
            live: false,        //�Ƿ���live�ķ�ʽע���¼�
            trigger: 'hover',   //����tip��ʾ�ķ�ʽ
            x: false,           //�Ƿ���ʾ�رհ�ť
            maxWidth: 150,       //�����
            fade: false, 		//�Ƿ��뵭�� todo
            opacity: 1,          //͸���� todo
            tipEl: null,         //ָ����ȡ'tip'���Ե�Ԫ��,Ϊɨ������validate�����Ĵ���
            content_cls: '.ctip-msg',
            close_cls: '.ctip-x',
            tipType: 'normal'      //Ĭ������ɫ ����ֵ normal error
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
         * ����TipDOM�ṹ
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
         * ��Ҫ��ʾtip��domԪ���ϰ���Ӧ�¼�
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
         * ��ʱ����tip
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
         * ��tip���¼�
         */
        _bindEvent: function() {
            var _self = this, o = this.options;
            //�رհ�ť
            if(o.x === true){
                this.$tip.find(o.close_cls).bind('click', function(){
                    _self.hide();
                    return false;
                });
            }

        },

        /**
         * �Ƴ�Ҫ��ʾtip��domԪ�ص�title����
         */
        _fixTitle: function() {
            this.$el.removeAttr('title');
        },

        /**
         * ����tipҪ��ʾ��λ��
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


            //����ie6 ��֧��css max-width���Ե�����
            if( C.Browser.isIE && tipWidth > o.maxWidth){
                $tip.width(o.maxWidth);
                tipWidth = $tip[0].offsetWidth; //���»�ȡ��߶�
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
         * ����û���ָ����ʾλ�ã��Զ�����tip����ʾλ��
         */
        _calAutoPosition: function(elePos) {
            var $win = $(window);
            var windowSize = {
                width: $win.width(),
                height: $win.height()
            };
            var tb = elePos.top > ($(document).scrollTop() + windowSize.height / 2) ? 't' : 'b';
            var lr = '',
                minDistance = this.options.maxWidth / 2, //�������Ҵ��ߵ���С����
                farToLeft = elePos.left + elePos.width / 2 - $(document).scrollLeft(), //Ԫ�ص��󴰱ߵľ���
                farToRight = windowSize.width - farToLeft; //Ԫ�ص��Ҵ��ߵľ���

            if(farToLeft < minDistance){
                lr = 'l';
            } else if(farToRight < minDistance){
                lr = 'r';
            }
            return lr + tb;
        },

        /**
         * ��ȡtip������
         */
        getContent: function() {
            var o = this.options;
            return o.content ? o.content : this.$tipEl.attr('tip');
        },

        /**
         * ����tip������
         * @param content {String} tip����
         */
        setContent: function(content) {
            var content = content || this.getContent();

            //���tipû�д��������ȴ���tip
            if(!this.created){
                this._lazyCreate();
            }

            this.$tip.find(this.options.content_cls).html(content);
            this.$tipEl.attr('tip', content);
        },

        /**
         * ����tip����
         * @param tipType {String} tip״̬���ͣ��ֱ���'normal/error'
         */
        setType: function(tipType){
            var self = this,
                opts = self.options;
            self.$tip.removeClass('ctip-' + opts.tipType);
            self.$tip.addClass('ctip-' + tipType);
            opts.tipType = tipType;
        },

        /**
         * ��ʾtip
         * @param tipType {String} ��ʾɫ�����ͣ�ֵ��options.tipTypeһ��
         */
        show: function(tipType) {
            var self = this;
            self._lazyCreate();
            if($.trim(self.getContent())==='') { //���tip����Ϊ�գ��Ͳ���ʾ
                return;
            }

            self.setContent();
            //��������ʽ
            self.$tip[0].className = 'ctip';
            self.$tip.css({top: 0, left: 0, display: 'block'});
            self._setMaxWidth();
            self._setPosition();
            self.setType(tipType || self.options.tipType);
            //this.$tip.show();
        },

        /**
         * ����tip
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