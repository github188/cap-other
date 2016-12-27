<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>ͳ������-�й��Ϸ�����</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
        <style>
            .sidebar .side .side-menu .first-child img{
                width:22px;
                height:22px;
                margin:10px 13px 0px 3px;
            }
            .star-icon{
                width: 20px;
                height: 20px;
                display: inline-block;
                vertical-align: sub;
                *vertical-align: middle;
                background-repeat: no-repeat;
                background-position: center;
                background-image:url(${pageScope.cuiWebRoot}/top/workbench/reportcenter/img/star.png);    
                cursor: pointer;
                margin-right:5px;
            }
            .active > .star-icon{
                background-image:url(${pageScope.cuiWebRoot}/top/workbench/reportcenter/img/star-active.png);    
            }
        </style>
    </head>
    <body>
        <%@ include file="/top/workbench/base/MainNav.jsp" %>
        <div class="app-nav">
            <img src="${pageScope.cuiWebRoot}/top/workbench/reportcenter/img/app-report.png" class="app-logo">
            <span class="app-name">ͳ������</span>
        </div>
        <div class="workbench-container" id="report-center">
        </div>
        <!--Ӧ���б�-->
        <script type="text/template" id="app-tmpl">
            <a id="app-<@=app.id@>">
                <img src="<@= Workbench.formatUrl(app.logo) @>" class="pull-left"/>
                <span class="pull-left break-word"><@=app.name @></span>
                <i class="right-arrow pull-right"></i>
            </a>
        </script>
        
        <!--����˵�-->
        <script type="text/template" id="menu-tmpl">
            <@ var reportMenus = app.reportMenus; @>
            <div class="sub-menu" id="sub-menu-<@=app.id@>">
                <div class="sub-title"><@= jQuery.trim(app.name) @></div>
                <div class="menu-body">
                    <@if(reportMenus.length > 0){@>
                        <@ _.each(reportMenus,function(reportMenu,index){ @>
                        <@if(reportMenu.name && reportMenu.secondMenus && reportMenu.secondMenus.length > 0){ @>
                        <div class="menu-group">
                            <@= jQuery.trim(reportMenu.name)@>
                        </div>
                        <@}@>
                        <div class="clearfix">
                            <@ _.each(reportMenu.secondMenus || [reportMenu],function(menu,index2){@>
                                <@if(menu.name && menu.url){@>
                                <div class="menu-item <@=(menu.attentionFlag?'active':'')@>">
                                    <i class="star-icon <@=(menu.attentionFlag?'un-attention':'attention')@>" 
                                        data-menu-id="<@=menu.id@>" 
                                        data-app-id="<@=menu.appId@>"
                                        title="<@=(menu.attentionFlag?'ȡ����ע':'��ע')@>">
                                    </i>
                                    <a href="javascript:void(0)" data-url="<@= menu.url@>"><@= jQuery.trim(menu.name) @></a>
                                </div>
                                <@}@>
                            <@});@>
                        </div>
                        <@});@>
                    <@}else if(app.id == 'attention'){@>
                        <div style="position:absolute;top:50%;left:50%; margin-left:-175px;margin-top:-20px;text-align: center;">
                                                                            ����û�й�ע���õ�ͳ�Ʊ�������ർ������ӹ�ע��
                        </div>
                    <@}@>
                </div>
            </div>
        </script>
        
        <script type="text/javascript">
            require(['sidebar', 'underscore','workbench/reportcenter/js/report-center'], function(SideBar, _,ReportCenter) {
                var reportCenter = new ReportCenter();
                reportCenter.getInstalled(function(apps) {
                    var sideBar = new SideBar({
                        context : '#report-center',
                        title : 'ҵ��Ӧ��',
                        toggle : true,
                        model : apps,
                        iframe:true,
                        search:true,
                        primaryKey:'id',
                        iframeMinHeight:function(){return $(window).height() - 114;},
                        template : function(app) {
                            if (app.id!='attention'&&(!app.reportMenus || !app.reportMenus || app.reportMenus.length==0)) {
                                return '';
                            }
                            return _.template($('#app-tmpl').html(), {
                                app : app
                            });
                        },
                        subTemplate : function(app){
                            return _.template($('#menu-tmpl').html(), {
                                app : app
                            });
                        },
                        filter:function(app,searchValue){
                            return app.name.indexOf(searchValue)!=-1;
                        }
                    });
                    //��Ⱦ
                    sideBar.render();
                    
                    //Ĭ�ϼ��ص�һ��url
                    $('#report-center .sub-menu:first a:first').click();
                    if($('#report-center .sub-menu:first a:first').length == 0){
                        sideBar.main.load(Workbench.formatUrl('/top/workbench/reportcenter/EmptyAttention.jsp'));
                    }
                    
                    $('#report-center').on('click','.attention',function(e){//��ע
                        var menuId = $(e.target).data('menu-id');
                        var appId = $(e.target).data('app-id');
                        reportCenter.attention(menuId,function(){
                            cui.message('��ע�ɹ�','success');
                            reportCenter.reRender(appId);
                        });
                    }).on('click','.un-attention',function(e){//ȡ����ע
                        var menuId = $(e.target).data('menu-id');
                        var appId = $(e.target).data('app-id');
                        reportCenter.unAttention(menuId,function(){
                            cui.message('ȡ����ע�ɹ�','success');
                            reportCenter.reRender(appId);
                        });
                    });
                    //������Ⱦ�˵�
                    reportCenter.reRender = function (appId){
                        $('#sub-menu-' + appId).html($(sideBar.subTemplate($('#sub-menu-' + appId).parent('li').data('bar-data'))).html());
                        //ˢ�¹�ע�˵�
                        $('.sub-menu:first',sideBar.side).html($(sideBar.subTemplate(reportCenter.getAttentionMenu())).html());
                    };
                    //end reportCenter.getInstalled
                });
            });
            require(['cui']);
        </script>
    </body>
</html>