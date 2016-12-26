/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression.ast;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.EvaluationException;
import com.comtop.cap.document.expression.ExpressionException;
import com.comtop.cap.document.expression.accessor.AccessException;
import com.comtop.cap.document.expression.accessor.MethodExecutor;
import com.comtop.cap.document.expression.accessor.MethodResolver;
import com.comtop.cap.document.expression.support.TypeDescriptor;
import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.util.FormatHelper;

/**
 * 方法节点
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月12日 lizhongwen
 */
public class MethodRef extends ExprNodeImpl {
    
    /** 方法名称 */
    private final String name;
    
    /** 方法执行器 */
    private volatile MethodExecutor cachedExecutor;
    
    /**
     * 构造函数
     * 
     * @param methodName 方法名称
     * @param pos 表达式位置
     * @param arguments 方法参数
     */
    public MethodRef(String methodName, int pos, ExprNodeImpl... arguments) {
        super(pos, arguments);
        this.name = methodName;
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
        TypedValue currentContext = context.getActiveContextObject();
        Object[] arguments = new Object[getChildCount()];
        for (int i = 0; i < arguments.length; i++) {
            // Make the root object the active context again for evaluating the parameter
            // expressions
            try {
                context.pushActiveContextObject(context.getRootObject());
                arguments[i] = children[i].getValueInternal(context).getValue();
            } finally {
                context.popActiveContextObject();
            }
        }
        if (currentContext.getValue() == null) {
            return TypedValue.NULL;
        }
        
        MethodExecutor executorToUse = this.cachedExecutor;
        if (executorToUse != null) {
            try {
                return executorToUse.execute(context, context.getActiveContextObject().getValue(), arguments);
            } catch (AccessException ae) {
                // Two reasons this can occur:
                // 1. the method invoked actually threw a real exception
                // 2. the method invoked was not passed the arguments it expected and has become 'stale'
                
                // In the first case we should not retry, in the second case we should see if there is a
                // better suited method.
                
                // To determine which situation it is, the AccessException will contain a cause - this
                // will be the exception thrown by the reflective invocation. Inside this exception there
                // may or may not be a root cause. If there is a root cause it is a user created exception.
                // If there is no root cause it was a reflective invocation problem.
                
                throwSimpleExceptionIfPossible(context, ae);
                
                // at this point we know it wasn't a user problem so worth a retry if a better candidate can be found
                this.cachedExecutor = null;
            }
        }
        
        // either there was no accessor or it no longer existed
        executorToUse = findAccessorForMethod(this.name, getTypes(arguments), context);
        this.cachedExecutor = executorToUse;
        try {
            return executorToUse.execute(context, context.getActiveContextObject().getValue(), arguments);
        } catch (AccessException ae) {
            // Same unwrapping exception handling as above in above catch block
            throwSimpleExceptionIfPossible(context, ae);
            throw new EvaluationException(getStartPosition(), MessageFormat.format("调用对象''{0}''的方法''{1}''异常:''{2}''",
                context.getActiveContextObject().getValue().getClass().getName(), this.name, ae.getMessage()), ae);
        }
    }
    
    /**
     * 
     * 抛异常
     *
     * @param context 表达式执行上下文
     * @param ae 异常
     */
    private void throwSimpleExceptionIfPossible(EvaluationContext context, AccessException ae) {
        Throwable causeOfAccessException = ae.getCause();
        Throwable rootCause = (causeOfAccessException == null ? null : causeOfAccessException.getCause());
        if (rootCause != null) {
            // User exception was the root cause - exit now
            if (rootCause instanceof RuntimeException) {
                throw (RuntimeException) rootCause;
            }
            throw new ExpressionException(getStartPosition(), "A problem occurred when trying to execute method '"
                + this.name + "' on object of type '"
                + context.getActiveContextObject().getValue().getClass().getName() + "'", rootCause);
        }
    }
    
    /**
     * 根据参数获取类型
     *
     * @param arguments 参数
     * @return 类型集合
     */
    private List<TypeDescriptor> getTypes(Object... arguments) {
        List<TypeDescriptor> descriptors = new ArrayList<TypeDescriptor>(arguments.length);
        for (Object argument : arguments) {
            descriptors.add(TypeDescriptor.forObject(argument));
        }
        return descriptors;
    }
    
    /**
     * @return 抽象语法树中的字符串
     * @see com.comtop.cap.document.expression.ast.ExprNodeImpl#toStringAST()
     */
    @Override
    public String toStringAST() {
        StringBuilder sb = new StringBuilder();
        sb.append(name).append("(");
        for (int i = 0; i < getChildCount(); i++) {
            if (i > 0)
                sb.append(",");
            sb.append(getChild(i).toStringAST());
        }
        sb.append(")");
        return sb.toString();
    }
    
    /**
     * 查找方法执行器
     *
     * @param methodName 方法名称
     * @param argumentTypes 参数类型
     * @param context 表达式执行上下文
     * @return 方法执行器
     * @throws EvaluationException 表达式执行异常
     */
    private MethodExecutor findAccessorForMethod(String methodName, List<TypeDescriptor> argumentTypes,
        EvaluationContext context) throws EvaluationException {
        
        TypedValue active = context.getActiveContextObject();
        Object activeObject = active.getValue();
        
        List<MethodResolver> mResolvers = context.getMethodResolvers();
        if (mResolvers != null) {
            for (MethodResolver methodResolver : mResolvers) {
                try {
                    MethodExecutor cEx = methodResolver.resolve(context, activeObject, methodName, argumentTypes);
                    if (cEx != null) {
                        return cEx;
                    }
                } catch (AccessException ex) {
                    throw new EvaluationException(getStartPosition(), MessageFormat.format("在类''{0}''中查找方法''{1}''错误！",
                        activeObject.getClass(), methodName), ex);
                }
            }
        }
        throw new EvaluationException(getStartPosition(), MessageFormat.format("在类''{0}''中查找不到方法''{1}''错误！",
            FormatHelper.formatMethodForMessage(methodName, argumentTypes), FormatHelper
                .formatClassNameForMessage(activeObject instanceof Class ? ((Class<?>) activeObject) : activeObject
                    .getClass())));
    }
}
