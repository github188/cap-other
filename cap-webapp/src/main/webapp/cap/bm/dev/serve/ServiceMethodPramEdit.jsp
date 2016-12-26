<!doctype html>
<%
  /**********************************************************************
	*  服务建模---方法参数编辑
	* 2016-6-1 林玉千 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>

<html>
<head>
<title>方法参数编辑页面</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_title">方法参数信息编辑</div>
		<div class="thw_operate">
			<span uitype="button" label="保存" on_click="save"></span> 
			<span uitype="button" label="关闭" on_click="close"></span>
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<td class="td_label"><span class="top_required">*</span>参数名称：</td>
				<td><span uitype="input" id="engName" name="engName" enable="false"
					databind="parameterVO.engName" validate="validateEnName" maxlength="50"></span>
				</td>
			</tr>
			<tr>
				<td class="td_label"><span class="top_required">*</span>中文名称：</td>
				<td>
					<span uitype="input" id="chName" name="chName" databind="parameterVO.chName" 
						validate="validateCnName" ></span>
				</td>
			</tr>
			<tr>	
				<td class="td_label"><span class="top_required">*</span>参数类型：</td>
				<td><span uitype="SinglePullDown" id="dataType" name="dataType" on_change="changeDataType"  validate="参数类型必须填写"
					databind="parameterVO.dataType.type" datasource="dataTypeDataSource" value="1" ></span>
				</td>
			</tr>
			<tr>
				<td class="td_label"><span id="entityLabel"><span class="top_required">*</span>参数实体：</span><span id="genericLabel">参数泛型：</span></td>
				<td><span uitype="ClickInput" id="entityName" name="entityName"  on_iconclick="selEntity" maxlength="100"></span>
					<span uitype="ClickInput" id="genericName" name="genericName"  on_iconclick="selGeneric" maxlength="100"></span>
					</td>
			</tr>
		</table>
	</div>
	<script type="text/javascript">
	var projectId = "${param.projectId}";//工程ID
	var entityId = "${param.entityId}";//实体ID
	var packageId = "${param.packageId}";//包位置
	var modelId = "${param.modelId}";//包ID
	var editRemarkId = "${param.editRemarkId}";//参数ID
    var parameterVO = $.extend(true, {}, parent.parameterVO);
	var dataTypeValueTemp = getReturnTypeValue();
	var lastTimeSetReturnType = getReturnType();
	
    var regEx = "^(?![0-9_])[a-zA-Z0-9_]+$";
  	//参数名称检测 
	var validateEnName = [
	      {'type':'required','rule':{'m':'参数名称不能为空。'}},
	      {'type':'custom','rule':{'against':checkEnNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以英文字符开头。'}},
	      {'type':'custom','rule':{'against':checkNameExist, 'm':'当前方法下已存在同名参数。'}}
	    ];
	
	function getReturnTypeValue(){
   		if(parameterVO.dataType){
   			return parameterVO.dataType.value;
   		}else{
   			return "";
   		}
   	}
   	
   	function getReturnType(){
   		if(parameterVO.dataType){
   			return parameterVO.dataType.type;
   		}else{
   			return "";
   		}
   	}
  	
	//检查参数文名称字符
	function checkEnNameChar(data) {
		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}
	//检查参数名称是否重复
	var validateNameMsg = "";
	function checkNameExist(data) {
		var flag = true;
		if(parent.entityMethodVo.parameters){
			for(var i=0;i<parent.entityMethodVo.parameters.length;i++){
				exsitParam = parent.entityMethodVo.parameters[i];
				if(exsitParam.engName.indexOf(parameterVO.engName)>-1 && exsitParam.editRemark !=editRemarkId){
					flag = false;
					break;
				}
	 		}
		}
		return flag;
	}
	
	//参数中文名称检测 
	var validateCnName = [
	      {'type':'required','rule':{'m':'参数中文名称不能为空。'}}
	    ];
	
    //参数类型
	dataTypeDataSource = [
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
   	window.onload = function(){
   		init();
   	}
   	
	function init() {
		comtop.UI.scan();
		changeDataType({id:parameterVO.dataType.type});
	}
	
	
 	//选择实体
 	function selEntity() {
 		var url = "../entity/SelSystemModelMain.jsp?sourcePackageId=" + packageId + "&isSelSelf=true&sourceEntityId=&openType=newWin";
		var title="选择目标实体";
		var height = 400; 
		var width =  300; 
	    var top=(window.screen.height-30-height)/2;
	    var left=(window.screen.width-10-width)/2;
	    window.open(url, "ParameterEdit_setEntity", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	}
 	
 	  //关联实体属性选择界面
	var selGeneric=function(){
		var url = "../entity/SetEntityAttributeGeneric.jsp?packageId=" + packageId + "&modelId=&openType=newWin";
		var title="属性泛型设置";
		var width=700; //窗口宽度
	    var height=600;//窗口高度
	    var top=(window.screen.height-30-height)/2;
	    var left=(window.screen.width-10-width)/2;
	    window.open(url, "ParameterEdit_setGeneric", "Scrollbars=no,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);
	};
	
	//获取参数泛型列表
	function getGenericList(){
		if(!parameterVO.dataType.generic){
			parameterVO.dataType.generic = [{source:"primitive",type:"String",value:"String"}];
		}
		return parameterVO.dataType.generic;
	}
	//获取参数类型
	function getType(){
		return parent.parent.getTypeString(parameterVO.dataType.type)
	}
	
	//泛型设置回调
	function setGeneric(genericString,genericDataList){
		parameterVO.dataType.value = genericString;
		parameterVO.dataType.generic = genericDataList;
		cui("#genericName").setValue(genericString);
		setDataTypeValueTemp(genericString);
	}
	
 	//选择父实体回调
 	function selEntityBack(data) {
		parameterVO.entityId = data.id;
		parameterVO.dataType.value = data.modelId;
		cui("#entityName").setValue(data.modelId);
		setDataTypeValueTemp(data.modelId);
 	}
 	
	function setDataTypeValueTemp(value){
		dataTypeValueTemp = value;
	}
 	
 	//保存参数
 	function save() {
 		if(!validateVO()) {
			return ;
		}
 		//判断中英文名称 是否重复
 		if(parent.entityMethodVo.parameters){
 			var engCount = 0;
 			var chCount = 0;
 			var exsitParam;
 			var msg = "";
 			for(var i=0;i<parent.entityMethodVo.parameters.length;i++){
 				exsitParam = parent.entityMethodVo.parameters[i];
 				if(exsitParam.engName.indexOf(parameterVO.engName)>-1){
 					engCount++;
 				}
 				if(exsitParam.chName.indexOf(parameterVO.chName)>-1){
 					chCount++;
 				}
 	 		}
 	 		if(editRemarkId && engCount>1){ //编辑,英文名称重复
 	 			msg += "参数名称已存在。\n";
 	 		}
 	 		if(editRemarkId && chCount>1){ //编辑,中文名称重复
 	 			msg += "中文名称已存在。\n";
 	 		}
 	 		if(!editRemarkId && engCount > 0){ //新增,英文名称重复
 	 			msg += "参数名称已存在。\n";
 	 		}
 	 		if(!editRemarkId && chCount > 0){ //新增,中文名称重复
 	 			msg += "中文名称已存在。";
 	 		}
 	 		if(msg != ""){
 	 			cui.alert(msg);
 	 			return;
 	 		}
 		}
 		parent.addParamBack(parameterVO);
 		close();
 	}
 	//验证
	function validateVO() {
		
		var map = window.validater.validAllElement();
		var inValid = map[0];
		var valid = map[1];
		//验证消息
		if(inValid.length > 0) { //验证失败
			var str = "";
			for(var i=0; i<inValid.length; i++) {
				str += inValid[i].message + "<br/>";
			}
			return false;
		}
		return true;
	}
	
 	function close() {
 		window.parent.dialog.hide();
 	}
 	//数据类型变动
 	function changeDataType(v) {
 		if(v && v.id && (v.id == "7")) {
 			cui("#entityLabel").show();
 			cui("#entityName").show();
 			cui("#genericLabel").hide();
 			cui("#genericName").hide();
 			cui("#genericName").setValue("");
 			if(lastTimeSetReturnType == v.id){
	  			cui("#entityName").setValue(dataTypeValueTemp);
  			}else{
  				lastTimeSetReturnType = v.id;
  				dataTypeValueTemp = "";
  				cui("#entityName").setValue("");
  			}
 			//添加验证
 			window.validater.disValid(cui("#entityName"),false);
 			window.validater.add(cui("#entityName"), 'required', {
			        m:'请选择参数实体！'
			});
 		}else if(v && v.id && (v.id == "8")){
 			cui("#entityLabel").hide();
 			cui("#entityName").hide();
 			cui("#genericLabel").show();
 			cui("#genericName").show();
 			cui("#entityName").setValue("");
 			if(lastTimeSetReturnType == v.id){
 				cui("#genericName").setValue(dataTypeValueTemp);
 			}else{
 				lastTimeSetReturnType = v.id;
 				dataTypeValueTemp = "";
 				cui("#genericName").setValue("");
 			}
 			//清除验证
 			window.validater.disValid(cui("#entityName"),true);
 		}else {
 			cui("#entityLabel").hide();
 			cui("#genericLabel").hide();
 			cui("#entityName").hide();
 			cui("#genericName").hide();
 			lastTimeSetReturnType = v.id;
 			dataTypeValueTemp = "";
 			//清除验证
 			window.validater.disValid(cui("#entityName"),true);
 		}
 	}
</script>
</body>
</html>