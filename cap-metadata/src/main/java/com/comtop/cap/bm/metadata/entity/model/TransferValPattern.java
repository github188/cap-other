/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 数据库对象传值方式
 * 
 * @author 凌晨
 * @since 1.0
 * @version 2015-10-8 凌晨
 */
public enum TransferValPattern {
    
    /** 常量 */
    CONSTANT("constant"),
    
    /** 方法参数 */
    METHOD_PARAM("methodParam"),
    
    /** 实体属性 */
    ENTITY_ATTRIBUTE("entity_attribute");
    
    /** 枚举项对应的值 */
    private String value;
    
    /**
     * 构造函数
     * 
     * @param value 枚举值
     */
    private TransferValPattern(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
}
