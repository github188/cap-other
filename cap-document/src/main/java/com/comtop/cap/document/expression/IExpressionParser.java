/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 表达式解析接口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public interface IExpressionParser {
    
    /**
     * 解析表达式
     *
     * @param expression 表达式字符串
     * @return 表达式对象
     * @throws ParseException 表达式解析异常
     */
    IExpression parse(String expression) throws ParseException;
    
    /**
     * 解析表达式
     *
     * @param expression 表达式字符串
     * @param context 表达解析上下文
     * @return 表达式对象
     * @throws ParseException 表达式解析异常
     */
    IExpression parse(String expression, IParseContext context) throws ParseException;
}
