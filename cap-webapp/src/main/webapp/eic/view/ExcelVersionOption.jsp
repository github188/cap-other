<!DOCTYPE html>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/eic/view/I18n.jsp" %>
<html>
<head>
<title><fmt:message key="selectVersion" /></title>
<meta http-equiv="Content-Type" content="text/html charset=gbk">
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/js/jquery.js"></script>
<link  rel="stylesheet" type="text/css"  href="<%=request.getContextPath()%>/eic/css/eic.css"></link>
<script type="text/javascript" src="<%=request.getContextPath()%>/eic/cui/js/comtop.ui.min.js"></script>
<script language="javascript">
var eicBizBigData = null;
var dyanDialog = null;
var param = "";
var _pt = window.top.cuiEMDialog.wins.exportDialog;
var objEicBizBigData = window.parent.cuiEMDialog.wins["exportDialog"].document.getElementById("eicBizBigData");
if(objEicBizBigData){
	eicBizBigData = objEicBizBigData.value;
}
var process = "<%=request.getParameter("process")==null?"":request.getParameter("process")%>";
var tempExcelVersion = "<%=request.getParameter("excelVersion")==null?"":request.getParameter("excelVersion")%>";
var excel2003FileName = "<%=request.getParameter("excel2003FileName")==null?"":request.getParameter("excel2003FileName")%>";
var	excel2007FileName = "<%=request.getParameter("excel2007FileName")==null?"":request.getParameter("excel2007FileName")%>";
var configFileName="<%=request.getParameter("configFileName")==null?"":request.getParameter("configFileName")%>";
var sysName="<%=request.getParameter("sysName")==null?"":request.getParameter("sysName")%>";
var buttonId="<%=request.getParameter("buttonId")==null?"":request.getParameter("buttonId")%>";
var userId="<%=request.getParameter("userId")==null?"":request.getParameter("userId")%>";
var excelId="<%=request.getParameter("excelId")==null?"":request.getParameter("excelId")%>";
var exportType="<%=request.getParameter("exportType")==null?"":request.getParameter("exportType")%>";
var excelVersion="<%=request.getParameter("excelVersion")==null?"":request.getParameter("excelVersion")%>";
var param="<%=request.getParameter("param")==null?"":request.getParameter("param")%>";
var asyn="<%=request.getParameter("asyn")==null?"false":request.getParameter("asyn")%>";
var exportFileName="<%=request.getParameter("exportFileName")==null?"":request.getParameter("exportFileName")%>";
var objButton = window.parent.cuiEMDialog.wins["exportDialog"].document.getElementById(buttonId);

if(eicBizBigData !== null && eicBizBigData !== undefined && eicBizBigData !== ""){
	if(param !== null && param !== undefined && param !== ""){
		param = encodeURIComponent(param + "eicBizBigData:"+eicBizBigData);
	}else{
		param = encodeURIComponent("eicBizBigData:"+eicBizBigData);
	}
}else{
	if(param !== null && param !== undefined && param !== ""){
		param = encodeURIComponent(param);
	}
}

if(objButton !== null && objButton !== undefined && objButton !== ""){
	if(!eicBizBigData){
		var p = $(objButton).attr("param");
		if(p !== null && p !== undefined && p !== ""){
			param = encodeURIComponent(p);
	    }
	}
}


function exportExcel(excelVersion){
	
	if(excelVersion==""){
		_pt.cui.alert("<fmt:message key="selectVersionNeedToExport" />");
		return;
	}
    if(exportType=="normal"){
		setButtonNoClick();
        //常规导出Excel文件
        process = "yes";
        setProcessDiv();
        var url = "";
        var currDate = new Date();
		//var params ="?configFileName="+configFileName+"&userId="+userId+"&excelId="+excelId+"&excelVersion="+excelVersion+"&exportType="+exportType+"&param="+param;
        if(null == sysName || "" == sysName || "null" == sysName){
        	url = "<%=request.getContextPath()%>/eic/eic.excelExport";
        }else {
        	url = "<%=request.getContextPath()%>"+sysName+"/eic/eic.excelExport";
        }
        var params = {
			userId: userId,
			excelId: excelId,
			param: param,
			exportType: exportType,
			excelVersion: excelVersion,
			sysName: sysName,
			asyn: asyn,
			exportFileName: exportFileName,
			time: currDate.getTime()
		}
        doSubmit(params,url);
    }else if(exportType=="dyan"){
        //动态列导出
        var objParams = {};
         objParams.webRoot = '<%=request.getContextPath()%>';
    	 objParams.sysName = sysName;
    	 objParams.excelId = excelId;
    	 objParams.userId = userId;
    	 objParams.exportType = exportType;
    	 objParams.excelVersion = excelVersion;
    	 objParams.buttonId = buttonId;
    	 if(eicBizBigData !== null || eicBizBigData !== "" || eicBizBigData !== undefined){
        	 param = null;
    	 }
    	 objParams.param = param;
    	 objParams.asyn = asyn;
    	 objParams.exportFileName = encodeURIComponent(exportFileName); 
    	 objParams.defVersion = defVersion;
        _pt.openDyColumnDialog(objParams);
        document.getElementById("e2003Id").className = "button";
		document.getElementById("e2007Id").className = "button";
		if(_pt.exportDialog!=null){
			_pt.exportDialog.hide();
		}
    }else{
		setButtonNoClick();
		_pt.exportDialog.setSize({height:130});
		var tip ='<tr>'
				+'<td colspan="4" class="notes">'
				+'<p class="tipsNote"><fmt:message key="cannotIdentifyTheType" /><br/></p>'
				+'</td>'
				+'</tr>'
		$("#versionTable").append(tip);
    }
}
function doSubmit(params,url){
	$.ajax({
		type: "POST",
		dataType: "JSON",
		url: url,
		data: params,
		success: function(data) {
			if(data[0] && data[0].errorInfo){
				_pt.isDelExportDialog = true;
				if(null != _pt.exportDialog){
				  _pt.exportDialog.hide();
				}
				_pt.openErrorDialog("<%=request.getContextPath()%>/eic/view/ExcelExportError.jsp?errorInfo="+encodeURIComponent(encodeURIComponent(data[0].errorInfo)));
				return;
			}
			if (data[0].asyn == "true") {
				_pt.openTaskMonitorList(data[0].taskListUrl);
				_pt.isDelExportDialog = true;
				if(_pt.exportDialog!=null){
					_pt.exportDialog.hide();
				}
			}else{
				var url = "";
				var filePath = "<%=(request.getSession().getServletContext().getRealPath("/")).replace("\\", "/")%>" + "/eic/temp/excelexport/";
				var fileName = "";
				if("Excel2003" == data[0].excelVersion){
					filePath = filePath + userId + "/" +  data[0].excel2003FileName;
					fileName = data[0].excel2003FileName;
			    }else{
			    	filePath = filePath + userId + "/" + data[0].excel2007FileName;
			    	fileName = data[0].excel2007FileName;
				}
				filePath = encodeURIComponent(encodeURIComponent(encodeURIComponent(filePath)));
				fileName = encodeURIComponent(encodeURIComponent(encodeURIComponent(fileName)));
	            if(null == sysName || "" == sysName || "null" == sysName){
	            	url = "<%=request.getContextPath()%>/eic/eic.excelExport?fileExist=yes&filePath="+filePath+"&fileName="+fileName+"&isDelete=true&sysName=";
	            }else {
	            	url = "<%=request.getContextPath()%>"+sysName+"/eic/eic.excelExport?fileExist=yes&filePath="+filePath+"&fileName="+fileName+"&isDelete=true&sysName="+sysName;
		        }
			    _pt.exportDialog.hide();
			    window.location.href = url;
			}
		}
	});
}

function setProcessDiv(){
	_pt.isDelExportDialog = true;
	var iframe=$(_pt.document.getElementById("exportDialog")).find("iframe");
	var iframeHeight=iframe.height();
	iframe.height(iframeHeight+30);
	$("#trImg").show();
}
function closeWindow(){
	if(_pt.exportDialog!=null){
		_pt.exportDialog.hide();
	}
}
function downloadFile(){
	var url = "../../excelExport?method=downloadFile";
    document.excelExportForm.action=url;
    document.excelExportForm.submit();
}
function selVersion(obj,version){
	if(process=="yes"){
		var tip ='<tr>'
				+'<td colspan="4" class="notes">'
				+'<p class="notes"><fmt:message key="occupy" /><br/></p>'
			    +'</td>'
			    +'</tr>';
		$("#versionTable").append(processDiv);
	}
	obj.className+=" red";
	exportExcel(version);
}
</script>
<style type="text/css"><!--
html {
	 height:100%;
}
body {
	background: #FFFFFF;
	overflow: hidden;
	font-size: 12px;
	margin: 0px;
	height:100%;
}
.form_table {
	margin: 0;
	padding: 0;
	width: 100%;
	height:100%;
	table-layout:fixed;
	background-color:#fff;
}
.form_table td{ padding:0;}
.form_table  .td_content {
	line-height: 18px;
	padding: 10px;
	height:30px;
}


.notes{ color:#9D9D9D; margin:10px 0 0 0; padding-left:5px;}
.tipsNote{ color:red; margin:10px 0;}
.bottom {position:absolute; width:100%; bottom:0; left:0;}
--></style>
</head>
<body class="table_tab_bgcolor">
<form name="excelExportForm" method="post" action="" class="form">



				<table id="versionTable" class="form_table" >
					<tr id="trTextId">
						<td align="center" width="50%" class="td_content">
						 <a id ="e2007Id" class ='button' onclick="selVersion(this,'Excel2007')">Excel 2007</a>
						</td>
						<td align="center" width="50%" class="td_content">
						 <a id ="e2003Id"  class ='button' onclick="selVersion(this,'Excel2003')">Excel 2003</a>
						</td>
					</tr>


					<tr id="trImg">
						<td align="left" colspan="2" bgcolor="#FFFFFF">
						<div id="progressing"><font style="font-size: 12px">
						<fmt:message key="onExport" /></font> <br>
						<img height="15" width="100%" src="../images/progress_handling.gif"
							style="vertical-align: middle; margin-right: 6px" /></div>
						</td>
					</tr>
</table>


</form>

<div class="bottom">
<p class="notes">
<fmt:message key="recommendSelect2007" />
</p>
</div>
<iframe id="exportExcelFrame" style="display: none;" src=""></iframe>
</body>
</html>
<script language="javascript">
   var fileExist = "<%=request.getParameter("fileExist")==null?"":request.getParameter("fileExist")%>";
   var errorInfo = "<%=request.getParameter("errorInfo")==null?"":request.getParameter("errorInfo")%>";
   var taskListUrl = "<%=request.getParameter("taskListUrl")==null?"":request.getParameter("taskListUrl")%>";
   var processDivFlag = "<%=request.getParameter("processDivFlag") == null?"":request.getParameter("processDivFlag")%>";
   var eversion = "<%=request.getParameter("eversion") == null?"":request.getParameter("eversion")%>";
   var flag = "<%=request.getParameter("flag") == null?"":request.getParameter("flag")%>";
   var defVersion = "<%=request.getParameter("defVersion") == null?"":request.getParameter("defVersion")%>"
   $(document).ready(function() {
        $("#trImg").hide();
        if(defVersion == "Excel 2007"){
        	document.getElementById("e2007Id").className+=" red";
        	selVersion(this,'Excel2007');
        }
        if(defVersion == "Excel 2003"){
        	document.getElementById("e2003Id").className+=" red";
        	selVersion(this,'Excel2003');
        }
        if("dynamicColumnProcess" == flag){
        	 if(null == sysName || "" == sysName || "null" == sysName){
             	url = "<%=request.getContextPath()%>/eic/eic.excelExport";
             }else {
             	url = "<%=request.getContextPath()%>"+sysName+"/eic/eic.excelExport";
             }
        	var columns = new Array();
        	var index = 0;
            <%
	            String[] objColumns = request.getParameterValues("columns");
	            if (null != objColumns && objColumns.length > 0) {
	                for (String strColumn : objColumns) {
	                   %>
	                   columns[index] = "<%=strColumn%>";
	                   index++;
	                   <%
	                }
	            }
            %>
            var currDate = new Date();
            var objButton = window.parent.cuiEMDialog.wins["exportDialog"].document.getElementById(buttonId);
        	 var params ={
        				userId: userId,
        				excelId: excelId,
        				param: param,
        				exportType: exportType,
        				excelVersion: excelVersion,
        				sysName: sysName,
        				columns: columns,
        				flag: flag,
        				asyn: asyn,
        				exportFileName: exportFileName,
        				time: currDate.getTime()
        			};
        	 doSubmit(params,url);
        }
		if("yes" == fileExist){
			var url = "";
			var filePath = "<%=(request.getSession().getServletContext().getRealPath("/")).replace("\\", "/")%>" + "/eic/temp/excelexport/";
			var fileName = "";
			var ip = "<%=request.getLocalAddr()%>";
			var port = "<%=request.getLocalPort()%>";
			if("Excel2003" == tempExcelVersion){
				filePath = filePath + userId + "/" + excel2003FileName;
				fileName = excel2003FileName;
		    }else{
		    	filePath = filePath + userId + "/" + excel2007FileName;
		    	fileName = excel2007FileName;
			}
			filePath = encodeURIComponent(encodeURIComponent(filePath));
			fileName = encodeURIComponent(encodeURIComponent(fileName));
            if(null == sysName || "" == sysName || "null" == sysName){
            	url = "<%=request.getContextPath()%>"+sysName+"/eic/eic.fileDownload?actionType=fileDownload&filePath="+filePath+"&fileName="+fileName+"&serverIP="+ip+"&serverPort="+port+"&isDelete=true&sysName="+sysName;
            }else {
            	url = "<%=request.getContextPath()%>/eic/eic.fileDownload?actionType=fileDownload&filePath="+filePath+"&fileName="+fileName+"&serverIP="+ip+"&serverPort="+port+"&isDelete=true&sysName=";
            }
		    _pt.exportDialog.hide();
		    window.location.href = url;
		}
		if("yes" == process){
			setButtonNoClick();
		}
		if("" != errorInfo){
			_pt.isDelExportDialog = true;
			if(_pt.exportDialog!=null){
				_pt.exportDialog.hide();
			}
			_pt.exportDialog.show("<%=request.getContextPath()%>/eic/view/ExcelExportError.jsp?errorInfo="+errorInfo);
		}
		if("" != taskListUrl){
			_pt.openTaskMonitorList(taskListUrl);
			_pt.isDelExportDialog = true;
			if(_pt.exportDialog!=null){
				_pt.exportDialog.hide();
			}
		}
		if("" != processDivFlag){
			setProcessDiv();
			if("Excel2003" == eversion){
				document.getElementById("e2003Id").className+=" red";
			}else{
				document.getElementById("e2007Id").className+=" red";
			}
		}
	});

	function setButtonNoClick(){
		$('#e2007Id').attr('disabled',"true");
    	$('#e2003Id').attr('disabled',"true");
    	$('#e2007Id').removeAttr("onclick");
    	$('#e2003Id').removeAttr("onclick");
	}
</script>