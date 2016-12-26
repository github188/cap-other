/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.model;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlTransient;
import javax.xml.bind.annotation.XmlType;

/**
 * 模板中的表格行对象
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月15日 lizhiyong
 */
@XmlType(name = "TableRowElementType")
@XmlAccessorType(XmlAccessType.FIELD)
public class DCTableRow extends ConfigElement {
    
    /** 序列化号 */
    private static final long serialVersionUID = 1L;
    
    /** 所属表格 */
    @XmlTransient
    private DCTable table;
    
    /** 是否是可扩展行，默认为false */
    @XmlAttribute
    private Boolean extRow;
    
    /** 表格单元格 */
    @XmlElements(@XmlElement(name = "td", type = DCTableCell.class))
    private List<DCTableCell> xmlCells = new ArrayList<DCTableCell>(200);
    
    /** 内存中的cells集合对象 */
    @XmlTransient
    private List<DCTableCell> cells = new ArrayList<DCTableCell>(200);
    
    /** 所属表格 */
    @XmlTransient
    private int rowIndex;
    
    /**
     * @return 获取 xmlCells属性值
     */
    public List<DCTableCell> getXmlCells() {
        return xmlCells;
    }
    
    /**
     * 初始化配置
     *
     */
    @Override
    public void initConfig() {
        cells.addAll(xmlCells);
        int cellIndex = 0;
        for (DCTableCell tableCell : cells) {
            tableCell.setTable(this.table);
            tableCell.setCellIndex(cellIndex++);
            tableCell.setRowIndex(this.rowIndex);
            tableCell.initConfig();
        }
    }
    
    /**
     * @return 获取 extRow属性值
     */
    public boolean isExtRow() {
        return extRow == null ? Boolean.FALSE : extRow.booleanValue();
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
     * @param colIndex 列号 ，从0开始
     * @return 获取 cells属性值
     */
    public DCTableCell getCell(int colIndex) {
        return cells.get(colIndex);
    }
    
    /**
     * @return 获取 cells属性值
     */
    public List<DCTableCell> getCells() {
        return cells;
    }
    
    /**
     * 获得最后一个单元格
     *
     * @return 最后一个单元格
     */
    public DCTableCell getLastCell() {
        return this.cells.get(cells.size() - 1);
    }
    
    /**
     * 获得最后一个单元格
     *
     * @return 最后一个单元格
     */
    public DCTableCell getFirstCell() {
        return this.cells.get(0);
    }
    
    /**
     * 添加 单元 格
     * 
     * @param cell 单元 格
     */
    public void addCell(DCTableCell cell) {
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
    public void addCell(int cellIndex, DCTableCell cell) {
        cells.add(cellIndex, cell);
        cell.setRow(this);
        cell.setTable(table);
        // 将当前单元格页面的单元格的cellIndex均+1.
        for (int i = cellIndex + 1; i < cells.size(); i++) {
            cells.get(i).setCellIndex(i);
        }
    }
    
    /**
     * 添加 单元 格
     * 
     * @param alCells 单元 格集
     */
    public void addCells(List<DCTableCell> alCells) {
        this.cells.addAll(alCells);
        for (DCTableCell tableCell : alCells) {
            tableCell.setRow(this);
            tableCell.setTable(table);
        }
    }
    
    /**
     * @return 获取 table属性值
     */
    public DCTable getTable() {
        return table;
    }
    
    /**
     * @param table 设置 table 属性值为参数值 table
     */
    public void setTable(DCTable table) {
        this.table = table;
    }
    
    @Override
    public String toString() {
        StringBuffer sb = new StringBuffer();
        sb.append("[");
        for (DCTableCell tableCell : cells) {
            sb.append(tableCell.toString()).append(",");
        }
        sb.append("]");
        return sb.toString();
    }
}
