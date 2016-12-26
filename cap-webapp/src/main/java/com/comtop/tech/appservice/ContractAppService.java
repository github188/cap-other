/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.appservice;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import java.util.List;
import com.comtop.bpms.common.model.ProcessInstanceInfo;
import com.comtop.cap.runtime.base.model.CapWorkflowParam;
import com.comtop.tech.model.ContractVO;
import com.comtop.tech.appservice.abs.AbstractContractAppService;


/**
 * 合同信息服务扩展类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-11-23 CAP超级管理员
 * @param <T> 类泛型
 */
@PetiteBean(value="contractAppService")
public class ContractAppService<T extends ContractVO> extends AbstractContractAppService<ContractVO> {

    /**
     * 
     * @see com.comtop.cap.runtime.base.appservice.CapWorkflowAppService#batchEntryCallback(java.util.List,
     *      java.util.List, com.comtop.bpms.common.model.ProcessInstanceInfo[], int)
     */
    @Override
    protected void batchEntryCallback(List<ContractVO> workRecords, List<CapWorkflowParam> workflowParamList,
        ProcessInstanceInfo[] processInstanceInfos, int targetFlowState) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        super.batchEntryCallback(workRecords, workflowParamList, processInstanceInfos, targetFlowState);
    }
    
    /**
     * 
     * @see com.comtop.cap.runtime.base.appservice.CapWorkflowAppService#batchForeCallback(java.util.List,
     *      java.util.List, com.comtop.bpms.common.model.ProcessInstanceInfo[], int)
     */
    @Override
    protected void batchForeCallback(List<ContractVO> workRecords, List<CapWorkflowParam> workflowParamList,
        ProcessInstanceInfo[] processInstanceInfos, int targetFlowState) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        super.batchForeCallback(workRecords, workflowParamList, processInstanceInfos, targetFlowState);
    }
    
    /**
     * 
     * @see com.comtop.cap.runtime.base.appservice.CapWorkflowAppService#batchBackCallback(java.util.List,
     *      java.util.List, com.comtop.bpms.common.model.ProcessInstanceInfo[], int)
     */
    @Override
    protected void batchBackCallback(List<ContractVO> workRecords, List<CapWorkflowParam> workflowParamList,
        ProcessInstanceInfo[] processInstanceInfos, int targetFlowState) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        super.batchBackCallback(workRecords, workflowParamList, processInstanceInfos, targetFlowState);
    }
    
    /**
     * 
     * @see com.comtop.cap.runtime.base.appservice.CapWorkflowAppService#undoCallback(com.comtop.cap.runtime.base.model.CapWorkflowVO,
     *      com.comtop.cap.runtime.base.model.CapWorkflowParam,com.comtop.bpms.common.model.ProcessInstanceInfo)
     */
    @Override
    protected void undoCallback(ContractVO vo, CapWorkflowParam workflowParam,ProcessInstanceInfo processInstanceInfo) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        super.undoCallback(vo, workflowParam);
    }
}
