<%
/**********************************************************************
* 模板实例化元数据列表
* 2015-10-12 诸焕辉
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>模板实例化元数据列表</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
	<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
	<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/bm/dev/page/template/js/common.js"></top:script>
	<top:script src="/cap/bm/dev/page/designer/js/pageactioncommon.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/MetadataGenerateFacade.js'></top:script>
	<top:script src="/cap/dwr/interface/PageFacade.js"></top:script>
	<top:script src="/cap/dwr/interface/ActionDefineFacade.js"></top:script>
</head>
<body>
	<div id="pageRoot" class="cap-page">
		<div class="cap-area" style="width: 100%;">
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td" style="text-align: left; padding: 5px">
						<span id="formTitle" uitype="Label" value="模板实例化元数据列表" class="cap-label-title" size="12pt"></span>
					</td>
					<td class="cap-td" style="text-align: right; padding: 5px">
						<span id="fromTemplateCreateMetadata" uitype="Button" onclick="generateCode()" label="生成元数据"></span> 
						<span id="createMetadataGenerate" uitype="Button" onclick="createMetadataGenerate()" label="新增"></span>
						<span id="deleteMetadataGenerate" uitype="Button" onclick="deleteMetadataGenerate()" label="删除"></span>
					</td>
				</tr>
			</table>
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td">
						<table uitype="Grid" id="lstMetadataGenerate" primarykey="modelId" colhidden="false" datasource="initData" pagination="false"
							resizewidth="getBodyWidth" resizeheight="getBodyHeight"
							colrender="columnRenderer">
							<thead>
								<tr>
									<th style="width: 30px" renderStyle="text-align: center;"><input
										type="checkbox"></th>
									<th style="width: 50px" renderStyle="text-align: center;"
										bindName="1">序号</th>
									<th renderStyle="text-align: left" render="editMetadataGenerate"
										bindName="cname">模版中文名</th>
									<th renderStyle="text-align: left"
										bindName="modelName">模版英文名</th>
									<th renderStyle="text-align: left" bindName="tmpCname">模版</th>
								</tr>
							</thead>
						</table>
					</td>
				</tr>
				<tr>
					<td class="cap-td"></td>
				</tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
		var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		
		/**
		 * 设置生产元数据列表数据源
		 * @param gridObj 表格组件对象
		 * @param query Json 包含分页信息和题头排序信息
		 */
		function initData(gridObj, query) {
			MetadataGenerateFacade.queryMetadataGenerateList(packageId,function(data) {
				var datasource = [];
				for(var i=0, len=data.length; i<len; i++){
					var cname = _.result(_.find(data[i].metadataValue.inputComponentList, { 'id': 'cname'}), 'value');
					datasource.push({modelId: data[i].modelId, cname: cname, modelName: data[i].modelName, tmpCname: data[i].metadataPageConfigVO != null ? data[i].metadataPageConfigVO.cname : ''});
				}
				gridObj.setDatasource(datasource, datasource.length);
			})
		}
		
		jQuery(document).ready(function() {
			comtop.UI.scan();
		});
		
		/**
		 * 表格自适应宽度
		 */
		function getBodyWidth () {
		    return parseInt(window.parent.$("body").css("width"))- 32;
		}

		/**
		 * 表格自适应高度
		 */
		function getBodyHeight () {
		    return (document.documentElement.clientHeight || document.body.clientHeight) - 73;
		}
		
		//新建页面
		function createMetadataGenerate(){
			var param = "?packageId="+packageId+"&openType=listToMain";
			var width=260; //窗口宽度
		    var height=350; //窗口高度
		    var top=(window.screen.availHeight-height)/2;
		    var left=(window.screen.availWidth-width)/2;
		    var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/template/MetadataTmpSelect.jsp'+param;
		    window.open(url, "entityAttribute", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
		}

		//跳转编辑页面列渲染
		function editMetadataGenerate(rd, index, col){
			var param="?packageId="+packageId+"&operationType=edit&metadataGenerateModelId="+rd['modelId']+"&openType=listToMain";
			return "<a href='${pageScope.cuiWebRoot}/cap/bm/dev/page/template/MetadataGenerateEdit.jsp"+param+"' target='_parent'>" + rd['cname'] + "<a>";
		}
		
		//删除
		function deleteMetadataGenerate(){
			var selectIds = cui("#lstMetadataGenerate").getSelectedPrimaryKey();
			if(selectIds == null || selectIds.length == 0){
				cui.alert("请选择要删除的元数据。");
				return;
			}
			
			cui.confirm("确定要删除这"+selectIds.length+"个元数据吗？",{
				onYes:function(){
					MetadataGenerateFacade.deleteModels(selectIds,function(data) {
						if(data){
							cui("#lstMetadataGenerate").loadData();
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