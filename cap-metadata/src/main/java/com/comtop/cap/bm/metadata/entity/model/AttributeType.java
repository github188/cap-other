
package com.comtop.cap.bm.metadata.entity.model;

import java.util.HashMap;
import java.util.Map;

/**
 * 属性类型
 * 
 * @author 章尊志
 * @since 1.0
 * @version 2014-10-27 章尊志
 */
public enum AttributeType {
    /** String类型 */
    VOID("void", "void", null),
    /** String类型 */
    STRING("String", "String", "java.lang.String"),
    /** int类型 */
    INT("int", "Integer", "java.lang.Integer"),
    /** Integer类型 */
    INTEGER("Integer", "Integer", "java.lang.Integer"),
    /** boolean类型 */
    BOOLEAN("boolean", "Boolean", "java.lang.Boolean"),
    /** double类型 */
    DOUBLE("double", "Double", "java.lang.Double"),
    /** byte类型 */
    BYTE("byte", "Byte", "java.lang.Byte"),
    /** shot类型 */
    SHOT("short", "Short", "java.lang.Short"),
    /** long类型 */
    LONG("long", "Long", "java.lang.Long"),
    /** float类型 */
    FLOAT("float", "Float", "java.lang.Float"),
    /** char类型 */
    CHAR("char", "Character", "java.lang.Character"),
    /** java.math.BigDecimal类型 */
    JAVA_MATH_BIGDECIMAL("java.math.BigDecimal", "BigDecimal", "java.math.BigDecimal"),
    
    /** java.sql.Clob类型 */
    JAVA_SQL_CLOB("java.sql.Clob", "Clob", "java.sql.Clob"),
    
    /** java.sql.Blob类型 */
    JAVA_SQL_BLOB("java.sql.Blob", "Blob", "java.sql.Blob"),
    
    /** java.sql.Date类型 */
    JAVA_SQL_DATE("java.sql.Date", "Date", "java.sql.Date"),
    /** java.sql.Timestamp类型 */
    JAVA_SQL_TIMESTAMP("java.sql.Timestamp", "Timestamp", "java.sql.Timestamp"),
    /** java.lang.Object类型 */
    JAVA_LANG_OBJECT("java.lang.Object", "Object", "java.lang.Object"),
    /** java.util.List类型 */
    JAVA_UTIL_LIST("java.util.List", "List", "java.util.List"),
    /** java.util.Map类型 */
    JAVA_UTIL_MAP("java.util.Map", "Map", "java.util.Map");
    
    /** 值 */
    private String value;
    
    /** 简称 */
    private String shortName;
    
    /**
     * @return the shortName
     */
    public String getShortName() {
        return shortName;
    }
    
    /**
     * @param shortName the shortName to set
     */
    public void setShortName(String shortName) {
        this.shortName = shortName;
    }
    
    /**
     * @return the fullName
     */
    public String getFullName() {
        return fullName;
    }
    
    /**
     * @param fullName the fullName to set
     */
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    /** 全称 */
    private String fullName;
    
    /***/
    private final static Map<String, AttributeType> valueTypeMap = new HashMap<String, AttributeType>();
    
    static {
        for (AttributeType a : values()) {
            valueTypeMap.put(a.value, a);
        }
    }
    
    /**
     * 构造函数
     * 
     * @param value 枚举值
     * @param shortName 类型简称
     * @param fullName 类型全路径
     */
    private AttributeType(String value, String shortName, String fullName) {
        this.value = value;
        this.shortName = shortName;
        this.fullName = fullName;
    }
    
    /**
     * @return 获取 value属性值
     */
    public String getValue() {
        return value;
    }
    
    /**
     * 根据值获取Type类型
     * 
     * @param v 值
     * @return Type类型
     */
    public static AttributeType getAttributeType(String v) {
        return valueTypeMap.get(v);
    }
    
}
