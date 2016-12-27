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
 * 页面
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月30日 lizhiyong
 */
public class PageDTO extends BaseDTO {
    
    /** 序列号 */
    private static final long serialVersionUID = 1L;
    
    /** 界面原型Id */
    private String crudeUIIds;
    
    /** 中文名称 */
    private String cnName;
    
    /** 录入页面类型，1为录入的模板，2为录入的自定义页面，默认为1 */
    private int pageType = 1;
    
    /** 类型 */
    private String type;
    
    /** 界面原型名称集合 */
    private String crudeUINames;
    
    /** 界面来源 */
    private String pageFrom;
    
    /** 界面原型字符串集合 */
    private List<String> crudeUIs;
    
    /** 元素事件 */
    private final List<PageElementDTO> elements = new ArrayList<PageElementDTO>();
    
    /** 元素事件 */
    private final List<PageElementEventDTO> events = new ArrayList<PageElementEventDTO>();
    
    /** 元素服务 */
    private final List<PageElementServiceDTO> services = new ArrayList<PageElementServiceDTO>();
    
    /**
     * @return 获取 elements属性值
     */
    public List<PageElementDTO> getElements() {
        return elements;
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
     * @return 获取 crudeUINames属性值
     */
    public String getCrudeUINames() {
        return crudeUINames;
    }
    
    /**
     * @return 获取 pageFrom属性值
     */
    public String getPageFrom() {
        return pageFrom;
    }
    
    /**
     * @param pageFrom 设置 pageFrom 属性值为参数值 pageFrom
     */
    public void setPageFrom(String pageFrom) {
        this.pageFrom = pageFrom;
    }
    
    /**
     * @param crudeUINames 设置 crudeUINames 属性值为参数值 crudeUINames
     */
    public void setCrudeUINames(String crudeUINames) {
        this.crudeUINames = crudeUINames;
    }
    
    /**
     * 添加服务
     *
     * @param elementDTO 元素
     */
    public void addElement(PageElementDTO elementDTO) {
        elements.add(elementDTO);
    }
    
    /**
     * 添加服务
     *
     * @param elementServiceDTO 服务
     */
    public void addService(PageElementServiceDTO elementServiceDTO) {
        services.add(elementServiceDTO);
        elementServiceDTO.setSortIndex(services.size() + 1);
    }
    
    /**
     * 添加服务
     *
     * @param elementEventDTO 事件
     */
    public void addEvent(PageElementEventDTO elementEventDTO) {
        events.add(elementEventDTO);
        elementEventDTO.setSortIndex(events.size() + 1);
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
     * @return 获取 crudeUIIds属性值
     */
    public String getCrudeUIIds() {
        return crudeUIIds;
    }
    
    /**
     * @param crudeUIIds 设置 crudeUIIds 属性值为参数值 crudeUIIds
     */
    public void setCrudeUIIds(String crudeUIIds) {
        this.crudeUIIds = crudeUIIds;
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
     * @return 获取 pageType属性值
     */
    public int getPageType() {
        return pageType;
    }
    
    /**
     * @param pageType 设置 pageType 属性值为参数值 pageType
     */
    public void setPageType(int pageType) {
        this.pageType = pageType;
        // this.type = String.valueOf(this.pageType);
    }
    
    /**
     * @return 获取 crudeUIs属性值
     */
    public List<String> getCrudeUIs() {
        return crudeUIs;
    }
    
    /**
     * @param crudeUIs 设置 crudeUIs 属性值为参数值 crudeUIs
     */
    public void setCrudeUIs(List<String> crudeUIs) {
        this.crudeUIs = crudeUIs;
    }
    
    /**
     * 添加事件集
     *
     * @param alEvents 事件集
     */
    public void addEvents(List<PageElementEventDTO> alEvents) {
        int index = this.events.size();
        for (PageElementEventDTO pageElementEventDTO : alEvents) {
            pageElementEventDTO.setSortIndex(++index);
        }
        this.events.addAll(alEvents);
    }
    
    /**
     * 添加服务集
     *
     * @param alServices 服务集
     */
    public void addServices(List<PageElementServiceDTO> alServices) {
        int index = this.services.size();
        for (PageElementServiceDTO pageElementServiceDTO : alServices) {
            pageElementServiceDTO.setSortIndex(++index);
        }
        this.services.addAll(alServices);
    }
    
}
