/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.io.Serializable;

import com.comtop.cap.document.word.docconfig.model.DCTableCell;

/**
 * 表格单元格
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class TableCell implements Serializable {
    
    /** 序列化号 */
    private static final long serialVersionUID = 1L;
    
    /** 所属表格 */
    private Table table;
    
    /** 所在行 */
    private TableRow row;
    
    /** 是否表头 */
    private boolean tableHead;
    
    /** 行号 */
    private int rowIndex;
    
    /** 列号 */
    private int cellIndex;
    
    /** 单元格定义 */
    private DCTableCell definition;
    
    /**
     * @return 获取 row属性值
     */
    public TableRow getRow() {
        return row;
    }
    
    /**
     * @param row 设置 row 属性值为参数值 row
     */
    public void setRow(TableRow row) {
        this.row = row;
    }
    
    /**
     * @return 获取 tableHead属性值
     */
    public boolean isTableHead() {
        return tableHead;
    }
    
    /**
     * @param tableHead 设置 tableHead 属性值为参数值 tableHead
     */
    public void setTableHead(boolean tableHead) {
        this.tableHead = tableHead;
    }
    
    /**
     * @return 获取 table属性值
     */
    public Table getTable() {
        return table;
    }
    
    /**
     * @param table 设置 table 属性值为参数值 table
     */
    public void setTable(Table table) {
        this.table = table;
    }
    
    /**
     * @return 获取 rowIndex属性值
     */
    public int getRowIndex() {
        return rowIndex;
    }
    
    /**
     * @param rowIndex 设置 rowIndex 属性值为参数值 rowIndex
     */
    public void setRowIndex(int rowIndex) {
        this.rowIndex = rowIndex;
    }
    
    /**
     * @return 获取 cellIndex属性值
     */
    public int getCellIndex() {
        return cellIndex;
    }
    
    /**
     * @param cellIndex 设置 cellIndex 属性值为参数值 cellIndex
     */
    public void setCellIndex(int cellIndex) {
        this.cellIndex = cellIndex;
    }
    
    /**
     * @return 获取 definition属性值
     */
    public DCTableCell getDefinition() {
        return definition;
    }
    
    /**
     * @param definition 设置 definition 属性值为参数值 definition
     */
    public void setDefinition(DCTableCell definition) {
        this.definition = definition;
    }
}
