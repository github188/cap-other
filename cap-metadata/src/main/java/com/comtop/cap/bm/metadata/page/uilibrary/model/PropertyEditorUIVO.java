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
import javax.xml.bind.annotation.XmlType;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import com.comtop.cap.common.xml.CDataAdaptor;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 属性赋值模型
 * 
 * 
 * @author 诸焕辉
 * @since 1.0
 * @version 2015-5-13 诸焕辉
 */
@DataTransferObject
@XmlType(name = "propertyEditorUI")
public class PropertyEditorUIVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -3857113706486829040L;
    
    /** 控件名称 */
    private String componentName;
    
    /** 控件属性 */
    private List<PropertyVO> properties = new ArrayList<PropertyVO>();
    
    /** 属性值{json对象} */
    private String script;
    
    /** 操作脚本 */
    private String operation;
    
    /**
     * @return 获取 componentName属性值
     */
    @XmlElement(name = "componentName")
    public String getComponentName() {
        return componentName;
    }
    
    /**
     * @param componentName 设置 componentName 属性值为参数值 componentName
     */
    public void setComponentName(String componentName) {
        this.componentName = componentName;
    }
    
    /**
     * @return 获取 script属性值
     */
    @XmlElement(name = "script")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getScript() {
        return script;
    }
    
    /**
     * @param script 设置 script 属性值为参数值 script
     */
    public void setScript(String script) {
        this.script = script;
    }
    
    /**
     * @return 获取 operation属性值
     */
    @XmlElement(name = "operation")
    @XmlJavaTypeAdapter(value = CDataAdaptor.class)
    public String getOperation() {
        return operation;
    }
    
    /**
     * @param operation 设置 operation 属性值为参数值 operation
     */
    public void setOperation(String operation) {
        this.operation = operation;
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
}
