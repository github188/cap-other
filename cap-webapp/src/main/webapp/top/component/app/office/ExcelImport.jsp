<%
/************************************************************************************
 * Excel导入组件选择文件界面
 *
 * @author 陈志伟
 * @history 2009-09-18 陈志伟 新建
 * @history 2011-08-25 阮祥兵 修改
 ************************************************************************************/
%>
<%@ page buffer="10kb" %>
<%@ include file="/top/component/common/Taglibs.jsp" %>
<%@ page contentType="text/html; charset=GBK" %>
<%@ page import="com.comtop.top.component.app.office.excelimport.util.ConfigConstant"%>
<%@ page import="com.comtop.top.component.app.office.excelimport.model.MessageVO"%>
<%
MessageVO objMessageVO=(MessageVO)session.getAttribute(ConfigConstant.REQUEST_OBJECT);
String strConfigName = request.getParameter("configName");
String strExcelId = request.getParameter("excelId");
String strParam = request.getParameter("param");
String strTempFilePath = request.getParameter("tempFilePath");
String messageBar = request.getParameter("messageBar");
String sysName = request.getParameter("sysName");
String callback = request.getParameter("callback");
%>
<html>
	<head>
		<title>导入数据</title>
		<meta http-equiv="Content-Type" content="text/html charset=gbk">
		<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/app/office/excelexport/js/jquery-1.7.2.js'></script>
		<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
		<script language="javascript">
		<!--

			/**
			 * 指定导入操作
			 */
		    function importContent(){
		    	var fileName = document.excelImportForm.filePath.value;
		    	if(fileName==""){
		    		cui.alert("请选择文件。");
		    		return;
		    	}
				var objYesDiv = document.getElementById('yes');
				objYesDiv.style.display = "none";
				var objNoDiv = document.getElementById('no');
				objNoDiv.style.display = "block";
				var sending = document.getElementById('sending');
		    	sending.style.visibility="visible";
		    	var messageBar = document.excelImportForm.messageBar.value;
			    if ( messageBar == "true" ){
			    	//excel上传进度条提示信息
			    	onloadExcelProcessMessage();
			    }
			    var url = getExcelImportAction("importOperate");
			    document.excelImportForm.action=url;
			    document.excelImportForm.submit();
		    }

		    /**
			 * 获取excelImport路径
			 */
			function getExcelImportAction(actionType){
				var webRoot = "${cuiWebRoot}";
				// 分布式子系统路径
				var sysName = document.excelImportForm.sysName.value;
				var url = webRoot + "/" + sysName + "/.topExcelImportServlet";
				url = url + "?actionType=" + actionType;
		        url = url + "&configName=" +  document.excelImportForm.configName.value;
		        url = url + "&excelId=" +  document.excelImportForm.excelId.value;
		        url = url + "&param=" +  document.excelImportForm.param.value;
		        url = url + "&tempFilePath=" +  document.excelImportForm.tempFilePath.value;
		        url = url + "&filePath=" +  document.excelImportForm.filePath.value;
		        url = url + "&messageBar=" +  document.excelImportForm.messageBar.value;
		        url = url + "&sysName=" +  document.excelImportForm.sysName.value;
		        url = url + "&callback=" +  document.excelImportForm.callback.value;
		        return url;
			}

			/**
		    * 获取文件名
		    */
		   function getFileName(){
		     var fileName = document.excelImportForm.filePath.value;
		     var fileExtendName = fileName.substring(fileName.lastIndexOf(".")+1);
		     if(fileExtendName!="xls"){
		     	cui.alert("只支持xls文件类型。");
		     	document.excelImportForm.filePath.value = "";
     			document.excelImportForm.filePath.focus();
     			document.excelImportForm.reset();
		       }
		   }
			/**
		    * 判断Excel是否上传成功，如果元素验证失败，则跳转到NTKO页面
		    */
		    function onloadExcel(){
		    	var objNoDiv = document.getElementById('no');
				objNoDiv.style.display = "none";
				//错误信息
				var errorMessage = "";
				var reload = true;
				//是否显示进度条信息
				var messageBar = document.excelImportForm.messageBar.value;
		   	    <%
			   	    if(objMessageVO!=null){
			   	    %>
			    		if ( messageBar == "true" ){
			   	    		//ajax请求读取excel上传进度条提示信息
			   	    		ajaxReadImportProcessMessage();
			   	    	}
			   	    <%
			   	    	if(objMessageVO.getResult()==ConfigConstant.VALIDATE_FAILURE){
			   	    	    if(objMessageVO.getElementResult()==ConfigConstant.VALIDATE_FAILURE){
				   	    	     %>
						   	    	if(confirm("文件格式/数据错误。确定查看错误信息吗？")){
							   	    	errorMessage = "导入文件格式有误/数据有误，请修改后重新导入。";
							   	    	document.excelImportForm.action = getExcelImportAction("update");
										document.excelImportForm.submit();
										reload = false;
						   	    	}else{
						   	    		closeWindow();
						   	    	}
								<%
			   	    	    }else {
			   	    	     %>
					   	    	errorMessage = "操作失败："+"<%=objMessageVO.getMessage()%>";
					   	    	cui.alert(errorMessage);
					   	    	closeWindow();
							<%
			   	    	    }
			   	    	 session.removeAttribute(ConfigConstant.REQUEST_OBJECT);
					} if(objMessageVO.getResult()==ConfigConstant.VALIDATE_EMPTY_FAILURE){
						%>
						errorMessage = "模板为空，请确认选择的模板是否正确";
						cui.alert(errorMessage);
						closeWindow();
						<%
						session.removeAttribute(ConfigConstant.REQUEST_OBJECT);
					}else {
						//清除session
						session.removeAttribute(ConfigConstant.REQUEST_OBJECT);
						if(objMessageVO.getResult()==0){
					    %>
						    //操作成功提示
						    cui.success("成功导入<%=objMessageVO.getShowSuccessCount()%>条数据.",function(){
						    	 // 需要实现逻辑刷新父窗体内容
					            if(reload){
					            	var callback = document.excelImportForm.callback.value;
					            	if("null" !=callback && callback != null && callback != "" && callback != undefined){
					               		//如果导入成功刷新父页面，并且关闭窗口
					               		eval("window.opener."+callback+"()");
					            	}
					               // 延时关闭该窗体
					               setTimeout("closeWindow()",200);
					            }
						    });
						<%
						}else {
						%>
					            // 需要实现逻辑刷新父窗体内容
					            if(reload){
					            	var callback = document.excelImportForm.callback.value;
					            	if("null" !=callback && callback != null && callback != "" && callback != undefined){
					               		//如果导入成功刷新父页面，并且关闭窗口
					               		eval("window.opener."+callback+"()");
					            	}
					               // 延时关闭该窗体
					               setTimeout("closeWindow()",200);
					            }
		       		 <% }
						}
			  		}%>

			  	if ( messageBar == "true" ){
			  		document.getElementById("errorMessage").innerHTML = errorMessage;
			  	}
			}


			function closeWindow(){
				window.close();
			}

			/*** 以下为添加的进度条代码 by yzg 2012.11.14 **/

			/**
			 * excel上传进度条提示信息
			 */
			function onloadExcelProcessMessage(){
			    document.getElementById("messageBarHandle-operation").innerHTML ="";
				document.getElementById("loadingRecodes").innerHTML = "";
			    document.getElementById("totalRecodes").innerHTML = "";
			    document.getElementById("errorMessage").innerHTML = "";
			    setDisplay("processBar", "none");
				setInterval("ajaxReadImportProcessMessage()", 300);
			}

			/**
			 * ajax请求读取excel上传进度条提示信息
			 */
			function ajaxReadImportProcessMessage(){
				$.ajax({type:"GET",
				url:"${cuiWebRoot}/top/.topExcelImportMessage?actionType=process",
				success:function(data){
					data = eval("("+data+")");
					if ( data.processState == 1 ){
						//显示1.加载数据
						if ( data.totalRecodes > 0 ){
							document.getElementById("messageBarHandle-operation").innerHTML ="1.加载数据"
							document.getElementById("loadingRecodes").innerHTML = data.loadingRecodes+"/";
							document.getElementById("totalRecodes").innerHTML = data.totalRecodes+"条";
						}
						//显示2.验证单元格内容格式
						if ( data.validateFormatRecodes > 0 ){
							document.getElementById("messageBarHandle-operation").innerHTML ="2.验证单元格内容格式"
							document.getElementById("loadingRecodes").innerHTML = data.validateFormatRecodes+"/";
							document.getElementById("totalRecodes").innerHTML = data.totalRecodes+"条";
						}
						//显示3.业务逻辑验证
						if ( data.validateLogicRecodes > 0  ){
							document.getElementById("messageBarHandle-operation").innerHTML ="3.业务逻辑验证"
							document.getElementById("loadingRecodes").innerHTML = data.validateLogicRecodes+"/";
							document.getElementById("totalRecodes").innerHTML = data.totalRecodes+"条";
						}
						//显示4.写入数据库
						if ( data.importOperationState == "1" ){
						   document.getElementById("messageBarHandle-operation").innerHTML ="4.写入数据库 正在处理中"
						   document.getElementById("loadingRecodes").innerHTML = "";
							document.getElementById("totalRecodes").innerHTML = "";
						}
						//显示5.处理完成、处理完的进度条
						if ( data.importOperationState == "2" ){
							document.getElementById("messageBarHandle-operation").innerHTML ="5.处理完成"
							document.getElementById("loadingRecodes").innerHTML = "";
							document.getElementById("totalRecodes").innerHTML = "";
							setDisplay("processBar", "");

						}
					}else{
					 //显示导入准备
					 document.getElementById("messageBarHandle-operation").innerHTML ="准备导入"
					}
				}
				});
			}



			/**
			 * 清除session中的excel进度条提示信息
			 */
			function ajaxDelImportProcessMessage(){
				$.ajax({type:"GET",url:"${cuiWebRoot}/top/.topExcelImportMessage?actionType=del"});
			}

			/**
			 * 设置html对象是否显示
			 * @param objId html对象id
			 * @param display "none"不显示 ""显示
			 */
			function setDisplay(objId, display){
				document.getElementById(objId).style.display = display;
			}

			/**
			 * 关闭窗口
			 */
			function onCloseWindow(){
				if (event.clientX<=0 && event.clientY<=0 ){
					ajaxDelImportProcessMessage();
				}
			}

		//-->
		</script>
		<style type="text/css">
		<!--
		html{
			overflow:visible;
		}
		body {
		background: #FFFFFF;
		font: MessageBox;
		font: Message-Box;
		overflow:hidden;
		font-size: 12px;
		background: none repeat scroll 0 0 #F2F2F2;
		margin: 0px;
		}

		marquee {
		border: 1px solid ButtonShadow;
		background: #F0FFFF;
		height: 12px;
		font-size: 1px;
		margin: 1px;
		width: 290px;
		-moz-binding: url("marquee-binding.xml#marquee");
		-moz-box-sizing: border-box;
		display: block;
		overflow: hidden;
		}

		marquee span {
		height: 8px;
		margin: 1px;
		width: 6px;
		background: #FF4500;
		float: left;
		font-size: 1px;
		}

		.progressBarHandle-0 {
		filter: alpha(opacity=20);
		-moz-opacity: 0.20;
		}

		.progressBarHandle-1 {
		filter: alpha(opacity=40);
		-moz-opacity: 0.40;
		}

		.progressBarHandle-2 {
		filter: alpha(opacity=60);
		-moz-opacity: 0.6;
		}

		.progressBarHandle-3 {
		filter: alpha(opacity=80);
		-moz-opacity: 0.8;
		}

		.progressBarHandle-4 {
		filter: alpha(opacity=100);
		-moz-opacity: 1;
		}


		.progressBarHandle-5 {
		filter: alpha(opacity=100);
		-moz-opacity: 1.2;
		}

		.progressBarHandle-6 {
		filter: alpha(opacity=100);
		-moz-opacity: 1.4;
		}

		.progressBarHandle-7 {
		filter: alpha(opacity=100);
		-moz-opacity: 1.8;
		}
		.progressBarHandle-8 {
		filter: alpha(opacity=100);
		-moz-opacity: 2;
		}
		.progressBarHandle-9 {
		filter: alpha(opacity=100);
		-moz-opacity: 2.2;
		}

		.td_label {
		    background-color: #DFEFFD;
		    border-bottom: 1px solid #BEC2CD;
		    border-right : 1px solid #BEC2CD;
		    line-height: 22px;
		    padding: 2px 5px 2px 3px;
		    text-align: right;
		    width: 200px;
		}


		.form_table {
		    border-left: 1px solid #BEC2CD;
		    border-top: 1px solid #BEC2CD;
		    border-bottom: 1px solid #BEC2CD;
		    border-right : 1px solid #BEC2CD;
		    margin: 0;
		    padding: 0;
		    width: 100%;
		}

		.td_content {
		    background-color: #FFFFFF;
		    border-bottom: 1px solid #BEC2CD;
		    line-height: 18px;
		    padding: 2px 2px 2px 3px;
		}

		//-->
		</style>
	</head>
	<body class="table_tab_bgcolor" onload="onloadExcel()">
		<form name="excelImportForm" method="post" action="${cuiWebRoot}/<c:out value='${param.sysName}/'/>test.topExcelImportServlet" enctype="multipart/form-data">
			<input type="hidden" name="configName" value="<c:out value='${param.configName}'/>"/>
			<input type="hidden" name="excelId" value="<c:out value='${param.excelId}'/>"/>
			<input type="hidden" name="param" value="<c:out value='${param.param}'/>"/>
			<input type="hidden" name="tempFilePath" value="<c:out value='${param.tempFilePath}'/>"/>
			<input type="hidden" name="messageBar" value="<c:out value='${param.messageBar}'/>"/>
			<input type="hidden" name="sysName" value="<c:out value='${param.sysName}'/>"/>
			<input type="hidden" name="callback" value="<c:out value='${param.callback}'/>"/>
			<img width="450" src="${cuiWebRoot}/top/component/app/office/excelexport/images/import.jpg">
			<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
				<tr><td></td></tr>
				<tr>
				<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="6" bgcolor="#FFFFFF">
				 <tr>
					<td class="bg_white" align="center">
					<table width="100%">
						<tr>
							<td width="100%"><b>请选择导入的文件</b></td>
						</tr>
					</table>
					<table class="form_table" cellSpacing="1" cellPadding="5" width="98%" bgcolor="#FFFFFF">
						<tr>
				      		<td width="20%" class="td_label"  style="text-align:right;">导入文件&nbsp;</td>
							<td width="80%" class="td_content" style="align:left;">
				      			<input type="file" name="filePath" size="43" onkeypress="return false;" onchange="getFileName();">
				      		</td>
				    	</tr>
						<tr>
							<td align="center" colspan ="4" bgcolor="#FFFFFF">
					           <div align="center" id="yes">
				      		<input name="Submit2" type="button" class="btn_href" value="&nbsp;确&nbsp;定&nbsp;"  onclick="importContent();"/>
				      		<input name="Submit3" type="button" class="btn_href" value="&nbsp;关&nbsp;闭&nbsp;" onclick="closeWindow();" />
				      	</div>
				      	<div align="center" id="no">
				      		<input name="Submit3" type="button" class="btn_href" value="&nbsp;关&nbsp;闭&nbsp;" onclick="closeWindow();" />
				      	</div>
						   </td>
						</tr>
					</table>
					</td>
				</tr>
			</table>

			<div id="messageDiv" style="font-size:12px;padding-left:11px;background:#FFF;" align="left">
				<span id="messageBarHandle-operation"></span><span id="loadingRecodes"></span><span id="totalRecodes"></span>
				<span id="errorMessage">&nbsp;</span>
			</div>
			<div id="processBar" style="display:none;width:95%;background:6F0;line-height:9px;border: 1px solid ButtonShadow;">&nbsp;</div>

			<div id="sending" align="center" style="z-index:10; visibility:hidden">
				<marquee direction="right" scrollamount="8" scrolldelay="100">
					<span class="progressBarHandle-0"></span>
					<span class="progressBarHandle-1"></span>
					<span class="progressBarHandle-2"></span>
					<span class="progressBarHandle-3"></span>
					<span class="progressBarHandle-4"></span>
					<span class="progressBarHandle-5"></span>
					<span class="progressBarHandle-6"></span>
					<span class="progressBarHandle-7"></span>
					<span class="progressBarHandle-8"></span>
					<span class="progressBarHandle-9"></span>
				</marquee>
			</div>
			</td>
			</tr>
			</table>
		</form>
	</body>
</html>