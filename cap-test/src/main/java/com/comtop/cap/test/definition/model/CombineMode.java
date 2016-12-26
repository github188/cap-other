/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.definition.model;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;

/**
 * 组合模式
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlType(name = "CombineMode")
@XmlEnum
public enum CombineMode {
    /** 固定 */
    @XmlEnumValue("fixed")
    FIXED,
    /** 动态 */
    @XmlEnumValue("dynamic")
    DYNAMIC;
}
