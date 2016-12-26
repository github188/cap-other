/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * FIXME 类注释信息(此标记由Eclipse自动生成,请填写注释信息删除此标记)
 *
 * @author 李小芬
 * @since jdk1.6
 * @version 2016年7月14日 李小芬
 */
@DataTransferObject
public class EditableGridColumnVO extends BaseMetadata {
    
    /** 添加序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** bindName */
    private String bindName;
    
    /** name */
    private String name;
    
    /** format */
    private String format;
    
    /** uitype */
    private String uitype;
    
    /** mask */
    private String mask;
    
    /**
     * @return 获取 bindName属性值
     */
    public String getBindName() {
        return bindName;
    }
    
    /**
     * @param bindName 设置 bindName 属性值为参数值 bindName
     */
    public void setBindName(String bindName) {
        this.bindName = bindName;
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
     * @return 获取 format属性值
     */
    public String getFormat() {
        return format;
    }
    
    /**
     * @param format 设置 format 属性值为参数值 format
     */
    public void setFormat(String format) {
        this.format = format;
    }
    
    /**
     * @return 获取 uitype属性值
     */
    public String getUitype() {
        return uitype;
    }
    
    /**
     * @param uitype 设置 uitype 属性值为参数值 uitype
     */
    public void setUitype(String uitype) {
        this.uitype = uitype;
    }
    
    /**
     * @return 获取 mask属性值
     */
    public String getMask() {
        return mask;
    }
    
    /**
     * @param mask 设置 mask 属性值为参数值 mask
     */
    public void setMask(String mask) {
        this.mask = mask;
    }
    
}
