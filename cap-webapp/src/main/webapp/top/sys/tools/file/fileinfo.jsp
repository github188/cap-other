<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=GBK"></meta> 
<title>文件信息</title>
<head> 
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css"/>
<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css"/>
 <script type="text/javascript" src="${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/top_common.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/dwr/engine.js"></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/sys/dwr/util.js'></script>
<script type='text/javascript' src="${pageScope.cuiWebRoot}/top/sys/dwr/interface/FileAction.js"></script>
<style type="text/css"> 
body{ margin:5px;}
.color {color: #FF0000}
.nav {
     text-align: right;
     margin-bottom: 5px;
     } 
 
</style>
</head>
<body>
 <div class="top_header_wrap">
		<div class="thw_title">
			编辑文件信息
		</div>
		<div class="thw_operate" id="thw_operate" tyle="DISPLAY: none">
     	  <span uitype="button" label="保&nbsp;&nbsp;存" on_click="save" /> 	
		</div>
<div class="top_content_wrap">
 
    <table class="form_table" cellspacing="0px" cellpadding="0px" width="100%">
 <tr>
       <td width="80px" class="td_label"><span class="top_required"></span>文件名称</td>
       <td width="263px" class="td_content" height="30">
       <span  uitype="Input" databind="data.downloadAppName" name="downloadAppName" maxlength="150" validate="validateFile" />
       </td>
       </td>
     </tr>
       <tr>
	     	<td width="80px" class="td_label">
	     	文件描述<br>
	     	</td>
		<td class="td_content" style="white-space:nowrap;">
          <span uitype="Textarea" databind="data.downloadAppDes" name ="downloadAppDes"  maxlength="100" height="60"  name="downloadAppDes" relation="downloadAppDes" />            
       </td>
      </tr>
    </table> 
 </div>
<div class="top_note">注<span style="color: red">*</span>的字段为必填项</div>
<script type="text/javascript">
	var downloadId="<c:out value='${param.downloadId}'/>",
	    fileType="",
	    pWindow = window.parent,
	    data={};
	
	 $(document).ready(function(){
		 
		if(downloadId!=""){
			getDownloadInfo(downloadId);		
		} 
		downloadId="SuperAdmin";
		 if (downloadId == "SuperAdmin") {
			document.all.thw_operate.style.display="";
		} 
		pWindow.isLoadData = false;
	    comtop.UI.scan(); 
	});
	  
/* 
	  window.onload = function(){ 
		  alert(downloadId);
		  pWindow.isLoadData = false;
			 comtop.UI.scan(); 
			
		  if((downloadId){
				getDownloadInfo(downloadId);
			} 
		  
		  var downloadId="SuperAdmin";
			 if (downloadId == "SuperAdmin") {
				document.all.thw_operate.style.display="";
			} 
			
		
	  }
	  
	   */
	  
	function save(){
		 var map = window.validater.validAllElement();
	     var inValid = map[0];
	
	     if(inValid.length==0){
	          if(typeof data.downloadAppName=="string" ){
	        	 data.downloadAppName=comtop.tool.safeHtml(data.downloadAppName);
			  } 
			  if(typeof data.downloadAppDes=="string" ){
	         	 data.downloadAppDes=comtop.tool.safeHtml(data.downloadAppDes);
	          }
	          if(fileType!=""){
		          data.downloadAppName+="."+fileType;
	          }
	         
	         FileAction.updateDownloadInfo(data,function(){
	             if(!parent){
	                 return;
	             }
	             pWindow.isLoadData = true;
	        	 parent.fileInfoDialog.hide();
	        	 parent.cui.message("修改文件信息成功。", "success");
	        	 
	         });
	     }  
	}
	
	function getDownloadInfo(id){
		
		dwr.TOPEngine.setAsync(false);
		FileAction.readFile(id,function(da){
			if(da==null){
				return;
			}
	        data=da;
	        var index = data.downloadAppName.lastIndexOf(".");
	        if(index>0){
	          fileType= data.downloadAppName.substring(index+1);
		      data.downloadAppName = data.downloadAppName.substring(0,index); 
	        }else{
	          fileType="";
	        }
	        data.fileContent=null; 
	        if(typeof data.downloadAppDes!="string"){
	          data.downloadAppDes="";
	        }
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	var validateFile =[{
		type:'required',
		rule:{
		   emptyVal:[' '],
	       m:'文件名不能为空'
	    }
	}];
</script>
</body>
</html>
