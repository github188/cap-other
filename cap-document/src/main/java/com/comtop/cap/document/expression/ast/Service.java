/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import java.lang.reflect.Method;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.support.MethodParameter;
import com.comtop.cap.document.expression.support.TypeDescriptor;
import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.util.ReflectionHelper;

/**
 * 服务节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月13日 lizhongwen
 */
public class Service extends ExprNodeImpl {
    
    /** 服务名称 */
    private final String name;
    
    /**
     * 构造函数
     * 
     * @param name 服务名称
     * @param pos 表达式位置
     * @param arguments 参数
     */
    public Service(String name, int pos, ExprNodeImpl... arguments) {
        super(pos, arguments);
        this.name = name;
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
        Object service = context.lookupService(name);
        Method method = context.lookupFunction(name + "#load");
        if (method == null || service == null) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("服务''{0}''未定义！", name));
        }
        ExprNodeImpl prev = this.getPreviousChild();
        Object condition = getCondition(context);
        TypedValue existed = executeLoadService(context, method, service, condition);
        if (prev instanceof IterableVariable) {
            return existed;
        } else if (prev instanceof Reference) {
            if (existed.getValue() == null) {
                return TypedValue.NULL;
            } else if (existed.getValue() instanceof Collection) {
                @SuppressWarnings("unchecked")
                Collection<Object> coll = (Collection<Object>) existed.getValue();
                if (coll.isEmpty()) {
                    return TypedValue.NULL;
                }
                return new TypedValue(coll.iterator().next());
            }
        }
        return existed;
    }
    
    /**
     * 数据加载服务执行
     * 
     * @param context 表达式执行上下文
     * @param method 服务方法
     * @param service 服务对象
     * @param condition 条件
     * @return 执行结果
     */
    private TypedValue executeLoadService(EvaluationContext context, Method method, Object service, Object condition) {
        if (!method.isVarArgs() && method.getParameterTypes().length != 1) {
            throw new EvaluationException(MessageFormat.format("服务''{0}''个参数，但实际只有1个参数！",
                method.getParameterTypes().length));
        }
        try {
            ReflectionHelper.makeAccessible(method);
            Object result = method.invoke(service, condition);
            return new TypedValue(result, new TypeDescriptor(new MethodParameter(method, -1)));
        } catch (Exception ex) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("服务''{0}''执行异常：''{1}''！", this.name,
                ex.getMessage()), ex);
        }
    }
    
    /**
     * 设置值
     * 
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#setValue(com.comtop.cap.document.expression.EvaluationContext,
     *      java.lang.Object)
     */
    @Override
    public void setValue(EvaluationContext context, Object value) throws EvaluationException {
        Object service = context.lookupService(name);
        Method method = context.lookupFunction(name + "#save");
        if (method == null || method == null || service == null) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("服务''{0}''未定义！", name));
        }
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
        if (var == null) {
            throw new EvaluationException(MessageFormat.format("表达式错误，不支持：''''！", prev.toStringAST()));
        }
        if (value instanceof TypedValue) {
            TypedValue typed = (TypedValue) value;
            if (TypedValue.NULL == typed) { // 空
                Object condition = this.getCondition(context);
                context.setLocalVariable("_" + var, condition); // 保存模板数据
                Method load = context.lookupFunction(name + "#load");
                TypedValue existed = TypedValue.NULL;
                if (load != null) {
                    existed = this.executeLoadService(context, load, service, condition);
                }
                if (prev instanceof IterableVariable) {
                    prev.setValue(context, existed.getValue());
                } else if (prev instanceof Reference) {
                    if (existed.getValue() == null) {
                        prev.setValue(context, condition);
                    } else if (existed.getValue() instanceof Collection) {
                        @SuppressWarnings("unchecked")
                        Collection<Object> coll = (Collection<Object>) existed.getValue();
                        if (coll.isEmpty()) {
                            prev.setValue(context, condition);
                        } else {
                            prev.setValue(context, coll.iterator().next());
                        }
                    }
                }
            } else if (TypedValue.EOF == typed) {
                Object data = null;
                if (prev instanceof IterableVariable) {
                    IterableVariable it = (IterableVariable) prev;
                    data = it.getValue(context);
                } else if (prev instanceof Reference) {
                    Reference reference = (Reference) prev;
                    Object obj = reference.getValue(context);
                    List<Object> coll = new ArrayList<Object>();
                    coll.add(obj);
                    data = coll;
                }
                if (data != null) {
                    this.executeSaveService(method, service, data);
                }
            }
        }
    }
    
    /**
     * 数据加载保存服务执行
     * 
     * @param method 服务方法
     * @param service 服务对象
     * @param data 数据
     * @return 执行结果
     */
    private TypedValue executeSaveService(Method method, Object service, Object data) {
        if (!method.isVarArgs() && method.getParameterTypes().length != 1) {
            throw new EvaluationException(MessageFormat.format("服务''{0}''个参数，但实际只有1个参数！",
                method.getParameterTypes().length));
        }
        try {
            ReflectionHelper.makeAccessible(method);
            Object result = method.invoke(service, data);
            return new TypedValue(result, new TypeDescriptor(new MethodParameter(method, -1)));
        } catch (Exception ex) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("服务''{0}''执行异常：''{1}''！", this.name,
                ex.getMessage()), ex);
        }
    }
    
    /**
     * 获取条件
     *
     * @param context 执行上下文
     * @return 条件对象
     */
    private Object getCondition(EvaluationContext context) {
        Class<?> type = context.lookupValueObject(name);
        if (type == null) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("VO''{0}''未定义！", name));
        }
        try {
            Object obj = ReflectionHelper.instance(type);
            for (ExprNodeImpl child : children) {
                if (!(child instanceof Assign)) {
                    throw new EvaluationException(getStartPosition(), MessageFormat.format("表达式错误，''{0}''不是正确的条件语句。",
                        child.toStringAST()));
                }
                Reference reference = (Reference) child.children[0];
                String fieldName = reference.getName();
                TypedValue typed = child.children[1].getTypedValue(context);
                ReflectionHelper.setField(fieldName, obj, typed.getValue());
            }
            return obj;
        } catch (IllegalStateException e) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("实例化VO''{0}''出错！错误原因：", name,
                e.getMessage()), e);
        }
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#toStringAST()
     */
    @Override
    public String toStringAST() {
        StringBuilder sb = new StringBuilder("#").append(name);
        sb.append("(");
        for (int i = 0; i < getChildCount(); i++) {
            if (i > 0)
                sb.append(",");
            sb.append(getChild(i).toStringAST());
        }
        sb.append(")");
        return sb.toString();
    }
    
    /**
     * @see java.lang.Object#toString()
     */
    @Override
    public String toString() {
        return name;
    }
    
}
