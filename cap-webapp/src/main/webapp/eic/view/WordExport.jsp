<!DOCTYPE html>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/eic/view/I18n.jsp" %>
<html>
	<head>
		<title><fmt:message key="importExcel" /></title>
		<meta http-equiv="Content-Type" content="text/html charset=gbk">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/eic/css/eic.css">
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
		<script language="javascript">
		    var _pt = window.top.cuiEMDialog.wins.wordExportDialog;
		    var userId="<%=request.getParameter("userId")%>";
		    var wordId="<%=request.getParameter("wordId")%>";
		    var asyn="<%=request.getParameter("asyn")%>";
		    var param = "<%=request.getParameter("exparam")%>";
		    var webRoot = "<%=request.getParameter("webroot")%>";
		    var sysName = "<%=request.getParameter("sysname")%>";
		    var fileName = "<%=request.getParameter("fileName")%>";
		    var currDate = new Date();

		    if (sysName && !startWith(sysName, "/")) {
				sysName = "/" + sysName;
			}

		    function startWith(str, fix) {
				return str.substring(0, 1) == fix;
			}
		    
		    var params = {
				asyn: asyn,
				userId: userId,
				wordId: wordId,
				param: param,
				actionType: "exportWord",
				sysName: sysName,
				fileName: fileName,
				time: currDate.getTime()
			}

		    function exportWord() {
				$.ajax({
					type: "POST",
					dataType: "JSON",
					url: webRoot + sysName + "/eic/eic.wordExport",
					data: params,
					success: function(data) {
						if (data.result != "true") {
							//导出失败
							window._pt.wordExportDialog.setTitle("<fmt:message key="wordDownloadFailed" />");
							$("#eic_wordexport_error_tip").css({
								display: "block"
							});
							$("#eic_wordexport_progress").css({
								display: "none"
							});
							$(".note").text(data.error);
						} else if (data.type == "asyn") {
							//导出成功，异步导出
							window._pt.wordExportDialog.hide();
							window._pt.openTaskMonitorList(webRoot + data.path);
						} else {
							//导出成功，同步导出，直接发送下载文件的请求
							var tempFileName = data.fileName;
							doDownloadWord(tempFileName);
						}
					}
				});
			}

			function doDownloadWord(tempFileName) {
				tempFileName = encodeURIComponent(encodeURIComponent(tempFileName));
				if(fileName){
					fileName = encodeURIComponent(encodeURIComponent(fileName));
				}
				var url = webRoot + sysName + "/eic/eic.wordExport?actionType=download&sysName=" + sysName + "&filePath=" + tempFileName + "&fileName=" + tempFileName;
				var date = new Date();
				url += "&time=" + date.getTime();
				var exportFrame = document.getElementById("exportWordFrame");
				exportFrame.src = url;
				window._pt.wordExportDialog.hide();
			}

			function doCancel() {
				window._pt.wordExportDialog.hide();
			}
		</script>
		<style type="text/css">
			html {
				overflow: visible;
			}
			
			body {
				margin: 0px;
				font: 12px/1.5 Arial, "宋体", Helvetica, sans-serif;
				background-color: #EFF1F6;
			}

			.header_wrap {
				border-top: 1px solid #BFCFDA;
				padding: 5px 0 0 0;
				height: 25px;
			}

			.thw_operate {
				float: right;
				padding: 0 6px;
			}
			
			.content_wrap {
				padding: 12px 12px 0 12px;
				height: 105px;
				background-color: #FFFFFF;
			}
			
			.note {
				font-size: 12px;
				font-family: "宋体", Arial, Sans;
				color: #333;
				word-wrap: break-word;
				margin-left: 35px;
				margin-top: -25px;
			}
			
			.icon{
				width : 30px;
				height: 30px;
				margin-top: 10px;
				background: url(../images/c-icon-1.png) no-repeat 0 -180px;
			}
		</style>
	</head>
	<body onload="exportWord();">
		<div class="content_wrap">
			<div id="eic_wordexport_progress" style="vertical-align: center;text-align: center;">
				<img style="vertical-align: middle;margin-top: 30px;height: 10px;width: 200px;" src="../images/progress_handling.gif" />
				<div style="padding-top:5px;">
					<fmt:message key="exportWait" />
				</div>
			</div>
			<div style=" padding: 0;margin: 0;display: none;" id="eic_wordexport_error_tip">
				<div class="icon"></div><div class="note">&nbsp;&nbsp;</div>
			</div>
		</div>
		<div class="header_wrap">
			<div class="thw_operate">
				<a type="button" name="cancelBtn" id="cancelBtn" class="button_top"  onclick="doCancel();" >&nbsp;<fmt:message key="confirm" />&nbsp;</a>
			</div>
		</div>
		<iframe id="exportWordFrame" style="display: none;" src=""></iframe>
	</body>
</html>