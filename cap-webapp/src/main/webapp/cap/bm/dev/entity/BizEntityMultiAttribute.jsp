<%
/**********************************************************************
* 从业务实体选择多属性
* 2015-1-4 李小芬  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>实体属性选择页</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>                        
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/EntityFacade.js'></top:script>
	
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
		.top_float_right {
			margin-top: -5px;
		}
	</style>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left">
		<div class="thw_title" style="margin-left:11px;margin-top:0px;">
			<font id="pageTittle" class="fontTitle">实体属性</font> 
			<span id="tableAlias_span"><a style="color:#000;">表别名:</a><span uitype="input" id="tableAlias" name="tableAlias" width="100px"></span></span>
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入属性英文名、中文名过滤"
						on_iconclick="fastQuery"  icon="search" enterable="true" style="text-align:left;"
						editable="true"	 width="180px" on_keydown="keyDownQuery"></span>
		<span uitype="button" label="确定" on_click="enSure"></span> 
	    <span uitype="button" label="取消" on_click="closeSelf"></span>
	</div>
</div>
 <table uitype="Grid" id="EntityAttributeGrid" primarykey="modelId" sorttype="1" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
 	resizewidth="resizeWidth" selectrows="multi" resizeheight="resizeHeight"  colrender="columnRenderer">
 	<thead>
	 	<tr>
			<th style="width:30px"></th>
			<th bindName="engName" style="width:30%;" renderStyle="text-align: left;" sort="false">属性名称</th>
			<th bindName="chName" style="width:30%;" renderStyle="text-align: left;" sort="false">中文名称</th>
			<th bindName="attributeType.type" style="width:30%;" renderStyle="text-align: center" sort="false">属性类型</th>
			<th bindName="dbFieldId" style="width:30%;" renderStyle="text-align: center" sort="false">数据库字段</th>
		</tr>
	</thead>
</table>

<script language="javascript"> 

	var entityId = "${param.entityId}";
	var tableAlias = "${param.tableAlias}";
	var entity =null;
	if(tableAlias){
		dwr.TOPEngine.setAsync(false);
		EntityFacade.loadEntity(entityId,"", function(data){
			entity = data;
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	window.onload = function(){
		comtop.UI.scan();
		initQueryModel();
	}
	
	//初始化查询建模
	function initQueryModel(){
		if(tableAlias){
			cui("#tableAlias").setValue(tableAlias);
			$("#pageTittle").hide();
		}else{
			$("#tableAlias_span").hide();
		}
	}
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){
		dwr.TOPEngine.setAsync(false);
		EntityFacade.queryAttributesAndNotRelationship(entityId, function(data){
			dataCount = data.count;
		    tableObj.setDatasource(data.list, data.count);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//快速查询
	function fastQuery(){
		var keyword = cui("#keyword").getValue().replace(new RegExp("/","gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
		dwr.TOPEngine.setAsync(false);
		EntityFacade.fastQueryEntityAttributes(entityId, keyword, function(data){
				cui("#EntityAttributeGrid").setDatasource(data.list, data.count);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			fastQuery();
		}
	}
	
	//grid列渲染
	function columnRenderer(data,field){
		if(field == 'engName') {
			if(data.primaryKey) {
				return data.engName + "&nbsp;<img src='images/zhujian.jpg'/>";
			} else {
				return data.engName;
			}
		}
	}
	

	//点击确定回调传值到父页面
	function enSure() {
		var selectAttrData = cui("#EntityAttributeGrid").getSelectedRowData();
		if(selectAttrData == null || selectAttrData.length == 0){
			cui.alert("请选择属性。");
			return;
		}
		var selectNodeId = entityId;
		if(tableAlias){
			tableAlias = cui("#tableAlias").getValue();
			window.parent.parent.multiAttrSelCallBack(selectNodeId, selectAttrData ,tableAlias ,entity ? entity.dbObjectName : "");
		}else{
			window.parent.parent.multiAttrSelCallBack(selectNodeId, selectAttrData);
		}
	}
	
	//关闭窗口
	function closeSelf(){
		window.parent.parent.closeMultiAttrWindow();
	}
	
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 55;
	}
 </script>
</body>
</html>