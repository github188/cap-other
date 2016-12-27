 <%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
 <%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
 <%@ include file="/top/component/common/Taglibs.jsp" %> 
<html>
<head>
<%//360�����ָ��webkit�ں˴�%>
<meta name="renderer" content="webkit">
<%//�ر�ie����ģʽ,ʹ����߰汾�ĵ�ģʽ��Ⱦҳ��%>
<meta http-equiv="x-ua-compatible" content="IE=edge" >
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
<title>��������</title>

	<script type="text/javascript" defer>
	 var not_resize=true;
		function mouseOver() {
			var demo = document.getElementById("demo");
			demo.style.overflowY = "auto";
			var demo2 = document.getElementById("demo2");
			demo2.style.display = "none";
		}
		function mouseOut() {
			var demo = document.getElementById("demo");
			demo.style.overflowY = "hidden";
			var demo2 = document.getElementById("demo2");
			demo2.style.display = "";
		}

		function getFramHeight(){
			var iframe = document.getElementById("rollFrame1");
			try{
				var bHeight = iframe.contentWindow.document.body.scrollHeight;
				var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
				var height = Math.max(bHeight, dHeight);
				iframe.height =  height;
				var demo1 = document.getElementById("demo1");
				var demo2 = document.getElementById("demo2");
				//����div�ĸ߶ȣ���ȻIE9�ºͻ���»�����ص�������
				demo1.style.height=height+20;
				demo2.style.height=height+20;
			}catch (ex){}
		}

		function getFramHeight2(){
			var iframe = document.getElementById("rollFrame2");
			try{
				var bHeight = iframe.contentWindow.document.body.scrollHeight;
				var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
				var height = Math.max(bHeight, dHeight);
				iframe.height =  height;
			}catch (ex){}
		}

		window.onload=function(){
			//��̬����demo�ĸ߶� ��ֹ��ҳչʾ��ʱ�� �������й�����
			var demo = document.getElementById("demo");
			var demoHeight = document.body.clientHeight;
			if(demoHeight>10){
			demo.style.height=demoHeight-10;
			}
			window.setInterval("getFramHeight()", 200);
			window.setInterval("getFramHeight2()", 200);
		}
		
	</script>
</head>

<body leftmargin="0" topmargin="0" cellpadding="0" cellpadding="0" cellspacing="0" onunload="clearInterval(MyMar);">
	<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td height="100%" align="center" valign="top" onmouseover="mouseOver();" onmouseout="mouseOut();">
				<div id=demo style='overflow:hidden;width:100%;height:200px;background-color:white ;'>
					<div id=demo1 style='width:100%; '>
					<iframe id="rollFrame1" src="RollBulletinDeskView.jsp" scrolling="no" width="100%"
                                                onload="getFramHeight()"
												frameborder="NO" noresize style="border-width:0px;border-style olid;border-color:#aeaeae;"></iframe>
					</div>
					<div id=demo2 style='width:100%; '>
					<iframe id="rollFrame2" src="RollBulletinDeskView.jsp" scrolling="no" width="100%"
                                                 onload="getFramHeight2()"
												frameborder="NO" noresize style="border-width:0px;border-style olid;border-color:#aeaeae;"></iframe>
					</div>
				</div>
				<script  type="text/javascript" defer>
				   
					var speed=30; //ֵԽ���ٶ�Խ��
					var MyMar;
					function Marquee(){
						try {
							var demo = document.getElementById("demo");
							var demo1 = document.getElementById("demo1");
							var demo2 = document.getElementById("demo2");
							if (!demo || !demo1 || !demo2) return;
							if(demo2.offsetTop-demo.scrollTop<=0) //��������demo1��demo2����ʱ
								demo.scrollTop-=demo1.offsetHeight; //demo�������
							else{
								demo.scrollTop++;
							}
						}catch(e){
						}
					}
					if(!MyMar) MyMar=setInterval(Marquee,speed)//���ö�ʱ��
					//�������ʱ�����ʱ���ﵽ����ֹͣ��Ŀ��
					demo.onmouseover=function() {clearInterval(MyMar)}
					//����ƿ�ʱ���趨ʱ��
					demo.onmouseout=function(){
						clearInterval(MyMar);//���������ʱ��,��֮ǰû�гɹ�����������ٶȻ���
						MyMar=setInterval(Marquee,speed);
					}
				</script>
			</td>
		</tr>
	</table>
	<div  style='overflow:hidden;height:30px;text-align:right;background-color:white ;'>
	<p class="pop"><a href="javascript:void(0)" data-url="${pageScope.cuiWebRoot}/top/sys/tools/bulletin/BulletinList.jsp?isShowHeader=1" data-mainframe="false"">����鿴���й���</a></p>	
	</div>
</body>
</html>
