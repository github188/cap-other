/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

/**
 * 行预处理封装
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年1月12日 lizhongwen
 */
public class RowExtra {
    
    /** 是否纵向扩展 */
    private boolean ext;
    
    /** 行数据源 */
    private String dataSource;
    
    /** 行单元格 */
    private CellExtra[] cells;
    
    /**
     * @return 获取 ext属性值
     */
    public boolean isExt() {
        return ext;
    }
    
    /**
     * @param ext 设置 ext 属性值为参数值 ext
     */
    public void setExt(boolean ext) {
        this.ext = ext;
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
     * @return 获取 cells属性值
     */
    public CellExtra[] getCells() {
        return cells;
    }
    
    /**
     * @param cells 设置 cells 属性值为参数值 cells
     */
    public void setCells(CellExtra[] cells) {
        this.cells = cells;
    }
}
