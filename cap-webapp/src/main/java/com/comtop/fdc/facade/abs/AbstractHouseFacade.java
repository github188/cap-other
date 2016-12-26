/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.fdc.facade.abs;


import com.comtop.fdc.appservice.HouseAppService;
import com.comtop.fdc.model.HouseVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;


/**
 * 房屋业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-12-1 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractHouseFacade<T extends HouseVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected HouseAppService houseAppService = (HouseAppService)BeanContextUtil.getBean("houseAppService");
	
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public HouseAppService getAppService() {
    	return houseAppService;
    }
    

}