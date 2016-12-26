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
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizDomainAction.js'></script>
</head>
<style>
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" id="saveDoc" label="保存" on_click="saveDoc"></span>
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
				<td class="td_label"><span class="top_required">*</span>文档模板：</td>
				<td >
					<span uitype="PullDown" mode="Single" id="docTemplate" width="100%" databind="Document.docTmplId" datasource="docTypeData" 
						select="0" editable="false" on_change ="changeTempalte" label_field="text" value_field="id"></span>
				</td>
			</tr>
			<tr>	
				<td class="td_label"><span class="top_required">*</span>名称：</td>
				<td>
					<span uitype="input" id="name" name="name" databind="Document.name" validate="validateName" maxlength="100" width="100%" ></span>
				</td>
			</tr>
			<!-- 
			<tr>
				<td class="td_label"><span class="top_required">*</span>总册/分册：</td>
				<td>
					<span uitype="RadioGroup" id="summaryFlag" name="summaryFlag" value="SUM" databind="Document.summaryFlag" width="100%" >
				        <input type="radio" value="SUM" text="总册" />
				        <input type="radio" value="SUB" text="分册" />
				    </span>
				</td>
				
			</tr>
			 -->
			<tr>
				<td class="td_label" >备注：<br></td>	
		        <td >
					<span style="color:#999;">您还能输入<label id="remark_tip" style="color: red;"></label>个字！</span><br/>
					<span uitype="Textarea" relation="remark_tip" id="remark" height="51px" maxlength="500" byte="true" textmode="false" 
						autoheight="false" width="99%" name="name" databind="Document.remark" readonly="false"></span>
		        </td>
			</tr>
			</table>
	</div>

	<script type="text/javascript">
	String.prototype.trim=function(){return this.replace(/(^\s*)|(\s*$)/g,"");}
	var bizDomainId = "${param.bizDomainId}";
	var bizDomainName = "${param.bizDomainName}";
	var documentId = "${param.documentId}";
	var Document = {};
	var Domain = {};
	var docTempinitData;
	window.onload = function(){
   		init();
   	}
	                
	//初始化加载  	
   	function init() {
		//业务域信息
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainById(bizDomainId,function(bResult){
			Domain = bResult;
		});
		dwr.TOPEngine.setAsync(true);
   		if(documentId != "") {
			dwr.TOPEngine.setAsync(false);
			DocumentAction.queryDocumentById(documentId,function(bResult){
				Document = bResult;
			});
			dwr.TOPEngine.setAsync(true);
		}
   		if(Document.docTmplId){//编辑页面 
   			//docTempinitData = getDocTempDic(Document.docType);
   			docTempinitData = [{text:Document.docTemplateName,id:Document.docTmplId}];
   		}else{
   			docTempinitData = getDocTempDic('');
   		}
		comtop.UI.scan();
		if(!documentId) {
			var name = cui("#docTemplate").getText();
			var domainName = "";
			if(Domain.name){
				domainName = Domain.name;
			}
			cui("#name").setValue(domainName+name);
		}
		if(Document.docTmplId){
			cui("#docTemplate").setValue(Document.docTmplId);
		}
   }
	
	//文档模板下拉框数据 
	function docTypeData(obj){
		obj.setDatasource(docTempinitData);
	}
	
	function getDocTempDic(type){
		var initData = new Array();
		var data;
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
	
	
	//更换模板时，类型一起变化
	function changeTempalte(data){
		var name = data.text;
		var domainName = "";
		if(Domain.name){
			domainName = Domain.name;
		}
		cui("#name").setValue(domainName+name);
	}
	
	//关闭窗口
	function closeSelf(){
		window.parent.dialog.hide();
	}
	
	//保存文档 
	function saveDoc(){
		var map = window.validater.validAllElement();
		var inValid = map[0];
		var valid = map[1];
		//验证消息
		if(inValid.length > 0) { //验证失败
			var str = "";
			for(var i=0; i<inValid.length; i++) {
				str += inValid[i].message + "<br/>";
			}
		} else {
			Document.bizDomain = bizDomainId;
			Document.name = Document.name.trim();
			Document.summaryFlag = 'SUM';
			if(!Document.id){
				Document.status = '新增成功';
			}
			dwr.TOPEngine.setAsync(false);
			DocumentAction.saveDocument(Document, function(data){
				//刷新列表
        	    window.parent.editCallBack(data);
	 			//保存提示
				window.parent.cui.message('保存成功。','success');
				closeSelf();
			});
			dwr.TOPEngine.setAsync(true);
		}
	}
	
	var validateTempalte = [{'type':'required','rule':{'m':'文档模板不能为空。'}}];
	
	var validateName = [
	          	      {'type':'required','rule':{'m':'名称不能为空。'}},
	        	      {'type':'custom','rule':{'against':checkNameIsExist, 'm':'名称已经存在。'}}
	];
	
	//检验名称是否存在
  	function checkNameIsExist(data) {
  		var flag = true;
  		Document.name = Document.name.trim();
  		Document.bizDomain = bizDomainId;
  		dwr.TOPEngine.setAsync(false);
  		DocumentAction.isExistSameName(Document,function(bResult){
			flag = bResult;
		});
		dwr.TOPEngine.setAsync(true);
		return flag;
  	}
</script>
</body>
</html>