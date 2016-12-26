/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import java.lang.reflect.Field;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.util.CollectionTypeResolver;
import com.comtop.cap.document.util.ReflectionHelper;

/**
 * 点分割表达式，如“属性1.属性2.属性3”
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月10日 lizhongwen
 */
public class Compound extends ExprNodeImpl {
    
    /**
     * 构造函数
     * 
     * @param pos 位置
     * @param components 符合表达式
     */
    public Compound(int pos, ExprNodeImpl... components) {
        super(pos, components);
        if (components.length < 2) {
            throw new IllegalStateException("Dont build compound expression less than one entry: " + components.length);
        }
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
        TypedValue result = null;
        ExprNodeImpl nextNode = null;
        try {
            nextNode = children[0];
            result = nextNode.getValueInternal(context);
            for (int i = 1; i < getChildCount(); i++) {
                try {
                    context.pushActiveContextObject(result);
                    nextNode = children[i];
                    result = nextNode.getValueInternal(context);
                } finally {
                    context.popActiveContextObject();
                }
            }
        } catch (EvaluationException ee) {
            // Correct the position for the error before rethrowing
            ee.setPosition(nextNode == null ? 0 : nextNode.getStartPosition());
            throw ee;
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
        if (TypedValue.INIT == value) {
            initValue(context);
            return;
        }
        if (getChildCount() == 1) {
            getChild(0).setValue(context, value);
            return;
        }
        TypedValue ctx = children[0].getValueInternal(context);
        for (int i = 1; i < getChildCount() - 1; i++) {
            try {
                context.pushActiveContextObject(ctx);
                ctx = children[i].getValueInternal(context);
            } finally {
                context.popActiveContextObject();
            }
        }
        try {
            context.pushActiveContextObject(ctx);
            getChild(getChildCount() - 1).setValue(context, value);
        } finally {
            context.popActiveContextObject();
        }
    }
    
    /**
     * 初始化值
     * 
     * @param context 表达式执行上下文
     */
    private void initValue(EvaluationContext context) {
        // 处理如果右表达式为复制语句
        ExprNodeImpl nextNode = null;
        ExprNodeImpl prev = this.getPreviousChild();
        if (prev == null) {
            return;
        }
        String var = null;
        if (prev instanceof IterableVariable) {
            IterableVariable it = (IterableVariable) prev;
            var = it.getItemName();
        } else if (prev instanceof Reference) {
            Reference ref = (Reference) prev;
            var = ref.getName();
        }
        Object value = this.getValue(context);
        nextNode = children[0];
        if (nextNode instanceof Reference) { // 引用
            Reference ref = (Reference) nextNode;
            Object obj = ref.getValue(context);
            if (obj == null) {
                obj = context.lookupLocalVariable("_" + ref.getName());
                if (obj == null) {
                    throw new EvaluationException(ref.getStartPosition(), MessageFormat.format("无法为null对象''{0}''设值！",
                        ref.getName()));
                }
            }
            Class<?> clazz = obj.getClass();
            Field filed = null;
            Object p = obj;
            for (int i = 1; i < getChildCount(); i++) {
                nextNode = children[i];
                obj = nextNode.getValue(context);
                if (obj == null) {
                    if (nextNode instanceof PropertyRef) {
                        PropertyRef pref = (PropertyRef) nextNode;
                        filed = ReflectionHelper.findField(clazz, pref.getName());
                    }
                } else {
                    p = obj;
                    clazz = obj.getClass();
                }
            }
            if (filed != null) {
                if (Collection.class.isAssignableFrom(filed.getType())) {// 集合
                    Class<?> elementClass = CollectionTypeResolver.getCollectionFieldType(filed);
                    obj = ReflectionHelper.instance(elementClass);
                    if (value == null) {
                        List<Object> list = new ArrayList<Object>();
                        ReflectionHelper.setField(filed, p, list);
                        prev.setValue(context, list);
                    } else {
                        prev.setValue(context, value);
                    }
                    context.setLocalVariable("_" + var, obj); // 保存模板数据
                }
            }
        }
    }
    
    @Override
    public String toStringAST() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < getChildCount(); i++) {
            if (i > 0) {
                sb.append(".");
            }
            sb.append(getChild(i).toStringAST());
        }
        return sb.toString();
    }
}
