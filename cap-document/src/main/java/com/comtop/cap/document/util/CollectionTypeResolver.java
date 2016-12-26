/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.util;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.WildcardType;
import java.util.Collection;
import java.util.Map;

import com.comtop.cap.document.expression.support.MethodParameter;

/**
 * 泛型化集合参数解析
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class CollectionTypeResolver {
    
    /**
     * Determine the generic element type of the given Collection class
     * (if it declares one through a generic superclass or generic interface).
     * 
     * @param collectionClass the collection class to introspect
     * @return the generic type, or <code>null</code> if none
     */
    public static Class<?> getCollectionType(@SuppressWarnings("rawtypes") Class<? extends Collection> collectionClass) {
        return extractTypeFromClass(collectionClass, Collection.class, 0);
    }
    
    /**
     * 获取集合字段类型
     *
     * @param collectionField 集合字段
     * @return 类型
     */
    public static Class<?> getCollectionFieldType(Field collectionField) {
        return getGenericFieldType(collectionField, Collection.class, 0, 1);
    }
    
    /**
     * Determine the generic element type of the given Collection field.
     * 
     * @param collectionField the collection field to introspect
     * @param nestingLevel the nesting level of the target type
     *            (typically 1; e.g. in case of a List of Lists, 1 would indicate the
     *            nested List, whereas 2 would indicate the element of the nested List)
     * @return the generic type, or <code>null</code> if none
     */
    public static Class<?> getCollectionFieldType(Field collectionField, int nestingLevel) {
        return getGenericFieldType(collectionField, Collection.class, 0, nestingLevel);
    }
    
    /**
     * Determine the generic key type of the given Map class
     * (if it declares one through a generic superclass or generic interface).
     * 
     * @param mapClass the map class to introspect
     * @return the generic type, or <code>null</code> if none
     */
    public static Class<?> getMapKeyType(@SuppressWarnings("rawtypes") Class<? extends Map> mapClass) {
        return extractTypeFromClass(mapClass, Map.class, 0);
    }
    
    /**
     * Determine the generic value type of the given Map class
     * (if it declares one through a generic superclass or generic interface).
     * 
     * @param mapClass the map class to introspect
     * @return the generic type, or <code>null</code> if none
     */
    public static Class<?> getMapValueType(@SuppressWarnings("rawtypes") Class<? extends Map> mapClass) {
        return extractTypeFromClass(mapClass, Map.class, 1);
    }
    
    /**
     * Determine the generic key type of the given Map field.
     * 
     * @param mapField the map field to introspect
     * @return the generic type, or <code>null</code> if none
     */
    public static Class<?> getMapKeyFieldType(Field mapField) {
        return getGenericFieldType(mapField, Map.class, 0, 1);
    }
    
    /**
     * Determine the generic key type of the given Map field.
     * 
     * @param mapField the map field to introspect
     * @param nestingLevel the nesting level of the target type
     *            (typically 1; e.g. in case of a List of Lists, 1 would indicate the
     *            nested List, whereas 2 would indicate the element of the nested List)
     * @return the generic type, or <code>null</code> if none
     */
    public static Class<?> getMapKeyFieldType(Field mapField, int nestingLevel) {
        return getGenericFieldType(mapField, Map.class, 0, nestingLevel);
    }
    
    /**
     * Determine the generic value type of the given Map field.
     * 
     * @param mapField the map field to introspect
     * @return the generic type, or <code>null</code> if none
     */
    public static Class<?> getMapValueFieldType(Field mapField) {
        return getGenericFieldType(mapField, Map.class, 1, 1);
    }
    
    /**
     * Determine the generic value type of the given Map field.
     * 
     * @param mapField the map field to introspect
     * @param nestingLevel the nesting level of the target type
     *            (typically 1; e.g. in case of a List of Lists, 1 would indicate the
     *            nested List, whereas 2 would indicate the element of the nested List)
     * @return the generic type, or <code>null</code> if none
     */
    public static Class<?> getMapValueFieldType(Field mapField, int nestingLevel) {
        return getGenericFieldType(mapField, Map.class, 1, nestingLevel);
    }
    
    /**
     * Extract the generic type from the given Class object.
     * 
     * @param clazz the Class to check
     * @param source the expected raw source type (can be <code>null</code>)
     * @param typeIndex the index of the actual type argument
     * @return the generic type as Class, or <code>null</code> if none
     */
    private static Class<?> extractTypeFromClass(Class<?> clazz, Class<?> source, int typeIndex) {
        return extractTypeFromClass(null, clazz, source, typeIndex, 1, 1);
    }
    
    /**
     * 获取泛型字段参数类型
     *
     * @param field 字段
     * @param source 源类型
     * @param typeIndex 参数索引
     * @param nestingLevel 关联层次
     * @return 类型
     */
    private static Class<?> getGenericFieldType(Field field, Class<?> source, int typeIndex, int nestingLevel) {
        return extractType(null, field.getGenericType(), source, typeIndex, nestingLevel, 1);
    }
    
    /**
     * Extract the generic type from the given Type object.
     * 
     * @param methodParam the method parameter specification
     * @param type the Type to check
     * @param source the source collection/map Class that we check
     * @param typeIndex the index of the actual type argument
     * @param nestingLevel the nesting level of the target type
     * @param currentLevel the current nested level
     * @return the generic type as Class, or <code>null</code> if none
     */
    @SuppressWarnings("rawtypes")
    private static Class<?> extractType(MethodParameter methodParam, Type type, Class<?> source, int typeIndex,
        int nestingLevel, int currentLevel) {
        
        Type resolvedType = type;
        if (resolvedType instanceof ParameterizedType) {
            return extractTypeFromParameterizedType(methodParam, (ParameterizedType) resolvedType, source, typeIndex,
                nestingLevel, currentLevel);
        } else if (resolvedType instanceof Class) {
            return extractTypeFromClass(methodParam, (Class) resolvedType, source, typeIndex, nestingLevel,
                currentLevel);
        } else {
            return null;
        }
    }
    
    /**
     * Extract the generic type from the given ParameterizedType object.
     * 
     * @param methodParam the method parameter specification
     * @param ptype the ParameterizedType to check
     * @param source the expected raw source type (can be <code>null</code>)
     * @param typeIndex the index of the actual type argument
     * @param nestingLevel the nesting level of the target type
     * @param currentLevel the current nested level
     * @return the generic type as Class, or <code>null</code> if none
     */
    @SuppressWarnings("rawtypes")
    private static Class<?> extractTypeFromParameterizedType(MethodParameter methodParam, ParameterizedType ptype,
        Class<?> source, int typeIndex, int nestingLevel, int currentLevel) {
        
        if (!(ptype.getRawType() instanceof Class)) {
            return null;
        }
        Class rawType = (Class) ptype.getRawType();
        Type[] paramTypes = ptype.getActualTypeArguments();
        if (nestingLevel - currentLevel > 0) {
            int nextLevel = currentLevel + 1;
            Integer currentTypeIndex = (methodParam != null ? methodParam.getTypeIndexForLevel(nextLevel) : null);
            // Default is last parameter type: Collection element or Map value.
            int indexToUse = (currentTypeIndex != null ? currentTypeIndex : paramTypes.length - 1);
            Type paramType = paramTypes[indexToUse];
            return extractType(methodParam, paramType, source, typeIndex, nestingLevel, nextLevel);
        }
        if (source != null && !source.isAssignableFrom(rawType)) {
            return null;
        }
        Class fromSuperclassOrInterface = extractTypeFromClass(methodParam, rawType, source, typeIndex, nestingLevel,
            currentLevel);
        if (fromSuperclassOrInterface != null) {
            return fromSuperclassOrInterface;
        }
        if (paramTypes == null || typeIndex >= paramTypes.length) {
            return null;
        }
        Type paramType = paramTypes[typeIndex];
        if (paramType instanceof WildcardType) {
            WildcardType wildcardType = (WildcardType) paramType;
            Type[] upperBounds = wildcardType.getUpperBounds();
            if (upperBounds != null && upperBounds.length > 0 && !Object.class.equals(upperBounds[0])) {
                paramType = upperBounds[0];
            } else {
                Type[] lowerBounds = wildcardType.getLowerBounds();
                if (lowerBounds != null && lowerBounds.length > 0 && !Object.class.equals(lowerBounds[0])) {
                    paramType = lowerBounds[0];
                }
            }
        }
        if (paramType instanceof ParameterizedType) {
            paramType = ((ParameterizedType) paramType).getRawType();
        }
        if (paramType instanceof GenericArrayType) {
            // A generic array type... Let's turn it into a straight array type if possible.
            Type compType = ((GenericArrayType) paramType).getGenericComponentType();
            if (compType instanceof Class) {
                return Array.newInstance((Class) compType, 0).getClass();
            }
        } else if (paramType instanceof Class) {
            // We finally got a straight Class...
            return (Class) paramType;
        }
        return null;
    }
    
    /**
     * Extract the generic type from the given Class object.
     * 
     * @param methodParam the method parameter specification
     * @param clazz the Class to check
     * @param source the expected raw source type (can be <code>null</code>)
     * @param typeIndex the index of the actual type argument
     * @param nestingLevel the nesting level of the target type
     * @param currentLevel the current nested level
     * @return the generic type as Class, or <code>null</code> if none
     */
    @SuppressWarnings("rawtypes")
    private static Class<?> extractTypeFromClass(MethodParameter methodParam, Class<?> clazz, Class<?> source,
        int typeIndex, int nestingLevel, int currentLevel) {
        
        if (clazz.getName().startsWith("java.util.")) {
            return null;
        }
        if (clazz.getSuperclass() != null && isIntrospectionCandidate(clazz.getSuperclass())) {
            return extractType(methodParam, clazz.getGenericSuperclass(), source, typeIndex, nestingLevel, currentLevel);
        }
        Type[] ifcs = clazz.getGenericInterfaces();
        if (ifcs != null) {
            for (Type ifc : ifcs) {
                Type rawType = ifc;
                if (ifc instanceof ParameterizedType) {
                    rawType = ((ParameterizedType) ifc).getRawType();
                }
                if (rawType instanceof Class && isIntrospectionCandidate((Class) rawType)) {
                    return extractType(methodParam, ifc, source, typeIndex, nestingLevel, currentLevel);
                }
            }
        }
        return null;
    }
    
    /**
     * Determine whether the given class is a potential candidate
     * that defines generic collection or map types.
     * 
     * @param clazz the class to check
     * @return whether the given class is assignable to Collection or Map
     */
    private static boolean isIntrospectionCandidate(@SuppressWarnings("rawtypes") Class clazz) {
        return (Collection.class.isAssignableFrom(clazz) || Map.class.isAssignableFrom(clazz));
    }
    
    /**
     * 获取 方法参数Map集合Key类型
     *
     * @param methodParameter 方法参数
     * @return Map集合Key类型
     */
    public static Class<?> getMapKeyParameterType(MethodParameter methodParameter) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        return null;
    }
    
    /**
     * 获取 方法参数Map集合Value类型
     *
     * @param methodParameter 方法参数
     * @return Map集合Value类型
     */
    public static Class<?> getMapValueParameterType(MethodParameter methodParameter) {
        // TODO 自动生成方法存根注释，方法实现时请删除此注释
        return null;
    }
    
}
