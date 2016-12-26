<%
/**********************************************************************
* 工作流 待办/已办URL页面
* 2016-2-24 许畅 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>工作流待办URL界面</title>
		<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
		<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/base/css/base.css" type="text/css">
		<link rel="stylesheet" href="${pageScope.cuiWebRoot}/cap/bm/common/base/css/comtop.cap.bm.css" type="text/css">
		
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/top/js/jquery.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/comtop.ui.min.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/angular.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/cui2angularjs.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/base/js/comtop.cap.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/common/cui/js/cui.utils.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/js/pageList.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/dwr/engine.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/dwr/util.js"></script>
		<script type="text/javascript" src="${pageScope.cuiWebRoot}/cap/dwr/interface/PageFacade.js"></script>
	</head>
	<body>
		<div id="pageRoot" class="cap-page">
			<div class="cap-area" style="width: 100%;">
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td" style="text-align: left; padding: 5px">
							<span id="formTitle" uitype="Label" value="界面URL" class="cap-label-title" size="12pt"></span>
						</td>
						
						<td>
						    <div class="top_float_right">
								<span uitype="button" id="enSureBtn" label="确定" on_click="enSure"></span>
								<span uitype="button" id="closeBtn" label="取消" on_click="closeSelf"></span>
								<span uitype="button" id="clearData" label="清空" on_click="clearData"></span>
							</div>
						</td>
					</tr>
				</table>
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td">
							<table uitype="EditableGrid" id="lstPage" primarykey="modelId" colhidden="false" datasource="initData" pagination="false"
								resizewidth="getBodyWidth" resizeheight="getBodyHeight" rowdblclick_callback="dbclick" edittype ="edittype"
								colrender="columnRenderer">
								<thead>
									<tr>
										<th style="width: 30px" renderStyle="text-align: center;"><input
											type="checkbox"></th>
										<th style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
										<th renderStyle="text-align: left" render="editPage" bindName="cname">页面中文名</th>
										<th renderStyle="text-align: left" bindName="url">页面URL</th>
										<th renderStyle="text-align: left" style="display:none;" bindName="modelName">页面文件名</th>
										<th renderStyle="text-align: left" style="display:none;" bindName="modelPackage">页面包路径</th>
										<th style="width: 100px" renderStyle="text-align: center;" render="pageType" bindName="pageType">是否自定义页面</th>
										<th style="width: 70px;display:block;" renderStyle="text-align: center;" render="renderPreviewLink" bindName="view">预览</th>
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
			var openType="${param.openType}";//1 待办 2已办
			var page = [];
			function initData(gridObj, query) {
				dwr.TOPEngine.setAsync(false);
				PageFacade.queryPageList(packageId,function(data) {
					page = templatePageList(data);
					gridObj.setDatasource(data, data.length);
				})
				dwr.TOPEngine.setAsync(true);
			}
			
			/**
			 * 把列表上的页面集合进行过滤，过去掉pageType=2的自定义录入界面
			 *
			 * @param pages 列表页面集合
			 * @return 过滤后的页面集合
			 */
			var templatePageList = function(pages){
				if(pages && Array.isArray(pages) && pages.length > 0){
					var pageList = [];
					pages.forEach(function(item,index,arr){
						if(item.pageType == 1){
							pageList.push(item);
						}
					});
					return pageList;
				}
				return [];
			};
			
			//url可编辑
			var edittype = {
					url: {
					uitype: "Input"
					}
			}
			
			
			jQuery(document).ready(function() {
				comtop.UI.scan();
			});
				
		    //see /cap/bm/dev/page/designer/js/pageList.js
		    var addTemplateURL = '../template/EditMetadataTmpType.jsp?operationType=add&parentemplateTypeCode=pageMetadataTmp';
				
			/**
			 * 表格自适应宽度
			 */
			function getBodyWidth () {
			    return parseInt(jQuery("#pageRoot").css("width"))- 10;
			}
		
			/**
			 * 表格自适应高度
			 */
			function getBodyHeight () {
			    return (document.documentElement.clientHeight || document.body.clientHeight) - 73;
			}
			
			var param="";
			
			//新建页面
			function createPage(){
				param="?modelId="+"&packageId="+packageId+"&openType=listToMain";
				window.parent.location="${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageMain.jsp"+param;
			}
			
			function pageType(rd, index, col){
				var pageType = rd['pageType'];
				if(pageType == 1){
					return "否";
				}else{
					return "是";
				}
			}
			
			// 确定
			function enSure(){
				var gridId = cui('#lstPage').getSelectedPrimaryKey();
				if (checkStrEmty(gridId)){
					cui.alert('请选择一条记录。');
					return;
				}
				
				if(gridId.length>1){
					cui.alert('请选择一条记录。');
					return;
				}
				
				if(parent.setPageURL) {
					parent.setPageURL(cui("#lstPage").getSelectedRowData()[0],openType);
				}
				closeSelf();
			}
			
			//关闭
			function closeSelf() {
				window.parent.dialog.hide();
			}
			
			//清空
			function clearData(){
				parent.clearPageURL(openType);
				closeSelf();
			}
			
			function checkStrEmty(strParam) {
				if (strParam == null || strParam == ""
						|| strParam == "undefined" || strParam == "null") {
					return true;
				}
				return false;
			}
			
			//双击选择
			function dbclick(rowData,index){
				parent.setPageURL(rowData,openType);
				closeSelf();
			}

			var handleMask = null;

			function renderPreviewLink(rd, index, col) {
				return "<span class='cui-icon' style='font-size:12pt;color:#545454;cursor:pointer' onclick=\"window.open('${pageScope.cuiWebRoot}"
						+ rd.url + "')\">&#xf002;</span>";
			}
		</script>
	</body>
</html>
