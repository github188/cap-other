/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

/**
 * 表达式解析异常
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class ParseException extends ExpressionException {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * 
     * 构造函数
     * 
     * @param expression 表达式
     * @param position 位置索引
     * @param message 错误消息
     */
    public ParseException(String expression, int position, String message) {
        super(expression, position, message);
    }
    
    /**
     * 构造函数
     * 
     * @param position 位置索引
     * @param message 错误消息
     * @param cause 错误原因
     */
    public ParseException(int position, String message, Throwable cause) {
        super(position, message, cause);
    }
    
    /**
     * 构造函数
     * 
     * @param position 位置索引
     * @param message 错误消息
     */
    public ParseException(int position, String message) {
        super(position, message);
    }
}
