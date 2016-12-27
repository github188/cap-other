 <%
/**********************************************************************
* 4A用户同步确认操作界面
* 2013-04-22 李小宇  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK"/>
    <title>4A用户同步确认</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">    
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">

	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FouraSyncConfirmAction.js"></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/LoginAction.js"></script>	
   
   <style type="text/css">
   		 .div_body{
			MARGIN-RIGHT: auto;
			MARGIN-LEFT: auto;
			height:120px;
			vertical-align:middle;
			width:400px;
			background-color:White;
			margin-top:150px;
			border:1px solid
		}
		
		.div_content{
			margin-top:10px;
			margin-left:10px;
			width:380px; 
			height:60px;
			background-color:#FFFFFF
		}
		
		.div_btn{
			MARGIN-RIGHT: auto;
			MARGIN-LEFT: auto;
			margin-top:10px;
			background-color:#FFFFFF;
			text-align:center
		}
   
   </style>
   
   
</head>
<body >	
	<div class="div_body">
	
		<div id="tip_content" class="div_content">
		</div>

		<div class="div_btn" id="confirm_btn" >
			<span uitype="Button" label="返 回" on_click="backHistoryPage"></span>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<span uitype="Button" id="confirmButton" label="确 认" on_click="syncConfirm"></span>
		</div>	
		<div class="div_btn" id="reset_btn" style="display:none">
			<span uitype="Button" label="重新登录" on_click="resetLogin"></span>
		</div>
	
	</div>

	<script type="text/javascript">
	
		var userId = globalUserId;
		var messageId = "<c:out value='${param.messageId}'/>"
	
		//页面入口
		window.onload = function() {
			comtop.UI.scan();
			initDivContent();
		}
		
		var message = "";
		var dataCount = 0;
		function initDivContent(){
			var contents = "" ;
			dwr.TOPEngine.setAsync(false);
			FouraSyncConfirmAction.getTipInfo(userId,function(data){
				contents = data;
			});
			dwr.TOPEngine.setAsync(true);
			
			dwr.TOPEngine.setAsync(false);
			FouraSyncConfirmAction.queryTodoCount(userId,function(data){
				dataCount = data;
				if(data > 0){
			//		cui("#confirmButton").disable(true);
					contents += "<br/>";
					contents += "您还有"+data+"条待办未处理，请先处理完待办事宜再确认岗位变更操作。";
				}		
			});
			dwr.TOPEngine.setAsync(true);
			document.getElementById('tip_content').innerHTML=contents;
		}
		
		//确认同步
		function syncConfirm(){
			if(dataCount > 0){
				var message = "您还有"+dataCount+"条待办未处理,确认是否要进行岗位变更操作？"
				cui.confirm(message, {
					buttons: [{
						name: '确认',
						handler: function(){
							var flag = false;
							dwr.TOPEngine.setAsync(false);
							FouraSyncConfirmAction.syncConfirm(userId, messageId, function(){		
								$('#tip_content').html('岗位变更成功，系统将在<span id="time" style="color: red;font-size: 30px">5</span>秒后自动跳转到登录界面...。');
								$('#confirm_btn').hide();
								$('#reset_btn').show(); 
								init();
								exit();
							});
							dwr.TOPEngine.setAsync(true); 
	   			  		}
					},{
						name: '取消',
						handler: function(){
						}
					}]
				});
			}else{
				var flag = false;
				dwr.TOPEngine.setAsync(false);
				FouraSyncConfirmAction.syncConfirm(userId, messageId, function(){		
					$('#tip_content').html('岗位变更成功，系统将在<span id="time" style="color: red;font-size: 30px">5</span>秒后自动跳转到登录界面...。');
					$('#confirm_btn').hide();
					$('#reset_btn').show(); 
					init();
					exit();
				});
				dwr.TOPEngine.setAsync(true); 
			}
			
		}
		
		//退出系统
	    function exit() {
	        LoginAfterAction.exit();
	    }
		
		//返回
		function backHistoryPage(){
			window.top.close();
		}
		
		var url = "/top/workbench/message/MessageCenter.jsp";
		var mainFrameName = "mainFrame;fram_work_Main";
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
	    		win.top.location =  topUrl +   "<top:webRoot/>?url=" + getRedirectUrl();
	    		return;
	    	}
			try{
			    if(isInArray(win.top.name,mainFrameName) || win.top.opener == null){
			    	win.top.location =  topUrl +   "<top:webRoot/>?url=" + getRedirectUrl();
			    }else{
			    	closeWin.push(win.top);
			    	toReLogin(win.top.opener);
			    }
			}catch(e){
				//出现拒绝访问异常表示没有opener父窗口
				win.top.location =  topUrl +   "<top:webRoot/>?url=" + getRedirectUrl();
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
</body>
</html>


            