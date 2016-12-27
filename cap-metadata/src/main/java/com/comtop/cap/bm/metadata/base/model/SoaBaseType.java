/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.base.model;

/**
 * soa 基础枚举类型
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-6-28 林玉千
 */
public enum SoaBaseType {
    
    /** 实体 */
    ENTITY_TYPE("entity"),
    
    /** 服务实体 */
    SERVICEOBJECT_TYPE("serviceObject");
    
    /** 枚举项对应的值 */
    private String value;
    
    /**
     * 构造函数
     * 
     * @param value 枚举类型值
     */
    private SoaBaseType(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
    /**
     * 
     * @see java.lang.Enum#toString()
     */
    @Override
    public String toString() {
        return this.value;
    }
    
}
