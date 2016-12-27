/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.common.reflect;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

import org.apache.commons.lang.StringUtils;

/**
 * 反射工具类
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年12月4日 lizhiyong
 */
public class ReflectUtil {
    
    /** 类别映射集 用于缓存 */
    private static final Map<Class<?>, TypeDescription> TYPE_MAP = new HashMap<Class<?>, TypeDescription>(64);
    
    /**
     * 设置字段的值
     *
     * @param field 字段
     * @param target 目标对象
     * @param value 值
     */
    public static void setField(Field field, Object target, Object value) {
        try {
            makeAccessible(field);
            field.set(target, value);
        } catch (IllegalAccessException ex) {
            throw new IllegalStateException("Unexpected reflection exception - " + ex.getClass().getName() + ": "
                + ex.getMessage());
        }
    }
    
    /**
     * 设置字段的值
     *
     * @param field 字段
     * @param target 目标对象
     * @return 返回
     */
    public static Object getField(Field field, Object target) {
        try {
            makeAccessible(field);
            return field.get(target);
        } catch (IllegalAccessException ex) {
            throw new IllegalStateException("Unexpected reflection exception - " + ex.getClass().getName() + ": "
                + ex.getMessage());
        }
    }
    
    /**
     * 设置字段可以访问
     *
     * @param field 字段
     */
    public static void makeAccessible(Field field) {
        if ((!Modifier.isPublic(field.getModifiers()) || !Modifier.isPublic(field.getDeclaringClass().getModifiers()) || Modifier
            .isFinal(field.getModifiers())) && !field.isAccessible()) {
            field.setAccessible(true);
        }
    }
    
    /**
     * 获得类的所有属性
     *
     * @param clazz 类型
     * @return 属性集
     */
    public static List<Field> getFields(Class<?> clazz) {
        Class<?> tempClass = clazz;
        List<Field> alField = new ArrayList<Field>(20);
        for (; tempClass != Object.class; tempClass = tempClass.getSuperclass()) {
            Field[] fields = tempClass.getDeclaredFields();
            if (fields != null && fields.length > 0) {
                for (Field field2 : fields) {
                    alField.add(field2);
                }
            }
        }
        return alField;
    }
    
    /**
     * 获得类别描述信息
     *
     * @param clazz 类
     * @return 类型描述
     */
    public static TypeDescription getTypeDescription(Class<?> clazz) {
        if (clazz == null) {
            return null;
        }
        TypeDescription description = TYPE_MAP.get(clazz);
        if (description != null) {
            return description;
        }
        TypeDescription typeDescription = new TypeDescription();
        typeDescription.setClazz(clazz);
        Table table = clazz.getAnnotation(Table.class);
        if (table != null && StringUtils.isNotBlank(table.name())) {
            typeDescription.setTableName(table.name());
        }
        
        List<Field> fields = getFields(clazz);
        for (Field field : fields) {
            Column column = field.getAnnotation(Column.class);
            FieldDescription fieldDescription = new FieldDescription();
            fieldDescription.setField(field);
            if (column != null && StringUtils.isNotBlank(column.name())) {
                fieldDescription.setColumnName(column.name());
            }
            typeDescription.addFieldDescriptionMap(fieldDescription);
            if (field.getAnnotation(Id.class) != null) {
                FieldDescription idFieldDescription = new FieldDescription();
                idFieldDescription.setField(field);
                idFieldDescription.setColumnName(fieldDescription.getColumnName());
                typeDescription.setIdFieldDescription(idFieldDescription);
            }
        }
        TYPE_MAP.put(clazz, typeDescription);
        return typeDescription;
    }
    
    /**
     * 获得类型的泛型参数实际类型
     *
     * @param clazz 待处理的对象
     * @return 泛型参数类型
     */
    public static Type[] getParameterizedType(Class<?> clazz) {
        ParameterizedType type = (ParameterizedType) clazz.getGenericSuperclass();
        return type.getActualTypeArguments();
    }
    
}
