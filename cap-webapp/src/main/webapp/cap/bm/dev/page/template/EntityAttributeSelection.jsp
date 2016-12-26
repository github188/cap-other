<%
/**********************************************************************
* 界面添加属性时所用
* 2014-10-15 诸焕辉 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>实体属性列表页</title>
    <top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
    <top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <style type="text/css">
    	.top_float_right{
    		margin-top:-6px;
    	}
    </style>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/angular.js"></top:script>
    <top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
    <top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/PageFacade.js"></top:script>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left">
		<div class="thw_title" style="margin-top:0px;margin-left:0px;">
			<font id="pageTittle" class="fontTitle">实体属性列表</font> 
		</div>
	</div>
	<div class="top_float_right">
		<span uitype="button" label="确定" id="button_enSure" on_click="enSure"></span>
	</div>
</div>
<table uitype="Grid" id="EntityAttributeGrid" primarykey="id" sorttype="1" datasource="initData" selectrows="single"
 	colrender="columnRenderer" pagination="false" resizeheight="resizeHeight" resizewidth="resizeWidth">
 	<thead>
 	<tr>
		<th style="width:5%;"></th>
		<th bindName="engName" style="width:30%;" renderStyle="text-align: left;" >属性名称</th>
		<th bindName="chName" style="width:30%;" renderStyle="text-align: left;" >中文名称</th>
		<th bindName="attributeType" style="width:35%;" renderStyle="text-align: center" >属性类型</th>
	</tr>
	</thead>
</table>

<script language="javascript"> 

	var entityId = "${param.entityId}";//实体ID
	var propertyName = "${param.propertyName}";
	var flag = "${param.flag}";
	var callbackMethod = "${param.callbackMethod}";
	var entityVo = {};
	
	window.onload = function(){
		entityVo = getEntity(entityId);
		comtop.UI.scan();
	}
	
	/**
	 * 获取实体信息
	 * @param entityId 实体id
	 */
  	function getEntity(entityId){
  		var entityVO = null;
  		if(window.opener.scope && window.opener.scope.entityList) {
  			entityVO = _.find(window.opener.scope.entityList, {modelId: entityId});
  		}
  		if(entityVO == null){
	  		dwr.TOPEngine.setAsync(false);
			PageFacade.readEntity(entityId,function(data){
				entityVO= data;
			});
			dwr.TOPEngine.setAsync(true);
  		}
		return entityVO;
  	}
	
	// grid数据源
	function initData(tableObj,query){
		var attributes = [];
		if(entityVo != null){
			for(var i=0, len=entityVo.attributes.length; i<len; i++){
				var sourceType = entityVo.attributes[i].attributeType.source;
				if(sourceType != "primitive" && sourceType != "dataDictionary" && sourceType != "enumType"){
					continue;
				}
				attributes.push(entityVo.attributes[i]);
			}
		} 
		tableObj.setDatasource(attributes, attributes.length);
	}
	
	// 确定
	function enSure() {
		var selectData = cui("#EntityAttributeGrid").getSelectedRowData();
		selectData[0].entityEngName = entityVo.engName;
		window.opener[callbackMethod](selectData[0],flag,propertyName);
		window.close();
	}

	//grid列渲染
	function columnRenderer(data,field){
		if(field == 'attributeType'){
			return data.attributeType.type;
		}
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