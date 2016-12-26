/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.hr.facade.abs;


import com.comtop.hr.appservice.PersonAppService;
import com.comtop.hr.model.PersonVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;


/**
 * 部门员工业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-16 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractPersonFacade<T extends PersonVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected PersonAppService personAppService = (PersonAppService)BeanContextUtil.getBean("personAppService");
	
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public PersonAppService getAppService() {
    	return personAppService;
    }
    

}