/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 访问级别
 * 
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-4-1 章尊志
 */
public enum AccessLevel {
    /** private */
    PRIVATE_LEVEL("private"),
    
    /** default */
    DEFAULT_LEVEL(""),
    
    /** protected */
    PROTECTED_LEVEL("protected"),
    
    /** public */
    PUBLIC_LEVEL("public");
    
    /** 值 */
    private String value;
    
    /**
     * 构造函数
     * 
     * @param value 枚举值
     */
    private AccessLevel(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
}
