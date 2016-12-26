/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.docmodel.datatype;

import javax.xml.bind.annotation.XmlEnum;

/**
 * 表格主键类型
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月21日 lizhiyong
 */
@XmlEnum
public enum IDKeyType {
    
    /** 单个：单行，单列 */
    SINGLE,
    
    /** 联合 多列或多行形成的联合主键 */
    UNION,
    
    /** 没有主键 */
    NONE;
    
    @Override
    public String toString() {
        return this.name();
    }
}
