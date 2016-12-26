/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.accessor;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.lang.reflect.Member;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.support.MethodParameter;
import com.comtop.cap.document.expression.support.PropertyTypeDescriptor;
import com.comtop.cap.document.expression.support.TypeDescriptor;
import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.util.ReflectionHelper;

/**
 * 属性反射访问器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class ReflectivePropertyAccessor implements PropertyAccessor {
	/** 日志 */
    protected static final Logger LOGGER = LoggerFactory.getLogger(ReflectivePropertyAccessor.class);
    
    /** 读取缓存 */
    protected final Map<CacheKey, InvokerPair> readerCache = new ConcurrentHashMap<CacheKey, InvokerPair>();
    
    /** 写入缓存 */
    protected final Map<CacheKey, Member> writerCache = new ConcurrentHashMap<CacheKey, Member>();
    
    /** 类型描述缓存 */
    protected final Map<CacheKey, TypeDescriptor> typeDescriptorCache = new ConcurrentHashMap<CacheKey, TypeDescriptor>();
    
    /**
     * 返回控制，表示一般的访问器
     * 
     * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#getSpecificTargetClasses()
     */
    @Override
    public Class<?>[] getSpecificTargetClasses() {
        return null;
    }
    
    /**
     * 是否可以读取数据
     *
     * @param context 执行上下文
     * @param name 属性名称
     * @param target 数据对象
     * @return 是否可以读取
     * @throws AccessException 属性访问异常
     * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#canRead(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    public boolean canRead(EvaluationContext context, Object target, String name) throws AccessException {
        if (target == null) {
            return false;
        }
        Class<?> type = (target instanceof Class ? (Class<?>) target : target.getClass());
        if (type.isArray() && name.equals("length")) {
            return true;
        }
        CacheKey cacheKey = new CacheKey(type, name);
        if (this.readerCache.containsKey(cacheKey)) {
            return true;
        }
        Method method = findGetterForProperty(name, type, target instanceof Class);
        if (method != null) {
            // Treat it like a property
            try {
                // The readerCache will only contain gettable properties (let's not worry about setters for now)
                PropertyDescriptor propertyDescriptor = new PropertyDescriptor(name, method, null);
                TypeDescriptor typeDescriptor = new PropertyTypeDescriptor(propertyDescriptor, new MethodParameter(
                    method, -1));
                this.readerCache.put(cacheKey, new InvokerPair(method, typeDescriptor));
                this.typeDescriptorCache.put(cacheKey, typeDescriptor);
                return true;
            } catch (IntrospectionException ex) {
                throw new AccessException("Unable to access property '" + name + "' through getter " + method, ex);
            }
        }
        Field field = findField(name, type, target instanceof Class);
        if (field != null) {
            TypeDescriptor typeDescriptor = new TypeDescriptor(field);
            this.readerCache.put(cacheKey, new InvokerPair(field, typeDescriptor));
            this.typeDescriptorCache.put(cacheKey, typeDescriptor);
            return true;
        }
        return false;
    }
    
    /**
     * 读取数据
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 属性名称
     * @return 返回带有类型描述的数据结果封装
     * @throws AccessException 属性访问异常
     * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#read(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    public TypedValue read(EvaluationContext context, Object target, String name) throws AccessException {
        if (target == null) {
            throw new AccessException("Cannot read property of null target");
        }
        Class<?> type = (target instanceof Class ? (Class<?>) target : target.getClass());
        
        if (type.isArray() && name.equals("length")) {
            if (target instanceof Class) {
                throw new AccessException("Cannot access length on array class itself");
            }
            return new TypedValue(Array.getLength(target), TypeDescriptor.valueOf(Integer.TYPE));
        }
        
        CacheKey cacheKey = new CacheKey(type, name);
        InvokerPair invoker = this.readerCache.get(cacheKey);
        
        if (invoker == null || invoker.member instanceof Method) {
            Method method = (Method) (invoker != null ? invoker.member : null);
            if (method == null) {
                method = findGetterForProperty(name, type, target instanceof Class);
                if (method != null) {
                    // TODO remove the duplication here between canRead and read
                    // Treat it like a property
                    try {
                        // The readerCache will only contain gettable properties (let's not worry about setters for now)
                        PropertyDescriptor propertyDescriptor = new PropertyDescriptor(name, method, null);
                        TypeDescriptor typeDescriptor = new PropertyTypeDescriptor(propertyDescriptor,
                            new MethodParameter(method, -1));
                        invoker = new InvokerPair(method, typeDescriptor);
                        this.readerCache.put(cacheKey, invoker);
                    } catch (IntrospectionException ex) {
                        throw new AccessException("Unable to access property '" + name + "' through getter " + method,
                            ex);
                    }
                }
            }
            if (method != null && invoker != null) {
                try {
                    ReflectionHelper.makeAccessible(method);
                    return new TypedValue(method.invoke(target), invoker.typeDescriptor);
                } catch (Exception ex) {
                    throw new AccessException("Unable to access property '" + name + "' through getter", ex);
                }
            }
        }
        
        if (invoker == null || invoker.member instanceof Field) {
            Field field = (Field) (invoker == null ? null : invoker.member);
            if (field == null) {
                field = findField(name, type, target instanceof Class);
                if (field != null) {
                    invoker = new InvokerPair(field, new TypeDescriptor(field));
                    this.readerCache.put(cacheKey, invoker);
                }
            }
            if (field != null && invoker != null) {
                try {
                    ReflectionHelper.makeAccessible(field);
                    return new TypedValue(field.get(target), invoker.typeDescriptor);
                } catch (Exception ex) {
                    throw new AccessException("Unable to access field: " + name, ex);
                }
            }
        }
        
        throw new AccessException("Neither getter nor field found for property '" + name + "'");
    }
    
    /**
     * 是否可以写入数据
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 属性名称
     * @return 是否可以写入数据
     * @throws AccessException 属性访问异常
     * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#canWrite(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object, java.lang.String)
     */
    @Override
    public boolean canWrite(EvaluationContext context, Object target, String name) throws AccessException {
        if (target == null) {
            return false;
        }
        Class<?> type = (target instanceof Class ? (Class<?>) target : target.getClass());
        CacheKey cacheKey = new CacheKey(type, name);
        if (this.writerCache.containsKey(cacheKey)) {
            return true;
        }
        Method method = findSetterForProperty(name, type, target instanceof Class);
        if (method != null) {
            // Treat it like a property
            PropertyDescriptor propertyDescriptor = null;
            try {
                propertyDescriptor = new PropertyDescriptor(name, null, method);
            } catch (IntrospectionException ex) {
                throw new AccessException("Unable to access property '" + name + "' through setter " + method, ex);
            }
            MethodParameter mp = new MethodParameter(method, 0);
            TypeDescriptor typeDescriptor = new PropertyTypeDescriptor(propertyDescriptor, mp);
            this.writerCache.put(cacheKey, method);
            this.typeDescriptorCache.put(cacheKey, typeDescriptor);
            return true;
        }
        Field field = findField(name, type, target instanceof Class);
        if (field != null) {
            this.writerCache.put(cacheKey, field);
            this.typeDescriptorCache.put(cacheKey, new TypeDescriptor(field));
            return true;
        }
        return false;
    }
    
    /**
     * 写入数据
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 属性名称
     * @param value 属性值
     * @throws AccessException 属性访问异常
     * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#write(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object, java.lang.String, java.lang.Object)
     */
    @Override
    public void write(EvaluationContext context, Object target, String name, Object value) throws AccessException {
        if (target == null) {
            throw new AccessException("Cannot write property on null target");
        }
        Class<?> type = (target instanceof Class ? (Class<?>) target : target.getClass());
        
        Object possiblyConvertedNewValue = value;
        TypeDescriptor typeDescriptor = getTypeDescriptor(context, target, name);
        if (typeDescriptor != null) {
            try {
                possiblyConvertedNewValue = context.getTypeConverter().convert(value, TypeDescriptor.forObject(value),
                    typeDescriptor);
            } catch (EvaluationException evaluationException) {
                throw new AccessException("Type conversion failure", evaluationException);
            }
        }
        CacheKey cacheKey = new CacheKey(type, name);
        Member cachedMember = this.writerCache.get(cacheKey);
        
        if (cachedMember == null || cachedMember instanceof Method) {
            Method method = (Method) cachedMember;
            if (method == null) {
                method = findSetterForProperty(name, type, target instanceof Class);
                if (method != null) {
                    cachedMember = method;
                    this.writerCache.put(cacheKey, cachedMember);
                }
            }
            if (method != null) {
                try {
                    ReflectionHelper.makeAccessible(method);
                    method.invoke(target, possiblyConvertedNewValue);
                    return;
                } catch (Exception ex) {
                    throw new AccessException("Unable to access property '" + name + "' through setter", ex);
                }
            }
        }
        
        if (cachedMember == null || cachedMember instanceof Field) {
            Field field = (Field) cachedMember;
            if (field == null) {
                field = findField(name, type, target instanceof Class);
                if (field != null) {
                    cachedMember = field;
                    this.writerCache.put(cacheKey, cachedMember);
                }
            }
            if (field != null) {
                try {
                    ReflectionHelper.makeAccessible(field);
                    field.set(target, possiblyConvertedNewValue);
                    return;
                } catch (Exception ex) {
                    throw new AccessException("Unable to access field: " + name, ex);
                }
            }
        }
        
        throw new AccessException("Neither setter nor field found for property '" + name + "'");
    }
    
    /**
     * 获取类型描述
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 属性名称
     * @return 属性类型描述
     */
    private TypeDescriptor getTypeDescriptor(EvaluationContext context, Object target, String name) {
        if (target == null) {
            return null;
        }
        Class<?> type = (target instanceof Class ? (Class<?>) target : target.getClass());
        
        if (type.isArray() && name.equals("length")) {
            return TypeDescriptor.valueOf(Integer.TYPE);
        }
        CacheKey cacheKey = new CacheKey(type, name);
        TypeDescriptor typeDescriptor = this.typeDescriptorCache.get(cacheKey);
        if (typeDescriptor == null) {
            // attempt to populate the cache entry
            try {
                if (canRead(context, target, name)) {
                    typeDescriptor = this.typeDescriptorCache.get(cacheKey);
                } else if (canWrite(context, target, name)) {
                    typeDescriptor = this.typeDescriptorCache.get(cacheKey);
                }
            } catch (AccessException ex) {
            	LOGGER.debug("获取类型描述出错.", ex);
            }
        }
        return typeDescriptor;
    }
    
    /**
     * 获取Getter方法
     *
     * @param propertyName 属性名称
     * @param clazz 类
     * @param mustBeStatic 是否必须为静态
     * @return Getter方法
     */
    protected Method findGetterForProperty(String propertyName, Class<?> clazz, boolean mustBeStatic) {
        Method[] ms = clazz.getMethods();
        // Try "get*" method...
        String getterName = "get" + StringUtils.capitalize(propertyName);
        for (Method method : ms) {
            if (method.getName().equals(getterName) && method.getParameterTypes().length == 0
                && (!mustBeStatic || Modifier.isStatic(method.getModifiers()))) {
                return method;
            }
        }
        // Try "is*" method...
        getterName = "is" + StringUtils.capitalize(propertyName);
        for (Method method : ms) {
            if (method.getName().equals(getterName) && method.getParameterTypes().length == 0
                && boolean.class.equals(method.getReturnType())
                && (!mustBeStatic || Modifier.isStatic(method.getModifiers()))) {
                return method;
            }
        }
        return null;
    }
    
    /**
     * 
     * 获取Setter方法
     *
     * @param propertyName 属性名称
     * @param clazz 类
     * @param mustBeStatic 是否必须为静态
     * @return Setter方法
     */
    protected Method findSetterForProperty(String propertyName, Class<?> clazz, boolean mustBeStatic) {
        Method[] methods = clazz.getMethods();
        String setterName = "set" + StringUtils.capitalize(propertyName);
        for (Method method : methods) {
            if (method.getName().equals(setterName) && method.getParameterTypes().length == 1
                && (!mustBeStatic || Modifier.isStatic(method.getModifiers()))) {
                return method;
            }
        }
        return null;
    }
    
    /**
     * 查找字段
     *
     * @param name 名称
     * @param clazz 类型
     * @param mustBeStatic 是否必须为静态
     * @return 字段
     */
    protected Field findField(String name, Class<?> clazz, boolean mustBeStatic) {
        Field[] fields = clazz.getFields();
        for (Field field : fields) {
            if (field.getName().equals(name) && (!mustBeStatic || Modifier.isStatic(field.getModifiers()))) {
                return field;
            }
        }
        return null;
    }
    
    /**
     * 执行器对
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年11月10日 lizhongwen
     */
    private static class InvokerPair {
        
        /** 成员 */
        final Member member;
        
        /** 类型描述 */
        final TypeDescriptor typeDescriptor;
        
        /**
         * 构造函数
         * 
         * @param member 成员
         * @param typeDescriptor 类型描述
         */
        public InvokerPair(Member member, TypeDescriptor typeDescriptor) {
            this.member = member;
            this.typeDescriptor = typeDescriptor;
        }
        
    }
    
    /**
     * 缓存键
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年11月10日 lizhongwen
     */
    private static class CacheKey {
        
        /** 类型 */
        private final Class<?> clazz;
        
        /** 名称 */
        private final String name;
        
        /**
         * 构造函数
         * 
         * @param clazz 类型
         * @param name 名称
         */
        public CacheKey(Class<?> clazz, String name) {
            this.clazz = clazz;
            this.name = name;
        }
        
        @Override
        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof CacheKey)) {
                return false;
            }
            CacheKey otherKey = (CacheKey) other;
            return (this.clazz.equals(otherKey.clazz) && this.name.equals(otherKey.name));
        }
        
        @Override
        public int hashCode() {
            return this.clazz.hashCode() * 29 + this.name.hashCode();
        }
    }
    
    /**
     * 创建最佳访问器
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 属性名称
     * @return 最佳访问器
     */
    public PropertyAccessor createOptimalAccessor(EvaluationContext context, Object target, String name) {
        // Don't be clever for arrays or null target
        if (target == null) {
            return this;
        }
        Class<?> type = (target instanceof Class ? (Class<?>) target : target.getClass());
        if (type.isArray()) {
            return this;
        }
        
        CacheKey cacheKey = new CacheKey(type, name);
        InvokerPair invocationTarget = this.readerCache.get(cacheKey);
        
        if (invocationTarget == null || invocationTarget.member instanceof Method) {
            Method method = (Method) (invocationTarget == null ? null : invocationTarget.member);
            if (method == null) {
                method = findGetterForProperty(name, type, target instanceof Class);
                if (method != null) {
                    invocationTarget = new InvokerPair(method, new TypeDescriptor(new MethodParameter(method, -1)));
                    ReflectionHelper.makeAccessible(method);
                    this.readerCache.put(cacheKey, invocationTarget);
                }
            }
            if (method != null) {
                return new OptimalPropertyAccessor(invocationTarget);
            }
        }
        
        if (invocationTarget == null || invocationTarget.member instanceof Field) {
            Field field = (Field) (invocationTarget == null ? null : invocationTarget.member);
            if (field == null) {
                field = findField(name, type, target instanceof Class);
                if (field != null) {
                    invocationTarget = new InvokerPair(field, new TypeDescriptor(field));
                    ReflectionHelper.makeAccessible(field);
                    this.readerCache.put(cacheKey, invocationTarget);
                }
            }
            if (field != null) {
                return new OptimalPropertyAccessor(invocationTarget);
            }
        }
        return this;
    }
    
    /**
     * 最佳属性访问器
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年11月12日 lizhongwen
     */
    static class OptimalPropertyAccessor implements PropertyAccessor {
        
        /** 成员 */
        private final Member member;
        
        /** 类型描述 */
        private final TypeDescriptor typeDescriptor;
        
        /** 是否使其可访问 */
        private final boolean needsToBeMadeAccessible;
        
        /**
         * 构造函数
         * 
         * @param target 执行对
         */
        OptimalPropertyAccessor(InvokerPair target) {
            this.member = target.member;
            this.typeDescriptor = target.typeDescriptor;
            if (this.member instanceof Field) {
                Field field = (Field) member;
                needsToBeMadeAccessible = (!Modifier.isPublic(field.getModifiers()) || !Modifier.isPublic(field
                    .getDeclaringClass().getModifiers())) && !field.isAccessible();
            } else {
                Method method = (Method) member;
                needsToBeMadeAccessible = ((!Modifier.isPublic(method.getModifiers()) || !Modifier.isPublic(method
                    .getDeclaringClass().getModifiers())) && !method.isAccessible());
            }
        }
        
        /**
         * 特殊类型
         * 
         * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#getSpecificTargetClasses()
         */
        @Override
        public Class<?>[] getSpecificTargetClasses() {
            throw new UnsupportedOperationException("Should not be called on an OptimalPropertyAccessor");
        }
        
        /**
         * 是否可以读取数据
         *
         * @param context 执行上下文
         * @param name 属性名称
         * @param target 数据对象
         * @return 是否可以读取
         * @throws AccessException 属性访问异常
         * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#canRead(com.comtop.cap.document.expression.EvaluationContext,
         *      java.lang.Object, java.lang.String)
         */
        @Override
        public boolean canRead(EvaluationContext context, Object target, String name) throws AccessException {
            if (target == null) {
                return false;
            }
            Class<?> type = (target instanceof Class ? (Class<?>) target : target.getClass());
            if (type.isArray()) {
                return false;
            }
            if (member instanceof Method) {
                Method method = (Method) member;
                String getterName = "get" + StringUtils.capitalize(name);
                if (getterName.equals(method.getName())) {
                    return true;
                }
                getterName = "is" + StringUtils.capitalize(name);
                return getterName.equals(method.getName());
            }
            Field field = (Field) member;
            return field.getName().equals(name);
        }
        
        /**
         * 读取数据
         *
         * @param context 执行上下文
         * @param target 目标对象
         * @param name 属性名称
         * @return 返回带有类型描述的数据结果封装
         * @throws AccessException 属性访问异常
         * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#read(com.comtop.cap.document.expression.EvaluationContext,
         *      java.lang.Object, java.lang.String)
         */
        @Override
        public TypedValue read(EvaluationContext context, Object target, String name) throws AccessException {
            if (member instanceof Method) {
                try {
                    if (needsToBeMadeAccessible) {
                        ReflectionHelper.makeAccessible((Method) member);
                    }
                    return new TypedValue(((Method) member).invoke(target), typeDescriptor);
                } catch (Exception ex) {
                    throw new AccessException("Unable to access property '" + name + "' through getter", ex);
                }
            }
            if (member instanceof Field) {
                try {
                    if (needsToBeMadeAccessible) {
                        ReflectionHelper.makeAccessible((Field) member);
                    }
                    return new TypedValue(((Field) member).get(target), typeDescriptor);
                } catch (Exception ex) {
                    throw new AccessException("Unable to access field: " + name, ex);
                }
            }
            throw new AccessException("Neither getter nor field found for property '" + name + "'");
        }
        
        /**
         * 是否可以写入数据
         *
         * @param context 执行上下文
         * @param target 目标对象
         * @param name 属性名称
         * @return 是否可以写入数据
         * @throws AccessException 属性访问异常
         * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#canWrite(com.comtop.cap.document.expression.EvaluationContext,
         *      java.lang.Object, java.lang.String)
         */
        @Override
        public boolean canWrite(EvaluationContext context, Object target, String name) throws AccessException {
            throw new UnsupportedOperationException("Should not be called on an OptimalPropertyAccessor");
        }
        
        /**
         * 写入数据
         *
         * @param context 执行上下文
         * @param target 目标对象
         * @param name 属性名称
         * @param value 属性值
         * @throws AccessException 属性访问异常
         * @see com.comtop.cap.document.expression.accessor.PropertyAccessor#write(com.comtop.cap.document.expression.EvaluationContext,
         *      java.lang.Object, java.lang.String, java.lang.Object)
         */
        @Override
        public void write(EvaluationContext context, Object target, String name, Object value) throws AccessException {
            throw new UnsupportedOperationException("Should not be called on an OptimalPropertyAccessor");
        }
    }
    
}
