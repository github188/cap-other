/*
 * ҵ���������̴�����ش��� by ���� Date: 14-7-15 Time: ����14:48
 */
(function(root) {
	// ��Ҫ��Ϊȫ�ֶ����bpms
	var bizFlow = root.bizFlow = {};
	
	var $ = jQuery.noConflict();
	
	// ��������
	var config = {};
	
	// ��������ajax����json
	var auditOptions = {};
	// ���̴�������Ϣ��JSON��ʽ��
	var flowResultJson = {};
	
	// �������̵�url
	var auditUrl = subSystmeRoot + "/bizflow/bizFlowOperateAction.do";
	// �������̹���Action URL
	var auditUtilUrl = subSystmeRoot + "/bizflow/bizFlowUtilAction.do";

	// ���̲����Ƿ���ָ��֮��Ĺ���������
	var isSpecialFlow = false;

	bizFlow.ENTRY_SUCCESS = "�ϱ��ɹ�";
	bizFlow.ENTRY_FAIL = "�ϱ�ʧ��";
	bizFlow.FORE_SUCCESS = "���ͳɹ�";
	bizFlow.FORE_FAIL = "����ʧ��";
	bizFlow.BACK_SUCCESS = "���˳ɹ�";
	bizFlow.BACK_FAIL = "����ʧ��";
	bizFlow.REASSIGN_SUCCESS = "ת���ɹ�";
	bizFlow.REASSIGN_FAIL = "ת��ʧ��";
	bizFlow.UNDO_SUCCESS = "���سɹ�";
	bizFlow.UNDO_FAIL = "�ѱ��������ܳ���";
	bizFlow.UPDATE_SUCCESS = "��д����ɹ�";
	bizFlow.UPDATE_FAILURE = "��д���ʧ��";
	bizFlow.OVER_SUCCESS = "�������̳ɹ�";
	bizFlow.OVER_FAILURE = "��������ʧ��";
	bizFlow.JUMP_SUCCESS = "����ͨ���ɹ�";
	bizFlow.JUMP_FAILURE = "����ͨ��ʧ��";
	bizFlow.ajaxErrorMsg = "������ִ����������ڲ����ִ�����ˢ��ҳ��";
	// ��̨������������ʾ��Ϣ����Json
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
		"doBatchSpecialEntry" : "����ָ���ϱ�",
		"doBatchSpecialFore" : "����ָ������",
		"doBatchSpecialBack" : "����ָ������",
		"doBatchReassign" : "����ת��"
	};

	// ��̨�����쳣����ʾ��Ϣ����Json
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

	// ��չJQuery �ж�undefined ����
	$.extend( {
		isUndefined : function(obj) {
			return obj === void 0;
		}
	});

	// ����ajax���󷽷�
	var sendAjaxRequest = function(options) {
		options.data = $.extend(options.data, {
			"encoding" : "UTF-8"
		});
		// ajax����
		$.ajax( {
			type : "POST", // �ύ��ʽ��get/post
			dataType : "json", // �������ݸ�ʽ��json/xml/html/test
			async : $.isUndefined(options.async) ? true : options.async,
			url : options.url, // �����ַ·��
			data : options.data, // �������
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

	// ����������¼���
	var cardListBpmsInit = function(options) {
		config = $.extend(config, options);
		config.isEditPage = false;
		showTaskNode();
		cardListEventBind();
	};

	// �༭ҳ���ʼ������
	var editPageBpmsInit = function(options) {
		config = $.extend(config, options);
		config.isEditPage = true;
		editPageEventBind();
	};

	//�б�������ذ�ť�¼���
	var cardListEventBind = function() {
		// �����ϱ���ť�¼���
		$('#btn-batch-entry').click(function() {
			flowBatchButtonEvent("handleBatchEntry");
		});
		// �����·���ť�¼���
		$('#btn-batch-fore').click(function() {
			flowBatchButtonEvent("handleBatchFore");
		});
		// �������˰�ť�¼���
		$('#btn-batch-back').click(function() {
			flowBatchButtonEvent("handleBatchBack");
		});
		// Ĭ�ϻ��˰�ť�¼��󶨣�֧��������
		$('#btn-batch-default-back').click(function() {
			flowBatchButtonEvent("handleBatchDefaultBack");
		});
		// ָ�����˰�ť�¼��󶨣�֧��������
		$('#btn-batch-special-back').click(function() {
			flowBatchButtonEvent("handleBatchSpecialBack");
		});
		// ���������˰�ť�¼��󶨣�֧��������
		$('#btn-batch-request-back').click(function() {
			flowBatchButtonEvent("handleBatchRequestBack");
		});
		// ��������
		$('#btn-batch-undo').click(function() {
			flowBatchButtonEvent("handleBatchUndo");
		});
		// ��������������
		$('#btn-batch-undo-request').click(function() {
			flowBatchButtonEvent("handleBatchUndoRequest");
		});
		// ������������
		$('#btn-batch-over-flow').click(function() {
			flowBatchButtonEvent("handleBatchOverFlow");
		});
		// ����jump��ת��������
		$('#btn-batch-jump-flow').click(function() {
			flowBatchButtonEvent("handleBatchJumpFlow");
		});
		// ������д���
		$('#btn-batch-update-task-note').click(function() {
			flowBatchButtonEvent("handleBatchUpdateTaskNote");
		});
	};

	// �༭���߲鿴ҳ���¼���
	var editPageEventBind = function() {
		// �༭ҳ���ϱ���ť�¼���
		$('#btn-entry').click(function() {
			flowButtonEvent("handleEntry");
		});
		// ��ϸҳ�淢�Ͱ�ť�¼���
		$('#btn-fore').click(function() {
			flowButtonEvent("handleFore");
		});
		// ��ϸҳ�泷�ذ�ť�¼���
		$('#btn-undo').click(function() {
			flowButtonEvent("handleUndo");
		});
		// ��ϸҳ�泷�������˰�ť�¼���
		$('#btn-undo-request').click(function() {
			flowButtonEvent("handleUndoRequest");
		});
		// ��ϸҳ��������̰�ť�¼���
		$('#btn-over-flow').click(function() {
			flowButtonEvent("handleOverFlow");
		});
		// ��ϸҳ��������̰�ť�¼���
		$('#btn-jump-flow').click(function() {
			flowButtonEvent("handleJumpFlow");
		});
		// ��ϸҳ����д�����ť�¼���
		$('#btn-update-task-note').click(function() {
			flowButtonEvent("handleUpdateTaskNote");
		});
		// ���˰�ť�¼���
		$('#btn-back').click(function() {
			flowButtonEvent("handleBatchBack");
		});
		// Ĭ�ϻ��˰�ť�¼���
		$('#btn-default-back').click(function() {
			flowButtonEvent("handleBatchDefaultBack");
		});
		// ָ�����˰�ť�¼���
		$('#btn-special-back').click(function() {
			flowButtonEvent("handleBatchSpecialBack");
		});
		// ���������˰�ť�¼���
		$('#btn-request-back').click(function() {
			flowButtonEvent("handleBatchRequestBack");
		});
	};

	// ������ذ�ť���¼�ͨ�÷�����������¼��
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

	// ������ذ�ť���¼�ͨ�÷�����������
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

	//�ϱ� paramArray�������������� ����������  workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleEntryFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchEntry");
	};
	
	//�·�  paramArray�������������� ���������� workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleForeFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchFore");
	};
	
	//����  paramArray�������������� ����������  workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleBackFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchBack");
	};
	
	//Ĭ�ϻ���  paramArray�������������� ����������    workId��������  workName���������� todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleDefaultBackFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchDefaultBack");
	};
	
	//ָ������  paramArray�������������� ����������   workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleSpecialBackFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchSpecialBack");
	};
	
	//����������  paramArray�������������� ����������   workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleRequestBackFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchRequestBack");
	};
	
	//����  paramArray�������������� ����������  workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleUndoFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchUndo");
	};
	
	//�����˳���  paramArray�������������� ����������  workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleUndoFlowRequest = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchUndoRequest");
	};
	
	//��������  paramArray�������������� ����������  workId��������  workName���������� todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleOverFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchOverFlow");
	};
	
	//��ת��������  paramArray�������������� ����������  workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleJumpFlow = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchJumpFlow");
	};
	
	//��д���  paramArray�������������� ����������  workId��������  workName����������  todoTaskId������ID doneTaskIdArray���Ѱ�ID processInstanceId������ʵ��id
	var handleUpdateTaskNote = function(paramArray) {
		flowBatchOperate(paramArray,"handleBatchUpdateTaskNote");
	};
	
	//������������ ���ݲ�������
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
	
	//����ָ���·���Աѡ���
	var openFlowSpecialDialog = function(json) {
		var isOpinionDisplay = true;    //���ƽ���ѡ�����������Ƿ���ʾ
		var isSelectNodeUser = true;    //����ѡ��ѡ�ڵ㲿���Ƿ���ʾ
		var isLimitOpinionValue = true; //�����Ƿ���˲���ʱ����ѡ��ͬ��
		var isOpinionRequired = false;  //��������������ֵ
		//var isSingleSelect = true;      //�����ǵ�ѡ���Ƕ�ѡ
		var isEmailColHide = false;      //�����ʼ�������
		var isSmsColHide = false;      //�����ʼ�������
		var isViewSelectDept = false;      //��ʾ����ѡ���
        var sameOrgUserOrgStructureId = '';      //��ʾ����ѡ���
        var sameOrgUserDeptPath = '';      //��ʾ����ѡ���
		/*
		 * isOpinionDisplay��isSelectNodeUser��Ϊtrue,winHeight = 514
		 * isSelectNodeUserΪtrue,winHeight = 407
		 * isOpinionDisplayΪtrue,winHeight = 158
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
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // ��ô��ڵĴ�ֱλ��;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // ��ô��ڵ�ˮƽλ��;
		window.open(windowSrc, "userSelectPage",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
	};

	//�������������ز���
	var updateTaskNoteFucObj = {};
	// ���´������
	var updateTaskNoteDialog = function(actionType) {
		// ��֤��������Լ����ø��´�������Ĳ���
		if (vlidataAndSetTaskParams(actionType)) {
			var topWin = window.top;
			var top = "100px", left = "50%";
			left = (document.documentElement.scrollWidth - 460) / 2;
			left =  left < 0 ? "50%" : left;
			top = 60 + document.body.scrollTop+topWin.document.body.scrollTop;
			cacheObj.createDialog("update-task-note",
							cui.dialog({
										title : '��д���',
										src : webRoot + "/bpms/bizflow/flowmanage/UpdateTaskNote.jsp?actionType="+actionType,
										page_scroll : false,
										top: top,
										left: left,
										width : 460,
										height : 410
									})).show();
		}
	};

	// ���������Ϣ�����д����������
	var updateTaskNoteByNote = function(resultFlag, note) {
		// ��֤��������Լ����ø��´�������Ĳ���
		if (vlidataAndSetTaskParams()) {
			updateTaskNoteFucObj.updateTaskNote(resultFlag, note);
		}
	};

	// ���ݴ�����������������ҵ�����ֱ�Ӵ��ݲ�������JS������
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

	// ���ø��´�������Ĳ���
	var vlidataAndSetTaskParams = function(actionType) {
		var batchJson = getFlowJson();
		if ('' == (batchJson[0]).processInstanceId || '' == (batchJson[0]).todoTaskId || '' == (batchJson[0]).moduleId) {
			cui.error("���ݲ��Ϸ������ȼ�������ԣ�");
			return false;
		}
		// �Ѳ������õ�updateTaskNoteFucObj�����ϣ��ڵ�����ҳ��ʹ��
		updateTaskNoteFucObj.isQueryNote = true;
		updateTaskNoteFucObj.processInstanceId = (batchJson[0]).processInstanceId;
		updateTaskNoteFucObj.todoTaskId = (batchJson[0]).todoTaskId;
		updateTaskNoteFucObj.moduleId = (batchJson[0]).moduleId;
		updateTaskNoteFucObj.auditUrl = auditUrl;
		updateTaskNoteFucObj.sendAjaxRequest = sendAjaxRequest;
		// ������ز���
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
				
				//���˲���ʱ��ˢ��ҳ��
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

	// ���������������
	var batchUpdateTaskNoteDialog = function(data, actionType) {
		var checkedCount = 0;
		var errorCount = 0;
		var $checkBox = null;
		var objJson = null;
		// �����ύ�ļ�¼JSON
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
			cui.error("����ѡ�񵥾ݣ�");
			if(window.cancel){
				cancel();
			}
			return;
		} else if (errorCount > 0) {
			cui.error("����" + errorCount + "�����Ϸ����ݣ����ȼ�������ԣ�");
			if(window.cancel){
				cancel();
			}
			return;
		}
		// ���ֻ��һ�� ��Ҫ�Ѳ�ѯ�������Ϣ
		if (1 == checkedCount) {
			// �Ѳ������õ�updateTaskNoteFucObj�����ϣ��ڵ�����ҳ��ʹ��
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
					title : '��д���',
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
				var msgConstans = "������";
				var handleResult = json.bpmsAuditParamsVO.handleResult;
				var successCount = json.bpmsAuditParamsVO.successCount;
				var msg = "";
				if (handleResult.indexOf('updateFailure') != -1) {
					// ��������ʧ��
					msg = checkedCount + msgConstans + handleResultConstants[handleResult];
					if (config.error && config.error.auditError) {
						config.error.auditError(json);
					} else {
						cui.alert(msg, 'error');
					}
				} else {
					if (checkedCount > successCount) {
						// �����ɹ�����ʧ��
						var msg1 = successCount + msgConstans + handleResultConstants[handleResult];
						var msg2 = (checkedCount - successCount) + msgConstans + bizFlow.UPDATE_FAILURE;
						msg = msg1 + "," + msg2;
						cui.alert(msg, 'success');
					} else if (checkedCount === successCount) {
						// �����ɹ�
						msg = successCount + msgConstans + handleResultConstants[handleResult];
						cui.message(msg, 'success');
					}
					
					//���˲���ʱ��ˢ��ҳ��
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

	// ���´���ص����� resultFlag ���� note���
	updateTaskNoteFucObj.updateTaskNote = function(resultFlag, note) {
		this.auditOptions.data = $.extend(this.auditOptions.data, {
			"resultFlag" : resultFlag,
			"flowOpinion" : note
		});
		sendAjaxRequest(this.auditOptions);
	};

	// NotionDetailҳ����������
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

	// NotionDetailҳ����������
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

	// NotionDetailҳ���������˵�������
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
	 * �򿪴������ҳ�� �������Բ���˵�� projectName ��Ŀ���� returnURL ���ء�ˢ��URL moduleId ģ��ID
	 * workId ����ID workName ��������  processInstanceId ����ʵ��ID doneTaskId �Ѱ�����ID todoTaskId ��������ID
	 * foreAdapter ���������� backAdapter ���������� checkBillBackTag
	 * ������֤��ʾ(��֤�Ƿ����ִ�з��͡�����) true ͨ�� false ��ͨ�� strCheckBillBackMsg
	 * ��checkBillBackTag Ϊfalseʱ����ʾ��Ϣ
	 */
	var openNotionDetail = function(paramsObject) {
		var url = getNotionDetailUrl(paramsObject);
		url = url + "&pClosePage=false";
		document.location.target = "_self";
		document.location.href = url;
	};

	/*
	 * �򿪴������ҳ�� �������Բ���˵�� projectName ��Ŀ���� returnURL ���ء�ˢ��URL moduleId ģ��ID
	 * workId ����ID workName ��������   processInstanceId ����ʵ��ID doneTaskId �Ѱ�����ID todoTaskId ��������ID
	 * foreAdapter ���������� backAdapter ���������� checkBillBackTag
	 * ������֤��ʾ(��֤�Ƿ����ִ�з��͡�����) true ͨ�� false ��ͨ�� strCheckBillBackMsg
	 * ��checkBillBackTag Ϊfalseʱ����ʾ��Ϣ
	 */
	var openNotionDetailDialog = function(paramsObject) {
		var url = getNotionDetailUrl(paramsObject);
		url = url + "&pClosePage=true";
		var height = $(document.body).height() * 0.8;
		var width = $(document.body).width() * 0.9;
		bizFlow.cacheObj.createDialog("openNotionDetailDialog", cui.dialog( {
			title : '�������',
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

	// �����ύʱÿ�����ݺϷ���У��
	var batchLegalCheck = function(workId) {
		var legalMark = true;
		if (config.beforeSend && config.beforeSend.auditBeforeSend) {
			config.data.workId = workId;
			legalMark = config.beforeSend.auditBeforeSend(config);
		}
		return legalMark;
	}

	// �������ݺϷ�����֤
	var legalMarkCheck = function(workId) {
		var legalMark = true;
		if (config.beforeSend && config.beforeSend.auditBeforeSend) {
			if (config.data) {
				config.data.workId = workId;
			} else {
				config.auditData.workId = workId;
			}
			var isLegal = config.beforeSend.auditBeforeSend(config);
			if ($.isUndefined(isLegal)) { //�޷���ֵ����ֹ������
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

	// ִ�����̴���������
	var doBatchFlow = function(specialAuditData) {
		if (!isSpecialFlow) {
			var flowOpinion = "";
			if (specialAuditData && specialAuditData.flowOpinion) {
				flowOpinion = specialAuditData.flowOpinion;
			}
			// �������̴�����Ϣ
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
				cui.error("����ѡ�񵥾ݣ�");
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
					isSpecialFlow = false;// ��λΪfalse�������´β��ᵯ��ѡ�˽���
					cui.message(bizFlow.ajaxErrorMsg, 'error', {
					width : 350
					});
				},
				"success" : function(json) {
					isSpecialFlow = false;// ��λΪfalse�������´β��ᵯ��ѡ�˽���
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
	 * ��ȡ�����ύ��������Ϣ
	 */
	var getBatchFlowInfo = function() {
		// ѡ�е����ݼ�¼�� ���û��ѡ������ʾ
		var checkedCount = 0;
		// ���Ϸ����ݼ�¼��
		var illegalCount = 0;
		// �����ύ�ļ�¼JSON
		var batchJson = [];
		// �Ƿ��������ϱ�
		var isBatchEntry = 'handleBatchEntry' == config.actionType;
		// ��¼����������Ϣ
		var $checkBox, legalMark, workId, isLegal;
		//�ж���������У�鷽�� �����������У�鷽�� ������õ�����У�鷽��
		if (config.beforeSend && config.beforeSend.batchAuditBeforeSend) {
			var totalList = $("#tableMain").find("tbody input[type='checkbox']");
			legalMark = config.beforeSend.batchAuditBeforeSend(totalList);
			if ($.isUndefined(legalMark) || legalMark != true) {
				illegalCount = 1;
			}
			$("#tableMain").find("tbody input[type='checkbox']:checked").each(function() {
				$checkBox = $(this);
				// �������ݴ�������������Ϣ
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
						if (isLegal != true) {// ���ݲ��Ϸ�
							illegalCount += 1;
							return false;
						}
						// �������ݴ�������������Ϣ
						batchJson.push(getBatchFlowJson($checkBox));
					});
		}
		// �����������̵���Ϣ
		var batchFlowInfo = {};
		batchFlowInfo.isBatchEntry = isBatchEntry;
		batchFlowInfo.checkedCount = checkedCount;
		batchFlowInfo.illegalCount = illegalCount;
		batchFlowInfo.batchJson = batchJson;
		return batchFlowInfo;
	};
	
	/**
	 * ���ݲ�����ȡ�����ύ��������Ϣ
	 */
	var getBatchFlowInfoByParams = function (paramArray) {
		// ѡ�е����ݼ�¼�� ���û��ѡ������ʾ
		var checkedCount = 0;
		// ���Ϸ����ݼ�¼��
		var illegalCount = 0;
		// �����ύ�ļ�¼JSON
		var batchJson = [];
		// �Ƿ��������ϱ�
		var isBatchEntry = 'handleBatchEntry' == config.actionType;
		// ��¼����������Ϣ
		var legalMark, workId, isLegal;
		// �����Ƿ��������ϱ�����ͬ����
		if (isBatchEntry) {
			// ���������ϱ��������̰汾�����µ������������̵ĵ��ݵı���
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
					if (isLegal != true) {// ���ݲ��Ϸ�
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
				if (isLegal != true) {// ���ݲ��Ϸ�
					illegalCount += 1;
					break;
				}
				batchJson.push(getBatchFlowJsonByParams(paramObj));
			}
		}
		// �����������̵���Ϣ
		var batchFlowInfo = {};
		batchFlowInfo.isBatchEntry = isBatchEntry;
		batchFlowInfo.checkedCount = checkedCount;
		batchFlowInfo.illegalCount = illegalCount;
		batchFlowInfo.batchJson = batchJson;
		return batchFlowInfo;
	};

	// ��ȡ��Ҫ���������json��ʽ������Ϣ
	var getBatchFlowJson = function($checkBox) {
		var json = {};
		json.workId = $checkBox.attr('data-work-id') || '';
		json.workName = $checkBox.attr('data-work-name') || '';
		json.todoTaskId = $checkBox.attr('data-todo-task-id') || '';
		json.doneTaskId = $checkBox.attr('data-done-task-id') || '';
		json.processInstanceId = $checkBox.attr('data-process-instance-id') || '';
		json.moduleId = config.extendParams.moduleId || "";
		// ��������������
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
	
	//�ж��Ƿ����������ͱ���
	function isNumeric(num){
		   // var reg=/^(-|+)?d+(.d+)?$/
			var reg = /^(-)?([1-9]\d*|0)(\.\d*[0-9])?$/; 
		   return(reg.test(num));
	}
	
	// ��ȡ��Ҫ���������json��ʽ������Ϣ
	var getBatchFlowJsonByParams = function(paramObj) {
		var json = {};
		json.workId = paramObj.workId;
		json.workName = paramObj.workName;
		json.todoTaskId = paramObj.todoTaskId;
		json.doneTaskId = paramObj.doneTaskId;
		json.processInstanceId = paramObj.processInstanceId;
		json.moduleId = config.extendParams.moduleId || "";
		// ��������������
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

	// ִ�����̴���������¼��
	var doFlow = function(specialAuditData) {
		// �������ϸҳ�� ���ͺͻ��˲���Ҫ��ȡ���ݺϷ���
		if (config.isEditPage) {
			var workId = document.bpmsEditFlowForm.workId.value;
			// �ص�ҵ��У�飬���Ϸ��򷵻�
			if (!legalMarkCheck(workId)) {
				return;
			}
			doEditFlow(specialAuditData);
		} 
	};

	// �༭ҳ�����̴���취
	var doEditFlow = function(specialAuditData) {
		// ͨ��isSpecialFlow�ж��Ƿ���ָ����Ա֮��Ĺ���������
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
			// ������ز���
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
					isSpecialFlow = false;// ��λΪfalse�������´β��ᵯ��ѡ�˽���
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
					isSpecialFlow = false;// ��λΪfalse�������´β��ᵯ��ѡ�˽���
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

	// ��ȡ��Ҫ���������json��ʽ������Ϣ��batchJson��ֻ���뵥��json���ݣ�
	var getFlowJson = function() {
		var batchJson = [];
		var json = {};
		json.workId = document.bpmsEditFlowForm.workId.value;
		json.workName = decodeURIComponent(document.bpmsEditFlowForm.workName.value);
		json.todoTaskId = document.bpmsEditFlowForm.todoTaskId.value;
		json.doneTaskId = document.bpmsEditFlowForm.doneTaskId.value;
		json.processInstanceId = document.bpmsEditFlowForm.processInstanceId.value;
		json.moduleId = document.bpmsEditFlowForm.moduleId.value;
		// ��������������
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
	
	//�ж��Ƿ���г��ع�����2.0������
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
			 msg = "[" + msg + "]ΪǨ�����ݣ����ܽ��г��ز�����";
			 cui.alert(msg, 'error');
		 }
		 return returnParam;
	};
	
	// ��ָ���ϱ����·�����˵ĶԻ���������
	var openBatchFlowSpecialDialog = function(actionType) {
		var isOpinionDisplay = true;    //���ƽ���ѡ�����������Ƿ���ʾ
		var isSelectNodeUser = true;    //����ѡ��ѡ�ڵ㲿���Ƿ���ʾ
		var isLimitOpinionValue = true; //�����Ƿ���˲���ʱ����ѡ��ͬ��
		var isOpinionRequired = false;  //��������������ֵ
		//var isSingleSelect = true;      //�����ǵ�ѡ���Ƕ�ѡ
		var isEmailColHide = false;      //�����ʼ�������
		var isSmsColHide = false;      //�����ʼ�������
		var isViewSelectDept = false;      //��ʾ����ѡ���
        var sameOrgUserOrgStructureId = '';      //��ʾ����ѡ���
        var sameOrgUserDeptPath = '';      //��ʾ����ѡ���
		/*
		 * isOpinionDisplay��isSelectNodeUser��Ϊtrue,winHeight = 514
		 * isSelectNodeUserΪtrue,winHeight = 407
		 * isOpinionDisplayΪtrue,winHeight = 158
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
		
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // ��ô��ڵĴ�ֱλ��;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // ��ô��ڵ�ˮƽλ��;
		window.open(windowSrc,
					"userSelectPage",
					'height='+ winHeight +
					',width='+ winWidth +
					',top='+ iTop + 
					',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
	};

	// ���̲����󣬸��ݷ����ж��ǵ���ָ��ѡ�˿򣬻�����ʾ��Ϣ��������¼��
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

		// ָ�������Ի���(FlowSpecial.jsp)��isSpecialFlow���ó�true ������������±������ó�false
		// ֻ��Ϊfasleʱ�Ż����³�ʼ��auditOptions���̲���
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
				// ����Ajaxˢ�´����Ѱ�����
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
				// ����Ajaxˢ�½ڵ������Ϣ
				showTaskNode();
				// ˢ���б�
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

	// �������̲����ɹ��� ������
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
		// ָ�������Ի���(FlowSpecial.jsp)��isSpecialFlow���ó�true ������������±������ó�false
		// ֻ��Ϊfasleʱ�Ż����³�ʼ��auditOptions���̲���
		isSpecialFlow = false;
		var msgConstans = "������";
		var handleResult = json.bpmsAuditParamsVO.handleResult;
		var successCount = json.bpmsAuditParamsVO.successCount;
		var msg = "";
		if (handleResult.indexOf('Failure') != -1) {
			// ��������ʧ��
			msg = checkCount + msgConstans
					+ handleResultConstants[handleResult];
			if (config.error && config.error.auditError) {
				config.error.auditError(json);
			} else {
				cui.alert(msg, 'error');
			}
		} else {
			if (checkCount > successCount) {
				// �����ɹ�����ʧ��
				var msg1 = successCount + msgConstans
						+ handleResultConstants[handleResult];
				var msg2 = (checkCount - successCount) + msgConstans + "����ʧ�ܣ�";
				msg = msg1 + "," + msg2;
				cui.alert(msg, 'success');
			} else if (checkCount === successCount) {
				// �����ɹ�
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

	//�仯�ڵ�������
	var changeTaskNode = function() {
		$('#' + config.extendParams.formId).submit();
	};

	// ��ʾ����ڵ���˲�ѯ���� showTaskNode_ID
	var showTaskNode = function() {
		if ($("#taskNodes").length > 0) {
			$.ajax({
						type : "POST", // �ύ��ʽ��get/post
						dataType : "json", // �������ݸ�ʽ��json/xml/html/test
						"url" : subSystmeRoot + "/bizflow/bizFlowUtilAction.do",
						"data" : {
							"actionType" : "queryHumanNodesByUserIdAndProcess",
							"moduleId" : config.extendParams.moduleId
						},
						async : false,
						success : function(json) {
							if (json && json.bpmsHumanNodeInfo) {
								var showRequestNode = false; // Ĭ��Ϊ����ʾ����ڵ�
						if (!$.isUndefined(config.extendParams.showRequestNode)) {
							showRequestNode = config.extendParams.showRequestNode;
						}
						var bpmsHumanNodeInfo = json.bpmsHumanNodeInfo;
						var iLength = bpmsHumanNodeInfo.length;
						var nodeId = config.extendParams.nodeId;
						if (iLength > 0) {
							var selectHtml = "&nbsp;����<select name='nodeId' onchange='bizFlow.changeTaskNode();'>";
							// true��Ҫ��ʾ����ڵ�
							if (true == showRequestNode) {
								if (!nodeId) {
									selectHtml += "<option value=''>����ڵ�</option>";
								} else {
									selectHtml += "<option value='' selected='selected'>����ڵ�</option>";
								}
							}
							for ( var i = 0; i < iLength; i++) {
								if (nodeId == bpmsHumanNodeInfo[i].value) {
									selectHtml += "<option value='"
											+ bpmsHumanNodeInfo[i].value
											+ "' selected='selected'>"
											+ bpmsHumanNodeInfo[i].text
											+ "��"
											+ bpmsHumanNodeInfo[i].todoTaskCount
											+ "��" + "</option>";
								} else {
									selectHtml += "<option value='"
											+ bpmsHumanNodeInfo[i].value
											+ "'>"
											+ bpmsHumanNodeInfo[i].text
											+ "��"
											+ bpmsHumanNodeInfo[i].todoTaskCount
											+ "��" + "</option>";
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

	// �°����̸���
	var flowTrack = function(keyName, workName, moduleId, processInstanceId) {
		var processIdJson = getProcessIdByModuleId(moduleId);
		var processId = processIdJson.processId;
		var url = webRoot + "/bpms/flex/Track.jsp?processId="+ processId + "&processInsId=" + processInstanceId+ "&webRootUrl=" + subSystmeRoot+ "&showTrackFlag=true"
		// ���̸��ٴ���
		var winWidth = 850;
		var winHeight = 500;
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // ��ô��ڵĴ�ֱλ��;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // ��ô��ڵ�ˮƽλ��;
		window.open(url, "flowTrack",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
	};
	
	// �°����̸���ͼ(ֻչʾδ��ɫ������ͼ)
	var flowTrackDiagram = function(keyName, workName, moduleId, processInstanceId) {
		var processIdJson = getProcessIdByModuleId(moduleId);
		var processId = processIdJson.processId;
		var url = webRoot + "/bpms/flex/" +"BpmsTrackDiagram.jsp?processId="+processId+"&processInsId="+processInstanceId+"&webRootUrl="+subSystmeRoot+"&showTrackFlag=false";
		//���̸���ͼ����
		var winWidth = 850;
		var winHeight = 500;
		var iTop = (window.screen.availHeight - 30 - winHeight) / 2; // ��ô��ڵĴ�ֱλ��;
		var iLeft = (window.screen.availWidth - 10 - winWidth) / 2; // ��ô��ڵ�ˮƽλ��;
		window.open(url, "flowTrackDiagram",
					'height='+ winHeight + ',width='+ winWidth +
					',top='+ iTop + ',left='+ iLeft + 
					',toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
	};

	// ���µ���Ϊ�Ѷ����Ѷ��ĵ��ݲ��ܳ��� (moduleId -ģ��ID�� todoTaskId -��������Id)
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
	 * ����һ��������� createDialog:ͨ��ָ����id ����һ�� cui���Ķ��� getDialog��
	 * ͨ��ָ����key��ȡһ��cui���Ķ��� clear:����������
	 */
	var cacheObj = function() {
		var dialogObj = {};
		var currentDialog = null;
		return {
			createDialog : function(key, value, useCache) { // ����һ��dialog
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

	// ��urlĩβ��ȡ����
	var getUrlParam = function(name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); // ����һ������Ŀ�������������ʽ����
		var r = window.location.search.substr(1).match(reg); // ƥ��Ŀ�����
		if (r != null) {
			return decodeURIComponent(r[2]);
		}
		return null; // ���ز���ֵ
	}

	// ������������̴�������Ϣ
	var getFlowResultJson = function() {
		return flowResultJson;
	};

	// ���õ�ǰ���̲�����ָ������
	var setIsFlowSpecial = function(isSpecial) {
		isSpecialFlow = isSpecial;
	};

	var currNodeAllUsers;
	var queryCurrNodeAllUser = function(processId, processVersion, nodeId) {
		currNodeAllUsers = [ {} ];
		// ��ajax��ʽ���̨��������
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
		// ��ajax��ʽ���̨��������
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

	// �����Ǳ�¶���ⲿ�ķ���
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
	//�����ز���
	bizFlow.updateTaskNoteFucObj = updateTaskNoteFucObj;
	bizFlow.updateTaskNoteDialog = updateTaskNoteDialog;
	bizFlow.updateTaskNoteByNote = updateTaskNoteByNote;
	bizFlow.batchUpdateTaskNoteDialog = batchUpdateTaskNoteDialog;
	bizFlow.updateSingleTaskNote = updateSingleTaskNote;
	bizFlow.openNotionDetailDialog = openNotionDetailDialog;
	bizFlow.openNotionDetail = openNotionDetail;
	//������ز���
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

// Ϊ�°���Աѡ������ṩ�ڵ㼰��Ա����
function getNodeInfoList() {
	return bizFlow.getFlowResultJson().bpmsAuditParamsVO.bpmsNodeInfo;
}

/** �жϽڵ��Ƿ�ѡ */
function isNodeSingleSelect(nodeinfolist){
// �������Эͬ�ڵ㣬���ж�Ϊ���Զ�ѡ
	for (var i in nodeinfolist) {
	var nodeInfo = nodeinfolist[i];
		if(nodeInfo.cooperationFlag == true){
		return false;
		}
	}
return true;
}



// Ϊ�°���Աѡ������ṩ����ڵ�󣬻�ȡ�ڵ�����Ա�Ĺ���
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
						//��������orgIdΪ�գ����ʾ����Ҫ���������
						if (('' != orgId && orgId == user.deptId) || '' == orgId) {
							if (('' != nameKeyWord && (user.userName.indexOf(nameKeyWord) != -1 || user.deptPath.indexOf(nameKeyWord) != -1))
								|| '' == nameKeyWord){
								var returnUser = {};//��Ҫ���¿���һ�ݣ������������ݸĶ�����Դ���ݱ���
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

// Ϊ�°���Աѡ������ṩָ���ڵ��ϵ�������Ա���ݣ�
// ��json��ʽ���أ�����userId, userName, deptId, deptPath, position, sendEmail, sendSms
function queryCurrNodeAllUser(processId, processVersion, nodeId) {
	return bizFlow.queryCurrNodeAllUser(processId, processVersion, nodeId);
}

/**
 * ѡ����Ա��Ļص�������ҵ��ϵͳ���ݷ���ֵ�������Ӧ���·������˵Ȳ���
 * 
 * @param opinion �Ƿ�ͬ�⣨1��ͬ��, 0����ͬ�⣩
 * @param opinionText ����ı�
 * @param map �û�ѡ��Ľڵ����Ա��Ϣ����map�ṹ�洢
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

// ����д���ҳ���Ѿ��������������ͨ����������������ֵ���ݸ�ѡ��ҳ��
function getOpinionInfo() {
	if (bizFlow.updateTaskNoteFucObj.flowOpinion
			&& '' != bizFlow.updateTaskNoteFucObj.flowOpinion) {
		return bizFlow.updateTaskNoteFucObj.flowOpinion;
	}
	return '';
}
