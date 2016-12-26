/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.converter;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.support.TypeDescriptor;
import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.util.ClassUtils;

/**
 * 转换工具类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class ConverterUtils {
    
    /**
     * 将数据转换为目标类型
     * @param <T> 转换结果
     * 
     * @param context 表达式执行上下文
     * @param value 被转换的值
     * @param targetType 目标类型
     * @return 转换结果
     * @throws EvaluationException 转换执行异常
     */
    public static <T> T convert(EvaluationContext context, Object value, Class<T> targetType)
        throws EvaluationException {
        return convertTypedValue(context, new TypedValue(value, TypeDescriptor.forObject(value)), targetType);
    }
    
    /**
     * 将数据转换为目标类型
     * @param <T> 返回对象值
     * 
     * @param context 表达式执行上下文
     * @param typedValue 被转换的值
     * @param targetType 目标类型
     * @return 转换结果
     * @throws EvaluationException 转换执行异常
     */
    @SuppressWarnings("unchecked")
    public static <T> T convertTypedValue(EvaluationContext context, TypedValue typedValue, Class<T> targetType) {
        Object value = typedValue.getValue();
        if (targetType == null || ClassUtils.isAssignableValue(targetType, value)) {
            return (T) value;
        }
        if (context != null) {
            return (T) context.getTypeConverter().convert(value, typedValue.getDescriptor(),
                TypeDescriptor.valueOf(targetType));
        }
        throw new EvaluationException("Cannot convert value '" + value + "' to type '" + targetType.getName() + "'");
    }
    
    /**
     * 将数据转换为目标类型
     * @param <T> targetType
     * 
     * @param value 被转换的值
     * @param targetType 目标类型
     * @return 转换结果
     */
    @SuppressWarnings("unchecked")
    public static <T> T convert(Object value, Class<T> targetType) {
        return (T) ConverteService.getInstance().convert(value, targetType);
    }
    
}
