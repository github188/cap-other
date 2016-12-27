<%
/**********************************************************************
* 流程跟踪查看
* 2016-05-03 许畅 新建
**********************************************************************/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/cap/rt/common/CapRtTaglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>流程跟踪</title>
    <top:link href="/cap/rt/common/base/css/base.css"/>
    <top:link href="/cap/rt/common/base/css/comtop.cap.rt.css"/>
    <top:link href="/cap/rt/common/cui/themes/default/css/comtop.ui.min.css"/>
    <top:link href="/practice/css/ApproveOpinion.css"/>
    <style type="text/css">
    	.cap-page{
    		width: 1024px;
    	}
    </style>
	<top:script src='/cap/rt/common/base/js/jquery.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/comtop.ui.min.js'></top:script>
	<top:script src='/cap/rt/common/base/js/comtop.cap.rt.js'></top:script>
	<top:script src='/cap/rt/common/cui/js/cui.utils.js'></top:script>
	<top:script src='/cap/rt/common/globalVars.js'></top:script>
	<top:script src='/cap/dwr/engine.js'></top:script>
	<top:script src='/cap/dwr/util.js'></top:script>
	<top:script src='/cap/dwr/interface/CapWorkflowAction.js'></top:script>
	<top:script src='/cap/rt/common/workflow/comtop.cap.rt.workflow.js'></top:script>
	<top:script src='/practice/js/ApproveOpinion.js'></top:script>
	<top:script src='/cap/rt/common/workflow/common/js/userSelect/userOrgUtil.js'></top:script>
    
</head>
<body>
<div id="pageRoot" class="cap-page">
<div class="cap-area" style="width:100%;">
	<table id="tableid-9917734248097986" class="cap-table-fullWidth">
		<tr id="trid-8473065126454458">
			<td id="tdid-13046554566826671" class="cap-td"  >
            	<%@ include  file="/practice/ApproveOpinion.jsp"%>
			</td>
		</tr>
	</table>
</div>
</div>
</body>

<script type="text/javascript">

cap.dicDatas=<%=com.comtop.top.core.util.JsonUtil.objectToJson(request.getAttribute("dicDatas"))%>;

/**
 * 
 * 获取流程单据的数据 需包含流程所需相关数据
 * 
 */
function getBizData(){
var selectDataTmp = '';
    if(selectDataTmp != ''){
		var selectData = window[selectDataTmp];
		return selectData;
	}
	//控制返回数据

	return selectDataTmp;
}
	

		
/**
 * 
 * 流程操作完成的回调函数
 * @param type 操作类型
 * 	 "back" : 回退 , "report" : 上报 , 
 *	 "backReport" : 回退 申请人, "send" ： 发送， "undo" :撤回,"saveOpinion":保存意见
 */
 //流程审批页面回调行为 流程审批页面回调行为
function bizCallbackFunc(type){
var saveContinue=1;
//根据不同的操作类型，处理不同的提示信息，或者是相关业务处理

if(saveContinue==1){
	refreshApprovePage();
}else if(saveContinue==2){
	window.close();
}
	
}
	


//页面初始化状态
function pageInitState(){
}
        
jQuery(document).ready(function(){
	cap.beforePageInit.fire();
	cap.executeFunction("pageInitBeforeProcess");
	if(window['pageMode'] == "textmode" || window['pageMode'] == "readonly"){
		comtop.UI.scan[pageMode]=true;
	}
	comtop.UI.scan();
	cap.errorHandler();
	cap.executeFunction("pageInitLoadData");
	cap.pageInit();
	pageInitState();
	cap.executeFunction("pageInitAfterProcess");
});
        
        
//页面控件属性配置
var uiConfig={
    "uiid-696544573479332":{
        "bizCallback":bizCallbackFunc,
        "height":"200px",
        "pageUrl":"/practice/ApproveOpinion.jsp",
        "width":"100%",
        "bizCallback_id":"146225721402501",
        "uitype":"IncludePage",
        "initData":getBizData,
        "initData_id":"14622572140250"
    }
}

</script>
</html>