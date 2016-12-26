/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import static com.comtop.cap.document.util.Assert.isTrue;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.converter.ConverterUtils;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 抽象语法树中的通用节点实现
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public abstract class ExprNodeImpl implements ExprNode {
    
    /** 无子节点 */
    private static ExprNodeImpl[] NO_CHILDREN = new ExprNodeImpl[0];
    
    /** 当前位置 */
    protected int pos; // start = top 16bits, end = bottom 16bits
    
    /** 默认子节点 */
    protected ExprNodeImpl[] children = ExprNodeImpl.NO_CHILDREN;
    
    /** 父节点 */
    protected ExprNodeImpl parent;
    
    /**
     * 构造函数
     * 
     * @param pos 当前位置
     * @param operands 操作数
     */
    public ExprNodeImpl(int pos, ExprNodeImpl... operands) {
        this.pos = pos;
        // pos combines start and end so can never be zero because tokens cannot be zero length
        isTrue(pos != 0);
        if (operands != null && operands.length > 0) {
            this.children = operands;
            for (ExprNodeImpl childnode : operands) {
                childnode.parent = this;
            }
        }
    }
    
    /**
     * @return 上一个子节点
     */
    protected ExprNodeImpl getPreviousChild() {
        ExprNodeImpl result = null;
        if (parent != null) {
            for (ExprNodeImpl child : parent.children) {
                if (this == child)
                    break;
                result = child;
            }
        }
        return result;
    }
    
    /**
     * 下一个节点是否指定类型集合中的一个
     *
     * @param clazzes 指定类型集合
     * @return 下一个节点是否指定类型集合中的一个
     */
    protected boolean nextChildIs(Class<?>... clazzes) {
        if (parent != null) {
            ExprNodeImpl[] peers = parent.children;
            for (int i = 0, max = peers.length; i < max; i++) {
                if (peers[i] == this) {
                    if ((i + 1) >= max) {
                        return false;
                    }
                    Class<?> clazz = peers[i + 1].getClass();
                    for (Class<?> desiredClazz : clazzes) {
                        if (clazz.equals(desiredClazz)) {
                            return true;
                        }
                    }
                    return false;
                }
            }
        }
        return false;
    }
    
    /**
     * 获取下一个子节点
     *
     * @return 下一个节点
     */
    protected ExprNodeImpl getNextChild() {
        ExprNodeImpl result = null;
        if (parent != null) {
            ExprNodeImpl prv = null;
            for (ExprNodeImpl child : parent.children) {
                if (this == prv) {
                    result = child;
                    break;
                }
                prv = child;
            }
        }
        return result;
    }
    
    /**
     * 获取数据
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNode#getValue(com.comtop.cap.document.expression.EvaluationContext)
     */
    @Override
    public final Object getValue(EvaluationContext context) throws EvaluationException {
        if (context != null) {
            return getValueInternal(context).getValue();
        }
        // configuration not set - does that matter?
        return getValue(new EvaluationContext());
    }
    
    /**
     * 获取数据
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNode#getTypedValue(com.comtop.cap.document.expression.EvaluationContext)
     */
    @Override
    public TypedValue getTypedValue(EvaluationContext context) throws EvaluationException {
        if (context != null) {
            return getValueInternal(context);
        }
        // configuration not set - does that matter?
        return getTypedValue(new EvaluationContext());
    }
    
    /**
     * 获取数据
     * @param <T> 返回对象类型
     *
     * @param context 表达式执行上下文
     * @param desiredReturnType 返回值类型
     * @return 特定类型的返回值
     * @throws EvaluationException 表达式执行异常
     */
    @SuppressWarnings("unchecked")
    protected final <T> T getValue(EvaluationContext context, Class<T> desiredReturnType) throws EvaluationException {
        Object result = getValueInternal(context).getValue();
        if (result != null && desiredReturnType != null) {
            Class<?> resultType = result.getClass();
            if (desiredReturnType.isAssignableFrom(resultType)) {
                return (T) result;
            }
            // Attempt conversion to the requested type, may throw an exception
            return ConverterUtils.convert(context, result, desiredReturnType);
        }
        return (T) result;
    }
    
    /**
     * 表达式计算
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     */
    public abstract TypedValue getValueInternal(EvaluationContext context) throws EvaluationException;
    
    /**
     * 设置值
     * 
     * @param context 表达式执行上下文
     * @param value 数据值
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNode#setValue(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object)
     */
    @Override
    public void setValue(EvaluationContext context, Object value) throws EvaluationException {
        // 默认什么都不做
        return;
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNode#toStringAST()
     */
    @Override
    public abstract String toStringAST();
    
    /**
     * @return 当前节点的子节点数量
     * @see com.comtop.cap.document.expression.ast.ExprNode#getChildCount()
     */
    @Override
    public int getChildCount() {
        return children.length;
    }
    
    /**
     * 获取指定索引的子节点
     *
     * @param index 索引
     * @return 子节点
     * @see com.comtop.cap.document.expression.ast.ExprNode#getChild(int)
     */
    @Override
    public ExprNode getChild(int index) {
        return children[index];
    }
    
    /**
     * 获取对象的类
     *
     * @param obj 数据
     * @return 类
     * @see com.comtop.cap.document.expression.ast.ExprNode#getObjectClass(java.lang.Object)
     */
    @Override
    public Class<?> getObjectClass(Object obj) {
        if (obj == null) {
            return null;
        }
        return (obj instanceof Class ? ((Class<?>) obj) : obj.getClass());
    }
    
    /**
     * @return 获取抽象语法树中的节点在表达式中的开始位置
     * @see com.comtop.cap.document.expression.ast.ExprNode#getStartPosition()
     */
    @Override
    public int getStartPosition() {
        return (pos >> 16);
    }
    
    /**
     * @return 获取抽象语法树中的节点在表达式中的结束位置
     * @see com.comtop.cap.document.expression.ast.ExprNode#getEndPosition()
     */
    @Override
    public int getEndPosition() {
        return (pos & 0xffff);
    }
    
}
