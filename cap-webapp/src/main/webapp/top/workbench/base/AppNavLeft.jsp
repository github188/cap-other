<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<c:if test="${requestScope.app != null && requestScope.app.navType == 1}">
    <div class="app-nav clearfix" id="app-nav">
        <%//logo延后加载,先处理url路径%>
        <img class="app-logo">
        <span class="app-name">${requestScope.app.name}</span>
    </div>
    <div class="workbench-container" id="main-container"></div>
    <!--查询菜单-->
    <script type="text/template" id="menu-tmpl">
        <div class="app-nav box" id="second-<@=menu.id@>" data-first-menu-id="<@=menu.id@>" style="display:none;">
            <ul class="menu" >
                <@_.each(menu.secondMenus,function(secondMenu){@>
                <li>
                    <a id="<@=secondMenu.id@>" href="javascript:void(0)" target="mainFrame" data-url="<@=secondMenu.url@>" data-menu-id="<@=secondMenu.id@>"><@=secondMenu.name@></a>
                </li>
                <@})@>
                <li class="dropdown more" style="display:none;"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">更多<b class="caret"></b></a><ul class="dropdown-menu" role=menu></ul></li>
            </ul>
        </div>
    </script>
    <script>
        var menuList = ${requestScope.menusJson};
        require(['sidebar', 'underscore',webPath + '/top/workbench/base/js/MainFrame.js'], function(SideBar, _) {
            //默认url
            var sideBar = new SideBar({
                context : '#main-container',
                model : menuList,
                iframe : true,
                frameName : 'mainFrame',
                iframeMinHeight : function() {
                    return $(window).height() - 112 - ($('[data-first-menu-id]:visible').length>0?56:0);
                },
                template : function(menu) {
                    return '<a class="break-word" style="width: 178px;" id="' + menu.id + '" href="javascript:void(0)" target="mainFrame"'
                            + (menu.secondMenus?'':' data-url="' + menu.url)
                            + '" data-menu-id="' + menu.id + '" title="' + menu.name + '">' + menu.name + '</a>';
                },
                isDefaultData : function(menu, index) {
                    return false;
                },
                //有二级菜单打开二级菜单的第一个链接,无二级菜单直接该链接
                //初始化时加载默认页面
                click : function(menu, e) {
                    $('[data-first-menu-id]').hide();
                    //一级a链接的点击跳转由系统组件监听,无需处理
                    if (menu.secondMenus && menu.secondMenus.length > 0) {
                        var $secondMenu = $('#second-' + menu.id);
                        $secondMenu.show().find('a:first').click();
                        $(window).resize();
                    }
                }
            });
            //渲染
            sideBar.render();
            //初始化数据
            //初始化数据
            MainFrame.init({
               //设置菜单数据源
               menuList : ${requestScope.menusJson},
               $frame:$('#mainFrame'),
               //匹配菜单后回调,激活选中的菜单,设置效果
               activeMenu : activeMenu
            });
            //渲染所有二级菜单
            renderSecondMenu(menuList);
            
            var menuInfo = MainFrame.getHashMenuInfo();
            //设置默认加载链接
            if(!menuInfo) {
                $('a[data-menu-id]:first').click();
            } else {
                activeMenu(menuInfo.menuId);
                MainFrame.$frame[0].src = menuInfo.url;
            }
            
            resetAllMenu();
            $(window).resize(function(){
                resetAllMenu();
            });
            /**
             *重置菜单宽度,防止菜单换行 
             */
            function resetAllMenu(){
                var $menu = $('[data-first-menu-id]:visible > ul'),
                    ulWidth = $menu.width();
                if($menu.length>0) {
                    MainFrame.resetMenu(ulWidth,$menu)
                };
            }
            /**
             *激活菜单设置效果 
             */
            function activeMenu(menuId){
                $('[data-first-menu-id]').hide();
                var $menu = $('#' + menuId),$secondMenu = $menu.closest('.app-nav').show();
                MainFrame.activeMenu($menu);
                //匹配到二级菜单
                if($secondMenu.length>0){
                    MainFrame.activeMenu($('#' + $secondMenu.data('first-menu-id')));
                }
                //触发resize事件重新计算iframe高度和调整菜单宽度
                $(window).resize();
            }
            /**
             *渲染二级菜单 
             */
            function renderSecondMenu(menuList){
                for(var i=0;i<menuList.length;i++){
                    var menu = menuList[i];
                    if (menu.secondMenus && menu.secondMenus.length > 0) {
                        var menuHtml = _.template($('#menu-tmpl').html(), {
                            menu : menu
                        });
                        sideBar.main.prepend(menuHtml);   
                    }
                }
            }
        });
    </script>

</c:if>