<%
/**********************************************************************
* ���ż���ȥ�����µ�¼
* 2012-11-16 ŷ����  �½�
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<% 
//session.invalidate(); 
%>
<html>
<head>
<title>���µ�¼</title>
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

		//ҳ����ط���
		function init(){
			countdown();
		}
		var count = 0;
		//ʹ��ײ�ҳ����ת����¼ҳ�棬����¼������Ҫ�رյ�ҳ��
	    function toReLogin(win){ 
	    	if(count++==6){
	    		//���ݹ�5�Σ�������ѭ��
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
				//���־ܾ������쳣��ʾû��opener������
				win.top.location.href = "${pageScope.cuiWebRoot}";
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
			<p class="message">���ã������˺��������ط���¼��</p>
			<p class="message">ϵͳ����<span id="time" style="color: red;font-size: 30px">5</span>����Զ���ת����¼����...</p>
		</div>
	</div>
	<script type="text/javascript">
	init();
	</script>
</body>
</html>
