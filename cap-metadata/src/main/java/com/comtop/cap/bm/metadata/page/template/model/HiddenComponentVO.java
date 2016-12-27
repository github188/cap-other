/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.page.template.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 无控件类型的VO对象
 * 
 * @author 诸焕辉
 * @version jdk1.6
 * @version 2016-1-7 诸焕辉
 */
@DataTransferObject
public class HiddenComponentVO extends BaseMetadata {
    
    /** 标识 */
    private static final long serialVersionUID = 1L;
    
    /**
     * 控件Id
     */
    private String id;
    
    /**
     * 属性名称
     */
    private String name;
    
    /**
     * 值
     */
    private String value;
    
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
}
