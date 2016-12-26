<!doctype html>
<%
  /**********************************************************************
	* 业务对象基本信息编辑
	* 2015-11-10 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>业务对象基本信息编辑</title>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
</head>
<style>
	.form_table .divTitle{
		position:relative;
		background: url("<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/styledefine/images/title.png") 0 3px no-repeat;
		padding: 2px 5px 8px 15px;
	}
	.divTreeBtn {
		margin-top:28px;
		margin-right :15px;
	    float:right;
	    
	}
	.InputDiv{
	margin-top:4px;
	}
</style>
<body class="top_body">
	<div class="divTreeBtn" >
		<span uitype="button" disable="false" label="确定" on_click="chooseBizInfoItems" id="btnChooseBizInfoItems" hide="false" button_type="blue-button"></span> 
		<span uitype="button" on_click="btnClose" id="btnClose" hide="false" button_type="blue-button" disable="false" label="关闭"></span>
	</div>
	<div id="editDiv"  class="top_content_wrap">
		<div class="InputDiv">
			所属对象编码：<span uitype="Input" id="code" maxlength="250" byte="true" textmode="false" maskoptions="{}" align="left" width="200" databind="BizObjInfo.code" 
					type="text" readonly="false"></span>
		</div >
		<div class="InputDiv">
			所属对象名称：<span uitype="Input" id="name" maxlength="200" byte="true" textmode="false" maskoptions="{}" align="left" width="200" databind="BizObjInfo.name"
					type="text" readonly="false"></span>
		</div>
		<table style="table-layout:fixed;">
					<td class="grid-td">				
						<div >
							<table uitype="EditableGrid" id="BizObjDataItemGrid"  submitdata="submitdata"  gridheight="650px"  ellipsis="true"  colhidden="true"  pageno="1"  gridwidth="600px" rowclick_callback="clickRow" 
							       selectrows="multi"  datasource="initGridData"  resizeheight="resizeHeight"  sorttype="[]"  sortname="[]"  resizewidth="resizeWidth"  loadtip="true"  pagesize_list="[25, 50, 100]"  colmove="false"  primarykey="id"  edittype="edittypeForBizObjDataItem"  pagination="true"  oddevenrow="false" >
							 	<thead>
							 	<tr>
									<th style="width:50px"><input type="checkbox" /></th>
									<th bindName="name" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: center;">名称</th>
									<th bindName="code" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: center;">编码</th>
									<th bindName="codeNote" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: center;">编码引用说明</th>
									<th bindName="remark" sort="false" hide="false" width="200" disabled="false" render="" renderStyle="text-align: center;">备注</th>
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
	<top:script src="/cap/dwr/interface/BizObjInfoAction.js" />
	<top:script src="/cap/dwr/interface/BizObjDataItemAction.js" />

<script language="javascript"> 
	var BizObjInfoId = "<c:out value='${param.BizObjInfoId}'/>";
	var domainId = "<c:out value='${param.domainId}'/>";
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
			dataCount = data.count;
		    tableObj.setDatasource(data.list, data.count);
		    maxSortNo = dataCount;
		});
		dwr.TOPEngine.setAsync(true);
	}
		
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return 700;
	}
	function chooseBizInfoItems(){
		BizObjInfo.dataItems = cui("#BizObjDataItemGrid").getSelectedRowData();
		if(BizObjInfo.dataItems == null || BizObjInfo.dataItems.length == 0){
			cui.alert("请选择数据项。");
			return;
		}	
		window.parent.parent.chooseBizObjInfoCallback(BizObjInfo.dataItems,BizObjInfoId);
		btnClose();
	}

	function init() {
		if(BizObjInfoId != "") {
			dwr.TOPEngine.setAsync(false);
			BizObjInfoAction.queryBizObjInfoById(BizObjInfoId,function(bResult){
				BizObjInfo = bResult;
			});
			dwr.TOPEngine.setAsync(true);
		}
		comtop.UI.scan();
		comtop.UI.scan.setReadonly(true);		
	}
	
	//配置具体可编辑的列及列控件--配置的grid添加了字段
	var edittypeForBizObjDataItem = {
		
	};

	//可编辑列表回显数据，方法名为before+Grid的datasource方法名
	function beforeinitGridData(tableObj,query){
		if(!BizObjInfoId){	  		 
			query.bizObjId = null;  
		}else{
			query.bizObjId = BizObjInfoId;
		}
    }
	
	function btnClose(){
		window.parent.parent.dialog.hide(); 
	}
	
	function clickRow(rowData,isChecked,index){
		cui("#BizObjDataItemGrid").selectRowsByPK(rowData.id);
	}
</script>
<top:script src="/cap/bm/biz/info/js/BizObjInfo.js"/>
</body>
</html>