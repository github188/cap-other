<%
/**********************************************************************
* 文档管理-列表
* 2015-11-9
**********************************************************************/
%>
<%@ include file="/cap/bm/common/Taglibs.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>文档操作记录列表页</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_base.css" type="text/css">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/cap/bm/common/top/css/top_sys.css" type="text/css">
	<top:link  href="/cap/bm/common/cui/themes/default/css/comtop.ui.min.css"/>
	<top:link  href="/eic/css/eic.css"/>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/top/js/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath() %>/cap/bm/common/cui/js/comtop.ui.min.js"></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.ui.emDialog.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/eic/js/comtop.eic.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/engine.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/util.js'></script>
	<script type='text/javascript' src='<%=request.getContextPath() %>/cap/dwr/interface/DocOperLogAction.js'></script>
<style type="text/css">
.top_float_right{
	margin-top:4px;
	margin-bottom:4px;
	margin-right:4px;
}
</style>
</head>
<body>
<div class="list_header_wrap">
	<table id="select_condition">
	    <tbody>
			<tr>
				<td class="td_label" width="15%"><span>操作类型：</span></td>
				<td width="30%" ><span uitype="PullDown" id="docOperType" mode="Single" datasource="docOperTypeData" select="-1" empty_text="--操作类型--" editable="false" on_change ="fastQuery" ></span></td>
				<td class="td_label" width="15%"><span>操作者：</span></td>
				<td width="30%" ><span uitype="ClickInput" id="creator" name="creator" on_iconclick="chooseCreator" on_focus="chooseCreator" on_change ="fastQuery" ></span></td>
			</tr>
		</tbody>
    </table>
    <div class="top_float_right">
		<span uitype="button" id="search_btn" label="查 询" on_click="fastQuery"></span>
		<span uitype="button" id="clear_btn" label="清空条件" on_click="clearSearch" ></span>
		<span uitype="button" id="delete_btn" label="删 除" on_click="deleteOperLog" ></span>
	</div>
    <table uitype="Grid" id="DocOperLogGrid" primarykey="id" sorttype="1" datasource="initData" pagination="false"  pagesize_list="[10,20,30]"  
	 	resizewidth="resizeWidth" resizeheight="resizeHeight">  
	 	<tr>
			<th style="width:5%"><input type="checkbox"/></th>
			<th bindName="userName" style="width:15%;" renderStyle="text-align: left;" >操作者</th>
			<th bindName="remark" style="width:25%;" renderStyle="text-align: left;" >文档名称</th>
			<th bindName="operTime" style="width:15%;" renderStyle="text-align: center;" format="yyyy-MM-dd hh:mm">操作时间</th>
			<th bindName="operType" style="width:10%;" renderStyle="text-align: center;" render="operTypeRender">操作类型</th>
			<th bindName="operResult" style="width:10%;" renderStyle="text-align: center;" render="operResultRender">操作结果</th>
			<th bindName="fileAddr" style="width:10%;" renderStyle="text-align: center;" render="loadDoc">文档</th>
			<th bindName="logFilePath" style="width:10%;" renderStyle="text-align: center;" render="loadDocOperLog">日志</th>
		</tr>
	</table>
</div>

<script language="javascript"> 
	var bizDomainId = "${param.bizDomainId}";//业务域ID
	var creator={};
	var docOperTypeData =  [
		{"id": "IMP", "text":"导入"},                   
		{"id": "EXP", "text":"导出"},
	];
	//onload 
	window.onload = function(){
		creator.id=globalCapEmployeeId;
		comtop.UI.scan();
		cui("#creator").setValue(globalCapEmployeeName);
	}
	
	//grid数据源
	function initData(tableObj,query){
		query.bizDomainId = bizDomainId;
		query.userId=creator.id;
		query.operType=cui("#docOperType").getValue();
		dwr.TOPEngine.setAsync(false);
		DocOperLogAction.queryOperLogByPage(query,function(data){
			tableObj.setDatasource(data.list, data.count);
		});
		dwr.TOPEngine.setAsync(true);
	}
	
	//快速查询
	function fastQuery(){
		cui("#DocOperLogGrid").loadData();
	}
	
	function clearSearch(){
		cui("#docOperType").setValue("");
		cui("#creator").setValue("");
		creator.id=null;
		fastQuery();
	}
	
	//grid 宽度
	function resizeWidth(){
		return (document.documentElement.clientWidth || document.body.clientWidth) - 20;
	}
	
	//grid高度
	function resizeHeight(){
		return (document.documentElement.clientHeight || document.body.clientHeight) - 80;
	}
	
	//
	function chooseCreator(event,self){
		var id="SelectionEmployee";
		var url = "<%=request.getContextPath()%>/cap/ptc/team/CheckSinPersonnel.jsp";
		var title="选择人员";
		var height = 300;
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
	
	//
	function operTypeRender(rd, index, col){
		if(rd['operType'] =="IMP"){
			return "导入";
		}
		else{
			return "导出";
		}
	}
	
	//
	function operResultRender(rd, index, col){
		if(rd['operResult'] =="Doing"){
			return "执行中...";
		}
		else if(rd['operResult'] =="FAIL"){
			return "<font color='red'>失败</font>";
		}
		else{
			return "<font color='blue'>成功</font>";
		}
	}
	
	//
	function loadDoc(rd, index, col){
		if(rd['operResult'] =="Doing"){
			return "";
		}
		else if(rd['operResult'] =="FAIL"){
			return "";
		}
		else{
			if(rd['fileAddr']){
				str="<a href='"+"<%=request.getContextPath()%>"+rd['fileAddr']+"' target='_blank' download=''>下载</a>";
			}
			else{
				str="";
			}
			return str;
		}
	}
	
	//
	function loadDocOperLog(rd, index, col){
		if(rd['logFilePath']){
// 			rd['logFilePath']="D:\CAP\BM\code\cip\cip-webapp\src\main\webapp\"+rd['logFilePath'];
// 			str="<a href="+rd['logFilePath']+" target='_blank' download=''>查看</a>";
			var rel=false;
			dwr.TOPEngine.setAsync(false);
			DocOperLogAction.isExitFile(rd['logFilePath'],function(data){
				rel=data;
			});
			dwr.TOPEngine.setAsync(true);
			if(rel){
				str="<a href="+"<%=request.getContextPath()%>"+rd['logFilePath']+" target='_blank' download=''>查看</a>";
			}
			else{
				str="文件不存在!";
			}
			return str;
		}
		else{
			return "";
		}
	}
	
	//删除事件
	function deleteOperLog(){
		var selects = cui("#DocOperLogGrid").getSelectedRowData();
		if(selects == null || selects.length == 0){
			cui.alert("请选择要删除的数据。");
			return;
		}	
		cui.confirm("记录删除后不可恢复,确定要删除这"+selects.length+"条数据吗？",{
			onYes:function(){
				dwr.TOPEngine.setAsync(false);
				DocOperLogAction.deleteOperLog(selects);
				dwr.TOPEngine.setAsync(true);
				cui("#DocOperLogGrid").loadData();
				window.parent.cui.message('删除成功。','success');
			}
		});
	}
	
	function openLog(url){
		var rel=false;
		dwr.TOPEngine.setAsync(false);
		DocOperLogAction.isExitFile(url,function(data){
			rel=data;
		});
		dwr.TOPEngine.setAsync(true);
		if(rel){
			window.open("<%=request.getContextPath()%>"+url);
		}
		else{
			cui.alert("本地不存在该文件,查看失败");
		}
		
	}
 </script>
</body>
</html>