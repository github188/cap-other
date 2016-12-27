/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import com.comtop.cap.bm.metadata.base.model.BaseModel;
import com.comtop.cap.bm.metadata.common.storage.annotation.AggregationField;
import com.comtop.cap.bm.metadata.common.storage.annotation.IgnoreField;
import com.comtop.cap.bm.metadata.sysmodel.model.CapPackageVO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 异常模型VO
 * 
 * @author 凌晨
 * @since 1.0
 * @version 2014-10-14 凌晨
 */
@DataTransferObject
public class ExceptionVO extends BaseModel {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 异常中文名称 */
    private String chName;
    
    /** 异常描述 */
    private String description;
    
    /** 异常英文名称 */
    private String engName;
    
    /** 异常消息 */
    private String message;
    
    /** 所在模块 */
    @IgnoreField
    @AggregationField(value = "modelPackage")
    private CapPackageVO pkg;
    
    /**
     * 构造函数
     */
    public ExceptionVO() {
        this.setModelType("exception");
    }
    
    /**
     * @return 获取 chName属性值
     */
    public String getChName() {
        return chName;
    }
    
    /**
     * @param chName 设置 chName 属性值为参数值 chName
     */
    public void setChName(String chName) {
        this.chName = chName;
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
     * @return 获取 engName属性值
     */
    public String getEngName() {
        return engName;
    }
    
    /**
     * @param engName 设置 engName 属性值为参数值 engName
     */
    public void setEngName(String engName) {
        this.engName = engName;
    }
    
    /**
     * @return 获取 message属性值
     */
    public String getMessage() {
        return message;
    }
    
    /**
     * @param message 设置 message 属性值为参数值 message
     */
    public void setMessage(String message) {
        this.message = message;
    }
    
    /**
     * @return 获取 pkg属性值
     */
    public CapPackageVO getPkg() {
        return pkg;
    }
    
    /**
     * @param pkg 设置 pkg 属性值为参数值 pkg
     */
    public void setPkg(CapPackageVO pkg) {
        this.pkg = pkg;
    }
    
}
