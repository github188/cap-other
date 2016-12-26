/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.webapp.page.demo.facade;

import com.comtop.cap.bm.webapp.page.demo.appservice.FormAppService;
import com.comtop.cap.runtime.base.appservice.CapBaseAppService;
import com.comtop.cap.runtime.base.appservice.CapWorkflowAppService;
import com.comtop.cap.runtime.base.facade.CapWorkflowFacade;
import com.comtop.cip.jodd.petite.meta.PetiteBean;
import com.comtop.cip.jodd.petite.meta.PetiteInject;
import com.comtop.top.core.jodd.AppContext;

/**
 * facade例子
 * 
 * @author 郑重
 * @version jdk1.5
 * @version 2015-5-12 郑重
 */
@PetiteBean
public class FormFacade extends CapWorkflowFacade {
    
    /**
     * ioc注入FormFacade
     */
    @PetiteInject
    protected FormAppService formAppService;
    
    @Override
    protected CapWorkflowAppService getWorkflowAppService() {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        
        if (formAppService == null) {
            formAppService = AppContext.getBean(FormAppService.class);
        }
        
        return formAppService;
    }

	/** 
	 * @return xx
	 *		
	 * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
	 */
	@Override
	protected CapBaseAppService getAppService() {
		return null;
	}
}
