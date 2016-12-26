/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import com.comtop.cap.document.expression.ast.Assign;
import com.comtop.cap.document.expression.ast.ExprNode;
import com.comtop.cap.document.expression.ast.Service;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 表达式
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月13日 lizhongwen
 */
public class Expression implements IExpression {
    
    /** 表达式 */
    private final String expression;
    
    /** 抽象语法树 */
    private final ExprNode ast;
    
    /** 默认执行上下文 */
    private EvaluationContext defaultContext;
    
    /** 是否支持重复调用 */
    private boolean service;
    
    /**
     * 构造函数
     * 
     * @param expression 表达式
     * @param ast 抽象语法树
     */
    public Expression(String expression, ExprNode ast) {
        this.expression = expression;
        this.ast = ast;
        initService();
    }
    
    /**
     * 初始化reCallable
     *
     */
    private void initService() {
        service = this.ast != null && this.ast instanceof Assign && this.ast.getChild(1) instanceof Service;
    }
    
    /**
     * 执行
     *
     * @param root 根对象
     * @param value 参数
     * @return 表达式计算结果
     * @see com.comtop.cap.document.expression.IExpression#execute(java.lang.Object, java.lang.Object)
     */
    @Override
    public Object execute(Object root, Object value) {
        Object result;
        if (value == null) {
            result = this.ast.getValue(getEvaluationContext());
        } else {
            this.ast.setValue(getEvaluationContext(), toTypedValue(value));
            result = value;
        }
        return result;
    }
    
    /**
     * 
     * @see com.comtop.cap.document.expression.IExpression#execute(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object)
     */
    @Override
    public Object execute(EvaluationContext context, Object value) {
        Object result;
        if (value == null) {
            result = this.ast.getValue(context);
        } else {
            this.ast.setValue(context, value);
            result = value;
        }
        return result;
    }
    
    /**
     * @return 获取被表达式执行上下文
     */
    public EvaluationContext getEvaluationContext() {
        if (defaultContext == null) {
            defaultContext = new EvaluationContext();
        }
        return defaultContext;
    }
    
    /**
     * @param context 设置被表达式执行上下文
     */
    public void setEvaluationContext(EvaluationContext context) {
        this.defaultContext = context;
    }
    
    /**
     * @return 获取 expression属性值
     */
    public String getExpression() {
        return expression;
    }
    
    /**
     * @return 获取 ast属性值
     */
    @Override
    public ExprNode getAst() {
        return ast;
    }
    
    /**
     * 将对象转换为类型包装后的对象
     *
     * @param object 对象
     * @return 类型包装后的数据
     */
    private TypedValue toTypedValue(Object object) {
        if (object == null) {
            return TypedValue.NULL;
        }
        return new TypedValue(object);
    }
    
    /**
     * @return 转换为抽象语法树表达方式
     */
    @Override
    public String toString() {
        return ast.toStringAST();
    }
    
    /**
     * @return 获取 service属性值
     */
    @Override
    public boolean isService() {
        return service;
    }
}
