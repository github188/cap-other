<%
    /**********************************************************************
	 * 测试建模用例展示页面
	 * 2016-10-10  zhangzunzhi 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta charset="UTF-8">
<title>测试建模主框架</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/test/css/comtop.ui.rowspangrid.css"></top:link>
<style type="text/css">
.cui-tab ul.cui-tab-nav li{
	padding:0 5px;
	margin-right:5px
}
.color-state {
	display: inline;
	color: #39c;
}

.repository-lang-stats-graph .language-color {
	display: table-cell;
	line-height: 27px; 
	text-indent: -9999px;
	text-align: center;
	font-size: 10px;
	text-indent: -9999px;
}
.selected_row1{
   background:#fff;
   color:#fff;
}
</style>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/test/js/comtop.ui.rowspangrid.min.js"></top:script>
<top:script src='/cap/dwr/engine.js'></top:script>
<top:script src='/cap/dwr/util.js'></top:script>
<top:script src='/cap/dwr/interface/TestResultAnalyseAction.js'></top:script>
<script type="text/javascript">
//测试结果ID
var testUuid = "${param.testUuid}";
jQuery(document).ready(function(){
    comtop.UI.scan();
    cui("#functionTable").rowSpanGrid({
        datasource : initData,
        gridheight: "400px",
        tablewidth : "2000px",
        pagesize_list : [10, 25, 50],
        pagesize : 20,
        resizewidth : getBodyWidth,
        custom_pagesize : true,
        pagination:false,
        resizeheight : getBodyHeight,
        selectrows:"no",
        //colstylerender : colstylerenderTestResult,
        //selectedrowclass : "selected_row1",
        primarykey : "modelId"
    });

});

//数据初始化
function initData(obj,query){
	dwr.TOPEngine.setAsync(false);
	TestResultAnalyseAction.queryTestResultByTestUuid(testUuid,function(data){
		obj.setDatasource(data,data.length);
	});
	dwr.TOPEngine.setAsync(true);
	
}

function renderTestResult(rd,index,col){
	var pass = rd['pass'];
	var result;
	if(pass){
		result = '<div style="width:100%;border:0px solid #ccc"><div style="height:15px;width:100%;background:#32cd32;"></div></div>';
	}else{
		result = '<div style="width:100%;border:0px solid #ccc"><div style="height:15px;width:100%;background:#ff0000;"></div></div>';	
	} 
	return result;
}

function getBodyWidth () {
    return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
}
function getBodyHeight () {
    return (document.documentElement.clientHeight || document.body.clientHeight) - 20;
}

</script>
</head>
<body style="background-color:#f5f5f5">
<div>
    <table id="functionTable">
       <thead>
        <tr> 
            <th renderStyle="text-align: center;" style="width:100px;" bindName="appName" spanrow="true">应用名称</th>
            <th renderStyle="text-align: center;" style="width:100px" bindName="metaName" spanrow="true">元数据中文名</th>
            <th renderStyle="text-align: center;" style="width:100px" bindName="funcName" spanrow="false">用例名称</th>
            <th renderStyle="text-align: center;" style="width:90px;" bindName="pass" render="renderTestResult">测试结果
            <div class="color-state">
           (<span class="cui-icon" style="color: #32cd32;font-size:6px;">&#xf0c8;</span>成功
			&nbsp;<span class="cui-icon" style="color: #ff0000;font-size:6px;">&#xf0c8;</span>失败
			&nbsp;<span class="cui-icon" style="color: #b5b1b1;font-size:6px;">&#xf0c8;</span>未执行)
			</div></th>
											
        </tr>
       </thead>
    </table>
</div>
</body>
</html>