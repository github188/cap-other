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
 * 值类型
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年6月23日 lizhongwen
 */
@XmlType(name = "ValueType")
@XmlEnum
public enum ValueType {
    /** 字符串 */
    @XmlEnumValue("String")
    STRING("String"),
    /** 时间 */
    @XmlEnumValue("Time")
    TIME("Time"),
    /** 数值 */
    @XmlEnumValue("Number")
    NUMBER("Number"),
    /** 布尔 */
    @XmlEnumValue("Bool")
    BOOL("Bool");
    
    /** 描述 */
    private String description;
    
    /**
     * 构造函数
     * 
     * @param description 描述
     */
    private ValueType(String description) {
        this.description = description;
    }
    
    /**
     * @return 获取 description属性值
     */
    public String getDescription() {
        return description;
    }
    
}
