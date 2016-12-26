<%
  /**********************************************************************
	* 构建
	* 2016-07-20杜祺  新建 
  **********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>

<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>起始版本选择</title>
	<top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
	<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
	<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
	<top:script src='/cap/rt/common/globalVars.js'></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/BuildAction.js'></top:script>
	<top:script src='/cap/bm/cdp/build/js/buildCommon.js'></top:script>
	<top:script src='/cap/dwr/interface/RepoVariabeAction.js'></top:script>
	
	<style>
		body{margin:0;padding-left:5px; padding-right:5px;}
		.header-button{
			height:30px;
			width:100%;
			padding: 5px 0 5px 0;
		}
		.div-title {
		    font-family: "Microsoft Yahei";
		    font-weight: bold;
		    font-size: 16px;
		    color: #000;
		}
		.form_table{
			width:100%;
		}
		.required{
		    color: red;
		}
	</style>
<body>
	<div class="header-button">
		<div style="float:right">
			<span id="insertButton" uitype="button" label="新增行" mark="0" on_click="add"></span>
			<span uitype="button" label="删除行" on_click="deleteSelectedRow"></span>
			<span id="saveButton" uitype="button" label="保存" on_click="saveData"></span>
			<span id="confirmButton" uitype="button" label="确定" on_click="confirm"></span>
			<span uitype="button" label="取消" on_click="cancel"></span>
		</div>
	</div>
	<table id="repoVariableGrid" uitype="EditableGrid" primarykey="id" datasource="initData" editafter="editafter"
		selectrows="single" edittype="edittype" submitdata="save" resizewidth="resizewidth" resizeHeight="resizeheight">
	 	 <thead>
		 	<tr>
		 		<th width="4%"></th>
				<th bindName="key" renderStyle="text-align: left;"  width="30%">键</th>
				<th bindName="description" renderStyle="text-align: center;" width="70%">描述</th>
			</tr>
		 </thead>
	</table>
<script type="text/javascript">
var configRepoId =  "${param.configRepoId}";
var data=[];
var edittype = {
	key : {
    	uitype: "Input"
	},
	description : {
    	uitype: "Input"
	}
};
comtop.UI.scan();
function initData(gridObj, query){
	var entityId = 'com.comtop.cap.bm.cdp.entity.RepoVariabe';
	var entityMethodName = 'queryVOListByPage';
	var paramArray = [];
	var param = {configRepoId: configRepoId, pageNo: query.pageNo, pageSize: query.pageSize};
	paramArray.push(param);
	dwr.TOPEngine.setAsync(false);	    
	BuildAction.dwrInvoke(getDwrParam(entityId, entityMethodName, paramArray), function(_result){
		if(_result && _result.list){
			data = _result.list;
			gridObj.setDatasource(_result.list, _result.count);
		}else{
			gridObj.setDatasource([], 0);
		}
    });
    dwr.TOPEngine.setAsync(true);
}

function confirm(){
    var selectRows = cui("#repoVariableGrid").getSelectedRowData();
    if(selectRows && selectRows.length > 0){
    	var selectRow = selectRows[0];
    	parent.selectKeyCallback(selectRow);
    	parent.closeVarDialog();
    }else{
    	cui.alert("必须选择一条记录。");
    }
}

function cancel(){
	 parent.closeVarDialog();
}

function editafter(){
	cui("#confirmButton").disable(true);
}
function add(a,b,mark){
	cui("#confirmButton").disable(true);
	cui("#repoVariableGrid").insertRow({configRepoId:configRepoId, creator:globalUserId, createTime:new Date()}, mark ? mark - 0 : undefined);
}
/**
 * 删除选择行
 */
function deleteSelectedRow() {
	cui("#repoVariableGrid").deleteSelectRow();
	if(cui("#repoVariableGrid").getData().length > 0){
		cui("#repoVariableGrid").selectRowsByIndex(0);
	}
	var changeData = cui("#repoVariableGrid").getChangeData();
	if((!changeData.insertData || changeData.insertData.length <= 0) 
			&& (!changeData.updateData || changeData.updateData.length <= 0)){
		cui("#confirmButton").disable(false);
	}
}

/**
 * 保存数据（例子均以本地存储模拟，正式开发后，可以根据项目不同进行修改）
 * @param obj {Object} Grid组件对象
 * @param changeData {Array} 变更数据集
 */
function saveData() {
  	var validate = validateData();
    if(!validate){
    	return;
    }
	cui("#repoVariableGrid").submit();
}
 
//保存数据
function save(obj, changeData) {
    var insertData = changeData.insertData,
        deleteData = changeData.deleteData,
        updateData = changeData.updateData;
    //删除数据
    if (deleteData && deleteData.length > 0) {
    	dwr.TOPEngine.setAsync(false);	    
    	RepoVariabeAction.deleteList(deleteData);
        dwr.TOPEngine.setAsync(true);
    }
    //更新数据
    if (updateData && updateData.length > 0) {
    	dwr.TOPEngine.setAsync(false);	    
    	RepoVariabeAction.update(updateData);
        dwr.TOPEngine.setAsync(true);
    }
    //插入数据
    if (insertData && insertData.length > 0) {
    	dwr.TOPEngine.setAsync(false);	    
    	RepoVariabeAction.insert(insertData);
        dwr.TOPEngine.setAsync(true);
    }
    cui("#confirmButton").disable(false);
    setTimeout(function () {
        obj.submitComplete();
    }, 500)
}
function validateData(){
	var tmpArr = [];
	var datas = cui("#repoVariableGrid").getData();
	
	if(datas){
		for (var i = 0; i < datas.length; i++) {
			var key = datas[i].key;
			if(key == ''){
				cui.alert('键不能重复，且不能为空。');
				return false;
			}
			if(tmpArr[key] != undefined){
				cui.alert('键不能重复，且不能为空。');
				return false;
			}else{
				tmpArr[key] = 1;
			}
		}
	}
	return true;
}

function resizewidth(){
	return (document.documentElement.clientWidth || document.body.clientWidth) - 10;
}

function resizeheight(){
	return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
}
if(cui("#repoVariableGrid").getData().length > 0){
	cui("#repoVariableGrid").selectRowsByIndex(0);
}
</script>	
</body>
</html>