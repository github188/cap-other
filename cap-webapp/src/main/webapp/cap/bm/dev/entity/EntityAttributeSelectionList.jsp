<%
/**********************************************************************
* 元数据建模：实体属性选择列表
* 2014-8-13 沈康 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%@ page import="java.util.*" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>实体属性选择列表页</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
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
			<font id="pageTittle" class="fontTitle">实体属性选择列表</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入属性英文名、中文名过滤"
						on_iconclick="fastQuery"  icon="search" enterable="true" style="text-align:left;"
						editable="true"	 width="240" on_keydown="keyDownQuery"></span>
		<span uitype="button" label="确定" on_click="enSure"></span> 
	    <span uitype="button" label="取消" on_click="closeSelf"></span> 
	</div>
</div>
 <table uitype="Grid" id="EntityAttributeGrid" primarykey="engName" sorttype="1" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
 	resizewidth="resizeWidth" selectrows="single" resizeheight="resizeHeight"  colrender="columnRenderer">
 	 <thead>	
 	<tr>
		<th style="width:30px"></th>
		<th bindName="engName" style="width:30%;" renderStyle="text-align: left;" sort="false">属性名称</th>
		<th bindName="chName" style="width:30%;" renderStyle="text-align: left;" sort="false">中文名称</th>
		<th bindName="attributeType.type" style="width:30%;" renderStyle="text-align: center" sort="false">属性类型</th>
	</tr>
	</thead>
</table>

<script language="javascript"> 

	var entityId = "${param.entityId}";
	var selectFlag = "${param.selectFlag}";
	var selData ="${param.selData}";
	
	window.onload = function(){
		comtop.UI.scan();
		cui("#EntityAttributeGrid").selectRowsByPK(selData,true);
	}

	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){
		dwr.TOPEngine.setAsync(false);
		EntityFacade.queryBaseAttributes(entityId, function(data){
			dataCount = data.count;
		    tableObj.setDatasource(data.list, data.count);
		});
		dwr.TOPEngine.setAsync(true);
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
		var selectData = cui("#EntityAttributeGrid").getSelectedRowData();
		if(selectData == null || selectData.length == 0){
			cui.alert("请选择属性。");
			return;
		}
		var selectNodeId = entityId;
		var selectNodeTitle = selectData[0].engName;
		var chName = selectData[0].chName;
		var selectAttrType = selectData[0].attributeType.type;
		if(selectFlag=="expression"){
			window.parent.opener.editCallBackOtherTypeSelect(selectNodeId, selectNodeTitle, chName, selectAttrType,selectFlag);
			window.parent.close();
		}else{
			window.parent.parent.editCallBackOtherTypeSelect(selectNodeId, selectNodeTitle, "AttributeData", selectAttrType,selectFlag);
		}
	}
	
	//取消，关闭窗口
	function closeSelf(){
		window.parent.parent.closeAttrWindow();
	}
	
	
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 55;
	}
	
	//快速查询
	function fastQuery(){
		var keyword = cui("#keyword").getValue().replace(new RegExp("/","gm"), "//");
		keyword = keyword.replace(new RegExp("%", "gm"), "/%");
		keyword = keyword.replace(new RegExp("_","gm"), "/_");
		keyword = keyword.replace(new RegExp("'","gm"), "''");
		dwr.TOPEngine.setAsync(false);
		EntityFacade.fastQueryEntityBaseAttributes(entityId, keyword, function(data){
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
 </script>
</body>
</html>