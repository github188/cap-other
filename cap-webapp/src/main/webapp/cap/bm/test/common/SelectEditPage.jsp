<%
    /**********************************************************************
	 * 选择页面
	 * 2016-7-8 诸焕辉 新建
	 **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
	<head>
		<meta charset="UTF-8">
		<title>选择页面</title>
		<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
		<top:link href="/cap/bm/test/css/comtop.cap.test.css" />
		<style type="text/css">
			
		</style>
		<top:script src="/cap/bm/test/design/js/jquery.min.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/comtop.ui.all.js"></top:script>
		<top:script src="/cap/bm/test/js/comtop.cap.js"></top:script>
    	<top:script src="/cap/bm/test/js/comtop.cap.js"></top:script>
		<top:script src="/cap/rt/common/cui/js/cui.utils.js"></top:script>
		<top:script src="/cap/dwr/engine.js"></top:script>
		<top:script src="/cap/dwr/util.js"></top:script>
		<top:script src="/cap/dwr/interface/PageMetadataProvider.js"></top:script>
	</head>
	<body>
		<div id="pageRoot">
			<div class="cap-area" style="width: 100%;">
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td" style="text-align: left; padding: 5px">
							<span uitype="ClickInput" id="quickSearch" width="240" name="search" editable="true" on_keydown="keyDownQuery" on_iconclick="keyWordQuery" emptytext="请输入关键字" icon="search"></span>
						</td>
						<td class="cap-td" style="text-align: right; padding: 5px">
							<span id="ensureBtn" uitype="Button" onclick="ensure()" label="确定"></span>
							<span id="clearBtn" uitype="Button" onclick="clearValue()" label="清空"></span>
							<span id="closeBtn" uitype="Button" onclick="closeWin()" label="取消"></span>
						</td>
					</tr>
				</table>
				<table class="cap-table-fullWidth">
					<tr>
						<td class="cap-td">
							<table uitype="Grid" id="lstPage" primarykey="modelId" colhidden="false" datasource="initData" pagination="false" selectrows="single"
								resizewidth="getBodyWidth" resizeheight="getBodyHeight">
								<thead>
									<tr>
										<th style="width: 30px" renderStyle="text-align: center;">&nbsp;</th>
										<th renderStyle="text-align: left" render="editPage"
											bindName="cname">页面标题</th>
										<th renderStyle="text-align: left" bindName="modelName">页面文件名</th>
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
		    var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
		    var selectEditPage = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("editPage"))%>;
		    var argName = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("argName"))%>;
		    var callbackMethod = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("callbackMethod"))%>;
		    callbackMethod = callbackMethod != null ? callbackMethod : 'commonCallback';
		    var gridDatasource = [];
		    /**
			 * 初始化页面列表
			 * @param gridObj 网格对象
			 * @param query 查询对象
			 */
			function initData(gridObj, query) {
				gridDatasource = queryCurrModelPackagePageList(packageId);
				gridObj.setDatasource(gridDatasource, gridDatasource.length);
			}
			
			/**
			 * 根据包路径，获取当前包下的所有页面元数据
			 * @param modelPackage 包路径
			 */
			function queryCurrModelPackagePageList(packageId){
				var pageList = [];
				dwr.TOPEngine.setAsync(false);
				PageMetadataProvider.getPagesByModelId(packageId, function(data){
				   	pageList = data != null ? data : [];
			   	});
				dwr.TOPEngine.setAsync(true);
				return pageList;
			}
			
			//快速查询
			function keyWordQuery(){
				query();
			}
			
			//键盘回车键快速查询 
			function keyDownQuery() {
				if (event.keyCode ==13) {
					keyWordQuery();
				}
			} 
			
			//通过sql过滤查询
			function query(){
				var keyWord = cui('#quickSearch').getValue();
				var datasource = gridDatasource;
				if($.trim(keyWord) != ''){
					var obj = new cap.CollectionUtil(datasource);
					datasource = obj.query("this.cname.indexOf('"+ keyWord +"') != -1 || this.modelName.indexOf('"+ keyWord +"') != -1");
				}
				cui('#lstPage').setDatasource(datasource, datasource.length);
			}
			
			//选择页面
			function ensure(){
				var selectedPageModelId = cui('#lstPage').getSelectedPrimaryKey();
				if(selectedPageModelId && selectedPageModelId.length > 0){
					window.opener[callbackMethod](selectedPageModelId[0], argName);
					closeWin();
				} else {
					cui.alert("请选择元数据页面。");
				}
			}

			//清空
			function clearValue(){
				window.opener[callbackMethod]('', argName);
				closeWin();
			}
			
			//关闭窗口
			function closeWin(){
				window.close();
			}	
			
			/**
			 * 表格自适应宽度
			 */
			function getBodyWidth() {
			    return parseInt(jQuery("#pageRoot").css("width"))- 10;
			}
		
			/**
			 * 表格自适应高度
			 */
			function getBodyHeight() {
			    return (document.documentElement.clientHeight || document.body.clientHeight) - 73;
			}
			
			jQuery(document).ready(function() {
				comtop.UI.scan();
				if(selectEditPage){
					cui('#lstPage').selectRowsByPK(selectEditPage, true);
				}
			});
		</script>
	</body>
</html>