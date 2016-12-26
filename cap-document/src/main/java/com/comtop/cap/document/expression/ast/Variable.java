/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 变量节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public class Variable extends ExprNodeImpl {
    
    /** this */
    private final static String THIS = "this"; // currently active context object
    
    /** root */
    private final static String ROOT = "root"; // root context object
    
    /** 名称 */
    private final String name;
    
    /**
     * 构造函数
     * 
     * @param name 变量名称
     * @param pos 表达式位置
     */
    public Variable(String name, int pos) {
        super(pos);
        this.name = name;
    }
    
    /**
     * 表达式计算
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#getValueInternal(com.comtop.cap.document.expression.EvaluationContext)
     */
    @Override
    public TypedValue getValueInternal(EvaluationContext context) throws EvaluationException {
        if (this.name.equals(THIS)) {
            return context.getActiveContextObject();
        }
        if (this.name.equals(ROOT)) {
            return context.getRootObject();
        }
        TypedValue result = context.lookupVariable(this.name);
        // a null value will mean either the value was null or the variable was not found
        return result;
    }
    
    /**
     * 设置数据
     *
     * @param context 表达式执行上下文
     * @param value 数据值
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#setValue(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object)
     */
    @Override
    public void setValue(EvaluationContext context, Object value) throws EvaluationException {
        context.setVariable(this.name, value);
    }
    
    @Override
    public String toStringAST() {
        return "$" + this.name;
    }
}
