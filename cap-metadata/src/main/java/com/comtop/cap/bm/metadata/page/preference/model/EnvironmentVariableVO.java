/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.preference.model;

import javax.persistence.Id;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 环境变量
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2015-5-28 诸焕辉
 */
@DataTransferObject
public class EnvironmentVariableVO extends BaseMetadata {
    
    /** serialVersionUID */
    private static final long serialVersionUID = -5061187179857758958L;
    
    /** 页面参数英文名称 */
    @Id
    private String attributeName;
    
    /** 页面参数数据类型，为基本类型 */
    private String attributeClass;
    
    /** 页面参数数据类型，为基本类型 */
    private String attributeType;
    
    /** 页面参数默认值 */
    private String attributeValue;
    
    /**
	 * @return the attributeClass
	 */
	public String getAttributeClass() {
		return attributeClass;
	}

	/**
	 * @param attributeClass the attributeClass to set
	 */
	public void setAttributeClass(String attributeClass) {
		this.attributeClass = attributeClass;
	}

	/** 页面参数中文描述 */
    private String attributeDescription;
    
    /** 关联全局引入文件名称 */
    private String fileName;
    
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
     * @return 获取 fileName属性值
     */
    public String getFileName() {
        return fileName;
    }
    
    /**
     * @param fileName 设置 fileName 属性值为参数值 fileName
     */
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
}
