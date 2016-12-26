/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.facade.abs;


import com.comtop.tech.appservice.PaymentAppService;
import com.comtop.tech.model.PaymentVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;


/**
 * 付款单信息业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-12 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractPaymentFacade<T extends PaymentVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected PaymentAppService paymentAppService = (PaymentAppService)BeanContextUtil.getBean("paymentAppService");
	
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public PaymentAppService getAppService() {
    	return paymentAppService;
    }
    

}