<%
/**********************************************************************
* 自定义行为编辑页面
* 2015-11-1 zhangzunzhi 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html ng-app='resourceFileEdit'>
<head>
<style>

</style>
<meta charset="UTF-8">
<title> 自定义行为编辑页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ResourceFacade.js"></top:script>
	<style type="text/css">
.file-box{ position:relative;width:100%}
.txt{ height:22px; border:1px solid #cdcdcd; width:69%;}
 .btn{ background-color:#FFF; border:1px solid #CDCDCD;height:24px; width:90px;}
.file{ position:absolute; top:0; right:130px; height:24px; filter:alpha(opacity:0);opacity: 0;width:1px }
</style>
	<script type="text/javascript">
	var editType=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("editType"))%>;
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
	});
	
	function setValue(obj){
		var path=obj.value;
		var index = path.lastIndexOf("\\");
		var name = path.substr(index+1);
		$("#content").val(name);
	}
	
	//上传文件
	function save(){
		var map = window.validater.validAllElement();
	    var inValid = map[0];
	    var valid = map[1];
	   	//验证消息
		if(inValid.length > 0){//验证失败
			var str = "";
	        for (var i = 0; i < inValid.length; i++) {
				str += inValid[i].message + "<br />";
			}
		}else{
			//校验选择
			var text = document.getElementById('content').value;
			if(!text){
				cui.alert("请选择js或css文件！");
				return false;
			}
			var fileFlag = true;
			var saveData = cui(data).databind().getValue();
			if(text.indexOf(".js")>0){
				if(text.substring(text.length-3)=="jsp"){
					fileFlag = true;
				}else{
				fileFlag = false;
				//文件类型
				saveData.fileType = "js";
				//文件名称
				saveData.fileName = text.substring(0,text.length-3);
				}
			}
			if(text.indexOf(".css")>0){
				fileFlag = false;
				//文件类型
				saveData.fileType = "css";
				//文件名称
				saveData.fileName = text.substring(0,text.length-4);
			}
			
			if(fileFlag){
				cui.alert("只支持导入js或css文件！");
				return false;
			}
		    var packagePath = saveData.packagePath;
		    if(isExistFileName(saveData)){
		    	cui.alert("文件已存在!");
		    	return false;
		    }
		    var uploadFile = dwr.util.getValue('docFile');//uploadFile
		    dwr.TOPEngine.setAsync(false);
			ResourceFacade.upload(uploadFile,packagePath, function(data){
	 			if(data){
	 				cui.message('文件上传成功。',"success");	
	 				saveData.fullFilePath = data;
	 				saveData.content = "function";
	 				window.parent.fileEditCallback(saveData,editType);
	 				window.parent.uploadFileDialog.hide();
	 			}else{
	 				   cui.message('文件上传失败。',"error");
	 			}
	 		})
	 		dwr.TOPEngine.setAsync(true);
		
		}
	}
	
	//检测文件名称是否存在
	function isExistFileName(saveData){
		var isExist = false;
		dwr.TOPEngine.setAsync(false);
		ResourceFacade.existed(saveData, function(data){
			isExist = data;
		});
		dwr.TOPEngine.setAsync(true); 
		return isExist;
	}
	
	//关闭窗口
	function back(){
		window.parent.uploadFileDialog.hide();
	}
	
	var validatecFilePath = [ {'type':'required','rule':{'m':'包路径不能为空。'}},
	                          {'type':'custom','rule':{'against':checkFilePathName, 'm':'包路径不能以cap.开头'}},
	                          {'type':'custom','rule':{'against':checkFilePath, 'm':'包路径只能为数字、小写字母、分包用.隔开。'}}
	                         ]
	
	//检测包路径
	function checkFilePathName(data){
		if(data&&data.startsWith("cap.")){
			return false;
		}
		return true;
	}
	
	//只能为数字、字母、
	function checkFilePath(data){
		if(data){
			var reg = new RegExp("^[a-z0-9.]+$");
			return (reg.test(data));
		}
		return true;
	}
	</script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="resourceFileEditCtrl" data-ng-init="ready()">
<div id="pageRoot" class="cap-page">
	<div id="chooseCopyPage" class="cap-area" style="width:100%;dispaly:none;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	<span id="save" uitype="Button" onclick="save()" label="上传"></span> 
					<span id="back" uitype="Button" onclick="back()" label="取消"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: left;">
		        	<span>
			        	<blockquote class="cap-form-group">
							<span class="cap-label-title" size="12pt">文件基本信息</span>
						</blockquote>
					</span>
		        </td>
		    </tr>
		</table>
		<table class="form_table" style="table-layout:fixed;">
						<tr>
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>包路径：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input" id="packagePath" width="90%" databind="data.packagePath" validate="validatecFilePath"  emptytext="ipb.manager.js" readOnly="false"></span>
					        </td>
						</tr>
						<tr>
							<td  class="td_label" style="text-align: right;width:10%"><font color="red">*</font>选择文件：
							</td>
							 <td bordercolor="1px solid #cdcdcd" class="td_content" style="text-align: left;width:40%">
							 <div class="file-box" >
								 <input type='text' name='content' id='content' class='txt' readonly="readonly" />  
								 <input type='button' class='btn' value='浏览...' />
								 <input type="file" name="content" class="file" id="docFile" size="1" onChange="setValue(this)" />
						     </div>
							</td>
						</tr> 
				</table>
</div>
</div>
</body>
</html>				