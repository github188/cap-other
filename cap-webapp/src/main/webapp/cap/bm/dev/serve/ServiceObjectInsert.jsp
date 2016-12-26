<%
  /**********************************************************************
	* 服务建模----服务实体创建页面
	* 2016-5-30 林玉千 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>

<!doctype html>
<html>
<head>
<title>服务新增</title>
	<top:link href="/cap/bm/common/top/css/top_base.css"></top:link>
	<top:link href="/cap/bm/common/top/css/top_sys.css"></top:link>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/ServiceObjectFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/ServiceAction.js'></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
.spanTop {
  font-family: "Microsoft Yahei";
  font-size: 20px;
  color: #0099FF;
  margin-left: 20px;
  float: left;
  line-height:45px;
}
.divTitle {
  font-family: "Microsoft Yahei";
  font-size: 14px;
  color: #0099FF;
  margin-left: 20px;
  float: left;
}
.editGrid{
  margin-left: 100px;
}
</style>
<body onload="window.status='Finished';">
<div uitype="Borderlayout" is_root="true" >
		<div class="top_header_wrap">
			<div class="divTitle">服务类基本信息</div>
			<div class="thw_operate">
<!-- 				<span uitype="button" id="btnEdit" label="编辑服务" on_click="editServiceObject"></span> -->
				<span uitype="button" id="btnSave" label="保  存" on_click="saveServiceObject"></span>
				<span uitype="button" label="注册服务" id="button_executeGenerateCode" on_click="generateCode" ></span>
<!-- 				<span uitype="button" id="btnCancel" label="取  消" on_click="cancel"></span> -->
				<span uitype="button" id="btnClose" label="关  闭" on_click="close"></span>
			</div>
		</div>
		<div class="top_content_wrap cui_ext_textmode">
			<table class="form_table" style="table-layout:fixed;">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
<!-- 				<tr><td colspan="4" class="divTitle">服务类基本信息</td></tr> -->
				<tr>
					<td class="td_label" >服务类全名：<br></td>	
			        <td colspan="3">
				      	<span uitype="input" id="objectPath" name="objectPath" databind="" maxlength="200" width="100%"></span>
					<td>
				</tr>
				<tr>
					<td class="td_label"><span class="top_required">*</span>服务类名：</td>
					<td><span uitype="input" id="englishName" name="englishName" databind="serviceObjectData.englishName" 
								validate="validateObjectEnName" maxlength="50" width="100%" on_keyup="englishNameKeyUp"></span>
					</td>
					<td class="td_label"><span class="top_required">*</span>服务类中文名：</td>
					<td><span uitype="input" id="chineseName" name="chineseName" databind="serviceObjectData.chineseName" validate="validateObjectCnName" maxlength="100" width="100%"></span></td>
				</tr>
				<tr>
					<td class="td_label"><span class="top_required">*</span>服务类别名：</td>
					<td ><span uitype="input" id="serviceAlias" name="serviceAlias" 
						databind="serviceObjectData.serviceAlias" validate="validateObjectAliasName" maxlength="50" width="100%" ></span>
					</td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<td class="td_label"><span class="top_required">*</span>类实体构造器：<br></td>	
			        <td colspan="3">
				      	<span uitype="PullDown" mode="Single" id="buildClass" name="buildClass" databind="serviceObjectData.buildClass" 
				      			datasource="buildClassData" select="0" validate="validateObjectBuildClass" maxlength="50" width="100%"></span>
					<td>
				</tr>
				<tr>
					<td class="td_label" valign="top">描述：</td>
					<td colspan="3" class="td_content" >
						<div style="width:100%;">
							<span uitype="textarea" id="description" name="description" databind="serviceObjectData.description" 
									relation="remarkLength" maxlength="300" width="100%"></span>
							<!-- <div style="float:right">
									<font id="remarkLengthFont" >(您还能输入<label id="remarkLength" style="color:red;"></label>&nbsp; 字符)</font>
							</div>
							 -->
						</div>
					</td>
				</tr>
				</table>
				<div id="methodDiv"  class="top_content_wrap cui_ext_textmode" align="center">
					<div class="top_header_wrap">
						<div class="divTitle">服务功能列表</div>
						<div class="thw_operate" id="operateDiv">
							<span uitype="button" id="btnMethodAdd" label="新增" on_click="addMethod"></span>
							<span uitype="button" id="btnMethodDel" label="删除" on_click="delMethod"></span>
						</div>
					</div>
					<div class="editGrid">
					<table uitype="Grid" id="MethodGrid" primarykey="id" sorttype="1" datasource="initMethodData" pagination="false"
					 	gridwidth="750px" resizewidth="resizeWidth"  gridheight="500px" resizeheight="resizeheight"  colrender="columnRenderer">
					 	<thead>
					 	<tr>
							<th style="width:50px"></th>
							<th bindName="engName" style="width:20%;" renderStyle="text-align: left;" render="englishNameEditLink">方法名称</th>
							<th bindName="chName" style="width:15%;" renderStyle="text-align: left;">中文名称</th>
							<th bindName="aliasName" style="width:15%;" renderStyle="text-align: left;">方法别名</th>
							<th bindName="returnType.type" style="width:15%;" renderStyle="text-align: center" render="returnTypeRender">返回值</th>
							<th bindName="parameters" style="width:20%;" renderStyle="text-align: center" render="parameterRender">参数列表</th>
<!-- 							<th bindName="lastReagistTime" format="yyyy-MM-dd hh:mm:ss" style="width:15%;" renderStyle="text-align: center">最后注册时间</th> -->
						</tr>
						</thead>
					</table>
					</div>
				</div>
		</div>
</div>

<script type="text/javascript">
	var packageId = "${param.packageId}";//应用ID 	
	var modelId = "${param.modelId}";//应用ID 	
	var packagePath = "${param.packagePath}";//包路径
	var editType = "${param.editType}";
	var serviceObjectData = {};//服务对象VO 
	var regEx = "^([A-Z])[a-zA-Z0-9_]*$";
	var buildClassData = [{id:'com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap',text:'com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap'}];
	
	var entityMethodVo;
	var isComeEntity = "";
	var originalAlias = "";
	
	var menu_gen_data = {
			 datasource:
				[						
				 {id:'gen_all',label:'生成所有代码',title:'生成所有后台facade代码与SOA服务脚本'},
            	 {id:'gen_sql',label:'生成SOA脚本',title:'生成并执行SOA服务相关脚本'},
            	 {id:'gen_biz',label:'生成业务代码',title:'生成后台facade代码'}
             	],
			 on_click: function(obj){
				 var type = obj.id;
				 var genType = 0;
				 if("gen_all" === type){
					 genType = 0;
				 }else if("gen_biz" === type){
					 genType = 1;
				 }else if("gen_sql" === type){
					 genType = 2;
				 }
				 generateCode(genType);
			 }
	};
	
	//初始化 
	window.onload = function(){
   		init();
   	}
	
	//初始化加载  	
   	function init() {
		//根据模块Id和包Id获取服务对象
   		loadServiceObject();
		
		if(serviceObjectData){
	 		serviceObjectData.packageId = packageId;
		}
		
   		comtop.UI.scan();
		cui("#buildClass").setValue("com.comtop.cap.runtime.spring.SoaBeanBuilder4Cap");
   		//设置服务路径
	   	setObjectPath();
   		//按钮隐藏控制、 页面只读控制
   		pageStausSet(editType);
   		//如果是从AppDetail.jsp操作 则关闭按钮显示，否则隐藏
   		if(parent.appInsertFlag == "true" || parent.appEditFlag == "true"){
   			cui("#btnClose").show();
   		}else{
   			cui("#btnClose").hide();
   		}
   	}
	
	//服务类名检测 
	var validateObjectEnName = [
		{'type':'required','rule':{'m':'服务类名不能为空。'}},
		{'type':'custom','rule':{'against':checkObjectEnNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以大写英文字符开头。'}},
		{'type':'custom','rule':{'against':checkObjectEnNameIsExist, 'm':'同级应用下服务类名已存在。'}}
	];
	
	//服务类名格式检测 
	function checkObjectEnNameChar(data) {
		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
	}
	
	//根据模块Id和包Id获取服务对象
	function loadServiceObject(){
		//获取VO
		dwr.TOPEngine.setAsync(false);
		ServiceObjectFacade.loadServiceObject(modelId,packageId,function(resultData){
			serviceObjectData = resultData;
			originalAlias = serviceObjectData.serviceAlias;
			//加载元数据类型转换 
			if(serviceObjectData.methods){
				for(var i=0;i<serviceObjectData.methods.length;i++){
					serviceObjectData.methods[i].returnType.type = getTypeId(serviceObjectData.methods[i].returnType.type);
					serviceObjectData.methods[i].accessLevel=getAccessLevelId(serviceObjectData.methods[i].accessLevel);
					if(serviceObjectData.methods[i].parameters){
						for(var k=0;k<serviceObjectData.methods[i].parameters.length;k++){
							if(serviceObjectData.methods[i].parameters[k].dataType){
								serviceObjectData.methods[i].parameters[k].dataType.type = getTypeId(serviceObjectData.methods[i].parameters[k].dataType.type);
							}
						}
					}
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//服务类名是否存在检测
	function checkObjectEnNameIsExist(englishName) {
		var flag = true;
  		dwr.TOPEngine.setAsync(false);
  		ServiceObjectFacade.isExistSameEnNameServiceObject(packagePath,englishName,modelId,function(bResult){
			flag = !bResult;
		});
		dwr.TOPEngine.setAsync(true);
		if(flag){
			if(englishName!=''){
				cui("#serviceAlias").setValue(englishName.substring(0,1).toLowerCase() + englishName.substring(1));
			}
		}
		return flag;
	}
	
	//服务类中文名检测 
	var validateObjectCnName = [
	      {'type':'required','rule':{'m':'服务类中文名不能为空。'}},
	      {'type':'custom','rule':{'against':checkObjectChNameIsExist, 'm':'服务类中文名已存在。'}}
	];
	
	//服务类中文名是否存在检测
	function checkObjectChNameIsExist(chineseName) {
		var flag = true;
  		dwr.TOPEngine.setAsync(false);
  		ServiceObjectFacade.isExistSameChNameServiceObject(packagePath,chineseName,modelId,function(bResult){
			flag = !bResult;
		});
		dwr.TOPEngine.setAsync(true);
		return flag;
	}
	
	//服务别名检测 
	var validateObjectAliasName = [
		{'type':'required','rule':{'m':'服务类别名不能为空。'}},
		{'type':'custom','rule':{'against':checkObjectAliasNameChar, 'm':'必须为英文字符、数字或者下划线，且必须以小写英文字符开头。'}},
		{'type':'custom','rule':{'against':checkObjectAliasNameIsExist, 'm':'系统中服务类别名已存在。'}}
	];
	
	//服务类别名是否存在检测
	function checkObjectAliasNameIsExist(serviceAlias) {
		var flag = true;
  		dwr.TOPEngine.setAsync(false);
  		ServiceObjectFacade.isExistSameAliasNameServiceObject(serviceAlias,modelId,function(bResult){
			flag = !bResult;
		});
		dwr.TOPEngine.setAsync(true);
		return flag;
	}
	
	 //校验实体名称字符
  	function checkObjectAliasNameChar(data) {
  		var regEx = "^([a-z])[a-zA-Z0-9_]*$";
  		if(data){
			var reg = new RegExp(regEx);
			return (reg.test(data));
		}
		return true;
  	}
	
	//类构造器检测 
	var validateObjectBuildClass = [{'type':'required','rule':{'m':'类实体构造器不能为空。'}}];
	
	//设置服务路径
	function setObjectPath(){
		var objectPath = packagePath;
   		if(serviceObjectData.englishName){
   			objectPath += ".facade." + serviceObjectData.englishName + "Facade";
   		}
   		cui("#objectPath").setValue(objectPath);
	}
	
	//按钮隐藏控制、 页面只读控制
	function pageStausSet(editType){
		if(editType == "read" && modelId){
   			buttonCanSave(false);
   			comtop.UI.scan.setReadonly(true);
   			cui('.top_required').hide();
   			$('#remarkLengthFont').hide();
   			cui('#aliasNote').hide();
   		}else if(editType == "read" && !modelId){
   			buttonCanSave(false);
   			comtop.UI.scan.setReadonly(true);
   			cui('.top_required').hide();
   			$('#remarkLengthFont').hide();
   			cui('#aliasNote').hide();
   			cui("#btnEdit").hide();
			cui("#button_executeGenerateCode").hide();
   		}else if(editType == "insert"){
   			buttonCanSave(true);
   			comtop.UI.scan.setReadonly(false);
   			cui("#objectPath").setReadonly(true);
   			cui('.top_required').show();
   			$('#remarkLengthFont').show();
   			cui('#aliasNote').show();
   		}else if(editType == "edit"){
   			buttonCanSave(true);
   			comtop.UI.scan.setReadonly(false);
   			cui("#objectPath").setReadonly(true);
   			cui("#englishName").setReadonly(true);
   			cui("#serviceAlias").setReadonly(true);
   			cui('.top_required').show();
   			$('#remarkLengthFont').show();
   			cui('#aliasNote').hide();
   		}else{
   			buttonCanSave(true);
   			comtop.UI.scan.setReadonly(false);
   			cui("#objectPath").setReadonly(true);
   			cui('.top_required').show();
   			$('#remarkLengthFont').show();
   			cui('#aliasNote').show();
   		}
	}
	
	//编辑区域按钮控制
	function buttonCanSave(flag){
		if(flag){
			cui("#btnEdit").hide();
			cui("#button_executeGenerateCode").show();
			cui("#btnSave").show();
			cui("#btnCancel").show();
			cui("#btnMethodAdd").show();
			cui("#btnMethodDel").show();
		}else{
			cui("#btnEdit").show();
			cui("#button_executeGenerateCode").show();
			cui("#btnSave").show();
			cui("#btnCancel").hide();
			cui("#btnMethodAdd").hide();
			cui("#btnMethodDel").hide();
		}
	}
	
	//编辑englishName时更新服务路径 
	function englishNameKeyUp(event,self){
		var objectPath = packagePath;
		var englishNameValue = cui("#englishName").getValue();
		if(englishNameValue){
			objectPath = objectPath + ".facade." + englishNameValue + "Facade";
		}
   		cui("#objectPath").setValue(objectPath);
	}
	
	//编辑事件 
	function editServiceObject(){
		parent.editLoad(modelId);	
	}
	
	//保存事件 
	function saveServiceObject(){
		var map = window.validater.validAllElement();
		var inValid = map[0];
		var valid = map[1];
		//验证消息
		if(inValid.length > 0) { //验证失败
			var str = "";
			for(var i=0; i<inValid.length; i++) {
				str += inValid[i].message + "<br/>";
			}
			return;
		}
		
		var aliasChange = false;
		if(originalAlias != serviceObjectData.serviceAlias && editType != 'insert'){
			aliasChange = true;
		}
		
		if(aliasChange){
			cui.confirm("服务类别名修改后，所有方法需要重新注册！\n 是否继续保存？",{
				onYes:function(){
					saveData(aliasChange);
				}
			});
		}else{
			saveData(aliasChange);
		}
	}
	//保存数据
	function saveData(aliasChange){
		//包装服务对象
		wrapperServiceObjectData();
		
		dwr.TOPEngine.setAsync(false);
		ServiceObjectFacade.saveServiceObject(serviceObjectData,function(data){
			  if(data){
				  parent.selectedObjectId = serviceObjectData.modelId;
				  if(editType == 'insert'){
					  parent.refreshGrid(true);
				  }else{
					  parent.refreshGrid(false);
				  }
				  //如果是从AppDeail.jsp入口，保存成功后需要刷新父窗口
				  if(window.parent){
					if(window.parent.opener){
						window.parent.opener.refresh();
					}
				  }
				  cui.message('保存成功！', 'success');
				  init();
			  }else{
				  cui.error("保存失败！"); 
			  }
		});
		dwr.TOPEngine.setAsync(true);
		pageStausSet("edit");
		
	}
	//包装服务对象数据
	function wrapperServiceObjectData(){
		serviceObjectData.packageId = packageId;
		serviceObjectData.modelType = "serve";
		serviceObjectData.modelName = serviceObjectData.englishName;
		serviceObjectData.modelPackage = packagePath;
		serviceObjectData.modelId = serviceObjectData.modelPackage+"."+serviceObjectData.modelType+"."+serviceObjectData.modelName;
		//创建模型前转换优化数据
		if(serviceObjectData.methods){
			for(var i=0;i<serviceObjectData.methods.length;i++){
				var type = serviceObjectData.methods[i].returnType.type;
				serviceObjectData.methods[i].returnType.type = getTypeString(serviceObjectData.methods[i].returnType.type);
				//如果类型为"7":实体; "8":集合; 为其他时就是基本类型
				if(type == "7"){
					serviceObjectData.methods[i].returnType.source = "entity";
					serviceObjectData.methods[i].returnType.generic = null;
				}else if(type == "8"){
					serviceObjectData.methods[i].returnType.source = "collection";
				}else{
					serviceObjectData.methods[i].returnType.source = "primitive";
					serviceObjectData.methods[i].returnType.generic = null;
					serviceObjectData.methods[i].returnType.value = "";
				}
				//空方法
				serviceObjectData.methods[i].methodType = "blank";
				//公有方法
				serviceObjectData.methods[i].accessLevel = "public";
				if(serviceObjectData.methods[i].parameters){
					for(var k=0;k<serviceObjectData.methods[i].parameters.length;k++){
						if(serviceObjectData.methods[i].parameters[k].dataType){
							var typeTemp = serviceObjectData.methods[i].parameters[k].dataType.type;
							serviceObjectData.methods[i].parameters[k].dataType.type = getTypeString(serviceObjectData.methods[i].parameters[k].dataType.type);
							//如果类型为"7":实体; "8":集合; 为其他时就是基本类型
							if(typeTemp == "7"){
								serviceObjectData.methods[i].parameters[k].dataType.source = "entity";
								serviceObjectData.methods[i].parameters[k].dataType.generic = null;
							}else if(typeTemp == "8"){
								serviceObjectData.methods[i].parameters[k].dataType.source = "collection";
							}else{
								serviceObjectData.methods[i].parameters[k].dataType.source = "primitive";
								serviceObjectData.methods[i].parameters[k].dataType.value = "";
								serviceObjectData.methods[i].parameters[k].dataType.generic = null;
							}
						}
					}
				}
			}
		}
	}
	
	//获取类型名称
	function getAccessLevelId(accessLevelId) {
		var strAccessLeve = "";
		switch (accessLevelId) {
			case "public":
				strAccessLeve = 3;
				break;
			default:
				strAccessLeve = 3;
		}		
		return strAccessLeve;
	}
	
	function soaRegist(){
		cui("#MethodGrid").loadData();
	}
	
	//取消事件 
	function cancel(){
		parent.cancelLoad(modelId);	
	}
	var refreshMethodData = false;
	//注册成功后方法回调
	function registSuccessCallBack () {
		refreshMethodData = true;
		cui("#MethodGrid").loadData();
	}
	
	//方法数据源
	function initMethodData(tableObj,query) {
		if(refreshMethodData) {		//需要刷新methodData
			dwr.TOPEngine.setAsync(false);
			ServiceObjectFacade.queryMethodByModelId(modelId,function(data){
			    tableObj.setDatasource(data.list, data.count);
				serviceObjectData.methods = data.list;
			});
			refreshMethodData = false;
			dwr.TOPEngine.setAsync(true);

		}else {
			if(serviceObjectData && serviceObjectData.methods){
				var lst = serviceObjectData.methods;
	 			if(lst && lst.length > 0) {
	 				tableObj.setDatasource(lst, lst.length);
	 			}else {
	 				tableObj.setDatasource([], 0);
	 			}
			}else{
				tableObj.setDatasource([], 0);
			}
		}
	}
	//方法名渲染
	function englishNameEditLink(rd, index, col) {
		var methodName = rd.engName;
		if(editType == "read" ) {
			return methodName;
 		}else{
 			return "<a href='javascript:;' onclick='updateMethod(\"" +rd.engName+ "\",\""+rd.id+"\");'>" +methodName + "</a>";
 		}
 		
	}
	
	//grid列渲染
	function returnTypeRender(rd, index, col) {
		return getTypeString(rd.returnType.type);
	}
	
	//获取类型名称
	function getTypeString(iType) {
		var strReturnType = "";
		switch (iType) {
			case "-1":
				strReturnType = "void";
				break;
			case "0":
				strReturnType = "int";
				break;
			case "1":
				strReturnType = "String";
				break;
			case "2":
				strReturnType = "boolean";
				break;
			case "3":
				strReturnType = "double";
				break;
			case "4":
				strReturnType = "java.sql.Date";
				break;
			case "5":
				strReturnType = "java.sql.Timestamp";
				break;
			case "6":
				strReturnType = "java.lang.Object";
				break;
			case "7":
				strReturnType = "Entity";
				break;
			case "8":
				strReturnType = "java.util.List";
				break;
			default:
				strReturnType = "void";
		}		
		return strReturnType;
	}
	
	//获取类型名称
	function getTypeId(iType) {
		var strReturnType = "";
		switch (iType) {
			case "void":
				strReturnType = "-1";
				break;
			case "int":
				strReturnType = "0";
				break;
			case "String":
				strReturnType = "1";
				break;
			case "boolean":
				strReturnType = "2";
				break;
			case "double":
				strReturnType = "3";
				break;
			case "java.sql.Date":
				strReturnType = "4";
				break;
			case "java.sql.Timestamp":
				strReturnType = "5";
				break;
			case "java.lang.Object":
				strReturnType = "6";
				break;
			case "Entity":
				strReturnType = "7";
				break;
			case "java.util.List":
				strReturnType = "8";
				break;
			default:
				strReturnType = "-1";
		}		
		return strReturnType;
	}
	
	//grid列渲染
	function parameterRender(rd, index, col) {
		var objParameters = rd.parameters;
		strReturnType = "(" 
		if(objParameters && objParameters.length && objParameters.length > 0) {
			for(var i = 0 ; i < objParameters.length; i++) {
				if(i != 0) {
					strReturnType += ","
				}
				strReturnType += getParamTypeString(objParameters[i]) +　" " + objParameters[i].engName;
			}
		}
		strReturnType += ")" 
		return strReturnType;
	}
	
	//获取类型名称
	function getParamTypeString(paramVO) {
		var iType = paramVO.dataType;
		if(paramVO.dataType){
			iType = paramVO.dataType.type;
		}
		var strReturnType = "";
		switch (iType) {
			case "0":
				strReturnType = "int";
				break;
			case "1":
				strReturnType = "String";
				break;
			case "2":
				strReturnType = "boolean";
				break;
			case "3":
				strReturnType = "double";
				break;
			case "4":
				strReturnType = "Date";
				break;
			case "5":
				strReturnType = "Timestamp";
				break;
			case "6":
				strReturnType = "Object";
				break;
			case "7":
				var value = '';
				if(paramVO.dataType.value){
					value = paramVO.dataType.value;
					value = value.substring(value.lastIndexOf(".")+1)+"VO";
				}
				strReturnType = value;
				break;
			case "8":
				strReturnType = "List";
				break;
			default:
				strReturnType = "";
		}		
		return strReturnType;
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 110;
	}
	
	//grid 宽度
	function resizeheight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 400;
	}
	
	var dialog;
	//新增服务方法事件 
	function addMethod(){
		var url = getEditMethodUrl("","insert");
		var title="服务功能新增";
		var height = 600; //600
		var width =  800; // 680;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			page_scroll : true,
			height : height
		})
		dialog.show(url);
	}
	
	// 编辑服务方法
	function updateMethod(englishName,id) {
		
		for(var i= 0 ; i <  serviceObjectData.methods.length; i++) {
			if((id && id == serviceObjectData.methods[i].id) || englishName == serviceObjectData.methods[i].engName) {
				entityMethodVo = serviceObjectData.methods[i];
				break;
			}
		}
		
		var url = getEditMethodUrl(id,"edit");
		var title="服务功能编辑";
		var height = 500; //600
		var width =  780; // 680;
		if(!dialog){
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				page_scroll : true,
				height : height
			});
		}
		dialog.show(url);
	}
	
	//服务方法页面参数信息
	function getEditMethodUrl(mId,type) {
		if(!mId) {
			mId = "";
 		}
		var retStr = "ServiceMethodEdit.jsp"; 
		retStr = retStr + "?modelId=" + modelId + "&packageId=" + packageId +"&packagePath=" + packagePath +"&isComeEntity=" + isComeEntity + "&type=" +type;
		if(mId) {
			retStr = retStr + "&methodId=" + mId;
		}
		return retStr;
	}
	
	//新增参数回调
 	function addMethodBack(mVo) {
 		var added = false;
 		if(serviceObjectData.methods && serviceObjectData.methods.length) {
	 		//ID或者英文名称相同则替换
	 		for(var i= 0 ; i < serviceObjectData.methods.length; i++) {
	 			var o1 = serviceObjectData.methods[i];
	 			if((o1.id != null && o1.id == mVo.id)|| o1.engName == mVo.engName) {
	 				serviceObjectData.methods[i] = mVo;
	 				added = true;
	 				break;
	 			}
	 		}
 		}else {
 			serviceObjectData.methods =  new Array();
 		}
 		//没有替换则新增
 		if(!added) {
 			serviceObjectData.methods.push(mVo);
 		}
 		//刷新页面
 		cui("#MethodGrid").loadData();
		if(mVo && mVo.id) {
			cui("#MethodGrid").selectRowsByPK(mVo.id);
		}
	}
	
 	//校验方法别名 -- true 为通过，false为重名 
	function checkEnNameExist(mVo,type){
		var existFlag = true;
		var repeat = 0;
		if(serviceObjectData.methods && serviceObjectData.methods.length) {
	 		for(var i= 0 ; i < serviceObjectData.methods.length; i++) {
	 			var o1 = serviceObjectData.methods[i];
	 			if(type == 'insert' && o1.engName == mVo.engName){
	 				repeat = 2;
	 				break;
	 			}else if(o1.engName == mVo.engName){
	 				++repeat;
	 			}
	 		}
	 		if(repeat>1){
	 			existFlag = false;
	 		}
 		}
		return existFlag;
	}
	
	//校验方法别名 -- true 为通过，false为重名 
	function checkAliasNameExist(mVo,type){
		var existFlag = true;
		var repeat = 0;
		if(serviceObjectData.methods && serviceObjectData.methods.length) {
	 		for(var i= 0 ; i < serviceObjectData.methods.length; i++) {
	 			var o1 = serviceObjectData.methods[i];
	 			if(type == 'insert' && o1.aliasName == mVo.aliasName){
	 				repeat = 2;
	 				break;
	 			}else if(o1.aliasName == mVo.aliasName){
	 				++repeat;
	 			}
	 		}
	 		if(repeat>1){
	 			existFlag = false;
	 		}
 		}
		return existFlag;
	}
	
	//删除事件 
	function delMethod(){
		var params = serviceObjectData.methods;
 		var selects = cui("#MethodGrid").getSelectedRowData();
		if(selects != null && selects.length > 0){
			cui.confirm("确定要删除这"+selects.length+"个方法吗？",{
				onYes:function(){
					serviceObjectData.methods = removeArray(params,selects);
					cui("#MethodGrid").loadData();
				}
			});
		}else {
			cui.alert("请选择需要删除的参数。");
		}
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
	
	//注册服务
	function generateCode(){
		createCustomHM();
		ServiceAction.executeGenerateCodeByModelId(modelId,packageId, function(msg){
				removeCustomHM();
				if ("" == msg ){
					window.top.cui.message('注册服务成功。','success');
				}else{
					window.top.cui.message(msg,'error');
				}
		});
	}
	
	var objHandleMask;
	//生成遮罩层
	function createCustomHM(){
		objHandleMask = cui.handleMask({
	        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在注册服务，预计需要2~3分钟，请耐心等待。</div>'
	    });
		objHandleMask.show();
	}

	//生成遮罩层
	function removeCustomHM(){
		objHandleMask.hide();
	}
	//如果是从App主页进入，则关闭按钮有效
	function close(){
		if(window.parent){
			window.parent.close();
		}else{
			window.close();
		}
	}
</script>
</body>
</html>