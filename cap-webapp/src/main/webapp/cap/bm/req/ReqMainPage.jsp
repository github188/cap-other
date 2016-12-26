<%
  /**********************************************************************
	* CAP需求管理首页
	* 2015-12-02 李小强  新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>需求管理首页</title>
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
</head>
<body> 
	<div uitype="Borderlayout" id="border" is_root="true">
		<div id="area" position="left" width="180px" url="" collapsable="true" show_expand_icon="true">
		</div>
		<div id=border position="center" url="" >
		</div>
	</div>
<script type="text/javascript">
	window.onload = function(){
		comtop.UI.scan();
		setLeftUrl("");
	}
	//设置左侧布局链接界面 
	function setLeftUrl(nodeId){ 
		var url = "<%=request.getContextPath() %>/cap/bm/req/func/ReqDomainCombTree.jsp?selectNodeId="+nodeId;
		cui("#border").setContentURL("left",url);
	}
	
	//设置右侧Tab页 (新增)
	function setCenterUrlForInsert(parentId,editType){ 
		var url = "TabList.jsp?parentId="+parentId+"&editType="+editType;
		cui("#border").setContentURL("center",url);
	}
	
	//设置右侧Tab页 (单击业务域)
	function setCenterUrlForClik(nodeId,nodeType,editType,modelPackage){ 
		var url ="";
		if(nodeType=='1'){//业务域
			url = "<%=request.getContextPath() %>/cap/bm/req/func/ReqDomainPage.jsp?selectDomainId="+nodeId;
		}
		if(nodeType=='2'){ //功能项
			url = "<%=request.getContextPath() %>/cap/bm/req/func/ReqFunctionItemList.jsp?ReqFunctionItemId="+nodeId;
		}
		 if(nodeType=='3'){ //功能子项
			url = "<%=request.getContextPath() %>/cap/bm/req/subfunc/ReqFunctionSubitemMain.jsp?selectDomainId="+nodeId+"&editType=read"+"&modelPackage="+modelPackage;
		}
		cui("#border").setContentURL("center",url);
	}
	
</script>
</body>
</head>
</html>