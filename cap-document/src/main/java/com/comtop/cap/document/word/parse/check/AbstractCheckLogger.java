/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.parse.check;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 抽象日志记录器
 *
 * @author lizhiyong
 * @since jdk1.6
 * @version 2015年11月11日 lizhiyong
 */
public abstract class AbstractCheckLogger {
    
    /** 日志记录器 */
    private ILogRecorder logRecorder;
    
    /** 日志对象 */
    protected Logger logger = LoggerFactory.getLogger(getClass());
    
    /** 常量串 */
    public static final String FSTR_ERR = "错误:";
    
    /** 常量串 */
    public static final String FSTR_WARN = "警告:";
    
    /** 常量串 */
    public static final String FSTR_INFO = "提示:";
    
    /** 常量串 */
    public static final String FSTR_TPL = "【当前模板】";
    
    /** 常量串 */
    public static final String FSTR_DOC = "【当前文档】";
    
    /** 常量串 */
    public static final String FSTR_TABLE = "【当前表格】";
    
    /** 常量串 */
    public static final String FSTR_TABLE_ROW = "【当前行】";
    
    /** 常量串 */
    public static final String FSTR_CHAPTER = "【当前章节】";
    
    /** 常量串 */
    public static final String FSTR_TEXT = "【文本】";
    
    /** 常量串 */
    public static final String FSTR_CELL = "【当前单元格】";
    
    /** 常量串 */
    public static final String FSTR_SECTION = "【分节】";
    
    /** 常量串 */
    public static final String FSTR_LEFT_BRACKET = "(";
    
    /** 常量串 */
    public static final String FSTR_RIGHT_BRACKET = ")";
    
    /** 常量串 */
    public static final String FSTR_COMMA = ",";
    
    /** 常量串 */
    public static final String FSTR_COLON = ":";
    
    /** 常量串 */
    public static final String FSTR_LEFT_BIAS = "/";
    
    /**
     * 构造函数
     * 
     * @param logRecorder 日志记录器
     */
    public AbstractCheckLogger(ILogRecorder logRecorder) {
        super();
        this.logRecorder = logRecorder;
    }
    
    /**
     * 获得日志记录器
     *
     * @return 日志记录器
     */
    public ILogRecorder getLogRecorder() {
        return this.logRecorder;
    }
    
}
