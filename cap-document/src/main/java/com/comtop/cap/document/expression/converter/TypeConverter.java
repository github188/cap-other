/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.converter;

import static com.comtop.cap.document.util.Assert.notNull;

import com.comtop.cap.document.expression.support.TypeDescriptor;

/**
 * 标准类型转换器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class TypeConverter implements ITypeConverter {
    
    /**
     * 转换
     *
     * @param value 数据
     * @param source 源类型
     * @param target 目标类型
     * @return 转换结果
     * @see com.comtop.cap.document.expression.converter.ITypeConverter#convert(java.lang.Object,
     *      com.comtop.cap.document.expression.support.TypeDescriptor,
     *      com.comtop.cap.document.expression.support.TypeDescriptor)
     */
    @Override
    public Object convert(Object value, TypeDescriptor source, TypeDescriptor target) {
        assertNotNull(source, target);
        if (source == TypeDescriptor.NULL) {
            return null;
        }
        if (target == TypeDescriptor.NULL) {
            return null;
        }
        return ConverteService.getInstance().convert(value, target.getType());
    }
    
    /**
     * 类型不能为空检查
     * 
     * @param sourceType 源类型
     * @param targetType 目标类型
     */
    private void assertNotNull(TypeDescriptor sourceType, TypeDescriptor targetType) {
        notNull(sourceType, "The sourceType to convert to is required");
        notNull(targetType, "The targetType to convert to is required");
    }
    
}
