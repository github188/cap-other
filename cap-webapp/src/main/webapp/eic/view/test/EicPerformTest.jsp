<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
	pageEncoding="GBK"%>
<%@ taglib uri="http://www.szcomtop.com/eic" prefix="eic"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<title>性能测试页面</title>
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
 		测试callback传入值为方法名的字符串"a"
	*/
		function a(status){
			console.log(status);
			if(status === "onAsynSuccess"){
				console.log("异步完成");
			}
			if(status === "onAsynError"){
				console.log("异步出错");
			}
			if(status === "onSuccess"){
				console.log("同步成功");
			}
			if(status === "onAsyn"){
				console.log("成功将异步任务放入队列");
			}
			if(status === "onFail"){
				console.log("导入失败");
			}
			if(status === "onError"){
				console.log("操作失败");
			}
			if(status === "onClose"){
				console.log("提示窗口关闭");
			}
		}
	/**
		测试callback传入值为方法执行字符串"b()"---旧
	*/
		function b(){
			alert('b');
		}
 	</script>
	
	<h2>Excel导入按钮</h2>
	<eic:excelImport id="excelImport" asyn="true" callback="a" userId="wuxiaobing" excelId="userImportTest" buttonName="性能测试导入" style="button_top" showDownloadBtn="true" />
	<eic:excelImport id="excelImportTest2" userId="wuxiaobing" excelId="transSupportTest" buttonName="性能测试导入(事务支持)" style="button_top" showDownloadBtn="false" />
	<eic:excelImport id="excelImportTest3" asyn="true"  userId="wu-xiaobing" excelId="performaceTest" buttonName="性能测试导入(异步)" style="button_top" showDownloadBtn="false" />
	<hr></hr>
	
	<h2>Excel导出按钮</h2>
	<h3>List-Normal</h3>
	01.<eic:excelExport id="bigDataTest01"  userId="wuxiaobing" buttonName="List导出(5000条/20列/03模板)" asyn="true" excelId="bigDataTest01" param="111" exportType="normal" style="button_top" />
	02.<eic:excelExport id="bigDataTest02"  userId="wuxiaobing" buttonName="List导出(5000条/20列/07模板)" excelId="bigDataTest02" param="111" exportType="normal" style="button_top" />
	03.<eic:excelExport id="bigDataTest03"  userId="wuxiaobing" buttonName="List导出(20W条/20列/03模板)" excelId="bigDataTest03" param="111" exportType="normal" style="button_top" />
	04.<eic:excelExport id="bigDataTest04"  userId="wuxiaobing" buttonName="List导出(20W条/20列/07模板)" excelId="bigDataTest04" param="111" exportType="normal" style="button_top" /><br><br>
	05.<eic:excelExport id="bigDataTest05"  userId="wuxiaobing" buttonName="List导出(20W条/20列/03模板/含转换字符)" excelId="bigDataTest05" param="111" exportType="normal" style="button_top" />
	06.<eic:excelExport id="bigDataTest06"  userId="wuxiaobing" buttonName="List导出(20W条/20列/07模板/含转换字符)" excelId="bigDataTest06" param="111" exportType="normal" style="button_top" /><br><br>
	07.<eic:excelExport id="bigDataTest07"  userId="wuxiaobing" buttonName="List导出(5000条/20列/03模板/含横向扩展)" excelId="bigDataTest07" param="111" exportType="normal" style="button_top" />
	08.<eic:excelExport id="bigDataTest08"  userId="wuxiaobing" buttonName="List导出(5000条/20列/07模板/含横向扩展)" excelId="bigDataTest08" param="111" exportType="normal" style="button_top" />
	09.<eic:excelExport id="bigDataTest09"  userId="wuxiaobing" buttonName="List导出(1W条/20列/03模板/含横纵向扩展)" excelId="bigDataTest09" param="111" exportType="normal" style="button_top" />
	10.<eic:excelExport id="bigDataTest10"  userId="wuxiaobing" buttonName="List导出(1W条/20列/07模板/含横纵向扩展)" excelId="bigDataTest10" param="111" exportType="normal" style="button_top" /><br><br>
	11.<eic:excelExport id="bigDataTest11"  userId="wuxiaobing" buttonName="List导出(100条/20列/03模板/含嵌套循环)" excelId="bigDataTest11" param="111" exportType="normal" style="button_top" />
	12.<eic:excelExport id="bigDataTest12"  userId="wuxiaobing" buttonName="List导出(100条/20列/07模板/含嵌套循环)" excelId="bigDataTest12" param="111" exportType="normal" style="button_top" />
	13.<eic:excelExport id="bigDataTest13"  userId="wuxiaobing" buttonName="List导出(20W条/20列/03模板/含冻结窗口)" excelId="bigDataTest13" param="111" exportType="normal" style="button_top" />
	14.<eic:excelExport id="bigDataTest14"  userId="wuxiaobing" buttonName="List导出(20W条/20列/07模板/含冻结窗口)" excelId="bigDataTest14" param="111" exportType="normal" style="button_top" /><br><br>
    15.<eic:excelExport id="bigDataTest15"  userId="wuxiaobing" buttonName="List导出(模板多sheet页导出)" excelId="bigDataTest15" param="111" exportType="normal" style="button_top" /><br><br>
    16.<eic:excelExport id="bigDataTest16"  userId="wuxiaobing" buttonName="List导出(ICustomProcessor)" excelId="bigDataTest16" param="111testtestesareawr" exportType="normal" style="button_top" /><br><br>
	<h3>List-Merge</h3>
	01.<eic:excelExport id="bigDataTestMergedCell01"  userId="wuxiaobing" buttonName="List合并单元格导出(5W条/10列/03模板)" param="111" excelId="bigDataTestMergedCell01" exportType="normal" style="button_top" />
	02.<eic:excelExport id="bigDataTestMergedCell02"  userId="wuxiaobing" buttonName="List合并单元格导出(5W条/10列/07模板)" param="111" excelId="bigDataTestMergedCell02" exportType="normal" style="button_top" />
	03.<eic:excelExport id="bigDataTestMergedCell03"  userId="wuxiaobing" buttonName="List合并单元格导出(5W条/10列/03模板/含转换字符)" param="111" excelId="bigDataTestMergedCell03" exportType="normal" style="button_top" />
	04.<eic:excelExport id="bigDataTestMergedCell04"  userId="wuxiaobing" buttonName="List合并单元格导出(5W条/10列/07模板/含转换字符)" param="111" excelId="bigDataTestMergedCell04" exportType="normal" style="button_top" /><br><br>
	
	<h3>List-WithoutTemplate</h3>
	01.<eic:excelExport id="withoutTemplate01"  userId="wuxiaobing" buttonName="无模板导出(1W条/20列)" excelId="withoutTemplate01" param="111" exportType="normal" style="button_top" /><br><br>
	02.<eic:excelExport id="withoutTemplate02"  userId="wuxiaobing" buttonName="无模板自定义样式导出(1W条/20列)" excelId="withoutTemplate02" param="111" exportType="normal" style="button_top" /><br><br>
	
	<h3>Report</h3>
	01.<eic:excelExport id="reportTest01"  userId="wuxiaobing" buttonName="Report导出(200条/20列/03模板/含转换字符)" excelId="reportTest01" param="111" exportType="normal" style="button_top" />
	02.<eic:excelExport id="reportTest02"  userId="wuxiaobing" buttonName="Report导出(200条/20列/07模板/含转换字符)" excelId="reportTest02" param="111" exportType="normal" style="button_top" />
	03.<eic:excelExport id="reportTest03"  userId="wuxiaobing" buttonName="Report导出(200条/20列/03模板/含合并单元格)" excelId="reportTest03" param="111" exportType="normal" style="button_top" />
	04.<eic:excelExport id="reportTest04"  userId="wuxiaobing" buttonName="Report导出(200条/20列/07模板/含合并单元格)" excelId="reportTest04" param="111" exportType="normal" style="button_top" /><br><br>
	
	
	<h3>Dyan</h3>
	<eic:excelExport id="userExportReport"  userId="wuxiaobing" buttonName="动态列导出 " excelId="dyanTest" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport5"  userId="wuxiaobing" buttonName="动态列导出(07模板) " excelId="dyanTest07" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport"  userId="wuxiaobing" buttonName="动态列导出(同步) " excelId="dyanTestMinData" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport3"  userId="wuxiaobing" buttonName="动态列导出(从模板获取数据) " excelId="dyanTestYeTempLate" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport2"  userId="wuxiaobing" buttonName="动态列导出(无模板) " excelId="dyanTestNoTempLate" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport4"  userId="wuxiaobing" buttonName="单列动态列导出(从模板获取数据) " excelId="dyanTestOneYeTempLate" param="111" exportType="dyan" style="button_top" />
	<eic:excelExport id="userExportReport6"  userId="wuxiaobing" buttonName="单列动态列导出(从模板获取数据07模板)" excelId="dyanTestOneYeTempLate07" param="111" exportType="dyan" style="button_top" />
	<hr></hr>
	<h2 id="ttttt">Word导出按钮</h2>
	<eic:wordExport id="wordExportTest1" userId="wuxiaobing" wordId="wordExport" buttonName="&nbsp;普通Word导出&nbsp;" sysName="/top"/>
	<eic:wordExport id="wordExportTest2" userId="wuxiaobing" wordId="wordExportExcel" buttonName="&nbsp;Excel表格嵌入导出&nbsp;"/>
	<eic:wordExport id="wordExportTest4" wordId="wordExportXml" userId="wuxiaobing" buttonName="&nbsp;XML模板导出&nbsp;" />
	<eic:wordExport id="wordExportTest3" userId="wuxiaobing" wordId="wordExportAysn" buttonName="&nbsp;异步导出&nbsp;" sysName="/top" asyn="true"/>
	<eic:wordExport id="wordExportTest5" wordId="wordExportBigDataXml" userId="wuxiaobing" buttonName="&nbsp;word模板导出(1M数据量)&nbsp;"/>
	<input type="button" value="&nbsp;点击按钮&nbsp;" class="button_top" onclick="testClick();"/>


	</body>
	
	
</html>