<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	<title>系统管理>配置管理</title>
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/js/jquery.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/engine.js'></script>
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/ConfigClassifyAction.js'></script>
</head>
<body>
<div class="top_header_wrap">
	<div class="thw_operate">
		<span uitype="button" label="保&nbsp;存" on_click="save"></span> 
		<span uitype="button" label="关&nbsp;闭" on_click="closeSelf"></span>
	</div>
</div>
<table class="form_table">
	<tr>
		<td class="td_label" width="12%"><span class="top_required">*</span>全编码</td>
		<td>
			<span uitype="input" id="configClassifyFullCode" name="configClassifyFullCode"  databind="data.configClassifyFullCode" validate="validateConfigClassifyCode"></span>
		</td>
	</tr>
	<tr>
		<td class="td_label"><span class="top_required">*</span>名称</td>
		<td>
			<span uitype="input" id="configClassifyName" name="configClassifyName" databind="data.configClassifyName" maxlength="80"  validate="validateConfigClassifyName"></span>
		</td>
	</tr>
	<tr>
		<td class="td_label">描述</td>
		<td>	
			<span uitype="textarea" name="configClassifyDescription" databind="data.configClassifyDescription" validate="validateConfigClassifyDescription" height="100px" maxlength="250"></span>
		</td>
	</tr>
</table>
<script type="text/javascript">
	var nodeId = "<c:out value='${param.pId}'/>",
		classifyId = "<c:out value='${param.classifyId}'/>",
		classifyFullCode = '',
		validateConfigClassifyName = [
       		{'type':'required','rule':{'m':'请填写配置分类名称。'}},
       		{'type':'custom','rule':{'against':isClassifyNameContainSpecial, 'm':'名称只能为中英文、数字或下划线。'}},
       		{'type':'custom','rule':{'against':checkNameUnique, 'm':'名称已存在。'}}
       	],
       	validateConfigClassifyCode = [
       		{'type':'required','rule':{'m':'请填写配置分类编码。'}},
       		{'type':'custom','rule':{'against':isClassifyCodeContainSpecial, 'm':'编码只能为英文、数字、下划线或点号。'}},
       		{'type':'custom','rule':{'against':checkUnique, 'm':'编码已存在。'}}
       	],
       	validateConfigClassifyDescription = [
       		{'type':'custom','rule':{'against':isDescContainSpecial, 'm':'描述不能含有<符号。'}}
       	],
       	sysModule = "<c:out value='${param.sysModule}'/>",
		data={};
		
	window.onload = function(){
		if(classifyId){
			dwr.TOPEngine.setAsync(false);
			ConfigClassifyAction.showEditConfigClassifyPage(classifyId,function(result){
				cui(data).databind().setValue(result);
				comtop.UI.scan();
				//设置全编码的值
				var tempFullCode = data.configClassifyFullCode;
				var index = tempFullCode.lastIndexOf(".");
				var classifyFullCode = tempFullCode.substr(index+1);
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			dwr.TOPEngine.setAsync(false);
			ConfigClassifyAction.showAddConfigClassifyPage(nodeId,sysModule,function(result){
				cui(data).databind().set('configClassifyFullCode',result);
				classifyFullCode = result;
				comtop.UI.scan();
			});
			dwr.TOPEngine.setAsync(true);
		}
	}

	//保存
	function save(){
	 	var map = window.validater.validAllElement();
	    var inValid = map[0];  
	    //验证消息
	    if (inValid.length ==0){ 
			var vo = cui(data).databind().getValue();
			vo.parentConfigClassifyId = nodeId;
			if(sysModule=='Yes'){
				vo.parentClassifyType = 'SYS_MODULE';
			}else{
				vo.parentClassifyType = 'UNI_CLASSIFY';
			}
			vo.isFlag = 1;
			vo.classifyType = 1;
			//更新或者新增项目
			if(classifyId){
				ConfigClassifyAction.saveConfigClassifyPage(vo,"update",function(){
					window.parent.refrushNode('edit',vo.configClassifyName,vo.configClassifyFullCode);
					window.parent.cui.message('分类修改成功','success');
					closeSelf();
				});
			}else{	
				ConfigClassifyAction.saveConfigClassifyPage(vo,"save",function(){
					window.parent.refrushNode('add',vo.configClassifyName,vo.configClassifyFullCode);
					window.parent.cui.message('分类新增成功','success');
					closeSelf();
				});
			}
		}
	}
	//关闭窗口
	function closeSelf(){
		window.parent.dialog.hide();
	}
	
	//检测同一分类下是否有重名分类
	function checkNameUnique(){
		var flag = true;
		var configClassifyName = data.configClassifyName;
		if(configClassifyName != ""){
			var classifyVO = {configClassifyName:configClassifyName,parentConfigClassifyId:nodeId,configClassifyId:classifyId};
			dwr.TOPEngine.setAsync(false);
			ConfigClassifyAction.isClassifyNameUnique(classifyVO,function(result){
				if(!result){
					flag = false;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}
	
	//判断名称是否包含特殊字符
	function isClassifyNameContainSpecial(){
		var name = data.configClassifyName;
		if(name == "")return true;
		var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_]+$");
		return (reg.test(name));
	}

	//判断名称是否包含特殊字符
	function isClassifyCodeContainSpecial(){
		var name = data.configClassifyFullCode;
		if(name == "")return true;
		var reg = new RegExp("^[A-Za-z0-9_.]+$");
		return (reg.test(name));
	}

	//判断描述是否包含特殊字符
	function isDescContainSpecial(){
		var name = data.configClassifyDescription;
		if(name == "")return true;
		var reg = new RegExp("[<]");
		return (!reg.test(name));
	}
	
	//去掉字符中的空格
	function trimSpace(value){
		var v = value.replace(/[ ]/g,"");
		return v;
	}

	//检测编码是否唯一
	function checkUnique(){
		var flag = true;
		var codeVal = data.configClassifyFullCode;
		if(codeVal != ""){
			var classifyVO = {parentConfigClassifyId:nodeId,configClassifyFullCode:codeVal,configClassifyId:classifyId};
			dwr.TOPEngine.setAsync(false);
			ConfigClassifyAction.queryConfigClassifyUnique(classifyVO,function(result){
				if(!result){
					flag = false;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		return flag;
	}

</script>
</body>
</html>
