/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.external;

import com.comtop.cap.bm.metadata.entity.model.EntityVO;
import com.comtop.cap.bm.metadata.entity.model.MethodVO;
import com.comtop.cap.bm.metadata.page.desinger.model.PageActionVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.EventVO;

/**
 * 元素的事件
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月6日 凌晨
 */
public class EventDTO {
    
    /** 事件定义 */
    private EventVO eventDef;
    
    /** 元素的事件行为 */
    private PageActionVO action;
    
    /** 行为调用的后台方法 */
    private MethodVO service;
    
    /** 后台方法所属实体 */
    private EntityVO entity;
    
    /**
     * @return 获取 action属性值
     */
    public PageActionVO getAction() {
        return action;
    }
    
    /**
     * @param action 设置 action 属性值为参数值 action
     */
    public void setAction(PageActionVO action) {
        this.action = action;
    }
    
    /**
     * @return 获取 service属性值
     */
    public MethodVO getService() {
        return service;
    }
    
    /**
     * @param service 设置 service 属性值为参数值 service
     */
    public void setService(MethodVO service) {
        this.service = service;
    }
    
    /**
     * @return 获取 eventDef属性值
     */
    public EventVO getEventDef() {
        return eventDef;
    }
    
    /**
     * @param eventDef 设置 eventDef 属性值为参数值 eventDef
     */
    public void setEventDef(EventVO eventDef) {
        this.eventDef = eventDef;
    }
    
    /**
     * @return 获取 entity属性值
     */
    public EntityVO getEntity() {
        return entity;
    }
    
    /**
     * @param entity 设置 entity 属性值为参数值 entity
     */
    public void setEntity(EntityVO entity) {
        this.entity = entity;
    }
    
}
