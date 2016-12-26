/******************************************************************************
 * Copyright (C) 2016 
 * ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。
 * 未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/
package com.comtop.meeting.appservice.abs;

import com.comtop.meeting.model.XcMeetingroomVO;
import com.comtop.cap.runtime.base.appservice.CapWorkflowAppService;

import com.comtop.soa.annotation.SoaMethod;
/**
 * 会议室 业务逻辑处理类
 * 
 * @author CAP超级管理员
 * @since 1.0
 * @version 2016-5-30 CAP超级管理员
 * @param <T> 类泛型参数
 */
public abstract class AbstractXcMeetingroomAppService<T extends XcMeetingroomVO> extends CapWorkflowAppService<XcMeetingroomVO> {
	
		//todo
 	/** 会议室工作流ID */
   	public static final String XCMEETINGROOM_PROCESS_ID ="Pro3365008954395";
	   	
    /**
     * 返回流程编码
     * 
     * @return 会议室工作流ID
     */
    @Override
    public String getProcessId() {
        return XCMEETINGROOM_PROCESS_ID;
    }
    
    /**
     * 短信发送时获取业务数据名称，例如：检修单；缺陷单等
     * 
     * @return 工作流名称
     */
    @Override
    public String getDataName() {
        return "会议室";
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
     	String params = entityId;
        return (XcMeetingroomVO)capBaseCommonDAO.selectOne("com.comtop.meeting.model.xcMeetingroom_testSQL", params);
      }
      
}