/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.data;

/**
 * 单元格内容容器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2016年1月20日 lizhiyong
 */
public class CellContainer extends Container {
    
    /** 序列化号 */
    private static final long serialVersionUID = 1L;
    
    /** 关联的tableCell */
    private TableCell tableCell;
    
    /**
     * @return 获取 tableCell属性值
     */
    public TableCell getTableCell() {
        return tableCell;
    }
    
    /**
     * @param tableCell 设置 tableCell 属性值为参数值 tableCell
     */
    public void setTableCell(TableCell tableCell) {
        this.tableCell = tableCell;
    }
}
