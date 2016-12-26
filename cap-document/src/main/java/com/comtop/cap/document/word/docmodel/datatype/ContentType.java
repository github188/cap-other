/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.datatype;

/**
 * 章节内容的类型。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
public enum ContentType {
    
    /** 已定义的表格 */
    TABLE,
    
    /** 未定义的表格 */
    UN_DEF_TABLE,
    
    /** 已定义文本 */
    TEXT,
    
    /** 未定义文本 */
    UN_DEF_TXT,
    
    /** 图片 */
    GRAPHIC,
    
    /** 嵌入式对象 */
    EMBED;
    
    @Override
    public String toString() {
        return this.name();
    }
}
