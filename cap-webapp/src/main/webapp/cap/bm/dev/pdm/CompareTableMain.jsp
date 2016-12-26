<%
  /**********************************************************************
	* 数据库比较主页面
	* 2016-11-1 许畅 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>


<!doctype html>
<html>
<head>
<title>数据表结构差异</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/dev/page/uilibrary/css/base.css"/>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>

	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/TableOperateAction.js"></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	
	<div id="compareTableMain" uitype="tab" tabs="tabs" fill_height="true" ></div>

	<script type="text/javascript">
		var packageId = "${param.packageId}";//包ID
		var packagePath = "${param.packagePath}";//包路径
		var modelId = "${param.modelId}";//modelId
		var from = "${param.from}";//来源
		var datastorage = {};
		
		var tabs = [{
			title: "列",
			url: "CompareColumn.jsp?packageId=" + packageId + "&from=" + from,
		}, {
			title: "索引",
			url: "CompareIndex.jsp?packageId=" + packageId + "&from=" + from,
		}, {
			title: "预览",
			url: "ComparePreview.jsp?packageId=" + packageId + "&from=" + from,
		}];
		
		//初始化    加载  	
		window.onload = function() {
			comtop.UI.scan();
			initDatas();
		}

        /**
         * 初始化数据
         * 
         * [initDatas description]
         * @return {[type]} [description]
         */
        function initDatas() {
        	if (modelId && packagePath) {
        		initTableMetadata();
        	} else {
        		initPdmDatas();
        	}
        }

        /**
         * 初始化PDM导出数据
         * 
         * [initPdmDatas description]
         * @return {[type]} [description]
         */
        function initPdmDatas() {
        	var openerDatas = window.top.selectedDatas;
        	dwr.TOPEngine.setAsync(false);
        	TableOperateAction.compareTable(openerDatas, packageId, {
        		callback: function(map) {
        			datastorage = map;
        		},
        		errorHandler: function(message, exception) {}
        	});
        	dwr.TOPEngine.setAsync(true);
        }

        /**
         * 初始化Table元数据数据
         * 
         * [initTableMetadata description]
         * @return {[type]} [description]
         */
        function initTableMetadata() {
        	dwr.TOPEngine.setAsync(false);
        	TableOperateAction.compare4Table([modelId], packagePath, {
        		callback: function(map) {
        			datastorage = map;
        		},
        		errorHandler: function(message, exception) {}
        	});
        	dwr.TOPEngine.setAsync(true);
        }
		
	</script>
</body>
</html>