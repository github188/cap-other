<%
/**********************************************************************
* 动态步骤-自动录入字段-选择页面
* 2016-7-8 李小芬  新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <title>选择编辑页面</title>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	    <top:link href="/cap/bm/common/base/css/base.css"></top:link>
    <top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"/>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
    <top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
    <top:script src='/cap/dwr/engine.js'></top:script>
    <top:script src='/cap/dwr/util.js'></top:script>
    <top:script src='/cap/dwr/interface/PageFacade.js'></top:script>
    <top:script src='/cap/dwr/interface/PageMetadataProvider.js'></top:script>
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
		        	<span id="formTitle" uitype="Label" value="界面列表" class="cap-label-title" size="12pt"></span>
		        </td>
		        <td class="cap-td" style="text-align: right;padding:5px">
		        	 <span id="selectGrid" uitype="Button" onclick="selectGrid()" label="确定"></span> 
		        	 <span id="clearBtn" uitype="Button" onclick="clearValue()" label="清空"></span>
		        	 <span uitype="button" label="关闭" on_click="closeSelf"></span>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth">
		    <tr>
		        <td class="cap-td">
		        	<table uitype="Grid" id="pageGrid" primarykey="modelId" selectrows="single" colhidden="false" datasource="initPageData" pagination="false"
					 	resizewidth="getBodyWidth" resizeheight="getBodyHeight"  rowclick_callback="gridRowclick" colrender="columnRenderer">
						<thead>
							<tr>
							    <th style="width:25px"></th>
								<th  style="width:35px" renderStyle="text-align: center;" bindName="1">序号</th>
								<th  style="width:20%" renderStyle="text-align: left" render="editPage" bindName="cname">页面标题</th>
								<th  style="width:25%" renderStyle="text-align: left" bindName="modelName">页面英文名</th>
								<th  style="width:30%" renderStyle="text-align: left" bindName="modelPackage">页面包路径</th>			 
							</tr>
						</thead>
					</table>
		        </td>
		    </tr>
		</table>
		<table class="cap-table-fullWidth" width="100%">
			<colgroup>
				<col width="25%" />
				<col width="75%" />
			</colgroup>
			 <tr>
		        <td class="cap-td" style="text-align: left;padding:5px">
		        	<span id="formTitle" uitype="Label" value="选择EditableGrid：" class="cap-label-title" size="12pt"></span>
		        </td>
		        <td class="cap-td" style="text-align: left;padding:5px">
		         <span id="editableGridList" uitype="PullDown" value_field="id" label_field="text" select=0
	               		databind="" width="93%" datasource="editableGridList" on_change=""></span>
		        </td>
		    </tr>
		</table>
	</div>
</div>
	<script type="text/javascript">
	var packageId = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("packageId"))%>;
	var selectEditPageGrid = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("editPageGrid"))%>;
	var argName = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("argName"))%>;
    var callbackMethod = <%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getParameter("callbackMethod"))%>;
    callbackMethod = callbackMethod != null ? callbackMethod : 'commonCallback';
	var pageModelId = selectEditPageGrid != null ? selectEditPageGrid.split(";")[0] : null; 
	
	$(document).ready(function(){
		comtop.UI.scan();   //扫描
		if(pageModelId){
			cui('#pageGrid').selectRowsByPK(pageModelId, true);
		}
	});
	
	//选择页面
	function selectGrid() {
		var selectedPageModelId = cui('#pageGrid').getSelectedPrimaryKey();
		if(selectedPageModelId == null ||  selectedPageModelId.length == 0){
			cui.alert("请选择元数据页面.");
		} else {
			var selectData = cui("#editableGridList").getValue();
			if (!selectData) {
				cui.alert("该页面没有EditableGrid.");
			} else {
				window.opener[callbackMethod](selectedPageModelId[0] + ";" + selectData, argName);
				closeSelf();
			}
		}
	}
	
	//清空
	function clearValue(){
		window.opener[callbackMethod]('', argName);
		closeSelf();
	}
	
	//行选择事件
	function gridRowclick(rowData, isChecked, index){
		pageModelId = rowData.modelId;
		var initData = getDatasource2EditableGridPullDown(pageModelId, ["EditableGrid"]);
		cui("#editableGridList").setDatasource(initData);
		if(initData.length > 0 ){
			cui("#editableGridList").setValue(initData[0].id);
		}
	}
	
	//初始化下拉框数据源
	function editableGridList(obj){
		var initData = getDatasource2EditableGridPullDown(pageModelId, ["EditableGrid"]);
		obj.setDatasource(initData);
		var params = selectEditPageGrid != null ? selectEditPageGrid.split(";") : [];
		if(params.length > 0){
			obj.setValue(params[1]);
		} else if(initData.length > 0 ){
			obj.setValue(initData[0].id);
		}
	}
	
	function getDatasource2EditableGridPullDown(pageModelId, query){
		var initData = [];
		dwr.TOPEngine.setAsync(false);
		PageMetadataProvider.queryCmpsByUItypes(pageModelId, query, function(result){
			if(result && result.dataList){
				for(var i=0, len=result.dataList.length; i<len; i++){
					var arr = {id: result.dataList[i].id, text: result.dataList[i].id};
					initData.push(arr);
				}
			}
		});
		dwr.TOPEngine.setAsync(true);
		return initData;
	}
	
    //页面关闭
	function closeSelf(){
		window.close();
	}
	
	//初始化列表
	function initPageData(gridObj, query) {
		dwr.TOPEngine.setAsync(false);
		PageFacade.queryPageList(packageId,function(data) {
			  gridObj.setDatasource(data, data.length);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//过滤自定义的jsp页面
	function getJspData(pageData){
		var retData = [];
		for(var i =0;i<pageData.length;i++){
			if(pageData[i].pageType==2){
				retData.push(pageData[i]);
			}
		}
		return retData;
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
	    return (document.documentElement.clientHeight || document.body.clientHeight) - 121;
	}
	
		
	</script>
</body>
</html>