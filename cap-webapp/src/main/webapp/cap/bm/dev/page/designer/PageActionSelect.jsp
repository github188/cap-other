<%
/**********************************************************************
* 页面行为选择界面
* 2015-8-7 章尊志 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>页面行为选择界面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
    <top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
	<top:script src="/cap/dwr/engine.js"></top:script>
	<top:script src="/cap/dwr/util.js"></top:script>
	<top:script src="/cap/dwr/interface/BuiltInActionPreferenceFacade.js"></top:script>    
	<style type="text/css">
		img{
		  margin-left:5px;
		}
	</style>
</head>
<body>
<div uitype="Borderlayout"  id="body"  is_root="true"> 
		<div id="centerMain" position ="center">
		<table class="cap-table-fullWidth" width="100%">
		    <tr>
		        <td class="cap-td" style="text-align: left;padding:5px">
		        	<span id="formTitle" uitype="Label" value="页面行为列表" class="cap-label-title" size="12pt"></span>&nbsp;&nbsp;
		        	类型：<span uitype="PullDown" id="actionType" mode="Single" width="100" select="0" value_field="id" label_field="text" datasource="initActionType" on_change="selectActionType"></span>&nbsp;&nbsp;
		        	<span uitype="ClickInput" id="quickSearch" width="240" name="search" editable="true" on_keydown="keyDownQuery" on_iconclick="keyWordQuery" emptytext="请输入行为中文名称" icon="search"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		             <span id="selectPageAction" uitype="Button" onclick="selectPageAction()" label="确定"></span> 
		             <span id="cleanData" uitype="Button" onclick="cleanData()" label="清空"></span> 
		             <span id="addPageAction" uitype="Button" onclick="addPageAction()" label="新增"></span> 
			         <span id="close" uitype="Button" onclick="window.close();" label="关闭"></span> 
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td">
		        	<table uitype="Grid" id="pageAction" primarykey="pageActionId" selectrows="single" colhidden="false" datasource="initPageActionData" pagination="false"
					 	resizewidth="getBodyWidth" resizeheight="getBodyHeight"  colrender="columnRenderer">
						<thead>
							<tr>
							    <th style="width:25px"></th>
								<th  style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
								<th  style="width:20%" renderStyle="text-align: center;" render="editPage" bindName="cname">行为中文名称</th>
								<th  style="width:20%" renderStyle="text-align: center;" bindName="ename">行为英文名称</th>
								<th  style="width:20%" renderStyle="text-align: center;" bindName="actionDefineVO.modelName">行为模板</th>	
								<th  style="width:20%" renderStyle="text-align: center;" bindName="pageActionId" render="actionTypeRender">行为类型</th>		 	 
								<th  style="width:30%" renderStyle="text-align: left" bindName="description">描述</th>
							</tr>
						</thead>
					</table>
		        </td>
		    </tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	var pageId="<%=request.getParameter("modelId")%>";
	var packageId=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
   	var flag=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("flag"))%>;
   	var methodTemplate=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("methodTemplate"))%>;
   	var actionType = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("actionType"))%>;
   	var pageSession = new cap.PageStorage(pageId);
   	var pageActions = pageSession.get("action");
	
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
	});
	
	//获取内置行为方法
    function queryBuiltInActionList(){
    	var builtInActionList = [];
    	var page = pageSession.get("page");
		var includeFileList = page.includeFileList;
		var filePaths=[];
		for(var i=0;i<includeFileList.length;i++){
			if(includeFileList[i].fileType === 'js'){
				filePaths.push(includeFileList[i].filePath);
			}
		}
		dwr.TOPEngine.setAsync(false);
		BuiltInActionPreferenceFacade.queryListByFileName(filePaths,function(data){
			if(data!=null){
				builtInActionList = data;
			}
		});	
		dwr.TOPEngine.setAsync(true);
		return builtInActionList;
    }
	
	//初始化行为类型pulldown数据源
	function initActionType(obj){
		obj.setDatasource([{id:'0',text:'全部'},{id:'1',text:'内置'},{id:'2',text:'自定义'}]);
	}
	
	//行为类型改变选择事件
	function selectActionType(){
		keyWordQuery();
	}
	
	//内置行为函数集合
	var parentOpenerQueryBuiltInAction = window.opener.queryBuiltInAction?window.opener.queryBuiltInAction:window.opener.opener.queryBuiltInAction;
    var lstBuiltInAction = parentOpenerQueryBuiltInAction.data;

	//初始化页面模板列表
	function initPageActionData(gridObj, query) {
		var dataSource = getShowPageActionData();
		gridObj.setDatasource(dataSource, dataSource.length);
	}
	
	//页面展示可供选择的行为
	function getShowPageActionData(){
		var selectActionType = cui("#actionType").getValue();
		var allPageActions =[];//行为函数
		var pageActions4built = [];//内置行为
		if(selectActionType == "0"){
			allPageActions = jQuery.extend(true, [], pageActions);
			pageActions4built = lstBuiltInAction;
		} else if(selectActionType == "1"){
			pageActions4built = lstBuiltInAction;
		} else {
			allPageActions = pageActions;
		}
		if(pageActions4built.length > 0){
			for(var i in pageActions4built){
				var objbuiltInAction = pageActions4built[i];
				var objAction ={pageActionId:objbuiltInAction.actionMethodName,cname:objbuiltInAction.description,ename:objbuiltInAction.actionMethodName,description:objbuiltInAction.description,actionDefineVO:{modelName:""}};
				allPageActions.push(objAction);
			}
		}
    	return allPageActions;
	}
    
	//行为类型列渲染函数
	function actionTypeRender(rd, index, col) {
		return $.isNumeric(rd.pageActionId) ? "自定义" : "内置";
	}
	
    /**
	 * 根据行为模版，获取行为函数
	 * @param searchField 查询字段
	 * @param q 查询数据集
	 */
    function getDataSourceByActionTmp(methodTemplate, q){
    	var dataSource = [];
    	var result = q.query("this.methodTemplate=='"+methodTemplate+"'");
    	for(var i in result){
	    	dataSource.push({id:result[i].pageActionId,text:result[i].ename});
	    }
	    return dataSource;
    }
    
    /**
	 * 根据行为类型，获取行为函数
	 * @param searchField 查询字段
	 * @param q 查询数据集
	 */
    function getDataSourceByActionType(searchField, actionType, q){
    	var dataSource = [];
    	var result = q.query("this."+searchField+"=='"+actionType+"'");
    	if(searchField === 'type'){
	    	for(var i in result){
		    	dataSource.push({id:result[i].actionMethodName,text:result[i].actionMethodName});
		    }
	    } else if(searchField === 'actionDefineVO.type'){
	    	for(var i in result){
		    	dataSource.push({id:result[i].pageActionId,text:result[i].ename});
		    }
	    }
	    return dataSource;
    }
	
	//新增行为
	function addPageAction(){
		 var url='${pageScope.cuiWebRoot}/cap/bm/dev/page/designer/PageActionEdit.jsp?modelId='+pageId+'&packageId='+packageId+"&flag="+flag+"&operationType=insert&methodTemplate="+methodTemplate+"&actionType="+actionType+'&type='+"<c:out value='${param.type}'/>";
		 window.location = url;
	}
	
	function selectPageAction(){
		var  selectData = cui("#pageAction").getSelectedRowData();
		  if(selectData == null || selectData.length == 0){
				cui.alert("请选择页面行为。");
				return;
			}else{
				window.opener.selectPageActionData(selectData[0],flag);
				window.close();
		}
	}
	
	//清空选择的数据
	function cleanData(){
		window.opener.cleanSelectPageActionData(flag);
		window.close();
	}
	
	 //快速查询,根据行为中文名称过滤数据
	function keyWordQuery(){
		var keyWord = cui('#quickSearch').getValue(); 
		var showPageActionData = getShowPageActionData();
		if(keyWord!=""){
			var serchPageActions = new cap.CollectionUtil(showPageActionData);
		    var lstSerchPageActions = serchPageActions.query("this.cname.indexOf('"+ keyWord +"') != -1");
		    cui("#pageAction").setDatasource(lstSerchPageActions,lstSerchPageActions.length);
		}else{
			cui("#pageAction").setDatasource(showPageActionData,showPageActionData.length);
		}
	}
	 
	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			keyWordQuery();
		}
	} 
	
	/**
	 * 表格自适应宽度
	 */
	function getBodyWidth () {
	    return parseInt(jQuery("#centerMain").css("width"))- 10;
	}

	/**
	 * 表格自适应高度
	 */
	function getBodyHeight () {
	    return (document.documentElement.clientHeight || document.body.clientHeight) - 71;
	}
	
	</script>
</body>
</html>