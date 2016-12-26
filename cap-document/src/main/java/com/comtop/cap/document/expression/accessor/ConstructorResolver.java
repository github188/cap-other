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
 * 构造函数解析器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public interface ConstructorResolver {
    
    /**
     * 解析构造函数
     *
     * @param context 上下文
     * @param typeName 类型名称
     * @param argumentTypes 参数类型
     * @return 构造函数执行器
     * @throws AccessException 访问异常
     */
    ConstructorExecutor resolve(EvaluationContext context, String typeName, List<TypeDescriptor> argumentTypes)
        throws AccessException;
}
