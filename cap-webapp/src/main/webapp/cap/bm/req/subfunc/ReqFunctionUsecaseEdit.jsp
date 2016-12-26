<!doctype html>
<%
  /**********************************************************************
	* 功能用例
	* 2015-12-22 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>功能用例</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
</head>
<style>
	.form_table .divTitle{
		position:relative;
		background: url("<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/styledefine/images/title.png") 0 3px no-repeat;
		padding: 2px 5px 8px 15px;
	}
</style>
<body class="top_body">
	<div style="margin: 0 auto; width:auto;">
	<div class="top_header_wrap" style="text-align: center;">
			<div style="float:right">
			<span uitype="button" id="btnSave" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" on_click="btnSave" hide="false" button_type="blue-button" disable="false" label="保存"></span> 
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
						<span uitype="Input" id="name" maxlength="40" byte="true" textmode="false" databind="ReqFunctionUsecase.name" maskoptions="{}" align="left" width="85%" type="text" readonly="false" validate="[{'type':'required', 'rule':{'m': '名称不能为空！'}}]"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">使用级别：</span></td>
					<td>
						<span uitype="PullDown" select="-1" width="85%" label_field="text" value_field="id" must_exist="true" editable="true" mode="Multi" empty_text="请选择" id="useLevel" height="200" auto_complete="false" filter_fields="[]" databind="ReqFunctionUsecase.useLevel" readonly="false" datasource="initDataSource"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">业务说明：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="bizComment" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.bizComment" name="bizComment_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="bizComment"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.bizComment" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">业务规则：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="bizRule"  width="85%" min_frame_height="200" textmode="false" databind="ReqFunctionUsecase.bizRule" word_count="true" maximum_words="10000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">先决条件：</span></td>
					<td colspan="3">
						<span uitype="Textarea" id="premise" maxlength="-1" height="51px" byte="true" textmode="false" autoheight="false" width="85%" name="name" databind="ReqFunctionUsecase.premise" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">基本功能：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="baseFunction" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.baseFunction" name="baseFunction_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="baseFunction"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.baseFunction" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">辅助功能：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="auxiliaryFunction" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.auxiliaryFunction" name="auxiliaryFunction_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="auxiliaryFunction"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.auxiliaryFunction" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">提示信息：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="tipInfo" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.tipInfo" name="tipInfo_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="tipInfo"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.tipInfo" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">处理约束：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="dealConstraint" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.dealConstraint" name="dealConstraint_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="dealConstraint"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.dealConstraint" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">输入信息：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="inputInfo" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.inputInfo" name="inputInfo_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="inputInfo"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.inputInfo" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">输出信息：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" name="outputInfo_Textarea" readonly="false" textmode="false" autoheight="false" width="85%" id="outputInfo" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.outputInfo"></span> -->
						<span uitype="Editor" id="outputInfo"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.outputInfo" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">统计考核要素：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="evalFactor" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.evalFactor" name="evalFactor_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="evalFactor"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.evalFactor" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">非功能需求：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="nonfunctionReq" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.nonfunctionReq" name="nonfunctionReq_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="nonfunctionReq"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.nonfunctionReq" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">差异说明：</span></td>
					<td colspan="3">
<!-- 						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="differComment" maxlength="2000" height="51px" byte="true" databind="ReqFunctionUsecase.differComment" name="differComment_Textarea" readonly="false"></span> -->
						<span uitype="Editor" id="differComment"  width="85%" min_frame_height="50" textmode="false" databind="ReqFunctionUsecase.differComment" word_count="true" maximum_words="2000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">业务表单：</span></td>
					<td colspan="3">
						<span uitype="ClickInput" id="bizFormNames" databind="ReqFunctionUsecase.bizFormNames" width="85%"on_iconclick="chooseBizForm"></span>
						<span uitype="Button" on_click="btnClean" id="btnClean" button_type="blue-button" label="清空">
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">备注：</span></td>
					<td colspan="3">
						<span uitype="Textarea" textmode="false" autoheight="false" width="85%" id="remark" maxlength="250" height="51px" byte="true" databind="ReqFunctionUsecase.remark" name="remark_Textarea" readonly="false"></span>
					</td>
				</tr>
			</tbody>
		</table>
	</div>	</div>

	<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js" /> 
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" /> 
	<top:script src="/cap/dwr/interface/ReqFunctionUsecaseAction.js" />
	<top:script src="/cap/dwr/interface/ReqFunctionItemAction.js" />
	<top:script src="/cap/dwr/interface/ReqFunctionSubitemAction.js" />

<script language="javascript"> 
	var ReqFunctionSubitemId = "<c:out value='${param.ReqFunctionSubitemId}'/>";
	var ReqFunctionUsecase = {};
	var ReqFunctionItemId ="";
	var domainId = "";
	var bizFormIds;
	var initDataSource =[ {id:'公司',text:'公司'}, {id:'分子公司',text:'分子公司'}, {id:'层单位',text:'层单位'} ];
	toolbars=[[
	           'undo', //撤销
	           'redo', //重做
	           'bold', //加粗
	           'indent', //首行缩进
	           'italic', //斜体
	           'underline', //下划线
	           'strikethrough', //删除线
	           'time', //时间
	           'date', //日期
	           'inserttable', //插入表格
	           'insertrow', //前插入行
	           'insertcol', //前插入列
	           'mergeright', //右合并单元格
	           'mergedown', //下合并单元格
	           'deleterow', //删除行
	           'deletecol', //删除列
	           'splittorows', //拆分成行
	           'splittocols', //拆分成列
	           'splittocells', //完全拆分单元格
	           'deletecaption', //删除表格标题
	           'inserttitle', //插入标题
	           'mergecells', //合并多个单元格
	           'deletetable', //删除表格
	           'insertparagraphbeforetable', //"表格前插入行"
	           'fontfamily', //字体
	           'fontsize', //字号
	           'paragraph', //段落格式
	           'edittable', //表格属性
	           'edittd', //单元格属性
	           'link', //超链接
	           'spechars', //特殊字符
	           'justifyleft', //居左对齐
	           'justifyright', //居右对齐
	           'justifycenter', //居中对齐
	           'justifyjustify', //两端对齐
	           'forecolor', //字体颜色
	           'rowspacingtop', //段前距
	           'rowspacingbottom', //段后距
	           'pagebreak', //分页
	           'imagecenter', //居中
	           ]]
   	window.onload = function(){
   		init();
   	}
   	
	function init() {
		if(typeof dwrErrorHandle === "function") {
			//配置dwr全局异常处理方法
			dwr.TOPEngine.setErrorHandler(dwrErrorHandle);
		}
		if(ReqFunctionSubitemId != "") {
			dwr.TOPEngine.setAsync(false);
			ReqFunctionSubitemAction.queryReqFunctionSubitemById(ReqFunctionSubitemId,function(bResult){
				ReqFunctionItemId = bResult.itemId;
			});
			
			var ReqFunctionUsecaseVO = {};
			ReqFunctionUsecaseVO.subitemId = ReqFunctionSubitemId;
			ReqFunctionUsecaseAction.queryReqFunctionUsecaseList(ReqFunctionUsecaseVO,function(bResult){
				ReqFunctionUsecase = bResult.list[0];
			});
			dwr.TOPEngine.setAsync(true);
		}
	
		comtop.UI.scan();
		
		if(ReqFunctionUsecase.id){
			dwr.TOPEngine.setAsync(false);
			ReqFunctionUsecaseAction.queryReqUsecaseRelFormBysubitemId(ReqFunctionUsecase.id,function(bResult){
				if(bResult!=null){
					bizFormIds = bResult.bizFormId;
					cui("#bizFormNames").setValue(bResult.bizFormName);
				}else{
					cui("#btnClean").hide();
				}
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			cui("#btnClean").hide();
		}
		
		if(ReqFunctionItemId !=""){
			ReqFunctionItemAction.queryReqFunctionItemById(ReqFunctionItemId,function(bResult){
				domainId = bResult.bizDomainId;
			});
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
			if(str != ""){
				cui.alert(str);
				return false;
			}
		}
	
		if (typeof(beforeSave) == "function") {
			eval("beforeSave()");
        }
        
		var result = true;
        if(!result && typeof(result) != "undefined"){
        	return;
        }
			
		result = false;
		dwr.TOPEngine.setAsync(false);
		ReqFunctionUsecaseAction.saveReqFunctionUsecase(ReqFunctionUsecase, function(bResult){
 			//保存数据
 			if(bResult && isBack) {
 				if(ReqFunctionUsecase.id && ReqFunctionUsecase.id != "") {
 					window.parent.cui.message('修改成功。','success');
 				} else {
 					ReqFunctionUsecase.id = bResult;
 	 				window.parent.cui.message('新增成功。','success');
 				}
 			}
 			ReqFunctionUsecase.id = bResult;
 			result = true;
		});
		dwr.TOPEngine.setAsync(true);

		if (typeof(myAfterSave) == "function") {
			eval("myAfterSave()");
        }
        // 保存成功
		return result;
	}
	
	//选择业务表单
	function chooseBizForm(){
		var title="业务表单选择";
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/form/chooseMulForm.jsp?domainId="+domainId;
		var height = 800; //600
		var width =  1000; // 680;
		dialog = cui.dialog({
			title:title,
			src : url,
			top:0,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	//选择业务表单回调
	function chooseFormCallback(selects){
		var bizFormName = getArray(selects);
		if(bizFormIds == ""){
			cui.alert("选择的数据项已经导入。");
			return;
		}
		cui("#btnClean").show();
		cui("#bizFormNames").setValue(bizFormName);
	}
	
	//清空
	function btnClean(){
		bizFormIds = "";
		cui("#btnClean").hide();
		cui("#bizFormNames").setValue("");
	}
	
	//判断是否重复
	function getArray(selects){
		var formIds = "";
		var formNames = "";
		var ids = new Array();
		bizFormIds ="";
		if(bizFormIds !=""){
			ids = bizFormIds.split(",");
		}
		for(var i = 0;i<selects.length;i++){
			var flag = true;
			if(bizFormIds.length>0){
				for(var j =0;j<ids.length;j++){
					if(selects[i].id == ids[j]){
						flag = false;
						break;
					}
				}
			}
			if(flag){
				formIds += selects[i].id+",";
				formNames += selects[i].name+",";
			}
		}
		bizFormIds = formIds.substring(0,formIds.length-1);
		return formNames.substring(0,formNames.length-1);
	}
	//保存前处理事件
	function beforeSave() {
		alertMessage = "";
		ReqFunctionUsecase.bizComment = cui("#bizComment").getValue();	  
		ReqFunctionUsecase.premise = cui("#premise").getValue();	  
		ReqFunctionUsecase.baseFunction = cui("#baseFunction").getValue();	  
		ReqFunctionUsecase.auxiliaryFunction = cui("#auxiliaryFunction").getValue();	  
		ReqFunctionUsecase.tipInfo = cui("#tipInfo").getValue();	  
		ReqFunctionUsecase.dealConstraint = cui("#dealConstraint").getValue();	  
		ReqFunctionUsecase.inputInfo = cui("#inputInfo").getValue();	  
		ReqFunctionUsecase.outputInfo = cui("#outputInfo").getValue();	  
		ReqFunctionUsecase.evalFactor = cui("#evalFactor").getValue();	  
		ReqFunctionUsecase.nonfunctionReq = cui("#nonfunctionReq").getValue();	  
		ReqFunctionUsecase.differComment = cui("#differComment").getValue();	  
		ReqFunctionUsecase.remark = cui("#remark").getValue();	  
		ReqFunctionUsecase.bizFormIds = bizFormIds;
		ReqFunctionUsecase.subitemId = ReqFunctionSubitemId;
		ReqFunctionUsecase.dataFrom = 0;
	}

</script>
</body>
</html>