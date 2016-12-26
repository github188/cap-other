<%
  /**********************************************************************
	* 文档基本信息编辑
	* 2015-11-9 李小芬  新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<title>文档基本信息编辑页面</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/TxtImportAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/StepGroupsFacade.js'></script>
</head>
<style>
.file-box{ position:relative;width:100%}
.txt{ height:22px; border:1px solid #cdcdcd; width:80%;}
 .btn{ background-color:#FFF; border:1px solid #CDCDCD;height:24px; width:90px;}
.file{ position:absolute; top:0; right:80px; height:24px; filter:alpha(opacity:0);opacity: 0;width:1px }
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" id="saveDoc" label="导入" on_click="importDoc"></span>
			<span uitype="button" label="关闭" on_click="closeSelf"></span>
		</div>
	</div>
	<div class="top_content_wrap cui_ext_textmode">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tr>
					<td class="td_label"><span class="top_required">*</span>步骤分组：</td>
					<td bordercolor="1px solid #cdcdcd">
						<span uitype="PullDown" id="stepGroup" value_field="id" label_field="text" select=0
	               			databind="" width="99%" datasource="stepGroupData" on_change=""></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span class="top_required">*</span>选择文件：</td>
					<td bordercolor="1px solid #cdcdcd">
						<div class="file-box" >
							 <input type='text' name='textfield' id='textfield' class='txt' readonly="readonly" />  
							 <input type='button' class='btn' value='浏览...' />
							 <input type="file" name="fileField" class="file" id="docFile" size="1" onChange="setValue(this)" />
						</div>
					</td>
				</tr>
				
			</table>
			
	</div>
	<script type="text/javascript">
	
	window.onload = function(){
		comtop.UI.scan();
   	}
	
	function setValue(obj){
		var path=obj.value;
		var index = path.lastIndexOf("\\");
		var name = path.substr(index+1);
		$("#textfield").val(name);
	}
	
	//文档模板下拉框数据 
	function stepGroupData(obj){
		var initData = new Array();
		var data;
		dwr.TOPEngine.setAsync(false);
		StepGroupsFacade.loadStepGroups(function(result){
			data = result.groups;
		});
		dwr.TOPEngine.setAsync(true);
		for(var i =0;i<data.length;i++){
			if(data[i].code!="fixed"&&data[i].code!="dynamic"){
				var arr = {id:data[i].code,text:data[i].name};
				initData.push(arr);
			}
		}
		obj.setDatasource(initData);
	}
	
	
	//导入
	function importDoc(){
		//校验选择
		var text = document.getElementById('textfield').value;
		if(!text){
			cui.alert("请选择txt文件！");
			return false;
		}
		var lastTxt = text.substring(text.length-4);
		if(lastTxt !== '.txt'){
			cui.alert("目前只支持导入Txt文件！");
			return false;
		}
		//导入
		var uploadFile = dwr.util.getValue('docFile');//uploadFile
	    var fileNames = uploadFile.value.split("\\");     
	    var fileName = fileNames[fileNames.length-1];   
		dwr.TOPEngine.setAsync(false);
		cui('#saveDoc').disable(true);
		var stepGroupCode = cui("#stepGroup").getValue();
		if(!stepGroupCode){
			stepGroupCode = "common";
		}
		TxtImportAction.importTxt(uploadFile,fileName,stepGroupCode,function(bResult){
			cui('#saveDoc').disable(false);
			if("Success" === bResult.code){
				cui.success("导入成功",refreshParent);
			}else if("Error" === bResult.code){
				cui.warn("导入失败",refreshParent);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//关闭
	function refreshParent(){
		document.getElementById('textfield').value="";
		if(window.parent.reloadPage()){
			window.parent.reloadPage();
		}
		closeSelf(); 
	}
	
	//关闭
	function closeSelf(){
		window.parent.dialog.hide(); 
	}
</script>
</body>
</html>