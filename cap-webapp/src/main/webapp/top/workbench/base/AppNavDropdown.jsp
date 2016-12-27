<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<c:if test="${requestScope.app!=null && requestScope.app.navType ==0}">
<div class="app-nav clearfix" id="app-nav">
    <%//logo延后加载,先处理url路径%>
    <img class="app-logo">
    <span class="app-name">${requestScope.app.name}</span>
    <ul class="menu clearfix">
        <c:forEach items="${requestScope.app.businessMenus}" var="menu">
            <c:if test="${menu.menuType==1}">
                 <li class="dropdown">
                    <a id="${menu.id}" class="dropdown-toggle" data-toggle="dropdown" data-menu-id="${menu.id}" href="javascript:void(0)">${menu.name}<b class="caret"></b></a>
                    <ul class="dropdown-menu" role=menu>
                        <c:forEach items="${menu.secondMenus}" var="secondMenu">
                            <li><a id="${secondMenu.id}" href="javascript:void(0)" target="mainFrame" data-url="<c:if test='${!empty secondMenu.url}'>${secondMenu.url}</c:if>" data-menu-id="${secondMenu.id}">${secondMenu.name}</a></li>
                        </c:forEach>
                    </ul>
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
    <div class="frame-wrap">
        <iframe id="mainFrame"  name="mainFrame" src="about:blank" frameborder="0" allowTrzspansparency="true"></iframe>
    </div>
</div>
<script>
    require([webPath + '/top/workbench/base/js/MainFrame.js'], function() {
        //初始化数据
        MainFrame.init({
           //设置菜单数据源
           menuList : ${requestScope.menusJson},
           //匹配菜单后回调,激活选中的菜单,设置效果
           activeMenu : function(menuId){
                var $menu = $('#' + menuId);
                MainFrame.activeMenu($menu);
                resetAllMenu();
           },
           //iframe自动高度回调
           getHeight : function() {
               return $(window).height() - 112;
           }
        });
        
        var menuInfo = MainFrame.getHashMenuInfo();
        //设置默认加载链接
        if(!menuInfo) {
            $('#app-nav a[data-url]:first').click();
        } else {
            MainFrame.$frame[0].src = menuInfo.url;
            $('.dropdown-menu li a').each(function(){
               if($(this).attr('data-url')==null ||$(this).attr('data-url')==''){
               		$(this).attr('data-url',menuInfo.url);
                }
             });
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
        }
    });
</script>
</c:if>