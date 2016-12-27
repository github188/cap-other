<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
    <head>
        <title><c:if test="${requestScope.app!=null}">${requestScope.app.name}-</c:if>�й��Ϸ�����</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
    </head>
    <body>
        <%//����ҳü�����˵���ģʽ%>
        <c:set var="openMode" value="_blank"/>
        <%@ include file="/top/workbench/base/MainNav.jsp"%>
        <c:choose>
            <c:when test="${requestScope.app != null && requestScope.app.navType == 0}">
                <%//������������Ⱦ%>
                <%@ include file="/top/workbench/base/AppNavDropdown.jsp"%>
            </c:when>
            <c:when test="${requestScope.app != null && requestScope.app.navType == 3}">
                <%//����������չ�������˵���Ⱦ%>
                <%@ include file="/top/workbench/base/AppNavExpand.jsp"%>
            </c:when>
            <c:when test="${requestScope.app != null && requestScope.app.navType == 1}">
                <%//��ർ������Ⱦ%>
                <%@ include file="/top/workbench/base/AppNavLeft.jsp"%>
            </c:when>
            <c:otherwise>
                <%//�޲˵�������ʽ%>
                <%@ include file="/top/workbench/base/AppNavNoMenu.jsp"%>
            </c:otherwise>
        </c:choose>
        <script>
        	//openType��ֵ
        	var lastOpenType = 0;
        	//�жϵ���Ĳ˵����Ƿ��ж����˵���trueΪ�У�falseΪû��
        	var hasSecondMenu = false;
            <c:if test="${requestScope.app!=null}">
            //����logo·��,�ݴ���
            $('.app-logo').prop('src',Workbench.formatUrl('${requestScope.app.logo}'));
            require(['logAction'], function() {
                $(document).on('click','a[data-url]',function(){
                    var $this = $(this),
                        menuId = $this.data('menuId'),
                        menuUrl = $this.data('url'),
                        menuName = $this.html();
                    LogAction.funLogCollect(menuId,menuName,{errorHandler:function(){}});
                    
                    //�����ж�url���Ƿ��в���openType
                    var exp = /(openType=(\w+))/i;
                    var hash = menuUrl.match(exp);
                    var url = '';
                    //��ʼ��lastOpenType
                    lastOpenType = 0;
                    if(hash && !hasSecondMenu){
                    	
                    	//����lastOpenType��ֵΪ����url�����õ�openType��ֵ
                    	lastOpenType = hash[2];
                    	MainFrame.setCurOpenType('start');
                    	//����url
            			url = Workbench.formatUrl(menuUrl);
                    	//������ҳ��򿪣��������˵�
                    	MainFrame.setCurOpen(url,menuId);
                    	var menuInfo = MainFrame.getHashMenuInfo();
                    	
                    	//����˵�
                    	//���ò˵���
                    	$('.tab-menu').hide();
                        var $menu = $('#' + menuInfo.menuId),
                            $secondMenu = $menu.closest('.tab-menu').show();
                        	MainFrame.activeMenu($menu);
                        //ƥ�䵽�����˵�
                        if($secondMenu.length>0){
                            MainFrame.activeMenu($('#' + $secondMenu.data('first-menu-id')));
                        }
                        //����resize�¼����¼���iframe�߶Ⱥ͵����˵����
                        $(window).resize();
                    
                       //��¼��ǰ�˵�id
                        MainFrame.setCurMenuId(menuInfo.menuId);
                    }
                    else{
                    	//��¼��ǰ�˵�id
                    	MainFrame.setCurMenuId(menuId);
                    	hasSecondMenu = false;
                    }
                });
           
            });
            </c:if>
            //����cui���,�ڿ���ڲ�����cui�������ʱ����ͨ������top��cui����ʵ�ֵ�
            require(['cui'], function() {});
        </script>
    </body>
</html>