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
    <top:link href="/cap/bm/test/css/icons.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/lib/codemirror.css"></top:link>  
    <top:link href="/cap/bm/common/codemirror/theme/eclipse.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/hint/show-hint.css"></top:link>
    <top:link href="/cap/bm/common/codemirror/addon/display/fullscreen.css"></top:link>      
	<top:script src="/cap/bm/common/codemirror/lib/codemirror.js"></top:script>   
	<top:script src="/cap/bm/common/codemirror/mode/javascript/javascript.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/show-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/hint/javascript-hint.js"></top:script>
	<top:script src="/cap/bm/common/codemirror/addon/display/fullscreen.js"></top:script>	
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src="/cap/dwr/interface/ResourceFacade.js"></top:script>
	<style type="text/css">
    	.codeArea{
    		width:98%; 
    		background: whitesmoke;
    		border-radius: 3.01px;
    		transition: border .3s linear 0s;
    		border: 1px solid #ccc;
			-moz-transition:border .3s linear 0s;
			-webkit-transition:border .3s linear 0s;
			-o-transition:border .3s linear 0s
		}
		.CodeMirror {
			width:100%;
			height: auto;
			background: rgb(232, 229, 229);
		}
		.code_btn_area {
			position: relative;
			float: right;
			margin-bottom: -30px;
			margin-right:45px;
			z-index: 10000;
			cursor: pointer;
		}
    </style> 
	<script type="text/javascript">
	var editType=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("editType"))%>;
	var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
	var data={};
	
	$(document).ready(function(){
       if(editType=="add"){
    	   window.parent.$(".dialog-title").attr("title","新增文件");
    	   window.parent.$(".dialog-title").text("新增文件");
		}else{
			window.parent.$(".dialog-title").attr("title","文件内容编辑");
			window.parent.$(".dialog-title").text("文件内容编辑");
			var resourceVo = window.parent.scope.files[flag];
			var fullFilePath = resourceVo.packagePath.replace(/\./g,"/")+"/"+resourceVo.fileName +"."+resourceVo.fileType;
			dwr.TOPEngine.setAsync(false);
			ResourceFacade.readResouce(fullFilePath,function(result){
				data = result;
			})
			dwr.TOPEngine.setAsync(true);
			
			comtop.UI.scan.readonly=true;
		}
       initCodeMirror();
       comtop.UI.scan();   //扫描
	});
	
	//文件保存
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
			var saveData = cui(data).databind().getValue();
			saveData.content = editor.getValue();
			dwr.TOPEngine.setAsync(false);
			ResourceFacade.save(saveData, function(data){
	 			if(data){
	 				if(data.fileName==null||data.fileName==""){
	 					cui.message('文件新增成功。',"success");	
	 				}else{
		 			   cui.message('文件修改成功。',"success");
	 				}
	 				saveData.fullFilePath = data;
	 				window.parent.fileEditCallback(saveData,editType,flag);
	 				window.parent.addFileDialog.hide();
	 			}else{
	 				if(data.fileName==null||data.fileName==""){
	 				   cui.message('文件新增失败。',"error");
	 				}else{
	 				   cui.message('文件修改失败。',"error");
	 				}
	 			}
	 		})
	 		dwr.TOPEngine.setAsync(true);
		}
	}
	
	//页面装载方法
	function initCodeMirror(){
		var scriptText = "";
		if(data.content){
			scriptText = data.content;
		}
		var readOnlyFlag = false;
		if(data.packagePath){
		if(data.packagePath.startsWith("cap.")){
			readOnlyFlag = true;
		}
		}
	   	var textarea = document.getElementById("content");
	   	 editor = CodeMirror.fromTextArea(textarea, { //script_once_code为你的textarea的ID号
	   		       lineNumbers: true,//是否显示行号
	   		       mode: {name: "javascript", globalVars: true},
	   		       lineWrapping:true, //是否强制换行
	               theme:'eclipse',
	               viewportMargin:5000, //默认只显示11行数据，这里设置显示一千行数据
	   	           readOnly:readOnlyFlag	 
	   	 });
	   	editor.on('keypress', function(instance, event) {
	        if(event.charCode>=46 || (event.charCode>=65 && event.charCode<=90) || (event.charCode>=97 && event.charCode<=122)){
	            setTimeout(function(){
	              editor.showHint();  //满足自动触发自动联想功能  
	            },1)
	        }         
	    }); 
	   	$("#code").find('.CodeMirror').css({background: "#F5F5F5"});//设置背景色
	   	editor.setValue(scriptText);
	}
	var validatecFileName = [{'type':'required','rule':{'m':'文件名称不能为空。'}},
	                          {'type':'length','rule':{'max':'30','maxm':'长度不能大于30'}},
	         	              {'type':'custom','rule':{'against':checkName, 'm':'文件名称只能为数字、字母、下划线。'}},
	                          {'type':'custom','rule':{'against':isExistFileName, 'm':'文件名称已存在。'}}
	                         ]
	var validatecFilePath = [ {'type':'required','rule':{'m':'包路径不能为空。'}},
	                          {'type':'custom','rule':{'against':checkFilePathName, 'm':'包路径不能以cap.开头'}},
	                          {'type':'custom','rule':{'against':checkFilePath, 'm':'包路径只能为数字、小写字母、分包用.隔开。'}}
	                         ]
	var initfileTypeData=[{id:"js",text:"js"},
	                      {id:"css",text:"css"}
	                      ]
	
	//只能为 英文、数字、下划线
	function checkName(data) {
		if(data){
			var reg = new RegExp("^[A-Za-z0-9_]+$");
			return (reg.test(data));
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
	
	//检测包路径
	function checkFilePathName(data){
		if(data&&data.startsWith("cap.")){
			return false;
		}
		return true;
	}
	
	//检测文件名称是否存在
	function isExistFileName(){
		if(editType=="edit"){
			return true;
		}
		var isExist = false;
		var saveData = cui(data).databind().getValue();
		dwr.TOPEngine.setAsync(false);
		ResourceFacade.existed(saveData, function(data){
			isExist = !data;
		});
		dwr.TOPEngine.setAsync(true); 
		return isExist;
	}
	//关闭窗口
	function closeWindow(){
		window.parent.addFileDialog.hide();
	}
	</script>
</head>
<body style="background-color:#f5f5f5;" ng-controller="resourceFileEditCtrl" data-ng-init="ready()">
<div id="pageRoot" class="cap-page">
	<div id="chooseCopyPage" class="cap-area" style="width:100%;dispaly:none;">
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	<span id="save" uitype="Button" onclick="save()" label="保存"></span> 
					<span id="back" uitype="Button" onclick="closeWindow()" label="取消"></span> 
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
								<font color="red">*</font>文件类型：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="PullDown" mode="Single" id="fileType" databind="data.fileType" editable="false" width="90%" value_field="id" label_field="text" datasource="initfileTypeData" value="js"></span>
					        </td>
							
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>文件名称：
					        </td>
					        <td class="td_content" style="text-align: left;width:40%">
					        	<span uitype="input"  id="fileName" databind="data.fileName" width="90%" validate="validatecFileName"></span>
					        </td>
						</tr>
						<tr>
							<td  class="td_label" style="text-align: right;width:15%">
								<font color="red">*</font>包路径：
					        </td>
					        <td class="td_content" colspan="3" style="text-align: left;width:40%">
					        	<span uitype="input" id="packagePath" width="96%" databind="data.packagePath" emptytext="ipb.manager.js" validate="validatecFilePath"></span>
					        </td>
						</tr>
						<tr>
							<td  class="td_label" style="text-align: right;width:10%">文件内容：
							</td>
							<td class="td_content" colspan="3" style="text-align: left;">
								<div id="code" class="codeArea" style="width:96%;height:350px;overflow:auto;">
										<textarea id="content" name="content"></textarea>
								</div>
							</td>
						</tr> 
				</table>
</div>
</div>
</body>
</html>				