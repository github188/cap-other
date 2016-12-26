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
	<title>发布包变量选择</title>
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
	<top:script src='/cap/dwr/interface/PkgVariabeAction.js'></top:script>
	
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
			<span id="selectButton" uitype="button" label="选择" on_click="selectVar"></span>
			<span uitype="button" label="删除" on_click="deleteVar"></span>
			<span uitype="button" label="关闭" on_click="cancel"></span>
		</div>
	</div>
	<table id="pkgVariableGrid" uitype="Grid" primarykey="id" datasource="initData"
	 resizewidth="resizewidth" resizeHeight="resizeheight">
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
var publishPackageId =  "${param.publishPackageId}";
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
	var entityId = 'com.comtop.cap.bm.cdp.entity.PkgVariabe';
	var entityMethodName = 'queryVOListByPage';
	var paramArray = [];
	var param = {publishPkgId: publishPackageId, pageNo: query.pageNo, pageSize: query.pageSize};
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

function cancel(){
	 parent.closePkgVarDialog();
}

function selectVar(){
	var url = "<%=request.getContextPath() %>/cap/bm/cdp/ConfigRepoVariableSelect.jsp?configRepoId=" + configRepoId;
	repoVariableDialog = cui.dialog({
		title : "变量选择",
		src : url,
		width : 600,
		height : 500
	})
	repoVariableDialog.show(url);
}

function closeVarDialog(){
	repoVariableDialog.hide();
}

function selectKeyCallback(selectData){
	if(!validateData(selectData.key)){
		return;
	}
	var pkgVariable = {
		publishPkgId : publishPackageId,
		key : selectData.key,
		creator : globalUserId,
		createTime : new Date(),
		description : selectData.description
	};
	dwr.TOPEngine.setAsync(false);	    
	PkgVariabeAction.insertVO(pkgVariable, function(_result){
		cui("#pkgVariableGrid").loadData();
    });
    dwr.TOPEngine.setAsync(true);
}


function validateData(selectKey){
	var tmpArr = [];
	var datas = cui("#pkgVariableGrid").getData();
	if(datas){
		for (var i = 0; i < datas.length; i++) {
			var key = datas[i].key;
			if(key == selectKey){
				return false;
			}
		}
	}
	return true;
}

function deleteVar(){
	var selectDatas = cui("#pkgVariableGrid").getSelectedRowData();
	if(selectDatas && selectDatas.length > 0){
		dwr.TOPEngine.setAsync(false);	    
		PkgVariabeAction.deleteList(selectDatas, function(_result){
			if(_result){
				cui.message('删除成功。', 'success');
			}else{
				cui.message('删除失败。', 'fail');
			}
			cui("#pkgVariableGrid").loadData();
	    });
	    dwr.TOPEngine.setAsync(true);
	}else{
		cui.alert('请选择需删除的数据。');
	}
}
function resizewidth(){
	return (document.documentElement.clientWidth || document.body.clientWidth) - 10;
}

function resizeheight(){
	return (document.documentElement.clientHeight || document.body.clientHeight) - 45;
}

</script>	
</body>
</html>