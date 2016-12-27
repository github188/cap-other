<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/eic" prefix="eic"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>导入导出组件测试页面</title>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/eic/css/eic.css"></link>
		<link rel="stylesheet" type="text/css"
			href="<%=request.getContextPath()%>/eic/cui/themes/default/css/comtop.ui.min.css" />
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/cui/js/comtop.ui.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/comtop.eic.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
		<script type="text/javascript">
			function onWordExportPropertyChange() {
				var wordExportId = $("#wordExportId").val();
				var wordExportWordId = $("#wordExportWordId").val();
				var wordExportStyle = $("#wordExportStyle").val();
				var wordExportParam = $("#wordExportParam").val();
				var wordExportHide = $("#wordExportHide").val();
				var wordExportTextName = $("#wordExportButtonName").val();
				var wordExportIcon = $("#wordExportIcon").val();
				var wordExportAsyn = $("#wordExportAsyn").val();

				var parameter = "?id=" + wordExportId + "&userId=wuxiaobing&wordId=" + wordExportWordId + "&style=" + 
					wordExportStyle + "&icon=" + wordExportIcon + "&param=" + wordExportParam + "&hide=" + 
					wordExportHide + "&buttonName=" + wordExportTextName + "&asyn=" + wordExportAsyn;
				var date = new Date();
				parameter += "&time=" + date.getTime();
				
				window.open("WordExportTest.jsp" + parameter);
			}

			function onExcelImportPropertyChange() {
				var excelImportId = $("#excelImportId").val();
				var excelImportExcelId = encodeURIComponent(encodeURIComponent($("#excelImportExcelId").val()));
				var excelImportParam = encodeURIComponent(encodeURIComponent($("#excelImportParam").val()));
				var excelImportShowDownloadBtn = $("#excelImportShowDownloadBtn").val();
				var excelImportStyle = $("#excelImportStyle").val();
				var excelImportDownloadIcon = $("#excelImportDownloadIcon").val();
				var excelImportHide = $("#excelImportHide").val();
				var excelImportIcon = $("#excelImportIcon").val();
				var excelImportAsyn = $("#excelImportAsyn").val();
				var excelImportCallback=encodeURIComponent(encodeURIComponent($("#excelImportCallback").val()));
				var excelImportButtonName = $("#excelImportButtonName").val();
				var excelImportExcelDownloadBtnName = $("#excelImportExcelDownloadBtnName").val();

				var parameter = "?id=" + excelImportId + "&userId=wuxiaobing&excelId=" + excelImportExcelId + 
					"&param=" + excelImportParam + "&showDownloadBtn=" + excelImportShowDownloadBtn + "&style=" + 
					excelImportStyle + "&downloadIcon=" + excelImportDownloadIcon + "&hide=" + excelImportHide + 
					"&icon=" + excelImportIcon + "&asyn=" + excelImportAsyn+"&callback="+excelImportCallback
					+"&buttonName="+excelImportButtonName+"&downloadBtnName="+excelImportExcelDownloadBtnName;
				
				window.open("ExcelImportTest.jsp" + parameter);
			}
			
			function onExcelExportPropertyChange() {
				var excelExportId = $("#excelExportId").val();
				var excelExportButtonName = $("#excelExportButtonName").val();
				var excelExportExcelId = $("#excelExportExcelId").val();
				var excelExportExportType = $("#excelExportExportType").val();
				var excelExportStyle = $("#excelExportStyle").val();
				var excelExportHide = $("#excelExportHide").val();
				var excelExportParam = $("#excelExportParam").val();
				var excelExportIcon = $("#excelExportIcon").val();
				var excelExportCallback=$("#excelExportCallback").val();

				var parameter = "?id=" + excelExportId + "&userId=wuxiaobing&excelId=" + excelExportExcelId + 
					"&param=" + excelExportParam + "&buttonName=" + excelExportButtonName + "&style=" + 
					excelExportStyle + "&hide=" + excelExportHide + 
					"&icon=" + excelExportIcon + "&exportType=" + excelExportExportType+"&callback="+excelExportCallback;
				
				window.open("ExcelExportTest.jsp" + parameter);
			}
		</script>
		<style type="text/css">
			body {
				margin: 5px;
				font: 12px/1.5 Arial, "宋体", Helvetica, sans-serif;
				color: #333;
			}
			
			.doc-table {
				border-collapse: collapse;
				border-spacing: 0;
				margin-left: 9px;
				width: 98%;
				word-break: break-all;
			}
			input {
			    width: 85%;
			    margin: 0；
			}
		</style>
	</head>
	<body>
		<h3>Excel导入功能</h3>
		<hr />
		<table cellpadding="0" cellspacing="0" border="1px" class="doc-table" >
			<tr>
				<td width="100px" height="40px">&nbsp;id：<br>&nbsp;标签ID</td>
				<td width="200px">&nbsp;<input  id="excelImportId" onchange="onExcelImportPropertyChange();" /></td>
				<td width="100px">&nbsp;excelId：</td>
				<td width="200px">&nbsp;<input id="excelImportExcelId" onchange="onExcelImportPropertyChange();" /></td>
				<td width="100px">&nbsp;param：<br>&nbsp;参数</td>
				<td width="200px">&nbsp;<input id="excelImportParam" onchange="onExcelImportPropertyChange();" /></td>
			</tr>
			<tr>
				<td width="100px" height="40px">&nbsp;showDownloadBtn：<br>&nbsp;显示下载按钮</td>
				<td width="200px">
					&nbsp;<select id="excelImportShowDownloadBtn"  onchange="onExcelImportPropertyChange();">
						<option value="true" selected>true</option>
						<option value="false">false</option>
					</select> 
				</td>
				<td width="100px">&nbsp;style：<br>&nbsp;样式名称</td>
				<td width="200px">&nbsp;<input id="excelImportStyle" onchange="onExcelImportPropertyChange();" value="button_top" /></td>
				<td width="100px">&nbsp;downloadIcon：<br>&nbsp;下载按钮图标(指定图标的路径)</td>
				<td width="200px">&nbsp;<input id="excelImportDownloadIcon" value="<%=request.getContextPath()%>/eic/images/excel.gif" onchange="onExcelImportPropertyChange();" /></td>
			</tr>
			<tr>
				<td width="100px" height="40px">&nbsp;hide：<br>&nbsp;是否隐藏按钮</td>
				<td width="200px">
					&nbsp;<select id="excelImportHide" onchange="onExcelImportPropertyChange();">
						<option value="true">true</option>
						<option value="false" selected>false</option>
					</select> 
				</td>
				<td width="100px">&nbsp;callback:<br>&nbsp;回调函数（javascript函数）</td>
				<td width="200px">&nbsp;<input id="excelImportCallback" value="alert('call back run!')" onchange="onExcelImportPropertyChange();" /></td>
				<td width="100px">&nbsp;icon：<br>&nbsp;导入按钮图标(指定图标的路径)</td>
				<td width="200px">&nbsp;<input id="excelImportIcon" onchange="onExcelImportPropertyChange();" /></td>
			</tr>
			<tr>
				<td width="100px" height="40px">&nbsp;asyn：<br>&nbsp;是否异步执行(只有true生效)</td>
				<td width="200px">
					&nbsp;<select id="excelImportAsyn" onchange="onExcelImportPropertyChange();">
						<option value="true">true</option>
						<option value="false" selected>false</option>
					</select>
				</td>
				<td width="100px" height="40px">&nbsp;buttonName：<br>&nbsp;导入按钮名称</td>
				<td width="200px">&nbsp;<input  id="excelImportButtonName" onchange="onExcelImportPropertyChange();" /></td>
				<td width="100px">&nbsp;downloadBtnName：<br>&nbsp;下载按钮名称</td>
				<td width="200px">&nbsp;<input id="excelImportExcelDownloadBtnName" onchange="onExcelImportPropertyChange();" /></td>
			</tr>
			<tr>
				<td height="40px">&nbsp;按钮</td>
				<td colspan="5">
					&nbsp;<input style="width: 100px;" type="button" value="&nbsp;执&nbsp;行&nbsp;" onclick="onExcelImportPropertyChange();" />
				</td>
			</tr>
		</table>
		
		
		<hr/>
		<h3>Excel导出功能</h3>
		<hr/>
		<table cellpadding="0" cellspacing="0" border="1px" class="doc-table">
			<tr>
				<td width="100px" height="40px">&nbsp;id：<br>&nbsp;标签ID</td>
				<td width="200px">&nbsp;<input id="excelExportId" onchange="onExcelExportPropertyChange();" value="testExcelExport"/></td>
				<td width="100px">&nbsp;buttonName：<br>&nbsp;按钮名称</td>
				<td width="200px">&nbsp;<input id="excelExportButtonName" onchange="onExcelExportPropertyChange();" value="excelExport"/></td>
				<td width="100px">&nbsp;param：<br>&nbsp;参数</td>
				<td width="200px">&nbsp;<input id="excelExportParam" onchange="onExcelExportPropertyChange();" /></td>
			</tr>
			<tr>
				<td width="100px" height="40px">&nbsp;excelId：</td>
				<td width="200px">&nbsp;<input id="excelExportExcelId" onchange="onExcelExportPropertyChange();" value="bigDataTest"/></td>
				<td width="100px">&nbsp;exportType：<br>&nbsp;导出类型(正常导出:Normal,动态列导出:Dyan)</td>
				<td width="200px">&nbsp;<input id="excelExportExportType" onchange="onExcelExportPropertyChange();" value="Normal"/></td>
				<td width="100px">&nbsp;style：<br>&nbsp;按钮样式名称</td>
				<td width="200px">&nbsp;<input id="excelExportStyle" value="button_top" onchange="onExcelExportPropertyChange();" /></td>
			</tr>
			<tr>
				<td width="100px" height="40px">&nbsp;hide：<br>&nbsp;隐藏按钮</td>
				<td width="200px">
					&nbsp;<select id="excelExportHide" onchange="onExcelExportPropertyChange('hide', this.value);">
						<option value="true">true</option>
						<option value="false" selected>false</option>
					</select> 
				</td>
				<td width="100px">&nbsp;icon：<br>&nbsp;按钮图标</td>
				<td width="200px">&nbsp;<input id="excelExportIcon" onchange="onExcelExportPropertyChange();" /></td>
			</tr>
			<tr>
				<td height="40px">&nbsp;按钮</td>
				<td colspan="5">
					&nbsp;<input style="width: 100px;" type="button" value="&nbsp;执&nbsp;行&nbsp;" onclick="onExcelExportPropertyChange();" />
				</td>
			</tr>
		</table>
		
		
		<hr />
		<h3>Word导出功能</h3>
		<hr />
		<table cellpadding="0" cellspacing="0" border="1px" class="doc-table">
			<tr>
				<td width="100px" height="40px">&nbsp;id：<br>&nbsp;标签ID</td>
				<td width="200px">&nbsp;<input id="wordExportId" onchange="onWordExportPropertyChange();" value="exportWordTest" /></td>
				<td width="100px">&nbsp;wordId：<br>&nbsp;Word导出配置ID</td>
				<td width="200px">&nbsp;<input id="wordExportWordId" onchange="onWordExportPropertyChange();" value="wordExportTest" /></td>
				<td width="100px">&nbsp;按钮图标：</td>
				<td width="200px">&nbsp;<input id="wordExportIcon" onchange="onWordExportPropertyChange();" value="<%=request.getContextPath()%>/eic/images/excel.gif" /></td>
			</tr>
			<tr>
				<td width="100px" height="40px">&nbsp;asyn：<br>&nbsp;是否异步</td>
				<td width="200px">
					&nbsp;<select id="wordExportAsyn" onchange="onWordExportPropertyChange();">
						<option value="true">true</option>
						<option value="false" selected>false</option>
					</select>
				</td>
				<td width="100px">&nbsp;style：<br>&nbsp;按钮样式</td>
				<td width="200px">&nbsp;<input id="wordExportStyle" onchange="onWordExportPropertyChange();" value="button_top" /></td>
				<td width="100px">&nbsp;param：<br>&nbsp;参数</td>
				<td width="200px">&nbsp;<input id="wordExportParam" onchange="onWordExportPropertyChange();" /></td>
			</tr>
			<tr>
				<td width="100px" height="40px">&nbsp;hide：<br>&nbsp;隐藏按钮</td>
				<td width="200px">
					&nbsp;<select id="wordExportHide" onchange="onWordExportPropertyChange();">
						<option value="true">true</option>
						<option value="false" selected>false</option>
					</select> 
				</td>
				<td width="100px">&nbsp;buttonName：<br>&nbsp;文本名</td>
				<td width="200px">&nbsp;<input id="wordExportButtonName" onchange="onWordExportPropertyChange();" /></td>
				<td width="100px">&nbsp;</td>
				<td width="200px">&nbsp;</td>
			</tr>
			<tr>
				<td height="40px">&nbsp;按钮</td>
				<td colspan="5">
					&nbsp;<input style="width: 100px;" type="button" value="&nbsp;执&nbsp;行&nbsp;" onclick="onWordExportPropertyChange();" />
				</td>
			</tr>
		</table>
	</body>
	
	<script type="text/javascript">
		//onWordExportPropertyChange();
	</script>
</html>