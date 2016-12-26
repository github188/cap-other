/******************************************************************************
 * Copyright (C) 2016 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.test.exception;

/**
 * 文件上传异常
 *
 * @author lizhongwen
 * @since jdk1.6
 * @version 2016年7月7日 lizhongwen
 */
public class FileUploadException extends RuntimeException {
    
    /** 序列化Id */
    private static final long serialVersionUID = 1L;
    
    /**
     * 构造函数
     */
    public FileUploadException() {
        super();
    }
    
    /**
     * 构造函数
     * 
     * @param message 异常消息
     * @param cause 异常原因
     */
    public FileUploadException(String message, Throwable cause) {
        super(message, cause);
    }
    
    /**
     * 构造函数
     * 
     * @param message 异常消息
     */
    public FileUploadException(String message) {
        super(message);
    }
    
    /**
     * 构造函数
     * 
     * @param cause 异常原因
     */
    public FileUploadException(Throwable cause) {
        super(cause);
    }
}
