/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.util;

/**
 * 断言
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class Assert {
    
    /**
     * 如果不为空，则抛出参数异常
     * 
     * @param object 数据
     * @param message 异常消息
     */
    public static void isNull(Object object, String message) {
        if (object != null) {
            throw new IllegalArgumentException(message);
        }
    }
    
    /**
     * 检查参数是否为空，如果不为空，则抛出异常
     *
     * @param object 数据
     */
    public static void isNull(Object object) {
        isNull(object, "[Assertion failed] - the object argument must be null");
    }
    
    /**
     * 检查参数是否为空，如果为空，则抛出异常
     * 
     * @param object 数据
     * @param message 异常消息
     */
    public static void notNull(Object object, String message) {
        if (object == null) {
            throw new IllegalArgumentException(message);
        }
    }
    
    /**
     * 检查参数是否为空，如果为空，则抛出异常
     * 
     * @param object 数据
     */
    public static void notNull(Object object) {
        notNull(object, "[Assertion failed] - this argument is required; it must not be null");
    }
    
    /**
     * 表达式结果为否，则抛出异常
     *
     * @param expression 表达式
     * @param message 异常消息
     */
    public static void isTrue(boolean expression, String message) {
        if (!expression) {
            throw new IllegalArgumentException(message);
        }
    }
    
    /**
     * 表达式结果为否，则抛出异常
     *
     * @param expression 表达式
     */
    public static void isTrue(boolean expression) {
        isTrue(expression, "[Assertion failed] - this expression must be true");
    }
    
}
