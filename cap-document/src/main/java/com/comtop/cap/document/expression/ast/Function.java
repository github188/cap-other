/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.text.MessageFormat;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.converter.ITypeConverter;
import com.comtop.cap.document.expression.support.MethodParameter;
import com.comtop.cap.document.expression.support.TypeDescriptor;
import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.util.ReflectionHelper;

/**
 * 函数节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public class Function extends ExprNodeImpl {
    
    /** 函数名称 */
    private final String name;
    
    /**
     * 构造函数
     * 
     * @param name 函数名称
     * @param pos 表达式位置
     * @param arguments 参数
     */
    public Function(String name, int pos, ExprNodeImpl... arguments) {
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
        Method method = context.lookupFunction(name);
        if (method == null) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("函数''{0}''未定义！", name));
        }
        
        // Two possibilities: a lambda function or a Java static method registered as a function
        try {
            return executeFunctionJLRMethod(context, method);
        } catch (EvaluationException se) {
            se.setPosition(getStartPosition());
            throw se;
        }
    }
    
    /**
     * 
     * 执行函数
     *
     * @param context 表达式执行上下文
     * @param method 方法
     * @return 执行结果
     * @throws EvaluationException 表达式执行异常
     */
    private TypedValue executeFunctionJLRMethod(EvaluationContext context, Method method) throws EvaluationException {
        Object[] functionArgs = getArguments(context);
        
        if (!method.isVarArgs() && method.getParameterTypes().length != functionArgs.length) {
            throw new EvaluationException(MessageFormat.format("函数需要''{0}''个参数，但实际只有''{1}''个参数！",
                method.getParameterTypes().length, functionArgs.length));
        }
        // Only static methods can be called in this way
        if (!Modifier.isStatic(method.getModifiers())) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("函数''{0}''不是静态方法''{1}''！", name,
                method.getDeclaringClass().getName() + "." + method.getName()));
        }
        
        // Convert arguments if necessary and remap them for varargs if required
        if (functionArgs != null) {
            ITypeConverter converter = context.getTypeConverter();
            ReflectionHelper.convertAllArguments(converter, functionArgs, method);
        }
        if (method.isVarArgs()) {
            functionArgs = ReflectionHelper
                .setupArgumentsForVarargsInvocation(method.getParameterTypes(), functionArgs);
        }
        
        try {
            ReflectionHelper.makeAccessible(method);
            Object result = method.invoke(method.getClass(), functionArgs);
            return new TypedValue(result, new TypeDescriptor(new MethodParameter(method, -1)));
        } catch (Exception ex) {
            throw new EvaluationException(getStartPosition(), MessageFormat.format("函数''{0}''执行异常：{1}！", this.name,
                ex.getMessage()), ex);
        }
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#toStringAST()
     */
    @Override
    public String toStringAST() {
        StringBuilder sb = new StringBuilder("$").append(name);
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
     * 
     * 从上下文中获取参数
     *
     * @param context 表达式执行上下文
     * @return 参数结合
     * @throws EvaluationException 表达式执行异常
     */
    private Object[] getArguments(EvaluationContext context) throws EvaluationException {
        // Compute arguments to the function
        Object[] arguments = new Object[getChildCount()];
        for (int i = 0; i < arguments.length; i++) {
            arguments[i] = children[i].getValueInternal(context).getValue();
        }
        return arguments;
    }
    
}
