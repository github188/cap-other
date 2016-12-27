<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<%@page import="com.comtop.soa.common.util.SOAStringUtils"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.comtop.soa.common.util.SOAStringUtils"%>
<%@ taglib uri="http://www.szcomtop.com/soa/cui" prefix="cui"%>
<!DOCTYPE html>
<html>
<%
   String clientRandomCode = request.getParameter("clientRandomCode");
   if (SOAStringUtils.isNotBlank(clientRandomCode)){
       clientRandomCode = URLDecoder.decode(clientRandomCode,"utf-8");
   }
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"></meta>
<title>上传文件</title> 
<cui:link href="/soa/top/component/ui/cui/themes/default/css/comtop.ui.min.css"/>
<cui:link href="/soa/css/soa.css"/>
<style type="text/css">
 body{margin:5px;}  
.type-file-box{ position:relative;width:300px}
input{ vertical-align:middle; margin:0; padding:0}
.type-file-text{ height:22px; border:1px solid #cdcdcd; width:220px; }
.type-file-button{ background-color:#FFF; border:1px solid #CDCDCD;height:22px; width:70px;font-size: 13px;}
.type-file-file{ position:absolute; top:0; left:0; height:24px; filter:alpha(opacity:0);opacity: 0;width:295px }
 .type-file-invalid{ border-color:red;}
</style>
    <cui:script src="/soa/top/component/ui/cui/js/comtop.ui.min.js"/>
    <cui:script src="/soa/js/jquery.min.js"/>
<script type="text/javascript">
var randomCode = "<%=clientRandomCode%>";
/**
 * 上传文件
 */
window.onload = function () {
    comtop.UI.scan();
    fileInput("file");
}

var tip = null;

function save() {
	   var fileName = document.getElementById("file").value;
	   if (fileName == "" ||fileName == null || fileName.length == 0){
		   $("#textfield").addClass("type-file-invalid");
	       $(".type-file-box").attr("tip", "请选择要上传的文件");
	       if (!tip) {
	            tip = cui.tip(".type-file-box");
	        } else {
	            tip.show();
	        }
	        return;
	   }else {		
		   var url = '<cui:webRoot/>/soa/SoaServlet/importService?operType=importService&clientRandomCode='+randomCode+'&timeStamp='+ new Date().getTime();
		   document.fileForm.action= url;
		   document.fileForm.submit();
		   cui("#upload").disable(true);

	   }
}

function fileInput(id) {
    var fileField = "#" + id;
    var textButton = "<input type='text' name='textfield' id='textfield' class='type-file-text' />  <input type='button' name='button' id='button' value='浏&nbsp;览...' class='type-file-button' />";
    $(fileField).wrap('<div class="type-file-box"></div>');
    $(textButton).insertBefore(fileField);
    $(fileField).change(function () {
        var value = $(this).val();
        $("#textfield").val(value);
        if (value != "" && tip) {
            $("#textfield").removeClass("type-file-invalid");
            $(".type-file-box").attr("tip", "");
            tip.hide();
        }
    });
}

/**
 * 获取文件名
 */
function getFileName(){
   var fileName = document.getElementById("file").value;
   var fileExtendName = fileName.substring(fileName.lastIndexOf(".")+1);
   if (fileExtendName != "xml") {
       $("#textfield").addClass("type-file-invalid");
       $(".type-file-box").attr("tip", "请选择xml文件");
       if (!tip) {
           tip = cui.tip(".type-file-box");
       } else {
           tip.show();
       }
       document.getElementById("file").value = "";
  	   document.getElementById("file").focus();
  	   document.fileForm.reset();
       return;
   }
}  
</script>

</head>
<body>
<form id="fileForm" name="fileForm"  method="POST" enctype="multipart/form-data"> 
 <div class="top_header_wrap">
	<div class="thw_title">
		上传文件
	</div>
	<div class="thw_operate">
       <cui:button label="导&nbsp;入" on_click="save" id="upload" />
	</div>
</div>
<div class="soa_content_wrap">
    <table class="form_table" cellspacing="0px" cellpadding="0px" width="100%">
     <tr>
       <td width="76" class="td_label">选择文件</td>
       <td  class="td_content" height="30" >
        <input name="file" id="file" type="file" size="45" contenteditable="false" class="type-file-file" onchange="getFileName()">
       </td>
     </tr>
    </table>
</div>
</form>
</body>
</html>

