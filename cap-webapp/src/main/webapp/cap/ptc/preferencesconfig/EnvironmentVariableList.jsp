<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>首选项配置</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
	<script type='text/javascript' src="${pageScope.cuiWebRoot}/cap/dwr/interface/EnvironmentVariablePreferenceFacade.js"></script>
</head>
<body>
	<div class="main">
		<table style="width: 100%">
			<tr>
				<td class="cap-td" style="text-align: left; padding: 5px;width: 50%">
					<span id="formTitle" uitype="Label" value="页面全局参数列表" class="cap-label-title" size="12pt"></span>
				</td>
				<td class="cap-td" style="text-align: right; padding: 5px;width: 50%">
					<span id="createVariablePreference" uitype="Button" onclick="createVariablePreference()" label="新增"></span> 
					 <span id="deleteVariablePreference" uitype="Button" onclick="deleteVariablePreference()" label="删除"></span>
				</td>
			</tr>
		</table>
		<table id="listVariablePreference" uitype="grid" datasource="initData" primarykey="attributeName" ellipsis="false" pagination="false" resizewidth="resizeWidth" resizeheight="resizeHeight" rowclick_callback="rowclickcallback" selectall_callback="selectallcallback">
			<thead>
				<tr>
					<th width="5%" bindName="attributeName"><input type="checkbox"></th>
					<th renderStyle="text-align:center;" bindName="attributeName" width="15%" render="editAttributeName">参数名称</th>
					<th renderStyle="text-align:center;" bindName="attributeClass" width="10%">类别</th>
					<th renderStyle="text-align:center;" bindName="attributeType" width="10%">类型</th>
					<th renderStyle="text-align:center;" bindName="attributeValue" width="10%" >默认值</th>
					<th renderStyle="text-align:left;" bindName="fileName" width="25%" >关联引入文件名称</th>
					<th renderStyle="text-align:left;" bindName="attributeDescription" width="35%" >描述</th>
				</tr>
			</thead>
		</table>
	</div>
	<script>
		//选中的primaryKey
		var selectedPrimaryKey = [];
		
		/**
		* 设置grid数据源
		*
		* @param grid 表格组件对象
		* @param query Json对象：包含分页信息和题头排序信息
		*/
		function initData(grid, query) {
			dwr.TOPEngine.setAsync(false);
			EnvironmentVariablePreferenceFacade.queryEnvironmentVariableist(function(data) {
				gridDatasource = data;
				grid.setDatasource(gridDatasource, gridDatasource.length);
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		/**
		* Grid组件点击行时的回调函数
		*
		* @param rowData 当前行数据
		* @param isChecked 是否是全选
		* @param index 当前被点击行的索引号
		*/
		function rowclickcallback(rowData, isChecked, index){
			var filePath = rowData.filePath;
			if(isChecked){
				var indexNo = $.inArray(filePath, selectedPrimaryKey); 
				if(indexNo < 0){
					selectedPrimaryKey.push(filePath);
				}
			} else{
				var indexNo = $.inArray(filePath, selectedPrimaryKey); 
				if(indexNo >= 0){
					selectedPrimaryKey.splice(indexNo, 1);
				}
			}
		}
		
	   /**
		* Grid组件点击全选checkbox时的回调函数
		*
		* @param data 全选的数据
		* @param isChecked 是否是全选
		*/
		function selectallcallback(data, isChecked){
			if(isChecked){
				for(var i in data){
					var filePath = data[i].filePath;
					var indexNo = $.inArray(filePath, selectedPrimaryKey); 
					if(indexNo < 0){
						selectedPrimaryKey.push(filePath);
					}
				}
			} else{
				for(var i in data){
					var filePath = data[i].filePath;
					var indexNo = $.inArray(filePath, selectedPrimaryKey); 
					if(indexNo >= 0){
						selectedPrimaryKey.splice(indexNo, 1);
					}
				}
			}
		}
	   
	   function isDefaultReference(rowData, bindName){
		   var value;
	        if (bindName == "attributeName") {
	            value = rowData[bindName];
	            if (value==true) {
	                return "是";
	            }else{
	                return "否";
	            }
	        }
	   }
	   
		function resizeWidth() {
			return (document.documentElement.clientWidth || document.body.clientWidth) - 4;
		}
	
		function resizeHeight() {
			return (document.documentElement.clientHeight || document.body.clientHeight) - 50;
		}
		
		//页面装载方法
		jQuery(document).ready(function(){
			comtop.UI.scan();
		});
		
		function createVariablePreference(){
				window.open("EnvironmentVariableEdit.jsp","_self");
		}
		
		//跳转编辑页面列渲染
		function editAttributeName(rd, index, col){
			var pageType = rd['attributeName'];
			param="?attributeName="+rd.attributeName+"&attributeType="+rd.attributeType+"&attributeValue="+rd.attributeValue
					+"&fileName="+rd.fileName+"&attributeDescription="+rd.attributeDescription;
		   return "<a href='EnvironmentVariableEdit.jsp"+param+"' target='_self'>" + rd['attributeName'] + "<a>";
		}

		
		function deleteVariablePreference(){
			var selectIds = cui("#listVariablePreference").getSelectedPrimaryKey();
			if(selectIds == null || selectIds.length == 0){
				cui.alert("请选择要删除的元数据。");
				return;
			}
			cui.confirm("确定要删除这"+selectIds.length+"个元数据吗？",{
				onYes:function(){
					EnvironmentVariablePreferenceFacade.deleteEnvironmentVariable(selectIds,function(data) {
						if(data){
							cui("#listVariablePreference").loadData();
							cui.message("删除成功。","success");
						} else {
							cui.message("删除失败。","error");
						}
					})
				}
			});
		}
 	</script>
</body>
</html>