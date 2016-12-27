<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<c:if test="${requestScope.app!=null && requestScope.app.navType ==3}">
    <div class="app-nav clearfix" id="app-nav">
        <%//logo�Ӻ����,�ȴ���url·��%>
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
            <li class="dropdown more" style="display:none;"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">����<b class="caret"></b></a><ul class="dropdown-menu" role=menu></ul></li>
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
                    <li class="dropdown more" style="display:none;"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">����<b class="caret"></b></a><ul class="dropdown-menu" role=menu></ul></li>
                </ul>
                </div>
            </c:if>
        </c:forEach>
        <div class="frame-wrap">
            <iframe id="mainFrame"  name="mainFrame" src="about:blank" frameborder="0" allowTransparency="true"></iframe>
        </div>
    </div>
    <script>
        <%//�����Զ�iframe�߶�%>
        require([webPath + '/top/workbench/base/js/MainFrame.js'], function() {
            //��ʼ������
            MainFrame.init({
               //���ò˵�����Դ
               menuList : ${requestScope.menusJson},
               //ƥ��˵���ص�,����ѡ�еĲ˵�,����Ч��
               activeMenu : activeMenu,
               //iframe�Զ��߶Ȼص�
               getHeight : function() {
                   var marginTop = 112;
                   if ($('.tab-menu:visible').length > 0) {
                       marginTop += 42;
                   }
                   return $(window).height() - marginTop;
               }
            });
            
            //һ����������¼�,Ĭ�ϼ��ظ�Ŀ¼�µ�һ���˵�
            $('#app-nav').on('click', 'a[data-menu-id]', function() {
            	hasSecondMenu = false;
                var $this = $(this), 
                    curMenuId = $this.data('menu-id'),
                    $secondMenu = $('#second-' + curMenuId);
                $('.tab-menu').hide();
                if($secondMenu.length>0){
                	//�����һ���˵����ж����˵�
                	hasSecondMenu = true;
                    $secondMenu.show().find('a:first').click();
                    MainFrame.resetMenu($secondMenu.width(),$secondMenu.children());
                }
            });
            
            var menuInfo = MainFrame.getHashMenuInfo();
            //����Ĭ�ϼ�������
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
             *���ò˵����,��ֹ�˵����� 
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
             *����˵�����Ч�� 
             */
            function activeMenu(menuId){
            	if(lastOpenType !=1 && lastOpenType !=2){
            		$('.tab-menu').hide();
                    var $menu = $('#' + menuId),
                        $secondMenu = $menu.closest('.tab-menu').show();
                    MainFrame.activeMenu($menu);
                    //ƥ�䵽�����˵�
                    if($secondMenu.length>0){
                        MainFrame.activeMenu($('#' + $secondMenu.data('first-menu-id')));
                    }
                    //����resize�¼����¼���iframe�߶Ⱥ͵����˵����
                    $(window).resize();
            	}
                
            }
        });
    </script>
</c:if>