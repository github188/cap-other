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
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
	<top:link href="/cap/bm/common/styledefine/css/top_base.css" />
	<top:link href="/cap/bm/common/styledefine/css/top_sys.css" />
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<%-- 	<top:link  href="<%=request.getContextPath() %>/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>--%>
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/common/styledefine/editstyle.css"/>
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
	.divTreeBtn {
		margin-right :20px;
		margin-bottom:4px;
	    float:right;
	}

</style>
<body class="top_body" style="overflow: hidden;">
	    	<div id="buttonDiv" class="divTreeBtn">
	    		<span uitype="button" on_click="btnAdd" icon="<%=request.getContextPath() %>/cap/bm/common/cui/themes/smartGrid/images/button/add_white.gif" hide="false" button_type="blue-button" disable="false" label="新增" id="btnAdd"></span> 
				<span uitype="button" on_click="btnDelete" id="btnDelete" icon="<%=request.getContextPath() %>/cap/bm/common/cui/themes/smartGrid/images/button/delete_white.gif" hide="false" button_type="blue-button" disable="false" label="删除"></span>
				<span uitype="button" id="BizFlowGridUpButton" button_type="blue-button" label="上移" on_click="pageButtonUp" mark="BizFlowGrid" disable="true"></span> 
				<span uitype="button" id="BizFlowGridDownButton" button_type="blue-button" label="下移" on_click="pageButtonDown" mark="BizFlowGrid" disable="true"></span> 
				<span uitype="button" id="BizFlowGridTopButton" button_type="blue-button" label="置顶" on_click="pageButtonTop" mark="BizFlowGrid" disable="true"></span>
				<span uitype="button" id="BizFlowGridBottomButton" button_type="blue-button" label="置底" on_click="pageButtonBottom" mark="BizFlowGrid" disable="true"></span> 
	    	</div>
	    	<table uitype="EditableGrid" id="BizFlowGrid" ellipsis="true" sorttype="DESC" sortname="sortNo" colhidden="true" pageno="1" colmaxheight="auto" submitdata="save" rowclick_callback="BizFlowGridOneClick" selectall_callback="BizFlowGridAllClick" gridwidth="820px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initBizFlowData" fixcolumnnumber="0" adaptive="true" resizeheight="resizeHeight" titleellipsis="true" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" selectedrowclass="selected_row" colmove="false" primarykey="id" onstatuschange="onstatuschange" pagination="true" pagesize="50" oddevenrow="false">
			 <thead>
			 	<tr>
					<th style="width:30px"><input type="checkbox"/></th>
					<th id="" bindName="" render="rowNoRender" renderStyle="text-align: center;" style="width:5%;">序号</th>
					<th id="" bindName="processName" sort="true" render="editLinkRender" renderStyle="text-align: left;" style="width:10%;">名称</th>
					<th id="" bindName="code" sort="true" renderStyle="text-align: left;" style="width:10%;">流程编码</th>
					<th id="" bindName="processId" sort="true" renderStyle="text-align: left;" style="width:10%;">流程ID</th>
					<th id="" bindName="processDef" render="typeSysRender" renderStyle="text-align: left;" style="width:20%;">流程定义</th>
					<th id="" bindName="workDemand" renderStyle="text-align: left;" style="width:20%;">工作要求</th>   
					<th id="" bindName="workContext" renderStyle="text-align: left;" style="width:20%;">工作内容</th>
				</tr>
				</thead>
			</table>
<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" /> 
<top:script src="/top/js/jquery.js" />
<top:script src="/cap/bm/common/js/cap.bm.common.js" />
<top:script src="/cap/dwr/engine.js" />
<top:script src="/cap/dwr/util.js" /> 
<top:script src="/cap/dwr/interface/BizProcessInfoAction.js" />
<script type="text/javascript">
	//业务域ID
	var domainId = "${param.domainId}";
	//业务事项ID
	var selItemsId = "${param.selItemsId}";
	//初始化
	window.onload = function(){
		comtop.UI.scan();		
		if(!selItemsId){
			cui("#btnAdd").disable(true);
			cui("#btnDelete").disable(true);
		}
	}
	function initBizFlowData(tableObj,query){
		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		query.itemsId = selItemsId;
		if(selItemsId==null || selItemsId ==""){
			tableObj.setDatasource([], 0);
		}else{
			dwr.TOPEngine.setAsync(false);
				BizProcessInfoAction.queryBizProcessInfoList(query,function(data){
					dataCount = data.count;
				    tableObj.setDatasource(data.list, data.count);
				    maxSortNo = dataCount;
				});
			dwr.TOPEngine.setAsync(true);
		}
		
	}
	
	function rowNoRender(rowData, index, colName){
		return index+1;
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
	}
	
	
	  //列表列渲染——编辑链接渲染
	function editLinkRender(rd, index, col) {	
		if(!rd[col.bindName]){
			return;
		}		
		return "<a href='javascript:;' onclick='edit(\"" +rd.id+"\");'>" + rd[col.bindName] + "</a>";
	}
	  
	function edit(id){
    	var url = "BizProcessInfoEditMain.jsp?BizProcessInfoId="+id+"&domainId="+domainId;
    	if(selItemsId){
    		url += "&selItemsId="+selItemsId;
    	}
		parent.editProcess(url);
    }
	  
	//新增事件
	function btnAdd(){
		var url = "BizProcessInfoEdit.jsp?selItemsId="+selItemsId+"&domainId="+domainId;
		parent.editProcess(url); 		
	}
	
	//Grid组件自适应高度回调函数，返回宽度计算结果即可
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 25;
	}
	
	//删除事件
	function btnDelete(){

		var result = true;
		if (typeof(myBeforeDelete) == "function") {
			result = eval("myBeforeDelete()");
		}
		if(!result && typeof(result) != "undefined"){
			return;
		}

		var selects = cui("#BizFlowGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}	
		var selectKey = cui("#BizFlowGrid").getSelectedPrimaryKey();
		var count = 0;
		var condition = {};
		condition.idList = selectKey;
		dwr.TOPEngine.setAsync(false);
		BizProcessInfoAction.queryProcessNodeCount(condition,function(data){
			count = data;
		});
		dwr.TOPEngine.setAsync(true);
		if(count>0){
			cui.alert("该流程下有节点不能直接删除。");
			return;
		}else{
			cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
				onYes:function(){
					dwr.TOPEngine.setAsync(false);
					BizProcessInfoAction.deleteBizProcessInfoList(cui("#BizFlowGrid").getSelectedRowData(),function(msg){
					 	cui("#BizFlowGrid").loadData();
					 	window.parent.cui.message('删除成功！','success');
					 	});
					dwr.TOPEngine.setAsync(true);
				}
			});
		}
		if (typeof(myAfterDelete) == "function") {
			eval("myAfterDelete()");
		}
	}
	//editgrid上移下移，置顶，置底js
	//按钮区域
	function pageButtonUp(event, self, mark){
		up(mark);
	}
	function pageButtonDown(event, self, mark){
		down(mark);
	}
	function pageButtonTop(event, self, mark){
		myTop(mark);
	}
	function pageButtonBottom(event, self, mark){
		bottom(mark);
	}
	//上移
	function up(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var index = indexs[0];
		if(index == 0){
			return;
		}
		for(var i=0;i<indexs.length;i++){
			var datas = cui("#" + gridId).getData();
			var currentData   = datas[indexs[i]];
			var  frontData = datas[indexs[i]-1];
			
			var temp = currentData.sortNo;
			currentData.sortNo = frontData.sortNo;
			frontData.sortNo = temp;
			
			cui("#" + gridId).changeData(currentData, indexs[i] - 1,true,true);
			cui("#" + gridId).changeData(frontData,indexs[i],true,true);
			cui("#" + gridId).selectRowsByIndex(indexs[i] -1, true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
		}
		var allData= cui("#" + gridId).getData();
		dwr.TOPEngine.setAsync(false);
		BizProcessInfoAction.saveBizProcessInfoList(allData);
		dwr.TOPEngine.setAsync(true);
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	//下移
	function down(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var index = indexs[indexs.length-1];
		var datas = cui("#" + gridId).getData();
		if(index === datas.length - 1){
			return;
		}
		for(var i=indexs.length-1;i>=0;i--){
			var datas = cui("#" + gridId).getData();
			var currentData = datas[indexs[i]];
			var nextData = datas[indexs[i] + 1];
			
			var temp = currentData.sortNo;
			currentData.sortNo = nextData.sortNo;
			nextData.sortNo = temp;
			
			cui("#" + gridId).changeData(currentData, indexs[i] + 1,true,true);
			cui("#" + gridId).changeData(nextData, indexs[i],true,true);
			cui("#" + gridId).selectRowsByIndex(indexs[i], false);
			cui("#" + gridId).selectRowsByIndex(indexs[i] + 1, true);
		}
		var allData= cui("#" + gridId).getData();
		dwr.TOPEngine.setAsync(false);
		BizProcessInfoAction.saveBizProcessInfoList(allData);
		dwr.TOPEngine.setAsync(true);
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	function BizFlowGridOneClick(){
		oneClick('BizFlowGrid');
	}
	function BizFlowGridAllClick(){
		allClick('BizFlowGrid');
	}
	
	//置顶
	function myTop(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var datas = cui("#" + gridId).getData();
		var firstSortNo = datas[0].sortNo;
		var largeIndex = indexs[indexs.length-1];
		for(var i=indexs.length-1;i>=0;i--){
			firstSortNo--;
			var datas = cui("#" + gridId).getData();
			var currentData = datas[largeIndex];
			currentData.sortNo = firstSortNo;
			
			//咨询CUI，没提供move方法，先采用先删后增
			cui("#" + gridId).deleteRowByIndex(largeIndex);
			cui("#" + gridId).insertRow(currentData,0);
			cui("#" + gridId).selectRowsByIndex(0, true);
		}
		var allData= cui("#" + gridId).getData();
		dwr.TOPEngine.setAsync(false);
		BizProcessInfoAction.saveBizProcessInfoList(allData);
		dwr.TOPEngine.setAsync(true);
		//判断按钮是否置灰
		oneClick(gridId);
	}
	
	//置底
	function bottom(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var datas = cui("#" + gridId).getData();
		var lastSortNo = datas[datas.length-1].sortNo;
		var minIndex = indexs[0];
		for(var i=0;i<indexs.length;i++){
			lastSortNo++;
			var datas = cui("#" + gridId).getData();
			var currentData = datas[minIndex];
			currentData.sortNo = lastSortNo;
			
			//咨询CUI，没提供move方法，先采用先删后增
			cui("#" + gridId).deleteRowByIndex(minIndex);
			cui("#" + gridId).insertRow(currentData,datas.length-1);
			cui("#" + gridId).selectRowsByIndex(datas.length-1, true);
		}
		var allData= cui("#" + gridId).getData();
		dwr.TOPEngine.setAsync(false);
		BizProcessInfoAction.saveBizProcessInfoList(allData);
		dwr.TOPEngine.setAsync(true);
		//判断按钮是否置灰
		oneClick(gridId);
	}
	//按钮单选
	function oneClick(gridId){
		var indexs =  cui("#" + gridId).getSelectedIndex();
		var gridData = cui("#" + gridId).getData();
		if(indexs.length == 0){ //全不选-不能上移下移置顶置底
			setButtonIsDisable(gridId,true,true,true,true);
		}else{
			if(isContinue(indexs)){ // 是连续的-可上移下移
				if(indexs[0] == 0 && indexs[indexs.length-1] != gridData.length-1){ //包含了第一条记录只能下移、置底
					setButtonIsDisable(gridId,true,false,true,false);
				}else if(indexs[indexs.length-1] == gridData.length-1 && indexs[0] != 0 ){ //包含了最后一条记录只能上移、置顶
					setButtonIsDisable(gridId,false,true,false,true);
				}else if(indexs[0] == 0  && indexs[indexs.length-1] == gridData.length-1 ){//不能上移下移置顶置底
					setButtonIsDisable(gridId,true,true,true,true);
				}else{ //可上移下移置顶置底
				   setButtonIsDisable(gridId,false,false,false,false);
				}
			}else{ // 不是连续的
				setButtonIsDisable(gridId,true,true,true,true);
			}
		}
	}
	//按钮全选
	function allClick(gridId){
		setButtonIsDisable(gridId,true,true,true,true);
	}
	
	//设置grid的置灰显示
	function setButtonIsDisable(gridId,up,down,top,bottom){
		cui("#" + gridId + "UpButton").disable(up);
		cui("#" + gridId + "DownButton").disable(down);
		cui("#" + gridId + "TopButton").disable(top);
		cui("#" + gridId + "BottomButton").disable(bottom);
	}
	
	//保存
	function beforeSave(){
		cui("#BizFlowGrid").submit();
	}
	
	//保存数据 
	function save(isBack) {
		setButtonIsDisable("BizFlowGrid",true,true,true,true);
		setTimeout(function(){
			cui('#BizFlowGrid').loadData();
		},0);
	}
	
	//判断数组是否是连续数组
	function isContinue(array){
		var len=array.length;
		var n0=array[0];
		var sortDirection=1;//默认升序
		if(array[0]>array[len-1]){
		        //降序
				sortDirection=-1;
		}
		if((n0*1+(len-1)*sortDirection) !== array[len-1]){
		        return false;
		}
		var isContinuation=true;
			for(var i=0;i<len;i++){
		        if(array[i] !== (i+n0*sortDirection)){
		            isContinuation=false;
		            break;
				}
			 }
		return isContinuation;
	}
		
</script>
</body>
</html>