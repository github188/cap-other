<!doctype html>
<%
  /**********************************************************************
	* 业务对象编辑
	* 2015-11-20 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>业务对象编辑</title>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
	<top:link href="/cap/bm/common/styledefine/css/top_base.css" />
	<top:link href="/cap/bm/common/styledefine/css/top_sys.css" />
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:link href="/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
	<top:link href="/top/sys/usermanagement/orgusertag/css/choose.css"/>
</head>
<style>
	.form_table .divTitle{
		position:relative;
		background: url("<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/styledefine/images/title.png") 0 3px no-repeat;
		padding: 2px 5px 8px 15px;
	}
	.divTreeBtn {
		margin-right :10px;
	    float:right;
	}
</style>
<body class="top_body">
	<div class="divTreeBtn" >
			<span uitype="button" on_click="btnSave" id="btnSave" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/save_white.gif" hide="false" button_type="blue-button" disable="false" label="保存"></span> 
			<span uitype="button" on_click="deleteBizNodeConstraintGrid" id="BizNodeConstraintGridDelete" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/delete_white.gif" hide="false" button_type="blue-button" disable="false" label="删除"></span> 
			<span uitype="button" on_click="btnClose" id="btnClose" hide="false" button_type="blue-button" disable="false" label="关闭"></span>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<table class="form_table" style="table-layout:fixed;">
				<tr>
					<td class="grid-td" colspan=4>
						<div >
							<table uitype="EditableGrid" id="BizNodeConstraintGrid" sortname="[]"  resizewidth="resizeWidth"  loadtip="true"  pagesize_list="[25, 50, 100]"  colmove="false"  primarykey="id"  edittype="edittypeForBizNodeConstraint"  pagination="false"  oddevenrow="false"  pagesize="50"  submitdata="submitdata"  gridheight="1000px"  ellipsis="true"  colhidden="true"  pageno="1"  gridwidth="600px"  pagination_model="pagination_min_1"  sortstyle="1"  selectrows="multi"  datasource="initGridData"  insertbutton="2"  fixcolumnnumber="0"  adaptive="true"  titleellipsis="true"  resizeheight="resizeHeight"  sorttype="[]" colrender="columnRenderer" >
							 	<thead>
								 	<tr>
										<th style="width:50px"><input type="checkbox" /></th>
										<th width="200" disabled="false" render="" bindName="bizObjCode" sort="false" hide="false" renderStyle="text-align: center;">编码</th>
										<th bindName="bizObjName" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: center;">业务对象名称</th>
										<th bindName="itemName" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: center;">数据项</th>
										<th bindName="checkRule" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: center;">业务约束</th>
									</tr>
								</thead>
							</table>
						</div>
					</td>
				</tr>
				<tr>
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
	<top:script src="/cap/dwr/interface/BizNodeConstraintAction.js" />

<script language="javascript"> 
	var BizProcessNodeId = "<c:out value='${param.BizProcessnodeId}'/>";
	var bizObjId = "<c:out value='${param.bizObjId}'/>";
	var BizProcessNode = {};
   	window.onload = function(){
   		comtop.UI.scan();
   	}
   	//grid数据源	
	function initGridData(tableObj,query){
		if (typeof(beforeinitGridData) == "function") {
			eval("beforeinitGridData(tableObj,query)");
		}
		if (!BizProcessNodeId) {
			tableObj.setDatasource([], 0);
			return;
		}
		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		BizNodeConstraintAction.queryBizNodeConstraintList(query,function(data){
			if(data.count ==0){
				cui("#btnSave").hide();
				cui("#BizNodeConstraintGridDelete").hide();
			}else{
				cui("#btnSave").show();
				cui("#BizNodeConstraintGridDelete").show();
			}
			 tableObj.setDatasource(data.list||[], data.count);
		});
		dwr.TOPEngine.setAsync(true);
	}
		
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return 800;
	}
   	
	function btnSave(isBack) {
		cui("#BizNodeConstraintGrid").submit();
	}
	//删除grid行
	function deleteBizNodeConstraintGrid(){
		var selects = cui("#BizNodeConstraintGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}
		parent.cui.confirm("确定要删除选中的数据项吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				BizNodeConstraintAction.deleteBizNodeConstraintList(selects,function(data){
					var indexs =  cui("#BizNodeConstraintGrid").getSelectedIndex();
					cui("#BizNodeConstraintGrid").deleteRowByIndex(indexs);
					parent.setLeftUrl();
					parent.parent.parent.parent.cui.message("删除成功!","success");
				});
				dwr.TOPEngine.setAsync(true);
			}
		});
	}
	
	var vNull = [{'type':'custom','rule':{'against':isBlank, 'm':'不能为空'}}];
	//配置具体可编辑的列及列控件--配置的grid添加了字段
	var edittypeForBizNodeConstraint = {
		"checkRule": {
			uitype: "Input",
			id: "checkRule",
			maxlength: "32",
			validate:vNull,
			byte: true,
			textmode: false,
			maskoptions: "{}",
			emptytext:"如：创建、变更",
			align: "left",
			width: "85%",
			type: "text",
			readonly: false	
		}
	};
	
	//保存数据
	function submitdata(grid, changeData){
		var allData=cui("#BizNodeConstraintGrid").getData();
		var flag=false;
		//新增数据 修改数据
		if(allData){
			dwr.TOPEngine.setAsync(false);
			BizNodeConstraintAction.saveBizNodeConstraintList(allData, function(bResult){
				flag=bResult;
			});
			dwr.TOPEngine.setAsync(true);
			if(flag){
				cui('#BizNodeConstraintGrid').loadData();
				cui.message('保存成功。','success');
			}
		}
		cui('#BizNodeConstraintGrid').submitComplete();
	}
	
	//序号列渲染器 
	function rowNoRender(rowData, index, colName){
		return index+1;
	}


	//可编辑列表回显数据，方法名为before+Grid的datasource方法名
	function beforeinitGridData(tableObj,query){
		if(!BizProcessNodeId){	  		 
			query.nodeId = null;  
		}else{
			query.nodeId = BizProcessNodeId;
		}
		if(!bizObjId){	  		 
			query.bizObjId = null;  
		}else{
			query.bizObjId = bizObjId;
		}
    }

	//关闭事件
	function btnClose() {
		window.parent.parent.close();
	}

	//空格过滤
	function isBlank(data){
		if(data.replace(/\s/g, "")==""){
			return false;
		}
		return true;
	}
</script>
</body>
</html>