/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import static com.comtop.cap.document.util.FormatHelper.formatClassNameForMessage;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.accessor.AccessException;
import com.comtop.cap.document.expression.accessor.PropertyAccessor;
import com.comtop.cap.document.expression.accessor.ReflectivePropertyAccessor;
import com.comtop.cap.document.expression.support.TypeDescriptor;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 属性或者字段
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public class PropertyRef extends ExprNodeImpl {
    
	/** 日志 */
    protected static final Logger LOGGER = LoggerFactory.getLogger(PropertyRef.class);
	
    /** 属性或者字段名称 */
    private final String name;
    
    /** 缓存字段或者属性读取访问器 */
    private volatile PropertyAccessor cachedReadAccessor;
    
    /** 缓存字段或者属性写入访问器 */
    private volatile PropertyAccessor cachedWriteAccessor;
    
    /**
     * 构造函数
     * 
     * @param name 属性或者字段名称
     * @param pos 表达式位置
     */
    public PropertyRef(String name, int pos) {
        super(pos);
        this.name = name;
    }
    
    /**
     * @return 属性或者字段名称
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * 表达式计算
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#getValueInternal(com.comtop.cap.document.expression.EvaluationContext)
     */
    @Override
    public TypedValue getValueInternal(EvaluationContext context) throws EvaluationException {
        TypedValue result = readProperty(context, this.name);
        // Dynamically create the objects if the user has requested that optional behaviour
        if (result.getValue() == null && nextChildIs(Indexer.class, PropertyRef.class)) {
            result = dynamicallyCreate(context, result);
        }
        return result;
    }
    
    /**
     * 设置数据
     *
     * @param context 表达式执行上下文
     * @param value 数据值
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#setValue(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object)
     */
    @Override
    public void setValue(EvaluationContext context, Object value) throws EvaluationException {
        Object val = value;
        if (value instanceof TypedValue) {
            val = ((TypedValue) value).getValue();
        }
        writeProperty(context, this.name, val);
    }
    
    /**
     * 读取数据数据
     *
     * @param context 表达式执行上下文
     * @param propertyName 属性或者字段名称
     * @return 数据值
     * @throws EvaluationException 表达式执行异常
     */
    private TypedValue readProperty(EvaluationContext context, String propertyName) throws EvaluationException {
        TypedValue contextObject = context.getActiveContextObject();
        Object targetObject = contextObject.getValue();
        
        if (targetObject == null) {
            return TypedValue.NULL;
        }
        if (targetObject instanceof Map) {
            Map<?, ?> map = (Map<?, ?>) targetObject;
            Object obj = map.get(propertyName);
            if (obj == null) {
                return TypedValue.NULL;
            }
            return new TypedValue(obj);
        }
        
        PropertyAccessor accessorToUse = this.cachedReadAccessor;
        if (accessorToUse != null) {
            try {
                return accessorToUse.read(context, contextObject.getValue(), propertyName);
            } catch (AccessException ae) {
                // this is OK - it may have gone stale due to a class change,
                // let's try to get a new one and call it before giving up
            	LOGGER.debug("无法访问数据",ae);
                this.cachedReadAccessor = null;
            }
        }
        
        Class<?> contextObjectClass = getObjectClass(contextObject.getValue());
        List<PropertyAccessor> accessorsToTry = getPropertyAccessorsToTry(contextObjectClass, context);
        
        // Go through the accessors that may be able to resolve it. If they are a cacheable accessor then
        // get the accessor and use it. If they are not cacheable but report they can read the property
        // then ask them to read it
        if (accessorsToTry != null) {
            try {
                for (PropertyAccessor accessor : accessorsToTry) {
                    if (accessor.canRead(context, contextObject.getValue(), propertyName)) {
                        if (accessor instanceof ReflectivePropertyAccessor) {
                            accessor = ((ReflectivePropertyAccessor) accessor).createOptimalAccessor(context,
                                contextObject.getValue(), propertyName);
                        }
                        this.cachedReadAccessor = accessor;
                        return accessor.read(context, contextObject.getValue(), propertyName);
                    }
                }
            } catch (AccessException ae) {
                throw new EvaluationException(MessageFormat.format("访问属性''{0}''异常:''{1}''!", propertyName,
                    ae.getMessage()), ae);
            }
        }
        if (contextObject.getValue() == null) {
            throw new EvaluationException(MessageFormat.format("无法访问null属性''{0}''!", propertyName));
        }
        throw new EvaluationException(getStartPosition(), MessageFormat.format("属性''{0}''无法访问:''{1}''!", propertyName,
            formatClassNameForMessage(contextObjectClass)));
    }
    
    /**
     * 动态创建属性
     *
     * @param context 上下文
     * @param value 数据
     * @return 结果
     */
    private TypedValue dynamicallyCreate(EvaluationContext context, TypedValue value) {
        TypedValue result = null;
        TypeDescriptor resultDescriptor = value.getDescriptor();
        // Creating lists and maps
        if ((resultDescriptor.getType().equals(List.class) || resultDescriptor.getType().equals(Map.class))) {
            // Create a new collection or map ready for the indexer
            if (resultDescriptor.getType().equals(List.class)) {
                try {
                    List<?> newList = ArrayList.class.newInstance();
                    writeProperty(context, this.name, newList);
                    result = readProperty(context, this.name);
                } catch (InstantiationException ex) {
                    throw new EvaluationException(getStartPosition(), "无法创建或移除有一个null的List!", ex);
                } catch (IllegalAccessException ex) {
                    throw new EvaluationException(getStartPosition(), "无法创建或移除有一个null的List!", ex);
                }
            } else {
                try {
                    Map<?, ?> newMap = HashMap.class.newInstance();
                    writeProperty(context, name, newMap);
                    result = readProperty(context, this.name);
                } catch (InstantiationException ex) {
                    throw new EvaluationException(getStartPosition(), "无法创建或移除有一个null的Map!", ex);
                } catch (IllegalAccessException ex) {
                    throw new EvaluationException(getStartPosition(), "无法创建或移除有一个null的Map!", ex);
                }
            }
        } else {
            // 'simple' object
            try {
                Object newObject = value.getDescriptor().getType().newInstance();
                writeProperty(context, name, newObject);
                result = readProperty(context, this.name);
            } catch (InstantiationException ex) {
                throw new EvaluationException(getStartPosition(), MessageFormat.format("无法创建''{0}''类型的对象！", value
                    .getDescriptor().getType()), ex);
            } catch (IllegalAccessException ex) {
                throw new EvaluationException(getStartPosition(), MessageFormat.format("无法创建''{0}''类型的对象！", value
                    .getDescriptor().getType()), ex);
            }
        }
        return result;
    }
    
    /**
     * 设置数据
     *
     * @param context 表达式执行上下文
     * @param propertyName 属性名称
     * @param value 数据值
     * @throws EvaluationException 表达式执行异常
     */
    private void writeProperty(EvaluationContext context, String propertyName, Object value) throws EvaluationException {
        TypedValue contextObject = context.getActiveContextObject();
        Object targetObject = contextObject.getValue();
        if (targetObject == null) {
            if (Map.class.equals(contextObject.getDescriptor().getType()) && this.getNextChild() == null) {
                Map<String, Object> obj = new HashMap<String, Object>();
                targetObject = obj;
                contextObject.setValue(targetObject);
            }
            return;
            
        }
        if (contextObject.getDescriptor() != null && Map.class.equals(contextObject.getDescriptor().getType())
            && this.getNextChild() == null) {
            @SuppressWarnings({ "unchecked" })
            Map<String, Object> obj = (Map<String, Object>) targetObject;
            obj.put(propertyName, value);
            return;
        }
        
        PropertyAccessor accessorToUse = this.cachedWriteAccessor;
        if (accessorToUse != null) {
            try {
                accessorToUse.write(context, contextObject.getValue(), propertyName, value);
                return;
            } catch (AccessException ae) {
                // this is OK - it may have gone stale due to a class change,
                // let's try to get a new one and call it before giving up
            	LOGGER.debug("无法访问数据",ae);
                this.cachedWriteAccessor = null;
            }
        }
        
        Class<?> contextObjectClass = getObjectClass(targetObject);
        String className = contextObjectClass.getName();
        List<PropertyAccessor> accessorsToTry = getPropertyAccessorsToTry(contextObjectClass, context);
        if (accessorsToTry != null) {
            try {
                for (PropertyAccessor accessor : accessorsToTry) {
                    if (accessor.canWrite(context, targetObject, propertyName)) {
                        this.cachedWriteAccessor = accessor;
                        accessor.write(context, targetObject, propertyName, value);
                        return;
                    }
                }
            } catch (AccessException ae) {
                throw new EvaluationException(getStartPosition(), MessageFormat.format("写入''{0}''属性''{1}''异常:''{2}''!",
                    className, propertyName, ae.getMessage()), ae);
            }
        }
        throw new EvaluationException(getStartPosition(), MessageFormat.format("''{0}''属性''{1}''无法访问:''{2}''!",
            className, propertyName, formatClassNameForMessage(contextObjectClass)));
    }
    
    /**
     * 获取属性访问器
     *
     * @param targetType 目标类型
     * @param context 表达式执行上下文
     * @return 属性访问器
     */
    private List<PropertyAccessor> getPropertyAccessorsToTry(Class<?> targetType, EvaluationContext context) {
        List<PropertyAccessor> specificAccessors = new ArrayList<PropertyAccessor>();
        List<PropertyAccessor> generalAccessors = new ArrayList<PropertyAccessor>();
        for (PropertyAccessor resolver : context.getPropertyAccessors()) {
            Class<?>[] targets = resolver.getSpecificTargetClasses();
            if (targets == null) { // generic resolver that says it can be used for any type
                generalAccessors.add(resolver);
            } else {
                if (targetType != null) {
                    int p = 0;
                    for (Class<?> clazz : targets) {
                        if (clazz == targetType) { // put exact matches on the front to be tried first?
                            specificAccessors.add(p++, resolver);
                        } else if (clazz.isAssignableFrom(targetType)) { // put supertype matches at the end of the
                            // specificAccessor list
                            generalAccessors.add(resolver);
                        }
                    }
                }
            }
        }
        List<PropertyAccessor> resolvers = new ArrayList<PropertyAccessor>();
        resolvers.addAll(specificAccessors);
        resolvers.addAll(generalAccessors);
        return resolvers;
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#toStringAST()
     */
    @Override
    public String toStringAST() {
        return this.name;
    }
    
}
