/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * 字段关联关系VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class ReferenceJoinVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 3314357336201497357L;
    
    /** 父实体字段编码 */
    private String parentTableColumnCode;
    
    /** 关联实体字段编码 */
    private String childTableColumnCode;
    
    /** 父实体字段 */
    private ColumnVO parentTableColumn;
    
    /** 关联实体字段 */
    private ColumnVO childTableColumn;
    
    /**
     * @return 获取 parentTableColumnCode属性值
     */
    public String getParentTableColumnCode() {
        return parentTableColumnCode;
    }
    
    /**
     * @param parentTableColumnCode 设置 parentTableColumnCode 属性值为参数值 parentTableColumnCode
     */
    public void setParentTableColumnCode(String parentTableColumnCode) {
        this.parentTableColumnCode = parentTableColumnCode;
    }
    
    /**
     * @return 获取 childTableColumnCode属性值
     */
    public String getChildTableColumnCode() {
        return childTableColumnCode;
    }
    
    /**
     * @param childTableColumnCode 设置 childTableColumnCode 属性值为参数值 childTableColumnCode
     */
    public void setChildTableColumnCode(String childTableColumnCode) {
        this.childTableColumnCode = childTableColumnCode;
    }
    
    /**
     * @return 获取 parentTableColumn属性值
     */
    public ColumnVO getParentTableColumn() {
        return parentTableColumn;
    }
    
    /**
     * @param parentTableColumn 设置 parentTableColumn 属性值为参数值 parentTableColumn
     */
    public void setParentTableColumn(ColumnVO parentTableColumn) {
        this.parentTableColumn = parentTableColumn;
    }
    
    /**
     * @return 获取 childTableColumn属性值
     */
    public ColumnVO getChildTableColumn() {
        return childTableColumn;
    }
    
    /**
     * @param childTableColumn 设置 childTableColumn 属性值为参数值 childTableColumn
     */
    public void setChildTableColumn(ColumnVO childTableColumn) {
        this.childTableColumn = childTableColumn;
    }
    
}
