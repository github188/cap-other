<%
/**********************************************************************
* 数据库建模：数据库视图列表
* 2015-12-17 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>视图模型列表页</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/ViewFacade.js'></top:script>
	<style type="text/css">
		.validImg {
			cursor: pointer;
		    background: url(images/valid.png)  no-repeat;
		    width:16px;
		    height: 16px;
		    text-align:center;
		    margin:auto;
			_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/valid.png'); /* IE6 */
			_ background-image: none; /* IE6 */
		}
		
		.invalidImg {
			 cursor: pointer;
			 background: url(images/invalid.png)  no-repeat;
			 width:16px;
		     height:16px;
		     text-align:center;
		     margin:auto;
			_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/invalid.png'); /* IE6 */
			_ background-image: none; /* IE6 */
		}
		
		#showAllCheckBox {
			vertical-align: middle;
		}
		
		th{
		    font-weight: bold;
		    font-size:14px;
		}
	</style>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left">
		<div class="thw_title" style="margin-left:11px;margin-top:0px;">
			<font id="pageTittle" class="fontTitle">视图模型列表信息</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="导入" id="button_add" on_click="importEntity"></span>
		<span uitype="button" label="删除" id="button_del" on_click="delView"></span>
	</div>
</div>
 <table uitype="Grid" id="ViewGrid" primarykey="modelId" sorttype="DESC" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
 	resizewidth="resizeWidth" resizeheight="resizeHeight">
 	<thead>
 	<tr>
 	    <th style="width: 30px" renderStyle="text-align: center;"><input type="checkbox"></th>
		<th bindName="engName" style="width:30%;" renderStyle="text-align: left;"  render="correspondTableRenderer">视图名称</th>
		<th bindName="chName" style="width:30%;" renderStyle="text-align: left;" >中文名称</th>
		<th bindName="description" style="width:35%;" renderStyle="text-align: center" >描述</th>
	</tr>
	</thead>
</table>

<script language="javascript"> 
var packageId = "${param.packageId}";//包ID
var packagePath = "${param.packagePath}";//包路径
var packageModuleCode = "${param.packageModuleCode}";//父模块编码
	
	window.onload = function(){
		comtop.UI.scan();
	}
	
	//grid数据源
	function initData(tableObj,query){		
		dwr.TOPEngine.setAsync(false);
		ViewFacade.queryViewList(packagePath,function(data){
			tableObj.setDatasource(data, data.length);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//删除视图
	function delView(){
		var selectViewIds = cui("#ViewGrid").getSelectedPrimaryKey();
		if(selectViewIds == null || selectViewIds.length == 0){
			cui.alert("请选择要删除的表。");
			return;
		}
		cui.confirm("确定要删除这"+selectViewIds.length+"个视图吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				ViewFacade.delVeiws(selectViewIds,function(data){
					if(data){
						cui.message("删除成功。","success");
					}else{
						cui.message("删除失败。","error");
					}
		 			cui("#ViewGrid").loadData();
		 		});
		 		dwr.TOPEngine.setAsync(true);
			}
		});
	}
	
	
	
	// 查看表模型
	function viewTableModel(modelId) {
		var url =  "ViewModelView.jsp?packageId=${param.packageId}&modelId=" + modelId +"&packagePath="+packagePath+"&openType=listToMain";
		window.location.href = url;
	}
	
	//grid列渲染
	function correspondTableRenderer(rd, index, col) {
		return "<a href='javascript:;' onclick='viewTableModel(\"" +rd.modelId+ "\");'>" +rd.engName + "</a>";
	}
	
	var importViewWin = null;
	// 导入实体
	function importEntity() {
		var viewImport = "ViewImport.jsp?packageId=" + packageId +"&packagePath="+packagePath;
		try {
			importViewWin.close();
		}catch(e){}
		importViewWin = window.open(viewImport,"importViewWin");
	}
	
	function importCallback(){
		cui("#ViewGrid").loadData();
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 60;
	}
 </script>
</body>
</html>