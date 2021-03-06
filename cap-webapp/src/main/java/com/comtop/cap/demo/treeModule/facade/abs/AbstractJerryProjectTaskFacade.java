/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.cap.demo.treeModule.facade.abs;


import com.comtop.cap.demo.treeModule.appservice.JerryProjectTaskAppService;
import com.comtop.cap.demo.treeModule.model.JerryProjectTaskVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;


/**
 * JerryProjectTask业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-6-14 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractJerryProjectTaskFacade<T extends JerryProjectTaskVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected JerryProjectTaskAppService jerryProjectTaskAppService = (JerryProjectTaskAppService)BeanContextUtil.getBean("jerryProjectTaskAppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public JerryProjectTaskAppService getAppService() {
    	return jerryProjectTaskAppService;
    }
    

}