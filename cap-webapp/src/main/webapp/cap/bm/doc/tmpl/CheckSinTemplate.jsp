<!doctype html>
<%
  /**********************************************************************
	* 文档模板列表
	* 2015-11-9 CAP 新增
  **********************************************************************/
%>
<%@ include file="/top/component/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>文档模板列表</title>
    <top:link href="/cap/bm/common/styledefine/css/top_base.css" />
	<top:link href="/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
</head>

<style>
.btn-more:hover { color: #1c0ba1; background-color: #c0cef5;}
.btn-more {border: 1px solid #C4D5E9;background-color: #EBF0F5;color: #2164A1;padding: 0 4px;height: 24px;line-height: 24px;margin: 1px 5px 3px 0;cursor: pointer;border-radius: 4px;float: right;font-size : 12px;}

</style>

<body style="overflow-y:hidden;">
<div class="list_header_wrap" style="padding-left:10px;">
	<div id="queryDiv">
		 <table id="select_condition">
	    	<tbody>
				<tr>
					<td class="td_label"  width="15%"><span class="hide_span">文档类型：</span></td>
					<td	width="30%"><span class="hide_span"><span uitype="PullDown" width="85%" label_field="text" dictionary="DOC_TEMPLATE" on_change="search" value_field="id" must_exist="true" editable="true" mode="Single" empty_text="请选择" id="type" height="200" auto_complete="false" filter_fields="[]" value="'<c:out value='${param.type}'/>'" databind="CapDocTemplate.type" readonly="false" datasource="[]" select="-1"></span></span></td>
					<td>&nbsp;&nbsp;</td>
					<td>
						<div class="top_float_left">
							<span uitype="button" id="search_btn" label="查询" on_click="search" button_type="green-button"
								icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/search.gif"></span>
							<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch" button_type="orange-button"
								icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/clear.gif"></span>
						</div>
					</td>
				</tr>
			</tbody>
	    </table>
	</div>

	
		<div id="buttonDiv" class="top_float_right">
			<span uitype="button" on_click="btnCheck" id="btnCheck" hide="false" button_type="blue-button" disable="false" label="确定"></span> 
			<span uitype="button" on_click="btnClose" id="btnClose" hide="false" button_type="blue-button" disable="false" label="关闭"></span>
		</div>
			<table uitype="Grid" id="CapDocTemplateGrid" gridheight="500px" ellipsis="true" colhidden="true" pageno="1" colmaxheight="auto" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="single" datasource="initData" fixcolumnnumber="0" adaptive="true" resizeheight="resizeHeight" titleellipsis="true" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" selectedrowclass="selected_row" colmove="false" primarykey="id" onstatuschange="onstatuschange" pagination="true" pagesize="50" oddevenrow="false">
			 	<tr>
					<th style="width:30px"></th>
					<th id="" bindName="" render="" renderStyle="text-align: center;" style="width:5%;">序号</th>
					<th id="" bindName="name" sort="true" render="viewLinkRender" renderStyle="text-align: left;" style="width:20%;">名称</th>
					<th id="" bindName="type" sort="true" render="typeSysRender" renderStyle="text-align: left;" style="width:15%;">文档类型</th>
					<th id="" bindName="path" sort="true" renderStyle="text-align: left;" style="width:20%;">存储地址</th>
					<th id="" bindName="remark" sort="true" renderStyle="text-align: left;" style="width:30%;">说明</th>
				</tr>
			</table>
</div>
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" />
	<top:script src="/cap/bm/common/cui/js/cui.utils.js" />
    <top:script src="/top/js/jquery.js"/>
	<top:script src="/cap/dwr/engine.js"/>
	<top:script src="/cap/dwr/util.js"/>
	<top:script src="/cap/dwr/interface/CapDocTemplateAction.js"/>

<script language="javascript">
	var CapDocTemplate = {};
	
	var type = "<c:out value='${param.type}'/>";
	
	window.onload = function(){
		comtop.UI.scan();	
		if(type){
			cui("#type").setValue(type);
			search();
		}
	}
	var dataCount = 0;
	var typeSysRenderDatalist;
	//grid数据源
	function initData(tableObj,query){	
		if (typeof(beforeInitData) == "function") {
			eval("beforeInitData(tableObj,query)");
		}

		if (typeof(myBeforeInitData) == "function") {
			eval("myBeforeInitData(tableObj,query)");
		}
		//获取数据时，先找到定义的数据字典值集合
		setRenderDataList();
		
		query.sortFieldName = query.sortName[0];
		query.sortType = query.sortType[0];
		dwr.TOPEngine.setAsync(false);
		CapDocTemplateAction.queryCapDocTemplateList(query,function(data){
			dataCount = data.count;
		    tableObj.setDatasource(data.list, data.count);
		    maxSortNo = dataCount;
		});
		dwr.TOPEngine.setAsync(true);

		if (typeof(myAfterInitData) == "function") {
			eval("myAfterInitData(tableObj,query)");
		}
	}
	
	//数据字典值集合
	function setRenderDataList(){
		$.ajax({
	            url: "<c:out value='${pageScope.cuiWebRoot}'/>/top/cfg/getAllValue.ac",
	            data: "&fullcode=DOC_TEMPLATE",
	            dataType:"json",
	            async: false,
	            success: function(data){
	            	typeSysRenderDatalist = data;
	            }
	   });
	}
	
	function isExitsFunction(funcName) {
	    try {
	        if(typeof(eval(funcName)) == "function") {
	            return true;
	        }
	    } catch(e) {}
	    return false;
	}
	
	function rowNoRender(rowData, index, colName){
		return index+1;
	}
	
	/**
     * 配合下一个方法config做列宽的持久化
     */
	function onstatuschange(config){
		var seesionUrl = window.location.pathname + 'CapDocTemplate';
		cui.utils.setCookie(seesionUrl,config,new Date(2100,10,10).toGMTString(), '/');
	}
	
	/**
     * 配合下一个方法onstatuschange做列宽的持久化
     */
	function config(obj){
		var seesionUrl = window.location.pathname +'CapDocTemplate';
		obj.setConfig(cui.utils.getCookie(seesionUrl));
	}
		
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(CapDocTemplate).databind().getValue();
        //设置Grid的查询条件
        cui('#CapDocTemplateGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#CapDocTemplateGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
        cui(CapDocTemplate).databind().setEmpty();
        search();
    }
    
	/**
	 * 控制对象显示或隐藏
	 */
	function controlObjectShowHide(isShow, obj){
		if ( isShow ){
			obj.show();
		}else{
			obj.hide();
		}
	}
     
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//选择事件
	function btnCheck(){
		var result = true;
		if(!result && typeof(result) != "undefined"){
			return;
		}
		var selects = cui("#CapDocTemplateGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择数据。");
			return;
		}
		window.parent.dialog.hide(); 
	}
	
	function btnClose(){
		window.parent.dialog.hide(); 
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
		return (document.documentElement.clientHeight || document.body.clientHeight) - existingHeight;
	}
	
	function typeSysRender(rd, index, col){
		var finalValue = rd[col.bindName];
		if(finalValue == undefined || finalValue==null){
			return;
		}
		if(!typeSysRenderDatalist){
			return "";
		}
		var valueList = [finalValue];
		if(typeof(finalValue)==="string" && finalValue.indexOf(";")>0){
			valueList = finalValue.split(";");
		}
		var text = "";
		for(var i = 0; i < valueList.length; i++ ){
			var v = valueList[i];
			for(var t in typeSysRenderDatalist){
				if(typeSysRenderDatalist[t].id == v || typeSysRenderDatalist[t].value == v){
					if(i>0 && text){
						text += ";";
					}
					text += typeSysRenderDatalist[t].text;
				}
			}
		}
		if(!text && finalValue){
			text = finalValue;
		}
			return text;
	}
	
		//列表初始化前处理事件
	function beforeInitData(tableObj,query){
    }
</script>
</body>
</html>