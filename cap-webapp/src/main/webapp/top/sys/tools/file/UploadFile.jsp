<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/top/component/common/AccessTaglibs.jsp" %>
<html>
<title>上传文件</title>
<head>
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
<link rel="stylesheet"
	href="${pageScope.cuiWebRoot}/top/sys/css/top_sys.css" type="text/css">
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FileAction.js"></script> 
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
<form id='appForm'  action="${pageScope.cuiWebRoot}/top/sys/tools/file/UploadFile.ac" enctype="multipart/form-data"  method="post" >
 <div class="top_header_wrap">
	<div class="thw_title">
		上传文件
	</div>
	<div class="thw_operate" style="margin-right: 12px">
       <span id="download_button" name="download_button" uitype="button" label="上&nbsp;&nbsp;传"  on_click="save"></span>
	</div>
</div>

<div class="top_content_wrap">
    <table class="form_table" cellspacing="0px" cellpadding="0px" width="100%">
 		<tr>
	       <td width="80px" class="td_label"><span class="top_required">*</span> 选择文件</td>
	       <td  class="td_content">
	       <div class="type-file-box">
	       <span uitype="Input" id="fileText" name="fileText" on_focus="ss" validate="[{'type':'required', 'rule':{'m': '请选择文件。'}}]" maxlength = "100"></span>    
		   <input name="appFile" id="appFile" type="file"  class="type-file-file" MaxLength = "50"/> 
		   <span id="browseButton" uitype="button" label="浏&nbsp;&nbsp;览.." mark="2" on_click="selectFile"></span>
	       </div>
       	   </td>
    	</tr>
    	<tr>
    		<td width="80px" class="td_label"> 文件类别</td>
    		<td class="td_content">
    			<span uitype="singlePullDown" width="76%"id="fileClassify" name="fileClassify" datasource="initFileClassifyData" width="90%" value="fileClassify"
    			editable="false" label_field="fileClassifyName" value_field="fileClassifyId" ></span>
    		</td>
    	</tr>
	     <tr>
	     	<td width="80px" class="td_label">
	     	文件描述<br>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	     	</td>
			<td class="td_content" style="white-space:nowrap;">           
	          <span uitype="Textarea" id="fileTextArea" name="downloadappdes"  relation="fileDesc" height="70px" autoheight="true" maxlength="50" byte =true ></span>
	       </td>
	     </tr>
    </table> 
      
    </div>
</form>

<script type="text/javascript">
  var processingDiv = null;
  var fileClassify = "<c:out value='${param.fileClassify}'/>";
  var pWindow = window.parent;
  
  function selectFile(){
	  $('#appFile').click();
  }
  
  function getFileClassify(){
	  return fileClassify;
  }
/**
 * 上传文件
 */
 
$(document).ready(function(){
     comtop.UI.scan();
         pWindow.isLoadData = false;
        //当文件框值发生改变时 重新设置文件文本框内容
        cui("#fileClassify").setValue(fileClassify);
 		$("#appFile").change(function () {
 	    var fileName = $("#appFile").val();
 	if(fileName.substring(fileName.lastIndexOf('\\') + 1).length>100){
 		window.cui.error('文件路径长度超过一百个字符。');	
 		return;
 	} else{
 		if(getBytesLength(fileName) > 100){
 			fileName=" ";
 			window.cui.error('文件路径长度超过一百个字符,请修改后上传。');	
 		}
 		cui("#fileText").setValue(fileName.substring(fileName.lastIndexOf('\\') + 1));
 	}
 		}); 
 });
 
 function getBytesLength(str) {
     var len = 0;
     for (var i = 0; i < str.length; i++) {
         var c = str.charCodeAt(i);
         if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
             len ++;
         } else {
             len += 2;
         }
     }
     return len;
 }
 
 function initFileClassifyData(obj){
		
	dwr.TOPEngine.setAsync(false);
	FileAction.getFileClassifyInfo(function(resultData){
			obj.setDatasource(jQuery.parseJSON(resultData));
		});
	dwr.TOPEngine.setAsync(true);
}

/**
 * 点击导入按钮触发导入事件
 */
function save(){
	var map = window.validater.validAllElement();
	if(!map[2]){
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
