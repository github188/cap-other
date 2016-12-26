<!doctype html>
<%
  /**********************************************************************
	* 功能项编辑
	* 2015-12-2 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>子功能项</title>
		<top:link href="/cap/bm/common/top/css/top_base.css" />
		<top:link href="/cap/bm/common/top/css/top_sys.css" />
		<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
		<top:link href="/cap/bm/common/styledefine/css/public.css"/>
		<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
		<top:script src="/cap/dwr/engine.js" />
		<top:script src="/cap/dwr/util.js" />
		<top:script src="/cap/bm/common/top/js/jquery.js" />
		<top:script src="/cap/bm/common/js/capCommon.js" />
</head>
<style>
	.form_table .divTitle{
		position:relative;
		background: url("<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/styledefine/images/title.png") 0 3px no-repeat;
		padding: 2px 5px 8px 15px;
	}
	.BtnDiv{
	margin-bottom:4px;
	}
</style>
<body class="top_body" style="overflow-x: hidden;">
	<div class="top_header_wrap" style="text-align: center;">
			<div style="float:right">
			<span uitype="button" on_click="btnAdd" id="btnAdd" hide="false" button_type="blue-button" disable="false" label="新增功能子项"></span> 
			<span uitype="button" on_click="saveNoBack" id="addSaveNoBackButton" hide="false" button_type="blue-button" disable="false" label="保存"></span>
			<span uitype="button" on_click="deleteFunctionSubitem" id="deleteFunctionSubitem" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/delete_white.gif" hide="false" button_type="blue-button" disable="false" label="删除"></span> 
		</div>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<table class="form_table" style="table-layout:fixed;">
			<colgroup>
				<col width="16%" />
				<col width="34%" />
			</colgroup>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">名称<span class="top_required">*</span>：</span></td>
					<td colspan="3">
						<span uitype="Input" maxlength="80" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="ReqFunctionSubitem.cnName" type="text" readonly="false" validate="cnNameValidate" id="cnName"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">编码：</span></td>
					<td>
						<span uitype="Input" maxlength="80" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="ReqFunctionSubitem.code" type="text" readonly="true" id="code"></span>
					</td>
					<td class="td_label"><span style="padding-left: 10px;">IT实现<span class="top_required">*</span>：</span></td>
					<td>
						<span uitype="RadioGroup" id="itImp" name="itImp" databind="ReqFunctionSubitem.itImp" value="0" width="85%">
							<input type="radio" value="0" text="是" />
		        			<input type="radio" value="1" text="否" />
						</span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">需求分析：</span></td>
					<td colspan="3">
						<span style="color:#999;">您还能输入<label id="reqAnalysis_tip" style="color: red;"></label>个字！</span><br/>
						<span uitype="Textarea" relation="reqAnalysis_tip" textmode="false" autoheight="false" width="85%" id="reqAnalysis" maxlength="250" height="51px" byte="true" databind="ReqFunctionSubitem.reqAnalysis" name="reqAnalysis_Textarea" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label">流程节点：</td>
					<td colspan="3">
						<span uitype="ClickInput" id="nodeNames" databind="ReqFunctionSubitem.nodeNames" width="85%" on_iconclick="chooseBizFlowNode"></span>
						<span uitype="button" on_click="btnClean" id="btnClean" hide="false" button_type="blue-button" label="清空"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label">业务对象：</td>
					<td colspan="3">
					<span uitype="ClickInput" id="bizObjectNames" databind="ReqFunctionSubitem.bizObjectNames" width="85%"on_iconclick="chooseBizObjInfo"></span>
					<span uitype="button" on_click="btnCleanObj" id="btnCleanObj" hide="false" button_type="blue-button" label="清空">
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">功能综述：</span></td>
					<td colspan="3">
						<span uitype="Editor" id="functionDescription"  width="85%" min_frame_height="200" textmode="false" databind="ReqFunctionSubitem.functionDescription" word_count="true" maximum_words="10000" toolbars="toolbars" focus="true" readonly="false"></span>
					</td>
				</tr>
				<tr>
					<td class="td_label"><span style="padding-left: 10px;">备注：</span></td>
					<td colspan="3">
						<span uitype="Input" id="remark" maxlength="500" byte="true" textmode="false" maskoptions="{}" align="left" width="85%" databind="ReqFunctionSubitem.remark" type="text" readonly="false"></span>
					</td>
				</tr>
			</tbody>
		</table>
		<div id="relationDiv" align="center">
				<div class="BtnDiv" style="float:right">
							<span uitype="button" on_click="btnChooseRole" id="btnChooseRole" hide="false" button_type="blue-button" disable="false" label="导入"></span> 
							<span uitype="button" on_click="deleteReqSubitemDutyGrid" id="ReqSubitemDutyGridDelete" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/delete_white.gif" hide="false" button_type="blue-button" disable="false" label="删除"></span> 
						</div>
						<div >
							<table uitype="EditableGrid" id="ReqSubitemDutyGrid" pagesize="50"  submitdata="submitdata"  gridheight="500px"  ellipsis="true"  colhidden="true"  pageno="1"  gridwidth="600px"  pagination_model="pagination_min_1"  selectrows="multi"  sortstyle="1"  datasource="initGridData"  insertbutton="1,2"  fixcolumnnumber="0"  adaptive="true"  titleellipsis="true"  resizeheight="resizeHeight"  sorttype="[]"  sortname="[]"  resizewidth="resizeWidth"  loadtip="true"  pagesize_list="[25, 50, 100]"  colmove="false"  primarykey="id"  edittype="edittypeForReqSubitemDuty"  pagination="false"  oddevenrow="false" >
							 	<tr>
									<th style="width:50px"><input type="checkbox" /></th>
									<th bindName="roleName" sort="false" hide="false" width="100" disabled="false" render="" renderStyle="text-align: center;">角色名称</th>
									<th bindName="description" sort="false" hide="false" width="300" disabled="false" render="" renderStyle="text-align: left;">职责描述</th>
								</tr>
							</table>	
						</div>
		</div>
	</div>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js" /> 
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" /> 
	<top:script src="/cap/dwr/interface/ReqFunctionSubitemAction.js" />
	<top:script src="/cap/dwr/interface/ReqSubitemDutyAction.js" />
	<top:script src="/cap/dwr/interface/ReqFunctionItemAction.js" />
<script language="javascript"> 
	var ReqFunctionSubitemId = "<c:out value='${param.ReqFunctionSubitemId}'/>";
	var ReqFunctionItemId = "<c:out value='${param.ReqFunctionItemId}'/>";;
	var domainId = "";
	var ReqFunctionSubitem = {};
	var nodeIds;
	var bizObjectIds;
	var roleIds;
	var fromPage = "<c:out value='${param.fromPage}'/>";
   	var cnNameValidate = [
   	                     {'type':'required', 'rule':{'m': '名称不能为空！'}},
   	           	      {'type':'custom','rule':{'against':checkCnName, 'm':'名称已经存在！'}}
   	           	      ];
   	window.onload = function(){
   		init();
   	}
   	//grid数据源	
	function initGridData(tableObj,query){
		if (typeof(beforeinitGridData) == "function") {
			eval("beforeinitGridData(tableObj,query)");
		}
		
		if (!ReqFunctionSubitemId) {
			tableObj.setDatasource([], 0);
			return;
		}

		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		ReqSubitemDutyAction.queryReqSubitemDutyList(query,function(data){
			 tableObj.setDatasource(data.list||[], data.count);
			 if(data.roleIds){
				 roleIds = data.roleIds;
			 }
		});
		dwr.TOPEngine.setAsync(true);
	}
		
   	function checkCnName(cnName){
   		var count = 0;
   		var condition = {};
   		condition.itemId = ReqFunctionItemId;
   		if(ReqFunctionSubitemId){
   			condition.queryId = ReqFunctionSubitemId;
   		}
   		condition.cnName = cnName;
   		dwr.TOPEngine.setAsync(false);
	   		ReqFunctionSubitemAction.queryReqFunctionSubitemCount(condition,function(bResult){
	   			count=bResult;
			});
   		dwr.TOPEngine.setAsync(true);
   		return count>0 ?false :true;
   	}
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 40;
	}
	
	//grid高度
	function resizeHeight(){
		return 250;
	}
   	
	function init() {
		if(ReqFunctionSubitemId != "") {
			dwr.TOPEngine.setAsync(false);
			ReqFunctionSubitemAction.queryReqFunctionSubitemById(ReqFunctionSubitemId,function(bResult){
				ReqFunctionSubitem = bResult;
				ReqFunctionItemId = bResult.itemId;
				nodeIds = bResult.nodeIds;
				bizObjectIds = bResult.bizObjectIds;
			});
			dwr.TOPEngine.setAsync(true);
		}else{
			cui("#deleteFunctionSubitem").hide();
			cui("#btnChooseRole").hide();
			cui("#ReqSubitemDutyGridDelete").hide();
			cui("#btnAdd").hide();
		}
		if (typeof(myBeforeInit) == "function") {
			eval("myBeforeInit()");
		}
		
		if(!ReqFunctionSubitem.nodeIds){
			cui("#btnClean").hide();
		}
		if(!ReqFunctionSubitem.bizObjectIds){
			cui("#btnCleanObj").hide();
		}
		
		comtop.UI.scan();
		
		var isHideAddNewContinueBtn = true;
		if(ReqFunctionSubitemId=="" || ReqFunctionSubitemId==null){
			isHideAddNewContinueBtn = false;
		}
		if (typeof(afterInit) == "function") {
			eval("afterInit()");
		}
		
		if("<c:out value='${param.readOnly}'/>" == "true") {
			comtop.UI.scan.setReadonly(true);
			cui("#addSaveNoBackButton").hide();
			if (typeof(setReadonlyButton) == "function") {
				eval("setReadonlyButton()");
			}
		}
		
		if(ReqFunctionItemId !=""){
			ReqFunctionItemAction.queryReqFunctionItemById(ReqFunctionItemId,function(bResult){
				domainId = bResult.bizDomainId;
			});
		}
	}
	
	//删除数据
	function deleteFunctionSubitem(){
		cui.confirm("确定要删除当前数据吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				ReqFunctionSubitemAction.deleteReqFunctionSubitem(ReqFunctionSubitem,function(msg){
					window.parent.cui.message('删除成功。','success');
					setTimeout(function(){
						parent.parent.setLeftUrl(ReqFunctionItemId);
					},100);
				});
				dwr.TOPEngine.setAsync(true);
			}
		});
	}
	
	function saveNoBack(){
		var saveSuccess = btnSave(false);
	}
	
	//新增功能子项
	function btnAdd(){
		var url = "<%=request.getContextPath()%>/cap/bm/req/subfunc/ReqFunctionSubitemEdit.jsp?ReqFunctionItemId="+ReqFunctionItemId;
		window.parent.location.href = url;
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
			if(str != ""){
				cui.alert(str);
				return false;
			}
		}
	
		if (typeof(beforeSave) == "function") {
			eval("beforeSave()");
        }
        
		var result = true;

		if(!result && typeof(result) != "undefined"){
        	return;
        }
			
		cui("#EditableGrid").submit();
		dwr.TOPEngine.setAsync(false);
		ReqFunctionSubitemAction.saveReqFunctionSubitem(ReqFunctionSubitem, function(bResult){
 			//保存数据
 			if(bResult) {
 				ReqFunctionSubitem.id = bResult;
 				window.parent.cui.message('保存成功。','success');
 			}
 			//刷新坐标树形结构
 			setTimeout(function(){
	 			if(ReqFunctionSubitemId){
	 				parent.parent.setLeftUrl(ReqFunctionSubitem.id);
	 			}else{
	 				parent.setLeftUrl(ReqFunctionSubitem.id);
	 			}
			},300);
 			
		});
		dwr.TOPEngine.setAsync(true);

		if (typeof(myAfterSave) == "function") {
			eval("myAfterSave()");
        }
        // 保存成功
		return true;
	}
	
	//获取流程节点
	function chooseBizFlowNode(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/flow/chooseMulProcessNode.jsp?domainId="+domainId;
		var title="选择流程节点";
		var height = 800;
		var width =  800;
		
		dialog = cui.dialog({
			title : title,
			top : 0,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//选取流程节点回调
	function chooseProcessNodeCallback(selects){
		var selNames="";
		nodeIds="";
		for(var i=0;i<selects.length;i++){
			if(i<selects.length - 1){
				nodeIds += selects[i].id+",";
				selNames += selects[i].name+",";
			}else{
				nodeIds += selects[i].id;
				selNames += selects[i].name;
			}
		}
		cui("#btnClean").show();
		cui("#nodeNames").setValue(selNames);
	}
	
	//获取业务对象
	function chooseBizObjInfo(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/info/BizObjInfoList.jsp?domainId="+domainId;
		var title="选择业务对象";
		var height = 800;
		var width =  800;
		
		dialog = cui.dialog({
			title : title,
			top : 0,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	function chooseObjInfoCallback(selects){
		var selNames="";
		bizObjectIds="";
		for(var i=0;i<selects.length;i++){
			if(i<selects.length - 1){
				bizObjectIds += selects[i].id+",";
				selNames += selects[i].name+",";
			}else{
				bizObjectIds += selects[i].id;
				selNames += selects[i].name;
			}
		}
		cui("#btnCleanObj").show();
		cui("#bizObjectNames").setValue(selNames);
	}
	
	/**
	 * 保存后处理事件，在执行btnSave方法后调用该方法
	 * 该方法可自行维护，不需要时可删除
	 */
	function myAfterSave(){
		cui("#ReqSubitemDutyGrid").submit();
	}
	
	//删除grid行
	function deleteReqSubitemDutyGrid(){
		var selects = cui("#ReqSubitemDutyGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}
		cui.confirm("确定要删除选中的数据项吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				ReqSubitemDutyAction.deleteReqSubitemDutyList(selects,function(data){
					var indexs =  cui("#ReqSubitemDutyGrid").getSelectedIndex();
					cui("#ReqSubitemDutyGrid").deleteRowByIndex(indexs);
					cui.message("删除成功!","success");
				});
				dwr.TOPEngine.setAsync(true);
			}
		});
	
	
	}
	//保存前处理事件
	function beforeSave() {
		alertMessage = "";
		if(!ReqFunctionSubitem.creatorId){
			ReqFunctionSubitem.creatorId = globalUserId;
		}
		ReqFunctionSubitem.reqSubitemDutyByReqsubitemdutys = cui("#ReqSubitemDutyGrid").getData();
		
		ReqFunctionSubitem.reqAnalysis = cui("#reqAnalysis").getValue();
		ReqFunctionSubitem.bizObjectIds = bizObjectIds;
		ReqFunctionSubitem.nodeIds = nodeIds;
		ReqFunctionSubitem.itemId = ReqFunctionItemId;
		ReqFunctionSubitem.sortNo = 0;
		ReqFunctionSubitem.dataFrom = 0;
	}
	
	//初始化后处理事件，回显操作
  	function afterInit(){
  		if(!nodeIds){
			
		}
  	}

	//清空
	function btnClean(){
		cui("#nodeNames").setValue("");
		cui("#btnClean").hide();
		nodeIds="";
	}
	
	//清空
	function btnCleanObj(){
		cui("#bizObjectNames").setValue("");
		cui("#btnCleanObj").hide();
		bizObjectIds="";
	}
	
	//子grid新增行、删除行图标渲染
	function operationRenderForReqSubitemDuty(data,index,col){
		return "<img src='<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/dev/page/designer/images/add.gif' onclick='insertRowForReqSubitemDuty();'/>" +"  " +
			"<img src='<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/dev/page/designer/images/delete_1.gif' onclick='deleteRowForReqSubitemDuty(this);'/>";
	}
	
	//插入一行数据
	function insertRowForReqSubitemDuty() {
		cui("#ReqSubitemDutyGrid").insertRow({});
	}
	
	//删除grid行
	function deleteRowForReqSubitemDuty(t){
		var $t = $(t).parents('tr').eq(0);
		var $ts = $t.parent('tbody').children('tr');
		var index = $ts.index($t);
		cui("#ReqSubitemDutyGrid").deleteRowByIndex(index);
	}
	
	toolbars=[[
	           'undo', //撤销
	           'redo', //重做
	           'bold', //加粗
	           'indent', //首行缩进
	           'italic', //斜体
	           'underline', //下划线
	           'strikethrough', //删除线
	           'time', //时间
	           'date', //日期
	           'fontfamily', //字体
	           'fontsize', //字号
	           'paragraph', //段落格式
	           'edittable', //表格属性
	           'edittd', //单元格属性
	           'spechars', //特殊字符
	           'justifyleft', //居左对齐
	           'justifyright', //居右对齐
	           'justifycenter', //居中对齐
	           'justifyjustify', //两端对齐
	           'forecolor', //字体颜色
	           'rowspacingtop', //段前距
	           'rowspacingbottom', //段后距
	           'pagebreak', //分页
	           'imagecenter', //居中
	           ]]
	
	//配置具体可编辑的列及列控件--配置的grid添加了字段
	var edittypeForReqSubitemDuty = {
		"name": {
			uitype: "Input",
			id: "name",
			maxlength: "-1",
			byte: true,
			textmode: false,
			maskoptions: "{}",
			align: "left",
			width: "85%",
			type: "text",
			readonly: false	
		},
		"description": {
			uitype: "Input",
			id: "description",
			maxlength: "-1",
			byte: true,
			textmode: false,
			maskoptions: "{}",
			align: "left",
			width: "90%",
			type: "text",
			readonly: false	
		}
	};
		
	function submitdata(grid, changeData){
		var allData=cui("#ReqSubitemDutyGrid").getData();
		var flag=false;
		//新增数据 修改数据
		if(allData){
			dwr.TOPEngine.setAsync(false);
			ReqSubitemDutyAction.saveReqSubitemDutyList(allData, function(bResult){
				flag=bResult;
			});
			dwr.TOPEngine.setAsync(true);
			if(flag){
				cui('#ReqSubitemDutyGrid').loadData();
			}
		}
		cui('#ReqSubitemDutyGrid').submitComplete();
	}
	
	//序号列渲染器 
	function rowNoRender(rowData, index, colName){
		return index+1;
	}

	//可编辑列表回显数据，方法名为before+Grid的datasource方法名
	function beforeinitGridData(tableObj,query){
		if(!ReqFunctionSubitemId){	  		 
			query.subitemId = null;  
		}else{
			query.subitemId = ReqFunctionSubitemId;
		}
    }
	
	//导入角色
	function btnChooseRole(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/role/chooseMulRole.jsp?domainId="+domainId;
		var title="选择角色";
		var height = 800;
		var width =  800;
		
		dialog = cui.dialog({
			title : title,
			top : 0,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	function chooseRole(selects){
		var allData = new Array();
		allData = getArray(selects);
		if(allData == 0){
			cui.alert("选择的数据项已经导入。");
			return;
		}
		var flag=false;
		dwr.TOPEngine.setAsync(false);
		ReqSubitemDutyAction.saveReqSubitemDutyList(allData, function(bResult){
			flag=bResult;
		});
		dwr.TOPEngine.setAsync(true);
		if(flag){
			cui.message('导入成功。','success');
			cui("#ReqSubitemDutyGrid").loadData();
		}
	}
	
	//解析是否有重复
	function getArray(selects){
		var RelLst =[];
		RelLst = cui("#ReqSubitemDutyGrid").getData();
		var ReqSubitemDutyLst = new Array();
		for(var i = 0;i<selects.length;i++){
			var flag = true;
			if(RelLst.length>0){
				for(var j =0;j<RelLst.length;j++){
					if(selects[i].id == RelLst[j].roleId){
						flag = false;
						break;
					}
				}
			}
			if(flag){
				var ReqSubitemDuty={};
				ReqSubitemDuty.roleId = selects[i].id;
				ReqSubitemDuty.subitemId = ReqFunctionSubitemId;
				ReqSubitemDuty.description = selects[i].remark;
				ReqSubitemDuty.dataFrom = 0;
				ReqSubitemDutyLst.push(ReqSubitemDuty);
			}
		}
		return ReqSubitemDutyLst;
	}
	
</script>
</body>
</html>