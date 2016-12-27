/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.biz.model;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 业务角色DTO
 * 
 * @author 李志勇
 * @since 1.0
 * @version 2015-11-11 李志勇
 */
@DataTransferObject
public class BizRoleDTO extends BaseDTO {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /** 简称 */
    private String shortName;
    
    /** 业务层级 */
    private String bizLevel;
    
    /**
     * @return 获取 bizLevel属性值
     */
    public String getBizLevel() {
        return bizLevel;
    }
    
    /**
     * @param bizLevel 设置 bizLevel 属性值为参数值 bizLevel
     */
    public void setBizLevel(String bizLevel) {
        this.bizLevel = bizLevel;
    }
    
    /**
     * @return 获取 简称属性值
     */
    
    public String getShortName() {
        return shortName;
    }
    
    /**
     * @param shortName 设置 简称属性值为参数值 shortName
     */
    
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }
}
