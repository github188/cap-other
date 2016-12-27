/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.database.dbobject.model;

/**
 * 索引
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-9-28 林玉千
 */
public class Index {
    
    /** 索引名称 */
    private String indexName;
    
    /** 列名称 */
    private String columnName;
    
    /**
     * @return the indexName
     */
    public String getIndexName() {
        return indexName;
    }
    
    /**
     * @param indexName
     *            the indexName to set
     */
    public void setIndexName(String indexName) {
        this.indexName = indexName;
    }
    
    /**
     * @return the columnName
     */
    public String getColumnName() {
        return columnName;
    }
    
    /**
     * @param columnName
     *            the columnName to set
     */
    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }
}
