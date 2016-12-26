<!doctype html>
<%
  /**********************************************************************
	* 文档模板编辑
	* 2015-11-9 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>文档模板编辑</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/eic/css/eic.css" type="text/css">
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.eic.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
</head>
<style>
	.form_table .divTitle{
		position:relative;
		background: url("<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/styledefine/images/title.png") 0 3px no-repeat;
		padding: 2px 5px 8px 15px;
	}
	.buttonDiv{
	float:right;
	margin-bottom:4px;
	margin-right:55px;
}
</style>
<body class="top_body">
	<div class="top_header_wrap" style="text-align: center;">
		<div class="thw_title">文档模板编辑</div>
			<div class="buttonDiv">
			<span uitype="button" on_click="btnSave" id="btnSave" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" hide="false" button_type="blue-button" disable="false" label="保存"></span> 
			<span uitype="button" id="btnBack" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/back_white.gif" hide="false" button_type="blue-button" disable="false" label="返回" on_click="btnBack"></span> 
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="16%" />
				<col width="34%" />
				<col width="16%" />
				<col width="34%" />
			</colgroup>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">名称<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="name" maxlength="40" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="CapDocTemplate.name" type="text" readonly="false" validate="nameValidate"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">文档类型<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="PullDown"  width="85%" label_field="text" editable="true" validate="[{'type':'required', 'rule':{'m': '文档类型不能为空！'}}]" mode="Single" empty_text="请选择" id="type" height="200" databind="CapDocTemplate.type" datasource="docTypeData"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">存储地址<span class="top_required">*</span>：</span></td>
					<td colspan="3">
						<span uitype="Input" maskoptions="{}" id="path" maxlength="128" byte="true" textmode="false" align="left" width="85%" databind="CapDocTemplate.path" type="text" readonly="false" validate="[{'type':'required', 'rule':{'m': '存储地址不能为空！'}}]"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">说明：</span></td>
					<td colspan="3">
						<span uitype="Textarea" relation="remark_tip" id="remark" height="100px" maxlength="250" byte="true" textmode="false" autoheight="false" width="94%" name="remark_Textarea" databind="CapDocTemplate.remark" readonly="false"></span>
						<br/><span style="color:#999;">您还能输入<label id="remark_tip" style="color: red;"></label>个字！</span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<top:script src="/cap/dwr/interface/CapDocTemplateAction.js" />

<script language="javascript"> 
	var CapDocTemplateId = "<c:out value='${param.CapDocTemplateId}'/>";
	var CapDocTemplate = {};
	var fromPage = "<c:out value='${param.fromPage}'/>";
	var docTypeData =  [
                		{"id": "BIZ_MODEL", "text":"业务模型说明书"},                   
                		{"id": "SRS", "text":"需求规格说明书"},
                		{"id": "HLD", "text":"概要设计说明书"},
                		{"id": "LLD", "text":"详细设计说明书"},
                		{"id": "DBD", "text":"数据库设计说明书"}
                	];
   	window.onload = function(){
   		init();
   	}
   	
   	//名称校验
   	var nameValidate =  [{
						   	 type: 'required',
						     rule: {
						         m: '名称不能为空！'
						     	   }
							},
							{
						     type: 'custom',
						     rule: {
						         against:'checkName',
						         m:'名称不能重复,请重新输入！'
							       }	
   						 }];
   	
   	//判断名字是否重复
   	function checkName(name){
   		var Parameter = {};
		Parameter.name = name;
		var flag = true;
		dwr.TOPEngine.setAsync(false);
		CapDocTemplateAction.queryCapDocTemplateCount(Parameter, function(bResult){
			if((CapDocTemplateId != "" && bResult >=1)){
				if(CapDocTemplate.docConfigType != "PRIVATE"){
					flag = false;
				}
			}
			if((CapDocTemplateId == "" && bResult >0)){
				flag = false;
			}
		});
		dwr.TOPEngine.setAsync(true);
		return flag;
	}
   	
	function init() {
		if(CapDocTemplateId != "") {
			dwr.TOPEngine.setAsync(false);
			CapDocTemplateAction.queryCapDocTemplateById(CapDocTemplateId,function(bResult){
				CapDocTemplate = bResult;
			});
			dwr.TOPEngine.setAsync(true);
		}
		if (typeof(myBeforeInit) == "function") {
			eval("myBeforeInit()");
		}

		comtop.UI.scan();
		
		var isHideAddNewContinueBtn = true;
		if(CapDocTemplateId=="" || CapDocTemplateId==null){
			isHideAddNewContinueBtn = false;
		}
		setAddNewContinueBtnIsHide(isHideAddNewContinueBtn);
		if (typeof(afterInit) == "function") {
			eval("afterInit()");
		}
		
		if (typeof(myAfterInit) == "function") {
			eval("myAfterInit()");
		}
		
		if("<c:out value='${param.readOnly}'/>" == "true") {
			comtop.UI.scan.setReadonly(true);
			cui("#btnSave").hide();
			cui("#btnBack").show();
			if (typeof(setReadonlyButton) == "function") {
				eval("setReadonlyButton()");
			}
		}
	}
	
	function setAddNewContinueBtnIsHide(isHide){
		if(cui("#btnAddNewContinue")!=null){
			if(isHide==true){
				cui("#btnAddNewContinue").hide();
			}else{
				cui("#btnAddNewContinue").show();
			}
			
		}
	}
	
	function btnAddNewContinue(){
		var saveSuccess = btnSave(false);
		if(saveSuccess){
			window.parent.cui.success('新增成功。',function(){
 	 			window.location.reload();
 	 		});
		}
	}
	
	function saveNoBack(){
		var saveSuccess = btnSave(false);
		if(saveSuccess){
			window.parent.cui.message('修改成功。','success');
		}
	}
	
	function btnSave(isBack) {
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
			if(str ==""){
				var Parameter = {};
				Parameter.name = CapDocTemplate.name;
				dwr.TOPEngine.setAsync(false);
				CapDocTemplateAction.queryCapDocTemplateCount(Parameter, function(bResult){
					if((CapDocTemplateId != "" && bResult >1)){
						if(CapDocTemplate.docConfigType == "PUBLIC"){
								str = "名称不能重复,请重新输入！";
						}
					}
					if((CapDocTemplateId == "" && bResult >0)){
						str = "名称不能重复,请重新输入！";
					}
				});
				dwr.TOPEngine.setAsync(true);
			}
			if(str !=""){
				cui.alert(str);
				return false;
			}
		}
	
		if (typeof(beforeSave) == "function") {
			eval("beforeSave()");
        }
        
		var result = true;
		if (typeof(myBeforeSave) == "function") {
			result = eval("myBeforeSave()");
        }
        if(!result && typeof(result) != "undefined"){
        	return;
        }
		if(!CapDocTemplateId || CapDocTemplateId===""){
			CapDocTemplate.docConfigType="PUBLIC";
		}	
		dwr.TOPEngine.setAsync(false);
		CapDocTemplateAction.saveCapDocTemplate(CapDocTemplate, function(bResult){
 			//保存数据
 			if(bResult && isBack) {
 				if(CapDocTemplate.id && CapDocTemplate.id != "") {
 					window.parent.cui.message('修改成功。','success');
 				} else {
 					CapDocTemplate.id = bResult;
 	 				window.parent.cui.message('新增成功。','success');
 				}
	 			setTimeout('btnBack()',1000);
 			}
 			CapDocTemplate.id = bResult;
		});
		dwr.TOPEngine.setAsync(true);

		if (typeof(myAfterSave) == "function") {
			eval("myAfterSave()");
        }
        // 保存成功
		return true;
	}
	

	
		//保存前处理事件
	function beforeSave() {
		alertMessage = "";
		if(!CapDocTemplate.creatorId){
			CapDocTemplate.creatorId = globalUserId;
		}
		
		CapDocTemplate.remark = cui("#remark").getValue();	  
	}

	//初始化后处理事件，回显操作
  	function afterInit(){
  	}




</script>
<top:script src="/cap/bm/doc/tmpl/js/DocTemplateEdit.js"/>
</body>
</html>