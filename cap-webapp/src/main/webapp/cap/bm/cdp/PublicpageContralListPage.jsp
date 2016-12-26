<%
/**********************************************************************
* 发布包管理列表页面
* 2016-10-20 CAP超级管理员 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>发布包管理列表页面</title>
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
	<top:script src='/cap/dwr/interface/CapWorkflowAction.js'></top:script>
	<top:script src='/cap/rt/common/workflow/comtop.cap.rt.workflow.js'></top:script>
	<top:script src='/cap/dwr/interface/PublicpageContralListPageAction.js'></top:script>
	<top:verifyRight resourceString="[{menuCode:'cap_cdp_publicpageContralListPage'}]"/> 
    
</head>
<body>
<div id="pageRoot" class="cap-page">
<div class="cap-area" style="width:100%;">
	<table id="tableid-4294206428807229" class="cap-table-fullWidth">
	</table>
	<table id="tableid-3560829809634015" class="cap-table-fullWidth">
		<tr id="trid-36580671849660575">
			<td id="tdid-9530447873519734" class="cap-td" style="text-align:right;" >
            	<span id="btnQuery" uitype="Button" ></span>
            	<span id="btnClearQuery" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-6789563342463225" class="cap-table-fullWidth">
		<tr id="trid-4765031183836982">
			<td id="tdid-780692390166223" class="cap-td" style="text-align:left;" >
            	<span id="btnAdd" uitype="Button" ></span>
            	<span id="btnDelete" uitype="Button" ></span>
			</td>
		</tr>
	</table>
	<table id="tableid-8942423102911562" class="cap-table-fullWidth">
		<tr id="trid-21558110357727855">
			<td id="tdid-656892663310282" class="cap-td"  >
            	<table id="uiid-2007403086638078" uitype="Grid" ></table>
			</td>
		</tr>
	</table>
</div>
</div>
</body>

<script type="text/javascript">


cap.dicDatas=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("dicDatas"))%>;


var publishPackage={};
var publishPackageList=[];

var hideQueryCondition="hide";
var publicpageContralEditPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/publicpageContralEditPage.ac';
var publicpageContralViewPage='${pageScope.cuiWebRoot}'+'/cap/bm/cdp/publicpageContralEditPage.ac';

		
/**
 * grid初始化查询行为 列表查询行为方法
 * 该方法只支持后台方法有且只有一个参数，且参数类型为对象（vo）
 * 若是多条件查询，需把条件封装在vo中
 * @obj grid对象
 * @pageQuery grid分页信息
 */
function gridDatasource(obj, pageQuery) {
	var queryVarName = 'publishPackage';
	var query = {};
	if(queryVarName !== ''){
		query=cap.getQueryObject(window[queryVarName],pageQuery);
	}
	//初始化查询参数

	//获取查询条件
 	var paramArray = [];
 	paramArray[0] = query;
 	var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.PublishPackage';
	aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.PublishPackage';
 	var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'queryVOListByPage',paramArray);
 	//TODO 调用前操作

	
 	//调用后台查询
 	dwr.TOPEngine.setAsync(true);
	PublicpageContralListPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
		var returnValueVarName= 'publishPackageList';
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
  		var saveQueryData='yes';
  		if(saveQueryData=='yes'){
  			cap.setSessionAttribute({'publishPackage' : cap.cacheGridAttributes(obj.getQuery(), window['publishPackage'])});
  		}
  	},
  	errorHandler:function(message, exception){
	   //TODO 后台异常信息回调

	}
  	});
  	dwr.TOPEngine.setAsync(true);
  	//TODO 可自定义设置返回值

}
	


		
/**
 * 查询按钮方法
 */
function queryData(){
    //获取查询条件表单所有数据
    var gridId='#uiid-2007403086638078';
    
    //重新加载数据，loadData时，会重新调用initData
    cui(gridId).setQuery({pageNo:1});
    cui(gridId).loadData();
}

	

		
/*
 * 清空搜索条件
 */
function clearQueryCondition(){
	
    cui(publishPackage).databind().setEmpty();
    
    //获取查询条件表单所有数据
    var gridId='#uiid-2007403086638078';
    var data = cui(publishPackage).databind().getValue();
    
    //重新加载数据，loadData时，会重新调用initData
    cui(gridId).setQuery({pageNo:1});
    cui(gridId).loadData();
}


	

		
/*
 * 更多查询 更多查询
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function moreCondition(event, self, mark) {
	if(!self){
		cui("#uiid-2007403086638078").hide();
		return; 
	}
	var btnName=self.getLabel();
	if(btnName=='更多▼'){
		self.setLabel('更多▲');
		cui("#uiid-2007403086638078").show();
	}else if(btnName=='更多▲'){
		self.setLabel('更多▼');
		cui("#uiid-2007403086638078").hide();
	}
}
		
	

		
/*
 * 点击按钮跳转页面 点击按钮跳转页面
 *
 * @param event 当前事件对象
 * @param self 当前button对象
 * @param mark 传入的参数
 */
function addBizObject(event, self, mark) { 
	var pageJumpURL=cap.getforwardURL(publicpageContralEditPage);
	var container=window;
	//TODO  调用后台前处理逻辑
	
	//带查询条件返回设置
  	var saveQueryData='yes';
  	 if(saveQueryData=='yes'){
  		pageJumpURL=cap.buildURL(pageJumpURL,{clearSession:false});
  	}
  	//当打开的页面为新窗口，并且当前window实现了addBizObject_pageJump方法，则调用addBizObject_pageJump方法来打开新页面
  	var _openWindow = window["addBizObject_pageJump"]; 
  	if("win" == "win" && _openWindow && typeof(_openWindow) == "function"){
  		_openWindow(pageJumpURL);
  	}else{
		cap.pageJump(pageJumpURL,"win",container);
  	}
}
		
	

		
/**
* 列表页面流程上报行为 上报多条记录，一般在列表页面使用
*/
function entryListData(){
   	//getData 是获取要提交的业务数据的js方法
   	 var gridId= 'uiid-2007403086638078';
   	 var gridObj = cui("#"+gridId);
  	 var getData = function(){
   		var selectDatas = gridObj.getSelectedRowData();
   		if(selectDatas == null || selectDatas.length == 0){
   			cui.alert("请选择要提交的数据。");
   			return;
   		}
   		var checkResult = true;
   		//TODO 校验选择的数据是否能提交
   		
   		if(checkResult){
   			return selectDatas
   		}
   		
  		return [];
  	};
   	//var flowOperateCallback = null; //业务数据流程审批操作后的回调处理方法。
	//TODO 自定义回调处理逻辑 给flowOperateCallback赋值即可，如：
	var flowOperateCallback = function(result){
	    if(result["totalCounts"]==1){
	        if(result["successes"]==1){
	          cui.message("操作成功!", 'success', {'callback':function(){
	             
	   			 gridObj.loadData();
	   			 
	   		  }});
	        }
	        
	        if(result["errors"]==1){
	          cui.alert("操作失败!<br>详细信息:"+result["message"]);
	          gridObj.loadData();
	        }
		   
	    }else{
		 	var mesage="总共操作:"+result["totalCounts"]+"单数据,<br>成功:"+result["successes"]+"单数据,<br>"
	        +"失败:"+result["errors"]+"单数据";
	        if(result["message"]){
	        	mesage+=",<br>详细信息:"+result["message"]
	        }
	   		cui.alert(mesage);
	   	    gridObj.loadData();
	    }
   	}
	
   cap.rt10.workflow.operate.report(false,getData,flowOperateCallback);
}
	

		
//删除行为 删除行为
function deleteRow(){
	//删除前操作
	
	var gridId="uiid-2007403086638078";
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
			var aliasEntityId = 'com.comtop.cap.bm.cdp.entity.PublishPackage';
			aliasEntityId = aliasEntityId != '' ? aliasEntityId :  'com.comtop.cap.bm.cdp.entity.PublishPackage';	
			var dwrInvokeParam = cap.getDwrInvokeParam(aliasEntityId,'deleteList',paramArray);
			PublicpageContralListPageAction.dwrInvoke(dwrInvokeParam,{callback:function(result){
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
	

		
//加载grid数据 重新加载grid数据
function reloadGridData(){
	//刷新前操作
	
	cui("#uiid-2007403086638078").setQuery({pageNo:1});
	cui("#uiid-2007403086638078").loadData();
}
	

//页面初始化状态
function pageInitState(){
	    if(hideQueryCondition=='hide'){
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
    "btnQuery":{
        "id":"btnQuery",
        "on_click":queryData,
        "uitype":"Button",
        "label":"查询",
        "name":"btnQuery"
    },
    "btnClearQuery":{
        "id":"btnClearQuery",
        "on_click":clearQueryCondition,
        "uitype":"Button",
        "label":"清空条件",
        "name":"btnClearQuery"
    },
    "btnAdd":{
        "id":"btnAdd",
        "on_click":addBizObject,
        "uitype":"addButton",
        "label":"新增",
        "name":"btnAdd"
    },
    "btnDelete":{
        "id":"btnDelete",
        "on_click":deleteRow,
        "uitype":"deleteButton",
        "label":"删除",
        "name":"btnDelete"
    },
    "uiid-2007403086638078":{
        "resizeheight":getBodyHeight,
        "columns":[{"bindName":"publishVersion","name":"publishVersion","render":"a","options":"{'url':publicpageContralEditPage,'params':'id','targets':'_blank'}"},{"bindName":"configRepoId","name":"configRepoId"}],
        "gridheight":"auto",
        "resizewidth":getBodyWidth,
        "custom_pagesize":false,
        "primarykey":"id",
        "uitype":"Grid",
        "lazy":true,
        "pagination":true,
        "selectrows":"multi",
        "datasource":gridDatasource
    }
}

</script>
</html>