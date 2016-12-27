/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.common.executor;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.comtop.cap.common.reflect.FieldDescription;
import com.comtop.cap.common.reflect.TypeDescription;

/**
 * SQL构造器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 */
public class SqlBuilder {
    
    /**
     * 构建根据id读指定属性的SQL
     *
     * @param typeDescription 类型描述
     * @param properties 属性名称集
     * @return SQL 没有表名、没有主键注解、无法根据属性找到列名，均返回null。
     */
    public static String buildSQLReadPropertybyId(TypeDescription typeDescription, List<String> properties) {
        if (properties == null || properties.size() == 0) {
            return null;
        }
        if (StringUtils.isBlank(typeDescription.getTableName()) || typeDescription.getIdFieldDescription() == null
            || typeDescription.getColumnFieldDescriptionMap() == null) {
            return null;
        }
        
        Map<String, FieldDescription> propertiesDescriptionMap = typeDescription.getColumnFieldDescriptionMap();
        
        StringBuffer sbSQL = new StringBuffer();
        sbSQL.append("SELECT ");
        int index = 0;
        FieldDescription description = null;
        for (String field : properties) {
            description = propertiesDescriptionMap.get(field);
            if (description != null) {
                index++;
                sbSQL.append(description.getColumnName()).append(',');
            }
        }
        if (index == 0) {
            return null;
        }
        String idColumnName = typeDescription.getIdFieldDescription().getColumnName();
        String tableName = typeDescription.getTableName();
        sbSQL.deleteCharAt(sbSQL.length() - 1);
        sbSQL.append("  FROM ").append(tableName);
        sbSQL.append(" WHERE ").append(idColumnName).append(" = ? ");
        return sbSQL.toString();
    }
    
    /**
     * 构建根据id更新指定属性的SQL
     *
     * @param typeDescription 类型描述
     * @param propertiesMap 属性值集
     * @return SQL 没有表名、没有主键注解、无法根据属性找到列名，均返回null。
     */
    public static String buildSQLUpdatePropertybyId(TypeDescription typeDescription, Map<String, Object> propertiesMap) {
        if (propertiesMap == null || propertiesMap.size() == 0) {
            return null;
        }
        if (StringUtils.isBlank(typeDescription.getTableName()) || typeDescription.getIdFieldDescription() == null
            || typeDescription.getColumnFieldDescriptionMap() == null) {
            return null;
        }
        
        StringBuffer sbSQL = new StringBuffer();
        String tableName = typeDescription.getTableName();
        Map<String, FieldDescription> propertyColumnMap = typeDescription.getColumnFieldDescriptionMap();
        sbSQL.append("UPDATE ").append(tableName).append(" SET ");
        int index = 0;
        FieldDescription description = null;
        for (String key : propertiesMap.keySet()) {
            description = propertyColumnMap.get(key);
            if (description != null) {
                sbSQL.append(description.getColumnName()).append("=?,");
                index++;
            }
        }
        if (index == 0) {
            return null;
        }
        sbSQL.deleteCharAt(sbSQL.length() - 1);
        String idColumnName = typeDescription.getIdFieldDescription().getColumnName();
        sbSQL.append(" WHERE ").append(idColumnName).append(" = ? ");
        return sbSQL.toString();
    }
}
