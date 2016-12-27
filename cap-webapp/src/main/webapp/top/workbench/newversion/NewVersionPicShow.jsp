<%@ include file="/top/component/common/Taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/workbench/base/Header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<link rel="stylesheet" href="<top:webRoot/>/top/workbench/newversion/css/jquery.fullPage.css">
<script type="text/javascript" src="<top:webRoot/>/top/workbench/newversion/js/jquery.fullPage.min.js"></script>
<script type="text/javascript" src="<top:webRoot/>/top/workbench/dwr/interface/PlatFormAction.js?v=<%=version%>"></script>
<title>full page</title>
</head>
<body>

	<div id="dowebok">

	</div>

	<script type="text/javascript">
	    
		require([], function() {
			
			var menuId = window.parent.getCurrentTab();
			PlatFormAction.getSysUpdatePic(menuId.id,function(result){
				var data = eval(result);
				if(data&&data.length>0){
					var html="";
					for(var i=0;i<data.length;i++){
						html = html+"<div align='center' class='section'>";
						html = html+"<img alt='' style='width:1024px;height:500px;' src='"+data[i]+"'>";
						html = html+"</div>";
					}
					$("#dowebok").prepend(html);
					$(function() {
						$('#dowebok').fullpage(
							{
								'navigation' : true,
							});
					});
				}else{
					
				}

			});

		})
	</script>


</body>
</html>