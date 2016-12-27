/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 类模式
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2015-9-17 章尊志
 */
public enum ClassPattern {
    
    /** 普通的 */
    COMMON("common"),
    
    /** 抽象的 */
    ABSTRACT("abstract");
    
    /** 值 */
    private String value;
    
    /**
     * @param Value 枚举值
     */
    private ClassPattern(String Value) {
        this.value = Value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
}
