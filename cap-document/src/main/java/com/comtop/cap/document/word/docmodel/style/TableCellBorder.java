/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

/**
 * 单元格边框
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月3日 lizhiyong
 */
public class TableCellBorder {
    
    /** 是否有边框 */
    private final boolean hasBorder;
    
    /** 边框大小 */
    private final Float borderSize;
    
    /** fromTableCell */
    private final boolean fromTableCell;
    
    /** 边框颜色 */
    private final Color borderColor;
    
    /**
     * 构造函数
     * 
     * @param hasBorder z
     * @param fromTableCell z
     */
    public TableCellBorder(boolean hasBorder, boolean fromTableCell) {
        this.hasBorder = hasBorder;
        this.borderSize = null;
        this.borderColor = null;
        this.fromTableCell = fromTableCell;
    }
    
    /**
     * 构造函数
     * 
     * @param borderSize x
     * @param borderColor x
     * @param fromTableCell x
     */
    public TableCellBorder(Float borderSize, Color borderColor, boolean fromTableCell) {
        this.hasBorder = true;
        this.borderSize = borderSize;
        this.borderColor = borderColor;
        this.fromTableCell = fromTableCell;
    }
    
    /**
     * @return 获取 hasBorder属性值
     */
    public boolean isHasBorder() {
        return hasBorder;
    }
    
    /**
     * @return 获取 borderSize属性值
     */
    public Float getBorderSize() {
        return borderSize;
    }
    
    /**
     * @return 获取 fromTableCell属性值
     */
    public boolean isFromTableCell() {
        return fromTableCell;
    }
    
    /**
     * @return 获取 borderColor属性值
     */
    public Color getBorderColor() {
        return borderColor;
    }
    
}
