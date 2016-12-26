/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.util;

import static com.comtop.cap.document.util.Assert.isTrue;
import static com.comtop.cap.document.util.Assert.notNull;

import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.text.MessageFormat;
import java.util.Collection;

import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.converter.ITypeConverter;
import com.comtop.cap.document.expression.support.MethodParameter;
import com.comtop.cap.document.expression.support.TypeDescriptor;

/**
 * 反射工具类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class ReflectionHelper {
    
    /**
     * 设置方法可以访问
     *
     * @param method 方法
     */
    public static void makeAccessible(Method method) {
        if ((!Modifier.isPublic(method.getModifiers()) || !Modifier.isPublic(method.getDeclaringClass().getModifiers()))
            && !method.isAccessible()) {
            method.setAccessible(true);
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
     * 设置字段的值
     *
     * @param name 字段名称
     * @param target 目标对象
     * @param value 值
     */
    public static void setField(String name, Object target, Object value) {
        notNull(target, "Class must not be null");
        notNull(name, "name must not be null");
        Field field = findField(target.getClass(), name);
        setField(field, target, value);
    }
    
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
            handleReflectionException(ex);
            throw new IllegalStateException("Unexpected reflection exception - " + ex.getClass().getName() + ": "
                + ex.getMessage());
        }
    }
    
    /**
     * 获取字段的值
     *
     * @param name 字段名称
     * @param target 目标对象
     * @return 值
     */
    public static Object getField(String name, Object target) {
        notNull(target, "Class must not be null");
        notNull(name, "name must not be null");
        Field field = findField(target.getClass(), name);
        return getField(field, target);
    }
    
    /**
     * 获取字段的值
     *
     * @param field 字段
     * @param target 目标对象
     * @return 值
     */
    public static Object getField(Field field, Object target) {
        try {
            makeAccessible(field);
            return field.get(target);
        } catch (IllegalAccessException ex) {
            handleReflectionException(ex);
            throw new IllegalStateException("Unexpected reflection exception - " + ex.getClass().getName() + ": "
                + ex.getMessage());
        }
    }
    
    /**
     * 根据字段名称查找字段
     *
     * @param clazz 类
     * @param name 字段名称
     * @return 字段
     */
    public static Field findField(Class<?> clazz, String name) {
        return findField(clazz, name, null);
    }
    
    /**
     * 根据字段名称以及类型查找字段
     *
     * @param clazz 类
     * @param name 字段名称
     * @param type 字段类型
     * @return 字段
     */
    public static Field findField(Class<?> clazz, String name, Class<?> type) {
        notNull(clazz, "Class must not be null");
        isTrue(name != null || type != null, "Either name or type of the field must be specified");
        Class<?> searchType = clazz;
        while (!Object.class.equals(searchType) && searchType != null) {
            Field[] fields = searchType.getDeclaredFields();
            for (Field field : fields) {
                if ((name == null || name.equals(field.getName())) && (type == null || type.equals(field.getType()))) {
                    return field;
                }
            }
            searchType = searchType.getSuperclass();
        }
        return null;
    }
    
    /**
     * 实例化对象
     *
     * @param clazz 对象类型
     * @return 对象实例
     */
    public static Object instance(Class<?> clazz) {
        notNull(clazz, "Class must not be null");
        try {
            return clazz.newInstance();
        } catch (Exception e) {
            throw new IllegalStateException("Could not new instance for ' " + clazz.getSimpleName() + "',casue: "
                + e.getMessage(), e);
        }
    }
    
    /**
     * 转换所有参数的类型
     *
     * @param converter 转换器
     * @param arguments 函数参数
     * @param method 方法
     */
    public static void convertAllArguments(ITypeConverter converter, Object[] arguments, Method method) {
        Integer varargsPosition = null;
        if (method.isVarArgs()) {
            Class<?>[] paramTypes = method.getParameterTypes();
            varargsPosition = paramTypes.length - 1;
        }
        for (int argPosition = 0; argPosition < arguments.length; argPosition++) {
            TypeDescriptor targetType;
            if (varargsPosition != null && argPosition >= varargsPosition) {
                MethodParameter methodParam = new MethodParameter(method, varargsPosition);
                targetType = new TypeDescriptor(methodParam, methodParam.getParameterType().getComponentType());
            } else {
                targetType = new TypeDescriptor(new MethodParameter(method, argPosition));
            }
            Object argument = arguments[argPosition];
            if (argument != null && !targetType.getObjectType().isInstance(argument)) {
                if (converter == null) {
                    throw new EvaluationException(MessageFormat.format("无法将类型''{0}''转换为''{1}''!", argument.getClass()
                        .getName(), targetType));
                }
                arguments[argPosition] = converter.convert(argument, TypeDescriptor.forObject(argument), targetType);
            }
        }
        
    }
    
    /**
     * 设置所有参数
     *
     * @param requiredParameterTypes 需要的参数的类型集合
     * @param args 参数值
     * @return 设置参数
     */
    public static Object[] setupArgumentsForVarargsInvocation(Class<?>[] requiredParameterTypes, Object... args) {
        // Check if array already built for final argument
        int parameterCount = requiredParameterTypes.length;
        int argumentCount = args.length;
        
        // Check if repackaging is needed:
        if (parameterCount != args.length
            || requiredParameterTypes[parameterCount - 1] != (args[argumentCount - 1] == null ? null
                : args[argumentCount - 1].getClass())) {
            int arraySize = 0; // zero size array if nothing to pass as the varargs parameter
            if (argumentCount >= parameterCount) {
                arraySize = argumentCount - (parameterCount - 1);
            }
            Object[] repackagedArguments = (Object[]) Array.newInstance(
                requiredParameterTypes[parameterCount - 1].getComponentType(), arraySize);
            // Copy all but the varargs arguments
            for (int i = 0; i < arraySize; i++) {
                repackagedArguments[i] = args[parameterCount + i - 1];
            }
            // Create an array for the varargs arguments
            Object[] newArgs = new Object[parameterCount];
            for (int i = 0; i < newArgs.length - 1; i++) {
                newArgs[i] = args[i];
            }
            newArgs[newArgs.length - 1] = repackagedArguments;
            return newArgs;
        }
        return args;
    }
    
    /**
     * 处理反射异常
     *
     * @param ex 异常
     */
    public static void handleReflectionException(Exception ex) {
        if (ex instanceof NoSuchMethodException) {
            throw new IllegalStateException("Method not found: " + ex.getMessage());
        }
        if (ex instanceof IllegalAccessException) {
            throw new IllegalStateException("Could not access method: " + ex.getMessage());
        }
        if (ex instanceof InvocationTargetException) {
            rethrowRuntimeException(ex);
        }
        if (ex instanceof RuntimeException) {
            throw (RuntimeException) ex;
        }
        handleUnexpectedException(ex);
    }
    
    /**
     *
     * @param ex 重新抛出运行时异常
     */
    public static void rethrowRuntimeException(Throwable ex) {
        if (ex instanceof RuntimeException) {
            throw (RuntimeException) ex;
        }
        if (ex instanceof Error) {
            throw (Error) ex;
        }
        handleUnexpectedException(ex);
    }
    
    /**
     * @param ex 处理无法预期的异常
     */
    private static void handleUnexpectedException(Throwable ex) {
        throw new IllegalStateException("Unexpected exception thrown", ex);
    }
    
    /**
     * 获得字段集合元素的类型
     *
     * @param field 字段
     * @return class
     */
    public static Class<?> getCollectionElementType(Field field) {
        Class<?> fieldType = field.getType();
        if (!Collection.class.isAssignableFrom(fieldType)) {
            return fieldType;
        }
        Type fc = field.getGenericType(); // 关键的地方，如果是List类型，得到其Generic的类型
        if (fc == null) {
            return null;
        }
        if (fc instanceof ParameterizedType) // 【3】如果是泛型参数的类型
        {
            ParameterizedType pt = (ParameterizedType) fc;
            
            Class<?> genericClazz = (Class<?>) pt.getActualTypeArguments()[0]; // 【4】 得到泛型里的class类型对象。
            
            return genericClazz;
        }
        return null;
    }
}
