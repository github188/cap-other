<%
  /**********************************************************************
	* CIP元数据建模----实体信息编辑
	* 2015-12-17 zhangzunzhi 新建
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>

<!doctype html>
<html>
<head>
<title>表模型信息页面</title>
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/table.png">
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>

	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/TableFacade.js'></top:script>
</head>
<style type="text/css">

</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">数据库表信息</div>
		<div class="thw_operate">
			<span id="return" uitype="button" label="返回" on_click="back"></span> 
			<span id="close" uitype="Button" label="关闭" on_click="closeWindow"></span>
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr ><td class="divTitle">基本信息</td></tr>
			<tr>
				<td class="td_label">表名：</td>
				<td>
					<span uitype="input" id="engName" name="engName" databind="tableData.engName" width="280" readonly="true">
				</td>
				<td class="td_label">中文名：</td>
				<td>
					<span uitype="input" id="chName" name="chName" databind="tableData.chName" width="280" readonly="true">
				</td>
			</tr>
			<tr>	
				<td class="td_label" valign="top" style="padding-top: 5px;">描述：</td>
				<td colspan="3">
					<span uitype="textarea" id="description" maxlength="-1" databind="tableData.description" 
			      		width="80%" name="description" readonly="true"></span>
				</td>
			</tr>
			<tr ><td class="divTitle">字段信息</td></tr>
		</table>
		<table uitype="Grid" id="TableColumnGrid" primarykey="id" selectrows="no" sorttype="DESC" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
				 	resizewidth="resizeWidth" gridheight="auto">
		 	<thead>
		 	<tr>
				<th renderStyle="text-align: center" bindName="1" style="width:3%;">序号</th>
				<th bindName="engName" style="width:15%;" renderStyle="text-align: left;" render="renderField">字段名</th>
				<th bindName="chName" style="width:10%;" renderStyle="text-align: left;" >中文名称</th>
				<th bindName="dataType" style="width:10%;" renderStyle="text-align: center">数据类型</th>
				<th bindName="length" style="width:10%;" renderStyle="text-align: center" >长度</th>
				<th bindName="precision" style="width:10%;" renderStyle="text-align: center" >精度</th>
				<th bindName="canBeNull" style="width:10%;" renderStyle="text-align: center" render="renderAllowNull">是否允许为空</th>
				<!--  <th bindName="defaultValue" style="width:10%;" renderStyle="text-align: left;" >默认值</th>-->
				<th bindName="description" style="width:15%;" renderStyle="text-align: center" >描述</th>
			</tr>
			</thead>
		</table>
	</div>


	<script type="text/javascript">
	var openType = "${param.openType}";//listToMain
	var packageId = "${param.packageId}";//包ID
	var modelId = "${param.modelId}";//表ID
	var packagePath = "${param.packagePath}";//包路径
	var inited = false;
	
    var tableData = {};
    
   	window.onload = function(){
   		init();
   		showReturnOrClose();
   	}
   	
	function init() {
		dwr.TOPEngine.setAsync(false);
		TableFacade.queryTableById(modelId,function(data){
			tableData = data;
		});
		dwr.TOPEngine.setAsync(true);
		inited = true;
		comtop.UI.scan();
		
	}
	//grid数据源
	function initData(tableObj,query){
		if(inited) {
			tableObj.setDatasource(tableData.columns,tableData.columns.length);
		}
	}
	
	//grid列渲染
	function renderField(data,field){
		if(data.isPrimaryKEY) {
			return data.engName + "&nbsp;<img src='../entity/images/zhujian.jpg'/>";
		}
		return data.engName;
	}
	//grid列渲染
	function renderAllowNull(data,field){
		if(data.canBeNull) {
			return "是";
		}else{
			return "否";
		}
	}
	
	   //显示关闭或者是返回按钮
	   function showReturnOrClose(){
		     if(openType=="listToMain"){
		    	 cui("#close").hide();
		     }else{
		    	 cui("#return").hide();
		     }
	   }
	
	function closeWindow(){
		window.close();
	}
	
	function back() {
		window.location.href = "TableModelList.jsp?packageId=${param.packageId}"+"&packagePath="+packagePath;
	}
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	
</script>
</body>
</html>