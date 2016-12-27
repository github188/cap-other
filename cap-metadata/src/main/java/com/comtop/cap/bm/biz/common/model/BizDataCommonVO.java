/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.biz.common.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务数据公共对象
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-11-3 林玉千
 */
@DataTransferObject
public class BizDataCommonVO {
    
    /** 数据项ID */
    private String id;
    
    /** 数据项名称 */
    private String name;
    
    /** 数据项值 */
    private String value;
    
    /** 编码 */
    private String code;
    
    /** 描述 */
    private String description;
    
    /** 父ID */
    private String parentId;
    
    /**
     * @return 获取 id属性值
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id 设置 id 属性值为参数值 id
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 name属性值
     */
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
     * @return 获取 description属性值
     */
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
     * @return 获取 parentId属性值
     */
    public String getParentId() {
        return parentId;
    }
    
    /**
     * @param parentId 设置 parentId 属性值为参数值 parentId
     */
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
    
    /**
     * @return 获取 code属性值
     */
    public String getCode() {
        return code;
    }
    
    /**
     * @param code 设置 code 属性值为参数值 code
     */
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
    /**
     * @param value 设置 value 属性值为参数值 value
     */
    public void setValue(String value) {
        this.value = value;
    }
    
}
