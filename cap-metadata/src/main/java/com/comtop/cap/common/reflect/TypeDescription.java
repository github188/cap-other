/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.common.reflect;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

/**
 * 类别描述信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 */
public class TypeDescription {
    
    /** 表名 */
    private String tableName;
    
    /** 类对象 */
    private Class<?> clazz;
    
    /** id列名 */
    private FieldDescription idFieldDescription;
    
    /** 所有域描述 */
    private final Map<String, FieldDescription> fieldDescriptionMap = new HashMap<String, FieldDescription>(64);
    
    /** 带字段的域描述 */
    private final Map<String, FieldDescription> columnFieldDescriptionMap = new HashMap<String, FieldDescription>(64);
    
    /**
     * @return 获取 tableName属性值
     */
    public String getTableName() {
        return tableName;
    }
    
    /**
     * @param tableName 设置 tableName 属性值为参数值 tableName
     */
    public void setTableName(String tableName) {
        this.tableName = tableName;
    }
    
    /**
     * @return 获取 clazz属性值
     */
    public Class<?> getClazz() {
        return clazz;
    }
    
    /**
     * @param clazz 设置 clazz 属性值为参数值 clazz
     */
    public void setClazz(Class<?> clazz) {
        this.clazz = clazz;
    }
    
    /**
     * @return 获取 idFieldDescription属性值
     */
    public FieldDescription getIdFieldDescription() {
        return idFieldDescription;
    }
    
    /**
     * @param idFieldDescription 设置 idFieldDescription 属性值为参数值 idFieldDescription
     */
    public void setIdFieldDescription(FieldDescription idFieldDescription) {
        this.idFieldDescription = idFieldDescription;
    }
    
    /**
     * @return 获取 fieldDescriptionMap属性值
     */
    public Map<String, FieldDescription> getFieldDescriptionMap() {
        return fieldDescriptionMap;
    }
    
    /**
     * @param description 设置 fieldDescriptionMap 属性值为参数值 fieldDescriptionMap
     */
    public void addFieldDescriptionMap(FieldDescription description) {
        String key = description.getField().getName();
        if (fieldDescriptionMap.get(key) == null) {
            fieldDescriptionMap.put(key, description);
        }
        if (StringUtils.isNotBlank(description.getColumnName())) {
            columnFieldDescriptionMap.put(key, description);
        }
    }
    
    /**
     * @return 获取 columnFieldDescriptionMap属性值
     */
    public Map<String, FieldDescription> getColumnFieldDescriptionMap() {
        return columnFieldDescriptionMap;
    }
}
