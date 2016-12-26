<%
/**********************************************************************
* 帮助文档
* 2015-05-07 诸焕辉  
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>帮助文档</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/dev/page/uilibrary/css/doc.css"></top:link>
	<top:link href="/cap/bm/dev/page/uilibrary/css/shCore.css"></top:link>
	<top:link href="/cap/bm/dev/page/uilibrary/css/shThemeDefault.css"></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/ComponentFacade.js"></top:script>
</head>
<body>
	 <table id="grid" uitype="grid" gridwidth="800" gridheight="auto" resizewidth="resizeWidth" resizeheight="resizeheight" selectrows="no" ellipsis="false" datasource="initData" pagination="false">
        <thead>
        <tr>
            <th renderStyle="text-align: center; height:60px;" width="10%" bindName="propertyName">名称</th>
            <th renderStyle="text-align: center;" width="10%" bindName="type" >类型</th>
            <th renderStyle="text-align: left;" width="60%" bindName="description" render="showDescription" >描述</th>
            <th renderStyle="text-align: center;" width="10%" bindName="requried" >是否必填</th>
            <th renderStyle="text-align: left;" width="10%" bindName="defaultValue" >默认值</th>
        </tr>
        </thead>
    </table>
	<script type="text/javascript">
		var componentModelId = "<c:out value='${param.componentModelId}'/>";
		jQuery(document).ready(function(){
			comtop.UI.scan();
		});
		
		function showDescription(rd,index,col){
			var ret = rd.description != null ? rd.description.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;')
            .replace(/</g, '&lt;').replace(/>/g, '&gt;') : rd.description;
			return ret;
		}

		/**
		 * 渲染列表数据
		 * grid 会议列表表格节点对象
		 * query 分页查询对象
		 */
		function initData(grid, query) {
			var component = {};
			dwr.TOPEngine.setAsync(false);
			ComponentFacade.loadModel(componentModelId, function(data){
				component = data;
			});
			dwr.TOPEngine.setAsync(true);
			
			var datasource = new Array();
			var key, type, description, requried, defaultValue;
			var properties = component.properties;
			if(properties != null){
				for(var i=0; i<properties.length; i++){
					key = eval("("+properties[i].propertyEditorUI.script+")").name;
					type = properties[i].type;
					description = properties[i].description;
					requried = properties[i].requried;
					defaultValue = properties[i].defaultValue;
					datasource.push({"ID":i, "type":type, "propertyName":key, "description":description, "requried":requried, "defaultValue":defaultValue});
				}
			}
			var events = component.events;
			if(events != null){
				for(var i=0; i<events.length; i++){
					key = events[i].ename;
					type = events[i].type;
					description = events[i].description;
					requried = events[i].requried;
					datasource.push({"ID":i, "type":type, "propertyName":key, "description":description, "requried":requried, "defaultValue":defaultValue});
				}
			}
			grid.setDatasource(datasource, datasource.length);
		}
		
		//Grid组件自适应宽度回调函数，返回高度计算结果即可
		function resizeWidth(){
			return (document.documentElement.clientWidth || document.body.clientWidth)-30;
		}

		//Grid组件自适应高度回调函数，返回宽度计算结果即可
		function resizeHeight(){
			return (document.documentElement.clientHeight || document.body.clientHeight) - 65;
		}
	</script>
</body>
</html>

