var lastNodeTrackInfo;//最后一个节点跟踪信息
var bizDataForWorkflow; //业务数据
var bpmsWorkflowParam;//工作流参数
var bpmsVarExt = {};//bpms变量

/**
 * 转换为工作流参数
 * @param bizData 业务实体
 * @returns {___anonymous64_65}
 */
function convertToWFParam(){
	var data = {};
	data.flowState=bizDataForWorkflow.flowState;
	data.workId = bizDataForWorkflow.primaryValue;
	data.smsType = null;
	data.emailType = null;
	data.currNodeId = bizDataForWorkflow.nodeId;
	data.processVersion = bizDataForWorkflow.version ? bizDataForWorkflow.version : 0;
	data.taskId = bizDataForWorkflow.taskId;
	data.processId = bizDataForWorkflow.processId;
	data.currentUserId = globalUserId;
	data.comtop_bpms_current_orgId = globalOrganizationId;
	data.currentUserName = globalUserName;
	data.orgId = globalOrganizationId;
	data.opinion = bizDataForWorkflow.opinion;
	data.processInsId = bizDataForWorkflow.processInsId ? bizDataForWorkflow.processInsId : processInsId;
	data.targetNodeInfos = null;
	data.resultFlag =  bizDataForWorkflow.resultFlag;
	data.workflowFacadeName = bizDataForWorkflow.workflowFacadeName;
	data.paramMapString = cui.utils.stringifyJSON(bizDataForWorkflow);
	return data;
}

/**
 * 将当前用户的记录提取到第一位 为页面显示使用
 * @param colTransTrackInfo
 */
function orderTransTrackInfo(colTransTrackInfo){
	var newColTransTrackInfo = [];
	var doneColTransTrackInf = [];
	var todoColTransTrackInf = [];
	var currItem;
	for (var j = 0; j < colTransTrackInfo.length; j++) {
		var item = colTransTrackInfo[j];
		if(item.actorId == globalUserId){
			currItem = item;
		}else if(item.transFlag != 1){
			doneColTransTrackInf.push(item);
		}else{
			todoColTransTrackInf.push(item);
		}
	}
	//已办放在最前面
	for(var j = 0; j < doneColTransTrackInf.length; j++){
		newColTransTrackInfo.push(doneColTransTrackInf[j]);
	}
	//然后是当前用户的待办或已办
	if(currItem){
		newColTransTrackInfo.push(currItem);
	}
	//其他用户待办放在最后面
	for(var j = 0; j < todoColTransTrackInf.length; j++){
		newColTransTrackInfo.push(todoColTransTrackInf[j]);
	}
	return newColTransTrackInfo;
}

/**
 * 显示状态
 */
var ApprovePageConstants = {
	DONE : 1,  //该节点已经处理完成
	SELF_DOING : 2, //任务停留在该节点 且当前用户的待办
	OTHER_DOING : 3, //任务停留在该节点
	TODO : 4, //任务还未到达该节点
	OPTION_TIP : "请填写审批意见。"
}

/**
 * 通过跟踪信息获取显示的数据项
 * @param nodeTrackInfo 节点跟踪信息
 * @param userTrackInfo 用户处理跟踪信息
 */
function getDisplayDataItemByTrack(nodeTrackInfo, userTrackInfo){
	var overTime = userTrackInfo.overTime ? getOverTime(userTrackInfo.overTime) : "";
	var transFlag = userTrackInfo.transFlag;
	var dataItemStatus;
	if(transFlag == 1 || transFlag == 2){//1 待办 2保存意见后状态
		if(taskType && taskType == "todo" && userTrackInfo.actorId == globalUserId){
			dataItemStatus = ApprovePageConstants.SELF_DOING;
		}else{
			dataItemStatus = ApprovePageConstants.OTHER_DOING;
		}
	}else{
		dataItemStatus = ApprovePageConstants.DONE;
	}
	var displayDataItem = {
			nodeId : nodeTrackInfo.curNodeId,
			nodeName : nodeTrackInfo.curNodeName,
			nodeTrackId : nodeTrackInfo.nodeTrackId,
			userId : userTrackInfo.actorId,
			userName : userTrackInfo.actorName,
			msg : userTrackInfo.msg ? userTrackInfo.msg : "",
			overTime : overTime,
			status : dataItemStatus,
			activeInsId : userTrackInfo.activeInsId
		};
	if(bpmsVarExt.ipb_countersign_status == "running"){
		displayDataItem.hideBackButton = true;
	}
	if(displayDataItem.status == ApprovePageConstants.SELF_DOING 
			&& !isShowCountersignButton()){
		displayDataItem.hideCountersignButton = true;
	}
	if(bizDataForWorkflow.revokeBackFlag == "1" && taskType && taskType == "done"){//可撤回 已办页面 
		if(globalUserId == displayDataItem.userId 
				&& bizDataForWorkflow.activityInsId == displayDataItem.activeInsId){//匹配用户行 且活动实例一致
			//工作流状态为已完成的不显示撤回按钮
			if(bizDataForWorkflow.flowState && bizDataForWorkflow.flowState=="2"){
				displayDataItem.showUndo = false;//不显示撤回按钮
			}else{
				displayDataItem.showUndo = true;//显示撤回按钮	
			}
		}
	}
	return displayDataItem;
}

/**
 * 通过节点用户信息获取显示的数据项
 * @param node 节点信息
 * @param user 节点用户信息
 */
function getDisplayDataItemByNode(node, user){
	var nodeItem = {
			nodeId : node.nodeId,
			nodeName : node.nodeName,
			userId : user.userId,
			userName : user.userName,
			status : ApprovePageConstants.TODO
		};
	/**
	 * 特殊过滤逻辑： 当需要会签返回本人时，当前待办后一个节点是会签发起人节点，且用户是会签发起人
	 * 调用的后台接口获取的节点列表： 待办后一个节点是会签发起人节点，但节点用户返回了该节点的所有用户，
	 * 所以需要做过滤
	 * 
	 * 获取的节点列表： 1. 如果节点与lastNodeTrackInfo节点ID不一致 不需要做过滤
	 * （如果走了会签 lastNodeTrackInfo的节点Id 就是会签发起人节点ID）
	 * 	2. 只有在backSelf为true且节点与lastNodeTrackInfo的节点ID一致时 过滤掉其他用户
	 */
	if(bpmsVarExt.backSelf == "true" 
		&& user.userId == bpmsVarExt.ipb_back_self_userId
		&& node.nodeId == lastNodeTrackInfo.curNodeId){
		return nodeItem;
	}else if(node.nodeId != lastNodeTrackInfo.curNodeId){
		return nodeItem;
	}
	return null;
}

/**
 * 转化数据结构为页面显示所需的数据结构
 * 
 * @param nodeTrackInfoList
 *            节点跟踪信息列表
 * @param nodeList
 *            剩余节点列表
 */
function getApproveDisplayData(nodeTrackInfoList, nodeList) {
	//console.log(nodeTrackInfoList);
	//console.log(nodeList);
	var displayData = [];
	if(!nodeTrackInfoList || !nodeTrackInfoList.length){
		return displayData;
	}
	for (var i = 0; i < nodeTrackInfoList.length; i++) {
		var nodeTrackInfo = nodeTrackInfoList[i];
		var colTransTrackInfo = nodeTrackInfo.colTransTrackInfo;
		if (!colTransTrackInfo || !colTransTrackInfo.length) {
			continue;
		}
		var newColTransTrackInfo;
		if(i == nodeTrackInfoList.length -1){
			newColTransTrackInfo = orderTransTrackInfo(colTransTrackInfo);//将当前用户提取到第一位
		}else{
			newColTransTrackInfo = colTransTrackInfo;
		}
		for (var j = 0; j < newColTransTrackInfo.length; j++) {
			displayData.push(getDisplayDataItemByTrack(nodeTrackInfo, newColTransTrackInfo[j]));
		}
	}
	
	if(!nodeList || !nodeList.length){
		return displayData;
	}
	for (var i = 0; i < nodeList.length; i++) {
		var node = nodeList[i];
		var users = node.users;
		if (!users || !users.length) {
			continue;
		}
		for (var j = 0; j < users.length; j++) {
			var displayDataItem = getDisplayDataItemByNode(node, users[j]);
			if(displayDataItem){
				displayData.push(displayDataItem);
			}
		}
	}
	return displayData;
}

/**
 * 渲染页面 
 * @param displayData 显示数据
 */
function renderApproveData(displayData){
	var templateSettings = cui.utils.templateSettings;
	cui.utils.templateSettings = {
		    evaluate    : /\{\{([\s\S]+?)\}\}/g,
		    interpolate : /\{\{=([\s\S]+?)\}\}/g,
		    escape      : /\{\{-([\s\S]+?)\}\}/g
		};
	var templateElem = document.getElementById('template')
	var html = templateElem.innerHTML != '' ? templateElem.innerHTML : templateElem.innerText;
	var template = cui.utils.template(html);
	var result = template({displayData : displayData});
	document.getElementById('fillContent').innerHTML=result;
	cui.utils.templateSettings = templateSettings;
}

/**
 * 获取完成时间
 */
function getOverTime(overTime){
	if(!overTime){
		return "";
	}
	return new Date(overTime).Format("yyyy年MM月dd日");
}

/**
 * 日期格式化函数
 * (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
 * (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
 */
Date.prototype.Format = function (fmt) { //author: meizz 
	var o = {
	    "M+": this.getMonth() + 1, //月份 
	    "d+": this.getDate(), //日 
	    "h+": this.getHours(), //小时 
	    "m+": this.getMinutes(), //分 
	    "s+": this.getSeconds(), //秒 
	    "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
	    "S": this.getMilliseconds() //毫秒 
	};
	if (/(y+)/.test(fmt)){
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	}
	for (var k in o){
		if (new RegExp("(" + k + ")").test(fmt)){
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
		}
	}
	return fmt;
}

/**
 * 填写意见离焦事件
 */
function opnionTextareaBlur(){
	var opnionTextareaElem = document.getElementById('opnionTextarea');
	if(!opnionTextareaElem){
		return;
	}
	var approveOpnion = opnionTextareaElem.value;
	if(approveOpnion == ""){
		opnionTextareaElem.value = ApprovePageConstants.OPTION_TIP;
		opnionTextareaElem.style.color = "grey";
	}
}

/**
 * 填写意见聚焦事件
 */
function opnionTextareaFocus(){
	var opnionTextareaElem = document.getElementById('opnionTextarea');
	if(!opnionTextareaElem){
		return;
	}
	var approveOpnion = opnionTextareaElem.value;
	if(approveOpnion == ApprovePageConstants.OPTION_TIP){
		opnionTextareaElem.value = "";
	}
	opnionTextareaElem.style.color = "#333";
}
/**
 * 校验审批意见
 */
function valiadateApproveOpnion(){
	var approveOpnion = document.getElementById('opnionTextarea').value;
	
	if(!approveOpnion || approveOpnion.length <= 0 || approveOpnion == ApprovePageConstants.OPTION_TIP){
		cui.alert(ApprovePageConstants.OPTION_TIP);
		return false;
	}
	return true;
}

/**
 * 操作之前的业务-增加会签状态
 */
function doOperateBefore() {
	if (!bizDataForWorkflow.backSelf
			&& !bizDataForWorkflow.ipb_countersign_status) {
		bizDataForWorkflow.backSelf = "false";
		bizDataForWorkflow.ipb_countersign_status = "";
		bizDataForWorkflow.comtop_bpms_current_orgId = globalOrganizationId;
	}
}

/**
 * 下发单据
 */
function approveSendData(){
	if(!valiadateApproveOpnion()){
		return;
	}
	
	doOperateBefore();
	
	var getApproveData = function(){
		var result = [];
		if(!isArray(bizDataForWorkflow)){
			result[0] = bizDataForWorkflow;
		}else{
			result = bizDataForWorkflow;
		}
		var approveOpnion =document.getElementById('opnionTextarea').value;
		result[0].opinion = approveOpnion;
		return result;
	}
	
    var flowOperateCallback = function(){
    	bizCallbackFunc("send");
    };
    
    //会签状态为运行中并且是回退到本人的调用默认发送,其他情况调用指定发送
    if(bpmsVarExt && bpmsVarExt.ipb_countersign_status=="running" && bpmsVarExt.backSelf=="true"){
    	cap.rt10.workflow.operate.send(true, getApproveData, flowOperateCallback,
    	    		{opinionDisplay:false, opinionRequired:false});
    }else{
    	cap.rt10.workflow.operate.send(false, getApproveData, flowOperateCallback,
	    		{opinionDisplay:false, opinionRequired:false});
    }
}

/**
 * 回退
 */
function approveBackData(){
	if(!valiadateApproveOpnion()){
		return;
	}
	
	doOperateBefore();
	
	var getApproveData = function(){
		var result = [];
		if(!isArray(bizDataForWorkflow)){
			result[0] = bizDataForWorkflow;
		}else{
			result = bizDataForWorkflow;
		}
		var approveOpnion = document.getElementById('opnionTextarea').value;
		result[0].opinion = approveOpnion;
		return result;
	}
    var flowOperateCallback = function(){
    	bizCallbackFunc("back");
    };
	cap.rt10.workflow.operate.back(false, getApproveData, flowOperateCallback, 
			{backOpinionRequired: false, opinionDisplay:false, opinionRequired:false});
}

/**
 * 回退申请人
 */
function approveBackReport(){
	if(!valiadateApproveOpnion()){
		return;
	}
	
	doOperateBefore();
	
	var getApproveData = function(){
		var result = [];
		if(!isArray(bizDataForWorkflow)){
			result[0] = bizDataForWorkflow;
		}else{
			result = bizDataForWorkflow;
		}
		var approveOpnion = document.getElementById('opnionTextarea').value;
		result[0].opinion = approveOpnion;
		return result;
	}
    var flowOperateCallback = function(){
    	bizCallbackFunc("backReport");
    };
	cap.rt10.workflow.operate.backReport(false, getApproveData, flowOperateCallback, 
			{backOpinionRequired: false, opinionDisplay:false, opinionRequired:false});
}

/**
 * 撤回
 */
function approveUndoData(){
	doOperateBefore();
	
	var getApproveData = function(){
		var result = [];
		if(!isArray(bizDataForWorkflow)){
			result[0] = bizDataForWorkflow;
		}else{
			result = bizDataForWorkflow;
		}
		return result;
	}
    var flowOperateCallback = function(){
    	bizCallbackFunc("undo");
    };
    cap.rt10.workflow.operate.undo(false, getApproveData, flowOperateCallback);
}

/**
 * 保存意见
 */
function saveOpinion(){
	if(!valiadateApproveOpnion()){
		return;
	}
	var getApproveData = function(){
		var result = [];
		if(!isArray(bizDataForWorkflow)){
			result[0] = bizDataForWorkflow;
		}else{
			result = bizDataForWorkflow;
		}
		var approveOpinion = document.getElementById('opnionTextarea').value;
		result[0].opinion = approveOpinion;
		return result;
	}
	var flowOperateCallback = function(){
	    	bizCallbackFunc("saveOpinion");
	};
	bizDataForWorkflow.operateType=11;//操作类型11 是保存意见
	cap.rt10.workflow.operate.saveNote(false, getApproveData, flowOperateCallback,{needNotePage:"false",targetOpinionText:document.getElementById('opnionTextarea').value});
}

/**
 * 增加会签人
 */
function approveReassignData(param){
	if(!valiadateApproveOpnion()){
		return;
	}
	if(param.id == 'item1'){
		bizDataForWorkflow.backSelf = "true";
	}else{
		bizDataForWorkflow.backSelf = "false";
	}
	bizDataForWorkflow.ipb_countersign_status = "start";
	var getApproveData = function(){
		var result = [];
		if(!isArray(bizDataForWorkflow)){
			result[0] = bizDataForWorkflow;
		}else{
			result = bizDataForWorkflow;
		}
		var approveOpnion = document.getElementById('opnionTextarea').value;
		result[0].opinion = approveOpnion;
		cap.rt10.workflow.userSelect.targetOpinionText=approveOpnion;
		return result;
	}
    var flowOperateCallback = function(){
    	bizCallbackFunc("reassign");
    };
    
    cap.rt10.workflow.operate.send(false, getApproveData, flowOperateCallback, 
    		{special:true, selectNodeUser: true, chooseFromUserDeptComponet:true});
}

/**
 * 在使用TOP的人员选择组件时，需要重写工作流获取目标节点信息函数 
 * 为了使该函数重写有效 必须将该JS文件引入在comtop.cap.rt.workflow.js之后
 * @returns {Array}
 */
function getCustomDefineTargetNodeInfo4TopSelect(){
	return [{nodeId: lastNodeTrackInfo.curNodeId, nodeName: lastNodeTrackInfo.curNodeName, 
		nodeInstanceId : lastNodeTrackInfo.curNodeInsId, processId: lastNodeTrackInfo.mainProcessInsId, 
		processVersion: bizDataForWorkflow.version, nodeType:"USERTASK"}];
}

/**
 * 属性审批页面
 */
function refreshApprovePage(){
	if(bizDataForWorkflow.operateType == 11){//保存意见只需重载当前页面
		window.location.href = window.location.href;
		return;
	}
	var bpmsWorkflowParam = convertToWFParam(bizDataForWorkflow);
	var newTaskType = (taskType == "todo") ? "done" : "todo";//待办处理完后显示已办页面
	var doneTaskId;
	dwr.TOPEngine.setAsync(false);
	CapWorkflowAction.queryNewTaskId(bpmsWorkflowParam, bizDataForWorkflow.activityInsId, newTaskType, 
			function(result){
				doneTaskId=result;
	});
	dwr.TOPEngine.setAsync(true);
	window.location.href = getNewApproveUrl(window.location.href, doneTaskId, newTaskType);
}

/**
 * 该函数是将当前页面的url 去除taskId和taskType两个参数 
 * 因为这两个参数值发生变化
 * @param url 原始url
 * @returns {String}
 */
function getNewApproveUrl(url, taskId, taskType){
	var rootUrl = url.substring(0, url.indexOf('?'));
	var urlParamString = url.substring(url.indexOf('?') + 1, url.length);
	var urlParams = urlParamString.split('&');
	for (var i = 0; i < urlParams.length; i++) {
		var urlParamsItem = urlParams[i];
		if(urlParamsItem.indexOf('=') == -1){
			continue;
		}
		var paramKey = urlParamsItem.split('=')[0];
		var paramValue = urlParamsItem.split('=')[1];
		if(paramKey == "taskId"){
			urlParams[i] = 'taskId=' + taskId;
		}else if(paramKey == "taskType"){
			urlParams[i] = 'taskType=' + taskType;
		}
	}
	return rootUrl + "?" + urlParams.join('&');
}
/**
 * 是否显示会签按钮
 * @returns {Boolean}
 */
function isShowCountersignButton(){
	var bpmsWorkflowParam = convertToWFParam(bizDataForWorkflow);
	var returnValue = true;

    if(!bpmsWorkflowParam.flowState){
    	return false;
    }

	dwr.TOPEngine.setAsync(false);
	CapWorkflowAction.invokeWorklfowFacadeMethod('isShowCountersignButton',bpmsWorkflowParam, function(result){
		returnValue = result == "true" ? true : false;
	});
	dwr.TOPEngine.setAsync(true);
	return returnValue;
}

/**
 * 初始化数据
 */
function initApproveData(){
	bizDataForWorkflow = getBizData();
	bpmsWorkflowParam = convertToWFParam();
	//查询已办表
	queryWorkflowTask();
	setBpmsVar();
}

/**
 * 查询已办表(如果是查看模式)
 */
function queryWorkflowTask(){
	if (viewType && processId && processInsId) {
		bizDataForWorkflow={};
		
		dwr.TOPEngine.setAsync(false);
		CapWorkflowAction.queryTaskVOByProcessInsId(processId, processInsId,function(result) {
			if (result && result["vo"]) {
				taskType = result["workType"];
				var doneTask = result["vo"];
			    bizDataForWorkflow["taskId"] = doneTask["taskId"];
				bizDataForWorkflow["revokeBackFlag"] = doneTask["revokeBackFlag"];
				bizDataForWorkflow["nodeId"] = doneTask["nodeId"];
				bizDataForWorkflow["nodeName"] = doneTask["nodeName"];
				bizDataForWorkflow["backFlag"] = doneTask["backFlag"];
				bizDataForWorkflow["processId"] = doneTask["processId"];
				bizDataForWorkflow["opinion"] = doneTask["opinion"];
				bizDataForWorkflow["curNodeInsId"] = doneTask["curNodeInsId"];
				bizDataForWorkflow["activityInsId"] = doneTask["activityInsId"];
				bizDataForWorkflow["version"] = doneTask["version"];
				bpmsWorkflowParam = convertToWFParam();
			}else{
				taskType="todo";
			}
		});
		dwr.TOPEngine.setAsync(true);
	}
}

/**
 * 设置BPMS变量
 */
function setBpmsVar(){
	var bpmsVarExtList;
	
	if (viewType && processId && processInsId) {}

	if(!bpmsWorkflowParam.flowState){
		return;
	}

	dwr.TOPEngine.setAsync(false);
	CapWorkflowAction.invokeWorklfowFacadeMethod('queryBpmsVarExtList',bpmsWorkflowParam, function(result){
		if(typeof result == "string"){
			bpmsVarExtList = cui.utils.parseJSON(result);
		}else{
			bpmsVarExtList = result;
		}
		
	});
	dwr.TOPEngine.setAsync(true);
	if(!bpmsVarExtList || !bpmsVarExtList.length){
		return;
	}
	for (var i = 0; i < bpmsVarExtList.length; i++) {
		var item = bpmsVarExtList[i];
		if(item.variableKey && item.variableValue){
			bpmsVarExt[item.variableKey] = item.variableValue;
		}
	}
}

/**
 * 加载审批页面
 */
function loadApprovePage(){
	initApproveData();
	//获取节点跟踪信息列表
	var nodeTrackInfoList = getNodeTrackInfoList();
	if(!nodeTrackInfoList || !nodeTrackInfoList.length 
			|| nodeTrackInfoList.length <=0){
		return;
	}
	//获取最后一个节点跟踪信息
	lastNodeTrackInfo = nodeTrackInfoList[nodeTrackInfoList.length-1];
	//获取节点列表
	var nodeList = getNodeList(); 
	//将后台的数据结构转换为前台展示所需要的数据结构
	var displayData = getApproveDisplayData(nodeTrackInfoList, nodeList);
	//渲染数据
	renderApproveData(displayData);
	//常用意见的渲染
	initCommonOpinion();
	//渲染操作按钮
	initOperatebtn();

	comtop.UI.scan();
}

//渲染操作按钮
function initOperatebtn(){
	if (viewType && processId && processInsId) {
		$(".col-content-todo-oper").hide();
		$(".right-col").hide();
		$("#cancelBack").hide();
		$(".col-todo-attach").hide();
		$(".textarea_textarea_wrap").hide();
	}
}

//查询常用意见
function initCommonOpinion(){
	dwr.TOPEngine.setAsync(false);
	CommonOpinionFacade.getListData(null,function(data) {
		if(data && data["list"]){
			var opinions=data["list"];
			initOpinion = [];
			for(var i=0;i<opinions.length;i++){
				var opinion=opinions[i];
				var item={};
				item["id"]=opinion["id"];
				item["text"]=opinion["opinion"];
				initOpinion.push(item);
			}
		}
	});
	dwr.TOPEngine.setAsync(true);
}

/**
 * 获得节点跟踪信息列表
 * @returns 节点跟踪信息列表
 */
function getNodeTrackInfoList(){
	var nodeTrackInfoList;
	dwr.TOPEngine.setAsync(false);
	if(viewType && processId && processInsId){
		CapWorkflowAction.queryProcessInsTransTrackById(processId,processInsId,function(result){
			if(result){
				nodeTrackInfoList=cui.utils.parseJSON(result);
			}
		});
	}else{
		CapWorkflowAction.queryProcessInsTransTrack(bpmsWorkflowParam,function(result){
			if(result){
				nodeTrackInfoList=cui.utils.parseJSON(result);
			}
		});
	}
	dwr.TOPEngine.setAsync(true);
	return nodeTrackInfoList;
}

/**
 * 获得节点列表
 * @returns 节点列表
 */
function getNodeList(){
	var nodeList; 

	
	if(viewType && processId && processInsId){
		bizDataForWorkflow.backSelf=false;
		bizDataForWorkflow.ipb_countersign_status="";
		bizDataForWorkflow.comtop_bpms_current_orgId = globalOrganizationId;
		dwr.TOPEngine.setAsync(false);
		CapWorkflowAction.queryAllUserNodesByVersion(bpmsWorkflowParam,bizDataForWorkflow,function(result) {
					if (result) {
						nodeList = cui.utils.parseJSON(result);
					}
				});
		dwr.TOPEngine.setAsync(true);
		
		return nodeList;
	}
	
	
	if(!bpmsWorkflowParam.flowState){
		return nodeList;
	}

	dwr.TOPEngine.setAsync(false);
	bizDataForWorkflow.query_node_id = lastNodeTrackInfo.curNodeId;
	bizDataForWorkflow.comtop_bpms_current_orgId = globalOrganizationId;
	bpmsWorkflowParam.paramMapString = cui.utils.stringifyJSON(bizDataForWorkflow);
	CapWorkflowAction.invokeWorklfowFacadeMethod('queryAllUserNodesByVersion',bpmsWorkflowParam,
			function(result){
				if(result){
					nodeList = cui.utils.parseJSON(result);
				}
	});
	bizDataForWorkflow.query_node_id = undefined;
	dwr.TOPEngine.setAsync(true);
	return nodeList;
}
