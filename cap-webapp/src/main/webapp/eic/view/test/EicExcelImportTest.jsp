<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/eic" prefix="eic"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>word��������ҳ��</title>
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
	<h2>Excel���밴ť</h2>
	<eic:excelImport id="excelImportTest1" excelId="excelImportValidator_required" userId="wuxiaobing" style="button_top" param="test" />
	<eic:excelImport id="����&&��ڴ�ڵĿ϶�skajljasdfjasdjfksadlfjlk" param="{'name':'wuxiaobing','sex':'��'}" excelId="excelImportValidator_required" userId="wuxiaobing" style="button_top" />
	<eic:excelImport excelId="excelImportValidator_required" userId="wuxiaobing" asyn="true" buttonName="&nbsp;����asyn����&nbsp;" style="button_top" />
	<eic:excelImport excelId="excelImportValidator_required" userId="wuxiaobing" showDownloadBtn="true" downloadBtnName="&nbsp;���ذ�ť����&nbsp;" buttonName="&nbsp;����buttonName����&nbsp;" style="button_top" />
	<eic:excelImport excelId="excelImportValidator_required" callback="doCallBack();" userId="wuxiaobing" buttonName="&nbsp;�ص���������&nbsp;" style="button_top" />
	<eic:excelImport excelId="��С��" userId="wuxiaobing" buttonName="&nbsp;ExcelId���Ĳ���&nbsp;" style="button_top" />
	<eic:excelImport excelId="performaceTest" userId="wuxiaobing" buttonName="&nbsp;���ڸ�ʽ����&nbsp;" style="button_top" />
	<br/>
	<br/>
	<hr></hr>
	</body>
	
	
</html>