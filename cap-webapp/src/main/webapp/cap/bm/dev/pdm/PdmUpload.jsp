<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<%
   String packageId = request.getParameter("packageId");
   String parentNodeId = request.getParameter("parentNodeId");
   String parentNodeName = request.getParameter("parentNodeName");
%>
<html>
<title>文件上传</title>
<head>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	 <style type="text/css"> 
		.color {color: #FF0000}
		 
		 body{margin:5px;}
		#loading {
			left: 50%; top: 50%; margin: -14px 0px 0px -48px;position:absolute;
			display:none;
		}
		 .load_gif{
		
		 background: url("images/loading.gif") no-repeat scroll 4px 5px #FFFFFF;
		    border: 1px solid #6593CF;
		    font-size: 14px;
		    height: 21px;
		    padding: 5px 0 0 27px;
		    width: 68px;
		} 
		 .type-file-box{ position:relative;width:370px;height:30px;}
		 .type-file-file{ position:absolute; z-index:9;top:0; left:0; width:270px; height:30px; filter:alpha(opacity:0);opacity: 0;}
		 .type-file-button{ background-color:#FFF; border:1px solid #CDCDCD;height:24px; width:70px;}
		 .type-file-invalid{ border-color:red;} 
	</style>
</head>

<body>
<form id='appForm'  action="${pageScope.cuiWebRoot}/cap/.pdmImport?packageId=<%=packageId%>&parentNodeId=<%=parentNodeId%>&parentNodeName=<%=parentNodeName%>" enctype="multipart/form-data"  method="post" >
 <div class="top_header_wrap">
	<div class="thw_title">
		上传插件
	</div>
	<div class="thw_operate" style="margin-right: 12px">
       <span id="download_button" name="download_button" uitype="button" label="导&nbsp;&nbsp;入"  on_click="save"></span>
	</div>
</div>

<div class="top_content_wrap">
    <table class="form_table" cellspacing="0px" cellpadding="0px" width="100%">
 		<tr>
	       <td width="80px" class="td_label"><span class="top_required">*</span> 选择文件</td>
	       <td  class="td_content">
	       <div class="type-file-box">
	       <span uitype="Input" id="fileText" name="fileText" on_focus="ss" validate="[{'type':'required', 'rule':{'m': '请选择文件。'}}]" maxlength = "100"></span>    
		   <input name="appFile" id="appFile" type="file"  class="type-file-file" MaxLength = "50" accept=".pdm"/>
		   <span id="browseButton" uitype="button" label="浏&nbsp;&nbsp;览.." mark="2" on_click="selectFile"></span>
	       </div>
       	   </td>
    	</tr>
    </table> 
      
    </div>
</form>

<script type="text/javascript">
 var processingDiv = null;
  var pWindow = window.parent;
  
  function selectFile(){
	  $('#appFile').click();
  }

 String.prototype.endWith=function(str){
     var reg=new RegExp(str+"$");
     return reg.test(this);
 }

/**
 * 上传文件
 */
 
$(document).ready(function(){
    comtop.UI.scan();
    pWindow.isLoadData = false;
    //当文件框值发生改变时 重新设置文件文本框内容
    $("#appFile").change(function () {
        var fileName = $("#appFile").val();
        if(!fileName.endWith('.pdm') && !fileName.endWith('.PDM')){
            window.cui.error('文件必须是pdm格式文件。');
            return;
        }
        if(fileName.substring(fileName.lastIndexOf('\\') + 1).length>100){
            window.cui.error('文件长度超过一百字符。');
            return;
        } else{
        if(getBytesLength(fileName) > 100){
            fileName=" ";
            window.cui.error('文件长度超过一百字符,请修改后上传。');
        }
        cui("#fileText").setValue(fileName.substring(fileName.lastIndexOf('\\') + 1));
        }
    });
 });
 
 function getBytesLength(str) {
     var len = 0;
     for (var i = 0; i < str.length; i++) {
         var c = str.charCodeAt(i);
         //0x0001-0x007e  英文数字标点
         //0xff60-0xff9f  特殊符号
         if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
             len ++;
         } else {
             len += 2;
         }
     }
     return len;
 }

/**
 * 点击导入按钮触发导入事件
 */
function save(){
	var map = window.validater.validOneElement(cui("#fileText")); 
	 if(!map.valid){
		return;
	} 
	 processingDiv = cui.handleMask({
        html:'<div style="padding:10px;border:1px solid #666;background: #fff;">正在处理中,请稍候...</div>'
    }); 
    processingDiv.show();
    document.getElementById("appForm").submit();
}
</script>
</body>
</html>
