/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.appservice.abs;

import com.comtop.cap.demo.treeModule.model.JerryProjectVO;
import com.comtop.cap.runtime.base.appservice.CapWorkflowAppService;

/**
 * 项目 业务逻辑处理类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractJerryProjectAppService<T extends JerryProjectVO> extends CapWorkflowAppService<JerryProjectVO> {
	
		//todo
 	/** 项目工作流ID */
   	public static final String JERRYPROJECT_PROCESS_ID ="ProJerry";
	   	
    /**
     * 返回流程编码
     * 
     * @return 项目工作流ID
     */
    @Override
    public String getProcessId() {
        return JERRYPROJECT_PROCESS_ID;
    }
    
    /**
     * 短信发送时获取业务数据名称，例如：检修单；缺陷单等
     * 
     * @return 工作流名称
     */
    @Override
    public String getDataName() {
        return "项目";
    }
	
}