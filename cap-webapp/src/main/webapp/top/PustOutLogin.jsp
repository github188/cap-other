<%
/**********************************************************************
* 被排挤出去后，重新登录
* 2012-11-16 欧阳辉  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<% 
//session.invalidate(); 
%>
<html>
<head>
<title>重新登录</title>
	<style type="text/css">
			.div{
				background: url("${pageScope.cuiWebRoot}/top/sys/images/warning.png") no-repeat;
				margin-top: 100px;
				padding-top: 120px;
				width: 850px; 
				height: 300px;
			}
			
			.message{
				width: 500px; 
				margin-left: 200px; 
			}
	</style>
	<script language="javascript">
		var url = "${param.url}";
		var closeWin = [];

		//页面加载方法
		function init(){
			countdown();
		}
		var count = 0;
		//使最底层页面跳转到登录页面，并记录所有需要关闭的页面
	    function toReLogin(win){ 
	    	if(count++==6){
	    		//最多递归5次，避免死循环
	    		win.top.location.href = "${pageScope.cuiWebRoot}";
	    		return;
	    	}
			try{
			    if(win.top.name == 'mainFrame'||win.top.opener==null){
			    	win.top.location.href = "${pageScope.cuiWebRoot}";
			    }else{
			    	closeWin.push(win.top);
			    	toReLogin(win.top.opener);
			    }
			}catch(e){
				//出现拒绝访问异常表示没有opener父窗口
				win.top.location.href = "${pageScope.cuiWebRoot}";
			}
	    }

		//关闭所有该关闭的页面
	    function closeWins(){
		    for(var i=closeWin.length-1;i>=0;--i){
		    	closeWin[i].opener = null;
		    	closeWin[i].open("","_self");
		    	closeWin[i].close();
		    }
	    }

	    //倒计时
	    function countdown(){
		    var time = 5;
		    timerId = setInterval(function(){
			    if(time==1){
			    	window.clearInterval(timerId);
					toReLogin(self);
				    closeWins();
			    }else{
				    document.getElementById('time').innerHTML = --time;
				   }
				},1000);
	    }
	</script>
</head>
<body>
	<div align="center">
		<div class="div">
			<p class="message">您好，您的账号在其他地方登录。</p>
			<p class="message">系统将在<span id="time" style="color: red;font-size: 30px">5</span>秒后自动跳转到登录界面...</p>
		</div>
	</div>
	<script type="text/javascript">
	init();
	</script>
</body>
</html>
