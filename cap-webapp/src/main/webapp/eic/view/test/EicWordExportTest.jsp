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
		</script>
	</head>
	<body>
	<h2>Word������ť</h2>
	<eic:wordExport id="wordExportTest1" userId="wuxiaobing" buttonName="&&^^%%#@!*&&^^aajslkfjasldjflajsdfjasdfasdfddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" icon="/web/eic/images/min.png" wordId="wordExport" asyn="false" param="{'name':'wuxiaobing', 'age':'26', 'sex':'��'}"/>
	<eic:wordExport id="wordExportTest2" userId="wuxiaobing" wordId="wordExport" asyn="true" buttonName="&nbsp;�첽����&nbsp;"/>
	<eic:wordExport id="wordExportTest3" wordId="wordExportXml" userId="wuxiaobing" buttonName="&nbsp;xmlģ�嵼��&nbsp;" />
	<br/>
	<br/>
	<eic:wordExport id="wordExportTest4" wordId="wordExportXmlExcel" userId="wuxiaobing" buttonName="&nbsp;xmlģ�嵼��(�����������)&nbsp;" />
	<eic:wordExport id="wordExportTest5" wordId="wordExport" userId="wuxiaobing" buttonName="&nbsp;wordģ�嵼��&nbsp;" />
	<eic:wordExport id="wordExportTest6" wordId="wordExportObject" userId="wuxiaobing" buttonName="&nbsp;wordģ�嵼��(��������ͼƬ��Excel����)&nbsp;" />
	<br/>
	<br/>
	<eic:wordExport id="wordExportTest7" wordId="wordExportBigData" userId="wuxiaobing" buttonName="&nbsp;wordģ�嵼��(��������)&nbsp;" asyn="true" />
	<hr></hr>
	</body>
	
	
</html>