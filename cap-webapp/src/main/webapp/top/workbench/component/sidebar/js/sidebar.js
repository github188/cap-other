css.load(webPath + '/top/workbench/component/sidebar/css/sidebar.css');
define(['underscore', 'text!' + webPath + '/top/workbench/component/sidebar/template/sidebar.html','autoIframe'], function( _, template) {
    var SideBar = function(option) {
        if (!option || !option.model || !option.template || !option.context) {
            //console.log('左侧导航没有初始化数据！');
            return;
        }
        $.extend(this, option);
        //初始化dom结构
        this.context = $(this.context);
        var sideBarHtml = _.template($(template).filter('#sidebar-tmp').html(), {
            title : this.title||'',
            toggle : this.toggle,
            width : this.width,
            iframe : this.iframe,
            frameName:this.frameName,
            margin : this.margin,
            search : this.search
        });
        this.context.html(sideBarHtml);
        this.side = $(this.side, this.context);
        this.main = $(this.main, this.context);
        //初始化,事件加载
        this.iniEvent();
    };
    SideBar.prototype = {
        //渲染的容器
        context : 'body',
        //导航栏题头
        title : '',
        //导航宽度
        width : 200,
        //收缩后的宽度
        minWidth : 50,
        //弹出层菜单最大宽度
        subMenuMaxWidth:700,
        //弹出层菜单最大高度
        subMenuMaxHeight:600,
        //弹出层菜单最小高度
        subMenuMinHeight:400,
        //是否可收缩
        toggle : false,
        //导航选择器
        side : '.side',
        //页面加载主体选择器
        main : '.main',
        //是否在iframe中打开
        iframe : false,
        //frame名称和id
        frameName:'sideFrame',
        //frame高度是否自适应
        iframeAutoHeight: true,
        //导航和页面之间间距
        margin : 10,
        //渲染的数据对象
        model : [],
        //是否支持查询
        search:false,
        //数据对象主键,主要用于查询过滤
        primaryKey:null,
        iframeMinHeight:function(){
            return 'auto';
        },
        //过滤列表
        filterList:function(searchValue){
            var self = this;
            for(var i =0;i<self.model.length;i++){
                var isIn = self.filter(self.model[i],searchValue);
                var li = $('#' + self.model[i][self.primaryKey]);
                if(isIn){
                    li.show();
                }else{
                    li.hide();
                }
            }
        },
        //过滤单个对象,返回false隐藏
        filter:function(data,searchValue){
            return true;
        },
        //是否默认加载的数据
        isDefaultData : function(data, index) {
            if (index == 0) {
                return true;
            }
            return false;
        },
        //模板
        template : function() {
            return '';
        },
        //子菜单模板
        subTemplate : function(){
          return '';  
        },
        click : function(data, el) {//左侧导航点击事件,默认阻止事件冒泡
            var url = $(el).data('url');
            if (url) {
                this.main.load(url);
            }
            return false;
        },
        subClick : function(data, el) {//弹出菜单点击事件,默认阻止事件冒泡
            var url = $(el).data('url');
            if (url) {
                this.main.load(url);
            }
            return false;
        },
        formatUrl:function(url){
            if(!url){
                return '';
            }
            try{
            	//出现无法解码的额问题（但是这里为什么要界面呢？没看见有编码的地方啊，先catch处理吧）
                url = decodeURIComponent(url);
            }catch(e){
            	
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
        //加载事件
        iniEvent : function() {
            var self = this;
            if(self.search){
                //过滤事件
                $('.search').bind('keypress',function(e){
                    if(e.which==13){
                        var searchValue = $.trim($(this).val());
                        self.filterList(searchValue);
                    }
                }).bind('blur',function(){
                    var $this = $(this);
                    var searchValue = $.trim($this.val());
                    if(!searchValue){
                        $this.addClass('empty').val($this.attr('empty_text'));
                    }
                    self.filterList(searchValue);
                }).bind('focus',function(){
                    var $this = $(this);
                    if($this.hasClass('empty')){
                        $(this).removeClass('empty').val('');
                    }
                });
            }
            //弹出菜单点击事件
            $(self.side).off('click', '.sub-menu a').on('click', '.sub-menu a', function(e) {
                e.preventDefault();
                //e.stopPropagation();
                var el = $(this);
                var li = el.parents('li');
                li.siblings().removeClass('active');
                li.addClass('active');
                var data = li.data('bar-data');
                return self.subClick(data, this);
            });
            
            //左侧导航事件加载
            $(self.side).off('click', '.side-menu li > a').on('click', '.side-menu li > a', function(e) {
                e.preventDefault();
                //e.stopPropagation();
                var el = $(this);
                var li = el.parents('li');
                if(li.children('.sub-menu').length == 0){
                    li.siblings().removeClass('active');
                    li.addClass('active');
                }
                var data = li.data('bar-data');
                return self.click(data, this);
            });
            //左侧导航栏切换效果
            $(self.side).off('click', '.toggle-btn').on('click', '.toggle-btn', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var side = self.side;
                var main = self.main;
                var width = self.width;
                var margin = self.margin;
                if (!side.parent().hasClass('min-sidebar')) {
                    width = self.minWidth;
                }
                //将子元素设为最大宽度
                side.children().width(self.width);
                //将sidebar置为最大
                side.parent().removeClass('min-sidebar');
                side.animate({
                    width : width
                }, function() {
                    if (width == self.minWidth) {
                        side.parent().addClass('min-sidebar');
                    }
                    side.children().width('auto');
                    main.css('margin-left', width + margin);
                });
                main.animate({
                    'margin-left' : width + margin
                }, function() {
                    main.css('margin-left', width + margin);
                });
            });
            //hover效果
            $(self.side).off('mouseenter', '.side-menu li').on('mouseenter', '.side-menu li', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var el = $(this);
                el.children('a').addClass('menu-hove');
                var subMenu = el.children('.sub-menu');
                if(subMenu.length > 0){//计算sub menu 的宽高和位置
                    var width = Math.min(self.main.width(),self.subMenuMaxWidth);
                    //上下各保留10px距离
                    var margin = 10;
                    var winHeight = $(window).height() - margin*2;
                    var maxHeight = Math.min(winHeight,self.subMenuMaxHeight);
                    var minHeight = Math.min(winHeight,self.subMenuMinHeight);
                    el.siblings().children('.sub-menu').hide();
                    subMenu.css({width : width,'max-height':maxHeight,'min-height':minHeight}).show();
                    
                    var top = 0;
                    var pos = el.offset();
                    var topToWin = pos.top - $(window).scrollTop();
                    if(topToWin < 0){
                        top = Math.abs(topToWin) + margin;
                    }else{
                        top = Math.min(winHeight - topToWin - subMenu.height() + margin,0);
                    }
                    subMenu.css({top:top});
                }
            });
            //hover效果
            $(self.side).off('mouseleave', '.side-menu li').on('mouseleave', '.side-menu li', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var el = $(this);
                el.children('.sub-menu').hide();
                el.children('a').removeClass('menu-hove');
            });

            //添加ifame事件
            if (self.iframe) {
                //重置load方法改为iframe中加载
            	var iframeAutoHeight = self.iframeAutoHeight;
                self.main.load = function(url) {
                    $('iframe', self.main).attr('src', self.formatUrl(url));
                };
                function iframeMinHeight(){
                    return self.iframeMinHeight.call(self);
                }
                if(iframeAutoHeight){
                	$('iframe', self.main).autoFrameHeight('',iframeMinHeight);
                }
            }
        },
        //渲染
        render : function() {
            var self = this;
            var optList = $('#opt-list', self.side);
            var index = 0;
            var defaultEl = null;
            $(self.model).each(function() {
                var tmp = self.template(this);
                if (tmp) {
                    var li = $('<li></li>').html(tmp).data('bar-data', this);
                    if(self.primaryKey){
                        li.attr('id',this[self.primaryKey]);
                    }
                    if (index == 0) {
                        li.addClass('first-child');
                    }
                    optList.append(li);
                    if (self.isDefaultData(this, index++)) {
                        defaultEl = li.children('a');
                    }
                    
                    var subTmp = self.subTemplate(this);
                    if(subTmp){
                        li.append(subTmp);
                    }
                }
            });
            //默认加载
            if (defaultEl) {
                defaultEl.click();
            }
            
            $(window).resize();
            return self;
        }
    };
    return SideBar;
});
