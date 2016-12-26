<!doctype html>
<%
  /**********************************************************************
	* 功能项列表
	* 2015-12-2 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>功能项列表</title>
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
</style>

<body>
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" id="btnAddFunItem" label="新增功能项" button_type="blue-button" on_click="addFunItem"></span>
			<span uitype="button" id="btnAddSubFunItem" label="新增功能子项" button_type="blue-button" on_click="addSubFunItem"></span> 
			<span uitype="button" id="btnEdit" label="编辑" button_type="blue-button" on_click="editBtn"></span>
			<span uitype="button" id="btnDelete" label="删除" button_type="blue-button" on_click="deleteBtn"></span>
		</div>
	</div>
	<div class="top_content_wrap cui_ext_textmode">
		<table class="form_table" style="table-layout: fixed;">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<td class="divTitle">功能项信息</td>
			</tr>
			<tr>
				<td class="td_label">上级名称：</td>
				<td><span uitype="input" id="domainName" name="domainName" databind="reqFunItem.domainName" maxlength="200" width="85%" readonly="true" ></span></td>
				<td class="td_label">IT实现：</td>
				<td><span uitype="RadioGroup" id="itImp" name="itImp" databind="reqFunItem.itImp" value="0" width="85%" readonly="true">
					<input type="radio" value="0" text="是" />
        			<input type="radio" value="1" text="否" />
				</span></td>
			</tr>
			<tr>
				<td class="td_label">编码：</td>
				<td><span uitype="input" id="code" name="code" databind="reqFunItem.code" maxlength="256" width="85%" readonly="true"></span></td>
				<td class="td_label">名称：</td>
				<td><span uitype="input" id="cnName" name="cnName" databind="reqFunItem.cnName" maxlength="80" width="85%" validate="[{'type':'required', 'rule':{'m': '名称不能为空！'}}]" readonly="true"></span></td>
			</tr>
			<tr>
				<td class="td_label">功能分布：</td>
				<td colspan="3">
					<span id="distributed" uitype="CheckboxGroup" name="distributed" readonly="true">
        				<input type="checkbox" value="GSZB" text="公司总部" />
        				<input type="checkbox" value="CGYTFTP" text="超高压调峰调频" />
        				<input type="checkbox" value="NYGS" text="能源公司" />
       					<input type="checkbox" value="SGS" text="省公司" />
        				<input type="checkbox" value="DSGS" text="地市单位" />
        				<input type="checkbox" value="JCDW" text="基层单位" />
    				</span>
				</td>
			</tr>
			<tr>
				<td class="td_label" valign="top">需求分析：</td>
				<td colspan="3"><span uitype="Textarea" id="reqAnalysis" width="94%" height="50px" maxlength="500" databind="reqFunItem.reqAnalysis" textmode="true"></span></td>
			</tr>
			<tr>
				<td class="td_label" valign="top">功能综述：</td>
				<td colspan="3"><span uitype="Textarea" id="functionDescription" width="94%" height="100px" textmode="true" maxlength="4000" databind="reqFunItem.functionDescription"></span></td>
			</tr>
			<tr>
				<td class="td_label" valign="top">业务流程：</td>
				<td colspan="3"><span uitype="Textarea" id="bizflow" width="85%" height="50px" readonly="true"></span></td>
			</tr>
			<tr>
				<td class="td_label" valign="top">业务事项：</td>
				<td colspan="3"><span uitype="Textarea" id="bizItem" width="85%" height="50px" readonly="true"></span></td>
			</tr>
			<tr>
				<td class="td_label" valign="top">备注：</td>
				<td colspan="3"><span uitype="Textarea" id="remark" width="94%" height="50px" maxlength="500" databind="reqFunItem.remark" textmode="true"></span></td>
			</tr>
		</table>
		
		<div id="relationDiv" align="center">
				<div class="top_header_wrap">
					<div class="divTitle">关系分析(功能项关联)</div>
				</div>
				<div class="relateGrid">
					<table id="relationGrid" uitype="grid" datasource="initData" selectrows="no" primarykey="id" colhidden="false"  resizeheight="resizeHeight" ellipsis="true" resizewidth="resizeWidth">
						<thead>
							<tr>
								<th width="40%" align="center" bindName="name">关系标识</th>
								<th width="30%" align="center" bindName="remark">说明</th>
								<th width="30%" align="center" bindName="reFuntionItemId" render="relationRender">关联范围</th>
							</tr>
						</thead>
					</table>
				</div>
		</div>
<top:script src="/cap/dwr/interface/ReqFunctionItemAction.js"/>
<top:script src="/cap/dwr/interface/ReqFunctionRelAction.js" />
<script language="javascript">
	var ReqFunctionItemId = "<c:out value='${param.ReqFunctionItemId}'/>";
	var reqFunItem={};
	var flowName="";
	var bizItemName="";
	var distributed=[];
	var domainId="";
	window.onload = function(){
		init();
		comtop.UI.scan();	
		if(flowName!=""){
			cui("#bizflow").setValue(flowName);
		}
		if(distributed.length >0){
			cui("#distributed").setValue(distributed);
		}
		if(bizItemName!=""){
			cui("#bizItem").setValue(bizItemName);
		}
		comtop.UI.scan.setReadonly(true);
	}
	
	function init(){
		if(ReqFunctionItemId){
			dwr.TOPEngine.setAsync(false);
			ReqFunctionItemAction.queryReqFunctionItemById(ReqFunctionItemId,function(data){
   				if(data){
   					reqFunItem=data;
   					domainId=data.bizDomainId;
   					if(data.reqFunctionRelFlow){
   						var flowList=data.reqFunctionRelFlow;
   						for(var i=0;i<flowList.length;i++){
   							flowName+=flowList[i].bizFlowName+"；";
   						}
   					}
   					if(data.reqFunctionDistributed){
   						var distributedList=data.reqFunctionDistributed;
   						for(var j=0;j<distributedList.length;j++){
   							distributed[j]=distributedList[j].levelCode;
   						}
   					}
   					if(data.reqFunctionRelItems){
   						var bizItemList=data.reqFunctionRelItems;
   						for(var k=0;k<bizItemList.length;k++){
   							bizItemName+=bizItemList[k].bizItemName+"；";
   						}
   					}
   					domainId=data.bizDomainId;
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//grid数据源
	function initData(tableObj){	
		var reLVO={"functionItemId":ReqFunctionItemId};
		dwr.TOPEngine.setAsync(false);
		ReqFunctionRelAction.queryFunctionRel(reLVO,function(data){
	    	tableObj.setDatasource(data);
			});
		dwr.TOPEngine.setAsync(true);
	}

	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 50;
	}

	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 520;
	}
	
	//编辑功能项基本信息
	function editBtn(){
		var url = "<%=request.getContextPath() %>/cap/bm/req/func/ReqFunctionItemEdit.jsp?ReqFunctionItemId="+ReqFunctionItemId;
		window.location.href = url;
	}
	
	//
	function addFunItem(){
		var parentId=getParentId(ReqFunctionItemId);
		var url = "<%=request.getContextPath() %>/cap/bm/req/func/ReqFunctionItemEdit.jsp?domainId="+domainId;
		window.location.href = url;
	}
	
	//
	function getParentId(childId){
		var parentId;
		dwr.TOPEngine.setAsync(false);
		ReqFunctionItemAction.queryReqFunctionItemById(childId,function(data){
				if(data){
					parentId=data.bizDomainId;
				}
			});
		dwr.TOPEngine.setAsync(true);
		return parentId;
	}
	
	//
	function deleteBtn(){
		if(reqFunItem){
			var result=false;
			dwr.TOPEngine.setAsync(false);
			ReqFunctionItemAction.checkSubFunByFunItem(reqFunItem,function(data){
				result=data;
			});
			dwr.TOPEngine.setAsync(true);
			if(result){
				cui.alert("请先删除该功能项关联的功能子项！");
				return false;
			}
			else{
				cui.confirm("确定删除该功能项吗",{
					onYes:function(){
						dwr.TOPEngine.setAsync(false);
						ReqFunctionItemAction.deleteReqFunctionItem(reqFunItem);
						dwr.TOPEngine.setAsync(true);
						parent.setLeftUrl(reqFunItem.bizDomainId);
						window.parent.cui.message('删除成功。','success');
						}
				});
			}
		}
		else{
			cui.alert("请选择要删除的数据。");
		}
	}
	
	function relationRender(rd, index, col){
		var relDomainId="";
		dwr.TOPEngine.setAsync(false);
		ReqFunctionItemAction.queryReqFunctionItemById(rd['reFuntionItemId'],function(data){
			relDomainId=data.bizDomainId;
		});
		dwr.TOPEngine.setAsync(true);
		if(relDomainId == domainId){
			return "业务域内";
		}
		else{
			return "其他业务域";
		}
	}
	
	function addSubFunItem(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/req/subfunc/ReqFunctionSubitemEdit.jsp?ReqFunctionItemId="+ReqFunctionItemId;
		window.location.href = url;
	}
</script>
<top:script src="/cap/bm/req/func/js/ReqFunctionItemList.js"/>
</body>
</html>