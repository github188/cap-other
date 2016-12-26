/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.junit.Test;

import com.comtop.cap.document.expression.support.IterableTypedValue;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 表达式测试
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月13日 lizhongwen
 */
public class ExpressionTest {
    
    /**
     * 测试表达式词法分析
     */
    @Test
    public void testTokenizer() {
        String expr1 = "biz.name";
        Tokenizer tokenizer = new Tokenizer(expr1);
        System.out.println(Arrays.toString(tokenizer.getTokens().toArray(new Token[] {})));
        expr1 = "$fun('aaa:123','bbbb:\"abc\"')";
        tokenizer = new Tokenizer(expr1);
        System.out.println(Arrays.toString(tokenizer.getTokens().toArray(new Token[] {})));
        expr1 = "$fun(arg1,arg2)";
        tokenizer = new Tokenizer(expr1);
        System.out.println(Arrays.toString(tokenizer.getTokens().toArray(new Token[] {})));
        expr1 = "$var = $var2";
        tokenizer = new Tokenizer(expr1);
        System.out.println(Arrays.toString(tokenizer.getTokens().toArray(new Token[] {})));
        expr1 = "$var1 = 1222";
        tokenizer = new Tokenizer(expr1);
        System.out.println(Arrays.toString(tokenizer.getTokens().toArray(new Token[] {})));
        expr1 = "$var1 = 'ddfdafa'";
        tokenizer = new Tokenizer(expr1);
        System.out.println(Arrays.toString(tokenizer.getTokens().toArray(new Token[] {})));
        expr1 = "$var1 = biz.name";
        tokenizer = new Tokenizer(expr1);
        System.out.println(Arrays.toString(tokenizer.getTokens().toArray(new Token[] {})));
        
    }
    
    /**
     * 测试表达式词法分析
     */
    @Test
    public void testParser() {
        IExpressionParser parser = new ExpressionParser();
        String expr1 = "biz.name";
        IExpression expr = parser.parse(expr1);
        System.out.println(expr);
        expr1 = "var[]=#service(var1='123',var2 = v3)";
        expr = parser.parse(expr1);
        System.out.println(expr);
        expr1 = "var[]=$fun(arg1,arg2)";
        expr = parser.parse(expr1);
        System.out.println(expr);
        expr1 = "$fun(arg1,arg2)";
        expr = parser.parse(expr1);
        System.out.println(expr);
        expr1 = "var = var2";
        expr = parser.parse(expr1);
        System.out.println(expr);
        expr1 = "var1 = 1222";
        expr = parser.parse(expr1);
        System.out.println(expr);
        expr1 = "var1 = 'ddfdafa'";
        expr = parser.parse(expr1);
        System.out.println(expr);
        expr1 = "var1 = biz.name";
        expr = parser.parse(expr1);
        System.out.println(expr);
    }
    
    /**
     * 测试获取或者设置值
     */
    @Test
    public void testGetSetValue() {
        IExpressionParser parser = new ExpressionParser();
        String expr1 = "biz.name";
        TestVO test = new TestVO("张三");
        IExpression expr = parser.parse(expr1);
        EvaluationContext context = new EvaluationContext();
        context.setLocalVariable("biz", test);
        Object result = expr.execute(context, null);
        System.out.println(result);
        result = expr.execute(context, "李四");
        System.out.println(result);
    }
    
    /**
     * 测试参数定义
     */
    @Test
    public void testGetSetVariable() {
        IExpressionParser parser = new ExpressionParser();
        String expr1 = "$var = biz.name";
        TestVO test = new TestVO("张三");
        IExpression expr = parser.parse(expr1);
        EvaluationContext context = new EvaluationContext();
        context.setLocalVariable("biz", test);
        Object result = expr.execute(context, null);
        System.out.println(result);
        expr1 = "$var = 123";
        expr = parser.parse(expr1);
        result = expr.execute(context, null);
        System.out.println(result);
    }
    
    /**
     * 测试服务
     */
    @Test
    public void testLoadServices() {
        EvaluationContext context = new EvaluationContext();
        registServices(context);
        IExpressionParser parser = new ExpressionParser();
        String expr1 = "var[] = #test(name='a')";
        IExpression expr = parser.parse(expr1);
        Object result = expr.execute(context, null);
        System.out.println(result);
    }
    
    /**
     * 测试服务
     */
    @Test
    public void testLoadService() {
        EvaluationContext context = new EvaluationContext();
        registServices(context);
        IExpressionParser parser = new ExpressionParser();
        String expr1 = "var[] = #test(name='a')";
        IExpression expr = parser.parse(expr1);
        Object result = expr.execute(context, null);
        System.out.println(result);
    }
    
    /**
     * 测试服务
     */
    @SuppressWarnings("unchecked")
    @Test
    public void testSaveServices() {
        EvaluationContext context = new EvaluationContext();
        registServices(context);
        IExpressionParser parser = new ExpressionParser();
        IExpression expr = parser.parse("$var[] = #test(name='a')");
        Object result = expr.execute(context, TypedValue.NULL);
        IExpression expr1 = parser.parse("var.name");
        result = expr1.execute(context, "王五");
        TypedValue var = context.popActiveContextObject();
        Object vars = context.popActiveContextObject();
        if (vars instanceof IterableTypedValue) {
            @SuppressWarnings("rawtypes")
            IterableTypedValue it = (IterableTypedValue) vars;
            if (var != null) {
                it.addElement(var.getValue());
            }
        }
        expr.execute(context, TypedValue.EOF);
        System.out.println(result);
    }
    
    /**
     * 测试函数
     */
    @SuppressWarnings("rawtypes")
    @Test
    public void testFunctions() {
        EvaluationContext context = new EvaluationContext();
        registFunctions(context);
        IExpressionParser parser = new ExpressionParser();
        String expr1 = "var[] = $split('abc,def,ghi,jko',',')";
        IExpression expr = parser.parse(expr1);
        Object result = expr.execute(context, null);
        if (result instanceof Collection) {
            System.out.println(Arrays.toString(((Collection) result).toArray()));
        } else if (result.getClass().isArray()) {
            System.out.println(Arrays.toString((Object[]) result));
        }
        
        expr1 = "$join('abc','def','ghi','jko')";
        expr = parser.parse(expr1);
        result = expr.execute(context, null);
        System.out.println(result);
    }
    
    /**
     * 注册服务
     *
     * @param context 表达式执行上下文
     */
    private void registServices(EvaluationContext context) {
        TestService service = new TestService();
        Class<?> clazz = service.getClass();
        try {
            Method load = clazz.getMethod("loadTestList", TestVO.class);
            context.registerService("test", service);
            Method save = clazz.getMethod("saveTestList", List.class);
            context.registerFunction("test#load", load);
            context.registerFunction("test#save", save);
            context.registerValueObject("test", TestVO.class);
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 注册函数
     *
     * @param context 表达式执行上下文
     */
    private void registFunctions(EvaluationContext context) {
        Class<?> clazz = StringUtils.class;
        try {
            Method split = clazz.getMethod("split", String.class, String.class);
            Method join = StringUtil.class.getMethod("join", String[].class);
            context.registerFunction("split", split);
            context.registerFunction("join", join);
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }
}
