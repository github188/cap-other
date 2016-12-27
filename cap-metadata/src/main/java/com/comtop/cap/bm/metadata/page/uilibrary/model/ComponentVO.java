/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.uilibrary.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import com.comtop.cap.bm.metadata.base.consistency.model.FieldConsistencyConfigVO;
import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.common.xml.CDataAdaptor;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 控件模型
 * 
 * @author 郑重
 * @version jdk1.5
 * @version 2015-4-28 郑重
 */
@XmlRootElement(name = "component")
@DataTransferObject
public class ComponentVO extends BaseModel {
    
    /** 标识 */
    private static final long serialVersionUID = 8256735117840598083L;
    
    /**
     * 构造函数
     */
    public ComponentVO() {
        this.setModelType("component");
    }
    
    /** 中文名称 */
    private String cname;
    
    /** 所属分组 */
    private String group;
    
    /** 描述 */
    private String description;
    
    /** 属性编辑器模式 */
    private String propertyEditor;
    
    /** 属性编辑器页面URL */
    private String propertyEditorPage;
    
    /** 控件在基本控件库中的顺序 */
    private Integer sort;
    
    /** 帮助文档连接 */
    private String helpDocUrl;
    
    /** 是否是输入型控件 */
    private Boolean hasInputType = Boolean.FALSE;
    
    /** js引用文件 */
    private List<String> js = new ArrayList<String>();
    
    /** css引用文件 */
    private List<String> css = new ArrayList<String>();
    
    /** designerjs引用文件 */
    private List<String> designerjs = new ArrayList<String>();
    
    /** 控件属性 */
    private List<PropertyVO> properties = new ArrayList<PropertyVO>();
    
    /** 控件事件 */
    private List<EventVO> events = new ArrayList<EventVO>();
    
    /** 布局类型 */
    private List<String> layoutTypeList = new ArrayList<String>();
    
    /** 控件是否可用 */
    private Boolean disable = Boolean.FALSE;
    
    /** 一致性校验配置 */
    private FieldConsistencyConfigVO consistencyConfig;
    
    /**
     * @return the consistencyConfig
     */
    public FieldConsistencyConfigVO getConsistencyConfig() {
        if (this.consistencyConfig != null) {
            this.consistencyConfig.setFieldName(this.getModelName());
        }
        return consistencyConfig;
    }
    
    /**
     * @param consistencyConfig the consistencyConfig to set
     */
    public void setConsistencyConfig(FieldConsistencyConfigVO consistencyConfig) {
        this.consistencyConfig = consistencyConfig;
    }
    
    /**
     * @return 获取 designerjs属性值
     */
    @XmlElementWrapper(name = "designerjs")
    @XmlElement(name = "list")
    public List<String> getDesignerjs() {
        return designerjs;
    }
    
    /**
     * @param designerjs 设置 designerjs 属性值为参数值 designerjs
     */
    public void setDesignerjs(List<String> designerjs) {
        this.designerjs = designerjs;
    }
    
    /**
     * @return 获取 cname属性值
     */
    public String getCname() {
        return cname;
    }
    
    /**
     * @param cname 设置 cname 属性值为参数值 cname
     */
    public void setCname(String cname) {
        this.cname = cname;
    }
    
    /**
     * @return 获取 group属性值
     */
    @XmlElement(name = "group")
    public String getGroup() {
        return group;
    }
    
    /**
     * @param group 设置 group 属性值为参数值 group
     */
    public void setGroup(String group) {
        this.group = group;
    }
    
    /**
     * @return 获取 description属性值
     */
    @XmlElement(name = "description")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getDescription() {
        return description;
    }
    
    /**
     * @param description 设置 description 属性值为参数值 description
     */
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 helpDocUrl属性值
     */
    @XmlElement(name = "helpDocUrl")
    public String getHelpDocUrl() {
        return helpDocUrl;
    }
    
    /**
     * @param helpDocUrl 设置 helpDocUrl 属性值为参数值 helpDocUrl
     */
    public void setHelpDocUrl(String helpDocUrl) {
        this.helpDocUrl = helpDocUrl;
    }
    
    /**
     * @return 获取 propertyEditor属性值
     */
    @XmlElement(name = "propertyEditor")
    public String getPropertyEditor() {
        return propertyEditor;
    }
    
    /**
     * @param propertyEditor 设置 propertyEditor 属性值为参数值 propertyEditor
     */
    public void setPropertyEditor(String propertyEditor) {
        this.propertyEditor = propertyEditor;
    }
    
    /**
     * @return 获取 propertyEditorPage属性值
     */
    @XmlElement(name = "propertyEditorPage")
    public String getPropertyEditorPage() {
        return propertyEditorPage;
    }
    
    /**
     * @param propertyEditorPage 设置 propertyEditorPage 属性值为参数值 propertyEditorPage
     */
    public void setPropertyEditorPage(String propertyEditorPage) {
        this.propertyEditorPage = propertyEditorPage;
    }
    
    /**
     * @return 获取 js属性值
     */
    @XmlElementWrapper(name = "js")
    @XmlElement(name = "list")
    public List<String> getJs() {
        return js;
    }
    
    /**
     * @param js 设置 js 属性值为参数值 js
     */
    public void setJs(List<String> js) {
        this.js = js;
    }
    
    /**
     * @return 获取 css属性值
     */
    @XmlElementWrapper(name = "css")
    @XmlElement(name = "list")
    public List<String> getCss() {
        return css;
    }
    
    /**
     * @param css 设置 css 属性值为参数值 css
     */
    public void setCss(List<String> css) {
        this.css = css;
    }
    
    /**
     * @return 获取 properties属性值
     */
    @XmlElementWrapper(name = "properties")
    @XmlElement(name = "property")
    public List<PropertyVO> getProperties() {
        return properties;
    }
    
    /**
     * @param properties 设置 properties 属性值为参数值 properties
     */
    public void setProperties(List<PropertyVO> properties) {
        this.properties = properties;
    }
    
    /**
     * @return 获取 events属性值
     */
    @XmlElementWrapper(name = "events")
    @XmlElement(name = "event")
    public List<EventVO> getEvents() {
        return events;
    }
    
    /**
     * @param events 设置 events 属性值为参数值 events
     */
    public void setEvents(List<EventVO> events) {
        this.events = events;
    }
    
    /**
     * @return 获取 sort属性值
     */
    @XmlElement(name = "sort")
    public Integer getSort() {
        return sort;
    }
    
    /**
     * @param sort 设置 sort 属性值为参数值 sort
     */
    public void setSort(Integer sort) {
        this.sort = sort;
    }
    
    /**
     * @return 获取 layoutTypeList属性值
     */
    @XmlElementWrapper(name = "layoutType")
    @XmlElement(name = "list")
    public List<String> getLayoutTypeList() {
        return layoutTypeList;
    }
    
    /**
     * @param layoutTypeList 设置 layoutTypeList 属性值为参数值 layoutTypeList
     */
    public void setLayoutTypeList(List<String> layoutTypeList) {
        this.layoutTypeList = layoutTypeList;
    }
    
    /**
     * @return 获取 hasInputType属性值
     */
    public Boolean getHasInputType() {
        return hasInputType;
    }
    
    /**
     * @param hasInputType 设置 hasInputType 属性值为参数值 hasInputType
     */
    public void setHasInputType(Boolean hasInputType) {
        this.hasInputType = hasInputType;
    }
    
    /**
     * @return 获取 disable属性值
     */
    @XmlElement(name = "disable")
    public Boolean getDisable() {
        return disable;
    }
    
    /**
     * @param disable 设置 disable 属性值为参数值 disable
     */
    public void setDisable(Boolean disable) {
        this.disable = disable;
    }
    
}
