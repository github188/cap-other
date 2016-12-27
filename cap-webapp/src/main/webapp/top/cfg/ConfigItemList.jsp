<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<html>
<head>
<title>�������б�</title>
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
 		 <span uiType="ClickInput" id="myClickInput" name="clickInput" enterable="true" emptytext="���������������ơ�ȫ�����ѯ" editable="true" width="300" on_iconclick="iconclick" 
 			        		icon="search" iconwidth="18px"></span> 
 		 &nbsp;&nbsp;&nbsp;&nbsp;���ͣ�
		 <span uiType="PullDown" mode="Single" id="configItemQueryType" datasource="configItemDataSource" select="0"  label_field="text" value_field="id"  width="80"  on_change="changeConfigItemType"></span>
	</div>
	<div class="top_float_right"  style="padding-right: 5px;padding-bottom: 10px">
		 <div uitype="checkboxGroup" id="showAllConfig" name="showAllConfig" on_change="showAllConfigItem">
		 		<input type="checkbox" name="showAll" id="showAllCheckBox"  value="1"> ��ʾ���������� 
		 </div>
		<span uitype="button" id="add" label="����" on_click="editConfigItem"></span>
		<span uitype="button" id="delete" label="ɾ��" on_click="deleteConfigItem"></span>
		<span uitype="button" id="batchExport" label="����SQL" on_click="batchExportConfig"></span>
	</div>
</div>
	<table uitype="grid" id="tableList" primarykey="configItemId" datasource="initData" pagesize_list="[10,20,30]"   resizewidth="resizeWidth" resizeheight="resizeHeight" colrender="columnRender" >
			<th style="width:40px"><input type="checkbox"></th>
			<th bindName="configItemName" renderStyle="text-align: left;" sort="true">����</th>
			<th bindName="configItemFullCode" renderStyle="text-align: center;" sort="true">ȫ����</th>
			<th bindName="configItemType" renderStyle="text-align: center;" sort="true">����</th>
			<th bindName="configItemValue" renderStyle="text-align: center;" sort="true">����ֵ</th>
			<th bindName="path" renderStyle="text-align: center;" sort="true">��������</th>
			<th bindName="isValid" renderStyle="text-align: center;" sort="true">�Ƿ���Ч</th>
			<th bindName="exportConfig" renderStyle="text-align: center;" sort="false">�����ű�</th>
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
var keyword="";//��ѯ�ؼ���
var sysModule = "<c:out value='${param.sysModule}'/>";//��ʶ��ǰ�ڵ���ϵͳģ�黹��ͳһ����
var classifyCode ="<c:out value='${param.classifyCode}'/>";//��ʶ��ǰ�ڵ��code
var dialog;
var isShowAllConfig = "";
//���������ͣ��ֱ�Ϊȫ���������͡���������
var configItemDataSource = [
                 {id:'0',text:'ȫ��'},
                 {id:'1',text:'������'},
                 {id:'5',text:'��������'}
           ];
if (!nodeId || nodeId == "null") {
	nodeId = "0";
}
window.onload = function(){
	comtop.UI.scan();
	//��isShowAllConfigֵΪ�յ�ʱ�򣬴ӻ�����ȡ��
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
	//�˴�ָ���Ƿ���ϵͳģ����Ϊ�˿ӵ�����ƣ���������Ϣ�������ű����棬�޷��жϹ����ı���Ϣ
    var query = {configClassifyId:nodeId,sysModule:sysModule,pageNo:sQuery.pageNo,pageSize:sQuery.pageSize,sortFieldName:sQuery.sortName[0],sortType:sQuery.sortType[0],fastQueryValue:$.trim(keyword),configItemQueryType:configItemQueryType,configClassifyCode:classifyCode,showAllConfig:isShowAllConfig};
	ConfigItemAction.queryConfigItemList(query, function(data) {
	    totalCount = data.count;
	    tableObj.setDatasource(data.list, data.count);
	});
	dwr.TOPEngine.setAsync(true);
}


//ѡ�� "��ʾ����������" �¼�
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

//дcookies 
function setCookie(name,value) { 
    var Days = 30; 
    var exp = new Date(); 
    exp.setTime(exp.getTime() + Days*24*60*60*1000); 
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString(); 
} 

//��ȡcookies 
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
//�л�����������
function changeConfigItemType(){
	cui('#tableList').loadData();
}
//������ͼƬ����¼�
function iconclick() {
	keyword = cui("#myClickInput").getValue().replace(new RegExp("/", "gm"), "//");
	keyword = keyword.replace(new RegExp("%", "gm"), "/%");
	keyword = keyword.replace(new RegExp("_","gm"), "/_");
	keyword = keyword.replace(new RegExp("'","gm"), "''");
   cui("#tableList").setQuery({pageNo:1});
   //ˢ���б�
	cui("#tableList").loadData();
}

//����Ⱦ
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
	        str = "�ַ���";
	        break;
	    case "1":
	        str = "����";
	        break;
	    case "2":
	        str = "������";
	        break;
	    case "3":
	        str = "������";
	        break;
	    case "4":
	        str = "������";
	        break;
	    case "5":
	        str = "����";
	        break;
	    default:
	        ;
	    }
	    return str;
	}
}
//����������ű�
function exportConfig(fullcode){
	var url = "${pageScope.cuiWebRoot}/top/cfg/exportConfig.ac?fullcode="+fullcode;
	location.href = url;
}
// ��������������Ϣ ,��Сǿ<����>��2015-09-30
function batchExportConfig(){
	var selectData = cui("#tableList").getSelectedRowData();
	debugger;
	if (selectData.length == 0) {
	    cui.alert("��ѡ��Ҫ�����������");
	} else {
		var fullCodes ="";
		for(var i=0;i<selectData.length;i++){
			fullCodes+=(selectData[i].configItemFullCode+";");
		}
	    var url = "${pageScope.cuiWebRoot}/top/cfg/exportConfig.ac?fullcode="+fullCodes.substring(0,fullCodes.length-1);
	   location.href = url;
	}	
}
//ˢ���б�
function refreshList() {
	keyword = '';
	cui('#myClickInput').setValue();
	cui("#tableList").loadData();
}

/*
*����������״̬
*/

function checkInOrOut(id) {
	var imgObject = $("#" + id);
	if (imgObject.attr("class").indexOf('invalidImg') != -1) {
	    cui.confirm("ȷ��Ҫ���������״̬��Ϊ��Ч��", {
	        onYes: function () {
	            ConfigItemAction.updateConfigItemValidity(id, true, function (result) {
	                if (result == "success") {
	                    cui.message("״̬��Ч�޸ĳɹ�", 'success');
	                    imgObject.attr("class", "validImg");
	                }
	            });
	        }
	    });
	} else {
	    cui.confirm("ȷ��Ҫ���������״̬��Ϊ��Ч��", {
	        onYes: function () {
	            ConfigItemAction.updateConfigItemValidity(id, false, function (result) {
	                if (result == "success") {
	                    cui.message("״̬��Ч�޸ĳɹ�", 'success');
	                    imgObject.attr("class","invalidImg");	
	                }
	            });
	
	        }
	    });
	
	} 
}

/**
*ɾ��������
*/

function deleteConfigItem() {
	var selectData = cui("#tableList").getSelectedPrimaryKey();
	if (selectData.length == 0) {
	    cui.alert("��ѡ��Ҫɾ���������");
	} else {
	    var msg = "ȷ��Ҫɾ��ѡ�е���������";
	    cui.confirm(msg, {
	        onYes: function () {
	            dwr.TOPEngine.setAsync(false);
                ConfigItemAction.deleteConfigItem(selectData, function(result) {
                    var cuiTable = cui("#tableList");
                    cuiTable.removeData(cuiTable.getSelectedIndex());
                    cui.message("������ɾ���ɹ�", "success");
                    window.refreshList();
                });
	            dwr.TOPEngine.setAsync(true);
	        }
	    });
	}
}

//�༭������
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
		title : '������༭',
		src : webPath + "/top/cfg/"+url,
		width : 750,
		height : 420
    }).show(webPath + "/top/cfg/"+url);
}
</script>
</body>
</html>
