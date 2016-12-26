/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.support.IterableTypedValue;
import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.util.ObjectUtils;

/**
 * 引用节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月16日 lizhongwen
 */
public class Reference extends ExprNodeImpl {
    
    /** 引用名称 */
    private final String name;
    
    /**
     * 构造函数
     * 
     * @param name 属性或者字段名称
     * @param pos 表达式位置
     */
    public Reference(String name, int pos) {
        super(pos);
        this.name = name;
    }
    
    /**
     * @return 属性或者字段名称
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * 表达式计算
     *
     * @param context 表达式执行上下文
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#getValueInternal(com.comtop.cap.document.expression.EvaluationContext)
     */
    @Override
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public TypedValue getValueInternal(EvaluationContext context) throws EvaluationException {
        Object value = context.lookupLocalVariable(name);
        if (value == null) {
            Object template = context.lookupLocalVariable("_" + name);
            if (template == null) { // getValue
                Object coll = context.lookupLocalVariable(name + "_s");
                if (coll instanceof IterableTypedValue) {
                    value = ((IterableTypedValue) coll).popElement();
                    context.setLocalVariable(name, value);
                }
            } else {// setValue
                value = ObjectUtils.deepClone(template);
                context.setLocalVariable(name, value);
                Object coll = context.lookupLocalVariable(name + "_s");
                if (coll instanceof IterableTypedValue) {
                    ((IterableTypedValue) coll).addElement(value);
                }
                
            }
        }
        TypedValue result;
        if (value instanceof TypedValue) {
            result = (TypedValue) value;
        } else {
            result = toTypedValue(value);
        }
        return result;
    }
    
    /**
     * 设置数据
     *
     * @param context 表达式执行上下文
     * @param value 数据值
     * @throws EvaluationException 表达式执行异常
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#setValue(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object)
     */
    @Override
    public void setValue(EvaluationContext context, Object value) throws EvaluationException {
        TypedValue result;
        if (value instanceof TypedValue) {
            result = (TypedValue) value;
        } else {
            result = toTypedValue(value);
        }
        context.setLocalVariable(name, result);
    }
    
    /**
     * 将对数据转换为类型包装后的对象
     *
     * @param object 数据
     * @return 类型包装后的对象
     */
    private TypedValue toTypedValue(Object object) {
        if (object == null) {
            return TypedValue.NULL;
        }
        return new TypedValue(object);
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#toStringAST()
     */
    @Override
    public String toStringAST() {
        return this.name;
    }
}
