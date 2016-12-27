<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title><c:if test="${requestScope.app!=null}">${requestScope.app.name}-</c:if>中国南方电网</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
    </head>
    <body>
        <%//设置页眉导航菜单打开模式%>
        <c:set var="openMode" value="_blank"/>
        <%@ include file="/top/workbench/base/MainNav.jsp"%>
        <c:choose>
            <c:when test="${requestScope.app != null && requestScope.app.navType == 0}">
                <%//顶部导航栏渲染%>
                <%@ include file="/top/workbench/base/AppNavDropdown.jsp"%>
            </c:when>
            <c:when test="${requestScope.app != null && requestScope.app.navType == 3}">
                <%//顶部导航栏展开二级菜单渲染%>
                <%@ include file="/top/workbench/base/AppNavExpand.jsp"%>
            </c:when>
            <c:when test="${requestScope.app != null && requestScope.app.navType == 1}">
                <%//左侧导航栏渲染%>
                <%@ include file="/top/workbench/base/AppNavLeft.jsp"%>
            </c:when>
            <c:otherwise>
                <%//无菜单导航样式%>
                <%@ include file="/top/workbench/base/AppNavNoMenu.jsp"%>
            </c:otherwise>
        </c:choose>
        <script>
        	//openType的值
        	var lastOpenType = 0;
        	//判断点击的菜单下是否还有二级菜单，true为有，false为没有
        	var hasSecondMenu = false;
            <c:if test="${requestScope.app!=null}">
            //处理logo路径,容错处理
            $('.app-logo').prop('src',Workbench.formatUrl('${requestScope.app.logo}'));
            require(['logAction'], function() {
                $(document).on('click','a[data-url]',function(){
                    var $this = $(this),
                        menuId = $this.data('menuId'),
                        menuUrl = $this.data('url'),
                        menuName = $this.html();
                    LogAction.funLogCollect(menuId,menuName,{errorHandler:function(){}});
                    
                    //正则判断url中是否有参数openType
                    var exp = /(openType=(\w+))/i;
                    var hash = menuUrl.match(exp);
                    var url = '';
                    //初始化lastOpenType
                    lastOpenType = 0;
                    if(hash && !hasSecondMenu){
                    	
                    	//设置lastOpenType的值为配置url中配置的openType的值
                    	lastOpenType = hash[2];
                    	MainFrame.setCurOpenType('start');
                    	//处理url
            			url = Workbench.formatUrl(menuUrl);
                    	//设置新页面打开，并弹出菜单
                    	MainFrame.setCurOpen(url,menuId);
                    	var menuInfo = MainFrame.getHashMenuInfo();
                    	
                    	//激活菜单
                    	//设置菜单栏
                    	$('.tab-menu').hide();
                        var $menu = $('#' + menuInfo.menuId),
                            $secondMenu = $menu.closest('.tab-menu').show();
                        	MainFrame.activeMenu($menu);
                        //匹配到二级菜单
                        if($secondMenu.length>0){
                            MainFrame.activeMenu($('#' + $secondMenu.data('first-menu-id')));
                        }
                        //触发resize事件重新计算iframe高度和调整菜单宽度
                        $(window).resize();
                    
                       //记录当前菜单id
                        MainFrame.setCurMenuId(menuInfo.menuId);
                    }
                    else{
                    	//记录当前菜单id
                    	MainFrame.setCurMenuId(menuId);
                    	hasSecondMenu = false;
                    }
                });
           
            });
            </c:if>
            //加载cui组件,在框架内部调用cui弹出层的时候是通过调用top的cui对象实现的
            require(['cui'], function() {});
        </script>
    </body>
</html>