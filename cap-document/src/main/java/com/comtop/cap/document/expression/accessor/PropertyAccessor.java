/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.accessor;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 访问器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public interface PropertyAccessor {
    
    /**
     * @return 获取当前解析器可能调用的类数组
     */
    Class<?>[] getSpecificTargetClasses();
    
    /**
     * 是否可以读取数据
     *
     * @param context 执行上下文
     * @param name 属性名称
     * @param target 数据对象
     * @return 是否可以读取
     * @throws AccessException 属性访问异常
     */
    boolean canRead(EvaluationContext context, Object target, String name) throws AccessException;
    
    /**
     * 读取数据
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 属性名称
     * @return 返回带有类型描述的数据结果封装
     * @throws AccessException 属性访问异常
     */
    TypedValue read(EvaluationContext context, Object target, String name) throws AccessException;
    
    /**
     * 是否可以写入数据
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 属性名称
     * @return 是否可以写入数据
     * @throws AccessException 属性访问异常
     */
    boolean canWrite(EvaluationContext context, Object target, String name) throws AccessException;
    
    /**
     * 写入数据
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 属性名称
     * @param value 属性值
     * @throws AccessException 属性访问异常
     */
    void write(EvaluationContext context, Object target, String name, Object value) throws AccessException;
    
}
