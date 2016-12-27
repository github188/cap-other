<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/eic" prefix="eic"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>���ܲ���ҳ��</title>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/eic/css/eic.css"></link>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/eic/cui/themes/default/css/comtop.ui.min.css" />
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/cui/js/comtop.ui.min.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/comtop.eic.js"></script>
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/comtop.ui.emDialog.js"></script>
		<!--<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/comtop.eic.test.js"></script>-->
		<script type="text/javascript">
			function testClick() {
				var params = {"userId": "wuxiaobing", "wordId": "wordExport", "sysName": "/top", "webRoot": "/web"};
				iWordExport(params);
			}
		</script>
	</head>
	<body>
	
 	<script type="text/javascript">
 	/**
 		����callback����ֵΪ���������ַ���"a"
	*/
		function a(status){
			console.log(status);
			if(status === "onAsynSuccess"){
				console.log("�첽���");
			}
			if(status === "onAsynError"){
				console.log("�첽����");
			}
			if(status === "onSuccess"){
				console.log("ͬ���ɹ�");
			}
			if(status === "onAsyn"){
				console.log("�ɹ����첽����������");
			}
			if(status === "onFail"){
				console.log("����ʧ��");
			}
			if(status === "onError"){
				console.log("����ʧ��");
			}
			if(status === "onClose"){
				console.log("��ʾ���ڹر�");
			}
		}
	/**
		����callback����ֵΪ����ִ���ַ���"b()"---��
	*/
		function b(){
			alert('b');
		}
 	</script>
	
	<h2>Excel���밴ť</h2>
	<eic:excelImport id="excelImport" asyn="true" callback="a" userId="wuxiaobing" excelId="userImportTest" buttonName="���ܲ��Ե���" style="button_top" showDownloadBtn="true" />
	<eic:excelImport id="excelImportTest2" userId="wuxiaobing" excelId="transSupportTest" buttonName="���ܲ��Ե���(����֧��)" style="button_top" showDownloadBtn="false" />
	<eic:excelImport id="excelImportTest3" asyn="true"  userId="wu-xiaobing" excelId="performaceTest" buttonName="���ܲ��Ե���(�첽)" style="button_top" showDownloadBtn="false" />
	<hr></hr>
	
	<h2>Excel������ť</h2>
	<h3>List-Normal</h3>
	01.<eic:excelExport id="bigDataTest01"  userId="wuxiaobing" buttonName="List����(5000��/20��/03ģ��)" asyn="true" excelId="bigDataTest01" param="111" exportType="normal" style="button_top" />
	02.<eic:excelExport id="bigDataTest02"  userId="wuxiaobing" buttonName="List����(5000��/20��/07ģ��)" excelId="bigDataTest02" param="111" exportType="normal" style="button_top" />
	03.<eic:excelExport id="bigDataTest03"  userId="wuxiaobing" buttonName="List����(20W��/20��/03ģ��)" excelId="bigDataTest03" param="111" exportType="normal" style="button_top" />
	04.<eic:excelExport id="bigDataTest04"  userId="wuxiaobing" buttonName="List����(20W��/20��/07ģ��)" excelId="bigDataTest04" param="111" exportType="normal" style="button_top" /><br><br>
	05.<eic:excelExport id="bigDataTest05"  userId="wuxiaobing" buttonName="List����(20W��/20��/03ģ��/��ת���ַ�)" excelId="bigDataTest05" param="111" exportType="normal" style="button_top" />
	06.<eic:excelExport id="bigDataTest06"  userId="wuxiaobing" buttonName="List����(20W��/20��/07ģ��/��ת���ַ�)" excelId="bigDataTest06" param="111" exportType="normal" style="button_top" /><br><br>
	07.<eic:excelExport id="bigDataTest07"  userId="wuxiaobing" buttonName="List����(5000��/20��/03ģ��/��������չ)" excelId="bigDataTest07" param="111" exportType="normal" style="button_top" />
	08.<eic:excelExport id="bigDataTest08"  userId="wuxiaobing" buttonName="List����(5000��/20��/07ģ��/��������չ)" excelId="bigDataTest08" param="111" exportType="normal" style="button_top" />
	09.<eic:excelExport id="bigDataTest09"  userId="wuxiaobing" buttonName="List����(1W��/20��/03ģ��/����������չ)" excelId="bigDataTest09" param="111" exportType="normal" style="button_top" />
	10.<eic:excelExport id="bigDataTest10"  userId="wuxiaobing" buttonName="List����(1W��/20��/07ģ��/����������չ)" excelId="bigDataTest10" param="111" exportType="normal" style="button_top" /><br><br>
	11.<eic:excelExport id="bigDataTest11"  userId="wuxiaobing" buttonName="List����(100��/20��/03ģ��/��Ƕ��ѭ��)" excelId="bigDataTest11" param="111" exportType="normal" style="button_top" />
	12.<eic:excelExport id="bigDataTest12"  userId="wuxiaobing" buttonName="List����(100��/20��/07ģ��/��Ƕ��ѭ��)" excelId="bigDataTest12" param="111" exportType="normal" style="button_top" />
	13.<eic:excelExport id="bigDataTest13"  userId="wuxiaobing" buttonName="List����(20W��/20��/03ģ��/�����ᴰ��)" excelId="bigDataTest13" param="111" exportType="normal" style="button_top" />
	14.<eic:excelExport id="bigDataTest14"  userId="wuxiaobing" buttonName="List����(20W��/20��/07ģ��/�����ᴰ��)" excelId="bigDataTest14" param="111" exportType="normal" style="button_top" /><br><br>
    15.<eic:excelExport id="bigDataTest15"  userId="wuxiaobing" buttonName="List����(ģ���sheetҳ����)" excelId="bigDataTest15" param="111" exportType="normal" style="button_top" /><br><br>
    16.<eic:excelExport id="bigDataTest16"  userId="wuxiaobing" buttonName="List����(ICustomProcessor)" excelId="bigDataTest16" param="111testtestesareawr" exportType="normal" style="button_top" /><br><br>
	<h3>List-Merge</h3>
	01.<eic:excelExport id="bigDataTestMergedCell01"  userId="wuxiaobing" buttonName="List�ϲ���Ԫ�񵼳�(5W��/10��/03ģ��)" param="111" excelId="bigDataTestMergedCell01" exportType="normal" style="button_top" />
	02.<eic:excelExport id="bigDataTestMergedCell02"  userId="wuxiaobing" buttonName="List�ϲ���Ԫ�񵼳�(5W��/10��/07ģ��)" param="111" excelId="bigDataTestMergedCell02" exportType="normal" style="button_top" />
	03.<eic:excelExport id="bigDataTestMergedCell03"  userId="wuxiaobing" buttonName="List�ϲ���Ԫ�񵼳�(5W��/10��/03ģ��/��ת���ַ�)" param="111" excelId="bigDataTestMergedCell03" exportType="normal" style="button_top" />
	04.<eic:excelExport id="bigDataTestMergedCell04"  userId="wuxiaobing" buttonName="List�ϲ���Ԫ�񵼳�(5W��/10��/07ģ��/��ת���ַ�)" param="111" excelId="bigDataTestMergedCell04" exportType="normal" style="button_top" /><br><br>
	
	<h3>List-WithoutTemplate</h3>
	01.<eic:excelExport id="withoutTemplate01"  userId="wuxiaobing" buttonName="��ģ�嵼��(1W��/20��)" excelId="withoutTemplate01" param="111" exportType="normal" style="button_top" /><br><br>
	02.<eic:excelExport id="withoutTemplate02"  userId="wuxiaobing" buttonName="��ģ���Զ�����ʽ����(1W��/20��)" excelId="withoutTemplate02" param="111" exportType="normal" style="button_top" /><br><br>
	
	<h3>Report</h3>
	01.<eic:excelExport id="reportTest01"  userId="wuxiaobing" buttonName="Report����(200��/20��/03ģ��/��ת���ַ�)" excelId="reportTest01" param="111" exportType="normal" style="button_top" />
	02.<eic:excelExport id="reportTest02"  userId="wuxiaobing" buttonName="Report����(200��/20��/07ģ��/��ת���ַ�)" excelId="reportTest02" param="111" exportType="normal" style="button_top" />
	03.<eic:excelExport id="reportTest03"  userId="wuxiaobing" buttonName="Report����(200��/20��/03ģ��/���ϲ���Ԫ��)" excelId="reportTest03" param="111" exportType="normal" style="button_top" />
	04.<eic:excelExport id="reportTest04"  userId="wuxiaobing" buttonName="Report����(200��/20��/07ģ��/���ϲ���Ԫ��)" excelId="reportTest04" param="111" exportType="normal" style="button_top" /><br><br>
	
	
	<h3>Dyan</h3>
	<eic:excelExport id="userExportReport"  userId="wuxiaobing" buttonName="��̬�е��� " excelId="dyanTest" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport5"  userId="wuxiaobing" buttonName="��̬�е���(07ģ��) " excelId="dyanTest07" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport"  userId="wuxiaobing" buttonName="��̬�е���(ͬ��) " excelId="dyanTestMinData" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport3"  userId="wuxiaobing" buttonName="��̬�е���(��ģ���ȡ����) " excelId="dyanTestYeTempLate" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport2"  userId="wuxiaobing" buttonName="��̬�е���(��ģ��) " excelId="dyanTestNoTempLate" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport4"  userId="wuxiaobing" buttonName="���ж�̬�е���(��ģ���ȡ����) " excelId="dyanTestOneYeTempLate" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport6"  userId="wuxiaobing" buttonName="���ж�̬�е���(��ģ���ȡ����07ģ��)" excelId="dyanTestOneYeTempLate07" param="111" exportType="dyan" style="button_top" />
	<hr></hr>
	<h2 id="ttttt">Word������ť</h2>
	<eic:wordExport id="wordExportTest1" userId="wuxiaobing" wordId="wordExport" buttonName="&nbsp;��ͨWord����&nbsp;" sysName="/top"/>
	<eic:wordExport id="wordExportTest2" userId="wuxiaobing" wordId="wordExportExcel" buttonName="&nbsp;Excel���Ƕ�뵼��&nbsp;"/>
	<eic:wordExport id="wordExportTest4" wordId="wordExportXml" userId="wuxiaobing" buttonName="&nbsp;XMLģ�嵼��&nbsp;" />
	<eic:wordExport id="wordExportTest3" userId="wuxiaobing" wordId="wordExportAysn" buttonName="&nbsp;�첽����&nbsp;" sysName="/top" asyn="true"/>
	<eic:wordExport id="wordExportTest5" wordId="wordExportBigDataXml" userId="wuxiaobing" buttonName="&nbsp;wordģ�嵼��(1M������)&nbsp;"/>
	<input type="button" value="&nbsp;�����ť&nbsp;" class="button_top" onclick="testClick();"/>


	</body>
	
	
</html>