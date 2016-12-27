/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.doc.hld.model;

import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.document.word.docmodel.data.BaseDTO;

/**
 * 实体 概念模型、逻辑模型
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月4日 lizhiyong
 */
public class EntityDTO extends BaseDTO {
    
    /** FIXME */
    private static final long serialVersionUID = 1L;
    
    /** 中文名 */
    private String cnName;
    
    /** 约束 */
    private String constraint;
    
    /** 业务对象 */
    private String bizObjectNames;
    
    /** 表名 */
    private String tableName;
    
    /** 表中文名 */
    private String cnTableName;
    
    /** 表注释 */
    private String tableComments;
    
    /** 实体属性集 */
    private List<EntityItemDTO> items;
    
    /**
     * @return 获取 items属性值
     */
    public List<EntityItemDTO> getItems() {
        return items;
    }
    
    /**
     * @param items 设置 items 属性值为参数值 items
     */
    public void setItems(List<EntityItemDTO> items) {
        this.items = items;
    }
    
    /**
     * @return 获取 bizObjectNames属性值
     */
    public String getBizObjectNames() {
        return bizObjectNames;
    }
    
    /**
     * @param bizObjectNames 设置 bizObjectNames 属性值为参数值 bizObjectNames
     */
    public void setBizObjectNames(String bizObjectNames) {
        this.bizObjectNames = bizObjectNames;
    }
    
    /**
     * @return 获取 tableName属性值
     */
    public String getTableName() {
        return tableName;
    }
    
    /**
     * @param tableName 设置 tableName 属性值为参数值 tableName
     */
    public void setTableName(String tableName) {
        this.tableName = tableName;
    }
    
    /**
     * @return 获取 cnTableName属性值
     */
    public String getCnTableName() {
        return cnTableName;
    }
    
    /**
     * @param cnTableName 设置 cnTableName 属性值为参数值 cnTableName
     */
    public void setCnTableName(String cnTableName) {
        this.cnTableName = cnTableName;
    }
    
    /**
     * @return 获取 tableComments属性值
     */
    public String getTableComments() {
        return tableComments;
    }
    
    /**
     * @param tableComments 设置 tableComments 属性值为参数值 tableComments
     */
    public void setTableComments(String tableComments) {
        this.tableComments = tableComments;
    }
    
    /**
     * @return 获取 cnName属性值
     */
    public String getCnName() {
        return cnName;
    }
    
    /**
     * @param cnName 设置 cnName 属性值为参数值 cnName
     */
    public void setCnName(String cnName) {
        this.cnName = cnName;
    }
    
    /**
     * @return 获取 constraint属性值
     */
    public String getConstraint() {
        return constraint;
    }
    
    /**
     * @param constraint 设置 constraint 属性值为参数值 constraint
     */
    public void setConstraint(String constraint) {
        this.constraint = constraint;
    }
    
    /**
     * 添加属性
     *
     * @param item 属性
     */
    public void addEntityItem(EntityItemDTO item) {
        if (this.items == null) {
            this.items = new ArrayList<EntityItemDTO>();
        }
        this.items.add(item);
    }
    
}
