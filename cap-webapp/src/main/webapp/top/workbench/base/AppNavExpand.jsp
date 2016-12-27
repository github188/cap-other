<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<c:if test="${requestScope.app!=null && requestScope.app.navType ==3}">
    <div class="app-nav clearfix" id="app-nav">
        <%//logo延后加载,先处理url路径%>
        <img class="app-logo">
        <span class="app-name">${requestScope.app.name}</span>
        <ul class="menu clearfix">
            <c:forEach items="${requestScope.app.businessMenus}" var="menu">
                <c:if test="${menu.menuType==1}">
                     <li>
                        <a id="${menu.id}" data-menu-id="${menu.id}" href="javascript:void(0)">${menu.name}</a>
                     </li>
                </c:if>
                <c:if test="${menu.menuType!=1}">
                     <li><a id="${menu.id}" href="javascript:void(0)" target="mainFrame" data-url="${menu.url}" data-menu-id="${menu.id}">${menu.name}</a></li>
                </c:if>
            </c:forEach>
            <li class="dropdown more" style="display:none;"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">更多<b class="caret"></b></a><ul class="dropdown-menu" role=menu></ul></li>
        </ul>
    </div>
    <div class="workbench-container" id="main-container">
        <c:forEach items="${requestScope.app.businessMenus}" var="menu">
            <c:if test="${menu.menuType==1}">
                <div id="second-${menu.id}" data-first-menu-id="${menu.id}" class="tab-menu menu clearfix" style="display:none;">
                <ul class="clearfix" >
                    <c:forEach items="${menu.secondMenus}" var="secondMenu">
                        <li >
                            <a id="${secondMenu.id}" target="mainFrame" data-url="${secondMenu.url}" data-menu-id="${secondMenu.id}">${secondMenu.name}</a>
                        </li>
                    </c:forEach>
                    <li class="dropdown more" style="display:none;"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">更多<b class="caret"></b></a><ul class="dropdown-menu" role=menu></ul></li>
                </ul>
                </div>
            </c:if>
        </c:forEach>
        <div class="frame-wrap">
            <iframe id="mainFrame"  name="mainFrame" src="about:blank" frameborder="0" allowTransparency="true"></iframe>
        </div>
    </div>
    <script>
        <%//设置自动iframe高度%>
        require([webPath + '/top/workbench/base/js/MainFrame.js'], function() {
            //初始化数据
            MainFrame.init({
               //设置菜单数据源
               menuList : ${requestScope.menusJson},
               //匹配菜单后回调,激活选中的菜单,设置效果
               activeMenu : activeMenu,
               //iframe自动高度回调
               getHeight : function() {
                   var marginTop = 112;
                   if ($('.tab-menu:visible').length > 0) {
                       marginTop += 42;
                   }
                   return $(window).height() - marginTop;
               }
            });
            
            //一级导航点击事件,默认加载该目录下第一个菜单
            $('#app-nav').on('click', 'a[data-menu-id]', function() {
            	hasSecondMenu = false;
                var $this = $(this), 
                    curMenuId = $this.data('menu-id'),
                    $secondMenu = $('#second-' + curMenuId);
                $('.tab-menu').hide();
                if($secondMenu.length>0){
                	//点击的一级菜单下有二级菜单
                	hasSecondMenu = true;
                    $secondMenu.show().find('a:first').click();
                    MainFrame.resetMenu($secondMenu.width(),$secondMenu.children());
                }
            });
            
            var menuInfo = MainFrame.getHashMenuInfo();
            //设置默认加载链接
            if (!menuInfo) {
                $('#app-nav li:first > a').click();
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
                var $menu = $('#app-nav > .menu'),
                    ulWidth = $('#app-nav').width() + $('#app-nav').offset().left - $menu.children('li:eq(0)').offset().left + 10;
                MainFrame.resetMenu(ulWidth,$menu);
                $menu = $('.tab-menu:visible>ul');
                ulWidth = $menu.width();
                if($menu.length>0) MainFrame.resetMenu(ulWidth,$menu);
            }
            /**
             *激活菜单设置效果 
             */
            function activeMenu(menuId){
            	if(lastOpenType !=1 && lastOpenType !=2){
            		$('.tab-menu').hide();
                    var $menu = $('#' + menuId),
                        $secondMenu = $menu.closest('.tab-menu').show();
                    MainFrame.activeMenu($menu);
                    //匹配到二级菜单
                    if($secondMenu.length>0){
                        MainFrame.activeMenu($('#' + $secondMenu.data('first-menu-id')));
                    }
                    //触发resize事件重新计算iframe高度和调整菜单宽度
                    $(window).resize();
            	}
                
            }
        });
    </script>
</c:if>