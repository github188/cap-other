/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import java.text.MessageFormat;
import java.util.Collection;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.support.IterableTypedValue;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 可迭代的参数
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月13日 lizhongwen
 */
public class IterableVariable extends ExprNodeImpl {
    
    /** 名称 */
    private String name;
    
    /** 元素名称 */
    private String itemName;
    
    /**
     * 构造函数
     * 
     * @param itemName 元素变量名称
     * @param pos 表达式位置
     */
    public IterableVariable(String itemName, int pos) {
        super(pos);
        this.itemName = itemName;
        this.name = itemName + "_s";
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
    public TypedValue getValueInternal(EvaluationContext context) throws EvaluationException {
        Object value = context.lookupLocalVariable(this.name);
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
        if (value == null) {
            Object item = context.lookupLocalVariable(this.itemName);
            if (item == null) {
                result = new IterableTypedValue<Object>();
            } else {
                result = new IterableTypedValue<Object>(item);
            }
            context.setLocalVariable(name, result);
        } else if (value instanceof Collection) {
            result = new IterableTypedValue<Object>(value);
            context.setLocalVariable(name, result);
        } else if (value.getClass().isArray()) {
            result = new IterableTypedValue<Object>(value);
            context.setLocalVariable(name, result);
        } else if (value instanceof TypedValue && ((TypedValue) value).getValue() instanceof Collection) {
            result = new IterableTypedValue<Object>(((TypedValue) value).getValue());
            context.setLocalVariable(name, result);
        } else {
            throw new EvaluationException(MessageFormat.format("不支持的数据类型：''{0}''！", value.getClass().getSimpleName()));
        }
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
     * @return 获取 name属性值
     */
    public String getName() {
        return name;
    }
    
    /**
     * @return 获取 itemName属性值
     */
    public String getItemName() {
        return itemName;
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#toStringAST()
     */
    @Override
    public String toStringAST() {
        return this.itemName + "[]";
    }
    
}
