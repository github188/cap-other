/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade.abs;


import com.comtop.meeting.appservice.TestQueryAppService;
import com.comtop.meeting.model.TestQueryVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;


/**
 * TestQuery业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractTestQueryFacade<T extends TestQueryVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected TestQueryAppService testQueryAppService = (TestQueryAppService)BeanContextUtil.getBean("testQueryAppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public TestQueryAppService getAppService() {
    	return testQueryAppService;
    }
    
}