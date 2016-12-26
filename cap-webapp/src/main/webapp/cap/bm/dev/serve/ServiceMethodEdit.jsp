<%
  /**********************************************************************
	* 服务能力处理 ----服务方法编辑
	* 2016-5-30 林玉千 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>

<!doctype html>
<html>
<head>
<title>服务方法编辑页面</title>
	<top:link href="/cap/bm/common/top/css/top_base.css" ></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css" ></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/codeMirror/lib/codemirror.css" ></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">服务方法信息编辑</div>
		<div class="thw_operate">
			<span id="saveBtn" uitype="button" label="保存" on_click="save"></span> 
			<span uitype="button" label="关闭" on_click="closeWin"></span>
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr >
				<td class="divTitle" colspan="4">基本信息</td>
			</tr>
				<td class="td_label"><span class="top_required">*</span>方法名称：</td>
				<td><span uitype="input" id="engName" name="engName" databind="entityMethodVo.engName" 
							validate="validateMethodEnName" maxlength="50" onkeyup="setAliasName()"></span>
				</td>
				<td class="td_label"><span class="top_required">*</span>中文名称：</td>
				<td><span uitype="input" id="chName" name="chName" databind="entityMethodVo.chName" 
							validate="validateMethodCnName" maxlength="100"></span></td>
			</tr>
			<tr>
				<td class="td_label"><span class="top_required">*</span>访问级别：</td>
				<td >
					<span uitype="SinglePullDown" id="accessLevel" validate="访问级别必须填写" databind="entityMethodVo.accessLevel"  
							value_field="id" label_field="text" datasource="accessLevelData" value="3" ></span>
				</td>
				<td class="td_label"><span class="top_required">*</span>方法别名：</td>
				<td><span uitype="input" id="aliasName" name="aliasName" databind="entityMethodVo.aliasName" 
							validate="validateMethodAliasName" maxlength="50"></span>
				</td>
			</tr>
			<tr>
				<td class="td_label"><span class="top_required">*</span>返回值类型：</td>
				<td>
					<span uitype="SinglePullDown" id="returnType" validate="返回值类型必须填写" databind="entityMethodVo.returnType.type"  
								value_field="id"  label_field="text" on_change="changeReturnType"  datasource="returnTypeDataSource" value="-1"></span>
				</td>
				<td class="td_label"><span id="entityLabel"><span class="top_required">*</span>返回值实体：</span><span id="genericLabel">返回值泛型：</span></td>
				<td><span uitype="ClickInput" id="returnEntityName"  name="returnEntityName" on_iconclick="selEntity"></span>
					<span uitype="ClickInput" id="returnGenericName" name="returnGenericName" on_iconclick="selGeneric"></span>
				</td>
			</tr>
			<tr>
				<td class="td_label" valign="top">描述：</td>
				<td colspan="3" class="td_content" >
					<div style="width:100%;">
							<span uitype="textarea" id="description" name="description" databind="entityMethodVo.description" 
									relation="remarkLength" maxlength="300" width="90%"></span>
							<!-- <div style="float:right">
									<font id="remarkLengthFont" >(您还能输入<label id="remarkLength" style="color:red;"></label>&nbsp; 字符)</font>
							</div>
							 -->
					</div>
				</td>
			</tr>
				
		</table>
	</div>
	
	<div id="paramDiv"  class="top_content_wrap cui_ext_textmode" >
		<div class="top_header_wrap">
			<div class="divTitle">参数列表</div>
			<div class="thw_operate" id="paramButtonDiv">
				<span id="addParam" uitype="button" label="新增" on_click="addParam"></span>
				<span id="upParam" uitype="button" label="向上" on_click="sortParam"></span>
				<span id="downParam" uitype="button" label="向下" on_click="sortParam"></span>
				<span id="delParam" uitype="button" label="删除" on_click="delParam"></span>
			</div>
		</div>
		<table uitype="Grid" id="EntityMethodParamGrid" primarykey="parameterId" sorttype="DESC" sortName="sortNo"
			datasource="initParamData" pagination="false" oddevenrow="true"
		 	resizewidth="resizeWidth" gridheight="auto" >
		 	<thead>
		 	<tr>
				<th style="width:50px"><input type="checkbox"/></th>
				<th bindName="engName" renderStyle="text-align: left;" render="englishNameRenderer">参数名称</th>
				<th bindName="chName" renderStyle="text-align: center" >中文名称</th>
				<th bindName="dataType.type" renderStyle="text-align: center" render="dataTypeRenderer">参数类型</th>
			</tr>
			</thead>
		</table>
	</div>
	<div id="exceDiv"  class="top_content_wrap cui_ext_textmode" >
		<div class="top_header_wrap">
			<div class="divTitle">异常列表</div>
			<div class="thw_operate" id="exceptionButtonDiv">
				<span id="selException" uitype="button" label="选择" on_click="selException"></span>
				<span id="delException" uitype="button" label="删除" on_click="delException"></span>
			</div>
		</div>		
		<table uitype="Grid" id="EntityMethodExceGrid" primarykey="id" sorttype="DESC" 
			datasource="initExceData" pagination="false" oddevenrow="true"
		 	resizewidth="resizeWidth" gridheight="auto" >
		 	<thead>
		 	<tr>
				<th style="width:50px"><input type="checkbox"/></th>
				<th bindName="engName" style="width:30%;" renderStyle="text-align: center" sort="true">异常名</th>
				<th bindName="modelPackage" style="width:30%;" renderStyle="text-align: left;" sort="true">包名</th>
				<th bindName="chName" style="width:30%;" renderStyle="text-align: center" sort="true">中文名称</th>
				<th bindName="message" style="width:30%;" renderStyle="text-align: center" sort="true">异常消息</th>
			</tr>
			</thead>
		</table>
	</div>

	<script type="text/javascript">
	var modelId = "${param.modelId}";//服务对象ID
	var packagePath = "${param.packagePath}";//包路径
	var packageId = "${param.packageId}";//应用ID 	
	var methodId = "${param.methodId}";//包ID
	var type = "${param.type}";//包ID
	var isComeEntity = "${param.isComeEntity}";//是否来源于实体
	var regEx = "^([a-z])[a-zA-Z0-9_]*$";
	
	var entityMethodVo = $.extend(true, {}, parent.entityMethodVo);
	var parameterVO = new Array();
	var dataTypeValueTemp = getReturnTypeValue();
	var lastTimeSetReturnType = getReturnType();
	
	// 返回值类型
	returnTypeDataSource = [
	                        {id:"-1",text:"void"},
	                        {id:"0",text:"int"},
	                        {id:"1",text:"String"},
	                        {id:"2",text:"boolean"},
	                        {id:"3",text:"double"},
	                        {id:"4",text:"java.sql.Date"},
	                        {id:"5",text:"java.sql.Timestamp"},
	                        {id:"6",text:"java.lang.Object"},
	                        {id:"7",text:"Entity"},
	                        {id:"8",text:"java.util.List"}
	                       ];
	// 访问级别下拉选项
	accessLevelData = [
	        	       {id:"3",text:"public"}
	 ];
	
   	window.onload = function(){
   		init();
   	}
   	
   	function getReturnTypeValue(){
   		if(entityMethodVo.returnType){
   			return entityMethodVo.returnType.value;
   		}else{
   			return "";
   		}
   	}
   	
   	function getReturnType(){
   		if(entityMethodVo.returnType){
   			return entityMethodVo.returnType.type;
   		}else{
   			return "";
   		}
   	}
   	
   	//初始化数据
	function init() {
		if(!entityMethodVo || type == 'insert') {
			entityMethodVo = {};
		}
		comtop.UI.scan();
		
		cui("#EntityMethodExceGrid").loadData();
		cui("#EntityMethodParamGrid").loadData();
				
		changeReturnType({id:entityMethodVo.returnType.type});
		
		if(isComeEntity == "entity"){
			comtop.UI.scan.setReadonly(true);
			cui("#methodAlias").setReadonly(false);
			cui("#addParam").hide();
			cui("#upParam").hide();
			cui("#downParam").hide();
			cui("#delParam").hide();
			cui("#selException").hide();
			cui("#delException").hide();
			$('#remarkLengthFont').hide();
		}else{
			comtop.UI.scan.setReadonly(false);
			cui("#addParam").show();
			cui("#upParam").show();
			cui("#downParam").show();
			cui("#delParam").show();
			cui("#selException").show();
			cui("#delException").show();
			$('#remarkLengthFont').show();
		}
		if(type=="edit"){
			cui("#aliasName").setReadonly(true);
		}
	}
	
	//参数列表grid列渲染
	function dataTypeRenderer(rd, index, col) {
		var strDataType = "";   
		if(rd.dataType){
			switch (rd.dataType.type) {
			case "0":
				strDataType = "int";
				break;
			case "1":
				strDataType = "String";
				break;
			case "2":
				strDataType = "boolean";
				break;
			case "3":
				strDataType = "double";
				break;
			case "4":
				strDataType = "java.sql.Date";
				break;
			case "5":
				strDataType = "java.sql.Timestamp";
				break;
			case "6":
				strDataType = "java.lang.Object";
				break;
			case "7":
				strDataType = "Entity";
				break;
			case "8":
				strDataType = "java.util.List";
				break;
			default:
				strDataType = "int";
			} 
		}
		return strDataType;
	}
 	
	//保存
	function save() {
		var map = window.validater.validAllElement();
		var inValid = map[0];
		var valid = map[1];
		//验证消息
		if(inValid.length > 0) { //验证失败
			var str = "";
			for(var i=0; i<inValid.length; i++) {
				str += inValid[i].message + "<br/>";
			}
			return ;
		}
		parent.addMethodBack(entityMethodVo);
		closeWin();
	}
	
	function closeWin() {
		parent.dialog.hide();
	}
 	
	//选择实体
 	function selEntity() {
		var url = "../page/designer/EntityListSelectionMain.jsp?packageId=" + packageId+"&callBackMethod=selEntityBack";
		var title="选择实体";
		var height = 450; //600
		var width =  680; // 680;
		var top=(window.screen.availHeight-600)/2;
		var left=(window.screen.availWidth-800)/2;
		window.open (url,'entitySelect','height=450,width=680,top='+top+',left='+left+',toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')
	}
	var genericDialog ;
 	//选择泛型
 	function selGeneric() {
		var url = "../entity/SetEntityAttributeGeneric.jsp?packageId=" + packageId + "&modelId=";
		var title="属性泛型设置";
		var height = 450; //600
		var width =  680; // 680;
		
		genericDialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		genericDialog.show(url);
	}
 	
 	//获取方法返回类型泛型列表
	function getDataTypeGenericList(){
		if(!entityMethodVo.returnType.generic){
			entityMethodVo.returnType.generic = [{source:"primitive",type:"String",value:"String"}];
		}
		return entityMethodVo.returnType.generic;
	}
	//获取方法返回类型
	function getDataType(){
		return parent.getTypeString(entityMethodVo.returnType.type)
	}
	
	//泛型设置回调
	function setGeneric(genericString,genericDataList){
		entityMethodVo.returnType.value = genericString;
		entityMethodVo.returnType.generic = genericDataList;
		cui("#returnGenericName").setValue(genericString);
		setDataTypeValueTemp(genericString);
		if(genericDialog){
			genericDialog.hide();
		}
	}
	
 	//选择实体回调
 	function selEntityBack(vo) {
 		entityMethodVo.returnEntityId = vo.id;
 		entityMethodVo.returnType.value=vo.modelId;
		cui("#returnEntityName").setValue(vo.modelId);
		setDataTypeValueTemp(vo.modelId);
 	}
	//新增参数
 	function addParam() {
 		eval("parameterVO = {methodId:\""+ methodId + "\",dataType:{type:\"1\"}}");
 		openParamEdit();
	}
 	
	function setDataTypeValueTemp(value){
		dataTypeValueTemp = value;
	}
	
 	//打开参数编辑
 	function editParam(id) {
 		for(var i= 0 ; i <  entityMethodVo.parameters.length; i++) {
			if(id == entityMethodVo.parameters[i].editRemark) {
				parameterVO = entityMethodVo.parameters[i];
				break;
			}
		}
		openParamEdit(id);
 	}
 	//打开参数编辑
 	function openParamEdit(editRemarkId) {
 		if(!editRemarkId){
 			editRemarkId = '';
 		}
		var url = "ServiceMethodPramEdit.jsp?modelId=" + modelId + "&packageId=" + packageId +"&packagePath=" + packagePath +  "&methodId=" + methodId +"&editRemarkId=" + editRemarkId; 
		var title="参数编辑";
		var height = 450; //600
		var width =  350; // 680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height,
			onClose : function() {
				cui("#EntityMethodParamGrid").loadData();
			}
		})
		dialog.show(url);
	}
 	//新增参数回调
 	function addParamBack(pVo) {
 		var added = false;
 		if(entityMethodVo.parameters && entityMethodVo.parameters.length) {
	 		//ID或者英文名称相同则替换
	 		for(var i= 0 ; i < entityMethodVo.parameters.length; i++) {
	 			var o1 = entityMethodVo.parameters[i];
	 			if((o1.editRemark != null && o1.editRemark == pVo.editRemark)|| o1.engName == pVo.enghName) {
	 				entityMethodVo.parameters[i] = pVo;
	 				added = true;
	 				break;
	 			}
	 		}
 		}else {
 			entityMethodVo.parameters =  new Array();
 		}
 		//没有替换则新增
 		if(!added) {
	 		entityMethodVo.parameters.push(pVo);
 		}
 		setParamSortNo();
 		//刷新页面
 		cui("#EntityMethodParamGrid").loadData();
	}
 	//设置参数排序
 	function setParamSortNo() {
 		//设置排序
 		for(var i= 0 ; i < entityMethodVo.parameters.length; i++) {
 			entityMethodVo.parameters[i].sortNo = i;
 		}
 	}
 	
 	//选择异常
 	function selException() {
		var url = "../entity/ExceptionList.jsp?packageId=" + packageId+"&fromServiceObject=true";
		var title="选择异常";
		var height = 400; //600
		var width =  700; // 680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
 	
 	//选择异常回调
 	function selExceptionBack(pVos) {
 		if(!entityMethodVo.exceptions || !$.type(entityMethodVo.exceptions)==="array") {
 			entityMethodVo.exceptions = new Array();
 		}
 		//选择多个异常
 		if($.type(pVos)==="array") {
 			entityMethodVo.exceptions = removeArray(entityMethodVo.exceptions,pVos);
 			for(var i = 0; i < pVos.length ; i++) {
 				entityMethodVo.exceptions.push(pVos[i]);
 			}
 		}else {
 			entityMethodVo.exceptions = removeArray(entityMethodVo.exceptions,[pVos]);
 			entityMethodVo.exceptions.push(pVos);
 		}
 		
 		cui("#EntityMethodExceGrid").loadData();
 	}
 	
 	//删除异常
 	function delException() {
 		var tableObj = cui("#EntityMethodExceGrid");
 		var selects = cui("#EntityMethodExceGrid").getSelectedRowData();
		if(selects != null && selects.length > 0){
			cui.confirm("确定要删除这"+selects.length+"个异常吗？",{
				onYes:function(){
					entityMethodVo.exceptions = removeArray(entityMethodVo.exceptions,selects);
					initExceData(cui("#EntityMethodExceGrid"));
				}
			});
		}else {
			cui.alert("请选择需要删除的异常。");
		}
 	}
 	
 	//删除参数
 	function delParam() {
 		var params = entityMethodVo.parameters;
 		var selects = cui("#EntityMethodParamGrid").getSelectedRowData();
		if(selects != null && selects.length > 0){
			cui.confirm("确定要删除这"+selects.length+"个参数吗？",{
				onYes:function(){
					entityMethodVo.parameters = removeArray(params,selects);
					cui("#EntityMethodParamGrid").loadData();
				}
			});
		}else {
			cui.alert("请选择需要删除的参数。");
		}
 	}
 	
 	//grid数据源
	function initParamData(tableObj,query){
 		if(entityMethodVo && entityMethodVo.parameters) {
	 		for(var i = 0 ; i < entityMethodVo.parameters.length ; i++) {
	 				entityMethodVo.parameters[i].editRemark = "remark" + i;
	 		}
 			var lst = entityMethodVo.parameters;
 			if(lst && lst.length > 0) {
 				tableObj.setDatasource(lst, lst.length);
 			}else {
 				tableObj.setDatasource([], 0);
 			}
 		}else {
			tableObj.setDatasource([], 0);
		}
	}
		
 	//grid数据源
	function initExceData(tableObj,query){
		if(entityMethodVo) {
 			var lst = entityMethodVo.exceptions;
 			if(lst && lst.length > 0) {
 				tableObj.setDatasource(lst, lst.length);
 			}else {
 				tableObj.setDatasource([], 0);
 			}
 		}
	}
 	
	//上移或者下移，sortType 为 up 或者 down
	function sortParam(event,el){
		//取选中的记录
		var selectRow = cui("#EntityMethodParamGrid").getSelectedRowData();
		if(selectRow.length  == 0){
			cui.alert("没有选中记录。");
			return ;
		}
		if(selectRow.length  > 1){
			cui.alert("每次只能选择一条记录进行排序。");
			return ;
		}
		
		var type='';
		if(el.options.label=='向上'){
			type='up';
		}else {
			type='down';
		}
		
		var selectRowIndex = parseInt(cui("#EntityMethodParamGrid").getSelectedIndex());
		if(type==='up') {
			if(selectRowIndex == 0) {
				cui.alert("已经置顶了");
				return ;
			}
			var tmp = entityMethodVo.parameters[selectRowIndex - 1];
			//交换
			entityMethodVo.parameters[selectRowIndex - 1] = entityMethodVo.parameters[selectRowIndex];
			entityMethodVo.parameters[selectRowIndex - 1].sortNo = selectRowIndex - 1;
			entityMethodVo.parameters[selectRowIndex] = tmp;
			entityMethodVo.parameters[selectRowIndex].sortNo = selectRowIndex;
			selectRowIndex--;
		}else {
			if(selectRowIndex == (entityMethodVo.parameters.length - 1)) {
				cui.alert("已经置底了");
				return ;
			}
			var tmp = entityMethodVo.parameters[selectRowIndex + 1];
			//交换
			entityMethodVo.parameters[selectRowIndex + 1] = entityMethodVo.parameters[selectRowIndex];
			entityMethodVo.parameters[selectRowIndex + 1].sortNo = selectRowIndex + 1;
			entityMethodVo.parameters[selectRowIndex] = tmp;
			entityMethodVo.parameters[selectRowIndex].sortNo = selectRowIndex;
			selectRowIndex++;
		}
		
		cui("#EntityMethodParamGrid").loadData();
		cui("#EntityMethodParamGrid").selectRowsByIndex(selectRowIndex,true);
	}
 	
	//切换返回值类型
 	function changeReturnType(v) {
 		//根据id不同控制文本框及label的显示与隐藏
 		if(v && v.id && (v.id == "7")) {
 			cui("#entityLabel").show();
 			cui("#returnEntityName").show();
 			cui("#genericLabel").hide();
 			cui("#returnGenericName").hide();
  			cui("#returnGenericName").setValue("");
  			if(lastTimeSetReturnType == v.id){
	  			cui("#returnEntityName").setValue(dataTypeValueTemp);
  			}else{
  				lastTimeSetReturnType = v.id;
  				dataTypeValueTemp = "";
  				cui("#returnEntityName").setValue("");
  			}
  			
 			//添加验证
 			window.validater.disValid(cui("#returnEntityName"),false);
 			window.validater.add(cui("#returnEntityName"), 'required', {
			        m:'请选择返回值实体！'
			});
 		}else if(v && v.id && (v.id == "8")) {
 			cui("#genericLabel").show();
 			cui("#returnGenericName").show();
 			cui("#entityLabel").hide();
 			cui("#returnEntityName").hide();
 			cui("#returnEntityName").setValue("");
 			if(lastTimeSetReturnType == v.id){
 				cui("#returnGenericName").setValue(dataTypeValueTemp);
 			}else{
 				lastTimeSetReturnType = v.id;
 				dataTypeValueTemp = "";
 				cui("#returnGenericName").setValue("");
 			}
 			//清除验证
 			window.validater.disValid(cui("#returnEntityName"),true);
 		}else {
 			cui("#entityLabel").hide();
 			cui("#genericLabel").hide();
 			cui("#returnEntityName").hide();
 			cui("#returnGenericName").hide();
 			lastTimeSetReturnType = v.id;
 			dataTypeValueTemp = "";
 			//清除验证
 			window.validater.disValid(cui("#returnEntityName"),true);
 		}
 	}
	
 	//grid列渲染
	function englishNameRenderer(rd, index, col) {
 		if(isComeEntity == "entity"){
 			return rd.engName;
 		}else{
 			return "<a href='javascript:;' onclick='editParam(\"" +rd.editRemark+ "\");'>" +rd.engName + "</a>";
 		}
	}
 	
 	//方法名称检测 
	var validateMethodEnName = [
	      {'type':'required','rule':{'m':'方法名称不能为空。'}},
	      {'type':'custom','rule':{'against':checkMethodEnNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'}},
	      {'type':'custom','rule':{'against':checkNameExist, 'm':'当前服务下已存在同名方法。'}}
	    ];
 	
	//检查方法英文名称字符
	function checkMethodEnNameChar(data) {
		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}
	
	//给别名赋值 同步录入方法别名
	function setAliasName(){
		var engName = cui("#engName").getValue();
		engName = engName.replace(/(^\s*)|(\s*$)/g, "");//去掉前后空格
		cui("#aliasName").setValue(engName.substring(0,1).toLowerCase() + engName.substring(1));
	}
	
	//判断方法签名是否存在
	function checkNameExist(data) {
		var flag = parent.checkEnNameExist(entityMethodVo,type);
		return flag;
	}
	
	//方法中文名称检测 
	var validateMethodCnName = [
	      {'type':'required','rule':{'m':'中文名称不能为空。'}}
	];
	
	//方法别名检测 
	var validateMethodAliasName = [
	      {'type':'required','rule':{'m':'方法别名不能为空。'}},
	      {'type':'custom','rule':{'against':checkMethodEnNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'}},
	      {'type':'custom','rule':{'against':checkAliasNameExist, 'm':'当前服务下已存在同名别名。'}}
	    ];
 	
	//别名检测 
	function checkAliasNameExist(data) {
		return parent.checkAliasNameExist(entityMethodVo,type);
	}
 	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//从一个数组中删除其他数组的元素
 	function removeArray(source, target) {
 		var newParams = new Array();
 		if(!$.type(source)==="array") {
 			return newParams;
 		}else if(!$.type(source)==="array") {
 			return source;
 		}
 		
 		for(var i = 0 ; i < source.length; i++) {
			var o1 = source[i];
			var bDel = false;
			for(var j = 0 ; j < target.length ; j++) {
				var o2 = target[j];
				if((o1.id != null && o1.id == o2.id)|| o1.engName == o2.engName) {
					bDel = true;
					break;
				}
			}
			if(!bDel) {
				newParams.push(o1);
			}
		}
 		return newParams;
 	}

</script>
</body>
</html>