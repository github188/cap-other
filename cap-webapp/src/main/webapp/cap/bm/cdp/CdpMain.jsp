<%@ page language="java" contentType="text/html; charset=GBK"  pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<html>
    <head>
        <title>�Զ��������뷢����ҳ</title>
        <%@ include file="/top/workbench/base/Header.jsp"%>
        <style>
         	.myapp-container{
         		padding : 0px 10px 10px 10px;
         	}
        </style>
    </head>
    <body>
        <%@ include file="/top/workbench/base/MainNav.jsp" %>
        <div class="app-nav">
            <img src="${pageScope.cuiWebRoot}/top/workbench/reportcenter/img/app-report.png" class="app-logo">
            <span class="app-name">�Զ��������뷢��</span>
        </div>
        <div class="myapp-container" id="myapp-container">
			<iframe id="mainIframe" name="mainIframe" marginwidth="0" scrolling="no" src="${pageScope.cuiWebRoot}/cap/bm/cdp/CdpIndex.jsp" 
				marginheight="0" frameborder="0" src="" style="display:block;width:100%;height:100%"></iframe>
		</div>
		<script type="text/javascript">

			//����cui,����window.top.comtop������ɾ��
			 require(['cui'], function() {});
			 
			//��ʼ��ҳ����С�߶�
			$(window).resize(function(){
				jQuery("#myapp-container").css("height",$(window).height() - 115);
			}).resize();
			
		</script>
    </body>
</html>