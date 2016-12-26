<%
/**********************************************************************
* 应用模式管理编辑页面
* 2016-11-02 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>应用模式管理编辑页面</title>
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
	<top:script src='/cap/dwr/interface/AppPatternCroEditPageAction.js'></top:script>
	<top:script src='/cap/bm/cdp/js/CdpCinfigUtils.js'></top:script>
	<top:script src='/cap/dwr/interface/CdpConfigAction.js'></top:script>
	<top:verifyRight resourceString="[{menuCode:'cap_bm_cdp_appPatternCroEditPage'}]"/> 
    
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
	<table id="tableid-3800889741082095" class="cap-table-fullWidth">
		<tr id="trid-5816404423347529">
			<td id="tdid-21028558589738967" class="cap-td"  >
            	<span id="uiid-1476202943571191" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-007712592521517947" class="cap-table-fullWidth">
		<tr id="trid-012046284364010618">
			<td id="tdid-52366081779287356" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-847970166056663" uitype="Label" ></span>
			</td>
			<td id="tdid-60400295832973" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-02546558552090985" uitype="Input" ></span>
			</td>
			<td id="tdid-12006160901136607" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-39740899291495964" uitype="Label" ></span>
			</td>
			<td id="tdid-7270199485162246" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="appCode" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-08387890579149127">
			<td id="tdid-3908139994103874" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="middlewareLabel" uitype="Label" ></span>
			</td>
			<td id="tdid-9673411347346827" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="middleware" uitype="PullDown" ></span>
			</td>
			<td id="tdid-6539644309577295" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="imagesVersionLabel" uitype="Label" ></span>
			</td>
			<td id="tdid-7990506733168095" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="imagesVersion" uitype="PullDown" ></span>
			</td>
		</tr>
		<tr id="trid-006948727005989441">
			<td id="tdid-9267392423348481" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="podCountLabel" uitype="Label" ></span>
			</td>
			<td id="tdid-2001076408701143" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="podCount" uitype="Input" ></span>
			</td>
			<td id="tdid-1651245295764617" class="cap-td" style="text-align:right;width:20%;" >
			</td>
			<td id="tdid-3279909553942665" class="cap-td" style="text-align:right;width:30%;" >
			</td>
		</tr>
		<tr id="trid-09851159370611734">
			<td id="tdid-9707625172494916" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="nodeIpLabel" uitype="Label" ></span>
			</td>
			<td id="tdid-4367210091484253" class="cap-td" style="text-align:left;width:80%;" colspan='3'>
            	<span id="nodeIp" uitype="PullDown" ></span>
			</td>
		</tr>
		<tr id="trid-032637672056633293">
			<td id="tdid-5221996421908039" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-6239673238655615" uitype="Label" ></span>
			</td>
			<td id="tdid-6996896328980826" class="cap-td" style="text-align:left;width:80%;" colspan='3'>
            	<span id="uiid-3429291566320299" uitype="Textarea" ></span>
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
var middleWare=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("middleWare"))%>;
var imgTag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("imgTag"))%>;


cap.dicDatas=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("dicDatas"))%>;


var appPattern={};

var evcontralEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/evcontralEditPage.ac'+'?id='+envId;

		
/*
 * 定义页面需要的变量
 */
var dockerNodes = <%=com.comtop.top.core.util.JsonUtil.objectToJson(com.comtop.cap.bm.cdp.k8sclient.K8sAPI.getAllNodes())%>;
var lisDockerNode = new Array();
		
	

		
//初始化docker节点 自定义形参,多个参数使用英文逗号隔开
function initLisDockerNode(){
	for(var i=0;i<dockerNodes.length;i++){
		lisDockerNode[i] = new Object(); 
		lisDockerNode[i].id = dockerNodes[i];
		lisDockerNode[i].text = dockerNodes[i];
	}
}
	

		
//页面初始化数据加载行为 页面初始化数据加载行为
function pageInitLoadData(){
	//TODO 加载数据前操作
	initLisDockerNode();
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
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.AppPattern';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.AppPattern';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'getAppPattern',paramArray);
		dwr.TOPEngine.setAsync(false);
		AppPatternCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
			//TODO 数据设置前操作
			cui("#appCode").setReadonly(true);
			appPattern=result;
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
				defaultValue = <%=com.comtop.cip.json.JSON.toJSONStringWithDateFormat(request.getAttribute("appPattern"),"yyyy-MM-dd HH:mm:ss")%>;
				break;
			//TODO 增加case控制

		}
		appPattern = defaultValue ? defaultValue : {};
	}
	//TODO 数据加载完成后操作
	cui("#middleware").setReadonly(false);
	cui("#imagesVersion").setReadonly(false);
	appPattern.envId = envId;
	if(!appPattern.middleWare){
			appPattern.middleWare = middleWare;
	}
	if(appPattern.middleWare&&appPattern.middleWare!="undefined"){
      cui("#middleware").setReadonly(true);
    }
	if(!appPattern.imgTag){
			appPattern.imgTag = imgTag;
	}
	if(appPattern.imgTag&&appPattern.imgTag!="undefined"){
	      cui("#imagesVersion").setReadonly(true);
	    }
	cui("#nodeIp").setDatasource(lisDockerNode);
}
	

		
//保存表单行为 保存表单行为
function saveForm(){
	//校验前操作
   appPattern.envId = envId;
	var saveContinue=4;
	if(cap.validateForm()){
		cap.beforeSave();
		//提交数据前操作
      if(!appPattern.createTime||!appPattern.creator){
		  appPattern.createTime = new Date();
	      appPattern.creator = globalUserId;
	  }
		var paramArray = [];
		var paramsStr = 'appPattern';
		if(paramsStr != ''){
			paramArray = paramsStr.split(',');
		}
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.AppPattern';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.AppPattern';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'saveAppPattern',paramArray);
		var result;
		dwr.TOPEngine.setAsync(false);
		AppPatternCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(_result){
			//赋值前操作
			result = _result;
			if(""!="appPattern.id"){
				eval("appPattern.id=_result");
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
							reloadURL = localURL +"&primaryValue="+appPattern.id; 
						}
					}else{
						reloadURL = localURL +"?primaryValue="+appPattern.id; 
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
	var pageJumpURL=cap.getforwardURL(evcontralEditPage);
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
		
	

		
/*
 * 新增行事件 最后一行开始追加
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addRow(event, self, mark) { 
	var gridId="variableGrid";
	var initObj={};
	//自定义初始始化逻辑

	cui("#"+gridId).insertRow(initObj);
}
	

		
/*
 * 删除行事件 删除选中的行以及数据
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function deleteRows(event, self, mark) { 
	var gridId="variableGrid";
	//自定义删除前处理逻辑

	cui("#"+gridId).deleteSelectRow();
}
	

		
//应用模式编码是否存在 调用新版action方法
function isExistAppCode(code){
	if(appPattern.id){
     return true;
   }
	appPattern.code = code;
	var paramArray = [];
	var paramsStr = 'appPattern';
	if(paramsStr != ''){
		paramArray = paramsStr.split(',');
	}
	//对参数paramArray进行处理
	var flag = false;
	var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.AppPattern';
	aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.AppPattern';
	dwr.TOPEngine.setAsync(false);
	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'isExistAppCode',paramArray);
	//TODO  调用后台前处理逻辑

	AppPatternCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(data){
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
	

		
//页面初始化之后行为(自定义) 页面初始化之后行为(自定义)
function pageInitAfterProcess(){
	//TODO 自定义页面加载逻辑
if(isDevEnTypeMatch(envtype)){		
		cap.validater.add('podCount', 'required', {
            m:'副本数不能为空'
        });
      cap.validater.add('nodeIp', 'required', {
            m:'部署节点IP不能为空'
        });
	}else{
		$("#middlewareLabel").find("sup").hide();		
		$("#imagesVersionLabel").find("sup").hide();
		$("#podCountLabel").find("sup").hide();		
		$("#nodeIpLabel").find("sup").hide();
		cap.validater.remove('middleware', 'required');
		cap.validater.remove('imagesVersion', 'required');			
		cap.validater.remove('podCount', 'required');
		cap.validater.remove('nodeIp', 'required');
		
	}
	
	//镜像版本初始化数据
	    var middlewareId = cui("#middleware").getValue();
	    dwr.TOPEngine.setAsync(false);
		CdpConfigAction.queryAllCascadeConfig("cap_cdp_middleware",middlewareId,function(confgiMap){
			cui("#imagesVersion").setDatasource(confgiMap);
			var imgTag = appPattern.imgTag;
			cui("#imagesVersion").setValue(imgTag);
		});
		dwr.TOPEngine.setAsync(true);
}
	

		
//应用编辑自动宽度 应用编辑自动宽度
function getGridBodyWidth(params){
    return parseInt(jQuery("#pageRoot").css("width"))- 35;
}
	

		
//middlewareSelBack 用户自定义行为
function middlewareSelBack(reCord){
   dwr.TOPEngine.setAsync(false);
	CdpConfigAction.queryAllConfigByFullCode(reCord.value,function(confgiMap){
		cui("#imagesVersion").setDatasource(confgiMap);
	});
	dwr.TOPEngine.setAsync(true);


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
    "uiid-1476202943571191":{
        "value":"基本信息配置",
        "uitype":"Label",
        "label":"文字",
        "isBold":true
    },
    "uiid-847970166056663":{
        "value":"应用模式名称: ",
        "uitype":"Label",
        "label":"应用模式名称",
        "isReddot":true,
        "name":"nameLabel"
    },
    "uiid-02546558552090985":{
        "maxlength":30,
        "databind":"appPattern.name",
        "name":"name",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":30,"maxm":"应用模式名称长度不能大于30个字符"}},{"type":"required","rule":{"m":"应用模式名称不能为空"}}]
    },
    "uiid-39740899291495964":{
        "value":"应用模式编码: ",
        "uitype":"Label",
        "label":"应用模式编码",
        "isReddot":true,
        "name":"codeLabel"
    },
    "appCode":{
        "id":"appCode",
        "maxlength":8,
        "databind":"appPattern.code",
        "name":"code",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":8,"maxm":"应用模式编码长度不能大于8个字符"}},{"type":"format","rule":{"m":"应用模式编码只能由字母数字组成","pattern":"^[a-z0-9]+$"}},{"type":"required","rule":{"m":"应用模式编码不能为空"}},{"type":"custom","rule":{"m":"一个环境下应用编码不能重复","against":"isExistAppCode","args":"this"}}]
    },
    "middlewareLabel":{
        "value":"中间件: ",
        "id":"middlewareLabel",
        "uitype":"Label",
        "label":"中间件",
        "isReddot":true,
        "name":"middleWareLabel"
    },
    "middleware":{
        "on_change":middlewareSelBack,
        "id":"middleware",
        "name":"middleWare",
        "databind":"appPattern.middleWare",
        "width":"80%",
        "uitype":"PullDown",
        "dictionary":"cap_cdp_middleware",
        "validate":[{"type":"required","rule":{"m":"中间件不能为空"}}]
    },
    "imagesVersionLabel":{
        "value":"镜像版本: ",
        "id":"imagesVersionLabel",
        "uitype":"Label",
        "label":"镜像版本",
        "isReddot":true,
        "name":"imgTagLabel"
    },
    "imagesVersion":{
        "id":"imagesVersion",
        "filter_fields":"value",
        "databind":"appPattern.imgTag",
        "name":"imgTag",
        "width":"80%",
        "uitype":"PullDown",
        "validate":[{"type":"required","rule":{"m":"镜像版本不能为空"}}]
    },
    "podCountLabel":{
        "value":"副本数(个): ",
        "id":"podCountLabel",
        "uitype":"Label",
        "label":"副本数(个)",
        "isReddot":true,
        "name":"instanceNumLabel"
    },
    "podCount":{
        "id":"podCount",
        "maxlength":2,
        "databind":"appPattern.instanceNum",
        "name":"instanceNum",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"numeric","rule":{"oi":true,"min":1,"minm":"副本数需大于0","max":99,"maxm":"副本数需小于99"}}]
    },
    "nodeIpLabel":{
        "value":"部署节点ip: ",
        "id":"nodeIpLabel",
        "uitype":"Label",
        "label":"部署节点ip",
        "isReddot":true,
        "name":"deployNodeIpsLabel"
    },
    "nodeIp":{
        "id":"nodeIp",
        "filter_fields":"value",
        "databind":"appPattern.deployNodeIps",
        "name":"deployNodeIps",
        "width":"100%",
        "uitype":"PullDown",
        "mode":"Multi"
    },
    "uiid-6239673238655615":{
        "value":"应用描述: ",
        "uitype":"Label",
        "label":"应用描述",
        "isReddot":false,
        "name":"descriptionLabel"
    },
    "uiid-3429291566320299":{
        "height":"100px",
        "maxlength":1000,
        "databind":"appPattern.description",
        "name":"description",
        "width":"100%",
        "uitype":"Textarea",
        "validate":[{"type":"length","rule":{"max":1000,"maxm":"应用描述长度不能大于1000个字符"}}]
    }
}

</script>
</html>