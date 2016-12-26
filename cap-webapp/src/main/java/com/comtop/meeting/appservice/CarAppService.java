/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.appservice;

import com.comtop.cip.jodd.petite.meta.PetiteBean;

import java.util.List;

import com.comtop.bpms.common.model.ProcessInstanceInfo;
import com.comtop.bpms.common.model.TodoTaskInfo;
import com.comtop.cap.runtime.base.exception.CapWorkflowException;
import com.comtop.cap.runtime.base.model.CapWorkflowParam;
import com.comtop.meeting.model.CarVO;
import com.comtop.meeting.appservice.abs.AbstractCarAppService;

/**
 * 汽车人服务扩展类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 * @param <T>
 *            类泛型
 */
@PetiteBean(value = "carAppService")
public class CarAppService<T extends CarVO> extends
		AbstractCarAppService<CarVO> {

	/**
	 * 
	 * @see com.comtop.cap.runtime.base.appservice.CapWorkflowAppService#batchEntryCallback(java.util.List,
	 *      java.util.List, com.comtop.bpms.common.model.ProcessInstanceInfo[],
	 *      int)
	 */
	@Override
	protected void batchEntryCallback(List<CarVO> workRecords,
			List<CapWorkflowParam> workflowParamList,
			ProcessInstanceInfo[] processInstanceInfos, int targetFlowState) {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		super.batchEntryCallback(workRecords, workflowParamList,
				processInstanceInfos, targetFlowState);
	}

	/**
	 * 
	 * @see com.comtop.cap.runtime.base.appservice.CapWorkflowAppService#batchForeCallback(java.util.List,
	 *      java.util.List, com.comtop.bpms.common.model.ProcessInstanceInfo[],
	 *      int)
	 */
	@Override
	protected void batchForeCallback(List<CarVO> workRecords,
			List<CapWorkflowParam> workflowParamList,
			ProcessInstanceInfo[] processInstanceInfos, int targetFlowState) {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		super.batchForeCallback(workRecords, workflowParamList,
				processInstanceInfos, targetFlowState);
	}

	/**
	 * 
	 * @see com.comtop.cap.runtime.base.appservice.CapWorkflowAppService#batchBackCallback(java.util.List,
	 *      java.util.List, com.comtop.bpms.common.model.ProcessInstanceInfo[],
	 *      int)
	 */
	@Override
	protected void batchBackCallback(List<CarVO> workRecords,
			List<CapWorkflowParam> workflowParamList,
			ProcessInstanceInfo[] processInstanceInfos, int targetFlowState) {
		// TODO 自动生成方法存根注释，方法实现时请删除此注释
		super.batchBackCallback(workRecords, workflowParamList,
				processInstanceInfos, targetFlowState);
	}

	/**
	 *
	 * @param workflowParam
	 *            xx
	 *
	 * @see com.comtop.ipb.cap.runtime.base.appservice.WorkflowForIpbAppService#fore(com.comtop.cap.runtime.base.model.CapWorkflowParam)
	 */
	@Override
	public void fore(CapWorkflowParam workflowParam) {
		//
		super.fore(workflowParam);
	}
	
	 /**
     * 根据待办节点信息更新待办
     * 
     * @param workVO 工单对象
     * @param workflowParam 流程信息
     * @param todoTaskInfo 待办信息
     * @param operateType 操作类型
     */
    @Override
	protected void updateWorkFlowDoneByTodoTask(CapWorkflowParam workflowParam, CarVO workVO, TodoTaskInfo todoTaskInfo,
        String operateType) {
        try {
            if (todoTaskInfo == null) {// 待办节点为空，则将当前节点ID及节点名称置空
                updateWorkfowDone(workVO, workflowParam, null, null, null, operateType);
            } else {
                updateWorkfowDone(workVO, workflowParam, todoTaskInfo.getCurNodeId(), todoTaskInfo.getCurNodeName(),
                    todoTaskInfo.getActivityInsId(), operateType);
            }
        } catch (Exception ex) {
            throw new CapWorkflowException("更新已办信息出错。", ex);
        }
    }
}
