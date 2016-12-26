<!doctype html>
<%
  /**********************************************************************
	* 业务对象基本信息编辑
	* 2015-11-10 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>业务对象基本信息编辑</title> 
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js"/>
		<top:script src="/eic/js/comtop.ui.emDialog.js"/>
		<top:script src="/cap/dwr/engine.js"/>
		<top:script src="/cap/dwr/util.js"/>
		<top:script src="/cap/bm/common/top/js/jquery.js"/>
		<top:script src="/cap/bm/common/js/capCommon.js"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"/>
</head>
<style>
.thw_operate {
	margin-top: 4px;
	margin-right :10px;
	margin-bottom:4px;
	}
	.top_header_wrap{
	margin-top: 4px;
	margin-right :10px;
	margin-bottom:4px;
	}
</style>
<body class="top_body">
	<div class="top_header_wrap">
		<div class="divTitle">业务对象基本信息编辑</div>
			<div class="saveDiv" style="float:right">
			<span uitype="button" on_click="editBizInfoLoad" id="btnEdit"  hide="false" disable="false" button_type="blue-button" label="编辑"></span> 
			<span uitype="button" disable="false" label="保存" on_click="beforeSave" button_type="blue-button" id="btnSave" hide="false" ></span> 
		</div>
	</div>
	<div class="top_content_wrap cui_ext_textmode">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
				<tr>
					<td id="code_label" class="td_label">编码：</td>
					<td id="code_value">
						<span uitype="Input" id="code" maxlength="250" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizObjInfo.code" 
							type="text" readonly="ture"></span>
					</td>
					<td class="td_label">名称<span class="top_required">*</span>：</td>
					<td>
						<span uitype="Input" id="name" maxlength="200" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizObjInfo.name"
						validate="validateBizObjInfoName"	 type="text" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label" valign="top">说明：</td>
					<td colspan="3"><span uitype="Textarea" id="description" width="95%" height="80px" databind="BizObjInfo.description" maxlength="2000"></span></td>
				</tr>
				<tr>
					<td class="grid-td" colspan=4>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="thw_operate" style="float:right">
			<span uitype="button" button_type="blue-button" on_click="insertBizObjDataItemGrid" id="BizObjDataItemGridAdd"  hide="false"  disable="false" label="新增"></span> 
			<span uitype="button" button_type="blue-button" on_click="deleteBizObjDataItemGrid" id="BizObjDataItemGridDelete" hide="false"  disable="false" label="删除"></span> 
			<span uitype="button" button_type="blue-button" id="BizObjDataItemGridUpButton" label="上移" on_click="pageButtonUp" mark="BizObjDataItemGrid" disable="true"></span> 
			<span uitype="button" button_type="blue-button" id="BizObjDataItemGridDownButton"  label="下移" on_click="pageButtonDown" mark="BizObjDataItemGrid" disable="true"></span> 
			<span uitype="button" button_type="blue-button" id="BizObjDataItemGridTopButton"  label="置顶" on_click="pageButtonTop" mark="BizObjDataItemGrid" disable="true"></span> 
			<span uitype="button" button_type="blue-button" id="BizObjDataItemGridBottomButton"  label="置底" on_click="pageButtonBottom" mark="BizObjDataItemGrid" disable="true"></span> 
		</div>
		<div class="editGrid">
			<table uitype="EditableGrid" id="BizObjDataItemGrid" editbefore="editbefore" rowclick_callback="BizObjDataItemGridOneClick" selectall_callback="BizObjDataItemGridAllClick" submitdata="btnSave"  
				 selectrows="${param.readOnly == 'true' ? 'no' : 'multi'}"   colhidden="false" datasource="initGridData" resizeheight="resizeHeight"   resizewidth="resizeWidth"   primarykey="id"  edittype="edittypeForBizObjDataItem"  pagination="false"  >
				<tr>
					${param.readOnly == 'true' ? '' : '<th style="width: 5%"><input type="checkbox" /></th>'}
					<th bindName="name" width="15%"  renderStyle="text-align: left;">名称<span class="top_required">*</span></th>
					<th bindName="code" width="15%" renderStyle="text-align: left;">编码<span class="top_required">*</span></th>
					<th bindName="codeNote" width="30%" renderStyle="text-align: left;">编码引用说明</th>
					<th bindName="remark" width="35%" renderStyle="text-align: left;">备注</th>
				</tr>
			</table>
		</div>
	</div>
	<top:script src="/cap/dwr/interface/BizObjInfoAction.js" />
	<top:script src="/cap/dwr/interface/BizObjDataItemAction.js" />
<script language="javascript"> 
	var BizObjInfoId = "<c:out value='${param.BizObjInfoId}'/>";
	var domainId = "<c:out value='${param.domainId}'/>";
	var readOnly = "${param.readOnly}"
	var BizObjInfo = {};
	
   	window.onload = function(){
   		init();
   		BizObjInfo.domainId=domainId;
   	}
   		
   	//grid数据源	
	function initGridData(tableObj,query){
		if (typeof(beforeinitGridData) == "function") {
			eval("beforeinitGridData(tableObj,query)");
		}
		
		if (!BizObjInfoId) {
			tableObj.setDatasource([], 0);
			return;
		}

		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		BizObjDataItemAction.queryBizObjDataItemList(query,function(data){
			 tableObj.setDatasource(data.list||[], data.count);
		});
		dwr.TOPEngine.setAsync(true);
	}
		
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 30;
	}
	
	//grid高度
	function resizeHeight(){
		return 400;
	}
	
	//编辑事件 
	function editBizInfoLoad(){
		parent.editLoad(BizObjInfoId);
		buttonEnable(true);
	}
   	
	function init() {
		if(BizObjInfoId != "") {
			dwr.TOPEngine.setAsync(false);
			BizObjInfoAction.queryBizObjInfoById(BizObjInfoId,function(bResult){
				BizObjInfo = bResult;
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			$("#code_label").hide();
			$("#code_value").hide();
		}
		
		comtop.UI.scan();
		if("<c:out value='${param.readOnly}'/>" == "true") {
			comtop.UI.scan.setReadonly(true);
			buttonEnable(false);
		}else{
			buttonEnable(true);
		}
	}
	
	function beforeSave(){
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
				cui.alert(str);
				return false;
			}
		}
		var rel=cui("#BizObjDataItemGrid").submit();
		if(rel === "fail"){
			return false;
		}
		else{
			var dataItem=cui("#BizObjDataItemGrid").getData();
			if(dataItem.length>0){
				for(var i=0;i<dataItem.length;i++){
					dataItem[i].domainId=domainId;
				}
			}
			BizObjInfo.dataItems = dataItem;
			dwr.TOPEngine.setAsync(false);
			BizObjInfoAction.saveBizObjInfo(BizObjInfo, function(bResult){
	 			//保存数据
	 			if(bResult) {
	 				if(BizObjInfo.id && BizObjInfo.id != "") {
	 					window.parent.cui.message('修改成功。','success');
	 				} else {
	 					BizObjInfo.id = bResult;
	 	 				window.parent.cui.message('新增成功。','success');
	 				}
	 				cui("#BizObjDataItemGrid").loadData();
	 			}
	 			BizObjInfo.id = bResult;
	 			window.parent.loadGrid(BizObjInfo.id);
	 			window.parent.setCenterEditUrl(BizObjInfo.id,"read");
	 			window.parent.oneClick("BizObjGrid");
			});
			dwr.TOPEngine.setAsync(true);

			if (typeof(myAfterSave) == "function") {
				eval("myAfterSave()");
	        }
	        // 保存成功
	    	buttonEnable(false);
			comtop.UI.scan.setReadonly(true);
			return true;
		}
	}
	
	function btnSave(editableGridObj, changeData) {
	}
	
	
	//业务对象名称检测
	var validateBizObjInfoName = [
	      {'type':'required','rule':{'m':'业务对象名称不能为空。'}},
	      {'type':'custom','rule':{'against':checkNameIsExist, 'm':'业务对象名称已经存在。'}}
	    ];
 	//检验业务对象名称是否存在
  	function checkNameIsExist(data) {
  		var flag = true;
  		if(BizObjInfo.name){
  			BizObjInfo.name=trim(BizObjInfo.name);
  		}
  		dwr.TOPEngine.setAsync(false);
  		BizObjInfoAction.isExistSameNameBizInfo(BizObjInfo,function(bResult){
			flag = bResult;
		});
		dwr.TOPEngine.setAsync(true);
		return (flag==true?false:true);
  	}
 	
	//去左右空格;
 	function trim(str){
 	    return str.replace(/(^\s*)|(\s*$)/g, "");
 	}
 	
	//编辑区域按钮控制--
	function buttonEnable(flag){
		if(flag){
			cui("#btnEdit").hide();//编辑
			cui("#btnSave").show();//保存
			cui('.top_required').show();
			cui("#BizObjDataItemGridAdd").show();//新增
			cui("#BizObjDataItemGridDelete").show();//删除
			cui("#BizObjDataItemGridUpButton").show();//上移
			cui("#BizObjDataItemGridDownButton").show();//下移
			cui("#BizObjDataItemGridTopButton").show();//置顶
			cui("#BizObjDataItemGridBottomButton").show();//置底
			cui("#code").setReadonly(true);
		}else{
			cui("#btnEdit").show();//编辑
			cui("#btnSave").hide();//保存
			cui('.top_required').hide();
			cui("#BizObjDataItemGridAdd").hide();//新增
			cui("#BizObjDataItemGridDelete").hide();//删除
			cui("#BizObjDataItemGridUpButton").hide();//上移
			cui("#BizObjDataItemGridDownButton").hide();//下移
			cui("#BizObjDataItemGridTopButton").hide();//置顶
			cui("#BizObjDataItemGridBottomButton").hide();//置底
		}
	}
	
	//插入一行数据
	function insertBizObjDataItemGrid() {
		cui("#BizObjDataItemGrid").insertRow({});
	}
	//删除grid行
	function deleteBizObjDataItemGrid(){
		var selects = cui("#BizObjDataItemGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}
		var indexs =  cui("#BizObjDataItemGrid").getSelectedIndex();
		cui("#BizObjDataItemGrid").deleteRowByIndex(indexs);
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
	
	//设置grid的置灰显示
	function setButtonIsDisable(gridId,up,down,top,bottom){
		cui("#" + gridId + "UpButton").disable(up);
		cui("#" + gridId + "DownButton").disable(down);
		cui("#" + gridId + "TopButton").disable(top);
		cui("#" + gridId + "BottomButton").disable(bottom);
	}
	
	function BizObjDataItemGridOneClick(){
		oneClick('BizObjDataItemGrid');
	}
	function BizObjDataItemGridAllClick(){
		allClick('BizObjDataItemGrid');
	}

	//子grid新增行、删除行图标渲染
	function operationRenderForBizObjDataItem(data,index,col){
		return "<img src='<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/dev/page/designer/images/add.gif' onclick='insertRowForBizObjDataItem();'/>" +"  " +
			"<img src='<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/dev/page/designer/images/delete_1.gif' onclick='deleteRowForBizObjDataItem(this);'/>";
	}
	
	//插入一行数据
	function insertRowForBizObjDataItem() {
		cui("#BizObjDataItemGrid").insertRow({});
	}
	
	//删除grid行
	function deleteRowForBizObjDataItem(t){
		var $t = $(t).parents('tr').eq(0);
		var $ts = $t.parent('tbody').children('tr');
		var index = $ts.index($t);
		cui("#BizObjDataItemGrid").deleteRowByIndex(index);
	}
	var vNull = [{'type':'custom','rule':{'against':isBlank, 'm':'不能为空'}}];
	var objDataCode=[{'type':'custom','rule':{'against':isBlank, 'm':'不能为空'}},
	                 {'type':'custom','rule':{'against':checkDataCode, 'm':'编码已存在'}},
					 {'type':'custom','rule':{'against':notCn, 'm':'编码不能为中文'}}];
	var objDataName=[{'type':'custom','rule':{'against':isBlank, 'm':'不能为空'}},
	                 {'type':'custom','rule':{'against':checkDataName, 'm':'名称已存在'}}];
	
	function checkDataCode(data){
		var allData=cui("#BizObjDataItemGrid").getData();
		for(var i=0;i<allData.length;i++){
			for(var j=i+1;j<allData.length;j++){
				if(trim(allData[i].code)==trim(allData[j].code)){
					return false;
				}
			}
		}
		return true;
	}
	
	function checkDataName(data){
		var allData=cui("#BizObjDataItemGrid").getData();
		for(var i=0;i<allData.length;i++){
			for(var j=i+1;j<allData.length;j++){
				if(trim(allData[i].name)==trim(allData[j].name)){
					return false;
				}
			}
		}
		return true;
	}


	//可编辑列表回显数据，方法名为before+Grid的datasource方法名
	function beforeinitGridData(tableObj,query){
		if(!BizObjInfoId){	  		 
			query.bizObjId = null;  
		}else{
			query.bizObjId = BizObjInfoId;
		}
    }


	//空格过滤
	function isBlank(data){
		if(data.replace(/\s/g, "")==""){
			return false;
		}
		return true;
	}
	
	function notCn(data){
		if (/[\u4E00-\u9FA5]/i.test(data)){
			return false;
		  }
		return true;
	}
	
	//配置具体可编辑的列及列控件--配置的grid添加了字段
	var edittypeForBizObjDataItem = {
		"name": {
			uitype: "Input",
			id: "name",
			width: "85%",
			validate:objDataName,
		},
		"code": {
			uitype: "Input",
			id: "code",
			width: "85%",
			validate:objDataCode,
		},
		"codeNote": {
			uitype: "Input",
			id: "codeNote",
			width: "85%",
		},		
		"remark": {
			uitype: "Input",
			id: "remark",
			emptytext: "同时对应业务数据质量管理要求字段",
			width: "85%",
		}
	};
	
	//检查可编辑列编辑条件
	function editbefore(rowData, bindName){
		if (bindName == "name") {
			if(readOnly){
				return false;
			}
			else{
				return {             
					uitype: "Input",
					id: "name",
					width: "85%",
					validate:objDataName,
					maxlength:200
					}
			}
		}
		if (bindName == "code") {
			if(readOnly){
				return false;
			}
			else{
				return {             
					uitype: "Input",
					id: "code",
					width: "85%",
					validate:objDataCode,
					maxlength:250
					}
			}
		}
		if (bindName == "codeNote") {
			if(readOnly){
				return false;
			}
			else{
				return {             
					uitype: "Input",
					id: "codeNote",
					width: "85%",
					maxlength:100
					}
			}
		}
		if(bindName =="remark"){
			if(readOnly){
				return false;
			}
			else{
				return{
					uitype: "Input",
					id: "remark",
					emptytext: "同时对应业务数据质量管理要求字段",
					width: "85%",
					maxlength:2000
					}
			}
		}
	}
</script>
<top:script src="/cap/bm/biz/info/js/BizObjInfo.js"/>
</body>
</html>