<%
  /**********************************************************************
	* CAP业务模型管理首页
	* 2015-11-03  姜子豪  新增
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
	<div uitype="Borderlayout" id="border" is_root="false" gap="5px">
		<div id="area" position="left" width="210"  url="" resizable="true" show_expand_icon="true" collapsable="true">
		</div>
		<div id="tablePage" position="center"  url="">
		</div>
	</div>
<script type="text/javascript">
	window.onload = function(){
		comtop.UI.scan();
		setLeftUrl("");
	}
	//设置左侧布局链接界面 
	function setLeftUrl(nodeId){ 
		var url = "<%=request.getContextPath() %>/cap/bm/biz/domain/jsp/domainList.jsp?selectNodeId="+nodeId;
		cui("#border").setContentURL("left",url);
	}
	
	//设置右侧Tab页 (新增)
	function setCenterUrlForInsert(parentId,editType){ 
		var url = "TabList.jsp?parentId="+parentId+"&editType="+editType;
		cui("#border").setContentURL("center",url);
	}
	
	//设置右侧Tab页 (单击业务域)
	function setCenterUrlForClik(selectDomainId,editType){ 
		var url = "TabList.jsp?selectDomainId="+selectDomainId+"&editType="+editType;
		cui("#border").setContentURL("center",url);
	}
	
	
</script>
</body>
</head>
</html>