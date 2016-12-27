/*
 * 业务工作流流程处理相关代码 by 龚斌 Date: 14-7-15 Time: 上午14:48
 */
(function(root) {
	// 需要作为全局对象的bpms
	var bizFlow = root.bizFlow = {};
	
	var $ = jQuery.noConflict();
	
	// 参数配置
	var config = {};
	
	// 处理流程ajax参数json
	var auditOptions = {};
	// 流程处理结果信息（JSON格式）
	var flowResultJson = {};
	
	// 处理流程的url
	var auditUrl = subSystmeRoot + "/bizflow/bizFlowOperateAction.do";
	// 处理流程工具Action URL
	var auditUtilUrl = subSystmeRoot + "/bizflow/bizFlowUtilAction.do";

	// 流程操作是否是指定之后的工作流处理
	var isSpecialFlow = false;

	bizFlow.ENTRY_SUCCESS = "上报成功";
	bizFlow.ENTRY_FAIL = "上报失败";
	bizFlow.FORE_SUCCESS = "发送成功";
	bizFlow.FORE_FAIL = "发送失败";
	bizFlow.BACK_SUCCESS = "回退成功";
	bizFlow.BACK_FAIL = "回退失败";
	bizFlow.REASSIGN_SUCCESS = "转发成功";
	bizFlow.REASSIGN_FAIL = "转发失败";
	bizFlow.UNDO_SUCCESS = "撤回成功";
	bizFlow.UNDO_FAIL = "已被处理，不能撤回";
	bizFlow.UPDATE_SUCCESS = "填写意见成功";
	bizFlow.UPDATE_FAILURE = "填写意见失败";
	bizFlow.OVER_SUCCESS = "结束流程成功";
	bizFlow.OVER_FAILURE = "结束流程失败";
	bizFlow.JUMP_SUCCESS = "审批通过成功";
	bizFlow.JUMP_FAILURE = "审批通过失败";
	bizFlow.ajaxErrorMsg = "网络出现错误或服务器内部出现错误，请刷新页面";
	// 后台正常处理返回提示信息常量Json
	var handleResultConstants = {
		"entrySuccess" : bizFlow.ENTRY_SUCCESS,
		"entryFailure" : bizFlow.ENTRY_FAIL,
		"foreSuccess" : bizFlow.FORE_SUCCESS,
		"foreFailure" : bizFlow.FORE_FAIL,
		"backSuccess" : bizFlow.BACK_SUCCESS,
		"backFailure" : bizFlow.BACK_FAIL,
		"undoSuccess" : bizFlow.UNDO_SUCCESS,
		"undoFailure" : bizFlow.UNDO_FAIL,
		"reassignSuccess" : bizFlow.REASSIGN_SUCCESS,
		"reassignFailure" : bizFlow.REASSIGN_FAIL,
		"updateSuccess" : bizFlow.UPDATE_SUCCESS,
		"updateFailure" : bizFlow.UPDATE_FAILURE,
		"overSuccess" : bizFlow.OVER_SUCCESS,
		"overFailure" : bizFlow.OVER_FAILURE,
		"jumpSuccess" : bizFlow.JUMP_SUCCESS,
		"jumpFailure" : bizFlow.JUMP_FAILURE,
		"doBatchSpecialEntry" : "批量指定上报",
		"doBatchSpecialFore" : "批量指定发送",
		"doBatchSpecialBack" : "批量指定回退",
		"doBatchReassign" : "批量转发"
	};

	// 后台出现异常的提示信息常量Json
	var handleExceptionResultConstants = {
		"handleEntry" : bizFlow.ENTRY_FAIL,
		"handleBatchEntry" : bizFlow.ENTRY_FAIL,
		"handleFore" : bizFlow.FORE_FAIL,
		"handleBatchFore" : bizFlow.FORE_FAIL,
		"handleBack" : bizFlow.BACK_FAIL,
		"handleBatchBack" : bizFlow.BACK_FAIL,
		"handleBatchReassign" : bizFlow.REASSIGN_FAIL,
		"handleUndo" : bizFlow.UNDO_FAIL,
		"handleBatchUndo" : bizFlow.UNDO_FAIL
	};

	// 扩展JQuery 判断undefined 方法
	$.extend( {
		isUndefined : function(obj) {
			return obj === void 0;
		}
	});

	// 发送ajax请求方法
	var sendAjaxRequest = function(options) {
		options.data = $.extend(options.data, {
			"encoding" : "UTF-8"
		});
		// ajax请求
		$.ajax( {
			type : "POST", // 提交方式：get/post
			dataType : "json", // 返回数据格式：json/xml/html/test
			async : $.isUndefined(options.async) ? true : options.async,
			url : options.url, // 请求地址路径
			data : options.data, // 请求参数
			error : function(json) {
				if (options.error) {
					options.error(json, options);
				}
			},
			success : function(json) {
				if (options.success) {
					options.success(json, options);
				}
			}
		})
	};

	// 工作流相关事件绑定
	var cardListBpmsInit = function(options) {
		config = $.extend(config, options);
		config.isEditPage = false;
		showTaskNode();
		cardListEventBind();
	};

	// 编辑页面初始化方法
	var editPageBpmsInit = function(options) {
		config = $.extend(config, options);
		config.isEditPage = true;
		editPageEventBind();
	};

	//列表流程相关按钮事件绑定
	var cardListEventBind = function() {
		// 批量上报按钮事件绑定
		$('#btn-batch-entry').click(function() {
			flowBatchButtonEvent("handleBatchEntry");
		});
		// 批量下发按钮事件绑定
		$('#btn-batch-fore').click(function() {
			flowBatchButtonEvent("handleBatchFore");
		});
		// 批量回退按钮事件绑定
		$('#btn-batch-back').click(function() {
			flowBatchButtonEvent("handleBatchBack");
		});
		// 默认回退按钮事件绑定（支持批量）
		$('#btn-batch-default-back').click(function() {
			flowBatchButtonEvent("handleBatchDefaultBack");
		});
		// 指定回退按钮事件绑定（支持批量）
		$('#btn-batch-special-back').click(function() {
			flowBatchButtonEvent("handleBatchSpecialBack");
		});
		// 回退申请人按钮事件绑定（支持批量）
		$('#btn-batch-request-back').click(function() {
			flowBatchButtonEvent("handleBatchRequestBack");
		});
		// 批量撤回
		$('#btn-batch-undo').click(function() {
			flowBatchButtonEvent("handleBatchUndo");
		});
		// 批量撤回申请人
		$('#btn-batch-undo-request').click(function() {
			flowBatchButtonEvent("handleBatchUndoRequest");
		});
		// 批量结束流程
		$('#btn-batch-over-flow').click(function() {
			flowBatchButtonEvent("handleBatchOverFlow");
		});
		// 批量jump跳转结束流程
		$('#btn-batch-jump-flow').click(function() {
			flowBatchButtonEvent("handleBatchJumpFlow");
		});
		// 批量填写意见
		$('#btn-batch-update-task-note').click(function() {
			flowBatchButtonEvent("handleBatchUpdateTaskNote");
		});
	};

	// 编辑或者查看页面事件绑定
	var editPageEventBind = function() {
		// 编辑页面上报按钮事件绑定
		$('#btn-entry').click(function() {
			flowButtonEvent("handleEntry");
		});
		// 详细页面发送按钮事件绑定
		$('#btn-fore').click(function() {
			flowButtonEvent("handleFore");
		});
		// 详细页面撤回按钮事件绑定
		$('#btn-undo').click(function() {
			flowButtonEvent("handleUndo");
		});
		// 详细页面撤回申请人按钮事件绑定
		$('#btn-undo-request').click(function() {
			flowButtonEvent("handleUndoRequest");
		});
		// 详细页面结束流程按钮事件绑定
		$('#btn-over-flow').click(function() {
			flowButtonEvent("handleOverFlow");
		});
		// 详细页面结束流程按钮事件绑定
		$('#btn-jump-flow').click(function() {
			flowButtonEvent("handleJumpFlow");
		});
		// 详细页面填写意见按钮事件绑定
		$('#btn-update-task-note').click(function() {
			flowButtonEvent("handleUpdateTaskNote");
		});
		// 回退按钮事件绑定
		$('#btn-back').click(function() {
			flowButtonEvent("handleBatchBack");
		});
		// 默认回退按钮事件绑定
		$('#btn-default-back').click(function() {
			flowButtonEvent("handleBatchDefaultBack");
		});
		// 指定回退按钮事件绑定
		$('#btn-special-back').click(function() {
			flowButtonEvent("handleBatchSpecialBack");
		});
		// 回退申请人按钮事件绑定
		$('#btn-request-back').click(function() {
			flowButtonEvent("handleBatchRequestBack");
		});
	};

	// 流程相关按钮绑定事件通用方法（单条记录）
	var flowButtonEvent = function(actionType) {
		var options = {
			"actionType" : actionType
		};
		config = $.extend(config, options);
		if ("handleUpdateTaskNote" == actionType) {
			updateTaskNoteDialog();
		} else if ("handleBatchDefaultBack" == actionType || "handleBatchRequestBack" == actionType) {
			updateTaskNoteDialog(actionType);
		} else {
			doFlow();
		}
	};

	// 流程相关按钮绑定事件通用方法（批量）
	var flowBatchButtonEvent = function(actionType) {
		var options = {
			"actionType" : actionType
		};
		config = $.extend(config, options);
		if ("handleBatchUpdateTaskNote" == actionType) {
			batchUpdateTaskNoteDialog();
		} else if ("handleBatchDefaultBack" == actionType || "handleBatchRequestBack" == actionType) {
			batchUpdateTaskNoteDialog(null, actionType);
		} else {
			doBatchFlow();
		}
	};

	//上报 paramArray：参数对象数组 ，对象属性  workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleEntryFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchEntry");
	};
	
	//下发  paramArray：参数对象数组 ，对象属性 workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleForeFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchFore");
	};
	
	//回退  paramArray：参数对象数组 ，对象属性  workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleBackFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchBack");
	};
	
	//默认回退  paramArray：参数对象数组 ，对象属性    workId：工单号  workName：工单名称 todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleDefaultBackFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchDefaultBack");
	};
	
	//指定回退  paramArray：参数对象数组 ，对象属性   workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleSpecialBackFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchSpecialBack");
	};
	
	//回退申请人  paramArray：参数对象数组 ，对象属性   workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleRequestBackFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchRequestBack");
	};
	
	//撤回  paramArray：参数对象数组 ，对象属性  workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleUndoFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchUndo");
	};
	
	//申请人撤回  paramArray：参数对象数组 ，对象属性  workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleUndoFlowRequest = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchUndoRequest");
	};
	
	//结束流程  paramArray：参数对象数组 ，对象属性  workId：工单号  workName：工单名称 todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleOverFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchOverFlow");
	};
	
	//跳转结束流程  paramArray：参数对象数组 ，对象属性  workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleJumpFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchJumpFlow");
	};
	
	//填写意见  paramArray：参数对象数组 ，对象属性  workId：工单号  workName：工单名称  todoTaskId：待办ID doneTaskIdArray：已办ID processInstanceId：流程实例id
	var handleUpdateTaskNote = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchUpdateTaskNote");
	};
	
	//流程批量操作 根据参数对象
	var flowBatchOperate = function(paramArray,actionType) {
		var options = { "actionType" : actionType };
		config = $.extend(config, options);
		var data = {};
		data.paramArray = paramArray;
		if ("handleBatchUpdateTaskNote" == actionType) {
			batchUpdateTaskNoteDialog(data);
		} else {
			doBatchFlow(data);
		}
	};
	
	//弹出指定下发人员选择框
	var openFlowSpecialDialog = function(json) {
		var isOpinionDisplay = true;    //控制结论选择和意见输入是否显示
		var isSelectNodeUser = true;    //控制选人选节点部分是否显示
		var isLimitOpinionValue = true; //控制是否回退操作时必须选择不同意
		var isOpinionRequired = false;  //控制意见框必须有值
		//var isSingleSelect = true;      //控制是单选还是多选
		var isEmailColHide = false;      //控制邮件列隐藏
		var isSmsColHide = false;      //控制邮件列隐藏
		var isViewSelectDept = false;      //显示部门选择框
        var sameOrgUserOrgStructureId = '';      //显示部门选择框
        var sameOrgUserDeptPath = '';      //显示部门选择框
		/*
		 * isOpinionDisplay和isSelectNodeUser都为true,winHeight = 514
		 * isSelectNodeUser为true,winHeight = 407
		 * isOpinionDisplay为true,winHeight = 158
		 */
		var winWidth = 750;
		var winHeight = (isOpinionDisplay && isSelectNodeUser) ? 620 : 
			(isSelectNodeUser ? 510 : (isOpinionDisplay ? 158 : 0));
		var windowSrc = webRoot
				+ "/bpms/bizflow/flowmanage/UserSelect.jsp"
				+ "?actionType=" + json.bpmsAuditParamsVO.actionType
				+ "&isOpinionDisplay=" + isOpinionDisplay 
				+ "&isLimitOpinionValue=" + isLimitOpinionValue 
				+ "&isOpinionRequired=" + isOpinionRequired
				//+ "&isSingleSelect=" + isSingleSelect
				+ "&isSelectNodeUser=" + isSelectNodeUser 
				+ "&isEmailColHide=" + isEmailColHide 
				+ "&isSmsColHide=" + isSmsColHide 
				+ "&winHeight=" + winHeight 
				+ "&winWidth=" + winWidth
				+ "&isViewSelectDept=" + isViewSelectDept
                + "&sameOrgUserDeptPath=" + sameOrgUserDeptPath
                + "&sameOrgUserOrgStructureId=" + sameOrgUserOrgStructureId;
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // 获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // 获得窗口的水平位置;
		window.open(windowSrc, "userSelectPage",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
	};

	//单据意见更新相关操作
	var updateTaskNoteFucObj = {};
	// 更新待办意见
	var updateTaskNoteDialog = function(actionType) {
		// 验证待办参数以及设置更新待办所需的参数
		if (vlidataAndSetTaskParams(actionType)) {
			var topWin = window.top;
			var top = "100px", left = "50%";
			left = (document.documentElement.scrollWidth - 460) / 2;
			left =  left < 0 ? "50%" : left;
			top = 60 + document.body.scrollTop+topWin.document.body.scrollTop;
			cacheObj.createDialog("update-task-note",
							cui.dialog({
										title : '填写意见',
										src : webRoot + "/bpms/bizflow/flowmanage/UpdateTaskNote.jsp?actionType="+actionType,
										page_scroll : false,
										top: top,
										left: left,
										width : 460,
										height : 410
									})).show();
		}
	};

	// 传入意见信息，进行待办意见更新
	var updateTaskNoteByNote = function(resultFlag, note) {
		// 验证待办参数以及设置更新待办所需的参数
		if (vlidataAndSetTaskParams()) {
			updateTaskNoteFucObj.updateTaskNote(resultFlag, note);
		}
	};

	// 根据传入参数更新意见（供业务代码直接传递参数调用JS方法）
	var updateSingleTaskNote = function(processInstanceId, todoTaskId, moduleId) {
		document.bpmsEditFlowForm = {};
		document.bpmsEditFlowForm.workId = {"value" : ""};
		document.bpmsEditFlowForm.workName = {"value" : ""};
		document.bpmsEditFlowForm.todoTaskId = {"value" : todoTaskId};
		document.bpmsEditFlowForm.doneTaskId = {"value" : ""};
		document.bpmsEditFlowForm.processInstanceId = {"value" : processInstanceId};
		document.bpmsEditFlowForm.moduleId = {"value" : moduleId};
		updateTaskNoteDialog();
	};

	// 设置更新待办所需的参数
	var vlidataAndSetTaskParams = function(actionType) {
		var batchJson = getFlowJson();
		if ('' == (batchJson[0]).processInstanceId || '' == (batchJson[0]).todoTaskId || '' == (batchJson[0]).moduleId) {
			cui.error("单据不合法，请先检查完整性！");
			return false;
		}
		// 把参数设置到updateTaskNoteFucObj对象上，在弹出框页面使用
		updateTaskNoteFucObj.isQueryNote = true;
		updateTaskNoteFucObj.processInstanceId = (batchJson[0]).processInstanceId;
		updateTaskNoteFucObj.todoTaskId = (batchJson[0]).todoTaskId;
		updateTaskNoteFucObj.moduleId = (batchJson[0]).moduleId;
		updateTaskNoteFucObj.auditUrl = auditUrl;
		updateTaskNoteFucObj.sendAjaxRequest = sendAjaxRequest;
		// 流程相关参数
		auditOptions = {
			"url" : auditUrl,
			"data" : {
				"actionType" : ("handleBatchDefaultBack" == actionType || "handleBatchRequestBack" == actionType)? actionType :"handleUpdateTaskNote",
				"batchJson" : JSON.stringify(batchJson)
			},
			"error" : function(json) {
				cui.message(bizFlow.ajaxErrorMsg, 'error', {
					width : 350
				});
			},
			"success" : function(json) {
				var handleResult = json.bpmsAuditParamsVO.handleResult;
				if (handleResult.indexOf('updateFailure') != -1) {
					cui.alert(handleResultConstants[handleResult], 'error');
				} else {
					cui.message(handleResultConstants[handleResult], 'success');
				}
				
				//回退操作时会刷新页面
				if ("handleBatchDefaultBack" == actionType || "handleBatchRequestBack" == actionType) {
					if (config.success && config.success.auditSuccess) {
						config.success.auditSuccess(handleResultConstants[handleResult]);
					} else {
						var $moduleForm = $('#' + config.extendParams.formId);
						$moduleForm.action = config.url.listUrl;
						$moduleForm.target = "_self";
						$moduleForm.method = "POST";
						$moduleForm.submit();
					}
				}
			}
		};
		updateTaskNoteFucObj.auditOptions = auditOptions;
		return true;
	};

	// 批量更新任务待办
	var batchUpdateTaskNoteDialog = function(data, actionType) {
		var checkedCount = 0;
		var errorCount = 0;
		var $checkBox = null;
		var objJson = null;
		// 可以提交的记录JSON
		var batchJson = [];
		if (data && data.paramArray) {
			var paramArray = data.paramArray;
			var paramObj = null;
			for (var i = 0; i < paramArray.length; i++) {
				checkedCount++;
				paramObj = paramArray[i];
				batchJson.push(getBatchFlowJsonByParams(paramObj));
			}
		} else {
			$("#tableMain").find("tbody input[type='checkbox']:checked").each(
					function() {
						$checkBox = $(this);
						checkedCount++;
						objJson = getBatchFlowJson($checkBox);
						if ('' == objJson.processInstanceId || '' == objJson.todoTaskId || '' == objJson.moduleId) {
							errorCount++;
						} else {
							batchJson.push(objJson);
						}
					});
		}
		if (checkedCount === 0) {
			cui.error("请先选择单据！");
			if(window.cancel){
				cancel();
			}
			return;
		} else if (errorCount > 0) {
			cui.error("存在" + errorCount + "条不合法单据，请先检查完整性！");
			if(window.cancel){
				cancel();
			}
			return;
		}
		// 如果只有一条 需要把查询出意见信息
		if (1 == checkedCount) {
			// 把参数设置到updateTaskNoteFucObj对象上，在弹出框页面使用
			updateTaskNoteFucObj.isQueryNote = true;
			updateTaskNoteFucObj.processInstanceId = batchJson[0].processInstanceId;
			updateTaskNoteFucObj.todoTaskId = batchJson[0].todoTaskId;
			updateTaskNoteFucObj.moduleId = batchJson[0].moduleId;
			updateTaskNoteFucObj.auditUrl = auditUrl;
			updateTaskNoteFucObj.sendAjaxRequest = sendAjaxRequest;
		} else {
			updateTaskNoteFucObj.isQueryNote = false;
		}
		cacheObj.createDialog( "update-task-note",
				cui.dialog( {
					title : '填写意见',
					src : webRoot + "/bpms/bizflow/flowmanage/UpdateTaskNote.jsp?actionType="+actionType,
					page_scroll : false,
					width : 460,
					height : 410
				})).show();
		auditOptions = {
			"url" : auditUrl,
			"data" : {
				"actionType" : ("handleBatchDefaultBack" == actionType || "handleBatchRequestBack" == actionType) ? actionType :"handleBatchUpdateTaskNote",
				"batchJson" : JSON.stringify(batchJson)
			},
			"error" : function(json) {
				cui.message(bizFlow.ajaxErrorMsg, 'error', { width : 350 });
			},
			"success" : function(json) {
				var msgConstans = "条单据";
				var handleResult = json.bpmsAuditParamsVO.handleResult;
				var successCount = json.bpmsAuditParamsVO.successCount;
				var msg = "";
				if (handleResult.indexOf('updateFailure') != -1) {
					// 几条处理失败
					msg = checkedCount + msgConstans + handleResultConstants[handleResult];
					if (config.error && config.error.auditError) {
						config.error.auditError(json);
					} else {
						cui.alert(msg, 'error');
					}
				} else {
					if (checkedCount > successCount) {
						// 几条成功几条失败
						var msg1 = successCount + msgConstans + handleResultConstants[handleResult];
						var msg2 = (checkedCount - successCount) + msgConstans + bizFlow.UPDATE_FAILURE;
						msg = msg1 + "," + msg2;
						cui.alert(msg, 'success');
					} else if (checkedCount === successCount) {
						// 几条成功
						msg = successCount + msgConstans + handleResultConstants[handleResult];
						cui.message(msg, 'success');
					}
					
					//回退操作时会刷新页面
					if ("handleBatchDefaultBack" == actionType || "handleBatchRequestBack" == actionType) {
						if (config.success && config.success.auditSuccess) {
							config.success.auditSuccess(msg);
						} else {
							var $moduleForm = $('#' + config.extendParams.formId);
							$moduleForm.action = config.url.listUrl;
							$moduleForm.target = "_self";
							$moduleForm.method = "POST";
							$moduleForm.submit();
						}
					}
				}
			}
		};
		updateTaskNoteFucObj.auditOptions = auditOptions;
	};

	// 更新待办回掉函数 resultFlag 结论 note意见
	updateTaskNoteFucObj.updateTaskNote = function(resultFlag, note) {
		this.auditOptions.data = $.extend(this.auditOptions.data, {
			"resultFlag" : resultFlag,
			"flowOpinion" : note
		});
		sendAjaxRequest(this.auditOptions);
	};

	// NotionDetail页面带意见发送
	updateTaskNoteFucObj.flowNotionFore = function(resultFlag, note, isParentShow) {
		updateTaskNoteFucObj.resultFlag = resultFlag;
		updateTaskNoteFucObj.flowOpinion = note;
		updateTaskNoteFucObj.isParentShow = isParentShow;
		var data = {
			"actionType" : "handleBatchFore",
			"resultFlag" : resultFlag,
			"flowOpinion" : note,
			"isDefaultNoMsg" : "false"
		};
		var options = {
			"actionType" : "handleBatchFore"
		};
		config = $.extend(config, options);
		doFlow(data);
	};

	// NotionDetail页面带意见回退
	updateTaskNoteFucObj.flowNotionBack = function(resultFlag, note, isParentShow) {
		updateTaskNoteFucObj.resultFlag = resultFlag;
		updateTaskNoteFucObj.flowOpinion = note;
		updateTaskNoteFucObj.isParentShow = isParentShow;
		var data = {
			"actionType" : "handleBatchBack",
			"resultFlag" : resultFlag,
			"flowOpinion" : note,
			"isDefaultNoMsg" : "false"
		};
		var options = {
			"actionType" : "handleBatchBack"
		};
		config = $.extend(config, options);
		doFlow(data);
	};

	// NotionDetail页面带意见回退到申请人
	updateTaskNoteFucObj.flowNotionRequestBack = function(resultFlag, note, isParentShow) {
		updateTaskNoteFucObj.resultFlag = resultFlag;
		updateTaskNoteFucObj.flowOpinion = note;
		updateTaskNoteFucObj.isParentShow = isParentShow;
		var data = {
			"actionType" : "handleBatchRequestBack",
			"resultFlag" : resultFlag,
			"flowOpinion" : note,
			"isDefaultNoMsg" : "false"
		};
		var options = {
			"actionType" : "handleBatchRequestBack"
		};
		config = $.extend(config, options);
		doFlow(data);
	};

	/*
	 * 打开处理意见页面 对象属性参数说明 projectName 项目名称 returnURL 返回、刷新URL moduleId 模块ID
	 * workId 工单ID workName 工单名称  processInstanceId 流程实例ID doneTaskId 已办任务ID todoTaskId 待办任务ID
	 * foreAdapter 发送适配器 backAdapter 回退适配器 checkBillBackTag
	 * 单据验证表示(验证是否可以执行发送、回退) true 通过 false 不通过 strCheckBillBackMsg
	 * 当checkBillBackTag 为false时的提示信息
	 */
	var openNotionDetail = function(paramsObject) {
		var url = getNotionDetailUrl(paramsObject);
		url = url + "&pClosePage=false";
		document.location.target = "_self";
		document.location.href = url;
	};

	/*
	 * 打开处理意见页面 对象属性参数说明 projectName 项目名称 returnURL 返回、刷新URL moduleId 模块ID
	 * workId 工单ID workName 工单名称   processInstanceId 流程实例ID doneTaskId 已办任务ID todoTaskId 待办任务ID
	 * foreAdapter 发送适配器 backAdapter 回退适配器 checkBillBackTag
	 * 单据验证表示(验证是否可以执行发送、回退) true 通过 false 不通过 strCheckBillBackMsg
	 * 当checkBillBackTag 为false时的提示信息
	 */
	var openNotionDetailDialog = function(paramsObject) {
		var url = getNotionDetailUrl(paramsObject);
		url = url + "&pClosePage=true";
		var height = $(document.body).height() * 0.8;
		var width = $(document.body).width() * 0.9;
		bizFlow.cacheObj.createDialog("openNotionDetailDialog", cui.dialog( {
			title : '意见处理',
			src : url,
			page_scroll : false,
			width : width,
			height : height
		})).show();
	};

	var getNotionDetailUrl = function(paramsObject) {
		var url = webRoot + "/bpms/bizflow/flowmanage/NotionDetail.jsp";
		url = url + "?pProjectName="
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.projectName) ? '' : paramsObject.projectName));
		url = url + "&pReturnURL=" 
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.returnURL) ? '' : paramsObject.returnURL));
		url = url + "&moduleId="
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.moduleId) ? '' : paramsObject.moduleId));
		url = url + "&workId="
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.workId) ? '' : paramsObject.workId));
		url = url + "&workName="
		        + encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.workName) ? '' : paramsObject.workName));
		url = url + "&processInstanceId="
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.processInstanceId) ? '' : paramsObject.processInstanceId));
		url = url + "&doneTaskId="
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.doneTaskId) ? '' : paramsObject.doneTaskId));
		url = url + "&todoTaskId="
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.todoTaskId) ? '' : paramsObject.todoTaskId));
		url = url + "&pForeAdapter="
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.foreAdapter) ? '' : paramsObject.foreAdapter));
		url = url + "&pBackAdapter="
				+ encodeURIComponent(encodeURIComponent($.isUndefined(paramsObject.backAdapter) ? '' : paramsObject.backAdapter));
		if (!$.isUndefined(paramsObject.checkBillBackTag) && true == paramsObject.checkBillBackTag) {
			url = url + "&checkBillBackTag=true";
		} else {
			url = url + "&checkBillBackTag=false";
		}
		if (!$.isUndefined(paramsObject.strCheckBillBackMsg)) {
			url = url + "&pCheckBillBackMsg=" + encodeURIComponent(encodeURIComponent(paramsObject.strCheckBillBackMsg));
		}
		return url;
	};

	// 批量提交时每条单据合法性校验
	var batchLegalCheck = function(workId) {
		var legalMark = true;
		if (config.beforeSend && config.beforeSend.auditBeforeSend) {
			config.data.workId = workId;
			legalMark = config.beforeSend.auditBeforeSend(config);
		}
		return legalMark;
	}

	// 单条单据合法性验证
	var legalMarkCheck = function(workId) {
		var legalMark = true;
		if (config.beforeSend && config.beforeSend.auditBeforeSend) {
			if (config.data) {
				config.data.workId = workId;
			} else {
				config.auditData.workId = workId;
			}
			var isLegal = config.beforeSend.auditBeforeSend(config);
			if ($.isUndefined(isLegal)) { //无返回值则终止往下走
				legalMark = false;
			} else if (!isLegal) {
				if (config.illegal && config.illegal.auditBeforeSendIllegal) {
					config.illegal.auditBeforeSendIllegal();
				}
				legalMark = false;
			}
		}
		return legalMark;
	};

	// 执行流程处理（批量）
	var doBatchFlow = function(specialAuditData) {
		if (!isSpecialFlow) {
			var flowOpinion = "";
			if (specialAuditData && specialAuditData.flowOpinion) {
				flowOpinion = specialAuditData.flowOpinion;
			}
			// 批量流程处理信息
			var batchFlowInfo = null;
			if (specialAuditData && specialAuditData.paramArray) {
				batchFlowInfo = getBatchFlowInfoByParams(specialAuditData.paramArray);
			} else {
				batchFlowInfo = getBatchFlowInfo();
			}
			if (("handleBatchUndo" == config.actionType || "handleUndo" == config.actionType) 
					&& true == isWftFlowUndo(batchFlowInfo.batchJson)) {
			  return;	
			}
			var checkCount = batchFlowInfo.checkedCount;
			if (checkCount === 0) {
				cui.error("请先选择单据！");
				if(window.cancel){
					cancel();
				}
				return;
			} 
			else if (batchFlowInfo.illegalCount > 0) {
				if(window.cancel){
					cancel();
				}
				return;
			}
			auditOptions = {
				"url" : auditUrl,
				"data" : {
					"actionType" : config.actionType,
					"isDefaultNoMsg" : "true",
					"batchJson" : JSON.stringify(batchFlowInfo.batchJson)
				},
				"error" : function(json) {
					isSpecialFlow = false;// 复位为false，否则下次不会弹出选人界面
					cui.message(bizFlow.ajaxErrorMsg, 'error', {
					width : 350
					});
				},
				"success" : function(json) {
					isSpecialFlow = false;// 复位为false，否则下次不会弹出选人界面
					if (json && json.bpmsAuditParamsVO) {
						operateBatchHandleResult(json, checkCount);
						flowResultJson = json;
					}
				}
				};
			} else {
				auditOptions.data = $.extend(auditOptions.data, specialAuditData);
			}
			sendAjaxRequest(auditOptions);
	};
	
	/**
	 * 获取批量提交的数据信息
	 */
	var getBatchFlowInfo = function() {
		// 选中的数据记录数 如果没有选中则提示
		var checkedCount = 0;
		// 不合法数据记录数
		var illegalCount = 0;
		// 可以提交的记录JSON
		var batchJson = [];
		// 是否是批量上报
		var isBatchEntry = 'handleBatchEntry' == config.actionType;
		// 记录流程批量信息
		var $checkBox, legalMark, workId, isLegal;
		//判断有无批量校验方法 有则调用批量校验方法 无则调用当个的校验方法
		if (config.beforeSend && config.beforeSend.batchAuditBeforeSend) {
			var totalList = $("#tableMain").find("tbody input[type='checkbox']");
			legalMark = config.beforeSend.batchAuditBeforeSend(totalList);
			if ($.isUndefined(legalMark) || legalMark != true) {
				illegalCount = 1;
			}
			$("#tableMain").find("tbody input[type='checkbox']:checked").each(function() {
				$checkBox = $(this);
				// 单条单据处理流程所需信息
				batchJson.push(getBatchFlowJson($checkBox));
				checkedCount++;
			});
		} else {
			$("#tableMain").find("tbody input[type='checkbox']:checked").each(function() {
						$checkBox = $(this);
						
						checkedCount = checkedCount + 1;
						workId = $checkBox.attr('data-work-id');
						if(!workId){
							console.log($checkBox[0].name+"=="+workId);
							return true;
						}
						
						
						isLegal = batchLegalCheck(workId);
						if (isLegal != true) {// 数据不合法
							illegalCount += 1;
							return false;
						}
						// 单条单据处理流程所需信息
						batchJson.push(getBatchFlowJson($checkBox));
					});
		}
		// 批量操作流程的信息
		var batchFlowInfo = {};
		batchFlowInfo.isBatchEntry = isBatchEntry;
		batchFlowInfo.checkedCount = checkedCount;
		batchFlowInfo.illegalCount = illegalCount;
		batchFlowInfo.batchJson = batchJson;
		return batchFlowInfo;
	};
	
	/**
	 * 根据参数获取批量提交的数据信息
	 */
	var getBatchFlowInfoByParams = function (paramArray) {
		// 选中的数据记录数 如果没有选中则提示
		var checkedCount = 0;
		// 不合法数据记录数
		var illegalCount = 0;
		// 可以提交的记录JSON
		var batchJson = [];
		// 是否是批量上报
		var isBatchEntry = 'handleBatchEntry' == config.actionType;
		// 记录流程批量信息
		var legalMark, workId, isLegal;
		// 根据是否是批量上报做不同处理
		if (isBatchEntry) {
			// 用于批量上报区分流程版本，及新单据与已走流程的单据的变量
			var processVersion, bpmsVersionTemp, processInstanceId, processInsIdTemp;
			var paramObj = null;
			for (var i = 0; i < paramArray.length; i++) {
				    paramObj = paramArray[i];
				    checkedCount = checkedCount + 1;
					processInstanceId = paramObj.processInstanceId;
					if (checkedCount == 1) {
						processInsIdTemp = processInstanceId;
					}
					if ((isNull(processInstanceId) && !isNull(processInsIdTemp))
							|| (isNull(processInsIdTemp) && !isNull(processInstanceId))) {
						isExistNewAndInFlowTask = true;
						break;
					}
					processInsIdTemp = processInstanceId;
					workId = paramObj.workId;
					isLegal = batchLegalCheck(workId);
					if (isLegal != true) {// 数据不合法
						illegalCount += 1;
						break;
					}
					batchJson.push(getBatchFlowJsonByParams(paramObj));
			}
		} else {
			var paramObj = null;
			for (var i = 0; i < paramArray.length; i++) {
				paramObj = paramArray[i];
				checkedCount = checkedCount + 1;
				workId = paramObj.workId;
				isLegal = batchLegalCheck(workId);
				if (isLegal != true) {// 数据不合法
					illegalCount += 1;
					break;
				}
				batchJson.push(getBatchFlowJsonByParams(paramObj));
			}
		}
		// 批量操作流程的信息
		var batchFlowInfo = {};
		batchFlowInfo.isBatchEntry = isBatchEntry;
		batchFlowInfo.checkedCount = checkedCount;
		batchFlowInfo.illegalCount = illegalCount;
		batchFlowInfo.batchJson = batchJson;
		return batchFlowInfo;
	};

	// 获取需要批量处理的json格式单据信息
	var getBatchFlowJson = function($checkBox) {
		var json = {};
		json.workId = $checkBox.attr('data-work-id') || '';
		json.workName = $checkBox.attr('data-work-name') || '';
		json.todoTaskId = $checkBox.attr('data-todo-task-id') || '';
		json.doneTaskId = $checkBox.attr('data-done-task-id') || '';
		json.processInstanceId = $checkBox.attr('data-process-instance-id') || '';
		json.moduleId = config.extendParams.moduleId || "";
		// 设置适配器名称
		json.adapterName = config.extendParams.adapterName || "";
		if (config.data && config.data.auditData) {
			$.each(config.data.auditData, function(key, value) {
				if (typeof key !== "undefined") {
					var value = $checkBox.attr("data-"+value);
					if(isNumeric(value)){
						value = Number(value);
					}
					json[key] = value;
					//json[key] = $checkBox.data(value);
				}
			});
		}
		return json;
	};
	
	//判断是否是数字类型变量
	function isNumeric(num){
		   // var reg=/^(-|+)?d+(.d+)?$/
			var reg = /^(-)?([1-9]\d*|0)(\.\d*[0-9])?$/; 
		   return(reg.test(num));
	}
	
	// 获取需要批量处理的json格式单据信息
	var getBatchFlowJsonByParams = function(paramObj) {
		var json = {};
		json.workId = paramObj.workId;
		json.workName = paramObj.workName;
		json.todoTaskId = paramObj.todoTaskId;
		json.doneTaskId = paramObj.doneTaskId;
		json.processInstanceId = paramObj.processInstanceId;
		json.moduleId = config.extendParams.moduleId || "";
		// 设置适配器名称
		json.adapterName = config.extendParams.adapterName || "";
		if (config.data && config.data.auditData) {
			$.each(config.data.auditData, function(key, value) {
				if (typeof key !== "undefined") {
					json[key] = paramObj[value];
				}
			});
		}
		return json;
	};

	// 执行流程处理（单条记录）
	var doFlow = function(specialAuditData) {
		// 如果是详细页面 发送和回退不需要获取单据合法性
		if (config.isEditPage) {
			var workId = document.bpmsEditFlowForm.workId.value;
			// 回调业务校验，不合法则返回
			if (!legalMarkCheck(workId)) {
				return;
			}
			doEditFlow(specialAuditData);
		} 
	};

	// 编辑页面流程处理办法
	var doEditFlow = function(specialAuditData) {
		// 通过isSpecialFlow判断是否是指定人员之后的工作流处理
		if (!isSpecialFlow) {
			var batchJson = getFlowJson();
			var actionType = config.actionType;
			var flowOpinion = "";
			if (specialAuditData && specialAuditData.flowOpinion) {
				flowOpinion = specialAuditData.flowOpinion;
			}
			var resultFlag = "";
			if (specialAuditData && specialAuditData.resultFlag) {
				resultFlag = specialAuditData.resultFlag;
			}
			var isDefaultNoMsg = "true";
			if (specialAuditData && specialAuditData.isDefaultNoMsg) {
				isDefaultNoMsg = specialAuditData.isDefaultNoMsg;
			}
			if (("handleBatchUndo" == actionType || "handleUndo" == actionType) 
					&& true == isWftFlowUndo(batchJson)) {
			  return;	
			}
			// 流程相关参数
			auditOptions = {
				"url" : auditUrl,
				"data" : {
					"actionType" : actionType,
					"flowOpinion" : flowOpinion,
					"resultFlag" : resultFlag,
					"isDefaultNoMsg" : isDefaultNoMsg,
					"batchJson" : JSON.stringify(batchJson)
				},
				"error" : function(json) {
					isSpecialFlow = false;// 复位为false，否则下次不会弹出选人界面
					if (updateTaskNoteFucObj.isParentShow
							&& true == updateTaskNoteFucObj.isParentShow) {
						window.parent.cui.message(bizFlow.ajaxErrorMsg, 'error', {
							width : 350
						});
					} else {
						cui.message(bizFlow.ajaxErrorMsg, 'error', {
							width : 350
						});
					}
				},
				"success" : function(json) {
					isSpecialFlow = false;// 复位为false，否则下次不会弹出选人界面
					if (json && json.bpmsAuditParamsVO) {
						operateHandleResult(json);
						flowResultJson = json;
					}
				},
				"flowDialogTitle" : document.bpmsEditFlowForm.moduleName.value
				};
	
			} else {
				auditOptions.data = $.extend(auditOptions.data, specialAuditData);
			}
			sendAjaxRequest(auditOptions);
	};

	// 获取需要单条处理的json格式单据信息（batchJson中只存入单条json数据）
	var getFlowJson = function() {
		var batchJson = [];
		var json = {};
		json.workId = document.bpmsEditFlowForm.workId.value;
		json.workName = decodeURIComponent(document.bpmsEditFlowForm.workName.value);
		json.todoTaskId = document.bpmsEditFlowForm.todoTaskId.value;
		json.doneTaskId = document.bpmsEditFlowForm.doneTaskId.value;
		json.processInstanceId = document.bpmsEditFlowForm.processInstanceId.value;
		json.moduleId = document.bpmsEditFlowForm.moduleId.value;
		// 设置适配器名称
		json.adapterName = config.extendParams.adapterName || "";
		if (config.data && config.data.auditData) {
			$.each(config.data.auditData, function(key, value) {
				if (typeof key !== "undefined") {
					json[key] = value;
				}
			});
		}
		batchJson.push(json);
		return batchJson;
	};
	
	//判断是否进行撤回工作流2.0的流程
	var isWftFlowUndo = function(batchJson){
		 var returnParam = false;
		 var reg = /^wft_/;
		 var paramObject = null;
		 var msg = "";
		 var count = 0;
		 for (var i = 0; i < batchJson.length;i++) {
			 paramObject = batchJson[i];
			 if (reg.test(paramObject.processInstanceId)) {
				 if(null != paramObject.workName && "" != paramObject.workName){
					 if (0 == count) {
						 msg = paramObject.workName;
					 }else{
						 msg = msg + "," +paramObject.workName;
					 }
					 count++;
					 if (3 == count) {
						 break;
					 }
				 } else {
					 if (0 == count) {
						 msg = paramObject.workId;
					 }else{
						 msg = msg + "," +paramObject.workId;
					 }
					 count++;
					 if (3 == count) {
						 break;
					 }
				 }
			 }
		 }
		 if (count > 0) {
			 returnParam = true;
			 msg = "[" + msg + "]为迁移数据，不能进行撤回操作。";
			 cui.alert(msg, 'error');
		 }
		 return returnParam;
	};
	
	// 打开指定上报或下发或回退的对话框（批量）
	var openBatchFlowSpecialDialog = function(actionType) {
		var isOpinionDisplay = true;    //控制结论选择和意见输入是否显示
		var isSelectNodeUser = true;    //控制选人选节点部分是否显示
		var isLimitOpinionValue = true; //控制是否回退操作时必须选择不同意
		var isOpinionRequired = false;  //控制意见框必须有值
		//var isSingleSelect = true;      //控制是单选还是多选
		var isEmailColHide = false;      //控制邮件列隐藏
		var isSmsColHide = false;      //控制邮件列隐藏
		var isViewSelectDept = false;      //显示部门选择框
        var sameOrgUserOrgStructureId = '';      //显示部门选择框
        var sameOrgUserDeptPath = '';      //显示部门选择框
		/*
		 * isOpinionDisplay和isSelectNodeUser都为true,winHeight = 514
		 * isSelectNodeUser为true,winHeight = 407
		 * isOpinionDisplay为true,winHeight = 158
		 */
		var winWidth = 750;
		var winHeight = (isOpinionDisplay && isSelectNodeUser) ? 620 : 
			(isSelectNodeUser ? 510 : (isOpinionDisplay ? 158 : 0));
		
		var windowSrc = webRoot
				+ "/bpms/bizflow/flowmanage/UserSelect.jsp"
				+ "?actionType=" + actionType
				+ "&isOpinionDisplay=" + isOpinionDisplay 
				+ "&isLimitOpinionValue=" + isLimitOpinionValue 
				+ "&isOpinionRequired=" + isOpinionRequired
				//+ "&isSingleSelect=" + isSingleSelect
				+ "&isSelectNodeUser=" + isSelectNodeUser 
				+ "&isEmailColHide=" + isEmailColHide 
				+ "&isSmsColHide=" + isSmsColHide 
				+ "&winHeight=" + winHeight 
				+ "&winWidth=" + winWidth 
				+ "&isViewSelectDept=" + isViewSelectDept
                + "&sameOrgUserDeptPath=" + sameOrgUserDeptPath
                + "&sameOrgUserOrgStructureId=" + sameOrgUserOrgStructureId;
		
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // 获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // 获得窗口的水平位置;
		window.open(windowSrc,
					"userSelectPage",
					'height='+ winHeight +
					',width='+ winWidth +
					',top='+ iTop + 
					',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
	};

	// 流程操作后，根据返回判断是弹出指定选人框，还是提示信息（单条记录）
	var operateHandleResult = function(json) {
		if ("handleBatchDefaultBack" == json.bpmsAuditParamsVO.actionType) {
			updateTaskNoteDialog(json.bpmsAuditParamsVO.actionType);
			return;
		}
		if (json.bpmsAuditParamsVO.actionType) {
			var resultActionType = json.bpmsAuditParamsVO.actionType;
			auditOptions.data.actionType = resultActionType;
			openFlowSpecialDialog(json);
			return;
		}

		// 指定操作对话框(FlowSpecial.jsp)将isSpecialFlow设置成true 但是其它情况下必须设置成false
		// 只有为fasle时才会重新初始化auditOptions流程参数
		isSpecialFlow = false;
		var handleResult = json.bpmsAuditParamsVO.handleResult;
		var msg = handleResultConstants[handleResult];
		if (handleResult.indexOf('Failure') != -1) {
			if (config.error && config.error.auditError) {
				config.error.auditError(json);
			} else {

				if (json.bpmsAuditParamsVO.errorMessage != null
						&& json.bpmsAuditParamsVO.errorMessage != "") {
					msg = json.bpmsAuditParamsVO.errorMessage;
				}
				if (updateTaskNoteFucObj.isParentShow
						&& true == updateTaskNoteFucObj.isParentShow) {
					window.parent.cui.alert(msg, 'error');
				} else {
					cui.alert(msg, 'error');
				}
			}
		} else {
			if (config.isEditPage) {
				// 调用Ajax刷新待办已办数据
				// cardList.reflashMidTable(document.bpmsEditFlowForm.moduleId.value);
				if (config.url && config.url.listUrl && config.extendParams
						&& config.extendParams.formId) {
					var $moduleForm = $('#' + config.extendParams.formId);
					$moduleForm.action = config.url.listUrl;
					$moduleForm.target = "_self";
					$moduleForm.method = "POST";
					$moduleForm.submit();
				} else if (config.success && config.success.auditSuccess) {
					config.success.auditSuccess(json);
				} else {
					if (updateTaskNoteFucObj.isParentShow
							&& true == updateTaskNoteFucObj.isParentShow) {
						window.parent.cui.message(msg, 'success');
					} else {
						cui.message(msg, 'success');
					}
				}
			} else {
				// 调用Ajax刷新节点过滤信息
				showTaskNode();
				// 刷新列表
				// cardList.showPmsList();
				if (config.success && config.success.auditSuccess) {
					config.success.auditSuccess(json);
				} else {
					if (updateTaskNoteFucObj.isParentShow
							&& true == updateTaskNoteFucObj.isParentShow) {
						window.parent.cui.message(msg, 'success');
					} else {
						cui.message(msg, 'success');
					}
				}
			}
		}
	};

	// 批量流程操作成功后 处理方法
	var operateBatchHandleResult = function(json, checkCount) {
		if ("handleBatchDefaultBack" == json.bpmsAuditParamsVO.actionType) {
			batchUpdateTaskNoteDialog(null, json.bpmsAuditParamsVO.actionType);
			return;
		}
		if (json.bpmsAuditParamsVO.actionType) {
			var actionType = json.bpmsAuditParamsVO.actionType;
			auditOptions.data.actionType = actionType;
			openBatchFlowSpecialDialog(actionType);
			return;
		}
		// 指定操作对话框(FlowSpecial.jsp)将isSpecialFlow设置成true 但是其它情况下必须设置成false
		// 只有为fasle时才会重新初始化auditOptions流程参数
		isSpecialFlow = false;
		var msgConstans = "条单据";
		var handleResult = json.bpmsAuditParamsVO.handleResult;
		var successCount = json.bpmsAuditParamsVO.successCount;
		var msg = "";
		if (handleResult.indexOf('Failure') != -1) {
			// 几条处理失败
			msg = checkCount + msgConstans
					+ handleResultConstants[handleResult];
			if (config.error && config.error.auditError) {
				config.error.auditError(json);
			} else {
				cui.alert(msg, 'error');
			}
		} else {
			if (checkCount > successCount) {
				// 几条成功几条失败
				var msg1 = successCount + msgConstans
						+ handleResultConstants[handleResult];
				var msg2 = (checkCount - successCount) + msgConstans + "处理失败！";
				msg = msg1 + "," + msg2;
				cui.alert(msg, 'success');
			} else if (checkCount === successCount) {
				// 几条成功
				msg = successCount + msgConstans
						+ handleResultConstants[handleResult];
				cui.message(msg, 'success');
			}
			if (config.success && config.success.auditSuccess) {
				config.success.auditSuccess(msg);
			} else {
				var $moduleForm = $('#' + config.extendParams.formId);
				$moduleForm.action = config.url.listUrl;
				$moduleForm.target = "_self";
				$moduleForm.method = "POST";
				$moduleForm.submit();
			}
		}
	};

	//变化节点下拉框
	var changeTaskNode = function() {
		$('#' + config.extendParams.formId).submit();
	};

	// 显示任务节点过滤查询条件 showTaskNode_ID
	var showTaskNode = function() {
		if ($("#taskNodes").length > 0) {
			$.ajax({
						type : "POST", // 提交方式：get/post
						dataType : "json", // 返回数据格式：json/xml/html/test
						"url" : subSystmeRoot + "/bizflow/bizFlowUtilAction.do",
						"data" : {
							"actionType" : "queryHumanNodesByUserIdAndProcess",
							"moduleId" : config.extendParams.moduleId
						},
						async : false,
						success : function(json) {
							if (json && json.bpmsHumanNodeInfo) {
								var showRequestNode = false; // 默认为不显示申请节点
						if (!$.isUndefined(config.extendParams.showRequestNode)) {
							showRequestNode = config.extendParams.showRequestNode;
						}
						var bpmsHumanNodeInfo = json.bpmsHumanNodeInfo;
						var iLength = bpmsHumanNodeInfo.length;
						var nodeId = config.extendParams.nodeId;
						if (iLength > 0) {
							var selectHtml = "&nbsp;任务：<select name='nodeId' onchange='bizFlow.changeTaskNode();'>";
							// true需要显示申请节点
							if (true == showRequestNode) {
								if (!nodeId) {
									selectHtml += "<option value=''>申请节点</option>";
								} else {
									selectHtml += "<option value='' selected='selected'>申请节点</option>";
								}
							}
							for ( var i = 0; i < iLength; i++) {
								if (nodeId == bpmsHumanNodeInfo[i].value) {
									selectHtml += "<option value='"
											+ bpmsHumanNodeInfo[i].value
											+ "' selected='selected'>"
											+ bpmsHumanNodeInfo[i].text
											+ "（"
											+ bpmsHumanNodeInfo[i].todoTaskCount
											+ "）" + "</option>";
								} else {
									selectHtml += "<option value='"
											+ bpmsHumanNodeInfo[i].value
											+ "'>"
											+ bpmsHumanNodeInfo[i].text
											+ "（"
											+ bpmsHumanNodeInfo[i].todoTaskCount
											+ "）" + "</option>";
								}
							}
							selectHtml += "</select>";
							$('#taskNodes').html(selectHtml);
						}
					}
				}
			})
		}
	};

	// 新版流程跟踪
	var flowTrack = function(keyName, workName, moduleId, processInstanceId) {
		var processIdJson = getProcessIdByModuleId(moduleId);
		var processId = processIdJson.processId;
		var url = webRoot + "/bpms/flex/Track.jsp?processId="+ processId + "&processInsId=" + processInstanceId+ "&webRootUrl=" + subSystmeRoot+ "&showTrackFlag=true"
		// 流程跟踪窗口
		var winWidth = 850;
		var winHeight = 500;
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // 获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // 获得窗口的水平位置;
		window.open(url, "flowTrack",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
	};
	
	// 新版流程跟踪图(只展示未着色的流程图)
	var flowTrackDiagram = function(keyName, workName, moduleId, processInstanceId) {
		var processIdJson = getProcessIdByModuleId(moduleId);
		var processId = processIdJson.processId;
		var url = webRoot + "/bpms/flex/" +"BpmsTrackDiagram.jsp?processId="+processId+"&processInsId="+processInstanceId+"&webRootUrl="+subSystmeRoot+"&showTrackFlag=false";
		//流程跟踪图窗口
		var winWidth = 850;
		var winHeight = 500;
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // 获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // 获得窗口的水平位置;
		window.open(url, "flowTrackDiagram",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
	};

	// 更新单据为已读，已读的单据不能撤回 (moduleId -模块ID； todoTaskId -待办任务Id)
	var updateTaskReadFlag = function() {
		$.ajax( {
			type : "POST",
			url : auditUtilUrl,
			data : {
				"actionType" : "updateTaskReadFlag",
				"moduleId" : document.bpmsEditFlowForm.moduleId.value,
				"todoTaskId" : document.bpmsEditFlowForm.todoTaskId.value
			},
			success : function(json) {
			}
		})
	}

	/*
	 * 这是一个缓存对象 createDialog:通过指定的id 生成一个 cui或别的对象 getDialog：
	 * 通过指定的key获取一个cui或别的对象 clear:清除缓存对象
	 */
	var cacheObj = function() {
		var dialogObj = {};
		var currentDialog = null;
		return {
			createDialog : function(key, value, useCache) { // 生成一个dialog
				useCache = useCache || false;
				if (useCache && typeof dialogObj[key] !== "undefined") {
					currentDialog = dialogObj[key];
					return currentDialog;
				}
				currentDialog = value;
				dialogObj[key] = value;
				return value;
			},
			getDialog : function(key) {
				if (dialogObj[key]) {
					return dialogObj[key];
				} else {
					return null;
				}
			},
			getCurrentDialog : function() {
				return currentDialog;
			},
			clear : function() {
				dialogObj = {};
				currentDialog = null;
			}
		};
	}();

	// 从url末尾获取数据
	var getUrlParam = function(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); // 构造一个含有目标参数的正则表达式对象
		var r = window.location.search.substr(1).match(reg); // 匹配目标参数
		if (r != null) {
			return decodeURIComponent(r[2]);
		}
		return null; // 返回参数值
	}

	// 返回请求的流程处理结果信息
	var getFlowResultJson = function() {
		return flowResultJson;
	};

	// 设置当前流程操作是指定处理
	var setIsFlowSpecial = function(isSpecial) {
		isSpecialFlow = isSpecial;
	};

	var currNodeAllUsers;
	var queryCurrNodeAllUser = function(processId, processVersion, nodeId) {
		currNodeAllUsers = [ {} ];
		// 以ajax方式向后台请求数据
		var ajaxParam = {
			"url" : auditUtilUrl,
			async : false,
			"data" : {
				"actionType" : "queryCurrNodeAllUser",
				"processId" : processId,
				"processVersion" : processVersion,
				"nodeId" : nodeId
			},
			"error" : function(json) {
				cui.message(bizFlow.ajaxErrorMsg, 'error', {
					width : 350
				});
			},
			"success" : function(json) {
				if (json) {
					currNodeAllUsers = json.bpmsHumanNodeInfo;
				}
			}
		};
		sendAjaxRequest(ajaxParam);
		return currNodeAllUsers;
	}

	var tempProcessIdJson;
	var getProcessIdByModuleId = function(moduleId) {
		// 以ajax方式向后台请求数据
		var ajaxParam = {
			"url" : auditUtilUrl,
			async : false,
			"data" : {
				"actionType" : "getProcessIdByModuleId",
				"moduleId" : moduleId
			},
			"error" : function(json) {
				cui.message(unifiedFlow.ajaxErrorMsg, 'error', {
					width : 350
				});
			},
			"success" : function(json) {
				if (json) {
					tempProcessIdJson = json;
				}
			}
		};
		sendAjaxRequest(ajaxParam);
		return tempProcessIdJson;
	}

	// 以下是暴露到外部的方法
	bizFlow.flowButtonEvent = flowButtonEvent;
	bizFlow.flowBatchButtonEvent = flowBatchButtonEvent;
	bizFlow.flowTrack = flowTrack;
	bizFlow.flowTrackDiagram = flowTrackDiagram;
	bizFlow.cardListBpmsInit = cardListBpmsInit;
	bizFlow.cacheObj = cacheObj;
	bizFlow.editPageBpmsInit = editPageBpmsInit;
	bizFlow.getFlowResultJson = getFlowResultJson;
	bizFlow.setIsFlowSpecial = setIsFlowSpecial;
	bizFlow.doFlow = doFlow;
	bizFlow.doEditFlow = doEditFlow;
	bizFlow.doBatchFlow = doBatchFlow;
	bizFlow.updateTaskReadFlag = updateTaskReadFlag;
	bizFlow.sendAjaxRequest = sendAjaxRequest;
	bizFlow.changeTaskNode = changeTaskNode;
	//意见相关操作
	bizFlow.updateTaskNoteFucObj = updateTaskNoteFucObj;
	bizFlow.updateTaskNoteDialog = updateTaskNoteDialog;
	bizFlow.updateTaskNoteByNote = updateTaskNoteByNote;
	bizFlow.batchUpdateTaskNoteDialog = batchUpdateTaskNoteDialog;
	bizFlow.updateSingleTaskNote = updateSingleTaskNote;
	bizFlow.openNotionDetailDialog = openNotionDetailDialog;
	bizFlow.openNotionDetail = openNotionDetail;
	//流程相关操作
	bizFlow.queryCurrNodeAllUser = queryCurrNodeAllUser;
	bizFlow.handleEntryFlow = handleEntryFlow;
	bizFlow.handleForeFlow = handleForeFlow;
	bizFlow.handleBackFlow = handleBackFlow;
	bizFlow.handleDefaultBackFlow = handleDefaultBackFlow;
	bizFlow.handleSpecialBackFlow = handleSpecialBackFlow;
	bizFlow.handleRequestBackFlow = handleRequestBackFlow;
	bizFlow.handleUndoFlow = handleUndoFlow;
	bizFlow.handleUndoFlowRequest = handleUndoFlowRequest;
	bizFlow.handleOverFlow = handleOverFlow;
	bizFlow.handleJumpFlow = handleJumpFlow;
	bizFlow.handleUpdateTaskNote = handleUpdateTaskNote;
})(this);

// 为新版人员选择界面提供节点及人员数据
function getNodeInfoList() {
	return bizFlow.getFlowResultJson().bpmsAuditParamsVO.bpmsNodeInfo;
}

/** 判断节点是否单选 */
function isNodeSingleSelect(nodeinfolist){
// 如果存在协同节点，则判断为可以多选
	for (var i in nodeinfolist) {
	var nodeInfo = nodeinfolist[i];
		if(nodeInfo.cooperationFlag == true){
		return false;
		}
	}
return true;
}



// 为新版人员选择界面提供点击节点后，获取节点下人员的功能
function getNodeAllUsers(currSelectNodeId, version, nameKeyWord,orgId) {
	orgId = ('' == orgId || 'null' == orgId || null == orgId || undefined == orgId) ? "" : orgId;
	nameKeyWord = ('' == nameKeyWord || 'null' == nameKeyWord || null == nameKeyWord || undefined == nameKeyWord) ? "" : nameKeyWord;

	var nodes = getNodeInfoList();
	var returnUsers = [];
	if (nodes) {
		for (var m = 0; m < nodes.length; m++) {
			var node = nodes[m];
			if (node.nodeId == currSelectNodeId) {
				var users = node.users;
				if (users) {
					for (var n = 0; n < users.length; n++) {
						var user = users[n];
						//如果传入的orgId为空，则表示不需要用这个过滤
						if (('' != orgId && orgId == user.deptId) || '' == orgId) {
							if (('' != nameKeyWord && (user.userName.indexOf(nameKeyWord) != -1 || user.deptPath.indexOf(nameKeyWord) != -1))
								|| '' == nameKeyWord){
								var returnUser = {};//需要重新拷贝一份，以免引用数据改动导致源数据被改
								returnUser.userId = user.userId;
								returnUser.userName = user.userName;
								returnUser.deptId = user.deptId;
								returnUser.deptPath = user.deptPath;
								returnUser.postName = user.postName;
								returnUser.sendSMS = user.sendSMS;
								returnUser.sendEmail = user.sendEmail;
								returnUsers[returnUsers.length] = returnUser;
						
							}
						}
					}
				}
			}
		}
	}
	return returnUsers;
}

// 为新版人员选择界面提供指定节点上的所有人员数据，
// 以json格式返回，包含userId, userName, deptId, deptPath, position, sendEmail, sendSms
function queryCurrNodeAllUser(processId, processVersion, nodeId) {
	return bizFlow.queryCurrNodeAllUser(processId, processVersion, nodeId);
}

/**
 * 选择人员后的回调方法，业务系统根据返回值，处理对应的下发、回退等操作
 * 
 * @param opinion 是否同意（1：同意, 0：不同意）
 * @param opinionText 意见文本
 * @param map 用户选择的节点和人员信息，以map结构存储
 */
function bpmsUserSelectCallback(opinion, opinionText, map, actionType) {

	var data = {
		"actionType" : actionType,
		"resultFlag" : opinion,
		"flowOpinion" : opinionText,
		"nodes" : map
	};

	bizFlow.setIsFlowSpecial(true);
	if (actionType.indexOf('Batch') != -1) {
		bizFlow.doBatchFlow(data);
	} else {
		bizFlow.doEditFlow(data);
	}
}

// 在填写意见页面已经填了流程意见，通过这个函数把已填的值传递给选人页面
function getOpinionInfo() {
	if (bizFlow.updateTaskNoteFucObj.flowOpinion
			&& '' != bizFlow.updateTaskNoteFucObj.flowOpinion) {
		return bizFlow.updateTaskNoteFucObj.flowOpinion;
	}
	return '';
}
