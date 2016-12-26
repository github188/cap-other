/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.expression;

import static com.comtop.cap.document.util.Assert.notNull;

import java.util.Stack;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.ExpressionParser;
import com.comtop.cap.document.expression.ExpressionUtils;
import com.comtop.cap.document.expression.IExpression;
import com.comtop.cap.document.expression.IExpressionParser;

/**
 * 表达式执行器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
public class ExpressionExecuter implements IExpressionExecuter {
    
    /** 配置 */
    private Configuration configuration;
    
    /** 执行上下文 */
    private EvaluationContext context;
    
    /** 表达式解析器 */
    private IExpressionParser parser;
    
    /** 表达式栈 */
    private Stack<IExpression> expressionStack = new Stack<IExpression>();
    
    /**
     * 构造函数
     * 
     * @param configuration 配置
     */
    public ExpressionExecuter(final Configuration configuration) {
        notNull(configuration);
        this.configuration = configuration;
        this.context = configuration.getContext();
        this.parser = new ExpressionParser();
    }
    
    /**
     * 事件通知
     *
     * @param event 事件
     * @see com.comtop.cap.document.word.expression.IExpressionExecuter#notify(com.comtop.cap.document.word.expression.ExprEvent)
     */
    @Override
    public void notify(final ExprEvent event) {
        switch (event) {
            case START:
                expressionStack.push(null);
                context.initChildVariableScope();
                break;
            case END:
                IExpression curExpr = expressionStack.pop();
                try {
                    if (null != curExpr && curExpr.isService() && null != this.configuration.getEOFObject()) {
                        curExpr.execute(context, this.configuration.getEOFObject());
                    }
                } finally {
                    context.popVariableScope();
                }
                break;
            default:
                break;
        }
    }
    
    /**
     * 读取表达式中引用部分
     *
     * @param expr 从表达式中取得引用部分
     * @return 引用部分字符串
     */
    public String readReference(String expr) {
        return ExpressionUtils.readReference(expr);
    }
    
    /**
     * 读取表达式中的服务
     *
     * @param expr 表达式
     * @return 服务
     */
    public Object readService(final String expr) {
        return ExpressionUtils.readService(expr, context);
    }
    
    /**
     * 读取表达式中的服务名称
     *
     * @param expr 表达式
     * @return 服务名称
     */
    public String readServiceName(final String expr) {
        return ExpressionUtils.readServiceName(expr);
    }
    
    /**
     * 读取表达式中的变量名称
     *
     * @param expr 表达式
     * @return 变量名称
     */
    public String readVariable(final String expr) {
        return ExpressionUtils.readVariable(expr);
    }
    
    /**
     * 表达式执行器
     *
     * @param expression 表达式
     * @param value 数据
     * @return 执行结果
     * @see com.comtop.cap.document.word.expression.IExpressionExecuter#execute(java.lang.String, java.lang.Object)
     */
    @Override
    public Object execute(final String expression, final Object value) {
        return this.execute(expression, true, value);
    }
    
    /**
     * 表达式执行器
     *
     * @param expression 表达式
     * @param disposable 执行完即抛弃表达式
     * @param value 数据
     * @return 执行结果
     * @see com.comtop.cap.document.word.expression.IExpressionExecuter#execute(java.lang.String, boolean,
     *      java.lang.Object)
     */
    @Override
    public Object execute(final String expression, boolean disposable, final Object value) {
        IExpression expr = parser.parse(expression);
        if (expr.isService() || !disposable) {
            this.expressionStack.pop();// 弹出空占位表达式
            this.expressionStack.push(expr);
        }
        return expr.execute(context, value);
    }
    
    /**
     * @return 获取 configuration属性值
     */
    @Override
    public Configuration getConfiguration() {
        return configuration;
    }
    
}
