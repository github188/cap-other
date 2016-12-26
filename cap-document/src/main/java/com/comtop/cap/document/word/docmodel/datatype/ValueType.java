/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.datatype;

/**
 * 值类型
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
public enum ValueType {
    
    /** 简单值 */
    SIMPLE,
    
    /** 文本值 */
    TEXT,
    
    /** 图形值 */
    GRAPHIC,
    
    /** 嵌入式对象值 */
    EMBED;
    
    @Override
    public String toString() {
        return this.name();
    }
    
}
