/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.desinger.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 页面参数模型
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-4-28 诸焕辉
 */
@DataTransferObject
public class PageAttributeVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -6110472937009001125L;
    
    /** 参数名称 */
    private String attributeName;
    
    /** 参数类型 */
    private String attributeType;
    
    /** 默认值 */
    private String attributeValue;
    
    /** 参数描述 */
    private String attributeDescription;
    
    /** 是否默认 即每个页面是否必须具备 */
    private boolean defaultReference;
    
    /** 是否用于自定义 在页面上添加的属于自定义，在元数据文件中配置的非自定义 */
    private boolean userDefined = true;
    
    /** 页面参数可选值 */
    private String attributeSelectValues;
    
    /**
     * @return 获取 attributeName属性值
     */
    public String getAttributeName() {
        return attributeName;
    }
    
    /**
     * @param attributeName 设置 attributeName 属性值为参数值 attributeName
     */
    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }
    
    /**
     * @return 获取 attributeType属性值
     */
    public String getAttributeType() {
        return attributeType;
    }
    
    /**
     * @param attributeType 设置 attributeType 属性值为参数值 attributeType
     */
    public void setAttributeType(String attributeType) {
        this.attributeType = attributeType;
    }
    
    /**
     * @return 获取 attributeValue属性值
     */
    public String getAttributeValue() {
        return attributeValue;
    }
    
    /**
     * @param attributeValue 设置 attributeValue 属性值为参数值 attributeValue
     */
    public void setAttributeValue(String attributeValue) {
        this.attributeValue = attributeValue;
    }
    
    /**
     * @return 获取 attributeDescription属性值
     */
    public String getAttributeDescription() {
        return attributeDescription;
    }
    
    /**
     * @param attributeDescription 设置 attributeDescription 属性值为参数值 attributeDescription
     */
    public void setAttributeDescription(String attributeDescription) {
        this.attributeDescription = attributeDescription;
    }
    
    /**
     * @return 获取 defaultReference属性值
     */
    public boolean isDefaultReference() {
        return defaultReference;
    }
    
    /**
     * @param defaultReference 设置 defaultReference 属性值为参数值 defaultReference
     */
    public void setDefaultReference(boolean defaultReference) {
        this.defaultReference = defaultReference;
    }
    
    /**
     * @return 获取 userDefined属性值
     */
    public boolean isUserDefined() {
        return userDefined;
    }
    
    /**
     * @param userDefined 设置 userDefined 属性值为参数值 userDefined
     */
    public void setUserDefined(boolean userDefined) {
        this.userDefined = userDefined;
    }
    
    /**
     * @return 获取 attributeSelectValues属性值
     */
    public String getAttributeSelectValues() {
        return attributeSelectValues;
    }
    
    /**
     * @param attributeSelectValues 设置 attributeSelectValues 属性值为参数值 attributeSelectValues
     */
    public void setAttributeSelectValues(String attributeSelectValues) {
        this.attributeSelectValues = attributeSelectValues;
    }
    
}
