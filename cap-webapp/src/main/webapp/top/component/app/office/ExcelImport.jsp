<%
/************************************************************************************
 * Excel�������ѡ���ļ�����
 *
 * @author ��־ΰ
 * @history 2009-09-18 ��־ΰ �½�
 * @history 2011-08-25 ����� �޸�
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
		<title>��������</title>
		<meta http-equiv="Content-Type" content="text/html charset=gbk">
		<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/app/office/excelexport/js/jquery-1.7.2.js'></script>
		<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
		<script language="javascript">
		<!--

			/**
			 * ָ���������
			 */
		    function importContent(){
		    	var fileName = document.excelImportForm.filePath.value;
		    	if(fileName==""){
		    		cui.alert("��ѡ���ļ���");
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
			    	//excel�ϴ���������ʾ��Ϣ
			    	onloadExcelProcessMessage();
			    }
			    var url = getExcelImportAction("importOperate");
			    document.excelImportForm.action=url;
			    document.excelImportForm.submit();
		    }

		    /**
			 * ��ȡexcelImport·��
			 */
			function getExcelImportAction(actionType){
				var webRoot = "${cuiWebRoot}";
				// �ֲ�ʽ��ϵͳ·��
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
		    * ��ȡ�ļ���
		    */
		   function getFileName(){
		     var fileName = document.excelImportForm.filePath.value;
		     var fileExtendName = fileName.substring(fileName.lastIndexOf(".")+1);
		     if(fileExtendName!="xls"){
		     	cui.alert("ֻ֧��xls�ļ����͡�");
		     	document.excelImportForm.filePath.value = "";
     			document.excelImportForm.filePath.focus();
     			document.excelImportForm.reset();
		       }
		   }
			/**
		    * �ж�Excel�Ƿ��ϴ��ɹ������Ԫ����֤ʧ�ܣ�����ת��NTKOҳ��
		    */
		    function onloadExcel(){
		    	var objNoDiv = document.getElementById('no');
				objNoDiv.style.display = "none";
				//������Ϣ
				var errorMessage = "";
				var reload = true;
				//�Ƿ���ʾ��������Ϣ
				var messageBar = document.excelImportForm.messageBar.value;
		   	    <%
			   	    if(objMessageVO!=null){
			   	    %>
			    		if ( messageBar == "true" ){
			   	    		//ajax�����ȡexcel�ϴ���������ʾ��Ϣ
			   	    		ajaxReadImportProcessMessage();
			   	    	}
			   	    <%
			   	    	if(objMessageVO.getResult()==ConfigConstant.VALIDATE_FAILURE){
			   	    	    if(objMessageVO.getElementResult()==ConfigConstant.VALIDATE_FAILURE){
				   	    	     %>
						   	    	if(confirm("�ļ���ʽ/���ݴ���ȷ���鿴������Ϣ��")){
							   	    	errorMessage = "�����ļ���ʽ����/�����������޸ĺ����µ��롣";
							   	    	document.excelImportForm.action = getExcelImportAction("update");
										document.excelImportForm.submit();
										reload = false;
						   	    	}else{
						   	    		closeWindow();
						   	    	}
								<%
			   	    	    }else {
			   	    	     %>
					   	    	errorMessage = "����ʧ�ܣ�"+"<%=objMessageVO.getMessage()%>";
					   	    	cui.alert(errorMessage);
					   	    	closeWindow();
							<%
			   	    	    }
			   	    	 session.removeAttribute(ConfigConstant.REQUEST_OBJECT);
					} if(objMessageVO.getResult()==ConfigConstant.VALIDATE_EMPTY_FAILURE){
						%>
						errorMessage = "ģ��Ϊ�գ���ȷ��ѡ���ģ���Ƿ���ȷ";
						cui.alert(errorMessage);
						closeWindow();
						<%
						session.removeAttribute(ConfigConstant.REQUEST_OBJECT);
					}else {
						//���session
						session.removeAttribute(ConfigConstant.REQUEST_OBJECT);
						if(objMessageVO.getResult()==0){
					    %>
						    //�����ɹ���ʾ
						    cui.success("�ɹ�����<%=objMessageVO.getShowSuccessCount()%>������.",function(){
						    	 // ��Ҫʵ���߼�ˢ�¸���������
					            if(reload){
					            	var callback = document.excelImportForm.callback.value;
					            	if("null" !=callback && callback != null && callback != "" && callback != undefined){
					               		//�������ɹ�ˢ�¸�ҳ�棬���ҹرմ���
					               		eval("window.opener."+callback+"()");
					            	}
					               // ��ʱ�رոô���
					               setTimeout("closeWindow()",200);
					            }
						    });
						<%
						}else {
						%>
					            // ��Ҫʵ���߼�ˢ�¸���������
					            if(reload){
					            	var callback = document.excelImportForm.callback.value;
					            	if("null" !=callback && callback != null && callback != "" && callback != undefined){
					               		//�������ɹ�ˢ�¸�ҳ�棬���ҹرմ���
					               		eval("window.opener."+callback+"()");
					            	}
					               // ��ʱ�رոô���
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

			/*** ����Ϊ��ӵĽ��������� by yzg 2012.11.14 **/

			/**
			 * excel�ϴ���������ʾ��Ϣ
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
			 * ajax�����ȡexcel�ϴ���������ʾ��Ϣ
			 */
			function ajaxReadImportProcessMessage(){
				$.ajax({type:"GET",
				url:"${cuiWebRoot}/top/.topExcelImportMessage?actionType=process",
				success:function(data){
					data = eval("("+data+")");
					if ( data.processState == 1 ){
						//��ʾ1.��������
						if ( data.totalRecodes > 0 ){
							document.getElementById("messageBarHandle-operation").innerHTML ="1.��������"
							document.getElementById("loadingRecodes").innerHTML = data.loadingRecodes+"/";
							document.getElementById("totalRecodes").innerHTML = data.totalRecodes+"��";
						}
						//��ʾ2.��֤��Ԫ�����ݸ�ʽ
						if ( data.validateFormatRecodes > 0 ){
							document.getElementById("messageBarHandle-operation").innerHTML ="2.��֤��Ԫ�����ݸ�ʽ"
							document.getElementById("loadingRecodes").innerHTML = data.validateFormatRecodes+"/";
							document.getElementById("totalRecodes").innerHTML = data.totalRecodes+"��";
						}
						//��ʾ3.ҵ���߼���֤
						if ( data.validateLogicRecodes > 0  ){
							document.getElementById("messageBarHandle-operation").innerHTML ="3.ҵ���߼���֤"
							document.getElementById("loadingRecodes").innerHTML = data.validateLogicRecodes+"/";
							document.getElementById("totalRecodes").innerHTML = data.totalRecodes+"��";
						}
						//��ʾ4.д�����ݿ�
						if ( data.importOperationState == "1" ){
						   document.getElementById("messageBarHandle-operation").innerHTML ="4.д�����ݿ� ���ڴ�����"
						   document.getElementById("loadingRecodes").innerHTML = "";
							document.getElementById("totalRecodes").innerHTML = "";
						}
						//��ʾ5.������ɡ�������Ľ�����
						if ( data.importOperationState == "2" ){
							document.getElementById("messageBarHandle-operation").innerHTML ="5.�������"
							document.getElementById("loadingRecodes").innerHTML = "";
							document.getElementById("totalRecodes").innerHTML = "";
							setDisplay("processBar", "");

						}
					}else{
					 //��ʾ����׼��
					 document.getElementById("messageBarHandle-operation").innerHTML ="׼������"
					}
				}
				});
			}



			/**
			 * ���session�е�excel��������ʾ��Ϣ
			 */
			function ajaxDelImportProcessMessage(){
				$.ajax({type:"GET",url:"${cuiWebRoot}/top/.topExcelImportMessage?actionType=del"});
			}

			/**
			 * ����html�����Ƿ���ʾ
			 * @param objId html����id
			 * @param display "none"����ʾ ""��ʾ
			 */
			function setDisplay(objId, display){
				document.getElementById(objId).style.display = display;
			}

			/**
			 * �رմ���
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
							<td width="100%"><b>��ѡ������ļ�</b></td>
						</tr>
					</table>
					<table class="form_table" cellSpacing="1" cellPadding="5" width="98%" bgcolor="#FFFFFF">
						<tr>
				      		<td width="20%" class="td_label"  style="text-align:right;">�����ļ�&nbsp;</td>
							<td width="80%" class="td_content" style="align:left;">
				      			<input type="file" name="filePath" size="43" onkeypress="return false;" onchange="getFileName();">
				      		</td>
				    	</tr>
						<tr>
							<td align="center" colspan ="4" bgcolor="#FFFFFF">
					           <div align="center" id="yes">
				      		<input name="Submit2" type="button" class="btn_href" value="&nbsp;ȷ&nbsp;��&nbsp;"  onclick="importContent();"/>
				      		<input name="Submit3" type="button" class="btn_href" value="&nbsp;��&nbsp;��&nbsp;" onclick="closeWindow();" />
				      	</div>
				      	<div align="center" id="no">
				      		<input name="Submit3" type="button" class="btn_href" value="&nbsp;��&nbsp;��&nbsp;" onclick="closeWindow();" />
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