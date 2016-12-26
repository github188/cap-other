/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

/**
 * 表格合并对象
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年12月3日 lizhongwen
 */
public class TableMargin {
    
    /** 起始行 */
    private int startRowIndex;
    
    /** 起始列 */
    private int startColIndex;
    
    /** 结束行 */
    private int endRowIndex;
    
    /** 结束列 */
    private int endColIndex;
    
    /**
     * 构造函数
     */
    public TableMargin() {
        
    }
    
    /**
     * 构造函数
     * 
     * @param rowIndex 行索引
     * @param startColIndex 起始列
     * @param endColIndex 结束列
     */
    public TableMargin(int rowIndex, int startColIndex, int endColIndex) {
        this(rowIndex, startColIndex, rowIndex, endColIndex);
    }
    
    /**
     * 构造函数
     * 
     * @param startRowIndex 起始行
     * @param startColIndex 起始列
     * @param endRowIndex 结束行
     * @param endColIndex 结束列
     */
    public TableMargin(int startRowIndex, int startColIndex, int endRowIndex, int endColIndex) {
        this.startRowIndex = startRowIndex;
        this.startColIndex = startColIndex;
        this.endRowIndex = endRowIndex;
        this.endColIndex = endColIndex;
    }
    
    /**
     * @return 获取 startRowIndex属性值
     */
    public int getStartRowIndex() {
        return startRowIndex;
    }
    
    /**
     * @param startRowIndex 设置 startRowIndex 属性值为参数值 startRowIndex
     */
    public void setStartRowIndex(int startRowIndex) {
        this.startRowIndex = startRowIndex;
    }
    
    /**
     * @return 获取 startColIndex属性值
     */
    public int getStartColIndex() {
        return startColIndex;
    }
    
    /**
     * @param startColIndex 设置 startColIndex 属性值为参数值 startColIndex
     */
    public void setStartColIndex(int startColIndex) {
        this.startColIndex = startColIndex;
    }
    
    /**
     * @return 获取 endRowIndex属性值
     */
    public int getEndRowIndex() {
        return endRowIndex;
    }
    
    /**
     * @param endRowIndex 设置 endRowIndex 属性值为参数值 endRowIndex
     */
    public void setEndRowIndex(int endRowIndex) {
        this.endRowIndex = endRowIndex;
    }
    
    /**
     * @return 获取 endColIndex属性值
     */
    public int getEndColIndex() {
        return endColIndex;
    }
    
    /**
     * @param endColIndex 设置 endColIndex 属性值为参数值 endColIndex
     */
    public void setEndColIndex(int endColIndex) {
        this.endColIndex = endColIndex;
    }
}
