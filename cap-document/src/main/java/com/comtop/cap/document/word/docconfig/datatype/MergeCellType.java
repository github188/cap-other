/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docconfig.datatype;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 单元格合并类型,配置在单元格上用于表示该单元格的合并方向，主要用于数据导出时指定是否合并某些单元格的数据。
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
@XmlEnum
public enum MergeCellType {
    
    /** 不合并 .默认值 */
    NONE,
    
    /** 横向合并，从左往右合并 */
    HORIZONTAL,
    
    /** 纵向合并，从上往下合并 */
    VERTICAL,
    
    /** 横向纵向都合并 */
    BOTH;
    
    @Override
    public String toString() {
        return this.name();
    }
    
}
