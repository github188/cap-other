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
<top:script src='/cap/dwr/interface/TestCaseFacade.js'></top:script>
<script type="text/javascript">
var funcFullCode = "${param.funcFullCode}";
var packageId = "${param.packageId}";
var testModel = "${param.testModel}";
var type = "${param.type}";
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
        resizeheight : getBodyHeight,
        //colstylerender : colstylerenderTestResult,
        //selectedrowclass : "selected_row1",
        primarykey : "modelId"
    });

});

//数据初始化
function initData(obj,query){
	var pageSize = query.pageSize;
	var pageNo = query.pageNo;
	var objTestCase ={type:type,pageNo:pageNo,pageSize:pageSize};
	dwr.TOPEngine.setAsync(false);
	TestCaseFacade.queryTestCaseList(funcFullCode,packageId,objTestCase,function(data){
		obj.setDatasource(data.list,data.size);
	});
	dwr.TOPEngine.setAsync(true);
	
}

//界面元数据编辑
function editMetaData(metadataId){
	var editMetaDataUrl;
	if(type=="FUNCTION"){
		editMetaDataUrl = "<%=request.getContextPath() %>/cap/bm/dev/page/designer/PageMain.jsp?packageId=" + packageId + "&testModel=" + testModel + "&globalReadState=true"+"&modelId="+metadataId;
    }else if(type=="API"){
    	editMetaDataUrl = "<%=request.getContextPath() %>/cap/bm/dev/entity/EntityMain.jsp?packageId=" + packageId+"&moduleCode="+funcFullCode + "&testModel="+testModel+"&globalReadState=true"+"&modelId="+metadataId;
    }else if(type=="SERVICE"){
    	editMetaDataUrl = "<%=request.getContextPath() %>/cap/bm/dev/serve/ServiceObjectMain.jsp?appEditFlag=true&packageId=" + packageId +"&packagePath="+funcFullCode+ "&editType=edit"+"&selectedObjectId="+metadataId;
    }
	window.open(editMetaDataUrl);
}

//测试用例编辑
function editTestCase(modelId){
	var editTestCaseUrl = "<%=request.getContextPath() %>/cap/bm/test/design/TestCaseMain.jsp?packageId=" + packageId +"&moduleCode="+funcFullCode+"&modelId="+modelId;
	window.open(editTestCaseUrl);
}

//页面元数据连接渲染
function renderMetaData(rd,index,col){
	var metadataId,metadataName;
	if(rd['metadata']&&rd['metadataName']){
		metadataId= rd['metadata'].split(':')[0];
		metadataName = rd['metadataName'];
	 }else{
		 metadataId = "";
		 metadataName = "自定义";
		 return metadataName;
	 }
	return "<a href='#' style='cursor:pointer' onclick='javascript:editMetaData(\""+metadataId+"\")'>" +metadataName+"</a>";
}

//测试用例连接渲染
function renderTestCase(rd,index,col){
	var testCaseName ="";
	if(rd['name']){
		 testCaseName = rd['name'].split('_')[0];	
	}
	
	return "<a href='#' onclick='javascript:editTestCase(\""+rd['modelId']+"\")'>" +testCaseName+"</a>";
}

function renderTestResult(rd,index,col){
	//如果没有测试用例，则不用展示测试结果
	if(!rd['name']){
		return "<div></div>";
	}
	var pass = rd['pass'];
	var result;
	if(pass==1){
		result = '<div style="width:100%;border:0px solid #ccc"><div style="height:15px;width:100%;background:#32cd32;"></div></div>';
	}else if(pass==0){
		result = '<div style="width:100%;border:0px solid #ccc"><div style="height:15px;width:100%;background:#ff0000;"></div></div>';	
	} else{
		result = '<div style="width:100%;border:0px solid #ccc"><div style="height:15px;width:100%;background:#b5b1b1;"></div></div>';
	}
	return result;
}

//测试结果渲染
function colstylerenderTestResult(rowData, bindName){
	if(bindName=="pass"){
		if(rowData['pass']){
	         return 'background:#32cd32;';
		}else{
			 return 'background:#ff0000;';
		}
   }
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
            <th width="12px"><input type="checkbox" checked=true /></th>
            <th renderStyle="text-align: center;" style="width:100px;" bindName="metadataName" spanrow="true" render="renderMetaData">元数据中文名</th>
            <th renderStyle="text-align: center;" style="width:100px" bindName="name" spanrow="false" render="renderTestCase">用例名称</th>
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