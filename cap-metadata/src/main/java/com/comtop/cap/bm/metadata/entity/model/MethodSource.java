/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 方法来源
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-9-17 章尊志
 */
public enum MethodSource {
    
    /** 来源于实体 */
    ENTITY("entity"),
    
    /** 来源于服务对象 */
    SERVER_OBJECT("serverObject");
    
    /** 值 */
    private String value;
    
    /**
     * 构造函数
     * @param value 枚举值
     */
    private MethodSource(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
}
