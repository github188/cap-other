/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

/**
 * 属性类型、参数类型、方法返回值类型VO
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-9-17 章尊志
 */
public enum AttributeSourceType {
    /** 基本类型 */
    PRIMITIVE("primitive"),
    /** 数据字典 */
    DATA_DICTIONARY("dataDictionary"),
    /** 枚举 */
    ENUM_TYPE("enumType"),
    /** 关联其它实体 属性 */
    OTHER_ENTITY_ATTRIBUTE("otherEntityAttibute"),
    /** 第三方类型 */
    THIRD_PARTY_TYPE("thirdPartyType"),
    /** 集合 */
    COLLECTION("collection"),
    /** 对象 */
    JAVA_OBJECT("javaObject"),
    /** 实体 */
    ENTITY("entity");
    
    /** 值 */
    private String value;
    
    /**
     * 构造函数
     * 
     * @param value 枚举值
     */
    private AttributeSourceType(String value) {
        this.value = value;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
}
