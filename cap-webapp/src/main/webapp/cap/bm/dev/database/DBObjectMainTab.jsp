<%
  /**********************************************************************
	* CIP数据库建模----数据库对象主Tab页面
	* 2015-12-17 zhangzunzhi 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>


<!doctype html>
<html>
<head>
<title>数据库对象主Tab页面</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	
	<div id="entityManTab" uitype="tab" tabs="tabs" fill_height="true" ></div>

	<script type="text/javascript">
		var packageId = "${param.packageId}";//包ID
		var packagePath = "${param.packagePath}";//包路径
		var packageModuleCode = "${param.packageModuleCode}";//父模块编码
		
		var tabs = [ {
	        title: "表",
	        url: "TableModelList.jsp?packageId=" + packageId+"&packagePath="+packagePath+"&packageModuleCode="+packageModuleCode,
	    },{
	        title: "视图",
	        url: "ViewModelList.jsp?packageId=" + packageId+"&packagePath="+packagePath+"&packageModuleCode="+packageModuleCode,
	    }, {
	        title: "存储过程",
	        url: "ProcedureModelList.jsp?packageId=" + packageId+"&packagePath="+packagePath+"&packageModuleCode="+packageModuleCode,
	    }, {
	        title: "函数",
	        url: "FunctionModelList.jsp?packageId=" + packageId+"&packagePath="+packagePath+"&packageModuleCode="+packageModuleCode,
	    }];
		
		
		//初始化    加载  	
	   	window.onload = function(){	   		
	   		comtop.UI.scan();
	   	}
		

		
		
	</script>
</body>
</html>