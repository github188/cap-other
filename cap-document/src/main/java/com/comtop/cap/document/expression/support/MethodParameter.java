/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import static com.comtop.cap.document.util.Assert.notNull;

import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.util.HashMap;
import java.util.Map;

/**
 * 方法参数
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class MethodParameter {
    
    /** 方法 */
    private Method method;
    
    /** 构造器 */
    @SuppressWarnings("rawtypes")
    private Constructor constructor;
    
    /** 参数索引 */
    private final int parameterIndex;
    
    /** 参数类型 */
    private Class<?> parameterType;
    
    /** 参数注解 */
    private Annotation[] parameterAnnotations;
    
    /** 泛型化参数类型 */
    private Type genericParameterType;
    
    /** 关联层次 */
    private int nestingLevel = 1;
    
    /** Map from Integer level to Integer type index */
    private Map<Integer, Integer> typeIndexesPerLevel;
    
    /** 泛型参数 */
    Map<TypeVariable<?>, Type> typeVariableMap;
    
    /**
     * Create a new MethodParameter for the given method, with nesting level 1.
     * 
     * @param method the Method to specify a parameter for
     * @param parameterIndex the index of the parameter
     */
    public MethodParameter(Method method, int parameterIndex) {
        this(method, parameterIndex, 1);
    }
    
    /**
     * 构造函数
     * 
     * @param method 方法
     * @param parameterIndex 参数索引
     * @param nestingLevel 关联层次
     */
    public MethodParameter(Method method, int parameterIndex, int nestingLevel) {
        notNull(method, "Method must not be null");
        this.method = method;
        this.parameterIndex = parameterIndex;
        this.nestingLevel = nestingLevel;
    }
    
    /**
     * 构造函数
     * 
     * @param constructor 构造器
     * @param parameterIndex 参数索引
     */
    public MethodParameter(@SuppressWarnings("rawtypes") Constructor constructor, int parameterIndex) {
        this(constructor, parameterIndex, 1);
    }
    
    /**
     * 构造函数
     * 
     * @param constructor 构造器
     * @param parameterIndex 参数索引
     * @param nestingLevel 关联层次
     */
    public MethodParameter(@SuppressWarnings("rawtypes") Constructor constructor, int parameterIndex, int nestingLevel) {
        notNull(constructor, "Constructor must not be null");
        this.constructor = constructor;
        this.parameterIndex = parameterIndex;
        this.nestingLevel = nestingLevel;
    }
    
    /**
     * 构造函数
     * 
     * @param original 方法参数
     */
    public MethodParameter(MethodParameter original) {
        notNull(original, "Original must not be null");
        this.method = original.method;
        this.constructor = original.constructor;
        this.parameterIndex = original.parameterIndex;
        this.parameterType = original.parameterType;
        this.parameterAnnotations = original.parameterAnnotations;
        this.typeVariableMap = original.typeVariableMap;
    }
    
    /**
     * Return the wrapped Method, if any.
     * <p>
     * Note: Either Method or Constructor is available.
     * 
     * @return the Method, or <code>null</code> if none
     */
    public Method getMethod() {
        return this.method;
    }
    
    /**
     * Return the wrapped Constructor, if any.
     * <p>
     * Note: Either Method or Constructor is available.
     * 
     * @return the Constructor, or <code>null</code> if none
     */
    @SuppressWarnings("rawtypes")
    public Constructor getConstructor() {
        return this.constructor;
    }
    
    /**
     * @return Return the class that declares the underlying Method or Constructor.
     */
    @SuppressWarnings("rawtypes")
    public Class getDeclaringClass() {
        return (this.method != null ? this.method.getDeclaringClass() : this.constructor.getDeclaringClass());
    }
    
    /**
     * Return the index of the method/constructor parameter.
     * 
     * @return the parameter index (never negative)
     */
    public int getParameterIndex() {
        return this.parameterIndex;
    }
    
    /**
     * @param parameterType Set a resolved (generic) parameter type.
     */
    void setParameterType(Class<?> parameterType) {
        this.parameterType = parameterType;
    }
    
    /**
     * Return the type of the method/constructor parameter.
     * 
     * @return the parameter type (never <code>null</code>)
     */
    public Class<?> getParameterType() {
        if (this.parameterType == null) {
            if (this.parameterIndex < 0) {
                this.parameterType = (this.method != null ? this.method.getReturnType() : null);
            } else {
                this.parameterType = (this.method != null ? this.method.getParameterTypes()[this.parameterIndex]
                    : this.constructor.getParameterTypes()[this.parameterIndex]);
            }
        }
        return this.parameterType;
    }
    
    /**
     * Return the generic type of the method/constructor parameter.
     * 
     * @return the parameter type (never <code>null</code>)
     */
    public Type getGenericParameterType() {
        if (this.genericParameterType == null) {
            if (this.parameterIndex < 0) {
                this.genericParameterType = (this.method != null ? this.method.getGenericReturnType() : null);
            } else {
                this.genericParameterType = (this.method != null
                    ? this.method.getGenericParameterTypes()[this.parameterIndex] : this.constructor
                        .getGenericParameterTypes()[this.parameterIndex]);
            }
        }
        return this.genericParameterType;
    }
    
    /**
     * @return Return the annotations associated with the target method/constructor itself.
     */
    public Annotation[] getMethodAnnotations() {
        return (this.method != null ? this.method.getAnnotations() : this.constructor.getAnnotations());
    }
    
    /**
     * Increase this parameter's nesting level.
     * 
     * @see #getNestingLevel()
     */
    public void increaseNestingLevel() {
        this.nestingLevel++;
    }
    
    /**
     * Decrease this parameter's nesting level.
     * 
     * @see #getNestingLevel()
     */
    public void decreaseNestingLevel() {
        getTypeIndexesPerLevel().remove(this.nestingLevel);
        this.nestingLevel--;
    }
    
    /**
     * @return Return the nesting level of the target type
     *         (typically 1; e.g. in case of a List of Lists, 1 would indicate the
     *         nested List, whereas 2 would indicate the element of the nested List).
     * 
     */
    public int getNestingLevel() {
        return this.nestingLevel;
    }
    
    /**
     * Set the type index for the current nesting level.
     * 
     * @param typeIndex the corresponding type index
     *            (or <code>null</code> for the default type index)
     * @see #getNestingLevel()
     */
    public void setTypeIndexForCurrentLevel(int typeIndex) {
        getTypeIndexesPerLevel().put(this.nestingLevel, typeIndex);
    }
    
    /**
     * Return the type index for the current nesting level.
     * 
     * @return the corresponding type index, or <code>null</code> if none specified (indicating the default type index)
     * @see #getNestingLevel()
     */
    public Integer getTypeIndexForCurrentLevel() {
        return getTypeIndexForLevel(this.nestingLevel);
    }
    
    /**
     * Return the type index for the specified nesting level.
     * 
     * @param level the nesting level to check
     * @return the corresponding type index, or <code>null</code> if none specified (indicating the default type index)
     */
    public Integer getTypeIndexForLevel(int level) {
        return getTypeIndexesPerLevel().get(level);
    }
    
    /**
     * @return Obtain the (lazily constructed) type-indexes-per-level Map.
     */
    private Map<Integer, Integer> getTypeIndexesPerLevel() {
        if (this.typeIndexesPerLevel == null) {
            this.typeIndexesPerLevel = new HashMap<Integer, Integer>(4);
        }
        return this.typeIndexesPerLevel;
    }
    
    /**
     * 获取参数注解
     *
     * @return 参数注解
     */
    public Annotation[] getParameterAnnotations() {
        if (this.parameterAnnotations == null) {
            Annotation[][] annotationArray = (this.method != null ? this.method.getParameterAnnotations()
                : this.constructor.getParameterAnnotations());
            if (this.parameterIndex >= 0 && this.parameterIndex < annotationArray.length) {
                this.parameterAnnotations = annotationArray[this.parameterIndex];
            } else {
                this.parameterAnnotations = new Annotation[0];
            }
        }
        return this.parameterAnnotations;
    }
    
    /**
     * 获取泛型参数类型
     * @param <T> Annotation注解类型
     *
     * @param annotationType 泛型类型
     * @return 泛型参数类型
     */
    @SuppressWarnings("unchecked")
    public <T extends Annotation> T getParameterAnnotation(Class<T> annotationType) {
        Annotation[] anns = getParameterAnnotations();
        for (Annotation ann : anns) {
            if (annotationType.isInstance(ann)) {
                return (T) ann;
            }
        }
        return null;
    }
    
}
