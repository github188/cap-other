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
 * 方法执行器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public interface MethodExecutor {
    
    /**
     * 执行
     *
     * @param context 表达式执行上下文
     * @param target 目标对象
     * @param arguments 参数
     * @return 执行结果
     * @throws AccessException 方法访问异常
     */
    TypedValue execute(EvaluationContext context, Object target, Object... arguments) throws AccessException;
    
}
