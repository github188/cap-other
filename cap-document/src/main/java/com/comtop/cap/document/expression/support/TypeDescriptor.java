/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import static com.comtop.cap.document.util.Assert.notNull;
import static com.comtop.cap.document.util.ClassUtils.getQualifiedName;
import static com.comtop.cap.document.util.ClassUtils.resolvePrimitiveIfNecessary;
import static com.comtop.cap.document.util.CollectionTypeResolver.getCollectionFieldType;
import static com.comtop.cap.document.util.CollectionTypeResolver.getCollectionType;
import static com.comtop.cap.document.util.CollectionTypeResolver.getMapKeyFieldType;
import static com.comtop.cap.document.util.CollectionTypeResolver.getMapValueFieldType;
import static com.comtop.cap.document.util.CollectionUtils.findCommonElementType;
import static com.comtop.cap.document.util.ObjectUtils.nullSafeEquals;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import com.comtop.cap.document.util.CollectionTypeResolver;

/**
 * 类型描述
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class TypeDescriptor {
    
    /** 空类型 */
    public static final TypeDescriptor NULL = new TypeDescriptor();
    
    /** 结束符 */
    public static final TypeDescriptor EOF = new TypeDescriptor(EndSymbol.class);
    
    /** 初始化 */
    public static final TypeDescriptor INIT = new TypeDescriptor(InitSymbol.class);
    
    /** 未知类型 */
    public static final TypeDescriptor UNKNOWN = new TypeDescriptor(Object.class);
    
    /** 常用类型 */
    private static final Map<Class<?>, TypeDescriptor> typeDescriptorCache = new HashMap<Class<?>, TypeDescriptor>();
    
    /** 空注解集合 */
    private static final Annotation[] EMPTY_ANNOTATION_ARRAY = new Annotation[0];
    
    static {
        typeDescriptorCache.put(boolean.class, new TypeDescriptor(boolean.class));
        typeDescriptorCache.put(Boolean.class, new TypeDescriptor(Boolean.class));
        typeDescriptorCache.put(byte.class, new TypeDescriptor(byte.class));
        typeDescriptorCache.put(Byte.class, new TypeDescriptor(Byte.class));
        typeDescriptorCache.put(char.class, new TypeDescriptor(char.class));
        typeDescriptorCache.put(Character.class, new TypeDescriptor(Character.class));
        typeDescriptorCache.put(short.class, new TypeDescriptor(short.class));
        typeDescriptorCache.put(Short.class, new TypeDescriptor(Short.class));
        typeDescriptorCache.put(int.class, new TypeDescriptor(int.class));
        typeDescriptorCache.put(Integer.class, new TypeDescriptor(Integer.class));
        typeDescriptorCache.put(long.class, new TypeDescriptor(long.class));
        typeDescriptorCache.put(Long.class, new TypeDescriptor(Long.class));
        typeDescriptorCache.put(float.class, new TypeDescriptor(float.class));
        typeDescriptorCache.put(Float.class, new TypeDescriptor(Float.class));
        typeDescriptorCache.put(double.class, new TypeDescriptor(double.class));
        typeDescriptorCache.put(Double.class, new TypeDescriptor(Double.class));
        typeDescriptorCache.put(String.class, new TypeDescriptor(String.class));
    }
    
    /** 类型 */
    private Class<?> type;
    
    /** 数据 */
    private Object value;
    
    /** 字段 */
    private Field field;
    
    /** 字段关联级别 */
    private int fieldNestingLevel = 1;
    
    /** 元素类型 */
    private TypeDescriptor elementType;
    
    /** Map集合中key类型 */
    private TypeDescriptor mapKeyType;
    
    /** Map集合中值类型 */
    private TypeDescriptor mapValueType;
    
    /** 方法参数 */
    private MethodParameter methodParameter;
    
    /** 注解 */
    private Annotation[] annotations;
    
    /**
     * 构造函数
     */
    private TypeDescriptor() {
    }
    
    /**
     * 
     * 构造函数
     * 
     * @param type 类型
     */
    public TypeDescriptor(final Class<?> type) {
        notNull(type, "类型不能为空");
        this.type = type;
    }
    
    /**
     * 构造函数
     * 
     * @param value 数据
     */
    public TypeDescriptor(final Object value) {
        notNull(value, "Value must not be null");
        this.value = value;
        this.type = value.getClass();
    }
    
    /**
     * 构造函数
     * 
     * @param field 字段
     */
    public TypeDescriptor(final Field field) {
        notNull(field, "Field must not be null");
        this.field = field;
    }
    
    /**
     * 构造函数
     * 
     * @param field 字段
     * @param type 类型
     */
    public TypeDescriptor(Field field, Class<?> type) {
        notNull(field, "Field must not be null");
        this.field = field;
        this.type = type;
    }
    
    /**
     * 构造函数
     * 
     * @param field 字段
     * @param nestingLevel 关联级别
     * @param type 类型
     */
    private TypeDescriptor(Field field, int nestingLevel, Class<?> type) {
        notNull(field, "Field must not be null");
        this.field = field;
        this.fieldNestingLevel = nestingLevel;
        this.type = type;
    }
    
    /**
     * 构造函数
     * 
     * @param methodParameter 方法参数
     */
    public TypeDescriptor(MethodParameter methodParameter) {
        notNull(methodParameter, "MethodParameter must not be null");
        this.methodParameter = methodParameter;
    }
    
    /**
     * 构造函数
     * 
     * @param methodParameter 方法参数
     * @param type 类型
     */
    public TypeDescriptor(MethodParameter methodParameter, Class<?> type) {
        notNull(methodParameter, "MethodParameter must not be null");
        this.methodParameter = methodParameter;
        this.type = type;
    }
    
    /**
     * @return 获取 field属性值
     */
    public Field getField() {
        return field;
    }
    
    /**
     * @return 获取类型
     */
    public Class<?> getType() {
        if (this.type != null) {
            return this.type;
        } else if (this.field != null) {
            return this.field.getType();
        } else if (this.methodParameter != null) {
            return this.methodParameter.getParameterType();
        }
        return null;
    }
    
    /**
     * @return 获取方法参数
     */
    public MethodParameter getMethodParameter() {
        return this.methodParameter;
    }
    
    /**
     * 获取对象类型
     *
     * @return 类型
     */
    public Class<?> getObjectType() {
        Class<?> clazz = getType();
        return (clazz != null ? resolvePrimitiveIfNecessary(clazz) : clazz);
    }
    
    /**
     * 获取类型名称
     * 
     * @return 名称
     */
    public String getName() {
        Class<?> clazz = getType();
        return (clazz != null ? getQualifiedName(clazz) : null);
    }
    
    /**
     * @return Is this type a primitive type?
     */
    public boolean isPrimitive() {
        Class<?> clazz = getType();
        return (clazz != null && clazz.isPrimitive());
    }
    
    /**
     * @return Is this type an array type?
     */
    public boolean isArray() {
        Class<?> clazz = getType();
        return (clazz != null && clazz.isArray());
    }
    
    /**
     * @return Is this type a {@link Collection} type?
     */
    public boolean isCollection() {
        return Collection.class.isAssignableFrom(getType());
    }
    
    /**
     * @return If this type is an array type or {@link Collection} type, returns the underlying element type.
     *         Returns <code>null</code> if the type is neither an array or collection.
     */
    public Class<?> getElementType() {
        return getElementTypeDescriptor().getType();
    }
    
    /**
     * @return Return the element type as a type descriptor.
     */
    public synchronized TypeDescriptor getElementTypeDescriptor() {
        if (this.elementType == null) {
            this.elementType = forElementType(resolveElementType());
        }
        return this.elementType;
    }
    
    /**
     * Return the element type as a type descriptor. If the element type is null
     * (cannot be determined), the type descriptor is derived from the element argument.
     * 
     * @param element the element
     * @return the element type descriptor
     */
    public TypeDescriptor getElementTypeDescriptor(Object element) {
        TypeDescriptor eType = getElementTypeDescriptor();
        return (eType != TypeDescriptor.UNKNOWN ? eType : forObject(element));
    }
    
    /**
     * @return Is this type a {@link Map} type?
     */
    public boolean isMap() {
        return Map.class.isAssignableFrom(getType());
    }
    
    /**
     * @return Is this descriptor for a map where the key type and value type are known?
     */
    public boolean isMapEntryTypeKnown() {
        return (isMap() && getMapKeyType() != null && getMapValueType() != null);
    }
    
    /**
     * Determine the generic key type of the wrapped Map parameter/field, if any.
     * 
     * @return the generic type, or <code>null</code> if none
     */
    public Class<?> getMapKeyType() {
        return getMapKeyTypeDescriptor().getType();
    }
    
    /**
     * @return Returns map key type as a type descriptor.
     */
    public synchronized TypeDescriptor getMapKeyTypeDescriptor() {
        if (this.mapKeyType == null) {
            this.mapKeyType = forElementType(resolveMapKeyType());
        }
        return this.mapKeyType;
    }
    
    /**
     * Return the map key type as a type descriptor. If the key type is null
     * (cannot be determined), the type descriptor is derived from the key argument.
     * 
     * @param key the key
     * @return the map key type descriptor
     */
    public TypeDescriptor getMapKeyTypeDescriptor(Object key) {
        TypeDescriptor keyType = getMapKeyTypeDescriptor();
        return (keyType != TypeDescriptor.UNKNOWN ? keyType : TypeDescriptor.forObject(key));
    }
    
    /**
     * Determine the generic value type of the wrapped Map parameter/field, if any.
     * 
     * @return the generic type, or <code>null</code> if none
     */
    public Class<?> getMapValueType() {
        return getMapValueTypeDescriptor().getType();
    }
    
    /**
     * @return Returns map value type as a type descriptor.
     */
    public synchronized TypeDescriptor getMapValueTypeDescriptor() {
        if (this.mapValueType == null) {
            this.mapValueType = forElementType(resolveMapValueType());
        }
        return this.mapValueType;
    }
    
    /**
     * Return the map value type as a type descriptor. If the value type is null
     * (cannot be determined), the type descriptor is derived from the value argument.
     * 
     * @param object the value
     * @return the map value type descriptor
     */
    public TypeDescriptor getMapValueTypeDescriptor(Object object) {
        TypeDescriptor valueType = getMapValueTypeDescriptor();
        return (valueType != TypeDescriptor.UNKNOWN ? valueType : forObject(object));
    }
    
    /**
     * 元素类型
     *
     * @param clazz 元素类型
     * @return 元素类型描述
     */
    public TypeDescriptor forElementType(Class<?> clazz) {
        if (clazz == null) {
            return TypeDescriptor.UNKNOWN;
        } else if (this.methodParameter != null) {
            MethodParameter nested = new MethodParameter(this.methodParameter);
            nested.increaseNestingLevel();
            return new TypeDescriptor(nested, clazz);
        } else if (this.field != null) {
            return new TypeDescriptor(this.field, this.fieldNestingLevel + 1, clazz);
        } else {
            return TypeDescriptor.valueOf(clazz);
        }
    }
    
    /**
     * @return 处理元素类型
     */
    private Class<?> resolveElementType() {
        if (isArray()) {
            return getType().getComponentType();
        } else if (isCollection()) {
            return resolveCollectionElementType();
        } else {
            return null;
        }
    }
    
    /**
     * @return 集合元素类型
     */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    private Class<?> resolveCollectionElementType() {
        if (this.field != null) {
            return getCollectionFieldType(this.field, this.fieldNestingLevel);
        } else if (this.value instanceof Collection) {
            Class<?> clazz = findCommonElementType((Collection) this.value);
            if (clazz != null) {
                return clazz;
            }
        } else if (this.type != null) {
            return getCollectionType((Class<? extends Collection>) this.type);
        }
        return null;
    }
    
    /**
     * @return 解析Map集合Key类型
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private Class<?> resolveMapKeyType() {
        if (this.field != null) {
            return getMapKeyFieldType(this.field);
        } else if (this.methodParameter != null) {
            return CollectionTypeResolver.getMapKeyParameterType(this.methodParameter);
        } else if (this.value instanceof Map<?, ?>) {
            Class<?> keyType = findCommonElementType(((Map<?, ?>) this.value).keySet());
            if (keyType != null) {
                return keyType;
            }
        } else if (this.type != null && isMap()) {
            return CollectionTypeResolver.getMapKeyType((Class<? extends Map>) this.type);
        }
        return null;
    }
    
    /**
     * @return 解析Map集合值类型
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    private Class<?> resolveMapValueType() {
        if (this.field != null) {
            return getMapValueFieldType(this.field);
        } else if (this.methodParameter != null) {
            return CollectionTypeResolver.getMapValueParameterType(this.methodParameter);
        } else if (this.value instanceof Map<?, ?>) {
            Class<?> valueType = findCommonElementType(((Map<?, ?>) this.value).values());
            if (valueType != null) {
                return valueType;
            }
        } else if (this.type != null && isMap()) {
            return CollectionTypeResolver.getMapValueType((Class<? extends Map>) this.type);
        }
        return null;
    }
    
    /**
     * 根据数据获取类型
     *
     * @param object 数据
     * @return 类型描述
     */
    public static TypeDescriptor forObject(Object object) {
        if (object == null) {
            return NULL;
        } else if (object instanceof Collection<?> || object instanceof Map<?, ?>) {
            return new TypeDescriptor(object);
        } else {
            return valueOf(object.getClass());
        }
    }
    
    /**
     * 获取类型的值
     *
     * @param type 类型
     * @return 类型描述对象
     */
    public static TypeDescriptor valueOf(Class<?> type) {
        if (type == null) {
            return TypeDescriptor.NULL;
        }
        TypeDescriptor desc = typeDescriptorCache.get(type);
        return (desc != null ? desc : new TypeDescriptor(type));
    }
    
    /**
     * @return 获取注解集合
     */
    public synchronized Annotation[] getAnnotations() {
        if (this.annotations == null) {
            this.annotations = resolveAnnotations();
        }
        return this.annotations;
    }
    
    /**
     * @param annotationType 注解类型
     * @return 注解
     */
    public Annotation getAnnotation(Class<? extends Annotation> annotationType) {
        for (Annotation annotation : getAnnotations()) {
            if (annotation.annotationType().equals(annotationType)) {
                return annotation;
            }
        }
        return null;
    }
    
    /**
     * @return 解析注解
     */
    private Annotation[] resolveAnnotations() {
        if (this.field != null) {
            return this.field.getAnnotations();
        } else if (this.methodParameter != null) {
            if (this.methodParameter.getParameterIndex() < 0) {
                return this.methodParameter.getMethodAnnotations();
            }
            return this.methodParameter.getParameterAnnotations();
        } else {
            return EMPTY_ANNOTATION_ARRAY;
        }
    }
    
    /**
     * 是否可以指派到指定类型
     *
     * @param targetType 类型描述
     * @return 是否指定类型
     */
    public boolean isAssignableTo(TypeDescriptor targetType) {
        if (this == TypeDescriptor.NULL || targetType == TypeDescriptor.NULL) {
            return true;
        }
        if (isCollection() && targetType.isCollection() || isArray() && targetType.isArray()) {
            return targetType.getType().isAssignableFrom(getType())
                && getElementTypeDescriptor().isAssignableTo(targetType.getElementTypeDescriptor());
        } else if (isMap() && targetType.isMap()) {
            return targetType.getType().isAssignableFrom(getType())
                && getMapKeyTypeDescriptor().isAssignableTo(targetType.getMapKeyTypeDescriptor())
                && getMapValueTypeDescriptor().isAssignableTo(targetType.getMapValueTypeDescriptor());
        } else {
            return targetType.getObjectType().isAssignableFrom(getObjectType());
        }
    }
    
    /**
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof TypeDescriptor) || obj == TypeDescriptor.NULL) {
            return false;
        }
        TypeDescriptor other = (TypeDescriptor) obj;
        boolean annotatedTypeEquals = getType().equals(other.getType())
            && nullSafeEquals(getAnnotations(), other.getAnnotations());
        if (isCollection()) {
            return annotatedTypeEquals && nullSafeEquals(getElementType(), other.getElementType());
        } else if (isMap()) {
            return annotatedTypeEquals && nullSafeEquals(getMapKeyType(), other.getMapKeyType())
                && nullSafeEquals(getMapValueType(), other.getMapValueType());
        } else {
            return annotatedTypeEquals;
        }
    }
    
    /**
     * @see java.lang.Object#hashCode()
     */
    @Override
    public int hashCode() {
        return (this == TypeDescriptor.NULL ? 0 : getType().hashCode());
    }
    
    /**
     * 结束符
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年11月19日 lizhongwen
     */
    public static class EndSymbol {
        
        /** 实例 */
        private static final EndSymbol INSTANCE = new EndSymbol();
        
        /**
         * 构造函数
         */
        private EndSymbol() {
            
        }
        
        /**
         * @return 获取结束符实例
         */
        public static EndSymbol instance() {
            return INSTANCE;
        }
        
        /**
         * 
         * @see java.lang.Object#toString()
         */
        @Override
        public String toString() {
            return "EOF";
        }
    }
    
    /**
     * 初始化符
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年11月19日 lizhongwen
     */
    public static class InitSymbol {
        
        /** 实例 */
        private static final InitSymbol INSTANCE = new InitSymbol();
        
        /**
         * 构造函数
         */
        private InitSymbol() {
            
        }
        
        /**
         * @return 获取初始化符实例
         */
        public static InitSymbol instance() {
            return INSTANCE;
        }
        
        /**
         * 
         * @see java.lang.Object#toString()
         */
        @Override
        public String toString() {
            return "INIT";
        }
    }
    
}
