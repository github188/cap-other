<%
/**********************************************************************
* 常用意见列表界面
* 2016-4-12 许畅 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>常用意见</title>
		<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/rt/common/base/css/base.css"></top:link>
		
		<style type="text/css">
			#pageRoot{
			   overflow: hidden;
			}
			#formTitle{
			  font-weight: bold;
              font-size: 12pt;
			}
			.cap-table-fullWidth{
			   width: 100%;
			   margin-left: 5px;
			}
			.lastButton{
			   padding-right: 5px;
			}
		</style>
		
		<top:script src="/cap/rt/common/base/js/jquery.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/comtop.ui.min.js"></top:script>
		<top:script src="/cap/rt/common/base/js/comtop.cap.rt.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/cui.utils.js"></top:script>
		<top:script src='/cap/dwr/engine.js'></top:script>
		<top:script src='/cap/dwr/util.js'></top:script>
		<top:script src='/cap/dwr/interface/CommonOpinionFacade.js'></top:script>
	</head>
	<body>
		<div id="pageRoot" class="cap-opinion">
			<div class="cap-area" style="width: 100%;">
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td" style="text-align: left; padding: 5px">
							<span id="formTitle" uitype="Label" value="常用意见" class="cap-label-title" size="12pt"></span>
						</td>
						<td class="cap-td" style="text-align: right; padding: 5px">
						    <span id="sure" uitype="Button" onclick="sureAction()" label="确认"></span> 
							<span id="addNew" uitype="Button" onclick="addNewAction()" label="常用意见新增"></span> 
							<span id="delete" class="lastButton" uitype="Button" onclick="deleteAction()" label="常用意见删除"></span>
						</td>
					</tr>
				</table>
				
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td">
							<table uitype="Grid" id="lstPage" primarykey="id" colhidden="false" datasource="initData" pagination="false"
								resizewidth="getBodyWidth" resizeheight="getBodyHeight" rowdblclick_callback="dbclick" selectrows="single"
								colrender="columnRenderer">
								<thead>
									<tr>
										<th style="width: 30px" renderStyle="text-align: center;"></th>
										<th style="width: 50px" renderStyle="text-align: center;" bindName="1">序号</th>
										<th renderStyle="text-align: left" render="edit" bindName="opinion">意见内容</th>
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
		    //工单id
			var workId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("primaryValue"))%>;
			 //员工id
		    var personId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("personId"))%>;
		    
		    //表格初始化数据
			function initData(gridObj, query) {
				CommonOpinionFacade.getListData(personId,function(data) {
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
			    return (document.documentElement.clientHeight || document.body.clientHeight) - 100;
			}
			
			//新增
			function addNewAction(){
				var param="?primaryValue="+workId+"&personId="+personId;
				window.location="${pageScope.cuiWebRoot}/cap/rt/common/workflow/flowmanage/CommonOpinionEdit.jsp"+param;
			}
				
			//跳转编辑页面列渲染
			function edit(rd, index, col){
				var param="?modelId="+rd.id+"&primaryValue="+workId+"&personId="+personId;
				return "<a href='${pageScope.cuiWebRoot}/cap/rt/common/workflow/flowmanage/CommonOpinionEdit.jsp"+param+"' target='_self'>" + rd['opinion'] + "<a>";
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
						CommonOpinionFacade.deleteAction(selectIds,function(data) {
							if(data){
								cui("#lstPage").loadData();
								cui.message("删除成功。","success");
							}
						})
					}
				});
			}
			
			function sureAction(){
				var selectIds = cui("#lstPage").getSelectedPrimaryKey();
				if(selectIds == null || selectIds.length == 0){
					cui.alert("请选择需要的数据。");
					return;
				}
				
				var rowDatas=cui("#lstPage").getSelectedRowData();
				if(rowDatas && rowDatas.length>0){
					window.opener.commonOpinionCallback(rowDatas[0]);
					window.close();
				}
			}
			
			//双击事件
			function dbclick(rowData,index){
				window.opener.commonOpinionCallback(rowData);
				window.close();
			}
				
		</script>
	</body>
</html>
