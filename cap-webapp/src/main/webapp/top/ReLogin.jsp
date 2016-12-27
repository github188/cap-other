<%
/**********************************************************************
* 在线用户统计-列表
* 2012-09-07 孙晓帆  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
<head>
<title>重新登录</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
    <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
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
	<%
		String strMessage = "您未登录系统或在页面上的空闲时间超时，请重新登录系统。";
	%>
	<script language="javascript">
		var url = "<c:out value='${param.url}'/>";
		var mainFrameName = "<c:out value='${param.mainFrameName}'/>";
		var closeWin = [];
		var topUrl = "";

		//页面加载方法
		function init(){
			countdown();
		}

		//获取指定跳转的URL
		function getRedirectUrl(){
			var url=location.search;
			var index = url.indexOf('url=');
            if(index < 0){
              url = "";
            }else{
              url = url.slice(index+4,url.length);
            }		
			return url;
		}

		var count = 0;
		//使最底层页面跳转到登录页面，并记录所有需要关闭的页面
	    function toReLogin(win){
	    	if(count++==6){
	    		//最多递归5次，避免死循环
	    		win.top.location =  topUrl +   "<top:webRoot/>/?url=" + getRedirectUrl();
	    		return;
	    	}
	    	
			try{
			    if(isInArray(win.top.name,mainFrameName) || win.top.opener == null){
			    	win.top.location =  topUrl +   "<top:webRoot/>/?url=" + getRedirectUrl();
			    }else{
			    	closeWin.push(win.top);
			    	toReLogin(win.top.opener);
			    }
			}catch(e){
				//出现拒绝访问异常表示没有opener父窗口
				win.top.location =  topUrl +   "<top:webRoot/>/?url=" + getRedirectUrl();
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
			    	obtainParam(self);
					toReLogin(self);
				    closeWins();
			    }else{
				    document.getElementById('time').innerHTML = --time;
			    }
          	},1000);
	    }
        
	    function obtainParam(win){
	    	if(null == mainFrameName || typeof mainFrameName == 'undefined'){
	    		mainFrameName = [];
		    }else if(typeof mainFrameName == 'string'){
		    	mainFrameName = mainFrameName.split(';');
			}
	    	var topLocaUrl = win.top.location.href;
	    	var index = topLocaUrl.indexOf('<top:webRoot/>');
	    	topUrl = topLocaUrl.substring(0,index);
	    }

	    function isInArray(value,arrayValue){
           for(var i = arrayValue.length - 1; i >= 0; i--){
                if(arrayValue[i] == value){
                   return true;
                }
           }
           return false;
		}

		function resetLogin(){
			obtainParam(self);
			toReLogin(self);
		    closeWins();
		}
	</script>
</head>
<body>
	<div align="center">
		<div class="div">
			<p class="message"><%=strMessage%></p>
			<p class="message">系统将在<span id="time" style="color: red;font-size: 30px">5</span>秒后自动跳转到登录界面...</p>
			<p class="message"><span uiType="Button" id="resetLoginButton" label="重新登录"  on_click="resetLogin" ></span></p>
		</div>
	</div>
<script type="text/javascript">
		comtop.UI.scan();
	    init();
</script>
</body>
</html>