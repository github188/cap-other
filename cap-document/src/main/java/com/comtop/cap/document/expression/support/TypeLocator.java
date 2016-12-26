/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.support;

import com.comtop.cap.document.expression.EvaluationException;

/**
 * 类型加载器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public interface TypeLocator {
    
    /**
     * 获取类型
     *
     * @param typeName 类型名称
     * @return 类型
     * @throws EvaluationException 获取类型异常
     */
    Class<?> findType(String typeName) throws EvaluationException;
}
