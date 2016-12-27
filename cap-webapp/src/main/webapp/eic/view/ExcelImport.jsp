<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=GBK"
pageEncoding="GBK"%>
<%@ include file="/eic/view/I18n.jsp" %>
<html>
	<head>
		<title><fmt:message key="importExcel" /></title>
		<meta http-equiv="Content-Type" content="text/html charset=GBK">
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/eic/css/eic.css">
		<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
		<script language="javascript">
		    var _pt = window.top.cuiEMDialog.wins.importDialog;
			var userId = "<%=request.getParameter("userId")%>";
			var excelId = "<%=request.getParameter("excelId")%>";
			var asyn = "<%=request.getParameter("asyn")%>";
			var param = "<%=request.getParameter("param")%>";
			var callback = "<%= request.getParameter("callback")%>";
			var sysName = "<%=request.getParameter("sysName") %>";
			var webRoot = "<%=request.getContextPath()%>";
			var rex = /^[\s\w]+\s*[(][\w()]*([);]|[\s]*$)/;
			$(document).ready(
				function(){
					window._pt.importDialog.setTitle("<fmt:message key="selectFile" />");
					var url = null;
					if(!sysName){
						url = "<%=request.getContextPath()%>/eic/eic.excelImport?actionType=showMaxRow&excelId="+excelId;
					}else{
						if(sysName.indexOf("/") === 0){
							url = "<%=request.getContextPath()%>"+sysName+"/eic/eic.excelImport?actionType=showMaxRow&excelId="+excelId;
						}else{
							url = "<%=request.getContextPath()%>"+"/"+sysName+"/eic/eic.excelImport?actionType=showMaxRow&excelId="+excelId;
						}
					}
					$.ajax({
						type: "POST",
						url: url,
						success: function(data){
							var maxRow = $("#maxRow")[0];
							maxRow.innerHTML = "当前可导入最大条数："+data+"条";
						}
					});
				}
			);

			/**
			 * 导入
			 */
			function doImportExcel() {
				if(asyn == "true"){
					if(!rex.test(callback) && callback != null){
						var fun = eval("window._pt."+callback);
						if(Object.prototype.toString.call(fun) === "[object Function]"){
							window.top.eic_asynTaskCompleteCallBack(fun);
						}
					}
				}
				var fileValue = $("#file").val();
				if (fileValue == null || fileValue.length == 0) {
					$("#textfield").val("<fmt:message key="selectFileNote" />");
					$("#textfield").addClass('type-file-invalid');
					return;
				}
				var params = "?userId=" + escape(userId) + "&excelId=" + escape(excelId) + "&asyn=" + escape(asyn) + "&actionType=import" + "&param=" + encodeURIComponent(param)+ "&sysName=" +getSubSysName();
				var url = webRoot + getSubSysName() + "/eic/eic.excelImport" + params;
				var form = $('#excelImportForm');
				$(form).attr('action', url);
				$(form).attr('target', 'excelImportIframe');
				try {
					$("#progressing").show();
					$("#progress_overlay").addClass('overlay_show');
					$(form).submit();
					disableBtn(true, $('#importExcelBtn'));
					disableBtn(true, $('#cancelBtn'));
				} catch (e) {
					showUnknownError();
				}
				$('#excelImportIframe').load(excelImportCallback);
			}

			function showUnknownError(){
				$("#import").removeClass("show_wrap");
				$("#import").addClass("hide_wrap");
				$("#result").removeClass("hide_wrap");
				$("#result").addClass("show_wrap");
				$("#result_icon").removeClass();
				$("#result_warning").removeClass();
				$("#result_content").removeClass("content_result_withnote_wrap");
				window._pt.importDialog.setTitle("operation failed");
				$("#result_icon").addClass("msg-box-icon").addClass("msgbox-icon-error");
				$("#result_info").html("<fmt:message key="unkonwnError" />");
				$("#result_warning").addClass("hide_wrap");
			}

			/**
			 * 导入回调
			 */
			function excelImportCallback() {

				$("#progressing").hide();
				$("#progress_overlay").removeClass('overlay_show');
				var event = "unknown";
				try {
					$("#import").removeClass("show_wrap");
					$("#import").addClass("hide_wrap");
					$("#result").removeClass("hide_wrap");
					$("#result").addClass("show_wrap");
					$("#result_icon").removeClass();
					$("#result_warning").removeClass();
					$("#result_content").removeClass("content_result_withnote_wrap");
					var data = getDataFromIFrame();
					if ("SUCCESS" === data.resultType) {
						window._pt.importDialog.setTitle("<fmt:message key="importSuccess" />");
						$("#result_icon").addClass("msg-box-icon").addClass("msgbox-icon-success");
						$("#result_info").text("<<" + data.excelName + ">>  <fmt:message key="importSuccess" />");
						$("#result_warning").addClass("hide_wrap");
						event = "onSuccess";
					} else if ("ASYN" === data.resultType) {
						if (data.asynUrl != null && data.asynUrl != 'null' && data.asynUrl.length > 0) {
							window._pt.openTaskMonitorList(data.asynUrl);
							window._pt.importDialog.hide();
						}
						event = "onAsyn";
					} else if ("FAIL" === data.resultType) {
						window._pt.importDialog.setTitle("<fmt:message key="importFailed" />");
						$("#result_icon").addClass("msg-box-icon").addClass("msgbox-icon-alert");
						$("#result_content").addClass("content_result_withnote_wrap");
						$("#result_info").html("");
						$("#result_info").html("<span style='color:red'>" + data.errorInfo + "</span>" + "<a id='excel_errorFileDownload' href='javascript:void(0)' onclick='doDownloadErrorFile(\"" + decodeURIComponent(data.errorFileName) + "\")' ><fmt:message key="click" /> </a>" + "<fmt:message key="downloadFile" />");
						$("#result_warning").addClass("show_wrap");
						event = "onFail";
					} else if ("ERROR" === data.resultType) {
						window._pt.importDialog.setTitle("<fmt:message key="operationFailed_Title" />");
						$("#result_icon").addClass("msg-box-icon").addClass("msgbox-icon-error");
						$("#result_info").html("");
						$("#result_info").html(data.errorInfo);
						$("#result_warning").addClass("hide_wrap");
						event = "onError";
					}
				} catch (e) {
					event = "onError";
					showUnknownError();
				}
				if(callback!=null && callback!='null' && callback.length>0){
					if(rex.test(callback)){
						eval("window._pt."+callback);
						return;
					}
					var fun = eval("window._pt."+callback);
					if(Object.prototype.toString.call(fun) === "[object Function]"){
						fun(event);
	    			}else{
	    				eval("window._pt."+callback);
	    			}
				}
			}

			/**
			 * 取消
			 */
			function doCancel() {
				window._pt.importDialog.hide();
			}

			function fileChange() {
				var value = $("#file").val();
				if (value != "") {
					$("#textfield").val(value);
					$("#textfield").removeClass("type-file-invalid");
				}
			}

			/**
			 * 返回
			 */
			function doBack() {
				window._pt.importDialog.setTitle("<fmt:message key="selectFile" />");
				$("#result").removeClass("show_wrap");
				$("#result").addClass("hide_wrap");
				$("#import").removeClass("hide_wrap");
				$("#import").addClass("show_wrap");
				disableBtn(false, $('#importExcelBtn'));
				disableBtn(false, $('#cancelBtn'));
				var file = $("#file");
				file.after(file.clone().val(null));
				file.remove();
				$("#textfield").val("<fmt:message key="plsSelectFile" />");
			}

			/**
			 * 获取服务器返回的数据
			 */
			function getDataFromIFrame() {
				var dataIFrame = document.getElementById("excelImportIframe");
				var responseText = dataIFrame.contentWindow.document.getElementById("excelImportResultInfo");
				var text;
				if(!responseText){
					var inner = dataIFrame.contentWindow.document.body.innerHTML;
					var begin = inner.indexOf("{")
					var end = inner.indexOf("}")
					text = inner.substring(begin,end+1).replace("&amp;","&");
				}else{
					text = $(responseText).text();
				}
				return eval("data = " + text);
			}

			/**
			 * 下载错误数据文件
			 */
			function doDownloadErrorFile(errorFileName) {
				var date = new Date();
				var params = "userId=" + escape(userId) + "&excelId=" + escape(excelId) + "&sysName=" + getSubSysName() + "&asyn=" + asyn + "&excelName=" + encodeURIComponent(encodeURIComponent(errorFileName)) + "&actionType=downloadErrorData&time=" + date.getTime();
				var downloadUrl = webRoot + getSubSysName() + "/eic/eic.excelImport?" + params;
				$("#excel_errorFileDownload").attr('target', 'excelImportIframe');
				$("#excel_errorFileDownload").attr("href", downloadUrl);
			}

			/**
			 * 获取子系统
			 */
			function getSubSysName() {
				if (sysName) {
					if (sysName.indexOf("/") === 0) {
						return sysName;
					}
					return "/" + sysName;
				}
				return "";
			}

			/**
			 * 禁用按钮
			 */
			function disableBtn(flag, btn) {
				if (flag) {
					$(btn).attr("disabled", true);
				} else {
					$(btn).attr("disabled", false);
				}
			}

			function onMouseOver(btn) {
				$(btn).addClass('button_hover');
			}

			function onMouseOut(btn) {
				$(btn).removeClass('button_hover ').removeClass('button_active');
			}

			function onMouseDown(btn) {
				$(btn).removeClass('button_active');
				$(btn).addClass('button_hover');
			}

			function onMouseUp(btn) {
				$(btn).addClass('button_active');
			}
		</script>
		<style type="text/css">
			html {
				overflow: visible;
			}

			body {
				margin: 0;
				font: 12px/1.5 Arial, "宋体", Helvetica, sans-serif;
				color: #333;
				background-color: #EFF1F6;
			}

			form {
				margin: 0;
				padding: 0;
				height: 60px;
			}

			.header_wrap {
				border-top: 1px solid #BFCFDA;
				padding: 5px 0 0 0;
				height: 25px;
			}

			.thw_title {
				float: left;
				font: 12px "宋体";
				margin-top: 10px;
				font-weight: bold;
				color: #333;
			}

			.thw_operate {
				float: right;
				padding: 0 6px;
			}

			.content_wrap {
				padding: 12px 12px 0 12px;
				height: 105px;
				color: #333;
				background-color: #FFFFFF;
			}

			.content_result_wrap {
				padding: 12px 12px 0 12px;
				height: 105px;
				background-color: #FFFFFF;
			}

			.content_result_withnote_wrap {
				height: 83px;
			}

			.type-file-box {
				position: relative;
				padding: 25px 0 6px;
				width: 380px;
				height: 24px;
			}

			input {
				line-height: 21px;
				margin: 0;
				padding: 0;
			}

			.type-file-text {
				height: 21px;
				border: 1px solid #cdcdcd;
				width: 295px;
				color: #7E7E7E;
				padding-left: 5px;
			}

			.type-file-invalid {
				color: red;
				border-color: red;
			}

			.type-file-file {
				position: absolute;
				top: 25px;
				left: 0;
				height: 24px;
				filter: alpha(opacity :   0);
				opacity: 0;
				width: 375px;
				cursor: pointer;
			}

			#progressing {
				left: 50%;
				top: 50%;
				margin: -35px 0px 0px -140px;
				position: absolute;
				display: none;
				background: #FFFFFF;
				border: 1px solid #B4B5B6;
				height: 42px;
				width: 250px;
				padding: 5px 0 0 30px;
				z-index: 10002;
			}

			.note {
				font-size: 12px;
				font-family: "宋体", Arial, Sans;
				color: #7E7E7E;
				height: 22px;
				margin-left: -11px;
				position: relative;
				bottom: 0;
			}

			.info {
				font-size: 12px;
				font-family: "宋体", Arial, Sans;
				color: #333;
				word-wrap: break-word;
				margin-left: 35px;
				margin-top: -25px;
			}

			.overlay {
				display: none;
				height: 100%;
				width: 100%;
				background-color: #6d6d6d;
				position: fixed;
				_position: absolute;
				top: 0;
				left: 0;
				z-index: 10001;
			}

			.overlay_show {
				opacity: 0.5;
				display: block;
			}

			.show_wrap {
				display: block;
			}

			.hide_wrap {
				display: none;
			}
		</style>
	</head>
	<body style="height: 100%; width: 100%;">
		<div id="import" class="show_wrap">
			<div class="content_wrap">
				<form id="excelImportForm" method="post" enctype="multipart/form-data">
					<div class="type-file-box">
						<input type="text" name="textfield"
						value="<fmt:message key="plsSelectFile" />" readonly="readonly" id="textfield"
						class="type-file-text">
						<a type="button" name="button"
						id="fileBtn" class="button_top">&nbsp;<fmt:message key="browse" />&nbsp;</a>
						<input
						id="file" name="file" type="file" size="40" onchange="fileChange()"
						accept=".xls,.xlsx,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
						onkeypress="return false;" class="type-file-file"
						onmouseover="onMouseOver($('#fileBtn'))"
						onmouseout="onMouseOut($('#fileBtn'))"
						onmousedown="onMouseDown($('#fileBtn'))"
						onmouseup="onMouseUp($('#fileBtn'))">
					</div>
				</form>
				<div class="note">
					<font id="maxRow" color="red"></font>
				</div>
				<div class="note">
					<fmt:message key="note" />
				</div>
			</div>
			<div class="header_wrap">
				<div class="thw_operate">
					<a type="button" name="importExcelBtn"
					id="importExcelBtn" class="button_top" onclick="doImportExcel()">&nbsp;<fmt:message key="import" />&nbsp;</a>
					<a type="button" name="cancelBtn" id="cancelBtn" class="button_top"
					onclick="doCancel()">&nbsp;<fmt:message key="cancel" />&nbsp;</a>
				</div>
			</div>
			<iframe id="excelImportIframe" name="excelImportIframe"
			style='display: none; width: 0px; height: 0px;' src=""></iframe>
		</div>
		<div id="result" class="hide_wrap">
			<div id="result_content" class="content_result_wrap">
				<div style="padding: 0; margin: 0;">
					<div id="result_icon" class="msg-box-icon msgbox-icon-success"></div>
					<div id="result_info" class="info">
						<fmt:message key="importSuccess" />
					</div>
				</div>
			</div>
			<div id="result_warning" class="hide_wrap">
				<div class="note" style="padding: 0; margin: 0;">
					<fmt:message key="afterDownloadNote" />
				</div>
			</div>
			<div class="header_wrap">
				<div class="thw_operate">
					<a type="button" name="cancelBtn"
					id="cancelBtn" class="button_top" onclick="doCancel()">&nbsp;<fmt:message key="confirm" />&nbsp;</a>
					<a type="button" name="backBtn" id="backBtn" class="button_top"
					onclick="doBack()">&nbsp;<fmt:message key="continue" />&nbsp;</a>
				</div>
			</div>
		</div>
		<div id="progress_overlay" class="overlay"></div>
		<div id="progressing">
			<div><img height="15px" width="200px"
				src="../images/progress_handling.gif"
				style="vertical-align: middle; margin-left: 6px" />
			</div>
			<div style="padding-top: 5px; padding-left: 50px;">
				<fmt:message key="wait" />
			</div>
		</div>
	</body>
</html>