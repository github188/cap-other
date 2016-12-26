<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>

<html>
    <head>
        <%@ include file="/cap/bm/dev/main/header.jsp" %>
        <title>我的应用-中国南方电网</title>
        <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css"/>
        <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/app/css/app.css"/>
    </head>
    <body>
      <%--   <%@ include file="/top/workbench/base/MainNav.jsp" %> --%>
        <%@ include file="/cap/bm/dev/main/mainNav.jsp" %>
        <div class="app-nav" style="line-height: 44px;">
            <i class="myapp-icon place-left"></i>
            <span class="app-name">我的应用</span>
        </div>
        <div class="workbench-container box">
            <div class="myapp-container" id="myapp-container">
                <div class="app-header">
                    <input class="app-search empty" type="text" id="app-name" style="box-sizing:content-box" value="应用搜索" empty_text="应用搜索"/>
                                                    类别：<span id="category" uitype="PullDown" mode="Single" value_field="categoryId" label_field="categoryName" select="0" on_change="AppAction.filterApp" datasource=""></span>
                    
                </div>
                <div id="my-apps" ></div>
            </div>
            <div class="goto-top" title="回到顶部"> </div>
        </div>
        <script type="text/template" id="app-tmpl">
            <@ _.each(models,function(category){  @>
                <div class="app-category clearfix">
                    <div class="place-left"><@=category.categoryName@></div><hr/>
                </div>
                <div class="app-list">
                <@ _.each(category.apps,function(app,index){@>
                    <a data-url="/cap/bm/dev/main/applicationDetail.jsp?packageId=<@= app.id @>" target="_blank" data-mainframe="false" class="app" category="<@= app.categoryId @>">
                    <div class="app-name<@if(app.hasTodo){@> red-point<@}@>">
                        <@= app.name @>
                    </div>
                    <img src="${pageScope.cuiWebRoot}/top/workbench/querycenter/img/app-querycenter.png" class="app-logo">
                </a>
                <@ });@>
                </div>
            <@ });@>
        </script>
        <script type="text/javascript">
            var page = 'MyApp';
            require(['workbench/app/js/app'], function(AppAction) {
                
            });
            //初始化页面最小高度
            $(window).resize(function(){
                $('#myapp-container').setMinHeight($(window).height()-135);
            }).resize();
        </script>
    </body>
</html>