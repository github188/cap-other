/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.accessor;

import java.util.List;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.support.TypeDescriptor;

/**
 * 方法解析器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public interface MethodResolver {
    
    /**
     * 解析方法
     *
     * @param context 执行上下文
     * @param target 目标对象
     * @param name 方法名称
     * @param argumentTypes 参数类型
     * @return 方法执行器
     * @throws AccessException 方法访问异常
     */
    MethodExecutor resolve(EvaluationContext context, Object target, String name, List<TypeDescriptor> argumentTypes)
        throws AccessException;
}
