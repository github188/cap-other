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
<title>�û�����</title>
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
								//alert("ҳ��ɹ������������");
								break;
							case 2 : 
								//alert("�ѳɹ�����Ĭ��ָ����ͼƬ���༭��塣");
								break;
							case 3 :
								if(msg.type == 0)
								{
									alert("����ͷ��׼���������û�������ʹ�á�");
								}
								else if(msg.type == 1)
								{
									alert("����ͷ��׼���������û�δ����ʹ�ã�");
								}
								else
								{
									alert("����ͷ��ռ�ã�");
								}
							break;
							case 5 : 
								if(msg.type == 0)
								{
									//if(msg.content.sourceUrl)
									//{
										//alert("ԭͼ�ѳɹ���������������urlΪ��\n" +��msg.content.sourceUrl);
									//}
									//alert("ͷ���ѳɹ���������������urlΪ��\n" + msg.content.avatarUrls.join("\n"));
									//alert("ͷ����³ɹ�!");
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
