?;(function($, C){
    "use strict";
    var buttonImgPath = '';
    /**
     * @class C.UI.Button
     * @extends C.UI.Base
     * ��ťUI���<br>
     *
     * 1.ͨ�����������ܶ�̬������ͨ��ť���˵���ť��<br>
     * 2.��ť������Ӧ��ȣ������ֶ����ÿ��<br>
     * 3.�����Ľ��û������ð�ť��<br><br>
     * @author ̷����
     * @version 1.0
     * @history 2012-10-17 ̷���� �½�
     * @demo doc/buttonDoc.html
     */
    C.UI.Button = C.UI.Base.extend({
        options: {
            uitype:'Button',//������ͣ�button
            label:'',//��ť��ʾ������
            hide:false,//��ʼ��ʱ���Ƿ�����,hidden�����ǩ��Ĭ�����Գ�ͻ
            disable:false,//��ʼ��ʱ���Ƿ����
            icon:'',//��ť��ͼƬ
            on_click:null,//����¼�
            menu:null,//�����˵�
            button_type:"",//�˵�����ʽ
            mark:""
        },
        /**
         * ��ʼ�����Է���
         */
        _init:function(){
            var opts = this.options;
            this.$el = opts.el;
            opts.label = opts.label || this.$el.html() || '��&nbsp;ť';
            opts.menuId = 'button_' + C.guid();
        },
        /**
         * ��ʼ��ģ�巽��
         */
        _create:function(){
            var self = this,opts = self.options;
            this._createDom();

            if(opts.hide){
                this.hide();
            }
            if(opts.disable){
                this.disable(true);
            }
            if(opts.icon){
                this._setIcon(opts.icon);
            }
            if(opts.menu){
                if($.isFunction(opts.menu)){//����������һ��������ִ�з����������
            		opts.menu = opts.menu();
            	}
            	opts.menu = cui("#" + opts.menuId).menu(opts.menu);//���ݴ�������ݴ���menu����
            	opts.el.children('a').unbind('click');//��menu����ж���ռλ�����Ĭ�ϰ���click�¼�����������
            }
            //�󶨵���¼�
            opts.el.children('a').on("click",function(e){
                self._clickHandler(e,this,e.target);
                return false;
            })
        },
        /**
         * ����button����domԪ��
         * ����DOM����Root������
         * @private
         */
        _createDom: function () {
            var opts = this.options,
                $el = this.$el,
                buttonHtml = [];
            //Ԫ�ؽṹ
            buttonHtml.push('<a class="cui-button ');
            if(C.Browser.isQM){
                buttonHtml.push('QM-cui-button ');
            }
            if(opts.button_type){
                buttonHtml.push(opts.button_type);
            }
            buttonHtml.push('" hidefocus="true" href="#">');
            if(opts.icon){
                buttonHtml.push('<span class="button-icon cui-icon">&nbsp;</span>');
            }
            buttonHtml.push('<span class="button-label">' + opts.label + '</span>');
            if(opts.menu){
                buttonHtml.push('<span class="button-arrow cui-icon">&#xf0dc;</span>');
            }
            buttonHtml.push('</a>');
            $el.html(buttonHtml.join(""));
        },
        /**
         * ��ͼ��
         * @param {string} icon ͼƬ��·��
         */
        _setIcon:function(icon){
            var cIcon = C.icon;
            if (/\./.test(icon)) {
                if(!/\/+/.test(icon)){
                    icon = this._getIconPath('comtop.ui') +'images/button/' + icon;
                }
                this.$el.find('.button-icon').addClass('button-icon-center').html('<img src="' + icon + '" />');
            } else {
                this.$el.find('.button-icon').html(cIcon[icon] || "");
            }
        },
        /**
         * �����ť
         * @param {event} e ����¼�
         * @param {dom} eventEl  ָ����¼���ԭ��DOM����
         * @param {dom} target ָ���¼���׽����ԭ��DOM����
         */
        _clickHandler:function(e, eventEl, target){
            var opts = this.options;
        	if(opts.disable)return;
        	e.stopPropagation();
        	//��ʾ�˵�
        	var objMenu = opts.menu;
        	objMenu && objMenu.show(this.$el.children('.cui-button'));
        	//ִ�лص�����
        	this.options.on_click && this.options.on_click(e,this, opts.mark);
        },

        /**
         * ��ȡ�̶�ͼƬ��·��,����js�е�ͼƬ�ǲο�ҳ������λ�ӵģ�����Ҫ��ȡjs��·��
         * @return iconPath
         */
        _getIconPath:function(keyWord){
            //����Ѿ�����·�������ٲ���
            if(buttonImgPath){
                return buttonImgPath;
            }
            var $link = $('link');
            var path;
            var reg = new RegExp(keyWord);
            for( var i = 0; i <  $link.length; i++ ){
                path = $link.eq(i).attr('href');
                if( reg.test(path) ){
                    break;
                }
            }
            path = path.substr( 0, path.lastIndexOf('/') );
            buttonImgPath = path = path.substr( 0, path.lastIndexOf('/') + 1 );
            return path;
        },
         /**
         * ��̬���ð�ť
         * @param {boolean} flag �Ƿ���ð�ť
         **/
         disable:function(flag){
           if(flag == true){
               //this.options.el ���Ԫ���ǿ���ж���ġ�ÿ���̳��˶��л���Ķ����У�el����ռλ����dom����
        	   this.options.disable = true;
               this.options.el.children('.cui-button').addClass('disable-button');
               if(this.options.menu){
            	   this.options.menu.hide && this.options.menu.hide();
               }
           }else{
        	   this.options.disable = false;
               this.options.el.children('.cui-button').removeClass('disable-button');
           }
        },
        /**
         * ��̬���ذ�ť
         **/
        hide:function(){
        	this.options.el.hide();
        	this.options.menu && this.options.menu.hide && this.options.menu.hide();
        },

        /**
         * �޸İ�ťlabel
         * @param label {String} ��ť����
         */
        setLabel:function(label){
            var type = $.type(label),
                opts = this.options;
            if(type === 'number' || type === 'string'){
                opts.label = label;
                opts.el.children('a').children('.button-label').html(label);
            }
        },

        /**
         * ��ȡlabel
         * @returns {string} ��ť����
         */
        getLabel: function(){
            return this.options.label;
        },

        /**
         * ��ȡbutton�ϵ�menu
         * @returns {CUI} ����cui�������
         */
        getMenu: function(){
            return this.options.menu;
        }
    })
})(window.comtop.cQuery, window.comtop);