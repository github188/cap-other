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
 * 赋值节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月13日 lizhongwen
 */
public class Assign extends ExprNodeImpl {
    
    /**
     * 构造函数
     * 
     * @param pos 表达式
     * @param operands 操作数
     */
    public Assign(int pos, ExprNodeImpl... operands) {
        super(pos, operands);
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
        TypedValue newValue = children[1].getValueInternal(context);
        getChild(0).setValue(context, newValue.getValue());
        return newValue;
    }
    
    /**
     * 设置值
     * 
     * @param context 表达式执行上下文
     * @param value 数据值
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#setValue(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object)
     */
    @Override
    public void setValue(EvaluationContext context, Object value) throws EvaluationException {
        if (children[1] instanceof Service) { // 子节点为服务
            children[1].setValue(context, value);
        } else if (children[1] instanceof Compound && TypedValue.NULL == value) {
            children[1].setValue(context, TypedValue.INIT);
        } else if (TypedValue.NULL == value) {
            TypedValue newValue = children[1].getValueInternal(context);
            getChild(0).setValue(context, newValue.getValue());
        }
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#toStringAST()
     */
    @Override
    public String toStringAST() {
        return new StringBuilder().append(getChild(0).toStringAST()).append("=").append(getChild(1).toStringAST())
            .toString();
    }
    
}
