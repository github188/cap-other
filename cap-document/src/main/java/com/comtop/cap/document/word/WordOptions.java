/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word;

import java.io.File;
import java.io.Serializable;

import com.comtop.cap.document.word.expression.Configuration;
import com.comtop.cap.document.word.expression.ExpressionExecuter;
import com.comtop.cap.document.word.expression.IExpressionExecuter;
import com.comtop.cap.document.word.parse.check.FileLogRecorder;
import com.comtop.cap.document.word.parse.check.ILogRecorder;
import com.comtop.cap.document.word.util.DocUtil;

/**
 * 配置对象
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年10月14日 lizhiyong
 */
public class WordOptions implements Serializable {
    
    /** 序列化号 */
    private static final long serialVersionUID = 1L;
    
    /** 忽略未使用的样式 */
    private boolean ignoreStylesIfUnused;
    
    /** 缩进 */
    private Integer indent;
    
    /** 导入日志路径 */
    private String logPath;
    
    /** 表达式执行器 */
    private transient IExpressionExecuter expExecuter;
    
    /** 是否需要存储非模型类的章节数据 */
    private boolean needStoreContentSeg = false;
    
    /** 表达式执行器配置 */
    private transient Configuration configuration;
    
    /** 日志记录器 */
    private transient ILogRecorder logRecorder;
    
    /**
     * 构造函数
     * 
     * @param configuration word操作配置
     */
    public WordOptions(Configuration configuration) {
        this(configuration, true, DocUtil.createLogPath(System.getProperty("user.dir"), "doc-log", ""));
    }
    
    /**
     * 构造函数
     * 
     * @param logPath 日志文件路径
     * @param configuration word操作配置
     */
    public WordOptions(Configuration configuration, String logPath) {
        this(configuration, true, logPath);
    }
    
    /**
     * 构造函数
     * 
     * @param needStoreContentSeg 是否存储内容片段
     * 
     * @param logPath 日志文件路径
     * @param configuration word操作配置
     */
    public WordOptions(Configuration configuration, boolean needStoreContentSeg, String logPath) {
        this(configuration, needStoreContentSeg, logPath, true, 2);
    }
    
    /**
     * 构造函数
     * 
     * @param ignoreStylesIfUnused g
     * @param indent g
     * 
     * @param needStoreContentSeg 是否存储内容片段
     * 
     * @param logPath 日志文件路径
     * @param configuration word操作配置
     */
    private WordOptions(Configuration configuration, boolean needStoreContentSeg, String logPath,
        boolean ignoreStylesIfUnused, Integer indent) {
        super();
        this.ignoreStylesIfUnused = ignoreStylesIfUnused;
        this.indent = indent;
        this.logPath = logPath;
        this.expExecuter = new ExpressionExecuter(configuration);
        this.needStoreContentSeg = needStoreContentSeg;
        this.configuration = configuration;
    }
    
    /**
     * @return 获取 logRecorder属性值
     */
    public ILogRecorder getLogRecorder() {
        if (logRecorder != null) {
            return logRecorder;
        }
        synchronized (this) {
            if (logRecorder == null) {
                logRecorder = new FileLogRecorder(new File(getLogPath()));
            }
        }
        return logRecorder;
    }
    
    /**
     * @param logRecorder 设置 logRecorder 属性值为参数值 logRecorder
     */
    public void setLogRecorder(ILogRecorder logRecorder) {
        this.logRecorder = logRecorder;
    }
    
    /**
     * @return 获取 indent属性值
     */
    public Integer getIndent() {
        return indent;
    }
    
    /**
     * @return 获取 ignoreStylesIfUnused属性值
     */
    public boolean isIgnoreStylesIfUnused() {
        return ignoreStylesIfUnused;
    }
    
    /**
     * @return 获取 expExecuter属性值
     */
    public IExpressionExecuter getExpExecuter() {
        return expExecuter;
    }
    
    /**
     * @return 获取 needStoreContentSeg属性值
     */
    public boolean isNeedStoreContentSeg() {
        return needStoreContentSeg;
    }
    
    /**
     * @return 获取 logPath属性值
     */
    public String getLogPath() {
        return logPath;
    }
    
    /**
     * @return 获取 configuration属性值
     */
    public Configuration getConfiguration() {
        return configuration;
    }
    
}
