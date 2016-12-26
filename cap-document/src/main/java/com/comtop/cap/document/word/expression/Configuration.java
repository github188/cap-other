/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.expression;

import com.comtop.cap.document.expression.EvaluationContext;
import com.comtop.cap.document.expression.support.TypedValue;

/**
 * 表达式配置
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月18日 lizhongwen
 */
public class Configuration {
    
    /** 执行策略 */
    private Strategy strategy;
    
    /** 文档容器 */
    private final DocumentContainer container;
    
    /** 文档容器初始化 */
    private ContainerInitializer initializer;
    
    /** 执行上下文 */
    private EvaluationContext context;
    
    /** 上下文是否初始化 */
    private boolean contextInited;
    
    /** 结束标记 */
    private Object eof;
    
    /**
     * 构造函数
     * 
     * @param strategy 执行策略
     */
    public Configuration(final Strategy strategy) {
        this(strategy, null);
    }
    
    /**
     * 构造函数
     * 
     * @param strategy 执行策略
     * 
     * @param initializer 容器初始化
     */
    public Configuration(final Strategy strategy, final ContainerInitializer initializer) {
        this.strategy = strategy;
        this.container = DocumentContainer.getInstance();
        this.initializer = (initializer == null ? new SimpleContainerInitializer() : initializer);
        switch (strategy) {
            case WRITE:
                eof = TypedValue.EOF;
                break;
            case READ:
                eof = null;
                break;
            default:
                break;
        }
        init();
    }
    
    /**
     * 初始化
     */
    private void init() {
        if (!container.isInitialize()) { // 容器初始化
            initializer.init(container);
        }
    }
    
    /**
     * 配置执行上下文
     */
    private void configContext() {
        this.context = new EvaluationContext();
        this.context.setValueObjects(container.getValueObjects());
        this.context.setServices(container.getServices());
        this.context.setFunctions(container.getFunctions());
        this.contextInited = true;
    }
    
    /**
     * @return 获取 strategy属性值
     */
    public Strategy getStrategy() {
        return strategy;
    }
    
    /**
     * @param strategy 设置 strategy 属性值为参数值 strategy
     */
    public void setStrategy(Strategy strategy) {
        this.strategy = strategy;
    }
    
    /**
     * @return 获取 context属性值
     */
    public EvaluationContext getContext() {
        if (!contextInited) {
            configContext();
        }
        return context;
    }
    
    /**
     * 获取结束标记
     *
     * @return 结束标记
     */
    public Object getEOFObject() {
        return this.eof;
    }
    
    /**
     * 执行策略
     *
     * @author lizhongwen
     * @since jdk1.6
     * @version 2015年11月18日 lizhongwen
     */
    public enum Strategy {
        /** 读优先 */
        READ,
        /** 写优先 */
        WRITE;
    }
    
}
