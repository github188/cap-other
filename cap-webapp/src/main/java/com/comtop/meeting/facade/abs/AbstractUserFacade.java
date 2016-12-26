/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade.abs;


import com.comtop.meeting.appservice.UserAppService;
import com.comtop.meeting.model.UserVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapWorkflowFacade;

import com.comtop.soa.annotation.SoaMethod;

/**
 * 用户表业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-31 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractUserFacade<T extends UserVO> extends CapWorkflowFacade {

	
	/** 注入AppService **/
    protected UserAppService userAppService = (UserAppService)BeanContextUtil.getBean("userAppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public UserAppService getAppService() {
    	return userAppService;
    }
    
    /**
     * 测试多参数
     * 
     * @param param1 param1
     * @param param2 param2
     * @return  Object
     * 
     */
    @SoaMethod(alias="testTwoParams")     
    abstract public Object testTwoParams(String param1,String param2);
    
    /**
     * 测试
     * 
     * @return  String
     * 
     */
    @SoaMethod(alias="testThrid")     
    abstract public String testThrid();
    
}