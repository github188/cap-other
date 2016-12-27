/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.bm.metadata.base.model.BaseMetadata;
import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM索引VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class TableIndexVO extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = -1148110286761221463L;
    
    /** 中文名称 */
    private String chName;
    
    /** 英文名称 */
    private String engName;
    
    /** 描述 */
    private String description;
    
    /** 索引类型 */
    private String type;
    
    /** 是否唯一 */
    private boolean unique;
    
    /** 是否主键 */
    private boolean isPrimary;
    
    /** 包含字段 */
    private List<IndexColumnVO> columns = new ArrayList<IndexColumnVO>();
    
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
     * @return 获取 type属性值
     */
    public String getType() {
        return type;
    }
    
    /**
     * @param type 设置 type 属性值为参数值 type
     */
    public void setType(String type) {
        this.type = type;
    }
    
    /**
     * @return 获取 unique属性值
     */
    public boolean isUnique() {
        return unique;
    }
    
    /**
     * @param unique 设置 unique 属性值为参数值 unique
     */
    public void setUnique(boolean unique) {
        this.unique = unique;
    }
    
    /**
     * @return 获取 columns属性值
     */
    public List<IndexColumnVO> getColumns() {
        return columns;
    }
    
    /**
     * @param columns 设置 columns 属性值为参数值 columns
     */
    public void setColumns(List<IndexColumnVO> columns) {
        this.columns = columns;
    }
    
    /**
     * @param column 设置 column 属性值为参数值 column
     */
    public void addColumn(IndexColumnVO column) {
        columns.add(column);
    }
    
    /**
     * @return 获取 isPrimary属性值
     */
    public boolean isPrimary() {
        return isPrimary;
    }
    
    /**
     * @param isPrimary 设置 isPrimary 属性值为参数值 isPrimary
     */
    public void setPrimary(boolean isPrimary) {
        this.isPrimary = isPrimary;
    }
    
    /**
     * 是否唯一性主键约束
     * 
     * @return true 是 ，false 否
     */
    
    public boolean isPrimaryConstraint() {
        return this.isPrimary;
    }
    
    /**
     * 
     * 是否唯一性约束
     * 
     * @return true: 是 ，false ： 否
     */
    public boolean isUniqueConstraint() {
        return this.unique;
    }
    
}
