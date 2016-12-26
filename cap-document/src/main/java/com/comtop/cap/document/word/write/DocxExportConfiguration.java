/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

import java.util.concurrent.atomic.AtomicInteger;

import com.comtop.cap.document.word.docmodel.DocxProperties;
import com.comtop.cap.document.word.expression.Configuration;
import com.comtop.cap.document.word.expression.Configuration.Strategy;
import com.comtop.cap.document.word.expression.ContainerInitializer;
import com.comtop.cap.document.word.expression.ExpressionExecuteHelper;
import com.comtop.cap.document.word.expression.SimpleContainerInitializer;

/**
 * 文档导出配置
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月23日 lizhongwen
 */
public class DocxExportConfiguration {
    
    /** 文档属性 */
    private DocxProperties properties;
    
    /** 文档模板路径 */
    private String templatePath;
    
    /** 文档路径 */
    private String filePath;
    
    /** 日志路径 */
    private String logPath;
    
    /** 表达式执行器 */
    private ExpressionExecuteHelper executer;
    
    /** 容器初始化 */
    private ContainerInitializer initializer;
    
    /** 章节计数器 */
    private AtomicInteger chapterCounter;
    
    /** 最大章节数 */
    private int maxChapterCount = 1000;
    
    /** 配置 */
    private Configuration configuration;
    
    /**
     * 构造函数
     * 
     * @param properties 文档属性
     */
    public DocxExportConfiguration(final DocxProperties properties) {
        this(properties, new SimpleContainerInitializer());
    }
    
    /**
     * 构造函数
     * 
     * @param properties 文档属性
     * @param initializer 容器初始化
     */
    public DocxExportConfiguration(final DocxProperties properties, final ContainerInitializer initializer) {
        this.properties = properties;
        this.initializer = initializer;
        this.chapterCounter = new AtomicInteger(0);
        initExpressionExecuter();
    }
    
    /**
     * 初始化表达式执行器
     */
    private void initExpressionExecuter() {
        configuration = new Configuration(Strategy.READ, initializer);
        this.executer = new ExpressionExecuteHelper(configuration);
    }
    
    /**
     * 获得配置对象
     *
     * @return 配置对象
     */
    public Configuration getConfiguration() {
        return this.configuration;
    }
    
    /**
     * @return 获取 title属性值
     */
    public String getTitle() {
        return this.properties == null ? null : this.properties.getTitle();
    }
    
    /**
     * @return 获取 templatePath属性值
     */
    public String getTemplatePath() {
        return templatePath;
    }
    
    /**
     * @param templatePath 设置 templatePath 属性值为参数值 templatePath
     */
    public void setTemplatePath(String templatePath) {
        this.templatePath = templatePath;
    }
    
    /**
     * @return 获取 filePath属性值
     */
    public String getFilePath() {
        return filePath;
    }
    
    /**
     * @param filePath 设置 filePath 属性值为参数值 filePath
     */
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    
    /**
     * @return 获取 creator属性值
     */
    public String getCreator() {
        return this.properties == null ? null : this.properties.getCreator();
    }
    
    /**
     * @return 获取 properties属性值
     */
    public DocxProperties getProperties() {
        return properties;
    }
    
    /**
     * @return 获取 executer属性值
     */
    public ExpressionExecuteHelper getExecuter() {
        return executer;
    }
    
    /**
     * @return 获取 initializer属性值
     */
    public ContainerInitializer getInitializer() {
        return initializer;
    }
    
    /**
     * 设置参数
     *
     * @param variable 变量名
     * @param value 变量值
     */
    public void setVariable(String variable, Object value) {
        this.executer.setVariable(variable, value);
    }
    
    /**
     * @param initializer 设置 initializer 属性值为参数值 initializer
     */
    public void setInitializer(ContainerInitializer initializer) {
        this.initializer = initializer;
    }
    
    /**
     * @return 获取 logPath属性值
     */
    public String getLogPath() {
        return logPath;
    }
    
    /**
     * @param logPath 设置 logPath 属性值为参数值 logPath
     */
    public void setLogPath(String logPath) {
        this.logPath = logPath;
    }
    
    /**
     * 获取并增加章节计数器
     *
     * @return 增加前的值
     */
    public int getAndIncrementChapterCounter() {
        return this.chapterCounter.getAndIncrement();
    }
    
    /**
     * 增加并获取章节计数器
     *
     * @return 增加后的值
     */
    public int IncrementtAndGetChapterCounter() {
        return this.chapterCounter.incrementAndGet();
    }
    
    /**
     * @return 获取 maxChapterCount属性值
     */
    public int getMaxChapterCount() {
        return maxChapterCount;
    }
    
    /**
     * @param maxChapterCount 设置 maxChapterCount 属性值为参数值 maxChapterCount
     */
    public void setMaxChapterCount(int maxChapterCount) {
        this.maxChapterCount = maxChapterCount;
    }
}
