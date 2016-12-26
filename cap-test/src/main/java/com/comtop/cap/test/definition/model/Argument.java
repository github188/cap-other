/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import javax.persistence.Id;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 参数
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月22日 lizhongwen
 */
@XmlType(name = "arg")
@DataTransferObject
public class Argument extends BaseMetadata {
    
    /** 添加序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 名称 */
    @Id
    private String name;
    
    /** 引用 */
    private String reference;
    
    /** 值类型 */
    private ValueType valueType;
    
    /** 值 */
    private String value;
    
    /** 是否必填 */
    private Boolean required;
    
    /** 默认值 */
    private String defaultValue;
    
    /** 控件 */
    private CtrlDefinition ctrl;
    
    /** 描述 */
    private String description;
    
    /** 帮助 */
    private String help;
    
    /**
     * 构造函数
     */
    public Argument() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param name 参数名
     * @param reference 引用
     */
    public Argument(String name, String reference) {
        super();
        this.name = name;
        this.reference = reference;
    }
    
    /**
     * @return 获取 name属性值
     */
    @XmlAttribute(name = "name", required = true)
    public String getName() {
        return name;
    }
    
    /**
     * @param name 设置 name 属性值为参数值 name
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @return 获取 reference属性值
     */
    @XmlAttribute(name = "ref")
    public String getReference() {
        return reference;
    }
    
    /**
     * @param reference 设置 reference 属性值为参数值 reference
     */
    public void setReference(String reference) {
        this.reference = reference;
    }
    
    /**
     * @return 获取 valueType属性值
     */
    @XmlAttribute(name = "valueType")
    public ValueType getValueType() {
        return valueType;
    }
    
    /**
     * @param valueType 设置 valueType 属性值为参数值 valueType
     */
    public void setValueType(ValueType valueType) {
        this.valueType = valueType;
    }
    
    /**
     * @return 获取 value属性值
     */
    @XmlAttribute(name = "value")
    public String getValue() {
        return value;
    }
    
    /**
     * @param value 设置 value 属性值为参数值 value
     */
    public void setValue(String value) {
        if (StringUtils.isNotBlank(value) && value.contains("\"")) {
            this.value = value.replace('"', '\'');
        } else {
            this.value = value;
        }
    }
    
    /**
     * @return 获取 required属性值
     */
    @XmlAttribute(name = "required")
    public Boolean getRequired() {
        return required;
    }
    
    /**
     * @param required 设置 required 属性值为参数值 required
     */
    public void setRequired(Boolean required) {
        this.required = required;
    }
    
    /**
     * @return 获取 defaultValue属性值
     */
    @XmlAttribute(name = "default")
    public String getDefaultValue() {
        return defaultValue;
    }
    
    /**
     * @param defaultValue 设置 defaultValue 属性值为参数值 defaultValue
     */
    public void setDefaultValue(String defaultValue) {
        this.defaultValue = defaultValue;
    }
    
    /**
     * @return 获取 ctrl属性值
     */
    @XmlElement(name = "ctrl")
    public CtrlDefinition getCtrl() {
        return ctrl;
    }
    
    /**
     * @param ctrl 设置 ctrl 属性值为参数值 ctrl
     */
    public void setCtrl(CtrlDefinition ctrl) {
        this.ctrl = ctrl;
    }
    
    /**
     * @return 获取 description属性值
     */
    @XmlAttribute(name = "desc")
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
     * @return 获取 help属性值
     */
    @XmlElement(name = "help")
    public String getHelp() {
        return help;
    }
    
    /**
     * @param help 设置 help 属性值为参数值 help
     */
    public void setHelp(String help) {
        this.help = help;
    }
}
