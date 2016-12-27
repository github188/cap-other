/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 关联关系多重性常量
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2014-3-26 李忠文
 */
public enum RelatioMultiple {
    /**
     * 一对一
     */
    ONE_ONE("One-One"),
    
    /**
     * 一对多
     */
    ONE_MANY("One-Many"),
    
    /**
     * 多对一
     */
    MANY_ONE("Many-One"),
    
    /**
     * 多对多
     */
    MANY_MANY("Many-Many");
    
    /** 值 */
    private String value;
    
    /**
     * 构造函数
     * @param value 枚举值
     */
    private RelatioMultiple(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
}
