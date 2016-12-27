<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <%@ include file="/top/workbench/base/Header.jsp" %>
        <title>待办-统一工作台</title>
    </head>
    <body>
        <%@ include file="/top/workbench/base/MainNav.jsp" %>
        <div class="workbench-container" id="todo-body"></div>
        <script type="text/template" id="todo-tmpl">
            <a href="javascript:void(0)" data-url="${pageScope.cuiWebRoot}<@=todo.pageUrl@>">
            <img src="${pageScope.cuiWebRoot}<@= todo.iconUrl @>" style="float:left"/>
            <span class="min-hide" style="float:left"><@=todo.name @></span>
            <i class="right-arrow min-hide" style="float: right"></i>
            <span style="float: right" class="todo-count min-hide" data-count-url="${pageScope.cuiWebRoot}<@=todo.countUrl@>"></span>
            </a>
        </script>
        <script type="text/javascript">
            require(['jquery', 'sidebar', 'underscore'], function($, SideBar, _) {
                //App.getInstalled("$!userInfo.userId",function(installed){
                var todos =  [];
                todos.push({
                    iconUrl : '/top/workbench/test/app-defect.png?bgColor=#B52600',
                    name : '缺陷管理',
                    countUrl : '',
                    pageUrl : '/test'

                });
                todos.push({
                    iconUrl : '/top/workbench/test/app-defect.png?bgColor=#B52600',
                    name : '缺陷管理',
                    countUrl : '',
                    pageUrl : '/test'

                });
                todos.push({
                    iconUrl : '/top/workbench/test/app-defect.png?bgColor=#B52600',
                    name : '缺陷管理',
                    countUrl : '',
                    pageUrl : '/test'

                });
                var sideBar = new SideBar({
                    context : '#todo-body',
                    title : '请选择',
                    toggle : true,
                    model : todos,
                    template : function(todo) {
                        if (!todo.pageUrl) {
                            return "";
                        }
                        return _.template($('#todo-tmpl').html(), {
                            todo : todo
                        });
                    },
                    click : function(todo, e) {
                        this.main.html('<div class="clearfix">内容</div>');
                        //this.main.load(webPath + todo.pageUrl);
                    }
                });
                sideBar.render(); 
            });
            //});
        </script>
    </body>
</html>