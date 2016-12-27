/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.common.reflect;

import java.lang.reflect.Field;

/**
 * 域描述信息
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 */
public class FieldDescription {
    
    /** 域 */
    Field field;
    
    /** 列名 */
    String columnName;
    
    /** 数据库字段类型 */
    String dbColumnType;
    
    /**
     * @return 获取 field属性值
     */
    public Field getField() {
        return field;
    }
    
    /**
     * @param field 设置 field 属性值为参数值 field
     */
    public void setField(Field field) {
        this.field = field;
    }
    
    /**
     * @return 获取 columnName属性值
     */
    public String getColumnName() {
        return columnName;
    }
    
    /**
     * @param columnName 设置 columnName 属性值为参数值 columnName
     */
    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }
    
    /**
     * @return 获取 dbColumnType属性值
     */
    public String getDbColumnType() {
        return dbColumnType;
    }
    
    /**
     * @param dbColumnType 设置 dbColumnType 属性值为参数值 dbColumnType
     */
    public void setDbColumnType(String dbColumnType) {
        this.dbColumnType = dbColumnType;
    }
    
}
