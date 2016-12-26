/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.expression;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.ExpressionParser;
import com.comtop.cap.document.expression.IExpression;
import com.comtop.cap.document.expression.IExpressionParser;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 表达式执行帮助类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月25日 lizhongwen
 */
public class ExpressionExecuteHelper {
    
    /** 日志 */
    private final Logger logger = LoggerFactory.getLogger(ExpressionExecuteHelper.class);
    
    /** 表达式执行器 */
    private ExpressionExecuter executer;
    
    /**
     * 构造函数
     * 
     * @param configuration 表达式执行帮助类
     */
    public ExpressionExecuteHelper(final Configuration configuration) {
        this.executer = new ExpressionExecuter(configuration);
    }
    
    /**
     * 根据表达式读取内容
     *
     * @param expression 表达式
     * @return 执行结果
     */
    public Object read(final String expression) {
        Object ret;
        try {
            ret = this.executer.execute(expression, null);
        } catch (Throwable e) {
            ret = null;
            logger.error(e.getMessage(), e);
        }
        return ret;
    }
    
    /**
     * 根据表达式写入内容
     *
     * @param expression 表达式
     * @return 执行结果
     */
    public Object write(final String expression) {
        Object ret;
        try {
            ret = this.executer.execute(expression, TypedValue.NULL);
        } catch (Throwable e) {
            ret = null;
            logger.error(e.getMessage(), e);
        }
        return ret;
    }
    
    /**
     * 根据表达式写入内容
     *
     * @param expression 表达式
     * @param value 数据
     * @return 执行结果
     */
    public Object write(final String expression, final Object value) {
        Object ret;
        try {
            ret = this.executer.execute(expression, value);
        } catch (Throwable e) {
            ret = null;
            logger.error(e.getMessage(), e);
        }
        return ret;
    }
    
    /**
     * 根据表达式更新内容
     *
     * @param expression 表达式
     * @param value 数据
     * @return 执行结果
     */
    public Object update(final String expression, final Object value) {
        Object ret;
        IExpressionParser parser = new ExpressionParser();
        try {
            IExpression expr = parser.parse(expression);
            if (expr == null || !expr.isService()) {
                return null;
            }
            String ref = this.readReference(expression);
            if (StringUtils.isBlank(ref)) {
                return null;
            }
            EvaluationContext context = executer.getConfiguration().getContext();
            context.initChildVariableScope();
            if (ref.startsWith("$")) {
                context.setVariable(ref, value);
            } else {
                context.enterScope(ref, value);
            }
            ret = expr.execute(context, TypedValue.EOF);
            context.popVariableScope();
        } catch (Throwable e) {
            ret = null;
            logger.error(e.getMessage(), e);
        }
        return ret;
    }
    
    /**
     * 读取表达式中引用部分
     *
     * @param expr 从表达式中取得引用部分
     * @return 引用部分字符串
     */
    public String readReference(String expr) {
        return this.executer.readReference(expr);
    }
    
    /**
     * 读取表达式中的服务
     *
     * @param expr 表达式
     * @return 服务
     */
    public Object readService(final String expr) {
        return this.executer.readService(expr);
    }
    
    /**
     * 读取表达式中的服务名称
     *
     * @param expr 表达式
     * @return 服务名称
     */
    public String readServiceName(final String expr) {
        return this.executer.readServiceName(expr);
    }
    
    /**
     * 读取表达式中的变量名称
     *
     * @param expr 表达式
     * @return 变量名称
     */
    public String readVariable(final String expr) {
        return this.executer.readVariable(expr);
    }
    
    /**
     * 设置变量
     *
     * @param variable 变量名
     * @param value 变量值
     */
    public void setVariable(final String variable, final Object value) {
        EvaluationContext context = executer.getConfiguration().getContext();
        context.setVariable(variable, value);
    }
    
    /**
     * 开始事件通知
     */
    public void notifyStart() {
        try {
            this.executer.notify(ExprEvent.START);
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
        }
    }
    
    /**
     * 结束事件通知
     */
    public void notifyEnd() {
        try {
            this.executer.notify(ExprEvent.END);
        } catch (Throwable e) {
            logger.error(e.getMessage(), e);
        }
    }
    
}
