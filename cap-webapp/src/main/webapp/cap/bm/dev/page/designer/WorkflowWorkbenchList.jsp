<%
/**********************************************************************
* 工作流配置工作台待办列表界面
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
		<title>工作台配置</title>
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/bm/common/base/css/base.css"></top:link>
		<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css" />
		
		<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
		<top:script src="/cap/bm/common/base/js/angular.js"></top:script>
		<top:script src="/cap/bm/common/base/js/cui2angularjs.js"></top:script>
		<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
		<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
		
		<top:script src='/cap/dwr/engine.js'></top:script>
		<top:script src='/cap/dwr/util.js'></top:script>
		<top:script src='/cap/dwr/interface/WorkflowWorkbenchAction.js'></top:script>
	</head>
	<body>
		<div id="pageRoot" class="cap-page">
			<div class="cap-area" style="width: 100%;">
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td" style="text-align: left; padding: 5px">
							<span id="formTitle" uitype="Label" value="工作流工作台待办配置" class="cap-label-title" size="12pt"></span>
						</td>
						<td class="cap-td" style="text-align: right; padding: 5px">
							<span id="createPage" uitype="Button" onclick="addNewAction()" label="新增"></span> 
							<span id="deletePage" uitype="Button" onclick="deleteAction()" label="删除"></span>
						</td>
					</tr>
				</table>
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td">
							<table uitype="Grid" id="lstPage" primarykey="processId" colhidden="false" datasource="initData" pagination="false"
								resizewidth="getBodyWidth" resizeheight="getBodyHeight" 
								colrender="columnRenderer">
								<thead>
									<tr>
										<th style="width: 30px" renderStyle="text-align: center;"><input
											type="checkbox"></th>
										<th style="width: 50px" renderStyle="text-align: center;"
											bindName="1">序号</th>
										<th renderStyle="text-align: left" render="editPage"
											bindName="processId">流程ID</th>
										<th renderStyle="text-align: left" bindName="processName">流程名称</th>
										<th renderStyle="text-align: left" bindName="todo_url">待办页面URL</th>
										<th renderStyle="text-align: left" bindName="done_url">已办页面URL</th>
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
			 //系统目录树的，应用模块编码
		    var moduleCode = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageModuleCode"))%>;
			var page = [];
			function initData(gridObj, query) {
				WorkflowWorkbenchAction.getListData(moduleCode,function(data) {
					if(data!=null)
					   gridObj.setDatasource(data["list"], data["count"]);
					else{
					   var list =[];
					   gridObj.setDatasource(list , 0);
					}
					  
				})
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
			
			//新增
			function addNewAction(){
				var param="?modelId="+"&packageId="+packageId+"&packageModuleCode="+moduleCode;
				window.location="${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/WorkflowWorkbenchEdit.jsp"+param;
			}
				
			//跳转编辑页面列渲染
			function editPage(rd, index, col){
				var param="?modelId="+rd.processId+"&packageId="+packageId+"&packageModuleCode="+moduleCode;
				return "<a href='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/WorkflowWorkbenchEdit.jsp"+param+"' target='_self'>" + rd['processId'] + "<a>";
			}
			
			function pageType(rd, index, col){
				var pageType = rd['pageType'];
				if(pageType == 1){
					return "否";
				}else{
					return "是";
				}
			}
			
			//删除页面
			function deleteAction(){
				var selectIds = cui("#lstPage").getSelectedPrimaryKey();
				if(selectIds == null || selectIds.length == 0){
					cui.alert("请选择要删除的数据。");
					return;
				}
				
				cui.confirm("确定要删除这"+selectIds.length+"个数据吗？",{
					onYes:function(){
						WorkflowWorkbenchAction.deleteAction(selectIds,function(data) {
							if(data){
								
							}
							cui("#lstPage").loadData();
							cui.message("删除成功。","success");
						})
					}
				});
			}
				
		</script>
	</body>
</html>
