<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<c:if test="${requestScope.app != null && requestScope.app.navType == 1}">
    <div class="app-nav clearfix" id="app-nav">
        <%//logo�Ӻ����,�ȴ���url·��%>
        <img class="app-logo">
        <span class="app-name">${requestScope.app.name}</span>
    </div>
    <div class="workbench-container" id="main-container"></div>
    <!--��ѯ�˵�-->
    <script type="text/template" id="menu-tmpl">
        <div class="app-nav box" id="second-<@=menu.id@>" data-first-menu-id="<@=menu.id@>" style="display:none;">
            <ul class="menu" >
                <@_.each(menu.secondMenus,function(secondMenu){@>
                <li>
                    <a id="<@=secondMenu.id@>" href="javascript:void(0)" target="mainFrame" data-url="<@=secondMenu.url@>" data-menu-id="<@=secondMenu.id@>"><@=secondMenu.name@></a>
                </li>
                <@})@>
                <li class="dropdown more" style="display:none;"><a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">����<b class="caret"></b></a><ul class="dropdown-menu" role=menu></ul></li>
            </ul>
        </div>
    </script>
    <script>
        var menuList = ${requestScope.menusJson};
        require(['sidebar', 'underscore',webPath + '/top/workbench/base/js/MainFrame.js'], function(SideBar, _) {
            //Ĭ��url
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
                //�ж����˵��򿪶����˵��ĵ�һ������,�޶����˵�ֱ�Ӹ�����
                //��ʼ��ʱ����Ĭ��ҳ��
                click : function(menu, e) {
                    $('[data-first-menu-id]').hide();
                    //һ��a���ӵĵ����ת��ϵͳ�������,���账��
                    if (menu.secondMenus && menu.secondMenus.length > 0) {
                        var $secondMenu = $('#second-' + menu.id);
                        $secondMenu.show().find('a:first').click();
                        $(window).resize();
                    }
                }
            });
            //��Ⱦ
            sideBar.render();
            //��ʼ������
            //��ʼ������
            MainFrame.init({
               //���ò˵�����Դ
               menuList : ${requestScope.menusJson},
               $frame:$('#mainFrame'),
               //ƥ��˵���ص�,����ѡ�еĲ˵�,����Ч��
               activeMenu : activeMenu
            });
            //��Ⱦ���ж����˵�
            renderSecondMenu(menuList);
            
            var menuInfo = MainFrame.getHashMenuInfo();
            //����Ĭ�ϼ�������
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
             *���ò˵����,��ֹ�˵����� 
             */
            function resetAllMenu(){
                var $menu = $('[data-first-menu-id]:visible > ul'),
                    ulWidth = $menu.width();
                if($menu.length>0) {
                    MainFrame.resetMenu(ulWidth,$menu)
                };
            }
            /**
             *����˵�����Ч�� 
             */
            function activeMenu(menuId){
                $('[data-first-menu-id]').hide();
                var $menu = $('#' + menuId),$secondMenu = $menu.closest('.app-nav').show();
                MainFrame.activeMenu($menu);
                //ƥ�䵽�����˵�
                if($secondMenu.length>0){
                    MainFrame.activeMenu($('#' + $secondMenu.data('first-menu-id')));
                }
                //����resize�¼����¼���iframe�߶Ⱥ͵����˵����
                $(window).resize();
            }
            /**
             *��Ⱦ�����˵� 
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