?;(function($, C){
    "use strict";
    var buttonImgPath = '';
    /**
     * @class C.UI.Button
     * @extends C.UI.Base
     * 按钮UI组件<br>
     *
     * 1.通过属性配置能动态生成普通按钮，菜单按钮。<br>
     * 2.按钮能自适应宽度，无需手动设置宽度<br>
     * 3.可灵活的禁用或者启用按钮。<br><br>
     * @author 谭国华
     * @version 1.0
     * @history 2012-10-17 谭国华 新建
     * @demo doc/buttonDoc.html
     */
    C.UI.Button = C.UI.Base.extend({
        options: {
            uitype:'Button',//组件类型，button
            label:'',//按钮显示的文字
            hide:false,//初始化时候是否隐藏,hidden会与标签的默认属性冲突
            disable:false,//初始化时候是否禁用
            icon:'',//按钮的图片
            on_click:null,//点击事件
            menu:null,//下拉菜单
            button_type:"",//菜单的样式
            mark:""
        },
        /**
         * 初始化属性方法
         */
        _init:function(){
            var opts = this.options;
            this.$el = opts.el;
            opts.label = opts.label || this.$el.html() || '按&nbsp;钮';
            opts.menuId = 'button_' + C.guid();
        },
        /**
         * 初始化模板方法
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
                if($.isFunction(opts.menu)){//如果传入的是一个方法就执行方法获得数据
            		opts.menu = opts.menu();
            	}
            	opts.menu = cui("#" + opts.menuId).menu(opts.menu);//根据传入的数据创建menu对象
            	opts.el.children('a').unbind('click');//在menu组件中对于占位符组件默认绑定了click事件，这里解除。
            }
            //绑定点击事件
            opts.el.children('a').on("click",function(e){
                self._clickHandler(e,this,e.target);
                return false;
            })
        },
        /**
         * 创建button所有dom元素
         * 并把DOM存入Root属性中
         * @private
         */
        _createDom: function () {
            var opts = this.options,
                $el = this.$el,
                buttonHtml = [];
            //元素结构
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
         * 换图标
         * @param {string} icon 图片的路径
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
         * 点击按钮
         * @param {event} e 点击事件
         * @param {dom} eventEl  指向绑定事件的原生DOM对象
         * @param {dom} target 指向事件捕捉到的原生DOM对象
         */
        _clickHandler:function(e, eventEl, target){
            var opts = this.options;
        	if(opts.disable)return;
        	e.stopPropagation();
        	//显示菜单
        	var objMenu = opts.menu;
        	objMenu && objMenu.show(this.$el.children('.cui-button'));
        	//执行回调函数
        	this.options.on_click && this.options.on_click(e,this, opts.mark);
        },

        /**
         * 获取固定图片的路径,由于js中的图片是参考页面所在位子的，所以要获取js的路径
         * @return iconPath
         */
        _getIconPath:function(keyWord){
            //如果已经存在路径，则不再查找
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
         * 动态禁用按钮
         * @param {boolean} flag 是否禁用按钮
         **/
         disable:function(flag){
           if(flag == true){
               //this.options.el 这个元素是框架中定义的。每个继承了都有基类的对象都有，el就是占位符的dom对象
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
         * 动态隐藏按钮
         **/
        hide:function(){
        	this.options.el.hide();
        	this.options.menu && this.options.menu.hide && this.options.menu.hide();
        },

        /**
         * 修改按钮label
         * @param label {String} 按钮文字
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
         * 获取label
         * @returns {string} 按钮文字
         */
        getLabel: function(){
            return this.options.label;
        },

        /**
         * 获取button上的menu
         * @returns {CUI} 返回cui组件对象
         */
        getMenu: function(){
            return this.options.menu;
        }
    })
})(window.comtop.cQuery, window.comtop);