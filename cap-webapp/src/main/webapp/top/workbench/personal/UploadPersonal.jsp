<%@ page language="java" contentType="text/html; charset=GBK"	pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
    String version = formatter.format(new Date());
%>
<html>
<head>
<title>用户设置</title>
<script type="text/javascript" src="js/swfobject.js?v=<%=version%>"></script>
<script type="text/javascript" src="js/fullAvatarEditor.js?v=<%=version%>"></script>
</head>
<body>
	<div style="width: 630px; margin: 0 auto;">
		<div>
			<p id="swfContainer">
			</p>
		</div>
	</div>
	<script type="text/javascript">
		window.setTimeout(function(){
            swfobject.addDomLoadEvent(function () {
                var swf = new fullAvatarEditor("swfContainer", {
					    id: 'swf',
					    tab_visible:false,
						upload_url:"${pageScope.cuiWebRoot}/top/workbench/workbenchServlet.ac",
						src_upload:0
					}, function (msg) {
						switch(msg.code)
						{
							case 1 : 
								//alert("页面成功加载了组件！");
								break;
							case 2 : 
								//alert("已成功加载默认指定的图片到编辑面板。");
								break;
							case 3 :
								if(msg.type == 0)
								{
									alert("摄像头已准备就绪且用户已允许使用。");
								}
								else if(msg.type == 1)
								{
									alert("摄像头已准备就绪但用户未允许使用！");
								}
								else
								{
									alert("摄像头被占用！");
								}
							break;
							case 5 : 
								if(msg.type == 0)
								{
									//if(msg.content.sourceUrl)
									//{
										//alert("原图已成功保存至服务器，url为：\n" +　msg.content.sourceUrl);
									//}
									//alert("头像已成功保存至服务器，url为：\n" + msg.content.avatarUrls.join("\n"));
									//alert("头像更新成功!");
									window.parent.location.reload();
								}
							break;
						}
					}
				);
            })
		}, 500);
        </script>
</body>
</html>
