/**
 * CAP流程审批功能公共JS Created by 罗珍明 on 2015-06-03.
 */
//定义流程审批对象命名空间
var cap =cap ? cap:  {};
cap.rt10 = cap.rt10 ? cap.rt10 : {};
cap.rt10.workflow = cap.rt10.workflow ? cap.rt10.workflow : {};
var CapWorkflowRemoteObj = typeof(CapWorkflowAction) == 'undefined'?null:CapWorkflowAction;
var console= typeof(console) == 'undefined'?{log:function(message){}}:console;

//当前用户信息
cap.rt10.workflow.currentUserInfo={
		userId:globalUserId,
		userName:globalUserName,
		deptId:globalOrganizationId,
		deptPath:globalOrganizationName,
		//以下是代理用户信息，在top中暂未定义出来，后续有再补充。
		authorizerId : null,
		authorizerName : null
};

//定义流程审批配置对象
cap.rt10.workflow.config = {
	//上报配置
	reportConfig:{reportOnLastVersion:false},
	//当前节点信息
	currentNodeInfo:null,
	//流程操作类型
	operateType:null,
	//流程操作回调函数
	operateCallBack:null,
	//节点扩展属性实际值
	currentNodeConfig:null,
	//获取流程审批数据
	getBizflowDataMethod :null,
	//业务检查用户选择的结果
	userSelectCheck:null,
	//流程操作远程对象
	remoteObject:CapWorkflowRemoteObj,
	//流程关联实体名称
	workflowFacadeName:null,
	//
	submitData:null,
	//
	webRoot:webPath,
	//子系统转发路径
	subSystmeRoot:null,
	//流程跟踪表扩展实现
	trackKey:null,
	//调用批量接口的最小数量
	batchSubmitMinNum:15
};

//流程审批人员选择界面使用的相关对象
cap.rt10.workflow.userSelect = {
	//提交到后台查询节点的数据
	queryData:null,
	//可到达的下一节点集合
	nextNodeInfos:null,
	//人员选择界面当前选中的节点
	currentSelectNodeInfo:null,
	//人员选择界面当前选中节点上过滤函数所需的参数
	currentNodeFlowParam:null,
	//
	filterUserInfo:null,
	//
	selectedNodeUse:null
};

cap.rt10.workflow.operate= new function(){
	
	var operateEnum={
			report:1,
			send:2,
			back:3,
			reassign:4,
			abort:5,
			hungup:6,
			undo:7,
			copyto:8,
			backReport:9,
			undoReport:10,
			saveNote:11,
			overFlow:12,
			jump:13,
			recover:14
	}
	
	this.report=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		if(defaultType == true){
			defaultApprove('report');
		}else{
			approveFlowData('report');
		}
	}
	
	this.back=function(defaultType,getData,callback, pNodeConfig){
		setUserFunctionToConfig(getData,callback);
		if(defaultType == true){
			defaultApprove('back');
		}else{
			approveFlowData('back', pNodeConfig);
		}
	}
	
	this.send=function(defaultType,getData,callback,pNodeConfig){
		setUserFunctionToConfig(getData,callback);
		if(defaultType == true){
			defaultApprove('send');
		}else{
			approveFlowData('send',pNodeConfig);
		}
	}
	
	this.backReport=function(defaultType,getData,callback,pNodeConfig){
		setUserFunctionToConfig(getData,callback);
		if(defaultType == true){
			defaultApprove('backReport');
		}else{
			approveFlowData('backReport', pNodeConfig);
		}
	}
	
	this.undo=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('undo');
	}
	
	this.undoReport=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('undoReport');
	}
	
	this.reassign=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('reassign');
	}
	
	this.overFlow=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('overFlow');
	}
	
	this.saveNote=function(defaultType,getData,callback,pNodeConfig){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('saveNote',pNodeConfig);
	}
	
	// 流程跟踪
	this.flowTrack = function(processId, processInstanceId) {
		
		var webRoot = cap.rt10.workflow.config.webRoot;
		var subSystmeRoot = cap.rt10.workflow.config.subSystmeRoot;
		subSystmeRoot= subSystmeRoot == null?'':subSystmeRoot;
		
		var trackKey = cap.rt10.workflow.config.trackKey;
		trackKey = trackKey == null?'':trackKey;
		var url = webRoot + "/bpms/flex/BpmsTrack.jsp?processId="+ processId + "&processInsId=" + processInstanceId+ "&webRootUrl=" + subSystmeRoot+ "&showTrackFlag=true&trackKey="+trackKey;
		// 流程跟踪窗口
		var winWidth = 850;
		var winHeight = 500;
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // 获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // 获得窗口的水平位置;
		window.open(url, "flowTrack",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
	}
	
	// 查看流程图(只展示未着色的流程图)
	this.flowTrackDiagram = function(processId, processInstanceId,showTrackFlag) {
		if(typeof(showTrackFlag)=="undefined"){
			showTrackFlag=false;
		}else{
			showTrackFlag=true;
		}
		var webRoot = cap.rt10.workflow.config.webRoot;
		var subSystmeRoot = cap.rt10.workflow.config.subSystmeRoot;
		subSystmeRoot= subSystmeRoot == null?'':subSystmeRoot;
		
		var url = webRoot + "/bpms/flex/" +"BpmsTrackDiagram.jsp?processId="+processId+"&processInsId="+processInstanceId+"&webRootUrl="+subSystmeRoot+"&showTrackFlag="+showTrackFlag;
		//流程跟踪图窗口
		var winWidth = 850;
		var winHeight = 500;
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // 获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // 获得窗口的水平位置;
		window.open(url, "flowTrackDiagram",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
	}
	
	// 查看流程表
	this.flowTrackTable = function(processId, processInstanceId) {
		
		var webRoot = cap.rt10.workflow.config.webRoot;
		var subSystmeRoot = cap.rt10.workflow.config.subSystmeRoot;
		subSystmeRoot= subSystmeRoot == null?'':subSystmeRoot;
		if(subSystmeRoot==""){
			subSystmeRoot = webRoot;
		}
		
		var url = webRoot + "/bpms/track/BpmsTrackTable.jsp?processId="+processId+"&processInsId="+processInstanceId+"&webRootUrl="+subSystmeRoot+"&showTrackFlag=false";
		//流程跟踪表窗口
		var winWidth = 850;
		var winHeight = 500;
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // 获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // 获得窗口的水平位置;
		window.open(url, "flowTrackTable",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
	}
	
	this.jump=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('jump');
	}
	
	this.abort=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('abort');
	}
	
	this.hungup=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('hungup');
	}
	
	this.recover=function(defaultType,getData,callback){
		setUserFunctionToConfig(getData,callback);
		approveFlowData('recover');
	}
	
	this.submit = function(){
			invokeFlowOperate();
		
	}
	
	function setUserFunctionToConfig(getData,callback){
		if(getData && isFunction(getData)){
			cap.rt10.workflow.config.getBizflowDataMethod = getData;
		}
		if(callback && isFunction(callback)){
			cap.rt10.workflow.config.operateCallBack = callback;
		}
	}
	
	function defaultApprove(operateType){
		cap.rt10.workflow.config.operateType = operateType;
		var workflowData = getBizDataBeforeOperate();
		if(!workflowData){
			console.log('数据校验出错，或提交的业务数据为空。');
			return;
		}
		if(!isArray(workflowData)){
			var singleData = workflowData;
			workflowData = [];
			workflowData[0] = singleData;
		}
		if(workflowData.length == 0){
			console.log('返回的业务数据数组长度为0');
			return;
		}
		//将提交的业务数据，转换成审批需要的数据结构
		var submitData = convertToWFParam(workflowData);
		if(submitData.length == 0){
			return;
		}
		cap.rt10.workflow.config.submitData = submitData;
		var cloneObj= copyObject(submitData[0]);
		//var cloneObj=cui.utils.parseJSON(cui.utils.stringifyJSON(submitData[0]));
		cap.rt10.workflow.userSelect.queryData = cloneObj;
		
		var nodeConfig = cap.rt10.workflow.config.currentNodeConfig;
		if(!nodeConfig || nodeConfig == null){
			//回退操作时，默认为意见必须填写
			nodeConfig = {};
			if(isBackOperate()){
				setDefaultBackConfig(nodeConfig);
			}
		}
		cap.rt10.workflow.config.currentNodeConfig = nodeConfig;
		doOperate();
	}
	
	/**
	 * 拷贝对象
	 */
	function copyObject(oldObject){
		return jQuery.extend(true, {}, oldObject);
	}
	
	function isBackOperate(){
		return cap.rt10.workflow.config.operateType == 'back' 
			|| cap.rt10.workflow.config.operateType == 'backReport'  ;
	}
	
	function isSaveNoteOperate(){
		return cap.rt10.workflow.config.operateType == 'saveNote';
	}
	
	function onlyEndNode(){
		var nextNodes = cap.rt10.workflow.userSelect.nextNodeInfos
		if(nextNodes && nextNodes.length == 1){
			return nextNodes[0] && nextNodes[0].nodeType == 'ENDEVENT';
		}
		return false;
	}
	
	function doOperate(){
		var nodeConfig = cap.rt10.workflow.config.currentNodeConfig;
		cap.rt10.workflow.userSelect.nextNodeInfos = null;
		//填写意见，弹出意见填写界面
		if(isSaveNoteOperate()){
			if(nodeConfig.needNotePage&&nodeConfig.needNotePage==="false"){
				invokeFlowOperate();
			}else{
			   openWfWindow();
			}
		}
		//回退操作
		else if(isBackOperate()){
			//指定回退，或回退意见必填，弹出界面
			if( nodeConfig.backSpecial == true 
					|| nodeConfig.backOpinionRequired == true){
				openWfWindow();
			}else{
				invokeFlowOperate();
			}
		}
		else{
			if(nodeConfig.special == true){
				//查询下一节点集合
				getNodeInfoList();
				//若下一节点是结束节点。
				if(onlyEndNode()){
					sendToEnd();
				}else if(nodeConfig.chooseFromUserDeptComponet == true){
					openUserSelectWindow();
				}else{
					openWfWindow();
				}
			}
			else if(nodeConfig.opinionRequired == true){
				openWfWindow();
			}
            // 意见是否显示
			else if (!nodeConfig.opinionRequired && nodeConfig.opinionDisplay == true) {
				openWfWindow();
			}
			else{
				invokeFlowOperate();
			}
		} 
	}
	
	function sendToEnd(){
		cui.confirm('此操作成功后，流程将审批结束。是否继续？',{
			onYes: function(){ 
					invokeFlowOperate();
				}, 
			onNo: function(){ 
					
				} 
		});
	}
	
	function approveFlowData(operateType, pNodeConfig){
		cap.rt10.workflow.config.operateType = operateType;
		var workflowData = getBizDataBeforeOperate();
		if(!workflowData){
			console.log('数据校验出错，或提交的业务数据为空。');
			return;
		}
		/*if(workflowData == null){
			console.log('数据校验出错，或提交的业务数据为空。');
			return;
		}else if(workflowData == false) {
			return;
		}else if(!workflowData){
			return;
		}*/
		if(!isArray(workflowData)){
			var singleData = workflowData;
			workflowData = [];
			workflowData[0] = singleData;
		}
		if(workflowData.length == 0){
			console.log('返回的业务数据数组长度为0');
			return;
		}
		//将提交的业务数据，转换成审批需要的数据结构
		var submitData = convertToWFParam(workflowData);
		if(submitData.length == 0){
			return;
		}
		cap.rt10.workflow.config.submitData = submitData;
		var cloneObj= copyObject(submitData[0]);
		//var cloneObj=cui.utils.parseJSON(cui.utils.stringifyJSON(submitData[0]));
		cap.rt10.workflow.userSelect.queryData = cloneObj;
		
		//根据提交的数据，计算当前的节点信息
		var nodeInfo = setCurrentNodeInfo();
		cap.rt10.workflow.config.currentNodeInfo = nodeInfo;
		//根据当前节点信息，获取当前节点上配置的扩展属性
		var nodeConfig = getNodeCongfig(pNodeConfig);
		if(!nodeConfig){
			cui.alert('获取审批节点配置信息出错，请检查流程节点扩展属性配置是否正确');
			return;
		}
		cap.rt10.workflow.config.currentNodeConfig = nodeConfig;
		doOperate();
	}

	/**
	 * 保存之前处理控件数据绑定
	 */
	function getBizDataBeforeOperate(){
		if(cap.rt10.workflow.config.getBizflowDataMethod){
			return cap.rt10.workflow.config.getBizflowDataMethod();
		}
		console.log('未指定获取业务数据的方法，或指定方法:'+cap.rt10.workflow.config.getBizflowDataMethod+'不存在。');
		return null;
		//var operateType = cap.rt10.workflow.config.operateType;
		//var beforeOperateMethod = 'cap.rt10.workflow.config.before'+operateType;
		//if(eval(beforeOperateMethod+'==undefined')){
			//return getBizData();
		//}
		//return eval(beforeOperateMethod+'()');
	}

	function convertToWFParam(workflowData){
		var operateTypeValue = eval('operateEnum.'+cap.rt10.workflow.config.operateType);
		
		var submitData = [];
		for ( var i = 0; i < workflowData.length; i++) {
			var data = {};
			data.flowState=workflowData[i].flowState;
			data.workId = workflowData[i].primaryValue;
			data.smsType = null;
			data.emailType = null;
			data.currNodeId = workflowData[i].nodeId;
			data.processVersion = workflowData[i].version ? workflowData[i].version : 0;
			data.taskId = workflowData[i].taskId;
			data.processId = workflowData[i].processId;
			data.currentUserId = cap.rt10.workflow.currentUserInfo.userId;
			data.currentUserName = cap.rt10.workflow.currentUserInfo.userName;
			data.orgId = cap.rt10.workflow.currentUserInfo.deptId;
			data.opinion = workflowData[i].opinion;
			data.processInsId = workflowData[i].processInsId;
			data.targetNodeInfos = null;
			data.authorizerId = cap.rt10.workflow.currentUserInfo.authorizerId;
			data.authorizerName= cap.rt10.workflow.currentUserInfo.authorizerName;
			data.resultFlag =  workflowData[i].resultFlag;
			data.workflowFacadeName = getWorkflowFacadeName(workflowData[i]);
			//data.paramMap = workflowData[i];
			data.paramMapString = cui.utils.stringifyJSON(workflowData[i]);
			data.operateType = operateTypeValue;
			submitData.push(data);
		}
		return submitData;
	}
	
	function getWorkflowFacadeName(workflowVO){
		if(cap.rt10.workflow.config.workflowFacadeName && cap.rt10.workflow.config.workflowFacadeName != null){
			return cap.rt10.workflow.config.workflowFacadeName;
		}
		return workflowVO.workflowFacadeName;
	}
	
	function setCurrentNodeInfo(){
		var submitData = cap.rt10.workflow.config.submitData;
		var firstData = submitData[0];
		
		if(cap.rt10.workflow.config.operateType == 'report'){
			if(cap.rt10.workflow.config.reportConfig.reportOnLastVersion == true){
				return null;
			}
			if(!firstData.processInsId || firstData.processInsId == null){
				return null;
			}
			if(firstData.flowState == null || firstData.flowState == '' || firstData.flowState == '0'){
				return null;
			}

		}
		var nodeInfo = {};
		//获取当前任务停留节点信息；
		nodeInfo.currentNodeId = firstData.nodeId;
		nodeInfo.currentNodeName = firstData.curNodeName;
		//nodeInfo.currentProcessId = firstData.curProcessId;
		nodeInfo.mainProcessId = firstData.mainProcessId;
		nodeInfo.processVersion = firstData.processVersion;
		
		if(submitData.length == 1){
			return nodeInfo;
		}
		for ( var i = 0; i < submitData.length; i++) {
			//如果提交的业务数据，所处的流程节点不相同，则当前任务停留节点信息为null；
			if(submitData[i].nodeId != nodeInfo.currentNodeId
			|| submitData[i].processVersion != nodeInfo.processVersion||
			submitData[i].mainProcessId != nodeInfo.mainProcessId){
				return null;
			}
		}
		return nodeInfo;
	}
	
	/**
	 * @param pNodeConfig 由接口传入 自定义部分属性配置
	 */
	function getNodeCongfig(pNodeConfig){
		var operateType = cap.rt10.workflow.config.operateType;
		//撤回、结束流程、终止流程、挂起流程、恢复流程不读取扩展属性
		if(operateType == 'undo'||operateType == 'overFlow'||operateType == 'abort' 
			||operateType == 'hungup'||operateType == 'recover'){
			return {};
		}
		var nodeConfig = getCustomDefineCurrentNodeAttConfig();
		if(!nodeConfig || nodeConfig == null ){
			if(cap.rt10.workflow.config.currentNodeInfo == null){
				if(operateType == 'report'){
					nodeConfig = queryFirstUserNodeConfig();
				}else{
					nodeConfig = {
							/**是否指定操作*/	
							special:false,
							/**是否显示部门选择组件*/
							viewSelectDept:false,
							/**是否显示结论选择和意见输入*/
							opinionDisplay:false,
							/**回退操作时是否必须选择不同意, (决定是否限制结论值（如：回退时，是否必须是不同意，发送时必须是同意）限制为true，反之false)*/
							limitOpinionValue : false,
							/**意见是否必须有值,( 意见是否必填，必填为true，非必填为false)*/
							opinionRequired : false,
							/** 多流程节点时是单选还是多选，单选为true，多选为false*/
							singleSelect : true,
							/**是否显示短信列*/
							smsColHide : false,
							/**是否显示邮件列*/
							emailColHide : false,
							/**是否显示选人选节点部分*/
							selectNodeUser : false,
							/**是否调用部门人员选择组件进行人员选择*/
							chooseFromUserDeptComponet:false,
							/** 是否指定回退 */
						    backSpecial : false,
						    /** 回退意见是否必填 */
						    backOpinionRequired : true
					};
				}
			}else{
				nodeConfig = queryCurrentNodeConfig();
			}
			if(!nodeConfig || nodeConfig == null){
				nodeConfig = {};
				if(isBackOperate()){
					setDefaultBackConfig(nodeConfig);
				}
			}
		}
		var operateType = cap.rt10.workflow.config.operateType;
		
		//非上报、发送操作，不显示部门过滤框
		if(operateType == 'report' ||
				operateType == 'send'){
			nodeConfig.selectNodeUser = nodeConfig.special;
		}else{
			nodeConfig.viewSelectDept=false;
			if(isBackOperate()){
				nodeConfig.selectNodeUser = nodeConfig.backSpecial;
				nodeConfig.chooseFromUserDeptComponet = false;
				nodeConfig.opinionDisplay = nodeConfig.backOpinionRequired;
			}
			//撤回操作、撤回已结束流程并回退到申请人，不用弹出页面
			else if (operateType == 'undoReport'){
				nodeConfig.special = false;
				nodeConfig.selectNodeUser = false;
				nodeConfig.chooseFromUserDeptComponet = false;
			}
			//填写意见操作，必须要弹出页面
			else if(isSaveNoteOperate()){
				nodeConfig.special = false;
				nodeConfig.selectNodeUser = false;
				nodeConfig.opinionDisplay = true;
				nodeConfig.chooseFromUserDeptComponet = false;
			}//转发操作弹出人员选择
			else if(operateType == 'reassign'){
				nodeConfig.special = true;
				nodeConfig.selectNodeUser = true;
			}
		}
		
		
		if(nodeConfig.opinionRequired == true){
			nodeConfig.opinionDisplay=true;
		}
		if(pNodeConfig){//将自定义的部分属性配置上去
			for(var pro in pNodeConfig){
				nodeConfig[pro] = pNodeConfig[pro];
			}
		}
		return nodeConfig;
	}
	
	function setDefaultBackConfig(nodeConfig){
		nodeConfig.backSpecial = false;
		nodeConfig.selectNodeUser = false;
		nodeConfig.opinionDisplay = true;
		nodeConfig.backOpinionRequired = true;
		nodeConfig.limitOpinionValue = true;
	}
	
	function queryFirstUserNodeConfig(){
		var postData = cap.rt10.workflow.userSelect.queryData;
		var remoteObj = cap.rt10.workflow.config.remoteObject;
		
		dwr.TOPEngine.setAsync(false);
		var nodeConfig;
		remoteObj.queryFirstUserNodeConfig(postData,function(data1){
			nodeConfig = data1;
		});
		dwr.TOPEngine.setAsync(true);
		return nodeConfig;
	}
	
	function queryCurrentNodeConfig(){
		var postData = cap.rt10.workflow.userSelect.queryData;
		var remoteObj = cap.rt10.workflow.config.remoteObject;
		
		dwr.TOPEngine.setAsync(false);
		var nodeConfig;
		remoteObj.queryCurrentNodeConfig(postData,function(data1){
			nodeConfig = data1;
		});
		dwr.TOPEngine.setAsync(true);
		return nodeConfig;
	}

	function getBizData(){
		if(cap.validateForm){
			if(cap.validateForm()){
				cap.beforeSave();
				if(data){
					if(isArray(data)){
						return data;
					}
					var dd = [];
					dd[0] = data;
					return dd
				}
			}
		}
		return null;
	}

	//弹出TOP的人员选择页面
	function openUserSelectWindow(){
		var obj = getTopUserSelectConfig();
	    obj.callback = 'chooseFromComponetCallback'; //定义回调函数
	    displayUserOrgTag(obj);
	}
	
	function openWfWindow(){
		// 获取当前用户信息
		var userInfo = cap.rt10.workflow.currentUserInfo;
		var sameOrgUserOrgStructureId = userInfo.deptId;
		var sameOrgUserDeptPath = userInfo.deptPath;
		
		var nodeConfig = cap.rt10.workflow.config.currentNodeConfig;
		var isOpinionDisplay = nodeConfig.opinionDisplay;
		//控制是否回退操作时必须选择不同意, (决定是否限制结论值（如：回退时，是否必须是不同意，发送时必须是同意）限制为true，反之false)
		var isLimitOpinionValue = nodeConfig.limitOpinionValue;
		//控制意见框必须有值,( 意见是否必填，必填为true，非必填为false)
		var isOpinionRequired = nodeConfig.opinionRequired;
		if(isBackOperate()){
			isOpinionRequired = nodeConfig.backOpinionRequired
		}
		// 控制是单选还是多选，单选为true，多选为false
		var isSingleSelect = nodeConfig.singleSelect;
		//控制是否发送短信
		var isSmsColHide = nodeConfig.smsColHide;
		//控制是否发送邮件
		var isEmailColHide = nodeConfig.emailColHide;
		//控制选人选节点部分是否显示
		var isSelectNodeUser = nodeConfig.selectNodeUser;
		//
		var isViewSelectDept = nodeConfig.viewSelectDept;
		// 选人界面标题
		var title = "人员选择";
		if(isSelectNodeUser == true){
			if(isSingleSelect == false){
				title = "人员选择(单选/多选)";
			}
		}else{
			title = "填写意见";
		}
		// 操作类型：默认回退：specialBack、指定下发：specialFore、指定上报：specialEntry、转发：reassign
		var actionType = cap.rt10.workflow.config.operateType;
		var recordId = cap.rt10.workflow.userSelect.queryData.workId;
		var taskId = cap.rt10.workflow.userSelect.queryData.taskId;
//		// 获取节点信息
//		_self.selectNodeInfoList(taskId,recordId);
		var height = (isOpinionDisplay && isSelectNodeUser) ? 620 : (isSelectNodeUser ? 590 : (isOpinionDisplay ? 158 : 0));
		var width = 750;
		var iTop = (window.screen.availHeight - 30 - height) / 2; // 获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth - 10 - width) / 2; // 获得窗口的水平位置;
		var webRoot = cap.rt10.workflow.config.webRoot;
		
		var windowSrc = webRoot + "/bpms/bizflow/flowmanage/UserSelect.jsp"
									+ "?actionType=" + actionType
									+ "&isViewSelectDept=" + isViewSelectDept 
									+ "&recordId=" + recordId 
									+ "&taskId=" + taskId 
									+ "&isOpinionDisplay=" + isOpinionDisplay 
									+ "&isLimitOpinionValue=" + isLimitOpinionValue 
									+ "&isOpinionRequired=" + isOpinionRequired
									+ "&isSingleSelect=" + isSingleSelect
									+ "&isSelectNodeUser=" + isSelectNodeUser 
									+ "&isEmailColHide=" + isEmailColHide 
									+ "&isSmsColHide=" + isSmsColHide 
									+ "&winHeight=" + height 
									+ "&winWidth=" + width 
									+ "&title=" + title 
									+ "&sameOrgUserOrgStructureId=" + sameOrgUserOrgStructureId 
									+ "&sameOrgUserDeptPath="+decToHex(sameOrgUserDeptPath);
		window.open(windowSrc, "userSelectPage", 'height=' + height + ',width=' + width + ',top=' + iTop + ',left=' + iLeft + ',toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
	}

	function decToHex(str) {
	    var res=[];
	    for(var i=0;i < str.length;i++)
	        res[i]=("00"+str.charCodeAt(i).toString(16)).slice(-4);
	    return "\\u"+res.join("\\u");
	}
	
	function isExecuteBatchSubmit(){
		var operateType = cap.rt10.workflow.config.operateType;
		var submitData = cap.rt10.workflow.config.submitData;
		if(submitData.length > cap.rt10.workflow.config.batchSubmitMinNum){
			if(operateType == 'report' 
				|| operateType == 'send'
				|| operateType == 'back'
				|| operateType == 'backReport'
				||operateType == 'reassign'){
				return true;
			}
		}
		return false;
	}
	
	function invokeFlowOperate(){
		var handleMask = cui.handleMask;
		//打开进度条
		handleMask.show();
		
		if(!cap.rt10.workflow.config.remoteObject || cap.rt10.workflow.config.remoteObject == null){
			cui.alert('服务对象为空,不能访问后台服务.');
			return;
		}
		var bizCallBackFun = cap.rt10.workflow.config.operateCallBack ;
		if (!bizCallBackFun || bizCallBackFun == null){
			bizCallBackFun = defaultOperateCallBack;
		}
		var operateType = cap.rt10.workflow.config.operateType;
		var submitData = cap.rt10.workflow.config.submitData;
		
		if(!cap.rt10.workflow.config.currentNodeConfig.needNotePage&&cap.rt10.workflow.config.currentNodeConfig.needNotePage!="false"){
			var selectedNode = cap.rt10.workflow.userSelect.selectedNodeUse;
			if(selectedNode && selectedNode != null){
				var jsonString = cui.utils.stringifyJSON(cap.rt10.workflow.userSelect.selectedNodeUse);
				for ( var i = 0; i < submitData.length; i++) {
					submitData[i].resultFlag = cap.rt10.workflow.userSelect.targetOpinionResult;
					if(cap.rt10.workflow.userSelect.targetOpinionText){
						submitData[i].opinion = cap.rt10.workflow.userSelect.targetOpinionText;
					}
					//submitData[i].targetNodeInfos = cap.rt10.workflow.userSelect.selectedNodeUse;
					submitData[i].tagNodeInfoString = jsonString;
				}
			}
		}
		//每次处理完成后需要清除选中的人员数据，当当前页面有多个流程节点时，上一个节点选中的数据会影响下一个节点的选中数据
		cap.rt10.workflow.userSelect.selectedNodeUse = null;
		
		var decoratedFunction = function(result){
			//关闭进度条
			handleMask.hide();
			bizCallBackFun(result);
		};
		
		if(isExecuteBatchSubmit()){
			cap.rt10.workflow.config.remoteObject.batchSubmit(submitData,{callback:function(result){
				decoratedFunction(result);
			},errorHandler:function(){
				handleMask.hide();
				cui.warn('操作失败！');
			}});
		}else{
			cap.rt10.workflow.config.remoteObject.submit(submitData,{callback:function(result){
				decoratedFunction(result);
			},errorHandler:function(){
				handleMask.hide();
				cui.warn('操作失败！');
			}});
		}
	}
	
};

function isUserTaskNode(nodeInfo){
	return nodeInfo && nodeInfo.nodeType === "USERTASK"
}

/**
 * 获取业务自定义的目标节点集合，在使用TOP的人员选择组件时，由业务返回目标节点集合
 * @returns
 */
function getCustomDefineTargetNodeInfo4TopSelect(){
	return null;
}

/**
 * 获取业务自定义的当前节点扩展属性集合，业务可通过重写此方法指定业务特有的扩展属性
 * @returns
 */
function getCustomDefineCurrentNodeAttConfig(){
	return null;
}

/**
 * 使用top的人员选择组件时，确定人员选择组件的配置信息，必要时此方法可有业务模块重写
 * @returns
 */
function getTopUserSelectConfig(){
    var obj ={};
    obj.chooseMode = 0; //控制可选人数，0默认无限制
    obj.chooseType = 'user';//弹出人员选择页面
    obj.userType = 1; //1 在职，2是离职
    obj.rootId='';
    obj.orgStructureId='';
    return obj;
}

/**
 *top选人后回调
 * 回调方法，参数1：selected，参数2：tagId，selected参数为节点信息，tagId为当前选择的标签id
 */
function chooseFromComponetCallback(selected,tagId){
	if(!selected ||selected.length < 1){
		cui.alert("流程审批信息校验不通过，未选择流程处理人。");
    	return;
	}
	//采用TOP的人员选择界面时，目标节点需要业务模块在页面上赋值
	var nodeInfoList ;
	var operateType = cap.rt10.workflow.config.operateType;
	if(operateType == 'reassign'){
		nodeInfoList = cap.rt10.workflow.config.currentNodeInfo;
	}else{
		nodeInfoList = getCustomDefineTargetNodeInfo4TopSelect();
	}
    if (null == nodeInfoList) {
    	cui.alert("流程审批信息校验不通过，未设置流程节点。");
    	return;
    }
    for (var i in nodeInfoList) {
        var nodeInfo = nodeInfoList[i];
        if(isUserTaskNode(nodeInfo)){
        	nodeInfo.users = formatUser(selected,nodeInfo);
        }
    }
    if(!businessValidate(nodeInfoList)){
    	return;
    }
    cap.rt10.workflow.userSelect.targetOpinionText = null;
    cap.rt10.workflow.userSelect.targetOpinionResult = null;
    cap.rt10.workflow.userSelect.selectedNodeUse = nodeInfoList;
	cap.rt10.workflow.operate.submit();
}

/** 获取部门选择需要的参数，部门ID和部门路径 */
//这两个变量采用 getNodeFilterDeptParam(nodeInfo)
//返回{sameOrgUserOrgStructureId:sameOrgUserOrgStructureId,sameOrgUserDeptPath:sameOrgUserDeptPath}
//+ "&sameOrgUserOrgStructureId=" + sameOrgUserOrgStructureId 
//+ "&sameOrgUserDeptPath="+_self.decToHex(sameOrgUserDeptPath);
function getNodeFilterDeptParam(nodeInfo){
	var userInfo = cap.rt10.workflow.userSelect.filterUserInfo;
	if(!userInfo){
		userInfo = cap.rt10.workflow.currentUserInfo;
	}
	var jsonData = {
			sameOrgUserOrgStructureId:userInfo.deptId,
			sameOrgUserDeptPath:userInfo.deptPath
	    }
	return jsonData;
}

/** 将TOP人员选择页面的传递的数据，格式化成nodeInfo需要的数据 */
function  formatUser(selected,nodeInfo){
	var result;
	var users = [];
	if (null != selected) {
        for (var i in selected) {
        	var user= {};
        	var tempUser = selected[i];
        	user.userId  = tempUser.id;
        	user.userName  = tempUser.name;
        	user.deptId  = tempUser.orgId;
        	user.deptPath  = tempUser.orgName;
        	user.sendSMS  = false;
        	user.sendEmail  = false;
        	users.push(user);
        }
    }
	return users;
}

function bpmsUserSelectCallback(opinion,opinionText,nodeInfo,actionType){
	cap.rt10.workflow.userSelect.targetOpinionText = opinionText;
    cap.rt10.workflow.userSelect.targetOpinionResult = opinion;
    cap.rt10.workflow.userSelect.selectedNodeUse = cui.utils.parseJSON(nodeInfo);
	cap.rt10.workflow.operate.submit();
}

function defaultOperateCallBack(result){
	//var operateType = cap.rt10.workflow.config.operateType;
	//var submitData = cap.rt10.workflow.config.submitData;
	cui.message('操作成功！', 'success');
	window.location.reload();
}

/** 返回节点信息*/
function getNodeInfoList(taskId,recordId) {
	var nextNodes = cap.rt10.workflow.userSelect.nextNodeInfos;
	if(nextNodes && nextNodes != null){
		return nextNodes;
	}
	
	var postData = cap.rt10.workflow.userSelect.queryData;
	
	var remoteObj = cap.rt10.workflow.config.remoteObject;
	var operateType = cap.rt10.workflow.config.operateType;
	
	dwr.TOPEngine.setAsync(false);
	if(operateType == 'send' || operateType == 'report'){
		remoteObj.queryForeNode(postData,function(data1){
			cap.rt10.workflow.userSelect.nextNodeInfos = data1;
		});
	}else if(operateType == 'back'/**||operateType =='backReport'*/){
		remoteObj.queryBackNode(postData,function(data1){
			cap.rt10.workflow.userSelect.nextNodeInfos = data1;
		});
	}else if(operateType == 'reassign'){
		remoteObj.queryReassignNode(postData,function(data1){
			cap.rt10.workflow.userSelect.nextNodeInfos = data1;
		});
	}else if(operateType == 'jump'){
		//TODO
	}
	dwr.TOPEngine.setAsync(true);
	return cap.rt10.workflow.userSelect.nextNodeInfos;
}

/** 判断节点是否单选 */
function isNodeSingleSelect(nodeinfolist){
	// 如果存在系统节点，则判断为可以多选
	for (var i in nodeinfolist) {
		var nodeInfo = nodeinfolist[i];
		if(nodeInfo.cooperationFlag == true){
			return false;
		}
	}
	return true;
}

/** 获取下发某个节点对应的人员信息*/
function getNodeAllUsers(currSelectNodeId,version,nameKeyWord,orgId) {
	
	var operateType = cap.rt10.workflow.config.operateType; 
	if(operateType == 'send'||operateType == 'report'){
		var param = cap.rt10.workflow.userSelect.queryData;
		param.paramKey = cap.rt10.workflow.userSelect.currentNodeFlowParam;
		param.orgId = orgId;
		var remoteObj = cap.rt10.workflow.config.remoteObject;
		
		var userlist = [];
		
		dwr.TOPEngine.setAsync(false);
		remoteObj.queryUserListByNode(param,version,currSelectNodeId,nameKeyWord,function(resultData) {
			userlist = resultData;
		});
		dwr.TOPEngine.setAsync(true);
		return userlist;
	}else{
		var allNodeUserData = cap.rt10.workflow.userSelect.nextNodeInfos;
		if (null != allNodeUserData) {
			for (var i = 0; i < allNodeUserData.length; i++) {
                var nodeInfo = allNodeUserData[i];
                if(nodeInfo.nodeId == currSelectNodeId){
                	return nodeInfo.users;
                }
			}
			return allNodeUserData[0].users;
		}
		return [];
	}
}

/** 获取是否显示部门选择组件 */
function getViewSelectDeptFlag(nodeInfo){
	var resultFlag = false;
	if (nodeInfo) {
		var hasFilterFunction = nodeInfo.hasFilterFunction;
		// 节点上不存在过滤函数，不显示部门选择框
		if(false == hasFilterFunction){
			return false;
		}
		// 如果存在过滤函数
		if (true == hasFilterFunction) {
			var functionInfo = nodeInfo.functionInfo;
			// 如果过滤函数是以人员作为过滤条件的，不现实部门选择条件
            if (functionInfo && functionInfo.length > 0) {
                for (var i = 0; i < functionInfo.length; i++) {
                    var func = functionInfo[i];
                    // 如果是过滤函数
                    if(func && func.functionType == "filter"){
                        if (func.functionCode && ("getUsersBySameDepart" == func.functionCode || "getUserByUserId" == func.functionCode)) {
                            resultFlag = false;
                            break;
                        }else{
                        	var funcParam = func.funcParamInfo;
                        	// 如果过滤函数存在参数变量，获取第一个参数的key
                        	if(funcParam && functionInfo.length > 0){
                        		cap.rt10.workflow.userSelect.currentNodeFlowParam = funcParam[0].paramKey;
                        		resultFlag = true;
                        	}
                        }
                    }
                };
            }
            // 如果是过滤函数，并且需要获取对应的部门信息
            if(resultFlag == true){
            	getFilterUserInfo();
            }
            
            // 如果存在过滤函数，并且过滤条件为多个部门id，不显示部门选择条件
            var userInfo = cap.rt10.workflow.userSelect.filterUserInfo;
            if(userInfo.deptId && userInfo.deptId.split(",").length > 1){
            	resultFlag = false;
            }
		}
	}
	return resultFlag;
}

function getFilterUserInfo(){ 
	var queryData = cap.rt10.workflow.userSelect.queryData;
	var remoteObj = cap.rt10.workflow.config.remoteObject;
	
	dwr.TOPEngine.setAsync(false);
	remoteObj.getDeptFilerParam(queryData,function(data1){
		cap.rt10.workflow.userSelect.filterUserInfo = data1;
		});
	dwr.TOPEngine.setAsync(true);
}

/**
 * 工作流待办已办意见回调函数
 * 
 * @returns {String}
 */
function getOpinionInfo() {
	var opinion = "";
	var bizData = cap.rt10.workflow.config.submitData;
	var remoteObj = cap.rt10.workflow.config.remoteObject;
	if (!bizData || !remoteObj || bizData.length <= 0)
		return opinion;

	if (bizData.length > 1) {
		return opinion;
	}

	if (bizData[0].opinion) {
		opinion = bizData[0].opinion;
	}
	return opinion;
}

/**
 * 检验选择的节点集合
 * @param nodeInfoList
 * @returns {Boolean}
 */
function businessValidate(nodeInfoList){
	if(cap.rt10.workflow.config.userSelectCheck && cap.rt10.workflow.config.userSelectCheck != null){
    	var checkResult = cap.rt10.workflow.config.userSelectCheck(nodeInfoList);
    	if(checkResult != true){
    		return false;
    	}
    }
	return true;
}

function isArray(obj){
	return Object.prototype.toString.call(obj) === '[object Array]'; 
}

function isFunction(obj){
	return Object.prototype.toString.call(obj) === '[object Function]'; 
}


