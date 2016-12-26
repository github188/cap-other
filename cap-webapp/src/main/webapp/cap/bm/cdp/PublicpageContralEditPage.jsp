<%
/**********************************************************************
* 发布包管理编辑页面
* 2016-10-20 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>发布包管理编辑页面</title>
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
	<top:script src='/cap/rt/common/cui/js/comtop.ui.editor.min.js'></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/PublicpageContralEditPageAction.js'></top:script>
	<top:verifyRight resourceString="[{menuCode:'cap_cdp_publicpageContralEditPage'}]"/> 
    
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
	<table id="tableid-07823887481522869" class="cap-table-fullWidth">
		<tr id="trid-040356617878753">
			<td id="tdid-03966161724475087" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-019621281887984476" uitype="Label" ></span>
			</td>
			<td id="tdid-04058354040218781" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-04694385022929476" uitype="Input" ></span>
			</td>
			<td id="tdid-021205990753894022" class="cap-td" style="text-align:right;width:20%;" >
            	<span id="uiid-07657095283547926" uitype="Label" ></span>
			</td>
			<td id="tdid-0018227256438817285" class="cap-td" style="text-align:left;width:30%;" colspan='1'>
            	<span id="uiid-04764521002881982" uitype="Input" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-058638757017841" class="cap-table-fullWidth">
		<tr id="trid-03428640604717661">
			<td id="tdid-008685721628988652" class="cap-td" style="text-align:left;" >
            	<span id="07860726605935031" uitype="Button" ></span>
            	<span id="03309329114600219" uitype="Button" ></span>
            	<div id="uiid-2696136621261096" uitype="Editor"></div>
			</td>
		</tr>
	</table>
	<table id="tableid-07625405687463372" class="cap-table-fullWidth">
		<tr id="trid-06086002950980561">
			<td id="tdid-013477149691213108" class="cap-td"  >
            	<table id="uiid-020727665763989356" uitype="EditableGrid" ></table>
			</td>
		</tr>
	</table>
	<table id="tableid-06153805404691587" class="cap-table-fullWidth">
		<tr id="trid-05073398576168359">
			<td id="tdid-05459140938132371" class="cap-td" style="text-align:left;" >
            	<span id="0622106877647087" uitype="Button" ></span>
            	<span id="06282418180885349" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-06531441311463737" class="cap-table-fullWidth">
		<tr id="trid-012027192021918953">
			<td id="tdid-032606524006078497" class="cap-td"  >
            	<table id="uiid-07304335466747913" uitype="EditableGrid" ></table>
			</td>
		</tr>
	</table>
	<table id="tableid-09317504794617726" class="cap-table-fullWidth">
		<tr id="trid-09618926244657413">
			<td id="tdid-0045649144346710746" class="cap-td" style="text-align:left;" >
            	<span id="009190756422393953" uitype="Button" ></span>
            	<span id="042229294006679396" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-01393858096934083" class="cap-table-fullWidth">
		<tr id="trid-02967799581325531">
			<td id="tdid-09812348923278907" class="cap-td"  >
            	<table id="uiid-07677891989268114" uitype="EditableGrid" ></table>
			</td>
		</tr>
	</table>
	<table id="tableid-06363902489505338" class="cap-table-fullWidth">
		<tr id="trid-05910753823376897">
			<td id="tdid-09091381996470522" class="cap-td" style="text-align:left;" >
            	<span id="05188267448455061" uitype="Button" ></span>
            	<span id="05417214487170434" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-03737395943434436" class="cap-table-fullWidth">
		<tr id="trid-07996837261341618">
			<td id="tdid-016992490658810577" class="cap-td"  >
            	<table id="uiid-043352377334987546" uitype="EditableGrid" ></table>
			</td>
		</tr>
	</table>
	<table id="tableid-038772738064071044" class="cap-table-fullWidth">
		<tr id="trid-038337614505023787">
			<td id="tdid-08223449135262498" class="cap-td" style="text-align:left;" >
            	<span id="05421269812243106" uitype="Button" ></span>
            	<span id="06997678329225289" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-01782632788315096" class="cap-table-fullWidth">
		<tr id="trid-0520825253132133">
			<td id="tdid-07128073634348072" class="cap-td"  >
            	<table id="uiid-06847877278884014" uitype="EditableGrid" ></table>
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


var publishPackage={};

var publicpageContralListPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/publicpageContralListPage.ac';

		
//页面初始化数据加载行为 页面初始化数据加载行为
function pageInitLoadData(){
	//TODO 加载数据前操作

	var paramArray =[];
	cap.formId = id;
	var param = "id";
    if (param) {
       paramArray = param.split(",");
    }
	if(!cap.isUndefinedOrNullOrBlank(cap.formId) && paramArray.length>0){
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.PublishPackage';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.PublishPackage';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'getPublishPage',paramArray);
		dwr.TOPEngine.setAsync(false);
		PublicpageContralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
			//TODO 数据设置前操作

			publishPackage=result;
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
				defaultValue = <%=com.comtop.cip.json.JSON.toJSONStringWithDateFormat(request.getAttribute("publishPackage"),"yyyy-MM-dd HH:mm:ss")%>;
				break;
			//TODO 增加case控制

		}
		publishPackage = defaultValue ? defaultValue : {};
	}
	//TODO 数据加载完成后操作

}
	

		
//保存表单行为 保存表单行为
function saveForm(){
	//校验前操作

	var saveContinue=2;
	if(cap.validateForm()){
		cap.beforeSave();
		//提交数据前操作

		var paramArray = [];
		var paramsStr = 'publishPackage';
		if(paramsStr != ''){
			paramArray = paramsStr.split(',');
		}
		var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.PublishPackage';
		aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.PublishPackage';
		var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'savaPublishPage',paramArray);
		var result;
		dwr.TOPEngine.setAsync(false);
		PublicpageContralEditPageAction.dwrInvoke(dwrInvokeParam,{callback:function(_result){
			//赋值前操作
			result = _result;
			if(""!="publishPackage.id"){
				eval("publishPackage.id=_result");
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
							reloadURL = localURL +"&primaryValue="+publishPackage.id; 
						}
					}else{
						reloadURL = localURL +"?primaryValue="+publishPackage.id; 
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
	var pageJumpURL=cap.getforwardURL(publicpageContralListPage);
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
function addRows09612342929800984(event, self, mark) { 
	var gridId="uiid-020727665763989356";
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
function deleteRows003419448038495421(event, self, mark) { 
	var gridId="uiid-020727665763989356";
	//自定义删除前处理逻辑
	
	cui("#"+gridId).deleteSelectRow();
}
	

		
/*
 * editGrid新增事件 editGrid新增事件
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addRows002360260545612336(event, self, mark) { 
	var gridId="uiid-07304335466747913";
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
function deleteRows0008615965364194955(event, self, mark) { 
	var gridId="uiid-07304335466747913";
	//自定义删除前处理逻辑
	
	cui("#"+gridId).deleteSelectRow();
}
	

		
/*
 * editGrid新增事件 editGrid新增事件
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addRows08683513897177372(event, self, mark) { 
	var gridId="uiid-07677891989268114";
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
function deleteRows06537216968186749(event, self, mark) { 
	var gridId="uiid-07677891989268114";
	//自定义删除前处理逻辑
	
	cui("#"+gridId).deleteSelectRow();
}
	

		
/*
 * editGrid新增事件 editGrid新增事件
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addRows03901052367919947(event, self, mark) { 
	var gridId="uiid-043352377334987546";
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
function deleteRows03427176951715848(event, self, mark) { 
	var gridId="uiid-043352377334987546";
	//自定义删除前处理逻辑
	
	cui("#"+gridId).deleteSelectRow();
}
	

		
/*
 * editGrid新增事件 editGrid新增事件
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addRows009585196389072403(event, self, mark) { 
	var gridId="uiid-06847877278884014";
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
function deleteRows08907463446113506(event, self, mark) { 
	var gridId="uiid-06847877278884014";
	//自定义删除前处理逻辑
	
	cui("#"+gridId).deleteSelectRow();
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
    "uiid-019621281887984476":{
        "value":"publishVersion:",
        "uitype":"Label",
        "label":"publishVersion",
        "isReddot":false,
        "name":"publishVersionLabel"
    },
    "uiid-04694385022929476":{
        "uitype":"Input",
        "validate":[{"type":"length","rule":{"max":100,"maxm":"publishVersion长度不能大于100个字符"}}],
        "databind":"publishPackage.publishVersion",
        "name":"publishVersion"
    },
    "uiid-07657095283547926":{
        "value":"configRepoId:",
        "uitype":"Label",
        "label":"configRepoId",
        "isReddot":false,
        "name":"configRepoIdLabel"
    },
    "uiid-04764521002881982":{
        "uitype":"Input",
        "validate":[{"type":"required","rule":{"m":"configRepoId不能为空"}},{"type":"length","rule":{"max":32,"maxm":"configRepoId长度不能大于32个字符"}}],
        "databind":"publishPackage.configRepoId",
        "name":"configRepoId"
    },
    "07860726605935031":{
        "id":"07860726605935031",
        "on_click":addRows09612342929800984,
        "uitype":"addButtonOnEditGrid",
        "label":"新增",
        "name":"add07860726605935031"
    },
    "03309329114600219":{
        "id":"03309329114600219",
        "on_click":deleteRows003419448038495421,
        "uitype":"deleteButtonOnEditGrid",
        "label":"删除",
        "name":"delete03309329114600219"
    },
    "uiid-2696136621261096":{
        "server_url":"${pageScope.cuiWebRoot}/cap/rt/common/cui/js/uedit/jsp/controller.jsp",
        "textmode":true,
        "databind":"publishPackage.shortDesc",
        "name":"shortDesc",
        "maximum_words":10000,
        "uitype":"Editor",
        "focus":false,
        "validate":[{"type":"length","rule":{"max":32,"maxm":"简述长度不能大于32个字符"}}]
    },
    "uiid-020727665763989356":{
        "resizeheight":getBodyHeight,
        "columns":[{"bindName":"jobName","name":"jobName"}],
        "resizewidth":getBodyWidth,
        "custom_pagesize":false,
        "primarykey":"id",
        "name":"ItemByRelations",
        "databind":"publishPackage.relationBuildInfo",
        "edittype":{"jobName": {"uitype": "Input"}},
        "uitype":"EditableGrid",
        "lazy":true,
        "pagination":true,
        "selectrows":"multi",
        "datasource":cap.editGridDatasource
    },
    "0622106877647087":{
        "id":"0622106877647087",
        "on_click":addRows002360260545612336,
        "uitype":"addButtonOnEditGrid",
        "label":"新增",
        "name":"add0622106877647087"
    },
    "06282418180885349":{
        "id":"06282418180885349",
        "on_click":deleteRows0008615965364194955,
        "uitype":"deleteButtonOnEditGrid",
        "label":"删除",
        "name":"delete06282418180885349"
    },
    "uiid-07304335466747913":{
        "resizeheight":getBodyHeight,
        "columns":[{"bindName":"description","name":"description"}],
        "resizewidth":getBodyWidth,
        "custom_pagesize":false,
        "primarykey":"id",
        "name":"ItemByRelations",
        "databind":"publishPackage.relationUserOperItemList",
        "edittype":{"description": {"uitype": "Input"}},
        "uitype":"EditableGrid",
        "lazy":true,
        "pagination":true,
        "selectrows":"multi",
        "datasource":cap.editGridDatasource
    },
    "009190756422393953":{
        "id":"009190756422393953",
        "on_click":addRows08683513897177372,
        "uitype":"addButtonOnEditGrid",
        "label":"新增",
        "name":"add009190756422393953"
    },
    "042229294006679396":{
        "id":"042229294006679396",
        "on_click":deleteRows06537216968186749,
        "uitype":"deleteButtonOnEditGrid",
        "label":"删除",
        "name":"delete042229294006679396"
    },
    "uiid-07677891989268114":{
        "resizeheight":getBodyHeight,
        "columns":[{"bindName":"changeNo","name":"changeNo"},{"bindName":"description","name":"description"}],
        "resizewidth":getBodyWidth,
        "custom_pagesize":false,
        "primarykey":"id",
        "name":"ItemByRelations",
        "databind":"publishPackage.relationChangeList",
        "edittype":{"changeNo": {"uitype": "Input"}, "description": {"uitype": "Input"}},
        "uitype":"EditableGrid",
        "lazy":true,
        "pagination":true,
        "selectrows":"multi",
        "datasource":cap.editGridDatasource
    },
    "05188267448455061":{
        "id":"05188267448455061",
        "on_click":addRows03901052367919947,
        "uitype":"addButtonOnEditGrid",
        "label":"新增",
        "name":"add05188267448455061"
    },
    "05417214487170434":{
        "id":"05417214487170434",
        "on_click":deleteRows03427176951715848,
        "uitype":"deleteButtonOnEditGrid",
        "label":"删除",
        "name":"delete05417214487170434"
    },
    "uiid-043352377334987546":{
        "resizeheight":getBodyHeight,
        "columns":[{"bindName":"filePath","name":"filePath"}],
        "resizewidth":getBodyWidth,
        "custom_pagesize":false,
        "primarykey":"id",
        "name":"ItemByRelations",
        "databind":"publishPackage.relationExtractFileList",
        "edittype":{"filePath": {"uitype": "Input"}},
        "uitype":"EditableGrid",
        "lazy":true,
        "pagination":true,
        "selectrows":"multi",
        "datasource":cap.editGridDatasource
    },
    "05421269812243106":{
        "id":"05421269812243106",
        "on_click":addRows009585196389072403,
        "uitype":"addButtonOnEditGrid",
        "label":"新增",
        "name":"add05421269812243106"
    },
    "06997678329225289":{
        "id":"06997678329225289",
        "on_click":deleteRows08907463446113506,
        "uitype":"deleteButtonOnEditGrid",
        "label":"删除",
        "name":"delete06997678329225289"
    },
    "uiid-06847877278884014":{
        "resizeheight":getBodyHeight,
        "columns":[{"bindName":"versionNo","name":"versionNo"}],
        "resizewidth":getBodyWidth,
        "custom_pagesize":false,
        "primarykey":"id",
        "name":"ItemByRelations",
        "databind":"publishPackage.relationExtractVer",
        "edittype":{"versionNo": {"uitype": "Input"}},
        "uitype":"EditableGrid",
        "lazy":true,
        "pagination":true,
        "selectrows":"multi",
        "datasource":cap.editGridDatasource
    }
}

</script>
</html>