/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.lld.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 页面元素
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class PageElementDTO extends BaseDTO {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 页面id */
    private String pageId;
    
    /** 中文名称 */
    private String cnName;
    
    /** 元素类型 */
    private String type;
    
    /** 元素类型 */
    private String uiType;
    
    /** 中文元素类型 */
    private String cnUiType;
    
    /** 元素事件 */
    private final List<PageElementEventDTO> events = new ArrayList<PageElementEventDTO>();
    
    /** 元素服务 */
    private final List<PageElementServiceDTO> services = new ArrayList<PageElementServiceDTO>();
    
    /**
     * 添加服务
     *
     * @param elementServiceDTO 服务
     */
    public void addService(PageElementServiceDTO elementServiceDTO) {
        services.add(elementServiceDTO);
    }
    
    /**
     * 添加服务
     *
     * @param elementEventDTO 事件
     */
    public void addEvent(PageElementEventDTO elementEventDTO) {
        events.add(elementEventDTO);
    }
    
    /**
     * @return 获取 events属性值
     */
    public List<PageElementEventDTO> getEvents() {
        return events;
    }
    
    /**
     * @return 获取 services属性值
     */
    public List<PageElementServiceDTO> getServices() {
        return services;
    }
    
    /**
     * @return 获取 cnUiType属性值
     */
    public String getCnUiType() {
        return cnUiType;
    }
    
    /**
     * @param cnUiType 设置 cnUiType 属性值为参数值 cnUiType
     */
    public void setCnUiType(String cnUiType) {
        this.cnUiType = cnUiType;
    }
    
    /**
     * @return 获取 pageId属性值
     */
    public String getPageId() {
        return pageId;
    }
    
    /**
     * @param pageId 设置 pageId 属性值为参数值 pageId
     */
    public void setPageId(String pageId) {
        this.pageId = pageId;
    }
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @param cnName 设置 cnName 属性值为参数值 cnName
     */
    public void setCnName(String cnName) {
        this.cnName = cnName;
    }
    
    /**
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * @return 获取 uitype属性值
     */
    public String getUiType() {
        return uiType;
    }
    
    /**
     * @param uitype 设置 uitype 属性值为参数值 uitype
     */
    public void setUiType(String uitype) {
        this.uiType = uitype;
    }
    
}
