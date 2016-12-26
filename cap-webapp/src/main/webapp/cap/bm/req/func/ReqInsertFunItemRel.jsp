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
<title>功能项编辑</title>
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
.top_header_wrap{
				margin-right:28px;
				margin-top: 4px;
				margin-bottom:4px;
}
</style>
<body>
	<div class="top_header_wrap">
		<div class="thw_operate">
			<span uitype="button" id="btnSave" label="确 定" on_click="saveReqFunRel"></span> 
			<span uitype="button" id="btnReturn" label="关 闭" on_click="returnBtn"></span>
		</div>
	</div>
	<div class="top_content_wrap">
		<table class="form_table" style="table-layout: fixed;">
			<colgroup>
				<col width="15%" />
				<col width="85%" />
			</colgroup>
			<tr>
				<td class="td_label">关联功能项<span class="top_required">*</span>：</td>
				<span uitype="input" type="hidden" id="reFuntionItemId" name="reFuntionItemId" databind="reqFunItemRel.reFuntionItemId"></span>
				<td><span uitype="ClickInput" id="reFuntionItemName" databind="reqFunItemRel.reFuntionItemName" width="85%" on_iconclick="chooseRelFunItem" on_change="setRelName" validate="checkRelFunction"></span></td>
			</tr>
				<td class="td_label">关系标识<span class="top_required">*</span>：</td>
				<td><span uitype="input" id="name" databind="reqFunItemRel.name" maxlength="80" width="85%" validate="vNull"></span></td>
			</tr>
			<tr>
				<td class="td_label">关系来源（业务事项）：</td>
				<span uitype="input" type="hidden" id="bizItemIds" databind="reqFunItemRel.bizItemIds"></span>
				<td><span uitype="ClickInput" id="bizItemNames" databind="reqFunItemRel.bizItemNames" width="85%" on_iconclick="chooseBizRelInfo"></span></td>
			</tr>
			<tr>
				<td class="td_label">说明：</td>
				<td><span uitype="Textarea" id="remark" databind="reqFunItemRel.remark" maxlength="500" width="85%" height="150"></span></td>
			</tr>
		</table>
	</div>
<top:script src="/cap/dwr/interface/ReqFunctionRelAction.js" />
<top:script src="/cap/dwr/interface/ReqFunctionItemAction.js" />
<script language="javascript"> 
	var ReqFunctionItemId = "<c:out value='${param.ReqFunctionItemId}'/>";
	var domainId = "<c:out value='${param.domainId}'/>";
	var relId = "<c:out value='${param.relId}'/>";
	var relFunItemName;
	var relFunItemId;
	var reqFunItemRel={};
	var vNull = [{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}}];
	var checkRelFunction=[{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}},
	                      {'type':'custom','rule':{'against':'checkRelFunItemId', 'm':'此功能项已关联，请勿重复关联'}}];
	window.onload = function(){
		init();
		comtop.UI.scan();
	}
	
	function init(){
		if(relId){
			dwr.TOPEngine.setAsync(false);
			ReqFunctionRelAction.queryFunctionRelById(relId,function(data){
   				if(data){
   					reqFunItemRel=data;
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
		}
	}
	
	function chooseRelFunItem(event,self){
		var url = "${pageScope.cuiWebRoot}/cap/bm/req/func/ReqFunItemTreeForChoose.jsp";
		var title="选择";
		var height = 400;
		var width =  350;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	function chooseBizRelInfo(event,self){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/item/chooseMulBizItem.jsp?domainId="+domainId;
		var title="选择业务事项";
		var height = 600;
		var width =  550;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	function chooseFunItemCallBack(name,id){
		if(id===ReqFunctionItemId){
			cui.alert("无法关联当前功能项本身!");
			return;
		}
		else{
			relFunItemName=name;
			relFunItemId=id;
			cui("#reFuntionItemName").setValue(relFunItemName);
		}
	}
	//选择业务事项回调
 	function chooseBizItemCallback(bizList){
 		if(bizList){
 			var bizItemNames="";
 			var bizItemIds="";
 			bizItemIdList=[];
 			for(var i=0;i<bizList.length;i++){
 				bizItemNames+=bizList[i].name+";";
 				bizItemIds+=bizList[i].id+";";
 			}
 			cui("#bizItemNames").setValue(bizItemNames);
 			cui("#bizItemIds").setValue(bizItemIds);
 		}
 	}
	//
	function saveReqFunRel(){
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
		reqFunItemRel=cui(reqFunItemRel).databind().getValue();
		if(!relId){
			reqFunItemRel.reFuntionItemId=relFunItemId;
		}
		reqFunItemRel.functionItemId=ReqFunctionItemId;
		dwr.TOPEngine.setAsync(false);
		ReqFunctionRelAction.saveFunctionRel(reqFunItemRel);
		dwr.TOPEngine.setAsync(true);
		parent.refleshGrid();
		returnBtn();
	}
	
	//
	function setRelName(event,self){
		var str=relFunItemName+"->";
		dwr.TOPEngine.setAsync(false);
		ReqFunctionItemAction.queryReqFunctionItemById(ReqFunctionItemId,function(data){
			str+=data.cnName;
   		});
   		dwr.TOPEngine.setAsync(true);
   		cui("#name").setValue(str);
	}
	
	function returnBtn(){
		parent.dialog.hide();
	}
	
	//空格过滤
	function isBlank(data){
		if(data.replace(/\s/g, "")==""){
			return false;
		}
		return true;
	}
	
	function checkRelFunItemId(data){
		var relFunctionItem={};
		relFunctionItem.functionItemId=ReqFunctionItemId;
		relFunctionItem.reFuntionItemId=relFunItemId;
		var result;
		dwr.TOPEngine.setAsync(false);
		ReqFunctionRelAction.checkRelFunctionItemId(relFunctionItem,function(data){
			result=data;
		});
		dwr.TOPEngine.setAsync(true);
		return result;
	}
	
</script>
</body>
</html>