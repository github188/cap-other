<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <%@ include file="/top/workbench/base/Header.jsp" %>
        <title>���¼�¼-�й��Ϸ�����</title>
        <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/app/css/app.css"/>
        <style>
            .myapp-container{
                padding-bottom:36px;
            }
        </style>
    </head>
    <body>
        <%@ include file="/top/workbench/base/MainNav.jsp" %>
        <div class="app-nav">
            <i class="record-icon place-left"></i>
            <span class="app-name">���¼�¼</span>
        </div>
        <div class="workbench-container box">
            <div class="myapp-container" id="myapp-container">
                <div class="app-header">
                    <input class="app-search empty" type="text" id="app-name" value="Ӧ������" empty_text="Ӧ������"/>
                    ���<span id="category" uitype="PullDown" mode="Single" value_field="categoryId" label_field="categoryName" select="0" on_change="AppAction.filterApp" datasource=""></span>
                </div>
                <div id="my-apps" class="app-store"></div>
            </div>
            <div class="app-footer">
                <a class="app-back pull-right" href="${pageScope.cuiWebRoot}/top/workbench/app/MyApp.jsp">����</a>
            </div>
            <div class="goto-top" title="�ص�����" style="margin-bottom:46px"> </div>
        </div>
        <script type="text/template" id="app-tmpl">
        <@ _.each(models,function(app){ @>
            <div class="app" data-appid="<@= app.id @>" data-category="<@=app.category@>">
                <div class="app-inner">
                    <div class="app-logo">
                        <img src="${pageScope.cuiWebRoot}<@= app.logo @>" >
                    </div>
                    <div class="app-info">
                        <div class="app-name">
                            <@= app.name @>
                        </div>
                        <div class="app-status clearfix">
                            <div class="pull-left">
                            <@if(app.maxUpdateTime){@>
                                                                             �������
                            <@}else{@>
                                                                             ���޸���
                            <@}@>
                            <@= app.maxUpdateTime @>
                            </div>
                            <@ if(app.updateRecordUrl){ @>
                                <a class="pull-right show-record" data-app-name="<@=app.name@>" data-record-url="<@=app.updateRecordUrl@>">�鿴���¼�¼</a>
                            <@ }else{@>
                                <span class="pull-right">�޸��¼�¼</span>
                            <@}@>    
                        </div>
                        <div class="app-description">
                            <@= app.description@>
                        </div>
                    </div>
                </div>
            </div>
        <@ }); @>
        </script>
<script type="text/javascript">
    var page = 'Store';
    var updateRecordDialog = null;
    require(['workbench/app/js/app'], function() {
        //ie10������jsʵ�ֶ���Ч��,������ͨ��cssʵ��
        var ieVersion = navigator.userAgent.toLowerCase().match(/msie ([\d.]+)/);
        if(ieVersion && ieVersion[1] < 10){
            var appOver = null;
            $('#myapp-container').on('mouseenter', '.app', function(e) {
                e.preventDefault();
                e.stopPropagation();
                if (appOver) {
                    window.clearTimeout(appOver);
                }
                var appInner = $(this).children('.app-inner');
                appOver = window.setTimeout(function() {
                    appInner.clearQueue();
                    appInner.animate({
                        top : '-120'
                    },function(){
                       appInner.find('a').show(); 
                    });
                }, 200);
            }).on('mouseleave', '.app', function(e) {
                e.preventDefault();
                e.stopPropagation();
                var appInner = $(this).children('.app-inner');
                if (appOver) {
                    window.clearTimeout(appOver);
                }
                appInner.animate({
                    top : '0'
                },function(){
                   appInner.find('a').hide(); 
                });
            });
        }
        updateRecordDialog = cui.dialog({
            modal: true,
            title: '���¼�¼',
            width:680,
            height:400,
            src:'blanlk',
            page_scroll:false,
            buttons:[{
                name:'�ر�',                         
                handler:function(){
                    updateRecordDialog.hide();
                }    
            }]
        });
    });
    //�򿪵�����
    $('#myapp-container').on('click', '.show-record', function(e) {
        var recordUrl = $(this).data('recordUrl');
        var appName = $(this).data('appName');
        appName = '<span style="color:#096ae2">' + appName + '</span>';
        updateRecordDialog.setTitle(appName + '-���¼�¼');
        updateRecordDialog.show(Workbench.formatUrl(recordUrl));
    });
    //��ʼ��ҳ����С�߶�
    $(window).resize(function(){
        $('#myapp-container').setMinHeight($(window).height()-161);
    }).resize();
</script>
</body>
</html>