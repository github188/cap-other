<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>查询中心-中国南方电网</title>
        <%@ include file="/top/workbench/base/Header.jsp" %>
        <style>
            #empty-box{
               background-color:#fff;
               display: none;
           }
           #set-btn{
               font-size:14px;
               color:#000;
               margin-right:20px;
               line-height: 45px;
               float:right;
               padding-left:20px;
               background:url(${pageScope.cuiWebRoot}/top/workbench/querycenter/img/set.png) left center no-repeat;
           }
        </style>
    </head>
    <body>
        <%@ include file="/top/workbench/base/MainNav.jsp" %>
        <div class="app-nav">
            <img src="${pageScope.cuiWebRoot}/top/workbench/querycenter/img/app-querycenter.png" class="app-logo">
            <span class="app-name">查询中心</span>
            <a id="set-btn">设置</a>
        </div>
        <div class="workbench-container" id="query-center"> 
            <div id="empty-box" class="box">
               <div style="position:absolute;top:50%;left:50%;">
                    <div style="position:relative;left:-50%;" class="no-data">暂无查询</div>
               </div>
            </div>
        </div>
        <div class="load-tip">努力加载中，请稍候</div>
        <!--应用列表-->
        <script type="text/template" id="app-tmpl">
            <a id="app-<@=app.id@>">
                <img src="<@= Workbench.formatUrl(app.logo) @>" class="pull-left"/>
                <span class="pull-left break-word"><@=app.name @></span>
                <i class="right-arrow pull-right"></i>
            </a>
        </script>
        <!--查询菜单-->
        <script type="text/template" id="menu-tmpl">
            <div class="app-nav box" id="second-menu">
                <ul class="menu">
                    <@_.each(app.queryMenus,function(menu){@>
                    <li>
                        <a href="###" data-url="<@=menu.url@>" target="mainFrame"><@=menu.name@></a>
                    </li>
                    <@})@>
                </ul>
            </div>
        </script>
        <script type="text/javascript">
        	//获取默认查询应用
        	var queryAppId = '<c:out value="${param.queryAppId}"/>'; 
			//获取默认查询菜单
        	var queryMenuId = '<c:out value="${param.queryMenuId}"/>'; 
        	
            require(['sidebar', 'underscore', 'workbench/querycenter/js/QueryCenter'], function(SideBar, _) {
                QueryCenter.queryUserQueryMenu(function(apps) {
                    if (apps.length == 0) {
                        $('#empty-box').show();
                        $(".load-tip").hide();
                        return;
                    }
                    var sideBar = new SideBar({
                        context : '#query-center',
                        title : '业务应用',
                        toggle : true,
                        model : apps,
                        iframe : true,
                        frameName:'mainFrame',
                        search : true,
                        primaryKey : 'id',
                        iframeMinHeight:function(){
                            return $(window).height() - 112 - ($('#second-menu').length > 0?56:0);
                        },
                        isDefaultData : function(data, index){
							if(data.id==queryAppId){
								return true;
							}
							if (index == 0) {
								return true;
							}
							return false;
						},
                        template : function(app) {
                            if (!app.queryMenus || app.queryMenus.length == 0) {
                                return "";
                            }
                            return _.template($('#app-tmpl').html(), {
                                app : app
                            });
                        },
                        click : function(app, e) {
                            $('#second-menu').remove();
                            if (app.queryMenus && app.queryMenus.length > 1) {
                                var menuHtml = _.template($('#menu-tmpl').html(), {
                                    app : app
                                });
                                sideBar.main.prepend(menuHtml);
                              //判断当前点击的应用是否跟传入的应用ID一致
                                if(app.id == queryAppId){
                                	//一致，则开始判断menus中哪个菜单的ID与当前的ID一样。
                                	var i = 0;
                                	//获取默认查询菜单
                    				if(queryMenuId){
	                                	for(x in app.queryMenus){
	    						                if(app.queryMenus[x].id == queryMenuId){
	    						                	//把a标签的data-url参数换掉
	    						                	$('#second-menu a:eq('+i+')').click();
	    						                	break;
	    						                }
	    						                i++;
	                                	}
                    				}else{
		                                $('#second-menu a:first').click();
                    				}
                                }else{
	                                $('#second-menu a:first').click();
                                }
                            } else if (app.queryMenus.length == 1) {
                                sideBar.main.load(app.queryMenus[0].url);
                            }
                        },
                        filter : function(app, searchValue) {
                            return app.name.indexOf(searchValue) != -1;
                        }
                    });
                    $('.load-tip').hide();
                    //渲染
                    sideBar.render();
                });
                //初始化页面最小高度
                $(window).resize(function(){
                    $('#empty-box').setMinHeight($(window).height()-115);
                }).resize();
            });
            require(['cui'],function(){
                $('#set-btn').click(function(){
                    setDialog = cui.dialog({
                        src:webPath + '/top/workbench/querycenter/QuerySet.jsp',
                        refresh:false,
                        modal: true,
                        canClose:false,
                        title: '查询中心设置',
                        width:600,
                        height:400
                    }).show();
                });
            });
        </script>
    </body>
</html>