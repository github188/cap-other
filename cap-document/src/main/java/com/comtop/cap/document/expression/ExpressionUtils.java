/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import com.comtop.cap.document.expression.ast.Assign;
import com.comtop.cap.document.expression.ast.Compound;
import com.comtop.cap.document.expression.ast.ExprNode;
import com.comtop.cap.document.expression.ast.IterableVariable;
import com.comtop.cap.document.expression.ast.Reference;
import com.comtop.cap.document.expression.ast.Service;
import com.comtop.cap.document.expression.ast.Variable;

/**
 * 表达式工具类
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月26日 lizhongwen
 */
public class ExpressionUtils {
    
    /**
     * 构造函数
     */
    private ExpressionUtils() {
    }
    
    /**
     * 读取表达式中引用部分
     *
     * @param expr 从表达式中取得引用部分
     * @return 引用部分字符串
     */
    public static String readReference(final String expr) {
        ExpressionParser parser = new ExpressionParser();
        IExpression expression = parser.parse(expr);
        ExprNode node = expression.getAst();
        return readReference(node);
    }
    
    /**
     * 读取表达式中引用部分
     *
     * @param ast 抽象语法树节点
     * @return 引用部分字符串
     */
    private static String readReference(final ExprNode ast) {
        String ref = null;
        if (ast instanceof Reference) {
            ref = ast.toStringAST();
        } else if (ast instanceof Compound) {
            int count = ast.getChildCount();
            for (int i = 0; i < count; i++) {
                String chRef = readReference(ast.getChild(i));
                if (chRef != null) {
                    if (ref == null) {
                        ref = chRef;
                    } else {
                        ref = ref + "." + chRef;
                    }
                }
            }
        } else if (ast instanceof Assign) {
            ExprNode left = ast.getChild(0);
            if (left instanceof Reference || left instanceof IterableVariable || left instanceof Variable) {
                ref = left.toStringAST();
            }
        }
        return ref;
    }
    
    /**
     * 读取表达式中的服务
     *
     * @param expr 表达式
     * @param context 表达式执行上下文
     * @return 服务
     */
    public static Object readService(final String expr, final EvaluationContext context) {
        ExpressionParser parser = new ExpressionParser();
        IExpression expression = parser.parse(expr);
        ExprNode node = expression.getAst();
        return readService(node, context);
    }
    
    /**
     * 读取表达式中的服务
     *
     * @param ast 抽象语法树节点
     * @param context 表达式执行上下文
     * @return 服务
     */
    public static Object readService(final ExprNode ast, final EvaluationContext context) {
        Object obj = null;
        if (ast instanceof Service) {
            Service service = (Service) ast;
            obj = context.lookupService(service.toString());
            return obj;
        }
        int count = ast.getChildCount();
        for (int i = 0; i < count; i++) {
            ExprNode child = ast.getChild(i);
            obj = readService(child, context);
        }
        return obj;
        
    }
    
    /**
     * 读取表达式中的服务名称
     *
     * @param expr 表达式
     * @return 服务名称
     */
    public static String readServiceName(final String expr) {
        ExpressionParser parser = new ExpressionParser();
        IExpression expression = parser.parse(expr);
        ExprNode node = expression.getAst();
        return readServiceName(node);
    }
    
    /**
     * 读取表达式中的服务名称
     *
     * @param ast 抽象语法树节点
     * @return 服务名称
     */
    private static String readServiceName(final ExprNode ast) {
        String name = null;
        if (ast instanceof Service) {
            Service service = (Service) ast;
            return service.toString();
        }
        int count = ast.getChildCount();
        for (int i = 0; i < count; i++) {
            ExprNode child = ast.getChild(i);
            name = readServiceName(child);
        }
        return name;
    }
    
    /**
     * 读取表达式中的全局变量名称
     *
     * @param expr 表达式
     * @return 变量名称
     */
    public static String readVariable(final String expr) {
        ExpressionParser parser = new ExpressionParser();
        IExpression expression = parser.parse(expr);
        ExprNode node = expression.getAst();
        return readVariable(node);
    }
    
    /**
     * 读取表达式中的全局变量名称
     *
     * @param ast 抽象语法树节点
     * @return 全局变量名称
     */
    private static String readVariable(final ExprNode ast) {
        String name = null;
        if (ast instanceof Variable) {
            return ast.toStringAST();
        }
        int count = ast.getChildCount();
        for (int i = 0; i < count; i++) {
            ExprNode child = ast.getChild(i);
            name = readVariable(child);
        }
        return name;
    }
}
