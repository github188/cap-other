<%
/**********************************************************************
* �����û�ͳ��-�б�
* 2012-09-07 ������  �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
<head>
<title>���µ�¼</title>
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
		String strMessage = "��δ��¼ϵͳ����ҳ���ϵĿ���ʱ�䳬ʱ�������µ�¼ϵͳ��";
	%>
	<script language="javascript">
		var url = "<c:out value='${param.url}'/>";
		var mainFrameName = "<c:out value='${param.mainFrameName}'/>";
		var closeWin = [];
		var topUrl = "";

		//ҳ����ط���
		function init(){
			countdown();
		}

		//��ȡָ����ת��URL
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
		//ʹ��ײ�ҳ����ת����¼ҳ�棬����¼������Ҫ�رյ�ҳ��
	    function toReLogin(win){
	    	if(count++==6){
	    		//���ݹ�5�Σ�������ѭ��
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
				//���־ܾ������쳣��ʾû��opener������
				win.top.location =  topUrl +   "<top:webRoot/>/?url=" + getRedirectUrl();
			}
	    }

		//�ر����иùرյ�ҳ��
	    function closeWins(){
		    for(var i=closeWin.length-1;i>=0;--i){
		    	closeWin[i].opener = null;
		    	closeWin[i].open("","_self");
		    	closeWin[i].close();
		    }
	    }

	    //����ʱ
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
			<p class="message">ϵͳ����<span id="time" style="color: red;font-size: 30px">5</span>����Զ���ת����¼����...</p>
			<p class="message"><span uiType="Button" id="resetLoginButton" label="���µ�¼"  on_click="resetLogin" ></span></p>
		</div>
	</div>
<script type="text/javascript">
		comtop.UI.scan();
	    init();
</script>
</body>
</html>