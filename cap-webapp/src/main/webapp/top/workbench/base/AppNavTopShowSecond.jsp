<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<c:if test="${requestScope.app!=null && requestScope.app.navType ==3}">
    <div class="app-nav nav-type-show-second clearfix" id="app-nav">
        <img src="${pageScope.cuiWebRoot}${requestScope.app.logo}" class="app-logo">
        <span class="app-name">${requestScope.app.name}</span>
        <ul class="menu clearfix">
            <c:forEach items="${requestScope.app.businessMenus}" var="menu">
                <c:if test="${menu.menuType==1}">
                     <li class="dropdown">
                        <a class="dropdown-toggle" data-menu-id="${menu.id}" href="javascript:void(0)">${menu.name}</a>
                     </li>
                </c:if>
                <c:if test="${menu.menuType!=1}">
                     <li><a href="javascript:void(0)" target="mainFrame" data-url="${menu.url}" data-menu-id="${menu.id}">${menu.name}</a></li>
                </c:if>
            </c:forEach>
        </ul>
    </div>
    <div class="workbench-container box" id="main-container">
        <c:forEach items="${requestScope.app.businessMenus}" var="menu">
            <c:if test="${menu.menuType==1}">
            <div class="tab-menu" style="display:none;" id="${menu.id}">
                <ul class="nav-tabs clearfix">
                    <c:forEach items="${menu.secondMenus}" var="secondMenu">
                        <li >
                            <a target="mainFrame" data-url="${secondMenu.url}" data-menu-id="${secondMenu.id}">${secondMenu.name}</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            </c:if>
        </c:forEach>
        <iframe id="mainFrame"  name="mainFrame" src="about:blank" frameborder="0" allowTransparency="true"></iframe>
    </div>
    <script>
        <%//�����Զ�iframe�߶�%>
        require(['autoIframe'], function() {
            <%//һ����������¼�,Ĭ�ϼ��ظ�Ŀ¼�µ�һ���˵�%>
            $('#app-nav').on('click', 'a[data-menu-id]', function() {
                $this = $(this);
                var menuId = $this.data('menu-id');
                $('.tab-menu').hide();
                $('#' + menuId).show();
                $('a:first', '#' + menuId).click();
            });
    
            <%//�˵�����¼�,����Ч��%>
            $('#main-container').on('click', '.tab-menu a', function() {
                var li = $(this).parent();
                li.addClass('active').siblings().removeClass('active');
                var menuId = li.closest('.tab-menu').attr('id');
                if (menuId) {
                    $('a[data-menu-id=' + menuId + ']:eq(0)').parent().addClass('active').siblings().removeClass('active');
                }
            });
            /**
            *ƥ�䶨λ�˵� 
             */
            window.matchMenu = function(url){
                if(!url){
                    return;
                }
                var curUrl = decodeURIComponent(url);
                var curLink = null;
                $('a[data-url]').each(function() {
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
                if(curLink){
                    curLink = $(curLink);
                    curLink.parent().addClass('active').siblings().removeClass('active');
                    var curTabMenu = curLink.closest('.tab-menu').show();
                    curTabMenu.siblings('.tab-menu').hide();
                    var menuId = curTabMenu.attr('id');
                    if (menuId) {
                        $('a[data-menu-id=' + menuId + ']:eq(0)').parent().addClass('active').siblings().removeClass('active');
                    }
                }
            };
            /**
             *�Զ���Ⱦ��������,��iframe��ҳ������תʱ,������ת��url�͵�ǰapp�еĲ˵�ƥ�� ,�����ؼ�����ʽ
             */
            $('#mainFrame').load(function() {
                var url = $('#mainFrame')[0].contentWindow.location.href.replace(baseUrl, '');
                window.location.hash = url;
                matchMenu(url);
            });
            
            function autoIframe(){
                $('#mainFrame').autoFrameHeight('', function() {
                    var marginTop = 116;
                    if ($('.tab-menu:visible').length > 0) {
                        marginTop = 160;
                    }
                    return $(window).height() - marginTop;
                });
            }
            <%//����תurl,Ĭ�ϼ��ص�һ���˵�%>
            var curUrl = window.location.hash.replace('#', '');
            if (!curUrl) {
                autoIframe();
                $('#app-nav li:first > a').click();
            } else {
                matchMenu(curUrl);
                autoIframe();
                $('#mainFrame')[0].src = Workbench.formatUrl(curUrl);
            }
        });
    </script>
</c:if>