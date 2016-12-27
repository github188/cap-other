<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	<title>ϵͳ����>���ù���</title>
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
		<span uitype="button" label="��&nbsp;��" on_click="save"></span> 
		<span uitype="button" label="��&nbsp;��" on_click="closeSelf"></span>
	</div>
</div>
<table class="form_table">
	<tr>
		<td class="td_label" width="12%"><span class="top_required">*</span>ȫ����</td>
		<td>
			<span uitype="input" id="configClassifyFullCode" name="configClassifyFullCode"  databind="data.configClassifyFullCode" validate="validateConfigClassifyCode"></span>
		</td>
	</tr>
	<tr>
		<td class="td_label"><span class="top_required">*</span>����</td>
		<td>
			<span uitype="input" id="configClassifyName" name="configClassifyName" databind="data.configClassifyName" maxlength="80"  validate="validateConfigClassifyName"></span>
		</td>
	</tr>
	<tr>
		<td class="td_label">����</td>
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
       		{'type':'required','rule':{'m':'����д���÷������ơ�'}},
       		{'type':'custom','rule':{'against':isClassifyNameContainSpecial, 'm':'����ֻ��Ϊ��Ӣ�ġ����ֻ��»��ߡ�'}},
       		{'type':'custom','rule':{'against':checkNameUnique, 'm':'�����Ѵ��ڡ�'}}
       	],
       	validateConfigClassifyCode = [
       		{'type':'required','rule':{'m':'����д���÷�����롣'}},
       		{'type':'custom','rule':{'against':isClassifyCodeContainSpecial, 'm':'����ֻ��ΪӢ�ġ����֡��»��߻��š�'}},
       		{'type':'custom','rule':{'against':checkUnique, 'm':'�����Ѵ��ڡ�'}}
       	],
       	validateConfigClassifyDescription = [
       		{'type':'custom','rule':{'against':isDescContainSpecial, 'm':'�������ܺ���<���š�'}}
       	],
       	sysModule = "<c:out value='${param.sysModule}'/>",
		data={};
		
	window.onload = function(){
		if(classifyId){
			dwr.TOPEngine.setAsync(false);
			ConfigClassifyAction.showEditConfigClassifyPage(classifyId,function(result){
				cui(data).databind().setValue(result);
				comtop.UI.scan();
				//����ȫ�����ֵ
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

	//����
	function save(){
	 	var map = window.validater.validAllElement();
	    var inValid = map[0];  
	    //��֤��Ϣ
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
			//���»���������Ŀ
			if(classifyId){
				ConfigClassifyAction.saveConfigClassifyPage(vo,"update",function(){
					window.parent.refrushNode('edit',vo.configClassifyName,vo.configClassifyFullCode);
					window.parent.cui.message('�����޸ĳɹ�','success');
					closeSelf();
				});
			}else{	
				ConfigClassifyAction.saveConfigClassifyPage(vo,"save",function(){
					window.parent.refrushNode('add',vo.configClassifyName,vo.configClassifyFullCode);
					window.parent.cui.message('���������ɹ�','success');
					closeSelf();
				});
			}
		}
	}
	//�رմ���
	function closeSelf(){
		window.parent.dialog.hide();
	}
	
	//���ͬһ�������Ƿ�����������
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
	
	//�ж������Ƿ���������ַ�
	function isClassifyNameContainSpecial(){
		var name = data.configClassifyName;
		if(name == "")return true;
		var reg = new RegExp("^[\u4E00-\u9FA5A-Za-z0-9_]+$");
		return (reg.test(name));
	}

	//�ж������Ƿ���������ַ�
	function isClassifyCodeContainSpecial(){
		var name = data.configClassifyFullCode;
		if(name == "")return true;
		var reg = new RegExp("^[A-Za-z0-9_.]+$");
		return (reg.test(name));
	}

	//�ж������Ƿ���������ַ�
	function isDescContainSpecial(){
		var name = data.configClassifyDescription;
		if(name == "")return true;
		var reg = new RegExp("[<]");
		return (!reg.test(name));
	}
	
	//ȥ���ַ��еĿո�
	function trimSpace(value){
		var v = value.replace(/[ ]/g,"");
		return v;
	}

	//�������Ƿ�Ψһ
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
