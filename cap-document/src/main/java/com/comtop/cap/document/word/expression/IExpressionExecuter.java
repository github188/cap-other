/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.expression;

/**
 * 表达式执行器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public interface IExpressionExecuter {
    
    /**
     * 表达式执行器
     *
     * @param expression 表达式
     * @param value 数据
     * @return 执行结果
     */
    Object execute(String expression, Object value);
    
    /**
     * 表达式执行器
     *
     * @param expression 表达式
     * @param disposable 执行完即抛弃表达式
     * @param value 数据
     * @return 执行结果
     */
    Object execute(final String expression, boolean disposable, final Object value);
    
    /**
     * 事件通知
     *
     * @param event 事件
     */
    void notify(ExprEvent event);
    
    /**
     * @return 获取表达执行配置
     */
    Configuration getConfiguration();
}
