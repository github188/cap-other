<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<c:if test="${requestScope.app!=null && requestScope.app.navType ==0}">
<div class="app-nav clearfix" id="app-nav">
    <img src="${pageScope.cuiWebRoot}${requestScope.app.logo}" class="app-logo">
    <span class="app-name">${requestScope.app.name}</span>
    <ul class="menu clearfix">
        <c:forEach items="${requestScope.app.businessMenus}" var="menu">
            <c:if test="${menu.menuType==1}">
                 <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" data-menu-id="${menu.id}" href="javascript:void(0)">${menu.name}<b class="caret"></b></a>
                    <ul class="dropdown-menu" role=menu>
                        <c:forEach items="${menu.secondMenus}" var="secondMenu">
                            <li><a href="javascript:void(0)" target="mainFrame" data-url="${secondMenu.url}" data-menu-id="${secondMenu.id}">${secondMenu.name}</a></li>
                        </c:forEach>
                    </ul>
                </li>
            </c:if>
            <c:if test="${menu.menuType!=1}">
                 <li><a href="javascript:void(0)" target="mainFrame" data-url="${menu.url}" data-menu-id="${menu.id}">${menu.name}</a></li>
            </c:if>
        </c:forEach>
    </ul>
</div>
<div class="workbench-container box" id="main-container">
    <iframe id="mainFrame"  name="mainFrame" src="about:blank" frameborder="0" class="" allowTransparency="true"></iframe>
</div>
<script>
    require(['autoIframe'], function() {
        $('#mainFrame').autoFrameHeight('', function() {
            return $(window).height() - 114;
        });
        /**
         *匹配定位菜单 
         */
        window.matchMenu = function(url){
            if(!url){
                return;
            }
            var curUrl = decodeURIComponent(url);
            var curLink = null;
            $('#app-nav a[data-url]').each(function() {
                var $this = $(this);
                var url = $this.data('url');
                if(!url){
                    return true;
                }
                if(url == curUrl){
                    curLink = this;
                    return false;
                }
                if (curUrl.indexOf(url) != -1 && (!curLink||$(curLink).data('url').length < url.length)) {
                    curLink = this;
                }
            });
            if (curLink) {
                $(curLink).closest('li').addClass('active').siblings().removeClass('active');
                $(curLink).closest('.dropdown').addClass('active').siblings().removeClass('active');
            }
        };
        /**
         *自动渲染激活链接,当iframe中页面有跳转时,会用跳转的url和当前app中的菜单匹配 ,并加载激活样式
         */
        $('#mainFrame').load(function() {
            var url = $('#mainFrame')[0].contentWindow.location.href.replace(baseUrl, '');
            window.location.hash = url;
            matchMenu(url);
        });
        
        var curUrl = window.location.hash.replace('#', '');
        if (!curUrl) {
            $('#app-nav a[class!=dropdown-toggle]:first').click();
        } else {
            matchMenu(curUrl);
            $('#mainFrame')[0].src = Workbench.formatUrl(curUrl);
        }
    });
</script>
</c:if>