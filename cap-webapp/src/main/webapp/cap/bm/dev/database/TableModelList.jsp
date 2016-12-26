<%
/**********************************************************************
* 元数据建模：表列表
* 2015-12-17 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>表模型列表页</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/TableFacade.js'></top:script>
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
			<font id="pageTittle" class="fontTitle">表模型列表信息</font> 
		</div>
	</div>
	<div class="top_float_right">
		<!-- <span uitype="button" label="导入" id="button_add" on_click="importEntity"></span>  -->
		<span uitype="button" label="删除" id="button_del" on_click="delTable"></span>
	</div>
</div>
 <table uitype="Grid" id="TableGrid" primarykey="modelId" sorttype="DESC" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
 	resizewidth="resizeWidth" resizeheight="resizeHeight">
 <thead>
 	<tr>
 	    <th style="width: 30px" renderStyle="text-align: center;"><input type="checkbox"></th>
		<th bindName="engName" style="width:30%;" renderStyle="text-align: left;" render="correspondTableRenderer">表名称</th>
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
		TableFacade.queryTableList(packagePath,function(data){
			tableObj.setDatasource(data, data.length);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//删除表
	function delTable(){
		var selectTableIds = cui("#TableGrid").getSelectedPrimaryKey();
		if(selectTableIds == null || selectTableIds.length == 0){
			cui.alert("请选择要删除的表。");
			return;
		}
		cui.confirm("确定要删除这"+selectTableIds.length+"个表吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				TableFacade.delTables(selectTableIds,function(data){
					if(data){
						cui.message("删除成功。","success");
					}else{
						cui.message("删除失败。","error");
					}
		 			cui("#TableGrid").loadData();
		 		});
		 		dwr.TOPEngine.setAsync(true);
			}
		});
	}
	
	// 查看表模型
	function viewTableModel(modelId) {
		dwr.TOPEngine.setAsync(false);
		TableFacade.getDBType(function(data) {
			if (data == "mysql") {
				var url = "TableModelEdit_mysql.jsp?packageId=${param.packageId}&modelId=" + modelId + "&packagePath=" + packagePath + "&openType=listToMain&funcCode=" + packageModuleCode;
			} else {
				var url = "TableModelEdit.jsp?packageId=${param.packageId}&modelId=" + modelId + "&packagePath=" + packagePath + "&openType=listToMain&funcCode=" + packageModuleCode;
			}
			//window.open(url,"tableWin");
			window.location.href = url;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//grid列渲染
	function correspondTableRenderer(rd, index, col) {
		return "<a href='javascript:;' onclick='viewTableModel(\"" +rd.modelId+ "\");'>" +rd.engName + "</a>";
	}

	var importEntityWin = null;
	// 导入实体
	function importEntity() {
		var importEntityWin = "EntityImport.jsp?packageId=" + packageId ;
		try {
			importEntityWin.close();
		}catch(e){}
		importEntityWin = window.open(importEntityWin,"importEntityWin");
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