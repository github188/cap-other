/******************************************************************************
 * Copyright (C) 2014 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.entity.model;

import com.comtop.cap.runtime.base.enumeration.IEnum;

/**
 * java 数据类型 枚举类
 * 
 * @author 林玉千
 * @since jdk1.6
 * @version 2016-12-2 林玉千
 */
public enum JavaDatatypeEnum implements IEnum {
    /** boolean类型 */
    OBJ_BOOLEAN_TYPE("boolean", "class java.lang.Boolean", "primitive"),
    /** byte类型 */
    OBJ_BYTE_TYPE("byte", "class java.lang.Byte", "primitive"),
    /** char类型 */
    OBJ_CHARACTER_TYPE("char", "class java.lang.Character", "primitive"),
    /** float类型 */
    OBJ_FLOAT_TYPE("float", "class java.lang.Float", "primitive"),
    /** long类型 */
    OBJ_LONG_TYPE("long", "class java.lang.Long", "primitive"),
    /** short类型 */
    OBJ_SHORT_TYPE("short", "class java.lang.Short", "primitive"),
    /** int类型 */
    OBJ_INTEGER_TYPE("int", "class java.lang.Integer", "primitive"),
    /** double类型 */
    OBJ_DOUBLE_TYPE("double", "class java.lang.Double", "primitive"),
    /** boolean类型 */
    BOOLEAN_TYPE("boolean", "boolean", "primitive"),
    /** byte类型 */
    BYTE_TYPE("byte", "byte", "primitive"),
    /** char类型 */
    CHARACTER_TYPE("char", "char", "primitive"),
    /** float类型 */
    FLOAT_TYPE("float", "float", "primitive"),
    /** long类型 */
    LONG_TYPE("long", "long", "primitive"),
    /** short类型 */
    SHORT_TYPE("short", "short", "primitive"),
    /** int类型 */
    INTEGER_TYPE("int", "int", "primitive"),
    /** double类型 */
    DOUBLE_TYPE("double", "double", "primitive"),
    /** String类型 */
    STRING_TYPE("String", "class java.lang.String", "primitive"),
    
    /** Object类型 */
    OBJECT_TYPE("java.lang.Object", "class java.lang.Object", "javaObject"),
    
    /** List类型 */
    LIST_TYPE("java.util.List", "interface java.util.List", "collection"),
    
    /** Map类型 */
    MAP_TYPE("java.util.Map", "interface java.util.Map", "collection"),
    
    /** Blob类型 */
    BLOB_TYPE("java.sql.Blob", "interface java.sql.Blob", "primitive"),
    /** Clob类型 */
    CLOB_TYPE("java.sql.Clob", "interface java.sql.Clob", "primitive"),
    
    /** Date类型 */
    Date_TYPE("java.sql.Date", "class java.sql.Date", "primitive"),
    
    /** Timestamp类型 */
    TIMESTAMP_TYPE("java.sql.Timestamp", "class java.sql.Timestamp", "primitive");
    
    /** 枚举项对应的健 */
    private String key;
    
    /** 枚举项对应的值 */
    private String value;
    
    /** 类型的基本来源 */
    private String source;
    
    /**
     * @param value 枚举值
     * @param key 健
     * @param source 类型的基本来源
     */
    private JavaDatatypeEnum(String value, String key, String source) {
        this.key = key;
        this.value = value;
        this.source = source;
    }
    
    /**
     * @return 获取 source属性值
     */
    public String getSource() {
        return source;
    }
    
    /**
     * @return 获取 value属性值
     */
    @Override
    public String getValue() {
        return value;
    }
    
    /**
     * @return 获取 name属性值
     */
    @Override
    public String getKey() {
        return key;
    }
    
    /**
     * 
     * @see com.comtop.cap.runtime.base.enumeration.IEnum#getName()
     */
    @Override
    public String getName() {
        return this.getSource();
    }
    
}
