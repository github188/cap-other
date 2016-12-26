/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import static com.comtop.cap.document.util.ReflectionHelper.findField;

import java.beans.PropertyDescriptor;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.LinkedHashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

/**
 * 属性类型描述
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class PropertyTypeDescriptor extends TypeDescriptor {
    
    /** 属性描述 */
    private final PropertyDescriptor propertyDescriptor;
    
    /** 注解缓存 */
    private Annotation[] cachedAnnotations;
    
    /**
     * 构造函数
     * 
     * @param propertyDescriptor 属性描述
     * @param methodParameter 方法参数
     */
    public PropertyTypeDescriptor(PropertyDescriptor propertyDescriptor, MethodParameter methodParameter) {
        super(methodParameter);
        this.propertyDescriptor = propertyDescriptor;
    }
    
    /**
     * 构造函数
     * 
     * @param propertyDescriptor 属性描述
     * @param methodParameter 方法参数
     * @param type 类型
     */
    public PropertyTypeDescriptor(PropertyDescriptor propertyDescriptor, MethodParameter methodParameter, Class<?> type) {
        super(methodParameter, type);
        this.propertyDescriptor = propertyDescriptor;
    }
    
    /**
     * @return 属性描述
     */
    public PropertyDescriptor getPropertyDescriptor() {
        return this.propertyDescriptor;
    }
    
    /**
     * 获取注解集合
     * 
     * @see com.comtop.cap.document.expression.support.TypeDescriptor#getAnnotations()
     */
    @Override
    public Annotation[] getAnnotations() {
        Annotation[] anns = this.cachedAnnotations;
        if (anns == null) {
            Map<Class<?>, Annotation> annMap = new LinkedHashMap<Class<?>, Annotation>();
            String name = this.propertyDescriptor.getName();
            if (StringUtils.isNotBlank(name)) {
                Class<?> clazz = getMethodParameter().getMethod().getDeclaringClass();
                Field field = findField(clazz, name);
                if (field == null) {
                    // Same lenient fallback checking as in CachedIntrospectionResults...
                    field = findField(clazz, name.substring(0, 1).toLowerCase() + name.substring(1));
                    if (field == null) {
                        field = findField(clazz, name.substring(0, 1).toUpperCase() + name.substring(1));
                    }
                }
                if (field != null) {
                    for (Annotation ann : field.getAnnotations()) {
                        annMap.put(ann.annotationType(), ann);
                    }
                }
            }
            Method writeMethod = this.propertyDescriptor.getWriteMethod();
            Method readMethod = this.propertyDescriptor.getReadMethod();
            if (writeMethod != null && writeMethod != getMethodParameter().getMethod()) {
                for (Annotation ann : writeMethod.getAnnotations()) {
                    annMap.put(ann.annotationType(), ann);
                }
            }
            if (readMethod != null && readMethod != getMethodParameter().getMethod()) {
                for (Annotation ann : readMethod.getAnnotations()) {
                    annMap.put(ann.annotationType(), ann);
                }
            }
            for (Annotation ann : getMethodParameter().getMethodAnnotations()) {
                annMap.put(ann.annotationType(), ann);
            }
            for (Annotation ann : getMethodParameter().getParameterAnnotations()) {
                annMap.put(ann.annotationType(), ann);
            }
            anns = annMap.values().toArray(new Annotation[annMap.size()]);
            this.cachedAnnotations = anns;
        }
        return anns;
    }
    
    /**
     * 获取元素类型
     * 
     * @see com.comtop.cap.document.expression.support.TypeDescriptor#forElementType(java.lang.Class)
     */
    @Override
    public TypeDescriptor forElementType(Class<?> elementType) {
        if (elementType != null) {
            return new PropertyTypeDescriptor(this.propertyDescriptor, getMethodParameter(), elementType);
        }
        return super.forElementType(null);
    }
}
