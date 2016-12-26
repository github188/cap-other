/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

/**
 * 表格外观
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月5日 lizhongwen
 */
public class TableLook {
    
    /** 标题行 ,可以设置表格第一行是否采用不同的格式； */
    private boolean fisrtRow = Boolean.TRUE;
    
    /** 标题行值 */
    private int fisrtRowVal = 0x0020;
    
    /** 汇总行,可以设置表格最底部一行是否采用不同的格式； */
    private boolean lastRow;
    
    /** 汇总行值 */
    private int lastRowVal = 0x0040;
    
    /** 第一列 ,可以设置第一列是否采用不同的格式； */
    private boolean firstColumn = Boolean.TRUE;
    
    /** 汇总行值 */
    private int firstColumnVal = 0x0080;
    
    /** 最后一列 ,可以设置最后一列是否采用不同的格式 */
    private boolean lastColumn;
    
    /** 汇总行值 */
    private int lastColumnVal = 0x0100;
    
    /** 非镶边行 ,可以设置相邻行是否采用不同的格式； */
    private boolean noHBand;
    
    /** 非镶边行值 ,可以设置相邻列是否采用不同的格式； */
    private int noHBandVal = 0x0200;
    
    /** 非镶边列 */
    private boolean noVBand = Boolean.TRUE;
    
    /** 非镶边列值 */
    private int noVBandVal = 0x0400;
    
    /**
     * @return 获取 fisrtRow属性值
     */
    public boolean isFisrtRow() {
        return fisrtRow;
    }
    
    /**
     * @param fisrtRow 设置 fisrtRow 属性值为参数值 fisrtRow
     */
    public void setFisrtRow(boolean fisrtRow) {
        this.fisrtRow = fisrtRow;
    }
    
    /**
     * @return 获取 lastRow属性值
     */
    public boolean isLastRow() {
        return lastRow;
    }
    
    /**
     * @param lastRow 设置 lastRow 属性值为参数值 lastRow
     */
    public void setLastRow(boolean lastRow) {
        this.lastRow = lastRow;
    }
    
    /**
     * @return 获取 firstColumn属性值
     */
    public boolean isFirstColumn() {
        return firstColumn;
    }
    
    /**
     * @param firstColumn 设置 firstColumn 属性值为参数值 firstColumn
     */
    public void setFirstColumn(boolean firstColumn) {
        this.firstColumn = firstColumn;
    }
    
    /**
     * @return 获取 lastColumn属性值
     */
    public boolean isLastColumn() {
        return lastColumn;
    }
    
    /**
     * @param lastColumn 设置 lastColumn 属性值为参数值 lastColumn
     */
    public void setLastColumn(boolean lastColumn) {
        this.lastColumn = lastColumn;
    }
    
    /**
     * @return 获取 noHBand属性值
     */
    public boolean isNoHBand() {
        return noHBand;
    }
    
    /**
     * @param noHBand 设置 noHBand 属性值为参数值 noHBand
     */
    public void setNoHBand(boolean noHBand) {
        this.noHBand = noHBand;
    }
    
    /**
     * @return 获取 noVBand属性值
     */
    public boolean isNoVBand() {
        return noVBand;
    }
    
    /**
     * @param noVBand 设置 noVBand 属性值为参数值 noVBand
     */
    public void setNoVBand(boolean noVBand) {
        this.noVBand = noVBand;
    }
    
    /**
     * 获取十六进制外观值
     *
     * @return 十六进制外观值
     */
    public String getValAsHexString() {
        int val = 0;
        if (this.fisrtRow) {
            val += this.fisrtRowVal;
        }
        if (this.firstColumn) {
            val += this.firstColumnVal;
        }
        if (this.lastRow) {
            val += this.lastRowVal;
        }
        if (this.lastColumn) {
            val += this.lastColumnVal;
        }
        if (this.noHBand) {
            val += this.noHBandVal;
        }
        if (this.noVBand) {
            val += this.noVBandVal;
        }
        String ret = Integer.toHexString(val).toUpperCase();
        return (ret.length() < 4 ? "0000".substring(0, 4 - ret.length()) + ret : ret);
    }
    
}
