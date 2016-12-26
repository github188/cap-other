<%
/**********************************************************************
* sql脚本文件目录编辑页面
* 2016-10-20 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>sql脚本文件目录编辑页面</title>
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
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/SqlDirCroEditPageAction.js'></top:script>
	<top:verifyRight resourceString="[{menuCode:'cap_cdp_sqlDirCroEditPage'}]"/> 
    
</head>
<body>
<div id="pageRoot" class="cap-page">
<div class="cap-area" style="width:100%;">
	<table id="tableid-34423556085675955" class="cap-table-fullWidth">
		<tr id="trid-9196089173201472">
			<td id="tdid-5912058073095977" class="cap-td" style="text-align:right;" >
            	<span id="btnSave" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-07449573550839224" class="cap-table-fullWidth">
		<tr id="trid-05779346411527726">
			<td id="tdid-3290577166829124" class="cap-td" style="text-align:right;width:30%;" >
            	<span id="uiid-36697350300934836" uitype="Label" ></span>
			</td>
			<td id="tdid-9405745323595444" class="cap-td" style="text-align:left;width:70%;" colspan='1'>
            	<span id="uiid-011162808160065185" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-6911537212757034">
			<td id="tdid-6700679828303693" class="cap-td" style="text-align:right;width:30%;" >
            	<span id="uiid-7887731138296527" uitype="Label" ></span>
			</td>
			<td id="tdid-65138727208777" class="cap-td" style="text-align:left;width:70%;" colspan='1'>
            	<span id="uiid-6623911525533751" uitype="ClickInput" ></span>
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


cap.dicDatas=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("dicDatas"))%>;


var sqlDir={};

var sqlDirCroListPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/sqlDirCroListPage.ac';

		
//页面初始化数据加载行为 页面初始化数据加载行为
function pageInitLoadData(){
	//TODO 加载数据前操作

	var paramArray =[];
	cap.formId = primaryValue;
	var param = "primaryValue";
    if (param) {
       paramArray = param.split(",");
    }
	if(!cap.isUndefinedOrNullOrBlank(cap.formId) && paramArray.length>0){
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.SqlDir';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.SqlDir';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'loadById',paramArray);
		dwr.TOPEngine.setAsync(false);
		SqlDirCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
			//TODO 数据设置前操作

			sqlDir=result;
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
				defaultValue = <%=com.comtop.cip.json.JSON.toJSONStringWithDateFormat(request.getAttribute("sqlDir"),"yyyy-MM-dd HH:mm:ss")%>;
				break;
			//TODO 增加case控制

		}
		sqlDir = defaultValue ? defaultValue : {};
	}
	//TODO 数据加载完成后操作

}
	

		
//保存表单行为 保存表单行为
function saveForm(){
	//校验前操作
	sqlDir.configRepoId = id;
	var saveContinue=4;
	if(cap.validateForm()){
		cap.beforeSave();
		//提交数据前操作

		var paramArray = [];
		var paramsStr = 'sqlDir';
		if(paramsStr != ''){
			paramArray = paramsStr.split(',');
		}
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.SqlDir';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.SqlDir';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'save',paramArray);
		var result;
		dwr.TOPEngine.setAsync(false);
		SqlDirCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(_result){
			//赋值前操作
			result = _result;
			if(""!="sqlDir.id"){
				eval("sqlDir.id=_result");
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
							reloadURL = localURL +"&primaryValue="+sqlDir.id; 
						}
					}else{
						reloadURL = localURL +"?primaryValue="+sqlDir.id; 
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
	var pageJumpURL=cap.getforwardURL(sqlDirCroListPage);
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
		
	
		
/**
 * 打开定高定宽新窗口 打开定高定宽新窗口
 */
function openDbSelectWinow(url){
	var width=600; //窗口宽度
	var height=400;//窗口高度
	var top=(window.screen.height-30-height)/2;
	var left=(window.screen.width-10-width)/2;
	var windowName = "_blank";
	//TODO 改变新窗口的高、宽以、位置及窗口名称
   width=300;
	url='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/DatabaseConfigSelect.jsp?databaseConfigCodes='+sqlDir.code;
	window.open(url, windowName, "Scrollbars=yes,Toolbar=no,Location=no,titlebar=no,Direction=no,Resizeable=no,alwaysLowered=yes,Width="+width+" ,Height="+height+",top="+top+",left="+left);	
}
	

		
//数据库选择回调函数 用户自定义行为
function selectDatabaseCallback(selectNodes){

	var appDatabaseCodes='';
	var appDatabaseNames='';
	for(var i = 0; i < selectNodes.length; i++){
		appDatabaseCodes += selectNodes[i].code;
		appDatabaseNames += selectNodes[i].name;
		if(i != selectNodes.length - 1){
			appDatabaseCodes += ',';
			appDatabaseNames += ',';
		}
	}
	cui('#uiid-6623911525533751').setValue(appDatabaseCodes);

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
    "uiid-36697350300934836":{
        "value":"sql目录: ",
        "uitype":"Label",
        "label":"sql目录",
        "isReddot":"true",
        "name":"dirPathLabel"
    },
    "uiid-011162808160065185":{
        "databind":"sqlDir.dirPath",
        "name":"dirPath",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":250,"maxm":"dirPath长度不能大于250个字符"}},{"type":"required","rule":{"m":"dirPath不能为空"}}]
    },
    "uiid-7887731138296527":{
        "value":"数据库编码: ",
        "uitype":"Label",
        "label":"数据库编码",
        "isReddot":"true",
        "name":"codeLabel"
    },
    "uiid-6623911525533751":{
        "on_iconclick":openDbSelectWinow,
        "databind":"sqlDir.code",
        "name":"code",
        "width":"80%",
        "uitype":"ClickInput",
        "validate":[{"type":"length","rule":{"max":1000,"maxm":"code长度不能大于1000个字符"}},{"type":"required","rule":{"m":"code不能为空"}}]
    }
}

</script>
</html>