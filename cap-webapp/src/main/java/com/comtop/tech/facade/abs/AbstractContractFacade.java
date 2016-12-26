/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.facade.abs;


import com.comtop.tech.appservice.ContractAppService;
import com.comtop.tech.model.ContractVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapWorkflowFacade;


/**
 * 合同信息业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-11-29 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractContractFacade<T extends ContractVO> extends CapWorkflowFacade {

	
	/** 注入AppService **/
    protected ContractAppService contractAppService = (ContractAppService)BeanContextUtil.getBean("contractAppService");
	
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public ContractAppService getAppService() {
    	return contractAppService;
    }
    

}