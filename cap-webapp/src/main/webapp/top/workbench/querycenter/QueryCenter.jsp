<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>��ѯ����-�й��Ϸ�����</title>
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
            <span class="app-name">��ѯ����</span>
            <a id="set-btn">����</a>
        </div>
        <div class="workbench-container" id="query-center"> 
            <div id="empty-box" class="box">
               <div style="position:absolute;top:50%;left:50%;">
                    <div style="position:relative;left:-50%;" class="no-data">���޲�ѯ</div>
               </div>
            </div>
        </div>
        <div class="load-tip">Ŭ�������У����Ժ�</div>
        <!--Ӧ���б�-->
        <script type="text/template" id="app-tmpl">
            <a id="app-<@=app.id@>">
                <img src="<@= Workbench.formatUrl(app.logo) @>" class="pull-left"/>
                <span class="pull-left break-word"><@=app.name @></span>
                <i class="right-arrow pull-right"></i>
            </a>
        </script>
        <!--��ѯ�˵�-->
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
        	//��ȡĬ�ϲ�ѯӦ��
        	var queryAppId = '<c:out value="${param.queryAppId}"/>'; 
			//��ȡĬ�ϲ�ѯ�˵�
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
                        title : 'ҵ��Ӧ��',
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
                              //�жϵ�ǰ�����Ӧ���Ƿ�������Ӧ��IDһ��
                                if(app.id == queryAppId){
                                	//һ�£���ʼ�ж�menus���ĸ��˵���ID�뵱ǰ��IDһ����
                                	var i = 0;
                                	//��ȡĬ�ϲ�ѯ�˵�
                    				if(queryMenuId){
	                                	for(x in app.queryMenus){
	    						                if(app.queryMenus[x].id == queryMenuId){
	    						                	//��a��ǩ��data-url��������
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
                    //��Ⱦ
                    sideBar.render();
                });
                //��ʼ��ҳ����С�߶�
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
                        title: '��ѯ��������',
                        width:600,
                        height:400
                    }).show();
                });
            });
        </script>
    </body>
</html>