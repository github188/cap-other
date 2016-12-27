/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.external;

import java.util.List;

import com.comtop.cap.bm.metadata.page.desinger.model.LayoutVO;
import com.comtop.cap.bm.metadata.page.uilibrary.model.ComponentVO;

/**
 * 封装页面元数据的DTO(供文档生成使用)
 *
 *
 * @author 凌晨
 * @since jdk1.6
 * @version 2016年1月6日 凌晨
 */
public class PageMetadataDTO {
    
    /** 元素的布局vo */
    private LayoutVO layout;
    
    /** 元素本身vo */
    private ComponentVO component;
    
    /** 元素的事件 */
    private List<EventDTO> events;
    
    /**
     * @return 获取 layout属性值
     */
    public LayoutVO getLayout() {
        return layout;
    }
    
    /**
     * @param layout 设置 layout 属性值为参数值 layout
     */
    public void setLayout(LayoutVO layout) {
        this.layout = layout;
    }
    
    /**
     * @return 获取 events属性值
     */
    public List<EventDTO> getEvents() {
        return events;
    }
    
    /**
     * @param events 设置 events 属性值为参数值 events
     */
    public void setEvents(List<EventDTO> events) {
        this.events = events;
    }
    
    /**
     * @return 获取 component属性值
     */
    public ComponentVO getComponent() {
        return component;
    }
    
    /**
     * @param component 设置 component 属性值为参数值 component
     */
    public void setComponent(ComponentVO component) {
        this.component = component;
    }
    
}
