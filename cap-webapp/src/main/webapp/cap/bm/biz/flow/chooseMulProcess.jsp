<%
  /**********************************************************************
	* CIP元数据建模----服务新增
	* 2015-6-30 李小芬 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<!doctype html>
<html>
<head>
<title>服务新增</title>
    <top:link href="/cap/bm/common/top/css/top_base.css" />
	<top:link href="/cap/bm/common/top/css/top_sys.css" />
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
	<top:script src="/cap/bm/common/top/js/jquery.js" />
	<top:script src="/cap/bm/common/js/capCommon.js" />
	<top:script src="/cap/dwr/engine.js" />
	<top:script src="/cap/dwr/util.js" />
</head>
<style>
.btn-more:hover { color: #1c0ba1; background-color: #c0cef5;}
.btn-more {border: 1px solid #C4D5E9;background-color: #EBF0F5;color: #2164A1;padding: 0 4px;height: 24px;line-height: 24px;margin: 1px 5px 3px 0;cursor: pointer;border-radius: 4px;float: right;font-size : 12px;}
.top_float_right{
	margin-top:4px;
	margin-bottom:4px;
}
</style>
<body style="overflow-y:hidden;">
<div class="list_header_wrap" style="padding-left:10px;">
			<div id="queryDiv">
				 <table id="select_condition">
			    	<tbody>
						<tr>
							<td class="td_label"  width="15%">所属业务域：</td>
							<td	width="30%"><span id="domainId" uitype="ClickInput"  on_change="search" icon="th-list" on_iconclick="chooseDomain" databind="roleInfo.domain"></span></td>
							<td class="td_label" width="15%"><span>名称：</span></td>
							<td width="30%" ><span uitype="Input" id="processName" maxlength="200" byte="true" textmode="false" width="85%" align="left" databind="roleInfo.processName" type="text"></span></td>
						</tr>
					</tbody>
			    </table>
			</div>
			<div id="buttonDiv" class="top_float_right">
				<span uitype="button" id="search_btn" label="查询" on_click="search" ></span>
				<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch"></span>
				<span uitype="button" on_click="btnCheck" id="btnCheck" label="确定"></span> 
				<span uitype="button" on_click="btnClose" id="btnClose" label="关闭"></span>
			</div>
			<table uitype="Grid" id="BizFlowGrid" adaptive="true" resizeheight="resizeHeight" lazy="true" resizewidth="resizeWidth" primarykey="id" onstatuschange="onstatuschange" pagination="false"  gridheight="500px" ellipsis="true" gridwidth="600px" selectrows="multi" datasource="initData">
			 	<tr>
					<th style="width:10%;"><input type="checkbox"/></th>
					<th bindName="processName"  renderStyle="text-align: left;" style="width:10%;">名称</th>
					<th bindName="code" renderStyle="text-align: left;" style="width:10%;">流程编码</th>
					<th bindName="processId" renderStyle="text-align: left;" style="width:10%;">流程ID</th>
					<th bindName="processDef" renderStyle="text-align: left;" style="width:20%;">流程定义</th>
					<th bindName="workDemand" renderStyle="text-align: left;" style="width:20%;">工作要求</th>
					<th bindName="workContext" renderStyle="text-align: left;" style="width:20%;">工作内容</th>
				</tr>
			</table>
</div>
<top:script src="/cap/dwr/interface/BizProcessInfoAction.js" />
<top:script src="/cap/dwr/interface/BizDomainAction.js" />
<script type="text/javascript">
	//业务域ID
	var domainId = "${param.domainId}";
	//业务事项ID
	var selItemsId = "${param.selItemsId}";
	var domainVO={};
	//初始化
	window.onload = function(){
		comtop.UI.scan();
		if(domainId){
			dwr.TOPEngine.setAsync(false);
			BizDomainAction.queryDomainById(domainId,function(data){
				domainVO=data;
			});
			dwr.TOPEngine.setAsync(true);
			cui("#domainId").setValue(domainVO.name);
			search();
		}
	}
	
	function initData(tableObj,query){
		dwr.TOPEngine.setAsync(false);
			BizProcessInfoAction.queryBizProcessInfoList(query,function(data){
				   tableObj.setDatasource(data.list);
			});
		dwr.TOPEngine.setAsync(true);
	}

	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}

	//grid高度
	function resizeHeight(){
		var queryDiv = $("#queryDiv");
		var buttonDiv = $("#buttonDiv");
		var existingHeight = 0;
		if(queryDiv){
			existingHeight = queryDiv[0].clientHeight;
		}
		if(buttonDiv){
			existingHeight += buttonDiv[0].clientHeight;
		}
		return (document.documentElement.clientHeight || document.body.clientHeight) - existingHeight-100;
	}
	
	function chooseDomain(){
		var url = "${pageScope.cuiWebRoot}/cap/bm/biz/domain/jsp/DomainTree.jsp?selectDomainId="+domainId;
		var title="选择业务域";
		var height = 400;
		var width =  300;
		
		dialog = cui.dialog({
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	function chooseDomainCallback(domainId,domainName){
		cui("#domainId").setValue(domainName);
		var domain={'id':domainId,'name':domainName};
		domainVO=domain;
		domainId=domainId;
		search();
	}
	
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(roleInfo).databind().getValue();
        if(domainVO){
        	data.domainId=domainVO.id;
        }
        //设置Grid的查询条件
        cui('#BizFlowGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#BizFlowGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
        cui(roleInfo).databind().setEmpty();
        domainVO.id=null;
        search();
    }
	
  //选择事件
	function btnCheck(){
		var result = true;
		if(!result && typeof(result) != "undefined"){
			return;
		}
		var selects = cui("#BizFlowGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择数据。");
			return;
		}
		window.parent.chooseFlowCallBack(selects);
		btnClose(); 
	}
	
	function btnClose(){
		window.parent.dialog.hide(); 
	}
</script>
</body>
</html>