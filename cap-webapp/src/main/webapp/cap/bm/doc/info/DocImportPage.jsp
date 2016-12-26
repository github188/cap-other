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
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocumentAction.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/CapDocTemplateAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js"></script>
</head>
<style>
.file-box{ position:relative;width:100%}
.txt{ height:22px; border:1px solid #cdcdcd; width:80%;}
.btn{ background-color:#FFF; border:1px solid #CDCDCD;height:24px; width:70px;}
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
					<td class="td_label"><span class="top_required">*</span>业务域：</td>
					<td >
						 <span uitype="ClickInput" id="domainName" name="domainName" databind="Document.domainName" editable="true"  readonly="true" validate="[{'type':'required', 'rule':{'m': '业务域不能为空！'}}]"  maxlength="50"  ></span>
						 <span uitype="button" id="but_import" label="选择业务域" on_click="selectDomain"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span class="top_required">*</span>选择文件：</td>
					<td bordercolor="1px solid #cdcdcd">
						<div class="file-box" >
							 <input type='text' name='textfield' id='textfield' class='txt' />  
							 <input type='button' class='btn' value='浏览...' />
							 <input type="file" name="fileField" class="file" id="docFile" size="1" onChange="setValue(this)" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span class="top_required">*</span>模板：</td>
					<td >
						<span id="docTemplate" uitype="PullDown" mode="Single" databind="Document.docTmplId" value_field="id" label_field="text" validate="[{'type':'required', 'rule':{'m': '模板不能为空！'}}]" datasource="docTypeData" width="95%"></span>
					</td>
				</tr>
				<tr><td colspan='2'></td>
				</tr>
				<tr>
					<td colspan='2'>
						<div align="center"><span style="color:#FF0000; " >注：只能导入word2007及以后的版本的文档，word2003版本请先手动转换为2007格式再导入</span></div>
					</td>
				</tr>
			</table>
			
	</div>
	<script type="text/javascript">
	var bizDomain = "";//业务域ID
	var bizDomainId = "${param.bizDomainId}";//业务域ID
	var bizDomainName = decodeURIComponent("${param.bizDomainName}");
	var Document = {};
	window.onload = function(){
		comtop.UI.scan();
		bizDomain = bizDomainId;
		cui("#domainName").setValue(bizDomainName);
   	}
	
	function setValue(obj){
		var path=obj.value;
		var index = path.lastIndexOf("\\");
		var name = path.substr(index+1);
		$("#textfield").val(name);
		var query ={'summaryFlag':'','bizDomain':bizDomain,'name':name};
		dwr.TOPEngine.setAsync(false);
		var document;
		DocumentAction.queryDocumentByName(query,function(data){
			if(data.count==0){
				document = null;
			}else{
				document=data.list[0];
			}
		});
		dwr.TOPEngine.setAsync(true);
		//查询模板，私有的清空，公有的保留 
		var selectTempId = cui("#docTemplate").getValue();
		var selectDocType;
		if(selectTempId){
			dwr.TOPEngine.setAsync(false);
			CapDocTemplateAction.queryCapDocTemplateById(selectTempId,function(data){
				selectDocType = data.docConfigType;
			});
			dwr.TOPEngine.setAsync(true);
		}
		if(!document && selectDocType && selectDocType == 'PUBLIC'){
			return;
		}
		var docType= '';
		if(document!=null){
			docType=document.docType;
		}
		var initData=getDocTempDic(docType);
		if(document!=null){
			var temp={text:document.docTemplateName,id:document.docTmplId};
			initData.push(temp);
		}
		cui("#docTemplate").setDatasource(initData);
		if(document!=null){
			cui("#docTemplate").setValue(document.docTmplId);
		}
	}
	
	//文档模板下拉框数据 
	function docTypeData(obj){
		var initData=getDocTempDic('');
		obj.setDatasource(initData);
	}
	
	
	function getDocTempDic(type){
		var initData = new Array();
		var data;
		//var condition = {'type':'BIZ_MODEL','docConfigType':'PUBLIC'};
		var condition = {'type':type,'docConfigType':'PUBLIC'};
		dwr.TOPEngine.setAsync(false);
		CapDocTemplateAction.queryCapDocTemplateList(condition,function(bResult){
			data = bResult;
		});
		dwr.TOPEngine.setAsync(true);
		for(var i =0;i<data.count;i++){
			var arr = {id:data.list[i].id,text:data.list[i].name};
			initData.push(arr);
		}
		return initData;
	}
	
	//选择业务域回调函数
	function chooseDomainCallback(domainId,domainName){
		bizDomain = domainId;
		cui("#domainName").setValue(domainName);
	}
	
	function selectDomain(){
		var url = "<%=request.getContextPath() %>/cap/bm/biz/domain/jsp/DomainTree.jsp";
		var title="选择业务域";
		var height = 450; //600
		var width =  250; // 680;
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//导入
	function importDoc(){
		var str = "";
		if(window.validater){
			window.validater.notValidReadOnly = true;
			var map = window.validater.validAllElement();
			var inValid = map[0];
			var valid = map[1];
			//验证消息
			if(inValid.length > 0) { //验证失败
				for(var i=0; i<inValid.length; i++) {
					str += inValid[i].message + "<br/>";
				}
			}
			if(bizDomain == ""){
				str +="业务域不能为空！"+"<br/>";
			}
			if(str != ""){
				cui.alert(str);
				return false;
			}
		}
		Document.bizDomain = bizDomain;
		//导入操作
		var file = dwr.util.getValue('docFile');
		dwr.TOPEngine.setAsync(false);
		dwr.TOPEngine.setAttributes({"uploadKey":"UPLOAD_DOC_FILE"});
		Document.uploadKey = "UPLOAD_DOC_FILE";
		cui('#saveDoc').disable(true);
		DocumentAction.importDocument(Document,file,function(bResult){
			if("Success" === bResult.code){
				cui.success(bResult.message,refreshParent);
			}else if("Error" === bResult.code){
				cui.warn(bResult.message,refreshParent);
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//关闭
	function refreshParent(){
		document.getElementById('textfield').value="";
		window.parent.fastQuery();
		closeSelf(); 
	}
	
	//关闭
	function closeSelf(){
		window.parent.dialog.hide(); 
	}
</script>
</body>
</html>