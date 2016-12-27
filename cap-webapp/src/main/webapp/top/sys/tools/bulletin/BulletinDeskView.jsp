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
<%//360浏览器指定webkit内核打开%>
<meta name="renderer" content="webkit">
<%//关闭ie兼容模式,使用最高版本文档模式渲染页面%>
<meta http-equiv="x-ua-compatible" content="IE=edge" >
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/workbench/base/css/base.css?v=<%=version%>"/>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/workbench/base/js/base.js?v=<%=version%>"></script>
<title>滚动公告</title>

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
				//设置div的高度，不然IE9下和火狐下会出现重叠的问题
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
			//动态设置demo的高度 防止首页展示的时候 最外面有滚动条
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
				   
					var speed=30; //值越大速度越慢
					var MyMar;
					function Marquee(){
						try {
							var demo = document.getElementById("demo");
							var demo1 = document.getElementById("demo1");
							var demo2 = document.getElementById("demo2");
							if (!demo || !demo1 || !demo2) return;
							if(demo2.offsetTop-demo.scrollTop<=0) //当滚动至demo1与demo2交界时
								demo.scrollTop-=demo1.offsetHeight; //demo跳到最顶端
							else{
								demo.scrollTop++;
							}
						}catch(e){
						}
					}
					if(!MyMar) MyMar=setInterval(Marquee,speed)//设置定时器
					//鼠标移上时清除定时器达到滚动停止的目的
					demo.onmouseover=function() {clearInterval(MyMar)}
					//鼠标移开时重设定时器
					demo.onmouseout=function(){
						clearInterval(MyMar);//重新清除定时器,若之前没有成功清除，滚动速度会变快
						MyMar=setInterval(Marquee,speed);
					}
				</script>
			</td>
		</tr>
	</table>
	<div  style='overflow:hidden;height:30px;text-align:right;background-color:white ;'>
	<p class="pop"><a href="javascript:void(0)" data-url="${pageScope.cuiWebRoot}/top/sys/tools/bulletin/BulletinList.jsp?isShowHeader=1" data-mainframe="false"">点击查看所有公告</a></p>	
	</div>
</body>
</html>
