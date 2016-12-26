<!doctype html>
<%
  /**********************************************************************
	* 业务关联编辑
	* 2015-11-25 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>业务关联编辑</title>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link href="/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
</head>
<style>
	.form_table .divTitle{
		position:relative;
		background: url("<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/styledefine/images/title.png") 0 3px no-repeat;
		padding: 2px 5px 8px 15px;
	}
</style>
<body class="top_body">
	<div style="text-align: center;">
		<div class="thw_title">业务关联编辑</div>
			<div style="float:right">
			<span uitype="button" on_click="saveNoBack" id="btnSave" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" hide="false" button_type="blue-button" disable="false" label="保存"></span> 
<%-- 			<span uitype="button" on_click="btnAddNewContinue" id="btnAddNewContinue" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" hide="false" button_type="blue-button" disable="false" label="保存并继续"></span>  --%>
			<span uitype="button" on_click="btnClose" id="btnClose" hide="false" button_type="blue-button" disable="false" label="关闭"></span>
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="16%" />
				<col width="34%" />	
				<col width="16%" />
				<col width="34%" />
			</colgroup>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">编码：</td>
					<td>
						<span uitype="Input" id="code" maxlength="125" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizRelInfo.code" type="text" readonly="true" ></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">名称<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="Input" id="name" maxlength="100" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizRelInfo.name" type="text" readonly="false" validate="[{'type':'required', 'rule':{'m': '名称不能为空！'}}]"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">关联类型<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="PullDown" select="-1" width="85%" label_field="text" value_field="id" must_exist="true" editable="true" validate="[{'type':'required', 'rule':{'m': '关联类型不能为空！'}}]" mode="Single" empty_text="请选择" id="relType" name="relType" height="200" auto_complete="false" filter_fields="[]" databind="BizRelInfo.relType" readonly="false" datasource="initRelType"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">关联方向<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="PullDown" select="-1" width="85%" label_field="text" value_field="id" must_exist="true" validate="[{'type':'required', 'rule':{'m': '关联方向不能为空！'}}]" editable="true" empty_text="请选择" mode="Single" id="relOrient" height="200" auto_complete="false" filter_fields="[]" databind="BizRelInfo.relOrient" readonly="false" datasource="initRelInfoType"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">触发条件：</span></td>
					<td colspan="3">
						<span uitype="Textarea" relation="triggerCondition_tip" name="name" readonly="false" id="triggerCondition" maxlength="256" height="51px" byte="true" textmode="false" databind="BizRelInfo.triggerCondition" autoheight="false" width="94%"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">本方工作内容：</span></td>
					<td colspan="3">
						<span uitype="Textarea" relation="roleaWorkContext_tip" id="roleaWorkContext" height="51px" maxlength="256" byte="true" textmode="false" autoheight="false" width="94%" name="roleaWorkContext_Textarea" databind="BizRelInfo.roleaWorkContext" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">本方工作要求：</span></td>
					<td colspan="3">
						<span uitype="Textarea" relation="roleaWorkDemand_tip" id="roleaWorkDemand" maxlength="256" height="51px" byte="true" textmode="false" databind="BizRelInfo.roleaWorkDemand" autoheight="false" width="94%" name="name" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">对方流程节点<span class="top_required">*</span>：</span></td>
					<td colspan="3">
						<span uitype="Input" type="text" readonly="true" validate="[{'type':'required', 'rule':{'m': '对方业务流程节点名称不能为空！'}}]" id="rolebNodeName" maxlength="200" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="BizRelInfo.rolebNodeName"></span>
						<span uitype="button" on_click="btnChose" id="btnChose" hide="false" button_type="blue-button" disable="false" label="选择节点"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">对方工作内容：</span></td>
					<td colspan="3">
						<span uitype="Textarea" relation="rolebWorkContext_tip" id="rolebWorkContext" maxlength="256" height="51px" byte="true" textmode="false" databind="BizRelInfo.rolebWorkContext" autoheight="false" width="94%" name="name" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">对方工作要求：</span></td>
					<td colspan="3">
						<span uitype="Textarea" relation="rolebWorkDemand_tip" id="rolebWorkDemand" maxlength="256" height="51px" byte="true" textmode="false" databind="BizRelInfo.rolebWorkDemand" autoheight="false" width="94%" name="name" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="grid-td" colspan=4>
						<div class="top_header_wrap" style="float:right">
							<span uitype="button" on_click="selectObjInfoItem" id=SelectObjInfoItem hide="false" button_type="blue-button" disable="false" label="导入"></span> 
							<span uitype="button" on_click="deleteBizRelDataGrid" id="BizRelDataGridDelete" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/delete_white.gif" hide="false" button_type="blue-button" disable="false" label="删除"></span> 
						</div>
						<div >
							<table uitype="EditableGrid" id="BizRelDataGrid" pagesize="50"  submitdata="submitdata"  gridheight="800px"  ellipsis="true"  colhidden="true"  pageno="1"  gridwidth="600px"  pagination_model="pagination_min_1"  sortstyle="1"  selectrows="multi"  datasource="initGridData"  insertbutton="1,2"  fixcolumnnumber="0"  adaptive="true"  resizeheight="resizeHeight"  titleellipsis="true"  sorttype="[]"  sortname="[]"  resizewidth="resizeWidth"  loadtip="true"  pagesize_list="[25, 50, 100]"  colmove="false"  primarykey="id"  edittype="edittypeForBizRelData"  pagination="false"  oddevenrow="false" >
							 	<tr>
									<th style="width:50px"><input type="checkbox" /></th>
									<th sort="false" hide="false" width="200" disabled="false" render="" bindName="bizObjName" renderStyle="text-align: left;">业务对象名称</th>
									<th bindName="itemName" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: left;">数据项名称</th>
									<th bindName="itemCodeNote" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: left;">编码引用说明</th>
									<th bindName="remark" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: left;">备注</th>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" /> 
	<top:script src="/top/js/jquery.js" />
	<top:script src="/cap/bm/common/js/cap.bm.common.js" />
	<top:script src="/cap/dwr/engine.js" />
	<top:script src="/cap/dwr/util.js" /> 
	<top:script src="/cap/dwr/interface/BizProcessNodeAction.js" />
	<top:script src="/cap/dwr/interface/BizRelInfoAction.js" />
	<top:script src="/cap/dwr/interface/BizRelDataAction.js" />

<script language="javascript"> 
	var domainId = "${param.domainId}";
	var BizProcessInfoId = "${param.BizProcessInfoId}";
	var BizProcessnodeId = "${param.BizProcessnodeId}";
	var BizRelInfoId = "<c:out value='${param.BizRelInfoId}'/>";
	var BizRelInfo = {};
	var fromPage = "<c:out value='${param.fromPage}'/>";
	
   	var initRelType = [
    	   	          		{id:'业务域内',text:'业务域内'},
    	   	          		{id:'跨业务域',text:'跨业务域'},
	    	   	         	{id:'外部单位',text:'外部单位'},
		   	          		{id:'设备',text:'设备'}
    	   	          		];
   	var initRelInfoType = [
 	   	          		{id:'输入',text:'输入'},
 	   	          		{id:'输出',text:'输出'}
 	   	          		];
   	
   	//验证不为中文
	function notCn(data){
		if (/[\u4E00-\u9FA5]/i.test(data)){
			return false;
		  }
		return true;
	}
 	
	//配置具体可编辑的列及列控件--配置的grid添加了字段
	var edittypeForBizRelData = {
		"remark": {
			uitype: "Input",
			id: "remark",
			maxlength: "-1",
			byte: true,
			textmode: false,
			maskoptions: "{}",
			align: "left",
			width: "85%",
			type: "text",
			maxlength: 1000,
			readonly: false	
		}
	};
	
   	window.onload = function(){
   		init();
   	}
	function init() {
		if(BizRelInfoId != "") {
			dwr.TOPEngine.setAsync(false);
			BizRelInfoAction.queryBizRelInfoById(BizRelInfoId,function(bResult){
				BizRelInfo = bResult;
			});
			dwr.TOPEngine.setAsync(true);
		}
		if (typeof(myBeforeInit) == "function") {
			eval("myBeforeInit()");
		}

		comtop.UI.scan();
		
		var isHideAddNewContinueBtn = true;
		if(BizRelInfoId=="" || BizRelInfoId==null){
			isHideAddNewContinueBtn = false;
		}
		setAddNewContinueBtnIsHide(isHideAddNewContinueBtn);
		if (typeof(afterInit) == "function") {
			eval("afterInit()");
		}
		
		if (typeof(myAfterInit) == "function") {
			eval("myAfterInit()");
		}
		
		if("<c:out value='${param.readOnly}'/>" == "true") {
			comtop.UI.scan.setReadonly(true);
			cui("#btnSave").hide();
			cui("#btnAddNewContinue").hide();
			cui("#btnClose").show();
			if (typeof(setReadonlyButton) == "function") {
				eval("setReadonlyButton()");
			}
		}
	}
	
   	//grid数据源	
	function initGridData(tableObj,query){
		if (typeof(beforeinitGridData) == "function") {
			eval("beforeinitGridData(tableObj,query)");
		}
		
		if (!BizRelInfoId) {
			tableObj.setDatasource([], 0);
			return;
		}

		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		BizRelDataAction.queryBizRelDataList(query,function(data){
			 tableObj.setDatasource(data.list||[], data.count);
		});
		dwr.TOPEngine.setAsync(true);
	}
   	
   	//提交eidtGrid
	function submitdata(grid, changeData){
		var allData=cui("#BizRelDataGrid").getData();
		//新增数据 修改数据
		var flag = false;
		dwr.TOPEngine.setAsync(false);
		BizRelDataAction.saveBizRelDataList(allData, function(bResult){
			flag = bResult;
		});
		dwr.TOPEngine.setAsync(true);
		if(flag){
			cui('#BizRelDataGrid').submitComplete();		
		}
	}
	
	function beforeinitGridData(tableObj,query){
		if (BizRelInfoId) {
			query.relInfoId= BizRelInfoId;	
		}
	}
   	
	//删除grid行
	function deleteBizRelDataGrid(){
		var selects = cui("#BizRelDataGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}
		cui.confirm('确认要删除选中的数据项吗？', {
	        onYes: function () {
	    		dwr.TOPEngine.setAsync(false);
	    		BizRelDataAction.deleteBizRelDataList(selects);
	    		dwr.TOPEngine.setAsync(true);
				var indexs =  cui("#BizRelDataGrid").getSelectedIndex();
				cui("#BizRelDataGrid").deleteRowByIndex(indexs);
				window.parent.cui.message('删除成功!','success');
	        }
	    });
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 50;
	}
	
	//grid高度
	function resizeHeight(){
		return 350;
	}
	
	function setAddNewContinueBtnIsHide(isHide){
		if(cui("#btnAddNewContinue")!=null){
			if(isHide==true){
				cui("#btnAddNewContinue").hide();
			}else{
				cui("#btnAddNewContinue").show();
			}
			
		}
	}
	
	function btnAddNewContinue(){
		var saveSuccess = btnSave(false);
		if(saveSuccess){
			parent.setLeftUrl("");
			window.cui.message('保存成功。','success');
		}
	}
	
	function saveNoBack(){
		var saveSuccess = btnSave(false);
		if(saveSuccess){
			parent.setLeftUrl(BizRelInfo.id);
			var url = 'BizRelInfoEdit.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId;
			url += '&BizRelInfoId='+BizRelInfo.id;
			parent.setCenterUrl(url);
			window.parent.cui.message('保存成功。','success');
			if (typeof(myAfterSave) == "function") {
				eval("myAfterSave()");
	        }
		}
	}
	
	function btnSave(isBack) {
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
			if(BizRelInfo.rolebNodeId ==null || BizRelInfo.rolebNodeId ==""){
				str +="对方流程节点不能为空！<br/>"
			}
			if(str != ""){
				cui.alert(str);
				return false;
			}
		}
	
		if (typeof(beforeSave) == "function") {
			eval("beforeSave()");
        }
        
		var result = true;
		if (typeof(myBeforeSave) == "function") {
			result = eval("myBeforeSave()");
        }
        if(!result && typeof(result) != "undefined"){
        	return;
        }
        cui("#BizRelDataGrid").submit();
		dwr.TOPEngine.setAsync(false);
		BizRelInfoAction.saveBizRelInfo(BizRelInfo, function(bResult){
 			//保存数据
 			if(bResult && isBack) {
 				if(BizRelInfo.id && BizRelInfo.id != "") {
 					window.parent.cui.message('修改成功。','success');
 				} else {
 					BizRelInfo.id = bResult;
 					BizRelInfoId = bResult;
 	 				window.parent.cui.message('新增成功。','success');
 	 				var url = 'BizRelInfoEdit.jsp?domainId='+domainId+'&BizProcessInfoId='+BizProcessInfoId+'&BizProcessnodeId='+BizProcessnodeId;
 					url +="&BizRelInfoId="+bResult;
 					parent.setCenterUrl(url);
 				}
 				parent.setLeftUrl(BizRelInfo.id);
 			}
 			BizRelInfo.id = bResult;
		});
		dwr.TOPEngine.setAsync(true);
        // 保存成功
		return true;
	}
	
	//保存后处理事件
	function myAfterSave() {
		cui("#SelectObjInfoItem").show();
		cui("#BizRelDataGridDelete").show();
	}
	
		//保存前处理事件
	function beforeSave() {
		alertMessage = "";
		if(!BizRelInfo.creatorId){
			BizRelInfo.creatorId = globalUserId;
		}
		BizRelInfo.triggerCondition = cui("#triggerCondition").getValue();	  
		BizRelInfo.roleaWorkContext = cui("#roleaWorkContext").getValue();	  
		BizRelInfo.roleaWorkDemand = cui("#roleaWorkDemand").getValue();	  
		BizRelInfo.rolebWorkContext = cui("#rolebWorkContext").getValue();	  
		BizRelInfo.rolebWorkDemand = cui("#rolebWorkDemand").getValue();	
		BizRelInfo.dataFrom = 0;
		if(BizRelInfoId == null || BizRelInfoId ==""){
			BizRelInfo.roleaDomainId = domainId;
			BizRelInfo.roleaProcessId = BizProcessInfoId;
			BizRelInfo.roleaNodeId = BizProcessnodeId;
		}
	}
		
	//初始化后处理事件，回显操作
  	function afterInit(){
		var BizProcessNode = {};
		//初始化本方信息
		if(BizProcessnodeId){
			BizProcessNode.id=BizProcessnodeId;
			dwr.TOPEngine.setAsync(false);
			BizProcessNodeAction.queryNodeInfoById(BizProcessNode,function(bResult){
				if(bResult !=null && bResult !=""){
					BizRelInfo.roleaDomainName = bResult.domainName;
					BizRelInfo.roleaProcessName = bResult.processName;
					BizRelInfo.roleaNodeName = bResult.name;
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		//初始化对方信息
		if(BizRelInfo.rolebNodeId){
			BizProcessNode.id=BizRelInfo.rolebNodeId;
			dwr.TOPEngine.setAsync(false);
			BizProcessNodeAction.queryNodeInfoById(BizProcessNode,function(bResult){
				if(bResult !=null && bResult !=""){
					BizRelInfo.rolebDomainName = bResult.domainName;
					BizRelInfo.rolebProcessName = bResult.processName;
					cui("#rolebNodeName").setValue(bResult.name);
				}
			});
			dwr.TOPEngine.setAsync(true);
		}
		
		//数据项导入导出隐藏
		if(BizRelInfoId==null || BizRelInfoId ==""){
			cui("#SelectObjInfoItem").hide();
			cui("#BizRelDataGridDelete").hide();
		}
  	}
	
	//选择业务流程节点回调方法
	function chooseProcessNodeCallback(selects){
		if(selects[0].id == BizProcessnodeId){
			cui.alert("不能选择当前节点");
			return;
		}
		
		if(domainId == selects[0].domainId){
			cui("#relType").setValue("业务域内");
		}
		
		cui("#rolebNodeName").setValue(selects[0].name);
		BizRelInfo.rolebDomainId = selects[0].domainId;
		BizRelInfo.rolebDomainName = selects[0].domainName;
		BizRelInfo.rolebProcessId = selects[0].processId;
		BizRelInfo.rolebProcessName = selects[0].processName;
		BizRelInfo.rolebNodeId = selects[0].id;
	}

	//选择业务流程节点
	function btnChose(){
		var url ='chooseSinProcessNode.jsp?domainId='+domainId;	
		if(BizRelInfo.rolebNodeId !=null &&　BizRelInfo.rolebNodeId　!=""){
			url +="&id="+BizRelInfo.rolebNodeId;
		}
		var height = 800; //600
		var width =  1000; // 680;
		var y = (document.body.clientHeight -height)/2; 
		var x = (document.body.clientWidth-width)/2; 
		var title="业务流程节点选择";
			
		dialog = cui.dialog({
			title : title,
			src : url,
			top : y,
			left : x,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//弹出流程节点维护页面
	function selectObjInfoItem(){
		var title="业务对象数据项选择";
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/info/BizObjInfoDataItemSelect.jsp?domainId="+domainId;
		var height = 800; //600
		var width =  1000; // 680;
		var y = (document.body.clientHeight -height)/2; 
		var x = (document.body.clientWidth-width)/2; 
		dialog = cui.dialog({
			title:title,
			top:y,
			left:x,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//选中业务对象数据项回调函数
	function chooseBizObjInfoCallback(dataItems,BizObjInfoId){
		var allData = new Array();
		allData = getArray(dataItems,BizObjInfoId);
		if(allData == 0){
			cui.alert("选择的数据项已经导入。");
			return;
		}
		var flag=false;
		dwr.TOPEngine.setAsync(false);
		BizRelDataAction.saveBizRelDataList(allData, function(bResult){
			flag=bResult;
		});
		dwr.TOPEngine.setAsync(true);
		if(flag){
			cui.message('导入成功。','success');
			cui("#BizRelDataGrid").loadData();
		}
		
	}
	
	function getArray(dataItems,BizObjInfoId){
		var query = {};
		var result = [];
		result = cui("#BizRelDataGrid").getData();
		var BizRelDataLst = new Array();
		 for(var i = 0;i<dataItems.length;i++){
			 var flag = true;
			 for(var j = 0;j<result.length;j++){
				 if(dataItems[i].id == result[j].itemId){
					 flag = false;
					 break;
				 }
			 }
			 if(flag){
				 var BizRelData={};
				 BizRelData.relInfoId = BizRelInfoId;
				 BizRelData.objId = BizObjInfoId;
				 BizRelData.itemId = dataItems[i].id;
				 BizRelDataLst.push(BizRelData);
			 }
		 }
		 return BizRelDataLst;
	}
	
	//关闭事件
	function btnClose() {
		window.parent.parent.close(); 
	}
</script>
</body>
</html>