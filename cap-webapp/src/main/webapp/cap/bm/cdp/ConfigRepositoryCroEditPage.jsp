<%
/**********************************************************************
* 配置库管理编辑页面
* 2016-10-27 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>配置库管理编辑页面</title>
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
	<top:script src='/cap/dwr/interface/ConfigRepositoryCroEditPageAction.js'></top:script>
	<top:verifyRight resourceString="[{menuCode:'cap_bm_cdp_configRepositoryCroEditPage'}]"/> 
    
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
	<table id="tableid-5591041600832368" class="cap-table-fullWidth">
		<tr id="trid-7097028277250072">
			<td id="tdid-7892387596960842" class="cap-td"  >
            	<span id="uiid-18114037665769903" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-0452899747799801" class="cap-table-fullWidth">
		<tr id="trid-07907751408516024">
			<td id="tdid-14313157821777684" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-11077022746829142" uitype="Label" ></span>
			</td>
			<td id="tdid-9194849548677398" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-09579712766772548" uitype="Input" ></span>
			</td>
			<td id="tdid-8847450729118304" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-7063113649444651" uitype="Label" ></span>
			</td>
			<td id="tdid-14642357307464252" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-16522748480705715" uitype="PullDown" ></span>
			</td>
		</tr>
		<tr id="trid-07781709422761761">
			<td id="tdid-5789194064522183" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-4954389752771605" uitype="Label" ></span>
			</td>
			<td id="tdid-6385450782225648" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-05256553937491744" uitype="Input" ></span>
			</td>
			<td id="tdid-29792045993685687" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-11921974966761539" uitype="Label" ></span>
			</td>
			<td id="tdid-24795884796530085" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-019336221662585595" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-08596177045080163">
			<td id="tdid-8585158314183046" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-38580406621021396" uitype="Label" ></span>
			</td>
			<td id="tdid-1948526815099098" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-07294169363672115" uitype="Input" ></span>
			</td>
			<td id="tdid-8956112888805673" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-6776555672621453" uitype="Label" ></span>
			</td>
			<td id="tdid-8951058528424343" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-006952816016491581" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-004464993715037979">
			<td id="tdid-3227580818779312" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-8033514676341522" uitype="Label" ></span>
			</td>
			<td id="tdid-4570187883633144" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="buildTool" uitype="PullDown" ></span>
			</td>
			<td id="tdid-21665482193571535" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-9053017869662523" uitype="Label" ></span>
			</td>
			<td id="tdid-31150565892230546" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-5108665513266735" uitype="PullDown" ></span>
			</td>
		</tr>
		<tr id="trid-03535510028617267">
			<td id="tdid-48139566994286156" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-7535529906437273" uitype="Label" ></span>
			</td>
			<td id="tdid-5387312585075383" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="execTaskid" uitype="Input" ></span>
			</td>
			<td id="tdid-6646143988596876" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-8850919444477633" uitype="Label" ></span>
			</td>
			<td id="tdid-33718317486708145" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-07837546087949417" uitype="Input" ></span>
			</td>
		</tr>
		<tr id="trid-06611601633938001">
			<td id="tdid-17348796415896967" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-853594975353652" uitype="Label" ></span>
			</td>
			<td id="tdid-690926684093543" class="cap-td" style="text-align:left;width:80%;" colspan='3'>
            	<span id="uiid-05009357643087166" uitype="Textarea" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-37800264643482116" class="cap-table-fullWidth">
		<tr id="trid-5789189717862931">
			<td id="tdid-391444874093726" class="cap-td"  >
            	<span id="uiid-3730913472587195" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-6137405122863129" class="cap-table-fullWidth">
		<tr id="trid-98020229046233">
			<td id="tdid-49583365542348474" class="cap-td" style="text-align:left;" >
            	<span id="btnAddOnEGird" uitype="Button" ></span>
            	<span id="btnDeleteOnEGrid" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-021178060202262028" class="cap-table-fullWidth">
		<tr id="trid-39595755618065596">
			<td id="tdid-985950362868607" class="cap-td"  >
            	<table id="uiid-7901557899778709" uitype="EditableGrid" ></table>
			</td>
		</tr>
	</table>
	<table id="tableid-59911268158087275" class="cap-table-fullWidth">
		<tr id="trid-5954200927529335">
			<td id="tdid-3691304726206741" class="cap-td"  >
            	<span id="uiid-211761081058534" uitype="Label" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-4615942979074725" class="cap-table-fullWidth">
		<tr id="trid-930901796435689">
			<td id="tdid-6304885702627195" class="cap-td"  >
            	<table id="uiid-6330825547416603" uitype="EditableGrid" ></table>
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


var configRepository={};

var configRepositoryCroListPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/configRepositoryCroListPage.ac';
var sqlDirCroEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/sqlDirCroEditPage.ac'+'?id='+id;

		
/*
 * 定义页面需要的变量
 */
var mavenInstall =<%=com.comtop.top.core.util.JsonUtil.objectToJson(com.comtop.cap.bm.cdp.jenkinsclient.JenkinsAPI.getMavenInstalls())%>;
var gradleInstalls = <%=com.comtop.top.core.util.JsonUtil.objectToJson(com.comtop.cap.bm.cdp.jenkinsclient.JenkinsAPI.getGradleInstalls())%>;
var bulidToolVersion = new Array();
var selectDBPattern_dialog;
var tmpId = '';
var tmpDbCode;
var tmpConfigPath;
var seletType;
		
	

		
//用户自定义行为 用户自定义行为
function initbulidToolVersion(){
    bulidToolVersion["maven"]=new Array();
	 for(var i=0;i<mavenInstall.length;i++){
		 bulidToolVersion["maven"][i] = new Object();
		 bulidToolVersion["maven"][i].id = mavenInstall[i];
		 bulidToolVersion["maven"][i].text = mavenInstall[i];
     }
	 bulidToolVersion["gradle"]=new Array();
	 for(var i=0;i<gradleInstalls.length;i++){
		 bulidToolVersion["gradle"][i] = new Object();
		 bulidToolVersion["gradle"][i].id = gradleInstalls[i];
		 bulidToolVersion["gradle"][i].text = gradleInstalls[i];
     }
	cui("#uiid-5108665513266735").setDatasource(bulidToolVersion["gradle"]);
	cui("#uiid-5108665513266735").setValue(bulidToolVersion["gradle"][0].text);
	cui("#execTaskid").setValue("clean build");
}
	

		
//页面初始化数据加载行为 页面初始化数据加载行为
function pageInitLoadData(){
	//TODO 加载数据前操作
   initbulidToolVersion();
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
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.ConfigRepository';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.ConfigRepository';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'getConfigRepo',paramArray);
		dwr.TOPEngine.setAsync(false);
		ConfigRepositoryCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
			//TODO 数据设置前操作
         cui("#uiid-09579712766772548").setReadonly(true);
			configRepository=result;
			//TODO 数据设置后操作
         cui("#uiid-5108665513266735").setDatasource(bulidToolVersion[configRepository.buildTool]);
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
				defaultValue = <%=com.comtop.cip.json.JSON.toJSONStringWithDateFormat(request.getAttribute("configRepository"),"yyyy-MM-dd HH:mm:ss")%>;
				break;
			//TODO 增加case控制

		}
		configRepository = defaultValue ? defaultValue : {};
	}
	//TODO 数据加载完成后操作

}
	

		
//保存表单行为 保存表单行为
function saveForm(){
	//校验前操作

	var saveContinue=4;
	if(cap.validateForm()){
		cap.beforeSave();
		//提交数据前操作
      var reg=/(\/|\\)*$/gi; 
		var tempUrl = configRepository.repositoryUrl;
		tempUrl=tempUrl.replace(reg,""); 
		configRepository.repositoryUrl = tempUrl;
		configRepository.createTime = new Date();
      configRepository.creator = globalUserId;
      for(var i=0;i<configRepository.relationConfigFileList.length;i++){
			configRepository.relationConfigFileList[i].creator=globalUserId;
			configRepository.relationConfigFileList[i].createTime=new Date();
		}
		var paramArray = [];
		var paramsStr = 'configRepository';
		if(paramsStr != ''){
			paramArray = paramsStr.split(',');
		}
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.ConfigRepository';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.ConfigRepository';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'saveConfigRepo',paramArray);
		var result;
		dwr.TOPEngine.setAsync(false);
		ConfigRepositoryCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(_result){
			//赋值前操作
			result = _result;
			if(""!="configRepository.id"){
				eval("configRepository.id=_result");
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
							reloadURL = localURL +"&primaryValue="+configRepository.id; 
						}
					}else{
						reloadURL = localURL +"?primaryValue="+configRepository.id; 
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
	var pageJumpURL=cap.getforwardURL(configRepositoryCroListPage);
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
 * editGrid新增事件 editGrid新增事件
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addRow(event, self, mark) { 
	var gridId="uiid-7901557899778709";
	var initObj={};
	//自定义初始始化逻辑

	cui("#"+gridId).insertRow(initObj);
}
	

		
/*
 * editGrid删除事件 editGrid删除事件
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function deleteRows(event, self, mark) { 
	var gridId="uiid-7901557899778709";
	//自定义删除前处理逻辑
	var gridObj = cui("#"+gridId);
	var selects = gridObj.getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要删除的数据。");
		return;
	}
	cui("#"+gridId).deleteSelectRow();
}
	

		
//值改变时事件 pulldown值改变时事件
function buildToolSelect(params){
if(cui("#uiid-5108665513266735").setDatasource) {
		cui("#uiid-5108665513266735").setDatasource(bulidToolVersion[params.id]);
	}
var str = cui("#execTaskid").getValue();
if( str == ""||str == "clean build"||str =="clean install -Dmaven.test.skip=true"){	
	if(params.id=="gradle"){
		 cui("#execTaskid").setValue("clean build");
	 }else if(params.id=="maven"){
		 cui("#execTaskid").setValue("clean install -Dmaven.test.skip=true");
	 }
	}
}
	

		
//判断配置库是否存在 调用新版action方法
function isExistConfigRepo(name){
   if(configRepository.id){
     return true;
   }
	var paramArray = [];
	var paramsStr = 'configRepository';
	if(paramsStr != ''){
		paramArray = paramsStr.split(',');
	}
	//对参数paramArray进行处理
   var flag = false;
	var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.ConfigRepository';
	aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.ConfigRepository';
	dwr.TOPEngine.setAsync(false);
	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'isExistConfigRepo',paramArray);
	//TODO  调用后台前处理逻辑

	ConfigRepositoryCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(data){
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
	

		
/*
 * 点击按钮跳转页面 点击按钮跳转页面
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addBizObject(event, self, mark) { 
	var pageJumpURL=cap.getforwardURL();
	var container=window;
	//TODO  调用后台前处理逻辑

	//带查询条件返回设置
  	var saveQueryData='no';
  	 if(saveQueryData=='yes'){
  		pageJumpURL=cap.buildURL(pageJumpURL,{clearSession:false});
  	}
  	//当打开的页面为新窗口，并且当前window实现了addBizObject_pageJump方法，则调用addBizObject_pageJump方法来打开新页面
  	var _openWindow = window["addBizObject_pageJump"]; 
  	if("location" == "win" && _openWindow && typeof(_openWindow) == "function"){
  		_openWindow(pageJumpURL);
  	}else{
		cap.pageJump(pageJumpURL,"location",container);
  	}
}
		
	

		
//删除行为 删除行为
function deleteRow(){
	//删除前操作

	var gridId="";
	var gridObj = cui("#"+gridId);
	var selects = gridObj.getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要删除的数据。");
		return;
	}
	cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
		onYes:function(){
			var paramArray = [];
			paramArray[0] = selects;
			var aliasEntityId = '';
			aliasEntityId = aliasEntityId != '' ? aliasEntityId :  '';	
			var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'',paramArray);
			ConfigRepositoryCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
				//数据刷新前处理

				
				if(result){
					gridObj.loadData();
				 	cui.message("删除成功！","success");
				}else{
					cui.error("删除失败，请重新操作！");
				}
				
				//数据刷新后处理

			},
			errorHandler:function(message, exception){
			   //TODO 后台异常信息回调
			   var message ="删除失败,存在异常信息:"+message;

			   cui.message(message);
			}
			});
		}
	});
	//TODO 可自定义设置返回值

}
	

		
/**
 * 初始化查询行为 列表查询行为方法
 * 该方法只支持后台方法有且只有一个参数，且参数类型为对象（vo）
 * 若是多条件查询，需把条件封装在vo中
 * @obj grid对象
 * @pageQuery grid分页信息
 */
function initDatasource(obj, pageQuery) {
	var queryVarName = '${methodParameter}';
	var query = {};
	if(queryVarName !== ''){
		query=cap.getQueryObject(window[queryVarName],pageQuery);
	}
	//初始化查询参数

	//获取查询条件
 	var paramArray = [];
 	paramArray[0] = query;
 	var aliasEntityId = '';
	aliasEntityId = aliasEntityId != '' ? aliasEntityId :  '';
 	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'',paramArray);
 	//TODO 调用前操作

	
 	//调用后台查询
 	dwr.TOPEngine.setAsync(true);
	ConfigRepositoryCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
		var returnValueVarName= '';
		if(returnValueVarName === ''){
			returnValueVarName = 'returnValueVarName';
		}
  		//TODO 数据设置前操作

  		window[returnValueVarName]=result.list;
  		//设置到数据源
  		if(result.list!=null){
  			obj.setQuery({pageNo:result.pageNo});
  			obj.setDatasource(result.list,result.count); 
      	}else{
      		obj.setDatasource([],0);
      	}
  		//TODO 数据设置后操作

  		//查询条件保存设置
  		var saveQueryData='no';
  		if(saveQueryData=='yes'){
  			cap.setSessionAttribute({'${methodParameter}' : cap.cacheGridAttributes(obj.getQuery(), window['${methodParameter}'])});
  		}
  	},
  	errorHandler:function(message, exception){
	   //TODO 后台异常信息回调

	}
  	});
  	dwr.TOPEngine.setAsync(true);
  	//TODO 可自定义设置返回值

}
	

		
//查询sql目录 列表查询行为方法
function gridSqlDirDatasource(obj, pageQuery) {
	var gridData = [];
	var gridDataCount = 0;
 	//TODO 自定义列表初始化行为
gridData = configRepository.relationSqlDirList;
	obj.setDatasource(gridData,gridDataCount);
}
	

		
var openDialogSqlFileWinow_dialog; //dialog变量
/**
 * 添加sql脚本窗口
 */
function openDialogSqlFileWinow(url){
	//TODO 弹出窗口前的业务操作
	if(typeof(url) != 'string'){
		url='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/sqlDirCroEditPage.ac?id='+id;
	}
	if(!openDialogSqlFileWinow_dialog){
		var _cuiObj = cui;
		var width=600; //窗口宽度
		var height=400;//窗口高度
		var title = '新窗口';//窗口title
		//TODO 设置dialog属性值
		title='添加SQl目录';
		openDialogSqlFileWinow_dialog = _cuiObj.dialog({
			//TODO 根据需要添加dialog属性
 			beforeClose: function () {
                pageRefresh();
            },
			title : title,
  		    width : width,
  		    height : height,
  		    src : url
  	    });
  	}else{
  		openDialogSqlFileWinow_dialog.reload(url);
  	}
	openDialogSqlFileWinow_dialog.show(url);	
}
	

		
//删除行为 删除行为
function deleteSqlDir(){
	//删除前操作

	var gridId="uiid-8037542869026188";
	var gridObj = cui("#"+gridId);
	var selects = gridObj.getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要删除的数据。");
		return;
	}
	cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
		onYes:function(){
			var paramArray = [];
			paramArray[0] = selects;
			var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.SqlDir';
			aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.SqlDir';	
			var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'deleteList',paramArray);
			ConfigRepositoryCroEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
				//数据刷新前处理
 			if(result){
		             for(var i=0;i<configRepository.relationSqlDirList.length;i++){
							 for(var j=0;j<selects.length;j++){
									if(configRepository.relationSqlDirList[i].id==selects[j].id){
										configRepository.relationSqlDirList.splice(i,1);
										i--;
									}
								}
							}
		            }
				
				if(result){
					gridObj.loadData();
				 	cui.message("删除成功！","success");
				}else{
					cui.error("删除失败，请重新操作！");
				}
				
				//数据刷新后处理

			},
			errorHandler:function(message, exception){
			   //TODO 后台异常信息回调
			   var message ="删除失败,存在异常信息:"+message;

			   cui.message(message);
			}
			});
		}
	});
	//TODO 可自定义设置返回值

}
	

		
//配置库编辑页面刷新 页面刷新方法
function pageRefresh(){
	var refreshTarget='current';
	var customPage = window;
	//TODO  自定义处理逻辑

	//refreshTarget == custom 时，使用 customPage 来 刷新
	cap.pageRefresh(refreshTarget,customPage);
	//TODO  自定义处理逻辑

}
	

		
/*
 * 新增数据库脚本路径 最后一行开始追加
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addDbRow(event, self, mark) { 
	var gridId="uiid-6330825547416603";
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
function deleteDbRows(event, self, mark) { 
	var gridId="uiid-6330825547416603";
	//自定义删除前处理逻辑
	var gridObj = cui("#"+gridId);
	var selects = gridObj.getSelectedRowData();
	if(selects == null || selects.length == 0){
		cui.alert("请选择要删除的数据。");
		return;
	}
	cui("#"+gridId).deleteSelectRow();
}
	

		
//打开Dialog新窗口选择数据库 打开Dialog新窗口
function selectDBPattern(event, self){
	var dbCodes = self.editRowData.code;
	//TODO 弹出窗口前的业务操作
	var url='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/DatabaseConfigSelect.jsp?databaseConfigCodes='+dbCodes;
	if(!selectDBPattern_dialog){
		var _cuiObj = cui;
		var width=600; //窗口宽度
		var height=400;//窗口高度
		var title = '数据库选择';//窗口title
		//TODO 设置dialog属性值

		selectDBPattern_dialog = _cuiObj.dialog({
			//TODO 根据需要添加dialog属性

			title : title,
  		    width : width,
  		    height : height,
  		    src : url
  	    });
  	}else{
  		selectDBPattern_dialog.reload(url);
  	}
	selectDBPattern_dialog.show(url);	

}
	

		
/*
 * 普通事件的回调 普通事件的回调
 * 
 * Input、ClickInput、Textarea组件的所有事件的回调函数
 *
 * @param event 当前事件对象
 * @param self 当前组件实例对象
 */
function dbSelectEvent(event, self) { 
	tmpId = self.editRowData.id;	
	tmpDbCode = self;
	var dbCodes = self.editRowData.code;
	//TODO 弹出窗口前的业务操作
	var url='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/DatabaseConfigSelect.jsp?databaseConfigCodes='+dbCodes;
	if(!selectDBPattern_dialog){
		var _cuiObj = cui;
		var width=300; //窗口宽度
		var height=400;//窗口高度
		var title = '选择数据库';//窗口title
		//TODO 设置dialog属性值

		selectDBPattern_dialog = _cuiObj.dialog({
			//TODO 根据需要添加dialog属性

			title : title,
  		    width : width,
  		    height : height,
  		    src : url
  	    });
  	}else{
  		selectDBPattern_dialog.reload(url);
  	}
	selectDBPattern_dialog.show(url);	
}
		
	

		
//数据库选择回调方法 自定义形参,多个参数使用英文逗号隔开
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
	if(!tmpId){
		tmpDbCode.setValue(appDatabaseCodes) ;
	}else{
      var datas = cui('#uiid-6330825547416603').getRowsDataByPK(tmpId);
      datas[0].code = appDatabaseCodes;
      cui('#uiid-6330825547416603').changeData(datas[0]);
	}
}
	

		
//用户自定义形参行为 自定义形参,多个参数使用英文逗号隔开
function closeDialog(){
	selectDBPattern_dialog.hide();
}
	

		
/*
 * 配置文件选择 自定义形参,多个参数使用英文逗号隔开
 * 
 * Input、ClickInput、Textarea组件的所有事件的回调函数
 *
 * @param event 当前事件对象
 * @param self 当前组件实例对象
 */
function selectConfigFile(event, self) { 
    seletType = "file";	
    selectSvnFile(event, self);
}
		
	

		
//配置库选择 自定义形参,多个参数使用英文逗号隔开
function selSingleBack(selectNodeData){
    if(seletType == selectNodeData.data.type){
	    var fullPath = selectNodeData.data.url;
		var relativePath = fullPath.replace(configRepository.repositoryUrl, "");
		relativePath = relativePath.substr(1); //去掉最前面的"/"
	    tmpConfigPath.setValue(relativePath) ;
	    closeDialog();
	}else if(seletType == "file"){
		cui.alert("请选择具体文件");
	}else if(seletType == "dir"){
		cui.alert("请选择具体目录");
	}
}
	

		
/*
 * svn文件选择 普通事件的回调
 * 
 * Input、ClickInput、Textarea组件的所有事件的回调函数
 *
 * @param event 当前事件对象
 * @param self 当前组件实例对象
 */
function selectSvnFile(event, self) { 
	tmpConfigPath = self;
	//TODO 弹出窗口前的业务操作
	var url='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/SvnDirectorySelect.jsp?repositoryUrl='+configRepository.repositoryUrl+"&username="+configRepository.username+"&password="+configRepository.password;
	if(!selectDBPattern_dialog){
		var _cuiObj = cui;
		var width=500; //窗口宽度
		var height=800;//窗口高度
		var title = '选择配置文件';//窗口title
		//TODO 设置dialog属性值

		selectDBPattern_dialog = _cuiObj.dialog({
			//TODO 根据需要添加dialog属性

			title : title,
  		    width : width,
  		    height : height,
  		    src : url
  	    });
  	}else{
  		selectDBPattern_dialog.reload(url);
  	}
	selectDBPattern_dialog.show(url);	
}
		
	

		
/*
 * sql路径选择 自定义形参,多个参数使用英文逗号隔开
 * 
 * Input、ClickInput、Textarea组件的所有事件的回调函数
 *
 * @param event 当前事件对象
 * @param self 当前组件实例对象
 */
function selectSqlPath(event, self) { 
    seletType = "dir";	
    selectSvnFile(event, self);
}
		
	

		
//去掉配置库最后的斜杠 自定义形参,多个参数使用英文逗号隔开
function subUrl(even,self){
		var reg=/(\/|\\)*$/gi; 
		var tempUrl = configRepository.repositoryUrl;
		tempUrl=tempUrl.replace(reg,""); 
		configRepository.repositoryUrl = tempUrl;
		self.setValue(tempUrl);
}
	


//页面初始化状态
function pageInitState(){
	    if(pageMode=='readonly'){
		    cap.setUIState('btnSave',"hide");
	        cap.disValid('btnSave', true);
		    cap.setUIState('btnAddOnEGird',"hide");
	        cap.disValid('btnAddOnEGird', true);
		    cap.setUIState('btnDeleteOnEGrid',"hide");
	        cap.disValid('btnDeleteOnEGrid', true);
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
    "uiid-18114037665769903":{
        "value":"基本信息配置",
        "uitype":"Label",
        "label":"文字",
        "isBold":"true"
    },
    "uiid-11077022746829142":{
        "value":"配置库名称: ",
        "uitype":"Label",
        "label":"配置库名称",
        "isReddot":true,
        "name":"nameLabel"
    },
    "uiid-09579712766772548":{
        "maxlength":"100",
        "databind":"configRepository.name",
        "name":"name",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"required","rule":{"m":"配置库名称不能为空"}},{"type":"custom","rule":{"m":"配置库名称不可同名","against":"isExistConfigRepo","args":"this"}},{"type":"length","rule":{"max":100,"maxm":"配置库名称长度不能大于100个字符"}}]
    },
    "uiid-7063113649444651":{
        "value":"发布包类型: ",
        "uitype":"Label",
        "label":"发布包类型",
        "isReddot":true,
        "name":"pkgFormatLabel"
    },
    "uiid-16522748480705715":{
        "filter_fields":"value",
        "select":0,
        "name":"pkgFormat",
        "databind":"configRepository.pkgFormat",
        "width":"80%",
        "uitype":"PullDown",
        "dictionary":"cap_cdp_pkg_format",
        "validate":[{"type":"required","rule":{"m":"发布包类型不能为空"}}]
    },
    "uiid-4954389752771605":{
        "value":"WEB项目路径: ",
        "uitype":"Label",
        "label":"WEB项目路径",
        "isReddot":false,
        "name":"webappPathLabel"
    },
    "uiid-05256553937491744":{
        "maxlength":"100",
        "databind":"configRepository.webappPath",
        "name":"webappPath",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":100,"maxm":"WEB项目路径长度不能大于100个字符"}}]
    },
    "uiid-11921974966761539":{
        "value":"源码库URL: ",
        "uitype":"Label",
        "label":"源码库URL",
        "isReddot":true,
        "name":"repositoryUrlLabel"
    },
    "uiid-019336221662585595":{
        "maxlength":100,
        "name":"repositoryUrl",
        "databind":"configRepository.repositoryUrl",
        "width":"80%",
        "uitype":"Input",
        "on_blur":subUrl,
        "validate":[{"type":"length","rule":{"max":100,"maxm":"源码库URL长度不能大于100个字符"}},{"type":"required","rule":{"m":"源码库URL不能为空"}}]
    },
    "uiid-38580406621021396":{
        "value":"用户名: ",
        "uitype":"Label",
        "label":"用户名",
        "isReddot":true,
        "name":"usernameLabel"
    },
    "uiid-07294169363672115":{
        "maxlength":"32",
        "databind":"configRepository.username",
        "name":"username",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":32,"maxm":"用户名长度不能大于32个字符"}},{"type":"required","rule":{"m":"用户名不能为空"}}]
    },
    "uiid-6776555672621453":{
        "value":"密码: ",
        "uitype":"Label",
        "label":"密码",
        "isReddot":true,
        "name":"passwordLabel"
    },
    "uiid-006952816016491581":{
        "maxlength":"64",
        "databind":"configRepository.password",
        "name":"password",
        "width":"80%",
        "uitype":"Input",
        "type":"password",
        "validate":[{"type":"length","rule":{"max":64,"maxm":"密码长度不能大于64个字符"}},{"type":"required","rule":{"m":"密码不能为空"}}]
    },
    "uiid-8033514676341522":{
        "value":"构建工具: ",
        "uitype":"Label",
        "label":"构建工具",
        "isReddot":true,
        "name":"buildToolLabel"
    },
    "buildTool":{
        "select":0,
        "width":"80%",
        "dictionary":"cap_cdp_build_tool",
        "validate":[{"type":"required","rule":{"m":"构建工具不能为空"}}],
        "id":"buildTool",
        "on_change":buildToolSelect,
        "databind":"configRepository.buildTool",
        "name":"buildTool",
        "uitype":"PullDown"
    },
    "uiid-9053017869662523":{
        "value":"构建工具版本: ",
        "uitype":"Label",
        "label":"构建工具版本",
        "isReddot":true,
        "name":"buildToolVersionLabel"
    },
    "uiid-5108665513266735":{
        "filter_fields":"value",
        "select":0,
        "databind":"configRepository.buildToolVersion",
        "name":"buildToolVersion",
        "width":"80%",
        "uitype":"PullDown",
        "validate":[{"type":"required","rule":{"m":"构建工具版本不能为空"}}]
    },
    "uiid-7535529906437273":{
        "value":"执行任务: ",
        "uitype":"Label",
        "label":"执行任务",
        "isReddot":true,
        "name":"execTaskLabel"
    },
    "execTaskid":{
        "id":"execTaskid",
        "maxlength":100,
        "databind":"configRepository.execTask",
        "name":"execTask",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":100,"maxm":"执行任务长度不能大于100个字符"}},{"type":"required","rule":{"m":"执行任务不能为空"}}]
    },
    "uiid-8850919444477633":{
        "value":"更新忽略路径: ",
        "uitype":"Label",
        "label":"更新忽略路径",
        "isReddot":false,
        "name":"ignorePathLabel"
    },
    "uiid-07837546087949417":{
        "databind":"configRepository.ignorePath",
        "name":"ignorePath",
        "width":"80%",
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":1000,"maxm":"更新忽略路径长度不能大于1000个字符"}}]
    },
    "uiid-853594975353652":{
        "value":"描述: ",
        "uitype":"Label",
        "label":"描述",
        "isReddot":false,
        "name":"descriptionLabel"
    },
    "uiid-05009357643087166":{
        "maxlength":"1000",
        "databind":"configRepository.description",
        "name":"description",
        "width":"100%",
        "uitype":"Textarea",
        "validate":[{"type":"length","rule":{"max":2000,"maxm":"描述长度不能大于2000个字符"}}]
    },
    "uiid-3730913472587195":{
        "value":"配置文件管理",
        "uitype":"Label",
        "label":"文字",
        "isBold":"true"
    },
    "btnAddOnEGird":{
        "id":"btnAddOnEGird",
        "on_click":addRow,
        "uitype":"addButtonOnEditGrid",
        "label":"新增",
        "name":"btnAddOnEGird"
    },
    "btnDeleteOnEGrid":{
        "id":"btnDeleteOnEGrid",
        "on_click":deleteRows,
        "uitype":"deleteButtonOnEditGrid",
        "label":"删除",
        "name":"btnDeleteOnEGrid"
    },
    "uiid-7901557899778709":{
        "resizeheight":getBodyHeight,
        "columns":[{"bindName":"filePath","name":"配置文件路径"},{"name":"发布包文件路径","bindName":"targetFilePath"}],
        "gridheight":"auto",
        "resizewidth":getBodyWidth,
        "custom_pagesize":false,
        "gridwidth":"95%",
        "primarykey":"id",
        "name":"ItemByRelations",
        "databind":"configRepository.relationConfigFileList",
        "edittype":{"filePath": {"on_iconclick": selectConfigFile, "uitype": "ClickInput", "validate": [{"rule":{"m":"配置文件路径不能为空"},"type":"required"}]}, "targetFilePath": {"width": "99%", "uitype": "Input", "validate": [{"rule":{"m":"发布包文件不能为空"},"type":"required"}]}},
        "uitype":"EditableGrid",
        "lazy":true,
        "pagination":false,
        "selectrows":"multi",
        "datasource":cap.editGridDatasource
    },
    "uiid-211761081058534":{
        "value":"SQL脚本目录管理",
        "uitype":"Label",
        "label":"文字",
        "isBold":"true"
    },
    "uiid-6330825547416603":{
        "resizeheight":getBodyHeight,
        "columns":[{"name":"脚本路径","bindName":"dirPath"},{"name":"数据库编码","bindName":"code"}],
        "gridheight":"auto",
        "resizewidth":getBodyWidth,
        "custom_pagesize":false,
        "gridwidth":"95%",
        "primarykey":"id",
        "databind":"configRepository.relationSqlDirList",
        "edittype":{"dirPath": {"on_iconclick": selectSqlPath, "uitype": "ClickInput", "readonly": true, "validate": [{"rule":{"m":"脚本路径不能为空"},"type":"required"}]}, "code": {"on_iconclick": dbSelectEvent, "uitype": "ClickInput", "validate": [{"rule":{"m":"数据库编码不能为空"},"type":"required"}]}},
        "uitype":"EditableGrid",
        "lazy":true,
        "pagination":false,
        "selectrows":"no",
        "datasource":cap.editGridDatasource
    }
}

</script>
</html>