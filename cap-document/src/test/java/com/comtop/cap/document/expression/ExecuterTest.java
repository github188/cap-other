/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.expression;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.math.RandomUtils;
import org.junit.Test;

import com.comtop.cap.document.expression.support.TypedValue;
import com.comtop.cap.document.word.expression.Configuration;
import com.comtop.cap.document.word.expression.Configuration.Strategy;
import com.comtop.cap.document.word.expression.ExprEvent;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.expression.ExpressionExecuter;
import com.comtop.cap.document.word.expression.IExpressionExecuter;

/**
 * 测试表达式执行器
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
public class ExecuterTest {
    
    /**
     * 测试表达式执行
     */
    @Test
    public void testExecute() {
        IExpressionExecuter exec = new ExpressionExecuter(new Configuration(Strategy.READ,
            new ContainerInitializerImpl()));
        exec.notify(ExprEvent.START);
        Object result = exec.execute("var[] = #Test(name='a')", null);
        System.out.println(result);
    }
    
    /**
     * 测试上下文
     */
    @Test
    public void testContextOnRuntime() {
        IExpressionExecuter exec = new ExpressionExecuter(new Configuration(Strategy.WRITE,
            new ContainerInitializerImpl()));
        exec.execute("$domainId = 'domain_1'", TypedValue.NULL); // 定义全局变量
        exec.notify(ExprEvent.START); // 章节
        exec.execute("biz = #BizObject(domainId=$domainId)", false, null);
        exec.notify(ExprEvent.START);
        // exec.execute("biz = $select(biz[],'sortNo:2')", false, TypedValue.NULL);
        exec.execute("biz.name", "年季月运行方式管理");
        exec.execute("biz.map.abc", "这是map中的一个值");
        exec.execute("biz.map.adf", "这是map中的一个值1");
        exec.notify(ExprEvent.START);
        // TODO 如果从对象属性中取不到数据，怎么初始化模板对象~~~~
        exec.execute("dataItem[] = biz.dataItems", false, TypedValue.NULL);
        // exec.execute("dataItem[] = #BizDataItem(bizObjId='bizObject_01')", false, TypedValue.NULL);
        int len = RandomUtils.nextInt(10);
        for (int j = 0; j < len; j++) {
            exec.notify(ExprEvent.START);
            exec.execute("dataItem.code", TypedValue.NULL);
            exec.execute("dataItem.codeNote", RandomStringUtils.randomAlphabetic(5));
            exec.execute("dataItem.description", RandomStringUtils.randomAlphabetic(10));
            exec.execute("dataItem.name", RandomStringUtils.randomAlphabetic(10));
            exec.execute("dataItem.remark", "表达式新增对象 :" + j);
            exec.notify(ExprEvent.END); // 数据项封装完成
        }
        exec.notify(ExprEvent.END); // 数据项集合封装完成
        exec.execute("biz.code", RandomStringUtils.randomAlphabetic(5));
        exec.notify(ExprEvent.END);// 业务对象封装完毕
        exec.notify(ExprEvent.END);// 业务对象封装完毕
        System.out.println();
    }
    
    /**
     * 帮助类
     */
    @Test
    public void testHelper() {
        ExpressionExecuteHelper executer = new ExpressionExecuteHelper(new Configuration(Strategy.WRITE,
            new ContainerInitializerImpl()));
        String expr = "biz = #BizObject(domainId=$domainId)";
        BizObjectVO vo = new BizObjectVO();
        vo.setName("年季月运行方式管理");
        vo.setCode("123444");
        vo.setId("bizObject_03");
        Object ret = executer.update(expr, vo);
        System.out.println(ret);
    }
}
