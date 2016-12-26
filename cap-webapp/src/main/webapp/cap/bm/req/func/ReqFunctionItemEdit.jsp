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
		<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"/>
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
			<span uitype="button" id="btnSave" label="保  存" button_type="blue-button" on_click="saveReqFunItem"></span> 
			<span uitype="button" id="btnReturn" label="返 回" button_type="blue-button" on_click="returnBtn"></span>
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
				<td class="td_label">IT实现<span class="top_required">*</span>：</td>
				<td><span uitype="RadioGroup" id="itImp" name="itImp" databind="reqFunItem.itImp" value="0" width="85%">
					<input type="radio" value="0" text="是" />
        			<input type="radio" value="1" text="否" />
				</span></td>
			</tr>
			<tr>
				<td class="td_label">编码：</td>
				<td><span uitype="input" id="code" name="code" databind="reqFunItem.code" width="85%" readonly="true"></span></td>
				<td class="td_label">名称<span class="top_required">*</span>：</td>
				<td><span uitype="input" id="cnName" name="cnName" databind="reqFunItem.cnName" maxlength="80" width="85%" validate="checkName"></span></td>
			</tr>
			<tr>
				<td class="td_label">功能分布：</td>
				<td colspan="3">
					<span id="distributed" uitype="CheckboxGroup" name="distributed">
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
				<td colspan="3"><span uitype="Textarea" id="reqAnalysis" width="94%" height="50px" maxlength="500" databind="reqFunItem.reqAnalysis"></span></td>
			</tr>
			<tr>
				<td class="td_label" valign="top">功能综述：</td>
				<td colspan="3"><span uitype="Editor" id="functionDescription" width="94%" height="100px" maxlength="4000" databind="reqFunItem.functionDescription" toolbars="toolbars"></span></td>
			</tr>
			<tr>
				<td class="td_label">业务流程：</td>
				<td colspan="3"><span uitype="ClickInput" id="bizFlow" width="88%" on_iconclick="chooseBizFlow"></span>
								<span uitype="Button" label="清空" on_click="clearBizFlow" id="clearBizFlowBtn"></span></td>
			</tr>
			<tr>
				<td class="td_label">业务事项：</td>
				<td colspan="3"><span uitype="ClickInput" id="bizItem" width="88%" on_iconclick="chooseBizItem"></span>
								<span uitype="Button" label="清空" on_click="clearBizItem" id="clearBizItemBtn"></td>
			</tr>
			<tr>
				<td class="td_label" valign="top">备注：</td>
				<td colspan="3"><span uitype="Textarea" id="remark" width="95%" height="80px" databind="reqFunItem.remark" maxlength="500"></span></td>
			</tr>
		</table>
		<div id="relationDiv" align="center">
			<div class="top_header_wrap">
				<div class="divTitle">关系分析（功能项关联）</div>
				<div class="thw_operate" id="operateDiv">
					<span uitype="Button" id="addRow" label="新增" icon="plus" on_click="insertRelationRow"></span>
					<span uitype="Button" id="deleteRow" label="删除" icon="minus" on_click="deleteRelationRow"></span>
				</div>
			</div>
			<div class="editGrid">
				<table id="relationGrid" uitype="Grid" datasource="initData" selectrows="multi" primarykey="id" colhidden="false" pagination="false" resizeheight="resizeHeight" ellipsis="false" resizewidth="resizeWidth">
					<thead>
						<tr>
						<th width="5%"></th>
						<th width="15%" align="center" bindName="reFuntionItemName">关联功能项</th>
						<th width="25%" align="center" bindName="name">关系标识</th>
						<th width="30%" align="center" bindName="remark">说明</th>
						<th width="20%" align="center" bindName="bizItemNames">关系来源</th>
						<th width="5%" align="center" renderStyle="text-align: center;" render="operate">操作</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
<top:script src="/cap/dwr/interface/ReqFunctionItemAction.js" />
<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<top:script src="/cap/dwr/interface/BizItemsAction.js" />
<top:script src="/cap/dwr/interface/ReqFunctionRelAction.js" />
<script language="javascript"> 
	var ReqFunctionItemId = "<c:out value='${param.ReqFunctionItemId}'/>";
	var domainId = "<c:out value='${param.domainId}'/>";
	var vNull = [{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}}];
	var reqFunItem={};
	var flowVOList=[];
	var bizVOList=[];
	var flowName="";
	var bizItemName="";
	var distributed=[];
	var bizItemIdListChooseByFlow=[];
	var bizItemIdList=[];
	var checkName=[{'type':'custom','rule':{'against':'isBlank', 'm':'不能为空'}},
	               {'type':'custom','rule':{'against':'checkFunItemName', 'm':'名称已存在，请使用其他名称'}}
	               ]
	window.onload = function(){
		if(domainId){
			dwr.TOPEngine.setAsync(false);
   			BizDomainAction.queryDomainById(domainId,function(data){
   				if(data){
   					reqFunItem.domainName=data.name;
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
		}
		init();
		comtop.UI.scan();
		if(flowName!=""){
			cui("#bizFlow").setValue(flowName);
			cui("#clearBizFlowBtn").show();
		}
		else{
			cui("#clearBizFlowBtn").hide();
		}
		if(distributed.length >0){
			cui("#distributed").setValue(distributed);
		}
		if(bizItemName!=""){
			cui("#bizItem").setValue(bizItemName);
			cui("#clearBizItemBtn").show();
		}
		else{
			cui("#clearBizItemBtn").hide();
		}
		if(ReqFunctionItemId){
			cui("#addRow").show();
			cui("#deleteRow").show();
		}
		else{
			cui("#addRow").hide();
			cui("#deleteRow").hide();
		}
	}
	
	//返回按钮
	function returnBtn(){
		if(ReqFunctionItemId){
			var url = "<%=request.getContextPath()%>/cap/bm/req/func/ReqFunctionItemList.jsp?ReqFunctionItemId="+ReqFunctionItemId;
			window.location.href = url;
		}
		else{
			parent.setLeftUrl(domainId);
		}
	}
	
	function init(){
		if(ReqFunctionItemId){
			dwr.TOPEngine.setAsync(false);
			ReqFunctionItemAction.queryReqFunctionItemById(ReqFunctionItemId,function(data){
   				if(data){
   					reqFunItem=data;
   					if(data.reqFunctionRelFlow){
   						flowVOList=data.reqFunctionRelFlow;
   						for(var i=0;i<flowVOList.length;i++){
   							flowName+=flowVOList[i].bizFlowName+";";
   						}
   					}
   					if(data.reqFunctionDistributed){
   						var distributedList=data.reqFunctionDistributed;
   						for(var j=0;j<distributedList.length;j++){
   							distributed[j]=distributedList[j].levelCode;
   						}
   					}
   					if(data.reqFunctionRelItems){
   						bizVOList=data.reqFunctionRelItems;
   						for(var k=0;k<bizVOList.length;k++){
   							bizItemName+=bizVOList[k].bizItemName+";";
   						}
   					}
   					domainId=data.bizDomainId;
   				}
   			});
   			dwr.TOPEngine.setAsync(true);
		}
	}
	
	//保存功能项
	function saveReqFunItem(){
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
		reqFunItemVO=cui(reqFunItem).databind().getValue();
		reqFunItemVO.cnName=trim(reqFunItemVO.cnName);
		if(!reqFunItemVO.id){
			reqFunItemVO.bizDomainId=domainId;
			reqFunItemVO.dataFrom=0;
		}
		if(cui("#bizFlow").getValue()){
			reqFunItemVO.reqFunctionRelFlow=flowVOList;
		}
		else{
			reqFunItemVO.reqFunctionRelFlow=null;
		}
		if(cui("#bizItem").getValue()){
			reqFunItemVO.reqFunctionRelItems=bizVOList;
		}else{
			reqFunItemVO.reqFunctionRelItems=null;
		}
		if(cui("#distributed").getValue()){
			var reqFunctionDistributed=new Array();
			var distributed={}
			var distributedList=cui("#distributed").getValue();
			for(var i=0;i<distributedList.length;i++){
				distributed={"levelCode":distributedList[i],"relation":"1"};
				reqFunctionDistributed.push(distributed);
			}
			reqFunItemVO.reqFunctionDistributed=reqFunctionDistributed;
		}
		dwr.TOPEngine.setAsync(false);
   		ReqFunctionItemAction.saveReqFunctionItem(reqFunItemVO,function(data){
			if(data){
				if(reqFunItemVO.id){
					window.parent.cui.message('保存成功。','success');
				}
				else{
					window.parent.cui.message('新增成功。','success');
				}
				ReqFunctionItemId=data;
				parent.setLeftUrl(data);
			}
		});
		dwr.TOPEngine.setAsync(true);
		returnBtn();
	}
	
	//空格过滤
	function isBlank(data){
		if(data.replace(/\s/g, "")==""){
			return false;
		}
		return true;
	}
	
	//去左右空格;
 	function trim(str){
 	    return str.replace(/(^\s*)|(\s*$)/g, "");
 	}
 	
 	//选择业务流程事件
 	function chooseBizFlow(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/flow/chooseMulProcess.jsp?domainId="+domainId;
		var title="选择业务流程";
		var height = 800;
		var width =  800;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
 	
 	//选择业务流程回调
 	function chooseFlowCallBack(flowList){
 		if(flowList){
 			var flowNameList="";
 			var flowVO={};
 			bizItemIdListChooseByFlow=[];
 			for(var i=0;i<flowList.length;i++){
 				flowNameList+=flowList[i].processName+";";
 				if(flowList[i].itemsId){
 					bizItemIdListChooseByFlow.push(flowList[i].itemsId);
 				}
 				flowVO={"bizFlowId" : flowList[i].id};
 				flowVOList.push(flowVO);
 			}
 			cui("#bizFlow").setValue(flowNameList);
 			if(bizItemIdListChooseByFlow.length>0){
 				bizItemIdListChooseByFlow=unique(bizItemIdListChooseByFlow);
 				setBizItemByFlow(bizItemIdListChooseByFlow);
 			}
 			cui("#clearBizFlowBtn").show();
 		}
 		else{
 			cui("#clearBizFlowBtn").hide();
 		}
 	}
 	
 	//通过业务流程获取所属事项并设值
 	function setBizItemByFlow(itemIdList){
 		var itemName="";
 		bizVOList=[];
 		for(var i=0;i<itemIdList.length;i++){
 			dwr.TOPEngine.setAsync(false);
 	 		BizItemsAction.queryBizItemsById(itemIdList[i],function(data){
 	 			itemName+=data.name+";";
 	 		});
 	 		dwr.TOPEngine.setAsync(true);
			bizVO={"bizItemsId" : itemIdList[i]};
			bizVOList.push(bizVO);
 		}
 		cui("#bizItem").setValue(itemName);
 		cui("#clearBizItemBtn").show();
 	}
 	
 	//选择业务事项事件
 	function chooseBizItem(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/item/chooseMulBizItem.jsp?selectItemIdList="+bizItemIdList+"&domainId="+domainId;
		var title="选择业务事项";
		var height = 800;
		var width =  800;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
 	
 	//选择业务事项回调
 	function chooseBizItemCallback(bizList){
 		if(bizList){
 			var bizNameList="";
 			var bizVO={};
 			bizItemIdList=[];
 			for(var j=0;j<bizItemIdListChooseByFlow.length;j++){
 				bizItemIdList.push(bizItemIdListChooseByFlow[j]);
 			}
 			for(var i=0;i<bizList.length;i++){
 				bizItemIdList.push(bizList[i].id);
 			}
 			bizItemIdList=unique(bizItemIdList);
 			setBizItemByFlow(bizItemIdList);
 			cui("#clearBizItemBtn").show();
 		}
 		else{
 			cui("#clearBizItemBtn").hide();
 		}
 	}
 	
 	//数组去重
 	function unique(array)
 	{
 		var n = {},r=[]; //n为hash表，r为临时数组
 		for(var i = 0; i < array.length; i++) //遍历当前数组
 		{
 			if (!n[array[i]]) //如果hash表中没有当前项
 			{
 				n[array[i]] = true; //存入hash表
 				r.push(array[i]); //把当前数组的当前项push到临时数组里面
 			}
 		}
 		return r;
 	}
 	
 	//grid数据源
	function initData(tableObj,query){
		var reLVO={"functionItemId":ReqFunctionItemId};
		dwr.TOPEngine.setAsync(false);
		ReqFunctionRelAction.queryFunctionRel(reLVO,function(data){
	    	tableObj.setDatasource(data);
			});
		dwr.TOPEngine.setAsync(true);
	}

	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 80;
	}

	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 520;
	}
	
	//新增关系分析行
	function insertRelationRow(){
		if(ReqFunctionItemId){
			var url = "${pageScope.cuiWebRoot}/cap/bm/req/func/ReqInsertFunItemRel.jsp?ReqFunctionItemId="+ReqFunctionItemId+"&domainId="+reqFunItem.bizDomainId;
			var title="关系分析编辑界面";
			var height = 600;
			var width =  800;
			
			dialog = cui.dialog({
				title : title,
				src : url,
				width : width,
				height : height
			})
			dialog.show(url);
		}
		else{
			cui.alert("请先创建好功能项后在添加关系分析");
		}
	}
	
	//删除关系分析行
	function deleteRelationRow(){
		var selects = cui("#relationGrid").getSelectedRowData();
		if(selects.length==0){
			cui.alert("请选择要删除的数据。");
			return;
		}
		cui.confirm("确定要删除这"+selects.length+"条数据吗?",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				ReqFunctionRelAction.deleteFunctionRel(selects);
				dwr.TOPEngine.setAsync(true);
				cui.message('删除成功。','success');
				cui("#relationGrid").loadData();
				}
			});
	}
	
	//回调刷新grid
	function refleshGrid(){
		cui.message('保存成功。','success');
		cui("#relationGrid").loadData();
	}
	
	//操作行渲染
	function operate(rd, index, col){
		return "<a href='javascript:;' onclick='editRel(\"" +rd['id']+"\");'>" + "修改" + "</a>";
	}
	
	//关系分析编辑
	function editRel(id){
		var url = "${pageScope.cuiWebRoot}/cap/bm/req/func/ReqInsertFunItemRel.jsp?relId="+id+"&ReqFunctionItemId="+ReqFunctionItemId;
		var title="编辑界面";
		var height = 600;
		var width =  800;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//清空业务流程
	function clearBizFlow(){
		cui("#bizFlow").setValue("");
		flowVOList=[];
		cui("#clearBizFlowBtn").hide();
	}
	
	//清空业务事项
	function clearBizItem(){
		cui("#bizItem").setValue("");
		cui("#clearBizItemBtn").hide();
	}
	
	//功能项名称查重
	function checkFunItemName(data){
		data=trim(data);
		var strResult=false;
		var funcitemVO={};
		if(ReqFunctionItemId){
			funcitemVO=reqFunItem
		}
		else{
			funcitemVO.bizDomainId=domainId;
		}
		funcitemVO.cnName=data;
		dwr.TOPEngine.setAsync(false);
		ReqFunctionItemAction.checkFuncItemName(funcitemVO,function(result){
			strResult=result;
		});
		dwr.TOPEngine.setAsync(true);
		return strResult;
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
	           ]];
</script>
<top:script src="/cap/bm/req/func/js/ReqFunctionItemEdit.js"/>
</body>
</html>