/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.document.word.write;

/**
 * 文档导出异常
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2015年11月9日 lizhongwen
 */
public class ExportException extends RuntimeException {
    
    /** 序列ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * 构造函数
     * 
     * @param message 错误消息
     * @param cause 错误原因
     */
    public ExportException(String message, Throwable cause) {
        super(message, cause);
    }
    
    /**
     * 构造函数
     * 
     * @param message 错误消息
     */
    public ExportException(String message) {
        super(message);
    }
    
}
