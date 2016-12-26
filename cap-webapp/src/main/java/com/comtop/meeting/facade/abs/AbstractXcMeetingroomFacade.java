/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.facade.abs;


import com.comtop.meeting.appservice.XcMeetingroomAppService;
import com.comtop.meeting.model.XcMeetingroomVO;
import com.comtop.cap.runtime.base.util.BeanContextUtil;
import com.comtop.cap.runtime.base.facade.CapWorkflowFacade;

import java.util.ArrayList;
import java.util.List;
import com.comtop.soa.annotation.SoaMethod;

/**
 * 会议室业务逻辑处理类门面
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractXcMeetingroomFacade<T extends XcMeetingroomVO> extends CapWorkflowFacade {

	
	/** 注入AppService **/
    protected XcMeetingroomAppService xcMeetingroomAppService = (XcMeetingroomAppService)BeanContextUtil.getBean("xcMeetingroomAppService");
     /**
     * @see com.comtop.cap.runtime.base.facade.CapBaseFacade#getAppService()
     */
    @Override
    public XcMeetingroomAppService getAppService() {
    	return xcMeetingroomAppService;
    }
    
    /**
     * 测试级联
     * 
     * @param entityId 查询的实体Id
     * @return  XcMeetingroomVO
     * 
     */
    @SoaMethod(alias="testJL")     
     public XcMeetingroomVO testJL(String entityId){
        List<String> lstCascade = new ArrayList<String>();
		return (XcMeetingroomVO) super.loadCascadeById(loadById(entityId), getCascadeVOList(lstCascade));
     }
    
    /**
     * 测试自定义SQL
     * 
     * @param entityId 查询的实体Id
     * @return  XcMeetingroomVO
     * 
     */
    @SoaMethod(alias="testSQL")     
     public XcMeetingroomVO testSQL(String entityId){
    	return getAppService().testSQL(entityId);
     }
    
    /**
     * 测试
     * 
     * @return  String
     * 
     */
    @SoaMethod(alias="test")     
    abstract public String test();
    
}