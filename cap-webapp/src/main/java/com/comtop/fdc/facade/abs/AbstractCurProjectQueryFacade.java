/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.fdc.facade.abs;


import com.comtop.fdc.appservice.CurProjectQueryAppService;
import com.comtop.fdc.model.CurProjectQueryVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;


/**
 * 项目分期查询实体业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-11-9 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractCurProjectQueryFacade<T extends CurProjectQueryVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected CurProjectQueryAppService curProjectQueryAppService = (CurProjectQueryAppService)BeanContextUtil.getBean("curProjectQueryAppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public CurProjectQueryAppService getAppService() {
    	return curProjectQueryAppService;
    }
    

}