
<%
  /**********************************************************************
	* CIP元数据建模----查询建模From信息编辑页面
	* 2014-1-21 沈康 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>


<!doctype html>
<html>
<head>
<title>模块关系主界面</title>
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/eic/css/eic.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.eic.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/GraphAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocumentAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/bm/common/js/jquery.fileDownload.js'></script>
	<style>
		body{margin:0}
		.top_header_wrap {
		    padding: 5px 0;
		    height: 25px;
		}
		.thw_title{
			float:left;
			font:14px "宋体";
			margin-top:5px;
			margin-left:10px;
			font-weight:bold;
		    color: #000;
		}
		.thw_operate{
			float:right;
		}
	</style>
</head>
<body>
<div class="top_header_wrap" style="padding-top:3px">
	<div class="thw_title">
		<font id = "pageTittle" class="fontTitle">模块关系图</font> 
	</div>
	<div class="thw_operate">
		<span uitype="button" id="exportWord" label="导出文档"  menu="exportWord" ></span>
		<span uitype="button" id="exportImage" label="导出EA文件"  on_click="exoprtEaFile" ></span>
		<span uitype="button" id="exportImage" label="导出图片"  on_click="exportImage" ></span>
		<span uitype="button" id="returnToPage" label="返回"  on_click="returnToPage" ></span>
	</div>
</div>
<div id="moduleRelationTab" uitype="Tab" tabs="tabs" closeable="true"></div>
<script type="text/javascript">
var moduleId = "${param.moduleId}";//模块ID
var returnUrl = "${param.returnUrl}";//模块ID
var testModel = "${param.testModel}";//测试建模
<%--  var returnUrl = '<%=request.getContextPath() %>/cap/bm/dev/systemmodel/SystemModuleEdit.jsp?nodeId='
 		+ '${param.nodeId}' + '&parentNodeId=' + '${param.parentNodeId}'+ "&parentNodeName=" + '${param.parentNodeName}';
 	returnUrl = encodeURI(returnUrl); --%>
var moduleName = "根模块";
if(moduleId == "undefined" || moduleId == "null"){
	moduleId = "";
}
window.onload = function(){
	var url = "<%=request.getContextPath() %>/cap/bm/doc/info/MonitorAsynTaskList.jsp?userId="+globalCapEmployeeId+"&init=true"
	initOpenBottomImage(url);
	dwr.TOPEngine.setAsync(false);
	GraphAction.queryGraphModuleNameByModuleId(moduleId, function(data) {
		moduleName = data.moduleName;
	});
	dwr.TOPEngine.setAsync(true);
	//comtop.UI.scan();
	//setInterval("fastQuery()",30000);
}


var tabs =  [
	     	{
	     		id:'tab_' + moduleId, 
		     	title: moduleName,
		     	url: 'ModuleRelationGraph.jsp?moduleId=' + moduleId
	     	}
	];
	
	//导出文档 
	var exportWord = {
	    	datasource: [
	     	            {id:'exportHLD',label:'概要设计说明书'},
	     	            {id:'exportLLD',label:'详细设计说明书'},
	     	            {id:'exportDBD',label:'数据库设计说明书'}
	     	        ],
	     	        on_click:function(obj){
	     	        	if(obj.id=='exportHLD'){
	     	        		exportWordMain('HLD');
	     	        	}else if(obj.id=='exportLLD'){
	     	        		exportWordMain('LLD');
	     	        	}else if(obj.id=='exportDBD'){
	     	        		exportWordMain('DBD');
	    	        	}
	     	        }
	};
	
//DOM加载完毕后，执行scan扫描生成组件
comtop.UI.scan();

if(returnUrl){
	cui('#returnToPage').show();
}else{
	cui('#returnToPage').hide();
}
var height = (document.documentElement.clientHeight || document.body.clientHeight) - 40;
cui('#moduleRelationTab').resize(height);
/* var selectIndex;
cui('#moduleRelationTab').bind("switch",function(event, data){
	selectIndex = data.toTab;
	console.log(event);
	console.log(data);
});
cui('#moduleRelationTab').onClose(function(event,tab){
	var selectTitle = cui('#moduleRelationTab').getTab(selectIndex, 'title');
	console.log('selectTitle:');
	console.log(selectTitle);
	console.log(tab);
	if(tab.title == selectTitle){
		cui('#moduleRelationTab').prev();
	}
});
 */
function returnToPage(){
	window.open(returnUrl+"&testModel="+testModel, '_self');
}
 
function exportImage(){
	$(".cui-tab-content > iframe").eq(cui('#moduleRelationTab').index())[0].contentWindow.exportToImage();
}


function exoprtEaFile(){
	dwr.TOPEngine.setAsync(false);
	GraphAction.exoprtEaFile(moduleId,function(result){
		var code = result.code;
		if("Success" === code){
			cui.success(result.message);
		}else if("Error" === code){
			cui.warn(result.message);
		}else{
			cui.alert(result.message);
		}
	});
	dwr.TOPEngine.setAsync(true);
}
//导出文档
function exportWord(type){
	dwr.TOPEngine.setAsync(false);
	DocumentAction.exportDocumentOutDoc(moduleId,type,function(result){
		var code = result.code;
		if("Success" === code){
			cui.success(result.message);
		}else if("Error" === code){
			cui.warn(result.message);
		}else{
			cui.alert(result.message);
		}
	});
	dwr.TOPEngine.setAsync(true);
}

$(window).resize(function(){//开启监控，第一次初始化时，不会进入此方法
	var clientHeight = (document.documentElement.clientHeight || document.body.clientHeight);
    jQuery("body").css("height", clientHeight);
    jQuery(".cui-tab-content").css("height", clientHeight - $(".top_header_wrap").height() - 60);
});
</script>	
</body>
</html>