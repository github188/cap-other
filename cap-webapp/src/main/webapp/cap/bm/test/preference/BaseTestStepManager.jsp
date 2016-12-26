<%
/**********************************************************************
* 基本测试步骤管理
* 2016-6-28 zhangzunzhi 新建
**********************************************************************/
%>
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>步骤分组配置</title>
<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"></top:link>
<top:link href="/cap/bm/common/base/css/base.css"></top:link>
<top:link href="/cap/bm/common/base/css/comtop.cap.bm.css"></top:link>
<top:link href="/cap/bm/test/css/icons.css"></top:link>

<top:script src="/cap/bm/common/top/js/jquery.js"></top:script>
<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"></top:script>
<top:script src="/cap/bm/common/base/js/comtop.cap.js"></top:script>
<top:script src="/cap/bm/common/cui/js/cui.utils.js"></top:script>
<top:script src="/cap/bm/dev/page/designer/js/lodash.js"></top:script>
<top:script src="/cap/bm/dev/page/uilibrary/js/component.js"></top:script>
<top:script src="/cap/dwr/engine.js"></top:script>
<top:script src="/cap/dwr/util.js"></top:script>
<top:script src="/cap/dwr/interface/StepFacade.js"></top:script>
<top:script src="/cap/dwr/interface/StepGroupsFacade.js"></top:script>

<style>
.top_header_wrap {
	padding-right: 5px;
}
.icon {
        display: inline-block;
        *display: inline;
        *zoom: 1;
        vertical-align: top;
        text-align: center;
        cursor: pointer;
        width: 20px;
        position: relative;
    }
    
    .icon .icon-img {
        width: 20px;
        height: 20px;
        text-align: center;
        background-size: 100% 100% !important;
    }
</style>
</head>
<script type="text/javascript">

window.onload = function(){
	comtop.UI.scan();
	var initStepGroup=[{code:"all",name:"步骤分组"}];
	dwr.TOPEngine.setAsync(false);
	StepGroupsFacade.loadStepGroups(function(data){
		if(data&&data.groups){
		    for(var i=0;i<data.groups.length;i++){
				if(data.groups[i].code!="fixed"&&data.groups[i].code!="dynamic"){
					var objStepGroup ={code:data.groups[i].code,name:data.groups[i].name};
					initStepGroup.push(objStepGroup);
				}
			}
			cui("#stepGroup").setDatasource(initStepGroup);
			cui("#stepGroup").setValue("all");
		}
	});
	dwr.TOPEngine.setAsync(true);
}

//grid列渲染
function codeRenderer(rd, index, col) {
	return "<a href='javascript:;' onclick='updateStep(\"" +rd.modelId+ '","'+rd.modelName+"\");'>" +rd.name + "</a>";
}

//grid数据源
function initData(tableObj,query){
	var stepName = cui("#stepNameFilter").getValue();
	var stepGroup = cui("#stepGroup").getValue();
	if(stepGroup=="all"){
		stepGroup ="";
	}
	dwr.TOPEngine.setAsync(false);
	StepFacade.queryBasicStepByName(stepName,stepGroup,query.pageNo,query.pageSize,function(data){
		tableObj.setDatasource(data.list, data.size);
	});
	dwr.TOPEngine.setAsync(true);
}

function iconRenderer(rd,index,col){
	return "<div class='icon'><div class='icon-img "+rd.icon+"'></div></div>";
}

function stepSourceTypeRenderer(rd,index,col){
	var stepSource = rd.src;
	if(stepSource=="ui-system.txt"||stepSource=="database.txt"||stepSource=="page.txt"||stepSource=="api-element.txt"||stepSource=="element.txt"){
		return "";
	}
	return "<span class='cui-icon' title='删除步骤' style='font-size:12pt;color:rgb(255,68,0);cursor:pointer;' onclick='delOneStep(\""+rd.modelId +"\")'>&#xf00d;</span>";
}

//编辑基本步骤
function updateStep(modelId,modelName){
	window.location.href = "BaseTestStepEdit.jsp?modelId="+modelId;
}

//删除一个基本步骤
function delOneStep(modelId){
	cui.confirm("确认要删除当前测试步骤吗？",{
		onYes:function(){
			var delStepArr = [];
			delStepArr.push(modelId);
			delTestStep(delStepArr);
		}
	});
}

//删除测试步骤
function delStep(){
	var delStepArr = cui("#stepGroupGrid").getSelectedPrimaryKey();
	if(delStepArr.length==0){
		cui.alert("请选择要删除的测试步骤。");
	}else{
		cui.confirm("确认要删除当前测试步骤吗？",{
			onYes:function(){
				delTestStep(delStepArr);
			}
		});
	}
	
}

//删除测试步骤
function delTestStep(delStepArr){
	dwr.TOPEngine.setAsync(false);
	StepFacade.delTestBasicStep(delStepArr,function(data){
		if(data){
			cui.message("删除测试步骤成功。","success");
			searchStepItem();
			//cui("#stepGroupGrid").loadData();
		}else{
			cui.message("删除测试步骤失败。","error");
			searchStepItem();
			//cui("#stepGroupGrid").loadData();
		}
		});
		dwr.TOPEngine.setAsync(true);
}

//改为从数据库读取
/* var initStepGroup=[
                {id:'all',text:'步骤分组'},
				{id:"0",text:"常用步骤"},
	        	{id:"1",text:"输入步骤"},
	        	{id:"2",text:"元素查找"},
	        	{id:"3",text:"元素操作"}
                   ] */
                   
 //分组切换事件
function stepGroupChange(data,oldData){
	searchStepItem();
}

//测试步骤名称搜索
function keyDown(){
	if (event.keyCode ==13) {
		searchStepItem();
	}
}

function searchStepItem(){
	var stepName = cui("#stepNameFilter").getValue();
	var stepGroup = cui("#stepGroup").getValue();
	if(stepGroup=="all"){
		stepGroup ="";
	}
	var pageNo = cui("#stepGroupGrid").getQuery().pageNo;
	var pageSize = cui("#stepGroupGrid").getQuery().pageSize;
	dwr.TOPEngine.setAsync(false);
	StepFacade.queryBasicStepByName(stepName,stepGroup,pageNo,pageSize,function(data){
		cui("#stepGroupGrid").setDatasource(data.list, data.size);
	});
	dwr.TOPEngine.setAsync(true);
}

//grid 宽度
function resizeWidth(){
	return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
}

//grid高度
function resizeHeight(){
	return (document.documentElement.clientHeight || document.body.clientHeight) - 75;
}	

//导入Txt
var dialog;
function importTxt(){
	var url = "TxtImportPage.jsp";
	var title="导入";
	var height = 300; //600
	var width = 650; // 680;
	
	dialog = cui.dialog({
		title : title,
		src : url,
		width : width,
		height : height
	})
	dialog.show(url);
}

//导入成功之后刷新页面
function reloadPage(){
	searchStepItem();
}

//保存
function saveBaseStep(){

}
</script>
<body>
	<div id="pageRoot" class="cap-page">
		<div class="cap-area" style="width: 100%;">
			<table class="cap-table-fullWidth">
				<tr>
					 <td class="cap-td" style="text-align: left;padding:5px">
			        	<span uitype="PullDown" id ="stepGroup" mode="Single" value_field="code" label_field="name" value="all" width="180" datasource="initStepGroup" on_change="stepGroupChange" editable="false"></span>
			            <span uitype="ClickInput" id="stepNameFilter" emptytext="请输入步骤名称或步骤定义" on_iconclick="searchStepItem" on_keydown="keyDown" icon="search" editable="true" width="280"></span>
			        </td>
					<td class="cap-td" style="text-align: right; padding: 5px">
					   <!--  <span uitype="button" id="delStep" label="删除"  on_click="delStep" ></span>  -->
						<span uitype="button" id="importTxt" label="导入TXT"  on_click="importTxt" ></span>
					</td>
				</tr>
			</table>
			<table class="cap-table-fullWidth">
				<tr>
					<td class="cap-td">
						<table uitype="Grid" id="stepGroupGrid" primarykey="modelId" selectrows="no" colhidden="false" datasource="initData" pagination="true"
							resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRenderer" pagesize_list="[18,25,50]" pagesize="25">
							<thead>
								<tr>
								    <!--  <th style="width: 30px" renderStyle="text-align: center;"><input type="checkbox"></th> -->
									<th style="width: 50px" renderStyle="text-align: center;" bindName="1">序号</th>
									<th style="width:25%;" renderStyle="text-align: left" render="codeRenderer" bindName="name">步骤名称</th>
									<th style="width:25%;" renderStyle="text-align: left" bindName="definition">步骤定义</th>
									<th style="width:25%;" renderStyle="text-align: left" bindName="icon">图标名称</th>
									<th style="width:6%;" renderStyle="text-align: center" render="iconRenderer" bindName="icon">图标</th>
									<th style="width:25%;" renderStyle="text-align: center;" bindName="group">分组</th>
									<th style="width:25%;" renderStyle="text-align: center;" bindName="src">来源</th>
								<!-- 	<th style="width: 50px" renderStyle="text-align: center;" bindName="stepSourceType" render="stepSourceTypeRenderer">操作</th>  -->
								</tr>
							</thead>
						</table>
					</td>
				</tr>
				<tr>
					<td class="cap-td"></td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>