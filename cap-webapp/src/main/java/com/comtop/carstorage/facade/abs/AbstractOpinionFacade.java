/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.carstorage.facade.abs;


import com.comtop.carstorage.appservice.OpinionAppService;
import com.comtop.carstorage.model.OpinionVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;

import com.comtop.carstorage.model.BizaccountVO;
import java.util.List;
import com.comtop.soa.annotation.SoaMethod;

/**
 * cap流程常用意见业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-9-12 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractOpinionFacade<T extends OpinionVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected OpinionAppService opinionAppService = (OpinionAppService)BeanContextUtil.getBean("opinion2AppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public OpinionAppService getAppService() {
    	return opinionAppService;
    }
    
    
   
    /**
     * relationBizAccount
     * 
     * @param bizAccount bizAccount
     * @return  List<BizaccountVO>
     * 
     */
    @SoaMethod(alias="relationBizAccount")   
    abstract public List<BizaccountVO> relationBizAccount(BizaccountVO bizAccount);

}