<%
  /**********************************************************************
	* CIP元数据建模----服务新增
	* 2015-6-30 李小芬 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<title>服务新增</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/BizObjInfoAction.js'></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/cui.utils.js"></script>

</head>
<style>
.top_header_wrap {
	margin-right: 10px;
}
.thw_operate{
	margin-bottom: 4px;
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
  margin-top: 4px;
}
</style>
<body>
<div uitype="Borderlayout" id="objectMain" is_root="true">
	<div position="left" width="230" collapsable="true" show_expand_icon="true">
		<div class="top_header_wrap">
			<div class="thw_operate" id="BizObjDiv">
				<span uitype="ClickInput" id="searchCondition" on_iconclick="search" icon="search" maxlength="200" editable="true" emptytext="请输入名称、编码进行查询" on_keydown="keyDownQuery"></span>
			</div>
			<div class="thw_operate" id="BizObjDiv">
				<span uitype="button" button_type="blue-button" id="btnAddNew" label="新增" on_click="addBizObj"></span> 
				<span uitype="button" button_type="blue-button" id="btnDelete" label="删除" on_click="deleteBizObjInfoList"></span>
				<span uitype="button" button_type="blue-button" id="BizObjGridUpButton" button_type="blue-button" label="上移" on_click="pageButtonUp" mark="BizObjGrid" disable="true"></span> 
				<span uitype="button" button_type="blue-button" id="BizObjGridDownButton" button_type="blue-button" label="下移" on_click="pageButtonDown" mark="BizObjGrid" disable="true"></span> 
				<div class="editGrid">
				<table uitype="EditableGrid" id="BizObjGrid" primarykey="id" datasource="initBizObjDataItemsource" 	gridwidth="200"  pagination="false"  gridheight="auto" selectrows="single" 
		colrender="columnRenderer" rowclick_callback="selectOneObject">
			<thead>
				<tr>
					<th style="width:20px;"></th>
					<th render="BizObjRender" renderStyle="text-align: left;" >业务对象列表</th>
				</tr>
				</thead>
			</table>
			</div>
			</div>
		</div>
    </div>
    <div position="center" url="">
	</div>
</div>
<script type="text/javascript">
	var domainId = "${param.selectDomainId}";//业务域ID 
	var selectedObjectId = "";//列表选中的行ID 
	var BizObjInfo = {};
	//初始化 
	window.onload = function(){
		var objectMainDiv= $("objectMain");
		comtop.UI.scan();
		if(selectedObjectId){
			setButtonIsDisable("BizObjGrid",true,false);
		}
		else{
			setButtonIsDisable("BizObjGrid",true,true);
		}
		setCenterEditUrl(selectedObjectId,"read");
   	}
	
	//业务对象数据源
	function initBizObjDataItemsource(tableObj,query) {
		if(cui("#searchCondition").getValue()){
			BizObjInfo.keyWords=cui("#searchCondition").getValue();
		}
		else{
			BizObjInfo.keyWords=null;
		}
		dwr.TOPEngine.setAsync(false);
		BizObjInfo.domainId=domainId;
		BizObjInfoAction.queryBizObjInfoList(BizObjInfo,function(data){
		    tableObj.setDatasource(data.list, data.count);
		    if(data.count>0 && !selectedObjectId){//列表存在记录
		    	selectedObjectId = data.list[0].id;
		    	tableObj.selectRowsByPK(selectedObjectId);
		    }
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//设置右侧编辑页面 
	function setCenterEditUrl(objectId,editType){ 
		var url = "BizObjInfoEdit.jsp?BizObjInfoId=" + objectId + "&domainId="+domainId+"&readOnly=";
		if(editType=="read"){
			url = "BizObjInfoEdit.jsp?BizObjInfoId=" + objectId + "&domainId="+domainId+"&readOnly="+"true";
		}
		cui("#objectMain").setContentURL("center",url); 
	}
	
	//业务对象
	function BizObjRender(rd, index, col) {
		if(rd.code){
			return rd.name+"【"+rd.code+"】";
		}
		else{
			return rd.name;
		}
		
	}
	//序号列 
	function rowNoRender(rowData, index, colName){
		return index+1;
	}
	
	//新增按钮事件 
	function addBizObj(){
		setCenterEditUrl("","insert");
	}
	
	//删除按钮事件 
	function deleteBizObjInfoList(){
		var selectIds = cui("#BizObjGrid").getSelectedPrimaryKey();
		var selects = cui("#BizObjGrid").getSelectedRowData();
		var indexs = cui("#BizObjGrid").getSelectedIndex();
		var count=0;
		var selectIndex = parseInt(indexs[0]);
		if(selectIds == null || selectIds.length == 0){
			cui.alert("请选择要删除的业务对象。");
			return;
		}
		dwr.TOPEngine.setAsync(false);
		BizObjInfoAction.checkObjInfoIsUse(selects[0],function(data){
			count=data;
		});
		dwr.TOPEngine.setAsync(true);
		if(count>0){
			cui.alert("该业务对象已被引用,无法删除。");
			return;
		}
		else{
			cui.confirm("确定删除该业务对象吗",{
				onYes:function(){
					dwr.TOPEngine.setAsync(false);
					BizObjInfoAction.deleteBizObjInfoList(selects);
			    	dwr.TOPEngine.setAsync(true);
			    	if(cui("#BizObjGrid").getRowsDataByIndex(0).id){ // 后面一行有值取下一行记录 
						selectedObjectId = cui("#BizObjGrid").getRowsDataByIndex(0)[0].id;
					}else{
						selectedObjectId = "";
					}
					cui("#BizObjGrid").loadData();
					cui.message("删除成功。","success");
					if(selectedObjectId){
						cui("#BizObjGrid").selectRowsByPK(selectedObjectId);
						oneClick("BizObjGrid");
					}
					else{
						setButtonIsDisable("BizObjGrid",true,true);
					}
					setCenterEditUrl(selectedObjectId,"read");
				}
			});
		}
	}
	
	
	//单击行事件 
	function selectOneObject(rowData,isChecked,index){
		if(rowData.entityId){
			isEntity = true;
		}
		cui("#BizObjGrid").selectRowsByPK(rowData.id);
		oneClick('BizObjGrid');
		setCenterEditUrl(rowData.id,"read");
	}
	
	
	//按钮单选
	function oneClick(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var gridData = cui("#" + gridId).getData();
		if(indexs.length == 0){ //全不选-不能上移
			setButtonIsDisable(gridId,true,true);
		}else{
			if(indexs[0] == 0 && indexs[indexs.length-1] != gridData.length-1){ //包含了第一条记录只能下移
				setButtonIsDisable(gridId,true,false);
			}else if(indexs[indexs.length-1] == gridData.length-1 && indexs[0] != 0 ){ //包含了最后一条记录只能上移
				setButtonIsDisable(gridId,false,true);
			}else if(indexs[0] == 0  && indexs[indexs.length-1] == gridData.length-1 ){//不能上移下移
				setButtonIsDisable(gridId,true,true);
			}else{ //可上移下移
			   setButtonIsDisable(gridId,false,false);
			}			
		}
	}
	
	//设置grid的置灰显示
	function setButtonIsDisable(gridId,up,down){
		cui("#" + gridId + "UpButton").disable(up);
		cui("#" + gridId + "DownButton").disable(down);
	}
	
	//editgrid上移下移，置顶，置底js
	function pageButtonUp(event, self, mark){
		upObjInfo();
		oneClick(mark);
	}
	
	function pageButtonDown(event, self, mark){
		downObjInfo();
		oneClick(mark);
	}
	
// 	//修改排序,1:升级、-1：降级
// 	function updateSortNo(type){
// 		var selectBizObjInfo=cui("#BizObjGrid").getSelectedRowData();
// 		var updataBizObjInfo;
// 		if(type==1){
// 			updataIndex=
// 		}
// 		var id=selectBizObjInfo[0].id;
// 		if(selectBizObjInfo != null || selectBizObjInfo.length ==1){
// 			dwr.TOPEngine.setAsync(false);
// 			BizObjInfoAction.updateSortNo(selectBizObjInfo[0],type, function(result) {					
//             });
// 	    	dwr.TOPEngine.setAsync(true);
// 		}
// 		cui("#BizObjGrid").loadData();
// 		cui("#BizObjGrid").selectRowsByPK(id, true);
// 	}

	function upObjInfo(){
		var selectBizObjInfo=cui("#BizObjGrid").getSelectedRowData()[0];
		var id=selectBizObjInfo.id;
		var selectIndex=cui("#BizObjGrid").getSelectedIndex()[0];
		var preBizObjInfo=cui("#BizObjGrid").getRowsDataByIndex(selectIndex-1)[0];
		var curSortNo=selectBizObjInfo.sortNo;
		var preSortNo=preBizObjInfo.sortNo;
		if(preSortNo==curSortNo){
			curSortNo+=1;
		}
		selectBizObjInfo.sortNo=preSortNo;
		preBizObjInfo.sortNo=curSortNo;
		dwr.TOPEngine.setAsync(false);
		BizObjInfoAction.updateSortNo(selectBizObjInfo);
		BizObjInfoAction.updateSortNo(preBizObjInfo);
		dwr.TOPEngine.setAsync(true);
		cui("#BizObjGrid").loadData();
		cui("#BizObjGrid").selectRowsByPK(id, true);
	}
	
	function downObjInfo(){
		var selectBizObjInfo=cui("#BizObjGrid").getSelectedRowData()[0];
		var id=selectBizObjInfo.id;
		var selectIndex=cui("#BizObjGrid").getSelectedIndex()[0];
		var nextBizObjInfo=cui("#BizObjGrid").getRowsDataByIndex(selectIndex+1)[0];
		var curSortNo=selectBizObjInfo.sortNo;
		var nextSortNo=nextBizObjInfo.sortNo;
		if(nextSortNo==curSortNo){
			nextSortNo+=1;
		}
		selectBizObjInfo.sortNo=nextSortNo;
		nextBizObjInfo.sortNo=curSortNo;
		dwr.TOPEngine.setAsync(false);
		BizObjInfoAction.updateSortNo(selectBizObjInfo);
		BizObjInfoAction.updateSortNo(nextBizObjInfo);
		dwr.TOPEngine.setAsync(true);
		cui("#BizObjGrid").loadData();
		cui("#BizObjGrid").selectRowsByPK(id, true);
	}
	
	//编辑保存后刷新grid
	function loadGrid(objectId){
		selectedObjectId = objectId;
		cui("#BizObjGrid").loadData();
		cui("#BizObjGrid").selectRowsByPK(selectedObjectId);
	}
	
	//右侧点击编辑按钮，重新加载主要是为了方法的方法签名可编辑 
	function editLoad(selectedObjectId){
		setCenterEditUrl(selectedObjectId,"edit");
	}
	
	//右侧点击编辑按钮，重新加载主要是为了方法的方法签名不可编辑  
	function saveLoad(selectedObjectId){
		setCenterEditUrl(selectedObjectId,"read");
	}
	
	function search(){
		cui("#BizObjGrid").loadData();
	}
	
	//键盘回车键快速查询 
	function keyDownQuery() {
		if ( event.keyCode ==13) {
			search();
		}
	}
</script>
	<top:script src="/cap/bm/biz/info/js/BizObjInfo.js"/>
</body>
</html>