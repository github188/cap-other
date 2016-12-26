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
 * 表达式节点，解析后的抽象表达式语法树节点接口
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public interface ExprNode {
    
    /**
     * 获取数据
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     */
    Object getValue(EvaluationContext context) throws EvaluationException;
    
    /**
     * 获取数据
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     */
    TypedValue getTypedValue(EvaluationContext context) throws EvaluationException;
    
    /**
     * 设置数据
     *
     * @param context 表达式执行上下文
     * @param value 数据值
     * @throws EvaluationException 表达式执行异常
     */
    void setValue(EvaluationContext context, Object value) throws EvaluationException;
    
    /**
     * @return 抽象语法树中的字符串
     */
    String toStringAST();
    
    /**
     * @return 当前节点的子节点数量
     */
    int getChildCount();
    
    /**
     * 获取指定索引的子节点
     *
     * @param index 索引
     * @return 子节点
     */
    ExprNode getChild(int index);
    
    /**
     * 获取对象的类
     *
     * @param obj 数据
     * @return 类
     */
    Class<?> getObjectClass(Object obj);
    
    /**
     * @return 获取抽象语法树中的节点在表达式中的开始位置
     */
    int getStartPosition();
    
    /**
     * @return 获取抽象语法树中的节点在表达式中的结束位置
     */
    int getEndPosition();
    
}
