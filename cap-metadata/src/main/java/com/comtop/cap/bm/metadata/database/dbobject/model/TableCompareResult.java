/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
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
 * 表比较结果
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-9-26 林玉千 新建
 */
@DataTransferObject
public class TableCompareResult extends BaseMetadata {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * 表比较结果:-1 表示表不存在
     */
    public final static int TABLE_NOT_EXISTS = -1;
    
    /**
     * 表比较结果:0 表示相同
     */
    public final static int TABLE_EQUAL = 0;
    
    /**
     * 表比较结果:1 表示只有列存在不同
     */
    public final static int TABLE_DIFF = 1;
    
    /** ID */
    private String id;
    
    /** 比较结果：0表示相同，-1 表示表不存在，1 表示只有列存在不同 */
    private int result;
    
    /** 源表 */
    private TableVO srcTable;
    
    /** 目标表 */
    private TableVO targetTable;
    
    /** 列比较结果 */
    private List<ColumnCompareResult> columnResults = new ArrayList<ColumnCompareResult>();
    
    /** 索引比较结果 */
    private List<IndexCompareResult> indexResults = new ArrayList<IndexCompareResult>();
    
    /**
     * 
     * 构造函数
     */
    public TableCompareResult() {
        // 默认表数据没有变化
        this.result = TABLE_EQUAL;
    }
    
    /**
     * 构造函数
     * 
     * @param id ID
     */
    public TableCompareResult(String id) {
        super();
        this.id = id;
    }
    
    /**
     * @return xx
     */
    public String getId() {
        return id;
    }
    
    /**
     * @param id xx
     */
    public void setId(String id) {
        this.id = id;
    }
    
    /**
     * @return 获取 result属性值
     */
    public int getResult() {
        return result;
    }
    
    /**
     * @param result 设置 result 属性值为参数值 result
     */
    public void setResult(int result) {
        this.result = result;
    }
    
    /**
     * @return 获取 srcTable属性值
     */
    public TableVO getSrcTable() {
        return srcTable;
    }
    
    /**
     * @param srcTable 设置 srcTable 属性值为参数值 srcTable
     */
    public void setSrcTable(TableVO srcTable) {
        this.srcTable = srcTable;
    }
    
    /**
     * @return 获取 targetTable属性值
     */
    public TableVO getTargetTable() {
        return targetTable;
    }
    
    /**
     * @param targetTable 设置 targetTable 属性值为参数值 targetTable
     */
    public void setTargetTable(TableVO targetTable) {
        this.targetTable = targetTable;
    }
    
    /**
     * @return 获取 columnResults属性值
     */
    public List<ColumnCompareResult> getColumnResults() {
        return columnResults;
    }
    
    /**
     * @param columnResults 设置 columnResults 属性值为参数值 columnResults
     */
    public void setColumnResults(List<ColumnCompareResult> columnResults) {
        this.columnResults = columnResults;
    }
    
    /**
     * @return 获取 indexResults属性值
     */
    public List<IndexCompareResult> getIndexResults() {
        return indexResults;
    }
    
    /**
     * @param indexResults 设置 indexResults 属性值为参数值 indexResults
     */
    public void setIndexResults(List<IndexCompareResult> indexResults) {
        this.indexResults = indexResults;
    }
    
    /**
     * 添加列比较结果
     * 
     * @param columnResult 列比较结果
     */
    public void addColumnResult(ColumnCompareResult columnResult) {
        if (this.columnResults == null) {
            this.columnResults = new ArrayList<ColumnCompareResult>();
        }
        this.columnResults.add(columnResult);
        // 更新比较结果
        if (TableCompareResult.TABLE_EQUAL != columnResult.getResult()) {
            this.result = TABLE_DIFF;
        }
    }
    
    /**
     * 添加列比较结果
     * 
     * @param IndexResult 索引比较结果
     */
    public void addIndexResult(IndexCompareResult IndexResult) {
        if (this.indexResults == null) {
            this.indexResults = new ArrayList<IndexCompareResult>();
        }
        this.indexResults.add(IndexResult);
        // 更新比较结果
        if (TableCompareResult.TABLE_EQUAL != IndexResult.getResult()) {
            this.result = TABLE_DIFF;
        }
    }
    
}
