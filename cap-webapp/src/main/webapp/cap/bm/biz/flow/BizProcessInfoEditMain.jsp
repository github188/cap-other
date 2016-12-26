<%
  /**********************************************************************
	* CAP业务流程编辑
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>业务模型管理</title>
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
</head>
<body>
	<div uitype="Borderlayout" id="border" is_root="false">
		<div id="nodeList" position="left" resizable="true" width="140px" url="">
		</div>
		<div id="processEdit" position="center" url="">
		</div>
	</div>
<script type="text/javascript">
	//业务域ID
	var domainId = "${param.domainId}";
	var BizProcessInfoId = "<c:out value='${param.BizProcessInfoId}'/>";
	var selItemsId = "<c:out value='${param.selItemsId}'/>";
	var url = "BizProcessInfoEdit.jsp?selItemsId="+selItemsId+"&BizProcessInfoId="+BizProcessInfoId+"&domainId="+domainId;
	window.onload = function(){
		comtop.UI.scan();
		setLeftUrl();
		setCenterUrl(url);
	}
	//设置左侧布局链接界面 
	function setLeftUrl(){ 
		var url = "BizProcessNodeList.jsp?BizProcessInfoId="+BizProcessInfoId+"&domainId="+domainId;
		cui("#border").setContentURL("left",url);
	}
	
	//设置中间布局链接页面
	function setCenterUrl(url){ 
		cui("#border").setContentURL("center",url);
	}
	
	function goback(){
		var vUrl = "BizProcessInfoMain.jsp?domainId="+domainId+"&selItemsId="+selItemsId;	
		window.location.href = vUrl;	
	}
	
	function dialogNodePage(url){
		var width =  screen.width-20;
		var height = screen.height-80;
		var parameter = 'height='+height+',width='+width+',top=0,left=0,toolbar=no,resizable=no,location=no,fullscreen=no';
		window.open(url,'editProcessNode',parameter);
	}
</script>
</body>
</head>
</html>