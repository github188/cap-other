<%
/**********************************************************************
* 数据库管理编辑页面
* 2016-10-20 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>数据库管理编辑页面</title>
    <top:link href="/cap/rt/common/base/css/base.css"/>
    <top:link href="/cap/rt/common/base/css/comtop.cap.rt.css"/>
    <top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
    <style type="text/css">
    	.cap-page{
    		width: 100%;
    		min-width: 600px;
    		padding: 0;
    	}
    </style>
	<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
	<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
	<top:script src='/cap/rt/common/globalVars.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.extend.dictionary.js'></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/DbconfigCroEditPageAction.js'></top:script>
	<top:script src='/cap/bm/cdp/js/CdpCinfigUtils.js'></top:script>
	<top:script src='/cap/dwr/interface/CdpConfigAction.js'></top:script>
	<top:verifyRight resourceString="[{menuCode:'cap_cdp_dbconfigCroEditPage'}]"/> 
    
</head>
<body>
<div id="pageRoot" class="cap-page">
<div class="cap-area" style="width:100%;">
	<table id="tableid-34423556085675955" class="cap-table-fullWidth">
		<tr id="trid-9196089173201472">
			<td id="tdid-5912058073095977" class="cap-td" style="text-align:right;" >
            	<span id="btnSave" uitype="Button" ></span>
            	<span id="btnBackTo" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-6134405015247633" class="cap-table-fullWidth">
		<tr id="trid-5479869417121071">
			<td id="tdid-838346278252321" class="cap-td"  >
            	<span id="uiid-8540977048157212" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-05607273534523004" class="cap-table-fullWidth">
		<tr id="trid-017819934741363075">
			<td id="tdid-10166753149024974" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-2420474107821456" uitype="Label" ></span>
			</td>
			<td id="tdid-10109003587246514" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-0181795463035204" uitype="Input" ></span>
			</td>
			<td id="tdid-9850726308948943" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-4865024767896672" uitype="Label" ></span>
			</td>
			<td id="tdid-63805791035326195" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-6996581833341573" uitype="PullDown" ></span>
			</td>
		</tr>
		<tr id="trid-027996920967588">
			<td id="tdid-5029880867856134" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-29851713098348103" uitype="Label" ></span>
			</td>
			<td id="tdid-8377159979421901" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-03165974068145161" uitype="Input" ></span>
			</td>
			<td id="tdid-4265782546628448" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-33350522997116926" uitype="Label" ></span>
			</td>
			<td id="tdid-22370240706960328" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-5423529546022953" uitype="PullDown" ></span>
			</td>
		</tr>
		<tr id="trid-09839222129205087">
			<td id="tdid-6969430401990002" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="usernameLabel" uitype="Label" ></span>
			</td>
			<td id="tdid-30678449263136287" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-09121105982163609" uitype="Input" ></span>
			</td>
			<td id="tdid-4158124260932051" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="passwordLabel" uitype="Label" ></span>
			</td>
			<td id="tdid-8679697932228711" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-037101431246525785" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-040156205462369665">
			<td id="tdid-5895784550115175" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="databaseUrlLabel" uitype="Label" ></span>
			</td>
			<td id="tdid-13964790241301387" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-03806945158097078" uitype="Input" ></span>
			</td>
			<td id="tdid-7342651260693243" class="cap-td" style="text-align:right;width:20%;" >
			</td>
			<td id="tdid-9886493601274368" class="cap-td" style="text-align:right;width:30%;" >
			</td>
		</tr>
		<tr id="trid-6685453387056319">
			<td id="tdid-1349570546807939" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-3121942489507017" uitype="Label" ></span>
			</td>
			<td id="tdid-13575592564304664" class="cap-td" style="text-align:left;width:80%;" colspan='3'>
            	<span id="uiid-06750266387599365" uitype="Textarea" ></span>
			</td>
		</tr>
	</table>
</div>
</div>
</body>

<script type="text/javascript">
var primaryValue=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("primaryValue"))%>;
var pageMode=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("pageMode"))%>;
var id=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("id"))%>;
var envId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("envId"))%>;
var envtype=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("envtype"))%>;


cap.dicDatas=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("dicDatas"))%>;


var databaseConfig={};

var dbconfigCroListPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/evcontralEditPage.ac'+'?id='+envId;

		
//页面初始化数据加载行为 页面初始化数据加载行为
function pageInitLoadData(){
	//TODO 加载数据前操作
	if(!id){
     id =  primaryValue;
    }
	var paramArray =[];
	cap.formId = id;
	var param = "id";
    if (param) {
       paramArray = param.split(",");
    }
	if(!cap.isUndefinedOrNullOrBlank(cap.formId) && paramArray.length>0){
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.DatabaseConfig';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.DatabaseConfig';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'loadById',paramArray);
		dwr.TOPEngine.setAsync(false);
		DbconfigCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
			//TODO 数据设置前操作
         cui("#uiid-03165974068145161").setReadonly(true);
			databaseConfig=result;
			//TODO 数据设置后操作

		},
		errorHandler:function(message, exception){
		   //TODO 后台异常信息回调

		}
		});
		dwr.TOPEngine.setAsync(true);
	}else{
		var defaultValue = {};
		var expression = "default";
		//TODO 改变expression

		switch (expression){
			case "default":
				defaultValue = <%=com.comtop.cip.json.JSON.toJSONStringWithDateFormat(request.getAttribute("databaseConfig"),"yyyy-MM-dd HH:mm:ss")%>;
				break;
			//TODO 增加case控制

		}
		databaseConfig = defaultValue ? defaultValue : {};
	}
	//TODO 数据加载完成后操作

}
	

		
//保存表单行为 保存表单行为
function saveForm(){
	//校验前操作
databaseConfig.envId =envId;
	var saveContinue=4;
	if(cap.validateForm()){
		cap.beforeSave();
		//提交数据前操作
	if(!databaseConfig.creator||!databaseConfig.createTime){
			databaseConfig.creator = globalUserId;
			databaseConfig.createTime = new Date();
		}
		var paramArray = [];
		var paramsStr = 'databaseConfig';
		if(paramsStr != ''){
			paramArray = paramsStr.split(',');
		}
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.DatabaseConfig';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.DatabaseConfig';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'save',paramArray);
		var result;
		dwr.TOPEngine.setAsync(false);
		DbconfigCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(_result){
			//赋值前操作
			result = _result;
			if(""!="databaseConfig.id"){
				eval("databaseConfig.id=_result");
			}

			
			//默认保存成功
			var type = 'success';
			var message = '保存成功！';
			
			cui.message(message, type,{'callback':function(){
				//回调的操作

				if(type != "success"){
					return;
				}
				var pWindow = cap.searchParentWindow("reloadGridData");
				if(pWindow && typeof pWindow["reloadGridData"] === "function"){
					pWindow["reloadGridData"]();
				}
				if(saveContinue==1){
					window.location=window.location;
				}else if(saveContinue==2){
					window.close();
				}else if(saveContinue==4){
					var reloadURL = window.location.href;
					var localURL = window.location.href;
					if(localURL.indexOf("?")>0){
						if(localURL.indexOf("primaryValue")<0){
							reloadURL = localURL +"&primaryValue="+databaseConfig.id; 
						}
					}else{
						reloadURL = localURL +"?primaryValue="+databaseConfig.id; 
					}
					window.location.href=reloadURL;
				}
			}});
    	},
    	errorHandler:function(message, exception){
		   //TODO 后台异常信息回调
		   var type = 'error';
		   var message ="保存失败,存在异常信息:"+message;

		   cui.message(message);
		}
    	});
    	dwr.TOPEngine.setAsync(true);
	}
	//TODO 可自定义设置返回值

}
	

		
/*
 * 点击按钮跳转页面 点击按钮跳转页面
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function backTo(event, self, mark) { 
	var pageJumpURL=cap.getforwardURL(dbconfigCroListPage);
	var container=window;
	//TODO  调用后台前处理逻辑

	//带查询条件返回设置
  	var saveQueryData='yes';
  	 if(saveQueryData=='yes'){
  		pageJumpURL=cap.buildURL(pageJumpURL,{clearSession:false});
  	}
  	//当打开的页面为新窗口，并且当前window实现了backTo_pageJump方法，则调用backTo_pageJump方法来打开新页面
  	var _openWindow = window["backTo_pageJump"]; 
  	if("location" == "win" && _openWindow && typeof(_openWindow) == "function"){
  		_openWindow(pageJumpURL);
  	}else{
		cap.pageJump(pageJumpURL,"location",container);
  	}
}
		
	

		
//页面初始化之后行为(自定义) 页面初始化之后行为(自定义)
function pageInitAfterProcess(){
	//TODO 自定义页面加载逻辑
	if(isDevEnTypeMatch(envtype)){
		cap.validater.add('uiid-03806945158097078', 'required', {
            m:'数据库地址不能为空'
        });
		cap.validater.add('uiid-09121105982163609', 'required', {
            m:'用户名不能为空'
        });
		cap.validater.add('uiid-037101431246525785', 'required', {
            m:'密码不能为空'
        });
	}else{
		$("#usernameLabel").find("sup").hide();
		$("#passwordLabel").find("sup").hide();
		$("#databaseUrlLabel").find("sup").hide();
		cap.validater.remove('uiid-03806945158097078', 'required');
		cap.validater.remove('uiid-09121105982163609', 'required');
		cap.validater.remove('uiid-037101431246525785', 'required');
		
	}
}
	

		
//判断数据库编码是否存在 调用新版action方法
function isExistDBCode(code){
	if(databaseConfig.id){
     return true;
   }
	var paramArray = [];
	var paramsStr = 'databaseConfig';
	if(paramsStr != ''){
		paramArray = paramsStr.split(',');
	}
	//对参数paramArray进行处理
	var flag = false;
	var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.DatabaseConfig';
	aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.DatabaseConfig';
	dwr.TOPEngine.setAsync(false);
	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'isExistDbCode',paramArray);
	//TODO  调用后台前处理逻辑

	DbconfigCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(data){
		if(data>0){
        flag = false;
        }else{
        flag = true;
        }
		
		//TODO  后台调用返回后的处理逻辑  

	},
	errorHandler:function(message, exception){
		   //TODO 后台异常信息回调
		   var message ="调用后台服务失败,存在异常信息:"+message;

		   cui.message(message);
	}
	});
	dwr.TOPEngine.setAsync(true);
	//TODO 可自定义设置返回值

	return flag;
}
	


//页面初始化状态
function pageInitState(){
	    if(pageMode=='readonly'){
		    cap.setUIState('btnSave',"hide");
	        cap.disValid('btnSave', true);
	    }
}
        
jQuery(document).ready(function(){
	cap.beforePageInit.fire();
	cap.executeFunction("pageInitBeforeProcess");
	if(window['pageMode'] == "textmode" || window['pageMode'] == "readonly"){
		comtop.UI.scan[pageMode]=true;
	}
	comtop.UI.scan();
	cap.errorHandler();
	cap.executeFunction("pageInitLoadData");
	cap.pageInit();
	pageInitState();
	cap.executeFunction("pageInitAfterProcess");
});
        
        
//页面控件属性配置
var uiConfig={
    "btnSave":{
        "id":"btnSave",
        "on_click":saveForm,
        "uitype":"saveButton",
        "label":"保存",
        "name":"btnSave"
    },
    "btnBackTo":{
        "id":"btnBackTo",
        "on_click":backTo,
        "uitype":"backToButton",
        "label":"返回",
        "name":"btnBackTo"
    },
    "uiid-8540977048157212":{
        "value":"基本信息配置",
        "uitype":"Label",
        "label":"文字",
        "isBold":true
    },
    "uiid-2420474107821456":{
        "value":"数据库名称: ",
        "uitype":"Label",
        "label":"数据库名称",
        "isReddot":true,
        "name":"nameLabel"
    },
    "uiid-0181795463035204":{
        "maxlength":100,
        "databind":"databaseConfig.name",
        "name":"name",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":100,"maxm":"数据库名称长度不能大于100个字符"}},{"type":"required","rule":{"m":"数据库名称不能为空"}}]
    },
    "uiid-4865024767896672":{
        "value":"数据库类型: ",
        "uitype":"Label",
        "label":"数据库类型",
        "isReddot":true,
        "name":"typeLabel"
    },
    "uiid-6996581833341573":{
        "filter_fields":"value",
        "databind":"databaseConfig.type",
        "name":"type",
        "width":"80%",
        "uitype":"PullDown",
        "dictionary":"cap_cdp_dbType",
        "validate":[{"type":"required","rule":{"m":"数据库类型不能为空"}}]
    },
    "uiid-29851713098348103":{
        "value":"数据库编码: ",
        "uitype":"Label",
        "label":"数据库编码",
        "isReddot":true,
        "name":"codeLabel"
    },
    "uiid-03165974068145161":{
        "maxlength":32,
        "databind":"databaseConfig.code",
        "name":"code",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":32,"maxm":"数据库编码长度不能大于32个字符"}},{"type":"required","rule":{"m":"数据库编码不能为空"}},{"type":"format","rule":{"m":"数据库编码只能由字母数字及下划线组成","pattern":"^[a-zA-Z0-9_]+$"}},{"type":"custom","rule":{"m":"数据库编码不能重复","against":"isExistDBCode","args":"this"}}]
    },
    "uiid-33350522997116926":{
        "value":"是否默认: ",
        "uitype":"Label",
        "label":"是否默认",
        "isReddot":true,
        "name":"defaultDbLabel"
    },
    "uiid-5423529546022953":{
        "filter_fields":"value",
        "databind":"databaseConfig.defaultDb",
        "name":"defaultDb",
        "width":"80%",
        "uitype":"PullDown",
        "dictionary":"cap_cdp_db_default",
        "validate":[{"type":"required","rule":{"m":"是否默认不能为空"}}]
    },
    "usernameLabel":{
        "value":"用户名: ",
        "id":"usernameLabel",
        "uitype":"Label",
        "label":"用户名",
        "isReddot":true,
        "name":"usernameLabel"
    },
    "uiid-09121105982163609":{
        "maxlength":32,
        "databind":"databaseConfig.username",
        "name":"username",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":32,"maxm":"用户名长度不能大于32个字符"}}]
    },
    "passwordLabel":{
        "value":"密码: ",
        "id":"passwordLabel",
        "uitype":"Label",
        "label":"密码",
        "isReddot":true,
        "name":"passwordLabel"
    },
    "uiid-037101431246525785":{
        "maxlength":32,
        "databind":"databaseConfig.password",
        "name":"password",
        "width":"80%",
        "uitype":"Input",
        "type":"password",
        "validate":[{"type":"length","rule":{"max":32,"maxm":"密码长度不能大于32个字符"}}]
    },
    "databaseUrlLabel":{
        "value":"数据库地址: ",
        "id":"databaseUrlLabel",
        "uitype":"Label",
        "label":"数据库地址",
        "isReddot":true,
        "name":"databaseUrlLabel"
    },
    "uiid-03806945158097078":{
        "maxlength":100,
        "databind":"databaseConfig.databaseUrl",
        "name":"databaseUrl",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":100,"maxm":"数据库地址长度不能大于100个字符"}}]
    },
    "uiid-3121942489507017":{
        "value":"描述: ",
        "uitype":"Label",
        "label":"描述",
        "isReddot":false,
        "name":"descriptionLabel"
    },
    "uiid-06750266387599365":{
        "height":"100px",
        "maxlength":1000,
        "databind":"databaseConfig.description",
        "name":"description",
        "width":"100%",
        "uitype":"Textarea",
        "validate":[{"type":"length","rule":{"max":1000,"maxm":"描述长度不能大于1000个字符"}}]
    }
}

</script>
</html>