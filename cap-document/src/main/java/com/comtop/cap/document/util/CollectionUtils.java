/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.util;

import java.lang.reflect.Field;
import java.util.Collection;
import java.util.List;

import com.comtop.cap.document.expression.annotation.Function;
import com.comtop.cap.document.expression.converter.ConverterUtils;

/**
 * 集合工具类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class CollectionUtils {
    
    /**
     * 检查集合是否为空
     * 
     * @param collection the Collection to check
     * @return whether the given Collection is empty
     */
    public static boolean isEmpty(Collection<?> collection) {
        return (collection == null || collection.isEmpty());
    }
    
    /**
     * 获取集合中元素的类型
     * 
     * @param collection the Collection to check
     * @return the common element type, or <code>null</code> if no clear
     *         common type has been found (or the collection was empty)
     */
    public static Class<?> findCommonElementType(Collection<?> collection) {
        if (isEmpty(collection)) {
            return null;
        }
        Class<?> candidate = null;
        for (Object val : collection) {
            if (val != null) {
                if (candidate == null) {
                    candidate = val.getClass();
                } else if (candidate != val.getClass()) {
                    return null;
                }
            }
        }
        return candidate;
    }
    
    /**
     * 根据条件获取集合中的数据
     * 
     * @param list 过滤数据集
     * @param conditions 条件，条件表达式格式为：'属性名：值'
     * @return 满足条件的一条数据
     */
    @Function(name = "select")
    public static Object select(List<Object> list, String... conditions) {
        if (list == null) {
            return null;
        }
        for (Object obj : list) {
            if (checkElement(obj, conditions)) {
                return obj;
            }
        }
        Object template = createElementTemplate(list);
        template = fillFields(template, conditions);
        if (template != null) {
            list.add(template);
        }
        return template;
    }
    
    /**
     * 根据条件获取集合中的数据
     * 
     * @param list 过滤数据集
     * @param className 元素类型
     * @param conditions 条件，条件表达式格式为：'属性名：值'
     * @return 满足条件的一条数据
     */
    @Function(name = "selectWithType")
    public static Object selectWithType(List<Object> list, String className, String... conditions) {
        if (list == null) {
            return null;
        }
        for (Object obj : list) {
            if (checkElement(obj, conditions)) {
                return obj;
            }
            
        }
        
        Object template;
        if (className == null) {
            template = createElementTemplate(list);
        } else {
            Class<?> elementType;
            try {
                elementType = Class.forName(className);
                template = ReflectionHelper.instance(elementType);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                template = null;
            }
        }
        template = fillFields(template, conditions);
        if (template != null) {
            list.add(template);
        }
        return template;
    }
    
    /**
     * 检查元素
     *
     * @param element 元素
     * @param conditions 条件
     * @return 是否满足条件
     */
    private static boolean checkElement(Object element, String... conditions) {
        if (conditions == null) {
            return true;
        }
        boolean check = true;
        for (String condition : conditions) {
            String fieldValue[] = condition.split(":");
            String name = fieldValue[0];
            int index = name.indexOf('.');
            if (index >= 0) {
                name = name.substring(index + 1);
            }
            String value = fieldValue[1];
            Object result;
            try {
                result = ReflectionHelper.getField(name, element);
            } catch (Exception e) {
            	e.printStackTrace();
                result = null;
            }
            String ret = result == null ? null : String.valueOf(result);
            check = check && ObjectUtils.nullSafeEquals(ret, value);
        }
        return check;
    }
    
    /**
     * 填充对象数据
     * 
     * @param obj 数据对象
     * @param fieldValues 条件表达式格式为：'属性名：值'
     * @return 填充完毕后的对象
     */
    public static Object fillFields(Object obj, String... fieldValues) {
        if (obj == null) {
            return null;
        }
        if (fieldValues == null) {
            return obj;
        }
        Field field;
        Class<?> objClass = obj.getClass();
        for (String fieldValue : fieldValues) {
            String parts[] = fieldValue.split(":");
            String filedName = parts[0];
            int index = filedName.lastIndexOf(".");
            if (index >= 0) {
                filedName = filedName.substring(index + 1);
            }
            String value = parts[1];
            try {
                field = ReflectionHelper.findField(objClass, filedName);
            } catch (Exception e) {
            	e.printStackTrace();
                field = null;
            }
            if (field != null) {
                Class<?> fieldType = field.getType();
                try {
                    ReflectionHelper.setField(field, obj, ConverterUtils.convert(value, fieldType));
                } catch (Exception e) {
                	e.printStackTrace();
                }
            }
        }
        return obj;
    }
    
    /**
     * 
     * 创建元素模板
     *
     * @param list 数据集
     * @return 返回模板对象
     */
    public static Object createElementTemplate(List<?> list) {
        if (list.isEmpty()) {
            return null;
        }
        Class<?> clazz = list.get(0).getClass();
        if (clazz != null) {
            return ReflectionHelper.instance(clazz);
        }
        return null;
    }
}
