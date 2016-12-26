/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 表达式异常
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class ExpressionException extends RuntimeException {
    
    /** 序列ID */
    private static final long serialVersionUID = 1L;
    
    /** 表达式 */
    protected String expression;
    
    /** 位置索引 */
    protected int position; // -1 if not known - but should be known in all reasonable cases
    
    /**
     * 构造函数
     * 
     * @param expression 表达式
     * @param message 位置索引
     */
    public ExpressionException(final String expression, final String message) {
        super(message);
        this.position = -1;
        this.expression = expression;
    }
    
    /**
     * 构造函数
     * 
     * @param expression 表达式
     * @param position 位置索引
     * @param message 错误消息
     */
    public ExpressionException(final String expression, final int position, final String message) {
        super(message);
        this.position = position;
        this.expression = expression;
    }
    
    /**
     * 构造函数
     * 
     * @param position 位置索引
     * @param message 错误消息
     */
    public ExpressionException(int position, String message) {
        super(message);
        this.position = position;
    }
    
    /**
     * 构造函数
     * 
     * @param position 位置索引
     * @param message 错误消息
     * @param cause 错误原因
     */
    public ExpressionException(int position, String message, Throwable cause) {
        super(message, cause);
        this.position = position;
    }
    
    /**
     * 构造函数
     * 
     * @param message 错误消息
     */
    public ExpressionException(String message) {
        super(message);
    }
    
    /**
     * 
     * 构造函数
     * 
     * @param message 错误消息
     * @param cause 错误原因
     */
    public ExpressionException(String message, Throwable cause) {
        super(message, cause);
    }
    
    /**
     * 详细消息
     *
     * @return 详细消息
     */
    public String toDetailedString() {
        StringBuilder output = new StringBuilder();
        if (expression != null) {
            output.append("Expression '");
            output.append(expression);
            output.append("'");
            if (position != -1) {
                output.append(" @ ");
                output.append(position);
            }
            output.append(": ");
        }
        output.append(getMessage());
        return output.toString();
    }
    
    /**
     * @return 获取表达式
     */
    public final String getExpression() {
        return this.expression;
    }
    
    /**
     * @return 获取位置索引
     */
    public final int getPosition() {
        return position;
    }
    
}
