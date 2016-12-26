<!doctype html>
<%
  /**********************************************************************
	* CAP业务基本信息
	* 2015-11-03 姜子豪 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<html>
<head>
<title>基本信息管理</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
		<top:script src="/cap/bm/common/base/js/cap_ui_attachment.js" />
		<top:script src="/cap/bm/common/cui/js/uedit/dialogs/capattachment/capAttachmentDialog.js" />
</head>
<style>
.top_header_wrap{
				margin-right:28px;
				margin-top: 4px;
				margin-bottom:4px;
}
</style>
<body>
		<div class="top_header_wrap">
			<div class="thw_operate">
				<span uitype="button" id="btnEdit" label="编  辑" button_type="blue-button" on_click="editFormfo"></span>
				<span uitype="button" id="btnSave" label="保  存" button_type="blue-button" on_click="saveFormInfo"></span> 
				<span uitype="button" id="btnCancel" label="返 回" button_type="blue-button" on_click="cancel"></span>
			</div>
		</div>
		<div class="top_content_wrap cui_ext_textmode" >
		<table class="form_table" style="table-layout: fixed;">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<td class="divTitle">表单信息</td>
			</tr>
			<tr>
				<td class="td_label"></span>所属业务域：</td>
				<td><span uitype="input" id="belongDomain" name="belongDomain" databind="formInfo.belongDomain" maxlength="50" width="85%" readonly="true" ></span></td>
				<td class="td_label"></span>附件：</td>
       			<td><span uitype="input" id="formChartName"></span>
       				<span uitype="Capattachment" id="formChartId" uploadKey="BIZ_PROCESS_INFO" databind="formInfo.attachmentId"></span></td>
			</tr>
			<tr>
				<td class="td_label">编码：</td>
				<td>
					<span uitype="Input" id="code" width="85%" databind="formInfo.code" type="text" readonly="true"></span>
				</td>
				<td class="td_label">名称<span class="top_required">*</span>：</td>
				<td><span uitype="input" id="name" name="name" databind="formInfo.name" maxlength="200" width="85%" validate="[{'type':'required', 'rule':{'m': '名称不能为空！'}}]"></span></td>
			</tr>
			<tr>
				<td class="td_label" valign="top">备注：</td>
				<td colspan="3"><span uitype="Textarea" id="remark" name="remark" databind="formInfo.remark" maxlength="2000" width="95%" height="130px"></span></td>
			</tr>
		</table>
		<div id="formDataDiv" align="center">
				<div class="top_header_wrap">
					<div class="divTitle">表单数据项</div>
					<div class="thw_operate" id="operateDiv">
						<span uitype="Button" id="addRow" label="新增" button_type="blue-button" icon="plus" on_click="insertFormData"></span>
						<span uitype="Button" id="deleteRow" label="删除" button_type="blue-button" icon="minus" on_click="deleteFormData"></span>
					</div>
				</div>
				<div class="grid">
					<table id="formDataGrid" uitype="EditableGrid" datasource="initData" selectrows="${param.editType == 'read' ? 'no' : 'multi'}" editbefore="formDataeditbefore" edittype="formDataEditType"
					primarykey="id" colhidden="false" pagination="false" resizeheight="resizeHeight" ellipsis="false" resizewidth="resizeWidth" submitdata="saveFormData">
						<thead>
							<tr>
								${param.editType == 'read' ? '' : '<th style="width: 5%"><input type="checkbox" /></th>'}
								<th width="5%" renderStyle="text-align: center" bindName="1">序号</th>
								<th width="20%" align="center" bindName="name">名称<span class="top_required">*</span></th>
								<th width="15%" align="center" bindName="type">类型</th>
								<th width="15%" align="center" bindName="unit">单位</th>
								<th width="10%" renderStyle="text-align: center" align="center" bindName="requried">必填</th>
								<th width="30%" align="center" bindName="description">数据项说明</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
	</div>
	<top:script src="/cap/dwr/interface/BizFormAction.js" />
	<top:script src="/cap/dwr/interface/BizDomainAction.js" />
	<top:script src="/cap/dwr/interface/BizFormDataAction.js" />
	<top:script src="/cap/dwr/interface/FileLoaderAction.js" />
<script type="text/javascript">
    var formInfo={};
    var formVO={};
    var formDataVO={};
    var editType="${param.editType}";
	var selectFromId="${param.selectFromId}";
	var selectDomainId ="${param.selectDomainId}";
	var noNull =[{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}}];
	var formDataName=[{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}},
	                   {'type':'custom','rule':{'against':'checkDataName', 'm':'名称已存在'}}];
	var formDataType=[{'id':'字符','text':'字符'},{'id':'枚举','text':'枚举'},{'id':'数字','text':'数字'},
					  {'id':'日期类型','text':'日期类型'},{'id':'金额','text':'金额'}];//角色层级

	window.onload = function(){
		init();
		if(editType == "insert"){
			pageStausSet("eidt");
		}
		else{
			pageStausSet(editType);
		}
	}
	
	//初始化界面加载
	function init(){
		if(selectFromId){
			dwr.TOPEngine.setAsync(false);
			BizFormAction.queryFormById(selectFromId,function(data){
   				if(data){
   					formInfo=data;
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
		}
		dwr.TOPEngine.setAsync(false);
		BizDomainAction.queryDomainById(selectDomainId,function(data){
				if(data){
					formInfo.belongDomain=data.name;
				}
			});
		dwr.TOPEngine.setAsync(true);
		comtop.UI.scan();
	}
	
	
	//编辑事件 
	function editFormfo(){
		parent.setRightUrl(selectDomainId,selectFromId,"edit");
	}
	
	//取消事件 
	function cancel(){
		parent.setRightUrl(selectDomainId,selectFromId,"read");
	}
	
	//新增表单
	function insertForm(){
		var belongDomain=formInfo.belongDomain;
		cui(formInfo).databind().setEmpty();
		formInfo.id=null;
		cui("#belongDomain").setValue(belongDomain);
		pageStausSet("edit");
	}
	
	//保存表单信息
	function saveFormInfo(){
		var str = "";
		if(window.validater){
			window.validater.notValidReadOnly = true;
			var map = window.validater.validAllElement();
			var inValid = map[0];
			var valid = map[1];
			//验证消息
			if(inValid.length > 0) { //验证失败
				for(var i=0; i<inValid.length; i++) {
					str += inValid[i].message + "<br/>";
				}
			}
			if(str != ""){
				return false;
			}
		}
		formVO=cui(formInfo).databind().getValue();
		formVO.domainId=selectDomainId;
		formVO.dataFrom=0;
		var rel=cui("#formDataGrid").submit();
		if(rel === "fail"){
			return false;
		}
		else{
			dwr.TOPEngine.setAsync(false);
			BizFormAction.saveForm(formVO,function(data){
					if(data) {
						if(formVO.id) {
							window.parent.loadTree(data,false,formVO.name);
						} else {
							window.parent.loadTree(data,true,formVO.name);
						}
						selectFromId=data;
					}else{
						cui.message('保存失败。','error');
					}
			});
			dwr.TOPEngine.setAsync(true);
			var allRoleData=cui("#formDataGrid").getData();
			if(allRoleData){
				for(var i=0;i<allRoleData.length;i++){
					if(!allRoleData[i].formId){
						allRoleData[i].formId=selectFromId;
						allRoleData[i].dataFrom=0;
						allRoleData[i].domainId=selectDomainId;
					}
				}
			}
			saveFormData(allRoleData);
			parent.loadGrid(selectFromId)
			parent.setRightUrl(selectDomainId,selectFromId,"read");
		}
	}
	
	//保存表单数据项
	function saveFormData(data){
		dwr.TOPEngine.setAsync(false);
		BizFormDataAction.saveFormData(data);
		dwr.TOPEngine.setAsync(true);
	}
	
  	//grid数据源
	function initData(tableObj){
		if(selectDomainId){
			formDataVO.formId=selectFromId;
			dwr.TOPEngine.setAsync(false);
			BizFormDataAction.queryFormDataListByFormId(formDataVO,function(data){
		    	tableObj.setDatasource(data.list);
			});
			dwr.TOPEngine.setAsync(true);
		}
		else{
			tableObj.setDatasource(null);
		}
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 50;
	}
	
	//grid 宽度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 380;
	}
	
	//空格过滤
	function isBlank(data){
		if(data.replace(/\s/g, "")==""){
			return false;
		}
		return true;
	}
	
	//需求元素grid插入新行
	function insertFormData() {
		var maxsort = getMaxsort(cui("#formDataGrid").getData())+1;
		cui("#formDataGrid").insertRow({sortNo:maxsort,requried:1});
	}
	
	//删除grid元素行
	function deleteFormData(){
		var selects = cui("#formDataGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}	
		cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
			onYes:function(){
				cui("#formDataGrid").deleteSelectRow();
				var pageChangeData = cui("#formDataGrid").getChangeData();
				var deleteData=pageChangeData.deleteData;
				dwr.TOPEngine.setAsync(false);
				BizFormDataAction.deleteFormData(deleteData);
				dwr.TOPEngine.setAsync(true);
				cui.message('删除成功。','success');
				}
			});
	}
	
	function checkDataName(data){
		var allData=cui("#formDataGrid").getData();
		for(var i=0;i<allData.length;i++){
			for(var j=i+1;j<allData.length;j++){
				if(trim(allData[i].name)==trim(allData[j].name)){
					return false;
				}
			}
		}
		return true;
	}
</script>
<top:script src="/cap/bm/biz/form/js/formInfo.js" />
</body>
</html>