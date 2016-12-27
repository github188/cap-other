<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
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
    background: url(images/valid.png)  no-repeat;
    width:16px;
    height: 16px;
    text-align:center;
    margin:auto;
	_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/valid.png'); /* IE6 */
	_ background-image: none; /* IE6 */
}

.download {
	cursor: pointer;
    background: url(images/down.png)  no-repeat;
    width:16px;
    height: 16px;
    text-align:center;
    margin:auto;
	_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/down.png'); /* IE6 */
	_ background-image: none; /* IE6 */
}

.invalidImg {
	 cursor: pointer;
	 background: url(images/invalid.png)  no-repeat;
	 width:16px;
     height:16px;
     text-align:center;
     margin:auto;
	_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='images/invalid.png'); /* IE6 */
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
 		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="请输入配置项名称、全编码查询" editable="true" width="300" on_iconclick="iconclick" 
 			        		icon="search" iconwidth="18px"></span> 
 		 &nbsp;&nbsp;&nbsp;&nbsp;类型：
		 <span uiType="PullDown" mode="Single" id="configItemQueryType" datasource="configItemDataSource" select="0"  label_field="text" value_field="id"  width="80"  on_change="changeConfigItemType"></span>
	</div>
	<div class="top_float_right"  style="padding-right: 5px;padding-bottom: 10px">
		 <div uitype="checkboxGroup" id="showAllConfig" name="showAllConfig" on_change="showAllConfigItem">
		 		<input type="checkbox" name="showAll" id="showAllCheckBox"  value="1"> 显示所有配置项 
		 </div>
		<span uitype="button" id="add" label="新增" on_click="editConfigItem"></span>
		<span uitype="button" id="delete" label="删除" on_click="deleteConfigItem"></span>
		<span uitype="button" id="batchExport" label="导出SQL" on_click="batchExportConfig"></span>
	</div>
</div>
	<table uitype="grid" id="tableList" primarykey="configItemId" datasource="initData" pagesize_list="[10,20,30]"   resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRender" >
			<th style="width:40px"><input type="checkbox"></th>
			<th bindName="configItemName" renderStyle="text-align: left;" sort="true">名称</th>
			<th bindName="configItemFullCode" renderStyle="text-align: center;" sort="true">全编码</th>
			<th bindName="configItemType" renderStyle="text-align: center;" sort="true">类型</th>
			<th bindName="configItemValue" renderStyle="text-align: center;" sort="true">数据值</th>
			<th bindName="path" renderStyle="text-align: center;" sort="true">所属分类</th>
			<th bindName="isValid" renderStyle="text-align: center;" sort="true">是否生效</th>
			<th bindName="exportConfig" renderStyle="text-align: center;" sort="false">导出脚本</th>
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
var isShowAllConfig = "";
//配置项类型，分别为全部、简单类型、集合类型
var configItemDataSource = [
                 {id:'0',text:'全部'},
                 {id:'1',text:'简单类型'},
                 {id:'5',text:'集合类型'}
           ];
if (!nodeId || nodeId == "null") {
	nodeId = "0";
}
window.onload = function(){
	comtop.UI.scan();
	//当isShowAllConfig值为空的时候，从缓存中取出
	if(isShowAllConfig == ""){
		isShowAllConfig = getCookie("isShowAllConfig");
		if(isShowAllConfig == "true"){
			cui('#showAllConfig').selectAll();
		}
	}
}
function initData(tableObj, sQuery) {
	var configItemQueryType = cui('#configItemQueryType').getValue();
	dwr.TOPEngine.setAsync(false);
	//此处指定是否是系统模块是为了坑爹的设计，分类树信息存在两张表里面，无法判断关联的表信息
    var query = {configClassifyId:nodeId,sysModule:sysModule,pageNo:sQuery.pageNo,pageSize:sQuery.pageSize,sortFieldName:sQuery.sortName[0],sortType:sQuery.sortType[0],fastQueryValue:$.trim(keyword),configItemQueryType:configItemQueryType,configClassifyCode:classifyCode,showAllConfig:isShowAllConfig};
	ConfigItemAction.queryConfigItemList(query, function(data) {
	    totalCount = data.count;
	    tableObj.setDatasource(data.list, data.count);
	});
	dwr.TOPEngine.setAsync(true);
}


//选中 "显示所有配置项" 事件
function showAllConfigItem() {
	var values = cui('#showAllConfig').getValue(); 
	if(values &&  values.length == 1 && values[0] == 1){
		isShowAllConfig = "true";
	} else {
		isShowAllConfig = "false";
	}
	setCookie("isShowAllConfig",isShowAllConfig);
	cui("#tableList").loadData();
}

//写cookies 
function setCookie(name,value) { 
    var Days = 30; 
    var exp = new Date(); 
    exp.setTime(exp.getTime() + Days*24*60*60*1000); 
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString(); 
} 

//读取cookies 
function getCookie(name) { 
    var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
    if(arr=document.cookie.match(reg)){
        return unescape(arr[2]); 
    } else{
        return null; 
    } 
} 

function resizeWidth() {
	return (document.documentElement.clientWidth || document.body.clientWidth) - 25;
}

function resizeHeight() {
	return (document.documentElement.clientHeight || document.body.clientHeight) - 70;
}
//切换配置项类型
function changeConfigItemType(){
	cui('#tableList').loadData();
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
	if (field == 'exportConfig') {
	        return "<div id='" + data.configItemFullCode + "'  class='download' onclick='exportConfig(\"" + data["configItemFullCode"] + "\")'></div>";
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
//导出配置项脚本
function exportConfig(fullcode){
	var url = "${pageScope.cuiWebRoot}/top/cfg/exportConfig.ac?fullcode="+fullcode;
	location.href = url;
}
// 批量导出配置信息 ,李小强<新增>，2015-09-30
function batchExportConfig(){
	var selectData = cui("#tableList").getSelectedRowData();
	debugger;
	if (selectData.length == 0) {
	    cui.alert("请选择要导出的配置项。");
	} else {
		var fullCodes ="";
		for(var i=0;i<selectData.length;i++){
			fullCodes+=(selectData[i].configItemFullCode+";");
		}
	    var url = "${pageScope.cuiWebRoot}/top/cfg/exportConfig.ac?fullcode="+fullCodes.substring(0,fullCodes.length-1);
	   location.href = url;
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
	    var msg = "确定要删除选中的配置项吗？";
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
	    url = "EditConfigItem.jsp?classifyId=" + nodeId + "&configItemId=" + configItemId;
	} else{
		url = "AddConfigItem.jsp?classifyId=" + nodeId + "&sysModule=" + sysModule;
	}
	if (typeof type == "string") {
	    url += "&dataType=" + type;
	}
	cui.extend.emDialog({
		id: 'ConfigItemListDialog',
		title : '配置项编辑',
		src : webPath + "/top/cfg/"+url,
		width : 750,
		height : 420
    }).show(webPath + "/top/cfg/"+url);
}
</script>
</body>
</html>
