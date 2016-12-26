/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import com.comtop.cap.document.expression.ast.ExprNode;

/**
 * 复合表达式
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月13日 lizhongwen
 */
public class CompositeExpression implements IExpression {
    
    /** 表达式 */
    private final String expression;
    
    /** 复合表达式中的表达式数组 */
    private final Expression[] expressions;
    
    /**
     * 构造函数
     * 
     * @param expression 表达式
     * @param expressions 复合表达式中的表达式数组
     */
    public CompositeExpression(String expression, Expression[] expressions) {
        this.expression = expression;
        this.expressions = expressions;
    }
    
    /**
     * 获取复合表达式中的表达式数组
     *
     * @return 表达式数组
     */
    public Expression[] getExpressions() {
        return expressions;
    }
    
    /**
     * 原始表达式字符串
     *
     * @return 表达式
     */
    public final String getExpression() {
        return this.expression;
    }
    
    /**
     * 
     * @see com.comtop.cap.document.expression.IExpression#execute(java.lang.Object, java.lang.Object)
     */
    @Override
    public Object execute(Object root, Object value) {
        return null;
    }
    
    /**
     * 
     * @see com.comtop.cap.document.expression.IExpression#execute(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object)
     */
    @Override
    public Object execute(EvaluationContext context, Object value) {
        return null;
    }
    
    /**
     * 
     * @see com.comtop.cap.document.expression.IExpression#isService()
     */
    @Override
    public boolean isService() {
        return false;
    }
    
    /**
     * 
     * @see com.comtop.cap.document.expression.IExpression#getAst()
     */
    @Override
    public ExprNode getAst() {
        return null;
    }
    
}
