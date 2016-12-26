/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.converter;

import com.comtop.cap.document.expression.support.TypeDescriptor;

/**
 * 类型转换器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public interface ITypeConverter {
    
    /**
     * 转换
     *
     * @param value 数据
     * @param source 源类型
     * @param target 目标类型
     * @return 转换结果
     */
    Object convert(Object value, TypeDescriptor source, TypeDescriptor target);
}
