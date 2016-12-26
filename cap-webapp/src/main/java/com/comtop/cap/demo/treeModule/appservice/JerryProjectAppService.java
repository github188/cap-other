/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.appservice;

import com.comtop.cip.jodd.petite.meta.PetiteBean;
import java.util.List;
import com.comtop.bpms.common.model.ProcessInstanceInfo;
import com.comtop.cap.runtime.base.model.CapWorkflowParam;
import com.comtop.cap.demo.treeModule.model.JerryProjectVO;
import com.comtop.cap.demo.treeModule.appservice.abs.AbstractJerryProjectAppService;


/**
 * 项目服务扩展类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 * @param <T> 类泛型
 */
@PetiteBean(value="jerryProjectAppService")
public class JerryProjectAppService<T extends JerryProjectVO> extends AbstractJerryProjectAppService<JerryProjectVO> {

    /**
     * 
     * @see com.comtop.cap.runtime.base.appservice.CapWorkflowAppService#batchEntryCallback(java.util.List,
     *      java.util.List, com.comtop.bpms.common.model.ProcessInstanceInfo[], int)
     */
    @Override
    protected void batchEntryCallback(List<JerryProjectVO> workRecords, List<CapWorkflowParam> workflowParamList,
        ProcessInstanceInfo[] processInstanceInfos, int targetFlowState) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        super.batchEntryCallback(workRecords, workflowParamList, processInstanceInfos, targetFlowState);
    }
    
}
