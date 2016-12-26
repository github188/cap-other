/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.comtop.cip.json.annotation.JSONField;

/**
 * 表格行
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
public class TableRow implements Serializable {
    
    /** 序列化号 */
    private static final long serialVersionUID = 1L;
    
    /** 所属表格 */
    private Table table;
    
    /** 内存中的cells集合对象 */
    @JSONField(serialize = false)
    private List<TableCell> cells = new ArrayList<TableCell>(200);
    
    /** 所属表格 */
    private int rowIndex;
    
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
     * @param colIndex 列号 ，从0开始
     * @return 获取 cells属性值
     */
    public TableCell getCell(int colIndex) {
        return cells.get(colIndex);
    }
    
    /**
     * @return 获取 cells属性值
     */
    public List<TableCell> getCells() {
        return cells;
    }
    
    /**
     * 获得最后一个单元格
     *
     * @return 最后一个单元格
     */
    public TableCell getLastCell() {
        return this.cells.get(cells.size() - 1);
    }
    
    /**
     * 获得最后一个单元格
     *
     * @return 最后一个单元格
     */
    public TableCell getFirstCell() {
        return this.cells.get(0);
    }
    
    /**
     * 添加 单元 格
     * 
     * @param cell 单元 格
     */
    public void addCell(TableCell cell) {
        cells.add(cell);
        cell.setRow(this);
        cell.setTable(table);
    }
    
    /**
     * 添加被合并的单元格
     *
     * @param cellIndex 列号
     * @param cell 单元格
     */
    public void addCell(int cellIndex, TableCell cell) {
        cells.add(cellIndex, cell);
        cell.setRow(this);
        cell.setTable(table);
        for (int i = cellIndex + 1; i < cells.size(); i++) {
            cells.get(i).setCellIndex(i);
        }
    }
    
    /**
     * 添加 单元 格
     * 
     * @param alCells 单元 格集
     */
    public void addCells(List<TableCell> alCells) {
        this.cells.addAll(alCells);
        for (TableCell tableCell : alCells) {
            tableCell.setRow(this);
            tableCell.setTable(table);
        }
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
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[");
        for (TableCell tableCell : cells) {
            sb.append(tableCell.toString()).append(",");
        }
        sb.append("]");
        return sb.toString();
    }
}
