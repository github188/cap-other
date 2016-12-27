/******************************************************************************
 * Copyright (C) 2015 ShenZhen ComTop Information Technology Co.,Ltd
 * All Rights Reserved.
 * 本软件为深圳康拓普开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、
 * 复制、修改或发布本软件.
 *****************************************************************************/

package com.comtop.cap.bm.metadata.common.storage.exception;

/**
 * Xml操作异常
 * 
 * 
 * @author 李忠文
 * @since 1.0
 * @version 2015-4-10 李忠文
 */
public class OperateException extends Exception {
    
    /** 序列化ID */
    private static final long serialVersionUID = 1L;
    
    /**
     * 构造函数
     * 
     * @param message 异常消息
     * @param cause 异常原因
     */
    public OperateException(String message, Throwable cause) {
        super(message, cause);
    }
    
    /**
     * 构造函数
     * 
     * @param message 异常消息
     */
    public OperateException(String message) {
        super(message);
    }
}
