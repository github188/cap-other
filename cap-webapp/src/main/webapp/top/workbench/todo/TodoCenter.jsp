<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<%@ include file="/top/workbench/base/Header.jsp"%>
<title>待办中心</title>
<style>
   #empty-box{
       background-color:#fff;
   }
</style>
</head>
<body>
	<%@ include file="/top/workbench/base/MainNav.jsp"%>
	<div class="app-nav">
        <img src="${pageScope.cuiWebRoot}/top/workbench/todo/img/app-todo.png" class="app-logo">
        <span class="app-name">待办中心</span>
    </div>
    <div class="workbench-container" >
        <div id="todo-body"></div>
    </div>
    <div class="load-tip">努力加载中，请稍候</div>
	<script type="text/template" id="todo-tmpl1">
            <a href="javascript:void(0)">
            	<span class="show-span todo-break-word" title="<@=todo.todoName @>">
									<@=todo.todoName @>
							</span>
            	<i class="right-arrow min-hide" style="float: right"></i>
            	<span style="float: right; width:30px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" class="todo-count min-hide" title="<@=todo.todoCount @>"><@=todo.todoCount @>&nbsp;</span>
            </a>
    </script>
    	<script type="text/template" id="todo-tmpl2">
            <a href="javascript:void(0)">
            	<span class="show-span todo-break-word" title="<@=todo.todoName @>">
									<@=todo.todoName @>
							</span>
            	<span class="todo-count min-hide" style="position:absolute;right: 0.3in;"><@=todo.todoCount @></span>
            	<i class="right-arrow min-hide" style="position:absolute;right: 0.15in;"></i>
            </a>
    </script>
	<script type="text/javascript">
		function refreshTodoCount(processId){
			DesktopTodoAction.queryTodoCountByProcessId(processId,function(data) {
				var count  = data;
				$("#"+processId+" span[class='todo-count min-hide']").attr("title",count);
				$("#"+processId+" span[class='todo-count min-hide']").html(count+"&nbsp;");
				window.parent.queryTodoCount();
			});
		}
		require(['sidebar', 'underscore','workbench/dwr/interface/DesktopTodoAction'], function(SideBar, _) {
			
			DesktopTodoAction.queryTodoList(function(data) {
				//获取默认选中流程
				var todoId = '<%=request.getParameter("todoId")%>';
				var todos = data.list;
				if(!todos || todos.length ==0){
					var html = '<div id="empty-box" class="box">'
					           +'<div style="position:absolute;top:50%;left:50%;">'
							   + '<div style="position:relative;left:-50%;" class="no-data">暂无数据</div>'
							   +'</div></div>';
					$("#todo-body").html(html);
					$('.load-tip').hide();
				}else{
					var sideBar = new SideBar({
						context : '#todo-body',
						title : '业务应用',
						toggle : true,
						model : todos,
						search:true,
						iframe : true,
						primaryKey:'todoId',
						iframeMinHeight:function(){return $(window).height() - 112;},
						isDefaultData : function(data, index){
							if(data.todoId==todoId){
								return true;
							}
							if (index == 0) {
								return true;
							}
							return false;
						},
						template : function(todo) {
							var browser =getBrowserInfo();
							if(browser){
								return _.template($('#todo-tmpl2').html(), {
									todo : todo
								});
							}else{
								return _.template($('#todo-tmpl1').html(), {
									todo : todo
								});
							}
						},
						click : function(todo, e) {
							this.main.load(todo.todoUrl);
							return false;
						},
						filter:function(todo,searchValue){
						    return todo.todoName.indexOf(searchValue)!=-1;
						}
					});
					$('.load-tip').hide();
					sideBar.render(); 
				}
				//初始化页面最小高度
			$(window).resize(function(){
				$('#empty-box').setMinHeight($(window).height()-115);
			}).resize();
				});
			});
		function getBrowserInfo()
		{
			var agent = navigator.userAgent.toLowerCase() ;
			if(agent.indexOf("msie 7") > 0)
			{
			   return true ;
			}
			return false ;
		}
	</script>
</body>
</html>