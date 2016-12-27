<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<%@ include file="/top/workbench/base/Header.jsp"%>
<title>帐号设置</title>
</head>
<body>
	<%@ include file="/top/workbench/base/MainNav.jsp"%>
	<div class="app-nav">
        <img src="${pageScope.cuiWebRoot}/top/workbench/personal/img/personal.png" class="app-logo">
        <span class="app-name">帐号设置</span>
    </div>
    <div class="workbench-container" >
        <div id="body_id"></div>
    </div>
	<script type="text/template" id="template_id">
            <a href="javascript:void(0)" data-url="${pageScope.cuiWebRoot}<@=todo.todoUrl@>">
            	<span class="min-hide" style="float:left">
					<@=todo.todoName @>
				</span>
            	<i class="right-arrow min-hide" style="float: right"></i>
            </a>
    </script>
	<script type="text/javascript">
		require([ 'sidebar', 'underscore'], function(SideBar, _) {
			//获取默认选中流程
			var todos = [{todoName:"个人设置",todoUrl:"/top/workbench/personal/PersonalSet.jsp"},
			             {todoName:"通知订阅",todoUrl:"/top/workbench/personal/NoticeSubscribe.jsp"}];

			var sideBar = new SideBar({
				context : '#body_id',
				toggle : false,
                   model : todos,
                   iframeMinHeight:function(){return $(window).height() - 160;},
				template : function(todo) {
					return _.template($('#template_id').html(), {
						todo : todo
					});
				},
				click : function(todo, e) {
					this.main.load(webPath + todo.todoUrl);
					return false;
				},
				filter:function(todo,searchValue){
				    return todo.todoName.indexOf(searchValue)!=-1;
				}
			});
			sideBar.render(); 
		});
	</script>
</body>
</html>