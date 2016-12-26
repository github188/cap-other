/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 表达式执行异常
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class EvaluationException extends ExpressionException {
    
    /** 序列ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * 构造函数
     * 
     * @param position 表达式出错位置
     * @param message 错误消息
     */
    public EvaluationException(int position, String message) {
        super(position, message);
    }
    
    /**
     * 构造函数
     * 
     * @param expression 出错的表达式
     * @param message 错误消息
     */
    public EvaluationException(String expression, String message) {
        super(expression, message);
    }
    
    /**
     * 构造函数
     * 
     * @param position 表达式出错位置
     * @param message 错误消息
     * @param cause 错误原因
     */
    public EvaluationException(int position, String message, Throwable cause) {
        super(position, message, cause);
    }
    
    /**
     * 构造函数
     * 
     * @param message 错误消息
     */
    public EvaluationException(String message) {
        super(message);
    }
    
    /**
     * 构造函数
     * 
     * @param message 错误消息
     * @param cause 错误原因
     */
    public EvaluationException(String message, Throwable cause) {
        super(message, cause);
    }
    
    /**
     * @param position 设置表达式的位置为position
     */
    public void setPosition(int position) {
        this.position = position;
    }
    
}
