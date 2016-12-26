/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

import static com.comtop.cap.document.util.ArrayUtils.ensureCapacity;
import static com.comtop.cap.document.util.ArrayUtils.reduceCapacity;

import java.util.Arrays;
import java.util.List;

import com.comtop.cap.document.word.docmodel.style.TableMargin;

/**
 * 表格封装（预处理结果）
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月12日 lizhongwen
 */
public class TableExtra {
    
    /** 行预处理封装 */
    private RowExtra[] rows;
    
    /** 所有单元格集合 */
    private CellExtra[][] cells;
    
    /** 合并单元格 */
    private List<TableMargin> margins;
    
    /** 名称 */
    private String title;
    
    /** 表格内容说明 表格备注 */
    private String remark;
    
    /** 表格宽度 */
    private Float width;
    
    /** 数据源 */
    private String dataSource;
    
    /**
     * @return 获取 rows属性值
     */
    public RowExtra[] getRows() {
        return rows;
    }
    
    /**
     * @param rows 设置 rows 属性值为参数值 rows
     */
    public void setRows(RowExtra[] rows) {
        this.rows = rows;
    }
    
    /**
     * @return 获取 cells属性值
     */
    public CellExtra[][] getCells() {
        return cells;
    }
    
    /**
     * @param cells 设置 cells 属性值为参数值 cells
     */
    public void setCells(CellExtra[][] cells) {
        this.cells = cells;
    }
    
    /**
     * @return 获取 margins属性值
     */
    public List<TableMargin> getMargins() {
        return margins;
    }
    
    /**
     * @param margins 设置 margins 属性值为参数值 margins
     */
    public void setMargins(List<TableMargin> margins) {
        this.margins = margins;
    }
    
    /**
     * @return 获取 title属性值
     */
    public String getTitle() {
        return title;
    }
    
    /**
     * @param title 设置 title 属性值为参数值 title
     */
    public void setTitle(String title) {
        this.title = title;
    }
    
    /**
     * @return 获取 remark属性值
     */
    public String getRemark() {
        return remark;
    }
    
    /**
     * @param remark 设置 remark 属性值为参数值 remark
     */
    public void setRemark(String remark) {
        this.remark = remark;
    }
    
    /**
     * @return 获取 width属性值
     */
    public Float getWidth() {
        return width;
    }
    
    /**
     * @param width 设置 width 属性值为参数值 width
     */
    public void setWidth(Float width) {
        this.width = width;
    }
    
    /**
     * @return 获取 dataSource属性值
     */
    public String getDataSource() {
        return dataSource;
    }
    
    /**
     * @param dataSource 设置 dataSource 属性值为参数值 dataSource
     */
    public void setDataSource(String dataSource) {
        this.dataSource = dataSource;
    }
    
    /**
     * 添加单元格扩展封装
     *
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @param cellExtra 单元格扩展
     */
    public void setCell(final int rowIndex, final int colIndex, final CellExtra cellExtra) {
        if (cells == null) {
            cells = new CellExtra[10][];
        }
        cells = (CellExtra[][]) ensureCapacity(rowIndex + 1, cells);
        CellExtra[] rowCells = cells[rowIndex];
        if (rowCells == null) {
            rowCells = new CellExtra[10];
        }
        cells[rowIndex] = rowCells = (CellExtra[]) ensureCapacity(colIndex + 1, rowCells);
        rowCells[colIndex] = cellExtra;
    }
    
    /**
     * 获取指定单元格扩展封装
     *
     * @param rowIndex 行索引
     * @param colIndex 列索引
     * @return 单元格扩展
     */
    public CellExtra getCell(int rowIndex, int colIndex) {
        if (rowIndex < 0 || colIndex < 0) {
            return null;
        }
        if (rowIndex >= cells.length) {
            return null;
        }
        CellExtra[] rowCells = cells[rowIndex];
        if (rowCells == null || colIndex >= rowCells.length) {
            return null;
        }
        return rowCells[colIndex];
    }
    
    /**
     * 重设容量
     */
    public void reduce() {
        for (int i = 0; i < cells.length; i++) {
            cells[i] = (CellExtra[]) reduceCapacity(cells[i]);
        }
        cells = (CellExtra[][]) reduceCapacity(cells);
        for (int i = 0; i < rows.length; i++) {
            RowExtra row = rows[i];
            if (i < cells.length) {
                row.setCells(cells[i]);
            }
        }
    }
    
    /**
     * 
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        StringBuffer buffer = new StringBuffer();
        for (CellExtra[] cellExtras : cells) {
            buffer.append(Arrays.toString(cellExtras)).append("\n");
        }
        return "TableExtra [cells=" + buffer.toString() + "]";
    }
}
