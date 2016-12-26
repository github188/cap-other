/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade.abs;


import com.comtop.meeting.appservice.XcMeetingAppService;
import com.comtop.meeting.model.XcMeetingVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapBaseFacade;


/**
 * 会议管理业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractXcMeetingFacade<T extends XcMeetingVO> extends CapBaseFacade {

	
	/** 注入AppService **/
    protected XcMeetingAppService xcMeetingAppService = (XcMeetingAppService)BeanContextUtil.getBean("xcMeetingAppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public XcMeetingAppService getAppService() {
    	return xcMeetingAppService;
    }
    
}