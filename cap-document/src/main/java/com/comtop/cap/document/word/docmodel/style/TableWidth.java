/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.style;

/**
 * 表格宽度
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月23日 lizhiyong
 */
public class TableWidth {
    
    /** 宽度 */
    public final float width;
    
    /** 是否以%为单位 */
    public final boolean percentUnit;
    
    /**
     * 构造函数
     * 
     * @param width width
     * @param percentUnit percentUnit
     */
    public TableWidth(float width, boolean percentUnit) {
        this.width = width;
        this.percentUnit = percentUnit;
    }
}
