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
<title>视图信息页面</title>
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/view.png">
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/ViewFacade.js'></top:script>
</head>
<style type="text/css">

</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">数据库视图信息</div>
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
				<td class="td_label">视图名：</td>
				<td>
					<span uitype="input" id="englishName" name="englishName" databind="viewData.engName" width="280" readonly="true">
				</td>
				<td class="td_label">中文名：</td>
				<td>
					<span uitype="input" id="chineseName" name="chineseName" databind="viewData.chName" width="280" readonly="true">
				</td>
			</tr>
			<tr>	
				<td class="td_label" valign="top" style="padding-top: 5px;">描述：</td>
				<td colspan="3">
					<span uitype="textarea" id="description" maxlength="-1" databind="viewData.description" 
			      		width="80%" name="description" readonly="true"></span>
				</td>
			</tr>
			<tr ><td class="divTitle">字段信息</td></tr>
		</table>
		<table uitype="Grid" id="TableColumnGrid" primarykey="engName" selectrows="no" sorttype="DESC" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
				 	resizewidth="resizeWidth" gridheight="auto">
		 	<thead>
		 	<tr>
				<th renderStyle="text-align: center" bindName="1" style="width:3%;">序号</th>
				<th bindName="engName" style="width:10%;" renderStyle="text-align: left;" render="renderField">字段名</th>
				<th bindName="chName" style="width:10%;" renderStyle="text-align: left;" >中文名称</th>
				<th bindName="dataType" style="width:10%;" renderStyle="text-align: center">数据类型</th>
				<th bindName="length" style="width:10%;" renderStyle="text-align: center" >长度</th>
				<th bindName="precision" style="width:10%;" renderStyle="text-align: center" >精度</th>
				<th bindName="description" style="width:10%;" renderStyle="text-align: center" >描述</th>
			</tr>
			</thead>
		</table>
	</div>


	<script type="text/javascript">
	var openType = "${param.openType}";//listToMain
	var packageId = "${param.packageId}";//包ID
	var modelId = "${param.modelId}";//视图ID
	var packagePath = "${param.packagePath}";//包路径
	var inited = false;
    var viewData = {};
    
   	window.onload = function(){
   		init();
   		showReturnOrClose();
   	}
   	
	function init() {
		dwr.TOPEngine.setAsync(false);
		ViewFacade.queryViewById(modelId,function(data){
			viewData = data;
		});
		dwr.TOPEngine.setAsync(true);
		inited = true;
		comtop.UI.scan();
		
	}
	//grid数据源
	function initData(tableObj,query){
		if(inited) {
			tableObj.setDatasource(viewData.columns,viewData.columns.length);
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
	
	//grid列渲染
	function renderField(data,field){
		if(data.primaryKey) {
			return data.correspondField + "&nbsp;<img src='../entity/images/zhujian.jpg'/>";
		}
		return data.correspondField;
	}
	function back() {
		window.location.href = "ViewModelList.jsp?packageId=${param.packageId}"+"&packagePath="+packagePath;
	}
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	
</script>
</body>
</html>