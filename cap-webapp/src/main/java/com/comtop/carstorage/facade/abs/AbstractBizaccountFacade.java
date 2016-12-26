/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.facade.abs;


import com.comtop.carstorage.appservice.BizaccountAppService;
import com.comtop.carstorage.model.BizaccountVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapWorkflowFacade;

import java.util.List;
import com.comtop.carstorage.model.OpinionVO;
import com.comtop.soa.annotation.SoaMethod;

/**
 * 费用报销单业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-9-12 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractBizaccountFacade<T extends BizaccountVO> extends CapWorkflowFacade {

	
	/** 注入AppService **/
    protected BizaccountAppService bizaccountAppService = (BizaccountAppService)BeanContextUtil.getBean("bizaccountAppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public BizaccountAppService getAppService() {
    	return bizaccountAppService;
    }
    
    
   
    /**
     * relationAppinion
     * 
     * @param opinion opinion
     * @return  List<OpinionVO>
     * 
     */
    @SoaMethod(alias="relationAppinion")   
    abstract public List<OpinionVO> relationAppinion(OpinionVO opinion);

}