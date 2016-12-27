/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

import java.util.ArrayList;
import java.util.List;

import comtop.org.directwebremoting.annotations.DataTransferObject;

/**
 * PDM字段VO
 * 
 * @author 陈志伟
 * @since 1.0
 * @version 2015-10-08 陈志伟
 */
@DataTransferObject
public class ViewVO extends BaseTableVO {
    
    /** 序列化ID */
    private static final long serialVersionUID = -312245421173239868L;
    
    /** sql */
    private String sqlQuery;
    
    /** 应用的表 */
    private List<String> tables = new ArrayList<String>();
    
    /** 包含字段 */
    private List<ViewColumnVO> columns = new ArrayList<ViewColumnVO>();
    
    /**
     * @return 获取 sqlQuery属性值
     */
    public String getSqlQuery() {
        return sqlQuery;
    }
    
    /**
     * @param sqlQuery 设置 sqlQuery 属性值为参数值 sqlQuery
     */
    public void setSqlQuery(String sqlQuery) {
        this.sqlQuery = sqlQuery;
    }
    
    /**
     * @return 获取 columns属性值
     */
    public List<ViewColumnVO> getColumns() {
        return columns;
    }
    
    /**
     * @param columns 设置 columns 属性值为参数值 columns
     */
    public void setColumns(List<ViewColumnVO> columns) {
        this.columns = columns;
    }
    
    /**
     * @return 获取 tables属性值
     */
    public List<String> getTables() {
        return tables;
    }
    
    /**
     * @param tables 设置 tables 属性值为参数值 tables
     */
    public void setTables(List<String> tables) {
        this.tables = tables;
    }
    
    @Override
    public ColumnVO getColumnVOByColumnEngName(String strEngName) {
        for (ColumnVO column : columns) {
            if (strEngName.equals(column.getEngName())) {
                return column;
            }
        }
        return null;
    }
    
}
