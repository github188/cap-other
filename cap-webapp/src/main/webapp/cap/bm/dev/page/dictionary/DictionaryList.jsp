<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/cap/bm/common/Taglibs.jsp" %>
<html>
<head>
<title>配置项列表</title>
    <link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="${pageScope.cuiWebRoot}/top/component/topui/cui/themes/default/css/comtop.ui.min.css" type="text/css">
	<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/component/topui/cui/js/comtop.ui.min.js'></script>
	<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/comtop.ui.emDialog.js"></script>
<style type="text/css">
.validImg {
	cursor: pointer;
    background: url(../designer/images/valid.png)  no-repeat;
    width:16px;
    height: 16px;
    text-align:center;
    margin:auto;
	_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='../designer/images/valid.png'); /* IE6 */
	_ background-image: none; /* IE6 */
}

.download {
	cursor: pointer;
    background: url(../designer/images/down.png)  no-repeat;
    width:16px;
    height: 16px;
    text-align:center;
    margin:auto;
	_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='../designer/images/down.png'); /* IE6 */
	_ background-image: none; /* IE6 */
}

.invalidImg {
	 cursor: pointer;
	 background: url(../designer/images/invalid.png)  no-repeat;
	 width:16px;
     height:16px;
     text-align:center;
     margin:auto;
	_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='../designer/images/invalid.png'); /* IE6 */
	_ background-image: none; /* IE6 */
}

th{
    font-weight: bold;
    font-size:14px;
}
</style>
</head>
<body>
<div class="list_header_wrap">
	<div class="top_float_left" >
		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="输入配置项名称、全编码查询" editable="true" width="220" on_iconclick="iconclick"
			        		icon="search" iconwidth="18px"></span>
	</div>
	<div class="top_float_right"  style="padding-right: 5px;padding-bottom: 10px">
		<span uitype="button" id="clear" label="清空" on_click="clearData"></span>
		<span uitype="button" id="selected" label="确定" on_click="selectOne"></span>
		<span uitype="button" id="add" label="新增" on_click="editConfigItem"></span>
<!-- 		<span uitype="button" id="delete" label="取消" on_click="cancelSelect"></span> -->
		<span uitype="button" id="delete" label="删除" on_click="deleteConfigItem"></span>
	</div>
</div>
	<table uitype="grid" id="tableList" primarykey="configItemId" datasource="initData" selectrows="single" pagesize_list="[10,20,30]"   resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRender" >
	    <thead>	
 	       <tr>
			<th style="width:30px">&nbsp;</th>
			<th bindName="configItemName" width="20%" renderStyle="text-align: left;" sort="true">名称</th>
			<th bindName="configItemFullCode" width="30%" renderStyle="text-align: center;" sort="true">全编码</th>
			<th bindName="configItemType" width="15%" renderStyle="text-align: center;" sort="true">类型</th>
			<th bindName="configItemValue" width="20%" renderStyle="text-align: center;" sort="true">数据值</th>
			<th bindName="isValid" width="15%" renderStyle="text-align: center;" sort="true">是否生效</th>
			</tr>
	</thead>
	</table> 
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/engine.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/util.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/ConfigClassifyAction.js'></script>
<script type="text/javascript" src='${pageScope.cuiWebRoot}/top/cfg/dwr/interface/ConfigItemAction.js'></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/jquery.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/js/top_common.js"></script>
<script type="text/javascript" src="${pageScope.cuiWebRoot}/top/sys/js/commonUtil.js"></script>
<script type="text/javascript">
var nodeId = "<c:out value='${param.classifyId}'/>",
totalCount = 0,
queryCondition = {},
importDialog = null;
var keyword="";//查询关键字
var sysModule = "<c:out value='${param.sysModule}'/>";//标识当前节点是系统模块还是统一分类
var classifyCode ="<c:out value='${param.classifyCode}'/>";//标识当前节点的code
var dialog;
var requestModule="<c:out value='${param.requestModule}'/>";
var dictionaryCode="<c:out value='${param.dictionaryCode}'/>";
if (!nodeId || nodeId == "null") {
	nodeId = "0";
}
window.onload = function(){
	if("module"==requestModule){		
		cui("#clear").hide();
		cui("#selected").hide();
		cui("#delete").hide();
	}
	comtop.UI.scan();
}

function initData(tableObj, sQuery) {
	//此处指定是否是系统模块是为了坑爹的设计，分类树信息存在两张表里面，无法判断关联的表信息
    var query = {configClassifyId:nodeId,sysModule:sysModule,pageNo:sQuery.pageNo,pageSize:sQuery.pageSize,sortFieldName:sQuery.sortName[0],sortType:sQuery.sortType[0],fastQueryValue:$.trim(keyword)};
	ConfigItemAction.queryConfigItemList(query, function(data) {
	    totalCount = data.count;
	    tableObj.setDatasource(data.list, data.count);
	    if(dictionaryCode!=null && dictionaryCode!="" && typeof(dictionaryCode)!= "undefined"){
		    for(var i=0; i<data.count; i++){
		    	var dicData = data.list[i];
		    	if(dictionaryCode==dicData.configItemFullCode){
		    		tableObj.selectRowsByPK(dicData.configItemId,true);
		    	}
		    }
	    }
	});
}

function resizeWidth() {
	return (document.documentElement.clientWidth || document.body.clientWidth) - 25;
}

function resizeHeight() {
	return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
}

//搜索框图片点击事件
function iconclick() {
	keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_","gm"), "/_");
	keyword = keyword.replace(new RegExp("'","gm"), "''");
   cui("#tableList").setQuery({pageNo:1});
   //刷新列表
	cui("#tableList").loadData();
}

//列渲染
function columnRender(data, field) {
	if (field == 'configItemName') {
	    return "<a onclick='javascript:editConfigItem(\"" + data["configItemId"] + "\",\"" + data["configItemType"] + "\");'><font style='color:#096DD1;'>" + data["configItemName"] + "</font></a>";
	}
	if (field == 'isValid') {
	    if (data.isValid == "1") {
	        return "<div id='" + data.configItemId + "'  class='validImg' onclick='checkInOrOut(\"" + data["configItemId"] + "\")'></div>";
	    } else {
	        return "<div  id='" + data.configItemId + "' class='invalidImg' onclick='checkInOrOut(\"" + data["configItemId"] + "\")'></div>";
	    }
	}
	if (field == "configItemType") {
	    var str = "";
	    switch (data.configItemType) {
	    case "0":
	        str = "字符串";
	        break;
	    case "1":
	        str = "整型";
	        break;
	    case "2":
	        str = "浮点型";
	        break;
	    case "3":
	        str = "日期型";
	        break;
	    case "4":
	        str = "布尔型";
	        break;
	    case "5":
	        str = "集合";
	        break;
	    default:
	        ;
	    }
	    return str;
	}
}
//刷新列表
function refreshList() {
	keyword = '';
	cui('#myClickInput').setValue();
	cui("#tableList").loadData();
}

/*
*更改配置项状态
*/

function checkInOrOut(id) {
	var imgObject = $("#" + id);
	if (imgObject.attr("class").indexOf('invalidImg') != -1) {
	    cui.confirm("确定要将配置项的状态改为有效吗？", {
	        onYes: function () {
	            ConfigItemAction.updateConfigItemValidity(id, true, function (result) {
	                if (result == "success") {
	                    cui.message("状态有效修改成功", 'success');
	                    imgObject.attr("class", "validImg");
	                }
	            });
	        }
	    });
	} else {
	    cui.confirm("确定要将配置项的状态改为无效吗？", {
	        onYes: function () {
	            ConfigItemAction.updateConfigItemValidity(id, false, function (result) {
	                if (result == "success") {
	                    cui.message("状态无效修改成功", 'success');
	                    imgObject.attr("class","invalidImg");	
	                }
	            });
	
	        }
	    });
	
	} 
}

/**
*删除配置项
*/

function deleteConfigItem() {
	var selectData = cui("#tableList").getSelectedPrimaryKey();
	if (selectData.length == 0) {
	    cui.alert("请选择要删除的配置项。");
	} else {
	    var msg = "删除数据可能会导致其他功能无法使用，确定要删除选中的配置项吗？";
	    cui.confirm(msg, {
	        onYes: function () {
	            dwr.TOPEngine.setAsync(false);
                ConfigItemAction.deleteConfigItem(selectData, function(result) {
                    var cuiTable = cui("#tableList");
                    cuiTable.removeData(cuiTable.getSelectedIndex());
                    cui.message("配置项删除成功", "success");
                    window.refreshList();
                });
	            dwr.TOPEngine.setAsync(true);
	        }
	    });
	}
}

//编辑配置项
function editConfigItem(configItemId, type) {
	var url = "";
	if (typeof configItemId == "string") {
	    url = "EditDictionary.jsp?classifyId=" + nodeId + "&configItemId=" + configItemId;
	} else{
		url = "AddDictionary.jsp?classifyId=" + nodeId + "&sysModule=" + sysModule;
	}
	if (typeof type == "string") {
	    url += "&dataType=" + type;
	}
	cui.extend.emDialog({
		id: 'ConfigItemListDialog',
		title : '配置项编辑',
		src : webPath + "/cap/bm/dev/page/dictionary/"+url,
		width : 750,
		height : 420
    }).show(webPath + "/cap/bm/dev/page/dictionary/"+url);
}

//确认选择
function selectOne(){
	var selectData = cui("#tableList").getSelectedRowData();
	console.log(cui("#tableList").getData());
	if(selectData == null || selectData.length == 0){
		cui.alert("请选择数字字典。");
		return;
	}
	window.parent.selectOne(selectData[0]);
}

//取消选择
// function cancelSelect(){
// 	window.parent.clearData;
// }
//清空选择
function clearData(){
	window.parent.clearData();
}
</script>
</body>
</html>
