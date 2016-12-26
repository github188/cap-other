<%
  /**********************************************************************
	* 服务建模----服务实体列表
	* 2016-5-30 林玉千 新增
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>

<!doctype html>
<html>
<head>
<title>服务新增</title>
	<link rel="shortcut icon" href="${pageScope.cuiWebRoot}/cap/ptc/index/image/service.png">
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
	<top:link href="/cap/bm/common/base/css/base.css"></top:link>
	<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"></top:link>
	<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
	<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>                        
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/ServiceObjectFacade.js'></top:script>
	<top:script src='/cap/dwr/interface/ServiceAction.js'></top:script>
</head>
<style>
.top_header_wrap {
	padding-right: 5px;
}
.spanTop {
  font-family: "Microsoft Yahei";
  font-size: 20px;
  color: #0099FF;
  margin-left: 20px;
  float: left;
  line-height:45px;
}
.divTitle {
  font-family: "Microsoft Yahei";
  font-size: 14px;
  color: #0099FF;
  margin-left: 20px;
  float: left;
}
.editGrid{
  margin-left: 100px;
}
</style>
<body>
<div uitype="Borderlayout" id="objectMain" is_root="true" >
	<div position="left" width="300" collapsable="true" show_expand_icon="true">
		<div class="top_header_wrap">
			<div class="thw_operate" id="serviceObjectDiv" style="float:right;">
				<span uitype="button" id="btnObjectNew" label="新增" on_click="addServiceObject"></span>
				<span uitype="button" id="btnObjectDelete" label="删除" on_click="delServiceObject"></span>
				<span uitype="button" id="executeGenerateCode" label="注册所有服务" on_click="executeGenerateCode"></span>
			</div>
		</div>
		<table uitype="Grid" id="ServiceObjectGrid" primarykey="modelId" sorttype="1" datasource="initServiceObjectData" pagination="false"
				gridwidth="295px"  gridheight="auto"  selectrows="single" colrender="columnRenderer" rowclick_callback="selectOneObject" selectall_callback="selectAllObject">
			<thead>
			<tr>
				<th style="width:30px;">&nbsp;</th>
				<th render="serviceObjectRender" renderStyle="text-align: left;" >服务对象</th>
				<th render="objectComeRender" style="width:100px;" renderStyle="text-align: center;" >服务中文名</th>
			</tr>
			</thead>
		</table>
    </div>
    <div position="top" height="47" >
        <span class="spanTop">服务建模</span>
    </div>
    <div position="center" url="">
	</div>
</div>

<script type="text/javascript">
	var packageId = "${param.packageId}";//应用ID 
	var packagePath = "${param.packagePath}";//包路径
	var selectedObjectId = "${param.selectedObjectId}";//列表选中的行ID 
	var appInsertFlag = "${param.appInsertFlag}" ; //从AppDetail操作新增  true：是
	var appEditFlag = "${param.appEditFlag}" ; //从AppDetail操作编辑  true：是
	var isEntity = false;
	var isFirstInsert=false;
	
	//初始化 
	window.onload = function(){
		comtop.UI.scan();
   	}
	
	//服务对象数据源
	function initServiceObjectData(tableObj,query) {
		dwr.TOPEngine.setAsync(false);
		ServiceObjectFacade.queryServiceObjectList(packageId,function(data){
		    tableObj.setDatasource(data);
		    if(appInsertFlag=="true" && selectedObjectId==""){
		    	setCenterEditUrl("","insert");
		    }else{
			    if(data.length>0 && selectedObjectId==""){//列表存在记录
			    	selectedObjectId = data[0].modelId;
	 				setCenterEditUrl(selectedObjectId,"edit");
			    }
		    	tableObj.selectRowsByPK(selectedObjectId);
		    	if(isFirstInsert){
		    		setCenterEditUrl(selectedObjectId,"edit");
		    	}
		    	if(appEditFlag == "true"){
		    		appEditFlag == "";
		    		setCenterEditUrl(selectedObjectId,"edit");
		    	}
		    }
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//刷新grid
	function refreshGrid(flag){
		isFirstInsert = flag;
		var tableObj =  cui("#ServiceObjectGrid");
		initServiceObjectData(tableObj);
	}
	
	//设置右侧编辑页面 
	function setCenterEditUrl(modelId,editType){ 
		var url = "ServiceObjectInsert.jsp?modelId=" + modelId + "&packagePath="+packagePath + "&packageId="+packageId + "&editType=" + editType;
		cui("#objectMain").setContentURL("center",url); 
	}
	
	//服务对象
	function serviceObjectRender(rd, index, col) {
		return rd.englishName;
	}
	
	//服务对象
	function objectComeRender(rd, index, col) {
		return rd.chineseName;
	}
	
	//序号列 
	function rowNoRender(rowData, index, colName){
		return index+1;
	}
	
	//新增按钮事件 
	function addServiceObject(){
		cui("#ServiceObjectGrid").selectRowsByPK(selectedObjectId,false);
		setCenterEditUrl("","insert");
	}
	
	//删除按钮事件 
	function delServiceObject(){
		var selectIds = cui("#ServiceObjectGrid").getSelectedPrimaryKey();
		var indexs = cui("#ServiceObjectGrid").getSelectedIndex();
		var selectIndex = parseInt(indexs[0]);
		if(selectIds == null || selectIds.length == 0){
			cui.alert("请选择要删除的服务对象。");
			return;
		}
		var selectData = cui("#ServiceObjectGrid").getSelectedRowData(); 
		if(selectData[0].entityId){
			cui.alert("来源为实体，不允许删除！");
			return;
		}
		cui.confirm("确定要删除这"+selectIds.length+"个服务对象吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				ServiceObjectFacade.delServiceObjectList(selectIds, function(result) {
					
						var nextSelectData =  cui("#ServiceObjectGrid").getRowsDataByIndex(selectIndex+1);
						if(nextSelectData[0]){ // 后面一行有值取下一行记录 
							selectedObjectId = nextSelectData[0].id;
						}else if(!nextSelectData[0] && selectIndex > 0){ // 删除的为最后一行 ，取第一行记录 
							selectedObjectId = cui("#ServiceObjectGrid").getRowsDataByIndex(0)[0].id;
						}else{
							selectedObjectId = "";
						}
						cui("#ServiceObjectGrid").loadData();
						cui.message("删除成功。","success");
						if(selectedObjectId){
							cui("#ServiceObjectGrid").selectRowsByPK(selectedObjectId);
						}
	                });
		    	dwr.TOPEngine.setAsync(true);
			}
		});
	}
	
	//单击行事件 
	function selectOneObject(rowData,isChecked,index){
		selectedObjectId = rowData.modelId;
		setCenterEditUrl(rowData.modelId,"edit");
	}
	
	//全选按钮事件 
	function selectAllObject(rowData,isChecked,index){
		
	}
	
	//编辑保存后刷新grid
	function loadGrid(objectId){
		selectedObjectId = objectId;
		cui("#ServiceObjectGrid").loadData();
		cui("#ServiceObjectGrid").selectRowsByPK(selectedObjectId);
	}
	
	//右侧点击编辑按钮，重新加载主要是为了方法的方法签名可编辑 
	function editLoad(modelId){
		setCenterEditUrl(modelId,"edit");
	}
	
	//右侧点击编辑按钮，重新加载主要是为了方法的方法签名不可编辑  
	function saveLoad(modelId){
		setCenterEditUrl(modelId,"edit");
	}
	
	/**
	* 取消后重新加载
	*/
	function cancelLoad(modelId){
		setTimeout(function(){
			setCenterEditUrl(modelId,"edit");
		},50);
	}
	
	//注册服务
	function executeGenerateCode(){
		createCustomHM();
		ServiceAction.executeGenerateCode(packageId, function(msg){
				removeCustomHM();
				if ("" == msg ){
					window.top.cui.message('注册服务成功。','success');
				}else{
					window.top.cui.message(msg,'error');
				}
		});
	}
	
	var objHandleMask;
	//生成遮罩层
	function createCustomHM(){
		objHandleMask = cui.handleMask({
	        html:'<div style="padding:10px;border:1px solid #666;background: #fff;"><div class="handlemask_image_1"/><br/>正在注册服务，预计需要2~3分钟，请耐心等待。</div>'
	    });
		objHandleMask.show();
	}

	//生成遮罩层
	function removeCustomHM(){
		objHandleMask.hide();
	}
	
</script>
</body>
</html>