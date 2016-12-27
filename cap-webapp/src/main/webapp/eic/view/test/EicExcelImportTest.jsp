<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/eic" prefix="eic"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>word导出测试页面</title>
		<link rel="stylesheet" type="text/css" href="/web/eic/css/eic.css"></link>
		<link rel="stylesheet" type="text/css"
			href="/web/eic/cui/themes/default/css/comtop.ui.min.css" />
		<script type="text/javascript" src="/web/eic/cui/js/comtop.ui.min.js"></script>
		<script type="text/javascript" src="/web/eic/js/comtop.eic.js"></script>
		<script type="text/javascript">
			function testClick() {
				var params = {"userId": "wuxiaobing", "wordId": "wordExport", "sysName": "/top", "webRoot": "/web"};
				iWordExport(params);
			}

			function doCallBack() {
				alert("asdfsadf");
			}
		</script>
	</head>
	<body>
	<h2>Excel导入按钮</h2>
	<eic:excelImport id="excelImportTest1" excelId="excelImportValidator_required" userId="wuxiaobing" style="button_top" param="test" />
	<eic:excelImport id="忠文&&大口大口的肯定skajljasdfjasdjfksadlfjlk" param="{'name':'wuxiaobing','sex':'男'}" excelId="excelImportValidator_required" userId="wuxiaobing" style="button_top" />
	<eic:excelImport excelId="excelImportValidator_required" userId="wuxiaobing" asyn="true" buttonName="&nbsp;测试asyn属性&nbsp;" style="button_top" />
	<eic:excelImport excelId="excelImportValidator_required" userId="wuxiaobing" showDownloadBtn="true" downloadBtnName="&nbsp;下载按钮测试&nbsp;" buttonName="&nbsp;测试buttonName属性&nbsp;" style="button_top" />
	<eic:excelImport excelId="excelImportValidator_required" callback="doCallBack();" userId="wuxiaobing" buttonName="&nbsp;回调函数测试&nbsp;" style="button_top" />
	<eic:excelImport excelId="吴小兵" userId="wuxiaobing" buttonName="&nbsp;ExcelId中文测试&nbsp;" style="button_top" />
	<eic:excelImport excelId="performaceTest" userId="wuxiaobing" buttonName="&nbsp;日期格式测试&nbsp;" style="button_top" />
	<br/>
	<br/>
	<hr></hr>
	</body>
	
	
</html>