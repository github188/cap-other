/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.pdm.model;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM键VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class PdmSelectVO extends PdmBaseVO {
    
    /** type */
    private int type;
    
    /** parentTableName */
    private String parentTableName;
    
    /** parentTableId */
    private String parentTableId;
    
    /**
     * @return 获取 type属性值
     */
    public int getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(int type) {
        this.type = type;
    }
    
    /**
     * @return 获取 parentTableName属性值
     */
    public String getParentTableName() {
        return parentTableName;
    }
    
    /**
     * @param parentTableName 设置 parentTableName 属性值为参数值 parentTableName
     */
    public void setParentTableName(String parentTableName) {
        this.parentTableName = parentTableName;
    }
    
    /**
     * @return 获取 parentTableId属性值
     */
    public String getParentTableId() {
        return parentTableId;
    }
    
    /**
     * @param parentTableId 设置 parentTableId 属性值为参数值 parentTableId
     */
    public void setParentTableId(String parentTableId) {
        this.parentTableId = parentTableId;
    }
    
}
