<%
/**********************************************************************
* 元数据建模：由视图导入数据库对象
* 2015-12-17 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>由数据库导入视图</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src='/cap/dwr/interface/ViewFacade.js'></top:script>
	<style type="text/css">
		th{
		    font-weight: bold;
		    font-size:14px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
	
	<div id="centerMain" position="center" width="500" collapsabltie="true" show_expand_icon="true">       
        <table width="85%" style="margin-left: 10px">
			<tr height="40px;">
				<td class="fontTitle" width="250px">由数据库导入视图</td>
			</tr>
			<tr height="40px;">
				<td align="right">
					<span uitype="ClickInput" id="keyword" name="keyword" emptytext="请输入视图名过滤"
						on_iconclick="fastQuery"  icon="search" enterable="true" style="text-align:left;"
						editable="true"	 width="330" on_keyup="keyDownQuery"></span>
					<span uitype="button" label="导入" on_click="enSure"></span> 
					<span uitype="button" label="关闭" on_click="closeWin"></span> 
				</td>
			</tr>
			
			<tr>
				<td>
					 <table uitype="Grid" id="ViewImportGrid" primarykey="engName" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
					 	pagesize="20" resizewidth="resizeWidth" resizeheight="resizeHeight" >
					 	<thead>
					 	<tr>
							<th style="width:50px"><input type="checkbox"/></th>
							<th bindName="engName" style="width:50%;" renderStyle="text-align: left;" >视图名</th>
							<th bindName="chName" renderStyle="text-align: center" hide="true">中文名称</th>
							<th bindName="description" style="width:35%;" renderStyle="text-align: left;" >描述</th>
						</tr>
						</thead>
					</table> 
				</td>
			</tr>
		</table>
        </div>
</div>

<script language="javascript"> 
	var packageId = "${param.packageId}";//包ID
	var packagePath = "${param.packagePath}";//包路径
	
	
	window.onload = function(){
		comtop.UI.scan();
	}
	
	
	var dataCount = 0;
	//grid数据源
	function initData(tableObj,query){
		var queryString = cui("#keyword").getValue();
		dwr.TOPEngine.setAsync(false);
		ViewFacade.loadViewFromDatabase(queryString,query,function(data){
			if(data && data.length > 0) {
			    tableObj.setDatasource(data, data.length);
			}else {
				tableObj.setDatasource([], 0);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	function fastQuery() {
		initData(cui("#ViewImportGrid"),cui("#ViewImportGrid").getQuery());
	}
	function keyDownQuery(event) {
		if(event.keyCode ==13) {
			initData(cui("#ViewImportGrid"),cui("#ViewImportGrid").getQuery());
		}
	}
	//导入
	function enSure() {
		var selectData = cui("#ViewImportGrid").getSelectedRowData();
		if (selectData.length == 0) {
		    cui.alert("请选择要导入的视图。");
		    return;
		}
		
		cui.handleMask.show();
		setTimeout(function(){
			ViewFacade.importView(packagePath,selectData,function(data){
				if(data) {
					window.opener.focus();
					window.opener.cui.message("导入视图成功。","success");
					window.opener.importCallback();
					//window.opener.cui("#ViewGrid").loadData();
					closeWin();
				}else {
					window.cui.message("导入视图出错，请联系管理员。");
				}
				cui.handleMask.hide();
			});
		}, 100);
	}
	
	//取消
	function closeWin() {
		window.top.close();
	}

	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) -90;
	}
 </script>
</body>
</html>