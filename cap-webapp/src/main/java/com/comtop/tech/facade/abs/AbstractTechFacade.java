/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.tech.facade.abs;


import com.comtop.tech.appservice.TechAppService;
import com.comtop.tech.model.TechVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;

import com.comtop.soa.annotation.SoaMethod;

/**
 * 科技信息业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-2 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractTechFacade<T extends TechVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected TechAppService techAppService = (TechAppService)BeanContextUtil.getBean("techAppService");
	
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public TechAppService getAppService() {
    	return techAppService;
    }
    
    
   
    /**
     * 空方法测试
     * 
     * @return  String
     * 
     */
    @SoaMethod(alias="blank")   
    abstract public String blank();
    
   
    /**
     * 自定义SQL查询
     * 
     * @return  String
     * 
     */
    @SoaMethod(alias="customSQL")   
     public String customSQL(){
    	return getAppService().customSQL();
     }

}