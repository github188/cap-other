<!doctype html>
<%
  /**********************************************************************
	* 公告基本信息列表
	* 2015-9-25 CAP 新增
  **********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ include file="/cap/bm/common/taglib/ExtendTaglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
    <title>公告基本信息列表</title>
    <top:link href="/cap/bm/common/top/css/top_base.css" />
	<top:link href="/cap/bm/common/top/css/top_sys.css" />
	<top:link href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:link href="/cap/bm/common/styledefine/css/public.css"/>
	<top:link href="/cap/bm/common/cui/themes/smartGrid/css/comtop.ui.min.css"/>
	<top:link href="/top/sys/usermanagement/orgusertag/css/choose.css"/>
</head>

<style>
.btn-more:hover { color: #1c0ba1; background-color: #c0cef5;}
.btn-more {border: 1px solid #C4D5E9;background-color: #EBF0F5;color: #2164A1;padding: 0 4px;height: 24px;line-height: 24px;margin: 1px 5px 3px 0;cursor: pointer;border-radius: 4px;float: right;font-size : 12px;}
					th{
    font-weight: bold;
    font-size:14px;
}
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
					<td class="td_label" width="15%"><span>公告标题：</span></td>
					<td width="30%" ><span uitype="Input" id="title" maxlength="200" byte="true" textmode="false" width="85%" align="left" maskoptions="{}" databind="CapPtcNotice.title" type="text" readonly="false"></span></td>
<!-- 					<td class="td_label" width="15%"><span>公告类型：</span></td> -->
<!-- 					<td width="30%" ><span uitype="PullDown" select="-1" width="85%" label_field="text" value_field="id" must_exist="true" editable="true" mode="Single" empty_text="请选择" id="type" height="200" auto_complete="false" filter_fields="[]" databind="CapPtcNotice.type" readonly="false" datasource="typeData"</span></td> -->
					<td class="td_label" width="15%"><span>公告创建人：</span></td>
					<td width="30%" ><span uitype="ClickInput" id="creator" name="creator"  databind="CapPtcNotice.creator" on_iconclick="chooseCreator" on_focus="chooseCreator"></span></td>
				</tr>
				<tr>
					<td class="td_label" width="15%"><span>创建时间：</span></td>
					<td width="30%" ><span uitype="Calender" model="date" clearbtn="true" width="41%" format="yyyy-MM-dd hh:mm" panel="1" trigger="click" icon="true" id="cdtStart" okbtn="false" databind="CapPtcNotice.cdtStart" zindex="9999" ></span>~<span uitype="Calender" id="cdtEnd" databind="CapPtcNotice.cdtEnd" panel="1" trigger="click" icon="true" model="date" clearbtn="true" width="41%" zindex="9999" format="yyyy-MM-dd hh:mm" mindate="#cdtStart"></span>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;</td>
					<td>
					</td>
				</tr>
			</tbody>
	    </table>
	</div>

	
		<div id="buttonDiv" class="top_float_right">
		<span uitype="button" on_click="btnAdd" id="btnAdd" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/add_white.gif" hide="false" button_type="blue-button" disable="false" label="新增"></span> 
		<span uitype="button" on_click="btnDelete" id="btnDelete" icon="${pageScope.cuiWebRoot}/cap/bm/common/cui/themes/smartGrid/images/button/delete_white.gif" hide="false" button_type="blue-button" disable="false" label="删除"></span> 
		<span uitype="button" id="search_btn" label="查询" on_click="search" button_type="green-button"
			  icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/search.gif"></span>
		<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch" button_type="orange-button"
			   icon="<c:out value='${pageScope.cuiWebRoot}'/>/cap/bm/common/cui/themes/smartGrid/images/button/clear.gif"></span>
		</div>
			<table uitype="Grid" id="CapPtcNoticeGrid" titleellipsis="true" resizeheight="resizeHeight" sorttype="[]" sortname="[]" resizewidth="resizeWidth" loadtip="true" pagesize_list="[25, 50, 100]" colmove="false" selectedrowclass="selected_row" primarykey="id" onstatuschange="onstatuschange" pagination="true" oddevenrow="false" pagesize="50" ellipsis="true" colhidden="true" pageno="1" colmaxheight="auto" gridwidth="600px" pagination_model="pagination_min_1" config="config" oddevenclass="cardinal_row" sortstyle="1" selectrows="multi" datasource="initData" fixcolumnnumber="0" adaptive="true" gridheight="500px">
			 	<tr>
					<th style="width:30px"><input type="checkbox"/></th>
					<th bindName="title" render="editLinkRender" renderStyle="text-align: left;">公告标题</th>
					<th bindName="type" render="typeSysRender" renderStyle="text-align: left;">公告类型</th>
					<th bindName="creatorName" render="" renderStyle="text-align: left;">公告创建人</th>
					<th bindName="cdt" format="yyyy-MM-dd hh:mm:ss" render="" renderStyle="text-align: center;">创建时间</th>
				</tr>
			</table>
</div>
	<top:script src="/cap/bm/common/cui/js/comtop.ui.min.js" />
	<top:script src="/cap/bm/common/cui/js/comtop.ui.editor.min.js"/>
	<top:script src="/cap/dwr/engine.js" />
	<top:script src="/cap/dwr/util.js" />
	<top:script src="/cap/bm/common/top/js/jquery.js" />
	<top:script src="/cap/bm/common/js/capCommon.js" />
	<top:script src="/cap/bm/common/cui/js/cui.extend.dictionary.js" />
	<top:script src="/cap/bm/common/cui/js/cui.utils.js" />
    <top:script src="/top/js/jquery.js"/>
	<top:script src="/cap/dwr/interface/CapPtcNoticeAction.js"/>
	<top:script src="/top/sys/usermanagement/orgusertag/js/choose.js"/>
	<top:script src="/top/sys/dwr/interface/ChooseAction.js"/>
<script language="javascript">
	var CapPtcNotice = {};
	var creator={};
	 var typeData = [
	             {id:'item1',text:'选项1'},
	             {id:'item2',text:'选项2'},
	             {id:'item3',text:'选项3'},
	             {id:'item4',text:'选项4'},
	             {id:'item5',text:'选项5'},
	             {id:'item6',text:'选项6'},
	             {id:'item7',text:'选项7'},
	             {id:'item8',text:'选项8'}
	         ];
	window.onload = function(){
		hiddenQueryAreaTr();
		comtop.UI.scan();	
	}
	
	var dataCount = 0;
	var typeSysRenderDatalist;
	//grid数据源
	function initData(tableObj,query){	
		//获取数据时，先找到定义的数据字典值集合
		setRenderDataList();
		
		query.sortFieldName = "cdt";
		query.sortType = "DESC";
		dwr.TOPEngine.setAsync(false);
		CapPtcNoticeAction.queryCapPtcNoticeList(query,function(data){
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
			if(isExitsFunction(typeData)){
				typeSysRenderDatalist =typeData;
			}else{
				typeSysRenderDatalist =typeData;
			}
		
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
		var seesionUrl = window.location.pathname + 'CapPtcNotice';
		cui.utils.setCookie(seesionUrl,config,new Date(2100,10,10).toGMTString(), '/');
	}
	
	/**
     * 配合下一个方法onstatuschange做列宽的持久化
     */
	function config(obj){
		var seesionUrl = window.location.pathname +'CapPtcNotice';
		obj.setConfig(cui.utils.getCookie(seesionUrl));
	}
		
    /**
     * 按钮查询事件
     */
    function search(){
        //获取查询条件表单所有数据
        var data = cui(CapPtcNotice).databind().getValue();
        if(data.cdtEnd){
        	data.cdtEnd=addDate(data.cdtEnd);
        }
        if(data.creator && data.creator!=""){
        	data.creatorId=creator.id;
        }
        else{
        	data.creatorId="";
        }
        //设置Grid的查询条件
        cui('#CapPtcNoticeGrid').setQuery(data);
        //重新加载数据，loadData时，会重新调用initData
        cui('#CapPtcNoticeGrid').loadData();
    }

	/**
     * 清空查询表单
     */
    function clearSearch(){
    	cui("#creator").setValue(null);
        cui(CapPtcNotice).databind().setEmpty();
        search();
    }
	
	//日期加一天
    function addDate(dd){
    	var a = dd.split("-");
    	var day = parseInt(a[2]) + 1;
    	var now;
    	if(day<10){
    		now = a[0]+"-"+a[1]+"-0"+day;
    	}
    	else{
    		now = a[0]+"-"+a[1]+"-"+day;
    	}
		return now;
    	}
 	/**
     * 隐藏查询区域条件
     */
	function hiddenQueryAreaTr()   {   		
		//查询区域少于1行不加隐藏功能
		if ($("#select_condition tr").length <= 1 
			|| 	( $("#select_condition tr").length == 2	&& $(".hide_span").length == 0 )){
			return;
		}
		//除第一行，最后一行显示，其它行隐藏
		$("#select_condition tr:not(:first, :last)").hide();
		//最后一行，除查询按钮其它控件隐藏
		$(".hide_span").hide();		
		//第一行增加一列显示更多按钮
		$("#select_condition tr:first td:last-child").each(function () {			
			$(this).after("<td><span class='btn-more' id='btnMoreSpan'>更多&#9660</span></td>");
		});
		
		//其它行增加一列
		$("#select_condition tr:not(:first) td:last-child").each(function () {			
			$(this).after("<td>&nbsp;</td>");
		});		
	}   
	
	/**
     * 更多按钮 单击隐藏查询区域条件
     */
	$("body").on('click', "#btnMoreSpan", function(){ 
		var isShow = $(this).html().lastIndexOf("▼") > 0;		
		//除第一行，最后一行，其它行是否显示
		controlObjectShowHide(isShow, $("#select_condition tr:not(:first, :last)"));	
		//最后一行，除查询按钮其它控件是否显示			
		controlObjectShowHide(isShow, $(".hide_span"));	
		if ( isShow ){			
			$(this).html("更多&#9650");
		}else{
			$(this).html("更多&#9660");
		}
	});
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
		return (document.documentElement.clientHeight || document.body.clientHeight) - existingHeight-20;
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
	

    //列表列渲染——编辑链接渲染
	function editLinkRender(rd, index, col) {	
		if(!rd[col.bindName]){
			return;
		}	
		return "<a href='javascript:;' onclick='edit(\"" +rd.id+"\");'>" + HTMLEnCode(rd[col.bindName]) + "</a>";
	}
	
    
    //列表列渲染——查看链接渲染
    function viewLinkRender(rd, index, col) {
    	if(!rd[col.bindName]){
			return;
		}			
		return "<a href='javascript:;' onclick='view(\"" +rd.id+"\");'>" + rd[col.bindName] + "</a>";
	}
	
	//删除事件
	function btnDelete(){

		var result = true;
		if (typeof(myBeforeDelete) == "function") {
			result = eval("myBeforeDelete()");
		}
		if(!result && typeof(result) != "undefined"){
			return;
		}

		var selects = cui("#CapPtcNoticeGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}	
		cui.confirm("确定要删除这"+selects.length+"条数据吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				CapPtcNoticeAction.deleteCapPtcNoticeList(cui("#CapPtcNoticeGrid").getSelectedRowData(),function(msg){
				 	cui("#CapPtcNoticeGrid").loadData();
				 	cui.message("删除成功！","success");
				 	});
				dwr.TOPEngine.setAsync(true);
			}
		});

		if (typeof(myAfterDelete) == "function") {
			eval("myAfterDelete()");
		}

	}
	
	//保存后处于列表首位 
	function fresh(index){
		cui('#CapPtcNoticeGrid').loadData();
		cui("#CapPtcNoticeGrid").selectRowsByPK(index, true);
		var index=cui("#CapPtcNoticeGrid").getSelectedIndex();
		var changeData=cui("#CapPtcNoticeGrid").getRowsDataByIndex(index);
		cui("#CapPtcNoticeGrid").removeData(index);
		cui("#CapPtcNoticeGrid").addData(changeData, 0);
		cui("#CapPtcNoticeGrid").selectRowsByIndex(0);
	}
	
	//
	function chooseCreator(event,self){
		var id="SelectionEmployee";
		var url = "<%=request.getContextPath()%>/cap/ptc/team/CheckSinPersonnel.jsp";
		var title="选择人员";
		var height = 500;
		var width =  600;
		
		dialog = cui.dialog({
			id:id,
			title : title,
			src : url,
			width : width,
			height : height
		})
		dialog.show(url);
	}
	
	//
	function chooseEmployee(selectEmployee){
		if(selectEmployee[0].id){
			cui("#creator").setValue(selectEmployee[0].employeeName);
			creator.id=selectEmployee[0].id;
			creator.name=selectEmployee[0].employeeName;
		}
	}
</script>
<top:script src="/cap/ptc/notice/js/NoticeList.js"/>
</body>
</html>