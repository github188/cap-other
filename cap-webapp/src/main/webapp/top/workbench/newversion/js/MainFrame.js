/**
 * 主框架公共js
 */
define(['autoIframe'],function(){
    'use strict';
    window.MainFrame = {
        menuList : [],
        $frame : $('#mainFrame'),
        baseUrl : location.protocol + '//' + location.hostname + (location.port?':' + location.port:''),
        /**
         *获取当前菜单id,name,主要是暴露给责任田调用 
         */
        getCurMenu:function(){
            var $curLink = $('.active > a[data-url]');
            return {id:$curLink.data('menuId'),name:$curLink.html()};
        },
        /**
         *重置菜单,当菜单过多的时候自动出现"更多"选项 
         */
        resetMenu:function(mWidth,$menu){
            var $more = $menu.children('.more'),
                moreWidth = $more.width(),
                $moreUL = $more.children('ul'),
                $moreLI,
                $liList = $menu.children('li:visible');
            
            $liList.each(function(){
                var $this = $(this),liWidth = $this.data('width')||$this.width();
                mWidth -= liWidth;
                $this.data('width',liWidth);
                //剩余宽度不足以放下该菜单
                if(mWidth<0){
                    //当前菜单是"更多"的话,需要将前一菜单放到"更多"中
                    if($this.is('.more')){
                        $moreUL.prepend($this.prev());
                        return false;
                    }
                    $moreUL.append($this);
                }
            });
            
            $moreLI = $('>li',$moreUL);
            if(mWidth>0&&$moreLI.length>0){
                $moreLI.each(function(index){
                    var $this = $(this);
                    mWidth -= ($this.data('width')||$this.width());
                    //如果more菜单下只剩余一个菜单,则尝试将该菜单提出来,再计算可不可以放得下
                    if($moreUL.children('li').length==1){
                        mWidth += moreWidth;
                    }
                    //剩余宽度足以放下当前菜单
                    if(mWidth>0){
                        //如果当前菜单是3级菜单,将3级菜单升级为2级菜单,只有下拉菜单时才会存在3级菜单的情况
                        if($this.hasClass('dropdown-submenu'))$this.removeClass('dropdown-submenu').addClass('dropdown');
                        $more.before($this);
                    }
                });
            }
            
            //当前菜单是否在"更多"中,如果在,激活"更多"菜单
            if($moreUL.children('li').length==0){
                $more.hide();
                return;
            }
            //当前菜单在更多菜单下,则激活更多菜单选中效果,否则移除效果
            if($moreUL.children('li.active').length==0){
                $more.removeClass('active');
            }else{
                $more.addClass('active');
            }
            //如果当前菜单是2级菜单,将2级菜单降级为3级菜单,只有下拉菜单时才会存在3级菜单的情况
            $more.find('.dropdown').removeClass('dropdown').addClass('dropdown-submenu');
            $more.show();
        },
        /**
         *当前激活菜单本地缓存,当f5刷新时需要通过该方法获取当前的菜单id  
         */
        setCurMenuId:function(menuId,url){
            var hashMenuInfo = this.getHashMenuInfo();
            if(hashMenuInfo){
                menuId = menuId||hashMenuInfo.menuId;
                url = url||hashMenuInfo.url||'';
            }
            menuId = menuId||'';
            url = url||'';
            window.location.hash = 'menuId=' + menuId + '&url=' + url;
        },
        /**
         * 根据url获取与该url匹配的菜单id,
         * 匹配规则为:完全相等的>相似的,相似的长度越长,匹配度越高
         * @param {Object} url 需要匹配的url
         */
        getCurMenuId:function(url){
            if(!url){
                return '';
            }
            var curUrl = url,
                hashMenu = this.getHashMenuInfo(),
                hashMenuId = hashMenu?hashMenu.menuId:'',
                hashUrl = hashMenuId?$('#' + hashMenuId).data('url'):'',
                hashUrl = Workbench.formatUrl(hashUrl),
                menuList = this.menuList,i,j,
                menu,secondMenu,menuUrl;
            try{
                //子系统如果为gbk编码,解码会报错
                curUrl = decodeURIComponent(url);
            }catch(e){}
            if(hashUrl&&curUrl.indexOf(hashUrl)!=-1){
                return hashMenuId;
            }
            
            for (i = 0; i < menuList.length; i++) {
                menu = menuList[i];
                menuUrl = Workbench.formatUrl(menu.url);
                if(curUrl == menuUrl){
                    return menu.id;
                }
                if (menu.secondMenus && menu.secondMenus.length > 0) {
                    for (j = 0; j < menu.secondMenus.length; j++) {
                        secondMenu = menu.secondMenus[j];
                        menuUrl = Workbench.formatUrl(secondMenu.url);
                        //验证菜单合法性
                        if(!menuUrl||menuUrl.indexOf('/')==-1||menuUrl==webPath){
                            continue;
                        }
                        if(curUrl == menuUrl){
                            return secondMenu.id;
                        }
                    }
                }
            }
            
            //如果存在匹配,则激活匹配的菜单,否则激活刷新之前的菜单
            return hashMenuId;
        },
        /**
         * iframe加载完后回调,匹配菜单
         * @param {Object} callback 回调函数
         */
        matchMenu:function(callback){
            var _self = this;
            this.$frame.load(function() {
                var url = _self.$frame[0].contentWindow.location.href.replace(MainFrame.baseUrl, ''),
                    menuId = MainFrame.getCurMenuId(url);
                //缓存当前菜单id
                MainFrame.setCurMenuId(menuId,url);
                callback(menuId,url);
            });
        },
        /**
         * 设置iframe自动高度
         * @param {Object} getHeight 返回高度
         */
        autoHeight:function(getHeight){
            this.$frame.autoFrameHeight('', getHeight);
        },
        /**
         * 激活菜单设置效果,主要是f5刷新时不能通过事件去定位与设置效果,所以需要该方法
         * @param {Object} $menu 菜单jQuery对象,对应a链接
         */
        activeMenu:function($menu){
            $menu.parents('li').addClass('active').siblings().removeClass('active').find('li').removeClass('active');
        },
        /**
         *格式化hash中的菜单信息 
         */
        getHashMenuInfo:function(){
           var hash = window.location.hash?window.location.hash.replace('#', ''):'',
               exp,result,menuInfo=null;
            if(hash){
                exp = /(menuId=(.+)&)?url=(.*)/i;
                result = hash.match(exp);
                if(result&&result.length>2){
                    menuInfo = {};
                    menuInfo.menuId = result[2];
                    if(result.length>3){
                        menuInfo.url = result[3];
                    }
                }
            }
            return menuInfo;
        },
        /**
         * 初始化方法
         * @param {Object} menuList菜单json数据
         * @param {Object} $iframeiframe对象
         */
        init:function(options){
            this.menuList = options.menuList||[];
            if(options.$frame){
                this.$frame = options.$frame;
            }
            if(options.activeMenu){
                this.matchMenu(options.activeMenu);
            }
            if(options.getHeight){
                this.autoHeight(options.getHeight);
            }
        }
    };
    window.getCurMenu = MainFrame.getCurMenu;
    return MainFrame;
});